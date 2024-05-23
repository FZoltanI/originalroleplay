conn = mysql:getDBConnection()
server_faction_list = {}
server_factionMembers_list = {}

server_dutyMarkers = {}

function outputFactionLogToAdmins(msg)
    for k, v in ipairs(getElementsByType("player")) do 
        local alevel = getElementData(v, "user:admin") or 0
        if alevel >= 4 then 
            outputChatBox(factionLogPrefix..msg, v, 255, 255, 255, true)
        end
    end
end

function outputChatBoxToFactionMembers(factionID, msg)
    for k, v in ipairs(getElementsByType("player")) do 
        if ( isPlayerInFaction(v, factionID) ) then 
            outputChatBox(core:getServerPrefix("blue-light-2", getFactionName(factionID), 3)..msg, v, 255, 255, 255, true)
        end
    end
end

addEventHandler("onResourceStart", resourceRoot, function()
    loadFactions()
    setTimer(saveFactions, core:minToMilisec(60), 0)

    setTimer(function() 
        triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
        triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
    end, 100, 1)
end)

addEventHandler("onElementDataChange", root, function(key, old, new)
    if key == "user:loggedin" then 
        if new then 
            triggerClientEvent(source, "getFactionMembersFromServer > Return", source, server_factionMembers_list)
            triggerClientEvent(source, "getFactionsFromServer > Return", source, server_faction_list)

            local player = source
            setTimer(function() 
                local factions = getPlayerAllFactions(player)

                for k, v in ipairs(factions) do 
                    for k2, v2 in pairs(server_factionMembers_list[v]) do 
                        if v2[1] == getElementData(player, "char:id") then 
                            server_factionMembers_list[v][k2][7] = string.format("%04d.%02d.%02d %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute"))
                            break
                        end
                    end

                    triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
                end
            end, 100, 1)
        end
    end
end)

addEventHandler("onResourceStop", resourceRoot, function() 
    saveFactions()
    for k, v in ipairs(getElementsByType("player")) do 
        setElementData(v, "char:factions", {})
    end
end)

function saveRequest()
    saveFactions()
    for k, v in ipairs(getElementsByType("player")) do 
        setElementData(v, "char:factions", {})
    end
	outputDebugString("[oServerStop]: oDashboard(factions) sikeres mentés.",3);
end 

addEvent("faction_admin > createFaction", true)
addEventHandler("faction_admin > createFaction", resourceRoot, function(player, factionDatas)
    -- id, név, tipus, engedélyezett dutyskinek, engedélyezett dutyitemek, járművek, ranks, dutys, számla összege, create date, dutyPos, description
    local createDate = ""

    local time = getRealTime()

    createDate = tostring(time.year+1900 .. ". "..(time.month+1)..". "..time.monthday.." "..time.hour..":"..time.second)

    --print(factionDatas["type"])
    local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO factions SET name=?, type=?, money=?, ranks=?, members=?, allowedDutyItems=?, allowedDutySkins=?, dutys=?, editDate=?", factionDatas["name"], factionDatas["type"], 0, toJSON({{"Alapértelmezett rang", 0, 1}}), toJSON({}), toJSON(factionDatas["allowedItems"]), toJSON(factionDatas["allowedSkins"]), toJSON({"Alapértelmezett duty", {}, {}}), createDate), 100)
    table.insert(server_faction_list, insertID, {insertID, factionDatas["name"], factionDatas["type"], factionDatas["allowedSkins"], factionDatas["allowedItems"], {}, {{"Alapértelmezett rang", 0, 1}}, {{"Alapértelmezett duty", {}, {}}}, 0, createDate, {}, "Alapertelmezett leiras"})
    table.insert(server_factionMembers_list, insertID, {})

    triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "létrehozta a(z) #db3535" ..factionDatas["name"].." #557ec9frakciót, típusa: #db3535"..faction_types[factionDatas["type"]].."#557ec9. #db3535[DBID: "..insertID.."]")

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list) 
    triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
end)

