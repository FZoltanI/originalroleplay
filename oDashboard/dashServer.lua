for k, v in ipairs(getElementsByType("player")) do 
    setElementData(v, "dashboard:vehicleBuy", false)
end


addEvent("dash > admin > callAdmins", true)
addEventHandler("dash > admin > callAdmins", resourceRoot, function()
    for k, v in ipairs(getElementsByType("player")) do 
        local alevel = getElementData(v, "user:admin") or 0
        if alevel > 0 then 
            outputChatBox(core:getServerPrefix("red-dark", "Adminisztrátor Segítségkérés", 2).." Adminisztrátori segítségre lenne szüksége "..color..getElementData(client, "char:name"):gsub("_", " ").." ("..getElementData(client, "playerid")..")#ffffff nevű játékosnak.", v, 255, 255, 255, true)
            infobox:outputInfoBox("Adminisztrátori segítségre van szükség!", "info", v)
        end
    end
end)

addEvent("premiumShop > buyPremiumItem", true)
addEventHandler("premiumShop > buyPremiumItem", resourceRoot, function(itemDatas)
    local id, price, count, value = unpack(itemDatas)

    inventory = exports.oInventory
    local itemID = inventory:giveItem(client, id, value, count, 0, _, _, _, client,1)
    setElementData(client, "char:pp", getElementData(client, "char:pp") - price)
    infobox:outputInfoBox("Sikeres vásárlás! Részletek a chatboxban.", "success", client)

    outputChatBox(core:getServerPrefix("server", "Prémium", 2).."Kedves: "..color..getPlayerName(client):gsub("_", " ").."#ffffff! Sikeresen vásároltál egy "..color..inventory:getItemName(id).." #ffffffnevű itemet!" , client, 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("red-dark", "Prémium", 2)..color.."Ezekre az üzenetekre bármikor szükséged lehet, ahoz, hogy bizonyítsd az item eredetét! Ha a későbbiekben ezekről az üzenetekről nem tudsz képet mutatni, akkor az item nem minősül prémium itemnek!", client, 255, 255, 255, true)
end)

addEvent("premiumShop > buyPremiumMoney", true)
addEventHandler("premiumShop > buyPremiumMoney", resourceRoot, function(itemDatas)
    local icon, price, count = unpack(itemDatas)

    setElementData(client, "char:pp", getElementData(client, "char:pp") - price)
    setElementData(client, "char:money", getElementData(client, "char:money") + count)
    infobox:outputInfoBox("Sikeres vásárlás! Részletek a chatboxban.", "success", client)

    outputChatBox(core:getServerPrefix("server", "Prémium", 2).."Kedves: "..color..getPlayerName(client):gsub("_", " ").."#ffffff! Sikeresen vásároltál "..color..count.."$#ffffff-t, "..color..price.."PP#ffffff-ért!" , client, 255, 255, 255, true)
end)


addEvent("premiumShop > buyPremiumPackage", true)
addEventHandler("premiumShop > buyPremiumPackage", resourceRoot, function(packageDatas)
    local name, price, items = unpack(packageDatas)

    inventory = exports.oInventory

    local player = client
    for k, v in pairs(items) do 
        --setTimer(function()
            local value
            if not v.value then 
                value = 1
            else
                value = v.value
            end
            
            local itemID = inventory:giveItem(player, v.id, value, v.count, 0, _, _, _, client,1) 
        --end, k*1000, 1)
    end
    setElementData(client, "char:pp", getElementData(client, "char:pp") - price)
    infobox:outputInfoBox("Sikeres vásárlás! Részletek a chatboxban.", "success", client)

    outputChatBox(core:getServerPrefix("server", "Prémium", 2).."Kedves: "..color..getPlayerName(client):gsub("_", " ").."#ffffff! Sikeresen vásároltál egy "..color..name.." #ffffffnevű prémium csomagot!" , client, 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("red-dark", "Prémium", 2)..color.."Ezekre az üzenetekre bármikor szükséged lehet, ahoz, hogy bizonyítsd az item eredetét! Ha a későbbiekben ezekről az üzenetekről nem tudsz képet mutatni, akkor az item nem minősül prémium itemnek!", client, 255, 255, 255, true)
end)

addEvent("slot > buySlot", true)
addEventHandler("slot > buySlot", resourceRoot, function(type, slot)
    setElementData(client, "char:pp", getElementData(client, "char:pp") - (slot * 100))
    setElementData(client, "char:"..type.."Slot", getElementData(client, "char:"..type.."Slot") + slot)
end)

addEvent("buypanel > startVehSell", true)
addEventHandler("buypanel > startVehSell", resourceRoot, function(tradePlayer, price, veh)
    setElementData(tradePlayer, "dashboard:inTrade", true)
    setElementData(client, "dashboard:inTrade", true)
    
    infobox:outputInfoBox(getPlayerName(client):gsub("_", " ").." el akar neked adni egy járművet!", "info", tradePlayer)

    triggerClientEvent(tradePlayer, "buypanel > startbuy", tradePlayer, client, price, veh)
end)

addEvent("buypanel > startIntSell", true)
addEventHandler("buypanel > startIntSell", resourceRoot, function(tradePlayer, price, veh)
    setElementData(tradePlayer, "dashboard:inTrade", true)
    setElementData(client, "dashboard:inTrade", true)
    
    infobox:outputInfoBox(getPlayerName(client):gsub("_", " ").." el akar neked adni egy ingatlant!", "info", tradePlayer)

    triggerClientEvent(tradePlayer, "buypanel > startbuy > int", tradePlayer, client, price, veh)
end)

