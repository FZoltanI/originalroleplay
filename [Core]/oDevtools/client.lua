local positions = {}
local traceing = false
local traceTimer = false
local clipboard = false

function startTraceGroundPos(time)
    positions = {}

    traceTimer = setTimer(function()
        local x, y, z = getElementPosition(localPlayer)

        --z = getGroundPosition(x, y, z)
        z = z - 1

        table.insert(positions, {x, y, z})
    end, time, 0)

    addEventHandler("onClientRender", root, renderTraces)
end

function stopTraceGroundPos()
    if isTimer(traceTimer) then 
        killTimer(traceTimer)
    end

    outputChatBox("A pozíciók a vágólapra lettek másolva!")
    setClipboard(toJSON(positions))

    removeEventHandler("onClientRender", root, renderTraces)
end


function renderTraces()
    for k, v in pairs(positions) do 
        dxDrawLine3D(v[1], v[2], v[3]-50, v[1], v[2], v[3]+50, tocolor(255, 0, 0, 255))
    end
end

addCommandHandler("tracegroundpos", function(cmd, time)
    if getElementData(localPlayer, "aclLogin") then
        if not time then outputChatBox("/"..cmd.." [Time] ") return end
        traceing = not traceing 

        if traceing then 
            startTraceGroundPos(time)
            outputChatBox("A pozíciód követése elkezdődött!")
        else
            stopTraceGroundPos()
            outputChatBox("A pozíciód követése befejeződött!")
        end
    end
end)

addCommandHandler("qenabled", function(cmd)
    if getElementData(localPlayer, "aclLogin") then
        clipboard = not clipboard 

        if clipboard then 
            outputChatBox("A tracepoint engedélyezve!")
        else
            outputChatBox("A pozíciód követése befejeződött!")
        end
    end
end)


-- 

local positions = {}
local area = false

addCommandHandler("createanimalspawnarea", function(cmd, radius, count)
    if getElementData(localPlayer, "aclLogin") then
        if not radius or not count then outputChatBox("/"..cmd.." [Radius] [Count]") return end 
        area = not area

        if area then
            positions = {}
            local x, y, z = getElementPosition(localPlayer)

            for i = 1, count do 
                local posX, posY, posZ = math.random(x-radius/2, x+radius/2), math.random(y-radius/2, y+radius/2), 300
                posZ = getGroundPosition(posX, posY, posZ)

                table.insert(positions, {posX, posY, posZ})
            end

            addEventHandler("onClientRender", root, renderAreaPositions)
            outputChatBox(count.."db pont létrehozva "..radius.." sugárban. ")
        else
            setClipboard(toJSON(positions))
            outputChatBox("A pozíciók a vágólapra másolva.")
            removeEventHandler("onClientRender", root, renderAreaPositions)
        end
    end
end)

function renderAreaPositions()
    for k, v in pairs(positions) do 
        dxDrawLine3D(v[1], v[2], v[3]-50, v[1], v[2], v[3]+50, tocolor(0, 0, 255, 255))
        dxDrawLine3D(v[1], v[2], v[3]-1, v[1], v[2], v[3]+1, tocolor(255, 0, 0, 255), 20)
    end
end

--
local createdPositionTable = {}
bindKey("q", "up", function()
    if getElementData(localPlayer, "aclLogin") then
        if clipboard then
            local posx, posy, posz = getElementPosition(localPlayer)
            setClipboard(posx..", "..posy..", "..posz)

            table.insert(createdPositionTable, {posx, posy, posz - 1})
        end
    end
end)

addEventHandler("onClientRender", root, function()
    for k, v in ipairs(createdPositionTable) do
        dxDrawLine3D(v[1], v[2], v[3]-50, v[1], v[2], v[3]+50, tocolor(0, 0, 255, 255))
        dxDrawLine3D(v[1], v[2], v[3]-0.2, v[1], v[2], v[3]+0.2, tocolor(255, 0, 0, 255), 20)
    end
end)

addCommandHandler("getqtable", function()
    if getElementData(localPlayer, "aclLogin") then
        setClipboard(toJSON(createdPositionTable))
    end
end)

--
addCommandHandler ( "gvc",
    function ( )
        if getElementData(localPlayer, "aclLogin") then
            local theVehicle = getPedOccupiedVehicle ( localPlayer )
            if ( theVehicle ) then
                for k in pairs ( getVehicleComponents ( theVehicle ) ) do
                    outputChatBox ( k )
                end
            end
        end
    end
)

-- streamed objects 

function showStreamedObjects()
    local streamedObjects = 0
    for k, v in ipairs(getElementsByType("object", root, true)) do 
        streamedObjects = streamedObjects + 1
        local x, y, z = getElementPosition(v) 
        dxDrawLine3D(x, y, z, x, y, z + 100, tocolor(255, 0, 0), 2)
    end
    dxDrawText(streamedObjects, 0, 0)
end

local showState = false 
addCommandHandler("showstreamedelements", function()
    if getElementData(localPlayer, "aclLogin") then
        showState = not showState 

        if showState then 
            addEventHandler("onClientRender", root, showStreamedObjects)
        else
            removeEventHandler("onClientRender", root, showStreamedObjects)
        end
    end
end)

-- easter
bindKey("-", "up", function()
    if getElementData(localPlayer, "aclLogin") then
        local randomSkins = {7, 9, 10, 12, 14, 17, 18, 19, 41, 53, 88, 91, 148, 151, 190}
        local randomNames = {"Olivia", "Emma", "Ava", "Sophia", "Isabella", "Charlotte", "Amelia", "Mia", "Layla", "Lily", "Sofia", "Luna", "Lucy", "Willow", "Summer", "Catalina", "Juliana"}

        local posX, posY, posZ = getElementPosition(localPlayer)
        local _, _, rotZ = getElementRotation(localPlayer)

        setClipboard("{"..randomSkins[math.random(#randomSkins)]..", "..posX..", "..posY..", "..posZ..", "..rotZ..", '"..randomNames[math.random(#randomNames)].."'},")
    end
end)

addCommandHandler("decrease", function(cmd, num, dec, times)
    if getElementData(localPlayer, "aclLogin") then
        if num and dec and times then
            local num = tonumber(num)
            local dec = tonumber(dec)
            for i = 1, times do 
                num = num - dec
                outputChatBox(num)
            end
        else
            outputChatBox("/"..cmd.." [Number] [Decreas] [Times]")
        end
    end
end)

addCommandHandler("increase", function(cmd, num, dec, times)
    if getElementData(localPlayer, "aclLogin") then
        if num and dec and times then
            local num = tonumber(num)
            local dec = tonumber(dec)
            for i = 1, times do 
                num = num + dec
                outputChatBox(num)
            end
        else
            outputChatBox("/"..cmd.." [Number] [Increas] [Times]")
        end
    end
end)