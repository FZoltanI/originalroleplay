local con = exports.oMysql:getDBConnection()

addEvent("premium > checkPending", true)
addEventHandler("premium > checkPending", root, function()
    local charid = getElementData(source, "char:id")
    local amount = getElementData(source, "char:pp")

    dbQuery(function (qh, source)
        local result, rows = dbPoll(qh, 0)
        for k, row in ipairs (result) do
            amount = amount + row["pp"]
            exports.oInfobox:outputInfoBox("Jóváírva "..row["pp"].."PP a karakteredre!", "success", source)
        end

        if rows > 0 then
            dbExec(con, "DELETE FROM pendingpps WHERE charid = ?", charid)
            dbExec(con, "UPDATE characters SET pp = ? WHERE id = ?", amount, charid)
        end

        setElementData(source, "char:pp", amount)
    end, {source}, con, "SELECT * FROM pendingpps WHERE charid = ?", charid)
end)

for k, v in ipairs(getElementsByType("player")) do
    if (getElementData(v, "user:loggedin")) then
        triggerEvent("premium > checkPending", v)
    end
end