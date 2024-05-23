local craftTabels = {
    -- dim int
    {2566.5075683594, -1288.033203125, 1037.7734375, 90, 838, 2}, 
    {2566.5075683594, -1284.033203125, 1037.7734375, 90, 838, 2}, 
    {2566.5075683594, -1292.033203125, 1037.7734375, 90, 838, 2}, 
    {2570.5075683594, -1284.033203125, 1037.7734375, 90, 838, 2}, 
    {2574.5075683594, -1284.033203125, 1037.7734375, 90, 838, 2}, 
}

function createCraftTables()
    for k, v in ipairs(craftTabels) do 
        local table = createObject(941, v[1], v[2], v[3] - 0.5, 0, 0, v[4])
        local mac1 = createObject(934, v[1], v[2], v[3] + 0.35, 0, 0, v[4] - 90)
        local mac2 = createObject(920, v[1], v[2], v[3] + 0.35, 0, 0, v[4] - 90)
        attachElements(mac2, table, 1.15, 0, 0.8, 0, 0, 86)
        setObjectScale(mac1, 0.3)
        setObjectScale(mac2, 0.7)
        setElementCollisionsEnabled(mac1, false)
        setElementCollisionsEnabled(mac2, false)

        setElementDimension(table, v[5])
        setElementDimension(mac1, v[5])
        setElementDimension(mac2, v[5])

        setElementInterior(table, v[6])
        setElementInterior(mac1, v[6])
        setElementInterior(mac2, v[6])

        setElementData(table, "weaponCraftTable", true)
    end
end
createCraftTables()

local _dxDrawText = dxDrawText 

local function dxDrawText(text, x, y, w, h, ...)
    _dxDrawText(text, x, y, x + w, y + h, ...)
end

local myX, myY = 1768, 992
local alpha, animType, openTick = 0, "open", getTickCount()
local scroll = 0
local selectedCraft = 1
local selectedObj = false

local weaponInCraft, weaponInCraftCount, weaponInCraftNeedPercent = 0, 0, 0
local minigameInProgress = false
local minigameTable = false

