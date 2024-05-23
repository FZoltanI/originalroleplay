local connection = exports.oMysql:getDBConnection() 
local core = exports.oCore
local admin = exports.oAdmin
local hex,r,g,b = core:getServerColor()
local rouletteTables = {}

local chipModels = {
	[1] = 1920,
	[5] = 1920,
	[25] = 1915,
	[50] = 1915,
	[100] = 1928,
	[500] = 1928,
	[1000] = 1923,
	[5000] = 1907,
	[10000] = 1907,
}

local blockPosition = {0.51, 0.425, -1.33, -0.299} -- minX, minY, maxX, maxY
local blockSizeX = (blockPosition[3] - blockPosition[1]) / 12
local blockSizeY = (blockPosition[4] - blockPosition[2]) / 3

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function getFieldRealCoord(x, y)
	return reMap(x, 301, 675, blockPosition[1] + blockSizeX / 2, blockPosition[3] - blockSizeX / 2), reMap(y, 48, 143, blockPosition[2] + blockSizeY / 2, blockPosition[4] - blockSizeY / 2)
end


addEventHandler("onResourceStart", getRootElement(),
	function (res)
		res = getResourceName ( res )
		if (res == 'oMysql') then 
			connection = exports.oMysql:getDBConnection() 
		--	print('export#db - Reload')
		elseif (res == 'oAdmin') then 
			admin = exports.oAdmin
		--	print('export#admin - Reload')
		elseif (res == 'oCore') then
			core = exports.oCore
		--	print('export#core - Reload')
		end
	end
)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		dbQuery(
			function (qh)
				local result = dbPoll(qh, 0)

				if result then
					for k, v in pairs(result) do
						loadRouletteTable(v.id, v)
					end
				end
			end,
		connection, "SELECT * FROM roulettes")
	end
)


addEvent("placeTheRouletteTable", true)
addEventHandler("placeTheRouletteTable", getRootElement(),
	function (dat)
		if not client then return end 
		if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(client) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

		if isElement(source) then
			sourcePlayer = client 
			if dat then

				dbExec(connection, "INSERT INTO roulettes (x, y, z, rz, interior, dimension) VALUES (?,?,?,?,?,?)", unpack(dat))
				dbQuery(
					function (qh, sourcePlayer)
						local result = dbPoll(qh, 0)[1]

						if result then
							loadRouletteTable(result.id, result, true)
							admin:sendMessageToAdmins(sourcePlayer, "létrehozott egy rulett asztalt. Itt: #db3535"..getElementZoneName(sourcePlayer).."#557ec9 (".."#db3535#"..result.id.."#557ec9)")
						end
					end,
				{source}, connection, "SELECT * FROM roulettes WHERE id = LAST_INSERT_ID()")
			end
		end
	end)

addCommandHandler("delroulette",
	function (sourcePlayer, commandName, tableId)
		if admin:hasPermission(sourcePlayer, commandName) then
			if not exports.oAnticheat:checkPlayerVerifiedAdminStatus(sourcePlayer) then return end -- ellenőrzi, hogy a játékos szerepel e a verified admin listában és ha nem akkor kickeli visszaélés miatt

			tableId = tonumber(tableId)

			if not tableId then
				outputChatBox(hex.."[Használat]: #ffffff/" .. commandName .. " [ID]", sourcePlayer, 255, 255, 255, true)
			else
				if rouletteTables[tableId] then
					if isElement(rouletteTables[tableId].element) then
						destroyElement(rouletteTables[tableId].element)
					end

					rouletteTables[tableId] = nil

					dbExec(connection, "DELETE FROM roulettes WHERE id = ?", tableId)
					admin:sendMessageToAdmins(sourcePlayer, "törölte a(z) #db3535"..tableId.."#557ec9-as/es ID-vel rendelkező rulett asztalt.")
				else
					outputChatBox(core:getServerPrefix('red-dark', 'Rulett', 3).."#ffffffNincs ilyen ID-vel rendelkező asztal!", sourcePlayer, 255, 255, 255, true)
				end
			end
		end
	end)