addEvent("faction > getServerFactionList", true)
addEventHandler("faction > getServerFactionList", resourceRoot, function() 
    --outputChatBox("faction > getServerFactionList <- SERVER")

    triggerClientEvent(client, "getFactionsFromServer > Return", client, server_faction_list)
end)

addEvent("faction > getServerFactionMembersList", true)
addEventHandler("faction > getServerFactionMembersList", resourceRoot, function() 
    --outputChatBox("faction > getServerFactionMembersList <- SERVER")

    triggerClientEvent(client, "getFactionMembersFromServer > Return", client, server_factionMembers_list)
end)

addEvent("faction_admin > delFaction", true)
addEventHandler("faction_admin > delFaction", resourceRoot, function(factionID)
    factionID = tonumber(factionID)
    if getFactionPlayersCount(factionID) == 0 then 
        triggerClientEvent("sendMessageToAdmins", getRootElement(), client, "kitörölte a(z) #db3535"..getFactionName(factionID).." #557ec9nevű frakciót.")
        local temp = server_faction_list

        deleteDutyMarker(factionID)

        server_faction_list[factionID] = false
        server_factionMembers_list[factionID] = false

        triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
        triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
    else
        outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Ebben a frakcióban vannak játékosok!", client, 255, 255, 255, true)
    end
end)

