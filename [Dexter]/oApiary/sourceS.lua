local connection = exports.oMysql:getDBConnection() 

local loadedApairy = {}

local apiaryHealthTimer = {}

local apiaryLockingTimer = {}

local apiaryProgressingTimer = {}

--964

addEventHandler("onResourceStart", getRootElement(),
	function(startedResource)
        if source == getResourceRootElement() then
            dbQuery(loadApiarys, connection, "SELECT * FROM apairy")
        end
    end
)

function loadApiarys(qh)
    local result = dbPoll(qh, 0)
    if result then 
        for k,v in pairs(result) do 
            loadApiary(v)
        end
    end
end

function placeApiary(player)
    local playerPosX, playerPosY, playerPosZ = getElementPosition(player)
    local rotX,rotY,rotZ = getElementRotation(player)
    local ownerId = getElementData(player, characterIDElementData)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0, true)[2][1][1]
        if result then 
            if loadApiary(result) then 
                if isElement(player) then 
                    outputChatBox(core:getServerPrefix("red-dark", 2).."Sikeresen létrehoztad a kaptárad. (ID: ".. result.id..")",player)
                end
            end
        end
    end, connection, "INSERT INTO apairy (x,y,z,rotation,owner,locked) VALUES (?, ?, ?, ?, ?, ?); SELECT * FROM apairy ORDER BY id DESC LIMIT 1",playerPosX, playerPosY, playerPosZ, rotZ, ownerId, 0)
end

function loadApiary(data)
    local objectElement = createObject(964, data.x, data.y, data.z-1,0, 0, data.rotation)
    if isElement(objectElement) then 
        setElementData(objectElement, "isApiary", true)
        setElementData(objectElement, "apiary:dbId", data.id)
        setElementData(objectElement, "apiary:health", data.health)
        setElementData(objectElement, "apiary:progress", data.progress)
        setElementData(objectElement, "apiary:owner", data.owner)
        setElementData(objectElement, "apiary:locked", data.locked)
        --print(data.locked)
        setElementData(objectElement, "apiary:haveBee", data.haveBee)
        if data.haveBee == "Y" then
            if data.locked == 1 then 
                apiaryLockingTimer[data.id] = setTimer(function()
                    outputChatBox(core:getServerPrefix("red-dark", 2).."Sajnos elszöktek a méheid! (ID: ".. data.id ..")", player, 255, 255, 255,true)
                    dbExec(connection, "UPDATE apairy SET haveBee = 'N' WHERE id = ?", data.id)
                    setElementData(objectElement, "apiary:haveBee", "N")
                    setElementData(objectElement, "apiary:progress", 0)
                end,closeTime, 1)
            else 
                apiaryProgressingTimer[data.id] = setTimer(function()
                    if getElementData(objectElement, "apiary:progress") > 100 then
                        setElementData(objectElement, "apiary:progress", 100)
                    else 
                        
                        setElementData(objectElement, "apiary:progress", getElementData(objectElement, "apiary:progress")+1)
                    end
                end,gettingHoney,0)
                apiaryLockingTimer[data.id] = setTimer(function()
                    outputChatBox(core:getServerPrefix("red-dark", 2).."Sajnos elpusztúltak a méheid! (ID: ".. data.id ..")", player, 255, 255, 255,true)
                    dbExec(connection, "UPDATE apairy SET haveBee = 'N' WHERE id = ?", data.id)
                    setElementData(objectElement, "apiary:haveBee", "N")
                    setElementData(objectElement, "apiary:progress", 0)
                end,openTime, 1)
            end
            apiaryHealthTimer[data.id] = setTimer(function()
                if getElementData(objectElement, "apiary:health") > 1 then
                    if getElementData(objectElement, "apiary:health") - 7.2 > 1 then
                     --   setElementData(objectElement, "apiary:health", getElementData(objectElement, "apiary:health")-7.2)
                    else 
                        setElementData(objectElement, "apiary:health", 1)
                    end
                end
            end, cleaningTime, 0)
        end
        return true
    end
    return false
end

