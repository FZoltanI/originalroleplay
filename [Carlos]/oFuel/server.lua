local mysql = exports.oMysql:getDBConnection()
local fuelStations = {}

function countFuelPrices()
    local petrol = math.random(5, 15)
    local diesel = math.random(8, 20)

    if diesel < petrol then 
        diesel = diesel + math.random((petrol-diesel), 100) 
    end

    setElementData(resourceRoot, "fuelPrice:95", petrol)
    setElementData(resourceRoot, "fuelPrice:D", diesel)
end
countFuelPrices()
setTimer(countFuelPrices, core:minToMilisec(70), 0)

function sendMessageToAdmins(player, msg)
	triggerClientEvent("sendMessageToAdmins", getRootElement(), player, msg, 8)
end

function loadFuelStations()
    query = dbQuery(mysql, 'SELECT * FROM fuelStations')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            local x, y, z, rot, dim, int = unpack(fromJSON(v["pedDatas"]))

            local ped = createPed(147, x, y, z, rot)
            setElementFrozen(ped, true)
            setElementDimension(ped, dim)
            setElementInterior(ped, int)

            setElementData(ped, "ped:name", "Jhonson")
            setElementData(ped, "ped:prefix", "Benzinkutas")
            setElementData(ped, "fuelStation:name", v["name"])
            setElementData(ped, "fuelStation:id", v["id"])
            setElementData(ped, "fuelStation:isCashier", true)

            fuelStations[v["id"]] = {
                ["ped"] = ped,
                ["pumps"] = fromJSON(v["fuelPumps"]),
                ["pump_objs"] = {},
                ["name"] = v["name"],
            }

            for k2, v2 in ipairs(fuelStations[v["id"]]["pumps"]) do 
                local x, y, z, rot, dim, int = unpack(v2)
                createFuelPump(x, y, z, rot, dim, int, v["id"])
            end
        end
    end
end

addEventHandler("onResourceStart", resourceRoot, function()
    loadFuelStations()
end)

