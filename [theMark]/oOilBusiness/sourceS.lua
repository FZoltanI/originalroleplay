local connection = exports["oMysql"]:getDBConnection()
local hex = "#e97619" --, r, g, b = exports.oCore:getServerColor()

local rentTimeDuration = 60 * 60 * 24 * 7 -- 7 nap

local dayTimeDuration = 60 * 60 * 24 -- 24 óra


addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),function()
    dbQuery(function(qh)
        local result, numAffect, error = dbPoll(qh, 0)
        if numAffect > 0 then 
            for k,v in pairs(result) do 
                local id = v.dbId

                oilDatas[id] = {
                    id = id,
                    owner = v.ownerId,
                    name = v.name,
                    position = fromJSON(v.position),
                    oilPump = v.oilPump,
                    locked = v.locked,
                    oilProgress = v.oilProgress,
                    errorMachine = v.errorMachine,
                    wrongMachineId = v.wrongMachineId,
                    rentOilStation = v.rentOilStation
                }
                --print(numAffect)
                loadOilStation(id)
                startOilStation(id)
            end
            setTimer(processRentedOilStation, 1800000, 0)
            -- setTimer(processRentedOilStation, 2000, 0)
        end
    end,connection, "SELECT * FROM oilbusiness")
end)

function loadOilStation(id)
    if oilDatas[id] then 
        local v = oilDatas[id]
        --outputChatBox(v.position[1])
        local oilMarker = createMarker(v.position[1],v.position[2],v.position[3]-1, "cylinder", 1, 255,0,0,150)
        setElementInterior(oilMarker, 0)
        setElementDimension(oilMarker, 0)
        setElementData(oilMarker,"oilMarker.dbId", id)
        setElementData(oilMarker,"oilMarker.isOil", true)
        --outputChatBox(id)
        setElementData(oilMarker,"oilMarker.datas", oilDatas[id])
    end
end

local giveOil = 2

function startOilStation(stationID)

    if oilDatas[stationID] and not oilTimers[stationID] then 

        local playerSource = false
        --outputConsole(" ")
        outputDebugString("asd")
        if oilDatas[stationID].owner > 0 then 
            outputDebugString("Óra indul")
            oilTimersErrors[stationID] = setTimer(function() 
                for k2, v2 in ipairs(getElementsByType("player")) do 
                    if isElement(v2) then 
                        if oilDatas[stationID].owner == getElementData(v2, "char:id") then
                            playerSource = v2
                            break
                        end
                    end
                end
                if oilDatas[stationID].owner > 0 and oilDatas[stationID].errorMachine == 0 then
                    oilDatas[stationID].errorMachine = 1
                    randomPump = math.random(1,oilDatas[stationID].oilPump)
                    --outputChatBox(randomPump)
                    oilDatas[stationID].wrongMachineId = randomPump
                    dbExec(connection, "UPDATE oilbusiness SET wrongMachineId = ?, errorMachine = 1 WHERE dbId = ?",randomPump, stationID)
                    setElementData(getOilStationById(stationID), "oilMarker.datas", oilDatas[stationID])
                    if isElement(playerSource) then 
                        -- Ez csak akkor érvényesül ha fent van az adott játékos
                        triggerClientEvent(root, "createRepairMarker", root, stationID)
                    end
                   outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Figyelem az egyik olaj pumpa leállt kérlek javítsd meg!", playerSource, 255, 255, 255, true)
                    outputDebugString("Megállt")
                end
            end, 12*60*60*1000, 0) -- 12*60*60*1000
            outputDebugString(oilDatas[stationID].oilProgress)
            asd = 60*60*1000/oilDatas[stationID].oilPump
            --outputChatBox(asd) 
            oilTimers[stationID] = setTimer(function()
                -- outputChatBox(inspect(oilDatas[8].oilProgress))
                if oilDatas[stationID].owner > 0 and  oilDatas[stationID].oilPump > 0 then
                    if oilDatas[stationID].oilProgress + giveOil < 10000 then --errorMachine
                        if oilDatas[stationID].errorMachine == 0 then
                            oilDatas[stationID].oilProgress = oilDatas[stationID].oilProgress + giveOil
                            dbExec(connection, "UPDATE oilbusiness SET oilProgress = ? WHERE dbId = ?", oilDatas[stationID].oilProgress, stationID)
                         --   outputChatBox(oilDatas[stationID].oilProgress)
                            setElementData(getOilStationById(stationID), "oilMarker.datas", oilDatas[stationID])
                            outputDebugString(oilDatas[stationID].oilProgress)
                        end
                    end
                end
            end, 50000, 0) -- mennyi idő alatt termeljen
            -- end, 1000, 0) -- mennyi idő alatt termeljen
        end
    end
