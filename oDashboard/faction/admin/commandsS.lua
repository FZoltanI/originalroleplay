function addPlayerToFaction(player, command, target, factionID)
    if exports["oAdmin"]:hasPermission(player,"setplayerfaction") then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        factionID, target = tonumber(factionID) or 0, tonumber(target) or 0

        if (factionID > 0) and (target > 0) then
            if isRealFaction(factionID) then
                target = core:getPlayerFromPartialName(player, target)

                if not isPlayerInFaction(target, factionID) then 
                    if getElementData(target,"hasContainer") then return outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."A kiválasztott játékos konténerrel rendelkezik, ennek bérletét először fel kell mondania!", player, 255, 255, 255, true) end

                    local length = #server_factionMembers_list[factionID] or 0
                    ----- Karakter ID,              rang,   leader,     név                               utolsó bejelentkezés,                          jelenleg online-e, szolgálati idő
                    table.insert(server_factionMembers_list[factionID], length+1, {getElementData(target, "char:id"), 1, false, getElementData(target, "char:name"), getElementData(target, "user:lastlogin") or "false", true, string.format("%04d.%02d.%02d %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute")), "Nincs adat", 0})
--                    print(toJSON(server_factionMembers_list[factionID]))

                    outputChatBox(core:getServerPrefix("server", "Hozzáadva", 1)..color..getPlayerName(player).." #ffffffhozzáadott a(z) "..color..getFactionName(factionID).."#ffffff nevű frakcióhoz.", target, 255, 255, 255, true)
                    triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "hozzáadta a(z) #db3535"..getFactionName(factionID).." #557ec9nevű frakcióhoz #db3535"..getPlayerName(target).."#557ec9 nevű játékost.")

                    triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)

                    triggerClientEvent(target, "resetPlayerFactionDatas", target)

                    setElementData(player, "log:admincmd", {getElementData(target, "char:id"), command})
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."A játékos már tagja a frakciónak! "..color.."("..getFactionName(factionID)..")", player, 255, 255, 255, true)  
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Nem létezik ilyen frakció! "..color.."("..factionID..")", player, 255, 255, 255, true) 
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..command.." [Játékos] [Frakció ID]", player, 255, 255, 255, true) 
        end
    end 
end
addCommandHandler("addplayertofaction", addPlayerToFaction)
addCommandHandler("giveplayerfaction", addPlayerToFaction)
addCommandHandler("addtofaction", addPlayerToFaction)
addCommandHandler("setplayerfaction",addPlayerToFaction)

function getPlayerFactions(player, command, target)
    if exports["oAdmin"]:hasPermission(player,"getplayerfactions") then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        target = tonumber(target) or 0 

        if target > 0 then 
            target = core:getPlayerFromPartialName(player, target)

            local target_factions = getPlayerAllFactions(target)

            if #target_factions > 0 then 
                outputChatBox(core:getServerPrefix("server", "Frakció", 3)..getPlayerName(target):gsub("_", " ").." frakciói:", player, 255, 255, 255, true) 
                for k, v in ipairs(target_factions) do 
                    outputChatBox(color.." ~ #ffffff"..getFactionName(v)..color.." ["..faction_types[getFactionType(v)].."] ("..v..")", player, 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("red-light", "Frakció", 3).."A játékos nem tartozik egyetlen szerverzethez sem!", player, 255, 255, 255, true) 
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..command.." [Játékos]", player, 255, 255, 255, true) 
        end
    end
end
addCommandHandler("getplayerfactions", getPlayerFactions)
addCommandHandler("getfactions", getPlayerFactions)

function removePlayerFromFaction(player, command, target, factionID)
    if exports["oAdmin"]:hasPermission(player,"removeplayerfromfaction") then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        factionID, target = tonumber(factionID) or 0, tonumber(target) or 0

        if (factionID > 0) and (target > 0) then
            if isRealFaction(factionID) then
                target = core:getPlayerFromPartialName(player, target)

                if target then 
                    local isInFaction, factionListNumber = isPlayerInFaction(target, factionID)
                    if isInFaction then 

                        outputChatBox(core:getServerPrefix("server", "Hozzáadva", 1)..color..getPlayerName(player).." #ffffffeltávolított a(z) "..color..getFactionName(factionID).."#ffffff nevű frakcióból.", target, 255, 255, 255, true)
                        triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "eltávolította a(z) #db3535"..getFactionName(factionID).." #557ec9nevű frakcióból #db3535"..getPlayerName(target).."#557ec9 nevű játékost.")

                        for k, v in ipairs(server_factionMembers_list[factionID]) do 
                            if v[1] == getElementData(target, "char:id") then 
                                table.remove(server_factionMembers_list[factionID], k)
                            end
                        end

                        triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
                        triggerClientEvent(target, "resetPlayerFactionDatas", target)
                       
                        setElementData(player, "log:admincmd", {getElementData(target, "char:id"), command})
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."A játékos nem tagja ennek a frakciónak! "..color.."("..getFactionName(factionID)..")", player, 255, 255, 255, true) 
                    end
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Nem létezik ilyen frakció! "..color.."("..factionID..")", player, 255, 255, 255, true) 
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..command.." [Játékos] [Frakció ID]", player, 255, 255, 255, true) 
        end
    end
end 
addCommandHandler("removeplayerfromfaction", removePlayerFromFaction)
addCommandHandler("removefromfaction", removePlayerFromFaction)

