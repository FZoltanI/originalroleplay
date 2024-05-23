local func = {};

func.setObjectTexture = function(object,shader,image)
	triggerClientEvent(getRootElement(), "setObjectTextureC", getRootElement(), object, shader, image)
end
addEvent("setObjectTexture", true)
addEventHandler("setObjectTexture", getRootElement(), func.setObjectTexture)

func.removeObjectTexture = function(object)
	triggerClientEvent(getRootElement(), "removeObjectTextureC", getRootElement(), object)
end