end

addEvent("updatePumpProgress", true)
addEventHandler("updatePumpProgress", root, function(player, dotdata) --BARANYKA
    connection:exec("UPDATE oilbusiness SET oilProgress=? WHERE ownerId=?", dotdata, player:getData("char:id"))
    -- outputChatBox("pump dat")
end)


-- 705.00933837891, 1403.9827880859, 17.219705581665

addEvent("create.oilVehicle", true)
addEventHandler("create.oilVehicle", root, function(player,oilCount)
    oilVeh = Vehicle(515, 518.43609619141, 1181.5064697266, 10.323194503784)
    player.dimension = 0
    oilVeh.dimension = 0
    oilVeh:setData("veh:id", player:getData("char:id"))
    oilVeh:setData("veh:owner", -1)
    oilVeh:setData("veh:engine", true)
    oilVeh:setData("veh:locked", false)
    oilVeh:setData("veh:fuel", false)
    oilVeh:setData("veh:fuelType", "95")
    oilVeh:setData("veh:oilCount", oilCount)
    -- player:setData()
    player:warpIntoVehicle(oilVeh)
end)

local LitersPerPrice = 10
addEvent("destroyVehGiveMoney", true)
addEventHandler("destroyVehGiveMoney", root, function(player, oils)
    local reportedMoney = LitersPerPrice * oils
    oilVeh:destroy()
    player:setData("char:money", player:getData("char:money") + reportedMoney)
    outputChatBox(exports["oCore"]:getServerPrefix() .. "Sikersen leadtál" .. " " .. oils .. " liter olajat!", player, 255, 255, 255, true)
    outputChatBox(exports["oCore"]:getServerPrefix() .. "Ennyi pénzt kaptál az olajért: " .. reportedMoney .. "$", player, 255, 255, 255, true)
end)

addEvent("teleportToOilStation", true)
addEventHandler("teleportToOilStation", getRootElement(), function(playerElement, id)
    setElementPosition(playerElement, 659.05920410156,1256.3720703125,11.4609375)
    
    setElementInterior(playerElement, 0)

    local dim = id
    setElementDimension(playerElement, dim)
    triggerClientEvent(playerElement, "initDimension", playerElement, id, dim)
    triggerClientEvent(playerElement, "createObj", playerElement, id)
end)

addEvent("teleportOut",true)
addEventHandler("teleportOut",getRootElement(),function(player, id)
    setElementData(player, "char.OilStationId", 0)
    local data = getElementData(getOilStationById(id), "oilMarker.datas")
    setElementPosition(player, data.position[1],data.position[2], data.position[3])
    setElementInterior(player, 0)
    setElementDimension(player, 0)
    triggerClientEvent(player, "unLoadDimension", player)
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for k,v in ipairs(getElementsByType("player")) do 
        if getElementData(v,"char.OilStationId") then 
           -- triggerEvent("teleportOut", v, v, getElementDimension(v))
        end
    end
end)

