local conn = exports.oMysql:getDBConnection()

local chargingTimers = {}
local chargers = {}

addEvent("teslaCharger > createCharger", true)
addEventHandler("teslaCharger > createCharger", resourceRoot, function(pos, blip)
    local player = client
    local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO teslachargers SET pos=?, hasBlip=?", toJSON(pos), blip, 1234), 250)

    setTimer(function()
        if insertID then
            createOneCharger(insertID, pos, blip)
            triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "létrehozott egy tesla töltőt. #db3535(#"..insertID..")", 8)
        end
    end, 250, 1)
end)

addEventHandler("onResourceStart", resourceRoot, function()
    local result = dbPoll(dbQuery(conn, 'SELECT * FROM teslachargers'), 255)

    if result then 
        for k, v in ipairs(result) do 
            createOneCharger(v["id"], fromJSON(v["pos"]), v["hasBlip"])
        end
    end
end)

addCommandHandler("fixcharger",function(player,cmd,id)
    if getElementData(player,"user:admin") >= 2 then
        if id then 
            id = tonumber(id)
            if chargers[id] then 
                for k, v in ipairs(chargers[id]) do 
                    destroyElement(v)
                end

                chargers[id] = false 

                local result = dbPoll(dbQuery(conn, 'SELECT * FROM teslachargers'), 255)

                if result then 
                    for k, v in ipairs(result) do
                        if v["id"]==id then
                            createOneCharger(v["id"], fromJSON(v["pos"]), v["hasBlip"])
                        end
                    end
                end

                triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "Frissített egy Tesla töltőt", 8)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Tesla Charger", 2).."Nincs ilyen azonosítóval rendelkező töltő.", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [ID]", player, 255, 255, 255, true)
        end
    end
end)


addCommandHandler("delcharger", function(player, cmd, id)
    if getElementData(player, "user:admin") >= 8 then 
        if id then 
            id = tonumber(id)
            if chargers[id] then 
                for k, v in ipairs(chargers[id]) do 
                    destroyElement(v)
                end

                chargers[id] = false 

                dbExec(conn, "DELETE FROM teslachargers WHERE id = ?", id)

                triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "törölt egy tesla töltőt.", 8)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Tesla Charger", 2).."Nincs ilyen azonosítóval rendelkező töltő.", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [ID]", player, 255, 255, 255, true)
        end
    end
end)

function createOneCharger(id, pos, hasBlip)
    local x, y, z, rotx, roty, rotz, dim, int = unpack(pos)

    local charger = createObject(10986, x, y, z-0.5, rotx, roty, rotz)--createObject(13641, x, y, z, rotx, roty, rotz)
    local chargerHead = createObject(10432, x, y, z, rotx, roty, rotz)


    attachElements(chargerHead, charger, 0.66, -0.01, 0.72, -40, 0, 90)


    setElementCollisionsEnabled(chargerHead, false)

    setElementData(chargerHead, "teslaCharger:chargerBody", charger)


    setElementDoubleSided(charger, true)

    setElementData(charger, "teslaCharger:inUse", false)
    setElementData(charger, "teslaCharger:isCharger", true)
    setElementData(charger, "teslaCharger:chargerHead", chargerHead)

    setElementData(charger, "teslaCharger:col:realHead", chargerHead)
    setElementData(charger, "teslaCharger:col:inUse", false)

    setElementData(charger, "teslaCharger:id", id)

    if hasBlip == 1 then
        if dim == 0 and int == 0 then
            local blip = createBlip(x, y, z, 51)
            setElementData(blip, "teslaCharger:obj", charger)
            setElementData(blip, "blip:name", "Tesla töltőállomás")
        end
    end

    chargers[id] = {charger, chargerHead, chargerHeadCol}
end

addEvent("teslaCharger > giveChargerHeadToPlayer", true)
addEventHandler("teslaCharger > giveChargerHeadToPlayer", resourceRoot, function(head)
    bone:attachElementToBone(head, client, 11, -0.06, 0.05, 0.07, 0, 80, 0)
end)

addEvent("teslaCharger > removeChargerHeadFromPlayer", true)
addEventHandler("teslaCharger > removeChargerHeadFromPlayer", resourceRoot, function(head, station)
    bone:detachElementFromBone(head)
    setElementDimension(head,0)
    setElementInterior(head,0)
    local x,y,z = getElementPosition(station)
    setElementPosition(head,x,y,z)
    attachElements(head, station, 0.66, -0.01, 0.72, -40, 0, 90)
    outputDebugString("Asdasdad")
end)

addEvent("teslaCharger > addTeslaChargerToVeh", true)
addEventHandler("teslaCharger > addTeslaChargerToVeh", resourceRoot, function(veh, model, head)
    bone:detachElementFromBone(head)
    attachElements(head, veh, unpack(teslaAttachPoints[model]))
    setElementFrozen(veh, true)
    setElementData(veh, "vehicleInTeslaCharger", head)

    local vehicle = veh
    chargingTimers[veh] = setTimer(function()
        if getElementData(veh, "veh:fuel") < getElementData(veh, "veh:maxFuel") then
            setElementData(veh, "veh:fuel", getElementData(veh, "veh:fuel") + 1)
        end
    end, core:minToMilisec(0.6), 0)
end)

function removeChargerToVeh(veh)
    if isTimer(chargingTimers[veh]) then 
        killTimer(chargingTimers[veh])
    end

    detachElements(getElementData(veh, "vehicleInTeslaCharger"), veh)
    setElementData(veh, "vehicleInTeslaCharger", false)
    setElementFrozen(veh, false)
end
addEvent("teslaCharger > removeTeslaChargerToVeh", true)
addEventHandler("teslaCharger > removeTeslaChargerToVeh", resourceRoot, removeChargerToVeh)

for k, v in ipairs(getElementsByType("vehicle")) do 
    setElementData(v, "vehicleInTeslaCharger", false)
end

function removeTeslaChargerToVehServer(veh)
    local head = getElementData(veh, "vehicleInTeslaCharger")
    removeChargerToVeh(veh)

    local station = getElementData(head, "teslaCharger:chargerBody")
    attachElements(head, station, 0.4, 0.1, 0.78, 20, 0, 90)
    setElementData(station, "teslaCharger:col:inUse", false)
end