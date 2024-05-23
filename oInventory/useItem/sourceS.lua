local func = {};
local objects = {};

func.giveWeaponServer = function(playerSource,weapon,ammo,item,dbid,value)
	takeAllWeapons(playerSource)
	if weaponCache[item] and not weaponCache[item].notAnim then
		setPedAnimation(playerSource, "COLT45", "sawnoff_reload", 500, false, false, false, false)
	end
	--outputChatBox(ammo)
	local asd = giveWeapon(playerSource, weapon, ammo, true)
	chat:sendLocalMeAction(playerSource, "elővesz egy fegyvert (".. getItemName(item, value) ..")")
	if weaponCache[item] and weaponCache[item].isBack then
		detachWeapon(playerSource,item,dbid)
	end
	toggleControl(playerSource,"next_weapon",false)
	toggleControl(playerSource,"previous_weapon",false)

	setElementData(playerSource, "weapon:skinid", value - 1)
end
addEvent("giveWeaponServer",true)
addEventHandler("giveWeaponServer",getRootElement(),func.giveWeaponServer)

func.takeWeaponServer = function(playerSource,item,dbid,value)
	takeAllWeapons(playerSource)
	if weaponCache[item] and weaponCache[item].isBack then
		attachWeapon(playerSource,item,dbid,value)
	end
	chat:sendLocalMeAction(playerSource, "elrakott egy fegyvert (".. getItemName(item, value) ..")")
	toggleControl(playerSource,"next_weapon",true)
	toggleControl(playerSource,"previous_weapon",true)
	toggleControl(playerSource,"fire",true)
	toggleControl(playerSource,"action",true)
	setElementData(playerSource, "weapon:skinid", -1)

end
addEvent("takeWeaponServer",true)
addEventHandler("takeWeaponServer",getRootElement(),func.takeWeaponServer)

func.takeWeaponServer2 = function(playerSource)
	takeAllWeapons(playerSource)
	
	toggleControl(playerSource,"next_weapon",true)
	toggleControl(playerSource,"previous_weapon",true)
	toggleControl(playerSource,"fire",true)
	toggleControl(playerSource,"action",true)
end
addEvent("takeWeaponServer2",true)
addEventHandler("takeWeaponServer2",getRootElement(),func.takeWeaponServer2)

local itemObjs = {}
func.eatingAnimation = function(playerSource,typ,item)
	if not item then item = 0 end 
	if typ == "food" then
		setPedAnimation(playerSource, "FOOD", "eat_pizza", 4000,false,false,false,false)
		setTimer(function()
			destroyElement(itemObjs[playerSource])
		end, 4000, 1)
	elseif typ == "drink" then
	--	setTimer(function()
			setPedAnimation(playerSource, "VENDING", "vend_drink2_p", 1500,false,false,false,false)
	--	end,500,1)
		
		setTimer(function()
			destroyElement(itemObjs[playerSource])
		end, 1500, 1)
	elseif typ == "smoke" then
		setPedAnimation(playerSource, "SMOKING", "M_smkstnd_loop", 6000,false,false,false,false)
		setTimer(function()
			destroyElement(itemObjs[playerSource])
		end, 6000, 1)
	end
	if item == 7 or (item >= 2 and item <= 3) or (item >= 6 and item <= 18) then -- hamburger
		itemObjs[playerSource] = createObject(2703,0,0,0)
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,12,0,0.08,0.08,180,0)
	elseif item == 4 then -- taco
		itemObjs[playerSource] = createObject(2769,0,0,0)
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,12,0,0.05,0.08,0,0)
	elseif item == 5 then -- pizza
		itemObjs[playerSource] = createObject(2702,0,0,0)
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,12,0,0.12,0.08,180,90,180)
	elseif item == 19 or item == 20 or item == 22 or item == 23 or item == 26 then -- sprite
		itemObjs[playerSource] = createObject(2647,0,0,0)
		setObjectScale(itemObjs[playerSource],0.6)
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.055,0.1,0,90,0)
	elseif item == 21 then -- cola
		itemObjs[playerSource] = createObject(2647,0,0,0)
		setObjectScale(itemObjs[playerSource],0.6)
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.055,0.1,0,90,0)
	elseif item == 24 or item == 25 then -- bor és sör
		itemObjs[playerSource] = createObject(1950,0,0,0)
		exports.oBone:attachElementToBone(itemObjs[playerSource],playerSource,11,0,0.055,0.1,0,90,0)
		setObjectScale(itemObjs[playerSource],0.8)
	elseif item == 71 then 
		itemObjs[playerSource] = createObject(9891,0,0,0)
		exports.oBone:attachElementToBone(itemObjs[playerSource], playerSource, 11, 0, 0.025, 0.09, 0, 0, 270)
	end


