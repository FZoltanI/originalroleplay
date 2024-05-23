function sendMessageToAdmins(player, msg)
	triggerClientEvent("sendMessageToAdmins", getRootElement(), player, msg, 8)
end

local createdElements = {}
local createdAlarms = {}
local safeObjects = {}

setElementData(resourceRoot, "bankrob:bank:safeDoorCode", createRandomCode())
setElementData(resourceRoot, "bankrob:bank:laserToggleCode", createRandomCode())

setElementData(resourceRoot, "bankrob:bank:lasersAreActive", false) -- Default: false
setElementData(resourceRoot, "bankrob:bank:bankdoorOpen", false) -- Default: false
setElementData(resourceRoot, "bankrob:bank:alarmTime", 0) -- Default: 0

local lsBankWall = nil

--[[outputChatBox("Safe: "..getElementData(resourceRoot, "bankrob:bank:safeDoorCode"))
outputChatBox("Laser: "..getElementData(resourceRoot, "bankrob:bank:laserToggleCode"))]]

function createElements()
    for k, v in pairs(bankElements) do 
        createdElements[k] = {}

        for k2, v2 in pairs(v) do
            local object = createOneElement(v2, {k, k2}, true)
        end
    end
end

function createLsBankSafeElements()
    for k2, v2 in pairs(lsBankSafeElements) do
        local object = createOneElement(v2, {"ls_bank_Safe", k2}, false)
    end
end

