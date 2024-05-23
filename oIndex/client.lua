function interactLeftLight()
   -- if getElementData(localPlayer, 'circleMenu:show') then return end
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 350, 1)
    if isCursorShowing() then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getElementData(veh, "vehindex_right") then return end
        if getElementData(veh, "vehindex_middle") then return end
        if getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Monster Truck" then
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                local oldValue = getElementData(veh, "vehindex_left")
                setElementData(veh, "vehindex_left", not oldValue)
            end
        end
    end
end

function interactRightLight()
    --if getElementData(localPlayer, 'circleMenu:show') then return end
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 350, 1)
    if isCursorShowing() then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getElementData(veh, "vehindex_middle") then return end
        if getElementData(veh, "vehindex_left") then return end
        if getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Monster Truck" then
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                local oldValue = getElementData(veh, "vehindex_right")
                setElementData(veh, "vehindex_right", not oldValue)
            end
        end
    end
end

function interactMiddleLight()
    --if getElementData(localPlayer, 'circleMenu:show') then return end
    if isTimer(spamTimer) then return end
    spamTimer = setTimer(function() end, 350, 1)
    if getElementData(localPlayer, "keysDenied") then return end
    if isCursorShowing() then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if getVehicleType(veh) == "Automobile" or getVehicleType(veh) == "Monster Truck" then
            if getPedOccupiedVehicleSeat(localPlayer) == 0 then
                local oldValue = getElementData(veh, "vehindex_middle")
                local newValue = not oldValue
                if newValue then
                    if getElementData(veh, "vehindex_right") then return end
                    if getElementData(veh, "vehindex_left") then return end
                end
                setElementData(veh, "vehindex_middle", newValue)
            end
        end
    end
end

bindKey("mouse1", "down", interactLeftLight)
bindKey("mouse2", "down", interactRightLight)
bindKey("F7", "down", interactMiddleLight)

addEvent("index", true)
addEventHandler("index", root,
    function(p, veh)
        if p == localPlayer then
            setSoundVolume(playSound("index.mp3"), 0.7)
        end
    end
)