function renderWeaponCraft()

    if animType == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount() - openTick) / 300, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount() - openTick) / 300, "Linear")
    end

    core:drawWindow(sx*0.4, sy*0.25, sx*0.2, sy*0.5, "Gyár", alpha)

    local startY = sy*0.278
    for i = 1, 7 do 
        if crafts[i + scroll] then 
            local v = crafts[i + scroll]

            if ((i + scroll) % 2) == 0 then 
                dxDrawRectangle(sx*0.4 + 8/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.04, tocolor(30, 30, 30, 200 * alpha))
            else
                dxDrawRectangle(sx*0.4 + 8/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.04, tocolor(30, 30, 30, 150 * alpha))
            end

            if i + scroll == selectedCraft then
                dxDrawText(inventory:getItemName(v.item), sx*0.4 + 12/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.025, tocolor(r, g, b, 200 * alpha), 1, fonts:getFont("condensed", 12/myX*sx), "left", "center")
            else
                dxDrawText(inventory:getItemName(v.item), sx*0.4 + 12/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.025, tocolor(255, 255, 255, 200 * alpha), 1, fonts:getFont("condensed", 12/myX*sx), "left", "center")
            end

            if v.faction then
                if v.faction == 4 then 
                    dxDrawText("Frakció: #f23333Banda", sx*0.4 + 12/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.037, tocolor(255, 255, 255, 100 * alpha), 1, fonts:getFont("condensed", 8/myX*sx), "left", "bottom", false, false, false, true)
                elseif v.faction == 5 then 
                    dxDrawText("Frakció: #f23333Maffia", sx*0.4 + 12/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.037, tocolor(255, 255, 255, 100 * alpha), 1, fonts:getFont("condensed", 8/myX*sx), "left", "bottom", false, false, false, true)
                elseif type(v.faction) == "table" then 
                    dxDrawText("Frakció: #f23333Banda, Maffia", sx*0.4 + 12/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.037, tocolor(255, 255, 255, 100 * alpha), 1, fonts:getFont("condensed", 8/myX*sx), "left", "bottom", false, false, false, true)
                end
            else
                dxDrawText("Frakció: #33f27cNem szükséges", sx*0.4 + 12/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.037, tocolor(255, 255, 255, 100 * alpha), 1, fonts:getFont("condensed", 8/myX*sx), "left", "bottom", false, false, false, true)
            end

            dxDrawText(v.count.."db", sx*0.4 + 8/myX*sx, startY, sx*0.2 - 36/myX*sx, sy*0.04, tocolor(r, g, b, 100 * alpha), 1, fonts:getFont("condensed", 10/myX*sx), "right", "center", false, false, false, true)

            startY = startY + sy*0.043
        end
    end

    local lineHeight = math.min(7 / #crafts, 1) 
    dxDrawRectangle(sx*0.594, sy*0.278, sx*0.0015, sy*0.298, tocolor(30, 30, 30, 200*alpha))
    dxDrawRectangle(sx*0.594, sy*0.278 + (sy*0.298 * (lineHeight * scroll / 7)), sx*0.0015, sy*0.298 * lineHeight, tocolor(r, g, b, 200*alpha)) 

    dxDrawRectangle(sx*0.4 + 8/myX*sx, sy*0.58, sx*0.2 - 16/myX*sx, sy*0.162, tocolor(30, 30, 30, 100 * alpha))
    dxDrawRectangle(sx*0.4 + 8/myX*sx, sy*0.58, sx*0.2 - 16/myX*sx, sy*0.02, tocolor(30, 30, 30, 255 * alpha))
    dxDrawText(inventory:getItemName(crafts[selectedCraft].item), sx*0.4 + 8/myX*sx, sy*0.58, sx*0.2 - 16/myX*sx, sy*0.02, tocolor(255, 255, 255, 100 * alpha), 1, fonts:getFont("condensed", 10/myX*sx), "center", "center")

    dxDrawRectangle(sx*0.4 + 16/myX*sx, sy*0.608, sx*0.08, sy*0.123, tocolor(40, 40, 40, 50 * alpha))
    dxDrawRectangle(sx*0.4 + 16/myX*sx, sy*0.608, sx*0.08, sy*0.02, tocolor(30, 30, 30, 255 * alpha))
    dxDrawText("Szükséges alapanyagok", sx*0.4 + 16/myX*sx, sy*0.608, sx*0.08, sy*0.02, tocolor(255, 255, 255, 100 * alpha), 0.8, fonts:getFont("condensed", 10/myX*sx), "center", "center")

    local startY2 = sy*0.632
    local craftAccepted = 0 
    for k, v in ipairs(crafts[selectedCraft].craftItems) do 
        dxDrawRectangle(sx*0.4 + 18/myX*sx, startY2, sx*0.08 - 4/myX*sx, sy*0.02, tocolor(30, 30, 30, 150 * alpha))

        local hasCraftItem, itemData = inventory:hasItem(v[1])

        local preColor = color
        if hasCraftItem then
            if itemData["count"] >= v[2] then 
                craftAccepted = craftAccepted + 1
            else
                preColor = "#f23333"
            end
        else
            if v[2] > 0 then 
                preColor = "#f23333"
            else
                craftAccepted = craftAccepted + 1
            end
        end

        dxDrawText(inventory:getItemName(v[1])..": "..preColor..v[2].."#ffffffdb", sx*0.4 + 18/myX*sx, startY2, sx*0.08 - 4/myX*sx, sy*0.02, tocolor(255, 255, 255, 255 * alpha), 0.85, fonts:getFont("condensed", 10/myX*sx), "center", "center", false, false, false, true)
        startY2 = startY2 + sy*0.025
    end

    if crafts[selectedCraft].faction then 
        if type(crafts[selectedCraft].faction) == "table" then 
            if dashboard:isPlayerFactionTypeMember(crafts[selectedCraft].faction) then 
                craftAccepted = craftAccepted + 1
            end
        else
            if dashboard:isPlayerFactionTypeMember({crafts[selectedCraft].faction}) then 
                craftAccepted = craftAccepted + 1
            end
        end
    else
        craftAccepted = craftAccepted + 1
    end

    if craftAccepted == 5 then 
        core:dxDrawButton(sx*0.502, sy*0.68, sx*0.08, sy*0.05, r, g, b, 200 * alpha, "Elkészítés", tocolor(255, 255, 255, 255 * alpha), 1, fonts:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 100 * alpha))
    else
        core:dxDrawButton(sx*0.502, sy*0.68, sx*0.08, sy*0.05, r, g, b, 50 * alpha, "Elkészítés", tocolor(255, 255, 255, 100 * alpha), 1, fonts:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 100 * alpha))
    end

    dxDrawImage(sx*0.502 + sx*0.04 - 25/myX*sx, sy*0.615, 50/myX*sx, 50/myY*sy, inventory:getItemImage(crafts[selectedCraft].item), 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))

    if selectedObj then 
        if core:getDistance(selectedObj, localPlayer) > 1.5 then 
            closePanel()
        end
    end