function createOneElement(elementDatas, id, insert)
    elementDatas = elementDatas[math.random(#elementDatas)]
    local object 

    local posX, posY, posZ = unpack(elementDatas[2])
    local rotX, rotY, rotZ = unpack(elementDatas[3])

    if id[2] == "door" or id[2] == "safe" or id[2] == "security_gate" or id[2] == "alarm" then 
        object = createObject(elementDatas[1], posX, posY, posZ, rotX, rotY, rotZ)
        setElementData(object, "bankrob:element:interactionTypes", elementDatas[4])
        setElementData(object, "bankrob:element:interactionEndValue", elementDatas[5])
        setElementData(object, "bankrob:element:bank", k)
        setElementData(object, "bankrob:element:iconPositions", elementDatas[6])

        if id[2] == "security_gate" then 
            local eltolasX, eltolasY, eltolasZ = unpack(elementDatas[6])
            local checkCol = createColTube(posX+eltolasX, posY+eltolasY, posZ - 1, 0.8, 3.5)

            setElementData(checkCol, "bankrob:isIronDetector", id[1])
        elseif id[2] == "alarm" then 
            setElementAlpha(object, 0)
            setElementCollisionsEnabled(object, false)

            createdAlarms[id[1]] = object
        end
    else
        object = createObject(elementDatas[1], posX, posY, posZ, rotX, rotY, rotZ)
        setElementData(object, "bankrob:element:interactionTypes", elementDatas[4])
        setElementData(object, "bankrob:element:interactionEndValue", elementDatas[5])
        setElementData(object, "bankrob:element:bank", k)
        setElementData(object, "bankrob:element:iconPositions", elementDatas[6])

        if elementDatas[7] then 
            setObjectScale(object, elementDatas[7])
            setElementCollisionsEnabled(object, false)
            setElementDoubleSided(object, true)
        end

        if id[2] == "wall_bomb" then 
            lsBankWall = object 
        end
    end

    setElementData(object, "bankrob:element:id", id)

    if insert then
        table.insert(createdElements[id[1]], object)
    else
        table.insert(safeObjects, object)
    end

    return object
end

createElements()

local drillTimers = {}

addEvent("bankrob > createDrill", true)
addEventHandler("bankrob > createDrill", resourceRoot, function(safe)
    local drill = createObject(18315, 0, 0, 0)

    attachElements(drill, safe, 0.05, -0.5, -0.1)

    setElementData(safe, "bankrob:element:interactionTypes", {})

    local drilledSafe = safe

    drillTimers[drill] = setTimer(function()
        local value = (getElementData(drill, "bankrob:drill:drillingValue") or 0) 

        if value < 0.9 then 
            setElementData(drill, "bankrob:drill:drillingValue", (getElementData(drill, "bankrob:drill:drillingValue") or 0)+0.1)
        else
            if isTimer(drillTimers[drill]) then 
                killTimer(drillTimers[drill])
            end

            destroyElement(drill)

            local newSafe = createObject(1829, 0, 0, 0)
            attachElements(newSafe, safe, 0, -0.3, 0.05)
            detachElements(newSafe)

            local safeID = getElementData(safe, "bankrob:element:id")
            setElementData(newSafe, "bankrob:element:id", safeID)

            destroyElement(safe)

            local col = createColTube(0, 0, 0, 1, 2)
            attachElements(col, newSafe, 0, 0, -0.5)

            local randomMoney = math.random(35000, 60000)
            setElementData(col, "bankrob:col:money", randomMoney)
            setElementData(col, "bankrob:col:defMoney", randomMoney)

            setElementData(col, "bankrob:col:safe", newSafe)

            createAlarm(safeID[1])
        end
    end, core:minToMilisec(0.5), 0)
end)

addEvent("bankrob > setPedAnimation", true)
addEventHandler("bankrob > setPedAnimation", resourceRoot, function(group, anim)
    setPedAnimation(client, group, anim, -1, true, false, false)
end)

addEventHandler("onElementDataChange", resourceRoot, function(data, old, new)
    if data == "bankrob:col:money" then 
        if new <= 0 then 
            local safe = getElementData(source, "bankrob:col:safe")
            local ID = getElementData(safe, "bankrob:element:id")

            destroyElement(source)

            setTimer(function()
                destroyElement(safe)
                createOneElement(bankElements[ID[1]][ID[2]], ID)
            end, core:minToMilisec(120), 1)
        end
    end
end)

addEvent("bankrob > openDoor", true)
addEventHandler("bankrob > openDoor", resourceRoot, function(door, time)   
    if time then 
        local player = client

        setPedAnimation(client, "sword", "sword_idle", -1, true, false, false)

        local saw = createObject(9579, 0, 0, 0)
        setElementCollisionsEnabled(saw, false)
        exports.oBone:attachElementToBone(saw, client, 1, -0.2, 0.43, -0.5, 45, 0, 20)
        setElementData(client, "bankrob:activesaw", saw)

        setTimer(function()
            setPedAnimation(player, "", "")

            local posX, posY, posZ = getElementPosition(door)
            local rotateZ = getElementData(door, "bankrob:element:interactionEndValue")
            moveObject(door, 2500, posX, posY, posZ, 0, 0, rotateZ, "Linear")

            setElementData(door, "bankrob:doorPlaySound", false)

            triggerClientEvent("bankrob > playDoorOpenSoundEffect", resourceRoot, door)

            destroyElement(getElementData(player, "bankrob:activesaw"))

            local ID = getElementData(door, "bankrob:element:id")
            setTimer(function()
                destroyElement(door)
                createOneElement(bankElements[ID[1]][ID[2]], ID)
            end, core:minToMilisec(60), 1)
        end, time, 1)
    else
        setPedAnimation(client, "", "")

        local posX, posY, posZ = getElementPosition(door)
        local rotateZ = getElementData(door, "bankrob:element:interactionEndValue")

        if getElementData(door, "bankrob:element:id")[2] == "door_up" then
            moveObject(door, 2500, posX, posY, posZ + 2.2, 0, 0, 0, "Linear")
        else
            moveObject(door, 2500, posX, posY, posZ, 0, 0, rotateZ, "Linear")
        end

        setElementData(door, "bankrob:doorPlaySound", false)

        triggerClientEvent("bankrob > playDoorOpenSoundEffect", resourceRoot, door)

        local ID = getElementData(door, "bankrob:element:id")
        setTimer(function()
            destroyElement(door)
            createOneElement(bankElements[ID[1]][ID[2]], ID)
        end, core:minToMilisec(60), 1)
    end
end)

addEvent("bankrob > pickupMoneyBag", true)
addEventHandler("bankrob > pickupMoneyBag", resourceRoot, function(obj, time, objType)   
    if time then 
        local player = client

        setPedAnimation(client, "rob_bank", "cat_safe_rob", -1, true, false, false)

        setTimer(function()
            setPedAnimation(player, "", "")

            local ID = getElementData(obj, "bankrob:element:id")

            destroyElement(obj)

            local givedMoney = 0

            if objType == "money" then 
                givedMoney = math.random(10000, 20000)
                outputChatBox(core:getServerPrefix("green-dark", "Bankrablás", 2).."A "..color.."pénz #ffffffértéke "..color..givedMoney.."$ #ffffffvolt.", player, 255, 255, 255, true)
            elseif objType == "gold" then 
                givedMoney = math.random(30000, 45000)
                outputChatBox(core:getServerPrefix("green-dark", "Bankrablás", 2).."Az "..color.."arany #ffffffértéke "..color..givedMoney.."$ #ffffffvolt.", player, 255, 255, 255, true)
            end

            setElementData(player, "char:money", getElementData(player, "char:money") + givedMoney)
        end, time, 1)
    end
end)

addEvent("bankrob > exploseWall", true)
addEventHandler("bankrob > exploseWall", resourceRoot, function(object)
    local bombobj = createObject(1252, getElementPosition(object))
    attachElements(bombobj, object, -1, -14.4, -12.5, 0, 0, 0)

    local bombobj2 = createObject(1252, getElementPosition(object))
    attachElements(bombobj2, object, -1, -13.15, -12.5, 0, 0, 0)

    setTimer(function()
        local realX, realY, realZ = getElementPosition(object)
        realX = realX - 1
        realY = realY - 13.15
        realZ = realZ - 12.5
        triggerClientEvent(root, "bankrob > createExplosion", root, realX, realY, realZ)

        local ID = getElementData(object, "bankrob:element:id")
        setTimer(function()
            createOneElement(bankElements[ID[1]][ID[2]], ID)
        end, core:minToMilisec(60), 1)

        for k, v in ipairs(getElementsByType("player")) do 
            local distance = core:getDistance(v, object)

            if distance < 5 then 
                setElementHealth(v, getElementHealth(v) - 25*(5/distance))
                setElementData(v, "char:hp", getElementHealth(v) - 25*(5/distance))
            end
        end
        
        if ID[2] == "wall_bomb" then 
            if not getElementData(resourceRoot, "bankrob:bank:bankdoorOpen") then
                openBigsafeDoor()
            end

            if not getElementData(resourceRoot, "bank:bankInRob:"..ID[1]) then 
                triggerEvent("banrkob > startBankAlarmSound", resourceRoot, ID[1])
            end    
        end

        local posx, posy, posz = getElementPosition(object)
        destroyElement(object)

        local obj = createObject(18312, posx, posy, posz)
        setElementDoubleSided(obj, true)

        lsBankWall = obj

        destroyElement(bombobj)
        destroyElement(bombobj2)
    end, math.random(5000, 10000), 1)
end)

local banksInAlarm = {}

addEvent("banrkob > startBankAlarmSound", true)
addEventHandler("banrkob > startBankAlarmSound", resourceRoot, function(bank)
    createAlarm(bank)

    if isTimer(bigsafe_AlarmTimer) then 
        killTimer(bigsafe_AlarmTimer)
        setElementData(resourceRoot, "bankrob:bank:alarmTime", 0)
    end
end)

function createAlarm(bank)
    if not banksInAlarm[bank] then 
        banksInAlarm[bank] = true 

        setElementData(resourceRoot, "bank:bankInRob:"..bank, true)
        setElementData(createdAlarms[bank], "bank:siren:state", true)

        for k, v in ipairs(getElementsByType("player")) do 
            if exports.oDashboard:getFactionType(getElementData(v, "char:duty:faction")) == 1 then 
                outputChatBox(" ", v)
                outputChatBox(core:getServerPrefix("blue-light-2", "Központ", 3).."Minden egységnek! Itt a központ! A(z) "..color..bankNames[bank].. " #ffffffrablása folyamatban!", v, 255, 255, 255, true)
                outputChatBox(" ", v)
            end
        end

        setTimer(function()
            setElementData(resourceRoot, "bank:bankInRob:"..bank, false)
            setElementData(createdAlarms[bank], "bank:siren:state", false)
        end, core:minToMilisec(30), 1)
    end
end

addEvent("bankrob > sendIronDetectorMessage", true)
addEventHandler("bankrob > sendIronDetectorMessage", resourceRoot, function(bank)
    for k, v in ipairs(getElementsByType("player")) do 
        if exports.oDashboard:getFactionType(getElementData(v, "char:duty:faction")) == 1 then 
            outputChatBox(core:getServerPrefix("blue-light-2", "Központ", 3).."Itt a központ! A(z) "..color..bankNames[bank].. " #fffffffémdetektora illegális tárgyat érzékelt, egy a bank területére lépő személynél!", v, 255, 255, 255, true)
        end
    end
end)

function openSafeDoor()
    for k, v in ipairs(createdElements["market_ls"]) do 
        if isElement(v) then
            if getElementModel(v) == 17143 then 
                local posX, posY, posZ = getElementPosition(v)
                moveObject(v, 6000, posX, posY, posZ, 0, 0, 60)
                break
            end
        end
    end
end

bigsafe_AlarmTimer = false

function openBigsafeDoor()
    openSafeDoor()
    createLsBankSafeElements()
    setElementData(resourceRoot, "bankrob:bank:lasersAreActive", true)
    setElementData(resourceRoot, "bankrob:bank:bankdoorOpen", true)

    setElementData(resourceRoot, "bankrob:bank:alarmTime", bigSafeSirenStart)

    bigsafe_AlarmTimer = setTimer(function()
        local value = getElementData(resourceRoot, "bankrob:bank:alarmTime")
        setElementData(resourceRoot, "bankrob:bank:alarmTime", value - 1)

        if value - 1 == 0 then 
            createAlarm("market_ls")
        end
    end, 1000, bigSafeSirenStart)

    setTimer(function()
        resetBank("market_ls")
    end, core:minToMilisec(60), 1)
end

addEvent("bankrob > openBigSafeDoor", true)
addEventHandler("bankrob > openBigSafeDoor", resourceRoot, openBigsafeDoor)

addEvent("bankrob > cutWires", true)
addEventHandler("bankrob > cutWires", resourceRoot, function()
    setElementData(resourceRoot, "bankrob:bank:lasersAreActive", false)

    setTimer(function()
        setElementData(resourceRoot, "bankrob:bank:lasersAreActive", true)
    end, core:minToMilisec(1), 1)
end)

function resetBank(bankID, player)
    if bankID == "market_ls" then
        if not getElementData(resourceRoot, "bankrob:bank:bankdoorOpen") then return end

        setElementData(resourceRoot, "bankrob:bank:safeDoorCode", createRandomCode())
        setElementData(resourceRoot, "bankrob:bank:laserToggleCode", createRandomCode())
        setElementData(resourceRoot, "bankrob:bank:lasersAreActive", false)
        setElementData(resourceRoot, "bankrob:bank:bankdoorOpen", false)
        setElementData(resourceRoot, "bankrob:bank:alarmTime", 0)

        --outputChatBox("Safe: "..getElementData(resourceRoot, "bankrob:bank:safeDoorCode"))

        if isTimer(bigsafe_AlarmTimer) then killTimer(bigsafe_AlarmTimer) end

        for k, v in ipairs(createdElements["market_ls"]) do 
            if isElement(v) then
                if getElementModel(v) == 17143 then 
                    local posX, posY, posZ = getElementPosition(v)
                    local rotX, rotY, rotZ = getElementRotation(v)
                    moveObject(v, 6000, posX, posY, posZ, 0, 0, -rotZ)
                    break
                end
            end
        end

        for k, v in ipairs(safeObjects) do 
            if isElement(v) then destroyElement(v) end
        end
        safeObjects = {}

        destroyElement(lsBankWall)
        createOneElement(bankElements["market_ls"]["wall_bomb"], {"market_ls", "wall_bomb"}, true)
    end

    setElementData(resourceRoot, "bank:bankInRob:"..bankID, false)
    setElementData(createdAlarms[bankID], "bank:siren:state", false)

    if player then
        sendMessageToAdmins(player, "visszaállította a(z) #db3535"..bankID.."#557ec9 ID-vel rendelkező bankot. ")
    end
end

addCommandHandler("resetbank", function(player, cmd, bankid)
    if getElementData(player, "user:admin") >= 7 then 
        if tonumber(bankid) then 
            bankid = tonumber(bankid)
            if bankid == 1 then 
                resetBank("market_ls", player)
            elseif bankid == 2 then 
                resetBank("palomino", player)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 1).."/"..cmd.." [BankID (1: LS, 2: Palomino)]", player, 255, 255, 255, true)
        end
    end
end)

