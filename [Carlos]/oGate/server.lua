local connection = exports.oMysql:getDBConnection()

addEventHandler("onResourceStart", resourceRoot, function() 
    loadGates()
end)

addEvent("gate > createGateOnServer", true)
addEventHandler("gate > createGateOnServer", resourceRoot, function(gatePositions, modelID, int, dim) 
    if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(client) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

    local obj = createObject(modelID, gatePositions["close"]["x"], gatePositions["close"]["y"], gatePositions["close"]["z"], gatePositions["close"]["rx"], gatePositions["close"]["ry"], gatePositions["close"]["rz"])

    local closePos = {gatePositions["close"]["x"], gatePositions["close"]["y"], gatePositions["close"]["z"], gatePositions["close"]["rx"], gatePositions["close"]["ry"], gatePositions["close"]["rz"]}
    local openPos = {gatePositions["open"]["x"], gatePositions["open"]["y"], gatePositions["open"]["z"], gatePositions["open"]["rx"], gatePositions["open"]["ry"], gatePositions["open"]["rz"]}

    setElementData(obj, "gate:closePos", closePos)
    setElementData(obj, "gate:openPos", openPos)
    setElementData(obj, "gate:inMove", false)
    setElementData(obj, "gate:state", true) -- true: zárva, false: nyitva
    setElementData(obj, "isGate", true)

    setElementInterior(obj, int)
    setElementDimension(obj, dim)

    local insertResult, _, insertID = dbPoll(dbQuery(connection, "INSERT INTO gates SET modelID=?, closePos=?, openPos=?, interior = ?, dimension = ? ", modelID, toJSON(closePos), toJSON(openPos), int, dim), 250)

    setElementData(obj, "gate:id", insertID)

    exports.oAdmin:sendMessageToAdmins(client, "létrehozott egy kaput. #db3535(ID: "..insertID..")")
    outputChatBox(core:getServerPrefix("green-dark", "Kapu", 2).."Sikeresen létrehoztál egy kaput. "..color.."(ID: "..insertID..")", client, 255, 255, 255, true)
end)

function loadGates() 
    query = dbQuery(connection, 'SELECT * FROM gates')
    result = dbPoll(query, 255)

    if result then 
        for k, v in ipairs(result) do 
            local gateID = v["id"]
            local modelID = v["modelID"]
            local closePos = fromJSON(v["closePos"])
            local openPos = fromJSON(v["openPos"])

            local int = v["interior"]
            local dim = v["dimension"]
          
            local obj = createObject(modelID, closePos[1], closePos[2], closePos[3], closePos[4], closePos[5], closePos[6])

            setElementData(obj, "isGate", true)
            setElementData(obj, "gate:id", gateID)
            setElementData(obj, "gate:closePos", closePos)
            setElementData(obj, "gate:openPos", openPos)
            setElementData(obj, "gate:inMove", false)
            setElementData(obj, "gate:state", true)

            setElementInterior(obj, int)
            setElementDimension(obj, dim)
        end
    end
end

function delGate(player, cmd, target)
    if getElementData(player, "user:admin") >= 7 then 
        if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

        if tonumber(target) then 
            local gate = false

            target = tonumber(target)

            local allGate = getAllGates()
            for k, v in pairs(allGate) do 
                if getElementData(v, "gate:id") == target then 
                    gate = v 
                    break
                end
            end

            if gate then 
                dbExec(connection, "DELETE FROM gates WHERE id=?", target)
                destroyElement(gate)

                exports.oAdmin:sendMessageToAdmins(player, "kitörölt egy kaput. #db3535(ID: "..target..")")
                outputChatBox(core:getServerPrefix("green-dark", "Kapu", 2).."Sikeresen töröltél egy kaput. "..color.."(ID: "..target..")", player, 255, 255, 255, true)
            else
                outputChatBox(core:getServerPrefix("red-dark", "Kapu", 2).."Nincs ilyen ID-vel rendelkező kapu! "..color.."("..target..")", player, 255, 255, 255, true)
            end 
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Kapu ID]", player, 255, 255, 255, true)
        end
    end
end
addCommandHandler("delgate", delGate) 

local gateTimers = {}
addEvent("gate > setGateState", true)
addEventHandler("gate > setGateState", resourceRoot, function(gate)
    if not isTimer(gateTimers[gate]) then
        local gate = gate
        gateTimers[gate] = setTimer(function()
            if isTimer(gateTimers[gate]) then 
                killTimer(gateTimers[gate])
            end
        end, gateMoveingTime + 1000, 1)
        setElementData(gate, "gate:inMove", true)
        local state =  getElementData(gate, "gate:state") 

        local newpos
        local oldpos

        local modelName = "kaput"

        local model = getElementModel(gate)

        if model == 3089 then 
            modelName = "ajtót"
        elseif model == 968 then 
            modelName = "sorompót"
        end

        if state then 
            newpos = getElementData(gate, "gate:openPos")
            oldpos = getElementData(gate, "gate:closePos")
            exports.oChat:sendLocalMeAction(client, "kinyitja a közelében lévő "..modelName..".")
        else
            newpos = getElementData(gate, "gate:closePos")
            oldpos = getElementData(gate, "gate:openPos")
            exports.oChat:sendLocalMeAction(client, "bezárja a közelében lévő "..modelName..".")
        end

        setElementData(gate, "gate:state", not state)

        if model == 3089 then 
            if state then 
                moveObject(gate, gateMoveingTime/2, newpos[1], newpos[2], newpos[3], 0, 0, 75)
            else
                moveObject(gate, gateMoveingTime/2, newpos[1], newpos[2], newpos[3], 0, 0, -75)
            end
        elseif model == 968 then 
            if state then 
                moveObject(gate, gateMoveingTime, newpos[1], newpos[2], newpos[3], 0, -75, 0)
            else
                moveObject(gate, gateMoveingTime, newpos[1], newpos[2], newpos[3], 0, 75, 0)
            end
        else
            moveObject(gate, gateMoveingTime, newpos[1], newpos[2], newpos[3])
        end

        setTimer(function() setElementData(gate, "gate:inMove", false) end, gateMoveingTime + 1000, 1)
    end
end)