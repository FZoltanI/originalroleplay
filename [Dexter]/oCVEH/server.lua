addEvent("cveh > setDoorState", true)
addEventHandler("cveh > setDoorState", resourceRoot, function(vehicle, component, state)
    setVehicleDoorOpenRatio(vehicle, component, state, 400)
end)