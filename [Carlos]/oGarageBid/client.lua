sx, sy = guiGetScreenSize()
myX, myY = 1768, 992

local startedLicitCount = 0 
local inLicit = false

setTimer(function()
	startedLicitCount = 0
end, core:minToMilisec(20), 0)

local storagePed = createPed(95, 215.86318969727,18.547714233398,2.57080078125, 270)
setElementFrozen(storagePed, true)
setElementData(storagePed, "ped:name", "Mike")

local interiorObjects = {}
local garageIntObjs = {}

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
	if key == "right" and state == "up" then 
        if element then 
			if element == storagePed then 
				if not inLicit then
					if core:getDistance(localPlayer, element) < 4 then 
						local interiors = getElementData(resourceRoot, "garageBid:savedGarages") or {}

						local charid = getElementData(localPlayer, "char:id")
						local intfound = false
						for k, v in ipairs(interiors) do 
							if v[1] == charid then 
								intfound = true 
								break 
							end
						end

						if not intfound then
							local hour = core:getDate("hour")
							hour = tonumber(hour)
							if (hour >= openTime and hour < closeTime) then 
								showPanel(1)
							else
								outputChatBox(core:getServerPrefix("server", "Raktár vásárlás", 3).."Jelenleg #EE4623zárva#ffffff! Nyitvatartás: "..color..openTime..":00 #ffffffés "..color..closeTime..":00#ffffff között.", 255, 255, 255, true)
							end
						else
							infobox:outputInfoBox("Egyszerre csak egy megvásárolt garázzsal rendelkezhetsz!", "error")
						end
					end
				end
			end
		end
	end
end)

-- Current bids --
-- Lekérés, frissítés, sync
local currentBids = {}
local currentBidsRequested = false
function getAvailableBids()
	if currentBidsRequested then return end 
	currentBidsRequested = true 
	triggerServerEvent( "garageBid > getCurrentBidsFromServer", resourceRoot)
end

addEvent("garageBid > sendCurrentBidsToClient", true) 
addEventHandler("garageBid > sendCurrentBidsToClient", getRootElement(), function(current)
	currentBids = current 
	currentBidsRequested = false
end)

------------------

local lastLicit, lastLiciter = 36000, 5
local licitCount, maxLicitCount = 1, 15
local licitLoottable = 0
local licits = {
	-- name, image, benne van a licitben, utolsó licit, legnagyobb, licitek száma, licitálás animáció (tick, state, animValue - nem kell változtatni), sound effect
    {"Lester", 37, true, 0, math.random(0, 3), {0, "open", 0}, "hey_1.mp3"},
    {"Emily", 38, true, 0, math.random(0, 3), {0, "open", 0}, "hey_3.mp3"},
    {"Ron", 40, true, 0, math.random(0, 3), {0, "open", 0}, "hey_2.mp3"},
    {"Marko", 36, true, 0, math.random(0, 3), {0, "open", 0}, "hey_1.mp3"},
	{"Carlos White", 1, true, 0, 0, {0, "open", 0}, ""},
}


local panelShowing = false
local panelType = 2

local endTimer = getTickCount() + 10000
local outTimer = getTickCount() + outTime

local animTick, animType = getTickCount(), "open"
local a = 0

local transporterCar = "loading"

