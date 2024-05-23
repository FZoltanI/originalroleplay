function setObjectTextureC(objectElement, shaderName, folder)
	if shaderName and folder then
		texturedObjects[objectElement] = {}
		texturedObjects[objectElement][1] = dxCreateShader("changer/changer.fx", 0, 100, true, "object")
		--outputChatBox(folder)
		texturedObjects[objectElement][2] = dxCreateTexture(folder..".png")
		if texturedObjects[objectElement][1] and texturedObjects[objectElement][2] then
			dxSetShaderValue(texturedObjects[objectElement][1], "TEXTURE", texturedObjects[objectElement][2])
			engineApplyShaderToWorldTexture(texturedObjects[objectElement][1], "*" .. shaderName .. "*", objectElement)
		end
	end
end
addEvent("setObjectTextureC",true)
addEventHandler("setObjectTextureC", getRootElement(), setObjectTextureC)

function removeObjectTextureC(object)
	if object then
		if texturedObjects[object] then
			--destroyElement(texturedObjects[object][1])
			destroyElement(texturedObjects[object][2])
			texturedObjects[object] = nil
		end
	end
end
addEvent("removeObjectTextureC",true)
addEventHandler("removeObjectTextureC", getRootElement(), removeObjectTextureC)