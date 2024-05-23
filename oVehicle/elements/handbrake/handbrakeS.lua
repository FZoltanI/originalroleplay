addEvent("veh > setVehicleHandbrakeState", true) 
addEventHandler("veh > setVehicleHandbrakeState", resourceRoot, function(veh, value)
    setElementFrozen(veh, value)
end) 