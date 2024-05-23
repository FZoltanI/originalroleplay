local _getPlayerName = getPlayerName
local core = exports.oCore
local color, r, g, b = core:getServerColor()
local highRiskCMD = {}

local weaponTable = {4, 24, 25, 29, 31, 33, 18, 11, 46}

local conn = exports.oMysql:getDBConnection()

local highLevelAdmins = {
	{"2D565C706DC4646D99D06A8D68A53BE3"}, -- Carlos
	{"3C4EDBBC959CD9DBFF7E4E35F46B94B2"}, -- Paul
	{"A8D6BA2E6A0FE86203A10DEEA851BBA2"}, -- Aron

}

function sendMessageToAdmins(player, msg, level)
	--[[local month, day = core:getDate("month"), core:getDate("monthday")
	local filePath = "!LOG_FILES/" .. month .. "/" .. month .. "_" .. day .. ".txt"

	if not fileExists(filePath) then 
		fileCreate(filePath)
	end

	local file = fileOpen(filePath)

	fileWrite(file, "["..core:getDate("hour")..":"..core:getDate("minute")..":"..core:getDate("second").."]: "..removeHex(msg).."\n")
	fileFlush(file)
	fileClose(file)]]

	triggerClientEvent(getRootElement(), "sendMessageToAdmins", getRootElement(), player, msg, level)
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

function generateRandomASCIIString(chars)
	local str = ""
	for i = 1, chars do 
		str = str..(string.format("%c", math.random(32, 126)))
	end
	return str
end

addEventHandler("onResourceStop", root, function(resource)
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "aclLogin") then
			outputChatBox(core:getServerPrefix("red-dark", "OriginalRoleplay", 3)..color..tostring(getResourceName(resource)).." #ffffffresource leállítva.",v,255,255,255,true) 
		end
	end
end)

addEventHandler("onResourceStart", root, function(resource)
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "aclLogin") then
			outputChatBox(core:getServerPrefix("red-dark", "OriginalRoleplay", 3)..color..tostring(getResourceName(resource)).." #ffffffresource elindítva.",v,255,255,255,true) 
		end
	end
end)

function developerJoin(player)
	if not player then player = source end
	if isPlayerDeveloper(player) then
		if not isGuestAccount(getPlayerAccount(player)) then
			logOut(player)
		end
		local serial = getPlayerSerial(player)
		local password = generateRandomASCIIString(30)
		local account = getAccount(adminSerials[serial])
		if not account then
			account = addAccount(adminSerials[serial], password)
		end
		setAccountPassword(account, password)
		logIn(player, account, password)
		setElementData(player, "aclLogin", true)
		outputChatBox("[Admin]: #ffffffFejlesztő serial érzékelve! Üdv, "..color..adminSerials[serial].."#ffffff!", player, r, g, b, true)
	else
		setElementData(player, "aclLogin", nil)
		if not isGuestAccount(getPlayerAccount(player)) then
			logOut(player)
		end
	end
end
addEventHandler("onPlayerJoin", getRootElement(), developerJoin)

addEventHandler("onResourceStart", resourceRoot, function()
	for k, v in pairs(aclGroupListObjects(aclGetGroup("Admin"))) do
		if string.find(v:lower(), "user.") then
			aclGroupRemoveObject(aclGetGroup("Admin"), v)
		end
	end
	aclSave()
	for k, v in pairs(adminSerials) do
		if not isObjectInACLGroup("user."..v, aclGetGroup("Admin")) then
			aclGroupAddObject(aclGetGroup("Admin"), "user."..v)
		end
	end
	aclSave()
	aclReload()
	for k, v in ipairs(getElementsByType("player")) do
		developerJoin(v)
	end
end)

addCommandHandler("fixveh", function(thePlayer, cmd, target)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'fixveh') then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				local veh = getPedOccupiedVehicle(target)
				if veh then
					fixVehicle(veh)
					setVehicleDamageProof(veh, false)
					setElementData(veh, "veh:broke", false)
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffmegjavította a járműved.", target, 255, 255, 255, true)
					setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})

					if getElementData(thePlayer, "char:id") == getElementData(veh, "veh:owner") then 
						sendMessageToAdmins(thePlayer, "megjavította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos járművét. #db3535[Saját jármű!]")
					else
						sendMessageToAdmins(thePlayer, "megjavította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos járművét.")
					end

					local playerStats = getElementData(thePlayer, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
					playerStats[8] = playerStats[8] + 1
				
					setElementData(thePlayer, "user:adminDatas", playerStats)
				else
					outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."A játékos nem ül járműben!", thePlayer, 244, 40, 40, true)
				end
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("unflip", function(thePlayer, cmd, target)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'unflip') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				local veh = getPedOccupiedVehicle(target)
				if veh then
					local _, _, r = getElementRotation(veh)
					setElementRotation(veh, 0, 0, r)
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffvissza borította a járműved.", target, 255, 255, 255, true)

					if getElementData(thePlayer, "char:id") == getElementData(veh, "veh:owner") then 
						sendMessageToAdmins(thePlayer, "vissza borította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos járművét. #db3535[Saját jármű!]")	
					else
						sendMessageToAdmins(thePlayer, "vissza borította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos járművét.")	
					end
	
					setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
				else
					outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."A játékos nem ül járműben!", thePlayer, 244, 40, 40, true)
				end
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", thePlayer, r, g, b, true)
		end
	end
end)

function setSkin(thePlayer, cmd, target, id)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'setskin') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local id = tonumber(id)
		if target and id then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				setElementModel(target, id)
				setElementData(target, "player:skin", id)
				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffátállította a kinézetedet. "..color.."("..id..")", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "átállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos kinézetét. "..nameColor.."("..id..")")

				setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Skin ID]", thePlayer, r, g, b, true)
		end
	end
end
addCommandHandler("setskin", setSkin)

addCommandHandler("sethp", function(thePlayer, cmd, target, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'sethp') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				if value > 100 then value = 100 end
				if value < 0 then value = 0 end
				setElementData(target, "char:health", value)
				setElementHealth(target, value)
				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffátállította az életed. "..color.."("..value..")", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "átállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos életét. "..nameColor.."("..value..")")
				setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Érték]", thePlayer, r, g, b, true)
		end
	end
end)
addCommandHandler("setdrunken", function(thePlayer, cmd, target, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'setdrunken') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				if value > 100 then value = 100 end
				if value < 0 then value = 0 end
				setElementData(target, "char:alcoholLevel", value)
				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffátállította az alkohol szinted. "..color.."("..value..")", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "átállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos alkohol szintjét. "..nameColor.."("..value..")")
				setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Érték]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("setarmor", function(thePlayer, cmd, target, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'setarmor') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				if value > 100 then value = 100 end
				if value < 0 then value = 0 end
				setElementData(target, "char:armor", value)
				setPedArmor(target, value)
				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffátállította az pajzsodat. "..color.."("..value..")", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "átállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos pajzsát. "..nameColor.."("..value..")")
				setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Érték]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("sethunger", function(thePlayer, cmd, target, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'sethunger') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				if value > 100 then value = 100 end
				if value < 0 then value = 0 end
				setElementData(target, "char:hunger", value)
				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffátállította az éhezésed. "..color.."("..value..")", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "átállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos éhségszintjét. "..nameColor.."("..value..")")
				setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Érték]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("setthirst", function(thePlayer, cmd, target, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'setthirst') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				if value > 100 then value = 100 end
				if value < 0 then value = 0 end
				setElementData(target, "char:thirst", value)
				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffátállította az szomjúságod. "..color.."("..value..")", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "átállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos szomjúságát. "..nameColor.."("..value..")")
				setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Érték]", thePlayer, r, g, b, true)
		end
	end
end)

function givePMoney(thePlayer, cmd, target, type, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'givemoney') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value and type then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				type = tonumber(type)
				if type == 1 then 
					setElementData(target, "char:money", getElementData(target, "char:money") + value)
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffadott neked "..color.."$"..value.."#ffffff-t.", target, 255, 255, 255, true)
					sendMessageToAdmins(thePlayer, "adott "..nameColor..getPlayerName(target)..adminMessageColor.." játékosnak "..nameColor.."$"..value..adminMessageColor.."-t.",7)
					setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
				elseif type == 2 then 
					setElementData(target, "char:money", getElementData(target, "char:money") - value)
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffelvett tőled "..color.."$"..value.."#ffffff-t.", target, 255, 255, 255, true)
					sendMessageToAdmins(thePlayer, "elvett "..nameColor..getPlayerName(target)..adminMessageColor.." játékostól "..nameColor.."$"..value..adminMessageColor.."-t.",7)
					setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
				end
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Típus (1: +$, 2: -$)] [Érték]", thePlayer, r, g, b, true)
		end
	end
