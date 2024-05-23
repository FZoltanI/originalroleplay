local screenX, screenY = guiGetScreenSize()
local core = exports.oCore
local admin = exports.oAdmin
local hex,r,g,b = core:getServerColor()

addEventHandler("onClientResourceStart", getRootElement(),
	function (res)
		res = getResourceName ( res )
		if (res == 'oAdmin') then 
			admin = exports.oAdmin
		--	print('export#admin - Reload')
		elseif (res == 'oCore') then
			core = exports.oCore
		--	print('export#core - Reload')
		end

	end
)

addEventHandler("onClientResourceStart", resourceRoot,function()

	removeWorldModel(1978,10,1961.1568603516,1018.0036621094,992.46875)

	local CasinoCar = createVehicle(451,1993.3392822266,1017.6640991211,994.63747558594,0,0, 269.54626464844,"F40")
	setVehicleDamageProof(CasinoCar,false)
	setVehicleLocked(CasinoCar,true)
	setVehicleColor(CasinoCar,255,242,0)
	setElementDimension(CasinoCar,833)
	setElementInterior(CasinoCar,10)
	setElementFrozen(CasinoCar,true)

end)

coincolor = {
	[1] = {120,120,120},
	[5] = {120,120,120},
	[25] = {168,61,61},
	[50] = {168,61,61},
	[100] = {73,160,56},
	[500] = {73,160,56},
	[1000] = {50,113,173},
	[5000] = {173,109,58},
	[10000] = {188,184,61},
} 

--[[ eredeti
	[1] = {120,120,120},
	[5] = {120,120,120},
	[25] = {168,61,61},
	[50] = {168,61,61},
	[100] = {73,160,56},
	[500] = {73,160,56},
	[1000] = {50,113,173},
	[5000] = {173,109,58},
	[10000] = {188,184,61},

]]


function reMap(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function respc(num)
    return num
end

local placedTable = false

addCommandHandler("createroulette",
	function (commandName)
		if admin:hasPermission(localPlayer, commandName) then
			if not placedTable then
				if isElement(placedTable) then
					destroyElement(placedTable)
				end

				placedTable = createObject(1978, 0, 0, 0)

				setElementCollisionsEnabled(placedTable, false)
				setElementAlpha(placedTable, 175)
				setElementInterior(placedTable, getElementInterior(localPlayer))
				setElementDimension(placedTable, getElementDimension(localPlayer))

				addEventHandler("onClientRender", getRootElement(), tablePlaceRender)
				addEventHandler("onClientKey", getRootElement(), tablePlaceKey)

				outputChatBox("#e58904[Original - Rulett]: #ffffffRulett asztal létrehozás mód #e58904bekapcsolva!", 255, 255, 255, true)
				outputChatBox("#e58904[Original - Rulett]: #ffffffAz asztal #e58904lerakásához #ffffffnyomd meg az #e58904BAL CTRL #ffffffgombot.", 255, 255, 255, true)
				outputChatBox("#e58904[Original - Rulett]: #ffffffA #d75959kilépéshez #ffffffírd be a #d75959/" .. commandName .. " #ffffffparancsot.", 255, 255, 255, true)
			else
				removeEventHandler("onClientRender", getRootElement(), tablePlaceRender)
				removeEventHandler("onClientKey", getRootElement(), tablePlaceKey)

				if isElement(placedTable) then
					destroyElement(placedTable)
				end
				placedTable = nil

				outputChatBox("#e58904[Original - Rulett]: #ffffffRulett asztal létrehozás mód #d75959kikapcsolva!", 255, 255, 255, true)
			end
		end
	end)

function tablePlaceRender()
	if placedTable then
		local x, y, z = getElementPosition(localPlayer)
		local rz = select(3, getElementRotation(localPlayer))
		
		setElementPosition(placedTable, x, y, z + 0.075)
		setElementRotation(placedTable, 0, 0, rz + 90)
	end
end

function tablePlaceKey(button, state)
	if isElement(placedTable) then
		if button == "lctrl" and state then
			local x, y, z = getElementPosition(placedTable)
			local rz = select(3, getElementRotation(placedTable))
			local interior = getElementInterior(placedTable)
			local dimension = getElementDimension(placedTable)
			triggerServerEvent("placeTheRouletteTable", localPlayer, {x, y, z+ 0.125, rz, interior, dimension})

			if isElement(placedTable) then
				destroyElement(placedTable)
			end
			placedTable = nil

			removeEventHandler("onClientRender", getRootElement(), tablePlaceRender)
			removeEventHandler("onClientKey", getRootElement(), tablePlaceKey)
		end
	end
end

addCommandHandler("nearbyroulette",
	function (commandName, maxDistance)
		if admin:hasPermission(localPlayer,commandName) then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local nearbyList = {}

			maxDistance = tonumber(maxDistance) or 15

			for i, v in ipairs(getElementsByType("object", resourceRoot, true)) do
				local tableId = getElementData(v, "isRoulette")

				if tableId then
					local targetX, targetY, targetZ = getElementPosition(v)
					local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ)

					if distance <= maxDistance then
						table.insert(nearbyList, {tableId, distance})
					end
				end
			end

			if #nearbyList > 0 then
				outputChatBox(core:getServerPrefix('server', 'Rulett', 3).."#ffffffKözeledben lévő asztalok (" .. maxDistance .. " yard):", 255, 255, 255, true)

				for i, v in ipairs(nearbyList) do
					outputChatBox("    * #e58904Azonosító: #ffffff" .. v[1] .. " - " .. math.floor(v[2] * 1000) / 1000 .. " yard", 255, 255, 255, true)
				end
			else
				outputChatBox(core:getServerPrefix('red-dark', 'Rulett', 3).."#ffffffNincs egyetlen asztal sem a közeledben.", 255, 255, 255, true)
			end
		end
	end)

