-- Custom events
addEvent("onVehicleDirtLevelChange", true)

-- NEEDED!
addEvent("setVehicleGrungeServer", true)
addEvent("setVehicleDirtProgressServer", true)
addEvent("loadVehicleDirtServer", true)
addEvent("getNextDirtTimeServer", true)

local grungeLimit = 5

local changeParameter = {}

local currentProgress = {}
local doNotChangeMore = {}
local addGrungeTimer = {}

function setVehicleDirtLevel(vehicle, level)
	level = tonumber(level)
	if isValidDirtVehicle(vehicle) then
		if not level then level = 1 end
		
		triggerClientEvent(root , "handleDirtShader", vehicle, vehicle, level)
		
		local oldDirtLevel = getElementData(vehicle, "veh.dirtLevel") or 1
		local newDirtLevel = level
		triggerEvent("onVehicleDirtLevelChange", vehicle, oldDirtLevel, newDirtLevel)
		
		setElementData(vehicle, "veh.dirtLevel", newDirtLevel)
	end
	return false
end
addEventHandler("setVehicleGrungeServer", root, setVehicleDirtLevel)

function setVehicleDirtProgress(vehicle, progress)
	progress = tonumber(progress)
	if isValidDirtVehicle(vehicle) then
		if not progress then progress = 0 end
		
		currentProgress[vehicle] = progress
		setElementData(vehicle, "veh.dirtProgress", currentProgress[vehicle])
	end
	return false
end
addEventHandler("setVehicleDirtProgressServer", root, setVehicleDirtProgress)

function setVehicleDirtTime(vehicle, theTime)
	theTime = tonumber(theTime)
	if isValidDirtVehicle(vehicle) then
		if not theTime then theTime = 0 end
		
		addGrungeTimer[vehicle] = theTime
		setElementData(vehicle, "veh.dirtTime", addGrungeTimer[vehicle])
	end
	return false
end

addEventHandler("onVehicleDirtLevelChange", getRootElement(),
    function(oldLevel, newLevel)
		if debugEnabled then
			if source and isElement(source) then
				outputChatBox("#ff9632[SERVER EVENT] #FFFFFF" .. getVehicleName(source) .. ", old dirt level: #2399dd" .. oldLevel .. "#FFFFFF, new dirt level: #d7b428" .. newLevel, client, 255, 255, 255, true)
			end
		end
    end
)

function setVehicleGrungeCommand(player, commandName, amount)
	amount = tonumber(amount)
	if amount and type(amount) == "number" and amount >= 1 and amount <= 5 then
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle then
			setVehicleDirtLevel(vehicle, amount)
			setVehicleDirtProgress(vehicle, 0)
		end
	else
		outputChatBox("[ERROR]#FFFFFF Value must be between #d7b4281 #FFFFFFand #d7b4285 #FFFFFF.", player, 255, 0, 0, true)
	end
end
addCommandHandler("setgrunge", setVehicleGrungeCommand)

function isElementUnderSomething(element)
	--I need a working function there which checks if the element is under something on server side, maybe a client side trigger?
end

