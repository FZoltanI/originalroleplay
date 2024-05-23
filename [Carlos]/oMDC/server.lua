local mysql = exports.oMysql:getDBConnection()

local serverMDCDatas = {
    ["users"] = {},
    ["wanted_persons"] = {},
    ["wanted_cars"] = {},
    ["penalties"] = {
        {},
        {},
    },
}

function sendMDCChatMessage(message)
    for k, player in ipairs(getElementsByType("player")) do 
        local factions = dashboard:getPlayerAllFactions(player)

        local benneVan = false
        if #factions > 0 then 
            for k2, v2 in ipairs(factions) do 
                local factiontype = dashboard:getFactionType(v2)

                if factiontype == 1 then 
                    benneVan = true
                end
            end
        end

        if benneVan then 
            outputChatBox(core:getServerPrefix("blue-light-2", "MDC", 2)..message, player, 255, 255, 255, true)
        end
    end
end

addEventHandler("onResourceStart", resourceRoot, function()
    for k, v in ipairs(getElementsByType("vehicle")) do 
        setElementData(v, "mdc:vehicleLoginDatas", false)
        setElementData(v, "mdc:mdcInUse", false)
        setElementData(v, "mdc:unitNumber", "")
        setElementData(v, "mdc:unitState", {"Nincs szolgálatban", 66, 66, 66, "#424242"})
    end

    setTimer(function()
        loadMDCDatasFromSQL()
    end, 500, 1)    
end)

function loadMDCDatasFromSQL()
    query = dbQuery(mysql, 'SELECT * FROM mdcAccounts')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            table.insert(serverMDCDatas["users"], {v["id"], v["user"], v["pass"], v["faction"], v["type"]})
        end
    end

    query = dbQuery(mysql, 'SELECT * FROM mdcWantedPersons')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            table.insert(serverMDCDatas["wanted_persons"], {v["name"], v["reason"], v["date"], v["lastUpdateUser"], v["skin"], numberToBoolean(v["isMostDanger"]), v["id"]})
        end
    end

    query = dbQuery(mysql, 'SELECT * FROM mdcWantedCars')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            table.insert(serverMDCDatas["wanted_cars"], {v["numberPlate"], v["modelName"], v["reason"], v["color"], v["date"], v["lastUpdateUser"], v["id"]})
        end
    end

    query = dbQuery(mysql, 'SELECT * FROM mdcPenalties')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            table.insert(serverMDCDatas["penalties"][v["faction"]], {v["title"], v["description"], v["price"], v["id"]})
        end
    end
    syncMDCDatas()
end

function syncMDCDatas()
    triggerClientEvent(root, "mdc > syncMDCDatasWithServer", root, serverMDCDatas)
end
addEvent("mdc > getMDCDatasFromServer", true)
addEventHandler("mdc > getMDCDatasFromServer", resourceRoot, syncMDCDatas)

function addDataToMDC(tableID, tableData, penaltiesFaction)
    if tableID == "wanted_persons" then 
        tableData[7] = 0

        local insertResult, _, insertID = dbPoll(dbQuery(mysql, "INSERT INTO mdcWantedPersons SET name=?, reason=?, date=?, lastUpdateUser=?, skin=?, isMostDanger=?", tableData[1], tableData[2], tableData[3], tableData[4], tableData[5], tableData[6]), 200)
        
        if tonumber(insertID) then 
            tableData[7] = insertID
        end

        if tableData[6] then 
            sendMDCChatMessage("Körözés kiadva a(z) "..color..tableData[1].."#ffffff nevű személyre. #ed2f2f[A személy fokozottan veszélyes!]")
        else
            sendMDCChatMessage("Körözés kiadva a(z) "..color..tableData[1].."#ffffff nevű személyre.")
        end

        dbExec(mysql, "INSERT INTO mdclogs SET reason=?, other=?, owner=?", "Körözés kiadva", tableData[2], tableData[1])
    elseif tableID == "wanted_cars" then 
        tableData[7] = 0

        local insertResult, _, insertID = dbPoll(dbQuery(mysql, "INSERT INTO mdcWantedCars SET numberPlate=?, modelName=?, reason=?, color=?, date=?, lastUpdateUser=?", tableData[1], tableData[2], tableData[3], tableData[4], tableData[5], tableData[6]), 200)
        
        if tonumber(insertID) then 
            tableData[7] = insertID
        end

        sendMDCChatMessage("Körözés kiadva a(z) "..color..tableData[1].."#ffffff rendszámú gépjárműre. Jármű típusa: "..color..tableData[2].."#ffffff, Jármű színe: "..color..tableData[4].."#ffffff.")

        dbExec(mysql, "INSERT INTO mdclogs SET reason=?, other=?, owner=?", "Körözés kiadva", tableData[3], tableData[1])
    elseif tableID == "penalties" then 
        tableData[4] = 0

        local insertResult, _, insertID = dbPoll(dbQuery(mysql, "INSERT INTO mdcPenalties SET title=?, description=?, price=?, faction=?", tableData[1], tableData[2], tableData[3], penaltiesFaction), 200)
        
        if tonumber(insertID) then 
            tableData[4] = insertID
        end
    elseif tableID == "users" then 
        tableData[4] = 0

        local insertResult, _, insertID = dbPoll(dbQuery(mysql, "INSERT INTO mdcAccounts SET user=?, pass=?, faction=?, type=?", tableData[1], tableData[2], tableData[3], 1), 200)
        
        if tonumber(insertID) then 
            tableData[4] = insertID
        end
    end

    if tableID == "penalties" then 
        table.insert(serverMDCDatas[tableID][penaltiesFaction], tableData)
    elseif tableID == "users" then 
        table.insert(serverMDCDatas[tableID], {tableData[4], tableData[1], tableData[2], tableData[3], 1})
    else
        table.insert(serverMDCDatas[tableID], tableData)
    end

    syncMDCDatas()
