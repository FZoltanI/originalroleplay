local sx, sy = guiGetScreenSize()
local myX, myY = 1600,900

local fonts = {
    ["bebasneue-20"] = exports.oFont:getFont("bebasneue", 20),
    ["condensed-12"] = exports.oFont:getFont("condensed", 12),
    ["fontawesome-30"] = exports.oFont:getFont("fontawesome2", 30),
}

local selectedService = 1
local pAlpha = 0

local panelPointer = 0

local tick = getTickCount()
local panelAnimType = "open"

function drawPanel()
    if panelAnimType == "open" then 
        pAlpha = interpolateBetween(pAlpha, 0, 0, 1, 0, 0, (getTickCount() - tick)/500, "Linear")
    else
        pAlpha = interpolateBetween(pAlpha, 0, 0, 0, 0, 0, (getTickCount() - tick)/500, "Linear")
    end

    dxDrawRectangle(sx*0.35, sy*0.3, sx*0.3, sy*0.4, tocolor(30, 30, 30, 200*pAlpha))
    dxDrawRectangle(sx*0.35+2/myX*sx, sy*0.3+2/myX*sx, sx*0.3-4/myX*sx, sy*0.4-4/myY*sy, tocolor(35, 35, 35, 255*pAlpha))
    --dxDrawRectangle(sx*0.355, sy*0.31, 50/myX*sx, 50/myY*sy)
    dxDrawText(phoneServices[selectedService].name.." #ffffff- San Andreas", sx*0.39, sy*0.315, sx*0.39+sx*0.1, sy*0.315+sy*0.04, tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 255*pAlpha), 0.85/myX*sx, fonts["bebasneue-20"], "left", "top", false, false, false, true)
    dxDrawText("Üdvözöljük nállunk!", sx*0.39, sy*0.31, sx*0.39+sx*0.1, sy*0.31+sy*0.05, tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 255*pAlpha), 0.7/myX*sx, fonts["condensed-12"], "left", "bottom", false, false, false, true)
    dxDrawImage(sx*0.355, sy*0.31, 50/myX*sx, 50/myY*sy, "files/services/"..phoneServices[selectedService].logo..".png", 0, 0, 0, tocolor(255, 255, 255, 255*pAlpha))

    dxDrawText("Elérhető csomagok:", sx*0.355, sy*0.37, sx*0.355+sx*0.1, sy*0.37+sy*0.04, tocolor(255, 255, 255, 255*pAlpha), 0.75/myX*sx, fonts["bebasneue-20"], "left", "top", false, false, false, true)

    local startY = sy*0.403
    for i = 1, 3 do 
        v = phoneServices[selectedService].packages[panelPointer+i]

        local color = tocolor(30, 30, 30, 255)
        local color2 = tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 255*pAlpha)

        if (i+panelPointer) % 2 == 0 then 
            color = tocolor(30, 30, 30, 150)
            color2 = tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 150*pAlpha)
        end

        dxDrawRectangle(sx*0.355, startY, sx*0.285, sy*0.095, color)

        if v then 
            --dxDrawRectangle(sx*0.36, startY, sx*0.1, sy*0.04)
            dxDrawText(v.name, sx*0.36, startY, sx*0.36+sx*0.1, startY+sy*0.04, tocolor(255, 255, 255, 255*pAlpha), 0.7/myX*sx, fonts["bebasneue-20"], "left", "center")

            dxDrawText("Csomag Ára: "..phoneServices[selectedService].color[1]..v.pricePerHour.."$/h", sx*0.36, startY+sy*0.03, sx*0.36+sx*0.1, startY+sy*0.05, tocolor(255, 255, 255, 255*pAlpha), 0.75/myX*sx, fonts["condensed-12"], "left", "center", false, false, false, true)
            dxDrawText("Garantált Hatótáv: "..phoneServices[selectedService].color[1]..v.radius.." yard", sx*0.36, startY+sy*0.05, sx*0.36+sx*0.1, startY+sy*0.07, tocolor(255, 255, 255, 255*pAlpha), 0.75/myX*sx, fonts["condensed-12"], "left", "center", false, false, false, true)
            dxDrawImage(sx*0.365, startY+sy*0.067, 20/myX*sx, 20/myY*sy, "files/l_arrow.png", 90, 0, 0, tocolor(255, 255, 255, 100*pAlpha))
                dxDrawText("A garantált hatótáv az a távolság amely távolságon belül elérhető lesz a szolgáltatás.", sx*0.38, startY+sy*0.07, sx*0.38+sx*0.1, startY+sy*0.093, tocolor(255, 255, 255, 100*pAlpha), 0.65/myX*sx, fonts["condensed-12"], "left", "center", false, false, false, true)

            if v.neededTime > 0 then 
                dxDrawRectangle(sx*0.355, startY, sx*0.285, sy*0.095, tocolor(27, 27, 27, 245*pAlpha))
                dxDrawText("", sx*0.355, startY, sx*0.355+sx*0.285, startY+sy*0.075, tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 255*pAlpha), 0.8/myX*sx, fonts["fontawesome-30"], "center", "center")

                dxDrawText("A szolgáltatás használatához szükséges a szolgáltatónál töltened legalább "..v.neededTime.." napot!", sx*0.355, startY, sx*0.355+sx*0.285, startY+sy*0.079, tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 255*pAlpha), 0.7/myX*sx, fonts["condensed-12"], "center", "bottom")
            else 
                if core:isInSlot(sx*0.545, startY+sy*0.01, sx*0.09, sy*0.02) then 
                    core:dxDrawShadowedText("Szolgáltatás kiválasztása", sx*0.585, startY+sy*0.01, sx*0.585+sx*0.05, startY+sy*0.01+sy*0.06, tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 255*pAlpha), tocolor(0, 0, 0, 255*pAlpha), 0.8/myX*sx, fonts["condensed-12"], "right", "top")
                    --dxDrawRectangle(sx*0.585, startY+sy*0.01, sx*0.05, sy*0.06, tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 255*pAlpha))
                else
                    core:dxDrawShadowedText("Szolgáltatás kiválasztása", sx*0.585, startY+sy*0.01, sx*0.585+sx*0.05, startY+sy*0.01+sy*0.06, tocolor(phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4], 200*pAlpha), tocolor(0, 0, 0, 200*pAlpha), 0.8/myX*sx, fonts["condensed-12"], "right", "top")
                end
            end
        end

        dxDrawRectangle(sx*0.355, startY, sx*0.0015, sy*0.095, color2)

        startY = startY + sy*0.097
    end

    core:createScrollBar(phoneServices[selectedService].packages, panelPointer, sx*0.644, sy*0.403, sx*0.002, sy*0.291, {phoneServices[selectedService].color[2], phoneServices[selectedService].color[3], phoneServices[selectedService].color[4]}, 3, true, "package", pAlpha)
end

function keyPanel(key, state)
    if state then 
        if core:isInSlot(sx*0.35, sy*0.3, sx*0.3, sy*0.4) then 
            if key == "mouse_wheel_down" then 
                if phoneServices[selectedService].packages[panelPointer+4] then 
                    panelPointer = panelPointer + 1
                end
            elseif key == "mouse_wheel_up" then 
                if panelPointer > 0 then 
                    panelPointer = panelPointer - 1
                end
            end
        end
    end
end

function showPanel()
    tick = getTickCount()
    panelAnimType = "open"

    addEventHandler("onClientKey", root, keyPanel)
    addEventHandler("onClientRender", root, drawPanel)
end
--showPanel()