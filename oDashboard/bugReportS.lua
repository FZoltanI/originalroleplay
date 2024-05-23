local bugReports = {}

addEvent("bugreport > addBugReport", true)
addEventHandler("bugreport > addBugReport", resourceRoot, function(playerDatas, bugDatas, date)
    local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO bugReports SET playerDatas = ?, bugDatas = ?, reportDate = ?", toJSON(playerDatas), toJSON(bugDatas), date), 250)

    if insertID then 
        table.insert(bugReports, 1, {insertID, playerDatas, bugDatas, date, "wait_dev"})

        triggerClientEvent(client, "dash > bugReport > bugReportsToClient", client, bugReports)

        for k, v in ipairs(getElementsByType("player")) do 
            if (getElementData(v, "user:admin") or 0) >= 9 then 
                infobox:outputInfoBox("Új hibát jelentettek! (Rendszer: "..bugDatas[1].. "; Hiba: "..bugDatas[2]..")", "bug", v)
            end
        end
    end
end)

addEventHandler("onResourceStart", resourceRoot, function()
    local query = dbQuery(conn, 'SELECT * FROM bugReports')
    local result = dbPoll(query, 255)


    if result then 
        local lastInserts = {}

        for k, v in ipairs(result) do 
            if v["state"] == "dev_complete" then 
                table.insert(lastInserts, {v["id"], fromJSON(v["playerDatas"]), fromJSON(v["bugDatas"]), v["reportDate"], v["state"]})
            else
                table.insert(bugReports, {v["id"], fromJSON(v["playerDatas"]), fromJSON(v["bugDatas"]), v["reportDate"], v["state"]})
            end
        end

        for k, v in ipairs(lastInserts) do 
            table.insert(bugReports, #bugReports + 1, v)
        end
    end
end)

addEventHandler("onResourceStop", resourceRoot, function()
    for k, v in ipairs(bugReports) do 
        dbExec(conn, "UPDATE bugReports SET state = ? WHERE id = ?", v[5], v[1])
    end
end)

addEvent("dash > bugReport > setReportState", true)
addEventHandler("dash > bugReport > setReportState", resourceRoot, function(reportID, state)
    for k, v in ipairs(bugReports) do 
        if v[1] == reportID then 
            --[[if v[5] == "dev_complete" then 
                local tempTable = v 

                tempTable[5] = state

                table.remove(bugReports, k)
                table.insert(bugReports, tempTable)
            else]]
                v[5] = state 

                if state == "dev_complete" then 
                    local tempTable = v 
    
                    table.remove(bugReports, k)
                    table.insert(bugReports, #bugReports + 1, tempTable)
                end
            --end
            break
        end
    end

    triggerClientEvent(client, "dash > bugReport > bugReportsToClient", client, bugReports)
end)

addEvent("dash > bugReport > requestBugRepotsFromServer", true)
addEventHandler("dash > bugReport > requestBugRepotsFromServer", resourceRoot, function()
    if getElementData(client, "user:admin") >= 8 then 
        triggerClientEvent(client, "dash > bugReport > bugReportsToClient", client, bugReports)
    end
end)