addEvent("changeOilStationOwner",true)
addEventHandler("changeOilStationOwner",getRootElement(),function(playerElement, dbId) --changeOilStationOwner
    local renewalTime = getRealTime().timestamp + rentTimeDuration
   -- local success = true
    dbQuery(function(qh)
        local result, numAffect = dbPoll(qh, 0)
        if numAffect > 0 then 
            -- outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Neked már van olaj teleped!",playerElement ,255, 255, 255, true)
        else 
            if dbExec(connection, "UPDATE oilbusiness SET ownerId = ?, rentOilStation = ?, name = ? WHERE dbId = ?", getElementData(playerElement, "char:id"), renewalTime,getPlayerName(playerElement) ,dbId) then 
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Sikeresen kibérelted az olaj telepet!",playerElement ,255, 255, 255, true)
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF 1 heted van meghosszabítani!",playerElement ,255, 255, 255, true)
                setElementData(playerElement, "char:money", getElementData(playerElement, "char:money")-3000)
                local data = getElementData(getOilStationById(dbId), "oilMarker.datas")
                data.owner = getElementData(playerElement, "char:id")
                data.name = getPlayerName(playerElement)
                data.rentOilStation = renewalTime
                oilDatas[dbId].owner = getElementData(playerElement, "char:id")
                setElementData(getOilStationById(dbId), "oilMarker.datas", data)
                startOilStation(dbId)
            else
                outputChatBox(hex .."[OriginalRoleplay - OilStation]#FFFFFF Hiba történt!",playerElement ,255, 255, 255, true)
            end
        end
    end, connection, "SELECT * FROM oilbusiness WHERE ownerId = ?", getElementData(playerElement, "char:id"))

end)

function processRentedOilStation()
    local currentTime = getRealTime().timestamp
    for k,v in pairs(oilDatas) do 
        if v.owner > 0 and v.rentOilStation > 0 then 
            --outputChatBox(v.name)
            local playerSource = false
            for k2, v2 in ipairs(getElementsByType("player")) do 
                if isElement(v2) then 
                    if v.owner == getElementData(v2, "char:id") then
                        playerSource = v2
                        break
                    end
                end
            end
            --outputChatBox(currentTime .." || ".. v.rentOilStation - dayTimeDuration)
            if currentTime >= v.rentOilStation then 
                outputChatBox("reset")
                if isElement(playerSource) then
                    outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Lejárt az olaj telep bérlésed!", playerSource, 255,255,255,true)
                end
            elseif v.rentOilStation - dayTimeDuration <= currentTime then
                if isElement(playerSource) then
                    local remaining = math.floor((v.rentOilStation - currentTime) % dayTimeDuration / 3600)                
                    outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Hamarosan lejár az olaj teleped (még ".. remaining .." óra)", playerSource, 255,255,255,true)      
                end
            end
        end
    end
end

addEvent("reapirPumpToServer",true)
addEventHandler("reapirPumpToServer", getRootElement(),function(playerElement, stationID, wrongMachine)
    if oilDatas[stationID] then
        oilDatas[stationID].errorMachine = 0
        oilDatas[stationID].wrongMachineId = 0
        dbExec(connection, "UPDATE oilbusiness SET wrongMachineId = 0, errorMachine = 0 WHERE dbId = ?", stationID)
        outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Sikeresen megjavítottad a ".. wrongMachine .. " számú pumpát.", playerElement, 255, 255, 255, true)
        setElementData(getOilStationById(stationID), "oilMarker.datas", oilDatas[stationID])
    end
end)

addCommandHandler("createoilstation", function(player, cmd, name)
    if not name then name = "Kiadó!" end
    local newId = 0
    local px,py,pz = getElementPosition(player)
    dbExec(connection, "INSERT oilbusiness SET name = ?, position = ?", name, toJSON({px, py, pz}))
    dbQuery(function(qh)
        local result, numAffectRows = dbPoll(qh, 0)
        if numAffectRows > 0 then 
            for k, v in pairs(result) do
                newId = v.dbId
            end
        end
    end, connection, "SELECT dbId FROM oilbusiness WHERE dbId = LAST_INSERT_ID()")
    setTimer(function()
        oilDatas[newId] = {
            id = newId,
            owner = 0,
            name = name,
            position = {px,py,pz},
            oilPump = 1,
            locked = 1,
            oilProgress = 0,
            errorMachine = 0,
            wrongMachineId = 0,
            rentOilStation = 0
        }
        loadOilStation(newId)
        outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Sikeresen létrehoztál egy olaj telepet (Név: ".. name .." | ID: ".. newId ..").", player, 255, 255, 255, true)
    end,1000,1)
end)