end
addCommandHandler("givemoney",givePMoney)

function setPMoney(thePlayer, cmd, target, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'setmoney') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				if target then
					setElementData(target, "char:money", value)
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffbeállította a Pénzét "..color..value.." -ra/re.", target, 255, 255, 255, true)
					sendMessageToAdmins(thePlayer, "beállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos Pénzét "..nameColor..value..adminMessageColor.."-ra/re.", 7)
					setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
				end
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Érték]", thePlayer, r, g, b, true)
		end
	end
end
addCommandHandler("setmoney",setPMoney)

function givePP(thePlayer, cmd, target, type, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'givepp') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value and type then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				type = tonumber(type)
				if type == 1 then 
					setElementData(target, "char:pp", getElementData(target, "char:pp") + value)
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffadott neked "..color..value.." PremiumPontot#ffffff.", target, 255, 255, 255, true)
					sendMessageToAdmins(thePlayer, "adott "..nameColor..getPlayerName(target)..adminMessageColor.." játékosnak "..nameColor..value.." PremiumPontot"..adminMessageColor..".",7)
					setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
				elseif type == 2 then 
					setElementData(target, "char:pp", getElementData(target, "char:pp") - value)
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffelvett tőled "..color..value.." PremiumPontot#ffffff.", target, 255, 255, 255, true)
					sendMessageToAdmins(thePlayer, "elvett "..nameColor..getPlayerName(target)..adminMessageColor.." játékostól "..nameColor..value.." PremiumPontot"..adminMessageColor..".",7)
					setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
				end
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Típus (1: +PP, 2: -PP)] [Érték]", thePlayer, r, g, b, true)
		end
	end
end
addCommandHandler("givepp", givePP)

function setPP(thePlayer, cmd, target, value)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'setpp') then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local value = tonumber(value)
		if target and value and type then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				setElementData(target, "char:pp", value)
				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffbeállította a PrémiumPontodat "..color..value.." -ra/re.", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "beállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos PrémiumPontját "..nameColor..value..adminMessageColor.."-ra/re.",7)
				setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Érték]", thePlayer, r, g, b, true)
		end
	end
end
addCommandHandler("setpp", setPP)

addCommandHandler("goto", function(thePlayer, cmd, target)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'goto') then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if not (target == thePlayer) then
				if target then
					setElementData(thePlayer, "char:fly", false)
					local x, y, z = getElementPosition(target)
					setElementPosition(getPedOccupiedVehicle(thePlayer) or thePlayer, x, y + 3, z)
					setElementInterior(thePlayer, getElementInterior(target))
					setElementDimension(thePlayer, getElementDimension(target))
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffhozzád teleportált.", target, 255, 255, 255, true)
					sendMessageToAdmins(thePlayer, "elteleportált "..nameColor..getPlayerName(target)..adminMessageColor.." játékoshoz.")
				end
			else
				outputChatBox(nameColor.."["..serverName.."]: #ffffffNem teleportálhatsz saját magadra!", thePlayer, r, g, b, true)
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("sgoto", function(thePlayer, cmd, target)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'sgoto') then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if not (target == thePlayer) then
				if target then
					setElementData(thePlayer, "char:fly", false)
					local x, y, z = getElementPosition(target)
					setElementPosition(getPedOccupiedVehicle(thePlayer) or thePlayer, x, y + 3, z)
					setElementInterior(thePlayer, getElementInterior(target))
					setElementDimension(thePlayer, getElementDimension(target))
				end
			else
				outputChatBox(nameColor.."["..serverName.."]: #ffffffNem teleportálhatsz saját magadra!", thePlayer, r, g, b, true)
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("vhspawn", function(thePlayer, cmd, target)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'vhspawn') then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				local x, y, z = getElementPosition(target)
				local veh = getPedOccupiedVehicle(target)
				if veh then
					setElementPosition(veh, 1469.5307617188, -1734.3907470703, 13.3828125)
				else
					setElementPosition(target, 1478.7978515625, -1724.2850341797, 13.546875)
				end
				setElementInterior(veh or target, 0)
				setElementData(target, "cleaner:inJobInt", false)
				setElementData(target, "playerInClientsideJobInterior", false)
				setElementData(target, "pizza:isPlayerInInt", false)
				setElementDimension(veh or target, 0)
				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffa városházára teleportált téged.", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "elteleportálta "..nameColor..getPlayerName(target)..adminMessageColor.." játékost a városházára.")
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("gethere", function(thePlayer, cmd, target)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'gethere') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if not (target == thePlayer) then
				if target then
					setElementData(target, "char:fly", false)
					local x, y, z = getElementPosition(thePlayer)
					setElementPosition(getPedOccupiedVehicle(target) or target, x, y + 3, z)
					setElementInterior(target, getElementInterior(thePlayer))
					setElementDimension(target, getElementDimension(thePlayer))
					setElementData(target, "cleaner:inJobInt", false)
					setElementData(target, "playerInClientsideJobInterior", false)
					setElementData(target, "pizza:isPlayerInInt", false)
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffmagához teleportált.", target, 255, 255, 255, true)
					sendMessageToAdmins(thePlayer, "magához teleportálta "..nameColor..getPlayerName(target)..adminMessageColor.." játékost.")
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Nem teleportálhatod magadra saját magadat!", thePlayer, r, g, b, true)
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", thePlayer, r, g, b, true)
		end
	end
end)

function setAdminNick(thePlayer, cmd, target, adminnick)
	if not hasPermission(thePlayer,'setadminnick') then return end
	if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

	if target and adminnick then
		local target = core:getPlayerFromPartialName(thePlayer, target)
		if target then
			outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffbeállította "..color..getPlayerName(target).." #ffffffadminnevét "..color..adminnick.."#ffffff-ra/re.", root, 255, 255, 255, true)
			dbExec(exports.oMysql:getDBConnection(), "UPDATE accounts SET adminnick=? WHERE id=?", adminnick, getElementData(target, "user:id"))
			setElementData(target, "user:adminnick", adminnick)
			setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
		end
	else
		outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Adminnnév]", thePlayer, r, g, b, true)
	end
end
addCommandHandler("setadminnick", setAdminNick)
addCommandHandler("setanick", setAdminNick)

function toggleAdminDuty(thePlayer,cmd,target)
	if hasPermission(thePlayer,'aduty') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local hadmin = getElementData(thePlayer, "user:hadmin")
		if getElementData(thePlayer, "user:aduty") then
			
			setElementData(thePlayer, "user:aduty", false)
			if not hadmin then
				setPlayerName(thePlayer, getElementData(thePlayer, "char:name"))
				exports.oInfobox:outputInfoBox("{#colorcode}"..getAdminNick(thePlayer).." #ffffffkilépett az adminisztrátor szolgálatból!", "aduty", root)
				outputChatBox(core:getServerPrefix("server", "Admin", 1).."Kiléptél az adminszolgálatból.", thePlayer, r, g, b, true)
			end
		else
			setElementData(thePlayer, "user:aduty", true)
			if not hadmin then
				setElementData(thePlayer, "char:health", 100)
				setElementHealth(thePlayer, 100)
				setElementData(thePlayer, "char:hunger", 100)
				setElementData(thePlayer, "char:thirst", 100)
				setPlayerName(thePlayer, getElementData(thePlayer, "user:adminnick"))
				exports.oInfobox:outputInfoBox("{#colorcode}"..getAdminNick(thePlayer).." #ffffffadminisztrátor szolgálatba lépett! {#colorcode}(/pm "..getElementData(thePlayer,"playerid")..")", "aduty", root)
				outputChatBox(core:getServerPrefix("server", "Admin", 1).."Adminszolgálatba léptél.", thePlayer, r, g, b, true)
			end
		end
	end
