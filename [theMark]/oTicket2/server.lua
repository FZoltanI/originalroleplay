local sql = exports.oMysql:getDBConnection()

addEvent("oPayTicket2", true)
addEventHandler("oPayTicket2", root, function(player, perpetrator, money)
    -- outputChatBox("asdasdsadsadsadasdasdasdasdsa")
    local perpetratorTxt = getPlayerFromName(perpetrator)
    if perpetratorTxt then
        perpetratorTxt:setData("char:money", perpetratorTxt:getData("char:money") - money)
        outputChatBox(exports.oCore:getServerPrefix("servercolor", 1) .. "Sikeresen megbüntetted a játékost!", player, 255, 255, 255, true)
    else
        return outputChatBox(exports.oCore:getServerPrefix("servercolor", 1) .. "Nincs ilyen játékos!", player, 255, 255, 255, true)
    end
end)
