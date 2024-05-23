-- reflective bump test 2_5
-- Original By ren712
-- Modified ccw

local scx, scy = guiGetScreenSize()

-----------------------------------------------------------------------------------
-- Le settings
-----------------------------------------------------------------------------------
Settings = {}
Settings.var = {}

Settings.var.bloom = 1.176

----------------------------------------------------------------
-- onClientResourceStart
----------------------------------------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		-- Create things
        myScreenSource = dxCreateScreenSource( scx/2, scy/2 )
		
        blurHShader = dxCreateShader( "blurH.fx" )
        blurVShader = dxCreateShader( "blurV.fx" )
		wetRoadsShader = dxCreateShader ( "shader_wet_roads.fx", 1, 400, false, "world,object" )

		if not wetRoadsShader then return end

		local wetAmountTexture = dxCreateTexture ( "images/wet_amount.png" );
		dxSetShaderValue ( wetRoadsShader, "sWetAmountTexture", wetAmountTexture );

		-- Apply to roads
		engineApplyShaderToWorldTexture ( wetRoadsShader, "*freew*" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "*road*" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "tar_*" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "hiway*" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "snpedtest*" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "*junction*" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "cos_hiwaymid_256" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "cos_hiwayout_256" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "gm_lacarpark1" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "des_1line256" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "des_1linetar" )
		engineApplyShaderToWorldTexture ( wetRoadsShader, "crossing_law" )

		-- Remove from non-roads
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "concroadslab_256" )
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "custom_roadsign_text" )
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "roadsback01_la" )
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "hiwaygravel1_256" )
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "laroad_offroad1" )
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "ws_freeway2" )
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "desertgravelgrassroad" )
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "tar_1line256hvtodirt" )
		engineRemoveShaderFromWorldTexture ( wetRoadsShader, "sw_farmroad*" )

		-- Check everything is ok
		bAllValid = myScreenSource and blurHShader and blurVShader and wetRoadsShader

		if not bAllValid then
			outputChatBox( "Could not create some things. Please use debugscript 3" )
		else
			outputChatBox( "Started: Shader wet roads" )
		end
	
	end
)


-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------
addEventHandler( "onClientPreRender", root,
    function()
		if not Settings.var then
			return
		end
        if bAllValid then
			-- Reset render target pool
			RTPool.frameStart()
			-- Update screen
			dxUpdateScreenSource( myScreenSource, false )
			-- Start with screen
			current = myScreenSource
			-- Apply all the effects, bouncing from one render target to another
			current = applyGBlurH( current, Settings.var.bloom )
			current = applyGBlurV( current, Settings.var.bloom )
			-- When we're done, turn the render target back to default
			dxSetRenderTarget()
			dxSetShaderValue( wetRoadsShader, "sReflectionTexture", current );

			-- Copy ansiotropic settings for 2nd+ textures
			local Anisotropy = math.pow( 2, dxGetStatus().SettingAnisotropicFiltering )
			dxSetShaderValue( wetRoadsShader, "sMaxAnisotropy", Anisotropy )
        end
    end
)


-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------

function applyGBlurH( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "TEX0", Src )
	dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShader, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

function applyGBlurV( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "TEX0", Src )
	dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShader, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end

-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
RTPool = {}
RTPool.list = {}

function RTPool.frameStart()
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
		outputDebugString( "creating new RT " .. tostring(mx) .. " x " .. tostring(mx) )
		RTPool.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end
