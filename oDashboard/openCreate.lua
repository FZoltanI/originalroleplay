raritys = {
    {name = "COMMON", color = {199, 199, 199}, scroll = 0}, -- common
    {name = "RARE", color = {105, 199, 250}, scroll = 0}, -- rare
    {name = "EPIC", color = {139, 105, 250}, scroll = 0}, -- epic 
    {name = "LEGENDARY", color = {252, 163, 38}, scroll = 0}, -- legendary
}

openedCreateDatas = {
    boxes = {},
    opened = false,
    name = "",
    icon = "",
    availableLoots = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
    },
    allLootCount = 0,
}


local openTick = getTickCount()
local animType = "open"
bgAnimationValue = 0

local winnerTick = getTickCount()
local winnerType = "open"
local winnerAnimation = 0

local inOpening = false

local _defStartX = -sx

local animationEasing = "InOutQuad"

local winnerItem = false

local rot = 0


function renderOpening()
    if animType == "open" then
        bgAnimationValue = interpolateBetween(bgAnimationValue, 0, 0, 1, 0, 0, (getTickCount() - openTick) / 1000, animationEasing)
    elseif animType == "close" then
        bgAnimationValue = interpolateBetween(bgAnimationValue, 0, 0, 0, 0, 0, (getTickCount() - openTick) / 1000, animationEasing)
    end
    dxDrawImage(0, 0, sx, sy * bgAnimationValue, "files/open_bg.png")

    dxDrawImage(sx*0.5 - (144/myX*sx*bgAnimationValue), sy*0.065, 288/myX*sx*bgAnimationValue, 202.88/myY*sy*bgAnimationValue, "files/cases/"..openedCreateDatas.icon..".png")
    dxDrawText(openedCreateDatas.name, 0, sy*0.275, sx, sy*0.275, tocolor(255, 255, 255, 255 * bgAnimationValue), 1 * bgAnimationValue, font:getFont("p_bo", 40/myX*sx), "center", "center", false, false, false, false, false, -5)
    --dxDrawRectangle(0, sy*0.5 - (sy*0.15 * bgAnimationValue), sx, sy*0.3 * bgAnimationValue, tocolor(30, 30, 30, 150))
    --dxDrawImage(sx*0.5 - 10/myX*sx, sy*0.5 - (sy*0.15 * bgAnimationValue) - 0.007*sy, 20/myX*sx, 20/myY*sy, "files/cucc.png")
    --local startX = interpolateBetween(0, 0, 0, sx, 0, 0, (getTickCount() - spinTick) / 2000, "Linear")
    --if startX == 0 then 
      --  spinTick = getTickCount()
    --end

    if not openedCreateDatas.opened then 
        core:dxDrawButton(sx*0.45, sy*0.66, sx*0.1, sy*0.035, r, g, b, 220 * bgAnimationValue, "Nyitás", tocolor(255, 255, 255, 255 * bgAnimationValue), 1, font:getFont("condensed", 11/myX*sx), true, tocolor(0, 0, 0, 50 * bgAnimationValue))
    end

    startX = -sx*0.06

    for i = 1, 9 do 
        local w, h, a = sx*0.12, sy*0.27, 255

        v = openedCreateDatas.boxes[i]
        dxDrawRectangle(startX, sy*0.5 - h/2, w, h, tocolor(35, 35, 35, a * bgAnimationValue))
        dxDrawImage(startX, sy*0.5 - h/2, w, h, "files/rarity.png", 0, 0, 0, tocolor(raritys[v.rarity].color[1], raritys[v.rarity].color[2], raritys[v.rarity].color[3], 100 * bgAnimationValue))
        core:dxDrawOutLine(startX, sy*0.5 - h/2, w, h, tocolor(raritys[v.rarity].color[1], raritys[v.rarity].color[2], raritys[v.rarity].color[3], 255 * bgAnimationValue), 2)
        dxDrawText(raritys[v.rarity].name, startX + 10/myX*sx, sy*0.5 - h/2 + 8/myY*sy, _, _, tocolor(raritys[v.rarity].color[1], raritys[v.rarity].color[2], raritys[v.rarity].color[3], 200 * bgAnimationValue), 1, font:getFont("p_ba", 11/myX*sx))

        if v.type == 1 then
            dxDrawImage(startX + w/2 - 35/myX*sx, sy*0.5 - 60/myY*sy, 70/myX*sx, 70/myY*sy, inventory:getItemImage(v.item, v.itemvalue), 0, 0, 0, tocolor(255, 255, 255, 255 * bgAnimationValue))
            dxDrawText(inventory:getItemName(v.item, v.itemvalue), startX, sy*0.53, startX + w, sy*0.53, tocolor(255, 255, 255, 200 * bgAnimationValue), 1, font:getFont("p_bo", 12/myX*sx), "center", "center")
        elseif v.type == 2 then 
            dxDrawImage(startX + w/2 - 35/myX*sx, sy*0.5 - 60/myY*sy, 70/myX*sx, 70/myY*sy, "files/daily/dollar.png", 0, 0, 0, tocolor(255, 255, 255, 255 * bgAnimationValue))
            dxDrawText(v.money .. "$", startX, sy*0.53, startX + w, sy*0.53, tocolor(255, 255, 255, 200 * bgAnimationValue), 1, font:getFont("p_bo", 12/myX*sx), "center", "center")
        elseif v.type == 3 then 
            dxDrawImage(startX + w/2 - 35/myX*sx, sy*0.5 - 60/myY*sy, 70/myX*sx, 70/myY*sy, "files/daily/pp.png", 0, 0, 0, tocolor(255, 255, 255, 255 * bgAnimationValue))
            dxDrawText(v.money .. "PP", startX, sy*0.53, startX + w, sy*0.53, tocolor(255, 255, 255, 200 * bgAnimationValue), 1, font:getFont("p_bo", 12/myX*sx), "center", "center")
        elseif v.type == 4 then 
            dxDrawImage(startX + w/2 - 35/myX*sx, sy*0.5 - 60/myY*sy, 70/myX*sx, 70/myY*sy, "files/daily/house.png", 0, 0, 0, tocolor(255, 255, 255, 255 * bgAnimationValue))
            dxDrawText(v.money .. " ingatlan slot", startX, sy*0.53, startX + w, sy*0.53, tocolor(255, 255, 255, 200 * bgAnimationValue), 1, font:getFont("p_bo", 12/myX*sx), "center", "center")
        elseif v.type == 5 then 
            dxDrawImage(startX + w/2 - 35/myX*sx, sy*0.5 - 60/myY*sy, 70/myX*sx, 70/myY*sy, "files/daily/car.png", 0, 0, 0, tocolor(255, 255, 255, 255 * bgAnimationValue))
            dxDrawText(v.money .. " jármű slot", startX, sy*0.53, startX + w, sy*0.53, tocolor(255, 255, 255, 200 * bgAnimationValue), 1, font:getFont("p_bo", 12/myX*sx), "center", "center")
        end

        startX = startX + sx*0.125
    end

    local panelW, panelH = sx*0.63, sy*0.195
    local panelX, panelY = sx*0.5 - panelW/2, sy - (sy*0.25 * bgAnimationValue)
    core:drawWindow(panelX, panelY, panelW, panelH, "Elérhető itemek - "..openedCreateDatas.name, bgAnimationValue)

    local startX = panelX + sx*0.007
    for i = 1, 4 do 
        dxDrawRectangle(startX, panelY + sy*0.03, sx*0.15, sy*0.025, tocolor(30, 30, 30, 100 * bgAnimationValue))
        dxDrawText(raritys[i].name, startX, panelY + sy*0.03, startX + sx*0.15, panelY + sy*0.03 + sy*0.025, tocolor(raritys[i].color[1], raritys[i].color[2], raritys[i].color[3], 255 * bgAnimationValue), 1, font:getFont("p_bo", 11/myX*sx), "center", "center")

        local startY = panelY + sy*0.03 + sy*0.025
        for i2 = 1, 5 do 
            local isSecond = 1

            if (i2%2 == 0) then 
                isSecond = 0.5
            end

            dxDrawRectangle(startX, startY, sx*0.148, sy*0.025, tocolor(30, 30, 30, 200 * isSecond * bgAnimationValue))

            if openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll] then 
                local name = "asd"

                if openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].type == 1 then 
                    name = inventory:getItemName(openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].item, openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].itemvalue)
                elseif openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].type == 2 then 
                    name = openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].money .. "$"
                elseif openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].type == 3 then 
                    name = openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].money .. "PP"
                elseif openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].type == 4 then 
                    name = openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].money .. " ingatlan slot"
                elseif openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].type == 5 then 
                    name = openedCreateDatas.availableLoots[i][i2 + raritys[i].scroll].money .. " jármű slot"
                end

                dxDrawText(name, startX + sx*0.003, startY, startX + sx*0.003+sx*0.148, startY+sy*0.025, tocolor(255, 255, 255, 255 * bgAnimationValue), 1, font:getFont("condensed", 9/myX*sx), "left", "center")
            end

            startY = startY + sy*0.025
        end

        core:dxDrawScrollbar(startX + sx*0.148, panelY + sy*0.03 + sy*0.025, sx*0.002, sy*0.125, openedCreateDatas.availableLoots[i], raritys[i].scroll, 5, raritys[i].color[1], raritys[i].color[2], raritys[i].color[3], bgAnimationValue)


        startX = startX + sx*0.155
    end

    if winnerItem then 
        if winnerType == "open" then
            winnerAnimation = interpolateBetween(winnerAnimation, 0, 0, 1, 0, 0, (getTickCount() - winnerTick) / 1000, animationEasing)
        elseif winnerType == "close" then
            winnerAnimation = interpolateBetween(winnerAnimation, 0, 0, 0, 0, 0, (getTickCount() - winnerTick) / 1000, animationEasing)
        end

        
        dxDrawImage(sx*0.5 - 350/myX*sx*winnerAnimation, sy*0.5 - 350/myY*sy*winnerAnimation, 700/myX*sx*winnerAnimation, 700/myY*sy*winnerAnimation, "files/effect.png", rot, 0, 0, tocolor(255, 255, 255, 255*winnerAnimation))
        rot = rot + 0.6

        local displaytext = ""
        if winnerItem.type == 1 then
            dxDrawImage(sx*0.5 - 40/myX*sx*winnerAnimation, sy*0.49 - 40/myY*sy*winnerAnimation, 80/myX*sx*winnerAnimation, 80/myY*sy*winnerAnimation, inventory:getItemImage(winnerItem.item, winnerItem.itemvalue), 0, 0, 0, tocolor(255, 255, 255, 255 * winnerAnimation))
            --core:dxDrawOutLine(sx*0.5 - 40/myX*sx*winnerAnimation, sy*0.49 - 40/myY*sy*winnerAnimation, 80/myX*sx*winnerAnimation, 80/myY*sy*winnerAnimation, tocolor(raritys[winnerItem.rarity].color[1], raritys[winnerItem.rarity].color[2], raritys[winnerItem.rarity].color[3], 255 * winnerAnimation), 2)

            displaytext = inventory:getItemName(winnerItem.item, winnerItem.itemvalue)
        elseif winnerItem.type == 2 then 
            dxDrawImage(sx*0.5 - 60/myX*sx*winnerAnimation, sy*0.49 - 60/myY*sy*winnerAnimation, 120/myX*sx*winnerAnimation, 120/myY*sy*winnerAnimation, "files/daily/dollar.png", 0, 0, 0, tocolor(255, 255, 255, 255 * winnerAnimation))
            displaytext = winnerItem.money.."$"
        elseif winnerItem.type == 3 then 
            dxDrawImage(sx*0.5 - 60/myX*sx*winnerAnimation, sy*0.49 - 60/myY*sy*winnerAnimation, 120/myX*sx*winnerAnimation, 120/myY*sy*winnerAnimation, "files/daily/pp.png", 0, 0, 0, tocolor(255, 255, 255, 255 * winnerAnimation))
            displaytext = winnerItem.money.."PP"
        elseif winnerItem.type == 4 then 
            dxDrawImage(sx*0.5 - 60/myX*sx*winnerAnimation, sy*0.49 - 60/myY*sy*winnerAnimation, 120/myX*sx*winnerAnimation, 120/myY*sy*winnerAnimation, "files/daily/house.png", 0, 0, 0, tocolor(255, 255, 255, 255 * winnerAnimation))
            displaytext = winnerItem.money.." ingatlan slot"
        elseif winnerItem.type == 5 then 
            dxDrawImage(sx*0.5 - 60/myX*sx*winnerAnimation, sy*0.49 - 60/myY*sy*winnerAnimation, 120/myX*sx*winnerAnimation, 120/myY*sy*winnerAnimation, "files/daily/car.png", 0, 0, 0, tocolor(255, 255, 255, 255 * winnerAnimation))
            displaytext = winnerItem.money.." jármű slot"
        end

        local textw = dxGetTextWidth(displaytext, 1 * winnerAnimation, font:getFont("p_bo", 40/myX*sx))
        dxDrawText(displaytext, 0, sy*0.56, sx, sy*0.56, tocolor(255, 255, 255, 255 * winnerAnimation), 1 * winnerAnimation, font:getFont("p_bo", 40/myX*sx), "center", "center", false, false, false, false, false, -5)
        --dxDrawText(raritys[winnerItem.rarity].name, sx*0.5 - textw/2 - sx*0.005, sy*0.56, textw, sy*0.57, tocolor(raritys[winnerItem.rarity].color[1], raritys[winnerItem.rarity].color[2], raritys[winnerItem.rarity].color[3], 255 * winnerAnimation), 1 * winnerAnimation, font:getFont("p_ba", 10/myX*sx), "left", "center", false, false, false, false, false, 5)

    end
