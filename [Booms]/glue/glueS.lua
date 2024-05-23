	
function gluePlayer(slot, vehicle, x, y, z, rotX, rotY, rotZ)
	attachElementToElement(source, vehicle, x, y, z, rotX, rotY, rotZ)
	setPlayerWeaponSlot(source, slot)
end
addEvent("gluePlayer",true)
addEventHandler("gluePlayer",getRootElement(),gluePlayer)

function ungluePlayer()
	detachElementFromElement(source)
end
addEvent("ungluePlayer",true)
addEventHandler("ungluePlayer",getRootElement(),ungluePlayer)