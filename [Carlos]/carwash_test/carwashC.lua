local sx, sy = guiGetScreenSize()

local carwashMarkers = {}

local currentWashVehicle = nil

local carwashState = 1
local lastClick = 0

function createCarwashes()
	for k, v in pairs(carwashes) do
		if v[5] then
			local carwashGarage = createObject(12943, v[1], v[2], v[3]-1, 0, 0, v[4]+90, false)
			local carwashInterior = createObject(12942, v[1], v[2], v[3]-1, 0, 0, v[4]+90, false)
			local carwashBrush = createObject(7311, v[1], v[2], v[3]+1, 0, 0, v[4]+90, false)
			setElementCollisionsEnabled(carwashBrush, false)
		end
		local marker = createMarker(v[1], v[2], v[3]-1, "cylinder", 3, 0, 180, 255, 50)
		carwashMarkers[marker] = true
		--local carwashBlip = createBlip(v[1], v[2], v[3], 55, 1, 255, 255, 255, 255, 0, 100)
	end
	
	addEventHandler("onClientMarkerHit", root, triggerCarwash)
	addEventHandler("onClientMarkerLeave", root,
		function()
			if carwashMarkers[source] then
				removeEventHandler("onClientRender", root, renderStates)
			end
		end
	)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), createCarwashes)

function triggerCarwash(hitElement, matchingDimension)
	if carwashMarkers[source] then
		if (getElementType(hitElement) == "player") then
			--removeEventHandler("onClientRender", root, renderStates)
			local vehicle = getPedOccupiedVehicle(hitElement)
			if (vehicle) then
				local driver = getVehicleOccupant(vehicle)
				if driver == hitElement then
					currentWashVehicle = vehicle
					local dirtLevel = getVehicleDirtLevel(currentWashVehicle)
					if dirtLevel <= 1 then
						outputChatBox("#ffb428[ATTENTION] #FFFFFFYour vehicle is already clean! #ffb428Are you sure you want to wash it?", 255,255,255,true)
					end
					addEventHandler("onClientRender", root, renderStates)
				end
			end
		end
	end
end

function washVehicle(vehicle)
	local vehX, vehY, vehZ = getElementPosition(vehicle)
	for P=-1,1 do
		for Q=-1,1 do
			fxAddWaterHydrant(vehX+P, vehY-Q, vehZ-4)
			setTimer(function()
				setTimer(function()
					fxAddWaterSplash(vehX+P, vehY-Q, vehZ)
				end, 500, 5)
			end, 10000, 1)
		end
	end
	setElementFrozen(vehicle, true)
	setTimer(function()
		triggerServerEvent("setVehicleGrungeServer", vehicle, vehicle, 1)
		setTimer(function()
			setElementFrozen(vehicle, false)
		end, 6000, 1)
	end, 5000, 1)
end

function renderStates()
	if carwashState == 1 then
		local scX, scY = getScreenFromWorldPosition(getElementPosition(currentWashVehicle))
		if scX and scY then
			-- Replace with some drawing function if you want, I used my custom export function here
		end
		
		if getKeyState("E") and lastClick+500 <= getTickCount() then
			lastClick = getTickCount()
			carwashState = 2
		end
	elseif carwashState == 2 then
		if lastClick+1000 <= getTickCount() then
			washVehicle(currentWashVehicle)
			removeEventHandler("onClientRender", root, renderStates)
			carwashState = 1
		end
	end
end




--[[
local smoothMoveEXP = 0
local expWidth, expHeight = 300, 20
local expX, expY = sx/2 - expWidth/2, sy/2

addEventHandler("onClientRender", root, function()
	local actualHP = getElementHealth(localPlayer)
	local progress = ( actualHP/100 ) * expWidth
	
	if smoothMoveEXP > progress then
		smoothMoveEXP = smoothMoveEXP - 5
	end
	if smoothMoveEXP < progress then
		smoothMoveEXP = smoothMoveEXP + 5
	end

	dxDrawRectangle(expX, expY, expWidth, expHeight, tocolor(0, 0, 0, 255/100*65))
	if actualHP == 0 then else
		dxDrawRectangle(expX+1, expY + 1, smoothMoveEXP, 18, tocolor(214, 63, 62, 255))
		dxDrawRectangle(expX+1, expY + 1, smoothMoveEXP, 1, tocolor(214, 63, 62, 255))
	end
	dxDrawText(actualHP.." HP", expX + 1, expY +4, expWidth-2 + expX + 1, 20 + expY - 20, tocolor(255, 255, 255, 255/2), 1, "default", "center", "top", false, false, true, true)
end)
]]