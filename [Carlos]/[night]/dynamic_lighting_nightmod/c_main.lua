------------------------------------------------------------------------------------------------------------------------------------------
-- Resource: Dynamic_lighting_NightMod v0.0.3 Alpha
-- Author: Ren712 
-- Contact: knoblauch700@o2.pl / Ren_712 on mtasa.com/forum
------------------------------------------------------------------------------------------------------------------------------------------
-- the rest of the settings in c_flashlight lua file

globalLightSettings = {
	autoEnableFL = false, -- true=the player gets the flashlight without writing commands
	switch_key = "r", -- define the key that switches the light effect
	FLobjID = 15060,  -- the object we are going to replace (interior building shadow in this case)
	enableNightSpot = true, -- uses night spot lights (from the table below)
	effectRange = 450, -- effect max range
	gDistFade = {250,220}, -- [0]MaxEffectFade,[1]MinEffectFade
	diffLight = { enabled = true, range = 70 }, -- this is a single diffuse light table (for stuff below)			
	-- diff light add
	nightVisionAdd = 0.35, -- Add to global brightness when using night vision
	carlightAdd = 0.12, -- Add to global brightness when in a vehicle or with flashlight
	standardAdd = 0.02, -- Add to global brightness 
}


local lightSpotTable = {
	{position = {-711, 957, 12.4}, interior = 0, radius = 80}, --ranch 
	{position = {2005, 1543, 13.5}, interior = 0, radius = 80}, --pirate
	{position = {2485, -1667, 13.3}, interior = 0, radius = 80}, --grove
	{position = {-2405, -598, 132.6}, interior = 0, radius = 100}, --hill
	{position = {214, 1861, 18}, interior = 0, radius = 130}, -- army
}

-------------------------------------------------------------------------------
-- Manage nightspots
-------------------------------------------------------------------------------
function sortedOutput(inTable, distFade, camInt)
	local outTable = {}
	for index,value in ipairs(inTable) do
		if value.interior == camInt then
			local dist = getElementFromCameraDistance(value.position[1],value.position[2],value.position[3])
			if dist <= distFade then 
				local w = #outTable + 1
				if not outTable[w] then 
					outTable[w] = {} 
				end
				outTable[w].position = value.position
				outTable[w].dist = dist
				outTable[w].radius = value.radius	
			end
		end
	end
		table.sort(outTable, function(a, b) return a.dist < b.dist end)
	return outTable
end

function getElementFromCameraDistance(hx,hy,hz)
	local cx,cy,cz,clx,cly,clz,crz,cfov = getCameraMatrix()
	local dist = getDistanceBetweenPoints3D(hx,hy,hz,cx,cy,cz)
	return dist
end

function startNightSpot()
	if nightSpotTimer then return end
	nightSpotTimer = setTimer( function()
		if not thisPos then 
			thisPos = {1,1,1}
			lastPos = {0,0,0}
			isLightPointEnabled = false 
		end
		local sortedTable = sortedOutput(lightSpotTable, globalLightSettings.effectRange, getCameraInterior())

		if #sortedTable > 0 then
			local thisPos = sortedTable[1].position
			local thisRad = sortedTable[1].radius
			if ((thisPos[1] ~= lastPos[1]) or (thisPos[2] ~= lastPos[2]) or (thisPos[3] ~= lastPos[3])) or not isLightPointEnabled then
				setNightSpot(true, thisPos[1], thisPos[2], thisPos[3], thisRad)
				isLightPointEnabled = true
				lastPos = thisPos
			end
		else
			if isLightPointEnabled then
				setNightSpot(false, 1, 1, 1, 0)
				isLightPointEnabled = false
			end
		end
	end ,100,0)
end

function stopNightSpot()
	if not nightSpotTimer then return end
	killTimer(nightSpotTimer)
	nightSpotTimer = nil
end

-------------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------------
addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
	outputChatBox('Resource: dynamic_lighting_nightMod v0.0.3 by Ren712',0,255,255)
	--nightmod stuff
	if not globalToTextureShaderCreate() then 
		outputChatBox('Could not start some things. Use debugscript 3')
		return false 
	end
	
	if globalLightSettings.enableNightSpot then
		exports.dynamic_lighting:setNightSpotEnable(true)
	end

	-- dynamic_lighting settings
	exports.dynamic_lighting:setLightsEffectRange(globalLightSettings.effectRange)
	exports.dynamic_lighting:setLightsDistFade(globalLightSettings.gDistFade[1], globalLightSettings.gDistFade[2])
	exports.dynamic_lighting:setShaderForcedOn(true)
	exports.dynamic_lighting:setShaderNightMod(true)
	exports.dynamic_lighting:setDiffLightEnable(globalLightSettings.diffLight.enabled)
	exports.dynamic_lighting:setDiffLightRange(globalLightSettings.diffLight.range)

	-- disable traffic lights
	setTrafficLightState(9)
	setTrafficLightsLocked ( true )
	
	-- weather stuff (you might want to change that)
	setWeather(0)
	setSunColor(0,0,0,0,0,0)
	
	-- start some internal stuff
	startRenderTime()
	startNightVision()
	if globalLightSettings.enableNightSpot then
		startNightSpot()
	end
	
	-- flashlight stuff
	engineImportTXD( engineLoadTXD( "obj/flashlight.txd" ), globalLightSettings.FLobjID ) 
	engineReplaceModel ( engineLoadDFF( "obj/flashlight.dff", 0 ), globalLightSettings.FLobjID,true)
	triggerServerEvent("onPlayerStartFLRes", resourceRoot)
	if globalLightSettings.autoEnableFL then 
		toggleFlashLight() 
	else
		outputChatBox('Type /flashlight to enable the flashlight ',255,255,0)
	end
	outputChatBox('Hit '..globalLightSettings.switch_key..' to turn on/off the flashlight',255,255,0)
	addCommandHandler("flashlight", toggleFlashLight)
end
)

addEventHandler("onClientResourceStop", getResourceRootElement( getThisResource()), function()
	--setNightSpot(false,1,1,1,0)
	--exports.dynamic_lighting:setLightsEffectRange(125)
	--exports.dynamic_lighting:setLightsDistFade(120, 100)
	--exports.dynamic_lighting:setShadersLayered(false,true,false)
	--exports.dynamic_lighting:setShaderForcedOn(false)
	--exports.dynamic_lighting:setShaderNightMod(false)
	--exports.dynamic_lighting:setDiffLightEnable(false)
	
	stopRenderTime()
	stopNightVision()
	if globalLightSettings.enableNightSpot then
		--exports.dynamic_lighting:setNightSpotEnable(false)
		stopNightSpot()
	end
	
	-- enable traffic lights
	setTrafficLightsLocked(false)
	
	resetSunColor()
end
)
