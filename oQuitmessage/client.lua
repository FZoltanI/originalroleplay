local reasons = {
    ["Unknown"] = "Ismeretlen",
    ["Quit"] = "Kilépett",
    ["Kicked"] = "Kickelve",
    ["Banned"] = "Bannolva",
    ["Bad Connection"] = "Bad Connection",
    ["Timed out"] = "Timed out",
}

addEventHandler("onClientPlayerQuit", root, function(reason)
    local dis = exports.oCore:getDistance(localPlayer, source)
    if dis < 20 then 
        outputChatBox("[Kilépés]: #ffffff"..getPlayerName(source):gsub("_", " ").." #f03629kilépett a közeledben #ffffff"..math.floor(dis).."#f03629 yard távolságban. #ffffff("..reasons[reason]..")", 240, 54, 41, true)
    end
end)