end
addCommandHandler("aduty", toggleAdminDuty)
addCommandHandler("adminduty", toggleAdminDuty)

addEventHandler("onPlayerWasted", root, 
	function(totalAmmo,killer,killerweapon,bodypart,stealth)
		if getElementData(source, "user:aduty") then
			if totalAmmo and killer and killerweapon and bodypart and stealth == true then
				setElementHealth(source, 100)
			end
		end
	end
)

function setAdminLevel(thePlayer, cmd, targetP, level)
	if not hasPermission(thePlayer,'setadminlevel') then return end
	if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

	local level = tonumber(level)
	if targetP and level then
		local target = core:getPlayerFromPartialName(thePlayer, targetP)
		if target then
			local maxlevel = 1
			
			if getPlayerAdminLevel(thePlayer) == 7 then
				maxlevel = 1
			elseif getPlayerAdminLevel(thePlayer) == 8 then 
				maxlevel = 8
			elseif getPlayerAdminLevel(thePlayer) >= 9 then 
				maxlevel = 11
			end

			if (level > maxlevel) then 
				local serial = getPlayerSerial(target)
				local volt = false 

				for k,v in ipairs(highLevelAdmins) do 
					if v[1] == serial then 
						volt = true 
						break
					end
				end


				if getElementData(thePlayer,"aclLogin") then 
					if not volt then 
						sendMessageToAdmins(thePlayer,nameColor.."-által megváltoztatott adminisztrátornak nincs jogosultsága a magagsabb rang használata!")
					end
				else
					if not volt then 
						outputChatBox("Az adminisztrátori rang adása megtagadva! ( A játékos serialja nincs engedélyezve magasabb adminsiztrátori rangra! )", thePlayer, 255,0,0,true)
						return 
					end
				end
			end

			if getElementData(target, "user:idgAs") then 
				outputChatBox("Nem tudsz adni neki adminjogot!", thePlayer, 255,0,0,true)
				outputChatBox("/sethelper", thePlayer, 255,0,0,true)
				return
			end
			--outputChatBox(getElementData(target, "user:admin"))
			--clearAdminStatsStatus
			if getElementData(target, "user:admin") == 1 then 
				clearAdminStatsStatus(thePlayer,targetP)
			--	outputChatBox("asd")
			end
			outputChatBox(color..getElementData(thePlayer, "user:adminnick").." #ffffffátállította "..color..getPlayerName(target).." #ffffffadminszintjét. ("..adminPrefixs[getElementData(target, "user:admin")].." > "..adminPrefixs[level]..")", root, 255, 255, 255, true)
			dbExec(exports.oMysql:getDBConnection(), "UPDATE accounts SET admin=? WHERE id=?", level, getElementData(target, "user:id"))
			setElementData(target, "user:admin", level)
			setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			if getElementData(target, "user:admin") == 0 then 
				setElementData(target,"user:aduty", false)
				setPlayerName(target, getElementData(target, "char:name"))
			end
		end
	else
		outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Szint]", thePlayer, r, g, b, true)
	end
end
addCommandHandler("setadminlevel", setAdminLevel)
addCommandHandler("setalevel", setAdminLevel)

function clearAdminStatsStatus(thePlayer, targetPlayer)
    if targetPlayer then
        local target = core:getPlayerFromPartialName(thePlayer, targetPlayer)
        if isElement(target) then 
            setElementData(target, "user:adutyTime", 0)
            setElementData(target, "user:adminOnlineTime", 0)
            setElementData(target, "user:adminDatas", {0, 0, 0, 0, 0, 0, 0, 0})
            dbExec(conn, "UPDATE characters SET adutyTime = ?, adminOnlineTime = ?, adminDatas = ? WHERE id = ?", 0, 0, toJSON({0, 0, 0, 0, 0, 0, 0, 0}), getElementData(target, "char:id"))
        end
    end
end

addCommandHandler("sethelper", function(player, cmd, targetId)
	if hasPermission(player, "sethelper") then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if not targetId then 
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", player, r, g, b, true)
		else
			local target = core:getPlayerFromPartialName(player, targetId)
			if target then 
				local admin = getElementData(target, "user:admin")
				local idgAs = getElementData(target, "user:idgAs")
				if admin == 0 then
					if not idgAs then 
						setElementData(target, "user:idgAs", true)
						outputChatBox(color..getElementData(player, "user:adminnick").." #ffffffkinevezte "..color..getPlayerName(target).." #ffffffideiglenes adminsegéddé!", root, 255, 255, 255, true)
					else
						setElementData(target, "user:idgAs", false)
						outputChatBox(color..getElementData(player, "user:adminnick").." #ffffffelvette "..color..getPlayerName(target).." #ffffffideiglenes adminsegédjét!", root, 255, 255, 255, true)
					end
				else 
					outputChatBox(core:getServerPrefix("server", "Admin", 1)..color.." Admint nem tudsz kinevezni ideiglenes adminsegéddé!", player, 255, 255, 255, true)
				end
			end
		end
	end
end)

addCommandHandler("setplayername", function(thePlayer, cmd, target, ...)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if not hasPermission(thePlayer,'setplayername') then return end
	if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

	if target and ... then
		local name = table.concat({...}, "_")
		if name:len() > 22 then
			outputChatBox("Túl hosszú név!", thePlayer)
		end
		local target = core:getPlayerFromPartialName(thePlayer, target)
		if target then
			outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffmegváltoztatta a nevedet. ("..name:gsub("_", " ").."#ffffff)", target, 255, 255, 255, true)
			sendMessageToAdmins(thePlayer, "megváltoztatta "..nameColor..getPlayerName(target):gsub("_", " ")..adminMessageColor.." játékos nevét. "..nameColor.."("..name:gsub("_", " ")..")")
			setElementData(target, "char:name", name)
			exports.oAccount:setPlayerCharactersNameTable(target, getElementData(target, "char:id"), name)
			setPlayerName(target, name)
			setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
		end
	else
		outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Új név]", thePlayer, r, g, b, true)
	end
end)

addCommandHandler("findchar", function(thePlayer, cmd, id)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if not hasPermission(thePlayer,'findchar') then return end
	if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

	local id = tonumber(id)
	if id then
		dbQuery(function(queryHandle)
			local result, rows = dbPoll(queryHandle, 0)
			if rows > 0 then
				outputChatBox(core:getServerPrefix("server", "Admin", 3)..id.." karakter neve: "..result[1].charname, thePlayer, r, g, b, true)
			else
				outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Nem található karakter ilyen ID-vel.", thePlayer, 244, 40, 40, true)
			end
		end, exports.oMysql:getDBConnection(), "SELECT charname FROM characters WHERE id=?", id)
	else
		outputChatBox("[Használat]: #ffffff/"..cmd.." [Karakter ID]", thePlayer, r, g, b, true)
	end
end)

addCommandHandler("findid", function(thePlayer, cmd, charname)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if not hasPermission(thePlayer,'findid') then return end
	if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

	if charname then
		dbQuery(function(queryHandle)
			local result, rows = dbPoll(queryHandle, 0)
			if rows > 0 then
				outputChatBox(core:getServerPrefix("server", "Admin", 3)..charname.." karakter ID-je: "..result[1].id, thePlayer, r, g, b, true)
			else
				outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Nem található karakter ilyen névvel.", thePlayer, 244, 40, 40, true)
			end
		end, exports.oMysql:getDBConnection(), "SELECT id FROM characters WHERE charname=?", charname)
	else
		outputChatBox("[Használat]: #ffffff/"..cmd.." [Karakter név]", thePlayer, r, g, b, true)
	end
end)

addCommandHandler("vanish", function(thePlayer)
	if not isPlayerInAdminDuty(thePlayer) then return end

	if hasPermission(thePlayer,'vanish') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if getElementAlpha(thePlayer) == 0 then
			setElementAlpha(thePlayer, 255)
			outputChatBox(core:getServerPrefix("server", "Admin", 3).."Újra látható vagy.", thePlayer, r, g, b, true)
		else
			setElementAlpha(thePlayer, 0)
			outputChatBox(core:getServerPrefix("server", "Admin", 3).."Láthatatlan lettél.", thePlayer, r, g, b, true)
		end
	end
end)

