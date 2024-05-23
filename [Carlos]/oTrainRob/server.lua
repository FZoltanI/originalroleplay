local mainTrain, trainDriver = false, false
local speedTimer = false
local createdTrainElements = {}

for k, v in ipairs(trainDestroyCols) do 
    local col = createColSphere(v[1], v[2], v[3], 10)
end

function createTrain()
    createdTrainElements = {}

    local randNum = math.random(#trainStartPoses)
    local startX, startY, startZ = unpack(trainStartPoses[randNum])

    local train = createVehicle(538, startX, startY, startZ) ---901.11437988281, 1020.4625854492, 34.578125
    mainTrain = train
    setTrainDerailable(train, false)

    if randNum == 2 then 
        setTrainDirection(train, false)
        setTrainSpeed(mainTrain, -trainSpeed)

        speedTimer = setTimer(function()
            setTrainSpeed(mainTrain, -trainSpeed)
        end, 2500, 0)
    else
        setTrainDirection(train, true)
        setTrainSpeed(mainTrain, trainSpeed)

        speedTimer = setTimer(function()
            setTrainSpeed(mainTrain, trainSpeed)
        end, 2500, 0)
    end

    local ped = createPed(0, 0, 0, 0)
    warpPedIntoVehicle(ped, train)
    trainDriver = ped

    triggerClientEvent(resourceRoot, "trainrob > startTrainDrive", root, ped)

    local lastAttach = train
    for i = 1, math.random(2, 5) do 
        local randomTrailer = math.random(#trailers)
        local veh = createVehicle(trailers[randomTrailer].vehID, -848.34240722656, 1059.177734375, 34.578125)
        setTrainDerailable(veh, false)
        attachTrailerToVehicle(lastAttach, veh)

        table.insert(createdTrainElements, veh)

        if trailers[randomTrailer].attachPoints then 
            for k, v in ipairs(trailers[randomTrailer].attachPoints) do 

                local objID = attachableObjects[1][math.random(#attachableObjects[1])]

                local obj = createObject(objID, 0, 0, 0)

                if objID == 2969 or objID == 3015 or objID == 3014 then 
                    attachElements(obj, veh, v[1], v[2], v[3] - 0.3)
                else
                    attachElements(obj, veh, v[1], v[2], v[3])
                end

                table.insert(createdTrainElements, obj)
            end
        end

        lastAttach = veh
    end

    setElementPosition(getPlayerFromName("Carlos"), 2864.9211425781, 1425.5153808594, 10.8203125) -- -827.32006835938, 1073.8666992188, 35.610179901123-
end



addEventHandler("onColShapeHit", resourceRoot, function(element, mdim)
    if mdim then
        if element == mainTrain then 
            if isTimer(speedTimer) then 
                killTimer(speedTimer) 
            end

            for k, v in pairs(createdTrainElements) do 
                if isElement(v) then 
                    destroyElement(v) 
                end
            end

            destroyElement(mainTrain)
            destroyElement(trainDriver)

            outputChatBox("destroy train")
        end
    end
end)

addEventHandler("onVehicleDamage", resourceRoot, function(loss)
    if source == mainTrain then 
        outputChatBox(getElementHealth(source))
        if getElementHealth(source) <= 325 then 
            setTrainSpeed(source, 0)
            setVehicleEngineState(source, false)
        end
    end
end)

setTimer(function()
    createTrain()
end, 500, 1)