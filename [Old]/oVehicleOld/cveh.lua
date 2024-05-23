local sx,sy = guiGetScreenSize(  )
local rel = ((sx/1920)+(sy/1080))/2

local cvehshowing = false
local clicked = false

function renderCvehPanel()
	exports.cl_blur:createBlur(0,0,sx,sy,150)

	--[[dxDrawRectangle(sx*0.45,sy*0.5,sx*0.1,sy*0.1)
	dxDrawRectangle(sx*0.45,sy*0.4,sx*0.1,sy*0.1)

	dxDrawRectangle(sx*0.425,sy*0.5,sx*0.1,sy*0.1)
	dxDrawRectangle(sx*0.425,sy*0.4,sx*0.1,sy*0.1)
	dxDrawRectangle(sx*0.425,sy*0.6,sx*0.125,sy*0.1,tocolor(255,0,255))

	dxDrawRectangle(sx*0.425,sy*0.23,sx*0.125,sy*0.1,tocolor(255,0,255))]]
end

addCommandHandler("cveh",
	function()
		local pveh = getPedOccupiedVehicle(localPlayer)

		if pveh then 
			if getPedOccupiedVehicleSeat(localPlayer) == 0 or getPedOccupiedVehicleSeat(localPlayer) == 1 then
				if cvehshowing then 
					exports.cl_preview:destroyObjectPreview(getElementData(localPlayer,"cveh:modelVeh"))
					destroyElement(getElementData(localPlayer,"cveh:modelVeh"))
					setElementData(localPlayer,"cveh:modelVeh",false)
					removeEventHandler("onClientRender",root,renderCvehPanel)
					cvehshowing = false
					toggleControl("enter_exit",true)
				else

					local cvehVehicle = createVehicle(getElementModel(pveh),0,0,0)
					local cR,cG,cB = getVehicleColor(pveh,true)
					setVehicleColor(cvehVehicle,cR,cG,cB)
					setElementData(localPlayer,"cveh:modelVeh",cvehVehicle)
					exports.cl_preview:createObjectPreview(cvehVehicle, 270, 0, 180, sx*0.335,sy*0.2, 600*rel, 650*rel, false, true)
					addEventHandler("onClientRender",root,renderCvehPanel)
					cvehshowing = true
					toggleControl("enter_exit",false)
				end
			end
		end
	end 
)

local components_state = {
	[0] = false,
	[1] = false,
	[2] = false,
	[3] = false,
	[4] = false,
	[5] = false,
}

addEventHandler("onClientKey",root,
	function(key,state)
		if key == "mouse1" and state and cvehshowing then 
			if not clicked then 
				local clickedComponent = false
				if isInSlot(sx*0.45,sy*0.5,sx*0.1,sy*0.1) then 
					clickedComponent = 2--"door_lf_dummy"
				elseif isInSlot(sx*0.45,sy*0.4,sx*0.1,sy*0.1) then 
					clickedComponent = 4--"door_lr_dummy"
				elseif isInSlot(sx*0.4,sy*0.5,sx*0.1,sy*0.1) then 
					clickedComponent = 3--"door_rf_dummy"
				elseif isInSlot(sx*0.425,sy*0.4,sx*0.1,sy*0.1) then
					clickedComponent = 5--"door_rr_dummy"
				elseif isInSlot(sx*0.425,sy*0.6,sx*0.125,sy*0.1) then 
					clickedComponent = 0--"bonnet_dummy"
				elseif isInSlot(sx*0.425,sy*0.23,sx*0.125,sy*0.1) then 
					clickedComponent = 1--"boot_dummy"
				end

				if clickedComponent then 
					local vehicle = getElementData(localPlayer,"cveh:modelVeh")

					if components_state[clickedComponent] then 
						--setVehicleComponentRotation(vehicle,clickedComponent,0,0,0)
						setVehicleDoorOpenRatio(vehicle, clickedComponent, 2,400)
						components_state[clickedComponent] = false
						triggerServerEvent("setVehicleDoorsState",root,getPedOccupiedVehicle(localPlayer),clickedComponent,2)
					else
						setVehicleDoorOpenRatio(vehicle, clickedComponent, 0,400)
						components_state[clickedComponent] = true
						triggerServerEvent("setVehicleDoorsState",root,getPedOccupiedVehicle(localPlayer),clickedComponent,1)
					end
					clicked = true
					setTimer(function() clicked = false end, 400, 1)
				end
			else
				outputChatBox(exports.cl_core:getServerColor().."[classGaming - Doors]: #ffffffLassabban!",255,255,255,true) 
			end
		end
	end 
)

function isInSlot(x, y, w, h)
    if isCursorShowing( ) then
        local cx,cy = getCursorPosition(  )
        cx, cy = cx*sx, cy*sy
        if cx>=x and cx<=x+w and cy>=y and cy<=y+h then
            return true
        end
        return false
    else
        return false
    end
end