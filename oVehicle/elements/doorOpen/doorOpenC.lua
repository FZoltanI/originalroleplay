function getNearbyVehicle(element)
    if element == localPlayer then
        local shortest = {5000, nil, nil}

        for k,v in pairs(getElementsByType("vehicle", root, true)) do
            local locked = getElementData(v, "veh:locked")
            local x, y, z = getElementPosition(v)
            local firstDist = core:getDistance(element, v)

            if firstDist < 4 then
                for k2, v2 in pairs(doorComponents) do
                    local x, y, z = getVehicleComponentPosition(v, v2[1], "world")

                    if x and y and z then
                        local playerPos = Vector3(getElementPosition(localPlayer))
                        local dist = getDistanceBetweenPoints3D(playerPos.x, playerPos.y, playerPos.z, x, y, z)
                        if v2[1] == "bonnet_dummy" then
                            if dist < shortest[1] and dist < 3 and not locked then
                                shortest = {dist, v, v2}
                            end
                        else
                            if dist < shortest[1] and dist < 2 and not locked then
                                shortest = {dist, v, v2}
                            end
                        end
                    end
                end
            end
        end

        if not shortest[2] or shortest[2] and not isElement(shortest[2]) then
            return false
        else
            return shortest
        end
    end
end

function interactVeh()
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 600, 1)
    --if boneBreaked(localPlayer) then return end
    if getPedWeapon(localPlayer) ~= 0 then return end
    if isCursorShowing() then return end
    if getElementData(localPlayer, "cuff:usePlayer") then return end
    if not getPedOccupiedVehicle(localPlayer) then
        local veh = getNearbyVehicle(localPlayer)
        if veh then
            local dist, element, componentDetails = unpack(veh)
            local newState = getVehicleDoorOpenRatio(element, componentDetails[2]) == 1
            triggerServerEvent("changeDoorState2", localPlayer, element, componentDetails[2], newState)
            if not newState then
                if componentDetails[2] >= 2 then
                    playSound("files/door_open.mp3")
                   exports.oChat:sendLocalMeAction("kinyitja a "..componentDetails[3].."ajtót", 1)
                else
                    playSound("files/door_open.mp3")
                   exports.oChat:sendLocalMeAction("felnyitja a "..componentDetails[3].."t", 1)
                end
            else
                if componentDetails[2] >= 2 then
                    playSound("files/door_close.mp3")
                   exports.oChat:sendLocalMeAction("bezárja a "..componentDetails[3].."ajtót", 1)
                else
                    playSound("files/door_close.mp3")
                   exports.oChat:sendLocalMeAction("bezárja a "..componentDetails[3].."t", 1)
                end
            end
        end
    end
end
bindKey("mouse2", "down", interactVeh)