adminSerials = {
	["52E602241DC69E45929DF7CA9DCDDE54"] = "Carlos",
	["A106718E8295717F198A146B8EC62DB3"] = "Carlos2",
	["E2582905A1146DE0D09B6C6C406772B2"] = "Aron",
	["6DADFF0244F50876A5E91D989ADBEE02"] = "Aronlorinczke",
	["3C4EDBBC959CD9DBFF7E4E35F46B94B2"] = "Paul",
	["10D1C517DCD4E19401F635E6DB9D93F4"] = "PaulLaptop",
	--["A8D6BA2E6A0FE86203A10DEEA851BBA2"] = "fasz",
	["FCF1E89E7894C8C58287D9B121B978B2"] = "kondor",
	--["A51AEA488C429FDF52385CC085F80134"] = "keiichi",

	--['FADD74F89263F9BEE73931EDAFB178A1'] = 'Dani',

}

adminPrefixs = {
	[0] = "Játékos",
	[1] = "AdminSegéd",
	[2] = "Admin 1",
	[3] = "Admin 2",
	[4] = "Admin 3",
	[5] = "Admin 4",
	[6] = "Admin 5",
	[7] = "FőAdmin",
	[8] = "AdminController",
	[9] = "Server Manager",
	[10] = "Fejlesztő",
	[11] = "Tulajdonos",
}

adminColors = {
    [0] = "#f7931e",
    [1] = "#f7931e",
    [2] = "#f7931e",
    [3] = "#f7931e",
    [4] = "#f7931e",
    [5] = "#f7931e",
    [6] = "#f7931e",
    [7] = "#ae61e8",
    [8] = "#72b55e",
    [9] = "#ffbb5b",
    [10] = "#5db2f7",
    [11] = "#f44141",
}

function isPlayerDeveloper(player)
	if adminSerials[getPlayerSerial(player)] then
		return true
	end
	return false
end

function getAdminPrefix(rankNum)
	return adminPrefixs[rankNum]
end

function getAdminColor(rankNum)
	return adminColors[rankNum]
end

function getPlayerAdminLevel(player)
	if adminSerials[getPlayerSerial(player)] then
		return 10
	end
	return getElementData(player, "user:admin") or 0
end

function isPlayerInAdminDuty(player)
	if getPlayerAdminLevel(player) > 6 then
		return true
	end
	return getElementData(player, "user:aduty") or false
end

function playerHasPermission(player, level, needHighLevel)
	if not player then return end
	if not needHighLevel then needHighLevel = false end
	if not level then level = 2 end

	if needHighLevel then
		if adminSerials[getPlayerSerial(player)] then
			return true
		else
			return false
		end
	else
		if getPlayerAdminLevel(player) >= 8 then
			return true
		elseif isPlayerInAdminDuty(player) then
			return true
		else
			return false
		end
	end
end

function getAdminNick(player)
	return getElementData(player, "user:adminnick")
end

nameColor = "#db3535"
adminMessageColor = "#557ec9"
adminMessagePrefixColor = "#276ce3"
core = exports.oCore
serverName = core:getServerName() or "Szerver"
color, r, g, b = core:getServerColor()
serverColor = core:getServerColor()
