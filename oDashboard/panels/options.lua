local selectedOption = 1

local crosshairColorButtons = {}
local selectedMenu_k = ""

for i = 1, #crosshairColors do 
    table.insert(crosshairColorButtons, {"N", getTickCount(), 0})
end

sliderEditing = 0

local snowAvailable = false
local month = core:getDate("month")
if (month == 12 or month == 1 or month == 2) then 
    snowAvailable = true
end

function renderPanel_options(a)
    dxDrawRectangle(sx*0.15,sy*0.22,sx*0.15,sy*0.04,tocolor(27,27,27,220*a))
    dxDrawText("Beállítások",sx*0.15,sy*0.22,sx*0.15+sx*0.15,sy*0.22+sy*0.044,tocolor(255,255,255,255*a),0.7/myX*sx,fonts["bebasneue-18"],"center","center")
    --dxDrawRectangle(sx*0.15,sy*0.22+sy*0.04,sx*0.15,sy*0.59,tocolor(27,27,27,100*a))

    local startY = sy*0.22+sy*0.045
    local item = 1
    local selectedMenuTitle = ""
    selectedMenu_k = ""
    local selectedMenuIcon = ""
    for k, v in pairs(options) do 
        local color = tocolor(26, 26, 26,220*a)
        local color2 = tocolor(r,g,b,255*a)

        if (item)%2 == 0 then 
            color = tocolor(24,24,24,220*a)
            color2 = tocolor(r,g,b,150*a)
        end

        if core:isInSlot(sx*0.15,startY,sx*0.15,sy*0.04) or selectedOption == item then 
            core:dxDrawRoundedRectangle(sx*0.15,startY,sx*0.15,sy*0.035, tocolor(20, 20, 20, 220*a), tocolor(20, 20, 20, 220*a))
        else
            core:dxDrawRoundedRectangle(sx*0.15,startY,sx*0.15,sy*0.035, color, color)
        end

        dxDrawRectangle(sx*0.15 + 4/myX*sx,startY + 4/myY*sy,sx*0.0015,sy*0.035 -8/myY*sy,color2)

        if selectedOption == item then 
            selectedMenuTitle = v.name
            selectedMenu_k = k
            selectedMenuIcon = v.icon
            --dxDrawText(v.name,sx*0.172,startY,sx*0.172+sx*0.1,startY+sy*0.04,tocolor(r, g, b,255*a),1,font:getFont("condensed", 10/myX*sx),"left","center",false,false,false,true)
            --dxDrawImage(sx*0.155, startY + sy*0.0075, sy*0.025, sy*0.025, "files/icons/"..v.icon, 0, 0, 0, tocolor(r, g, b, 255 * a))
        else
            --dxDrawImage(sx*0.155, startY + sy*0.0075, sy*0.025, sy*0.025, "files/icons/"..v.icon, 0, 0, 0, tocolor(255, 255, 255, 255 * a))
        end
        dxDrawImage(sx*0.1565, startY + sy*0.035/2 - 10/myX*sx, 20/myX*sx, 20/myX*sx, "files/options/"..v.icon, 0, 0, 0, tocolor(255, 255, 255, 255 * a))
        dxDrawText(v.name,sx*0.172,startY,sx*0.172+sx*0.1,startY+sy*0.037,tocolor(255,255,255,255*a),1,font:getFont("condensed", 9.5/myX*sx),"left","center",false,false,false,true)

      
        startY = startY + sy*0.04
        item = item + 1
    end

    --dxDrawRectangle(sx*0.31,sy*0.22,sx*0.585,sy*0.04,tocolor(27,27,27,220*a))
    dxDrawText("Beállítások",sx*0.35,sy*0.21,sx*0.35+sx*0.585,sy*0.21+sy*0.044,tocolor(255,255,255,100*a),1,font:getFont("condensed", 9.5/myX*sx),"left","center")
    dxDrawText(selectedMenuTitle,sx*0.35,sy*0.235,sx*0.35+sx*0.585,sy*0.235+sy*0.044,tocolor(255,255,255,255*a),1/myX*sx,fonts["bebasneue-18"],"left","center")
    dxDrawRectangle(sx*0.31,sy*0.22+sy*0.062,sx*0.585,sy*0.57,tocolor(27,27,27,100*a))
    dxDrawImage(sx*0.315,sy*0.22, 45/myX*sx, 45/myX*sx, "files/options/"..selectedMenuIcon)

    local item2 = 0
    startY = sy*0.22+sy*0.045 + sy*0.02
    for k, v in ipairs(options[selectedMenu_k]) do 
        local color = tocolor(21,21,21,220*a)
        local color2 = tocolor(r,g,b,255*a)

        if (item2)%2 == 0 then 
            color = tocolor(28,28,28,220*a)
            color2 = tocolor(r,g,b,100*a)
        end

        if v then
            if v[2] == 4 then 
                dxDrawRectangle(sx*0.31,startY,sx*0.58,sy*0.07,color)
                dxDrawRectangle(sx*0.31,startY,sx*0.001,sy*0.07,color2)
            else
                dxDrawRectangle(sx*0.31,startY,sx*0.58,sy*0.04,color)
                dxDrawRectangle(sx*0.31,startY,sx*0.001,sy*0.04,color2)
            end

            dxDrawText(v[1],sx*0.315,startY,sx*0.315+sx*0.1,startY+sy*0.04,tocolor(255,255,255,255*a),1,font:getFont("condensed", 10/myX*sx),"left","center",false,false,false,true)

            if v[2] == 1 then 
                local button_alpha = 180
                local button_text = {232, 76, 43}
                if v[6] == true then 
                    button_text = {81, 244, 109}
                end
    
                if core:isInSlot(sx*0.865, startY + sy*0.003, 30/myX*sx, 30/myX*sx) then 
                    button_alpha = 200
                end

                if v[6] then
                    dxDrawImage(sx*0.865, startY + sy*0.003, 30/myX*sx, 30/myX*sx, "files/onoff.png", 0, 0, 0, tocolor(button_text[1], button_text[2], button_text[3], button_alpha * a))
                else
                    dxDrawImage(sx*0.865, startY + sy*0.003, 30/myX*sx, 30/myX*sx, "files/onoff.png", -180, 0, 0, tocolor(button_text[1], button_text[2], button_text[3], button_alpha * a))
                end
    
            elseif v[2] == 2 then 
                if sliderEditing == k then 
                    local cX, cY = getCursorPosition() 
                    cX, cY = cX*sx, cY*sy  
    
                    local value = (sx*0.768+1/myX*sx)-cX 
                    value = value - value*2
                    value = value / 200
    
                    if value < 0 then 
                        value = 0 
                    end
    
                    value = math.floor(value*100)/100
    
                    if cX > (sx*0.768+1/myX*sx + sx*0.117-2/myX*sx) or value > 1 then
                        value = v[4] 
                        v[6] = value 
                    else
                        v[6] = v[4]*value 
                    end

                    if selectedMenu_k == "xmas" then
                        if v[1] == "havazás erőssége" then 
                            exports[v[5]]:updateSnowDensity(v[6], true, 1)
                        end
                    end
                end
    
                dxDrawRectangle(sx*0.768, startY+sy*0.009, sx*0.117, sy*0.02, tocolor(35, 35, 35, 255*a))
                dxDrawRectangle(sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, sx*0.117-2/myX*sx, sy*0.02-2/myY*sy, tocolor(40, 40, 40, 255*a))
    
                if v[6] > 0 then 
                    if core:isInSlot(sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, sx*0.117-2/myX*sx, sy*0.02-2/myY*sy) then 
                        dxDrawRectangle(sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, (sx*0.117-2/myX*sx)*(v[6]/v[4]), sy*0.02-2/myY*sy, tocolor(r, g, b, 210*a))
                    else
                        dxDrawRectangle(sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, (sx*0.117-2/myX*sx)*(v[6]/v[4]), sy*0.02-2/myY*sy, tocolor(r, g, b, 180*a))
                    end
                    core:dxDrawShadowedText(tostring(v[6]), sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, sx*0.768+1/myX*sx+(sx*0.117-2/myX*sx), startY+sy*0.009+1/myY*sy+sy*0.02-2/myY*sy, tocolor(255, 255, 255, 255*a), tocolor(0, 0, 0, 255*a), 0.7/myX*sx, fonts["condensed-bold-11"], "center", "center")
                else
                    if core:isInSlot(sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, sx*0.117-2/myX*sx, sy*0.02-2/myY*sy) then 
                        dxDrawRectangle(sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, (sx*0.117-2/myX*sx), sy*0.02-2/myY*sy, tocolor(r, g, b, 210*a))
                    else
                        dxDrawRectangle(sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, (sx*0.117-2/myX*sx), sy*0.02-2/myY*sy, tocolor(r, g, b, 180*a))
                    end
                    core:dxDrawShadowedText("Alapértelmezett", sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, sx*0.768+1/myX*sx+(sx*0.117-2/myX*sx), startY+sy*0.009+1/myY*sy+sy*0.02-2/myY*sy, tocolor(255, 255, 255, 255*a), tocolor(0, 0, 0, 255*a), 0.7/myX*sx, fonts["condensed-bold-11"], "center", "center")
                end
            elseif v[2] == 3 then 
                if core:isInSlot(sx*0.874, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx) then 
                    dxDrawImage(sx*0.874, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx, "files/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 200 * a)) 
                else
                    dxDrawImage(sx*0.874, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx, "files/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 100 * a)) 
                end
                
                if core:isInSlot(sx*0.821, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx) then
                    dxDrawImage(sx*0.821, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx, "files/arrow.png", -180, 0, 0, tocolor(255, 255, 255, 200 * a)) 
                else
                    dxDrawImage(sx*0.821, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx, "files/arrow.png", -180, 0, 0, tocolor(255, 255, 255, 100 * a)) 
                end
                
                local value = tostring(v[6])
                if selectedMenu_k == "char" then 
                    if type(v[6]) == "string" then 
                        value = (getElementData(localPlayer, v[6]) or 1)

                        if value == 0 then 
                            value = "Ki"
                        end
                    end
                end
                dxDrawText(value, sx*0.821, startY+sy*0.003, sx*0.874+20/myX*sx, startY+sy*0.007+30/myY*sy, tocolor(255, 255, 255, 255*a), 1/myX*sx, fonts["condensed-bold-11"], "center", "center")
            elseif v[2] == 4 then 
                local folder = v[8]

                local value = v[6]
                if folder == ":oAccount/avatars/" then 
                    value = getElementData(localPlayer, "char:avatarID") 
                end

                if selectedMenu_k == "crosshair" then
                    local color = getElementData(localPlayer, "char:crosshairCOLOR") or {255, 255, 255}
                    value = getElementData(localPlayer, "char:crosshairID") or 1 

                    folder = folder .. "/"..color[1].."/"
                    
                    dxDrawImage(sx*0.84, startY + 10/myX*sx, 45/myX*sx*0.5, 45/myX*sx*0.5, folder..value..".png", 0, 0, 0, tocolor(color[1], color[2], color[3], 255 * a))
                    dxDrawImage(sx*0.84 + 45/myX*sx*0.5, startY + 10/myX*sx, 45/myX*sx*0.5, 45/myX*sx*0.5, folder..value..".png", 90, 0, 0, tocolor(color[1], color[2], color[3], 255 * a))
                    dxDrawImage(sx*0.84, startY + 10/myX*sx + 45/myX*sx*0.5, 45/myX*sx*0.5, 45/myX*sx*0.5, folder..value..".png", -90, 0, 0, tocolor(color[1], color[2], color[3], 255 * a))
                    dxDrawImage(sx*0.84 + 45/myX*sx*0.5, startY + 10/myX*sx + 45/myX*sx*0.5, 45/myX*sx*0.5, 45/myX*sx*0.5, folder..value..".png", 180, 0, 0, tocolor(color[1], color[2], color[3], 255 * a))
                else
                    dxDrawImage(sx*0.84, startY + 10/myX*sx, 45/myX*sx, 45/myX*sx, folder..value..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * a))
                end
                
                if core:isInSlot(sx*0.87, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx) then
                    dxDrawImage(sx*0.87, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx, "files/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 200 * a)) 
                else
                    dxDrawImage(sx*0.87, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx, "files/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 100 * a))
                end

                if core:isInSlot(sx*0.819, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx) then 
                    dxDrawImage(sx*0.819, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx, "files/arrow.png", -180, 0, 0, tocolor(255, 255, 255, 200 * a))
                else
                    dxDrawImage(sx*0.819, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx, "files/arrow.png", -180, 0, 0, tocolor(255, 255, 255, 100 * a))
                end

                startY = startY + sy*0.03
            elseif v[2] == 5 then 
                local startX = sx*0.873
                local color = getElementData(localPlayer, "char:crosshairCOLOR") or {255, 255, 255}

                for k2, v2 in ipairs(crosshairColors) do
                    if core:isInSlot(startX, startY + sy*0.007, sy*0.025, sy*0.025) or color[1] == v2[1] then 
                        dxDrawRectangle( startX, startY + sy*0.007, sy*0.025, sy*0.025, tocolor(v2[1], v2[2], v2[3], 230 * a))
                    else
                        dxDrawRectangle( startX, startY + sy*0.007, sy*0.025, sy*0.025, tocolor(v2[1], v2[2], v2[3], 150 * a))
                    end
                    startX = startX - sy*0.027
                end
            end
        end

        startY = startY + sy*0.0425
        item2 = item2 + 1
    end

    dxDrawRectangle(sx*0.892, sy*0.22+sy*0.045 + sy*0.02, sx*0.0015, sy*0.564, tocolor(r, g, b, 100*a))
    dxDrawRectangle(sx*0.892, sy*0.22+sy*0.045 + sy*0.02, sx*0.0015, sy*0.564, tocolor(r, g, b, 200*a))

    if selectedMenu_k == "xmas" then
        if not snowAvailable then
            dxDrawRectangle(sx*0.31,sy*0.22+sy*0.062,sx*0.585,sy*0.57,tocolor(27,27,27,220*a))
            dxDrawImage(sx*0.31 + sx*0.585/2 - 125/myX*sx,sy*0.22+sy*0.062 + sy*0.05, 250/myX*sx, 250/myY*sy, "files/xmas.png", 0, 0, 0, tocolor(255, 255, 255, 255 * a))
            dxDrawText("Ezek a beállítások csak a karácsonyi időszakban érhetőek el!",sx*0.31,sy*0.635,sx*0.31 + sx*0.585,sy*0.635+sy*0.044,tocolor(255,255,255,255*a),1/myX*sx,fonts["bebasneue-18"],"center","center")
        end
    end
end

function keyPanel_options(key, state)
    local startY = sy*0.22+sy*0.045
    local item = 1
    for k, v in pairs(options) do 
        if core:isInSlot(sx*0.15,startY,sx*0.15,sy*0.04) then 
            if not (selectedOption == item) then
                selectedOption = item
                playSound("files/sounds/hover.wav")
            end
        end

        startY = startY + sy*0.04
        item = item + 1
    end

    if selectedMenu_k == "xmas" then
        if not snowAvailable then
            return
        end
    end

    local item2 = 0
    startY = sy*0.22+sy*0.045 + sy*0.02
    for k, v in ipairs(options[selectedMenu_k]) do 
        if v then

            if v[2] == 1 then 
                if core:isInSlot(sx*0.865, startY + sy*0.003, 30/myX*sx, 30/myX*sx) then 
                    v[6] = not v[6]
                    
                    if selectedMenu_k == "graphics" then
                        exports[v[5]]:switchShader(v[6])
                    elseif selectedMenu_k == "xmas" then
                        if v[1] == "Havazás" then 
                            exports[v[5]]:switchShader(v[6])
                        else
                            exports[v[5]]:updateSnowJitter(v[6])
                        end
                    end
                end
            elseif v[2] == 2 then    
                if core:isInSlot(sx*0.768+1/myX*sx, startY+sy*0.009+1/myY*sy, sx*0.117-2/myX*sx, sy*0.02-2/myY*sy) then 
                    sliderEditing = k
                end
            elseif v[2] == 3 then 
                if type(v[6]) == "string" then 
                    local max = 0
                    local min = 1

                    if v[6] == "char:fightStyle" then 
                        max = #fightingStyles 
                    elseif v[6] == "char:walkStyle" then
                        max = #walkingStyles
                    elseif v[6] == "char:talkAnimation" then 
                        max = #talkinkingAnimations
                        min = 0
                    end 

                    local value = (getElementData(localPlayer, v[6]) or 1)
                    if core:isInSlot(sx*0.821, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx) then 
                        if value > min then 
                            setElementData(localPlayer, v[6], value - 1)
                        else
                            setElementData(localPlayer, v[6], max)
                        end
                    end
    
                    if core:isInSlot(sx*0.874, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx) then 
                        if value < max then 
                            setElementData(localPlayer, v[6], value + 1)
                        else
                            setElementData(localPlayer, v[6], min)
                        end
                    end
                else
                    if core:isInSlot(sx*0.874, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx) then 
                        if v[6] < v[4] then 
                            v[6] = v[6] + 1 
                        else
                            v[6] = v[3]
                        end
                        
                        if selectedMenu_k == "graphics" then
                            exports[v[5]]:switchShader(v[6])
                        elseif selectedMenu_k == "xmas" then 
                            local snowType = "real"
                            local minM, maxM = 1, 3

                            if v[6] == 2 then 
                                snowType = "cartoon"
                                minM, maxM = 3, 6
                            end

                            exports[v[5]]:updateSnowType(snowType)
                        end
                    end
                    
                    if core:isInSlot(sx*0.821, startY + 5/myY*sx, 20/myX*sx, 20/myX*sx) then
                        if v[6] > v[3] then 
                            v[6] = v[6] - 1 
                        else
                            v[6] = v[4]
                        end

                        if selectedMenu_k == "graphics" then
                            exports[v[5]]:switchShader(v[6])
                        elseif selectedMenu_k == "xmas" then 
                            local snowType = "real"
                            local minM, maxM = 1, 3

                            if v[6] == 2 then 
                                snowType = "cartoon"
                                minM, maxM = 3, 6
                            end

                            exports[v[5]]:updateSnowType(snowType)
                        end
                    end
                end
            elseif v[2] == 4 then 
                if selectedMenu_k == "crosshair" then 
                    if core:isInSlot(sx*0.87, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx) then 
                        local color = getElementData(localPlayer, "char:crosshairCOLOR") or {255, 255, 255}
                        local crosshair = getElementData(localPlayer, "char:crosshairID") or 1 

                        if fileExists(":oCrosshair/crosshairs/"..color[1].."/"..(crosshair + 1)..".png") then 
                            setElementData(localPlayer, "char:crosshairID", crosshair + 1)
                            crosshairDatas[1] = crosshair + 1
                        end
                    end

                    if core:isInSlot(sx*0.819, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx) then 
                        local crosshair = getElementData(localPlayer, "char:crosshairID") or 1 

                        if crosshair > 1 then 
                            setElementData(localPlayer, "char:crosshairID", crosshair - 1)
                            crosshairDatas[1] = crosshair - 1
                        end
                    end
                elseif selectedMenu_k == "char" then
                    if core:isInSlot(sx*0.87, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx) then 
                        local avatar = getElementData(localPlayer, "char:avatarID") 
    
                        if fileExists(":oAccount/avatars/"..(avatar + 1)..".png") then 
                            setElementData(localPlayer, "char:avatarID", avatar + 1)
                        end
                    end

                    if core:isInSlot(sx*0.819, startY + 10/myY*sx, 30/myX*sx, 30/myX*sx) then 
                        local avatar = getElementData(localPlayer, "char:avatarID") 
    
                        if avatar > 1 then 
                            setElementData(localPlayer, "char:avatarID", avatar - 1)
                        end
                    end
                end
              
                startY = startY + sy*0.03
            elseif v[2] == 5 then 
                local startX = sx*0.873

                for k2, v2 in ipairs(crosshairColors) do
                    if core:isInSlot(startX, startY + sy*0.007, sy*0.025, sy*0.025) then 
                        setElementData(localPlayer, "char:crosshairCOLOR", v2)
                        crosshairDatas[2] = v2
                    end

                    startX = startX - sy*0.027
                end
               
            end
        end

        startY = startY + sy*0.0425
        item2 = item2 + 1
    end
end