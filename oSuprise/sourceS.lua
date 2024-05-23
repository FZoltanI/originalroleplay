local func = {};
local respawnTimer = {};
local objectCache = {};

func.start = function()
    for i = 1, 200 do
        id = math.random(1, #giftCache)
        if (giftCache[id].dropped) then
            id = math.random(1, #giftCache) 
            if not (giftCache[id].dropped) then
                local gift = createObject(model,giftCache[id][1],giftCache[id][2],giftCache[id][3]-1)
                giftCache[id].dropped = true
                setElementData(gift,"gift",true);
                setElementData(gift,"gift:id",id);
                setElementData(gift,"gift:pickup",false);
                objectCache[gift] = true;
                --outputChatBox(id)
            end
        else
            local gift = createObject(model,giftCache[id][1],giftCache[id][2],giftCache[id][3]-1)
            giftCache[id].dropped = true
            setElementData(gift,"gift",true);
            setElementData(gift,"gift:id",id);
            setElementData(gift,"gift:pickup",false);
            objectCache[gift] = true;
            --outputChatBox(id)
        end
    end
end
addEventHandler("onResourceStart",resourceRoot,func.start)



func.gotoGift = function(playerSource,cmd,x,y,z)
    if getElementData(playerSource,"user:admin") >= 8 then
        x = tonumber(x);
        y = tonumber(y);
        z = tonumber(z);
        if x and y and z and type(x) == "number" and type(y) == "number" and type(z) == "number" then
            setElementPosition(playerSource,x,y,z+1);
        end
    end
end
addCommandHandler("gotopos",func.gotoGift)

func.giveGift = function(playerSource,nid)
    
    for gift,v in pairs(objectCache) do
        if isElement(gift) and getElementData(gift,"gift") and getElementData(gift,"gift:id") == nid then
            outputChatBox(core:getServerPrefix("green-dark", "Ajándék", 3).." Sikeresen felvettél egy ajándékot.",playerSource,220,20,60,true)
            exports.oInventory:giveItem(playerSource,200,1,1,0);
            respawnTimer[nid] = setTimer(function()
                for i = 1, 1 do
                    id = math.random(1, #giftCache)
                    if (giftCache[id].dropped) then
                        id = math.random(1, #giftCache) 
                        if not (giftCache[id].dropped) then
                            local gift = createObject(model,giftCache[id][1],giftCache[id][2],giftCache[id][3]-0.6)
                            giftCache[id].dropped = true
                            setElementData(gift,"gift",true);
                            setElementData(gift,"gift:id",id);
                            setElementData(gift,"gift:pickup",false);
                            objectCache[gift] = true;
                            --outputChatBox(id)
                        end
                    else
                        local gift = createObject(model,giftCache[id][1],giftCache[id][2],giftCache[id][3]-0.6)
                        giftCache[id].dropped = true
                        setElementData(gift,"gift",true);
                        setElementData(gift,"gift:id",id);
                        setElementData(gift,"gift:pickup",false);
                        objectCache[gift] = true;
                        --outputChatBox(id)
                    end
                end
                killTimer(respawnTimer[nid]);
            end,5000,1);
            giftCache[getElementData(gift,"gift:id")].dropped = false
            objectCache[gift] = false;
            destroyElement(gift);
        end
    end
end
addEvent("givePlayerGift",true)
addEventHandler("givePlayerGift",getRootElement(),func.giveGift)