function triggerRouletteEvent(id, eventName, ...)
	local rouletteTable = rouletteTables[id]

	if rouletteTable then
		local players = {}

		for k, v in pairs(getElementsByType("player")) do
			local tableId = getElementData(v, "playerUsingRoulette")

			if id == tableId then
				table.insert(players, v)
			end
		end

		triggerClientEvent(players, eventName, resourceRoot, ...)

		return true
	end

	return false
end

addEventHandler("onPlayerClick", getRootElement(),
	function (button, state, clickedElement)
		if button == "right" and state == "up" then
			if clickedElement then
				local tableId = getElementData(clickedElement, "isRoulette") or 0

				if tableId > 0 then
					local rouletteTable = rouletteTables[tableId]

					if not getElementData(source, "playerUsingRoulette") then
						local playerX, playerY, playerZ = getElementPosition(source)
						local targetX, targetY, targetZ = getElementPosition(clickedElement)

						if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) < 2 then
							if math.abs(playerZ - targetZ) - 0.5 >= 0 then
								return
							end

							local playerRot = select(3, getElementRotation(source))
							local facingAngle = math.deg(math.atan2(targetY - playerY, targetX - playerX)) + 180 - playerRot

							if facingAngle < 0 then
								facingAngle = facingAngle + 360
							end

							if facingAngle < 180 then
								return
							end

							if rouletteTable.gameStage == 2 then
								--exports.see_hud:showInfobox(source, "e", "Várd meg a kör végét!")
								return
							end

							setPedAnimation(source, "CASINO", "Roulette_loop", -1, true, false, false, false)
							setElementData(source, "playerUsingRoulette", tableId)

							local num = getElementData(clickedElement, "theRouletteNum")

							triggerClientEvent(source, "openRouletteTable", source, tableId, clickedElement, num,
								rouletteTable.betsOnField,
								rouletteTable.betsHistory,
								rouletteTable.roundHistory,
								getRoundTime(rouletteTable)
							)
						end
					end
				end
			end
		end
	end)

addEvent("onPlayerExitRoulette", true)
addEventHandler("onPlayerExitRoulette", getRootElement(),
	function ()
		if isElement(source) then
			setPedAnimation(source, "CASINO", "Roulette_out", -1, false, false, false, false)
			setElementData(source, "playerUsingRoulette", false)
		end
	end)

function createChip(tableId, field, coin, charId)
	local rouletteTable = rouletteTables[tableId]

	if rouletteTable then
		local fieldX, fieldY = unpack(split(field, ","))

		fieldX = tonumber(fieldX)
		fieldY = tonumber(fieldY)

		if fieldX == 256 then
			fieldX = fieldX + 10
		end

		if fieldY == 221 then
			fieldY = fieldY + 15
		end

		fieldX, fieldY = getFieldRealCoord(fieldX, fieldY)

		if not rouletteTable.chipObjects[field] then
			rouletteTable.chipObjects[field] = {}
		end

		local id = #rouletteTable.chipObjects[field]

		local x, y, z = getElementPosition(rouletteTable.element)
		local rz = select(3, getElementRotation(rouletteTable.element))

		local x2, y2 = rotateAround(rz, fieldY, fieldX)
		local obj = createObject(chipModels[coin], x + x2 + 0.05, y + y2 - 0.05, z - 0.175 + id * 0.0105, 0, 0, math.random(360))

		setObjectScale(obj, 1.8)
		setElementInterior(obj, getElementInterior(rouletteTable.element))
		setElementDimension(obj, getElementDimension(rouletteTable.element))

		table.insert(rouletteTable.chipObjects[field], {obj, charId})
	end
end

function loadRouletteTable(id, data)
	--print("loaded")
	local obj = createObject(1978, data.x, data.y, data.z-0.3, 0, 0, data.rz)
	setElementCollisionsEnabled(obj,false)
	setTimer(function()
		setElementCollisionsEnabled(obj,true)
	end,2000,1)

	setElementInterior(obj, data.interior)
	setElementDimension(obj, data.dimension)
	setElementData(obj, "isRoulette", id)

	rouletteTables[id] = {}
	rouletteTables[id].element = obj
	rouletteTables[id].betsOnField = {}
	rouletteTables[id].betsHistory = {}
	rouletteTables[id].roundHistory = {}
	rouletteTables[id].gameStage = 0
	rouletteTables[id].roundTimer = false
	rouletteTables[id].spinTimer = false
	rouletteTables[id].chipObjects = {}