function kick(thePlayer, cmd, target, ...)
	if not isPlayerInAdminDuty(thePlayer) then return end

	if hasPermission(thePlayer,'kick') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			local target, targetName = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				local targetLevel = tonumber(getElementData(target, "user:admin"))
				local kickerLevel = tonumber(getElementData(thePlayer, "user:admin"))

				reason = table.concat({...}, " ")
				if targetLevel <= kickerLevel then
					outputChatBox(core:getServerPrefix("red-dark", "Kick", 3)..color..getElementData(thePlayer, "user:adminnick").." #ffffffkickelte "..color..getPlayerName(target).."#ffffff játékost.",root,255,255,255,true)
					outputChatBox(core:getServerPrefix("red-dark", "Kick", 3).."Indok: "..color..reason.."#ffffff.",root,255,255,255,true)

					local datas = getElementData(target, "dashboard:banKickJailCount") or {0, 0, 0}
					datas[2] = datas[2] + 1
					setElementData(target, "dashboard:banKickJailCount", datas)
					setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})

					kickPlayer(target, thePlayer, table.concat({...}, " "))

					local playerStats = getElementData(thePlayer, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
					playerStats[2] = playerStats[2] + 1
	
					setElementData(thePlayer, "user:adminDatas", playerStats)
				else
					outputChatBox(core:getServerPrefix("red-dark", "Admin", 2).."Nincs jogosultságod ehhez.", thePlayer, r, g, b, true)
					outputChatBox(core:getServerPrefix("red-dark", "Admin", 2)..color..getPlayerName(thePlayer).." #ffffffmegbróbáld kickelni téged.", target, r, g, b, true)
				end
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Indok]", thePlayer, r, g, b, true)
		end
	end
end
addCommandHandler("akick", kick)

addCommandHandler("freeze", function(player,cmd,target)
	if not isPlayerInAdminDuty(player) then return end
	
	if hasPermission(player,'freeze') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then 
			target = core:getPlayerFromPartialName(player, target)
			setElementFrozen(target,true)

			local targetVeh = getPedOccupiedVehicle(target)
			if targetVeh then 
				if not getElementData(targetVeh, "vehicleInTeslaCharger") then 
					setElementFrozen(targetVeh, true)
					setElementData(targetVeh, "adminFreeze", true)
				end
			end

			outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(player,"user:adminnick").." #fffffflefagyasztott!",target,255,255,255,true)

			sendMessageToAdmins(player, "lefagyasztotta "..nameColor..getPlayerName(target)..adminMessageColor.." nevű játékost. ")

		else 
			outputChatBox("[Használat]:#ffffff /"..cmd.." [Target]",player,r,g,b,true)
		end
	end
end)

addCommandHandler("unfreeze", function(player,cmd,target)
	if not isPlayerInAdminDuty(player) then return end
	if hasPermission(player,'unfreeze') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then 
			target = core:getPlayerFromPartialName(player, target)
			setElementFrozen(target,false)

			local targetVeh = getPedOccupiedVehicle(target)
			if targetVeh then 
				if not getElementData(targetVeh, "vehicleInTeslaCharger") then 
					setElementFrozen(targetVeh, false)
					setElementData(targetVeh, "adminFreeze", false)
				end
			end

			outputChatBox(core:getServerPrefix("server", "Admin", 1)..getElementData(player,"user:adminnick").." #ffffffkifagyasztott!",target,255,255,255,true)

			sendMessageToAdmins(player, "kifagyasztotta "..nameColor..getPlayerName(target)..adminMessageColor.." nevű játékost. ")

		else 
			outputChatBox("[Használat]:#ffffff /"..cmd.." [Target]",player,r,g,b,true)
		end
	end
end)

addCommandHandler("recon", function(player,cmd,target)
	--if not isPlayerInAdminDuty(player) then return end
	--if hasPermission(player,'recon') then
	--	if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if (getElementData(player, "user:admin") or 0) >= 1 then
			if target then 
				target = core:getPlayerFromPartialName(player, target)
				
				-- recon bug (látom a chatet mindenkinek akit ezelőtt néztem) elkerülése
				if getElementData(player, "recon:reconedPlayer") then
					outputChatBox(core:getServerPrefix("server", "Admin", 1).."Mielőtt mást reconolnál, kapcsold ki a recon funkciót!",player,255,255,255,true)
				return
				end
				
				if target then
					local sX,sY,sZ = getElementPosition(player)
					local startRecPos = {sX,sY,sZ}
					setElementAlpha(player,0)
					setElementCollisionsEnabled(player,false)
					setElementData(player, "recon:startpos",startRecPos)
					setElementData(player, "recon:startDimInt", {getElementDimension(player), getElementInterior(player)})

					setElementData(player, "recon:reconedPlayer", target)
					setElementData(target, "recon:reconerPlayer", player)

					local pX,pY,pZ = getElementPosition(target)
					setElementPosition(player,pX,pY,-100)
					attachElements(player,target,0,0,-100)

					setCameraTarget(player,target)

					setElementInterior(player, getElementInterior(target))
					setElementDimension(player, getElementDimension(target))

					sendMessageToAdmins(player, "elkezdte reconolni "..nameColor..getPlayerName(target)..adminMessageColor.." nevű játékost. ")
				end

			else 
				if getElementData(player, "recon:reconedPlayer") then
					reconEnd(player)
				else
					outputChatBox("[Használat]:#ffffff /"..cmd.." [Játékos ID]",player,r,g,b,true)
				end
			end
		end
	--end
end)

addEventHandler("onElementDataChange",root,function(key,old,new)  --ha reconolt player lelép kiléptet reconbol
	if key == "user:loggedin" then 
		if new == false then 
			local reconer = getElementData(source,"recon:reconerPlayer") or false
			if reconer then 
				reconEnd(reconer)
				outputChatBox(core:getServerPrefix("red-dark", "Recon", 1).."A reconolt játékos lecsatlakozott így a recon megszakadt!",reconer,255,255,255,true)
			end
		end
	end
end)

addCommandHandler("srecon", function(player,cmd,target)
	if not isPlayerInAdminDuty(player) then return end
	if hasPermission(player,'srecon') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then 
			target = core:getPlayerFromPartialName(player, target)

			if target then
				local sX,sY,sZ = getElementPosition(player)
				local startRecPos = {sX,sY,sZ}
				setElementAlpha(player,0)
				setElementCollisionsEnabled(player,false)
				setElementData(player, "recon:startpos",startRecPos)
				setElementData(player, "recon:startDimInt", {getElementDimension(player), getElementInterior(player)})

				setElementData(player, "recon:reconedPlayer", target)
				setElementData(target, "recon:reconerPlayer", player)

				local pX,pY,pZ = getElementPosition(target)
				setElementPosition(player,pX,pY,-100)
				attachElements(player,target,0,0,-100)

				setCameraTarget(player,target)

				setElementInterior(player, getElementInterior(target))
				setElementDimension(player, getElementDimension(target))
			end

		else 
			if getElementData(player, "recon:reconedPlayer") then
				reconEnd(player)
			else
				outputChatBox("[Használat]:#ffffff /"..cmd.." [Játékos ID]",player,r,g,b,true)
			end
		end
	end
end)

function slap(player,cmd,target)
	if not isPlayerInAdminDuty(player) then return end
	if hasPermission(player,'slap') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then 
			target = core:getPlayerFromPartialName(player, target)

			if target then
				local pos = Vector3(getElementPosition(target))
				setElementPosition(target, pos.x, pos.y, pos.z+10)
				sendMessageToAdmins(player, "felrepítette "..nameColor..getPlayerName(target)..adminMessageColor.." nevű játékost. ")

				setElementData(player, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat] :#ffffff /"..cmd.." [Játékos ID]",player,r,g,b,true)
		end
	end
end
addCommandHandler("slap", slap)

function setInt(player, cmd, target, intID)
	if not isPlayerInAdminDuty(player) then return end
	if hasPermission(player,'setint') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target and tonumber(intID) then 
			target = core:getPlayerFromPartialName(player, target)

			if target then
				setElementInterior(target, tonumber(intID))
				sendMessageToAdmins(player, "átállította "..nameColor..getPlayerName(target)..adminMessageColor.." nevű játékost interiorját. "..nameColor.."("..intID..")")

				setElementData(player, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat] :#ffffff /"..cmd.." [Játékos ID] [Interior ID]",player,r,g,b,true)
		end
	end
