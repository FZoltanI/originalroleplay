local whitelistEnabled = true
local playerIDs = {}
local pendingSerials = {}

local whitelistSerials = {
	["52E602241DC69E45929DF7CA9DCDDE54"] = true, --carlos
	["E2582905A1146DE0D09B6C6C406772B2"] = true, --aron
	["A106718E8295717F198A146B8EC62DB3"] = true, --carlos laptop

	["CEA522BAC3269175C7A200BBD3EA04F0"] = true, --costa
	["FCF1E89E7894C8C58287D9B121B978B2"] = true, --kondor
	["3C4EDBBC959CD9DBFF7E4E35F46B94B2"] = true, --paul
	["10D1C517DCD4E19401F635E6DB9D93F4"] = true, --paul laptop

	["659E685D624B685B93585B2EE40820A2"] = true, -- patrik

	["FADD74F89263F9BEE73931EDAFB178A1"] = true, -- daniel
	["A51AEA488C429FDF52385CC085F80134"] = true, -- keichii



	-- TESZTEREK + ADMINOK

}

local blacklistSerials = {
	["4ED87BD186DED0CF1A7BEFBDF56E48A2"] = true, --Ted
	["AAC7994A6E7E92FC9BD08397FD0BFDB2"] = true, --Ted haverja
}

function setWhiteListEnable()
	whitelistEnabled = true
end 
addEvent("setWhiteListEnable",true)
addEventHandler("setWhiteListEnable",root,setWhiteListEnable)

setFPSLimit(60)
setGameType("OriginalRoleplay")
setMapName("OriginalRoleplay")

addEventHandler("onResourceStart", resourceRoot, function()
	--outputChatBox("#e0361f[OriginalRoleplay - Whitelist]: #ffffff"..serverColor.."bela".." #ffffffmegpróbált csatlakozni. (/pendingserials, /acceptserial)", root, 255, 255, 255, true)
	local players = getElementsByType("player")
	for i = 1, #players do
		playerIDs[i] = players[i]
		setElementData(players[i], "playerid", i)
	end
end)

addEventHandler("onPlayerConnect", getRootElement(), function(playerName, _, _, playerSerial)
	if blacklistSerials[playerSerial] then 
		cancelEvent(true)
	end

	if not whitelistEnabled then return end
	if not whitelistSerials[playerSerial] then
		cancelEvent(true, "Jelenleg fejlesztés alatt...")

		for k, v in ipairs(getElementsByType("player")) do 
			if exports.oAdmin:isPlayerDeveloper(v) then 
				outputChatBox("#e0361f[OriginalRoleplay - Whitelist]: #ffffff"..serverColor..playerName.." #ffffffmegpróbált csatlakozni. (/pendingserials, /acceptserial)", v, 255, 255, 255, true)
			end 
		end

		for k, v in pairs(pendingSerials) do
			if v[2] == playerSerial then
				return
			end
		end
		table.insert(pendingSerials, {playerName, playerSerial})
    end
end)

addEventHandler("onPlayerJoin", getRootElement(), function()
	for i = 1, getMaxPlayers() do
		if not playerIDs[i] then
			playerIDs[i] = source
			setElementData(source, "playerid", i)
			break
		end
	end
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
	for i = 1, getMaxPlayers() do
		if playerIDs[i] == source then
			playerIDs[i] = nil
			break
		end
	end
end)

addEventHandler("onPlayerChangeNick", getRootElement(), function()
	cancelEvent()
end)

addEventHandler("onPlayerSpawn", getRootElement(), function()
	setPedHeadless(source, false)
	setElementData(source, "char:health", 100)
	setElementData(source, "char:hunger", 100)
	setElementData(source, "char:thirst", 100)
end)

