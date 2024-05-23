local alpha = 0

local bugReportInfos = {
    color.."1.) #ffffffAmennyiben a hiba nagyban befolyásolja a szerver\nműködését abban az estben keress fel egy "..color.."VEZETŐSÉGI #fffffftagot. ",
    color.."2.) #ffffffHa szükséges, akkor mellékelj "..color.."képet #ffffffa hibáról. \n(Ezt úgy teheded meg, hogy az adott képet feltöltöd a "..color.."\nwww.imgur.com #ffffffcímen elérhető oldalra és a kép linkjét a \nmegadott mezőbe beilleszted.)",
    color.."3.) #ffffffMiután beadtad a hiba jelentést a rendszer eltárolja a \nnevedet, így amennyiben a hibával kapcoslatban felmerülnek \nkérdések, akkor el fogonk tudni érni. ",
    color.."4.) #ffffffA visszaélések elkerülése véget, hibát csak "..color.."5 #ffffffpercenként \ntudsz jelenteni. (Több hiba esetén keress fel egy vezetőségi\ntagot!) ",
    color.."5.) A hiba jelentéssel kapcsolatos visszaéléseket a hiba \n jelentés funkció letiltásával és KITILTÁSSAL szankcionáljuk.",
}

local selectedText = 1

local clickTick, lastClick = getTickCount(), 0

local pagerTimer = false

local acceptInfos = false

local animTick, animState = getTickCount(), "open"

