local vehicleSpawnPos = {
    {2470.8981933594,-44.33772277832,26.484375},
    {2465.1145019531,-44.887702941895,26.484375},
    {2471.0412597656,-36.248275756836,26.484375},
}

addEvent("job->newspaper->makevehicle", true)
addEventHandler("job->newspaper->makevehicle", resourceRoot,
    function()
        if not getElementData(client,"job->haveJobVehicle") then 

            local randpos = math.random(#vehicleSpawnPos)

            local vehicle = exports.oVehicle:createTemporaryVehicle(462,{vehicleSpawnPos[randpos][1],vehicleSpawnPos[randpos][2],vehicleSpawnPos[randpos][3], 0, 0, 0}, client)
            setElementData(vehicle,"job->vehicleOwner",owner)
            setElementData(vehicle,"newspaper:isJobVehicle",true)

            setElementData(client,"job->haveJobVehicle",true)
            setElementData(client,"job->jobVehicle",vehicle)

            warpPedIntoVehicle(client,vehicle)

            setElementAlpha(vehicle, 150)
            --setElementCollisionsEnabled(vehicle, false)
            setVehicleDamageProof(vehicle, true)

            setTimer(function() 
                setElementAlpha(vehicle, 255)
                --setElementCollisionsEnabled(vehicle, true)
                setVehicleDamageProof(vehicle, false)
            end, 3000, 1)

            outputChatBox(core:getServerPrefix("green-dark", "Munkajármű", 2).."A munkajárműved létrehozása sikeres!",client,255,255,255,true)
        else 
            outputChatBox(core:getServerPrefix("red-dark", "Munkajármű", 2).."Már van munkajárműved!",client,255,255,255,true)
        end
    end 
)

addEvent("job->newspaper->destroyPlayerJobVehicle", true)
addEventHandler("job->newspaper->destroyPlayerJobVehicle", resourceRoot,
    function()
        if getElementData(client,"job->haveJobVehicle") then 
            destroyElement(getElementData(client,"job->jobVehicle"))
            setElementData(client, "job->haveJobVehicle", false)
            setElementData(client, "job->jobVehicle", false)
        else 
            --outputChatBox(core:getServerPrefix("red-dark", "Munkajármű", 2).."Nincs munkajárműved!", client,255,255,255,true)
        end
    end 
)

addEvent("job->newspaper->givemoney", true)
addEventHandler("job->newspaper->givemoney", resourceRoot, function(type, money)
    if type == 1 then 
        setElementData(client, "char:money", getElementData(client, "char:money") + money)
    elseif type == 2 then 
        setElementData(client, "char:money", getElementData(client, "char:money") - money)
    end
end)

addEvent("job->newspaper->addNoteItemToPlayer", true)
addEventHandler("job->newspaper->addNoteItemToPlayer", resourceRoot, function()
    inventory:giveItem(client, 149, 1, 1, 1, 0, "Megrendelések")
end)

addEventHandler("onPlayerQuit", root, function() 
    if getElementData(source,"job->haveJobVehicle") then 
        destroyElement(getElementData(source,"job->jobVehicle"))
        setElementData(source, "job->haveJobVehicle", false)
        setElementData(source, "job->jobVehicle", false)
    end
end)