end

function keyCraftPanel(key, state)
    if state then  
        if key == "mouse_wheel_down" then 
            if crafts[scroll + 8] then
                scroll = scroll + 1
            end 
        elseif key == "mouse_wheel_up" then 
            if scroll > 0 then 
                scroll = scroll - 1
            end
        elseif key == "mouse1" then 
            local startY = sy*0.278
            for i = 1, 7 do 
                if crafts[i + scroll] then 
                    if core:isInSlot(sx*0.4 + 8/myX*sx, startY, sx*0.2 - 26/myX*sx, sy*0.04) then
                        selectedCraft = i + scroll
                    end
                    startY = startY + sy*0.043
                end
            end

            local startY2 = sy*0.632
            local craftAccepted = 0 
            for k, v in ipairs(crafts[selectedCraft].craftItems) do         
                local hasCraftItem, itemData = inventory:hasItem(v[1])
        
                if hasCraftItem then
                    if itemData["count"] >= v[2] then 
                        craftAccepted = craftAccepted + 1
                   
                    end
                else
                    if v[2] > 0 then 
                    else
                        craftAccepted = craftAccepted + 1
                    end
                end
            end
        
            if crafts[selectedCraft].faction then 
                if type(crafts[selectedCraft].faction) == "table" then 
                    if dashboard:isPlayerFactionTypeMember(crafts[selectedCraft].faction) then 
                        craftAccepted = craftAccepted + 1
                    end
                else
                    if dashboard:isPlayerFactionTypeMember({crafts[selectedCraft].faction}) then 
                        craftAccepted = craftAccepted + 1
                    end
                end
            else
                craftAccepted = craftAccepted + 1
            end
        
            if core:isInSlot(sx*0.502, sy*0.68, sx*0.08, sy*0.05) then 
                if craftAccepted == 5 then 
                    minigameTable = selectedObj
                    chat:sendLocalMeAction("elkezdte a(z) "..inventory:getItemName(crafts[selectedCraft].item).." elkészítését.")
                    triggerServerEvent("weaponCraft > startWeaponCraft", resourceRoot, crafts[selectedCraft].craftItems)
                    weaponInCraft, weaponInCraftCount, weaponInCraftNeedPercent = crafts[selectedCraft].item, crafts[selectedCraft].count, crafts[selectedCraft].needPercent
                    closePanel()
                    startCraftMinigame()
                else
                    infobox:outputInfoBox("Nincs elegendő alapanyagod vagy nem vagy tagja a szükséges frakciónak!", "error")
                end
            end
        elseif key == "backspace" then 
            closePanel()
        end
    end
end 

local showing = false
function openPanel()
    if not showing then
        addEventHandler("onClientKey", root, keyCraftPanel)
        addEventHandler("onClientRender", root, renderWeaponCraft)
        showing = true
        animType, openTick = "open", getTickCount()
    end
end

function closePanel()
    selectedObj = false
    removeEventHandler("onClientKey", root, keyCraftPanel)
    animType, openTick = "close", getTickCount()
    showing = false

    setTimer(function()
        removeEventHandler("onClientRender", root, renderWeaponCraft)
    end, 300, 1)
end

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" and state == "up" then 
        if element then 
            if getElementData(element, "weaponCraftTable") then
                if core:getDistance(element, localPlayer) < 1.5 then
                    if not minigameInProgress then
                        if isElement(getElementData(element, "craftTable:inUse")) then 
                            outputChatBox(core:getServerPrefix("red-dark", "Gyár", 2).."Ez az asztal jelenleg használatban van!", 255, 255, 255, true)
                        else
                            openPanel() 
                            selectedObj = element
                        end
                    end
                end 
            end
        end
    end
end)   

-- minigame 
local minigameMove = -0.2
local pointerPos = sx*0.5 - sx*0.01/2
local successPercent = 0

