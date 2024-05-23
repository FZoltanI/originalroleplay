local connection = exports["oMysql"]:getDBConnection()


addEventHandler("onResourceStart", resourceRoot, function()
    dbQuery(function(qh)
        local result, numAffect = dbPoll(qh, 0)
        if result then 
            if numAffect > 0 then
                for k,v in ipairs(result) do 
                    local position = fromJSON(v["position"])
                    --outputChatBox(position[1][1])
                    objectElement = createObject(v["objID"], position[1], position[2], position[3])
                    setElementRotation(objectElement, position[4], position[5], position[6])
                    setElementInterior(objectElement, v["interior"])
                    setElementDimension(objectElement, v["dimension"])
                    setElementData(objectElement, "slotMachine.Id", v["id"])
                    setElementData(objectElement, "slotMachine.isMachine", true)
                    setElementData(objectElement, "slotMachine.price", v["price"])
                    setElementData(objectElement, "slotMachine.type", v["type"])
                end
            end
        end
    end, connection, "SELECT * FROM gamemachine")
end)

function loadAutomata(id)
    dbQuery(function(qh)
        local result, numAffect = dbPoll(qh, 0)
        if result then 
            if numAffect > 0 then
                for k,v in ipairs(result) do 
                    local position = fromJSON(v["position"])
                    --outputChatBox(position[1][1])
                    objectElement = createObject(v["objID"], position[1], position[2], position[3])
                    setElementRotation(objectElement, position[4], position[5], position[6])
                    setElementInterior(objectElement, v["interior"])
                    setElementDimension(objectElement, v["dimension"])
                    setElementData(objectElement, "slotMachine.Id", v["id"])
                    setElementData(objectElement, "slotMachine.isMachine", true)
                    setElementData(objectElement, "slotMachine.price", v["price"])
                    setElementData(objectElement, "slotMachine.type", v["type"])
                end
            end
        end
    end, connection, "SELECT * FROM gamemachine WHERE id = ?", id)
end

addEvent("placeMachine", true)
addEventHandler("placeMachine", getRootElement(), function(playerElement, objectId, type)
    local x,y,z = getElementPosition(playerElement)
    local rotX,rotY,rotZ = getElementRotation(playerElement)
    local interior = getElementInterior(playerElement)
    local dimension = getElementDimension(playerElement)


    dbQuery(function(qh, type)
        local result, numAffect, lastInsertID = dbPoll(qh, 0)
        if result then 
            loadAutomata(lastInsertID)
            outputChatBox(core:getServerPrefix("server").."Sikeresen létrehoztál egy Slot gépet (ID: "..lastInsertID .." | Típus: ".. typeName[type] ..")",playerElement, 0, 0, 0, true);
        end
    end,{type},connection, "INSERT INTO gamemachine (position, objID, type, interior, dimension) VALUES (?, ?, ?, ?, ?)", toJSON({x,y,z,rotX,rotY,rotZ}), objectId, type, interior, dimension)
end)

addEvent("deleteMachine",true)
addEventHandler("deleteMachine",getRootElement(),function(playerElement, id)
    dbExec(connection, "DELETE FROM gamemachine WHERE id = ?", id)
    for k,v in ipairs(getElementsByType("object")) do 
        if getElementData(v, "slotMachine.Id") == id then 
            destroyElement(v)
        end
    end
    outputChatBox(core:getServerPrefix("server").."Sikeresen törölted a kiválasztott automatát",playerElement, 0, 0, 0, true);
end)