local copyPed = createPed(142, 1926.8249511719,-2427.0678710938,15.401098251343, 293.62966918945)
setElementDimension(copyPed, 854)
setElementInterior(copyPed, 100)
setElementData(copyPed, "inventory:copyPed", true)
setElementFrozen(copyPed, true)
setElementData(copyPed, "ped:name", "Josh Klemanski")
setElementData(copyPed, "ped:prefix", "Kulcsmásoló")

addEvent("inventory > copyKey", true)
addEventHandler("inventory > copyKey", resourceRoot, function(item)
    local giveItemId = 234
    if item.item == 52 then 
        giveItemId = 235
    end

    if getFreeSlot(client, giveItemId) then 
        setElementData(client, "char:money", getElementData(client, "char:money") - 500)
        giveItem(client, giveItemId, item.value, 1, 0)
        outputChatBox(core:getServerPrefix("green-dark", "Kulcsmásolás", 3).."Sikeresen lemásoltattál egy "..getItemName(item.item).."ot. "..color.." (500$)", client, 255, 255, 255, true)
    else
        outputChatBox(core:getServerPrefix("red-dark", "Kulcsmásolás", 3).."Nincs szabad slotod.", client, 255, 255, 255, true)
    end
end)