--
-- c_nightmod.lua
--

-- lod texture list (for lod effects)
local reapplyList = {					
						"royaleroof01_64","flmngo05_256","flmngo04_256",
						"casinolights6lit3_256","*_lod","*lod","lod*",
						"wslod*","*_lod*","smokelod*","particleskid",
						"downtown1","road_junction","road_junction2","buglod1",
						"asjmsfse*","yetanotherlodsfe1","yetanotherlodsfe2",
						"yetmorelods*","asfnsjm9z*","whitebuildsfselong","whiterlodsfse",
						"greybrnlodsfse","firehsesfse01","firehsesfse02","beigebitlodsfse",
						"bluebuildsfse","greybrnlodsfse",
						"p69_again","tempgrasslod*","sfse_carshwrm*","stadiumsfse","car_shiplod*",
						"whitebuildsfse","cunte_roadwideside","chatshade02_law",
						"pinkylodsfse","golfcourselod_sfs_a","golfcourselod_sfs_b","flashlight_color",
						"striproadlod*","vgssnewshop04","vegguardhse01","vgnbarb1_256na","casinolights5_256n","ws_rooftarmaclod",
						"vgngewall2_128","gatebuildlod*","actopblank_128","vgnwrehselod*","vgwxrefhse*","xrefhselod*",
						"bikeschlod*","lan2lodbuild*","lanlodbuild*","sjmlas1lod*","sjmlas2lod*","sjmlod*","*_bridgroad",
						"laxrf_rdwarhus","laxrf_rdwarhusbig","laxrf_dckcanpy",
						"las2_block*","las1_block*","las_block*","laxrf_rbigcrate_las","lanlodplaza*",
						"sjmlaelod*","sllaelod*",
						"cxrf_refchim*","lod_pylon1","las2_drum1","las2_refinery",
						"las2_dukwal1","las2_redwal1","las2_dokwal","las2_greygrnd","las2_concnw","sjmmexref",
						"lanloddrygrss*","lan2lodplaza*","colinaslaelod*","sl_laelodbuild*","rocklaelod*",
						"lanlod*","lan2lod*","*_lawlod*","*roadlod*","ce_hillhouse*","snpedtest1x2","whitebuildwind64",
						"*lod_law*","beachlod*","redbridge128",
						"malllawn*","talllod01_*","pinkhoose","gasstopwall1_256lit","pavroadx2pav","2laneverge","2lanewhiteline",
						"hardon_*","lansjmlod*","sl_laefreeway1","donut1_lawn","yellowbildlodlawn","lawnlodwhite","holywdgblod*",
						"las2_rails1","las2_bakaly","las2_wall*","las2_xing","greenshade4_64","carsplash_02","splash_up"
						--"des_dirt1","bow_sub_walltiles" -- should apply to original blokwall
					}

-- list of the textures like grass etc
local grassApplyList = { "tx*","newaterfal1_256","water*","*smoke","smokeii_*","boatwake*","gensplash","coronaringa","flashlight_L" }
						
-- list of the world textures that will be disabled 
local clearList = { "sl_dtwinlights*","nitwin01_la","sfnite*","vgsn_nl_strip","vehicleshatter*","vehiclescratch64",
					"blueshade*","coronastar*","shad_exp"}
						
-- shader effects
function globalToTextureShaderCreate()
	wrdNightShader  = dxCreateShader ( "fx/shader_night_world.fx", 2, 0, false, "world,vehicle,object,other" )	
	nonAlphaShader  = dxCreateShader ( "fx/shader_night_other.fx", 2, 0, false, "world,object,other" )
	graNightShader  = dxCreateShader ( "fx/shader_night_grass.fx", 0, 0, false, "world,object" )
	vehClearShader = dxCreateShader ( "fx/shader_null.fx", 2, 0, false, "vehicle,world" )

	local isCreated = wrdNightShader  and nonAlphaShader and vehClearShader and graNightShader
	if isCreated then

			engineApplyShaderToWorldTexture ( nonAlphaShader, "unnamed" )

			for _,applyMatch in ipairs(grassApplyList) do
				engineApplyShaderToWorldTexture ( graNightShader, applyMatch )	
			end
			
			for _,applyMatch in ipairs(clearList) do
				engineApplyShaderToWorldTexture ( vehClearShader, applyMatch )	
			end
			
			for _,applyMatch in ipairs(reapplyList) do
				engineApplyShaderToWorldTexture ( wrdNightShader, applyMatch )	
			end
			return true
		else
			return false
		end
