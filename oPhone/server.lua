local conn = exports.oMysql:getDBConnection()

local phoneMessages = {}

addEvent("phone > getPhonedMan", true)
addEventHandler("phone > getPhonedMan", resourceRoot, function(phoneNumber, callerNumber, hiddenNumber)
    local founded = false 

    --outputChatBox(callerNumber)
    for k, v in ipairs(getElementsByType("player")) do 
        if exports.oInventory:hasItem(v, 1, phoneNumber) then 
            founded = v 
            break
        end
    end

    if founded then 
        if founded == client then 
            triggerClientEvent(client, "phone > getBackPhoneCallingData", client, "error", false)
            setElementData(client, "phone:state", false)
        else
            if not getElementData(founded, "phone:state") then 
                --outputChatBox("phoneNumber: "..getPlayerName(client).." > "..getPlayerName(founded))
                triggerClientEvent(client, "phone > getBackPhoneCallingData", client, "call", founded)
                triggerClientEvent(founded, "phone > getBackPhoneCallingData", founded, "in", client, callerNumber, phoneNumber, hiddenNumber)
                setElementData(client, "phone:state", "inWaiting")

                setElementData(client, "phone:talkedPlayer", founded)
                setElementData(founded, "phone:talkedPlayer", client)
            else
                triggerClientEvent(client, "phone > getBackPhoneCallingData", client, "busy", false)
                setElementData(client, "phone:state", false)
            end
        end
    else
        triggerClientEvent(client, "phone > getBackPhoneCallingData", client, "error", false)
        setElementData(client, "phone:state", false)
    end
end)

addEvent("phone > dismissCalling", true)
addEventHandler("phone > dismissCalling", resourceRoot, function(player)
    if isElement(player) then 
        triggerClientEvent(player, "phone > getBackPhoneCallingData", player, "dismiss", client)
        setElementData(player, "phone:state", false)
    end
    setElementData(client, "phone:state", false)
end)

addEvent("phone > acceptCalling", true)
addEventHandler("phone > acceptCalling", resourceRoot, function(player)
    triggerClientEvent(player, "phone > getBackPhoneCallingData", player, "accept", client)
    setElementData(client, "phone:state", "inCall")
    setElementData(player, "phone:state", "inCall")
end)

addEvent("phone > syncCall", true)
addEventHandler("phone > syncCall", resourceRoot, function(music, volume)
    setElementData(client, "phone:ringstone", music)
    setElementData(client, "phone:ringstoneVolume", volume)
    setElementData(client, "phone:state", "called")
end)

addEventHandler("onResourceStart", resourceRoot, function()
    for k, v in ipairs(getElementsByType("player")) do 
        setElementData(v, "phone:state", false)
        setElementData(v, "phone:talkedPlayer", false)
    end
end)

addEvent("phone > addNews", true)
addEventHandler("phone > addNews", resourceRoot, function(text, phoneNumber, type)
    if not type then type = "normal" end 

    if type == "normal" then 
        setElementData(client, "char:money", getElementData(client, "char:money")-150)

        for k, player in ipairs(getElementsByType("player")) do 
            if getElementData(player, "user:loggedin") then
                if exports.oInventory:hasItem(player, 1) then 
                    outputChatBox(core:getServerPrefix("server", "Hirdetés", 3).."#eb8c34"..text.." #ffffff(("..getPlayerName(client):gsub("_", " ").."))", player, 255, 255, 255, true)
                    if tonumber(phoneNumber) > 0 then 
                        outputChatBox(core:getServerPrefix("server", "Hirdetés", 3).."#eb8c34".."Telefonszám: #ffffff"..phoneNumber, player, 255, 255, 255, true)
                    end
                end
            end
        end
    elseif type == "dw" then 
        setElementData(client, "char:money", getElementData(client, "char:money")-375)

        for k, player in ipairs(getElementsByType("player")) do 
            if not (exports.oDashboard:isPlayerFactionTypeMember(player, {1})) then
                if getElementData(player, "user:loggedin") then
                    if exports.oInventory:hasItem(player, 1) then 
                        outputChatBox("#652d96[Dark Web]: #73449c"..text.." #ffffff(("..getPlayerName(client):gsub("_", " ").."))", player, 255, 255, 255, true)
                        if tonumber(phoneNumber) > 0 then
                            outputChatBox("#652d96[Dark Web]: #73449cTelefonszám: #ffffff"..phoneNumber, player, 255, 255, 255, true)
                        end
                    end
                end
            end
        end
    end
end)

addEvent("phone > sendMessage", true)
addEventHandler("phone > sendMessage", resourceRoot, function(text, player)
    triggerClientEvent(player, "phone > requestMessage", player, text) 
    triggerClientEvent(root, "outputChatMessage", client, client, text, 15)
end)