local rouletteEffects = {}
local defaultWheelNum = getRealTime().monthday

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if getElementData(localPlayer, "playerUsingRoulette") then
			setElementData(localPlayer, "playerUsingRoulette", false)
		end
	end)

addEventHandler("onClientElementStreamIn", getResourceRootElement(),
	function ()
		local tableId = getElementData(source, "isRoulette")

		if tableId then
			processRouletteEffects(source)
		end
	end)

addEventHandler("onClientElementStreamOut", getResourceRootElement(),
	function ()
		if rouletteEffects[source] then
			for k, v in pairs(rouletteEffects[source]) do
				if isElement(v) then
					destroyElement(v)
				end
			end

			rouletteEffects[source] = nil
		end
	end)

addEventHandler("onClientElementDestroy", getResourceRootElement(),
	function ()
		if rouletteEffects[source] then
			for k, v in pairs(rouletteEffects[source]) do
				if isElement(v) then
					destroyElement(v)
				end
			end

			rouletteEffects[source] = nil
		end
	end)

function processRouletteEffects(element)
	local tableX, tableY, tableZ = getElementPosition(element)
	local tableRotation = select(3, getElementRotation(element))
	local tableInterior = getElementInterior(element)
	local tableDimension = getElementDimension(element)

	rouletteEffects[element] = {}

	local x, y = rotateAround(tableRotation, -0.195, 1.35)
	local obj = createObject(1979, tableX + x, tableY + y, tableZ - 0.025, 0, 0, tableRotation)

	setElementInterior(obj, tableInterior)
	setElementDimension(obj, tableDimension)
	setElementDoubleSided(obj, true)

	rouletteEffects[element].wheel = obj

	local obj = createObject(3003, tableX + x, tableY + y, tableZ + 0.05, 0, 0, tableRotation)

	setElementInterior(obj, tableInterior)
	setElementDimension(obj, tableDimension)
	setObjectScale(obj, 0.4)
	setElementCollisionsEnabled(obj, false)

	rouletteEffects[element].ball = obj

	local x, y = rotateAround(tableRotation, 1.55, 1.5)
	local ped = createPed(172, tableX + x, tableY + y, tableZ, tableRotation + 90)

	setElementInterior(ped, tableInterior)
	setElementDimension(ped, tableDimension)
	setElementCollidableWith(ped, element, false)
	setTimer(isSetElementFrozen, 1500, 1, ped, true)
	setTimer(isSetPedAnimation, 1750, 1, ped, "CASINO", "Roulette_loop", -1, true, false, false, false)
	
	setElementData(ped, "ped:name", "Rulett")
	setElementData(ped, "invulnerable", true)

	rouletteEffects[element].ped = ped

	local num = getElementData(element, "theRouletteNum")

	if not num then
		num = defaultWheelNum
	end

	rouletteEffects[element].interpolation = {wheelNumbers[num] * degPerNum, num}
end

function isSetElementFrozen(element, state)
	if isElement(element) then
		setElementFrozen(element, state)
	end
end

function isSetPedAnimation(element, ...)
	if isElement(element) then
		setPedAnimation(element, ...)
	end
end
local playerIcons = {}
addEventHandler("onClientRender", getRootElement(),
	function ()
		--if getPlayerName ( localPlayer ) == 'Jack' then
		--	dxDrawImage(screenX/2,screenY/2,screenX/2,screenY/2,'files/orprulett.png')
		--end
	


		local now = getTickCount()
		local rot = -now / 50

		for k, v in pairs(rouletteEffects) do
			setElementRotation(v.wheel, 0, 0, rot)

			if v.interpolation then
				local wheelX, wheelY, wheelZ = getElementPosition(v.wheel)
				local wheelRot = select(3, getElementRotation(v.wheel))

				wheelRot = wheelRot - 135

				local angle = 0
				local x, z = 0, 0

				if tonumber(v.interpolation[1]) then
					angle = wheelRot - v.interpolation[1]
				else
					local elapsedTime = now - v.interpolation[2]
					local progress = interpolateBetween(0, 0, 0, 1, 0, 0, elapsedTime / 10000, "InOutQuad")

					angle = interpolateBetween(wheelRot - v.interpolation[3], 0, 0, wheelRot - v.interpolation[4], 0, 0, progress, "OutBack", 0.3, 1, 2)

					local progress = (elapsedTime - 5000) / 3500
					local progress2 = 0

					if progress > 0 then
						progress2 = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "InOutQuad")
					end

					x, z = interpolateBetween(0.15, 0.075, 0, 0.025, 0.025, 0, progress2, "OutBack", 0.3, 1, 4)

					local progress = (elapsedTime - 8000) / 500
					if progress > 0 then
						x, z = interpolateBetween(0.025, 0.025, 0, 0, 0, 0, progress, "Linear")
					end

					if progress >= 5 then
						rouletteEffects[k].interpolation = {v.interpolation[4], v.interpolation[5]}
					end
				end

				local rotatedX, rotatedY = rotateAround(angle, -0.23 - x, 0)

				setElementPosition(v.ball, wheelX + rotatedX, wheelY + rotatedY, wheelZ - 0.055 + z)
			end
		end
	end)

