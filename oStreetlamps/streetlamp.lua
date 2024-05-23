x, y = guiGetScreenSize()

rel = ((x/1376)+(y/768))/2

color, r, g, b = exports.oCore:getServerColor()

font = dxCreateFont("assets/RobotoCondensed-Bold.ttf", 11*rel)

core = exports.oCore

--[[
		4 féle lámpa-állás van: 1.Green, 2.Red, 3.Yellow, 4.OFF

]]

traffic_light_state_colors = {
	[0] = "Green",
	[1] = "Red",
	[2] = "Yellow",
	[3] = "OFF"
}
traffic_light_states = {0,1,2,3,4,5,6,7,8,9}

local panelShowing = true

local closing = false

local infopanel_isOpen = false

ppx, ppy, ppz = getElementPosition(localPlayer)

local a = 0


local marker = exports.oCustomMarker:createCustomMarker(1155.5059814453, -2047.2994384766, 69.000610351563, 3.0, 9, 152, 181, 255, "traffic_light", "circle")

addEventHandler("onClientResourceStop", resourceRoot, function()
	destroyElement(marker)
end)

setElementData(marker, "onmarker", true)

function keycsinalas(button,state)
	--addEventHandler("onClientKey", root, --közlekedési lámpák bekapcsolása
			if button == "mouse1" and state then
				if core:isInSlot(x*0.425,y*0.45,x*0.05,y*0.03) then
					triggerServerEvent("onLightsEnabled", getRootElement())
				    exports.oInfobox:outputInfoBox("Bekapcsoltad a közlekedési lámpákat!","info")
				    --local asd = all_of_the_light_states[1][0]
				    --outputChatBox(asd)
				end
			end
end
function keyremovolas(button,state)
			--addEventHandler("onClientKey", root, --közlekedési lámpák kikapcsolása
	    			if button == "mouse1" and state then
	        			if core:isInSlot(x*0.52,y*0.45,x*0.05,y*0.03) then
	            			triggerServerEvent("onLightsDisabled", getRootElement())
	            			exports.oInfobox:outputInfoBox("Kikapcsoltad a közlekedési lámpákat!","info")
	            		end
	            	end
end
function keybezaras(button,state)
	--addEventHandler("onClientKey", root, --panelbezárás
			if button == "mouse1" and true then
			    if core:isInSlot(x*0.585,y*0.4,x*0.015,y*0.0225) then
			        imageShowing = true
			        panelShowing = true
			        closing = true
			        removeEventHandler("onClientRender", root, panel)
			        removeEventHandler("onClientKey", root, keycsinalas)
			        removeEventHandler("onClientKey", root, keyremovolas)
			        removeEventHandler("onClientKey", root, keybezaras)
			        removeEventHandler("onClientRender", root, infopanel)
			        removeEventHandler("onClientKey", root, infopanel_key)
			    end
			end
end

function infopanel()
	local lightstate = getTrafficLightState()
	local fix_pos_x_up = 0.49 * x
	local fix_pos_y_up = 0.22 * y
	local fix_pos_x_down = 0.49 * x
	local fix_pos_y_down = 0.35 * y
	local fix_pos_x_left = 0.44 * x
	local fix_pos_y_left = 0.285 * y
	local fix_pos_x_right = 0.54 * x
	local fix_pos_y_right = 0.285 * y
	local width = 0.02 * x
	local height = 0.03 * y
	dxDrawRectangle(x*0.4, y*0.2, x*0.2, y*0.2, tocolor(30,30,30,255))
	if lightstate == 0 then
		dxDrawImage(fix_pos_x_up, fix_pos_y_up, width, height, "assets/Traffic_green.png")
		dxDrawImage(fix_pos_x_down, fix_pos_y_down, width, height, "assets/Traffic_green.png")
		dxDrawImage(fix_pos_x_left, fix_pos_y_left, width, height, "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_right, fix_pos_y_right, width, height, "assets/Traffic_red.png")
	elseif lightstate == 1 then
		dxDrawImage(fix_pos_x_up, fix_pos_y_up, width,height , "assets/Traffic_yellow.png")
		dxDrawImage(fix_pos_x_down, fix_pos_y_down,width ,height , "assets/Traffic_yellow.png")
		dxDrawImage(fix_pos_x_left, fix_pos_y_left,width ,height , "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_right, fix_pos_y_right,width ,height , "assets/Traffic_red.png")
	elseif lightstate == 2 then
		dxDrawImage(fix_pos_x_up, fix_pos_y_up, width, height, "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_down, fix_pos_y_down,width ,height , "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_left, fix_pos_y_left,width ,height , "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_right, fix_pos_y_right,width ,height , "assets/Traffic_red.png")
	elseif lightstate == 3 then
		dxDrawImage(fix_pos_x_up, fix_pos_y_up,width ,height , "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_down, fix_pos_y_down,width ,height , "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_left, fix_pos_y_left,width ,height , "assets/Traffic_green.png")
		dxDrawImage(fix_pos_x_right, fix_pos_y_right,width ,height , "assets/Traffic_green.png")
	elseif lightstate == 4 then
		dxDrawImage(fix_pos_x_up, fix_pos_y_up,width ,height , "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_down, fix_pos_y_down,width ,height , "assets/Traffic_red.png")
		dxDrawImage(fix_pos_x_left, fix_pos_y_left,width ,height , "assets/Traffic_yellow.png")
		dxDrawImage(fix_pos_x_right, fix_pos_y_right,width ,height , "assets/Traffic_yellow.png")
	elseif lightstate == 9 then
		dxDrawImage(fix_pos_x_up, fix_pos_y_up,width ,height , "assets/Traffic_off.png")
		dxDrawImage(fix_pos_x_down, fix_pos_y_down,width ,height , "assets/Traffic_off.png")
		dxDrawImage(fix_pos_x_left, fix_pos_y_left,width ,height , "assets/Traffic_off.png")
		dxDrawImage(fix_pos_x_right, fix_pos_y_right,width ,height , "assets/Traffic_off.png")
	end
end

function infopanel_key(button,state)
	if button == "mouse1" then
		if state == true then
			if core:isInSlot(x*0.57, y*0.4, x*0.015, y*0.0225) then
				if infopanel_isOpen == false then
					addEventHandler("onClientRender", root, infopanel)
					infopanel_isOpen = true
				else
					removeEventHandler("onClientRender", root, infopanel)
					infopanel_isOpen = false
				end
			end
		end
	end
end

function panel()
	if panelShowing == true then
		--dxDrawText(ppx.." "..ppy.." "..ppz.."", x*0.3, y*0.3)
		--outputConsole(ppx.." "..ppy.." "..ppz)
		local lightstate = getTrafficLightState()
		dxDrawRectangle(x*0.4, y*0.4, x*0.2, y*0.15, tocolor (50,50,50,255))
		dxDrawLine(x*0.4, y*0.43, x*0.6, y*0.43, tocolor(r,g,b,a))
		dxDrawText("Original"..color.."Roleplay", x*0.405, y*0.41, x*0.42, y*0.41, tocolor(255,255,255,255), 1, font, _, _, _, _, _, true)
		if lightstate == 0 or lightstate == 1 or lightstate == 2 or lightstate == 3 or lightstate == 4 then
			dxDrawText("A lámpák jelenlegi állapota: "..color.."Bekapcsolva", x*0.415, y*0.555, _, _, _, 1, font, _, _, _, _, _, true)
		else
			dxDrawText("A lámpák jelenlegi állapota: "..color.."Kikapcsolva", x*0.415, y*0.555, _, _, _, 1, font, _, _, _, _, _, true)
		end
		--dxDrawText("Roleplay", x*0.44, y*0.41, _, _, tocolor(r,g,b,FF), _, font)
		dxDrawLine(x*0.58, y*0.4, x*0.58, y*0.43, tocolor(r,g,b,a))
		dxDrawLine(x*0.58, y*0.4, x*0.6, y*0.4, tocolor(r,g,b,a))
		dxDrawLine(x*0.6, y*0.4, x*0.6, y*0.43, tocolor(r,g,b,a))
		dxDrawRectangle(x*0.43, y*0.45, x*0.05, y*0.03, tocolor(90,255,90,200))
		dxDrawRectangle(x*0.52, y*0.45, x*0.05, y*0.03, tocolor(255,30,30,200))
		dxDrawLine(x*0.4, y*0.55, x*0.4, y*0.58, tocolor(40,40,40,255))
		dxDrawLine(x*0.4, y*0.58, x*0.6, y*0.58, tocolor(40,40,40,255))
		dxDrawLine(x*0.6, y*0.58, x*0.6, y*0.43, tocolor(40,40,40,255))
		--dxDrawLine(x*0.585, y*0.4, x*0.585, y*0.4225, tocolor(255,0,0,255))
		--dxDrawLine(x*0.585, y*0.4225, x*0.6, y*0.4225, tocolor(255,0,0,255))
		--dxDrawLine(x*0.6, y*0.4225, x*0.6, y*0.4, tocolor(255,0,0,255))
		--dxDrawLine(x*0.6, y*0.4, x*0.585, y*0.4, tocolor(255,0,0,255))

		if core:isInSlot(x*0.43, y*0.45, x*0.05, y*0.03) then
			dxDrawText("Közlekedési lámpák bekapcsolása", x*0.425, y*0.52, _, _, tocolor(r,g,b,FF), _, font)
		end
		if core:isInSlot(x*0.52, y*0.45, x*0.05, y*0.03) then
			dxDrawText("Közlekedési lámpák kikapcsolása", x*0.428, y*0.52, _, _, tocolor(r,g,b,FF), _, font)	
		end
		if core:isInSlot(x*0.585,y*0.4,x*0.015,y*0.0225) then
			dxDrawRectangle(x*0.585, y*0.4, x*0.015, y*0.0225, tocolor(255,0,0,255))
	    	dxDrawImage(x*0.585,y*0.4,x*0.015,y*0.0225,"assets/xmark.png",0,0,0,tocolor(200,0,0,255))
	    else
			dxDrawImage(x*0.585, y*0.4, x*0.015, y*0.0225, "assets/xmark.png", 0, 0, 0, tocolor(255,0,0,255))
		end

		if core:isInSlot(x*0.57, y*0.4, x*0.015, y*0.0225) then
			dxDrawRectangle(x*0.57, y*0.4, x*0.015, y*0.0225, tocolor(30,30,30,255))
			dxDrawImage(x*0.57, y*0.4, x*0.015, y*0.0225, "assets/informationicon.png", 0, 0, 0, tocolor(255,255,255,255))
		else
			dxDrawImage(x*0.57, y*0.4, x*0.015, y*0.0225, "assets/informationicon.png", 0, 0, 0, tocolor(255,255,255,255))
		end
	end
end

function dohandling()
	addEventHandler("onClientRender", root, panel)
end
function removehandling()
	removeEventHandler("onClientRender", root, panel)
end

function Markerhit(hitPlayer, matchingDimension)
	if getElementData(source, "onmarker") then
		if hitPlayer == localPlayer and matchingDimension == true then
			addEventHandler("onClientRender", root, panel)	
			addEventHandler("onClientKey", root, keycsinalas)
			addEventHandler("onClientKey", root, keybezaras)
			addEventHandler("onClientKey", root, keyremovolas)	
			--addEventHandler("onClientRender", root, infopanel)
			addEventHandler("onClientKey", root, infopanel_key)
		end
	end
end
function Markerleave(leftPlayer, matchingDimension)
	if getElementData(source, "onmarker") then
		if leftPlayer == localPlayer and matchingDimension == true then
			removeEventHandler("onClientRender", root, panel)
			removeEventHandler("onClientKey", root, keycsinalas)
			removeEventHandler("onClientKey", root, keybezaras)
			removeEventHandler("onClientKey", root, keyremovolas)
			removeEventHandler("onClientRender", root, infopanel)
			removeEventHandler("onClientKey", root, infopanel_key)
			infopanel_isOpen = false
		end
	end
end
function positionsaving(button,state)
	if button == "u" then
		if state == true then
			local var,var1,var2 = getElementPosition(localPlayer)
			setClipboard(var..","..var1..","..var2.."") 
		end
	end
end

addEventHandler("onClientMarkerHit", root, Markerhit)
addEventHandler("onClientMarkerLeave", root, Markerleave)
addEventHandler("onClientKey", root, positionsaving)