end
addEvent("mdc > addDataToMDC", true)
addEventHandler("mdc > addDataToMDC", resourceRoot, addDataToMDC)

function modifyDataInMDC(tableID, tableRow, tableData)
    if tableID == "wanted_persons" then 
        dbExec(mysql, "UPDATE mdcWantedPersons SET name=?, reason=?, date=?, lastUpdateUser=?, skin=?, isMostDanger=? WHERE id=?", unpack(tableData))
    elseif tableID == "wanted_cars" then 
        dbExec(mysql, "UPDATE mdcWantedCars SET numberPlate=?, modelName=?, reason=?, color=?, date=?, lastUpdateUser=? WHERE id=?", unpack(tableData))
    end

    for k, v in ipairs(serverMDCDatas[tableID]) do 
        if tableID == "wanted_persons" or tableID == "wanted_cars" then 
            if v[7] == tableRow then 
                serverMDCDatas[tableID][k] = tableData
                break
            end
        end
    end

    syncMDCDatas()
end
addEvent("mdc > modifyDataInMDC", true)
addEventHandler("mdc > modifyDataInMDC", resourceRoot, modifyDataInMDC)

function deleteDataFromMDC(tableID, tableRow, penaltiesFaction)
    
    if tableID == "wanted_persons" then 
        dbExec(mysql, "DELETE FROM mdcWantedPersons WHERE id=?", tableRow)
    elseif tableID == "wanted_cars" then 
        dbExec(mysql, "DELETE FROM mdcWantedCars WHERE id=?", tableRow)
    elseif tableID == "penalties" then 
        dbExec(mysql, "DELETE FROM mdcPenalties WHERE id=?", tableRow)
    elseif tableID == "users" then 
        dbExec(mysql, "DELETE FROM mdcAccounts WHERE id=?", tableRow)
    end

    if tableID == "penalties" then
        for k, v in ipairs(serverMDCDatas[tableID][penaltiesFaction]) do 
            if v[4] == tableRow then 
                table.remove(serverMDCDatas[tableID][penaltiesFaction], k)
                
                break
            end
        end
    else
        for k, v in ipairs(serverMDCDatas[tableID]) do 
            if tableID == "wanted_persons" or tableID == "wanted_cars" then 
                if v[7] == tableRow then 
                    if tableID == "wanted_persons" then 
                        sendMDCChatMessage("A(z) "..color..v[1].."#ffffff nevű személy körözése visszavonásra került.")
                    elseif tableID == "wanted_cars" then 
                        sendMDCChatMessage("A(z) "..color..v[1].."#ffffff rendszámú jármű körözése visszavonásra került.")
                    end

                    dbExec(mysql, "INSERT INTO mdclogs SET reason=?, other=?, owner=?", "Körözés visszavonva", "", v[1])

                    table.remove(serverMDCDatas[tableID], k)

                    
                    break
                end
            elseif tableID == "users" then 
                if v[1] == tableRow then
                    table.remove(serverMDCDatas[tableID], k)
                    
                    break
                end
            end
        end
    end

    syncMDCDatas()
end
addEvent("mdc > deleteDataFromMDC", true)
addEventHandler("mdc > deleteDataFromMDC", resourceRoot, deleteDataFromMDC)

