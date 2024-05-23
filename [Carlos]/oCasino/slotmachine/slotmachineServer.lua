local created_slotmachines = {}

function createSlotmachines()
    for k, v in ipairs(slotmachines) do 
        v.rot = v.rot - 180

        local obj = createObject(1948, v.pos.x, v.pos.y, v.pos.z+0.1, 0, 0, v.rot)
        setObjectScale(obj, 1.5)
        setElementDoubleSided(obj, true)

        setElementDimension(obj, v.dim)
        setElementInterior(obj, v.int)

        local wheels = {}
        for i = 1, 3 do 
            local wheelRotation = slotmachineWheelRotations[math.random(#slotmachineWheelRotations)]
            wheels[i] = createObject(2324, v.pos.x, v.pos.y, v.pos.z, wheelRotation, 0, v.rot) -- 2324 | 2348
            setElementDimension(wheels[i], v.dim)
            setElementInterior(wheels[i], v.int)
            setObjectScale(wheels[i], 1.5)
            setElementCollisionsEnabled(wheels[i], false)

            if i == 1 then 
                attachElements(wheels[i], obj, -0.12, 0, 0, wheelRotation, 0, 0)
            else
                attachElements(wheels[i], obj, -0.12 + (0.16*(i-1)), 0, 0, wheelRotation, 0, 0)
            end

            detachElements(wheels[i])
        end

        --local chair = createObject(1716,  v.pos.x, v.pos.y, v.pos.z)
        --attachElements(chair, obj, 0.35, -0.8, -1.2)

        local col = createObject(2640, v.pos.x, v.pos.y, v.pos.z-0.08, 0, 0, v.rot)
        setElementDimension(col, v.dim)
        setElementInterior(col, v.int)
        setElementAlpha(col, 0)
        setElementData(col, "slotMachine:machine", obj)
        setElementData(col, "slotMachine:isSlotMachine", true)

        local col2 = createObject(2640, v.pos.x, v.pos.y, v.pos.z-0.08, 0, 0, v.rot)
        setElementDimension(col2, v.dim)
        setElementInterior(col2, v.int)
        attachElements(col2, obj, 0, 0.2, 0)
        setElementAlpha(col2, 0)

        setElementData(obj, "slotMachine:wheels", wheels)
        setElementData(obj, "slotMachine:id", k)

        setElementData(col, "slotMachine:machineUsePlayer", false)
        setElementData(col, "slotMachine:sound", false)

        table.insert(created_slotmachines, #created_slotmachines+1, obj)
    end
end
addEventHandler("onResourceStart", resourceRoot, createSlotmachines)

addEvent("casino > slotmachine > warpPlayerToSMFront", true)
addEventHandler("casino > slotmachine > warpPlayerToSMFront", resourceRoot, function(machine)
    setElementData(machine, "slotMachine:machineUsePlayer", client)
    attachElements(client, machine, 0, -0.76, -0.1, 0, 0, 180)
    setPedAnimation(client, "casino", "slot_wait")

    local rx, ry, rz = getElementRotation(machine)
    setElementRotation(client, 0, 0, rz)

    --spinSlotMachineWheels(machine)
end)

addEvent("casino > slotmachine > quitFromChar", true)
addEventHandler("casino > slotmachine > quitFromChar", resourceRoot, function(machine)
    setElementData(machine, "slotMachine:machineUsePlayer", false)

    detachElements(client, machine)
    setPedAnimation(client, "", "")
end)

addEvent("casino > slotmachine > spinMachineWheels", true)
addEventHandler("casino > slotmachine > spinMachineWheels", resourceRoot, function(machine, bet)
    local player = client
    setPedAnimation(client, "casino", "slot_bet_02", _, false)
    setElementData(client, "char:cc", (getElementData(client, "char:cc") or 0) - bet)
    setTimer(function() 
        setPedAnimation(player, "casino", "slot_wait")
        spinSlotMachineWheels(machine) 
    end, 500, 1)
end)

function spinSlotMachineWheels(slotmachine)
    local machine = getElementData(slotmachine, "slotMachine:machine")
    local wheels = getElementData(machine, "slotMachine:wheels")
    local _, _, slotmachineRot = getElementRotation(machine)

    local allrotcount = 0

    setElementData(machine, "slotMachine:sound", "slotmachine_spin.wav")

    for k, v in pairs(wheels) do 
        --outputChatBox(k)
        local randomrot = slotmachineWheelRotations[math.random(#slotmachineWheelRotations)]
        --setElementRotation(v, randomrot, 0, slotmachineRot)

        local pos = Vector3(getElementPosition(v))
        --print(pos.x, pos.y, pos.z)

        --moveObject(v, randRotTime, pos.x, pos.y, pos.z, randomrot, 0, slotmachinerot)

        local rotCount = math.random(15, 35)

        allrotcount = allrotcount + rotCount
        setTimer(function()
            local randomrot = slotmachineWheelRotations[math.random(#slotmachineWheelRotations)]
            setElementRotation(v, randomrot, 0, slotmachineRot)
            --moveObject(v, 100, pos.x, pos.y, pos.z, randomrot, 0, slotmachinerot)
        end, 50, rotCount)
    end

    setTimer(function() 
        --*outputChatBox("trigger")
        local usePlayer = getElementData(slotmachine, "slotMachine:machineUsePlayer")
        triggerClientEvent(usePlayer, "casino > slotmachine > endrot", usePlayer)
        setElementData(machine, "slotMachine:sound", false)
    end, (allrotcount)*34, 1)
end

addEvent("casino > playWinSound", true)
addEventHandler("casino > playWinSound", resourceRoot, function(machine)
    setElementData(machine, "slotMachine:sound", false)
    setElementData(machine, "slotMachine:sound", "slotmachine_win.wav")
end)

addEvent("casino > slotMachine > payBet", true)
addEventHandler("casino > slotMachine > payBet", resourceRoot, function(cc)
    setElementData(client, "char:cc", (getElementData(client, "char:cc") or 0) + cc)
end)