function loadFactions()
    query = dbQuery(conn, 'SELECT * FROM factions')
    result = dbPoll(query, 250)

    for k, v in ipairs(result) do 
        local factionID = v["id"]
        local factionName = v["name"]
        local factionType = v["type"]
        local factionMoney = v["money"]

        local ranks = fromJSON(v["ranks"])
        local vehicles = ""
        local dutys = fromJSON(v["dutys"])

        local allowedDutyItems = fromJSON(v["allowedDutyItems"])
        local allowedDutySkins = fromJSON(v["allowedDutySkins"])

        local factionEditDate = v["editDate"]

        local members = v["members"]

        local dutyPos = fromJSON(v["dutyPos"]) or {}

        local desc = v["description"]

        table.insert(server_faction_list, factionID, {factionID, factionName, factionType, allowedDutySkins, allowedDutyItems, vehicles, ranks, dutys, factionMoney, factionEditDate, dutyPos, desc})
        table.insert(server_factionMembers_list, factionID, fromJSON(members))
        --iprint(server_factionMembers_list)
        if (#dutyPos or 0) > 0 then 
            createDutyMarker(factionID)
        end
    end
end

function saveFactions() 
    local savedFactions = {0, 0}
    for k, v in pairs(server_faction_list) do
        if v then 
            --print(toJSON(server_factionMembers_list[v[1]]))
            local exec = dbExec(conn, "UPDATE factions SET name=?, type=?, money=?, ranks=?, editDate=?, members=?, dutys=?, dutyPos = ?, allowedDutyItems = ?, allowedDutySkins = ?, description = ? WHERE id=?", v[2], v[3], v[9], toJSON(v[7]), v[9], toJSON(server_factionMembers_list[v[1]]), toJSON(v[8]), toJSON(v[11]), toJSON(v[5]), toJSON(v[4]), v[12], v[1])
        
            if exec then 
                savedFactions[1] = savedFactions[1] + 1
                --outputDebugString("[Faction]: Frakció elmentve: "..v[2])
            else
                savedFactions[2] = savedFactions[2] + 1
               -- outputDebugString("[Faction]: Frakció elmentve: "..v[2], 1)
            end
        else
            local exec = dbExec(conn, "DELETE FROM factions WHERE id=?", k)
        end
    end

    outputDebugString("[Faction]: "..savedFactions[1].."db frakció sikeresen elmentve! ("..savedFactions[2].."db sikertelen mentés)")
end

function isRealFaction(id)
    if server_faction_list[id] then 
        return true
    else
        return false
    end
end

function getFactionName(id)
    if isRealFaction(id) then 
        return server_faction_list[id][2]
    end
end

function getFactionType(id)
    if isRealFaction(id) then 
        return server_faction_list[id][3]
    end
end

function getPlayerAllFactions(player) 
    local playerFactions = {}

    for keyFaction, factions in pairs(server_factionMembers_list) do 
        for key, member in pairs(factions) do 

            if member[1] == getElementData(player, "char:id") then 
                table.insert(playerFactions, #playerFactions+1, keyFaction)
                break
            end

        end
    end

    return playerFactions
end

function isPlayerInFaction(player, id)
    if isRealFaction(id) then 
        local player_factions = getPlayerAllFactions(player)
        if #player_factions > 0 then 
            local volt = false 
            local talalat_szam = 0

            for k, v in pairs(player_factions) do 
                if v == id then
                    volt = true 
                    talalat_szam = k 
                    break
                end
            end

            return volt, talalat_szam
        else
            return false
        end
    end
end

function isPlayerFactionTypeMember(player, factionTypes)
    local playerFactions = getPlayerAllFactions(player)

    local member = false 
    for k, v in ipairs(playerFactions) do 
        if core:tableContains(factionTypes, getFactionType(v)) then 
            member = true 
            break 
        end
    end

    return member
end


function findPlayerFromCharID(id)
    local player = false 

    for k, v in ipairs(getElementsByType("player")) do 
        if getElementData(v, "char:id") == id then 
            player = v 
            break
        end
    end

    return player
end

function ifPlayerLeaderOfTheFaction(factionID, playerID)
    for k, v in pairs(server_factionMembers_list[factionID]) do 
        if v[1] == playerID then 
            return v[3]
        end
    end
end


function getFactionPlayersCount(factionID)
    return #server_factionMembers_list[factionID]
end

function getPlayerRankInFaction(factionID, player)
    if isPlayerInFaction(player, factionID) then 
        for k, v in pairs(server_factionMembers_list[factionID]) do 
            if v[1] == getElementData(player, "char:id") then 
                return v[2]
            end
        end
    end
end

function getPlayerPaymentInFaction(factionID, player)
    if isPlayerInFaction(player, factionID) then 
        local rankID = getPlayerRankInFaction(factionID, player)

        return server_faction_list[factionID][7][rankID][2] 
    end
end

function getRankName(factionID, rankID)
    return server_faction_list[factionID][7][rankID][1]
end

function checkDutyElements(factionID)
    local allowedDutySkins = server_faction_list[factionID][4]
    local allowedDutyItems = server_faction_list[factionID][5]

    for k, v in pairs(server_faction_list[factionID][8]) do 
        for keyItem, valueItem in pairs(v[2]) do 
            if not (tableContains(allowedDutyItems, tostring(valueItem[1]))) then 
                table.remove(server_faction_list[factionID][8][k][2], keyItem)
            end
        end

        for keySkin, valueSkin in pairs(v[3]) do 
            if not (tableContains(allowedDutySkins, tostring(valueSkin))) then 
                table.remove(server_faction_list[factionID][8][k][3], keySkin)
            end
        end
    end

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end

function setFactionBankMoney(factionID, money, state)
    if state == "add" then 
        server_faction_list[factionID][9] = server_faction_list[factionID][9] + money
    elseif state == "remove" then 
        server_faction_list[factionID][9] = server_faction_list[factionID][9] - money
    end

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)

    --print(factionID, money, state)
end


function getFactionBankMoney(factionID)
    return server_faction_list[factionID][9]
end

-- / Admin panel / --
addEvent("faction > admin > modifyFactionDatas", true)
addEventHandler("faction > admin > modifyFactionDatas", resourceRoot, function(factionID, factionName, factionDutyPos, allowedDutySkins, allowedDutyItems)
    if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(client) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

    local oldDutyPos = server_faction_list[factionID][11]
    server_faction_list[factionID][2] = factionName
    server_faction_list[factionID][4] = allowedDutySkins
    if server_faction_list[factionID][3] <= 3 then 

        server_faction_list[factionID][11] = factionDutyPos
        
        server_faction_list[factionID][5] = allowedDutyItems

        if not (oldDutyPos == factionDutyPos) then 
            if #oldDutyPos == 0 then 
                createDutyMarker(factionID)
            else
                updateDutyMarker(factionID)
            end
        end

        checkDutyElements(factionID)
    end

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
    triggerClientEvent("sendMessageToAdmins", getRootElement(), client, "módosította a(z) #db3535" ..factionName.." #557ec9nevű frakciót, típusa: #db3535"..faction_types[server_faction_list[factionID][3]].."#557ec9. #db3535[DBID: "..server_faction_list[factionID][1].."]")
end)

-- / Leader / --
addEvent("faction > leader > fire", true)
addEventHandler("faction > leader > fire", resourceRoot, function(factionID, charID)
    for k, v in pairs(server_factionMembers_list[factionID]) do 
        if v[1] == charID then 
            outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." kirúgta "..factionLogNameColor..tostring(v[4]):gsub("_", " ")..factionLogMessageColor.." nevű játékost a "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióból.")
            table.remove(server_factionMembers_list[factionID], k)

            local player = findPlayerFromCharID(charID) 
            if player then
                outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Ki lettél rúgva a(z) "..color..getFactionName(factionID).." #fffffffrakcióból. Általa: "..color..getPlayerName(client):gsub("_", " "), player, 255, 255, 255, true)
            end

            triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
        end
    end
end)

addEvent("faction > leader > setleader", true)
addEventHandler("faction > leader > setleader", resourceRoot, function(factionID, charID, state)
    for k, v in pairs(server_factionMembers_list[factionID]) do 
        if v[1] == charID then 
            if state then 
                outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." leader jogosultságot adott "..factionLogNameColor..v[4]:gsub("_", " ")..factionLogMessageColor.." nevű játékosnak a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióban.")
            else 
                outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." elvette a leader jogosultságát "..factionLogNameColor..v[4]:gsub("_", " ")..factionLogMessageColor.." nevű játékosnak a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióban.")
            end 

            v[3] = state 
            
            local player = findPlayerFromCharID(charID) 
            if player then
                if state then 
                    outputChatBox(core:getServerPrefix("server", "Frakció", 3).."Leader jogosultságot kaptál a(z) "..color..getFactionName(factionID).." #fffffffrakcióban. Általa: "..color..getPlayerName(client):gsub("_", " "), player, 255, 255, 255, true)
                else
                    outputChatBox(core:getServerPrefix("server", "Frakció", 3).."Elvették a leader jogosultságodat a(z) "..color..getFactionName(factionID).." #fffffffrakcióban. Általa: "..color..getPlayerName(client):gsub("_", " "), player, 255, 255, 255, true)
                end
            end

            triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
        end
    end
