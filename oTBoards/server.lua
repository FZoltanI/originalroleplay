local cache = {}

local connection = exports.oMysql:getDBConnection()

Async:setPriority("high")
Async:setDebug(true)

addEventHandler("onResourceStart", resourceRoot, 
    function()
        dbQuery(function(query)
            local query, query_lines = dbPoll(query, 0)
            if query_lines > 0 then
                Async:foreach(query, function(row)
                    loadSpeedCam(row)
                end) 
            end
			outputDebugString(query_lines .. " db kressztábla betöltése sikeresen megtörtént!")
        end, connection, "SELECT * FROM `trafficboards`")
    end
)

local speedLimits = {
    [4] = 50,
    [5] = 40,
    [6] = 20,
    [7] = 30,
    [8] = 70,
    [9] = 80,
    [10] = 90,
    [11] = 100,
    [12] = 110,
    [13] = 120,
    [14] = 130,
}

function loadSpeedCam(details)
    local id = tonumber(details["id"])
    local type = tonumber(details["type"])
    local pos = fromJSON(tostring(details["pos"]))
    local modelid = 1375
    local x,y,z,int,dim,rot = unpack(pos)
    local object = createObject(modelid, x,y,z)
    setElementDimension(object, dim)
    setElementInterior(object, int)
    setElementRotation(object, 0,0,rot)
    setElementData(object, "TrafficBoards.id", id)
    setElementData(object, "TrafficBoards.type", type)
    setElementData(object, "defPositions", {x = x,y = y,z = z})

    if speedLimits[type] then
        local colshape = createColSphere(x, y, z, 35)
        setElementData(colshape, "TrafficCol:speedlimit",  speedLimits[type])
        setElementData(object, "speedcol", colshape)
    end
end

function createTrafficBoards(table1, type, sourceElement)
    local a1 = toJSON(table1)
    dbExec(connection, "INSERT INTO `trafficboards` SET `pos`=?, `type`=?", a1, type)
    
    dbQuery(function(query)
        local query, query_lines = dbPoll(query, 0)
        if query_lines > 0 then
            Async:foreach(query, function(row)
                local id = tonumber(row["id"])
                local syntax = exports.oCore:getServerPrefix("server", "orange", 1)
                local green = exports.oCore:getServerColor() 
                outputChatBox(syntax .. "Sikeresen létrehoztál egy kressztáblát, #ID: "..green..id, sourceElement, 255,255,255,true)
                loadSpeedCam(row)
            end) 
        end
    end, connection, "SELECT * FROM `trafficboards` WHERE `pos`=?", a1)
end
addEvent("createTrafficBoards", true)
addEventHandler("createTrafficBoards", root, createTrafficBoards)

function deleteTrafficBoards(object)
    local id = getElementData(object, "TrafficBoards.id") or 0
    
    if getElementData(object, "speedcol") then
        destroyElement(getElementData(object, "speedcol"))
    end
    destroyElement(object)
    
    dbExec(connection, "DELETE FROM `trafficboards` WHERE `id`=?", id)
end
addEvent("deleteTrafficBoards", true)
addEventHandler("deleteTrafficBoards", root, deleteTrafficBoards)