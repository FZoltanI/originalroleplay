savedGarages = {}
vehicleCols = {}
carCols = {}

-- Current bids --
-- Létrehozás, szinkronizáció 
local spawnChances = {} -- NE ÍRJ BELE SEMMIT

for k, v in ipairs(generatePositions) do
    for i = 1, v.chance do 
        table.insert(spawnChances, k)
    end
end

function mixSpawnChances()
    local oldTable = spawnChances
    local newMixedTable = {}

    for i = 1, #spawnChances do 
        local random = math.random(#oldTable)

        table.insert(newMixedTable, oldTable[random])
        table.remove(oldTable, random)
    end

    spawnChances = newMixedTable
end

local currentBids = {}

function createNewBid()
    if #currentBids < 10 then
        local hour = core:getDate("hour")
        hour = tonumber(hour)
        if (hour >= openTime and hour < closeTime) then 
            mixSpawnChances()

            local randomStorage = spawnChances[math.random(#spawnChances)]
            local randomPrice = math.random(generatePositions[randomStorage].priceRange[1], generatePositions[randomStorage].priceRange[2])
            -- Garage #[n randomStorage * 3 n n n n]
            table.insert(currentBids, {"Garage #"..math.random(1, 9) .. (randomStorage * 3) .. math.random(1000, 9999), randomPrice, randomStorage})
            syncStoragesForEveryone()
        else 
            currentBids = {}
        end
    end
end


setTimer(createNewBid, core:minToMilisec(7), 0) -- hány percenként legyen új garázs

function syncStoragesForEveryone()
    for k, v in ipairs(getElementsByType("player")) do 
        if getElementDimension(v) == 0 then 
            triggerClientEvent(v, "garageBid > sendCurrentBidsToClient", v, currentBids)
        end
    end
end

addEvent("garageBid > getCurrentBidsFromServer", true)
addEventHandler("garageBid > getCurrentBidsFromServer", resourceRoot, function()
    triggerClientEvent(client, "garageBid > sendCurrentBidsToClient", client, currentBids)
end)

addEvent("garageBid > removeSelectedBid", true)
addEventHandler("garageBid > removeSelectedBid", resourceRoot, function(bid)
    table.remove(currentBids, bid)
    syncStoragesForEveryone()
end)

setTimer(createNewBid, 1000, 1) -- Egy darab létrehozása kezdésnek
---------------

for k, v in ipairs(carColPositions) do 
    local col = createColCuboid(v[1], v[2], v[3] - 0.1, v[4], v[5], 5)
    table.insert(carCols, col)
end

function updateSavedGarages(owner, currentElements)
    --print(owner, toJSON(currentElements))
    table.insert(savedGarages, {owner, currentElements})
    syncGarages()
end

addEvent("garageBid > buyGarage", true)
addEventHandler("garageBid > buyGarage", resourceRoot, function(money, loot, color)
    --print("s", toJSON(color))


    setElementData(client, "char:money", getElementData(client, "char:money") - money)
    
    --print(loot)
    local objects = {}

    for k, v in pairs(generatePositions[loot]) do 
        if (tonumber(k)) then 
            if type(v[1]) == "table" then 
                v[1] = v[1][math.random(#v[1])]
                v[4] = v[4] + (adjustZPositions[v[1]] or 0)
            end

            if v[1] > 0 then
                table.insert(objects, v)
            end
        end
    end

    if color then 
        for k, v in ipairs(objects) do 
            if v[8] then 
                objects[k][10] = color
            end
        end
    end

    updateSavedGarages(getElementData(client, "char:id"), objects)
end)

addEvent("garageBid > sellGarage", true)
addEventHandler("garageBid > sellGarage", resourceRoot, function(ownerID, money)
    for k, v in ipairs(savedGarages) do 
        if v[1] == ownerID then 
            table.remove(savedGarages, k)
            break 
        end
    end

    syncGarages()

    setElementData(client, "char:money", getElementData(client, "char:money") + money)
end)

addEvent("garageBid > sellGarage > giveCar", true)
addEventHandler("garageBid > sellGarage > giveCar", resourceRoot, function(carDatas)
    local randomPos = carCreatePositions[math.random(#carCreatePositions)]
    local veh = exports.oVehicle:createNewVehicle(carDatas[1], client, randomPos, {0, 0, 0}, carDatas[10])
    setElementData(veh, "veh:paintjob", carDatas[9])

    local owner = client
    setTimer(function()
        exports.oInventory:giveItem(owner, 51, getElementData(veh, "veh:id"), 1, 0)
    end,100,1)

    warpPedIntoVehicle(client, veh)
end)

addEvent("garageBid > removeObjectFromSave", true)
addEventHandler("garageBid > removeObjectFromSave", root, function(charID, removeID)
    --print(charID, removeID)
    for k, v in ipairs(savedGarages) do 
        if v[1] == charID then 
            savedGarages[k][2][removeID] = false
            break 
        end
    end

    syncGarages()
end)

function searchForTransporterCar(owner)
    local ownerId = getElementData(owner, "char:id")
    local vehicle = false 
    for k, v in ipairs(carCols) do 
        local elements = getElementsWithinColShape(v, "vehicle")
        for k2, v2 in ipairs(elements) do 
            if (getElementData(v2, "veh:owner") == ownerId) then 
                if allowedVehiclesForTransport[getElementModel(v2)] then 
                    local itemsTable = getElementData(v2, "veh:garageBid:items") or {}
                    if #itemsTable == 0 then 
                        vehicle = v2 
                        break 
                    end
                end
            end
        end 
    end

    return vehicle
end 

addEvent("garageBid > getTransporterCar", true)
addEventHandler("garageBid > getTransporterCar", resourceRoot, function()
    triggerClientEvent(client, "garageBid > returnTransporterCar", client, searchForTransporterCar(client))
end)

addCommandHandler("checkcars", function(player)
    searchForTransporterCar(player)
end)

addEventHandler("onResourceStop", resourceRoot, function()
    exports.oJSON:saveDataToJSONFile(savedGarages, "savedGarages", true)
end)

addEventHandler("onResourceStart", resourceRoot, function()
    savedGarages = exports.oJSON:loadDataFromJSONFile( "savedGarages", true)
    syncGarages()
end)

function syncGarages()
    setElementData(resourceRoot, "garageBid:savedGarages", savedGarages)
end

setTimer(function()
    syncGarages()
end, core:minToMilisec(2), 0)