function renderBidPanel()
	licits[5][1] = getPlayerName(localPlayer):gsub("_", " ")

	if animType == "open" then 
		a = interpolateBetween(a, 0, 0, 1, 0, 0, (getTickCount() - animTick) / 500, "InOutQuad")
	else
		a = interpolateBetween(a, 0, 0, 0, 0, 0, (getTickCount() - animTick) / 500, "InOutQuad")
	end

	if panelType == 1 then 
		if ((core:getDistance(localPlayer, storagePed) > 4) or getKeyState("backspace")) and animType == "open" then
			closePanel() 
		end

		local panelW, panelH = sx*0.2, sy*0.07 + (#currentBids * sy*0.047)
		local panelX, panelY = sx*0.4, sy*0.5 - panelH/2

		core:drawWindow(panelX, panelY, panelW, panelH, "Aukciós telep", a)

		if #currentBids == 0 then 
			dxDrawText("Jelenleg nincsen licitre bocsájtott garázs!", panelX + sx*0.01, panelY + sy*0.035, _, _, tocolor(255, 255, 255, 200 * a), 1, font:getFont("p_m", 15/myX*sx))
		else
			dxDrawText("Licitre bocsájtott garázsok:", panelX + sx*0.01, panelY + sy*0.035, _, _, tocolor(255, 255, 255, 200 * a), 1, font:getFont("p_m", 15/myX*sx))

			local startY = panelY + sy*0.065
			for k, v in ipairs(currentBids) do 
				dxDrawRectangle(panelX + sx*0.005, startY, panelW - sx*0.01, sy*0.045, tocolor(30, 30, 30, 200 * a))
				dxDrawText(v[1], panelX + sx*0.01, startY + sy * 0.005, _, _, tocolor(255, 255, 255, 200 * a), 1, font:getFont("p_bo", 15/myX*sx))
				dxDrawText("Licit kezdőára: " .. color .. v[2] .. "$", panelX + sx*0.01, startY + sy * 0.022, _, _, tocolor(255, 255, 255, 200 * a), 0.9, font:getFont("p_m", 15/myX*sx), _, _, false, false, false, true)
				core:dxDrawButton(panelX + panelW - sx*0.05, startY + sy*0.005, sx*0.043, sy*0.035, r, g, b, 200 * a, "Licit", tocolor(255, 255, 255, 255 * a), 1, font:getFont("condensed", 10/myX*sx), false)
				
				if core:isInSlot(panelX + panelW - sx*0.05, startY + sy*0.005, sx*0.043, sy*0.035) then 
					core:drawToolTip("A licit megkezdéséhez elegendő a kezdőár, de ajánlott a licit miatt legalább a kezdőár duplájával rendelkezned.", tocolor(25, 25, 25, 200 * a), tocolor(255, 255, 255, 255 * a), font:getFont("condensed", 10/myX*sx), 1)
				end
				
				startY = startY + sy*0.047
			end
		end
	elseif panelType == 2 then 
		local panelW, panelH = sx*0.3, sy*0.4
		local panelX, panelY = sx*0.35, sy*0.3

		core:drawWindow(panelX, panelY, panelW, panelH, "Licitáló felület", a)

		local startY = panelY + sy*0.03
		for k, v in ipairs(licits) do
			dxDrawRectangle(panelX + sx*0.005, startY, panelW - sx*0.01, sy*0.07, tocolor(30, 30, 30, 200 * a))

			if k == 5 then 
				dxDrawImage(panelX + sx*0.007, startY + sx*0.002, sy*0.07 - sx*0.004, sy*0.07 - sx*0.004, ":oAccount/avatars/"..getElementData(localPlayer, "char:avatarID")..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * a))
			else 
				dxDrawImage(panelX + sx*0.007, startY + sx*0.002, sy*0.07 - sx*0.004, sy*0.07 - sx*0.004, ":oAccount/avatars/"..v[2]..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * a))
			end
			
			if k == 5 and v[3] then 
				local timeOut = math.floor((outTimer - getTickCount()) / 1000)

				if timeOut <= 0 then 
					licits[5][3] = false
				end
			end

			dxDrawText(v[1], panelX + sx*0.05, startY + sx*0.004, _, _, tocolor(255, 255, 255, 200 * a), 1, font:getFont("p_ba", 17/myX*sx))
	
			
			if v[3] then
				dxDrawText(v[4] .. " $", panelX + sx*0.05, startY + sy*0.03, _, _, tocolor(r, g, b, 200 * a), 1, font:getFont("p_bo", 25/myX*sx))
			else
				dxDrawText("OUT", panelX + sx*0.05, startY + sy*0.03, _, _, tocolor(245, 66, 66, 200 * a), 1, font:getFont("p_bo", 25/myX*sx))
			end 

			if v[4] == lastLicit then 
				core:dxDrawOutLine(panelX + sx*0.005, startY, panelW - sx*0.01, sy*0.07, tocolor(r, g, b, 150 * a), 2, false)
			
				if endTimer then
					local timeToBuy = math.floor((endTimer - getTickCount()) / 1000)
					dxDrawText(timeToBuy .. " mp", panelX + sx*0.005, startY, panelX + sx*0.005 + panelW - sx*0.02, startY + sy*0.07, tocolor(245, 66, 66, 255 * a), 1, font:getFont("p_ba", 25/myX*sx), "right", "center")

					if timeToBuy <= 0 then 
						licitEnd(k)
					end
				end
			end

			if v[6][2] == "open" then 
				v[6][3] = interpolateBetween(v[6][3], 0, 0, 1, 0, 0, (getTickCount() - v[6][1]) / 300, "InOutQuad")

				if (v[6][1] + 2500) < getTickCount() then  
					v[6][2] = "close"
					v[6][1] = getTickCount()
				end
			else
				v[6][3] = interpolateBetween(v[6][3], 0, 0, 0, 0, 0, (getTickCount() - v[6][1]) / 300, "InOutQuad")
			end

			core:dxDrawRoundedRectangle(sx*0.315, startY + sy*0.02 - (sy*0.01 * v[6][3]), 50/myX*sx, 50/myX*sx, tocolor(35, 35, 35, 255 * v[6][3]))
			dxDrawImage(sx*0.315 + 10/myX*sx, startY + sy*0.02 - (sy*0.01 * v[6][3]) + 10/myX*sx, 30/myX*sx, 30/myX*sx, "files/hand.png", 0, 0, 0, tocolor(255, 255, 255, 255 * v[6][3]))
			dxDrawImage(sx*0.315 + 44/myX*sx, startY + sy*0.02 - (sy*0.01 * v[6][3]) + 15/myX*sx, 20/myX*sx, 20/myX*sx, "files/arrow.png", -90, 0, 0, tocolor(35, 35, 35, 255 * v[6][3]))
			
			startY = startY + sy*0.072
		end

		local startX = panelX
		if not (lastLiciter == 5) and licits[5][3] then
			for i = 1, 5 do 
				if licitCount >= i then
					local money = lastLicit + numbersToFill[i][1]
					if getElementData(localPlayer, "char:money") >= money then
						core:dxDrawButton(startX, panelY + panelH + sy*0.0054, sx*0.05, sy*0.04, r, g, b, 200 * a, (money) .. "$", tocolor(255, 255, 255, 255 * a), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 100 * a))
					else
						core:dxDrawButton(startX, panelY + panelH + sy*0.0054, sx*0.05, sy*0.04, r, g, b, 150 * a, (money) .. "$", tocolor(255, 255, 255, 70 * a), 1, font:getFont("condensed", 10/myX*sx), true, tocolor(0, 0, 0, 20 * a))
					end
				end
				startX = startX + sx*0.056
			end
		end

	end
