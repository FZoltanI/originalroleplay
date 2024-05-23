createObject(1537, 1381.1161621094, 259.25, 18.566932678223, 0, 0, 155)

addEvent("pizza > giveMoney", true)
addEventHandler("pizza > giveMoney", resourceRoot, function(money)
	setElementData(client, "char:money", getElementData(client, "char:money") + money)
end)

addEvent("pizza > setPlayerStartPos", true)
addEventHandler("pizza > setPlayerStartPos", resourceRoot, function()
	setElementData(client, "pizza > startOutPos2", Vector3(getElementPosition(client)))
end)

function spawnPizzazo(player, cmd)

	setElementInterior(player, 100)
	setElementDimension(player, 100)
	setElementInterior(player, 0)
	setElementDimension(player, 0)
	setElementPosition(player, 2092.7797851563, -1807.4639892578, 13.548970222473)
end
addCommandHandler("pizzazo", spawnPizzazo)

addEvent("teleOut", true)
addEventHandler("teleOut", root,
	function(player)
		setElementPosition(player, 2102.9011230469, -1806.763671875, 13.5546875)
		setElementInterior(player, 100)
		setElementDimension(player, 100)
		setElementInterior(player, 0)
		setElementDimension(player, 0)
	end
);

addEvent("setPizzaSkin", true)
addEventHandler("setPizzaSkin", root,
	function(player)
		setElementModel(player, 155)
	end
);

addEvent("setOldSkin", true)
addEventHandler("setOldSkin", root,
	function(player, oldSkin)
		oldSkin = tonumber(oldSkin)
		setElementModel(player, oldSkin)
	end
);