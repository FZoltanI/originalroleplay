local sx,sy = guiGetScreenSize()
local relX, relY = 1768, 992

function dxDrawOutLine(x, y, w, h, color, size, postgui)
	dxDrawLine(x, y, x+w, y, color, size, postgui)
	dxDrawLine(x, y, x, y+h, color, size, postgui)
	dxDrawLine(x, y+h, x+w, y+h, color, size, postgui)
	dxDrawLine(x+w, y, x+w, y+h, color, size, postgui)
end

function drawToolTip(text,bgColor,textColor,font,scale)
    if isCursorShowing() then 
        local cx, cy = getCursorPosition()

        local width = dxGetTextWidth(text,scale/relX*sx,font)/sx + 0.01

        cx = cx +0.005
        cy = cy + 0.004

        dxDrawRectangle(sx*cx,sy*cy,sx*(width),sy*0.03,bgColor,true)
        dxDrawText(text, sx*cx, sy*cy, sx*cx+sx*(width), sy*cy+sy*0.03, textColor, scale/relX*sx, font, "center", "center", false, false, true, true)
    end
end

function isInSlot(x,y,w,h)
    if isCursorShowing() then 
        local cX,cY = getCursorPosition()
        if cX and cY then 
            local sx,sy = guiGetScreenSize()
            cX,cY = cX*sx,cY*sy 

            if cX > x and cX < x + w and cY > y and cY < y + h then 
                return true 
            else 
                return false 
            end
        else 
            return false 
        end
    else 
        return false
    end
end

