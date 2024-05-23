addEvent("bus > startTravell", true)
addEventHandler("bus > startTravell", resourceRoot, function(price, player)
    setElementData(client, "bus:isTravelling", true)
    setElementData(client, "bus:travellStartPos", Vector3(getElementPosition(client)))

    setElementData(client, "char:money", getElementData(client, "char:money")-price) 
    setElementDimension(client, 1)

    local randpos = bus_doors[math.random(#bus_doors)]
    setElementPosition(client, randpos.x, randpos.y, randpos.z)

    setElementFrozen(client, true)
    setElementAlpha(client, 100)
    setElementCollisionsEnabled(client, false)

    setTimer(function() 
        setElementFrozen(player, false)
        setElementAlpha(player, 255)
        setElementCollisionsEnabled(player, true)
    end, 1500, 1)
end)

addEvent("bus > endTravell", true)
addEventHandler("bus > endTravell", resourceRoot, function(x, y, z, player)

    setElementData(client, "bus:isTravelling", false)
    setElementData(client, "bus:travellStartPos", false)

    setElementPosition(client, x, y, z)
    setElementDimension(client, 0)

    setElementFrozen(client, true)
    setElementAlpha(client, 100)
    setElementCollisionsEnabled(client, false)

    setTimer(function() 
        setElementFrozen(player, false)
        setElementAlpha(player, 255)
        setElementCollisionsEnabled(player, true)
    end, 1500, 1)
end)