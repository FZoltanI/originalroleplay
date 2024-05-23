local allowed_interaction = true
local vehicleLimit = {}
addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oChat" or getResourceName(res) == "oVehicle" or getResourceName(res) == "oAdmin" or getResourceName(res) == "oInfobox" then  
        core = exports.oCore
        infobox = exports.oInfobox
        chat = exports.oChat
        admin = exports.oAdmin
	end
end)

function openCarDoor()
    local vehicle = getNearestVehicle(localPlayer, 5) or getPedOccupiedVehicle(localPlayer)

    if vehicle then 

        if allowed_interaction then 
            if isCursorShowing() then return end 

            if playerHasCarKey(vehicle) then 
                if not getElementData(vehicle, "vehicle:tempVeh:vehIsAlwaysLocked") then 
                    triggerServerEvent("setVehicleLocked", resourceRoot, vehicle)

                    local modelID = getElementModel(vehicle)
                    if not bikes[modelID] then 
                        local carName = getVehicleNameFromModel(modelID)

                        if getModdedVehName(modelID) then 
                            carName = getModdedVehName(modelID)
                        end

                        if getElementData(vehicle, "veh:locked") then 
                            --chat:sendLocalMeAction("kinyitja egy "..getModdedVehicleName(vehicle).." ajtaját.")
                            chat:sendLocalMeAction("kinyitja egy "..carName.." ajtaját.")
                        else
                            --chat:sendLocalMeAction("bezárja egy "..getModdedVehicleName(vehicle).." ajtaját.")
                            chat:sendLocalMeAction("bezárja egy "..carName.." ajtaját.")
                        end

                        if getPedOccupiedVehicle(localPlayer) then 
                            playSound("files/car_lock_inside.mp3")
                        else
                            playSound("files/car_lock_outside.mp3")
                        end
                    else
                        local carName = getVehicleNameFromModel(modelID)

                        if getModdedVehName(modelID) then 
                            carName = getModdedVehName(modelID)
                        end

                        if getElementData(vehicle, "veh:locked") then 
                            chat:sendLocalMeAction("leveszi a lakatot egy "..carName.."-ról/ről.")
                        else
                            chat:sendLocalMeAction("felrakja a lakatot egy "..carName.."-ra/re.")
                        end
                    end

                    allowed_interaction = false 
                    setTimer(function() allowed_interaction = true end, 500, 1)
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs kulcsod a járműhöz.",255,255,255,true)
            end

        end

    end
end
bindKey("k", "up", openCarDoor)
setTimer(function()
    unbindKey("k", "up", openCarDoor)
    bindKey("k", "up", openCarDoor)
end, 10000, 0)

bindKey("l", "up", function()
    if getPedOccupiedVehicle(localPlayer) then 
        local vehicle = getPedOccupiedVehicle(localPlayer)
        local vehicleID = getElementModel(vehicle)
        if allowed_interaction then 
            if vehicle then 
    
                if not (bikes[getElementModel(vehicle)]) then 
                    if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
                        if isCursorShowing() then return end 
    
                        if getElementData(vehicle,"veh:lamp") then 
                            chat:sendLocalMeAction("lekapcsolja egy "..getModdedVehName(vehicleID).." lámpáit.")
                        else
                            chat:sendLocalMeAction("felkapcsolja egy "..getModdedVehName(vehicleID).." lámpáit.")
                        end
    
                        triggerServerEvent("setVehicleLamp", resourceRoot, vehicle)
                        playSound("files/light.mp3")
    
                        allowed_interaction = false 
                        setTimer(function() allowed_interaction = true end, 250, 1)
    
                    end
                end
    
            end
    
        end
    end 
    end)

local engineTimer = false
local startsound = false

