local sx,sy = guiGetScreenSize()
local top = sx*0.25
local left = sx*0.45
local windowOffsetX, windowOffsetY = 0, 0
local isDraggingWindow = false
local visionName = "#e87618vision#ffffff2000"
local visionNameShadow = "vision2000"
local inPanel = false
local fontsScript = exports.oFont
local font = fontsScript:getFont("condensed", 14)

setElementData(localPlayer,"char:goggleUser",false)

function Clicker(b, s, x, y)
	if b == 'left' and s == 'down' and inPanel then
        if exports.oCore:isInSlot(left, top,sx*0.1,sy*0.1) then 
			show = false
		end
		if x >= left and x < left + 230 and y >= top and y < top + 140 then
			windowOffsetX, windowOffsetY = (left) - x, (top) - y
			isDraggingWindow = true
		end
	end
	if b == "left" and s == "up" and isDraggingWindow and inPanel then
		isDraggingWindow = false
	end
end

function scopeFix(button,pressed)
    if button == "mouse2" then 
        if getPedWeapon(localPlayer) == 34 then
            if pressed then 
                goggle = getElementData(localPlayer,"char:goggleElement") 
                setElementAlpha(goggle,0)
            else 
                goggle = getElementData(localPlayer,"char:goggleElement") 
                setElementAlpha(goggle,255)
            end
        else 
            goggle = getElementData(localPlayer,"char:goggleElement") 
            setElementAlpha(goggle,255)  
        end 
    end 
end 

local tg = dxCreateTexture("vg.png")
local lineR, lineG, lineB = 0,0,0

function drawGoggle()
	if isCursorShowing() then
		cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX * sx, cursorY * sy
	end 
		
	if isDraggingWindow then
		left, top = cursorX + windowOffsetX, cursorY + windowOffsetY
	end
    local r, g, b = 255, 255, 255
    local lineR ,lineG, lineB = 255,255,255
    if getElementData(localPlayer,"char:goggleUser") then 
        local alpha = interpolateBetween(0, 0, 0, 150, 0, 0, getTickCount() / 2000, "CosineCurve");

        if getElementData(localPlayer,"char:goggleUser->nightVision") then 
            lineR, lineG, lineB = interpolateBetween(0, 0, 0, 0, 80, 0, getTickCount() / 2000, "CosineCurve");
            r, g, b = interpolateBetween(255, 255, 255, 191, 61, 61, getTickCount() / 2000, "CosineCurve");
        elseif getElementData(localPlayer,"char:goggleUser->thermalVision") then 
            lineR ,lineG, lineB = interpolateBetween(10,2,123,249,145,1, getTickCount() / 2000, "CosineCurve"); 
            r, g, b = interpolateBetween(255, 255, 255, 191, 61, 61, getTickCount() / 2000, "CosineCurve");
        end 
    end 

    dxDrawRectangle(left, top,sx*0.088,sy*0.06,tocolor(40,40,40,255))
    dxDrawRectangle(left + sx*0.0015, top + sy*0.0015,sx*0.085,sy*0.012,tocolor(30,30,30,255))

    dxDrawText(visionNameShadow, left + sx*0.088 - 1, top + sy*0.016 + 1,left, top, tocolor(0, 0, 0, 255), 0.00035*sx, font, "center", "center",false,false,false,true)
    dxDrawText(visionName, left + sx*0.088, top + sy*0.016,left, top, tocolor(255, 255, 255, 255), 0.00035*sx, font, "center", "center",false,false,false,true)


    dxDrawRectangle(left + sx*0.0023, top + sy*0.017,sx*0.025,sy*0.04,tocolor(30,30,30,255)) -- night
    dxDrawRectangle(left + sx*0.0318, top + sy*0.017,sx*0.025,sy*0.04,tocolor(30,30,30,255)) -- off 
    dxDrawRectangle(left + sx*0.061, top + sy*0.017,sx*0.025,sy*0.04,tocolor(30,30,30,255)) --thermo

    dxDrawText("OFF", left + sx*0.088 - 1, top + sy*0.075 + 1,left, top, tocolor(0, 0, 0, 255), 0.00035*sx, font, "center", "center",false,false,false,true)
    dxDrawText("OFF", left + sx*0.088, top + sy*0.075,left, top, tocolor(r, g, b, 255), 0.00035*sx, font, "center", "center",false,false,false,true)

    dxDrawText("NIGHT\nVISION", left + sx*0.029 - 1, top + sy*0.075 + 1,left, top, tocolor(0, 0, 0, 255), 0.00031*sx, font, "center", "center",false,false,false,true)
    dxDrawText("NIGHT\nVISION", left + sx*0.029, top + sy*0.075,left, top, tocolor(255, 255, 255, 255), 0.00031*sx, font, "center", "center",false,false,false,true)

    dxDrawText("THERMO\nVISION", left + sx*0.147 - 1, top + sy*0.075 + 1,left, top, tocolor(0, 0, 0, 255), 0.00031*sx, font, "center", "center",false,false,false,true)
    dxDrawText("THERMO\nVISION", left + sx*0.147, top + sy*0.075,left, top, tocolor(255, 255, 255, 255), 0.00031*sx, font, "center", "center",false,false,false,true)

    dxDrawRectangle(left, top + sy*0.059,sx*0.088,sy*0.001,tocolor(lineR, lineG, lineB,255))
    
    if getElementData(localPlayer,"char:goggleUser->nightVision") then 
        dxDrawImage(left + sx*0.0023, top + sy*0.017,sx*0.025,sy*0.04,"vg.png",0,0,0,tocolor(0,80,0,alpha))
    elseif getElementData(localPlayer,"char:goggleUser->thermalVision") then 
        dxDrawImage(left + sx*0.061, top + sy*0.017,sx*0.025,sy*0.04,"vg.png",0,0,0,tocolor(lineR ,lineG, lineB,alpha))
    end 
