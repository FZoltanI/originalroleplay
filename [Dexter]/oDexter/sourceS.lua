local syntax = exports["oCore"]:getServerPrefix()
local hex = exports["oCore"]:getServerColor()

addCommandHandler("copy", function(player, cmd, value, dir)
    if not value then 
        outputChatBox(syntax .. "Használat: /"..cmd .." [ResourceName] <Dir>", player, 255, 255, 255, true)
    else
        if not dir then dir = "[Dexter]" else dir = tostring(dir) end
        value = tostring(value)

        resource = getResourceFromName(value)
        if getResourceState( resource ) == "running" then 
            copyResource(getResourceFromName(value), value .. "_bk", dir)
            outputChatBox(syntax .. hex .. value .."#FFFFFF resources másolása folyamatban ...", player, 255, 255, 255, true)
            setTimer(function()
                stopResource(getResourceFromName(value))
            end,1000,1)
            setTimer(function()
                deleteResource(getResourceFromName(value))
                outputChatBox(syntax .. hex .. value .."#FFFFFF resources sikeresen átmásolva! ("..hex.. dir .."#FFFFFF mappába)", player, 255, 255, 255, true)
            end, 2000, 1)
        else
            outputChatBox(syntax.. "Nincs ilyen resource vagy nem fut!", player, 255, 255, 255, true)
        end
    end
end)