function dxDrawShadowedText(text, x, y, w, h, color, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	if not font then
		return
	end

    local textWithoutColors = string.gsub(text, "#......", "")

    local shadowType = (exports.oDashboard:getDashboardSettingsValue("other", 1))
    if shadowType == 1 then 
        dxDrawText(textWithoutColors, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
        dxDrawText(textWithoutColors, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
        dxDrawText(textWithoutColors, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
        dxDrawText(textWithoutColors, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
    elseif shadowType == 2 then 
        dxDrawText(textWithoutColors, x, y + 1, w, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
        dxDrawText(textWithoutColors, x + 1, y, w + 1, h, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
    end

	dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
end

function dxDrawRoundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end

function dxDrawButton(x, y, w, h, br, bg, bb, ba, text, textColor, fontSize, font, borderedText, borderColor)
    if isInSlot(x, y, w, h) then
        dxDrawRectangle(x, y, w, h, tocolor(br, bg, bb, ba*0.55))
        dxDrawRectangle(x + 2/relX*sx, y + 2/relY*sy, w - 4/relX*sx, h - 4/relY*sy, tocolor(br, bg, bb, ba))
    else
        dxDrawRectangle(x, y, w, h, tocolor(br, bg, bb, ba*0.40))
        dxDrawRectangle(x + 2/relX*sx, y + 2/relY*sy, w - 4/relX*sx, h - 4/relY*sy, tocolor(br, bg, bb, ba*0.70))
    end

    if borderedText then
        if not borderColor then borderColor = tocolor(0, 0, 0, 255) end 
        dxDrawShadowedText(text, x, y, x + w, y + h, textColor, borderColor, fontSize, font, "center", "center")
    else
        dxDrawText(text, x, y, x + w, y + h, textColor, fontSize, font, "center", "center")
    end
end

-- Progress Bar --
local progressBarDatas = {"", 0, "", false}
local progressBarAnimType = "open"
local progressBarAnimTick = getTickCount()
local tick = getTickCount()
local isActiveProgressbar = false

local progressBarFont = dxCreateFont("files/condensed.ttf", 10)

function renderProgressBar()
    local alpha
    
    if progressBarAnimType == "open" then 
        alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - progressBarAnimTick)/250, "Linear")
    else
        alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (getTickCount() - progressBarAnimTick)/250, "Linear")
    end

    local line_height = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick)/progressBarDatas[2], "Linear")

    dxDrawRectangle(sx*0.4, sy*0.85, sx*0.2, sy*0.02, tocolor(40, 40, 40, 255*alpha))
    dxDrawRectangle(sx*0.401, sy*0.852, (sx*0.2-sx*0.002), sy*0.02-sy*0.004, tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(sx*0.401, sy*0.852, (sx*0.2-sx*0.002)*line_height, sy*0.02-sy*0.004, tocolor(serverRGB[1], serverRGB[2], serverRGB[3], 255*alpha))

    if progressBarDatas[4] then 
        dxDrawText(progressBarDatas[1] .." ("..(math.floor(line_height*100)).."%)", sx*0.4, sy*0.85, sx*0.4+sx*0.2, sy*0.85+sy*0.02, tocolor(35, 35, 35, 255*alpha), 0.8/relX*sx, progressBarFont, "center", "center", false, false, false, true)
    else
        dxDrawText(progressBarDatas[1], sx*0.4, sy*0.85, sx*0.4+sx*0.2, sy*0.85+sy*0.02, tocolor(35, 35, 35, 255*alpha), 0.8/relX*sx, progressBarFont, "center", "center", false, false, false, true)
    end
end

function createProgressBar(title, time, endEvent, percentShowing)
    if not title or not time or not endEvent then outputDebugString("createProgressBar: Hiányzó argumentumok! (title, time, endEvent, [percentShowing])", 1) return end
    if isActiveProgressbar then return end 
    percentShowing = percentShowing or false

    progressBarDatas = {title, time, endEvent, percentShowing}

    progressBarAnimType = "open"
    progressBarAnimTick = getTickCount()
    tick = getTickCount()

    isActiveProgressbar = true
    addEventHandler("onClientRender", root, renderProgressBar)

    setTimer(function()
        progressBarAnimType = "close"
        progressBarAnimTick = getTickCount()
        triggerEvent(progressBarDatas[3], root)
        setTimer(function() 
            removeEventHandler("onClientRender", root, renderProgressBar) 
            isActiveProgressbar = false
        end, 250, 1)
    end, time, 1)
end
------------------

-- Scroll bar --
--[[local scrollBars = {}
local oldValues = {}
local scrollTicks = {}
local startValues = {}
local inRender = false

function createScrollBar(table, pointer, x, y, width, height, color, listedElementCount, postGui, id, alphaMultiplier)
    if not scrollTicks[id] then 
        scrollTicks[id] = getTickCount()
    end

    local lineHeight = listedElementCount/#table

    if #table < listedElementCount then 
        lineHeight = 1
    end

    if not alphaMultiplier then alphaMultiplier = 1 end

    scrollBars[id] = {table, pointer, x, y, width, height, color, listedElementCount, postGui, alphaMultiplier}

    if not inRender then 
        inRender = true
        addEventHandler("onClientRender", root, renderScrollBars)
    end
end

function renderScrollBars()
    for k, v in pairs(scrollBars) do 
        local lineHeight = v[8]/#v[1]

        if #v[1] < v[8] then 
            lineHeight = 1
        end
                    
        dxDrawRectangle(v[3], v[4], v[5], v[6], tocolor(v[7][1], v[7][2], v[7][3], 100*v[10]), v[9])
        dxDrawRectangle(v[3], v[4]+(v[6]*(lineHeight*v[2]/v[8])), v[5], v[6]*lineHeight, tocolor(v[7][1], v[7][2], v[7][3], 255*v[10]), v[9])
    end
end]]

function dxDrawScrollbar(x, y, w, h, table, pointer, listedElementCount, r, g, b, a, postgui) -- a: 1-0 között
    local lineHeight = listedElementCount/#table

    if #table < listedElementCount then 
        lineHeight = 1
    end
                
    dxDrawRectangle(x, y, w, h, tocolor(r, g, b, 100*a), postgui)
    dxDrawRectangle(x, y+(h*(lineHeight*pointer/listedElementCount)), w, h*lineHeight, tocolor(r, g, b, 220*a), postgui)
end


----------------

-- Editbox -- 
local createdEditboxes = {}
local rendering = false
local font = exports.oFont
local activeEditbox = false

local textPointerTick = getTickCount()
local textPointerValue = 0

local eyeIcons = {
    [0] = "",
    [1] = "",
}

addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oFont" or getResourceName(res) == "oCore" then 
        font = exports.oFont
    end 
end)

function renderEditboxes()
    for k, v in pairs(createdEditboxes) do 
        if v then 
            if isInSlot(v.x, v.y, v.w, v.h) or activeEditbox == k then 
                dxDrawRectangle(v.x, v.y, v.w, v.h, tocolor(unpack(v.bgColor)), v.postGui)
            else
                dxDrawRectangle(v.x, v.y, v.w, v.h, tocolor(v.bgColor[1], v.bgColor[2], v.bgColor[3], v.bgColor[4]*0.8), v.postGui)
            end
            
            local alignX = "left"
            local text = guiGetText(v.edit)
            local textFont = font:getFont("condensed", v.h*math.min(v.fontMaxScale, 0.5)) 

            local iconWidth = dxGetTextWidth(eyeIcons[v.passVisible], 1, font:getFont("fontawesome2", v.h*0.35))

            local realWidth = v.w - 6/relX*sx

            if v.type == "password" then 
                realWidth = realWidth - iconWidth

                if v.passVisible == 0 then 
                    text = string.rep("", string.len(text))
                    textFont = font:getFont("fontawesome2", v.h*math.min(v.fontMaxScale, 0.35))
                end

                --dxDrawRectangle(v.x+v.w - iconWidth, v.y, iconWidth, v.h)
                if isInSlot(v.x+v.w - iconWidth, v.y, iconWidth, v.h) then 
                    dxDrawText(eyeIcons[v.passVisible], v.x+v.w - iconWidth, v.y, v.x+v.w, v.y+v.h, tocolor(255, 255, 255, v.bgColor[4]), 1, font:getFont("fontawesome2", v.h*0.35), "center", "center", _, _, v.postGui)
                else
                    dxDrawText(eyeIcons[v.passVisible], v.x+v.w - iconWidth, v.y, v.x+v.w, v.y+v.h, tocolor(255, 255, 255, v.bgColor[4]*0.7), 1, font:getFont("fontawesome2", v.h*0.35), "center", "center", _, _, v.postGui)
                end
            end

            local textPointerPos = v.x+4/relX*sx+dxGetTextWidth(text, 1, textFont)

            if dxGetTextWidth(text, 1, textFont) > realWidth then 
                alignX = "right"
                textPointerPos = v.x+realWidth
            end

            if text == v.text then 
                dxDrawText(text, v.x+4/relX*sx, v.y, v.x+realWidth, v.y+v.h, tocolor(255, 255, 255, v.bgColor[4]*0.7), 1, textFont, alignX, "center", true, _, v.postGui)
            else
                dxDrawText(text, v.x+4/relX*sx, v.y, v.x+realWidth, v.y+v.h, tocolor(255, 255, 255, v.bgColor[4]), 1, textFont, alignX, "center", true, _, v.postGui)
            end

            if activeEditbox == k then
                guiBringToFront(v.edit)
                guiEditSetCaretIndex(v.edit, string.len(text))

                textPointerValue = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-textPointerTick)/1000, "SineCurve")

                dxDrawText("|", textPointerPos, v.y, textPointerPos+v.w, v.y+v.h, tocolor(255, 255, 255, v.bgColor[4]*textPointerValue), 1, font:getFont("condensed", v.h*0.6), "left", "center", _, _, v.postGui)
                --dxDrawLine(v.x, v.y+(4/relY*sy)+(v.h*(1-textPointerValue)), v.x, v.y-(8/relY*sy)+(v.h*textPointerValue), tocolor(255, 255, 255, 255*textPointerValue), 2/relX*sx)
            end
        end
    end
