local screenX, screenY = guiGetScreenSize()


addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oJob" then  
        core = exports.oCore
        color = core:getServerColor()
        info = exports.oInfobox
        font = exports.oFont
	end
end)
