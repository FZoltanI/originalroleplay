function createBlackjackTables()
    for k, v in ipairs(blackjackTables) do 
        local ped = createPed(v.skin, v.pos.x, v.pos.y, v.pos.z, v.rot)
        setElementInterior(ped, v.int)
        setElementDimension(ped, v.dim)
        --local obj = createObject(2188, v.pos.x, v.pos.y, v.pos.z)

        setElementData(ped, "ped:name", v.name)
        setElementData(ped, "ped:prefix", "Blackjack")

        --attachElements(obj, ped, 0, 0.5, 0, 0, 0, 180)

        setElementFrozen(ped, true)

        setElementData(ped, "isBlackjackTable", true)
        setElementData(ped, "blackjack:table:use", 0)
    end
end
addEventHandler("onResourceStart", resourceRoot, createBlackjackTables)

local tableElement = false

addEvent("casino > blackjack > attachPlayerToTable", true)
addEventHandler("casino > blackjack > attachPlayerToTable", resourceRoot, function(table, pos)

    attachElements(client, table, bjTableposes[pos][1], bjTableposes[pos][2], bjTableposes[pos][3], bjTableposes[pos][4], bjTableposes[pos][5], bjTableposes[pos][6])
    tableElement = table
    local _, _, rot = getElementRotation(table)
    setElementRotation(client, 0, 0, rot-bjTableposes[pos][6])
    setElementData(table, "blackjack:table:use", getElementData(table, "blackjack:table:use") + 1)
end)

addEvent("casino > blackjack > detachPlayer", true)
addEventHandler("casino > blackjack > detachPlayer", resourceRoot, function(table)
    setElementData(table, "blackjack:table:use", getElementData(table, "blackjack:table:use") - 1)
    local originalPos = Vector3(getElementPosition(client))
    detachElements(client, table)
    tableElement = false
    setElementPosition(client, originalPos.x, originalPos.y, originalPos.z)
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    if tableElement and isElement(tableElement) then
        setElementData(tableElement, "blackjack:table:use", getElementData(tableElement, "blackjack:table:use") - 1)
    end
end)

addEvent("casino > blackjack > setPlayerMoney", true)
addEventHandler("casino > blackjack > setPlayerMoney", resourceRoot, function(money, type)
    local playermoney = getElementData(client, "char:cc")
    if type == "add" then 
        setElementData(client, "char:cc", playermoney + money)
        --setPedAnimation(client, "casino", "roulette_win", _, false)
    elseif type == "remove" then 
        setElementData(client, "char:cc", playermoney - money)
    end
end)