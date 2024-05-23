addCommandHandler("getwaters", function(player, cmd)
    if getElementData(player, "aclLogin") then 
        local runningResources = getResources()
        local names = {}

        for k, v in ipairs(runningResources) do
            if (getResourceState(v) == "running") then
                table.insert(names, getResourceName(v))
            end
        end

        triggerClientEvent(root, "sendResources", root, names)
    end
end)