function startVehicleGrunge()
	setTimer(function()
		for k, vehicle in pairs(getElementsByType("vehicle")) do
			if isValidDirtVehicle(vehicle) then
				local grungeLevel = getVehicleDirtLevel(vehicle)
				
				changeParameter[vehicle] = {
					["regular"] = false,
					["water"] = false,
					["rain"] = false
				}
				
				if not isElementInWater(vehicle) then
					changeParameter[vehicle]["regular"] = true
					if (rainyWeathers[getWeather()]) then
						if not isElementUnderSomething(vehicle) then
							changeParameter[vehicle]["rain"] = true
							changeParameter[vehicle]["regular"] = false
						else
							changeParameter[vehicle]["rain"] = false
						end
					end
				else
					changeParameter[vehicle]["water"] = true
				end
				
				if changeParameter[vehicle]["regular"] then
					if isVehicleOnGround(vehicle) then
						if getVehicleSpeed(vehicle) >= vehicleSpeedLimit then
							if grungeLevel >= 1 and grungeLevel < grungeLimit then
								doNotChangeMore[vehicle] = false
							else
								doNotChangeMore[vehicle] = true
								currentProgress[vehicle] = 0
							end
							
							if not doNotChangeMore[vehicle] then
								--[[if (materialIDs[getSurfaceVehicleIsOn(vehicle)]) then
									regularSpeed = addGrungeOnDirtSpeed
									addGrungeTimer[vehicle] = addGrungeOnDirt
									if getControlState("handbrake") then
										addGrungeTimer[vehicle] = addGrungeTimer[vehicle]/5
									end
								end]]
								
								currentProgress[vehicle] = currentProgress[vehicle] + addGrungeOnRegularSpeed
								setVehicleDirtTime(vehicle, addGrungeOnRegular)
								--addGrungeTimer[vehicle] = addGrungeOnRegular
								
								if debugEnabled then
									setVehicleDirtTime(vehicle, debugGrungeTimer)
									--addGrungeTimer[vehicle] = debugGrungeTimer
								end
								
								if grungeLevel == 1 then
									setVehicleDirtTime(vehicle, addGrungeTimer[vehicle]*2)
									--addGrungeTimer[vehicle] = addGrungeTimer[vehicle]*2
								end
								
								if currentProgress[vehicle] >= addGrungeTimer[vehicle] then
									currentProgress[vehicle] = 0
									if grungeLevel < grungeLimit then
										grungeLevel = grungeLevel+1
									else
										if debugEnabled then
											grungeLevel = 1
										else
											grungeLevel = grungeLimit
										end
									end
									
									if debugEnabled then
										outputChatBox("#826a53[DIRT]#FFFFFF New dirt level: #d7b428" .. grungeLevel, root, 255,255,255,true)
									end
									setVehicleDirtLevel(vehicle, grungeLevel)
									--triggerServerEvent("setVehicleGrungeServer", vehicle, vehicle, grungeLevel)
								end
							end
						else
							currentProgress[vehicle] = currentProgress[vehicle]
						end
					end
				end
				
				if changeParameter[vehicle]["water"] then
					if grungeLevel ~= 1 then
						doNotChangeMore[vehicle] = false
					else
						doNotChangeMore[vehicle] = true
						currentProgress[vehicle] = math.max(currentProgress[vehicle] - removeGrungeInWaterSpeed, 0)
					end
					
					if not doNotChangeMore[vehicle] then
						currentProgress[vehicle] = currentProgress[vehicle] + removeGrungeInWaterSpeed
						setVehicleDirtTime(vehicle, removeGrungeInWater)
						--addGrungeTimer[vehicle] = removeGrungeInWater
						
						if debugEnabled then
							setVehicleDirtTime(vehicle, debugGrungeTimer)
							--addGrungeTimer[vehicle] = debugGrungeTimer
						end
					
						if currentProgress[vehicle] >= addGrungeTimer[vehicle] then
							currentProgress[vehicle] = 0
							if grungeLevel ~= 1 then
								grungeLevel = grungeLevel-1
							else
								grungeLevel = 1
							end
							
							if debugEnabled then
								outputChatBox("#b1eced[WATER]#FFFFFF New dirt level: #d7b428" .. grungeLevel, root, 255,255,255,true)
							end
							setVehicleDirtLevel(vehicle, grungeLevel)
							--triggerServerEvent("setVehicleGrungeServer", vehicle, vehicle, grungeLevel)
						end
					end
				end
				
				if changeParameter[vehicle]["rain"] then
					if grungeLevel > 2 then
						doNotChangeMore[vehicle] = false
					else
						doNotChangeMore[vehicle] = true
						currentProgress[vehicle] = math.max(currentProgress[vehicle] - removeGrungeInWaterSpeed, 0)
					end
					
					if not doNotChangeMore[vehicle] then
						currentProgress[vehicle] = currentProgress[vehicle] + removeGrungeInRainSpeed
						setVehicleDirtTime(vehicle, removeGrungeInRain)
						--addGrungeTimer[vehicle] = removeGrungeInRain
						
						if debugEnabled then
							setVehicleDirtTime(vehicle, debugGrungeTimer)
							--addGrungeTimer[vehicle] = debugGrungeTimer
						end
						
						if currentProgress[vehicle] >= addGrungeTimer[vehicle] then	
							currentProgress[vehicle] = 0
							if grungeLevel > 2 then
								grungeLevel = grungeLevel-1
							elseif grungeLevel < 2 then
								grungeLevel = 1
							else
								grungeLevel = 2
							end
							
							if debugEnabled then
								outputChatBox("#385b8c[RAIN]#FFFFFF New dirt level: #d7b428" .. grungeLevel, root, 255,255,255,true)
							end
							setVehicleDirtLevel(vehicle, grungeLevel)
							--triggerServerEvent("setVehicleGrungeServer", vehicle, vehicle, grungeLevel)
						end
					end
				end
				
				setVehicleDirtProgress(vehicle, currentProgress[vehicle])
			end
		end
	end, dirtRefreshFrequency, 0)
end

function loadVehicleDirt(vehicle)
	if isValidDirtVehicle(vehicle) then
		currentProgress[vehicle] = getVehicleDirtProgress(vehicle)
		setVehicleDirtProgress(vehicle, currentProgress[vehicle])
		setVehicleDirtTime(vehicle, 0)
		
		local grungeValue = getVehicleDirtLevel(vehicle)
		if not grungeValue or grungeValue < 1 then
			grungeValue = 1
		elseif grungeValue > grungeLimit then
			grungeValue = grungeLimit
		end
		
		setVehicleDirtLevel(vehicle, grungeValue)
	end
end
addEventHandler("loadVehicleDirtServer", root, loadVehicleDirt)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
	function()
		setTimer(function()
			startVehicleGrunge()
			
			for k, vehicle in pairs(getElementsByType("vehicle")) do
				loadVehicleDirt(vehicle)
			end
		end, 100, 1)
	end
)