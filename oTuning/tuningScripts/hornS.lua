addEvent("horn > playVehicleHornSound", true)
addEventHandler("horn > playVehicleHornSound", resourceRoot, function(veh, horn)
	triggerClientEvent(root, "horn > playVehicleHornSoundClient", root, veh, horn)
end)