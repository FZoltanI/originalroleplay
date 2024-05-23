--
-- c_flashlight.lua
--

local flashLiTable = {flModel={}, shLight={}, shLiBul={}, shLiRay={}, isFlon={} ,isFLen={}, fLInID={} }
local isLightOn = false

---------------------------------------------------------------------------------------------------
-- flashlight settings
---------------------------------------------------------------------------------------------------
local disableFLTex = false -- true=makes the flashlight body not visible (useful for alter attach)
-- light settings for other players
local gLightTheta = math.rad(6) -- Theta is the inner cone angle
local gLightPhi = math.rad(18) -- Phi is the outer cone angle
local gLightFalloff = 1.5 -- light intensity attenuation between the phi and theta areas
local gAttenuation = 25 -- light attenuation (max radius)
-- light settings for localPlayer
local gLocLightTheta = math.rad(6) -- Theta is the inner cone angle
local gLocLightPhi = math.rad(45) -- Phi is the outer cone angle
local gLocLightFalloff = 1.5 -- light intensity attenuation between the phi and theta areas
local gLocAttenuation = 50 -- light attenuation (max radius)
-- for all
local gWorldSelfShadow = false -- enables object self shadowing
local gLightColor = {0.9,0.9,0.65,1.0} -- rgba color of the projected light, light rays and the lightbulb

local theTikGap = 0.5 -- here you set how many seconds to wait after switching the flashlight on/off
local flTimerUpdate = 200 -- the effect update time interval 

local getLastTack = getTickCount ( )-(theTikGap*1000)
local shTeNul = dxCreateShader ( "fx/shader_null.fx",0,0,false )

---------------------------------------------------------------------------------------------------
-- update the existing lights
---------------------------------------------------------------------------------------------------
addEventHandler("onClientPreRender", root, function()
	for index,this in ipairs(getElementsByType("player")) do
		if flashLiTable.shLight[this] then
			local x1, y1, z1 = getPedBonePosition ( this, 24 )
			local lx1, ly1, lz1 = getPedBonePosition ( this, 25 )
			exports.dynamic_lighting:setLightDirection(flashLiTable.shLight[this],lx1-x1,ly1-y1,lz1-z1,false)
			exports.dynamic_lighting:setLightPosition(flashLiTable.shLight[this],x1,y1,z1)	
		end
	end
end
)

---------------------------------------------------------------------------------------------------
-- create/destroy the effects for flashlight model
---------------------------------------------------------------------------------------------------
function createFlashlightModel(thisPed)
	if not flashLiTable.flModel[thisPed] then	
		flashLiTable.flModel[thisPed] = createObject(globalLightSettings.FLobjID,0,0,0,0,0,0,true)
		if disableFLTex and shTeNul then
			engineApplyShaderToWorldTexture ( shTeNul, "flashlight_COLOR", flashLiTable.flModel[thisPed] )	
			engineApplyShaderToWorldTexture ( shTeNul, "flashlight_L", flashLiTable.flModel[thisPed] )	
		end
		setElementAlpha(flashLiTable.flModel[thisPed],254)
		exports.bone_attach:attachElementToBone(flashLiTable.flModel[thisPed],thisPed,12,0,0.015,0.2,0,0,0)
	end
end

function destroyFlashlightModel(thisPed)
	if flashLiTable.flModel[thisPed] then			
		exports.bone_attach:detachElementFromBone(flashLiTable.flModel[thisPed])
		if disableFLTex and shTeNul then
			engineRemoveShaderFromWorldTexture ( shTeNul, "*", flashLiTable.flModel[thisPed] )
		end
		destroyElement(flashLiTable.flModel[thisPed])
		flashLiTable.flModel[thisPed]=nil
	end
end