end

function clickOpening(button, state)
    if state then 
        if button == "mouse1" then 
            if core:isInSlot(sx*0.45, sy*0.66, sx*0.1, sy*0.035) then 
                if not openedCreateDatas.opened then 
                    openedCreateDatas.opened = true 
                    startOpen()
                end
            end
        elseif button == "mouse_wheel_up" then 
            local panelW, panelH = sx*0.63, sy*0.195
            local panelX, panelY = sx*0.5 - panelW/2, sy*0.75
            local startX = panelX + sx*0.007
            for i = 1, 4 do 
                if core:isInSlot(startX, panelY + sy*0.03, sx*0.15, sy*0.15) then 
                    if raritys[i].scroll > 0 then 
                        raritys[i].scroll = raritys[i].scroll - 1
                    end
                end

                startX = startX + sx*0.155
            end
        elseif button == "mouse_wheel_down" then 
            local panelW, panelH = sx*0.63, sy*0.195
            local panelX, panelY = sx*0.5 - panelW/2, sy*0.75
            local startX = panelX + sx*0.007
            for i = 1, 4 do 
                if core:isInSlot(startX, panelY + sy*0.03, sx*0.15, sy*0.15) then 
                    if openedCreateDatas.availableLoots[i][raritys[i].scroll + 6] then 
                        raritys[i].scroll = raritys[i].scroll + 1
                    end
                end

                startX = startX + sx*0.155
            end
        end
    end
