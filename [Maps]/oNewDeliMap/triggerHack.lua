--triggerHack:
local cache = {}

function getTriggerName(triggerName)
    return exports['oAntiHook']:getTriggerName(getThisResource(), triggerName)
end

_addEvent = addEvent
function addEvent(eventName, allowRemoteTrigger)
    if not cache[eventName] then
        cache[eventName] = getTriggerName(eventName)
    end 

    eventName = cache[eventName]

    _addEvent(eventName, allowRemoteTrigger)
end

_addEventHandler = addEventHandler
function addEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority, customName)
    --[[
    local nowFunction = function(...)
        if type(triggerClientEvent) == "function" then
            if not client then
                return
            end
        end 
        
        if not source then
            return
        end 

        handlerFunction(...)
    end ]]

    local nowFunction = handlerFunction
    
    if cache[eventName] then
        eventName = getTriggerName(eventName)
    end 

    _addEventHandler(eventName, attachedTo, nowFunction, getPropagated, priority)
end

_removeEventHandler = removeEventHandler
function removeEventHandler(eventName, attachedTo, handlerFunction)
    --[[
    local nowFunction = function(...)
        if type(triggerClientEvent) == "function" then
            if not client then
                return
            end
        end 

        if not source then
            return
        end 

        handlerFunction(...)
    end ]]

    local nowFunction = handlerFunction
    
    if cache[eventName] then
        eventName = getTriggerName(eventName)
        cache[eventName] = nil
    end
    
    _removeEventHandler(eventName, attachedTo, nowFunction)
end

_triggerEvent = triggerEvent
function triggerEvent(eventName, ...)
    eventName = getTriggerName(eventName)
    _triggerEvent(eventName, ...)
end

if type(triggerServerEvent) == "function" then
    _triggerServerEvent = triggerServerEvent
    function triggerServerEvent(eventName, ...)
        eventName = getTriggerName(eventName)
        _triggerServerEvent(eventName, ...)
    end
end

if type(triggerClientEvent) == "function" then
    _triggerClientEvent = triggerClientEvent
    function triggerClientEvent(sourceElement, eventName, ...)
        eventName = getTriggerName(eventName)
        _triggerClientEvent(sourceElement, eventName, ...)
    end
end

--[[(function ()
    local _exports = exports

    local mt = {}
    mt.__index = function (table, key)
        if type(key ~= "string") then
            return _exports[key]
        else
            return _exports[md5(key)]
        end
    end

    exports = {}
    setmetatable(exports, mt)

    local _getResourceFromName = getResourceFromName
    getResourceFromName = function (name, ...)
        return _getResourceFromName(md5(name), ...)
    end
end)();--]]


--elementdata
if type(triggerServerEvent) == "function" then
    local eCache = {}
    _setElementData = setElementData
    function setElementData(e, dName, val)
        return exports['oAntiHook']:setEData(getThisResource(), e, dName, val)
    end

    _getElementData = getElementData
    function getElementData(e, dName)
        return _getElementData(e, dName)
    end

    function removeElementData(e, dName)
        return exports['oAntiHook']:setEData(getThisResource(), e, dName, nil)
    end

    local registry = debug.getregistry() 
    local Metatable = registry.mt 
    for className,v in pairs(Metatable) do
        --outputChatBox(className)
        
        --local playerClass = registry.mt.className.__class 
        local playerClass = registry.mt
        if playerClass then
            local playerClass2 = playerClass[className]
            if playerClass2 then
                local playerClass3 = playerClass2["__class"]
                if playerClass3 then
                    function playerClass3:setData(...)
                        return setElementData(self, ...)
                    end
                    
                    function playerClass3:getData(...)
                        return getElementData(self, ...)
                    end
                    
                    function playerClass3:removeData(...)
                        return removeElementData(self, ...)
                    end
                end
            end
        end
    end
end

--[[(function ()
    local functionsList = {
        "fileOpen",
        "fileExists",
        "fileRename",
        "fileCreate",
        "fileCopy",
        "fileDelete",
        "dxCreateFont",
        "DxFont",
        "dxCreateTexture",
        "DxTexture",
        "dxCreateShader",
        "DxShader",
        "engineLoadDFF",
        "EngineDFF",
        "engineLoadTXD",
        "EngineTXD",
        "engineLoadCOL",
        "EngineCOL",
        "playSound",
        "playSound3D",
        "Sound",
        "Sound3D",
        "dxDrawImage",
    }

    local excludePaths = _exclude_paths
    if not excludePaths then
        excludePaths = {}
    end

    for i, name in ipairs(functionsList) do
        local fn = _G[name]
        if fn then
            _G[name] = function (path, ...)
                if type(path) ~= "string" then
                    return fn(path, ...)
                end
                for i,p in ipairs(excludePaths) do
                    if string.find(path, p, 1, true) then
                        return fn(path, ...)
                    end
                end           
                return fn(md5("dp" .. path), ...)
            end
        end
    end
end)();--]]