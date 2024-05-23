--[[addEvent("tesla >assist > setDistencaCheckType", true)
addEventHandler("tesla >assist > setDistencaCheckType", resourceRoot, function(veh, state)
    setElementData(getPedOccupiedVehicle(client), "tesla:assist:distanceCheck:auto", state)
end)]]