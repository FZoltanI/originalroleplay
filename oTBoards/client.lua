exports.oCompiler:loadCompliedModel(1375, "uf9An#-D&!X$hvsm", ":oTBoards/files/ktdff.originalmodel", ":oTBoards/files/kttxd.originalmodel", ":oTBoards/files/ktcol.originalmodel", false)

local white = "#ffffff"
local objectCache = {}
local elements = {}
local elementShaders = {}
local elementTextures = {}

local core = exports.oCore
local eEditor = exports.oElementEditor

function syncModel(e)    
    if not objectCache[e] and e:getData("TrafficBoards.id") then
        local id = e:getData("TrafficBoards.id")
        local type = e:getData("TrafficBoards.type")
        objectCache[e] = id
		elementShaders[e] = dxCreateShader("files/shader.fx")
        if not elements[type] then
            elements[type] = dxCreateTexture("files/textures/" .. type .. ".png")
        end
        elementTextures[e] = elements[type]
		dxSetShaderValue(elementShaders[e], "gTexture", elementTextures[e])
		engineApplyShaderToWorldTexture(elementShaders[e], "tabla", e)
    end
end

addEventHandler("onClientElementStreamIn", resourceRoot,
    function()
        syncModel(source)
    end
)

local timers = {}
local timers2 = {}
addEventHandler("onClientObjectDamage", root,
    function()
        local source = source
        if objectCache[source] then
            local data = source:getData("defPositions")

            if source.position ~= Vector3(data.x, data.y, data.z) or source.health <= 0 then
                if not timers[source] then
                    if not timers2[source] then
                        timers2[source] = setTimer(
                            function()
                                setElementPosition(source, data.x,data.y,data.z - 100)
                                source.frozen = true
                                timers[source] = setTimer(respawnTable, 2 * 60 * 1000, 1, source)
                            end, 30 * 1000, 1
                        )
                    end
                end
            end
        end
    end
)

function respawnTable(e)
    if objectCache[e] then
        local data = e:getData("defPositions")
        if data then
            local x,y,z = data.x, data.y, data.z
            e.position = Vector3(x,y,z)
            e.frozen = false
        end
    end
end

local maxDistNearby = 18
function getNearbyTrafficBoards(cmd)
    if getElementData(localPlayer, "user:admin") > 7 then
        local target = false
        local px, py, pz = getElementPosition(localPlayer)
        local green = core:getServerColor()
        local syntax = core:getServerPrefix("server", "orange", 1)
        local hasVeh = false
        for k,v in pairs(getElementsByType("object", root, true)) do
            local x,y,z = getElementPosition(v)
            local dist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
            if dist <= maxDistNearby then
                local id = getElementData(v, "TrafficBoards.id") or 0
                if id > 0 then
                    local model = getElementModel(v)
                    local type = getElementData(v, "TrafficBoards.type") or 0
                    outputChatBox(syntax.."Model: "..green..model..white..", ID: "..green..id..white..", Típus: "..green..type..white..", Távolság: "..green..math.floor(dist)..white.." yard", 255,255,255,true)
                    hasVeh = true
                end
            end
        end
        if not hasVeh then
            local green = core:getServerColor()
            local syntax = core:getServerPrefix("server", "orange", 1)
            outputChatBox(syntax .. "Nincs TrafficBoards a közeledben!", 255,255,255,true)
        end
    end
end
addCommandHandler("getntb", getNearbyTrafficBoards)

function createTrafficBoard(cmd, type)
    if not type then
        local syntax = core:getServerPrefix("server", "orange", 1)
        outputChatBox(syntax .. "/"..cmd.." [Típus]", 255,255,255,true)
        return
    elseif tonumber(type) == nil then
        local syntax = core:getServerPrefix("server", "orange", 1)
        outputChatBox(syntax .. "A típusnak egy számnak kell lennie!", 255,255,255,true)
        return    
    elseif inSpeedCamCreating then
        local syntax = core:getServerPrefix("server", "orange", 1)
        outputChatBox(syntax .. "Egyszerre csak 1 táblát hozhatsz létre!", 255,255,255,true)
        return 
    end
    
    if getElementData(localPlayer, "user:admin") > 7 then
        inSpeedCamCreating = true 
        
        local modelid = 1375
        local x,y,z = getElementPosition(localPlayer)
        z = z + 0.4
        local dim = getElementDimension(localPlayer) 
        local int = getElementInterior(localPlayer)
        local a,a,rotation = getElementRotation(localPlayer)
        obj = createObject(modelid, x,y,z, 0,0, rotation + 180)
        setElementDimension(obj, dim)
        setElementInterior(obj, int)
        obj.collisions = false
        obj:setData("TrafficBoards.id", -1)
        obj:setData("TrafficBoards.type", tonumber(type))
        syncModel(obj)
        
        eEditor:toggleEditor(obj, "onSaveTrafficPositionEditor", "onSaveTrafficDeleteEditor", true)
        
        addCommandHandler("type", changeType)
    end
