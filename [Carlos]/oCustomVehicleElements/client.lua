addEventHandler("onClientRender", root, function()
    local parts = getVehicleComponents(getPedOccupiedVehicle(localPlayer))

    for k, v in pairs(parts) do 
        local x, y, z = getVehicleComponentPosition(getPedOccupiedVehicle(localPlayer), k)

        local vehPos = Vector3(getElementPosition(getPedOccupiedVehicle(localPlayer)))
        if x and y and z then 
            local sX, sY = getScreenFromWorldPosition(vehPos.x+x, vehPos.y+y, vehPos.z+z)
            if sX and sY then 
                dxDrawText(k, sX, sY, _, _, tocolor(255, 255, 255, 255), 1, "default-bold")
            end

            local rx, ry, rz = getVehicleComponentRotation(getPedOccupiedVehicle(localPlayer), k) 
            setVehicleComponentRotation(getPedOccupiedVehicle(localPlayer), k, 0, 0, 0)
        end
    end
end)