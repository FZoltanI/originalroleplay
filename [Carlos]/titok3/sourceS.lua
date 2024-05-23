addCommandHandler("foldrenges",
	function (player, _, period)
		if getElementData(player, "user:admin") >= 9 then
			if tonumber(period) then
				triggerClientEvent(root, "onEarthquake", player, tonumber(period))
				outputChatBox("[format]#7cc576[fa-globe] [Disaster]:#ffffff Földrengés aktiválva #7cc576" .. period .. " másodpercig.", player, 255, 255, 255, true)
			end
		end
	end
)

addEvent("onLightning", true)
addEventHandler("onLightning", getRootElement(),
	function (posX, posY, posZ)
		triggerClientEvent(root, "onLightning", client, posX, posY, posZ)
	end
)