end 




function getUpGoggle(player)
    inPanel = true
    triggerServerEvent("attachGoggle",root,player)
    addEventHandler("onClientRender",root,drawGoggle) 
    addEventHandler("onClientKey",root,scopeFix)
    addEventHandler('onClientClick', root,Clicker)
end    
addEvent("getUpGoggle",true)
addEventHandler("getUpGoggle",root,getUpGoggle)

function takeDownGoggle(player)
    triggerServerEvent("detachGoggle",root,player)
    removeEventHandler("onClientRender",root,drawGoggle) 
    removeEventHandler("onClientKey",root,scopeFix)
    removeEventHandler('onClientClick', root,Clicker)

    setCameraGoggleEffect("normal")
    inPanel = false
end
addEvent("takeDownGoggle",true)
addEventHandler("takeDownGoggle",root,takeDownGoggle)

local spam = false

function thermalKey(b, s, x, y)
	if b == 'left' and s == 'down' and inPanel then
        timer = 4000
        if exports.oCore:isInSlot(left + sx*0.0023, top + sy*0.017,sx*0.025,sy*0.04) then 
            if not spam then 
                if not getElementData(localPlayer,"char:goggleUser->nightVision") then
                    setCameraGoggleEffect("nightvision")
                    if getElementData(localPlayer,"char:goggleUser->thermalVision") then 
                        sound = playSound("switch.wav")
                        setSoundVolume(sound, 20)
                        timer = 700
                    else 
                        sound = playSound("on.wav")
                        setSoundVolume(sound, 20)
                        timer = 4000
                    end 
                    setElementData(localPlayer,"char:goggleUser->nightVision",true)
                    setElementData(localPlayer,"char:goggleUser->thermalVision",false)
                    spam = true 

                    setTimer(function()
                        spam = false 
                    end,timer,1)
                end
            else
                outputChatBox(exports.oCore:getServerPrefix("red-dark", "Vision", 2).."Ne spammeld!", 255, 255, 255, true)
            end 
        elseif exports.oCore:isInSlot(left + sx*0.0318, top + sy*0.017,sx*0.025,sy*0.04) then 
            if not spam then 
                if getElementData(localPlayer,"char:goggleUser->thermalVision") or getElementData(localPlayer,"char:goggleUser->nightVision") then
                    setCameraGoggleEffect("normal")
                    setElementData(localPlayer,"char:goggleUser->thermalVision",false)
                    setElementData(localPlayer,"char:goggleUser->nightVision",false)
                    sound = playSound("off.wav")
                    setSoundVolume(sound, 20)
                    spam = true 
                    
                    setTimer(function()
                        spam = false 
                    end,1700,1)
                end
            else
                outputChatBox(exports.oCore:getServerPrefix("red-dark", "Vision", 2).."Ne spammeld!", 255, 255, 255, true)
            end 
        elseif exports.oCore:isInSlot(left + sx*0.061, top + sy*0.017,sx*0.025,sy*0.04) then 
            if not spam then 
                if not getElementData(localPlayer,"char:goggleUser->thermalVision") then
                    setCameraGoggleEffect("thermalvision")
                    if getElementData(localPlayer,"char:goggleUser->nightVision") then 
                        sound = playSound("switch.wav")
                        setSoundVolume(sound, 20)
                        timer = 700
                    else 
                        sound = playSound("on.wav")
                        setSoundVolume(sound, 20)
                        timer = 4000

                    end 

                    setElementData(localPlayer,"char:goggleUser->nightVision",false)
                    setElementData(localPlayer,"char:goggleUser->thermalVision",true)
                    spam = true 

                    setTimer(function()
                        spam = false 
                    end,timer,1)
                end 
            else
                outputChatBox(exports.oCore:getServerPrefix("red-dark", "Vision", 2).."Ne spammeld!", 255, 255, 255, true)
            end 
        end 
	end
end
addEventHandler('onClientClick', root,thermalKey)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
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

function isPedAiming (thePedToCheck)
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(thePedToCheck) then
				return true
			end
		end
	end
	return false
end