end

function setNightSpot(isTrue,posX,posY,posZ,radius)
	if wrdNightShader and nonAlphaShader and graNightShader then
		dxSetShaderValue( wrdNightShader,"gNightSpotEnable", isTrue )
		dxSetShaderValue( wrdNightShader,"gNightSpotPosition", posX, posY, posZ )
		dxSetShaderValue( wrdNightShader,"gNightSpotRadius", radius )
		dxSetShaderValue( nonAlphaShader,"gNightSpotEnable", isTrue )
		dxSetShaderValue( nonAlphaShader,"gNightSpotPosition", posX, posY, posZ )
		dxSetShaderValue( nonAlphaShader,"gNightSpotRadius", radius )
		dxSetShaderValue( graNightShader,"gNightSpotEnable", isTrue )
		dxSetShaderValue( graNightShader,"gNightSpotPosition", posX, posY, posZ )
		dxSetShaderValue( graNightShader,"gNightSpotRadius", radius )   
		exports.dynamic_lighting:setNightSpotRadius(radius)     
		exports.dynamic_lighting:setNightSpotPosition(posX, posY, posZ)		
	end
end

-------------------------------------------------------------------------------
-- Manage time
-------------------------------------------------------------------------------
-- do not touch
local tempVis = 0.0
local addVis = 0.0

function startRenderTime()
	if renderTimeTimer then return end
	renderTimeTimer = setTimer( function()
		local hour, minute, second = getTimeHMS()

		if hour < 6 then dawn_aspect=0 end 
		if hour <= 6 and hour >= 5 then dawn_aspect =(((hour - 5) * 60 + minute + (second / 60))) / 120 end
		if hour > 6 and hour < 20 then dawn_aspect =1 end
		if hour>=20  then dawn_aspect = -6 * ((((hour - 20) * 60) + minute + (second / 60)) / 1440) + 1 end

		local outValue = math.min(dawn_aspect + tempVis + globalLightSettings.standardAdd, 1)  -- 0.1
		local gbrightness = math.min(dawn_aspect + 0.05 + tempVis + globalLightSettings.standardAdd, 1) -- 0.15
		--dxDrawText( outValue, 200, 220 )
		exports.dynamic_lighting:setShaderDayTime(outValue)
		exports.dynamic_lighting:setTextureBrightness(gbrightness)
		exports.dynamic_lighting:setDiffLightColor(addVis,addVis,addVis,addVis * math.max(0,1 - dawn_aspect))		
		dxSetShaderValue( wrdNightShader,"gDayTime", outValue)
		dxSetShaderValue( wrdNightShader,"gBrightness", gbrightness)
		dxSetShaderValue( nonAlphaShader,"gDayTime", outValue)
		dxSetShaderValue( nonAlphaShader,"gBrightness", gbrightness)
		dxSetShaderValue( graNightShader,"gDayTime", outValue)
		dxSetShaderValue( graNightShader,"gBrightness", gbrightness)
		
	end ,100,0)
end

function stopRenderTime()
	if not renderTimeTimer then return end
	killTimer(renderTimeTimer)
	renderTimeTimer = nil
end

-------------------------------------------------------------------------------
-- Manage night vision, flashlight and vehicle lights brightness alteration
-------------------------------------------------------------------------------
-- do not touch
local isGoogleOn = false
local isFlashlightOn = false
local isCarlightOn = false

function startNightVision()
	nightVisionTimer = setTimer( function()
		if isPedDoingTask ( getLocalPlayer (), "TASK_SIMPLE_GOGGLES_ON" ) and not isGoogleOn then
			isGoogleOn = true
			setTimer( function()
				triggerEvent( "switchGoogleNM",resourceRoot,isGoogleOn)
				addVis = globalLightSettings.nightVisionAdd
			end ,1000,1)
		end
		if isPedDoingTask ( getLocalPlayer (), "TASK_SIMPLE_GOGGLES_OFF" ) and isGoogleOn then
			isGoogleOn = false
			setTimer( function()
				triggerEvent( "switchGoogleNM",resourceRoot,isGoogleOn)
				if isFlashlightOn or isCarlightOn then
					addVis = globalLightSettings.carlightAdd
				else
					addVis = 0
				end
			end ,800,1)
		end	
	end ,100,0)