-- IDG Jack
local jack = false
function createJack()
    if isElement(jack) then destroyElement(jack) end 

    local randomX, randomY, randomZ, rot = unpack(idg_jackPositions[math.random(#idg_jackPositions)])
    jack = createPed(104, randomX, randomY, randomZ, rot)
    setElementFrozen(jack, true)
    setElementData(jack, "ped:name", "Jack")
    setElementData(jack, "idgBankrobCodePed", true)
end
createJack()
setTimer(createJack, core:minToMilisec(60), 0)

-- glassdoor 
local doorClosedPos = {1700.56,-1171.75, 22.85}
local doorOpenedPos = {1702,-1171.75, 22.85}
local door = createObject(18364, doorClosedPos[1], doorClosedPos[2], doorClosedPos[3], 0, 0, 0)
local doorCol = createColTube(doorClosedPos[1] - 0.7, doorClosedPos[2], doorClosedPos[3], 2.3, 2.6)
setElementDoubleSided(door, true)

local doorState = "close"

function openGlassdoor()
    doorState = "open"
    moveObject(door, 2000, doorOpenedPos[1], doorOpenedPos[2], doorOpenedPos[3])
    triggerClientEvent(root, "bankrob > glassdoorSoundEffect", root, doorOpenedPos[1], doorOpenedPos[2], doorOpenedPos[3])
end

function closeGlassdoor()
    if #getElementsWithinColShape(doorCol, "player") == 0 then
        doorState = "close"
        moveObject(door, 2000, doorClosedPos[1], doorClosedPos[2], doorClosedPos[3])
        triggerClientEvent(root, "bankrob > glassdoorSoundEffect", root, doorOpenedPos[1], doorOpenedPos[2], doorOpenedPos[3])
    end
end

addEventHandler ("onColShapeHit", doorCol, function(player, mdim)
    if getElementType(player) == "player" then 
        if mdim then 
            if doorState == "close" then 
                openGlassdoor()
            end
        end
    end
end)

addEventHandler ("onColShapeLeave", doorCol, function(player, mdim)
    if getElementType(player) == "player" then 
        if mdim then 
            if doorState == "open" then 
                closeGlassdoor()
            end
        end
    end
end)