function removePlayerFromAllFaction(player, command, target)
    if exports["oAdmin"]:hasPermission(player,"removeplayerfromallfaction") then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        target = tonumber(target) or 0

        if (target > 0) then
            target = core:getPlayerFromPartialName(player, target)
            local factions, factionId, key = getPlayerAllFactions(target)
            for k, v in pairs(factions) do 
                for a, b in pairs(server_factionMembers_list[v]) do 
                    if b[1] == getElementData(target, "char:id") then 
                        table.remove(server_factionMembers_list[v], a)
                    end
                end
            end
          --  iprint(server_factionMembers_list)
            triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
            triggerClientEvent(target, "resetPlayerFactionDatas", target)
            outputChatBox(core:getServerPrefix("server", 2)..color..getPlayerName(target).." #ffffffeltávolított az összes frakcióból.", target, 255, 255, 255, true)
            triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "eltávolította az összes frakcióból #db3535"..getPlayerName(target).."#557ec9 nevű játékost.")

            setElementData(player, "log:admincmd", {getElementData(target, "char:id"), command})
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..command.." [Játékos]", player, 255, 255, 255, true) 
        end
    end
end
addCommandHandler("removeplayerfromallfaction", removePlayerFromAllFaction)
addCommandHandler("removefromallfaction", removePlayerFromAllFaction)

function setPlayerFactionLeader(player, cmd, target, targetFaction) 
    if exports["oAdmin"]:hasPermission(player,"setfactionleader") then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        target = tonumber(target) or 0
        targetFaction = tonumber(targetFaction) or 0 

        if (target > 0) and (targetFaction > 0) then
            if isRealFaction(targetFaction) then 
                target = core:getPlayerFromPartialName(player, target)

                local targetFactions = getPlayerAllFactions(target)

                local talalt = false
                for k, v in pairs(targetFactions) do 
                    if tonumber(v) == targetFaction then 
                        talalt = true 
                        break
                    end
                end

                if talalt then 

                    for k, v in pairs(server_factionMembers_list[targetFaction]) do 
                        if v[1] == getElementData(target, "char:id") then 
                            v[3] = not v[3]
                            print(tostring(v[3]))

                            if v[3] then 
                                outputChatBox(core:getServerPrefix("server", "Hozzáadva", 1)..color..getPlayerName(player).." #ffffffleader jogot adott a(z) "..color..getFactionName(targetFaction).."#ffffff nevű frakcióban.", target, 255, 255, 255, true)
                                triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "leader jogot adott #db3535"..getPlayerName(target).."#557ec9 nevű játékosnak a(z) #db3535"..getFactionName(targetFaction).." #557ec9nevű frakcióban.")
                            else
                                outputChatBox(core:getServerPrefix("server", "Hozzáadva", 1)..color..getPlayerName(player).." #ffffffelvette a leder jogod a(z) "..color..getFactionName(targetFaction).."#ffffff nevű frakcióban.", target, 255, 255, 255, true)
                                triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "elvette #db3535"..getPlayerName(target).."#557ec9 nevű játékos leader jogát a(z) #db3535"..getFactionName(targetFaction).." #557ec9nevű frakcióban.")
                            end

                            triggerClientEvent(root, "getFactionMembersFromServer > Return", root, server_factionMembers_list)
                            setElementData(player, "log:admincmd", {getElementData(target, "char:id"), cmd})

                            break
                        end
                    end
                else
                    outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."A játékos nem tagja a frakciónak. "..color.."("..getFactionName(targetFaction)..")", player, 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("red-dark", "Frakció", 3).."Nem létezik ilyen frakció!", player, 255, 255, 255, true)
            end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Játékos] [Frakció ID]", player, 255, 255, 255, true) 
        end
    end
end
addCommandHandler("setfactionleader", setPlayerFactionLeader)

function addMoneyToFaction(player, cmd, factionID, money)
    if exports["oAdmin"]:hasPermission(player,"givefactionmoney") then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        factionID = tonumber(factionID) or 0
        money = tonumber(money) or 0 

        if (factionID > 0) and (money > 0) then
            setFactionBankMoney(factionID, money, "add")
            triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "pénzt adott a(z) #db3535"..getFactionName(factionID).."#557ec9 nevű frakció számára. Összeg: #db3535"..money.."$ #557ec9| Számla új egyenlege: #db3535"..getFactionBankMoney(factionID).."$#557ec9.")
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Frakció ID] [Összeg]", player, 255, 255, 255, true) 
        end 
    end
end
addCommandHandler("givefactionmoney", addMoneyToFaction)

function removeMoneyToFaction(player, cmd, factionID, money)
    if exports["oAdmin"]:hasPermission(player,"removefactionmoney") then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        factionID = tonumber(factionID) or 0
        money = tonumber(money) or 0 

        if (factionID > 0) and (money > 0) then
            setFactionBankMoney(factionID, money, "remove")
            triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "pénzt vett el a(z) #db3535"..getFactionName(factionID).."#557ec9 nevű frakciótól. Összeg: #db3535(-)"..money.."$ #557ec9| Számla új egyenlege: #db3535"..getFactionBankMoney(factionID).."$#557ec9.")
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Frakció ID] [Összeg]", player, 255, 255, 255, true) 
        end 
    end
end
addCommandHandler("removefactionmoney", removeMoneyToFaction)