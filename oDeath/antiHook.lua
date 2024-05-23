--triggerHack:
local cache = {}
local salt = "~>>ˇ~^˘°˛`_OriginalRP"


function getTriggerName(triggerName)
    return exports['oAntiHook']:getTriggerName(getThisResource(), triggerName)
end

_addEvent = addEvent
function addEvent(eventName, allowRemoteTrigger)
    cache[eventName] = true 
    eventName = getTriggerName(eventName)
    _addEvent(eventName, allowRemoteTrigger)
end

_addEventHandler = addEventHandler
function addEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
    local func
    local _func = handlerFunction
    if eventName == "onClientElementDataChange" or eventName == "onElementDataChange" then
        func = function(dName, oValue, newValue)
            --outputChatBox("DName O:"..dName)
            local dName = dName:gsub(salt, "")
            local source = source
            local client = client
            --outputChatBox("DName N:"..dName)
            _func(dName, oValue, newValue)
        end

        handlerFunction = func
    end
    
    if cache[eventName] then
        eventName = getTriggerName(eventName)
        _addEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
    else
        _addEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
    end
end

_removeEventHandler = removeEventHandler
function removeEventHandler(eventName, attachedTo, functionVar)
    local func
    local _func = functionVar
    if eventName == "onClientElementDataChange" or eventName == "onElementDataChange" then
        func = function(dName, oValue, newValue)
            outputChatBox("DName O:"..dName)
            local dName = dName:gsub(salt, "")
            local source = source
            local client = client
            outputChatBox("DName N:"..dName)
            _func(dName, oValue, newValue)
        end

        functionVar = func
    end
    
    if cache[eventName] then
        eventName = getTriggerName(eventName)
        cache[eventName] = nil
    end
    
    _removeEventHandler(eventName, attachedTo, functionVar)
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
