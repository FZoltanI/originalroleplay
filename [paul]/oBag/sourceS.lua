
local bag = {}
local cache = {}

function attachBag(attacker,element)
    h = exports["oCore"]:getServerColor()
    if not cache[element] then 
        bag[element] = createObject(2663,0,0,0);
        cache[element] = true ;
        setElementData(element,"player:bag",cache[element]);
        setObjectScale(bag[element],1.3);
        exports["oBone"]:attachElementToBone(bag[element],element,1,0,0,0.1);
        toggleAllControls(element,false,false,true)
        setElementData(element, "player:bagBAG", true)
        fadeCamera(element, false, 0.5)
        --setElementFrozen(element,true)
        exports["oChat"]:sendLocalMeAction(attacker,"ráhúz egy zsákot "..utf8.gsub(getElementData(element,"char:name"),"_"," ").." fejére.")
        exports["oInventory"]:takeItem(attacker,141)
    else 
        outputChatBox(h.."[oInventory]: "..getPlayerName(element).." fején már van zsák!",attacker,255,255,255,true);
    end 
end 
addEvent("attachBag",true)
addEventHandler("attachBag",root,attachBag)

function deattachBag(attacker,element)
    if cache[element] then
        cache[element] = false;
        destroyElement(bag[element]);
        setElementData(element,"player:bag",cache[element]);
        bag[element] = nil;
        exports["oChat"]:sendLocalMeAction(attacker,"levesz egy zsákot "..utf8.gsub(getElementData(element,"char:name"),"_"," ").." fejéről.")
        toggleAllControls(element,true,true,true)
        fadeCamera(element, true)
        --setElementFrozen(element,false)
        setElementData(element, "player:bagBAG", false)
        fadeCamera(element,true, 0.5)
        exports["oInventory"]:giveItem(attacker,141,1,1,0)
    else 
        outputChatBox(h.."[oInventory]: #ffffff"..getElementData(element,"char:name").." fején nincs zsák!",attacker,255,255,255,true);
    end 
end 
addEvent("deattachBag",true)
addEventHandler("deattachBag",root,deattachBag)