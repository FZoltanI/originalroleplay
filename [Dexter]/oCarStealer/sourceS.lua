local pedElement = false
local randomNumber = 1
local factoryMarker = false
local carStealerTimer = {}

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    for k,v in pairs(pedDatas["upper"]) do
        pedElement = createPed(v[1], v[2], v[3], v[4])
        setElementRotation(pedElement, 0, 0, v[8])
        setElementInterior(pedElement, v[5])
        setElementDimension(pedElement, v[6])
        setElementFrozen(pedElement, true)
        setElementData(pedElement, "ped:name", v[7])
        setElementData(pedElement, "isCarStealerPed", true)
        setElementData(pedElement, "isSpeakToStealer", false)
        setElementData(root, "randomDropDownPosNum", randomNumber)
    --    setTimer(function()
    --        setPositionThePed()
    --    end,15000,0)
    end

    factoryMarker = createMarker(factoryMarkerX, factoryMarkerY, factoryMarkerZ-1, "cylinder", 2, 255, 0, 0, 150)
    setElementData(factoryMarker, "isFactoryMarker", true)
end)

function setPositionThePed()
    local randomNumber = math.random(1,#pedRandPositon["upper"])
    setElementPosition(pedElement, pedRandPositon["upper"][randomNumber][1],pedRandPositon["upper"][randomNumber][2],pedRandPositon["upper"][randomNumber][3])
    setElementRotation(pedElement, 0, 0, pedRandPositon["upper"][randomNumber][4])
    setElementData(pedElement, "isSpeakToStealer", false)
    setElementData(root, "randomDropDownPosNum", randomNumber)
end

addEvent("createStealedCar", true)
addEventHandler("createStealedCar", getRootElement(), function(player, modelId, posX, posY, posZ, vehicleColorR, vehicleColorG, vehicleColorB)
    vehicleElement[player] = createVehicle(modelId, posX, posY, posZ)
    setVehicleColor(vehicleElement[player], vehicleColorR, vehicleColorG, vehicleColorB)

    local max = exports.oVehicle:getVehicleMaxFuel(modelId)
    setElementData(vehicleElement[player], "veh:maxFuel", max)
    setElementData(vehicleElement[player], "veh:fuel", max)
    setElementData(vehicleElement[player], "veh:traveledDistance", math.random(100000,300000))
    setElementData(vehicleElement[player], "veh:owner", 0)
    setElementData(vehicleElement[player], "veh:engine", true)
    setElementData(vehicleElement[player], "veh:locked", true)
    setVehicleLocked(vehicleElement[player], true)
    setElementData(vehicleElement[player], "veh:distanceToOilChange", 0)
    setElementData(vehicleElement[player], "veh:stealedCar", true)
    setElementData(player, "veh:stealedCarElement", vehicleElement[player])
    setElementData(vehicleElement[player], "veh:stealedCarOwner", player)

    --exports.oHandling:loadHandling(vehicleElement[player])
end)

addEvent("unlockTheVehicle", true)
addEventHandler("unlockTheVehicle", getRootElement(), function(player)
    if vehicleElement[player] then 
        setElementData(vehicleElement[player], "veh:locked", false)
        setVehicleLocked(vehicleElement[player], false)
        setElementData(vehicleElement[player], "char:stealer", true)
    end
end)

addEvent("nemtudomServer", true)
addEventHandler("nemtudomServer", getRootElement(), function(playerSource,vehicle,state, component)
    --print(component)
    triggerClientEvent(root,"vehicleComponentEvent",playerSource,vehicle, state, component,playerSource)
end)

addEvent("setMechanicAnim",true)
addEventHandler("setMechanicAnim",getRootElement(),function(playerSource,typ,state)
	if typ == "create" then
		setPedAnimation (playerSource, "bomber", "bom_plant", -1, true, false, true, true)
		--triggerClientEvent(root, "createMechanicSound", playerSource,playerSource)
	elseif typ == "remove" then
		if tostring(state) == "true" then
            toggleControl(playerSource,"fire", false)
            toggleControl(playerSource,"sprint", false)
            toggleControl(playerSource,"crouch", false)
            toggleControl(playerSource,"jump", false)
			setPedAnimation(playerSource, "CARRY", "crry_prtial", 0, true, false, true, true)
		else
			setPedAnimation(playerSource,nil,nil)
		end
		--triggerClientEvent(root, "destroyMechanicSound", playerSource,playerSource)
	end
end)

addEvent("componentDestroyFromHand",true)
addEventHandler("componentDestroyFromHand",getRootElement(),function(playerSource)
	triggerClientEvent(root,"componentDestroyClient",playerSource,playerSource)
    toggleControl(playerSource,"fire", true)
    toggleControl(playerSource,"sprint", true)
    toggleControl(playerSource,"crouch", true)
    toggleControl(playerSource,"jump", true)
end)

addEventHandler("onPlayerQuit", root,
	function ()
        if vehicleElement[source] then 
            destroyElement(vehicleElement[source])
            vehicleElement[source] = nil
        end
    end
)

addEvent("destroyTheCar", true)
addEventHandler("destroyTheCar", getRootElement(), function(player)
    setElementData(player, "veh:stealedCarElement", false)
    if isElement(vehicleElement[player]) then 
        destroyElement(vehicleElement[player])
    end
end)

addEvent("startStealer", true)
addEventHandler("startStealer", getRootElement(), function(player)
   -- outputChatBox("ad")
    if carStealerTimer[player] then 
        triggerClientEvent(player,"stealerHandler",player, false)
    else
        carStealerTimer[player] = setTimer(function()
            carStealerTimer[player] = nil 
        end,5*60*60*1000,1)
       -- outputChatBox()
        triggerClientEvent(player,"stealerHandler",player, true)
    end
end)