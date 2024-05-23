for k, v in ipairs(getElementsByType("vehicle")) do 
    if getElementModel(v) == 498 then 
        setElementData(v, "transporter:furnitures", {})
    end
end

addEvent("transporter > createFurnitureObjectOnServer", true)
addEventHandler("transporter > createFurnitureObjectOnServer", resourceRoot, function(objID)
    --outputChatBox(objID)
    setPedAnimation(client, "CARRY", "crry_prtial", 0, true, false, true, true)

    local obj = createObject(objID, 0, 0, 0)
    setElementDoubleSided(obj, true)
    setElementCollisionsEnabled(obj, false)

    local attachX, attachY, attachZ, rotX, rotY, rotZ = attachmentPositions[objID][1], attachmentPositions[objID][2], attachmentPositions[objID][3], attachmentPositions[objID][4], attachmentPositions[objID][5], attachmentPositions[objID][6] 

    exports.oBone:attachElementToBone(obj, client, 12, attachX, attachY, attachZ, rotX, rotY, rotZ)

    setElementData(client, "transporter:furnitureInHand", obj)
end)

addEvent("transporter > putFurnitureToTheCar", true)
addEventHandler("transporter > putFurnitureToTheCar", resourceRoot, function(nearestVeh, attachpos, alpha)
    --setElementAlpha(nearestVeh, 100)

    local obj = getElementData(client, "transporter:furnitureInHand")
    local objModel = getElementModel(obj)

    local furnitures = getElementData(nearestVeh, "transporter:furnitures") or {}

    local attachX, attachY, attachZ, attachRotX, attachRotY, attachRotZ = unpack(attachpos)
    setElementAlpha(obj, alpha)

    exports.oBone:detachElementFromBone(obj)
    setElementCollisionsEnabled(obj, false)

    attachElements(obj, nearestVeh, attachX, attachY, attachZ, attachRotX, attachRotY, attachRotZ)

    table.insert(furnitures, obj)

    setElementData(nearestVeh, "transporter:furnitures", furnitures)
    setElementData(client, "transporter:furnitureInHand", false)
end)

addEvent("transporter > putFurnitureFromCarToHand", true)
addEventHandler("transporter > putFurnitureFromCarToHand", resourceRoot, function(veh, furniture)
    detachElements(furniture)
    setPedAnimation(client, "CARRY", "crry_prtial", 0, true, false, true, true)
    setElementDoubleSided(furniture, true)
    setElementCollisionsEnabled(furniture, false)
    setElementAlpha(furniture, 255)

    local objID = getElementModel(furniture)

    local newTable = getElementData(veh, "transporter:furnitures")
    table.remove(newTable, #newTable)
    setElementData(veh, "transporter:furnitures", newTable)

    local attachX, attachY, attachZ, rotX, rotY, rotZ = attachmentPositions[objID][1], attachmentPositions[objID][2], attachmentPositions[objID][3], attachmentPositions[objID][4], attachmentPositions[objID][5], attachmentPositions[objID][6] 

    exports.oBone:attachElementToBone(furniture, client, 12, attachX, attachY, attachZ, rotX, rotY, rotZ)

    setElementData(client, "transporter:furnitureInHand", furniture)
end)

addEvent("transporter > putDownObject", true)
addEventHandler("transporter > putDownObject", resourceRoot, function(obj)
    setElementData(client, "transporter:furnitureInHand", false)
    exports.oBone:detachElementFromBone(obj)
    destroyElement(obj)
end)

addEvent("transporter > givePlayerPayment", true)
addEventHandler("transporter > givePlayerPayment", resourceRoot, function(payment)
    setElementData(client, "char:money", getElementData(client, "char:money")+payment)
end)

addEvent("transporter > makeJobVeh", true)
addEventHandler("transporter > makeJobVeh", resourceRoot, function()
    local createX, createY, createZ = 1775.8527832031, -2031.7973632813, 13.501180648804

    for k, v in ipairs(vehicleCreateCols) do 
        if #getElementsWithinColShape(v, "vehicle") == 0 then 
            createX, createY, createZ = getElementPosition(v)
            break
        end
    end

    local jobveh = exports.oJob:createJobVehicle(498, {createX, createY, createZ}, client, "Költöztető", 20)
    warpPedIntoVehicle(client, jobveh)
end)

addEvent("transporter > destroyJobVeh", true)
addEventHandler("transporter > destroyJobVeh", resourceRoot, function()
    exports.oJob:destoryJobVehicle(client)
end)