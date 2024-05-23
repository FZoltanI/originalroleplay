--ppx, ppy, ppz = getElementPosition(localPlayer)

addEvent("onLightsEnabled", true)
addEventHandler("onLightsEnabled", getRootElement(), 
	function()
		setTrafficLightState("auto")
	end

)
addEvent("onLightsDisabled", true)
addEventHandler("onLightsDisabled", getRootElement(),
	function()
		setTrafficLightState("disabled")	
	end

)
--function asdasd()
	--createMarker(ppx+2, ppy+2, ppz)
--end
--addCommandHandler("pppanel", asdasd)