local mySlotCoins = 0
local myCharId = false

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if source == localPlayer then
			if dataName == "char:cc" then
				mySlotCoins = getElementData(source, dataName) or 0
			end
		end

		if dataName == "theRouletteNum" then
			if isElementStreamedIn(source) then
				local theNumber = getElementData(source, "theRouletteNum")
				local oldNumber = 0

				if rouletteEffects[source] and rouletteEffects[source].interpolation then
					oldNumber = rouletteEffects[source].interpolation[2] or 0
				end
			
				rouletteEffects[source].interpolation = {true, getTickCount(), wheelNumbers[oldNumber] * degPerNum, wheelNumbers[theNumber] * degPerNum - 1080, theNumber}
			end
		elseif dataName == "playerIcons" and source == localPlayer then
			local dat = getElementData(source, dataName)
			playerIcons[source] = {dat[1], getTickCount()}
		end
	end)

local tableWidth = 734
local tableHeight = 268

local chipSize = 24
local chipPotSize = respc(32)

local panelWidth = tableWidth + respc(10)
local panelHeight = tableHeight + respc(50) + chipPotSize + respc(204)
local panelPosX = screenX / 2 - panelWidth / 2
local panelPosY = screenY / 2 - panelHeight / 2

local draggingPanel = false
local movedChip = false

local standingTableId = false
local standingTableObj = false

local cantExitNotiState = false
local ballInterpolation = false

local Roboto = false
local gtaFont = false
local tooltipFont = false

local timeLeft = false
local havePlacedBets = false
local latestWinNumber = {} 

local availableCoins = {
	--[9] = 10000,
	--[8] = 5000,
	--[7] = 1000, 
	[6] = 500,
	[5] = 100,
	[4] = 50,
	[3] = 25, 
	[2] = 5, 
	[1] = 1,
}

local blockPosition = {respc(270), respc(25), respc(692), respc(170)} -- startX, startY, endX, endY
local blockSizeX = (blockPosition[3] - blockPosition[1]) / 12
local blockSizeY = (blockPosition[4] - blockPosition[2]) / 3

local fieldPositions = {
	{"0", respc(240), blockPosition[2]+3, respc(30), respc(130)},

	{"1st12", blockPosition[1], blockPosition[4] + respc(0.5), blockSizeX * 4, respc(36)},
	{"2nd12", blockPosition[1] + blockSizeX * 4, blockPosition[4] + respc(0.5), blockSizeX * 4, respc(36)},
	{"3rd12", blockPosition[1] + blockSizeX * 8, blockPosition[4] + respc(0.5), blockSizeX * 4, respc(36)},

	{"1-18", blockPosition[1], blockPosition[4] + respc(37), blockSizeX * 2, respc(35)},
	{"even", blockPosition[1] + blockSizeX * 2, blockPosition[4] + respc(37), blockSizeX * 2, respc(35)},
	{"red", blockPosition[1] + blockSizeX * 4, blockPosition[4] + respc(37), blockSizeX * 2, respc(35)},
	{"black", blockPosition[1] + blockSizeX * 6, blockPosition[4] + respc(37), blockSizeX * 2, respc(35)},
	{"odd", blockPosition[1] + blockSizeX * 8, blockPosition[4] + respc(37), blockSizeX * 2, respc(35)},
	{"19-36", blockPosition[1] + blockSizeX * 10, blockPosition[4] + respc(37), blockSizeX * 2, respc(35)},

	{"2to3", blockPosition[3], blockPosition[2], blockSizeX, blockSizeY},
	{"2to2", blockPosition[3], blockPosition[2] + blockSizeY, blockSizeX, blockSizeY},
	{"2to1", blockPosition[3], blockPosition[2] + blockSizeY * 2, blockSizeX, blockSizeY}
}

for i = 0, 12 * 3 - 1 do
	local x = math.floor(i / 3)
	local y = i % 3

	table.insert(fieldPositions, {
		tostring(x * 3 + (3 - y)),
		blockPosition[1] + blockSizeX * x,
		blockPosition[2] + blockSizeY * y,
		blockSizeX,
		blockSizeY
	})
end

local hoverFields = {}
local hoverFieldDatas = {}

local topBets = {}
local allBets = {}
local myBets = {}

local clickTick = 0
local activeBetField = false
local betRemovingProcess = false