function changeLockApiary(element, player)
    local apiaryId = getElementData(element, "apiary:dbId") or false
    locked = 0
    if getElementData(element, "apiary:locked") == 1 then 
        locked = 0
        outputChatBox(core:getServerPrefix("red-dark", 2).."Kinyitottad a kaptárat!", player, 255, 255, 255,true)
        outputChatBox(core:getServerPrefix("red-dark", 2).."Figyelem, csak 20 óráig maradhat nyitva a kaptár, különben elszöknek a méhek!", player, 255, 255, 255,true)
        if isTimer(apiaryLockingTimer[apiaryId]) then 
            killTimer(apiaryLockingTimer[apiaryId])
        end
        apiaryLockingTimer[apiaryId] = setTimer(function()
            outputChatBox(core:getServerPrefix("red-dark", 2).."Sajnos elszöktek a méheid!", player, 255, 255, 255,true)
            dbExec(connection, "UPDATE apairy SET haveBee = 'N' WHERE id = ?", apiaryId)
            setElementData(element, "apiary:haveBee", "N")
            setElementData(element, "apiary:progress", 0)
        end,openTime, 1)
        apiaryProgressingTimer[apiaryId] = setTimer(function()
            if getElementData(element, "apiary:progress") > 100 then
                setElementData(element, "apiary:progress", getElementData(element, "apiary:progress")+1)
            else 
                setElementData(element, "apiary:progress", 100)
            end
        end,gettingHoney,0)
    else
        locked = 1
        outputChatBox(core:getServerPrefix("red-dark", 2).."Bezártad a kaptárat!", player, 255, 255, 255, true)
        outputChatBox(core:getServerPrefix("red-dark", 2).."Figyelem, csak 20 óráig maradhat zárva a kaptár, különben elpusztúlnak a méhek!", player, 255, 255, 255,true)
        if isTimer(apiaryLockingTimer[apiaryId]) then 
            killTimer(apiaryLockingTimer[apiaryId])
        end
        apiaryLockingTimer[apiaryId] = setTimer(function()
            outputChatBox(core:getServerPrefix("red-dark", 2).."Sajnos elpusztúltak a méheid!", player, 255, 255, 255,true)
            dbExec(connection, "UPDATE apairy SET haveBee = 'N' WHERE id = ?", apiaryId)
            setElementData(element, "apiary:haveBee", "N")
            setElementData(element, "apiary:progress", 0)
        end,closeTime, 1)
    end
    setElementData(element, "apiary:locked", locked)
    dbExec(connection, "UPDATE apairy SET locked = ? WHERE id = ?",locked, apiaryId)
end

function buyBee(element, player)
    local apiaryId = getElementData(element, "apiary:dbId") or false
    if not apiaryId then 
        outputChatBox("Hiba!", player)
    else
        dbExec(connection, "UPDATE apairy SET haveBee = 'Y' WHERE id = ?", apiaryId)
        setElementData(element, "apiary:haveBee", "Y")
        setElementData(element, "apiary:locked", 1)
    end
end

function pickUpApiary(element, player)
    local apiaryId = getElementData(element, "apiary:dbId") or false
    dbExec(connection, "DELETE FROM apairy WHERE id = ?", apiaryId)
    outputChatBox("Felvetted a kaptárat", player)
    for i, v in ipairs(getElementsByType("object")) do
        if getElementData(v, "isApiary") then
            if getElementData(v, "apiary:dbId") == apiaryId then
                destroyElement(v)
            end
        end
    end
    exports["oInventory"]:giveItem(player, 218, 1, 1)
end

function apiaryCleaning(element, player)
    if getElementData(element, "apiary:health") >= 100 then
        outputChatBox(core:getServerPrefix("red-dark", 2).."Mit akarsz tisztítani?!", player, 255, 255, 255, true)
    else
        setElementData(element, "apiary:health", 100)
        outputChatBox(core:getServerPrefix("red-dark", 2).."progress", player, 255, 255, 255, true)
    end
end

function collectHoney(element, player)
    local apiaryId = getElementData(element, "apiary:dbId") or false
    if getElementData(element, "apiary:health") >= 100 then
        randCount = 0
        if getElementData(element, "apiary:progress") > 0 and getElementData(element, "apiary:progress") < 50 then 
            randCount = math.random(10,30)
        elseif getElementData(element, "apiary:progress") > 50 and getElementData(element, "apiary:progress") < 80 then 
            randCount = math.random(30,50)        
        elseif getElementData(element, "apiary:progress") > 80 then 
            randCount = math.random(50,100)
        elseif getElementData(element, "apiary:progress") < 0 then 
            randCount = 0
        end
        print(getElementData(element, "apiary:progress") )
        setElementData(element, "apiary:progress", 0)
        if randCount > 0 then 
            outputChatBox("Összegyüjtöttél ".. randCount .. "db mézet")
        else 
            outputChatBox("Nincs bent semmi")
        end
    else

    end
end

function convertTime(ms) 
    local min = math.floor ( ms/60000 ) 
    local hour = math.floor ( min/60 ) 
    local sec = math.floor( (ms/1000)%60 ) 
    return hour,min, sec 
end 