addCommandHandler("createfuelstation", function(player, cmd, ...)
    if getElementData(player, "user:admin") >= 7 then
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if ... then
            local x, y, z = getElementPosition(player)
            local _, _, rot = getElementRotation(player)
            local dim, int = getElementDimension(player), getElementInterior(player)

            local name = table.concat({...}, " ")

            local insertResult, _, insertID = dbPoll(dbQuery(mysql, "INSERT INTO fuelStations SET pedDatas=?, fuelPumps=?, name=?", toJSON({x, y, z, rot, dim, int}),toJSON({}), name), 200)
        
            if tonumber(insertID) then 
                local ped = createPed(147, x, y, z, rot)
                setElementFrozen(ped, true)
                setElementDimension(ped, dim)
                setElementInterior(ped, int)

                setElementData(ped, "ped:name", "Jhonson")
                setElementData(ped, "ped:prefix", "Benzinkutas")
                setElementData(ped, "fuelStation:id", insertID)
                setElementData(ped, "fuelStation:isCashier", true)
                setElementData(ped, "fuelStation:name", name)

                fuelStations[insertID] = {
                    ["ped"] = ped,
                    ["pumps"] = {},
                    ["pump_objs"] = {},
                    ["name"] = name,
                }

                sendMessageToAdmins(player, "létrehozz egy benzinkutat #db3535"..name.." (ID: "..insertID..") #557ec9néven.")
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Fuel", 2).."/"..cmd.." [Név]", player, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("addfuelpump", function(player, cmd, id)
    if getElementData(player, "user:admin") >= 7 then
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if id then
            id = tonumber(id)
            if fuelStations[id] then
                local x, y, z = getElementPosition(player)
                local _, _, rot = getElementRotation(player)
                rot = rot + 0
                local dim, int = getElementDimension(player), getElementInterior(player)
                
                table.insert(fuelStations[id]["pumps"], {x, y, z, rot, dim, int})

                createFuelPump(x, y, z, rot, dim, int, id)

                dbExec(mysql, "UPDATE fuelStations SET fuelPumps = ? WHERE id = ?", toJSON(fuelStations[id]["pumps"]), id)

                sendMessageToAdmins(player, "hozzáadott egy benzinkút fejet a(z) #db3535"..fuelStations[id]["name"].." (ID: "..id..") #557ec9nevű benzinkúthoz.")
            else
                outputChatBox(core:getServerPrefix("red-dark", "Fuel", 2).."Nincs ilyen azonosítóval rendelkezű benzinkút!", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Fuel", 2).."/"..cmd.." [Benzinkút azonosító]", player, 255, 255, 255, true)
        end
    end
end)

function createFuelPump(x, y, z, rot, dim, int, id)
    local obj = createObject(4337, x, y, z-1, _, _, rot)
    setElementRotation(obj, 0, 0, rot)
    setElementDimension(obj, dim)
    setElementInterior(obj, int)

    table.insert(fuelStations[id]["pump_objs"], obj)

    setElementData(obj, "fuelStation:id", id)

    local objects = {}
    for k, v in ipairs(fuelGunAttachPositions) do 
        local gun = createObject(11335, x, y, z)
        local col = createObject(2194, x, y, z)

        setElementData(gun, "fuelStation:pump", obj)
        setElementData(gun, "fuelStation:gun:id", k)
        setElementData(col, "fuelStaiton:col:gun", gun)

        setElementData(col, "fuelStaiton:colSide", k)

        setElementData(col, "fuelStaiton:isGun", true)
        setElementData(col, "fuelStaiton:gun:fuelType", v[1])

        setObjectScale(col, 0)

        table.insert(objects, col)
        table.insert(objects, gun)
        
        attachElements(gun, obj, v[2], v[3], v[4], v[5], v[6], v[7])
        attachElements(col, obj, v[8], v[9], v[10], v[11], v[12], v[13])

    end

    setElementData(obj, "fuelStation:pump:allobject", objects)
end

addCommandHandler("delnearestpump", function(player, cmd, id)
    if getElementData(player, "user:admin") >= 7 then
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if id then
            id = tonumber(id)

            if fuelStations[id] then
                local distance = 5
                local lastMinDis = distance-0.0001
                local nearestObj = false

                local pint = getElementInterior(player)
                local pdim = getElementDimension(player)
            
                for _,v in pairs(getElementsByType("object", resourceRoot)) do
                    local vint,vdim = getElementInterior(v),getElementDimension(v)
                    if vint == pint and vdim == pdim then
                        if getElementModel(v) == 4337 then
                            local dis = core:getDistance(player, v)
                            if dis < distance then
                                if dis < lastMinDis then 
                                    lastMinDis = dis
                                    nearestObj = v
                                end
                            end
                        end
                    end
                end
                
                for k, v in ipairs(fuelStations[id]["pump_objs"]) do 
                    if v == nearestObj then 
                        table.remove(fuelStations[id]["pumps"], k)
                        table.remove(fuelStations[id]["pump_objs"], k)

                        for k2, v2 in ipairs(getElementData(v, "fuelStation:pump:allobject")) do
                            destroyElement(v2)
                        end

                        destroyElement(v)
                    end
                end

                dbExec(mysql, "UPDATE fuelStations SET fuelPumps = ? WHERE id = ?", toJSON(fuelStations[id]["pumps"]), id)

                sendMessageToAdmins(player, "törölt egy benzinkút fejet a(z) #db3535"..fuelStations[id]["name"].." (ID: "..id..") #557ec9nevű benzinkúttól.")
            else
                outputChatBox(core:getServerPrefix("red-dark", "Fuel", 2).."Nincs ilyen azonosítóval rendelkezű benzinkút!", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Fuel", 2).."/"..cmd.." [Benzinkút azonosító]", player, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("delfuelstation", function(player, cmd, id)
    if getElementData(player, "user:admin") >= 7 then
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if id then
            id = tonumber(id)
            if fuelStations[id] then
                destroyElement(fuelStations[id]["ped"])
                for k, v in ipairs(fuelStations[id]["pump_objs"]) do 
                    for k2, v2 in ipairs(getElementData(v, "fuelStation:pump:allobject")) do 
                        destroyElement(v2)
                    end
                    destroyElement(v)
                end

                dbExec(mysql, "DELETE FROM fuelStations WHERE id = ?", id)
                sendMessageToAdmins(player, "törölte a(z) #db3535"..fuelStations[id]["name"].." (ID: "..id..") #557ec9nevű benzinkutat.")
            else
                outputChatBox(core:getServerPrefix("red-dark", "Fuel", 2).."Nincs ilyen azonosítóval rendelkezű benzinkút!", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("red-dark", "Fuel", 2).."/"..cmd.." [Benzinkút azonosító]", player, 255, 255, 255, true)
        end
    end
end)

addEvent("fuelStation > attachGunToPlayer", true)
addEventHandler("fuelStation > attachGunToPlayer", resourceRoot, function(obj)
    bone:attachElementToBone(obj, client, 11, -0.05, 0.05, 0.07, 30, 170, 0)
end)

addEvent("fuelStation > attachGunToFuelPump", true)
addEventHandler("fuelStation > attachGunToFuelPump", resourceRoot, function(obj)
    bone:detachElementFromBone(obj)
end)

addEvent("fuelStation > setPedAnimationOnServer", true)
addEventHandler("fuelStation > setPedAnimationOnServer", resourceRoot, function(animGroup, animName)
    setPedAnimation(client, animGroup, animName, -1, true, false, false)		
end)