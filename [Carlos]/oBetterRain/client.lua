setTimer(function()
    if getElementInterior(localPlayer) > 0 then return end
    local pos = Vector3(getElementPosition(localPlayer))

    local color = tocolor(255, 0, 0)


    if isLineOfSightClear(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z+1000, true, false, false, true, false) then 
        color = tocolor(0, 0, 255)
        
        exports.oCore:setRainLevelOnClient()
    else
        resetRainLevel()
    end
end, 700, 0)