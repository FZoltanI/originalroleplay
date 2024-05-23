--
-- c_palette.lua
--

paletteTable = { customPalette = dxCreateTexture("palettes/1.png"), palEffectEnabled = false, paletteEnabled = true, 
				chromaticEnabled = false, orderPriority = "-3.5" }

local bAllValid = false

local Settings = {}
Settings.var = {}

---------------------------------
-- Settings for effect
---------------------------------
function setEffectVariables()
    local v = Settings.var
    -- Palette
    v.PaletteEnabled = paletteTable.paletteEnabled
    v.lumLerp = 0.96 -- the closer to 1 the slower the transition
-- Chromatic Abberation
    v.ChromaticEnabled = paletteTable.chromaticEnabled
    v.ChromaticAmount = 0.009
    v.LensSize = 0.515
    v.LensDistortion = 0.05
    v.LensDistortionCubic = 0.05
end

--------------------------------
-- Switch effect on
--------------------------------
function enablePalette(number)
	if paletteTable.palEffectEnabled and current == number then return end

	current = number

	-- Input texture
    screenTex = dxCreateScreenSource( scx, scy )

	-- Shaders
	chromaticShader = dxCreateShader( "fx/chromatic.fx" )
	paletteShader = dxCreateShader( "fx/palette.fx" )

	if isElement(paletteTable.customPalette) then
		destroyElement(paletteTable.customPalette)
	end

	if not isElement( paletteTable.customPalette ) then 
		chosenPalette = dxCreateTexture("palettes/" .. number .. ".png")
	else
		chosenPalette = paletteTable.customPalette
	end

	--outputDebugString("Created plaette: " .. number)
	
	-- A table to store the results of scene luminance calculations
	lumTemp = dxCreateScreenSource( 512, 512 )

	-- Get list of all elements used
	effectParts = {
						screenTex,
						paletteShader,
						chromaticShader,
						chosenPalette,
						lumTemp
					}

	-- Check list of all elements used
	bAllValid = true
	for _,part in ipairs(effectParts) do
		bAllValid = part and bAllValid
	end

	setEffectVariables ()
	paletteTable.palEffectEnabled = true

	if not bAllValid then
		disablePalette()
	else
		dxSetShaderValue( paletteShader, "sPaletteTexture", chosenPalette )
	end
end


--------------------------------
-- Switch effect off
--------------------------------
function disablePalette()
	if not paletteTable.palEffectEnabled then return end

	-- Destroy all shaders
	for _,part in ipairs(effectParts) do
		if part then
			if isElement(part) then
				destroyElement( part )
			end
		end
	end
	effectParts = {}
	bAllValid = false
	RTPool.clear()

	-- Flag effect as stopped
	paletteTable.palEffectEnabled = false
end

----------------------------------------------------------------
-- Render
----------------------------------------------------------------
addEventHandler( "onClientHUDRender", root,
    function()
		if not bAllValid or not Settings.var then return end
		local v = Settings.var

		RTPool.frameStart()

		dxUpdateScreenSource( screenTex, true )
		dxUpdateScreenSource( lumTemp, true )
		local current = screenTex
		
		if v.ChromaticEnabled then
			current1 = applyChromatic( current1, v.ChromaticAmount,v.LensSize, v.LensDistortion, v.LensDistortionCubic )
		end
		if v.PaletteEnabled then
			local lumPixel = countLuminanceForPalette(lumTemp, v.lumLerp)
			current = applyPalette( current, lumPixel )
		end
		dxSetRenderTarget()
		if current then 
			dxDrawImage( 0, 0, scx, scy, current, 0, 0, 0, tocolor(255,255,255,255) ) 
		end
    end
,true ,"low" .. paletteTable.orderPriority )


----------------------------------------------------------------
-- post process items
----------------------------------------------------------------
function applyChromatic( src, chromaticAmount,lensSize, lensDistortion, lensDistortionCubic )
	if not src then return nil end
	local mx,my = dxGetMaterialSize( src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( chromaticShader, "sBaseTexture", src )
	dxSetShaderValue( chromaticShader, "ChromaticAmount", chromaticAmount )
	dxSetShaderValue( chromaticShader, "LensSize", lensSize )
	dxSetShaderValue( chromaticShader, "LensDistortion", lensDistortion )
	dxSetShaderValue( chromaticShader, "LensDistortionCubic", lensDistortionCubic )
	dxDrawImage( 0, 0, mx,my, chromaticShader )
	return newRT
end

function applyPalette( src, lumPixel )
	if not src then return nil end
	local mx,my = dxGetMaterialSize( src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( paletteShader, "sBaseTexture", src )
	dxSetShaderValue( paletteShader, "sLumPixel", lumPixel )
	dxDrawImage( 0, 0, mx,my, paletteShader )
	return newRT
end

function countMedianPixelColor( tValue )
	local r, g, b, a = dxGetPixelColor( tValue, 0, 0 )
	return { r /255, g / 255, b / 255}
end

local lastPix = {1,1,1}
function countLuminanceForPalette(luminance, lerpValue)
	local lerpAdj = lerpValue ^ (25 / localFPS)
	local mx, my = dxGetMaterialSize( luminance )
	local size = 1
	while ( size < mx / 2 or size < my / 2 ) do
		size = size * 2
	end
	luminance = applyResize( luminance, size, size )
	while ( size > 1 ) do
		size = size / 2
		luminance = applyDownsample( luminance, 2 )
	end
	local lumSample = dxGetTexturePixels( luminance )
	local pix = countMedianPixelColor( lumSample )
	local thisPix = {lerpAngle(pix[1], lastPix[1], lerpAdj), lerpAngle(pix[2], lastPix[2], lerpAdj), lerpAngle( pix[3], lastPix[3], lerpAdj)}
	lastPix = thisPix
	return thisPix
end

function lerpAngle(a1, a2, t)
	if a2 - a1 > math.pi then
		a2 = a2 - 2 * math.pi
	elseif a1 - a2 > math.pi then
		a1 = a1 - 2 * math.pi
	end
	return a1 + (a2 - a1) * t
end

function applyResize( src, tx, ty )
	if not src then return nil end
	local newRT = RTPool.GetUnused(tx, ty)
	if not newRT then return nil end
	dxSetRenderTarget( newRT )
	dxDrawImage( 0,  0, tx, ty, src )
	return newRT
end

function applyDownsampleSteps( src, steps )
	if not src then return nil end
	for i=1,steps do
		src = applyDownsample ( src )
	end
	return src
end

function applyDownsample( src )
	if not src then return nil end
	local mx,my = dxGetMaterialSize( src )
	mx = mx / 2
	my = my / 2
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT )
	dxDrawImage( 0, 0, mx, my, src )
	return newRT
end

local function updateFPS(msSinceLastFrame)
    localFPS = (1 / msSinceLastFrame) * 1000
end
addEventHandler("onClientPreRender", root, updateFPS)

----------------------------------------------------------------
-- Avoid errors messages when memory is low
----------------------------------------------------------------
_dxDrawImage = dxDrawImage
function xdxDrawImage(posX, posY, width, height, image, ... )
	if not image then return false end
	return _dxDrawImage( posX, posY, width, height, image, ... )
end