local betsHistory = ""
local roundHistory = ""

addEvent("openRouletteTable", true)
addEventHandler("openRouletteTable", getRootElement(),
	function (tableId, element, theNumber, fieldBets, actions, history, roundTime)
		if core:getNetworkConnection() then 
			if not theNumber then
				theNumber = defaultWheelNum
			end
			rouletteShow = true
			standingTableId = tableId
			standingTableObj = element
			ballInterpolation = {0, wheelNumbers[theNumber] * degPerNum, wheelNumbers[theNumber] * degPerNum - 1080, theNumber}

			Roboto = dxCreateFont("files/Roboto.ttf", respc(14), false, "antialiased")
			RobotoLight = dxCreateFont("files/Roboto-Light.ttf", respc(13), false, "antialiased")
			RobotoBlack = dxCreateFont("files/Roboto-Black.ttf", respc(20), false, "antialiased")

			gtaFont = dxCreateFont("files/gtaFont.ttf", respc(20), false, "antialiased")
			tooltipFont = dxCreateFont("files/Roboto.ttf", respc(18), false, "antialiased")
			awsome = exports.oFont:getFont("fontawesome2", 12)



			mySlotCoins = getElementData(localPlayer, "char:cc") or 0
			myCharId = getElementData(localPlayer, "char:id")

			triggerEvent("onPlayerRouletteRefresh", localPlayer, fieldBets, actions, history, roundTime)

			showCursor(true)
			addEventHandler("onClientRender", getRootElement(), renderTheRoulette)
		end
	end)

function closeRouletteTable()
	triggerServerEvent("onPlayerExitRoulette", localPlayer)

	standingTableId = false
	standingTableObj = false
	rouletteShow = false

	removeEventHandler("onClientRender", getRootElement(), renderTheRoulette)

	if isElement(Roboto) then
		destroyElement(Roboto)
	end

	Roboto = nil

	if isElement(gtaFont) then
		destroyElement(gtaFont)
	end

	gtaFont = nil

	if isElement(tooltipFont) then
		destroyElement(tooltipFont)
	end

	tooltipFont = nil

	showCursor(false)

	movedChip = false
	draggingPanel = false
end

addEvent("onPlayerRouletteRefresh", true)
addEventHandler("onPlayerRouletteRefresh", getRootElement(),
	function (fieldBets, actions, history, roundTime, placeInTable)
		if not roundTime then
			timeLeft = false
		elseif not timeLeft and not placeInTable or rouletteShow then
			timeLeft = roundTime+getTickCount()
		end
		topBets = {}

		for field, bets in pairs(fieldBets) do
			for i = 1, #bets do
				topBets[field] = bets[i][1]
			end
		end

		local newgame = false

		betsHistory = ""
		roundHistory = table.concat(history, "\n")

		allBets = {}
		myBets = {}

		havePlacedBets = false

		for i = #actions, 1, -1 do
			local dat = actions[i]

			if i > #actions - 11 then
				if dat == "new" then
					betsHistory = betsHistory .. "#737373-- Új kör kezdődött --\n"
					newgame = true
				else
					betsHistory = betsHistory .. "#D6D6D6" .. dat[5] .. " fogadott erre: " .. dat[2] .. " (" .. dat[3] .. " Coin)\n"
				end
			end

			if dat ~= "new" and not newgame then
				if not allBets[dat[1]] then
					allBets[dat[1]] = dat[5] .. " tétje: " .. dat[3] .. " Coin"
				else
					allBets[dat[1]] = allBets[dat[1]] .. "\n" .. dat[5] .. " tétje: " .. dat[3] .. " Coin"
				end

				if tonumber(dat[4]) == myCharId then
					myBets[dat[1]] = true
					havePlacedBets = true
				end
			end
		end
	end)

addEvent("onRouletteBetRemoved", true)
addEventHandler("onRouletteBetRemoved", getRootElement(),
	function ()
		betRemovingProcess = false
	end
)

addEvent("chipSound", true)
addEventHandler("chipSound", getRootElement(), 
	function(x, y, z, soundName)
		local sound = playSound3D("files/chip" .. soundName .. ".mp3", x, y, z)
		setSoundMaxDistance(sound, 75)
		setElementInterior(sound, getElementInterior(localPlayer))
		setElementDimension(sound, getElementDimension(localPlayer))
	end
)

addEvent("onRouletteWheelSound", true)
addEventHandler("onRouletteWheelSound", getRootElement(),
	function ()
		local tableX, tableY, tableZ = getElementPosition(source)
		local tableRot = select(3, getElementRotation(source))
		local rotatedX, rotatedY = rotateAround(tableRot, -0.2, 1.35)
		local soundEffect = playSound3D("files/wheel.mp3", tableX + rotatedX, tableY + rotatedY, tableZ)

		setSoundMaxDistance(soundEffect, 125)
		setElementInterior(soundEffect, getElementInterior(source))
		setElementDimension(soundEffect, getElementDimension(source))
end
)

