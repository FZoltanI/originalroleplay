for k, v in ipairs(getElementsByType("vehicle")) do 
    detachTrailerFromVehicle(v)
end

addEvent("trailer > attachTrailerToVeh", true)
addEventHandler("trailer > attachTrailerToVeh", resourceRoot, function(veh, trailer)
    attachTrailerToVehicle(veh, trailer)
end)

addEvent("trailer > attachVehToTrailer", true)
addEventHandler("trailer > attachVehToTrailer", resourceRoot, function(veh, trailer)
    attachElements(veh, trailer, 0, 0, 0.5)
end)