function renderMinigame()
    dxDrawRectangle(sx*0.4, sy*0.8, sx*0.2, sy*0.02, tocolor(35, 35, 35, 100))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.8 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.02 - 4/myY*sy, tocolor(35, 35, 35, 255))

    dxDrawImage(sx*0.4 + 2/myX*sx, sy*0.8 + 2/myY*sy, sx*0.035, sy*0.02 - 4/myY*sy, "files/gradient.png", 0, 0, 0, tocolor(242, 51, 51, 255))
    dxDrawImage(sx*0.4 + 2/myX*sx + sx*0.2 - 4/myX*sx - sx*0.035, sy*0.8 + 2/myY*sy, sx*0.035, sy*0.02 - 4/myY*sy, "files/gradient.png", 180, 0, 0, tocolor(242, 51, 51, 255))

    dxDrawRectangle(pointerPos, sy*0.8 - 1/myY*sy, sx*0.001, sy*0.02, tocolor(255, 255, 255, 200))
    dxDrawRectangle(pointerPos - 2/myX*sx, sy*0.8 - 3/myY*sy, sx*0.001 + 4/myX*sx, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 50))

    dxDrawRectangle(sx*0.4, sy*0.822, sx*0.2, sy*0.01, tocolor(35, 35, 35, 100))
    dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, sx*0.2 - 4/myX*sx, sy*0.01 - 4/myY*sy, tocolor(35, 35, 35, 255))

    if successPercent >= weaponInCraftNeedPercent then
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.01 - 4/myY*sy, tocolor(r, g, b, 200))
    else
        dxDrawRectangle(sx*0.4 + 2/myX*sx, sy*0.822 + 2/myY*sy, (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.01 - 4/myY*sy, tocolor(242, 51, 51, 200))
    end

    dxDrawRectangle(sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100, sy*0.822 + 2/myY*sy, sx*0.001, sy*0.02, tocolor(255, 255, 255, 200))
    dxDrawRectangle((sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100) - 2/myX*sx, sy*0.822, sx*0.001 + 4/myX*sx, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 50))

    dxDrawText(math.floor(successPercent).."%", (sx*0.4 + 2/myX*sx + (sx*0.2 - 4/myX*sx) * successPercent / 100), sy*0.822, -sx*0.002, sy*0.02 + 4/myY*sy, tocolor(255, 255, 255, 255), 0.8, fonts:getFont("condensed", 10/myX*sx), "right", "bottom")

    if successPercent < 100 then
        successPercent = successPercent + 0.05
    else
        endMinigame()
    end

    if getKeyState("arrow_l") or getKeyState("a") then 
        minigameMove = minigameMove - math.random(3, 10) / 100
    elseif getKeyState("arrow_r") or getKeyState("d") then 
        minigameMove = minigameMove + math.random(3, 10) / 100
    else
        if minigameMove > 0 and minigameMove < 1.5 then
            minigameMove = 1.5 
        elseif minigameMove < 0 and minigameMove > -1.5 then 
            minigameMove = -1.5 
        end
    end

    pointerPos = pointerPos + minigameMove/myX*sx

    if pointerPos < sx*0.41 or pointerPos > sx*0.59 then 
        endMinigame()
    end
end

function startCraftMinigame()
    local values = {-0.3, -0.25, -0.2, -0.1, 0.1, 0.2, 0.25, 0.3}
    pointerPos = sx*0.5 - sx*0.01/2
    minigameMove = values[math.random(#values)]
    successPercent = 0
    minigameInProgress = true

    setElementData(minigameTable, "craftTable:inUse", localPlayer)


    addEventHandler("onClientRender", root, renderMinigame)
end

function endMinigame()
    successPercent = math.floor(successPercent)
    setElementData(minigameTable, "craftTable:inUse", false)

    local neededPercent = weaponInCraftNeedPercent
    if successPercent >= neededPercent then 
        chat:sendLocalMeAction("elkészített egy "..inventory:getItemName(weaponInCraft).."-t.")
        infobox:outputInfoBox("Sikeresen elkészítettél "..weaponInCraftCount.."db "..inventory:getItemName(weaponInCraft).."-t. ("..successPercent.."%)", "success")
        outputChatBox(core:getServerPrefix("green-dark", "Gyár", 2).."Sikeresen elkészítettél "..color..weaponInCraftCount.."#ffffffdb "..color..successPercent.."%#ffffff-os "..color..inventory:getItemName(weaponInCraft).."#ffffff-t!", 255, 255, 255, true)
        triggerServerEvent("weaponCraft > endWeaponCraft", resourceRoot, true, {weaponInCraft, successPercent, weaponInCraftCount})
    else
        chat:sendLocalDoAction("elrontotta a gyárátsi folyamatot.")
        outputChatBox(core:getServerPrefix("red-dark", "Gyár", 2).."Nem sikerült teljesítened a minigamet! Elbuktad az alapanyagokat!", 255, 255, 255, true)
        infobox:outputInfoBox("Sajnos nem sikerült teljesítened a minigamet, így elbuktad az alapanyagokat!", "warning")
        triggerServerEvent("weaponCraft > endWeaponCraft", resourceRoot, false)
    end
    minigameInProgress = false
    removeEventHandler("onClientRender", root, renderMinigame)
end