---------------------------------------------------------------------------------------------------
-- Creates / destroys  spot light
---------------------------------------------------------------------------------------------------
function createWorldLight(thisPed)
	if flashLiTable.shLight[thisPed] or ((isSynced==false) and (thisPed~=localPlayer)) then return end
	if (thisPed~=localPlayer) then
		flashLiTable.shLight[thisPed] = exports.dynamic_lighting:createSpotLight(0,0,3,gLightColor[1],gLightColor[2],gLightColor[3],gLightColor[4],0,0,0,flase,gLightFalloff,gLightTheta,gLightPhi,gAttenuation,gWorldSelfShadow)
	else
		flashLiTable.shLight[thisPed] = exports.dynamic_lighting:createSpotLight(0,0,3,gLightColor[1],gLightColor[2],gLightColor[3],gLightColor[4],0,0,0,flase,gLocLightFalloff,gLocLightTheta,gLocLightPhi,gLocAttenuation,gWorldSelfShadow)
	end
end

function destroyWorldLight(thisPed)
	if flashLiTable.shLight[thisPed] then
		flashLiTable.shLight[thisPed] = not exports.dynamic_lighting:destroyLight(flashLiTable.shLight[thisPed])
	end
end

---------------------------------------------------------------------------------------------------
-- Creates / destroys  light bulb and rays effects
---------------------------------------------------------------------------------------------------
function createFlashLightShader(thisPed)
	if not flashLiTable.flModel[thisPed] then return false end
	if not flashLiTable.shLiBul[thisPed] or flashLiTable.shLiRay[thisPed] then
		flashLiTable.shLiBul[thisPed]=dxCreateShader("fx/shader_lightBulb.fx",1,0,false)
		flashLiTable.shLiRay[thisPed]=dxCreateShader("fx/shader_lightRays.fx",1,0,true)
		if not flashLiTable.shLiBul[thisPed] or not flashLiTable.shLiRay[thisPed] then
			return
		end		
		engineApplyShaderToWorldTexture(flashLiTable.shLiBul[thisPed],"flashlight_L", flashLiTable.flModel[thisPed] )
		engineApplyShaderToWorldTexture(flashLiTable.shLiRay[thisPed], "flashlight_R", flashLiTable.flModel[thisPed] )	
		dxSetShaderValue (flashLiTable.shLiBul[thisPed],"gLightColor",gLightColor)
		dxSetShaderValue (flashLiTable.shLiRay[thisPed],"gLightColor",gLightColor)
	end
end

function destroyFlashLightShader(thisPed)
	if flashLiTable.shLiBul[thisPed] or flashLiTable.shLiRay[thisPed] then
		destroyElement(flashLiTable.shLiBul[thisPed])
		destroyElement(flashLiTable.shLiRay[thisPed])
		flashLiTable.shLiBul[thisPed]=nil
		flashLiTable.shLiRay[thisPed]=nil
	end
end

---------------------------------------------------------------------------------------------------
-- enabling and switching on the flashlight
---------------------------------------------------------------------------------------------------
function playSwitchSound(thisPed)
	pos_x,pos_y,pos_z=getElementPosition (thisPed)
	local flSound = playSound3D("snd/switch.wav", pos_x, pos_y, pos_z, false) 
	setSoundMaxDistance(flSound,40)
	setSoundVolume(flSound,0.6)
end

function flashLightEnable(isEN,thisPed)
if isEN==true then
		flashLiTable.isFLen[thisPed]=isEN	
	else
		flashLiTable.isFLen[thisPed]=isEN	
	end
end

function flashLightSwitch(isON,thisPed)
if isElementStreamedIn(thisPed) and flashLiTable.isFLen[thisPed] then  playSwitchSound(thisPed) end
if isON then
		flashLiTable.isFlon[thisPed]=true
	else
		flashLiTable.isFlon[thisPed]=false
	end
end


function whenPlayerQuits(thisPed)
	destroyWorldLight(thisPed) 
	destroyFlashlightModel(thisPed) 
	destroyFlashLightShader(thisPed)  
end