end)

addEvent("faction > leader > setPlayerRank", true)
addEventHandler("faction > leader > setPlayerRank", resourceRoot, function(factionID, charID, newRank)
    for k, v in pairs(server_factionMembers_list[factionID]) do 
        if v[1] == charID then 

            local oldRank = v[2]
            v[2] = newRank

            local player = findPlayerFromCharID(charID) 
            if player then
                if newRank > oldRank then 
                    outputChatBox(core:getServerPrefix("server", "Frakció", 3).."Előléptettek a(z) "..color..getFactionName(factionID).." #ffffffnevű frakcióban. Új rangod: "..color..server_faction_list[factionID][7][newRank][1]:gsub("_", " "), player, 255, 255, 255, true)
                else
                    outputChatBox(core:getServerPrefix("server", "Frakció", 3).."Lefokoztak a(z) "..color..getFactionName(factionID).." #ffffffnevű frakcióban. Új rangod: "..color..server_faction_list[factionID][7][newRank][1]:gsub("_", " "), player, 255, 255, 255, true)
                end
            end

            infobox:outputInfoBox("Sikeresen módosítottad "..v[4]:gsub("_", " ").." nevű játékos rangját!", "success", client)
            
            triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
        end
    end
end)

addEvent("faction > leader > resetPlayerDutyTime", true)
addEventHandler("faction > leader > resetPlayerDutyTime", resourceRoot, function(factionID, charID)
    for k, v in pairs(server_factionMembers_list[factionID]) do 
        if v[1] == charID then 

            v[9] = 0

            local player = findPlayerFromCharID(charID) 
            if player then
                outputChatBox(core:getServerPrefix("server", "Frakció", 3).."Nullázták a szolgálati idődet a(z) "..color..getFactionName(factionID).." #ffffffnevű frakcióban.", player, 255, 255, 255, true)
            end

            infobox:outputInfoBox("Sikeresen nulláztad "..v[4]:gsub("_", " ").." nevű játékos szolgálati idejét!", "success", client)
            
        end
    end
    triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
end)

