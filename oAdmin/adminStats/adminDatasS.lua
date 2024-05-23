local conn = exports.oMysql:getDBConnection()
local core = exports.oCore

addEvent("admin > getAdminDatasFromServerside", true)
addEventHandler("admin > getAdminDatasFromServerside", resourceRoot, function()

    local qh = dbQuery(conn, 'SELECT * FROM accounts')
    local result = dbPoll(qh, 100)

    local qh2 = dbQuery(conn, 'SELECT * FROM characters')
    local result2 = dbPoll(qh2, 100)

    local adminsTable = {}

    if result and result2 then
        for k, row in ipairs (result) do
            if row["admin"] > 1 then
                table.insert(adminsTable, {row["adminnick"], row["admin"], {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}})

                for key, value in ipairs(result2) do
                    if value["account"] == row["id"] then
                        --outputChatBox(value["account"].." "..row["id"])
                        adminsTable[#adminsTable][3][9] = value["adutyTime"]
                        adminsTable[#adminsTable][3][10] = value["adminOnlineTime"]

                        local otherData = fromJSON(value["adminDatas"])

                        for k, v in ipairs(otherData) do
                            adminsTable[#adminsTable][3][k] = v
                        end
                        break
                    end
                end
            end
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Admin", 2).."Nem sikerült kapcsolatot létesíteni az adatbázissal! "..color.."(Jelezd egy fejlesztőnek!)", client, 255, 255, 255, true)
    end

    if #adminsTable > 0 then
        triggerClientEvent(client, "admin > adminDatasToClientside", client, adminsTable)
    end

    dbFree(qh)
    dbFree(qh2)
end)

addCommandHandler("clearadminstats", function(thePlayer, cmd)
    if hasPermission(thePlayer,'clearadminstats') then
        if (getElementData(thePlayer, "lastUseAdminClearCommand") or 0) + core:minToMilisec(60) < getTickCount() then
            setElementData(thePlayer, "lastUseAdminClearCommand", getTickCount())
            setElementData(thePlayer, "log:admincmd", {"Használta", cmd})

            local qh = dbQuery(conn, 'SELECT * FROM characters')
            local result = dbPoll(qh, 350)

            for k, v in ipairs(getElementsByType("player")) do
                setElementData(v, "user:adutyTime", 0)
                setElementData(v, "user:adminOnlineTime", 0)
                setElementData(v, "user:adminDatas", {0, 0, 0, 0, 0, 0, 0, 0})
            end

            for k, row in ipairs (result) do
                dbExec(conn, "UPDATE characters SET adutyTime = ?, adminOnlineTime = ?, adminDatas = ? WHERE id = ?", 0, 0, toJSON({0, 0, 0, 0, 0, 0, 0, 0}), row["id"])
            end

            sendMessageToAdmins(thePlayer, "lenullázta az összes adminisztrátor statisztikáját.")
        else
            outputChatBox(core:getServerPrefix("red-dark", "Admin", 2).."Ezt a parancsot csak óránként használhatod.", thePlayer, 255, 255, 255, true)
        end
    end
end)