end

local bg_music = nil 
function insertNewElement()
    local rarity = 1
    local rand = math.random(1, 100)

    if rand > 50 and rand <= 80 then
        rarity = 2 
    elseif rand > 80 and rand <= 95 then 
        rarity = 3
    elseif rand > 95 then 
        rarity = 4
    end

    table.insert(openedCreateDatas.boxes, 1, openedCreateDatas.availableLoots[rarity][math.random(#openedCreateDatas.availableLoots[rarity])])
end

function openSelectedCreate(createName, createIcon, selectedCreateItems)
    if not inOpening then 
        inOpening = true
        openTick = getTickCount()
        animType = "open"

        addEventHandler("onClientRender", root, renderOpening)
        addEventHandler("onClientKey", root, clickOpening)

        raritys[1].scroll = 0
        raritys[2].scroll = 0
        raritys[3].scroll = 0
        raritys[4].scroll = 0

        openedCreateDatas.opened = false
        openedCreateDatas.boxes = {}
        openedCreateDatas.allLootCount = 0
        openedCreateDatas.availableLoots = {
            [1] = {},
            [2] = {},
            [3] = {},
            [4] = {},
        }

        for k, v in ipairs(selectedCreateItems) do 
            table.insert(openedCreateDatas.availableLoots[v.rarity], v)
            openedCreateDatas.allLootCount = openedCreateDatas.allLootCount + 1
        end

        openedCreateDatas.name = createName
        openedCreateDatas.icon = createIcon

        for i = 1, 9 do
            insertNewElement()
        end

        return true
    end
end

function playOpenSounds(type)
    if type == "opening" then 
        playSound("files/opening.mp3")
    end
end

function openingEnd()
    playOpenSounds("end")
    animType = "close"
    openTick = getTickCount()

    rot = 0
    winnerItem = openedCreateDatas.boxes[5]
    winnerTick = getTickCount()
    winnerType = "open"
    playSound("files/opened_case.mp3")

    showChat(true)
    interface:toggleHud(false)

    if winnerItem.type == 1 then
        outputChatBox(core:getServerPrefix("server", "Case", 2).."Kinyitottál egy "..color..inventory:getItemName(winnerItem.item, winnerItem.itemvalue).."#ffffff-et egy "..color..openedCreateDatas.name.."#ffffff boxból.", 255, 255, 255, true)
        inventory:giveItem(winnerItem.item, winnerItem.itemvalue, 1, 0)
    elseif winnerItem.type == 2 then
        outputChatBox(core:getServerPrefix("server", "Case", 2).."Kinyitottál "..color..winnerItem.money.."$#ffffff-t egy "..color..openedCreateDatas.name.."#ffffff boxból.", 255, 255, 255, true)
        setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + winnerItem.money)
    elseif winnerItem.type == 3 then
        outputChatBox(core:getServerPrefix("server", "Case", 2).."Kinyitottál "..color..winnerItem.money.."PP#ffffff-t egy "..color..openedCreateDatas.name.."#ffffff boxból.", 255, 255, 255, true)
        setElementData(localPlayer, "char:pp", getElementData(localPlayer, "char:pp") + winnerItem.money)
    elseif winnerItem.type == 4 then
        outputChatBox(core:getServerPrefix("server", "Case", 2).."Kinyitottál "..color..winnerItem.money.." ingatlasn slotot#ffffff egy "..color..openedCreateDatas.name.."#ffffff boxból.", 255, 255, 255, true)
        setElementData(localPlayer, "char:intSlot", getElementData(localPlayer, "char:intSlot") + winnerItem.money)
    elseif winnerItem.type == 5 then
        outputChatBox(core:getServerPrefix("server", "Case", 2).."Kinyitottál "..color..winnerItem.money.." jármű slotot#ffffff egy "..color..openedCreateDatas.name.."#ffffff boxból.", 255, 255, 255, true)
        setElementData(localPlayer, "char:vehSlot", getElementData(localPlayer, "char:vehSlot") + winnerItem.money)
    end

    setTimer(function()
        winnerType = "close"
        winnerTick = getTickCount()

        setTimer(function()
            removeEventHandler("onClientRender", root, renderOpening)
            removeEventHandler("onClientKey", root, clickOpening)        
            inOpening = false
        end, 1200, 1)
    end, 7000, 1)
end

function startOpen()
    local counts = {math.random(40, 100), math.random(5, 20), math.random(1, 5)}

    setTimer(function()
        playOpenSounds("opening")
        insertNewElement()
        table.remove(openedCreateDatas.boxes, #openedCreateDatas.boxes)
    end, 100, counts[1])

    setTimer(function()
        setTimer(function()
            playOpenSounds("opening")
            insertNewElement()
            table.remove(openedCreateDatas.boxes, #openedCreateDatas.boxes)
        end, 250, counts[2])

        setTimer(function()
            setTimer(function()
                playOpenSounds("opening")
                insertNewElement()
                table.remove(openedCreateDatas.boxes, #openedCreateDatas.boxes)
            end, 500, counts[3])

            setTimer(function()
                openingEnd()
            end, 500 * counts[3] + 1000, 1)
        end, 250 * counts[2], 1)

    end, 100 * counts[1] + 50, 1)
end


--[[openSelectedCreate("EASTER BOX 2K22", "easter",{
    {item = 2, rarity = 1, money = 0, type = 1, itemvalue = 1},
    {item = 88, rarity = 1, money = 0, type = 1, itemvalue = 1},
    {item = 13, rarity = 1, money = 0, type = 1, itemvalue = 1},
    {item = 18, rarity = 1, money = 0, type = 1, itemvalue = 1},
    {item = 22, rarity = 1, money = 0, type = 1, itemvalue = 1},
    {item = 212, rarity = 2, money = 0, type = 1, itemvalue = 1},
    {item = 214, rarity = 2, money = 0, type = 1, itemvalue = 1},
    {item = 159, rarity = 2, money = 0, type = 1, itemvalue = 1},
    {item = 76, rarity = 3, money = 0, type = 1, itemvalue = 1},
    {item = 135, rarity = 4, money = 0, type = 1, itemvalue = 1},
    {item = 195, rarity = 4, money = 0, type = 1, itemvalue = 1},
    {item = 0, rarity = 2, money = 3000, type = 2, itemvalue = 1},
    {item = 0, rarity = 3, money = 5000, type = 2, itemvalue = 1},
    {item = 0, rarity = 4, money = 7500, type = 2, itemvalue = 1},
    {item = 0, rarity = 3, money = 70, type = 3, itemvalue = 1},
    {item = 0, rarity = 4, money = 120, type = 3, itemvalue = 1},
})]]
