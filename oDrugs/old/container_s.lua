local conn = exports.oMysql:getDBConnection()
local interiors = exports.oInteriors

local pendingContainers = {}

function createContainer(id, attachedInteriorID, pos)
    local object = createObject(pos[5], pos[1], pos[2], pos[3], 0, 0, pos[4])
    setElementData(object, "drug:container:id", id)
    setElementData(object, "drug:container:attachedInt", attachedInteriorID)
    return object
end

function loadContainers()
    query = dbQuery(conn, 'SELECT * FROM drug_containers')
    result = dbPoll(query, 255)

    local Thread = newThread("loadcontainers", 100, 500)
    if result then 
        local tick = getTickCount()
        local loadedContainers = 0

        Thread:foreach(result, function(row) 
            local pos = fromJSON(row["pos"])
            local attached_interior = row["attached_interior"]

            createContainer(row["id"], attached_interior, pos)
            loadedContainers = loadedContainers + 1
        end, function()
            outputDebugString("[DRUGS]: "..loadedContainers.." container loaded in "..(getTickCount()-tick).."ms!")
        end)
    end
end
addEventHandler("onResourceStart", resourceRoot, loadContainers)

addCommandHandler("createdrugcontainer", function(player, cmd)
    if getElementData(player, "user:admin") >= 10 then 
        local x, y, z = getElementPosition(player)
        local rx, ry, rz = getElementRotation(player)
        local modelID = containerObjects[math.random(#containerObjects)]

        z = z + 0.4

        local insertResult, _, insertID = dbPoll(dbQuery(conn, "INSERT INTO drug_containers SET pos=?, attached_interior=?", toJSON({x, y, z, rz, modelID}), 0), 250)

        if tonumber(insertID) then 
            createdContainer = createContainer(insertID, 0, {x, y, z, rz, modelID})
        end

        local object = createObject(modelID, x, y, z, 0, 0, rz)
        local marker = createMarker(x, y, z, "cylinder", 1.0)
        attachElements(marker, object, 0, 4.5, -0.7)
        local markerx, markery, markerz = getElementPosition(marker)
        destroyElement(object)
        destroyElement(marker)

        interiors:createInteriorExport(140, 5, 10000, 0, "Konténer - "..insertID, markerx, markery, markerz, 0, 0)
        pendingContainers[markerx + markery + markerz] = createdContainer
    end
end)

addEvent("attachInteriorWithContainer", true)
addEventHandler("attachInteriorWithContainer", root, function(pos, intid)
    local pendingTEMP = pos[1] + pos[2] + pos[3]
    if pendingContainers[pendingTEMP] then 
        local id = getElementData(pendingContainers[pendingTEMP], "drug:container:id")
        setElementData(pendingContainers[pendingTEMP], "drug:container:attachedInt", intid)
        pendingContainers[pendingTEMP] = false
        createDrugFarmDatas(intid)
        dbExec(conn, 'UPDATE drug_containers SET attached_interior=? WHERE id=?', intid, id)
    end
end)