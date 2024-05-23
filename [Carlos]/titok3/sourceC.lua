local isLightningModeActive = false
local boltTexture = dxCreateTexture("files/bolt.png")
local createdBolts = {}
local processBoltRender = false

addCommandHandler("villam",
	function ()
		if getElementData(localPlayer, "user:admin") >= 9 then
			isLightningModeActive = not isLightningModeActive
			outputChatBox("[format]#7cc576[fa-bolt] [Disaster]:#ffffff Villám mód " .. (isLightningModeActive and "#7cc576on" or "#d75959off") .. ".", 255, 255, 255, true)
		
			if isLightningModeActive then
				addEventHandler("onClientClick", getRootElement(), processWorldClick)
			else
				removeEventHandler("onClientClick", getRootElement(), processWorldClick)
			end
		end
	end
)

function processWorldClick(_, state, _, _, worldX, worldY, worldZ)
	if state == "down" and isLightningModeActive then
		triggerServerEvent("onLightning", localPlayer, worldX, worldY, worldZ)
	end
end

addEvent("onLightning", true)
addEventHandler("onLightning", getRootElement(),
	function (posX, posY, posZ)
		if not processBoltRender then
			addEventHandler("onClientPreRender", getRootElement(), renderTheBolts)
		end
		processBoltRender = true
	
		table.insert(createdBolts, {posX, posY, posZ, -500, 0, getTickCount(), getTickCount() + 750})
	end
)

function renderTheBolts()
	if #createdBolts <= 0 then
		if processBoltRender then
			removeEventHandler("onClientPreRender", getRootElement(), renderTheBolts)
		end
		processBoltRender = false
		return
	end
	
	for i = 1, #createdBolts do
		if createdBolts[i] then
			if createdBolts[i][6] then
				local thunderboltStartTick = (getTickCount() - createdBolts[i][6]) / 450
				if thunderboltStartTick >= 0 then
					createdBolts[i][4], createdBolts[i][5] = interpolateBetween(-60, 0, 0, 2, 255, 0, thunderboltStartTick, "Linear")
					
					if thunderboltStartTick > 1 then
						createdBolts[i][6] = false
						createExplosion(createdBolts[i][1], createdBolts[i][2], createdBolts[i][3] - 2, 4, false, -1)
						createExplosion(createdBolts[i][1], createdBolts[i][2], createdBolts[i][3] - 1, 11, false, 0.5)
						createFire(createdBolts[i][1], createdBolts[i][2], createdBolts[i][3] - 2, 1)
						setSoundMaxDistance(playSound3D("files/bolt.mp3", createdBolts[i][1], createdBolts[i][2], createdBolts[i][3]), 300)
					end
				end
			end
			
			if createdBolts[i][7] then
				local thunderboltEndTick = (getTickCount() - createdBolts[i][7]) / 500
				if thunderboltEndTick >= 0 then
					createdBolts[i][5] = interpolateBetween(255, 0, 0, 0, 0, 0, thunderboltEndTick, "Linear")
					
					if thunderboltEndTick > 1 then
						table.remove(createdBolts, i)
					end
				end
			end
			
			for depth = 1, 100 do
				dxDrawMaterialLine3D(createdBolts[i][1], createdBolts[i][2], createdBolts[i][3] - createdBolts[i][4] + 4.5 * (depth - 1), createdBolts[i][1], createdBolts[i][2], createdBolts[i][3] - createdBolts[i][4] + 4.5 * depth, boltTexture, 4, tocolor(245, 245, 255, createdBolts[i][5]))
			end
		end
	end
end

addEvent("onEarthquake", true)
addEventHandler("onEarthquake", getRootElement(),
	function (period)
		if isElement(earthquakeSound) then
			destroyElement(earthquakeSound)
		end
		
		earthquakeSound = playSound("files/earthquake.mp3", true)
		
		setTimer(destroyElement, 1000 * (period + 1), 1, earthquakeSound)
		setTimer(setCameraShakeLevel, 1000 * (period + 1), 1, 0)
		setTimer(setPedControlState, 1000 * (period + 1), 1, "left", false)
		setTimer(setPedControlState, 1000 * (period + 1), 1, "right", false)
		
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
		
		createExplosion(playerPosX, playerPosY, playerPosZ - 50, 12, false, 1, false)
		
		setTimer(
			function()
				local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
				createExplosion(playerPosX, playerPosY, playerPosZ - 50, 12, false, 1, false)
			end,
		500, period * 2)
		
		setTimer(
			function()
				setPedControlState("left", false)
				setPedControlState("right", false)
				
				if getPedControlState("forwards") then
					if math.random(1, 3) == 2 then
						setPedControlState("left", true)
					elseif math.random(1, 3) == 3 then
						setPedControlState("right", true)
					end
				end
			end,
		1000, period)
	end
)