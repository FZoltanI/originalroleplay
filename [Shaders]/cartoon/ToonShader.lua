-- main variables
local root = getRootElement()
local resourceRoot = getResourceRootElement(getThisResource())
local screenWidth, screenHeight = guiGetScreenSize()

-- settings
local bitDepth = 16 -- between 1 and 64
local outlineStrength = 0.9 -- between 0 and 1 // higher amount will decrease outline strenght

-- functional variables
local myScreenSource = dxCreateScreenSource(screenWidth, screenHeight)

addEventHandler("onClientResourceStart", resourceRoot,
function()
    if getVersion ().sortable < "1.3.1" then
        outputChatBox("Resource is not compatible with this client.")
        return
	else
		toonShader, toonTec = dxCreateShader("shaders/toonShader.fx")
		
        if (not toonShader) then
            outputChatBox("Could not create blur shader. Please use debugscript 3.")
		else
			outputChatBox(toonTec .. " was started.")
        end
    end
end)

addEventHandler("onClientPreRender", root,
function()
    if (toonShader) then
        dxUpdateScreenSource(myScreenSource)
        
        dxSetShaderValue(toonShader, "ScreenSource", myScreenSource)
		dxSetShaderValue(toonShader, "ScreenWidth", screenWidth)
		dxSetShaderValue(toonShader, "ScreenHeight", screenHeight)
        dxSetShaderValue(toonShader, "BitDepth", bitDepth)
		dxSetShaderValue(toonShader, "OutlineStrength", outlineStrength)

        dxDrawImage(0, 0, screenWidth, screenHeight, toonShader)
    end
end)

addEventHandler("onClientResourceStop", resourceRoot,
function()
	if (toonShader) then
		destroyElement(toonShader)
		toonShader = nil
	end
end)