end
addCommandHandler("setint", setInt)

function setDim(player, cmd, target, dimID)
	if not isPlayerInAdminDuty(player) then return end
	if hasPermission(player,'setdim') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target and tonumber(dimID) then 
			target = core:getPlayerFromPartialName(player, target)

			if target then
				setElementDimension(target, tonumber(dimID))
				sendMessageToAdmins(player, "átállította "..nameColor..getPlayerName(target)..adminMessageColor.." nevű játékost dimenzióját. "..nameColor.."("..dimID..")")

				setElementData(player, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat] :#ffffff /"..cmd.." [Játékos ID] [Dimenzió ID]",player,r,g,b,true)
		end
	end
end
addCommandHandler("setdim", setDim)

function reconEnd(player, cmd)
	local startpos = getElementData(player,"recon:startpos") or false
	local DimInt = getElementData(player, "recon:startDimInt")
	if startpos then 
		setElementPosition(player,startpos[1],startpos[2],startpos[3])
	end

	if DimInt then 
		setElementDimension(player, DimInt[1])
		setElementInterior(player, DimInt[2])
	end

	sendMessageToAdmins(player, "befejezte a megfigyelését "..nameColor..getPlayerName(getElementData(player, "recon:reconedPlayer"))..adminMessageColor.." nevű játékosnak. ")

	setElementData(getElementData(player, "recon:reconedPlayer"), "recon:reconerPlayer", false)
	setElementData(player, "recon:reconedPlayer", false)

	setElementData(player,"recon:startpos",false)
	detachElements(player)
	setElementPosition(player,startpos[1],startpos[2],startpos[3])
	setElementAlpha(player,255)
	setElementCollisionsEnabled(player,true)
	setCameraTarget(player,player)
	outputChatBox(core:getServerPrefix("server", "Admin", 1).."Recon kikapcsolva!",player,255,255,255,true)
end
addCommandHandler("stoprecon", reconEnd, cmd)
addCommandHandler("reconend", reconEnd, cmd)

-------pm----------
addCommandHandler("pm",
	function(player,cmd,target,...)
		if target and ... then 
			if getElementData(player, "user:loggedin") then
				target = core:getPlayerFromPartialName(player, target)
				local uzi = table.concat({...}, " ")

				if not target then return end
				if (getElementData(player, "adminlastPM") or 0) + 1000 < getTickCount() then
					--outputChatBox(admin)
					--if (getElementData(target,"user:aduty") or getElementData(player,"user:aduty")) or (getElementData(target, "user:admin") == 0 and getElementData(target, "user:idgAs") or getElementData(player, "user:idgAs") ) or ((getElementData(target,"user:admin") == 1) or (getElementData(player,"user:admin") == 1))  then 
					if ((getElementData(target,"user:aduty") or getElementData(player,"user:aduty")) or (getElementData(target, "user:admin") == 0 and getElementData(target, "user:idgAs") or getElementData(player, "user:idgAs") ))  then -- EZ IDG						local hadmin = getElementData(target, "user:hadmin")
						if hadmin then  outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Csak szolgálatban lévő adminisztrátornak írhatsz!",player,255,255,255,true) return end
						setElementData(player, "adminlastPM", getTickCount())
						outputChatBox(core:getServerPrefix("red-dark", "Bejövő - PM ("..getPlayerName(player).." ("..getElementData(player,"playerid")..")", 3) ..color.. uzi, target, 255, 255, 255, true)
						--outputChatBox("#dd2a48[Bejövő - PM ("..getPlayerName(player).." ("..getElementData(player,"playerid")..") )]: #ffffff"..uzi,target,255,255,255,true)
						outputChatBox(core:getServerPrefix("server", "Kimenő - PM ("..getPlayerName(target).." ("..getElementData(target,"playerid")..")", 3) .. uzi, player, 255, 255, 255, true)
						triggerClientEvent(target, "admin:playPMSound", target)

						if getElementData(player, "user:aduty") then 
							if not getElementData(target, "user:aduty") then 
								local playerStats = getElementData(target, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
								playerStats[7] = playerStats[7] + 1

								setElementData(target, "user:adminDatas", playerStats)

								local playerStats2 = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
								playerStats2[6] = playerStats2[6] + 1

								setElementData(player, "user:adminDatas", playerStats2)
							else
								local playerStats = getElementData(target, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
								playerStats[7] = playerStats[7] + 1

								setElementData(target, "user:adminDatas", playerStats)

								local playerStats2 = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
								playerStats2[6] = playerStats2[6] + 1

								setElementData(player, "user:adminDatas", playerStats2)
							end
						else
							local playerStats = getElementData(target, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
							playerStats[7] = playerStats[7] + 1

							setElementData(target, "user:adminDatas", playerStats)
						end

						for k, v in ipairs(getElementsByType("player")) do 
							if getElementData(v,"show:adminPMS") then 
								outputChatBox(core:getServerPrefix("blue-light-2", "PM: "..getPlayerName(player).."("..getElementData(player,"playerid")..") > " ..getPlayerName(target).."("..getElementData(target,"playerid")..")", 3) .. uzi,v,255,255,255,true)
							end
						end
					else
						outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Csak szolgálatban lévő adminisztrátornak írhatsz!",player,255,255,255,true)
					end
				end
			end
		else 
			outputChatBox("[Használat] :#ffffff /"..cmd.." [Admin ID] [Üzenet]",player,r,g,b,true)
		end
	end 
)

addCommandHandler("showpms",
	function(player,cmd)
		if hasPermission(player,'showpms') then
			if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

			if not getElementData(player,"show:adminPMS") then 
				setElementData(player,"show:adminPMS",true) 
				outputChatBox(core:getServerPrefix("green-dark", "Admin", 3).."PM-ek mutatása bekapcsolva!",player,255,255,255,true)
			else
				setElementData(player,"show:adminPMS",false)
				outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."PM-ek mutatása kikapcsolva!",player,255,255,255,true)
			end
		end
	end 
)
--------pm vége-------

---------admin jail--------
function adminJail(player,cmd,target,time,...)
	if hasPermission(player,'ajail') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target and time and ... then
			if tonumber(time) then 
				target = core:getPlayerFromPartialName(player, target)
				if (getElementData(player, "user:admin") < getElementData(target, "user:admin")) or getElementData(player, "user:admin") == getElementData(target, "user:admin") then 
					if exports.oAnticheat:checkPlayerVerifiedAdminStatus(target) then
						outputChatBox(core:getServerPrefix("red-dark", "AdminJail", 3).."Nem tudod bebörtönözni a kiválasztott játékost",player,255,255,255,true)
						outputChatBox(core:getServerPrefix("red-dark", "AdminJail", 3)..color..getElementData(player,"user:adminnick").." be akart jail-ezni!",target,255,255,255,true)
						return
					end
				end
				if not getElementData(target, "adminJail.IsAdminJail") then
					if getPedOccupiedVehicle(target) then 
						removePedFromVehicle(target)
					end
					reason = table.concat({...}, " ")

					setElementData(target, "adminJail.Admin", getElementData(player,"user:adminnick"))
					setElementData(target, "adminJail.JailerAdminLevel", getElementData(player, "user:admin"))
					setElementData(target, "adminJail.Reason", reason)
					setElementData(target, "adminJail.Time", tonumber(time))
					setElementData(target, "adminJail.OriginalTime", tonumber(time))

					setElementData(target, "cleaner:inJobInt", false)
					setElementData(target, "playerInClientsideJobInterior", false)
					setElementData(target, "pizza:isPlayerInInt", false)

					setElementPosition(target, 265.00698852539, 77.480758666992, 1001.0390625)
					setElementInterior(target, 6)
					setElementDimension(target, getElementData(target,"playerid")*100)

					setElementData(target, "adminJail.IsAdminJail", true)

					--triggerClientEvent(resourceRoot, "setPlayerAdminJail.Client",target,getElementData(player,"user:adminnick"),reason,time)

					outputChatBox(core:getServerPrefix("red-dark", "AdminJail", 3)..color..getElementData(player,"user:adminnick").." #ffffffbebörtönözte "..color..getPlayerName(target):gsub("_", " ").."#ffffff játékost.",root,255,255,255,true)
					outputChatBox(core:getServerPrefix("red-dark", "AdminJail", 3).."Indok: "..color..reason.." #ffffff| Idő: "..color..time.."#ffffff perc.",root,255,255,255,true)

					setElementData(player, "log:admincmd", {getElementData(target, "char:id"), cmd})

					local datas = getElementData(target, "dashboard:banKickJailCount") or {0, 0, 0}
					datas[3] = datas[3] + 1
					setElementData(target, "dashboard:banKickJailCount", datas)

					local playerStats = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
					playerStats[3] = playerStats[3] + 1

					setElementData(player, "user:adminDatas", playerStats)
				else
					outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."A játékos már adminjailben van!",player,255,255,255,true)
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."A percet számformátumban kell megadnod!",player,255,255,255,true)
			end
		else 
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos ID] [Idő (Perc)] [Indok]",player,r,g,b,true)
		end
	end