function renderBugReportPanel()

    if animState == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount() - animTick) / 500, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount() - animTick) / 500, "Linear")
    end

    dxDrawRectangle(sx*0.4-2/myX*sx, sy*0.3-2/myY*sy, sx*0.2+4/myX*sx, sy*0.4+4/myY*sy, tocolor(30, 30, 30, 150*alpha))
    dxDrawRectangle(sx*0.4, sy*0.3, sx*0.2, sy*0.4, tocolor(35, 35, 35, 255*alpha))

    --dxDrawRectangle(sx*0.405, sy*0.31, sx*0.1, sy*0.03)

    local clickAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-clickTick)/400, "Linear")

    dxDrawText("Hiba jelentése a fejlesztők felé", sx*0.405, sy*0.305, sx*0.405+sx*0.1, sy*0.305+sy*0.03, tocolor(r, g, b, 255*alpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")

    dxDrawText("Mielőtt hibát jelentesz olvasd el az alább található tájékoztatást!", sx*0.405, sy*0.33, sx*0.405+sx*0.1, sy*0.33+sy*0.03, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("condensed", 9/myX*sx), "left", "top")

    dxDrawRectangle(sx*0.405, sy*0.35, sx*0.19, sy*0.08, tocolor(30, 30, 30, 200*alpha))
    dxDrawText(bugReportInfos[selectedText], sx*0.407, sy*0.352, sx*0.405+sx*0.19, sy*0.35+sy*0.08, tocolor(255, 255, 255, 255*clickAlpha*alpha), 0.8, font:getFont("condensed", 10/myX*sx), "center", "center", true, true, false, true)

    if core:isInSlot(sx*0.585, sy*0.31, 15/myX*sx, 15/myY*sy) then 
        dxDrawImage(sx*0.585, sy*0.31, 15/myX*sx, 15/myY*sy, "files/admin_panel/close.png", 0, 0, 0, tocolor(237, 55, 55, 255*alpha))
    else
        dxDrawImage(sx*0.585, sy*0.31, 15/myX*sx, 15/myY*sy, "files/admin_panel/close.png", 0, 0, 0, tocolor(237, 55, 55, 150*alpha))
    end

    local allWidth = sx*0.022*#bugReportInfos
    local startX = sx*0.405 + (sx*0.19 - allWidth)/2

    for k, v in ipairs(bugReportInfos) do 
        if selectedText == k then 
            dxDrawRectangle(startX, sy*0.435, sx*0.02, sy*0.01, tocolor(r, g, b, (50 + 70*clickAlpha) *alpha))
        else
            dxDrawRectangle(startX, sy*0.435, sx*0.02, sy*0.01, tocolor(r, g, b, 50*alpha))
        end

        if core:isInSlot(startX, sy*0.435, sx*0.02, sy*0.01) then
            if getKeyState("mouse1") then 
                if not (selectedText == k) then 
                    selectedText = k
                    clickTick = getTickCount()
                    lastClick = getTickCount()
                end 
            end
        end

        startX = startX + sx*0.022
    end

    core:createEditbox(sx*0.405, sy*0.45, sx*0.19, sy*0.03, "bugreport-script", "Rendszer megnevezése", "text", true, {30, 30, 30, 255*alpha}, 0.4)
    core:createEditbox(sx*0.405, sy*0.482, sx*0.19, sy*0.03, "bugreport-title", "Hiba megnevezése", "text", true, {30, 30, 30, 255*alpha}, 0.4)
    core:createEditbox(sx*0.405, sy*0.514, sx*0.19, sy*0.03, "bugreport-desc", "Hiba leírása", "text", true, {30, 30, 30, 255*alpha}, 0.4)
    core:createEditbox(sx*0.405, sy*0.546, sx*0.19, sy*0.03, "bugreport-image", "Kép(ek) a hibáról (Nem kötelező!)", "text", true, {30, 30, 30, 255*alpha}, 0.4)

    dxDrawRectangle(sx*0.405, sy*0.58, 30/myX*sx, 30/myY*sy, tocolor(30, 30, 30, 200*alpha))
    dxDrawRectangle(sx*0.405+2/myX*sx, sy*0.58+2/myY*sy, 26/myX*sx, 26/myY*sy, tocolor(35, 35, 35, 200*alpha))

    if core:isInSlot(sx*0.405+2/myX*sx, sy*0.58+2/myY*sy, 26/myX*sx, 26/myY*sy) then 
        dxDrawImage(sx*0.405+5/myX*sx, sy*0.58+5/myY*sy, 20/myX*sx, 20/myY*sy, "files/admin_panel/tick.png", 0, 0, 0, tocolor(r, g, b, 100*alpha))
    end

    if acceptInfos then 
        dxDrawImage(sx*0.405+5/myX*sx, sy*0.58+5/myY*sy, 20/myX*sx, 20/myY*sy, "files/admin_panel/tick.png", 0, 0, 0, tocolor(r, g, b, 255*alpha))
    end

    dxDrawText("Elolvastam és megértettem a tájékoztatóban foglaltakat.", sx*0.405 + 35/myX*sx, sy*0.58, sx*0.405 + 35/myX*sx+30/myX*sx, sy*0.58+30/myY*sy, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("condensed", 9/myX*sx), "left", "center")

    --dxDrawRectangle(sx*0.405, sy*0.62, sx*0.19, sy*0.07)
    local textColor = tocolor(255, 255, 255, 255*alpha)

    if ((not acceptInfos) or (string.len(core:getEditboxText("bugreport-script")) < 2) or (string.len(core:getEditboxText("bugreport-title")) < 4) or (string.len(core:getEditboxText("bugreport-desc")) < 10)) then 
        textColor = tocolor(255, 255, 255, 120*alpha)
    else
        if core:isInSlot(sx*0.405, sy*0.62, sx*0.19, sy*0.07) then 
            textColor = tocolor(r, g, b, 200*alpha)
        end
    end

    dxDrawText("Hiba jelentés beküldése", sx*0.405, sy*0.62, sx*0.405+sx*0.19, sy*0.62+sy*0.07, textColor, 1, font:getFont("condensed", 15/myX*sx), "center", "center")
end

function keyBugReportPanel(key, state)
    if key == "mouse1" and state then 
        if core:isInSlot(sx*0.405+2/myX*sx, sy*0.58+2/myY*sy, 26/myX*sx, 26/myY*sy) then 
            acceptInfos = not acceptInfos 
        end

        if core:isInSlot(sx*0.405, sy*0.62, sx*0.19, sy*0.07) then 
            if ((not acceptInfos) or (string.len(core:getEditboxText("bugreport-script")) < 2) or (string.len(core:getEditboxText("bugreport-title")) < 4) or (string.len(core:getEditboxText("bugreport-desc")) < 10)) then 
            else
                if string.len(core:getEditboxText("bugreport-script")) > 25 then 
                    return infobox:outputInfoBox("A rendszer neve nem haladhatja meg a 25 karaktert!", "warning")
                end 

                if string.len(core:getEditboxText("bugreport-title")) > 25 then 
                    return infobox:outputInfoBox("A hiba megnevezése nem haladhatja meg a 25 karaktert!", "warning")
                end 
                
                if string.len(core:getEditboxText("bugreport-desc")) > 200 then 
                    return infobox:outputInfoBox("A hiba leírása nem haladhatja meg a 200 karaktert!", "warning")
                end 

                if string.len(core:getEditboxText("bugreport-image")) > 100 then 
                    return infobox:outputInfoBox("A kép URL címe nem haladhatja meg a 100 karaktert!", "warning")
                end 

                triggerServerEvent("bugreport > addBugReport", resourceRoot, {getElementData(localPlayer, "char:id"), getElementData(localPlayer, "char:name"):gsub("_", " "), getElementData(localPlayer, "user:id"), getElementData(localPlayer, "user:name")}, {core:getEditboxText("bugreport-script"), core:getEditboxText("bugreport-title"), core:getEditboxText("bugreport-desc"), core:getEditboxText("bugreport-image")}, string.format("%04d.%02d.%02d %02d:%02d:%02d", core:getDate("year"), core:getDate("month"), core:getDate("monthday"), core:getDate("hour"), core:getDate("minute"), core:getDate("second")))
                closeBugReportMenu()
                infobox:outputInfoBox("Köszönjük, hogy jelentetted a hibát! A hiba hamarosan javításra kerül!", "success")
            end
        end

        if core:isInSlot(sx*0.585, sy*0.31, 15/myX*sx, 15/myY*sy) then 
            closeBugReportMenu()
        end
    end
end

function openBugReportMenu()
    animTick, animState = getTickCount(), "open"

    acceptInfos = false
    core:deleteEditbox("bugreport-script")
    core:deleteEditbox("bugreport-title")
    core:deleteEditbox("bugreport-desc")
    core:deleteEditbox("bugreport-image")

    addEventHandler("onClientRender", root, renderBugReportPanel)
    addEventHandler("onClientKey", root, keyBugReportPanel)

    pagerTimer = setTimer(function()    
        if lastClick + 5000 < getTickCount() then 
            if selectedText + 1 > #bugReportInfos then 
                selectedText = 1 
                clickTick = getTickCount()
            else
                selectedText = selectedText + 1
                clickTick = getTickCount()
            end
        end
    end, 5000, 0)
end

function closeBugReportMenu()
    animTick, animState = getTickCount(), "close"

    core:deleteEditbox("bugreport-script")
    core:deleteEditbox("bugreport-title")
    core:deleteEditbox("bugreport-desc")
    core:deleteEditbox("bugreport-image")
    removeEventHandler("onClientKey", root, keyBugReportPanel)

    setTimer(function()
        removeEventHandler("onClientRender", root, renderBugReportPanel)

        if isTimer(pagerTimer) then killTimer(pagerTimer) end
    end, 500, 1)
end

-- Fejlesztői felület
local bugTable = {}

local progressColors = {
    ["wait_dev"] = {242, 193, 56, "#f2c138"},
    ["error_in_dev"] = {247, 54, 54, "#f73636"},
    ["dev_complete"] = {73, 222, 73, "#49de49"},
    ["dev_in_progress"] = {237, 115, 55, "#ed7337"},
}

local progressTitles = {
    ["wait_dev"] = {"Javításra vár", ""},
    ["error_in_dev"] = {"Nem javítható", ""},
    ["dev_complete"] = {"Kijavítva", ""},
    ["dev_in_progress"] = {"Javítás folyamatban", ""},
}

local bugReportPointer = 0
local panelTick = getTickCount()

function renderBugListPanel()
    if animState == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount() - animTick) / 500, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount() - animTick) / 500, "Linear")
    end

    dxDrawRectangle(sx*0.25, sy*0.25, sx*0.5, sy*0.5, tocolor(30, 30, 30, 150*alpha))
    dxDrawRectangle(sx*0.25+2/myX*sx, sy*0.25+2/myY*sy, sx*0.5-4/myX*sx, sy*0.5-4/myY*sy, tocolor(35, 35, 35, 255*alpha))

    dxDrawText("Bug Reports", sx*0.25+10/myX*sx, sy*0.25+10/myY*sy, sx*0.25+10/myX*sx+sx*0.1, sy*0.25+10/myY*sy+sy*0.03, tocolor(r, g, b, 255*alpha), 1, font:getFont("bebasneue", 17/myX*sx), "left", "center")
    dxDrawText("Ebben a listában található az összes, játékosok által jelentett hiba!", sx*0.25+10/myX*sx, sy*0.25+35/myY*sy, sx*0.25+10/myX*sx+sx*0.1, sy*0.25+35/myY*sy+sy*0.03, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("condensed", 9/myX*sx), "left", "top")

    local startY = sy*0.33
    for i = 1, 8 do 
        local barAlpha = 255

        if i+bugReportPointer % 2 == 0 then barAlpha = 175 end

        dxDrawRectangle(sx*0.25+5/myX*sx, startY, sx*0.5-20/myX*sx, sy*0.05, tocolor(30, 30, 30, barAlpha*alpha))

        local v = bugTable[i+bugReportPointer] 

        if v then 
            --*dxDrawRectangle(sx*0.25+5/myX*sx+sx*0.4, startY, sx*0.062, sy*0.05)

            local iconAlpha = 255

            if v[5] == "wait_dev" then 
                iconAlpha = interpolateBetween(100, 0, 0, 255, 0, 0, (getTickCount()-panelTick)/1000, "SineCurve")
                dxDrawRectangle(sx*0.25+5/myX*sx, startY, 2/myX*sx, sy*0.05, tocolor(progressColors[v[5]][1], progressColors[v[5]][2], progressColors[v[5]][3], iconAlpha*alpha))

            else
                dxDrawRectangle(sx*0.25+5/myX*sx, startY, 2/myX*sx, sy*0.05, tocolor(progressColors[v[5]][1], progressColors[v[5]][2], progressColors[v[5]][3], barAlpha*alpha))
            end

            dxDrawText(progressTitles[v[5]][2], sx*0.25+5/myX*sx+sx*0.46, startY, sx*0.25+5/myX*sx+sx*0.46+sx*0.03, startY+sy*0.05, tocolor(progressColors[v[5]][1], progressColors[v[5]][2], progressColors[v[5]][3], iconAlpha*alpha), 1, font:getFont("fontawesome2", 15/myX*sx), "center", "center")
            dxDrawText(progressTitles[v[5]][1], sx*0.25+5/myX*sx+sx*0.4, startY, sx*0.25+5/myX*sx+sx*0.4+sx*0.062, startY+sy*0.051, tocolor(progressColors[v[5]][1], progressColors[v[5]][2], progressColors[v[5]][3], iconAlpha*alpha), 1, font:getFont("bebasneue", 13/myX*sx), "right", "center")

            --dxDrawRectangle(sx*0.25+10/myX*sx, startY, sx*0.1, sy*0.03)
            dxDrawText(v[3][2], sx*0.25+10/myX*sx, startY, sx*0.25+10/myX*sx+sx*0.1, startY+sy*0.035, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("bebasneue", 14/myX*sx), "left", "center")

            if string.len(v[3][4]) > 0 then  
                if core:isInSlot(sx*0.25+10/myX*sx, startY+sy*0.025, sx*0.1, sy*0.055) then 
                    dxDrawText(v[3][1] .. " #0077ed(Kép URL másolása)", sx*0.25+10/myX*sx, startY+sy*0.025, sx*0.25+10/myX*sx+sx*0.1, startY+sy*0.055, tocolor(255, 255, 255, 150*alpha), 1, font:getFont("bebasneue", 10/myX*sx), "left", "center", false, false, false, true)
                else
                    dxDrawText(v[3][1] .. " #429bf5(Kép URL másolása)", sx*0.25+10/myX*sx, startY+sy*0.025, sx*0.25+10/myX*sx+sx*0.1, startY+sy*0.055, tocolor(255, 255, 255, 150*alpha), 1, font:getFont("bebasneue", 10/myX*sx), "left", "center", false, false, false, true)
                end
            else
                dxDrawText(v[3][1], sx*0.25+10/myX*sx, startY+sy*0.025, sx*0.25+10/myX*sx+sx*0.1, startY+sy*0.055, tocolor(255, 255, 255, 150*alpha), 1, font:getFont("bebasneue", 10/myX*sx), "left", "center", false, false, false, true)
            end

            local startX = sx*0.44
            for k, v2 in pairs(progressTitles) do 
                if k == v[5] or core:isInSlot(startX, startY, sx*0.03, sy*0.05) then 
                    dxDrawText(v2[2], startX, startY, startX+sx*0.03, startY+sy*0.05, tocolor(progressColors[k][1], progressColors[k][2], progressColors[k][3], 220*alpha), 1, font:getFont("fontawesome2", 15/myX*sx), "center", "center")
                else
                    dxDrawText(v2[2], startX, startY, startX+sx*0.03, startY+sy*0.05, tocolor(progressColors[k][1], progressColors[k][2], progressColors[k][3], 100*alpha), 1, font:getFont("fontawesome2", 15/myX*sx), "center", "center")
                end

                startX = startX + sx*0.029
            end

            if core:isInSlot(sx*0.25+5/myX*sx, startY, sx*0.5-20/myX*sx, sy*0.05) then 
                local cx, cy = getCursorPosition()
                cx, cy = cx*sx, cy*sy
                
                cx, cy = cx + 5/myX*sx, cy + 5/myY*sy

                local boxWidth = dxGetTextWidth("Beküldő: #de3a3a"..v[2][2].."#ffffff (Char: "..v[2][1].." | User: "..v[2][3]..")", 1, font:getFont("condensed", 9/myX*sx), true)
                boxWidth = boxWidth + 15/myX*sx

                dxDrawRectangle(cx, cy, boxWidth+2/myX*sx, sy*0.1, tocolor(30, 30, 30, 200*alpha), true)
                dxDrawRectangle(cx+2/myX*sx, cy+2/myY*sy, boxWidth, sy*0.1-4/myY*sy, tocolor(35, 35, 35, 255*alpha), true)
                --dxDrawRectangle(cx+4/myX*sx, cy+4/myY*sy, sx*0.08, sy*0.025, _, true)
                dxDrawText("Beküldés dátuma: "..color..v[4], cx+8/myX*sx, cy+4/myY*sy, cx+8/myX*sx+sx*0.08, cy+4/myY*sy+sy*0.025, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("condensed", 9/myX*sx), "left", "center", false, false, true, true)
                dxDrawText("Beküldő: #de3a3a"..v[2][2].."#ffffff (Char: "..v[2][1].." | User: "..v[2][3]..")", cx+8/myX*sx, cy+4/myY*sy+0.03, cx+8/myX*sx+sx*0.08, cy+4/myY*sy+sy*0.055, tocolor(255, 255, 255, 255*alpha), 1, font:getFont("condensed", 9/myX*sx), "left", "center", false, false, true, true)
                dxDrawText(v[3][3], cx+8/myX*sx, cy+4/myY*sy+sy*0.035, cx+8/myX*sx+(boxWidth-25/myX*sx), cy+4/myY*sy+sy*0.095, tocolor(r, g, b, 255*alpha), 1, font:getFont("condensed", 9/myX*sx), "left", "top", false, true, true, false)
            end
        end

        startY = startY + sy*0.052
    end

    dxDrawRectangle(sx*0.7435, sy*0.33, sx*0.002, sy*0.413, tocolor(r, g, b, 100*alpha))

    local lineHeight = math.min(8/#bugTable, 1)
    dxDrawRectangle(sx*0.7435, sy*0.33 + (sy*0.413 * (lineHeight * bugReportPointer/8)), sx*0.002, sy*0.413*lineHeight, tocolor(r, g, b, 255*alpha))
end

function keyBugListPanel(key, state)
    if state then 
        if core:isInSlot(sx*0.25, sy*0.25, sx*0.5, sy*0.5) then 
            if key == "mouse_wheel_down" then 
                if bugTable[8 + bugReportPointer + 1] then 
                    bugReportPointer = bugReportPointer + 1
                end
            elseif key == "mouse_wheel_up" then 
                if bugReportPointer > 0 then 
                    bugReportPointer = bugReportPointer - 1
                end
            end
        end

        if key == "mouse1" then 
            local startY = sy*0.33
            for i = 1, 8 do 
                local v = bugTable[i+bugReportPointer] 

                if v then 

                    if core:isInSlot(sx*0.25+5/myX*sx, startY, sx*0.5-20/myX*sx, sy*0.05) then 
                        if string.len(v[3][4]) > 0 then  
                            if core:isInSlot(sx*0.25+10/myX*sx, startY+sy*0.025, sx*0.1, sy*0.055) then 
                                setClipboard(v[3][4])
                            end
                        end
                    end

                    local startX = sx*0.44
                    for k, v2 in pairs(progressTitles) do 
                        if core:isInSlot(startX, startY, sx*0.03, sy*0.05) then 
                            if not (v[5] == k) then 
                                triggerServerEvent("dash > bugReport > setReportState", resourceRoot, v[1], k)
                            end
                        end

                        startX = startX + sx*0.029
                    end
                end

                startY = startY + sy*0.052
            end
        end
    end
end

local bugListState = false
function openBugListPanel()
    bugListState = true 
    animTick, animState = getTickCount(), "open"

    addEventHandler("onClientRender", root, renderBugListPanel)
    addEventHandler("onClientKey", root, keyBugListPanel)
    triggerServerEvent("dash > bugReport > requestBugRepotsFromServer", resourceRoot)
end

function closeBugListPanel()
    bugListState = false 
    animTick, animState = getTickCount(), "close"

    removeEventHandler("onClientKey", root, keyBugListPanel)

    setTimer(function()
        removeEventHandler("onClientRender", root, renderBugListPanel)
    end, 500, 1)
end

addCommandHandler("bugreports", function()
    if exports["oAdmin"]:hasPermission(localPlayer,"bugreports") then 
        if animTick + 500 < getTickCount() then 
            if not bugListState then 
                openBugListPanel()
            else
                closeBugListPanel()
            end
        end
    end
end)

addEvent("dash > bugReport > bugReportsToClient", true)
addEventHandler("dash > bugReport > bugReportsToClient", root, function(reports)
    if getElementData(localPlayer, "user:admin") >= 8 then 
        bugTable = reports
    end
end)