addEvent("faction > leader > giveBadgeToPlayer", true)
addEventHandler("faction > leader > giveBadgeToPlayer", resourceRoot, function(factionID, charID, rank)
    for k, v in pairs(server_factionMembers_list[factionID]) do 
        if v[1] == charID then 
            local player = findPlayerFromCharID(charID) 
            if player then
                local badgeText = server_faction_list[factionID][7][rank][1].." #"..math.random(1, 9999)

                outputChatBox(core:getServerPrefix("server", "Frakció", 3).."Kaptál egy jelvényt! "..color.."("..badgeText..")", player, 255, 255, 255, true)
                inventory:giveItem(player, 69, badgeText, 1, 0) 

                infobox:outputInfoBox("Sikeresen adtál "..v[4]:gsub("_", " ").." nevű játékosnak egy jelvényt! ("..badgeText..")", "success", client)

                outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." jelvényt adott "..factionLogNameColor..v[4]:gsub("_", " ")..factionLogMessageColor.." nevű játékosnak a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióban. "..factionLogNameColor.."("..badgeText..")")
            end
        end
    end
end)

addEvent("faction > leader > addmember", true)
addEventHandler("faction > leader > addmember", resourceRoot, function(factionID, playerID)
    local target = core:getPlayerFromPartialName(client, playerID)

    if target then 
        if not isPlayerInFaction(target, factionID) then 
            if getFactionType(factionID) == 4 or getFactionType(factionID) == 5 then 
                if getElementData(target,"hasContainer") then return infobox:outputInfoBox("A kiválasztott játékos konténerrel rendelkezik, ezt előtte fel kell mondania!") end
            end 

            table.insert(server_factionMembers_list[factionID], #server_factionMembers_list[factionID]+1, {getElementData(target, "char:id"), 1, false, getElementData(target, "char:name"), "false", "Nincs adat", string.format("%04d.%02d.%02d %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute")), "Nincs adat", 0})
            outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." felvette "..factionLogNameColor..getPlayerName(target):gsub("_", " ")..factionLogMessageColor.." nevű játékost a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióban.")

            outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen felvetted a frakcióba "..color..getPlayerName(target):gsub("_", " ").."#ffffff nevű játékost.", client, 255, 255, 255, true)
            outputChatBox(core:getServerPrefix("green-dark", "Frakció", 1).."Felvettek a(z) "..color..getFactionName(factionID).."#ffffff nevű frakcióba.", target, 255, 255, 255, true)
            infobox:outputInfoBox("Sikeresen felvetted a frakcióba "..getPlayerName(target):gsub("_", " ").." nevű játékost.", "success", client)

            triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
        else
            outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Ez a játékos már a frakció tagja.", client, 255, 255, 255, true)
            infobox:outputInfoBox("Ez a játékos már tagja a frakciónak!", "error", client)
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Nincs ilyen ID-vel rendlekező játékos.", client, 255, 255, 255, true)
        infobox:outputInfoBox("Nincs ilyen ID-vel rendlekező játékos!", "error", client)
    end
end)

addEvent("faction > leader > createRank", true)
addEventHandler("faction > leader > createRank", resourceRoot, function(factionID, rankName)
    table.insert(server_faction_list[factionID][7], #server_faction_list[factionID][7] + 1, {rankName, 0, 0})

    outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." létrehozott egy új rangot a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióban. "..factionLogNameColor.."("..rankName..")")
    outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen létrehoztál egy új rangot."..color.." ("..rankName..")", client, 255, 255, 255, true)

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end)

