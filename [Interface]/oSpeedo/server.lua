addEvent("speedo > setVehicleDatas", true)
addEventHandler("speedo > setVehicleDatas", resourceRoot, function(veh, fuel, traveledDistance, oil)
    setElementData(veh, "veh:fuel", fuel)
    setElementData(veh, "veh:traveledDistance", traveledDistance)

    if fuel <= 0 then 
        setVehicleEngineState(veh, false)
        setElementData(veh, "veh:engine", false)
    end

    if oil then
        if tonumber(oil) <= 0 then 
            setVehicleEngineState(veh, false)
            setElementData(veh, "veh:engine", false)
            setElementHealth(veh, 250)
        end
    end
end)