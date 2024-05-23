removeWorldModel(4063, 200, 1549.9248046875,-1675.0966796875,15.176683425903)
removeWorldModel(4064, 200, 1549.9248046875,-1675.0966796875,15.176683425903)
removeWorldModel(4228, 200, 1587.8013916016,-1628.0208740234,13.3828125)


-- SETTINGS ---------------
local ASYNC   = false -- Enable async loading 
local STEPS   = 250 -- How much to load at one period (if 'ASYNC' enabled)
local TIMEOUT = 1000 -- Waiting time (ms) between two periods (if 'ASYNC' enabled)
---------------------------

local pdCol = createColRectangle(1548.2639160156,-1710.2052001953,43,50)

local tempObjects = {}

addEventHandler("onClientColShapeHit", resourceRoot, function(element, mdim)
    if source == pdCol and element == localPlayer and mdim then
        destroyTempObjects()
        loadObjects()
    end
end)

addEventHandler("onClientElementInteriorChange", localPlayer, function(old, new)
    if new == 0 then 
        if isElementWithinColShape(localPlayer, pdCol) then 
            destroyTempObjects()
            loadObjects()
        end
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(element, mdim)
    if source == pdCol and element == localPlayer and mdim then
        destroyTempObjects()
    end
end)

function loadObjects()
    for i = 1, #objects do
        local v = objects[i]

        if not v.alwaysLoaded then
            local e = createObject(v.model, v.x, v.y, v.z, v.rx, v.ry, v.rz)
            setElementInterior(e, v.interior)
            setElementDimension(e, v.dimension)
            setElementDoubleSided(e, v.doublesided)
            setElementFrozen(e, v.frozen)
            setObjectScale(e, v.scale)
            setElementAlpha(e, v.alpha)
            setElementCollisionsEnabled(e, v.collisions)

            if ASYNC and wait() then
                coroutine.yield()
            end

            table.insert(tempObjects, e)
        end
    end
end

function destroyTempObjects()
    for k, v in pairs(tempObjects) do 
        destroyElement(v)
        if ASYNC and wait() then
            coroutine.yield()
        end
    end
    tempObjects = {}
end


local cor     = nil
local counter = 0

local wait = function()
    counter = counter + 1
    return counter >= STEPS and setTimer(function()
        counter = 0
        coroutine.resume(cor)
    end, TIMEOUT, 1)
end

local loader = function()
    if objects then
        for i = 1, #objects do
            local v = objects[i]

            if v.alwaysLoaded then
                local e = createObject(v.model, v.x, v.y, v.z, v.rx, v.ry, v.rz)
                setElementInterior(e, v.interior)
                setElementDimension(e, v.dimension)
                setElementDoubleSided(e, v.doublesided)
                setElementFrozen(e, v.frozen)
                setObjectScale(e, v.scale)
                setElementAlpha(e, v.alpha)
                setElementCollisionsEnabled(e, v.collisions)

                if ASYNC and wait() then
                    coroutine.yield()
                end
            end
        end
    end


    if vehicles then
        for i = 1, #vehicles do
            local v = vehicles[i]
            
            local e = createVehicle(v.model, v.x, v.y, v.z, v.rx, v.ry, v.rz, v.plate)
            setElementInterior(e, v.interior)
            setElementDimension(e, v.dimension)
            setElementFrozen(e, v.frozen)
            setElementAlpha(e, v.alpha)
            setElementCollisionsEnabled(e, v.collisions)
            setVehiclePaintjob(e, v.paintjob)
            setElementHealth(e, v.health)
            setVehicleColor(e, unpack(v.gtacolors and v.gtacolors or v.colors))
            for _, upgrade in ipairs(v.upgrades) do
                addVehicleUpgrade(e, upgrade)
            end

            if ASYNC and wait() then
                coroutine.yield()
            end
        end
    end

    if peds then
        for i = 1, #peds do
            local v = peds[i]
            
            local e = createPed(v.model, v.x, v.y, v.z, v.rz)
            setElementInterior(e, v.interior)
            setElementDimension(e, v.dimension)
            setElementFrozen(e, v.frozen)
            setElementAlpha(e, v.alpha)
            setElementCollisionsEnabled(e, v.collisions)
            setElementHealth(e, v.health)
            setPedArmor(e, v.armor)

            if ASYNC and wait() then
                coroutine.yield()
            end
        end
    end

    if pickups then
        for i = 1, #pickups do
            local v = pickups[i]
            
            local e = v.type >= 2
                and createPickup(v.x, v.y, v.z, 2, v.type, v.respawn, v.amount)
                or  createPickup(v.x, v.y, v.z, v.type, v.amount, v.respawn)

            setElementInterior(e, v.interior)
            setElementDimension(e, v.dimension)
            setElementAlpha(e, v.alpha)

            if ASYNC and wait() then
                coroutine.yield()
            end
        end
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    if ASYNC then
        cor = coroutine.create(loader)
        return coroutine.resume(cor)
    end
    loader()

    
    if objectremoves then
        for i = 1, #objectremoves do
            local v = objectremoves[i]

            removeWorldModel(v.model, v.radius, v.x, v.y, v.z)

            if ASYNC and wait() then
                coroutine.yield()
            end
        end
    end
end)