end
addCommandHandler("createtb", createTrafficBoard)

function changeType(cmd, id)
    if tonumber(id) and isElement(obj) then
        obj:setData("TrafficBoards.type", tonumber(id))
        objectCache[obj] = nil
        destroyElement(elementShaders[obj])
        elementShaders[obj] = nil
        elementTextures[obj] = nil
        syncModel(obj)
    end
end

addEventHandler("onClientElementDestroy", root,
    function()
        local obj = source
        if objectCache[obj] then
            objectCache[obj] = nil
            destroyElement(elementShaders[obj])
            elementShaders[obj] = nil
            elementTextures[obj] = nil
        end
    end
)

addEvent("onSaveTrafficPositionEditor", true)
addEventHandler("onSaveTrafficPositionEditor", localPlayer,
    function(e, x, y, z, rx, ry, rz)
        inSpeedCamCreating = false
        removeCommandHandler("type", changeType)
        
        triggerServerEvent("createTrafficBoards", localPlayer, {x,y,z,e.interior,e.dimension,rz}, e:getData("TrafficBoards.type"), localPlayer)
        
        e:destroy()
    end
)

addEvent("onSaveTrafficDeleteEditor", true)
addEventHandler("onSaveTrafficDeleteEditor", localPlayer,
    function(e, x, y, z, rx, ry, rz)
        inSpeedCamCreating = false
        removeCommandHandler("type", changeType)
        e:destroy()
    end
)

local maxDistNearby = 18
function getNearbyTrafficBoards(cmd)
    if getElementData(localPlayer, "user:admin") > 7 then
        local target = false
        local px, py, pz = getElementPosition(localPlayer)
        local green = exports.oCore:getServerColor() 
        local syntax = core:getServerPrefix("server", "orange", 1)
        local hasVeh = false
        for k,v in pairs(getElementsByType("object", root, true)) do
            local x,y,z = getElementPosition(v)
            local dist = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
            if dist <= maxDistNearby then
                local id = getElementData(v, "TrafficBoards.id") or 0
                if id > 0 then
                    local model = getElementModel(v)
                    local type = getElementData(v, "TrafficBoards.type") or 0
                    outputChatBox(syntax.."Model: "..green..model..white..", ID: "..green..id..white..", Típus: "..green..type..white..", Távolság: "..green..math.floor(dist)..white.." yard", 255,255,255,true)
                    hasVeh = true
                end
            end
        end
        if not hasVeh then
            local green =  exports.oCore:getServerColor() 
            local syntax =  core:getServerPrefix("server", "orange", 1)
            outputChatBox(syntax .. "Nincs TrafficBoards a közeledben!", 255,255,255,true)
        end
    end
end
addCommandHandler("getnearbytbs", getNearbyTrafficBoards)

function delTrafficBoards(cmd, id2)
    if not id2 then
        local syntax = core:getServerPrefix("server", "orange", 1)
        outputChatBox(syntax .. "/"..cmd.." [ID]", 255,255,255,true)
        return
    elseif tonumber(id2) == nil then
        local syntax = core:getServerPrefix("server", "orange", 1)
        outputChatBox(syntax .. "Az IDnek egy számnak kell lennie!", 255,255,255,true)
        return 
    end
    if getElementData(localPlayer, "user:admin") > 7 then
        local target = false
        local px, py, pz = getElementPosition(localPlayer)
        local green =  exports.oCore:getServerColor() 
        local syntax = core:getServerPrefix("server", "orange", 1)
        local hasVeh = false
        for k,v in pairs(getElementsByType("object", root, true)) do
            local id = getElementData(v, "TrafficBoards.id") or 0
            if id == tonumber(id2) then
                target = v
                hasVeh = true
            end
        end
        if hasVeh then
            local green = exports.oCore:getServerColor() 
            local syntax = core:getServerPrefix("server", "orange", 1)
            outputChatBox(syntax .. "Kressztábla (ID: "..green..id2..white..") törölve!", 255,255,255,true)
            triggerServerEvent("deleteTrafficBoards", localPlayer, target)
        end
    end
end
addCommandHandler("deltb", delTrafficBoards)

exports.oAdmin:addAdminCMD("deltb", 8, "Kresztábla törlése")
exports.oAdmin:addAdminCMD("createtb", 8, "Kresztábla létrehozása")
exports.oAdmin:addAdminCMD("getnearbytbs", 8, "Közelben lévő kresztáblák lekérése")