addEvent("faction > leader > delRank", true)
addEventHandler("faction > leader > delRank", resourceRoot, function(factionID, rankID)
    outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." törölt egy rangot a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióban. "..factionLogNameColor.."("..server_faction_list[factionID][7][rankID][1]..")")
    outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen töröltél rangot."..color.." ("..server_faction_list[factionID][7][rankID][1]..")", client, 255, 255, 255, true)

    table.remove(server_faction_list[factionID][7], rankID)

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end)

addEvent("faction > leader > editRank", true)
addEventHandler("faction > leader > editRank", resourceRoot, function(factionID, rankID, rankName, rankPayment, attachedDuty)
    server_faction_list[factionID][7][rankID][1] = rankName
    server_faction_list[factionID][7][rankID][2] = rankPayment
    server_faction_list[factionID][7][rankID][3] = attachedDuty

    infobox:outputInfoBox("Sikeresen módosítottál egy rangot!", "success", client)

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end)

addEvent("faction > leader > createDuty", true)
addEventHandler("faction > leader > createDuty", resourceRoot, function(factionID, dutyName)
    table.insert(server_faction_list[factionID][8], #server_faction_list[factionID][8] + 1, {dutyName, {}, {}})

    outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." létrehozott egy új dutyt a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióban. "..factionLogNameColor.."("..dutyName..")")
    outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen létrehoztál egy új rangot."..color.." ("..dutyName..")", client, 255, 255, 255, true)
    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end)

addEvent("faction > leader > editDuty", true)
addEventHandler("faction > leader > editDuty", resourceRoot, function(factionID, dutyID, dutyName, dutySkins, dutyItems)
    server_faction_list[factionID][8][dutyID][1] = dutyName
    server_faction_list[factionID][8][dutyID][2] = dutyItems
    server_faction_list[factionID][8][dutyID][3] = dutySkins

    infobox:outputInfoBox("Sikeresen módosítottál egy dutyt!", "success", client)

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end)

addEvent("faction > leader > delDuty", true)
addEventHandler("faction > leader > delDuty", resourceRoot, function(factionID, dutyID)
    outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." törölt egy dutyt a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakcióban. "..factionLogNameColor.."("..server_faction_list[factionID][8][dutyID][1]..")")
    outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen töröltél rangot."..color.." ("..server_faction_list[factionID][8][dutyID][1]..")", client, 255, 255, 255, true)

    table.remove(server_faction_list[factionID][8], dutyID)

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end)

addEvent("faction > leader > editFactionDesc", true)
addEventHandler("faction > leader > editFactionDesc", resourceRoot, function(factionID, newDesc)
    outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." módosította a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakció leírását. Új leírás: "..factionLogNameColor..newDesc)
    outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeresen megváltoztattad a frakció leírását.", client, 255, 255, 255, true)

    server_faction_list[factionID][12] = newDesc

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end)