end

function keyEdtiboxes(key, state)
    if activeEditbox then 
        cancelEvent()
    end 

    if key == "mouse1" and state then 
        for k, v in pairs(createdEditboxes) do 
            if v then
                local iconWidth = dxGetTextWidth(eyeIcons[v.passVisible], 1, font:getFont("fontawesome2", v.h*math.min(v.fontMaxScale, 0.5)))

                if isInSlot(v.x+v.w-iconWidth, v.y, iconWidth, v.h) then 
                    if v.passVisible == 0 then 
                        v.passVisible = 1 
                    else 
                        v.passVisible = 0 
                    end
                    break
                end

                if isInSlot(v.x, v.y, v.w-iconWidth, v.h) then 
                    if guiGetText(v.edit) == v.defText then 
                        guiSetText(v.edit, "")
                    end

                    activeEditbox = k
                    guiBringToFront(v.edit) 

                    return 
                end
            end
        end

        if activeEditbox then 
            if guiGetText(createdEditboxes[activeEditbox].edit) == "" then 
                guiSetText(createdEditboxes[activeEditbox].edit, createdEditboxes[activeEditbox].defText)
            end
        end

        activeEditbox = false
    end
end

function createEditbox(x, y, w, h, name, text, type, postGui, bgColor, fontMaxScale, maxChar)
    if not (x or y or w or h or name) then return end
    fontMaxScale = fontMaxScale or 0.5
    text = text or ""
    postGui = postGui or false 
    bgColor = bgColor or {35, 35, 35, 255}
    maxChar = maxChar or false

    local edit = false

    if not createdEditboxes[name] then 
        edit = guiCreateEdit(-100, -100, 100, 100, text, false)

        if maxChar then
            guiEditSetMaxLength (edit, maxChar)
        end

        guiMoveToBack(edit)
    end

    if not edit then edit = createdEditboxes[name].edit end

    createdEditboxes[name] = {
        edit = edit,
        x = x, 
        y = y, 
        w = w, 
        h = h,
        text = text,
        type = type,
        postGui = postGui,
        bgColor = bgColor,
        defText = text,
        passVisible = 0,
        fontMaxScale = fontMaxScale, -- Max: 0.5, Min: 0
    }

    if not rendering then 
        rendering = true
        addEventHandler("onClientRender", root, renderEditboxes)
        addEventHandler("onClientKey", root, keyEdtiboxes)
    end
