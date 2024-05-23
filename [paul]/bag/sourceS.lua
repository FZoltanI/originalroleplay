
local bag = {}
local cache = {}

function attachBag(attacker,element)
    h = exports["oCore"]:getServerColor()
    if not cache[element] then 
        bag[element] = createObject(2663,0,0,0);
        cache[element] = true ;
        setElementData(element,"player:bag",cache[element]);
        setObjectScale(bag[element],1.3);
        exports["oBone"]:attachElementToBone(bag[element],element,1,0,0,0.2);
        outputChatBox(h.."[oInventory]: #ffffffEgy zsák kerűlt a fejedre, amíg ez rajtad van a folyamatos mozgás csak segítséggel fog menni, látni viszont semmit nem fogsz!",element,255,255,255,true);
        toggleControl(element,"sprint",false);
        toggleControl(element,"jump",false);
        --fadeCamera(element,false)
    else 
        outputChatBox(h.."[oInventory]: "..getPlayerName(element).." fején már van zsák!",attacker,255,255,255,true);
    end 
end 

function deattachBag(attacker,element)
    if cache[element] then
        cache[element] = false;
        destroyElement(bag[element]);
        setElementData(element,"player:bag",cache[element]);
        bag[element] = nil;
        outputChatBox(h.."[oInventory]: #ffffffMivel levették a zsákot a fejedről újra láthatsz és korlátozások nélkűl mozoghatsz!",element,255,255,255,true);
        toggleControl(element,"sprint",true);
        toggleControl(element,"jump",true);
        --fadeCamera(element,true)

    else 
        outputChatBox(h.."[oInventory]: #ffffff"..getElementData(element,"char:name").." fején nincs zsák!",attacker,255,255,255,true);
    end 
end 