addEvent("phone > sendSMS", true)
addEventHandler("phone > sendSMS", resourceRoot, function(recievedPhoneNumber, message, date, senderPhoneNumber)
    --outputChatBox("[SMS]: "..senderPhoneNumber.." > "..recievedPhoneNumber)
    --outputChatBox("[SMS]: "..message.." ("..date..")")

    recievedPhoneNumber = tonumber(recievedPhoneNumber)
    senderPhoneNumber = tonumber(senderPhoneNumber)

    if not phoneMessages[recievedPhoneNumber] then 
        phoneMessages[recievedPhoneNumber] = {}
    end

    if not phoneMessages[recievedPhoneNumber][senderPhoneNumber] then
        local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO phoneMessages SET recievedPhone = ?, senderPhone = ?, messageData = ? ", recievedPhoneNumber, senderPhoneNumber, toJSON({})), 250)

        if insertID then
            phoneMessages[recievedPhoneNumber][senderPhoneNumber] = {
                read = false,
                messages = {},
                id = insertID,
            }
        end
    end
    phoneMessages[recievedPhoneNumber][senderPhoneNumber].read = false
    table.insert(phoneMessages[recievedPhoneNumber][senderPhoneNumber].messages, {date, message})

    if not phoneMessages[senderPhoneNumber] then 
        phoneMessages[senderPhoneNumber] = {}
    end

    if not phoneMessages[senderPhoneNumber][recievedPhoneNumber] then
        local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO phoneMessages SET recievedPhone = ?, senderPhone = ?, messageData = ? ", senderPhoneNumber, recievedPhoneNumber, toJSON({})), 250)

        if insertID then
            phoneMessages[senderPhoneNumber][recievedPhoneNumber] = {
                read = true,
                messages = {},
                id = insertID,
            }
        end
    end
    phoneMessages[senderPhoneNumber][recievedPhoneNumber].read = true
    table.insert(phoneMessages[senderPhoneNumber][recievedPhoneNumber].messages, {date, message, true})

    triggerClientEvent(root, "phone > syncSMS > client", root, phoneMessages)

    for k, v in ipairs(getElementsByType("player")) do 
        if exports.oInventory:hasItem(v, 1, recievedPhoneNumber) then 
            founded = v 
            break
        end
    end

    if founded then 
        exports.oChat:sendLocalDoAction(founded, "kapott egy üzenetet.")
        triggerClientEvent(founded, "phone > getPhoneNotificationSound", resourceRoot, recievedPhoneNumber)
    end
end)

function saveMessages()
    for k, v in pairs(phoneMessages) do 
        for k2, v2 in pairs(v) do 
            --print(v2.id)
            dbExec(conn, "UPDATE phoneMessages SET messageData = ? WHERE id = ?", toJSON({v2.messages, v2.read}), v2.id)
        end
    end
end
addEventHandler("onResourceStop", resourceRoot, saveMessages)

function loadMessages()
    query = dbQuery(conn, 'SELECT * FROM phoneMessages')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            if not phoneMessages[v["recievedPhone"]] then 
                phoneMessages[v["recievedPhone"]] = {}
            end

            local messageDatas = fromJSON(v["messageData"])
            table.insert(phoneMessages[(v["recievedPhone"])], v["senderPhone"], {
                read = messageDatas[2],
                messages = messageDatas[1],
                id = v["id"],
            })

        end
    end
end

setTimer(function()
    triggerClientEvent(root, "phone > syncSMS > client", root, phoneMessages)
end, 2000, 1)

addEventHandler("onResourceStart", resourceRoot, loadMessages)

addEventHandler ( "onPlayerJoin", root, function()
    triggerClientEvent(source, "phone > syncSMS > client", root, phoneMessages)
end)

addEvent("phone > playPhoneNotificationSound", true)
addEventHandler("phone > playPhoneNotificationSound", resourceRoot, function(sound, volume)
    triggerClientEvent(resourceRoot, "phone > play3dNotifiactionSound", resourceRoot, client, sound, volume)
end)

addEvent("phone > delConversationFromPhone", true)
addEventHandler("phone > delConversationFromPhone", resourceRoot, function(phoneNum, conversation)
    local id = phoneMessages[phoneNum][conversation].id
    local idgtable = phoneMessages
    table.remove(idgtable[phoneNum], tostring(conversation))
    phoneMessages = idgtable
    triggerClientEvent(root, "phone > syncSMS > client", root, phoneMessages)
   -- dbExec(conn, "DELETE FROM phoneMessages WHERE id=?", id)
end)