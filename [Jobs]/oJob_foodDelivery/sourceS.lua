local interface = exports.oInterface
local admin = exports.oAdmin
local core = exports.oCore
local font = exports.oFont
local info = exports.oInfobox
color, r, g, b = exports.oCore:getServerColor()

for k,v in ipairs(getElementsByType("player")) do 
    toggleControl(v, "sprint", true)
    toggleControl(v, "jump", true)
    toggleControl(v, "crouch", true)
    toggleControl(v, "enter_exit", true)
    toggleControl(v, "walk", true)
    toggleControl(v, "fire", true)
    setPedAnimation(v, nil, nil)
end


addEvent("vehicleRequest", true)
addEventHandler("vehicleRequest", getRootElement(), function(player)
    local jobveh = createVehicle(565, 2119.7905273438,-1782.3134765625,13.388333320618)

    local max = exports.oVehicle:getVehicleMaxFuel(565)
    setElementData(jobveh, "veh:maxFuel", max)
    setElementData(jobveh, "veh:fuel", max)
    setElementData(jobveh, "veh:traveledDistance", math.random(1000,50000))
    warpPedIntoVehicle(player, jobveh)
    setElementData(jobveh, "jobVeh:createdScript", "Ételfutár")
    setElementData(jobveh, "jobVeh:owner", player)
    setElementData(jobveh, "isJobVeh", true)
    setElementData(jobveh, "jobVeh:destroyTime", (destroyTime or 10))

    setElementData(player, "jobVeh:ownedJobVeh", jobveh)
    info:outputInfoBox("Sikeresen lekérted a munkajárművedet!", "success", player)
    triggerClientEvent(player, "createNPCafterSpawnedVehicle", player, true)
end)

addEvent("vehicleDestroy", true)
addEventHandler("vehicleDestroy", getRootElement(), function(player, veh)
    local jobveh

    if not veh then 
        jobveh = getElementData(player, "jobVeh:ownedJobVeh", jobveh)    
    else
        jobveh = veh
    end
    if jobveh ~= getPedOccupiedVehicle(player) then 
        outputChatBox(core:getServerPrefix("server", "Ételfutár", 1).."Ez nem a te munkajárműved!",player ,255, 255, 255, true)
        return
    end
    info:outputInfoBox("Sikeresen leadtad a munkajárművedet!", "success", player)
    triggerClientEvent(player, "setJob",player)
    destroyElement(jobveh)
    setElementData(player, "jobVeh:ownedJobVeh", false)
end)

local crateObject = {}
local foodBag = {}

addEvent("foodToPlayer", true)
addEventHandler("foodToPlayer", getRootElement(), function(player, state)
    if state then 
        crateObject[player] = createObject(1271, 0, 0, 0, 0, 0, 0)
        setObjectScale(crateObject[player], 0.8)
        exports.oBone:attachElementToBone(crateObject[player],player,12, 0.3, 0.2, 0.15, 90, 70, 90)
        setPedAnimation(player, "CARRY", "crry_prtial", 0, true, false, true, true)
        toggleControl(player, "sprint", false)
        toggleControl(player, "jump", false)
        toggleControl(player, "crouch", false)
        toggleControl(player, "enter_exit", false)
        toggleControl(player, "walk", false)
        toggleControl(player, "fire", false)
    else
        toggleControl(player, "sprint", true)
        toggleControl(player, "jump", true)
        toggleControl(player, "crouch", true)
        toggleControl(player, "enter_exit", true)
        toggleControl(player, "walk", true)
        toggleControl(player, "fire", true)
        setPedAnimation(player, nil, nil)
        if isElement(crateObject[player]) then
            destroyElement(crateObject[player])
        end
    end
end)

addEvent("foodBagToPlayer", true)
addEventHandler("foodBagToPlayer", getRootElement(), function(player, state)
    if state then 
        foodBag[player] = createObject(2663, 0, 0, 0, 0, 0, 0)
        setObjectScale(foodBag[player], 0.5)
        exports.oBone:attachElementToBone(foodBag[player],player,12, 0, 0.04, 0.15, 170, 0, 0)
        toggleControl(player, "sprint", false)
        toggleControl(player, "jump", false)
        toggleControl(player, "crouch", false)
        toggleControl(player, "enter_exit", false)
        toggleControl(player, "walk", false)
        toggleControl(player, "fire", false)
    else
        toggleControl(player, "sprint", true)
        toggleControl(player, "jump", true)
        toggleControl(player, "crouch", true)
        toggleControl(player, "enter_exit", true)
        toggleControl(player, "walk", true)
        toggleControl(player, "fire", true)
        if isElement(foodBag[player]) then
            destroyElement(foodBag[player])
        end
    end
end)

function liftUpAnimation(player)
    setPedAnimation(player,"CARRY","liftup",1100,false,false,false,false)
end
addEvent("liftUpAnimation", true)
addEventHandler("liftUpAnimation", getRootElement(), liftUpAnimation)

addEvent("setPosition", true)
addEventHandler("setPosition", getRootElement(), function(player)
    setElementPosition(player, 2121.7680664062,-1790.0307617188,13.5546875)
    setElementInterior(player, 0)
    setElementDimension(player, 0)
end)