addEvent("interpolateTheRouletteBall", true)
addEventHandler("interpolateTheRouletteBall", getRootElement(),
	function (oldNumber, newNumber)
		oldNumber = tonumber(oldNumber) or getRealTime().monthday

		ballInterpolation = {
			getTickCount(),
			wheelNumbers[oldNumber] * degPerNum,
			wheelNumbers[newNumber] * degPerNum - 1080,
			newNumber
		}
		--outputChatBox(newNumber)
	end
)

addEvent("sendLastWinning", true)
addEventHandler("sendLastWinning", getRootElement(), function(winNumber, tableId)
	if not latestWinNumber[tableId] then 
		latestWinNumber[tableId] = {}
	end
	if redex[winNumber] then 
		coloring = tocolor(166, 51, 55, 200)
	elseif blackex[winNumber] then 
		coloring = tocolor(20,20,20,200)
	elseif winNumber == 0 then 
		coloring = tocolor(37, 153, 8, 200)
	else 
		coloring = tocolor(r, g, b, 200)
	end
	--latestWinNumber[#latestWinNumber + 1]
	--latestWinNumber[tableId] = {}
	--print(tableId)
	table.insert(latestWinNumber[tableId],  {["winNumber"] = winNumber, ["colored"] = coloring, ["tickCount"] = getTickCount()})
	table.sort(latestWinNumber[tableId], function(a,b)
		return a["tickCount"] > b["tickCount"]
	end)
end)


function renderTheRoulette()
	if core:getNetworkConnection() then 
		local currentTick = getTickCount()
		local cursorX, cursorY = getCursorPosition()

		if cursorX then
			cursorX = cursorX * screenX
			cursorY = cursorY * screenY

			if getKeyState("mouse1") then
				if cursorX >= panelPosX and cursorX <= panelPosX + panelWidth - respc(150) and cursorY>= panelPosY and cursorY <= panelPosY + respc(40) and not draggingPanel then
					draggingPanel = {cursorX, cursorY, panelPosX, panelPosY}
				end

				if draggingPanel then
					panelPosX = cursorX - draggingPanel[1] + draggingPanel[3]
					panelPosY = cursorY - draggingPanel[2] + draggingPanel[4]
				end
			elseif draggingPanel then
				draggingPanel = false
			end
		else
			cursorX, cursorY = -1, -1

			if movedChip then
				movedChip = false
			end

			if draggingPanel then
				draggingPanel = false
			end
		end

		dxDrawRectangle(panelPosX, panelPosY+respc(10), panelWidth, panelHeight, tocolor(44, 44, 44))

		dxDrawRectangle(panelPosX, panelPosY+respc(10), panelWidth, respc(30), tocolor(31, 31, 31))
		dxDrawText("Rulett",panelPosX, panelPosY+respc(10), panelPosX+panelWidth, panelPosY+respc(10)+respc(30),tocolor(104, 104, 104),1,RobotoLight,'center','center')

		local closeLength = dxGetTextWidth("", 0.7, awsome)
		local closeColor = tocolor(70, 70, 70)

		if cursorX >= panelPosX + panelWidth - respc(10) - closeLength and cursorX <= panelPosX + panelWidth - respc(10) and cursorY >= panelPosY and cursorY <= panelPosY + respc(47) then
			closeColor = tocolor(215, 75, 75)

			if getKeyState("mouse1") then
				if havePlacedBets then
					if timeLeft == 0 then
						if not cantExitNotiState then
							cantExitNotiState = true
							outputChatBox("#d75959[Hiba]".."#ffffff".." Várd meg a kör végét!",255,255,255,true)
						end
					elseif not cantExitNotiState then
						cantExitNotiState = true
						outputChatBox("#d75959[Hiba]".."#ffffff".." Előbb vedd le a tétjeid!",255,255,255,true)
					end
				else
					closeRouletteTable()
					return
				end
			elseif cantExitNotiState then
				cantExitNotiState = false
			end
		end

		dxDrawText("", 0, panelPosY+respc(5), panelPosX + panelWidth - respc(10), panelPosY + respc(47), closeColor, 0.7, awsome, "right", "center")

		-- ** Content
		local tableX = math.floor(panelPosX + respc(5))
		local tableY = math.floor(panelPosY + respc(45))

		dxDrawImage(tableX, tableY, tableWidth, tableHeight, "files/table.png")

		local wheelRot = currentTick / 50
		local wheelX = math.ceil(tableX - respc(12))
		local wheelY = math.ceil(tableY + tableHeight / 2 - respc(256) / 2)

		dxDrawImage(wheelX, wheelY, respc(256), respc(256), "files/wheel.png", wheelRot)

		-- Kerék
		local elapsedTime = currentTick - ballInterpolation[1]
		local animProgress = elapsedTime / 10000
		local rotProgress = interpolateBetween(0, 0, 0, 1, 0, 0, animProgress, "InOutQuad")
		local ballRot = interpolateBetween(ballInterpolation[2], 0, 0, ballInterpolation[3], 0, 0, rotProgress, "OutBack", 0.3, 1, 2)

		local preMoveProgress = (elapsedTime - 5000) / 3500
		local moveProgress = 0

		if preMoveProgress > 0 then
			moveProgress = interpolateBetween(0, 0, 0, 1, 0, 0, preMoveProgress, "InOutQuad")
		end

		local moveX, moveY = interpolateBetween(-65, 0, 0, 0, 10, 0, moveProgress, "OutInQuad", 0.3, 1, 4)
		local ballX, ballY = rotateAround(ballRot + wheelRot, moveX, moveY - 5)

		dxDrawImage(wheelX + ballX + respc(28), wheelY + ballY + respc(28), respc(200), respc(200), "files/ball.png", wheelRot + ballRot)

		if animProgress > 0 and moveProgress >= 1 then
			local sx, sy = respc(30), respc(25)
			local x = wheelX + respc(256) / 2 - sx / 2
			local y = wheelY + respc(24) - sy

			local num = ballInterpolation[4]

			if redex[num] then
				--dxDrawRectangle(x, y, sx, sy, tocolor(225, 25, 35))
			elseif blackex[num] then
				--dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0))
			else
				--dxDrawRectangle(x, y, sx, sy, tocolor(25, 150, 50))
			end

			--dxDrawText(num, x, y, x + sx, y + sy, tocolor(255, 255, 255), 0.8, Roboto, "center", "center")
		end

		-- Hátralévő idő
		local min, sec = 1, 0

		if timeLeft then
			local elapsedTime = currentTick - timeLeft
			local progress = math.floor((interactionTime - elapsedTime) / 1000)

			if progress > 0 then
				min, sec = math.floor(progress / 60), progress

				if progress <= 0 then
					timeLeft = 0
				end
			else
				min, sec = 0, 0
				timeLeft = 0
				movedChip = false
			end
		end

		if string.len(sec) < 2 then
			sec = "0" .. sec
		end


		dxDrawRectangle(tableX, tableY + tableHeight + chipPotSize - respc(27), tableWidth ,respc(42), tocolor(34, 34, 34))
		dxDrawImage(panelPosX+panelWidth-respc(730),panelPosY+panelHeight/2+respc(49),respc(25),respc(25), "files/time.png", 0, 0, 0, tocolor(120, 120, 120))
		centeredText(min..":#d65959"..sec,panelPosX-respc(620),panelPosY+panelHeight/2+respc(45.5),panelWidth,respc(30),tocolor(120,120,120),0.9,RobotoBlack,true,false,true)
		dxDrawRectangle(tableX, tableY + tableHeight + chipPotSize + respc(19), tableWidth / 2 - respc(10),respc(195), tocolor(34, 34, 34))
		dxDrawRectangle(tableX + tableWidth / 2 + respc(10), tableY + tableHeight + chipPotSize + respc(19), tableWidth / 2 - respc(10),respc(195), tocolor(34, 34, 34))


		centeredText("Utolsó 8 nyertes számok:",panelPosX+respc(100),panelPosY+respc(315),panelWidth,respc(30),tocolor(255,255,255),0.7,Roboto,true,true) 
		if latestWinNumber[standingTableId] then 
			local startX = panelPosX+respc(120)
			local startY = panelPosY+respc(330)+10
			for k = 1, 8 do 
				local data = latestWinNumber[standingTableId][k]
				if data then  

					dxDrawRectangle(startX,startY, 18,18, data["colored"])

					dxDrawText(data["winNumber"],startX,startY,startX + 18, startY + 18, tocolor(255,255,255,255),0.7,Roboto, "center", "center")
					shadowedText(tostring(data["winNumber"]),startX,startY,startX + 18, startY + 18,tocolor(255,255,255,255),0.7, Roboto, "center", "center")
					startX = startX + respc(20)
				end
			end
		else 
			centeredText("Nincs adat!",panelPosX+respc(100),panelPosY+respc(330),panelWidth,respc(30),tocolor(255,255,255),0.7,Roboto,true,true) 
		end
		centeredText("Jelenlegi:"..hex.." " ..mySlotCoins.. " #ffffffCoin",panelPosX+respc(280),panelPosY+respc(322),panelWidth,respc(30),tocolor(255,255,255),0.7,Roboto,true,true) 
		local chipX = panelPosX + (panelWidth - #availableCoins * chipPotSize) / 2
		local chipY = tableY + tableHeight + (chipPotSize - chipSize) / 2

		for i = 1, #availableCoins do
			local x = math.floor(chipX + (i - 1) * chipPotSize) + respc(225)
			local y = math.floor(chipY) + respc(5)

			if mySlotCoins >= availableCoins[i] and timeLeft ~= 0 then
				--dxDrawText(availableCoins[i], x, y, chipSize, chipSize, tocolor(255,255,255), 0.5, tooltipFont, 'center','bottom')
				dxDrawImage(x, y, chipSize, chipSize, "/files/chips/" .. availableCoins[i] .. ".png")
				--local r,g,b = coincolor[tonumber(availableCoins[i])][1]
				--outputChatBox(tonumber(availableCoins[i]))
				dxDrawText(availableCoins[i], x, y+respc(25), x+chipSize, chipSize, tocolor(coincolor[tonumber(availableCoins[i])][1], coincolor[tonumber(availableCoins[i])][2], coincolor[tonumber(availableCoins[i])][3]), 0.42, tooltipFont,'center')

				if not movedChip and cursorX >= x and cursorY >= y and cursorX <= x + chipSize and cursorY <= y + chipSize then
					if getKeyState("mouse1") then
						movedChip = availableCoins[i]
					end

					--showTooltip(cursorX, cursorY, "#598ed7" .. availableCoins[i] .. " #ffffffCoin")
				end
			else
				dxDrawImage(x, y, chipSize, chipSize, "/files/chips/" .. availableCoins[i] .. ".png", 0, 0, 0, tocolor(255, 255, 255, 120))
			end
		end

		activeBetField = false


		if not movedChip then
			--outputChatBox(#topBets)
			for field, chip in pairs(topBets) do
				local pos = split(field, ",")
				local x = tableX + pos[1] - chipSize / 2
				local y = tableY + pos[2] - chipSize / 2
				--local x,y = pos[1] + tableX, pos[2] + tableY

				dxDrawImage(x, y, chipSize, chipSize, "/files/chips/" .. chip .. ".png")
				--outputChatBox(#topBets)
				if cursorX >= x and cursorX <= x + chipSize and cursorY >= y and cursorY <= y + chipSize then
					if allBets[field] then
						showTooltip(cursorX, cursorY, "Fogadások", allBets[field])

						if not activeBetField and myBets[field] then
							activeBetField = field
						end
					end
				end
			end

			if activeBetField and not betRemovingProcess and timeLeft ~= 0 and getKeyState("mouse2") then
				betRemovingProcess = true
				--outputChatBox(#topBets)
				if currentTick - clickTick > 1275 and myBets[activeBetField] then
					triggerServerEvent("removeRouletteBet", localPlayer, activeBetField)
				else
					betRemovingProcess = false
				end
			end
		elseif isCursorShowing() then
			local activeFields = {}
			local activeFieldX, activeFieldY = 0, 0

			local fieldMinX, fieldMinY = 9999, 9999
			local fieldMaxX, fieldMaxY = -1, -1

			for i = 1, #fieldPositions do
				--outputChatBox(i)
				local dat = fieldPositions[i]--COMEBACKHERE

				local fieldX = math.floor(tableX + dat[2])
				local fieldY = math.floor(tableY + dat[3])

				if boxesIntersect(cursorX - chipSize / 2, cursorY - chipSize / 2, cursorX + chipSize / 2, cursorY + chipSize / 2, fieldX, fieldY, fieldX + dat[4], fieldY + dat[5]) then
					table.insert(activeFields, dat[1])
				end

				local field = dat[1]
				local numField = tonumber(field)
				local drawed = false

				if field ~= hoverFieldDatas[3] then
					drawed = true
				end

				if field == hoverFieldDatas[3] then
					activeFieldX = math.floor(dat[2] + dat[4] / 2)
					activeFieldY = math.floor(dat[3] + dat[5] / 2)
					--outputChatBox(dat[2]..' / '..dat[3]..' / '..dat[4]..' / '..dat[5])
				elseif hoverFieldDatas[5] then
					--outputChatBox(numField)
					if hoverFieldDatas[5][numField] then
						if activeFieldX <= 0 and activeFieldY <= 0 then
							local startX = dat[2]
							--outputChatBox("asd")
							if numField == 0 then
								startX = 205
							end

							if startX < fieldMinX then
								fieldMinX = startX
							end

							if fieldMaxX < dat[2] + dat[4] then
								fieldMaxX = dat[2] + dat[4]
							end

							if numField ~= 0 then
								if dat[3] < fieldMinY then
									fieldMinY = dat[3]
								end

								if fieldMaxY < dat[3] + dat[5] then
									fieldMaxY = dat[3] + dat[5]
								end
							end
						end

						drawed = false
					end
				elseif not drawed then
					drawed = true
				end

				if drawed then
					if numField == 0 then
						--dxDrawImage(tableX, tableY, respc(734), respc(268), "files/0.png", 0, 0, 0, tocolor(0, 0, 0, 150))
					else
					--	dxDrawRectangle(fieldX, fieldY, dat[4], dat[5], tocolor(0, 0, 0, 150))
					end
				end
			end

			if activeFieldX <= 0 and activeFieldY <= 0 then
				activeFieldX = fieldMinX + (fieldMaxX - fieldMinX) / 2
				activeFieldY = fieldMinY + (fieldMaxY - fieldMinY) / 2
			--	outputChatBox(fieldMinX)
				if (hoverFieldDatas[2] == "three line" or hoverFieldDatas[2] == "six line" or hoverFieldDatas[2] == "corner") and not tonumber(hoverFields[1]) then
					activeFieldY = fieldMinY + (fieldMaxY - fieldMinY)
				end
			end

			if #activeFields == 0 then
				hoverFields = {}
				hoverFieldDatas = {}
			else
				for i = 1, #activeFields do
					local activeField = activeFields[i]
					local selectedField = hoverFields[i]

					if activeField == selectedField then
						activeField = #activeFields
						selectedField = #hoverFields
					end

					if activeField ~= selectedField then
						local fieldNumbers, fieldName, oneFieldName, priceMultipler = getDetailsFromName(activeFields)

						hoverFields = activeFields
						hoverFieldDatas = {fieldNumbers, fieldName, oneFieldName, priceMultipler}
						hoverFieldDatas[5] = {}

						for j = 1, #fieldNumbers do
							hoverFieldDatas[5][tonumber(fieldNumbers[j])] = true
						end

						break
					end
				end
			end

			dxDrawImage(cursorX - chipSize / 2, cursorY - chipSize / 2, chipSize, chipSize, "/files/chips/" .. movedChip .. ".png")

			if #hoverFields > 0 and tonumber(hoverFieldDatas[4]) then
				showTooltip(cursorX, cursorY, hoverFieldDatas[2], "Kifizetés: " .. hoverFieldDatas[4] + 1 .. "x")
			end

			for field, chip in pairs(topBets) do
				local pos = split(field, ",")
				local x = tableX + pos[1] - chipSize / 2 
				local y = tableY + pos[2] - chipSize / 2

				dxDrawImage(x, y, chipSize, chipSize, "/files/chips/" .. chip .. ".png")
			end

			if not getKeyState("mouse1") then
				if #hoverFields > 0 and timeLeft ~= 0 and currentTick - clickTick > 1275 then
					local field = activeFieldX .. "," .. activeFieldY


					if not timeLeft then
						timeLeft = 0+getTickCount()
					end
					topBets[field] = movedChip
					hoverFieldDatas[3] = nil
					hoverFieldDatas[5] = nil
					hoverFieldDatas[6] = movedChip
					clickTick = getTickCount()
					--outputChatBox(field)

					triggerServerEvent("placeRouletteBet", localPlayer, field, hoverFieldDatas, getElementsByType("player", getRootElement(), true))

					hoverFieldDatas = {}
				end

				movedChip = false
			end
		end
		centeredText(roundHistory,tableX,tableY + tableHeight/2+respc(95),panelWidth,respc(194),tocolor(255,255,255),0.6,Roboto,true,true,false,true)
		centeredText(betsHistory,tableX + tableWidth / 2 + respc(10), tableY + tableHeight + chipPotSize + respc(30) - respc(195)/2, tableWidth / 2 - respc(10),respc(195),tocolor(255,255,255),0.6,Roboto,true,false,true,true)
	end
end

function boxesIntersect(x, y, sx, sy, x2, y2, sx2, sy2)
	if sx < x2 then
		return false
	end
	
	if sx2 < x then
		return false
	end
	
	if sy < y2 then
		return false
	end
	
	if sy2 < y then
		return false
	end
	
	return true
end

function showTooltip(x, y, text, text2)
	text = tostring(text)
	text2 = text2 and tostring(text2)

	if text == text2 then
		text2 = nil
	end

	local sx = dxGetTextWidth(text, 1, "clear", true) + 20
	
	if text2 then
		sx = math.max(sx, dxGetTextWidth(text2, 1, "clear", true) + 20)
		text = "#e58904" .. text .. "\n#ffffff" .. text2
	end

	local sy = 30

	if text2 then
		local lines = select(2, string.gsub(text2, "\n", "")) + 1
		sy = sy + 12 * lines
	end

	x = math.max(0, math.min(screenX - sx, x))
	y = math.max(0, math.min(screenY - sy, y))

	dxDrawRectangle(x - sx/2, y+respc(13), sx, sy, tocolor(31, 31, 31, 255), true)
	dxDrawText(text, x - sx/2, y+respc(13), x - sx/2 + sx, y + sy+respc(13), tocolor(255, 255, 255), 0.5, tooltipFont, "center", "center", false, false, true, true)
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end

function centeredText(text,x,y,w,h,color,size,font,shadow,leftcentered,rightcentered,top)
    if leftcentered then
		if shadow then
			if top then
				shadowedText(text,x+20,y+h/2,x+20,y+h/2,color,size,font,"left","top",false,false,false,true)
			else
				shadowedText(text,x+20,y+h/2,x+20,y+h/2,color,size,font,"left","center",false,false,false,true)
			end
        else
            dxDrawText(text,x+20,y+h/2,x+20,y+h/2,color,size,font,"left","center",false,false,false,true)
        end
	elseif rightcentered then
        if shadow then
            if top then
                shadowedText(text,x+w,y+h/2,x+w-20,y+h/2,color,size,font,"right","top",false,false,false,true)
            else
                shadowedText(text,x+w,y+h/2,x+w-20,y+h/2,color,size,font,"right","center",false,false,false,true)
            end
        else
            dxDrawText(text,x+20-20,y+h/2,x+20,y+h/2,color,size,font,"right","center",false,false,false,true)
        end
	else
        if shadow then 
            shadowedText(text,x+w/2,y+h/2,x+w/2,y+h/2,color,size,font,"center","center",false,false,false,true)
        else
            dxDrawText(text,x+w/2,y+h/2,x+w/2,y+h/2,color,size,font,"center","center",false,false,false,true)
        end
    end
end