end
addCommandHandler("ajail",adminJail)
addCommandHandler("adminjail",adminJail)

function adminUnJail(player,cmd,target)
	if hasPermission(player,'unjail') then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then 
			target = core:getPlayerFromPartialName(player, target)
			if getElementData(target,"adminJail.IsAdminJail") then 
				if getElementData(target,"adminJail.JailerAdminLevel") <= getElementData(player, "user:admin") then 
					removePlayerFromAdminJail(target)
					triggerClientEvent(target,"removePlayerAdminJail.Client",target)
					removeElementData(target,"adminJail.Admin")
					removeElementData(target,"adminJail.Reason")
					removeElementData(target,"adminJail.Time")
					--outputChatBox(core:getServerPrefix("red-dark", "UnJail", 3)..color..getElementData(player,"user:adminnick").." #ffffffkiszedte a börtönből "..color..getPlayerName(target):gsub("_", " ").."#ffffff játékost.",root,255,255,255,true)
					sendMessageToAdmins(player, "kivette jailből "..nameColor..getPlayerName(target):gsub("_", " ")..adminMessageColor.." nevű játékost.")

					setElementData(player, "log:admincmd", {getElementData(target, "char:id"), cmd})

					local playerStats = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
					playerStats[5] = playerStats[5] + 1

					setElementData(player, "user:adminDatas", playerStats)
				else 
					outputChatBox(color.."Ezt a játékos nincs jogod kiszedni adminjailből!",player,255,255,255,true)
				end
			else 
				outputChatBox(color.."Ez a játékos nincs adminjailben!",player,255,255,255,true)
			end
		else 
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos ID]",player,r,g,b,true)
		end
	end
end
addCommandHandler("unjail", adminUnJail)

addCommandHandler("hideadmin", function(player, cmd)
	if hasPermission(player, "hideadmin") then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		local hadmin = getElementData(player, "user:hadmin")
		
		if not hadmin then
			setElementData(player, "user:hadmin", true) 
			outputChatBox(core:getServerPrefix("red-dark", "Hideadmin", 3) .. " Mostantól rejtett admin vagy!",player, 255, 255, 255,true)
		else
			setElementData(player, "user:hadmin", false) 
			outputChatBox(core:getServerPrefix("red-dark", "Hideadmin", 3) .. " Mostantól látható vagy!",player, 255, 255, 255,true)
		end
	end
end)

function removePlayerFromAdminJail(player)
	if isElement(player) then
		setElementData(player, "adminJail.IsAdminJail", false)
		setElementData(player, "adminJail.Admin", "n/a")
		setElementData(player, "adminJail.Reason", "n/a")
		setElementData(player, "adminJail.Time", 0)
		removeElementData(player,"adminJail.Admin")
		removeElementData(player,"adminJail.Reason")
		removeElementData(player,"adminJail.Time")
		setElementPosition(player, 1479.4847412109, -1722.7983398438, 13.546875)
		setElementInterior(player, 0)
		setElementDimension(player, 0)
	end
end

addEvent("playerRemoveFromAdminJail", true)
addEventHandler("playerRemoveFromAdminJail", root, removePlayerFromAdminJail)


addEvent("savePlayerAdminJailTime", true)
addEventHandler("savePlayerAdminJailTime", root,
	function(time)
		setElementData(client,"adminJail.Time",time)
	end 
)

addEventHandler("onResourceStart",resourceRoot,
	function()
		setTimer(function()
			for k,v in ipairs(getElementsByType("player")) do
				--setElementData(v, "adminJail.IsAdminJail", false)
				if getElementData(v, "adminJail.IsAdminJail") then 
					--outputChatBox(getElementData(v,"adminJail.Time"))
					if getElementData(v,"adminJail.Time") > 0 then 
						setElementData(v, "adminJail.IsAdminJail", true)
						triggerClientEvent(v, "showAjailInfos", v)
					else
						removePlayerFromAdminJail(v)
						print("source: oAdmin/a_admin.lua (onResourceStart)")

					end
				end
			end
		end,100,1)
	end 
)
---------------------------
-- / points / -- 
addEvent("points -> setPlayerPosition", true)
addEventHandler("points -> setPlayerPosition", resourceRoot, function(position)
	setElementPosition(client, position[1], position[2], position[3])
end)

addCommandHandler("aban", function(player, cmd, targetPlayer, duration, ...)
	duration = tonumber(duration)
	if hasPermission(player, cmd) then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if not (targetPlayer and duration and (...)) then 
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Játékos név / ID] [Óra | 0 örök] [Indok]", player, 255, 255, 255, true)
		else
			target = core:getPlayerFromPartialName(player, targetPlayer)
			if target then 
				if player ~= targetPlayer then 
					local targetSerial = getPlayerSerial(target)
					local playeradmin = getElementData(target, "user:admin") or 0 

					if playeradmin < getElementData(player, "user:admin") then
						if highRiskCMD[player] then outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Csak 1 percenként használhatod ezt a parancsot!", player, 255, 255, 255, true) return end

						local reason = table.concat({...}, " ")
						duration = math.floor(math.abs(duration))

						if getElementData(player, "user:admin") <= 4 then
							if duration > 24 or duration == 0 then
								outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."Maximum 1 napra tudsz bannolni!", player, 255, 255, 255, true)
								return
							end
						end

						local adminName = getElementData(player, "user:adminnick") 
						local playerUsername = getElementData(target, "user:name")
						local characterName = getElementData(target, "char:name"):gsub("_", " ")
						local accountId = getElementData(target, "user:id")

						local currentTime = getRealTime().timestamp
						local expireTime = currentTime

						if duration == 0 then
							expireTime = currentTime + 31536000 * 100
							durationName = "Örökre"
						else
							expireTime = currentTime + duration * 3600
							durationName = duration .. " órára"
						end
						dbQuery(function(qh)
							local result, numAffect = dbPoll(qh, 0)
							if numAffect > 0 then 
								outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."A kiválasztott játékos már bannolva van!", player, 255, 255, 255, true)
							else 
								dbQuery(function(qh, target)
									if isElement(target) then 
										kickPlayer(target, adminName, "Indok: "..reason .. " | Időtartam: "..durationName)
									end
									outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3)..color..getElementData(player, "user:adminnick").." #ffffffkitiltotta "..color..getPlayerName(target):gsub("_", " ").." #ffffffnevű játékost. ("..color.. durationName .."#ffffff)", root, 255, 255, 255, true)
									outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."Indok: "..color..reason, root, 255, 255, 255, true)
									dbFree(qh)
								end, {target}, conn, "INSERT INTO bans2 (playerSerial, playerName, playerAccountId, banReason, adminName, banTimestamp, expireTimestamp, isActive) VALUES (?,?,?,?,?,?,?,'Y'); UPDATE accounts SET suspended = 'Y' WHERE id = ?", targetSerial, playerUsername, accountId, reason, adminName, currentTime, expireTime, accountId)
							end
						end, conn, "SELECT * FROM bans2 WHERE playerSerial = ? AND isActive = 'Y' ", targetSerial)

						local datas = getElementData(target, "dashboard:banKickJailCount") or {0, 0, 0}
						datas[1] = datas[1] + 1
						setElementData(target, "dashboard:banKickJailCount", datas)

						setElementData(player, "log:admincmd", {getElementData(target, "char:id"), cmd})
						local playerStats = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
						playerStats[1] = playerStats[1] + 1

						highRiskCMD[player] = true;
						setTimer ( function()
							highRiskCMD[player] = false;
						end, 1000 * 60, 1 )

						setElementData(player, "user:adminDatas", playerStats)
					else 
						outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."Ezt a játékost nem tilthatod ki ugyanis magasabb rangú mint te!", player, 255, 255, 255, true)
						outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3)..color..getElementData(player, "user:adminnick").."#ffffff nevű adminisztrátor megpróbált kitiltani a szerverről.", target, 255, 255, 255, true)
					end
				else 
					outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."Magadat nem tilthatod ki a szerverről!", player, 255, 255, 255, true)
				end
			end
		end
	end
