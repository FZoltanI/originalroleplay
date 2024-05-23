function setAlcoholLevel(level)
    for k, v in ipairs(getElementsByType("vehicles", root, true)) do 
        for i = 1, 3 do 
            local x, y, z = getElementPosition(v)
            local rotX, rotY, rotZ = getElementRotation(v)

            local vehcopy = createVehicle(getElementModel(v), x + 1, y + 1, z + 1, rotX, rotY, rotZ)
            setVehicleColor(vehcopy, getVehicleColor(v))
            setElementAlpha(vehcopy, 150)
            --setElementCollisionsEnabled(vehcopy, false)
            outputChatBox("asd")
        end
    end 
end

    --setAlcoholLevel(2)
    --outputChatBox("asd")