local db = exports.oMysql:getLogsDBConnection()

addEvent("sendPlayerLogs", true)
addEventHandler("sendPlayerLogs", getRootElement(), function(type, data)
    if type == "money" then
        dbExec(db, "INSERT INTO money (source, destination, amount, date) VALUES (?,?,?,?)", data[1], data[2], data[3], data[4])
    elseif type == "bank" then
        dbExec(db, "INSERT INTO bank (source, amount, type, date) VALUES (?,?,?,?)", data[1], data[2], data[3], data[4])
    elseif type == "vehicle" then
        dbExec(db, "INSERT INTO vehicle (source, destination, vehid, price, date) VALUES (?,?,?,?,?)", data[1], data[2], data[3], data[4], data[5])
    elseif type == "carshop" then
        dbExec(db, "INSERT INTO carshop (source, vehid, date) VALUES (?,?,?)", data[1], data[2], data[3])
    elseif type == "admincmd" then
        dbExec(db, "INSERT INTO admincmd (source, player, cmd, date) VALUES (?,?,?,?)", data[1], data[2], data[3], data[4])
    end
end)