bindKey("space", "down", function()
    local vehicle = getPedOccupiedVehicle(localPlayer)

    if allowed_interaction then 
        if vehicle then 

            if not (bikes[getElementModel(vehicle)]) then 
                if getPedOccupiedVehicleSeat(localPlayer) == 0 then 

                    if isCursorShowing() then return end
                    if getKeyState("j") then 
                        if playerHasCarKey(vehicle) then 

                            local old = getElementData(vehicle, "veh:engine")
                            local new = not old
                            modelID = getElementModel(vehicle)
                            if not new then return end

                            if not getElementData(vehicle, "veh:engine") then 
                                    if getElementHealth(vehicle) > 250 then 
                                        if tonumber(getElementData(vehicle, "veh:fuel")) > 0 then 
                                            if not isTimer(engineTimer) then 
                                                if getElementData(vehicle, "vehicleInTeslaCharger") then return end
                                               -- modelID = getElementModel(vehicle)
                                                engineTimer = setTimer(function() chat:sendLocalMeAction("elindítja egy "..getModdedVehName(modelID).." motorját.")
                                                    triggerServerEvent("setVehicleEngineOnServer", resourceRoot, vehicle)
                                                    engineTimer = false

                                                    if not (getElementData(vehicle, "veh:fuelType") == getElementData(vehicle, "veh:lastFuelType")) then 
                                                        setTimer(function()
                                                            setElementHealth(vehicle, 250)
                                                            setVehicleEngineState(vehicle, false)
                                                            exports.oInfobox:outputInfoBox("Mivel rossz típusú üzemanyag lett tankolva a járműbe, így a motor meghibásodott!", "warning")
                                                        end, 5000, 1)
                                                    end
                                                end, 1000, 1)

                                                if not (getElementData(vehicle, "veh:fuelType") == "electric") then
                                                    startsound = playSound("files/start.mp3")
                                                end
                                            end
                                        else
                                            chat:sendLocalMeAction("megpróbálja elindítani egy "..getModdedVehName(modelID).." motorját, de nem sikerül neki.")
                                        end
                                    else
                                        chat:sendLocalMeAction("megpróbálja elindítani egy "..getModdedVehName(modelID).." motorját, de nem sikerül neki.")
                                    end

                                    allowed_interaction = false 
                                    setTimer(function() allowed_interaction = true end, 250, 1)
                            end

                        else 
                            outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs kulcsod a járműhöz.",255,255,255,true)
                        end
                    end
                end
            end

        end 

    end

end)

bindKey("j", "down", function()
    local vehicle = getPedOccupiedVehicle(localPlayer)

    if allowed_interaction then 

        if vehicle then 

            if not (bikes[getElementModel(vehicle)]) then 
                if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
                    if isCursorShowing() then return end
                    if playerHasCarKey(vehicle) then 

                        local old = getElementData(vehicle, "veh:engine")
                        local new = not old
                        if new then return end

                        triggerServerEvent("setVehicleEngineOnServer", resourceRoot, vehicle)
                        chat:sendLocalMeAction("leállítja egy "..getModdedVehicleName(vehicle).." motorját.")

                        allowed_interaction = false 
                        setTimer(function() allowed_interaction = true end, 250, 1)
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."Nincs kulcsod a járműhöz.",255,255,255,true)
                    end
                end
            end

        end
    end
end)

function playerHasCarKey(vehicle)
    if getElementData(localPlayer, "user:aduty") then 
        return true 
    elseif tonumber(getElementData(vehicle,"veh:id")) and (exports.oInventory:hasItem(51,getElementData(vehicle,"veh:id")) or exports.oInventory:hasItem(234,getElementData(vehicle,"veh:id"))) then 
        return true 
    elseif getElementData(localPlayer, "job->jobVehicle") == vehicle then
        return true 
    elseif getElementData(vehicle, "jobVeh:owner") == localPlayer then 
        return true 
    elseif getElementData(vehicle, "vehicle:tempVeh:owner") == localPlayer then 
        return true 
    elseif localPlayer == getElementData(vehicle, "renteltcar") then 
        return true
    else
        return false
    end
end


addEventHandler("onClientElementDataChange", root, function(key, old, new)
    if key == "user:loggedin" then
        if source == localPlayer then
            if new then
                local player = source

                setTimer(function()
                    local playerID = getElementData(player, "char:id")
                    triggerServerEvent("loadVehiclesFromClientRequest", resourceRoot, playerID)
                end, 1000, 1)
            else
                local playerID = getElementData(source, "char:id")

                setTimer(function()
                    for k, v in ipairs(getElementsByType("vehicle")) do
                        if getElementData(v, "veh:owner") == playerID then
                            if getElementInterior(v) == 0 then
                                if (getElementData(v, "veh:protected") or 0) == 0 then
                                    if (getElementData(v, "veh:isFactionVehice") or 0) == 0 then
                                        --[[setElementDimension(v, (playerID or 0))

                                        if getElementData(v, "vehicleInTeslaCharger") then
                                            exports.oTeslaCharger:removeTeslaChargerToVehServer(v)
                                        end]]

                                        triggerServerEvent("loadVehicleFromClientRequest", localPlayer, v, false, (playerID))
                                    end
                                end
                            end
                        end
                    end
                end, 1000, 1)
            end
        end
    end
end)

addEventHandler("onClientVehicleStartEnter", root, function(player, seat)
    local modelID = getElementModel(source)
    local newValue = getElementData(source,"veh:distanceToOilChange")
    local veh = getPedOccupiedVehicle(player)

    if nonLockableVehicles[modelID] then

        if getElementData(source, "veh:locked") then 
            outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."A jármű be van zárva.",255,255,255,true)
            cancelEvent()
        end

    end
