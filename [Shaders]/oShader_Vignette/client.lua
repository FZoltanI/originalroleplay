local screenWidth, screenHeight = guiGetScreenSize()
local screenSource	= dxCreateScreenSource(screenWidth, screenHeight)
local darkness		= 0.5
local radius		= 10

addEventHandler("onClientResourceStart", resourceRoot,
function()
    if getVersion ().sortable < "1.1.0" then
        return false
    else
        vignetteShader = dxCreateShader("vignette.fx")
		if(vignetteShader) then
		end
    end
end)

function renderVignette()
	dxUpdateScreenSource(screenSource)
	if(vignetteShader) then
		dxSetShaderValue(vignetteShader, "ScreenSource", screenSource);
		dxSetShaderValue(vignetteShader, "radius", radius);
		dxSetShaderValue(vignetteShader, "darkness", darkness);
		dxDrawImage(0, 0, screenWidth, screenHeight, vignetteShader)
	end
end

local rendered = false
function switchShader(state)
	if state then 
		if not rendered then 
			rendered = true 
			addEventHandler("onClientHUDRender", root, renderVignette)
		end
	else
		if rendered then 
			rendered = false
			removeEventHandler("onClientHUDRender", root, renderVignette)
		end
	end
end

function setShaderValues(DASHdarkness, DASHradius)
	darkness = DASHdarkness
	raius = math.floor(DASHradius)
end