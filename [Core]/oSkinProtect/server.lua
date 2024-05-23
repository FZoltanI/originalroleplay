local protectedSkins = {
    --[297] = "AEA95DB987F1421D4D490423DB074292", -- Zacskós
    
    [236] = "AEA95DB987F1421D4D490423DB074292", -- Zacskós
    [290] = "CEA522BAC3269175C7A200BBD3EA04F0", -- Costa
    [158] = "52E602241DC69E45929DF7CA9DCDDE54", -- Carlos
    [310] = "3A57BCFE1D8489DAB7FE04B9CCBADEB2", -- dominik

}

addEventHandler("onElementModelChange", root, function(old, new)
    if getElementType(source) == "player" then 
        if protectedSkins[new] then
            if not (getPlayerSerial(source) == protectedSkins[new]) then 
                local player = source
                setTimer(function()
                    setElementModel(player, old)
                    outputChatBox(exports.oCore:getServerPrefix("red-dark", "Hiba", 3).."Nincs jogosultságod a skin használatára. "..exports.oCore:getServerColor().."("..new..")", player, 255, 255, 255, true)
                end, 100, 1)
            end
        end
    end
end)

local busyPedSkins = {
    [269] = true,
    [270] = true,
    [271] = true,
    [300] = true,
    [311] = true,
    [293] = true,
    [1] = true,
    [9] = true,
}

addEventHandler("onElementModelChange", root, function(old, new)
    if getElementType(source) == "player" then 
        if busyPedSkins[new] then
            local player = source
            setTimer(function()
                setElementModel(player, old)
                outputChatBox(exports.oCore:getServerPrefix("red-dark", "Hiba", 3).."Nincs jogosultságod a skin használatára. "..exports.oCore:getServerColor().."("..new..")", player, 255, 255, 255, true)
            end, 100, 1)
        end
    end
end)