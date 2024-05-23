exports.oCompiler:loadCompliedModel(16340, "rS)#49WmJ&c/R!rH", ":oMushrooms/files/mushroom1dff.originalmodel", ":oMushrooms/files/mushroomstxd.originalmodel", false, false)
exports.oCompiler:loadCompliedModel(16230, "rS)#49WmJ&c/R!rH", ":oMushrooms/files/mushroom2dff.originalmodel", ":oMushrooms/files/mushroomstxd.originalmodel", false, false)
exports.oCompiler:loadCompliedModel(16242, "rS)#49WmJ&c/R!rH", ":oMushrooms/files/mushroom3dff.originalmodel", ":oMushrooms/files/mushroomstxd.originalmodel", false, false)
exports.oCompiler:loadCompliedModel(16240, "rS)#49WmJ&c/R!rH", ":oMushrooms/files/mushroom4dff.originalmodel", ":oMushrooms/files/mushroomstxd.originalmodel", false, false)
exports.oCompiler:loadCompliedModel(16147, "rS)#49WmJ&c/R!rH", ":oMushrooms/files/mushroom5dff.originalmodel", ":oMushrooms/files/mushroomstxd.originalmodel", false, false)

local inCol = false

local occupiedCol = false
local occupiedColMushroom = false
local occupiedColType = 0

local startedPicking= false

local progressbar_datas = {"nan", 0}
local tick = getTickCount()

addEventHandler("onClientColShapeHit", root, function(element, mdim)
    if mdim then 
        if element == localPlayer then 
            if getElementData(source, "mushroom:type") then 
                if not inCol then 
                    inCol = true
                    occupiedColMushroom = getElementData(source, "mushroom:object")
                    occupiedColType = getElementData(source, "mushroom:type")
                    occupiedCol = source
                    addEventHandler("onClientRender", root, interactionRender)
                    bindKey("e", "up", pickUpMushroom)
                end
            end
        end
    end
end)

addEventHandler("onClientColShapeLeave", root, function(element, mdim)
    if mdim then 
        if element == localPlayer then 
            if getElementData(source, "mushroom:type") then 
                if inCol then 
                    inCol = false
                    occupiedCol = false
                    removeEventHandler("onClientRender", root, interactionRender)
                    unbindKey("e", "up", pickUpMushroom)
                end
            end
        end
    end
end)

local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local fonts = {
    ["condensed-14"] = exports.oFont:getFont("condensed", 14),
}

function interactionRender()
    if not isElement(occupiedCol) then 
        inCol = false
        occupiedCol = false
        removeEventHandler("onClientRender", root, interactionRender)
        unbindKey("e", "up", pickUpMushroom)
    end

    core:dxDrawShadowedText("A gomba felvételéhez nyomd meg az "..color.."[E] #ffffffgombot.", 0, sy*0.89, sx, sy*0.89+sy*0.05, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 0.8/myX*sx, fonts["condensed-14"], "center", "center", false, false, false, true)
end

