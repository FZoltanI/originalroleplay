local treasureCache = {}

function createRandomTreasure()
    if #treasureCache <= 1 then 
        treasureCache = {
            {2937.9458007813, -660.92889404297, 4.6588802337646},
            {2879.7021484375, -220.3514251709, 3.8567895889282},
            {2896.5710449219, -1867.1005859375, 3.0707206726074},
            {2880.4138183594, -1861.8361816406, 4.8193130493164},
            {2878.640625, -1873.4324951172, 6.5424041748047},
            {2899.8627929688, -2030.2155761719, 3.3078124523163},
            {2884.078125, -2150.8911132813, 4.0321054458618},
            {2859.9279785156, -2186.8078613281, 3.6831948757172},
            {2774.6137695313, -2237.8010253906, 4.9477653503418},
            {1260.8682861328, -2564.3552246094, 2.2349879741669},
            {1428.5639648438, -2763.6291503906, 2.4494738578796},
            {1593.5040283203, -2765.0690917969, 2.3283743858337},
            {1869.9204101563, -2766.4670410156, 2.0007145404816},
            {2103.0561523438, -2758.9677734375, 2.6584711074829},
            {2202.8662109375, -2709.9072265625, 1.6126554012299},
            {972.70263671875, -2082.0119628906, 2.2381987571716},
            {856.00415039063, -1889.5161132813, 1.671226978302},
            {742.37518310547, -1896.150390625, 1.5483877658844},
            {703.81494140625, -1913.5295410156, 2.0288162231445},
            {549.37786865234, -1907.2232666016, 1.2638250589371},
            {410.71618652344, -1895.197265625, 1.6224926710129},
            {289.50405883789, -1895.0350341797, 1.4079744815826},
            {173.32745361328, -1886.6068115234, 1.2311792373657},

            {-109.62484741211, -775.6748046875, 1.5876216888428},
            {-69.259704589844, -575.24060058594, 1.8076934814453},
            {-38.175827026367, -550.45678710938, 2.9296779632568},
            {-771.03839111328, 218.19604492188, 1.2474012374878},
            {-718.86938476563, 258.3151550293, 1.3867235183716},
            {-658.26397705078, 283.09945678711, 1.4967231750488},
            {-613.53503417969, 296.4690246582, 1.2934217453003},
            {-414.20281982422, 299.49700927734, 1.3542776107788},
            {380.74270629883, 222.43988037109, 1.1104459762573},
            {2161.6889648438, -121.00260162354, 1.431227684021},
        }
    end

    local randomPos = math.random(#treasureCache)
    local posX, posY, posZ = unpack(treasureCache[randomPos])
    table.remove(treasureCache, randomPos)

    local mound = createObject(moundModelID, posX, posY, posZ - 4)
    local box = createObject(boxModelID, posX, posY, posZ - 0.9, math.random(0, 360), math.random(0, 360), math.random(0, 360))
    setElementData(box, "treasureHunt:defPos", treasureCache[randomPos])
    setElementDoubleSided(box, true)
    setElementData(box, "isActiveTreasureHuntBox", true)
    setElementData(box, "treasureHunt:mound", mound)

    local col = createColTube(posX, posY, posZ - 1.2, 2, 3)
    setElementData(col, "treasureHunt:box", box)

    return {mound, box}
end

function digTreasure(mound, box, col)
    local player = client 

    local x, y, z = getElementPosition(mound)

    moveObject(mound, digTime, x, y, z - 0.4)

    setElementFrozen(player, true)

    destroyElement(col)

    setPedAnimation(player, "rob_bank", "cat_safe_rob", -1, true, false, false)

    setTimer(function()
        local defPos = getElementData(box, "treasureHunt:defPos")

        destroyElement(box)
        destroyElement(mound)
        setElementFrozen(player, false)
        setPedAnimation(player, "", "")

        setTimer(function()
            createRandomTreasure()
        end, core:minToMilisec(15), 1)

        table.insert(treasureCache, defPos)

        local randomNum = math.random(0, 100)
        for k, v in ipairs(chances) do 
            if randomNum >= v.min and randomNum <= v.max then 
                if v.item == 0 then
                    chat:sendLocalDoAction(player, "nem talált semmit a ládában.")
                else
                    chat:sendLocalDoAction(player, "a talált tárgy egy "..inventory:getItemName(v.item)..".")

                    if (inventory:getElementItemsWeight(player) + inventory:getItemWeight(v.item)) < 20 then 
                        outputChatBox(core:getServerPrefix("green-dark", "Kincsesláda", 2).."A kincsesláda tartalma egy "..color..inventory:getItemName(v.item).." #ffffffvolt.", player, 255, 255, 255, true)
                        inventory:giveItem(player, v.item, 1, 1, 0)
                    else
                        outputChatBox(core:getServerPrefix("red-dark", "Kincsesláda", 2).."Mivel nincs elegendő hely az inventorydban így nem kaptál semmit!", player, 255, 255, 255, true)
                    end
                end

                break
            end
        end
    end, digTime, 1)
end

addEvent("treasureHunt > startTreasureDig", true)
addEventHandler("treasureHunt > startTreasureDig", resourceRoot, digTreasure)
 
for i = 1, 4 do 
    createRandomTreasure()
end

function createShops()
    local jewstroy = createPed(jewelryStorePed[1], jewelryStorePed[2], jewelryStorePed[3], jewelryStorePed[4], jewelryStorePed[5])
    setElementData(jewstroy, "ped:name", "Frank")
    setElementData(jewstroy, "ped:prefix", "Drágakő kereskedő")
    setElementData(jewstroy, "treasureHunt:jewelryStore", true)
    setElementInterior(jewstroy, jewelryStorePed[6])
    setElementDimension(jewstroy, jewelryStorePed[7])
    setElementFrozen(jewstroy, true)

    local antiqueStore = createPed(antiqueStorePed[1], antiqueStorePed[2], antiqueStorePed[3], antiqueStorePed[4], antiqueStorePed[5])
    setElementData(antiqueStore, "ped:name", "Joseph")
    setElementData(antiqueStore, "ped:prefix", "Régiség kereskedő")
    setElementData(antiqueStore, "treasureHunt:antiqueStore", true)
    setElementInterior(antiqueStore, antiqueStorePed[6])
    setElementDimension(antiqueStore, antiqueStorePed[7])
    setElementFrozen(antiqueStore, true)

     local jew2store = createPed(jew2ped[1], jew2ped[2], jew2ped[3], jew2ped[4], jew2ped[5])
    setElementData(jew2store, "ped:name", "Peter")
    setElementData(jew2store, "ped:prefix", "Drágakő szakértő")
    setElementData(jew2store, "treasureHunt:jew", true)
    setElementInterior(jew2store, jew2ped[6])
    setElementDimension(jew2store, jew2ped[7])
    setElementFrozen(jew2store, true)

end
createShops()

addEvent("treasure > sellItem", true)
addEventHandler("treasure > sellItem", resourceRoot, function(money, slot, type, itemid)
    setElementData(client, "char:money", getElementData(client, "char:money")+money)
    if type == "antique" then 
        outputChatBox(core:getServerPrefix("green-dark", "Régiség kereskedő", 2).."Sikeres eladás! Összeg: "..money.."$", client, 255, 255, 255, true)
    elseif type == "jewelry" then 
        outputChatBox(core:getServerPrefix("green-dark", "Drágakő kereskedő", 2).."Sikeres eladás! Összeg: "..money.."$", client, 255, 255, 255, true)
    end
end)


-- Árváltozás, drágakő
function showCount()
    local amount = math.random(1000,3000)
    outputChatBox("[originalRoleplay - Drágakő kereskedő]: #ffffffA drágakövek grammonkénti ára megváltozott, #7cc576"..amount.."$#ffffff/g árra!", getRootElement(), r, g, b, true)
    setElementData(resourceRoot,"jewelryCount", amount)
end

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
    function ()
        showCount()
        setTimer(showCount, 1000000, 0)
    end
)
