local sx,sy = guiGetScreenSize()
local myX, myY = 1600, 900

local core = exports.cl_core
local font = exports.cl_font
local color, r, g, b = core:getServerColor()

local bigfont = font:getFont("bebasneue",15)
local wrenchTexture = dxCreateTexture("wrench.png")

local hasAcces = true
local showing = false
local jelenlegiCol = false

local ellenorzoTimer = false
local talaltKocsit = false

local alkatreszek = {
	
}

local panelW, panelH = sx*0.145, sy*0.3

local availableComponents = {
	-- Név, Component, Panel, Door, Offset{}, Wheel

	-- Létező componentek
	["boot_dummy"] = {"Csomagtartó", "boot_dummy", _, 1, {0, 0.6},15},
	["bonnet_dummy"] = {"Motorháztető", "bonnet_dummy", _, 0, {0, 0.45},25},
	["bump_rear_dummy"] = {"Hátsó lökhárító", "bump_rear_dummy", 6, _, {-0.9, 0.85},10},
	["bump_front_dummy"] = {"Első lökhárító", "bump_front_dummy", 5, _, {1, 0.6},8},
	["wheel_lf_dummy"] = {"Bal első kerék", "wheel_lf_dummy", _, _, {0.5, 0.85}, 5},
	["wheel_rf_dummy"] = {"Jobb első kerék", "wheel_rf_dummy", _, _, {0.5, 0.85}, 5},
	["wheel_lb_dummy"] = {"Bal hátsó kerék", "wheel_lb_dummy", _, _, {0.5, 0.85}, 5},
	["wheel_rb_dummy"] = {"Jobb hátsó kerék", "wheel_rb_dummy", _, _, {0.5, 0.85}, 2},
	["door_lf_dummy"] = {"Bal első ajtó", "door_lf_dummy", 0, 2, {0.5, 0.7},10},
	["door_rf_dummy"] = {"Jobb első ajtó", "door_rf_dummy", 1, 3, {0.5, 0.85},10},
	["door_lr_dummy"] = {"Bal hátsó ajtó", "door_lr_dummy", 2, 4, {0.5, 0.85},10},
	["door_rr_dummy"] = {"Jobb hátsó ajtó", "door_rr_dummy", 3, 5, {0.5, 0.85},10},
	["windscreen_dummy"] = {"Szélvédő", "windscreen_dummy", 4, _, {0, 0.6}},

	-- Motor
	["chassis_dummy"] = {"Motor", "chassis_dummy", _, _},
	--["windscreen_dummy"] = {"Motor", "chassis_dummy", _, _, _, 100},

	-- Nem valós componentek
	["panel_lf"] = {"Bal első sárvédő", "wheel_lf_dummy", 0, _, _, 10},
	["panel_rf"] = {"Jobb első sárvédő", "wheel_rf_dummy", 1, _, _, 10},
	["panel_lb"] = {"Bal hátsó sárvédő", "wheel_lb_dummy", 2, _, _, 10},
	["panel_rb"] = {"Jobb hátsó sárvédő", "wheel_rb_dummy", 3, _, _, 10},
}

