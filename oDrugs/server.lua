local conn = exports.oMysql:getDBConnection()

-- farm
drugFarms = {
    --[[[1] = { -- interiorID
        ["owner"] = 1, -- owner char id
        ["plants"] = { -- plants 
            {
                ["placeID"] = 1, -- place
                ["type"] = 1, -- tipus
                ["waterLevel"] = 0, -- víz
                ["qualityLevel"] = 0, -- minőség
                ["growthLevel"] = 0, -- növekedés
            },
        },
        ["roles"] = {
            [1] = { -- char id
                ["name"] = "Carlos White", -- név
                ["plant"] = true, -- ültetés
                ["harvest"] = true, -- aratás
                ["open"] = true, -- nyitás/zárás
                ["machine_fix"] = true, -- gépek szerelése
                ["craft"] = true, -- csomagolás, kraftolás
            },
        },
        ["upgradedInterior"] = true,
    },]]
}

function loadFarmDatas()
    query = dbQuery(conn, 'SELECT * FROM drug_farms')
    result = dbPoll(query, 255)

    local Thread = newThread("loadfarms", 100, 500)
    if result then 
        Thread:foreach(result, function(row) 
            local farmid = row["intID"]
            local owner = row["owner"]
            local plants = fromJSON(row["plants"])
            local roles = fromJSON(row["roles"])
            local upgraded = row["upgradedInterior"]

            if upgraded == 0 then 
                upgraded = false
            else
                upgraded = true
            end

            drugFarms[farmid] = {
                ["owner"] = owner,
                ["plants"] = plants,
                ["roles"] = roles,
                ["upgradedInterior"] = upgraded,
            }
        end)
    end
end
addEventHandler("onResourceStart", resourceRoot, loadFarmDatas)


addEvent("drugFarm > getFarmDatas", true)
addEventHandler("drugFarm > getFarmDatas", resourceRoot, function(drugFarmID, spec)
    if drugFarms[drugFarmID] then
        if not spec then 
            triggerClientEvent(getRootElement(), "drugfarm > sendFarmDatas > active", client, drugFarms[drugFarmID])
        else
            if drugFarms[drugFarmID][spec] then
                triggerClientEvent(getRootElement(), "drugfarm > sendFarmDatas", client, drugFarms[drugFarmID][spec])
            end
        end
    end
end)

function createDrugFarmDatas(id)
    drugFarms[id] = {
        ["owner"] = 0,
        ["plants"] = {},
        ["roles"] = {},
        ["upgradedInterior"] = false,
        ["activeOrder"] = {
            ["packed"] = false, 
            ["items"] = {
                -- itemid, count, completed
                {218, 3, false},
                {219, 1, false},
                {220, 5, false},
                {221, 2, false},
            },
        },
        ["illegalFaction"] = false,
    }

    dbExec(conn, "INSERT INTO drug_farms SET intID=?, owner=?, plants=?, roles=?, upgradedInterior=?", id, 0, toJSON({}), toJSON({}), 0)
end

-------

drogDealer = false 

