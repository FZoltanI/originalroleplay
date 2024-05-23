local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local randomPoems = {}
local poemsCache = {}

local alpha, tick, animType = 0, 0, "open"

local font = exports.oFont

function renderPanel()
    if animType == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount() - tick) / 250, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount() - tick) / 250, "Linear")
    end

    dxDrawRectangle(sx*0.4, sy*0.25, sx*0.2, sy*0.338, tocolor(30, 30, 30, 100 * alpha))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.25 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.338 - 4/myY*sy, tocolor(35, 35, 35, 255 * alpha))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.25 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.025, tocolor(30, 30, 30, 255 * alpha))
    dxDrawText("Válassz locsolóverset!", sx*0.4 + 2/myX*sx, sy*0.25 + 2/myY*sy, sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx, sy*0.25 + 2/myY*sy + sy*0.025, tocolor(r, g, b, 100 * alpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center")

    local startY = sy*0.28
    for i = 1, 3 do 
        if core:isInSlot(sx*0.4 + 4/myX*sx, startY, sx*0.2 - 8/myX*sx, sy*0.1) then 
            dxDrawRectangle(sx*0.4 + 4/myX*sx, startY, sx*0.2 - 8/myX*sx, sy*0.1, tocolor(r, g, b, 100 * alpha))
        else
            dxDrawRectangle(sx*0.4 + 4/myX*sx, startY, sx*0.2 - 8/myX*sx, sy*0.1, tocolor(37, 37, 37, 255 * alpha))
        end

        dxDrawText(randomPoems[i], sx*0.4 + 20/myX*sx, startY, sx*0.4 + 4/myX*sx + sx*0.2 - 24/myX*sx, startY + sy*0.1, tocolor(255, 255, 255, 200 * alpha), 1, font:getFont("condensed", 10/myX*sx), "center", "center", false, true)

        startY = startY + sy*0.1 + 2/myY*sy
    end

    showCursor(true)
end

function keyPanel(key, state)
    if key == "mouse1" and state then 
        local startY = sy*0.28
        for i = 1, 3 do 
            if core:isInSlot(sx*0.4 + 4/myX*sx, startY, sx*0.2 - 8/myX*sx, sy*0.1) then 
                chat:sendLocalMeAction("meglocsolt egy lányt.")
                outputChatBox(getElementData(localPlayer, "char:name"):gsub("_", " ").." mondja: "..randomPoems[i], 255, 255, 255)

                if math.random(100) < 70 then 
                    playSound("success.mp3")
                    outputChatBox(core:getServerPrefix("green-dark", "Easter", 2).."A lánynak tetszett a vers ezért kaptál tőle egy húsvéti tojást.", 255, 255, 255, true)
                    inventory:giveItem(205, 1, 1, 0)
                else
                    playSound("fail.mp3")
                    outputChatBox(core:getServerPrefix("red-dark", "Easter", 2).."A lánynak nem tetszett a vers ezért nem kaptál tőle húsvéti tojást.", 255, 255, 255, true)
                end

                closePanel()
            end

            startY = startY + sy*0.1 + 2/myY*sy
        end
    end
end

function openPanel()
    poemsCache = poems 
    randomPoems = {}

    for i = 1, 3 do 
        local randomPoem = math.random(#poemsCache)
        table.insert(randomPoems, poemsCache[randomPoem])
        table.remove(poemsCache, randomPoem)
    end
    
    tick = getTickCount()
    animType = "open"
    
    addEventHandler("onClientRender", root, renderPanel)
    addEventHandler("onClientKey", root, keyPanel)
end

function closePanel()
    showCursor(false)
    tick = getTickCount()
    animType = "close"
    removeEventHandler("onClientKey", root, keyPanel)

    setTimer(function()
        removeEventHandler("onClientRender", root, renderPanel)
        showCursor(false)
    end, 250, 1)
end

local serverTick = 0
local selectedPed = false
local floodClick = 0 
local floodTimer = false

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if element then 
            if getElementData(element, "easterPed") then 
                if core:getDistance(localPlayer, element) < 3 then 
                    if not isTimer(floodTimer) then
                        local hasItem = {inventory:hasItem(204)}
                        if hasItem[1] then 
                            selectedPed = element
                            triggerServerEvent("getServerTick", resourceRoot)
                            --local itemWeight = inventory:getItemWeight(hasItem[2].item) * hasItem[2].count
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Easter", 2).."Nincs nálad kölni!", 255, 255, 255, true)
                        end
                    end
                end
            end 
        end
    end
end)

addEvent("returnServerTickFromServer", true)
addEventHandler("returnServerTickFromServer", root, function(sTick)
    serverTick = math.floor(sTick/1000)

    local pedLast = getElementData(selectedPed, "easterPed:last:"..getElementData(localPlayer, "char:id")) or 0

    if pedLast + 3600 < serverTick then 
        print(pedLast, serverTick)

        local hasItem = {inventory:hasItem(204)}
        if hasItem[1] then 
            inventory:setItemState(hasItem[3], hasItem[2].state - 1)
        end

        openPanel()

        setElementData(selectedPed, "easterPed:last:"..getElementData(localPlayer, "char:id"), serverTick)
    else
        floodClick = floodClick + 1

        outputChatBox(core:getServerPrefix("red-dark", "Easter", 2).."Egy lányt csak "..color.."1 #ffffffóránként locsolhatsz meg.", 255, 255, 255, true)

        if floodClick >= 10 then 
            floodClick = 0
            floodTimer = setTimer(function()
                if isTimer(floodTimer) then killTimer(floodTimer) end
            end, core:minToMilisec(1), 1)

            outputChatBox(core:getServerPrefix("red-dark", "Flood", 3).."Flood miatt a funkció 1 percig letiltásra került.", 255, 255, 255, true)
        end

    end
end)

setTimer(function()
    if floodClick > 0 then 
        floodClick = floodClick - 1
    end
end, 2000, 0)