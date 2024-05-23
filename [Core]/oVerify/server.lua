local conn = exports.oMysql:getDBConnection()
local core = exports.oCore
local admin = exports.oAdmin
local verifiedSerails = {}

local prefix = "#f73e3e[Verifed]: #f73e6c"

local mainverifedserials = {
    ["D9B7974D5E8602566A8A87EF01B46753"] = "Dawis",
    ["52E602241DC69E45929DF7CA9DCDDE54"] = "Carlos",
    ["E83F361963A13115A103300633438183"] = "Rajmii",
    ["15D9EC74550C8B8C29B9E21D038A18F2"] = "Puzsér",
    ["2408B9AF6492187C36BBF3F7DF2CED13"] = "jekson",
    ["FCF1E89E7894C8C58287D9B121B978B2"] = "Kondor",
    ["3C4EDBBC959CD9DBFF7E4E35F46B94B2"] = "Paul",
    ["A2498F200A8A37DBD8BD00F8CFF46C72"] = "Dimitrii",
    ["A8D6BA2E6A0FE86203A10DEEA851BBA2"] = "Aron",
    ["DB4D5C149B828DB87EDE1F3E5D819093"] = "Ezio",
    ["1702ADC43E5AB6EC9E37504C58C38954"] = "Csabi",
}

function loadVerifiedSerials()
    local query = dbQuery(conn, "SELECT * FROM verifedplayers")
    local res = dbPoll(query, 200)

    if res then 
        verifiedSerails = {}
        for _, r in ipairs(res) do
            verifiedSerails[r["serial"]] = r["discordName"]
        end

        for k, v in ipairs(getElementsByType("player")) do 
            if verifiedSerails[getPlayerSerial(v)] or mainverifedserials[getPlayerSerial(v)] then 
                setElementData(v,"char:verifed",true)
            else 
                setElementData(v,"char:verifed",false)
            end
        end
    end
end
loadVerifiedSerials()

addEventHandler("onElementDataChange",root,function(key,old,new)
    if key == "user:loggedin" then 
        if new == true then 
            for k, v in ipairs(getElementsByType("player")) do 
                if not verifiedSerails[getPlayerSerial(v)] then 
                    setElementData(v,"char:verifed",true)
                end
            end
        end 
    end 
end)

function wlkick(p)
    kickPlayer(p)
end

setTimer(function()
    loadVerifiedSerials()

    for k, v in ipairs(getElementsByType("player")) do 
        if not verifiedSerails[getPlayerSerial(v)] then 
            wlkick(v)
        end
    end
end, 60000, 0)

function sendMSG(nick, msg)
    for k, v in ipairs(getElementsByType("player")) do 
        if mainverifedserials[getPlayerSerial(v)] then 
            outputChatBox(prefix..nick.."#ffffff "..msg, v, 255, 255, 255, true)
        end
    end
end

addCommandHandler("verifyplayer", function(player, cmd, serial, playerName, discordName)
    local adminSerial = getPlayerSerial(player)
    local aLevel = getElementData(player,"user:admin")

    if aLevel >= 7 then 

        if serial and playerName and discordName then 
            
            if verifiedSerails[serial] then 
                outputChatBox(core:getServerPrefix("red-dark", "Verifed", s2).."Ez a serial már hozzá van adva a verifed playerekhez.", player, 255, 255, 255, true)
                return 
            end

            dbExec(conn, "INSERT INTO verifedplayers (serial, playerName, discordName, adminName) VALUES (?, ?, ?, ?)", serial, playerName, discordName, mainverifedserials[adminSerial])
            loadVerifiedSerials()
            sendMSG(getPlayerName(player), "hozzáadta a verifed playerekhez #f73e3e"..discordName.."#ffffff-t ("..playerName.."), SERIAL: #f73e3e"..serial)

            for k,v in pairs(getElementsByType("player")) do 
                if getPlayerSerial(v) == serial then 
                    outputChatBox(prefix.." "..getPlayerName(player).." #ffffffhozzáadott téged a verifed playerek listájához!",v,255,255,255,true)
                end     
            end 
        else
            outputChatBox(core:getServerPrefix("server", "Verifed", 2).."/"..cmd.." [Serial] [Player Name] [Discord Name]", player, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("removeplayerverify", function(player, cmd, value)
    local adminSerial = getPlayerSerial(player)
    local aLevel = getElementData(player,"user:admin")

    if aLevel >= 7 then 
        if value then 
            if verifiedSerails[value] then 
                for k,v in pairs(getElementsByType("player")) do 
                    if getPlayerSerial(v) == value then 
                        outputChatBox(prefix.." "..getPlayerName(player).." #ffffffkivett téged a verifed playerek listájából!",v,255,255,255,true)
                    end     
                end 
                sendMSG(getPlayerName(player), "törölte a verifed playerek közül a következő SERIALT: #f73e3e"..value)
                dbExec(conn, "DELETE FROM verifedplayers WHERE serial = ?", value)
                loadVerifiedSerials()
            else 
                outputChatBox(core:getServerPrefix("server", "Verifed", 2).."A kiválasztott játékos nincs verifyolva!", player, 255, 255, 255, true)
            end 
        else
            outputChatBox(core:getServerPrefix("server", "Verifed", 2).."/"..cmd.." [Serial]", player, 255, 255, 255, true)
        end
    end
end)

addCommandHandler("getplayerserial",function(thePlayer,cmd,id)
    if not id then return outputChatBox(core:getServerPrefix("server", "Használat", 2).."/"..cmd.." [ID]", player, 255, 255, 255, true) end 
    local p = core:getPlayerFromPartialName(player, tonumber(id))

    if not p then return outputChatBox(core:getServerPrefix("server", "Használat", 2).."Nincs találat!", player, 255, 255, 255, true) end  
    local aLevel = getElementData(player,"user:admin")

    if aLevel >= 7 then 
        outputChatBox(core:getServerPrefix("server", "Serial", 2).."A kiválasztott játékos serialja: "..getPlayerSerial(p), player, 255, 255, 255, true)
    end 
end)