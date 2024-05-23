local vehicleSpawnPos = {
    {1211.9392089844, -1425.0296630859, 13.3828125},
    {1218.2004394531, -1424.6737060547, 13.336205482483},
}

addEvent("job > newspaper > gotoInt", true)
addEventHandler("job > newspaper > gotoInt", resourceRoot, function(startpos)
    --outputChatBox("gotoint")
    setElementData(client, "cleaner:inJobInt", true)
    setElementData(client, "cleaner:startOutPos2", Vector3(getElementPosition(client)))
end)

addEvent("job > newspaper > gotoOut", true)
addEventHandler("job > newspaper > gotoOut", resourceRoot, function()
    setElementData(client, "cleaner:inJobInt", false)
end)

addEvent("job->newspaper->makevehicle", true)
addEventHandler("job->newspaper->makevehicle", resourceRoot,
    function()
        if not getElementData(client,"job->haveJobVehicle") then 

            local randpos = math.random(#vehicleSpawnPos)

            local vehicle = createVehicle(440, vehicleSpawnPos[randpos][1],vehicleSpawnPos[randpos][2],vehicleSpawnPos[randpos][3])
            setElementData(vehicle,"job->vehicleOwner",client)
            setElementData(vehicle,"cleaner:isJobVehicle",true)
            setElementData(vehicle, "veh:fuel", 100)

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
            outputChatBox(core:getServerPrefix("green-dark", "Munkajármű", 2).."A munkajárműved törlésre került!",client,255,255,255,true)
        else 
            --outputChatBox(core:getServerPrefix("red-dark", "Munkajármű", 2).."Nincs munkajárműved!", client,255,255,255,true)
        end
    end 
)

addEvent("cleaner > giveMoney", true)
addEventHandler("cleaner > giveMoney", resourceRoot, function(money)
    setElementData(client, "char:money", getElementData(client, "char:money")+money)
end)