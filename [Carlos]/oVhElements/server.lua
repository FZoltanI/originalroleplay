local levels = {6.95, 13.45}
local level = 1

local liftx, lifty = 1500.5443359375, -1806.45
local lift = createObject(17113, liftx, lifty, levels[1])
local lift_col = createColTube(liftx, lifty, levels[1], 1, 2)
attachElements(lift_col, lift, 0, 0, 0.2)
setElementData(lift_col, "VH:Lift:inCol", true)

local jelenlegi = 1
local selectedlevel = 1
local liftInMove = false

local liftMovePerLevel = 5000

local liftMoveTime = 0

local liftDoorObj = 16342

local attachedDoors = {createObject(liftDoorObj, 1501.3, -1807.52, 8.115629196167, 0, 0, 270), createObject(liftDoorObj, 1501.3, -1807.52, 8.115629196167, 0, 0, 270)}

attachElements(attachedDoors[1], lift, 0.7, -0.98, 1.35, 0, 0, 90)
attachElements(attachedDoors[2], lift, -0.9, -0.98, 1.35, 0, 0, 270)

--1,12

local liftDoorPos = {
    ["close"] = {
        1501.3,
        1499.7,
    },

    ["open"] = {
        1502.2,
        1498.8,
    },
}

local lift_doors = {
    [1] = {
        createObject(liftDoorObj, 1501.3, -1807.52, 8.115629196167, 0, 0, 270),
        createObject(liftDoorObj, 1499.7, -1807.52, 8.115629196167, 0, 0, 90),
    },

    [2] = {
        createObject(liftDoorObj, 1501.3, -1807.46, 14.81, 0, 0, 90),
        createObject(liftDoorObj, 1499.7, -1807.46, 14.81, 0, 0, 90),
    },
}

function setLiftLocalDoorState(state)
    detachElements(attachedDoors[1], lift)
    detachElements(attachedDoors[2], lift)

    local posX1, posY1, posZ1 = getElementPosition(attachedDoors[1])
    local posX2, posY2, posZ2 = getElementPosition(attachedDoors[2])

    if state == "open" then 
        moveObject(attachedDoors[1], 2000, posX1 + 0.95, posY1, posZ1)
        moveObject(attachedDoors[2], 2000, posX2 - 0.85, posY2, posZ2)
    else
        moveObject(attachedDoors[1], 2000, posX1 - 0.95, posY1, posZ1)
        moveObject(attachedDoors[2], 2000, posX2 + 0.85, posY2, posZ2)

        setTimer(function()
            attachElements(attachedDoors[1], lift, 0.7, -0.98, 1.35, 0, 0, 90)
            attachElements(attachedDoors[2], lift, -0.9, -0.98, 1.35, 0, 0, 270)
        end, 2000, 1)
    end
end

function moveLift()
    if not liftInMove then 
        closeDoorInLevel(jelenlegi)
        setLiftLocalDoorState("close")
        liftInMove = true

        setTimer(function() 
            jelenlegi = selectedlevel
            moveObject(lift, liftMoveTime, liftx, lifty, levels[selectedlevel])
            setTimer(function() 
                jelenlegi = selectedlevel

                openDoorInLevel(jelenlegi)

                setLiftLocalDoorState("open")
                liftInMove = false 
                
            end, liftMoveTime, 1)
        end, 2000, 1)
    end
end

function openDoorInLevel(level)
    for key, value in ipairs(lift_doors[level]) do 
        local pos = Vector3(getElementPosition(value))

        moveObject(value, 2000, liftDoorPos["open"][key], pos.y, pos.z)
    end
end
openDoorInLevel(1)
setLiftLocalDoorState("open")

function closeDoorInLevel(level)
    for key, value in ipairs(lift_doors[level]) do 
        local pos = Vector3(getElementPosition(value))

        moveObject(value, 2000, liftDoorPos["close"][key], pos.y, pos.z)
    end
end

addEvent("VH > Lift > SetLevel", true)
addEventHandler("VH > Lift > SetLevel", resourceRoot, function(level, type)
    if not (level == jelenlegi) then 
        if not liftInMove then 
            if type == 1 then 
                local liftColObjs = getElementsWithinColShape(lift_col, "player")

                if #liftColObjs == 0 then 
                    liftMoveTime = liftMovePerLevel*math.abs(level - jelenlegi)
                    selectedlevel = level
                    moveLift()
                    exports.oInfobox:outputInfoBox("Sikeresen hívtál egy liftet!", "success", client)
                else
                    exports.oInfobox:outputInfoBox("A lift jelenleg foglalt!", "warning", client)
                end
            else
                liftMoveTime = liftMovePerLevel*math.abs(level - jelenlegi)
                selectedlevel = level
                moveLift()
                exports.oInfobox:outputInfoBox("Sikeresen elindítottad a liftet!", "success", client)
            end
        else
            exports.oInfobox:outputInfoBox("A lift jelenleg mozgásban van!", "warning", client)
        end
    end
end)

--[[local levels2 = {12.4, 27.6}
local lift2 = createObject(9054, 1479.41, -1789.8, levels2[1])
local liftMoveTime2 = 12000
local jelenlegi2 = 1
local inMove2 = false

local lift2_doors = {
    createObject(970, 1479.4, -1783.482421875, 14),
    createObject(970, 1479.4, -1795.1350097656, 29.2),
}

local lift2_doors_poses = {
    ["close"] = {14, 29.2},
    ["open"] = {10.9, 28.1},
}

function moveLift2(level)
    if not inMove2 then 
        inMove2 = true
        local pos = Vector3(getElementPosition(lift2))

        if level == 1 then 
            closeLift2DoorInLevel(2)
        elseif level == 2 then 
            closeLift2DoorInLevel(1)
        end

        moveObject(lift2, liftMoveTime2, pos.x, pos.y, levels2[level])
        setTimer(function()
            inMove2 = false
            jelenlegi2 = level
            openLift2DoorInLevel(level)
        end, liftMoveTime2, 1)
    end
end

function openLift2DoorInLevel(level)
    local jelenlegiPos = Vector3(getElementPosition(lift2_doors[level]))

    moveObject(lift2_doors[level], 1000, jelenlegiPos.x, jelenlegiPos.y, lift2_doors_poses["open"][level])
end

function closeLift2DoorInLevel(level)
    local jelenlegiPos = Vector3(getElementPosition(lift2_doors[level]))

    moveObject(lift2_doors[level], 1000, jelenlegiPos.x, jelenlegiPos.y, lift2_doors_poses["close"][level])
end

openLift2DoorInLevel(1)

addEvent("VH > VehLift > SetLiftLevel", true)
addEventHandler("VH > VehLift > SetLiftLevel", resourceRoot, function(newLevel)
    if not inMove2 then 
        if not (newLevel == jelenlegi2) then 
            if newLevel == 99 then 
                if jelenlegi2 == 1 then 
                    moveLift2(2)
                elseif jelenlegi2 == 2 then 
                    moveLift2(1)
                end
                exports.oInfobox:outputInfoBox("Sikeresen elindítottad a járműliftet!", "success", client)
            else
                moveLift2(newLevel)
                exports.oInfobox:outputInfoBox("Sikeresen elindítottad a járműliftet!", "success", client)
            end
        end
    else
        exports.oInfobox:outputInfoBox("A járműlift jelenleg mozgásban van!", "warning", client)
    end
end)]]