end


function keyBidPanel(key, state)
	if key == "mouse1" and state then 
		if panelType == 1 then 
			local panelW, panelH = sx*0.2, sy*0.07 + (#currentBids * sy*0.047)
			local panelX, panelY = sx*0.4, sy*0.5 - panelH/2
			if #currentBids > 0 then 
				local startY = panelY + sy*0.065
				for k, v in ipairs(currentBids) do 

					if core:isInSlot(panelX + panelW - sx*0.05, startY + sy*0.005, sx*0.043, sy*0.035) then 
						if (getElementData(localPlayer, "char:money") >= v[2]) then 
							if startedLicitCount < 2 then
								triggerServerEvent("garageBid > removeSelectedBid", resourceRoot, k)

								lastLicit = v[2]
								licits[5][4] = v[2]
								startLicit(v[3], true)
							else 
								outputChatBox(core:getServerPrefix("red-dark", "Raktár", 3).."20 percenként csak két licitet indíthatsz el.", 255, 255, 255, true)
							end
							
						else
							infobox:outputInfoBox("Nincs elegendő pénzed a licit megkezdéséhez!", "error")
						end
					end
					
					startY = startY + sy*0.047
				end
			end
		elseif panelType == 2 then 
			local panelW, panelH = sx*0.3, sy*0.4
			local panelX, panelY = sx*0.35, sy*0.3
	
			local startX = panelX
			if not (lastLiciter == 5) and licits[5][3] then
				for i = 1, 5 do 
					if licitCount >= i then
						if core:isInSlot(startX, panelY + panelH + sy*0.0054, sx*0.05, sy*0.04) then 
							local money = (lastLicit + numbersToFill[i][1])

							if getElementData(localPlayer, "char:money") >= money then
								giveALicitByPlayer(i)
							end
						end
					end
					startX = startX + sx*0.056
				end
			end
	
		end
	end
end

function showPanel(panel)
	if panelShowing then return end 

	if panel == 1 then
		getAvailableBids() -- elérhető raktárok lekérése 
	end

	animTick, animType = getTickCount(), "open"
	panelType = panel
	panelShowing = true
	addEventHandler("onClientKey", root, keyBidPanel)
	addEventHandler("onClientRender", root, renderBidPanel)
end

function closePanel()
	animTick, animType = getTickCount(), "close"
	removeEventHandler("onClientKey", root, keyBidPanel)

	setTimer(function()
		removeEventHandler("onClientRender", root, renderBidPanel)
		panelShowing = false
	end, 500, 1)
	
end

local giveLicitTimer = nil 

local garage_vehicleColor = false
function startLicit(garageType, openDoor)
		inLicit = true
		startedLicitCount = startedLicitCount + 1
		--lastLicit, lastLiciter = 36000, 5
		licitCount, maxLicitCount = 1, 15
		licits = {
			-- name, image, benne van a licitben, utolsó licit, legnagyobb, licitek száma, licitálás animáció (tick, state, animValue - nem kell változtatni), sound effect
			{"Lester", 37, true, 0, math.random(0, 3), {0, "open", 0}, "hey_1.mp3"},
			{"Emily", 38, true, 0, math.random(0, 3), {0, "open", 0}, "hey_3.mp3"},
			{"Ron", 40, true, 0, math.random(0, 3), {0, "open", 0}, "hey_2.mp3"},
			{"Marko", 36, true, 0, math.random(0, 3), {0, "open", 0}, "hey_1.mp3"},
			{"Carlos White", 1, true, 0, 0, {0, "open", 0}, ""},
		}

		closePanel()
		showLoadingScreen({"Interior betöltése", "Garázs betöltése", "Karakter betöltése"})
		showChat(false)
		exports.oInterface:toggleHud(true)

		garage_vehicleColor = false

		setTimer(function()
			setElementFrozen(localPlayer, true)
			setElementDimension(localPlayer, getElementData(localPlayer, "playerid"))
			setCameraMatrix(170.6356048584,232.8191986084,68.370597839355,169.63566589355,232.82510375977,68.380035400391)
			
		
			setTimer(function()
				generateGarage(generatePositions[garageType], garageType, openDoor)
				infobox:outputInfoBox("Ez a mai raktár! Nézz körbe hátha találsz valami érdekeset! Hamarosan kezdődik a licit!", "success")
		
				setTimer(function()
					endTimer = getTickCount() + 10000
					outTimer = getTickCount() + outTime
					showPanel(2)
			
					giveLicitTimer = setTimer(function()
						giveALicit()
					end, math.random(1500, 8000), 1)
				end, 7500, 1)
			end, 6000, 1)
			
		end, 3000, 1)
	
end

function licitEnd(winner)
	if winner == 5 then 
		infobox:outputInfoBox("Megvásároltad a raktárat! Hamarosan visszakerülsz a bejárathoz!", "success")
		outputChatBox(core:getServerPrefix("server", "Raktár", 3).."Vásásroltál egy raktárt "..color..lastLicit.."$#ffffff-ért.", 255, 255, 255, true)
		print("c", toJSON(garage_vehicleColor))
		triggerServerEvent("garageBid > buyGarage", resourceRoot, lastLicit, licitLoottable, garage_vehicleColor)
	else
		infobox:outputInfoBox("Hát ez most nem a te napod... Hamarosan visszakerülsz a bejárathoz!", "warning")
	end

	for k, v in ipairs(licits) do 
		if not (k == winner) then 
			v[3] = false
		end
	end

	endTimer = false

	setTimer(function()
		closePanel()
		showLoadingScreen({"Pálya betöltése", "Karakter betöltése", "Szinkronizáció"})

		setTimer(function()
			destroyInteriorObjects()

			setElementDimension(localPlayer, 0)
			setCameraTarget(localPlayer, localPlayer)
			setElementFrozen(localPlayer, false)
		end, 2500, 1)

		setTimer(function()
			showChat(true)
			exports.oInterface:toggleHud(false)	
			inLicit = false	
		end, 9000, 1)
	end, 2500, 1)
end

function giveALicitByPlayer(licit)
	local newLicit = lastLicit + numbersToFill[licit][1]
	lastLicit, lastLiciter = newLicit, 5
	endTimer = getTickCount() + 10000
	licitCount = licitCount + 1
	licits[5][4] = newLicit

	licits[5][6][1] = getTickCount()
	licits[5][6][2] = "open"

	outTimer = getTickCount() + outTime

	if isTimer(giveLicitTimer) then 
		killTimer(giveLicitTimer)
	end

	local randomNumber = math.random(1, 7)
	playSound("files/sounds/coin.mp3")
	--outputChatBox(randomNumber)
	if randomNumber >= numbersToFill[licit][3] then
		giveLicitTimer = setTimer(function()
			giveALicit()
		end, math.random(1500, 8000), 1)
	end 
end

function giveALicit()
	if licitCount < maxLicitCount then
		local random = math.random(1, 4)

		while (licits[random][3] == false) do 
			random = math.random(1, 4)
		end

		if not (lastLiciter == random) then 
			local newLast = lastLicit + licitNums[math.random(#licitNums)]
			licits[random][4] = newLast

			licits[random][6][1] = getTickCount()
			licits[random][6][2] = "open"

			lastLicit = newLast
			lastLiciter = random
		end

		endTimer = getTickCount() + 10000

		playSound("files/sounds/"..licits[random][7])

		if math.random(1, 5) > 2 then
			giveLicitTimer = setTimer(function()
				giveALicit()
			end, math.random(1500, 8000), 1)
		end
	end
end



-- Garage generation 
local exitMarker = false


function buildGarage()
	local objects = {}

	table.insert(objects, createObject(9505, 164.35458374023,235.3,66.711875915527))
	setElementRotation(objects[1], 0, -90, 0)

	table.insert(objects, createObject(18331, 160.03887939453,232.80952453613,68.5))
	table.insert(objects, createObject(18331, 162.03887939453,230.80952453613,68.5))
	table.insert(objects, createObject(18331, 162.03887939453,234.80952453613,68.5))
	setElementRotation(objects[3], 0, 0, -90)
	setElementRotation(objects[4], 0, 0, -90)

	table.insert(objects, createObject(9505, 164.35458374023,235.3,70.3))
	setElementRotation(objects[5], 0, -90, 0)

	local garageDoor = createObject(11360, 166.83653564453,232.85,68.87813415527)
	table.insert(objects, garageDoor)

	table.insert(objects, createObject(11360, 166.84,228.3,68.87813415527))
	table.insert(objects, createObject(11360, 166.84,237.4,68.87813415527))

	table.insert(objects, createObject(11360, 170.84,228.3,68.87813415527))
	table.insert(objects, createObject(11360, 170.84,237.4,68.87813415527))

	table.insert(objects, createObject(9505, 174.85,235.3,66.711875915527))
	setElementRotation(objects[11], 0, -90, 0)

	table.insert(objects, createObject(9505, 174.85,225.68,66.711875915527))
	setElementRotation(objects[12], 0, -90, 0)

	table.insert(objects, createObject(9505, 164.3545,225.68,66.711875915527))
	setElementRotation(objects[13], 0, -90, 0)

	table.insert(objects, createObject(18331, 168.77288818359, 225.65,68.5))
	setElementRotation(objects[14], 0, 0, -90)

	table.insert(objects, createObject(18331, 168.77288818359, 240.05,68.5))
	setElementRotation(objects[15], 0, 0, -90)

	table.insert(objects, createObject(9505, 164.3545,225.68,70.3))
	setElementRotation(objects[16], 0, -90, 0)

	table.insert(objects, createObject(9505, 174.85,225.68,70.3))
	setElementRotation(objects[17], 0, -90, 0)

	table.insert(objects, createObject(9505, 174.85,235.3,70.3))
	setElementRotation(objects[18], 0, -90, 0)

	table.insert(objects, createObject(18331, 175.52,230.80952453613,68.5))
	table.insert(objects, createObject(18331, 175.52,234.80952453613,68.5))
	setElementRotation(objects[19], 0, 0, -90)
	setElementRotation(objects[20], 0, 0, -90)

	table.insert(objects, createObject(11360, 170.85653564453,232.85,68.87813415527))

	table.insert(objects, createObject(2949, 169.5,225.74,66.8))
	setElementRotation(objects[22], 0, 0, -90)

	table.insert(objects, createObject(18331, 166.75,226,68))
	table.insert(objects, createObject(18331, 166.75,239.7,68))

	table.insert(objects, createObject(18331, 170.85,230.5,68))
	table.insert(objects, createObject(18331, 170.85,240,68))


	local playerID = getElementData(localPlayer, "playerid")
	for k, v in pairs(objects) do 
		setElementDimension(v, playerID)
	end

	return garageDoor, objects
end

function generateGarage(values, loottable, openDoor)
	licitLoottable = loottable

	local garageDoor, objects = buildGarage()

	garageIntObjs = objects

	local playerID = getElementData(localPlayer, "playerid")

	if openDoor then 
		setTimer(function()
			moveObject(garageDoor, 2000, 166.83653564453,232.85,71.87813415527, 0, 0, 0, "InOutQuad")
			playSound("files/sounds/garage_open.mp3")
		end, 1500, 1)
	else
		moveObject(garageDoor, 50, 166.83653564453,232.85,71.87813415527, 0, 0, 0, "InOutQuad")

		exitMarker = createMarker(168.74253845215,226.59973144531,67.797813415527-0.99, "cylinder", 1.0, 128, 72, 224, 150)--exports.oCustomMarker:createCustomMarker(168.74253845215,226.59973144531,67.797813415527, 2.5, 232, 65, 65, 150, _, "circle")
		setElementAlpha(exitMarker, 0)
		setElementDimension(exitMarker, playerID)
	end

	local createdElements = 0
	if values then
		for k, v in ipairs(values) do
			if v and not (v == nil) then
				if type(v[1]) == "table" then 
					v[1] = v[1][math.random(#v[1])]
					v[4] = v[4] + (adjustZPositions[v[1]] or 0)
				end

				if v[1] > 0 then
					if v[8] then 
						veh = createVehicle(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
						setElementFrozen(veh, true)
						table.insert(interiorObjects, veh)
						setElementDimension(veh, playerID)

						if v[10] then 
							setVehicleColor(veh, unpack(v[10]))
						elseif openDoor then 
							local randomColor = vehicleColors[math.random(#vehicleColors)]
							setVehicleColor(veh, unpack(randomColor))
							garage_vehicleColor = randomColor
						end

						setElementData(veh, "veh:paintjob", v[9])
					else
						obj = createObject(unpack(v)) 
						setElementFrozen(obj, true)
						setElementDoubleSided(obj, true)
						table.insert(interiorObjects, obj)
						setElementDimension(obj, playerID)

						if not openDoor then 
							setElementData(obj, "garageBid:pickupObjectID", k)

							if objectLoots[v[1]] then 
								--print("asdasd")
								setElementData(obj, "garageBid:pickupObject:loottable", objectLoots[v[1]])
								setElementData(obj, "garageBid:pickupObject:name", objectNames[v[1]])
							end
						end
					end
					createdElements = createdElements + 1
				end
			end
		end

		print(createdElements, "db elem létrehozva")
	end
end

--generateGarage(generatePositions[2], 2, false)

-- Interior bigyusz
local inInterior = false
local intMarker = createMarker(garagesInteriorMarkerPos[1], garagesInteriorMarkerPos[2], garagesInteriorMarkerPos[3]-0.99, "cylinder", 1.0, 128, 72, 224, 150) --exports.oCustomMarker:createCustomMarker(garagesInteriorMarkerPos[1], garagesInteriorMarkerPos[2], garagesInteriorMarkerPos[3], 2.5, 232, 65, 65, 150, _, "circle")
local inExitMarker = false

setElementAlpha(intMarker, 0)

-- Marker render
local tick = getTickCount()
addEventHandler("onClientRender",getRootElement(),function()
    local pX,pY,pZ = getElementPosition(localPlayer)
    for k, v in pairs(getElementsByType("marker", resourceRoot, true)) do
        if (v == intMarker) or (v == exitMarker) then
            local scale, zplus = interpolateBetween(0.4, 1.2, 0, 0.55, 1.7, 0, (getTickCount() - tick) / 5000, "CosineCurve")
            local markX,markY,markZ = getElementPosition(v)
            local x, y = getScreenFromWorldPosition(markX, markY, (markZ-0.6)+zplus)  

            if x and y then
                local distance = core:getDistance(localPlayer,v)
                if distance < 40 then    
                   
                    local r, g, b = getMarkerColor(v)
                    local size = interpolateBetween(40,0,0, 40 - distance/1.4,0,0, distance, "Linear")
                    exports.o3DElements:dxDrawCircle3D(markX, markY, (markZ - 0.6) +0.6, scale, tocolor(r, g, b, 150 - (2 * 30)), 3)
                    exports.o3DElements:dxDrawCircle3D(markX, markY, (markZ - 0.6) +0.75, scale, tocolor(r, g, b, 150 - (3 * 30)), 2)
                    exports.o3DElements:dxDrawCircle3D(markX, markY, (markZ - 0.6) +0.9, scale, tocolor(r, g, b, 150 - (4 * 30)), 1)
                    if isLineOfSightClear (pX, pY, pZ, markX, markY, markZ + 0.6, true, true, false, true) then    
                        dxDrawImage(x-size/2,y-size/2,size,size,"files/inticon.png",0,0,90, tocolor(r, g, b, 150),false)
                    end  
                end 
            end
        end
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	destroyElement(intMarker)

	if isElement(exitMarker) then 
		destroyElement(exitMarker) 
	end

	if inInterior then 
		setElementPosition(localPlayer, 221.55383300781,15.518689155579,2.578125)
		setElementDimension(localPlayer, 0)
	end
end)

intTitleText = ""
tooltipText = ""
function renderTooltip()
	if not interiorTick then
		interiorTick = getTickCount()
	end

	alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - interiorTick) / 200, "Linear")

	core:drawWindow(sx*0.4, sy*0.8, sx*0.2, sy*0.06, intTitleText, alpha)
	dxDrawText(tooltipText.." használd az "..color.."[E] #ffffffgombot.", sx*0.4, sy*0.835, sx*0.4+sx*0.2, sy*0.835+sy*0.009, tocolor(255, 255, 255, 255*alpha), 0.65, exports.oFont:getFont("condensed", 12) , "center", "center", false, false, false, true)
	dxDrawImage(sx*0.5 - 20/myX*sx,sy*0.76,40/myX*sx,40/myY*sy,"files/inticon.png", 0, 0, 0, tocolor(128, 72, 224, 255*alpha))

end

local receiptItems = {}
local nonMoveableItems = 0
function exitInterior()
	local interiors = getElementData(resourceRoot, "garageBid:savedGarages") or {}
	local charid = getElementData(localPlayer, "char:id")

	removeEventHandler("onClientRender", root, renderTooltip)
	unbindKey("e", "up", exitInterior)

	for k, v in ipairs(interiors) do 
		if v[1] == charid then 
			local lastItem = true 
			nonMoveableItems = 0

			if #v[2] > 0 then 
				for k2, v2 in pairs(v[2]) do 
					--print(toJSON(v2))
					if type(v2) == "table" then
						if objectLoots[v2[1]] then 
							lastItem = false 
							break 
						else
							if not v2[8] then
								nonMoveableItems = nonMoveableItems + 1700
							end
						end
					end
				end
			end

			if lastItem then 
				receiptItems = {}
				table.insert(receiptItems, {"Üres garázs", emptyGaragePrice})

				if nonMoveableItems > 0 then
					table.insert(receiptItems, {"Nem mozdítható tárgyak", nonMoveableItems})
				end

				--outputChatBox("utolsó")

				showLastReceipt()
			else
				--outputChatBox("asd")
				setElementPosition(localPlayer, 218.28240966797,14.663722991943,2.578125)
				setElementDimension(localPlayer, 0)
			
				inInterior = false

				destroyInteriorObjects()
			end

			break
		end
	end
end

cour = dxCreateFont("files/cour.ttf", 13)
local receiptFullPrice = 0
function renderReceipt()
	dxDrawImage(sx * 0.5 - 361.6/2/myX*sx, sy * 0.5 - 549.6/2/myY*sy, 361.6/myX*sx, 549.6/myY*sy, "files/receipt.png")
	
	receiptFullPrice = 0

	local startY = sy*0.455
	for k, v in ipairs(receiptItems) do 
		dxDrawText(v[1], sx*0.407, startY, sx*0.58, startY + sy*0.02, tocolor(0, 0, 0, 240), 0.8/myX*sx, cour, "left", "bottom")
		dxDrawText(v[2] .. "$", sx*0.407, startY, sx*0.59, startY + sy*0.02, tocolor(0, 0, 0, 240), 0.8/myX*sx, cour, "right", "bottom")

		startY = startY + sy*0.02

		receiptFullPrice = receiptFullPrice + v[2]
	end

	dxDrawText("Teljes összeg: ".. receiptFullPrice .. "$", sx*0.407, sy*0.695, sx*0.59, sy*0.695 + sy*0.02, tocolor(0, 0, 0, 240), 0.9/myX*sx, cour, "right", "bottom")

	core:dxDrawButton(sx * 0.5 - 361.6/2/myX*sx, sy*0.78, 361.6/myX*sx / 2 - 2/myX*sx, sy*0.035, r, g, b, 200, "Raktár eladása", tocolor(255, 255, 255), 1, font:getFont("condensed", 10/myX*sx), false)

	if transporterCar == "loading" then 
		core:dxDrawButton(sx * 0.5 - 361.6/2/myX*sx + 361.6/myX*sx / 2 + 2/myX*sx, sy*0.78, 361.6/myX*sx / 2 - 2/myX*sx, sy*0.035, r, g, b, 100, "...", tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 10/myX*sx), false)
	elseif transporterCar and nonMoveableItems > 0 then 
		core:dxDrawButton(sx * 0.5 - 361.6/2/myX*sx + 361.6/myX*sx / 2 + 2/myX*sx, sy*0.78, 361.6/myX*sx / 2 - 2/myX*sx, sy*0.035, r, g, b, 200, "Raktár eladása, kipakolás", tocolor(255, 255, 255), 1, font:getFont("condensed", 10/myX*sx), false)
	elseif transporterCar == false then 
		core:dxDrawButton(sx * 0.5 - 361.6/2/myX*sx + 361.6/myX*sx / 2 + 2/myX*sx, sy*0.78, 361.6/myX*sx / 2 - 2/myX*sx, sy*0.035, r, g, b, 100, "Nincs jármű", tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 10/myX*sx), false)
	elseif nonMoveableItems <= 0 then 
		core:dxDrawButton(sx * 0.5 - 361.6/2/myX*sx + 361.6/myX*sx / 2 + 2/myX*sx, sy*0.78, 361.6/myX*sx / 2 - 2/myX*sx, sy*0.035, r, g, b, 100, "Nincs kipakolható tárgy", tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 10/myX*sx), false)
	end

	core:dxDrawButton(sx * 0.5 - 361.6/2/myX*sx, sy*0.82, 361.6/myX*sx, sy*0.035, 59, 161, 217, 250, "Kilépés eladás nélkül", tocolor(255, 255, 255), 1, font:getFont("condensed", 10/myX*sx), false)


end

function keyReceipt(key, state)
	if key == "mouse1" and state then 
		if core:isInSlot(sx * 0.5 - 361.6/2/myX*sx, sy*0.78, 361.6/myX*sx / 2 - 2/myX*sx, sy*0.035) then -- eladás kipakolás nélkül
			local interiors = getElementData(resourceRoot, "garageBid:savedGarages") or {}
			local charid = getElementData(localPlayer, "char:id")
			for k, v in ipairs(interiors) do 
				if v[1] == charid then 
					for k2, v2 in pairs(v[2]) do 
						if v2 then
							if type(v2) == "table" then
								if v2[8] then 
									triggerServerEvent("garageBid > sellGarage > giveCar", resourceRoot, v2)
									break
								end
							end
						end
					end
				end
			end

			triggerServerEvent("garageBid > sellGarage", resourceRoot, getElementData(localPlayer, "char:id"), receiptFullPrice)
			setElementPosition(localPlayer, 218.28240966797,14.663722991943,2.578125)
			setElementDimension(localPlayer, 0)
			removeEventHandler("onClientRender", root, renderTooltip)
			unbindKey("e", "up", exitInterior)
			toggleLastReceipt()
			outputChatBox(core:getServerPrefix("server", "Raktár eladás", 2).."Eladtad a raktárodat "..color..receiptFullPrice.."$#ffffff-ért.", 255, 255, 255, true)
			inInterior = false

			destroyInteriorObjects()
		elseif core:isInSlot(sx * 0.5 - 361.6/2/myX*sx + 361.6/myX*sx / 2 + 2/myX*sx, sy*0.78, 361.6/myX*sx / 2 - 2/myX*sx, sy*0.035) then -- eladás kipakolással
			if transporterCar and nonMoveableItems > 0 then 

				local furnitures = {}

				local interiors = getElementData(resourceRoot, "garageBid:savedGarages") or {}
				local charid = getElementData(localPlayer, "char:id")
				for k, v in ipairs(interiors) do 
					if v[1] == charid then 
						for k2, v2 in pairs(v[2]) do 
							if v2 then
								if type(v2) == "table" then
									if objectLoots[v2[1]] then 
										lastItem = false 
										break 
									else
										table.insert(furnitures, v2[1])
									end
								end
							end
						end
					end
				end

				setElementData(transporterCar, "veh:garageBid:items", furnitures)

				triggerServerEvent("garageBid > sellGarage", resourceRoot, getElementData(localPlayer, "char:id"), receiptItems[1][2])
				setElementPosition(localPlayer, 218.28240966797,14.663722991943,2.578125)
				setElementDimension(localPlayer, 0)
				removeEventHandler("onClientRender", root, renderTooltip)
				unbindKey("e", "up", exitInterior)
				toggleLastReceipt()
				outputChatBox(core:getServerPrefix("server", "Raktár eladás", 2).."Eladtad a raktárodat "..color..receiptItems[1][2].."$#ffffff-ért.", 255, 255, 255, true)
				inInterior = false

				destroyInteriorObjects()

			else
				outputChatBox(core:getServerPrefix("red-dark", "Raktár eladás", 2).."Ez a művelet nem lehetséges.", 255, 255, 255, true)
			end
		elseif core:isInSlot(sx * 0.5 - 361.6/2/myX*sx, sy*0.82, 361.6/myX*sx, sy*0.035) then 
			setElementPosition(localPlayer, 218.28240966797,14.663722991943,2.578125)
			setElementDimension(localPlayer, 0)
			unbindKey("e", "up", exitInterior)
			inInterior = false

			destroyInteriorObjects()

			toggleLastReceipt()
		end
	end
end

function showLastReceipt()
	setElementFrozen(localPlayer, true)
	addEventHandler("onClientRender", root, renderReceipt)
	addEventHandler("onClientKey", root, keyReceipt)
	getTransporterCar()
end

function toggleLastReceipt()
	setElementFrozen(localPlayer, false)
	removeEventHandler("onClientRender", root, renderReceipt)
	removeEventHandler("onClientKey", root, keyReceipt)
end

function enterInterior()
	removeEventHandler("onClientRender", root, renderTooltip)
	unbindKey("e", "up", enterInterior)

	local interiors = getElementData(resourceRoot, "garageBid:savedGarages") or {}

	local charid = getElementData(localPlayer, "char:id")
	local intfound = false
	for k, v in ipairs(interiors) do 
		if v[1] == charid then 
			setElementFrozen(localPlayer, true)

			showLoadingScreen({"Interior betöltése", "Garázs betöltése", "Karakter betöltése"})
			showChat(false)
			exports.oInterface:toggleHud(true)

			setTimer(function()
				setElementDimension(localPlayer, getElementData(localPlayer, "playerid"))
				inInterior = true
				setTimer(function()
					print(toJSON(v[2]))
					generateGarage(v[2], _, false)
					
					setElementPosition(localPlayer, 168.81495666504,226.6270904541,67.797813415527)

					setTimer(function()
						showChat(true)
						exports.oInterface:toggleHud(false)		
						setElementFrozen(localPlayer, false)
					end, 2000, 1)
				end, 4000, 1)
				
			end, 3000, 1)

			intfound = true
			break
		end
	end

	if not intfound then 
		outputChatBox(core:getServerPrefix("red-dark", "Bejárat", 2).."Nincs megvásárolt garázsod! Menj és licitálj egyre Mikenál.", 255, 255, 255, true)
	end
end

addEventHandler("onClientMarkerHit", resourceRoot, function(player, mdim)
	if player == localPlayer then
		if mdim then 
			if source == intMarker then 
				intTitleText = "Bejárat"
				tooltipText = "A belépéshez"

				interiorTick = getTickCount()
				addEventHandler("onClientRender", root, renderTooltip)
				bindKey("e", "up", enterInterior)
			elseif source == exitMarker then 
				intTitleText = "Kijárat"
				tooltipText = "A kilépéshez"

				interiorTick = getTickCount()
				inExitMarker = true 
				addEventHandler("onClientRender", root, renderTooltip)
				bindKey("e", "up", exitInterior)
			end
		end
	end
end)

addEventHandler("onClientMarkerLeave", getRootElement(), function(player, mdim)
	if player == localPlayer then
		if mdim then 
			if source == exitMarker then 
				inExitMarker = false 
				removeEventHandler("onClientRender", root, renderTooltip)
				unbindKey("e", "up", exitInterior)
			elseif source == intMarker then 
				removeEventHandler("onClientRender", root, renderTooltip)
				unbindKey("e", "up", enterInterior)
			end 
		end 
	end 
end)

function destroyInteriorObjects()
	local intObjs = 0
	local wallObjs = 0
	for k, v in ipairs(interiorObjects) do 
		if isElement(v) then 
			destroyElement(v) 
			intObjs = intObjs + 1
		end 
	end

	for k, v in ipairs(garageIntObjs) do
		if isElement(v) then 
			destroyElement(v) 
			wallObjs = wallObjs + 1
		end 
	end

	print("Törölve ", intObjs, "db interior object és ", wallObjs, "db fal object")

	garageIntObjs = {}
	interiorObjects = {}
end

-- Loading screen 
local loadingTick, loadingAlpha, loadingAnimType = getTickCount(), 0, "open"
local rotTick = getTickCount()
local loadText = ""
function renderLoad()
	if loadingAnimType == "open" then 
		loadingAlpha = interpolateBetween(loadingAlpha, 0, 0, 1, 0, 0, (getTickCount() - loadingTick) / 3000, "InOutQuad")
	else
		loadingAlpha = interpolateBetween(loadingAlpha, 0, 0, 0, 0, 0, (getTickCount() - loadingTick) / 3000, "InOutQuad")
	end

	dxDrawImage(0, 0, sx, sy, "files/load/load.jpg", 0, 0, 0, tocolor(255, 255, 255, 255 * loadingAlpha))
	dxDrawImage(0, sy*0.1 - (sy*0.1 * loadingAlpha), sx, sy, "files/load/orp.png", 0, 0, 0, tocolor(255, 255, 255, 255 * loadingAlpha))

	rot = interpolateBetween(0,0,0,360,0,0,(getTickCount() - rotTick)/1000, "Linear")
    if rot >= 360 then 
        rotTick = getTickCount()
        rot = 0
    end

	dxDrawImage(sx*0.5 - (40/myX*sx) * loadingAlpha, sy*0.86 - (40/myX*sx * loadingAlpha), 80/myX*sx * loadingAlpha, 80/myX*sx * loadingAlpha, "files/load/circle2.png", 0, 0, 0, tocolor(255, 255, 255, 50 * loadingAlpha))
	dxDrawImage(sx*0.5 - (40/myX*sx) * loadingAlpha, sy*0.86 - (40/myX*sx * loadingAlpha), 80/myX*sx * loadingAlpha, 80/myX*sx * loadingAlpha, "files/load/circle1.png", -rot, 0, 0, tocolor(255, 255, 255, 255 * loadingAlpha))

	dxDrawText(loadText, 0, sy*0.6 - (sy*0.1 * loadingAlpha), sx, sy*0.65 - (sy*0.1 * loadingAlpha), tocolor(255, 255, 255, 150 * loadingAlpha), 0.7 * loadingAlpha, font:getFont("p_bo", 25/myX*sx), "center", "center")
end

function showLoadingScreen(texts)
	loadingTick, loadingAlpha, loadingAnimType = getTickCount(), 0, "open"
	rotTick = getTickCount()
	addEventHandler("onClientRender", root, renderLoad)

	loadText = texts[1]

	setTimer(function()
		loadText = texts[2]
	end, 3000, 1)

	setTimer(function()
		loadText = texts[3]
	end, 7000, 1)

	setTimer(function()
		loadingTick, loadingAnimType = getTickCount(), "close"
		setTimer(function()
			removeEventHandler("onClientRender", root, renderLoad)
		end, 3000, 1)
	end, 9000, 1)
end


-- Car zones
local threeD = exports.o3DElements
addEventHandler("onClientRender", root, function()
	for k, v in ipairs(carColPositions) do 
		threeD:render3DZone(v[1], v[2], v[3], v[4], v[5], 255, 255, 255, 150, 15, 3, false)
	end

	threeD:render3DZone(furnitureDepo.col[1], furnitureDepo.col[2], furnitureDepo.col[3] + 0.35, furnitureDepo.col[4], furnitureDepo.col[5], r, g, b, 150, 25, 3, false)
end)

function getTransporterCar()
	transporterCar = "loading"
	triggerServerEvent("garageBid > getTransporterCar", resourceRoot)
end

addEvent("garageBid > returnTransporterCar", true)
addEventHandler("garageBid > returnTransporterCar", root, function(car)
	transporterCar = car
end)