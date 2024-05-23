addEvent("junkyard > destroyVeh", true)
addEventHandler("junkyard > destroyVeh", resourceRoot, function(veh, money)
    setElementData(client, "char:money", getElementData(client, "char:money")+money)

    exports.oVehicle:deleteVehicle(veh)
end)