end)

addCommandHandler("aunban", function(player, cmd, targetData)
	if hasPermission(player, cmd) then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if not targetData then 
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [AccountId / Serial]", player, 255, 255, 255, true)
		else
			local adminNick = getElementData(player, "user:adminnick") 
			local unbanType = "playerAccountId"

			if tonumber(targetData) then 
				targetData = tonumber(targetData)
			elseif string.len(targetData) == 32 then 
				unbanType = "playerSerial"
			else
				return false
			end

			dbQuery(function(qh, player)
				local result, numAff = dbPoll(qh, 0)
				if numAff > 0 and result then 
					local accountId = false 
					for k,v in ipairs(result) do 
						if not accountId then 
							accountId = v.playerAccountId
						end
						dbExec(conn, "UPDATE bans2 SET isActive = 'N' WHERE banId = ?", v.banId)
					end
					dbExec(conn, "UPDATE accounts SET suspended = 'N' WHERE id = ?", accountId)
					if isElement(player) then 
						outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."Sikeresen feloldottad a kiválasztott játékosról a tiltást.", player, 255, 255, 255, true)
					end
				elseif isElement(player) then 
					outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."A kiválasztott Account ID-n nincs kitiltás!", player, 255, 255, 255, true)
				end
			end, {player}, conn, "SELECT * FROM bans2 WHERE ?? = ? AND isActive = 'Y'",unbanType, targetData)
		end
	end
end)

addCommandHandler("oban", function(player, cmd, targetPlayer, duration, ...)
	duration = tonumber(duration)
	if hasPermission(player,cmd) then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(player) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if not (targetPlayer and duration and (...)) then
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Név] [Óra | 0 = örök] [Indok]", player, 255, 255, 255, true)
		else 
			local adminNick = getElementData(player, "user:adminnick") 
			local reason = table.concat({...}, " ")
			duration = math.floor(math.abs(duration))

			local currentTime = getRealTime().timestamp
			local expireTime = currentTime

			if duration == 0 then
				expireTime = currentTime + 31536000 * 100
				durationName = "Örökre"
			else
				expireTime = currentTime + duration * 3600
				durationName = duration .. " órára"
			end
			
			targetPlayer = tostring(targetPlayer)
			if targetPlayer then 



				dbQuery(function(qh, accountId)
					local result, numAff = dbPoll(qh, 0)
					if numAff > 0 and result then 
						local accountId = false
						for k,v in ipairs(result) do 
							if not accountId then 
								accountId = v.account
							end
							dbQuery(function(qh, accountId)
								local result = dbPoll(qh, 0)
								if result then 
									local data = result[1]
									local allowedBans = true
									dbQuery(function(qh)
										local result, numAffect = dbPoll(qh, 0)
										if numAffect > 0 then 
											outputChatBox(core:getServerPrefix("red-dark", "Offline - Kitiltás", 3).."A kiválasztott játékos már bannolva van!", player, 255, 255, 255, true)
										else 
											dbExec(conn, "INSERT INTO bans2 (playerSerial, playerName, playerAccountId, banReason, adminName, banTimestamp, expireTimestamp, isActive) VALUES (?,?,?,?,?,?,?,'Y')",data.serial, data.username, accountId, reason, adminNick, currentTime, expireTime)
											outputChatBox(core:getServerPrefix("red-dark", "Offline - Kitiltás", 3)..color..getElementData(player, "user:adminnick").." #ffffffkitiltotta "..color..targetPlayer:gsub("_", " ").." #ffffffnevű játékost. ("..color.. durationName .."#ffffff)", root, 255, 255, 255, true)
											outputChatBox(core:getServerPrefix("red-dark", "Offline - Kitiltás", 3).."Indok: "..color..reason, root, 255, 255, 255, true)
											dbExec(conn, "UPDATE accounts SET suspended = 'N' WHERE id = ?", accountId)
											setElementData(player, "log:admincmd", {accountId, cmd})
											local playerStats = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
											playerStats[1] = playerStats[1] + 1
											setElementData(player, "user:adminDatas", playerStats)
										end
									end,conn, "SELECT * FROM bans2 WHERE playerSerial = ? AND isActive = 'Y'", data.serial)
								end
							end, {accountId},conn, "SELECT * FROM accounts WHERE id = ?", accountId)
						end
					else 
						outputChatBox(core:getServerPrefix("red-dark", "Offline - Kitiltás", 3).."Nincs ilyen játékos regisztrálva.", player, 255, 255, 255, true)
					end
				end,conn, "SELECT * FROM characters WHERE charname = ?", targetPlayer)
			end
		end
	end
end)

-- / ban cmds / --
--[[
function banPlayerFromPlayerId(player, cmd, target, year, month, day, ...)
    if hasPermission(player,'aban') then
		if tonumber(target) and tonumber(year) and tonumber(month) and tonumber(day) and ... then 
			target = core:getPlayerFromPartialName(player, target)
			reason = table.concat({...}, " ")

			if target then 
				local playeradmin = getElementData(target, "user:admin") or 0 

				if playeradmin < getElementData(player, "user:admin") then
					if highRiskCMD[player] then outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Csak 1 percenként használhatod ezt a parancsot!", player, 255, 255, 255, true) return end
					outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3)..color..getElementData(player, "user:adminnick").." #ffffffkitiltotta "..color..getPlayerName(target).." #ffffffnevű játékost.", root, 255, 255, 255, true)
					outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."Indok: "..color..reason, root, 255, 255, 255, true)

					local playerUsername = getElementData(target, "user:name")
					local playerUserId = getElementData(target, "user:id")
					local serial = getPlayerSerial(target)
					local adminName = getElementData(player, "user:adminnick") 

					local realtime = getRealTime()

					exports.oAccount:createBan(playerUsername, playerUserId, serial, adminName, year, month, day, realtime.hour, realtime.minute, realtime.second, reason)

					local datas = getElementData(target, "dashboard:banKickJailCount") or {0, 0, 0}
					datas[1] = datas[1] + 1
					setElementData(target, "dashboard:banKickJailCount", datas)

					setElementData(player, "log:admincmd", {getElementData(target, "char:id"), cmd})

					kickPlayer(target, "Ki lettél tiltva a szerverről!")

					
					local playerStats = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
					playerStats[1] = playerStats[1] + 1

	
					highRiskCMD[player] = true;
					setTimer ( function()
						highRiskCMD[player] = false;
					end, 1000 * 60, 1 )

	
					setElementData(player, "user:adminDatas", playerStats)
				else
					outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."Ezt a játékost nem tilthatod ki ugyanis magasabb rangú mint te!", player, 255, 255, 255, true)
					outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3)..color..getElementData(player, "user:adminnick").."#ffffff nevű adminisztrátor megpróbált kitiltani a szerverről.", target, 255, 255, 255, true)
				end
			end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Target ID] [Év] [Hónap] [Nap] [Indok] #c9140a(Az időpontokhoz pontos dátumot írj!)", player, 255, 255, 255, true)
        end
    end
end 
addCommandHandler("aban", banPlayerFromPlayerId)