---------------------------------------------------------------------------------------------------
-- streaming in/out the flashlight model
---------------------------------------------------------------------------------------------------
addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), function()
	if FLenTimer then return end
	FLenTimer = setTimer(	function()
		for index,thisPed in ipairs(getElementsByType("player")) do
			if flashLiTable.fLInID[thisPed]==nil then flashLiTable.fLInID[thisPed]=0 end
			if isElementStreamedIn(thisPed) and flashLiTable.isFLen[thisPed]==true and flashLiTable.fLInID[thisPed]~=getElementInterior(thisPed) then
			triggerServerEvent("onPlayerGetInter", resourceRoot, thisPed)
		end
		if  isElementStreamedIn(thisPed) and not flashLiTable.flModel[thisPed] and flashLiTable.isFLen[thisPed]==true then
			createFlashlightModel(thisPed)
			if flashLiTable.fLInID[thisPed]~=nil then setElementInterior ( flashLiTable.flModel[thisPed], flashLiTable.fLInID[thisPed]) end
			end
		if  isElementStreamedIn(thisPed) and flashLiTable.flModel[thisPed] and flashLiTable.isFLen[thisPed]==false then
			destroyFlashlightModel(thisPed)
			end
		if isElementStreamedIn(thisPed) and not flashLiTable.shLiRay[thisPed] and flashLiTable.isFlon[thisPed]==true then 
			createFlashLightShader(thisPed) 
			createWorldLight(thisPed)
			end
		if (isElementStreamedIn(thisPed) or not isElementStreamedIn(thisPed)) and flashLiTable.shLiRay[thisPed] and flashLiTable.isFlon[thisPed]==false then 
			destroyFlashLightShader(thisPed) 
			destroyWorldLight(thisPed)			
			end
		end
	end
	,flTimerUpdate,0 )
end
)

function getPlayerInteriorFromServer(thisPed,interiorID)
	if flashLiTable.flModel[thisPed] then
		flashLiTable.fLInID[thisPed]=interiorID
		if flashLiTable.flModel[thisPed] then setElementInterior ( flashLiTable.flModel[thisPed], flashLiTable.fLInID[thisPed]) end
	end
end

---------------------------------------------------------------------------------------------------
-- switching on / off the flashlight
---------------------------------------------------------------------------------------------------
addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == localPlayer then
			if isLightOn then
				isLightOn = false
				triggerServerEvent("onSwitchLight", resourceRoot, isLightOn)
				switchFlashLight( isLightOn )
				triggerEvent("switchFlashLight", root, isLightOn) -- remains for gravity_gun_plus
			end
        end
    end
)

function toggleLight()
	if getPedOccupiedVehicle(localPlayer) then return end
	if (getTickCount ( ) - getLastTack < theTikGap*1000) then outputChatBox('FlashLight: Wait '..theTikGap..' seconds.',255,0,0) return end
	isLightOn = not isLightOn
	triggerServerEvent("onSwitchLight", resourceRoot, isLightOn) -- remains for gravity_gun_plus
	switchFlashLight( isLightOn )
	triggerEvent("switchFlashLight", root, isLightOn)
	getLastTack = getTickCount ( )
end

function toggleFlashLight()
if flashLiTable.flModel[localPlayer] then 
	outputChatBox('You have disabled the flashlight',0,255,0)
	triggerServerEvent("onSwitchLight", resourceRoot, false)
	triggerServerEvent("onSwitchFLEffect", resourceRoot, false)
	isLightOn = false
	unbindKey(globalLightSettings.switch_key,"down",toggleLight)
else
	outputChatBox('You have enabled the flashlight',0,255,0)
	triggerServerEvent("onSwitchLight", resourceRoot, false)
	triggerServerEvent("onSwitchFLEffect", resourceRoot, true)
	bindKey(globalLightSettings.switch_key,"down",toggleLight)
	end
end

---------------------------------------------------------------------------------------------------
-- events
---------------------------------------------------------------------------------------------------
addEventHandler("onClientResourceStop", getResourceRootElement( getThisResource()), function()
	for index,this in ipairs(getElementsByType("player")) do
		if flashLiTable.shLight[this] then
			destroyWorldLight(this)
		end
	end
end
)

addEvent( "flashOnPlayerEnable", true )
addEvent( "flashOnPlayerQuit", true )
addEvent( "flashOnPlayerSwitch", true )
addEvent( "flashOnPlayerInter", true)
addEventHandler( "flashOnPlayerQuit", resourceRoot, whenPlayerQuits)
addEventHandler( "flashOnPlayerSwitch", resourceRoot, flashLightSwitch)
addEventHandler( "flashOnPlayerEnable", resourceRoot, flashLightEnable)
addEventHandler( "flashOnPlayerInter", resourceRoot, getPlayerInteriorFromServer)
