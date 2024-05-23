addEventHandler( "onClientRender", root, function()

    local veh = getPedOccupiedVehicle( localPlayer )

    if veh then 
        local count = 0
        for k, v in pairs(getVehicleHandling ( veh )) do 
            dxDrawText(k .. ": #00aaff"..toJSON(v), 5, count * 15, _, _, tocolor(255, 255, 255), 1, "default-bold", _, _, false, false, false, true)
            count = count + 1
        end
    end
end)