end


function pickWinningNumber(tableId)
	local rouletteTable = rouletteTables[tableId]

	if rouletteTable then
		if rouletteTable.forceChance then
			rouletteTable.gameStage = 2

			local oldNum = getElementData(rouletteTable.element, "theRouletteNum") or getRealTime().monthday
			local newNum = rouletteTable.forceChance

			setElementData(rouletteTable.element, "theRouletteNum", newNum)

			triggerRouletteEvent(tableId, "interpolateTheRouletteBall", oldNum, newNum)

			triggerClientEvent(rouletteTable.element, "onRouletteWheelSound", rouletteTable.element)

			rouletteTable.spinTimer = setTimer(finishTheRound, 10000, 1, tableId)
			rouletteTable.forceChance = false
		else
			rouletteTable.gameStage = 2

			local oldNum = getElementData(rouletteTable.element, "theRouletteNum") or getRealTime().monthday
			local newNum = wheelNumbers[math.random(#wheelNumbers)]

			setElementData(rouletteTable.element, "theRouletteNum", newNum)

			triggerRouletteEvent(tableId, "interpolateTheRouletteBall", oldNum, newNum)

			triggerClientEvent(rouletteTable.element, "onRouletteWheelSound", rouletteTable.element)

			rouletteTable.spinTimer = setTimer(finishTheRound, 10000, 1, tableId)
		end
	end
end

function getChance(player,cmd,tableid, num)
	if admin:isPlayerDeveloper(player) then
		local rouletteTable = rouletteTables[tonumber(tableid)]

		if rouletteTable then
			rouletteTable.forceChance = tonumber(num)
			outputChatBox('#7cc576[Roulette]: #ffffffA következő nyerőszám: '..num,player,255,255,255,true)
		else
			outputChatBox('nincs ilyen idju asztal',player)
		end
	end
end
addCommandHandler("getchance", getChance)


addEvent("placeRouletteBet", true)
addEventHandler("placeRouletteBet", getRootElement(),
	function (field, datas, players)
		if isElement(source) then
			local playerX, playerY, playerZ = getElementPosition(source)
			local tableId = getElementData(source, "playerUsingRoulette")

			if tableId then
				local fieldNumbers, fieldName, priceMultipler, betAmount = datas[1], datas[2], datas[4], datas[6]
				local rouletteTable = rouletteTables[tableId]

				if rouletteTable then
					local myCharId = getElementData(source, "char:id")
					local myCharName = getElementData(source, "char:name"):gsub("_", " ")

					if rouletteTable.gameStage == 0 then
						rouletteTable.gameStage = 1
						rouletteTable.roundTimer = setTimer(pickWinningNumber, interactionTime, 1, tableId)
						rouletteTable.betsOnField = {}

						table.insert(rouletteTable.betsHistory, "new")
						table.insert(rouletteTable.roundHistory, 1, "#737373-- Új kör kezdődött --")
					end

					if not rouletteTable.betsOnField[field] then
						rouletteTable.betsOnField[field] = {}
					end

					table.insert(rouletteTable.betsOnField[field], {betAmount, source})

					local myLastBet = false


					for i = #rouletteTable.betsHistory, 1, -1 do
						local dat = rouletteTable.betsHistory[i]

						if dat ~= "new" then
							if dat[1] == field and dat[4] and dat[4] == myCharId then
								myLastBet = i
								break
							end
						end
					end

					local bet = betAmount

					if myLastBet then
						bet = bet + rouletteTable.betsHistory[myLastBet][3]
						table.remove(rouletteTable.betsHistory, myLastBet)
					end

					table.insert(rouletteTable.betsHistory, {field, fieldName, bet, myCharId, myCharName, fieldNumbers, priceMultipler + 1, source})

					local currentBalance = getElementData(source, "char:cc") or 0

					if currentBalance - betAmount >= 0 then
						setElementData(source, "char:cc", currentBalance - betAmount)
					else
						setElementData(source, "char:cc", 0)
					end

					triggerRouletteEvent(tableId, "onPlayerRouletteRefresh", rouletteTable.betsOnField, rouletteTable.betsHistory, rouletteTable.roundHistory, getRoundTime(rouletteTable),true)
					triggerClientEvent(players, "chipSound", source, playerX, playerY, playerZ, math.random(3))

					setPedAnimation(source, "CASINO", "Roulette_bet", -1, false, false, false, false)
					setTimer(setPedAnimation, 1275, 1, source, "CASINO", "Roulette_loop", -1, true, false, false, false)

					createChip(tableId, field, betAmount, myCharId)
				end
			end
		end
	end)

addEvent("removeRouletteBet", true)
addEventHandler("removeRouletteBet", getRootElement(),
	function (field)
		if isElement(source) then
			local tableId = getElementData(source, "playerUsingRoulette")

			if tableId then
				local rouletteTable = rouletteTables[tableId]

				if rouletteTable then
					local myCharId = getElementData(source, "char:id")

					if not rouletteTable.spinTimer then
						local creditAll = 0

						if rouletteTable.betsOnField[field] then
							local temp = {}

							for i = 1, #rouletteTable.betsOnField[field] do
								local dat = rouletteTable.betsOnField[field][i]

								if dat[2] ~= source then
									table.insert(temp, 1, dat)
								else
									creditAll = creditAll + dat[1]
								end
							end

							rouletteTable.betsOnField[field] = temp
						end

						setElementData(source, "char:cc", (getElementData(source, "char:cc") or 0) + creditAll)

						local temp = {}

						for i = #rouletteTable.betsHistory, 1, -1 do
							local dat = rouletteTable.betsHistory[i]

							if dat ~= "new" then
								if dat[1] ~= field or dat[4] ~= myCharId then
									table.insert(temp, 1, dat)
								end
							else
								table.insert(temp, 1, dat)
							end
						end

						rouletteTable.betsHistory = temp

						triggerRouletteEvent(tableId, "onPlayerRouletteRefresh", rouletteTable.betsOnField, rouletteTable.betsHistory, rouletteTable.roundHistory, getRoundTime(rouletteTable))
						triggerClientEvent(source, "onRouletteBetRemoved", source)

						if rouletteTable.chipObjects[field] then
							local temp = {}

							for i = 1, #rouletteTable.chipObjects[field] do
								local dat = rouletteTable.chipObjects[field][i]

								if dat[2] ~= myCharId then
									table.insert(temp, 1, dat)
								else
									if isElement(dat[1]) then
										destroyElement(dat[1])
									end
								end
							end

							local z = select(3, getElementPosition(rouletteTable.element))
						
							for i = 1, #temp do
								local obj = temp[i][1]
								local x, y = getElementPosition(obj)

								setElementPosition(obj, x, y, z - 0.175 + (i - 1) * 0.0105)
							end

							rouletteTable.chipObjects[field] = temp
						end
					end
				end
			end
		end
	end)

function getRoundTime(rouletteTable)
	local time = false

	if isTimer(rouletteTable.roundTimer) then
		time = getTimerDetails(rouletteTable.roundTimer) - interactionTime
	end

	return time
end

function payoutTheWinners(tableId)
	local rouletteTable = rouletteTables[tableId]

	if rouletteTable then
		local winningNumber = getElementData(rouletteTable.element, "theRouletteNum")
		local winnersTable = {}
		local winners = 0

		for i = #rouletteTable.betsHistory, 1, -1 do
			local dat = rouletteTable.betsHistory[i]

			if dat ~= "new" and dat[4] then
				local field, credit, charId, fieldNumbers, priceMultipler = dat[2], dat[3], dat[4], dat[6], dat[7]
				local win = false
				if string.find(field, "straight") then
					if tonumber(string.sub(field, 10)) == winningNumber then
						win = true
					end
				else
					for i = 1, #fieldNumbers do
						if tonumber(fieldNumbers[i]) == winningNumber then
							win = true
							break
						end
					end
				end

				if not winnersTable[charId] then
					winnersTable[charId] = {0, dat[5], dat[8], 0}
				end

				if win then
					winnersTable[charId][1] = winnersTable[charId][1] + credit * priceMultipler
				else
					winnersTable[charId][4] = winnersTable[charId][4] + credit
				end

				dat[4] = nil
			end
		end

		for charId, data in pairs(winnersTable) do
			--print(data[1])
			if data[1] > 0 then
				table.insert(rouletteTable.roundHistory, 1, "#e58904" .. data[2] .. " nyereménye: " .. data[1] .. " CC")
				winners = winners + 1
			end

			if isElement(data[3]) then
				setElementData(data[3], "char:cc", (getElementData(data[3], "char:cc") or 0) + data[1])

				if data[1] > data[4] then
					setPedAnimation(data[3], "CASINO", "Roulette_win", -1, false, false, false, false)
					setElementData(data[3], "playerIcons", {"plus", data[1]})
				else
					setPedAnimation(data[3], "CASINO", "Roulette_lose", -1, false, false, false, false)
					setElementData(data[3], "playerIcons", {"minus", data[4]})
				end

				setTimer(setPedAnimation, 2000, 1, data[3], "CASINO", "Roulette_loop", -1, true, false, false, false)
			end
		end

		if winners == 0 then
			table.insert(rouletteTable.roundHistory, 1, "#e58904Ebben a körben nem nyert senki.")
		end
		triggerClientEvent(getRootElement(), "sendLastWinning", getRootElement(), winningNumber,tableId)
	end
end

function finishTheRound(tableId)
	local rouletteTable = rouletteTables[tableId]

	if rouletteTable then
		payoutTheWinners(tableId)

		rouletteTable.gameStage = 0
		rouletteTable.betsOnField = {}

		if isTimer(rouletteTable.roundTimer) then
			killTimer(rouletteTable.roundTimer)
		end

		rouletteTable.roundTimer = nil

		if isTimer(rouletteTable.spinTimer) then
			killTimer(rouletteTable.spinTimer)
		end

		rouletteTable.spinTimer = nil

		local temp = {}

		for i = #rouletteTable.roundHistory, 1, -1 do
			if i > #rouletteTable.roundHistory - 11 then
				table.insert(temp, 1, rouletteTable.roundHistory[i])
			end
		end

		rouletteTable.roundHistory = temp

		local temp = {}

		for i = #rouletteTable.betsHistory, 1, -1 do
			local dat = rouletteTable.betsHistory[i]

			if i > #rouletteTable.betsHistory - 11 then
				table.insert(temp, 1, dat)
			end
		end

		rouletteTable.betsHistory = temp

		triggerRouletteEvent(tableId, "onPlayerRouletteRefresh", rouletteTable.betsOnField, rouletteTable.betsHistory, rouletteTable.roundHistory, getRoundTime(rouletteTable))

		for field, data in pairs(rouletteTable.chipObjects) do
			for i = 1, #data do
				if isElement(data[i][1]) then
					destroyElement(data[i][1])
				end
			end

			rouletteTable.chipObjects[field] = nil
		end

		rouletteTable.chipObjects = {}
	end
end

addEventHandler("onElementDestroy", getRootElement(),
	function ()
		if getElementModel(source) == 1978 then
			local tableId = getElementData(source, "isRoulette")

			if tableId then
				local rouletteTable = rouletteTables[tableId]

				if rouletteTable then
					if isTimer(rouletteTable.roundTimer) then
						killTimer(rouletteTable.roundTimer)
					end

					if isTimer(rouletteTable.spinTimer) then
						killTimer(rouletteTable.spinTimer)
					end

					for field, data in pairs(rouletteTable.chipObjects) do
						for i = 1, #data do
							if isElement(data[i][1]) then
								destroyElement(data[i][1])
							end
						end

						rouletteTable.chipObjects[field] = nil
					end

					rouletteTable = nil
				end
			end			
		end
	end)