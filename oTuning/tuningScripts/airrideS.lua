addEvent("tuning > modifyVehicleAirrideLevel", true)
addEventHandler("tuning > modifyVehicleAirrideLevel", resourceRoot, function(veh, level)
    --local handling = getVehicleHandling(veh)
    if level == 0 then 
        level = exports.oHandling:getHandlingElement(veh, 24)
    end

    setVehicleHandling(veh, "suspensionLowerLimit", level)
end)