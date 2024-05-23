local neons = {
    [1] = 10491,
    [2] = 10696,
    [3] = 10451,
    [4] = 10694,
    [5] = 10489,
    [6] = 10364,
    [7] = 4308,
    [8] = 10387,
    [9] = 10413,
    [10] = 4307,
}

local neonColors = {"red", "blue", "green", "yellow", "pink", "white", "ice", "lightblue", "orange", "rainbow"}

local attachPositions = {
    {0.5, 0, -0.5, 0, 0, 0},
    {-0.5, 0, -0.5, 0, 0, 0},
}

function importFiles()
    local txd = engineLoadTXD ( "files/models/textures.txd" )

    for k, v in  ipairs(neonColors) do 
        dff = engineLoadDFF ("files/models/"..v..".dff", neons[k])
        engineReplaceModel (dff, neons[k]) 
    end
end
addEventHandler("onClientResourceStart", resourceRoot, importFiles)

addCommandHandler("setneon", function(cmd, id)
    if getElementData(localPlayer, "user:admin") >= 7 then
        local occupiedVeh = getPedOccupiedVehicle(localPlayer)
        if occupiedVeh then 
            if id then 
                id = tonumber(id)
                if id >= 1 and id <= 10 then
                    setElementData(occupiedVeh, "veh:neon:active", true)
                    setElementData(occupiedVeh, "veh:neon:id", id)

                    triggerServerEvent("neon > sendAdminLog", resourceRoot, getPedOccupiedVehicle(localPlayer))
                else
                    outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [1-10]", 255, 255, 255, true)
                end
            else
                outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [1-10]", 255, 255, 255, true)
            end
        end
    end
end)

local createdNeons = {}

addEventHandler("onClientResourceStop", root, function(res)
    if getResourceName(res) == "oVehicle" then
        for k, v in pairs(createdNeons) do 
            if not isElement(k) then 
                for key, value in pairs(v) do 
                    destroyElement(value)
                end

                createdNeons[k] = false
            end

        end
    end
end)

function addVehicleNeon(veh, id)
    if not (isElementStreamedIn(veh)) then return end
    if getElementData(veh, "veh:neon:active") then 
        if createdNeons[veh] then removeVehicleNeon(veh) end

        if (id or 0) > 0 then

            local pos = Vector3(getElementPosition(veh))

            local neonObjects = {
                createObject(neons[id], pos.x, pos.y, pos.z),
                createObject(neons[id], pos.x, pos.y, pos.z),
            }

            for k, v in ipairs(neonObjects) do 
                setElementCollisionsEnabled(v, false)
                setElementAlpha(v, 0)
                attachElements(v, veh, unpack(attachPositions[k]))
            end

            createdNeons[veh] = neonObjects

        end
    end
end

function removeVehicleNeon(veh)
    if not createdNeons then return end 
    
    if createdNeons[veh] then
        for k, v in ipairs(createdNeons[veh]) do 
            if isElement(v) then
                destroyElement(v)
            end
        end

        createdNeons[veh] = false
    end
end

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if data == "veh:neon:id" then
        if new > 0 then  
            addVehicleNeon(source, new)
        else
            removeVehicleNeon(source)
        end
    elseif data == "veh:neon:active" then 
        if new == true then 
            addVehicleNeon(source, getElementData(source, "veh:neon:id"))
        else
            removeVehicleNeon(source)
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "vehicle" then 
        if (getElementData(source, "veh:neon:active") or false) then
            addVehicleNeon(source, getElementData(source, "veh:neon:id"))
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "vehicle" then 
        if (getElementData(source, "veh:neon:active") or false) then
            removeVehicleNeon(source)
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k, v in ipairs(getElementsByType("vehicle"), root, false) do 
        local neon = getElementData(v, "veh:neon:id") or 0 

        if neon > 0 then 
            addVehicleNeon(v, neon)
        end
    end
end)

-- U

local lastInteraction = 0
bindKey("u", "up", function()
    if getPedOccupiedVehicleSeat(localPlayer) == 0 then 
        local occupiedVeh = getPedOccupiedVehicle(localPlayer)

        if (getElementData(occupiedVeh, "veh:neon:id") or 0) > 0 then 
            if lastInteraction + 400 < getTickCount() then 
                local neonState = getElementData(occupiedVeh, "veh:neon:active") or false
                setElementData(occupiedVeh, "veh:neon:active", not neonState)
                lastInteraction = getTickCount()
            end
        end
    end
end)