end

function deleteEditbox(name)
    if not createdEditboxes[name] then return end 

    local edit = createdEditboxes[name]
    destroyElement(edit.edit)

    if activeEditbox == name then activeEditbox = false end 

    createdEditboxes[name] = false 

    local renderedBox = false 

    for k, v in pairs(createdEditboxes) do 
        if v then 
            renderedBox = true
            break 
        end 
    end 

    if not renderedBox then 
        rendering = false
        removeEventHandler("onClientRender", root, renderEditboxes)
        removeEventHandler("onClientKey", root, keyEdtiboxes)
    end
end

function getEditboxText(name)
    if not createdEditboxes[name] then return end 

    local edit = createdEditboxes[name]
    local text = guiGetText(edit.edit) 

    if text == edit.defText then 
        text = ""
    end

    return text
end

function setEditboxText(name, text) 
    if not createdEditboxes[name] then return end 
    if not text then text = "" end

    local edit = createdEditboxes[name]
    local text = guiSetText(edit.edit, text)
end
-------------

-- Custom window
function drawWindow(x, y, w, h, title, alpha) -- alpha: (1 és 0 között)
    if not alpha then alpha = 1 end 

    dxDrawRectangle(x, y, w, h, tocolor(35, 35, 35, 100 * alpha))
    dxDrawRectangle(x + 2/relX*sx, y + 2/relY*sy, w - 4/relX*sx, h - 4/relY*sy, tocolor(35, 35, 35, 255 * alpha))
    dxDrawRectangle(x + 2/relX*sx, y + 2/relY*sy, w - 4/relX*sx, sy*0.02, tocolor(30, 30, 30, 255 * alpha))

    dxDrawText(title, x + 2/relX*sx, y + 2/relY*sy, x + 2/relX*sx + w - 4/relX*sx, y + 2/relY*sy + sy*0.02, tocolor(255, 255, 255, 100 * alpha), 1, font:getFont("condensed", 10/relX*sx), "center", "center", false, false, false, true)
end