-- Admin commands
function sendMessageToAdmins(player, msg)
	triggerClientEvent("sendMessageToAdmins", getRootElement(), player, msg, 8)
end

addCommandHandler("addmdcuser", function(player, cmd, username, pass, type, faction)
    if getElementData(player, "user:admin") >= 7 then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if username and pass then 
            if tonumber(type) > 0 and tonumber(type) < 4 then 
                if faction == "pd" or faction == "sd" or faction == "orp" then 
                    type = tonumber(type)
                    local insertResult, _, insertID = dbPoll(dbQuery(mysql, "INSERT INTO mdcAccounts SET user=?, pass=?, faction=?, type=?", username, pass, faction, type), 200)

                    if insertID then 
                        table.insert(serverMDCDatas["users"], {insertID, username, pass, faction, tonumber(type)})
                        syncMDCDatas()

                        outputChatBox(core:getServerPrefix("server", "MDC", 3).."Sikeresen létrehoztál egy mdc felhasználói fiókot!", player, 255, 255, 255, true)
                    
                        sendMessageToAdmins(player, "létrehozott egy #db3535"..username.."#557ec9 nevű MDC felhasználói fiókot. (".."#db3535#"..insertID.."#557ec9) Jogosultság típusa: #db3535"..accessTypes[type])
                    end
                else
                    outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Felhasználónév] [Jelszó] [Típus: (1: Járőr), (2: Admin), (3: SystemAdmin)] [Frakció: (pd, sd, orp)]", player, 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Felhasználónév] [Jelszó] [Típus: (1: Járőr), (2: Admin), (3: SystemAdmin)] [Frakció: (pd, sd, orp)]", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Felhasználónév] [Jelszó] [Típus: (1: Járőr), (2: Admin), (3: SystemAdmin)] [Frakció: (pd, sd, orp)]", player, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("delmdcuser", function(player, cmd, id)
    if getElementData(player, "user:admin") >= 7 then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if tonumber(id) then 
            id = tonumber(id)

            local talalat = false
            for k, v in ipairs(serverMDCDatas["users"]) do 
                if v[1] == id then 
                    table.remove(serverMDCDatas["users"], k)
                    syncMDCDatas()
                    talalat = true
                    break 
                end
            end

            if talalat then 
                dbExec(mysql, "DELETE FROM mdcAccounts WHERE id=?", id)
                outputChatBox(core:getServerPrefix("server", "MDC", 3).."Sikeresen töröltél egy mdc felhasználói fiókot!", player, 255, 255, 255, true)
                sendMessageToAdmins(player, "törölt a(z) #db3535"..id.."#557ec9-vel rendelkező MDC felhasználói fiókot.")
            else
                outputChatBox(core:getServerPrefix("red-dark", "MDC", 3).."Nincs ilyen ID-vel rendelkező MDC fiók.", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [ID]", player, 255, 255, 255, true)
        end
    end
end)

addEvent("mdc > getData", true)
addEventHandler("mdc > getData", resourceRoot, function(type, name)
    --outputChatBox("MDC: "..type..": "..name)

    if type == "veh" then 
        query = dbQuery(mysql, 'SELECT * FROM vehicles WHERE plateText = "'..name..'"')
        result = dbPoll(query, 70)
    else
        query = dbQuery(mysql, 'SELECT * FROM characters WHERE charname = "'..name:gsub(" ", "_")..'"')
        result = dbPoll(query, 70)
    end


    query2 = dbQuery(mysql, 'SELECT * FROM mdclogs WHERE owner = "'..name..'" ORDER BY time DESC')
    result2 = dbPoll(query2, 70)

    if result and result2 then 
        triggerClientEvent(client, "mdc > sendData", resourceRoot, result, result2)
    end
end)

for k, v in ipairs(policePCs) do 
    local pc = createObject(16224, v[1], v[2], v[3], 0, 0, v[4])
    setElementData(pc, "policePC", true)
    setElementData(pc, "policePC:inUse", false)

    setElementDimension(pc, v[5])
    setElementInterior(pc, v[6])
end

function getCarIsWanted(template)
   for k, v in pairs(serverMDCDatas["wanted_cars"]) do 
        if string.lower(v[1]) == string.lower(template) then 
            return true 
        else
            return false
        end
    end
end

function getCarWantedReason(template)
    for k, v in pairs(serverMDCDatas["wanted_cars"]) do 
        if string.lower(v[1]) == string.lower(template) then 
            return v[3]
        else
            return false
        end
    end
end
