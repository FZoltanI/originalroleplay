function onDutchyHook()
    kickPlayer(client)
end

addEvent("onDutchyHook", true)
addEventHandler("onDutchyHook", getRootElement(), onDutchyHook)


function onDutchyHookAdmin()
    if getElementData(client, "user:admin") <= 0 then
        kickPlayer(client)
    end
end

addEvent("onAdminEvent", true)
addEventHandler("onAdminEvent", getRootElement(), onDutchyHookAdmin)
