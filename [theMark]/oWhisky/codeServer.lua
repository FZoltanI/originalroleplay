local connection = exports["oMysql"]:getDBConnection()
--[[
function uploadBarrelData(player, level, idByIndex)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if (result) then 
            for _,row in ipairs(result) do 
                if not (row["idByIndex"] == idByIndex) then 
                    local qh = dbQuery(connection, "INSERT INTO owhisky SET owner = ?, date = NOW(), level = ?, interiorID = ?, dimension = ?, idByIndex = ?", player:getData("user:id"), level, 1, 265, idByIndex)
                    local res, _, ID = dbPoll(qh, -1)
                    outputChatBox("feltöltve! ID:"..ID, player, 255, 255, 255, true)
                    break
                else
                    outputChatBox("Már van!") 
                end 
            end 
        end 
    end, connection, "SELECT * FROM owhisky WHERE owner = ?", player:getData("user:id"))    
end
addEvent("uploadBarrelData", true)
addEventHandler("uploadBarrelData", root, uploadBarrelData)


addEventHandler("onResourceStart", root, 
    function()
        local players = getElementsByType ( "player" ) 
        for theKey, thePlayer in ipairs(players) do 
            dbQuery(function(qh)
                local result = dbPoll(qh, 0)
                if (result) then 
                    for i,v in ipairs(result) do 
                        level = v["level"]
                        date = v["date"]               
                    end 
                    triggerClientEvent(thePlayer, "sendServerData", thePlayer, level, date)
                end 
            end, connection, "SELECT * FROM owhisky WHERE id = ?", thePlayer:getData("user:id"))
        end 
    end 
);

addCommandHandler("ok", 
    function(player)
        dbExec(connection, "UPDATE owhisky SET level = ? WHERE id = ?", 20, 1)
        outputChatBox("kész")
    end 
);]]--