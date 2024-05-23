-- InteriorID: 115

local truckCount = 2 -- és pluszba a fogó (min: 2)
local createdVehicles = {}
local dim, int = 1135, 15

local core = exports.oCore
local color, r, g, b = core:getServerColor()

function createCars()
    local startX, startY, startZ = -1277.8096923828,994.94964599609,1038.2087402344

    for i = 1, truckCount + 1 do 
        local veh = createVehicle(444, startX, startY, startZ)

        setVehiclePlateText(veh, "Event-"..i)
        setElementDimension(veh, dim)
        setElementInterior(veh, int)
        setVehicleEngineState(veh, true)
        setElementData(veh, "veh:distanceToOilChange", 15000)
        setElementData(veh, "veh:fuel", 999)

        setElementData(veh, "veh:engine", true)
        setElementData(veh, "veh:locked", false)
            setVehicleLocked(veh, false)

        if i == 1 then
            setVehicleColor(veh, r, g, b, r, g, b)
            setElementData(veh, "fogocska:elkapo", true)
            startX, startY, startZ = -1392.6604003906,962.46710205078,1025.0495605469
            setElementRotation(veh, 0, 0, 90)
        else
            setVehicleColor(veh, 255, 255, 255, 255, 255, 255)
            setElementData(veh, "fogocska:uldozott", true)
            table.insert(createdVehicles, veh)
        end

        startX = startX - 5
    end
end
createCars()

addEvent("fogocska > elkapas", true)
addEventHandler("fogocska > elkapas", resourceRoot, function(loser)
    if not client then return end 

    --if isElement(loser) then
        local lsPlayer = getVehicleOccupant(loser)
        

        if lsPlayer then
            local lsPlayerName = getElementData(lsPlayer, "char:name") or "null"
            local lsPlayerID = getElementData(lsPlayer, "playerid") or 0
            for k, v in ipairs(getElementsByType("player")) do 
                if (getElementData(v, "user:admin") or 0) >= 2 then 
                    outputChatBox(core:getServerPrefix("server", "Fogócska", 2)..lsPlayerName..color.." ("..lsPlayerID..") #ffffff kiesett a játékból.", v, 255, 255, 255, true)
                end
            end

            for k, v in pairs(createdVehicles) do 
                if v == loser then 
                    table.remove(createdVehicles, k)
                    break
                end
            end

            destroyElement(loser)
            setTimer(function()
                setElementPosition(lsPlayer, -1396.4916992188,919.19854736328,1047.5610351562)
                setElementHealth(lsPlayer, 100)
            end, 500, 1)
            outputChatBox(core:getServerPrefix("red-dark", "Fogócska", 2).."Kiestél a játékból!", lsPlayer, 255, 255, 255, true)

            --outputChatBox(#createdVehicles)
            setTimer(function()
                if #createdVehicles == 1 then 
                    local wPlayer = getVehicleOccupant(createdVehicles[1])
                    if wPlayer then 
                        destroyElement(createdVehicles[1])

                        setTimer(function()
                            setElementPosition(wPlayer, -1428.3264160156,932.54669189453,1041.53125)
                        end, 500, 1)
                        setElementHealth(wPlayer, 100)

                        local wPlayerName = getElementData(wPlayer, "char:name") or "null"
                        local wPlayerID = getElementData(wPlayer, "playerid") or 0
                        for k, v in ipairs(getElementsByType("player")) do 
                            if (getElementData(v, "user:admin") or 0) >= 2 then 
                                outputChatBox(core:getServerPrefix("yellow", "Fogócska", 2)..wPlayerName..color.." ("..wPlayerID..") #ffffff megnyerte a játékot.", v, 255, 255, 255, true)
                            end
                        end
    
                        outputChatBox(core:getServerPrefix("yellow", "Fogócska", 2).."Megnyerted ezt a kört!", wPlayer, 255, 255, 255, true)
    
                    end
                end
            end, 1000, 1)
            
        end
    --end
end)

addEventHandler("onVehicleEnter", root, function(player)
    if getElementData(source, "fogocska:uldozott") then 
        setVehicleLocked(source, true)
        setElementData(source, "veh:locked", true)
    end
end)