addCommandHandler("deleteoilstation",function(player, cmd, id)
    if not id then 
        outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Használat: /"..cmd .." [ID]", player, 255, 255, 255, true)
    else
        id = tonumber(id)
        if oilDatas[id] then 
            --oilTimers oilTimersErrors
            if isTimer(oilTimers[id]) then killTimer(oilTimers[id]) end
            if isTimer(oilTimersErrors[id]) then killTimer(oilTimersErrors[id]) end
            for k,v in ipairs(getElementsByType("marker")) do 
                if getElementData(v, "oilMarker.isOil") then 
                    if getElementData(v, "oilMarker.dbId") == id then 
                        destroyElement(v)
                    end
                end
            end
            dbExec(connection, "DELETE FROM oilbusiness WHERE dbId = ?", id)
            oilDatas[id] = nil
            outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Sikeresen törölted a(z) #".. id .. " id-vel rendelkező olaj telepet.", player, 255, 255, 255, true)
        else 
            outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Ezzel az id-vel rendelkező olaj telep nem található!", player, 255, 255, 255, true) 
        end
    end
end)


addEvent("updatePumps", true)
addEventHandler("updatePumps", root, function(player, accepteddata, data2, price)
    if not accepteddata then return end
    connection:query(function(qh)
        local result = qh:poll(0)
        if result then
            for k, v in ipairs(result) do
                local stationData = getElementData(getOilStationByOwner(getElementData(player, "char:id")), "oilMarker.datas")
                -- outputChatBox(stationData.oilPump)
                -- stationData.oilPump = stationData.oilPump + 1
                local havePump = v["oilPump"]
                if havePump >= #oilStation.oilPump then outputChatBox(exports["oCore"]:getServerPrefix() .. "Ennél több olaj kutad nem lehet!", player, 255, 255, 255, true) return end
                connection:exec("UPDATE oilbusiness SET oilPump=? WHERE ownerId=?", havePump + 1, getElementData(player, "char:id"))
                if (data2 == 1) then
                    player:setData("char:money", player:getData("char:money") - price)
                    outputChatBox(exports["oCore"]:getServerPrefix() .. "Sikeresen vásároltál olajfúrót!(Ennyiért:" .. " " .. price .. "$", player, 255, 255, 255, true)
                    oilDatas[v.dbId].oilPump = havePump + 1
                    oilDatas[stationData.id] = {
                        id = stationData.id,
                        owner = stationData.owner,
                        name = stationData.name,
                        position = stationData.position,
                        oilPump = havePump + 1,
                        locked = stationData.locked,
                        oilProgress = stationData.oilProgress,
                        errorMachine = stationData.errorMachine,
                        wrongMachineId = stationData.wrongMachineId,
                        rentOilStation = stationData.rentOilStation
                    }
                    setElementData(getOilStationByOwner(getElementData(player, "char:id")),"oilMarker.datas", oilDatas[stationData.id])
                    setTimer(function()
                        startOilStation(stationData.id)
                    end,1000,1)
                    
                    --outputChatBox(exports["oCore"]:getServerPrefix() .. "Reconnectelj hogy jóváíródjon az olajfúrókút!", player, 255, 255, 255, true)
                end
                break
            end
        end
    end, "SELECT * FROM oilbusiness WHERE ownerId=?", getElementData(player, "char:id"))
end)


addCommandHandler("nearbyoilstation", function(player, cmd, lDist)
    if not lDist then lDist = 10 end
    local posX, posY, posZ = getElementPosition(player)
    outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Olaj telepek a közeledben (".. lDist .." Yard)", player, 255, 255, 255, true) 
    local count = 0
    if lDist then 
        lDist = tonumber(lDist)
    end
    for k,v in ipairs(getElementsByType("marker")) do 
        if getElementData(v, "oilMarker.isOil") then  
            local x,y,z = getElementPosition(v)
            local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
            if distance <= lDist and v and isElement(v) then
                local dbId = getElementData(v, "oilMarker.dbId")
                local stationData = getElementData(v, "oilMarker.datas")
                if dbId then 
                    outputChatBox(hex .. " *#FFFFFF Azonosító: "..hex.. dbId .."#FFFFFF | TulajdonosID: "..hex.. stationData.owner.."#FFFFFF | Távolság: "..hex.. math.floor(distance) .. "#FFFFFF Yard", player, 255, 255, 255, true)
                    count = count + 1
                end
            end
        end
    end
    if count == 0 then 
        outputChatBox(hex .. "[OriginalRoleplay - OilStation]#FFFFFF Nem található ".. lDist .." Yard-on belül olaj telep", player, 255, 255, 255, true)
    end
end)

