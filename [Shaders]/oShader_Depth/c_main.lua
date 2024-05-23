--
-- c_dof.lua
--
local orderPriority = "-2.7"	-- The lower this number, the later the effect is applied

Settings = {}
Settings.var = {}

---------------------------------
-- Settings for effect
---------------------------------
function setEffectVariables()
    local v = Settings.var
    -- Blur
    v.blurFactor = 0.95 -- blur ammount
    v.brightBlur = true -- should darker pixel get less blur
    v.brightBlurAdd = 0.3 -- standard blur is brightBlur true
	-- Depth 
	v.fManualFocus = false
	v.fNearBlurCurve = 10.0 -- [0.4 to X] Power of blur of closer-than-focus areas.
	v.fFarBlurCurve = 0.5 -- [0.4 to X] Elementary, my dear Watson: Blur power of areas behind focus plane.
	v.fManualFocusDepth = 0.1 -- [0.0 to 1.0] Manual focus depth. 0.0 means camera is focus plane, 1.0 means sky is focus plane.
end

---------------------------------
-- shader model version
---------------------------------
function vCardPSVer()
	local smVersion = tostring(dxGetStatus().VideoCardPSVersion)
	---outputDebugString("VideoCardPSVersion: "..smVersion)
	return smVersion
end

---------------------------------
-- DepthBuffer access
---------------------------------
function isDepthBufferAccessible()
	local depthStatus = tostring(dxGetStatus().DepthBufferFormat)
	--outputDebugString("DepthBufferFormat: "..depthStatus)
	if depthStatus=='unknown' then depthStatus=false end
	return depthStatus
end

----------------------------------------------------------------
-- enableDoF
----------------------------------------------------------------
function enableDoF()
	if dEffectEnabled then return end
	addEventHandler( "onClientHUDRender", root, hudRender, true, "low" .. orderPriority )
	-- Create things
	myScreenSource = dxCreateScreenSource( scx, scy )
	
	dBlurHShader,tecName = dxCreateShader( "fx/dBlurH.fx" )
	--outputDebugString( "blurHShader is using technique " .. tostring(tecName) )

	dBlurVShader,tecName = dxCreateShader( "fx/dBlurV.fx" )
	--outputDebugString( "blurVShader is using technique " .. tostring(tecName) )
	
	dDepthTexShader,tecName = dxCreateShader( "fx/dDepthTex.fx" )
	--outputDebugString( "depthTexShader is using technique " .. tostring(tecName) )
	
	-- Get list of all elements used
	effectParts = {
						myScreenSource,
						dBlurHShader,
						dBlurVShader,
						dDepthTexShader,
					}

	-- Check list of all elements used
	bAllValid = true
	for _,part in ipairs(effectParts) do
		bAllValid = part and bAllValid
	end
	
	curDistSample = 0
	medianFocalDist = 0
	distSamples = {}
	
	setEffectVariables ()
	dEffectEnabled = true
	
	if not bAllValid then
		--outputChatBox( "DoF: Could not create some things. Please use debugscript 3" )
		disableDoF()
	else
		local v = Settings.var
		dxSetShaderValue( dDepthTexShader, "fManualFocus", v.fManualFocus )
		dxSetShaderValue( dDepthTexShader, "fNearBlurCurve", v.fNearBlurCurve )
		dxSetShaderValue( dDepthTexShader, "fFarBlurCurve", v.fFarBlurCurve )
		dxSetShaderValue( dDepthTexShader, "fManualFocusDepth", v.fManualFocusDepth )
		dxSetShaderValue( dBlurVShader, "gblurFactor", v.blurFactor )
		dxSetShaderValue( dBlurVShader, "gBrightBlur", v.brightBlur )
		dxSetShaderValue( dBlurVShader, "gBrightBlurAdd", v.brightBlurAdd )
		dxSetShaderValue( dBlurHShader, "gblurFactor", v.blurFactor )
		dxSetShaderValue( dBlurHShader, "gBrightBlur", v.brightBlur )
		dxSetShaderValue( dBlurHShader, "gBrightBlurAdd", v.brightBlurAdd )
	end	
end

----------------------------------------------------------------
-- disableDoF
----------------------------------------------------------------
function disableDoF()
	if not dEffectEnabled then return end
	removeEventHandler( "onClientHUDRender", root, hudRender, true, "low" .. orderPriority )

	-- Destroy all shaders
	for _,part in ipairs(effectParts) do
		if part then
			destroyElement( part )
		end
	end
	effectParts = {}

	bAllValid = false
	RTPool.clear()
	
	-- Flag effect as stopped
	dEffectEnabled = false
end

-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------
function hudRender()
	if not bAllValid or not Settings.var then return end
	local v = Settings.var	
	-- Reset render target pool
	RTPool.frameStart()
	-- Update screen
	dxUpdateScreenSource( myScreenSource, true )
	-- Start with screen
	local current = myScreenSource

	-- Apply all the effects, bouncing from one render target to another
	if v.autoFocus then v.focalDepth = medianFocalDist end
	local depthTex = getDepthTexture( current )
	current = applyGDepthBlurH( current, depthTex )
	current = applyGDepthBlurV( current, depthTex )

	-- When we're done, turn the render target back to default
	dxSetRenderTarget()
	
	if current then dxDrawImage( 0, 0, scx, scy, current, 0, 0, 0, tocolor(255,255,255,255) ) end
	--if depthTex then dxDrawImage( 0.75*scx, 0, scx/4, scy/4, depthTex, 0, 0, 0, tocolor(255,255,255,255) ) end
end

-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------
function getDepthTexture(Src ) 
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused( mx,my )
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( dDepthTexShader, "sTexSize", mx,my )
	dxDrawImage( 0, 0, mx, my, dDepthTexShader )
	return newRT
end
	
function applyGDepthBlurH( Src, getDepth )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( dBlurHShader, "TEX0", Src )
	dxSetShaderValue( dBlurHShader, "TEX1", getDepth )
	dxSetShaderValue( dBlurHShader, "tex0size", mx,my )
	dxDrawImage( 0, 0, mx, my, dBlurHShader )
	return newRT
end

function applyGDepthBlurV( Src, getDepth )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( dBlurVShader, "TEX0", Src )
	dxSetShaderValue( dBlurVShader, "TEX1", getDepth )
	dxSetShaderValue( dBlurVShader, "tex0size", mx,my )
	dxDrawImage( 0, 0, mx,my, dBlurVShader )
	return newRT
end

----------------------------------------------------------------
-- Avoid errors messages when memory is low
----------------------------------------------------------------
_dxDrawImage = dxDrawImage
function xdxDrawImage(posX, posY, width, height, image, ... )
	if not image then return false end
	return _dxDrawImage( posX, posY, width, height, image, ... )
end