function renderMechanicPanel()

	if #alkatreszek > 0 then 

		dxDrawText("classGaming - Mechanic", sx*0.851, (sy*0.4)-(#alkatreszek*(sy*0.01))-sy*0.041, sx*0.85+panelW+sx*0.002, (sy*0.4)-(#alkatreszek*(sy*0.01))-sy*0.041+sy*0.048, tocolor(0,0,0,200),1/myX*sx,bigfont,"center","center")
		dxDrawText("classGaming - "..color.."Mechanic", sx*0.85, (sy*0.4)-(#alkatreszek*(sy*0.01))-sy*0.04, sx*0.85+panelW, (sy*0.4)-(#alkatreszek*(sy*0.01))-sy*0.04+sy*0.04, tocolor(255,255,255,255),1/myX*sx,bigfont,"center","center",false,false,false,true)
		dxDrawRectangle(sx*0.85, (sy*0.4)-(#alkatreszek*(sy*0.01)), panelW, (sy*0.04)*#alkatreszek, tocolor(50,50,50,220))
		dxDrawLine(sx*0.85, (sy*0.4)-(#alkatreszek*(sy*0.01)), sx*0.85+panelW, (sy*0.4)-(#alkatreszek*(sy*0.01)), tocolor(r, g, b, 255), 1)

		for i = 1, #alkatreszek do
			dxDrawText(alkatreszek[i][1].." #7cc576["..alkatreszek[i][2].."$]",sx*0.855, (sy*0.4)-(#alkatreszek*(sy*0.01))+sy*0.04*(i-1), sx*0.855+panelW, (sy*0.4)-(#alkatreszek*(sy*0.01))+sy*0.04+sy*0.04*(i-1), tocolor(255,255,255,255),0.8/myX*sx,bigfont,"left","center", false,false,false,true)

			if isInSlot(sx*0.97, (sy*0.405)-(#alkatreszek*(sy*0.01))+sy*0.04*(i-1), sx*0.018, sy*0.03) then

				dxDrawImage(sx*0.97, (sy*0.405)-(#alkatreszek*(sy*0.01))+sy*0.04*(i-1), sx*0.018, sy*0.03, wrenchTexture, 0, 0, 0, tocolor(r,g,b, 255))
			else
				dxDrawImage(sx*0.97, (sy*0.405)-(#alkatreszek*(sy*0.01))+sy*0.04*(i-1), sx*0.018, sy*0.03, wrenchTexture)
			end
		end
	end
end

addEventHandler("onClientKey", root,
	function(key,state)

		if state and key == "mouse1" and showing then 
			for i = 1, #alkatreszek do
				if isInSlot(sx*0.97, (sy*0.405)-(#alkatreszek*(sy*0.01))+sy*0.04*(i-1), sx*0.018, sy*0.03) then
					setVehicleComponentVisible(talaltKocsit, alkatreszek[i][3], true)
					outputChatBox(alkatreszek[i][4])
					setVehiclePanelState(talaltKocsit,availableComponents[alkatreszek[i][3]][3],0)
					outputChatBox(alkatreszek[i][1],0,255,0)
					table.remove(alkatreszek, i)
				end 
			end
		end
	end 
)

addEvent("setMechanicPanelVisible", true)
addEventHandler("setMechanicPanelVisible", root,
	function(state, col)
		if not state then 
			showing = false
			removeEventHandler("onClientRender", root, renderMechanicPanel)

			if isTimer(ellenorzoTimer) then 
				killTimer(ellenorzoTimer)
			end
			ellenorzoTimer = false
			talaltKocsit = false

			alkatreszek = {}
		else 
			showing = true 
			addEventHandler("onClientRender", root, renderMechanicPanel)

			ellenorzoTimer = setTimer( 
				function()
					for k, v in ipairs(getElementsByType("vehicle", _, true)) do 

						if isElementWithinColShape(v,jelenlegiCol) then
							talaltKocsit = v 

							alkatreszek = {}

							if talaltKocsit then 
								for i,component in pairs(availableComponents) do
									if hasComponent(v,component[2]) then
										local damaged = false
										if component[3] and getVehiclePanelState(v, component[3]) and getVehiclePanelState(v, component[3]) ~= 0 or component[4] and getVehicleDoorState(v, component[4]) > 1 then
											damaged = true
											table.insert(alkatreszek, #alkatreszek+1, {component[1], component[6], component[2], component[3]})
										end
									end 
								end
							end
						end
					end
				end, 100, 0)
		end

		if col then 
			jelenlegiCol = col 
		else 
			jelenlegiCol = false 
		end
	end 
)

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

function hasComponent(vehicle, component)
	for value in pairs(getVehicleComponents(vehicle)) do
		if value == component then
			return true
		end
	end
	return false
end