end	

function stopNightVision()
	if isTimer(nightVisionTimer) then 
		killTimer(nightVisionTimer)
		nightVisionTimer=nil
	end
end

function switchFlashLight( cpOn )
	if isGoogleOn or isCarlightOn then 
		isFlashlightOn = cpOn
		return 
	end	
	if cpOn then
		isFlashlightOn = true
		addVis = globalLightSettings.carlightAdd
	else
		if not isCarlightOn then
			addVis = 0
		end
		isFlashlightOn = false
	end
end

addEventHandler("onClientPlayerVehicleEnter",getRootElement(),function()
	local theVehicle = getPedOccupiedVehicle(source)
	if not isElement(theVehicle) then return end
	vehVisionTimer = setTimer( function()
		local hour, minutes = getTime()
		if isGoogleOn then
			isCarlightOn = true
			addVis = globalLightSettings.nightVisionAdd
		elseif ((getVehicleLightState ( theVehicle, 1 )==0 or getVehicleLightState ( theVehicle, 0 )==0) and getVehicleOverrideLights(theVehicle)==2) then
			isCarlightOn = true
			addVis = globalLightSettings.carlightAdd
		elseif ((getVehicleLightState ( theVehicle, 1 )==0 or getVehicleLightState ( theVehicle, 0 )==0) and (hour>=22 or hour<=5) 
				and getVehicleOverrideLights(theVehicle)==0) then
			isCarlightOn = true
			addVis = globalLightSettings.carlightAdd
		elseif isFlashlightOn then
			addVis = globalLightSettings.carlightAdd			
			isCarlightOn = true
		else 
			isCarlightOn = false
			addVis = 0			
		end
		triggerEvent( "switchCarLightNM",resourceRoot,isCarlightOn)
	end ,500,0)	
end
)

addEventHandler("onClientPlayerVehicleExit",getRootElement(),function()
	if isTimer(vehVisionTimer) then 
		killTimer(vehVisionTimer) 
		vehVisionTimer=nil 
	end
	if isFlashlightOn then
		addVis = globalLightSettings.carlightAdd
	elseif isGoogleOn then
		addVis = globalLightSettings.nightVisionAdd
	else
		addVis = 0	
	end
	isCarlightOn = false
	triggerEvent( "switchCarLightNM",resourceRoot,isCarlightOn)
end
)

----------------------------------------------------------------
-- getTimeHMS
--		Returns game time including seconds
----------------------------------------------------------------
local timeHMS = {0,0,0}
local minuteStartTickCount
local minuteEndTickCount

function getTimeHMS()
	return unpack(timeHMS)
end

addEventHandler( "onClientRender", root,
	function ()
		--if not bEffectEnabled then return end
		local h, m = getTime ()
		local s = 0
		if m ~= timeHMS[2] then
			minuteStartTickCount = getTickCount ()
			local gameSpeed = math.clamp( 0.01, getGameSpeed(), 10 )
			minuteEndTickCount = minuteStartTickCount + 1000 / gameSpeed
		end
		if minuteStartTickCount then
			local minFraction = math.unlerpclamped( minuteStartTickCount, getTickCount(), minuteEndTickCount )
			s = math.min ( 59, math.floor ( minFraction * 60 ) )
		end
		timeHMS = {h, m, s}
		--dxDrawText( string.format("%02d:%02d:%02d",h,m,s), 200, 200 )
	end
)

----------------------------------------------------------------
-- Math helper functions
----------------------------------------------------------------
function math.lerp(from,alpha,to)
    return from + (to-from) * alpha
end

function math.unlerp(from,pos,to)
	if ( to == from ) then
		return 1
	end
	return ( pos - from ) / ( to - from )
end

function math.clamp(low,value,high)
    return math.max(low,math.min(value,high))
end

function math.unlerpclamped(from,pos,to)
	return math.clamp(0,math.unlerp(from,pos,to),1)
end