local progressBarAnimType = "open"
local progressBarAnimTick = getTickCount()
function renderProgressBar()
    local alpha
    
    if progressBarAnimType == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - progressBarAnimTick)/250, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - progressBarAnimTick)/250, "Linear")
    end

    local line_height = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick)/progressbar_datas[2], "Linear")

    dxDrawRectangle(sx*0.4, sy*0.85, sx*0.2, sy*0.02, tocolor(40, 40, 40, 255*alpha))
    dxDrawRectangle(sx*0.401, sy*0.852, (sx*0.2-sx*0.002), sy*0.02-sy*0.004, tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(sx*0.401, sy*0.852, (sx*0.2-sx*0.002)*line_height, sy*0.02-sy*0.004, tocolor(r, g, b, 255*alpha))

    dxDrawText(progressbar_datas[1], sx*0.4, sy*0.85, sx*0.4+sx*0.2, sy*0.85+sy*0.02, tocolor(35, 35, 35, 255*alpha), 0.6/myX*sx, fonts["condensed-14"], "center", "center", false, false, false, true)
end

local lastItemGive = 0
function pickUpMushroom()
    if not getPedOccupiedVehicle(localPlayer) then 
        if startedPicking then return end 
        startedPicking = true
        setElementData(localPlayer, "mushroom:mushroomPickingUp", true)
        triggerServerEvent("mushroom > startPickup", resourceRoot, occupiedCol)
        inCol = false
        occupiedCol = false
        removeEventHandler("onClientRender", root, interactionRender)
        unbindKey("e", "up", pickUpMushroom)
        setElementFrozen(localPlayer, true)

        tick = getTickCount()
        progressbar_datas = {"Gomba felszedése", 8000}
        progressBarAnimType = "open"
        progressBarAnimTick = getTickCount()

        addEventHandler("onClientRender", root, renderProgressBar)

        triggerServerEvent("mushroom > setAnimation", resourceRoot, "BOMBER", "BOM_Plant")

        setTimer(function()
            startedPicking = false
            setElementData(localPlayer, "mushroom:mushroomPickingUp", false)

            setElementFrozen(localPlayer, false)
            progressBarAnimType = "close"
            progressBarAnimTick = getTickCount()    
            
            if lastItemGive + 7000 < getTickCount() then
                lastItemGive = getTickCount()
                triggerServerEvent("mushroom > endMushroomPickup", resourceRoot, occupiedColMushroom, occupiedColType, {getElementPosition(occupiedColMushroom)}, true)
                exports.oChat:sendLocalMeAction("felvett egy "..(mushroom_types[occupiedColType].name).."-(e)t.")
            else
                lastItemGive = getTickCount()
                triggerServerEvent("mushroom > endMushroomPickup", resourceRoot, occupiedColMushroom, occupiedColType, {getElementPosition(occupiedColMushroom)}, false)
                exports.oChat:sendLocalMeAction("felvett egy "..(mushroom_types[occupiedColType].name).."-(e)t.")
            end

            setTimer(function() removeEventHandler("onClientRender", root, renderProgressBar) end, 250, 1)
        end, 8000, 1)
    end
end

--[[bindKey("F5", "up", function()
    local pos = Vector3(getElementPosition(localPlayer))

    local string = pos.x..", "..pos.y..", "..pos.z 

    setClipboard(string)
end)]]

--[[local lines = {}

function generateRandomPositions()
    local minX, minY = 2697.5300292969,256.85409545898
    local maxX, maxY = 1897.9416503906,-392.06503295898

    print(math.floor(math.abs(math.min(minX, maxX) - math.max(minX, maxX))/5))
    for i = 1, math.floor(math.abs(math.min(minX, maxX) - math.max(minX, maxX))/5) do 
        randomX = math.random(math.min(minX, maxX), math.max(minX, maxX))
        randomY = math.random(math.min(minY, maxY), math.max(minY, maxY))

        local hit, _, _, _, _, _, _, _, surface = processLineOfSight(randomX, randomY, -10, randomX, randomY, 100) 
        if hit then
            if (surface == 13) or (surface == 14) or (surface == 15) or (surface == 9) or (surface == 10) or (surface == 11) or (surface == 12)  then 
                local randomZ =  getGroundPosition(randomX, randomY, 100)
                table.insert(lines, {randomX, randomY, randomZ})

                local randType = math.random(#mushroom_types)
                setElementCollisionsEnabled(createObject(mushroom_types[randType].modelID, randomX, randomY, randomZ, 90, 0, 0), false)
            end
        end
    end 

    setClipboard(toJSON(lines))
    outputChatBox(#lines .. " db gomba létrehozva")
end
generateRandomPositions()

addEventHandler("onClientRender", root, function()
    for k, v in ipairs(lines) do 
        --print("asd")
        dxDrawLine3D(v[1], v[2], -10, v[1], v[2], 100, tocolor(255, 100, 0, 255), 3)
        dxDrawLine3D(v[1], v[2], v[3], v[1], v[2], v[3]+0.2, tocolor(255, 0, 0, 255), 5)
    end
end)]]