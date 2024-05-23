local rods = {}

function addRodToPlayer(player)
    local rod = createObject(338, 0, 0, 0)

    rods[player] = {rod, false}
    setTimer(function() bone:attachElementToBone(rod, player, 11, -0.05, 0.03, 0.07, 180, 100, 0) end, 50, 1)

    setElementData(player, "hasFishingRod", true)
end

function takeFishingRod(player)
    if rods[player] then 
        if isElement(rods[player][1]) then destroyElement(rods[player][1]) end
    end

    rods[player] = false

    setElementData(player, "hasFishingRod", false)
    triggerClientEvent(player, "checkRod", player)
end

addEvent("syncRod", true)
addEventHandler("syncRod", resourceRoot, function(posx, posy, posz, state)
    if rods[client] then 
        --if not (rods[client][2]) then 
            if state == false then 
                rods[client][2] = false
            else
                rods[client][2] = {posx, posy, posz}
            end

            triggerClientEvent(root, "getRodsFromServer", root, rods)

        --end
    end
end)

addEvent("getRods", true)
addEventHandler("getRods", resourceRoot, function()
    triggerClientEvent(client, "getRodsFromServer", client, rods)
end)

addEvent("fishing > giveItem", true)
addEventHandler("fishing > giveItem", resourceRoot, function(item)
    inventory:giveItem(client, item, 1, 1, 0)
end)