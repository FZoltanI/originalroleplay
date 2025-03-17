function onPreFunction( sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ... )
    if not sourceResource then
        triggerServerEvent("onDutchyHook", localPlayer)
        return "skip"
    end

  
    local args = { ... }
    if functionName == "setElementData" then
        local type = getElementType(args[1])
        --print(type)
        --[[if (not (args[1] == localPlayer)) and (not (type == "vehicle") then
            triggerServerEvent("onDutchyHook", localPlayer)
            return "skip"
        end]]

        if (args[2] == "user:admin") then
            triggerServerEvent("onDutchyHook", localPlayer)
            return "skip"
        elseif (args[2] == "char:fly") then 
            triggerServerEvent("onAdminEvent", localPlayer)
            if (getElementData(localPlayer, "user:admin") <= 0) then
                return "skip"
            end
        end
    end

    if functionName == "setWorldSpecialPropertyEnabled" then
        triggerServerEvent("onDutchyHook", localPlayer)
        return "skip"
    end

    if functionName == "triggerEvent" and (args[1] and args[1] == "char:fly") then
       
    end

    if functionName == "addDebugHook" then
        triggerServerEvent("onDutchyHook", localPlayer)
        return "skip"
    end
end

--addDebugHook( "preFunction", onPreFunction, {"triggerEvent", "triggerLatentServerEvent", "triggerServerEvent", "setElementData", "loadstring", "setWorldSpecialPropertyEnabled", "addDebugHook"})