end
addEvent("eatingAnimation",true)
addEventHandler("eatingAnimation",getRootElement(),func.eatingAnimation)

func.setPlayerStat = function(playerSource,skill)
	setPedStat(playerSource,skill,999);
end
addEvent("setPlayerStat",true)
addEventHandler("setPlayerStat",getRootElement(),func.setPlayerStat)

-- Old item functions
addEvent("inv > playLuckGameSound", true)
addEventHandler("inv > playLuckGameSound", resourceRoot, function(sound, x, y, z)
	triggerClientEvent(root, "inv > playLuckGameSoundInClient", root, sound, x, y, z)
end)


addEvent("box > giveItem", true)
addEventHandler("box > giveItem", resourceRoot, function(item,pice)	
	giveItem(client,item,1,pice,0)
end)


addEvent("inv > setPedArmor", true)
addEventHandler("inv > setPedArmor", resourceRoot, function(armor)	
	setElementData(client, "char:armor", 100)
	setPedArmor(client, armor)
end)

addEvent("createHifi", true)
addEventHandler("createHifi", resourceRoot, function()
	local pos = Vector3(getElementPosition(client))
	pos.z = pos.z-1
	local rotX, rotY, rotZ = getElementRotation(client)
	local dim, int = getElementDimension(client), getElementInterior(client)
	exports.oHifi:createHifi(pos, rotZ+180, getElementData(client, "char:id"), getPlayerName(client):gsub("_", " "), dim, int)
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

addEvent("inv > createPot", true)
addEventHandler("inv > createPot", resourceRoot, function(values)	
	exports.oDrugs:createDrugPot(values[1][1], values[1][2], values[1][3]-0.8, values[2], values[3])
end)

-- Reload 
addEvent("inventory > reloadWeaponAmmo", true)
addEventHandler("inventory > reloadWeaponAmmo", resourceRoot, function(ped)
    reloadPedWeapon(ped) 
end)
--

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

addEvent("flexInUse",true)
addEventHandler("flexInUse", getRootElement(), function(player)
	local flexObject = getElementData(client, "activeFlexObject") or false
	--17128
	if isElement(flexObject) then 
		destroyElement(flexObject)
		toggleControl(player, "fire", true)
		toggleControl(player, "enter_exit", true)
	else
		toggleControl(player, "fire", false)
		toggleControl(player, "enter_exit", false)
		local flexObject = createObject(17128, 0, 0, 0)
		setElementData(player, "activeFlexObject", flexObject)
		exports.oBone:attachElementToBone(flexObject, player, 11, 0, 0.05, 0.125, 0, 180, -90)
	end
end)

addEvent("attachPoliceShield", true)
addEventHandler("attachPoliceShield", getRootElement(), function(player)
	local policeShield = getElementData(player, "activePoliceShield") or false 
	if isElement(policeShield) then 
		destroyElement(policeShield)
		setElementData(player, "activePoliceShield", false)
		chat:sendLocalMeAction(source, "elrak egy rendőrségi pajzsot")
	else
		local x,y,z = getElementPosition(player)
		local shield = createObject(321, x,y,z)
		setElementInterior(shield, getElementInterior(player))
		setElementDimension(shield, getElementDimension(player))
		--setElementRotation(shield, -15, 205, 175)
		setElementData(player, "activePoliceShield", shield)
		chat:sendLocalMeAction(source, "elővesz egy rendőrségi pajzsot")
		--attachElements(player, shield, -0.1, 0.35, 0.2, 0, 0, 0)
		exports.oBone:attachElementToBone(shield, player, 9, -0.1, 0.35, 0.2, -15, 205, 175)
	end
end)



addEvent("walkiTalkie > sendChatMessage", true)
addEventHandler("walkiTalkie > sendChatMessage", root, function(msg, station)
	for k, v in ipairs(getElementsByType("player")) do 
		if tonumber(getElementData(v, "char:radioStation")) == station then 
			if hasItem(v, 154) then 
				--if not (v == client) then
					outputChatBox(getPlayerName(client):gsub("_", " ").." rádióban: "..msg, v, r, g, b, true)
					triggerClientEvent(v, "faction > pd > playRadioSound", v)
				--end
			end
		end
	end
end)


addEvent("skillBook > updateSkill", true)
addEventHandler("skillBook > updateSkill", resourceRoot, function(element, stat, value)
    setPedStat(element, stat, value)
end)

addEvent("placeApiary", true)
addEventHandler("placeApiary", getRootElement(), function(element)
    exports["oApiary"]:placeApiary(element)
end)

addEvent("setPedWalkStyle", true)
addEventHandler("setPedWalkStyle", getRootElement(), function(player, walkStyle)
	--outputChatBox(walkStyle)
	setPedWalkingStyle(player, walkStyle);
end);
