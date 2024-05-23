local db = {exports.oMysql:getDBConnection(), exports.oMysql:getLogsDBConnection()}

local sections = {
    "money",
    --"bank",
    --"carshop",
    --"vehicle",
    "admincmd",
}

addEvent("server->requestLogs", true)
addEventHandler("server->requestLogs", getRootElement(), function(charname)
    dbQuery(function(queryHandle, client)
        local result, rows = dbPoll(queryHandle, 0)
        if rows > 0 then
            local charID = result[1].id
            triggerClientEvent(client, "client->serverResponse", client, charID)
            for _, section in ipairs(sections) do
                if section == "money" then
                    dbQuery(function(queryHandle, client)
                        local result, rows = dbPoll(queryHandle, 0)
                        if rows > 0 then
                            triggerClientEvent(client, "client->serverResponse", client, {"money", result})
                            outputDebugString("Trigger: logs to client (money)")
                        end
                    end, {client}, db[2], "SELECT * FROM money WHERE source=? OR destination=? ORDER BY id DESC", charID, charID)
                else
                    dbQuery(function(queryHandle, client, section)
                        local result, rows = dbPoll(queryHandle, 0)
                        if rows > 0 then
                            triggerClientEvent(client, "client->serverResponse", client, {section, result})
                            outputDebugString("Trigger: logs to client ("..section..")")
                        end
                    end, {client, section}, db[2], "SELECT * FROM "..section.." WHERE source=? ORDER BY id DESC", charID)
                end
            end
        else
            triggerClientEvent(client, "client->serverResponse", client)
        end
    end, {client}, db[1], "SELECT id FROM characters WHERE charname=?", charname)
end)