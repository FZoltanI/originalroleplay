addEventHandler("onTrailerDetach", root, function()
    outputChatBox("fasz")
end)

addEventHandler("onClientRender", getRootElement(), function() 
    setTime(03, 00)
    for k, v in ipairs(getElementsByType("vehicle")) do 
        local towedVehicle = getVehicleTowedByVehicle ( v )

        if towedVehicle then 
            --outputChatBox(getElementData(towedVehicle, "veh:id"))
            local towtruck = getVehicleTowingVehicle(towedVehicle)

            --outputChatBox(getElementData(towedVehicle, "veh:id").." "..getElementData(towtruck, "veh:id"))

            if exports.oCore:getDistance(towtruck, towedVehicle) > 0.25 then 
                detachTrailerFromVehicle(towedVehicle)
                attachTrailerToVehicle(towedVehicle, towtruck)
            end
        end
    end
end)