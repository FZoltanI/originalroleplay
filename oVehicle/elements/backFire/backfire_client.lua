
local fxShowValTest = false
local curEngine = 0

local vehicleBackFirePosition = {
	[506] = {
		{0.08, -2.3, -0.2},
		{-0.02, -2.3, -0.2},
	},
}


function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

function getVectors(x, y, z, x2, y2, z2)
	return x - x2, y - y2, z-z2;
end

function createBackFire(theVeh)
	if isElementStreamedIn(theVeh) then
		if vehicleBackFirePosition[getElementModel(theVeh)] then 
		--	local offset = 2
			for k,v in pairs(vehicleBackFirePosition[theVeh.model]) do
				local ox, oy, oz = unpack(v)
				--outputChatBox(ox)
				local matrix = theVeh.matrix
				local position = matrix:transformPosition(Vector3(ox, oy, oz))
				fxAddGunshot(position.x, position.y, position.z, (theVeh.position.x - position.x) * -1, (theVeh.position.y - position.y) * -1, 0, true)
				--fxAddGunshot(position.x + offset, position.y, position.z, (theVeh.position.x - position.x) * -1, (theVeh.position.y - position.y) * -1, 0, true)
			end
			local s = playSound3D("elements/backFire/sound/backfire2.wav", x,y,z, false)
			setSoundMaxDistance( s, 80 )	
			setSoundVolume(s, 0.5)
		else 
			local model = getElementModel(theVeh) 

			if model == 546 or model == 496 then
				return 
			end
			--[[local fireChords={}
			local dist = 0.04
			for i = 1, 6 do
				local x, y, z = getPositionFromElementOffset(theVeh,scx,scy-dist,scz)
				fireChords[i]= {pX = x, pY = y, pZ = z}
				dist = dist + 0.2
			end
			local x,y,z = getPositionFromElementOffset(theVeh,scx,scy,scz)
			local x2,y2,z2 = getPositionFromElementOffset(theVeh,scx,0,scz)
			local v1, v2, v3 = getVectors(x,y,z, x2,y2,z2)
			for i, val in ipairs(fireChords) do

				fxAddGunshot(val.pX,val.pY,val.pZ, v1-1.5,v2,v3, true)
				fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2,v3+0.8, true)
				fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2,v3-0.8, true)
				fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+1,v3+0.8, true)
				fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+2,v3+0.8, true)
				fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+10,v3+0.8, true)
				fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-10,v3+0.8, true)
				fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-2,v3+0.8, true)
				fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-1,v3+0.8, true)
			end]]
			local ox, oy, oz = getVehicleComponentPosition(theVeh, "exhaust_ok")
			local matrix = theVeh.matrix

			if ox and oy and oz then
				local position = matrix:transformPosition(Vector3(ox, oy - 1, oz))
				fxAddGunshot(position.x, position.y, position.z, (theVeh.position.x - position.x) * -1, (theVeh.position.y - position.y) * -1, 0, true)
			end

			local x, y, z = getElementPosition(theVeh)
			local s = playSound3D("elements/backFire/sound/backfire2.wav", x,y,z, false)
			setSoundMaxDistance( s, 80 )	
			setSoundVolume(s, 0.5)
		end
		
		--[[local fireChords={}
		local dist = 0.04
		for i = 1, 6 do
			local x, y, z = getPositionFromElementOffset(theVeh,scx,scy-dist,scz)
			fireChords[i]= {pX = x, pY = y, pZ = z}
			dist = dist + 0.2
		end
		local x,y,z = getPositionFromElementOffset(theVeh,scx,scy,scz)
		local x2,y2,z2 = getPositionFromElementOffset(theVeh,scx,0,scz)
		local v1, v2, v3 = getVectors(x,y,z, x2,y2,z2)
		for i, val in ipairs(fireChords) do

			fxAddGunshot(val.pX,val.pY,val.pZ, v1-1.5,v2,v3, true)
			fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2,v3+0.8, true)
			fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2,v3-0.8, true)
			fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+1,v3+0.8, true)
			fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+2,v3+0.8, true)
			fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+10,v3+0.8, true)
			fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-10,v3+0.8, true)
			fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-2,v3+0.8, true)
			fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-1,v3+0.8, true)
		end
		local s = playSound3D("elements/backFire/sound/backfire2.wav", x,y,z, false)
		setSoundMaxDistance( s, 80 )	
		setSoundVolume(s, 0.5)]]--	
	end
end

--[[addCommandHandler("bf",function()
	createBackFire(getPedOccupiedVehicle(localPlayer))
end)]]

function chandeMonitoringState(state,veh)
	if (state) then
		theVehicle = veh
		addEventHandler ( "onClientPreRender", root, monitorCurEngine )
	else
		removeEventHandler ( "onClientPreRender", root, monitorCurEngine )
		theVehicle=nil
		theTestVehicle=nil
	end
end
addEvent ( "chandeMonitoringState", true )
addEventHandler ( "chandeMonitoringState", getRootElement(), chandeMonitoringState)



local step = 0.2
function playerPressedKey(button, press)
	if button == "arrow_u" or button == "arrow_d" or button == "arrow_r" or button == "arrow_l" then
		local curstep = step
		if (press) then
			if getKeyState( "lalt" ) == true or getKeyState( "ralt" ) == true then curstep=step/2 end
			if button == "arrow_u" then
				if getKeyState( "lctrl" ) == true or getKeyState( "rctrl" ) == true then
					tpy = tpy+curstep
				else
					tpz = tpz+curstep
				end
			elseif button == "arrow_d" then
				if getKeyState( "lctrl" ) == true or getKeyState( "rctrl" ) == true then
					tpy = tpy-curstep
				else
					tpz = tpz-curstep
				end
			elseif button == "arrow_l" then
				tpx = tpx-curstep
			elseif button == "arrow_r" then
				tpx = tpx+curstep
			end
			--outputChatBox("x= "..tostring(tpx).." y= "..tostring(tpy).." z= "..tostring(tpz), 255,255,0)
		end
	end
end



local refreshTime = 50 --ms
local aLastCheck = 0

function monitorCurEngine()
	if ( getTickCount() >= aLastCheck ) then
		if isElement(theVehicle) then
			local cur = tonumber(getVehicleCurrentGear (theVehicle))
			local engineTunings = getElementData(theVehicle, "veh:engineTunings") 
			if ( cur ~= curEngine ) and (engineTunings) then
				for k,v in pairs(engineTunings) do
					--outputChatBox(v)
					if (v == 'engine-4') then
						if (tonumber(getElementSpeed(theVehicle, "kph")) > 1 ) then
							triggerServerEvent ( "create3DBackfireSound", root, theVehicle)
							curEngine = cur
						end
					end
				end
			end
			aLastCheck = getTickCount() + refreshTime
		end
	end
end

addEvent ( "create3DBackfireSoundClient", true )
addEventHandler ( "create3DBackfireSoundClient", getRootElement(), createBackFire)

