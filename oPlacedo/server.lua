local placedos = {}

addCommandHandler("placedo", function(player, cmd, ...)
    if (...) then 
        local playerID = getElementData(player, "char:id")
        if not placedos[playerID] then 
            placedos[playerID] = {}
        end

        local playerPlacedos = 0 

        for k, v in pairs(placedos[playerID]) do 
            if v then 
                playerPlacedos = playerPlacedos + 1
            end
        end

        if playerPlacedos < 5 then 
            text = table.concat({...}, " ")

            local playerPos = Vector3(getElementPosition(player))

            local placedo = createObject(675, playerPos.x, playerPos.y, playerPos.z)
            setElementCollisionsEnabled(placedo, false)
            setElementAlpha(placedo, 0)

            setElementInterior(placedo, getElementInterior(player))
            setElementDimension(placedo, getElementDimension(player))


            setElementData(placedo, "isPlacedo", true)
            setElementData(placedo, "placedo:text", text)
            setElementData(placedo, "placedo:ownerID", playerID)
            setElementData(placedo, "placedo:ownerName", (getPlayerName(player):gsub("_", " ")) )
            setElementData(placedo, "placedo:createTime", string.format("%04d.%02d.%02d. %02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute")))

            local id = #placedos[playerID]+1
            setElementData(placedo, "placedo:id", id)

            placedos[playerID][placedo] = {placedo, setTimer(function() 
                destroyElement(placedo)
                placedos[playerID][placedo] = false
            end, core:minToMilisec(60), 1)}
        else
            outputChatBox(core:getServerPrefix("red-dark", "Placedo", 2).."Maximum "..color.."5db #ffffffplacedot helyezhetsz le egyszerre!", player, 255, 255, 255, true)
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Placedo", 2).."/"..cmd.." [Szöveg]", player, 255, 255, 255, true)
    end
end)

addEvent("placedo > delPlacedo", true)
addEventHandler("placedo > delPlacedo", resourceRoot, function(placedo)
    local playerid = getElementData(placedo, "placedo:ownerID")
    --local placedoID = getElementData(placedo, "placedo:id")
    --outputChatBox(placedoID)
    killTimer(placedos[playerid][placedo][2])
    destroyElement(placedos[playerid][placedo][1])
    placedos[playerid][placedo] = false
end)