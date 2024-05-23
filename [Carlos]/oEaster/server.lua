function createPeds()
    for k, v in ipairs(peds) do 
        local ped = createPed(v[1], v[2], v[3], v[4], v[5])
        setElementData(ped, "ped:name", v[6])
        setElementData(ped, "ped:prefix", "Easter")
        setElementFrozen(ped, true)

        setElementData(ped, "easterPed", true)
        setElementData(ped, "easterPed:last", 0)
    end
end
createPeds()

addEvent("getServerTick", true)
addEventHandler("getServerTick", resourceRoot, function()
    triggerClientEvent(client, "returnServerTickFromServer", client, getTickCount())
end)