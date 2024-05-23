local connection = exports["oMysql"]:getDBConnection()
local func = {}
local itemObjs = {}
local flexs = {}
local bombs = {}
local batteringInteriors = {}
local briefCases = {}

addEventHandler("onPlayerQuit",getRootElement(),function()
	if (flexs[source]) then
		exports.oBone:detachElementFromBone(flexs[source])
		destroyElement(flexs[source])
		flexs[source] = nil
	end
	if (briefCases[source]) then
		exports.oBone:detachElementFromBone(briefCases[source])
		destroyElement(briefCases[source])
		briefCases[source] = nil
	end

	if hasItem(source, 149, 1) then 
		takeItem(source, 149)
	end
end)

addEvent("elveszfegyot", true)
addEventHandler("elveszfegyot", getRootElement(),function(playerSource,itemWeap, itemValue)
	takeAllWeapons(playerSource)
	toggleControl(playerSource,"next_weapon",true)
	toggleControl(playerSource,"previous_weapon",true)
end)

addEvent("adjfgytolivel", true)
addEventHandler("adjfgytolivel", getRootElement(),function(playerSource,itemWeap, fegyoammo, itemValue)
	takeAllWeapons(playerSource)
	itemValue = tonumber(itemValue)
	
	if getElementData(playerSource,"isAnim") then
		setPedAnimation(playerSource,"sweet","sweet_injuredloop",-1,false,false,false)
	else
		setPedAnimation(playerSource, "COLT45", "sawnoff_reload", 500, false, false, false, false)
	end

	if itemWeap == 42 or itemWeap == 23  or itemWeap == 152 then fegyoammo = 99999 end
	
	giveWeapon(playerSource, itemWeap, fegyoammo, true)

	local weapTimer = {}
	weapTimer[playerSource] = setTimer(function()
		toggleControl(playerSource,"next_weapon",false)
		toggleControl(playerSource,"previous_weapon",false)
		killTimer(weapTimer[playerSource])
	end,1000,1)
end)

function attachItemPlayer(playerSource,objID)
	itemObjs[playerSource] = createObject(objID,0,0,0)
	if objID == 2703 then -- hamburger
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,12,0,0.08,0.08,180,0)
	elseif objID == 2769 then -- taco
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,12,0,0.05,0.08,0,0)
	elseif objID == 2702 then -- pizza
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,12,0,0.12,0.08,180,90,180)
	elseif objID == 1546 then -- sprite
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.055,0.1,0,90,0)
	elseif objID == 2647 then -- cola
		setObjectScale(itemObjs[playerSource],0.6)
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.055,0.1,0,90,0)
	elseif objID == 1666 then
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.055,0.1,0,0,0)
	elseif objID == 1951 or objID == 1950 then -- bor és sör
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.055,0.1,0,90,0)
		setObjectScale(itemObjs[playerSource],0.8)
	elseif objID == 1509 then
		setObjectScale(itemObjs[playerSource],0.8)
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.05,0.08,90,0,90)
	elseif objID == 1664 then
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.05,0.08,90,0,90)
	elseif objID == 1485 then
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,-0.05,0.13,0.09,0,0,-90)
	elseif objID == 1543 then
		setObjectScale(itemObjs[playerSource],0.9)
		exports.oBone:attachElementToBone(itemObjs[playerSource], playerSource, 11, -0.2, 0.08, 0.09, 0, 90, 0)
	elseif objID == 9891 then 
		exports.oBone:attachElementToBone(itemObjs[playerSource], playerSource, 11, 0, 0.025, 0.09, 0, 0, 270)
	end
end
addEvent("attachItemPlayer",true)
addEventHandler("attachItemPlayer",root,attachItemPlayer)

function itemAnims(playerSource, typ)
	if type == 0 then 
		setPedAnimation(playerSource, "", "")
	elseif typ == 1 then
		setPedAnimation(playerSource, "FOOD", "eat_pizza", 4000,false,false,false,false)
	elseif typ == 2 then
		setPedAnimation(playerSource, "VENDING", "vend_drink2_p", 4000,false,false,false,false)
	elseif typ == 3 then
		setPedAnimation(playerSource, "SMOKING", "M_smkstnd_loop", 6000,false,false,false,false)
	end
end
addEvent("itemAnims", true)
addEventHandler("itemAnims",root,itemAnims)

function detachItemPlayer(playerSource)
	exports.oBone:detachElementFromBone(itemObjs[playerSource])
	destroyElement(itemObjs[playerSource])
	itemObjs[playerSource] = false
end
addEvent("detachItemPlayer",true)
addEventHandler("detachItemPlayer",root,detachItemPlayer)

addEventHandler("onPlayerQuit",getRootElement(),function()
	if (itemObjs[source]) then
		exports.oBone:detachElementFromBone(itemObjs[source])
		destroyElement(itemObjs[source])
		itemObjs[source] = nil
	end
end)