addEvent("buypanel > endVehSell", true)
addEventHandler("buypanel > endVehSell", resourceRoot, function(traderPlayer, type, veh, price)
    price = tonumber(price)
    setElementData(traderPlayer, "dashboard:inTrade", false)
    setElementData(client, "dashboard:inTrade", false)

    if type == 1 then -- túl messzire kerültek
        infobox:outputInfoBox("Mivel túl messzire kerültetek egymástól, az eladás megszakadt!", "warning", traderPlayer)
    elseif type == 2 then -- elfogadva
        exports.oInventory:deleteAllExisitingItemWithValue(234, getElementData(veh, "veh:id")) -- törli az összes másolt kulcsot

        infobox:outputInfoBox("Sikeres eladás!", "success", traderPlayer)
        setElementData(client, "char:money", getElementData(client, "char:money")-price)
        setElementData(traderPlayer, "char:money", getElementData(traderPlayer, "char:money")+price)
        setElementData(veh, "veh:owner", getElementData(client, "char:id"))

        outputChatBox(core:getServerPrefix("server", "Jármű vásárlás", 3).."Megvásároltad a(z) "..color..getElementData(veh, "veh:id").." #ffffffazonosítóval rendelkező járművet, "..color..price.."$#ffffff-ért.", client, 255, 255, 255, true)
        outputChatBox(core:getServerPrefix("server", "Jármű eladás", 3).."Eladtad a(z) "..color..getElementData(veh, "veh:id").." #ffffffazonosítóval rendelkező járművet, "..color..price.."$#ffffff-ért.", traderPlayer, 255, 255, 255, true)
    elseif type == 3 then -- nincs elég pénz
        infobox:outputInfoBox("A vásárlónak nincs elegendő pénze a vásárláshoz!", "error", traderPlayer)
    elseif type == 4 then -- elutasítva
        infobox:outputInfoBox("Elutasították az ajánlatodat!", "error", traderPlayer)
    elseif type == 4 then -- elutasítva
        infobox:outputInfoBox("A vásárló nem rendelkezik elegendő jármű slottal!", "error", traderPlayer)
    end
end)

addEvent("buypanel > endIntSell", true)
addEventHandler("buypanel > endIntSell", resourceRoot, function(traderPlayer, type, int, price)
    price = tonumber(price)
    setElementData(traderPlayer, "dashboard:inTrade", false)
    setElementData(client, "dashboard:inTrade", false)

    if type == 1 then -- túl messzire kerültek
        infobox:outputInfoBox("Mivel túl messzire kerültetek egymástól, az eladás megszakadt!", "warning", traderPlayer)
    elseif type == 2 then -- elfogadva
        local intID = getElementData(int, "dbid")
        local newOwnerID = getElementData(client, "char:id")
        exports.oInventory:deleteAllExisitingItemWithValue(235, intID) -- törli az összes másolt kulcsot

        infobox:outputInfoBox("Sikeres eladás!", "success", traderPlayer)
        setElementData(client, "char:money", getElementData(client, "char:money")-price)
        setElementData(traderPlayer, "char:money", getElementData(traderPlayer, "char:money")+price)
        setElementData(int, "owner", newOwnerID)
        setElementData(getElementData(int, "other"), "owner", newOwnerID)

        dbExec(conn, "UPDATE `interiors` SET `owner` = ? WHERE id = ?", newOwnerID, intID)

        outputChatBox(core:getServerPrefix("server", "Ingatlan vásárlás", 3).."Megvásároltad a(z) "..color..getElementData(int, "name").." #ffffffnevű ingatlant, "..color..price.."$#ffffff-ért.", client, 255, 255, 255, true)
        outputChatBox(core:getServerPrefix("server", "Ingatlan eladás", 3).."Eladtad a(z) "..color..getElementData(int, "name").." #ffffffnevű ingatlant, "..color..price.."$#ffffff-ért.", traderPlayer, 255, 255, 255, true)
    elseif type == 3 then -- nincs elég pénz
        infobox:outputInfoBox("A vásárlónak nincs elegendő pénze a vásárláshoz!", "error", traderPlayer)
    elseif type == 4 then -- elutasítva
        infobox:outputInfoBox("Elutasították az ajánlatodat!", "error", traderPlayer)
    elseif type == 4 then -- elutasítva
        infobox:outputInfoBox("A vásárló nem rendelkezik elegendő slottal!", "error", traderPlayer)
    end
end)

addEvent("dashboad > setPlayer > fightStyle", true)
addEventHandler("dashboad > setPlayer > fightStyle", resourceRoot, function(value)
    setPedFightingStyle(client, fightingStyles[value])
end)

addEvent("dashboad > setPlayer > walkStyle", true)
addEventHandler("dashboad > setPlayer > walkStyle", resourceRoot, function(value)
    setPedWalkingStyle(client, walkingStyles[value])
end)

function setDashboardRealtime()
    local realtime = getRealTime()
    setElementData(root, "dash:timestamp", getTimestamp(realtime.year + 1900, realtime.month, realtime.day, realtime.hour, realtime.minute, realtime.second))
end
setDashboardRealtime()
setTimer(setDashboardRealtime, core:minToMilisec(5), 0)