function createDrugDealer()
    if isElement(drogDealer) then destroyElement(drogDealer) end 
    
    local randomPos = math.random(#ped_posok)

    drogDealer = createPed(drugPedSkins[math.random(#drugPedSkins)], unpack(ped_posok[randomPos]))
    setElementData(drogDealer, "ped:name", core:createRandomName("boy"))
    setElementData(drogDealer, "isDrugPed", true)
    setElementFrozen(drogDealer, true)

   --createBlipAttachedTo(drogDealer, 1)
end
createDrugDealer()
setTimer(createDrugDealer, core:minToMilisec(360), 0)


addEvent("drug > addArmor", true)
addEventHandler("drug > addArmor", resourceRoot, function(level)
    setElementData(client, "char:armor", math.min(level, 100))
    setPedArmor(client, level)
    setElementHealth(client, getElementHealth(client) - level/5)
end)

local _createObject = createObject 

local function createObject(model, x, y, z, rotX, rotY, rotZ, dim, int)
    local object = _createObject(model, x, y, z, rotX, rotY, rotZ)
    setElementDimension(object, dim)
    setElementInterior(object, int)
    setElementDoubleSided(object, true)

    return object
end

local createdPots = {}

function createDrugPot(x, y, z, dim, int)
    local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO pots SET pos=?, plant=?", toJSON({x, y, z, dim, int}), toJSON({0, 0, 0, 0})), 250)

    if tonumber(insertID) then 
        createDrugPot2(x, y, z, dim, int, insertID)
    end
end

function createDrugPot2(x, y, z, dim, int, id, plant)
    id = id or 0 

    local object = createObject(2203, x, y, z, _, _, _, dim, int)

    if plant then 
        createDrugShrub(x, y, z, dim, int, plant, object)
    end

    setElementData(object, "isPlantPot", true)
    setElementData(object, "pot:id", id)

    createdPots[object] = object
end

--[[function loadPots()
    query = dbQuery(conn, 'SELECT * FROM pots')
    result = dbPoll(query, 255)

    local Thread = newThread("loaddrugs", 1000, 5000)
    if result then 
        local tick = getTickCount()
        local loadedPlants = 0

        Thread:foreach(result, function(row) 
            local x, y, z, dim, int = unpack(fromJSON(row["pos"]))
            local plant = fromJSON(row["plant"])

            if plant[1] > 0 then 
                createDrugPot2(x, y, z, dim, int, row["id"], plant)
            else
                createDrugPot2(x, y, z, dim, int, row["id"])
            end
            loadedPlants = loadedPlants + 1
        end, function()
            outputDebugString("[DRUGS]: "..loadedPlants.." pot loaded in "..(getTickCount()-tick).."ms!")
        end)
    end
end
setTimer(loadPots, 500, 1)]]

function plantDrugShrub(obj, plantID)
    local x, y, z = getElementPosition(obj)
    local dim, int = getElementDimension(obj), getElementInterior(obj)
    createDrugShrub(x, y, z, dim, int, {plantID, 0, 1, 1}, obj)
end
addEvent("drugs > plantDrugShrub", true)
addEventHandler("drugs > plantDrugShrub", root, plantDrugShrub)

function createDrugShrub(x, y, z, dim, int, plant, object)
    local plantOBJ = createObject(drugPlants[plant[1]].model, x, y, z-0.2, _, _, _, dim, int)

    setElementCollisionsEnabled(plantOBJ, false)
    setElementDoubleSided(plantOBJ, true)

    setElementData(object, "pot:plant", plantOBJ)
    setElementData(object, "pot:plantID", plant[1])
    setElementData(object, "pot:plant:growLevel", plant[2])
    setElementData(object, "pot:plant:waterLevel", plant[3])
    setElementData(object, "pot:plant:qualityLevel", plant[4])
    setObjectScale(plantOBJ, (plant[2] or 0))
end

function savePlants()
    for k, v in pairs(createdPots) do 
        if isElement(v) then 
            local id = getElementData(v, "pot:id")

            if id > 0 then 
                if getElementData(v, "pot:plant") then 
                    dbExec(conn, "UPDATE pots SET plant=? WHERE id=?", toJSON({getElementData(v, "pot:plantID"), getElementData(v, "pot:plant:growLevel"), getElementData(v, "pot:plant:waterLevel"), getElementData(v, "pot:plant:qualityLevel")}), id)
                else
                    dbExec(conn, "UPDATE pots SET plant=? WHERE id=?", toJSON({0, 0, 0, 0}), id)
                end
            end
        end
    end
end
--addEventHandler("onResourceStop", resourceRoot, savePlants)

--setTimer(savePlants, exports.oCore:minToMilisec(60), 0)

function destroyPlant(potObj)
    local plant = getElementData(potObj, "pot:plant") or false
    if not plant then return false end 
    destroyElement(plant)

    setElementData(potObj, "pot:plant", false) 
    setElementData(potObj, "pot:plantID", 0)
    setElementData(potObj, "pot:plant:growLevel", 0)
    setElementData(potObj, "pot:plant:waterLevel", 0)
    setElementData(potObj, "pot:plant:qualityLevel", 0)
end
addEvent("drugs > destroyPlant", true)
addEventHandler("drugs > destroyPlant", resourceRoot, destroyPlant)

function delOnePot(obj)
    local plant = getElementData(obj, "pot:plant")
    if isElement(plant) then
        destroyElement(plant)
    end 

    local id = getElementData(obj, "pot:id")
    createdPots[obj] = false 
    destroyElement(obj)

    dbExec(conn, "DELETE FROM pots WHERE id=?", id)
end
addEvent("drugs > destroyPot", true)
addEventHandler("drugs > destroyPot", root, delOnePot)

--[[local updateMultiplier = exports.oCore:minToMilisec(40) -- milisec
setTimer(function()
    local Thread = newThread("updateDrogs", 500, 1000)
    Thread:foreach(createdPots, function(v) 
        local plant = getElementData(v, "pot:plant") 
        if plant then 
            local growLevel = getElementData(v, "pot:plant:growLevel")
            local waterLevel = getElementData(v, "pot:plant:waterLevel")
            local qualityLevel = getElementData(v, "pot:plant:qualityLevel")

            if waterLevel > 0.02 then 
                setElementData(v, "pot:plant:waterLevel", waterLevel-0.02)
            end

            if qualityLevel > 0 then 
                if waterLevel < 0.45 then
                    setElementData(v, "pot:plant:qualityLevel", qualityLevel-0.01)
                end 
            end

            if growLevel < 1 then 
                if waterLevel > 0.4 then 
                    setElementData(v, "pot:plant:growLevel", math.min((getElementData(v, "pot:plant:growLevel")+0.015), 1))

                    if getElementModel(plant) == 824 then 
                        setObjectScale(plant, 0.002*(growLevel+0.01))
                    else
                        setObjectScale(plant, 0.8*(growLevel+0.01))
                    end

                    local posX, posY, posZ = getElementPosition(plant)

                    moveObject(plant, updateMultiplier, posX, posY, posZ+0.0025, 0, 0, 0, "Linear")
                end
            end
        end
    end)
end, updateMultiplier, 0)]]

-- Craft -- 
local craftingTables = {}

function createDrugCraftTable2(x, y, z, rot, dim, int, id, items)
    local table = createObject(2132, x, y, z, 0, 0, rot, dim, int)
    setElementData(table, "drug:isDrugCraftTable", true)
    setElementData(table, "drug:craft:tableItems", items)
    setElementData(table, "drug:craftTableID", id)

    craftingTables[id] = table
end

function createDrugCraftTable(x, y, z, rot, dim, int)
    local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO craftingTabels SET pos=?, items=?", toJSON({x, y, z, rot, dim, int}), toJSON({})), 250)

    if tonumber(insertID) then 
        createDrugCraftTable2(x, y, z, rot, dim, int, insertID, {})
        return insertID
    end
end

addCommandHandler("createcrafting", function(player, cmd)
    if getElementData(player, "user:admin") >= 7 then 
        local x, y, z = getElementPosition(player)
        local dim, int = getElementDimension(player), getElementInterior(player)
        local _, _, rotZ = getElementRotation(player)

        local id = createDrugCraftTable(x, y, z-1, rotZ, dim, int) or "0"

        triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "létrehozott egy drogkészítő asztalt. #db3535(#"..id..")", 8)
    end
end)

addCommandHandler("delcrafting", function(player, cmd, id)
    if getElementData(player, "user:admin") >= 7 then 
        if not id then 
            outputChatBox(core:getServerPrefix("red-dark", "Használat", 3).."/"..cmd.." [ID]", player, 255, 255, 255, true)
        else
            id = tonumber(id)

            if craftingTables[id] then 
                destroyElement(craftingTables[id])
                craftingTables[id] = false 

                triggerClientEvent("sendMessageToAdmins", getRootElement(), player, "törölte a(z) #db3535"..id.." #557ec9ID-vel rendelkező drogkészítő asztalt.", 8)
                dbExec(conn, "DELETE FROM craftingTabels WHERE id=?", id)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Hiba", 3).."Nincs ilyen ID-vel rendelkező drogkészítő asztal!", player, 255, 255, 255, true)
            end
        end
    end
end)

function loadCraftings()
    query = dbQuery(conn, 'SELECT * FROM craftingTabels')
    result = dbPoll(query, 255)

    if result then 
        for k, v in pairs(result) do 
            local x, y, z, rot, dim, int = unpack(fromJSON(v["pos"]))
            local items = fromJSON(v["items"])

            createDrugCraftTable2(x, y, z, rot, dim, int, v["id"], items)
        end
    end
end
setTimer(loadCraftings, 500, 1)

function saveTabels()
    for k, v in pairs(craftingTables) do 
        if isElement(v) then 
            if k > 0 then 
                dbExec(conn, "UPDATE craftingTabels SET items=? WHERE id=?", toJSON(getElementData(v, "drug:craft:tableItems")), k)
            end
        end
    end
end
addEventHandler("onResourceStop", resourceRoot, saveTabels)

addEvent("drugs > buyDrugFromPed", true)
addEventHandler("drugs > buyDrugFromPed", resourceRoot, function(itemID, price)
    setElementData(client, "char:money", getElementData(client, "char:money") - price)
    inventory:giveItem(client, itemID, 1, 1, 0)
end)

addEvent("drug > setPedAnimationServer", true)
addEventHandler("drug > setPedAnimationServer", resourceRoot, function(group, anim)
    setPedAnimation(client, group, anim, -1, true, false, false)
end)
-----------