local deathTypes = {
	[19] = "robbanás",
	[37] = "égés",
	[49] = "autóbaleset",
	[50] = "autóbaleset",
	[51] = "robbanás",
	[52] = "elütötték",
	[53] = "fulladás",
	[54] = "esés",
	[55] = "unknown",
	[56] = "verekedés",
	[57] = "fegyver",
	[59] = "tank",
	[63] = "robbanás",
	[0] = "verekedés"
}

addEventHandler("onPlayerWasted", getRootElement(), function(_, killer, weapon, bodypart, stealth)
	if not getElementData(source, "customDeath") then
		local deathReason = "ismeretlen"
		if tonumber(weapon) then
			deathReason = deathTypes[weapon]

			if not deathReason then
				local weaponName = getWeaponNameFromID(weapon)
				--if weaponNames[weaponName] then
					--weaponName = weaponNames[weaponName]

					if deathReason == "autóbaleset" then
						deathReason = "autóbaleset"
					else
						deathReason = "fegyver (" .. weaponName .. ")"
					end
				--else
				--	deathReason = "fegyver (" .. weaponName .. ")"
				--end
			elseif deathReason == "unknown" then
				deathReason = "ismeretlen"
			end
		end
		if bodyPart == 9 then
			deathReason = deathReason .. " [fejlövés]"
		end
        setElementData(source, "customDeath", deathReason)
    end
	triggerClientEvent(getRootElement(), "sendKillLog", getRootElement(), source, killer, weapon, bodypart)
end)

addEvent("killPlayer", true)
addEventHandler("killPlayer", getRootElement(), function(atk, wpn, bdp)
	setPedHeadless(client, true)
	killPed(client, atk, wpn, bdp)
end)

addCommandHandler("pendingserials", function(thePlayer)
	if exports.oAdmin:isPlayerDeveloper(thePlayer) then
		if #pendingSerials == 0 then
			outputChatBox("Jelenleg nincs olyan serial amit el kellene fogadni.", thePlayer, 255, 255, 255)
			return
		end
			
		for k, v in pairs(pendingSerials) do
			outputChatBox("["..k.."] - "..v[1], thePlayer, 255, 255, 255)
		end
	end
end)

addCommandHandler("acceptserial", function(thePlayer, cmd, id)
	if exports.oAdmin:isPlayerDeveloper(thePlayer) then
		if tonumber(id) then
			if pendingSerials[tonumber(id)] then
				whitelistSerials[(pendingSerials[tonumber(id)][2])] = true
				table.remove(pendingSerials, tonumber(id))
				outputChatBox("Serial hozzáadva a whitelisthez!", thePlayer, 255, 255, 255)
			else
				outputChatBox("Nincs ilyen sorszámmal serial kérelem.", thePlayer, 255, 255, 255)
			end
		else
			outputChatBox("/elfogadserial [id]", thePlayer, 255, 255, 255)
		end
	end
end)

addCommandHandler("togwhitelist", function(thePlayer)
	if exports.oAdmin:isPlayerDeveloper(thePlayer) then
		if whitelistEnabled then
			outputChatBox("Whitelist kikapcsolva!", thePlayer, 255, 255, 255)
		else
			outputChatBox("Whitelist bekapcsolva!", thePlayer, 255, 255, 255)
		end
		whitelistEnabled = not whitelistEnabled
	end
end)

addCommandHandler("elemdata", function(thePlayer)
	if exports.oAdmin:isPlayerDeveloper(thePlayer) then
		local veh = getPedOccupiedVehicle(thePlayer)
		if veh then
			data = getAllElementData(veh)
		else
			data = getAllElementData(thePlayer)
		end
		for k, v in pairs(data) do
			outputConsole(k..": "..tostring(v), thePlayer)
		end
	end
end)

addEvent("sendMoney", true)
addEventHandler("sendMoney", getRootElement(), function(target, amount)
	setElementData(client, "char:money", getElementData(client, "char:money") - amount)
	setElementData(target, "char:money", getElementData(target, "char:money") + amount)
end)