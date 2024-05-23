addEventHandler("onClientElementDataChange", localPlayer, function(key, _, value)
    if key:sub(0, 4) == "log:" then
        if not value then return end

        table.insert(value, 1, getElementData(localPlayer, "char:id"))
        table.insert(value, getDate())

        triggerServerEvent("sendPlayerLogs", localPlayer, key:sub(5), value)
    end
end)

function getDate()
    local time = getRealTime()

    local year = time.year
    local month = time.month
    local day = time.monthday
    local hour = time.hour 
    local min = time.minute 
    local sec = time.second
    
    return (year+1900).."-"..(month+1).."-"..day.." "..hour..":"..min..":"..sec
end