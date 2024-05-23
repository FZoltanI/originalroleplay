function isAllowed(player)
	return exports['oAdmin']:isPlayerDeveloper(player)
end

local openedExportLists = {}
addCommandHandler("exports", 
    function(player, cmd, type)
        if isAllowed(player) then
            if openedExportLists[player] then
                openedExportLists[player] = nil
                triggerClientEvent(player, "exportList->close", player)
            else
                openedExportLists[player] = true
                local tempExports = {}
                tempExports["shared"] = {}
                tempExports["client"] = {}
                tempExports["server"] = {}
                for k,v in ipairs(getResources()) do
                    local name = getResourceName(v)
                    local xmlFile = xmlLoadFile(":"..name.."/meta.xml")
                    if xmlFile then
                        local index = 0
                        local scriptNode = xmlFindChild(xmlFile,'export',index)
                        if scriptNode then
                            repeat

                            local funcName = xmlNodeGetAttribute(scriptNode,'function')
                            local scriptType = xmlNodeGetAttribute(scriptNode,'type') or "server"
                            if funcName then
                                table.insert(tempExports[scriptType], {name, funcName})
                            end

                            index = index + 1
                            scriptNode = xmlFindChild(xmlFile,'export',index)
                            until not scriptNode
                        end
                    end
                end

                if not type then
                    triggerClientEvent(player, "exportList->open", player, tempExports, "all")
                elseif tostring(type) == "shared" then
                    triggerClientEvent(player, "exportList->open", player, tempExports["shared"], "shared")
                elseif tostring(type) == "client" then
                    triggerClientEvent(player, "exportList->open", player, tempExports["client"], "client")
                elseif tostring(type) == "server" then
                    triggerClientEvent(player, "exportList->open", player, tempExports["server"], "server")
                end

                tempExports = nil
            end
        end
    end
)

addEventHandler("onPlayerQuit", root,
    function()
        if openedExportLists[source] then
            openedExportLists[source] = nil
        end
    end
)