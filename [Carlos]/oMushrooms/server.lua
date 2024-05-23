local mushroomPositionsServer = {}

local availablePositions = {}

function loadAllPostions()
    availablePositions = {}
    for k, v in ipairs(mushroomPositions) do 
        for k2, v2 in ipairs(fromJSON(v)) do 
            table.insert(availablePositions, v2)
        end
    end

    print(#availablePositions .. " mushroom position loaded")
end
loadAllPostions()

function createOneMushroom()
    local randType = randomTypeSelect[math.random(#randomTypeSelect)]

    local randpos = math.random(#availablePositions)
    local x, y, z = unpack(availablePositions[randpos])
    table.remove(availablePositions, randpos)

    if #availablePositions == 0 then 
        loadAllPostions()
    end
   
    local obj = createObject(mushroom_types[randType].modelID, x, y, z)
    setElementDoubleSided(obj, true)
    setElementRotation(obj, 90, 0, 0)
    setElementCollisionsEnabled(obj, false)

    local col = createColSphere(x, y, z, 1.6)
    setElementData(col, "mushroom:object", obj)
    setElementData(col, "mushroom:type", randType)
end


function createMushrooms()
    local count = math.floor(#availablePositions / 5)
    print(count .. " mushroom created")
    for i = 1, count do 
        createOneMushroom()
    end
end

addEventHandler("onResourceStart", resourceRoot, function() 
    mushroomPositionsServer = mushroomPositions
    createMushrooms()
end)

addEvent("mushroom > startPickup", true)
addEventHandler("mushroom > startPickup", resourceRoot, function(col)
    destroyElement(col)
end)

addEvent("mushroom > setAnimation", true)
addEventHandler("mushroom > setAnimation", resourceRoot, function(group, name)
    setPedAnimation(client, group, name)
end)    

addEvent("mushroom > endMushroomPickup", true)
addEventHandler("mushroom > endMushroomPickup", resourceRoot, function(obj, type, position, giveitem)
    setPedAnimation(client, "", "")

    local x, y, z = unpack(position)
    z = z + 1

    table.insert(mushroomPositionsServer, Vector3(x, y, z))

    destroyElement(obj)

    if giveitem then
        if exports.oInventory:getElementItemsWeight(client) + exports.oInventory:getItemWeight(mushroom_types[type].item) < 20 then 
            exports.oInventory:giveItem(client, mushroom_types[type].item, 1, 1, 0)
        end
    end

    setTimer(function()
        createOneMushroom()
    end, core:minToMilisec(math.random(25, 50)), 1)
end)    