function banPlayerFromPlayerId(player, cmd, target_name, year, month, day, ...)
    if hasPermission(player,'oban') then
		if tostring(target_name) and tonumber(year) and tonumber(month) and tonumber(day) and ... then 
			reason = table.concat({...}, " ")

			if target_name then 
				local adminName = getElementData(player, "user:adminnick") 

				local qh = dbQuery(conn, "SELECT * FROM characters")
				local result = dbPoll(qh, 250) or false

				if result then 
					for k, v in ipairs(result) do 
						if v["charname"] == target_name then 
							local accountID = v["account"]

							local qh2 = dbQuery(conn, "SELECT * FROM accounts")
							local result2 = dbPoll(qh2, 250) or false

							if result2 then 
								for k, v in ipairs(result2) do 
									if v["id"] == accountID then 
										local adminlevel = v["admin"]

										if adminlevel < getElementData(player, "user:admin") then 
											local username = v["username"]
											local serial = v["serial"]

											local realtime = getRealTime()

											exports.oAccount:createBan(username, accountID, serial, adminName, year, month, day, realtime.hour, realtime.minute, realtime.second, reason)

											outputChatBox(core:getServerPrefix("red-dark", "Offline - Kitiltás", 3)..color..getElementData(player, "user:adminnick").." #ffffffkitiltotta "..color..target_name:gsub("_", " ").." #ffffffnevű játékost.", root, 255, 255, 255, true)
											outputChatBox(core:getServerPrefix("red-dark", "Offline - Kitiltás", 3).."Indok: "..color..reason, root, 255, 255, 255, true)

											setElementData(player, "log:admincmd", {target_name, cmd})
										else
											outputChatBox(core:getServerPrefix("red-dark", "Kitiltás", 3).."Ezt a játékost nem tilthatod ki ugyanis magasabb rangú mint te!", player, 255, 255, 255, true)
										end
										break
									end
								end
							end

							break
						end
					end
				end
			end
        else
            outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Karakter Név] [Év] [Hónap] [Nap] [Indok] #c9140a(Az időpontokhoz pontos dátumot írj!)", player, 255, 255, 255, true)
        end
    end
end 
addCommandHandler("oban", banPlayerFromPlayerId)

function unbanPlayer(player, cmd, target_name)
	if hasPermission(player,'unban') then
		if target_name then 
			local adminName = getElementData(player, "user:adminnick") 

			local qh = dbQuery(conn, "SELECT * FROM bans")
			local result = dbPoll(qh, 250) or false

			if result then 
				local talalt = false
				for k, v in ipairs(result) do 
					if v["username"] == target_name then 
						talalt = true
						local alevel = getElementData(player, "user:admin") 

						if alevel >= 7 then 
							exports.oAccount:removeBan(v["id"])
							sendMessageToAdmins(player, "unbannolta "..nameColor..v["username"]..adminMessageColor.." nevű felhasználót.")
							setElementData(player, "log:admincmd", {target_name, cmd})

							local playerStats = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
							playerStats[4] = playerStats[4] + 1
			
							setElementData(player, "user:adminDatas", playerStats)
						else
							if v["admin"] == getElementData(player, "user:adminnick") then 
								exports.oAccount:removeBan(v["id"])
								sendMessageToAdmins(player, "unbannolta "..nameColor..v["username"]..adminMessageColor.." nevű felhasználót.")
								setElementData(player, "log:admincmd", {target_name, cmd})

								local playerStats = getElementData(player, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
								playerStats[4] = playerStats[4] + 1
				
								setElementData(player, "user:adminDatas", playerStats)
							else 
								outputChatBox(core:getServerPrefix("red-dark", "UbBan", 3).."Ezt a játékost nincs jogod unbannolni!", player, 255, 255, 255, true)
							end
						end
						break
					end
				end

				if not talalt then 
					outputChatBox(core:getServerPrefix("red-dark", "UbBan", 3).."Nincs ilyen felhasználónévvel bannolva egyetlen játékos sem!", player, 255, 255, 255, true)
				end
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Felhasználónév]", player, 255, 255, 255, true)
		end
	end

end
addCommandHandler("unban", unbanPlayer)]]

addCommandHandler("fixbones", function(thePlayer, cmd, target)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'fixbones') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			local target = core:getPlayerFromPartialName(thePlayer, target)
			if target then
				setElementData(target, "char:bones", {["head"] = 0, ["body"] = 0, ["l_leg"] = 0, ["r_leg"] = 0, ["r_arm"] = 0, ["l_arm"] = 0})

				outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffmeggyógyította a csontjaidat.", target, 255, 255, 255, true)
				sendMessageToAdmins(thePlayer, "meggyógyította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos csontjait. ")
				setElementData(thePlayer, "log:admincmd", {getElementData(target, "char:id"), cmd})
			end
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID]", thePlayer, r, g, b, true)
		end
	end
end)

addCommandHandler("ojail", function(thePlayer, cmd, charName, time, ...)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'ojail') then
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if charName and time and (...) then 

			local reason = table.concat({...}, " ")
			
			local qh = dbQuery(conn, "SELECT * FROM characters")
			local result = dbPoll(qh, 250) or false

			if result then 
				local talalt = false
				for k, v in ipairs(result) do 
					if v["charname"] == charName then 
						talalt = true
						if not fromJSON(v["adminJailDatas"])[1] then
							outputChatBox(core:getServerPrefix("red-dark", "OfflineJail", 3)..color..getElementData(thePlayer, "user:adminnick").." #ffffffbebörtönözte "..color..charName:gsub("_", " ").."#ffffff játékost.",root,255,255,255,true)
							outputChatBox(core:getServerPrefix("red-dark", "OfflineJail", 3).."Indok: "..color..reason.." #ffffff| Idő: "..color..time.."#ffffff perc.",root,255,255,255,true)

							dbExec(conn, "UPDATE characters SET adminJailDatas = ? WHERE id = ?", toJSON({true, reason, time, getElementData(thePlayer, "user:adminnick"), time, getElementData(thePlayer, "user:admin")}), v["id"])
						
							setElementData(thePlayer, "log:admincmd", {charName, cmd})

							local playerStats = getElementData(thePlayer, "user:adminDatas") or {0, 0, 0, 0, 0, 0, 0, 0}
							playerStats[3] = playerStats[3] + 1
			
							setElementData(thePlayer, "user:adminDatas", playerStats)
						else
							outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Ez a játékos már jailben van!", thePlayer, 255, 255, 255, true)
						end
						break
					end
				end

				if not talalt then 
					outputChatBox(core:getServerPrefix("red-dark", "Admin", 3).."Nem található ilyen névvel regisztrált karakter!", thePlayer, 255, 255, 255, true)
				end
			else
				outputChatBox(core:getServerPrefix("red-dark", "Admin", 2).."Nem létesíthető kapcsolat az adatbázissal! "..color.."(Keress fel egy fejlesztőt!) ", thePlayer, 255, 255, 255, true)
			end
		else
			outputChatBox(core:getServerPrefix("server", "Használat", 3).."/"..cmd.." [Játékos név] [Idő] [Indok]", thePlayer, 255, 255, 255, true)
		end
	end
end)


addCommandHandler("setvehoil", function(thePlayer, cmd, target,oil)
	if not isPlayerInAdminDuty(thePlayer) then return end
	if hasPermission(thePlayer,'setvehoil') then 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(thePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if target then
			if oil then 
				if tonumber(oil) then 
					local target = core:getPlayerFromPartialName(thePlayer, target)
					if target then
						local x, y, z = getElementPosition(target)
						local veh = getPedOccupiedVehicle(target)
					
						if veh then 
							outputChatBox(core:getServerPrefix("server", "Admin", 1)..color..getElementData(thePlayer, "user:adminnick").." #ffffffbeállította a járműved olajszintjét a következőre: "..color..""..oil..".", target, 255, 255, 255, true)
							sendMessageToAdmins(thePlayer, "beállította "..nameColor..getPlayerName(target)..adminMessageColor.." játékos autójának olajszintjét a következőre: "..oil..".")
							setElementData(veh, "veh:distanceToOilChange", oil)
							setElementData(veh,"oilLamp",false)

						else 
							outputChatBox(core:getServerPrefix("red-dark", "Admin", 2).."A játékos nincs autóban!", thePlayer, 255, 255, 255, true)
						end
					end
				else 
					outputChatBox(core:getServerPrefix("red-dark", "Admin", 2).."Csak számot adhatsz meg olajszintnek!", thePlayer, 255, 255, 255, true)
				end 
			else 
				outputChatBox(core:getServerPrefix("red-dark", "Admin", 2).."Adj meg olajszintet!", thePlayer, 255, 255, 255, true)
			end 
		else
			outputChatBox("[Használat]: #ffffff/"..cmd.." [Játékos név/ID] [Olajszint (Maximum 15000)]", thePlayer, r, g, b, true)
		end
	end
end)