addEventHandler("onPlayerQuit",getRootElement(),function()
	if (bombs[source]) then
		exports.oBone:detachElementFromBone(bombs[source])
		destroyElement(bombs[source])
		bombs[source] = nil
	end
end)

addEvent("syncBatteringRamToServer",true)
addEventHandler("syncBatteringRamToServer",getRootElement(),function(playerSource,other,interior)
	setElementData(interior,"locked",0)
	setElementData(other,"locked",0)
	setElementData(interior,"time",8)
	setElementData(other,"time",8)
	triggerClientEvent(getRootElement(), "createBatteringSounds", playerSource,other,interior)
	if not batteringInteriors[interior] then
		batteringInteriors[interior] = setTimer(function()
			if getElementData(interior,"time") > 0 then
				if getElementData(interior,"time") == 1 then
					batteringInteriors[interior] = nil
				end
				setElementData(interior,"time",getElementData(interior,"time")-1)
				setElementData(other,"time",getElementData(other,"time")-1)
			end
		end,60000,8)
	end
	dbExec(connection, "UPDATE interiors SET locked = ? WHERE id = ?",0,getElementData(interior,"dbid"))
end)

addEvent("giveFishingRod", true)
addEventHandler("giveFishingRod", resourceRoot, function(playerSource)
	local activeFishingRod = getElementData(client, "hasFishingRod") or false 

	if not activeFishingRod then 
		exports.oFishing:addRodToPlayer(client)
	else
		exports.oFishing:takeFishingRod(client)
	end
end)

addEvent("setPlayerBadge", true)
addEventHandler("setPlayerBadge", resourceRoot, function(state, text)
	setElementData(client, "badgeInUse", state)
	setElementData(client, "badgeText", text)
end)

addEvent("createHifi", true)
addEventHandler("createHifi", resourceRoot, function()
	local pos = Vector3(getElementPosition(client))
	pos.z = pos.z-1
	local rotX, rotY, rotZ = getElementRotation(client)
	local dim, int = getElementDimension(client), getElementInterior(client)
	exports.oHifi:createHifi(pos, rotZ+180, getElementData(client, "char:id"), getPlayerName(client):gsub("_", " "), dim, int)
end)

addEvent("inv > fixVehicle", true)
addEventHandler("inv > fixVehicle", resourceRoot, function(veh)
	setElementHealth(veh, 1000)
	fixVehicle(veh)
end)

addEvent("inv > unflipVehicle", true)
addEventHandler("inv > unflipVehicle", resourceRoot, function(veh)
	local rx, ry, rz = getElementRotation(veh)
	setElementRotation(veh, 0, ry, rz)
end)

addEvent("inv > fuelVehicle", true)
addEventHandler("inv > fuelVehicle", resourceRoot, function(veh)
	setElementData(veh, "veh:fuel", getElementData(veh, "veh:maxFuel"))
	setElementData(veh, "veh:lastFuelType", getElementData(veh, "veh:fuelType"))
end)

addEvent("inv > userInstantHealCard", true)
addEventHandler("inv > userInstantHealCard", resourceRoot, function()
	if getElementData(client, "playerInAnim") then 
		exports.oDeath:animEnd(client)
		setElementHealth(client, 100)
		setElementData(client, "char:health", 100)
		setElementData(client, "char:hunger", 100)
		setElementData(client, "char:thirst", 100)

		setElementData(client, "char:bones", {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0})
	else
		setElementHealth(client, 100)
		setElementData(client, "char:health", 100)
		setElementData(client, "char:hunger", 100)
		setElementData(client, "char:thirst", 100)

		setElementData(client, "char:bones", {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0})
	end
end)

addEvent("inv > setPedArmor", true)
addEventHandler("inv > setPedArmor", resourceRoot, function(armor)	
	setElementData(client, "char:armor", 100)
	setPedArmor(client, armor)
end)

addEvent("inv > createPot", true)
addEventHandler("inv > createPot", resourceRoot, function(values)	
	exports.oDrugs:createDrugPot(values[1][1], values[1][2], values[1][3]-0.8, values[2], values[3])
end)

addEvent("inv > playLuckGameSound", true)
addEventHandler("inv > playLuckGameSound", resourceRoot, function(sound, x, y, z)
	triggerClientEvent(root, "inv > playLuckGameSoundInClient", root, sound, x, y, z)
end)

addEvent("inv > takePetrolCan", true)
addEventHandler("inv > takePetrolCan", resourceRoot, function()
	local petrolCan = getElementData(client, "activePetrolCan") or false
	if isElement(petrolCan) then 
		destroyElement(petrolCan)
		toggleControl(client, "fire", true)
		toggleControl(client, "enter_exit", true)
	else
		toggleControl(client, "fire", false)
		toggleControl(client, "enter_exit", false)
		local can = createObject(1650, 0, 0, 0)
		setElementData(client, "activePetrolCan", can)
		exports.oBone:attachElementToBone(can, client, 11, 0, 0.05, 0.15, 0, 180, 180)
	end
end)