addEvent("faction > leader > addskins", true)
addEventHandler("faction > leader > addskins", getRootElement(), function(factionId, skins)
    table.insert(server_faction_list[factionId][4], #server_faction_list[factionId][4]+1, skins)
    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
    infobox:outputInfoBox("Sikeresen hozzáadtad a ".. skins.."-s id-vel rendelkező skint!", "success", client)
end)

addEvent("faction > leader > removeSkins", true)
addEventHandler("faction > leader > removeSkins", getRootElement(), function(factionId, tableId, skins)
    table.remove(server_faction_list[factionId][4], tableId)
    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
    infobox:outputInfoBox("Sikeresen törölted a ".. skins.."-s id-vel rendelkező skint!", "success", client)
end)

addEvent("faction > leader > bankTransaction", true)
addEventHandler("faction > leader > bankTransaction", resourceRoot, function(factionID, money, state)
    if state == 1 then 
        if (server_faction_list[factionID][9] - money) >= 0 then 
            outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." levett pénzt a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakció számlájáról. Összeg: "..factionLogNameColor..money.."$"..factionLogMessageColor.." Frakció számla egyenlege: "..factionLogNameColor..(server_faction_list[factionID][9] - money).."$")
            outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeres tranzakció.", client, 255, 255, 255, true)
            server_faction_list[factionID][9] = server_faction_list[factionID][9] - money

            setElementData(client, "char:money", getElementData(client, "char:money") + money)

            infobox:outputInfoBox("Sikeres tranzakció!", "success", client)
        else
            infobox:outputInfoBox("Nincs ennyi pénze a frakciónak!", "error", client)
            outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Nincs ennyi pénze a frakciónak! ("..color..money.."$#ffffff)", client, 255, 255, 255, true)
        end
    elseif state == 2 then 
        if money <= getElementData(client, "char:money") then 
            outputFactionLogToAdmins(factionLogNameColor..getPlayerName(client):gsub("_", " ")..factionLogMessageColor.." pénzt tett be a(z) "..factionLogNameColor..getFactionName(factionID)..factionLogMessageColor.." nevű frakció számlájára. Összeg: "..factionLogNameColor..money.."$"..factionLogMessageColor.." Frakció számla egyenlege: "..factionLogNameColor..(server_faction_list[factionID][9] + money).."$")
            outputChatBox(core:getServerPrefix("green-dark", "Frakció", 3).."Sikeres tranzakció.", client, 255, 255, 255, true)
            server_faction_list[factionID][9] = server_faction_list[factionID][9] + money

            setElementData(client, "char:money", getElementData(client, "char:money") - money)

            infobox:outputInfoBox("Sikeres tranzakció!", "success", client)
        else
            infobox:outputInfoBox("Nincs nálad ennyi pénz!", "error", client)
            outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Nincs nálad ennyi pénz! ("..color..money.."$#ffffff)", client, 255, 255, 255, true)
        end
    end

    triggerClientEvent(root, "getFactionsFromServer > Return", root, server_faction_list)
end)

-- / member / --
addEvent("faction > setMemberDutyState", true)
addEventHandler("faction > setMemberDutyState", resourceRoot, function(dutyState, dutySkin, dutyTime)
    local oldDutyState = getElementData(client, "char:duty:faction") or 0
    setElementData(client, "char:duty:faction", dutyState)

    if dutyState == 0 then 
        outputChatBoxToFactionMembers(oldDutyState, color..getPlayerName(client):gsub("_", " ").." ("..getRankName(oldDutyState, getPlayerRankInFaction(oldDutyState, client))..") #ffffffkilépett a szolgálatból.")
        inventory:takeDutyItems(client)
        setElementModel(client, getElementData(client, "char:originalSkin"))

        local charID = getElementData(client, "char:id")

        for k2, v2 in pairs(server_factionMembers_list[oldDutyState]) do 
            if v2[1] == charID then 
                --print(k2)
                server_factionMembers_list[oldDutyState][k2][9] = (server_factionMembers_list[oldDutyState][k2][9] or 0) + (dutyTime)
                setElementData(client, "faction:duty:time", 0)

                triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
            end
        end
    else
        setElementData(client, "char:originalSkin", getElementModel(client))
        outputChatBoxToFactionMembers(dutyState, color..getPlayerName(client):gsub("_", " ").." ("..getRankName(dutyState, getPlayerRankInFaction(dutyState, client))..") #ffffffszolgálatba állt.")
        local player = client
        for k, v in pairs(server_faction_list[dutyState][8][server_faction_list[dutyState][7][getPlayerRankInFaction(dutyState, client)][3]][2]) do 
            --setTimer(function() 
                inventory:giveItem(player, v[1], 100, v[2], 1) 
            --end, 1000*k, 1)
        end
        
        if dutySkin > 0 then 
            setElementModel(client, dutySkin)
        end

        local charID = getElementData(client, "char:id")

        for k2, v2 in pairs(server_factionMembers_list[dutyState]) do 
            if v2[1] == charID then 
                local date = string.format("%04d.%02d.%02d %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute"))
                server_factionMembers_list[dutyState][k2][8] = tostring(date)

                triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
            end
        end
    end
end)

addEvent("faction > setPlayerDutySkin", true)
addEventHandler("faction > setPlayerDutySkin", getRootElement(), function(player, factionId, dutySkin)
    setElementData(player, "char:originalSkin", getElementModel(player))
    setElementModel(player, dutySkin)
end)



addEventHandler("onPlayerQuit", root, function()
    saveFactions()
    local factionID = getElementData(source, "char:duty:faction") or 0

    if factionID > 0 then 
        local dutyTime = (getElementData(source, "faction:duty:time") or 0)
        local charID = getElementData(source, "char:id")

        if dutyTime > 0 then 
            for k2, v2 in pairs(server_factionMembers_list[factionID]) do 
                if v2[1] == charID then 
                    server_factionMembers_list[factionID][k2][9] = (server_factionMembers_list[factionID][k2][9] or 0) + dutyTime
                    setElementData(source, "faction:duty:time", 0)
    
                    triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
                end
            end
        end
    end
end)

addEvent("faction > updatePlayerName", true)
addEventHandler("faction > updatePlayerName", resourceRoot, function(factionID, playerID, newName)
    for k, v in ipairs(server_factionMembers_list[factionID]) do 
        for k2, v2 in ipairs(v) do 
            if v[1] == playerID then 
                v[4] = newName
                break
            end
        end
    end
    
    triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
end)

addEvent("faction > giveVehicleKeyToLeader", true)
addEventHandler("faction > giveVehicleKeyToLeader", resourceRoot, function(vehid)
    inventory:giveItem(client, 51, vehid, 1, 0)
end)

---- / Duty Marker / ----

function createDutyMarker(factionID) 

    local dutyPos = server_faction_list[factionID][11]

    local dutyMarker = cMarker:createCustomMarkerServer(dutyPos[1], dutyPos[2], dutyPos[3], 3.0, 42, 147, 245, 100, "shirt", "circle")

    table.insert(server_dutyMarkers, #server_dutyMarkers+1, dutyMarker)

    setElementDimension(dutyMarker, dutyPos[4])
    setElementInterior(dutyMarker, dutyPos[5])

    setElementData(dutyMarker, "dutyMarker:id", factionID)
end

function updateDutyMarker(factionID)
    local dutyPos = server_faction_list[factionID][11]

    local marker = getDutyMarker(factionID)

    if isElement(marker) then 
        setElementPosition(marker, dutyPos[1], dutyPos[2], dutyPos[3]-1)
        setElementDimension(marker, dutyPos[4])
        setElementInterior(marker, dutyPos[5])
    end
end

function deleteDutyMarker(factionID)
    local marker, index = getDutyMarker(factionID)

    if isElement(marker) then 
        destroyElement(marker)
        table.remove(server_dutyMarkers, index)
    end 
end

function getDutyMarker(factionID)
    local marker = false
    local index = 0
    for k, v in ipairs(server_dutyMarkers) do 
        if getElementData(v, "dutyMarker:id") == factionID then 
            marker = v 
            index = k
            break
        end
    end

    return marker, index
end

addEventHandler("onResourceStop", resourceRoot, function()
    for k, v in ipairs(server_dutyMarkers) do 
        destroyElement(v)
    end
end)

addEvent("mainFactionSettings", true)
addEventHandler("mainFactionSettings", getRootElement(), function(player, factionId, factionName)
    local charId = getElementData(player, "char:id") or 0
    local selected = getElementData(player, "char:mainFaction") or 0
    if selected == factionId then 
        exports.oInfobox:outputInfoBox("Jelenleg is ez az elsődleges frakciód.", "warning", player)
    else 
        dbQuery(function(qh)
            local result, numAff = dbPoll(qh, 0)
            if numAff > 0 then 
                setElementData(player, "char:mainFaction", factionId)
                dbExec(conn, "UPDATE characters SET mainFaction = ? WHERE id = ?", factionId, charId)
                exports.oInfobox:outputInfoBox("Sikeresen beállítottad a ".. factionName .. " frakciót elsődleges frakcióként!", "success", player)
            else
                exports.oInfobox:outputInfoBox("Hiba történt keress fel egy fejlesztőt (#770)", "error", player)
            end
        end, conn, "SELECT * FROM characters WHERE id = ?", charId)
    end
end)