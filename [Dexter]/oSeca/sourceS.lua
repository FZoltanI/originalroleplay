local data = {
    {"Dr Christopher Gates", 23.4, "Koenigsegg CCX"}
}

addEvent("finish.race",true)
addEventHandler("finish.race", getRootElement(), function(time)
    table.insert(data, {getElementData(source,"char:name"):gsub("_", " "), time, exports["oVehicle"]:getModdedVehicleName(getPedOccupiedVehicle(source))})
    triggerClientEvent(getRootElement(), "race.generateTable",getRootElement(), data)
end)