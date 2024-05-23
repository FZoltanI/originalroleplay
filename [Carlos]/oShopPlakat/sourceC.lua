local screenX, screenY = guiGetScreenSize()

-- shader
local shaderValue = [[
	texture textureFile;

	technique TexReplace
	{
		pass P0
		{
			Texture[0] = textureFile;
		}
	}
]]

-- init
function initShader()
	shader = dxCreateShader(shaderValue, 0, 500, false, "object")
	if shader then
		engineApplyShaderToWorldTexture(shader, "heat_04")
		--engineApplyShaderToWorldTexture(shader, "ads003 copy")
		plakat()
	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end
end

function plakat()
    if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
	renderTarget = dxCreateRenderTarget(960, 540)
    if renderTarget then 
        dxSetRenderTarget(renderTarget)
            dxDrawImage(0, 0, 960, 540, "plakat_1.png")
        dxSetRenderTarget()
		dxSetShaderValue(shader, "textureFile", renderTarget)
    end
end



initShader()

-- init
function initShader2()
	shader = dxCreateShader(shaderValue, 0, 500, false, "object")
	if shader then
		--engineApplyShaderToWorldTexture(shader, "heat_04")
		engineApplyShaderToWorldTexture(shader, "ads003 copy")
		plakat2()
	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end
end

function plakat2()
    if isElement(renderTarget) then
		destroyElement(renderTarget)
	end
	renderTarget = dxCreateRenderTarget(960, 540)
    if renderTarget then 
        dxSetRenderTarget(renderTarget)
            dxDrawImage(0, 0, 960, 540, "plakat_2.png")
        dxSetRenderTarget()
		dxSetShaderValue(shader, "textureFile", renderTarget)
    end
end




initShader2()

local shaderValue2 = [[
	texture textureFile;

	technique TexReplace
	{
		pass P0
		{
			Texture[0] = textureFile;
		}
	}
]]

-- init
function initShader3()
	shader2 = dxCreateShader(shaderValue2)
	if shader2 then
		--engineApplyShaderToWorldTexture(shader, "heat_04")
		engineApplyShaderToWorldTexture(shader2, "didersachs01")
		plakat3()
        --outputChatBox("asd")
	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end
end

function plakat3()
    if isElement(renderTarget2) then
		destroyElement(renderTarget2)
	end
	renderTarget2 = dxCreateRenderTarget(960, 540)
    if renderTarget2 then 
        dxSetRenderTarget(renderTarget2)
            dxDrawImage(0, 0, 960, 540, "plakat_3.png")
        dxSetRenderTarget()
		dxSetShaderValue(shader2, "textureFile", renderTarget2)
    end
end



initShader3()

-- init
function initShader3()
	shader2 = dxCreateShader(shaderValue2)
	if shader2 then
		--engineApplyShaderToWorldTexture(shader, "heat_04")
		engineApplyShaderToWorldTexture(shader2, "homies_2")
		plakat3()
        --outputChatBox("asd")
	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end
end

function plakat3()
    if isElement(renderTarget2) then
		destroyElement(renderTarget2)
	end
	renderTarget2 = dxCreateRenderTarget(960, 540)
    if renderTarget2 then 
        dxSetRenderTarget(renderTarget2)
            dxDrawImage(0, 0, 960, 540, "plakat_4.png")
        dxSetRenderTarget()
		dxSetShaderValue(shader2, "textureFile", renderTarget2)
    end
end



initShader3()

-- init
function initShader3()
	shader2 = dxCreateShader(shaderValue2)
	if shader2 then
		--engineApplyShaderToWorldTexture(shader, "heat_04")
		engineApplyShaderToWorldTexture(shader2, "eris_3")
		plakat3()
        --outputChatBox("asd")
	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end
end

function plakat3()
    if isElement(renderTarget2) then
		destroyElement(renderTarget2)
	end
	renderTarget2 = dxCreateRenderTarget(960, 540)
    if renderTarget2 then 
        dxSetRenderTarget(renderTarget2)
            dxDrawImage(0, 0, 960, 540, "plakat_5.png")
        dxSetRenderTarget()
		dxSetShaderValue(shader2, "textureFile", renderTarget2)
    end
end



initShader3()

-- init
function initShader3()
	shader2 = dxCreateShader(shaderValue2)
	if shader2 then
		--engineApplyShaderToWorldTexture(shader, "heat_04")
		engineApplyShaderToWorldTexture(shader2, "bobo_3")
		plakat3()
        --outputChatBox("asd")
	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end
end

function plakat3()
    if isElement(renderTarget2) then
		destroyElement(renderTarget2)
	end
	renderTarget2 = dxCreateRenderTarget(960, 540)
    if renderTarget2 then 
        dxSetRenderTarget(renderTarget2)
            dxDrawImage(0, 0, 960, 540, "plakat_6.png")
        dxSetRenderTarget()
		dxSetShaderValue(shader2, "textureFile", renderTarget2)
    end
end



initShader3()

-- init
function initShader3()
	shader2 = dxCreateShader(shaderValue2)
	if shader2 then
		--engineApplyShaderToWorldTexture(shader, "heat_04")
		engineApplyShaderToWorldTexture(shader2, "heat_04")
		plakat3()
        --outputChatBox("asd")
	else
		outputChatBox("Hiba történt a shader létrehozásakor", 255, 0, 0)
	end
end

function plakat3()
    if isElement(renderTarget2) then
		destroyElement(renderTarget2)
	end
	renderTarget2 = dxCreateRenderTarget(960, 540)
    if renderTarget2 then 
        dxSetRenderTarget(renderTarget2)
            dxDrawImage(0, 0, 960, 540, "plakat_7.png")
        dxSetRenderTarget()
		dxSetShaderValue(shader2, "textureFile", renderTarget2)
    end
end



initShader3()