local func = {};
local color, r, g, b = exports.oCore:getServerColor()

func.buyItemToSeller = function(playerSource,itemid,count,amount)

    local state, slot = exports.oInventory:getFreeSlot(playerSource,itemid)
	if state then
        local itemWeight = exports.oInventory:getItemWeight(itemid) * count;
        if exports.oInventory:getElementItemsWeight(playerSource) + itemWeight <= 20 then 
            --outputChatBox(itemid.." - "..count.." - "..amount,playerSource)
            exports.oInventory:giveItem(playerSource,itemid,1,count,0);
            setElementData(playerSource, "char:money", getElementData(playerSource, "char:money") - amount)
            outputChatBox(exports.oCore:getServerPrefix("green-dark", "Barkácsbolt", 2).."Sikeresen vásároltál "..color..count.."#ffffff darab "..color..exports.oInventory:getItemName(itemid).."#ffffff-t ami "..color..amount.."#ffffff dollárba került.", playerSource, 255, 255, 255, true)
        else
            outputChatBox(exports.oCore:getServerPrefix("red-dark", "Barkácsbolt", 2).."Nincs elég hely nálad, ezért nem kaptad meg.", playerSource, 255, 255, 255, true)
        end
	else
        outputChatBox(exports.oCore:getServerPrefix("red-dark", "Barkácsbolt", 2).."Nincs szabad slotod, ezért nem kaptad meg.", playerSource, 255, 255, 255, true)
    end
end
addEvent("buyItemToSeller",true)
addEventHandler("buyItemToSeller",getRootElement(),func.buyItemToSeller)