end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
    if player == localPlayer then 
        if seat == 0 then 
            if isTimer(engineTimer) then 
                killTimer(engineTimer)
                destroyElement(startsound)
            end
        end
    end
end)


addEventHandler("onClientVehicleEnter", root, function(player, seat)
    if player == localPlayer then
        setElementData(player, "vehicle:seatbeltState", false)
        local modelID = getElementModel(source)

        if not bikes[modelID] then 
            setVehicleEngineState(source, getElementData(source, "veh:engine"))
        else
            setVehicleEngineState(source, true)
        end

        if getPedOccupiedVehicleSeat(localPlayer) == 0 then  
            if not getVehicleType(source) == "BMX" then
                outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."A jármű beindításához használd a "..color.."[J] #ffffff+ "..color.."[SPACE] #ffffffbillentyűket.",255,255,255,true)
                outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."A lámpa felkapcsolásához használd az "..color.."[L] #ffffffbillentyűt.",255,255,255,true)
                outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."A biztonsági övedet az "..color.."[F5] #ffffffbillentyűvel tudod becsatolni.",255,255,255,true)
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Jármű",3).."A biztonsági övedet az "..color.."[F5] #ffffffbillentyűvel tudod becsatolni.",255,255,255,true)
        end
    end

end)

-- öv be/ki
local seatbeltTimer = false
bindKey("F5", "up", function()
    if getPedOccupiedVehicle(localPlayer) then 
        if not (bikes[getElementModel(getPedOccupiedVehicle(localPlayer))]) then 
            if not (getVehicleType(getPedOccupiedVehicle(localPlayer)) == "Bike" or getVehicleType(getPedOccupiedVehicle(localPlayer)) == "BMX") then 
                if not isTimer(seatbeltTimer) then 
                    local state = getElementData(localPlayer, "vehicle:seatbeltState") or false 

                    triggerServerEvent("togglePlayerSeatbelt", resourceRoot)

                    if state == false then 
                        chat:sendLocalMeAction("becsatolta a biztonsági övét.")
                        playSound("files/belt_in.mp3")
                    else
                        chat:sendLocalMeAction("kicsatolta a biztonsági övét.")
                        playSound("files/belt_out.mp3")
                    end

                    seatbeltTimer = setTimer(function()
                        if isTimer(seatbeltTimer) then 
                            killTimer(seatbeltTimer)
                        end
                    end, 500, 1)
                end
            end
        end
    end
end)

addEventHandler("onClientVehicleDamage", root, function(attacker, weapon, loss)
    if getPedOccupiedVehicle(localPlayer) == source then 
        if loss >= 50 then 
            if not weapon then
                local multiplier = getVehicleSafetyMultiplier(getElementModel(source)) or 1
                local playerDamage = 0 
        
                if getElementData(localPlayer, "vehicle:seatbeltState") then 
                    playerDamage = loss/40
                else 
                    playerDamage = loss/10
                end

                playerDamage = playerDamage * multiplier

                if not (getElementData(localPlayer, "carshop:inTest")) then 
                    setElementHealth(localPlayer, getElementHealth(localPlayer) - playerDamage)
                    
                    setElementData(localPlayer, "char:health", getElementHealth(localPlayer))
                end
            end
        end
    end
end)

function syncLimits(existingVehicleModels)
    vehicleLimit = {}

    vehicleLimit = existingVehicleModels
    print("limits: "..tostring(existingVehicleModels))
end
addEvent("syncLimits",true)
addEventHandler("syncLimits",root,syncLimits)

function getVehicleLimits(modelID)
	return (vehicleLimit[modelID] or 0) or 0
end 

triggerServerEvent("vehicle > getLimits", resourceRoot)

policeIDCars = {
    [427] = true,
    [428] = true,
    [490] = true,
    [596] = true,
    [597] = true,
    [598] = true,
    [599] = true,
    [601] = true,
    [428] = true,
}

addEventHandler("onClientRender", root, function()
    for _, veh in pairs(getElementsByType("vehicle", root, true)) do     
        if policeIDCars[getElementModel(veh)] then    
            if core:getDistance(localPlayer, veh) < 15 then    
                for compname in pairs(veh:getComponents()) do
                    local x, y = getScreenFromWorldPosition(veh:getComponentPosition("bump_rear_dummy", "world"))
                    local pos = Vector3(getElementPosition(veh))
                    local posx, posy, posz = getElementPosition(localPlayer)
                    if isLineOfSightClear(pos.x, pos.y, pos.z, posx, posy, posz, true, false, false) then
                        if (x) then
                            dxDrawText(getVehiclePlateText(veh), x, y, 0, 0, tocolor(200, 200, 200, 100),0.8,"default")
                        end
                    end
                end
            end  
        end
    end
end)