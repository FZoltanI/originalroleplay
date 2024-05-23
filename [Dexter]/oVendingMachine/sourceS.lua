local connection = exports["oMysql"]:getDBConnection()

addEventHandler("onResourceStart", resourceRoot, function()
    dbQuery(function(qh)
        local result, numAffect = dbPoll(qh, 0)
        if result then 
            if numAffect > 0 then
                for k,v in ipairs(result) do 
                    local position = fromJSON(v["position"])
                    --outputChatBox(position[1][1])
                    objectElement = createObject(v["objID"], position[1], position[2], position[3])
                    setElementRotation(objectElement, position[4], position[5], position[6])
                    setElementInterior(objectElement, v["interior"])
                    setElementDimension(objectElement, v["dimension"])
                    setElementData(objectElement, "vendingMachine.Id", v["dbId"])
                    setElementData(objectElement, "vendingMachine.isMachine", true)
                end
            end
        end
    end, connection, "SELECT * FROM vendingmachines")
end)

function loadAutomata(id)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result then 
            for k,v in ipairs(result) do 
                local position = fromJSON(v["position"])
                --outputChatBox(position[1][1])
                objectElement = createObject(v["objID"], position[1], position[2], position[3])
                setElementRotation(objectElement, position[4], position[5], position[6])
                setElementInterior(objectElement, v["interior"])
                setElementDimension(objectElement, v["dimension"])
                setElementData(objectElement, "vendingMachine.Id", v["dbId"])
                setElementData(objectElement, "vendingMachine.isMachine", true)
            end
        end
    end,connection, "SELECT * FROM vendingmachines WHERE dbId = ?", id)
end


addEvent("placeAutomata",true)
addEventHandler("placeAutomata",getRootElement(),function(playerElement, objID)
    local x,y,z = getElementPosition(playerElement)
    local rotX,rotY,rotZ = getElementRotation(playerElement)
    local interior = getElementInterior(playerElement)
    local dimension = getElementDimension(playerElement)


    dbQuery(function(qh)
        local result, numAffect, lastInsertID = dbPoll(qh, 0)
        if result then 
            loadAutomata(lastInsertID)
            outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Sikeresen létrehoztál egy automatát (ID: "..lastInsertID ..")",playerElement, 0, 0, 0, true);
        end
    end, connection, "INSERT INTO vendingmachines (position, objID, interior, dimension) VALUES (?, ?, ?, ?)",toJSON({x,y,z,rotX,rotY,rotZ}),objID ,interior, dimension)
end)

addEvent("deleteAutomata",true)
addEventHandler("deleteAutomata",getRootElement(),function(playerElement, id)
    dbExec(connection, "DELETE FROM vendingmachines WHERE dbId = ?", id)
    for k,v in ipairs(getElementsByType("object")) do 
        if getElementData(v, "vendingMachine.Id") == tonumber(id) then 
            destroyElement(v)
        end
    end
    outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Sikeresen törölted a kiválasztott automatát",playerElement, 0, 0, 0, true);
end)

addEvent("giveItem:vendingMachine",true)
addEventHandler("giveItem:vendingMachine",getRootElement(),function(playerElement, itemId, price)
  --  if exports.oInventory:giveItem(playerElement, itemId, 1, 1, 0) then 
    if exports["oInventory"]:getFreeSlot(playerElement, itemId) then
        exports.oInventory:giveItem(playerElement, itemId, 1, 1, 0)
        setElementData(playerElement, "char:money", getElementData(playerElement, "char:money") - price)
        outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Sikeresen megvásároltad a kiválasztott terméket!",playerElement, 0, 0, 0, true);
        triggerClientEvent (playerElement, "vendingAlreadyBuy", playerElement)
    else
        outputChatBox(core:getServerPrefix("server", "vendingMachine", 3).."Nincs szabad slot-od!",playerElement, 0, 0, 0, true);
        triggerClientEvent (playerElement, "vendingAlreadyBuy", playerElement)
    end
end)