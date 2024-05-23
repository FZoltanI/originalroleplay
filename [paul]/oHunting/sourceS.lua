pedTable = {}
unSyncTable = {}
lastUpdate = {}
createdAnimals = {}

UPDATE_INTERVAL_MS = 2000
UPDATE_INTERVAL_MS_INV = 1 / UPDATE_INTERVAL_MS
UPDATE_INTERVAL_S = UPDATE_INTERVAL_MS * 0.001
UPDATE_INTERVAL_S_INV = 1 / UPDATE_INTERVAL_S

respawnTime = 30*60*1000 -- 30 perc

maximumAttackDistance = 100 -- yard

local enableCollisionChecking = false
local colSphereRadius = 20

function round2(num, idp)
    return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()

        setTimer(doRespawn, respawnTime, 0)

        if debugMode then
			for k,v in ipairs(availableAnimals) do
				for i,l in ipairs(v["waypoints"]) do
					createPickup(l[1], l[2], l[3], 3, 1239, 1)
				end
			end
		end

        for k,v in ipairs(availableAnimals) do
            createdAnimals[k] = {}
			createdAnimals[k]["id"] = k
         --   outputChatBox(k)
            createdAnimals[k]["currentTask"] = {"walkToPos", v["waypoints"][2][1], v["waypoints"][2][2], v["waypoints"][2][3], 1}
			createdAnimals[k]["pedElement"] = createPed(availableTypes[v["animalType"]]["skin"], v["waypoints"][1][1], v["waypoints"][1][2], v["waypoints"][1][3])
            if isElement(createdAnimals[k]["pedElement"]) then
				setElementData(createdAnimals[k]["pedElement"], "animalId", k)
				setElementData(createdAnimals[k]["pedElement"], "ped.extraDamage", availableTypes[v["animalType"]]["hitDamage"])
				setElementData(createdAnimals[k]["pedElement"], "currentWayPoint", 2)
				setElementData(createdAnimals[k]["pedElement"], "animal:loot", availableTypes[v["animalType"]]["loot"])
				setElementData(createdAnimals[k]["pedElement"], "animal:type", v["animalType"])
                setElementData(createdAnimals[k]["pedElement"], "ped:name", availableTypes[v["animalType"]]["name"])
                setElementData(createdAnimals[k]["pedElement"], "ped:prefix", "Animal")
				setElementData(createdAnimals[k]["pedElement"], "autoAttack", availableTypes[v["animalType"]]["autoAttack"])
                makePedControllable(createdAnimals[k]["pedElement"], "walk", 1)

                setElementData(createdAnimals[k]["pedElement"], "ped.extraHealth", availableTypes[v["animalType"]]["health"])

                addPedTask(createdAnimals[k]["pedElement"], {"walkToPos", v["waypoints"][2][1], v["waypoints"][2][2], v["waypoints"][2][3], 1})

                createdAnimals[k]["colShape"] = createColSphere(v["waypoints"][1][1], v["waypoints"][1][2], v["waypoints"][1][3], colSphereRadius)
                if isElement(createdAnimals[k]["colShape"]) then
					attachElements(createdAnimals[k]["colShape"], createdAnimals[k]["pedElement"])
					setElementData(createdAnimals[k]["colShape"], "animalId", k)

                    createdAnimals[k]["collisionObject"] = createObject(collisionObjectId, v["waypoints"][1][1], v["waypoints"][1][2], v["waypoints"][1][3])
					if isElement(createdAnimals[k]["collisionObject"]) then
						attachElements(createdAnimals[k]["collisionObject"], createdAnimals[k]["pedElement"], 0, 0, 0, 0, 0, 90)
						setElementData(createdAnimals[k]["collisionObject"], "animalId", k)

						setElementAlpha(createdAnimals[k]["collisionObject"], 0)

						setElementCollisionsEnabled(createdAnimals[k]["collisionObject"], false)
					end
                end
            end
        end
    end,
true, "high+999999")

function doRespawn() 

end

function destroyAnimal(animalId)
	if animalId then
		local animalId = tonumber(animalId)
		if createdAnimals[animalId] then
			if isElement(createdAnimals[animalId]["pedElement"]) then
				destroyElement(createdAnimals[animalId]["pedElement"])
			end
			if isElement(createdAnimals[animalId]["colShape"]) then
				destroyElement(createdAnimals[animalId]["colShape"])
			end
			if isElement(createdAnimals[animalId]["collisionObject"]) then
				destroyElement(createdAnimals[animalId]["collisionObject"])
			end
		end
	end
end

addEventHandler("onPedWasted", getRootElement(),
	function (totalAmmo, killerElement)
		if isElement(source) then
			local animalId = tonumber(getElementData(source, "animalId"))
			if createdAnimals[animalId] then
				if isElement(createdAnimals[animalId]["collisionObject"]) then
					setElementCollisionsEnabled(createdAnimals[animalId]["collisionObject"], true)
				end
			end
		end
	end
)

addEvent("acceptAnimation", true)
addEventHandler("acceptAnimation", getRootElement(),
	function ()
		setPedAnimation(source, "BOMBER", "BOM_Plant", -1, true, false, false, false)
	end
)

addEvent("stopAnimation", true)
addEventHandler("stopAnimation", getRootElement(),
	function ()
		setPedAnimation(source)
	end
)

addEventHandler("onColShapeHit", getRootElement(),
	function (hitElement, matchingDimension)
		if isElement(hitElement) then
			if matchingDimension then
				if getElementType(hitElement) == "player" then
					if getElementData(hitElement, "user:loggedin") and not getElementData(hitElement, "user:aduty") then
						local animalId = tonumber(getElementData(source, "animalId"))
						if animalId then
							if createdAnimals[animalId] then
								if isElement(createdAnimals[animalId]["pedElement"]) then
									if not isPedDead(createdAnimals[animalId]["pedElement"]) then
										--if not getElementData(createdAnimals[animalId]["pedElement"], "animalPos") then
											local thisTask = getElementData(createdAnimals[animalId]["pedElement"], "huntingAnimal.thisTask")
											if thisTask then
											
												local lastTask = getElementData(createdAnimals[animalId]["pedElement"], "huntingAnimal.task." .. thisTask)
												if lastTask then
													if lastTask[1] ~= "killPed" and getElementData(createdAnimals[animalId]["pedElement"], "autoAttack") then
														clearPedTasks(createdAnimals[animalId]["pedElement"])
														setPedWalkSpeed(createdAnimals[animalId]["pedElement"], "run")
														addPedTask(createdAnimals[animalId]["pedElement"], {"killPed", hitElement, 5, 1})

														local posX, posY, posZ = getElementPosition(hitElement)

														setElementData(createdAnimals[animalId]["pedElement"], "animalPos", {posX, posY, posZ})
													end
												end
											end
										--end
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler("onColShapeLeave", getRootElement(),
	function (hitElement, matchingDimension)
		if isElement(hitElement) then
			if matchingDimension then
				if getElementType(hitElement) == "player" then
					if getElementData(hitElement, "user:loggedin") then
						local animalId = tonumber(getElementData(source, "animalId"))
						if animalId then
							if createdAnimals[animalId] then
								if isElement(createdAnimals[animalId]["pedElement"]) then
									if not isPedDead(createdAnimals[animalId]["pedElement"]) then
										--if not getElementData(createdAnimals[animalId]["pedElement"], "animalPos") then
											local thisTask = getElementData(createdAnimals[animalId]["pedElement"], "huntingAnimal.thisTask")
											if thisTask then
												local lastTask = getElementData(createdAnimals[animalId]["pedElement"], "huntingAnimal.task." .. thisTask)
												if lastTask then
													if lastTask[1] == "killPed" then
														clearPedTasks(createdAnimals[animalId]["pedElement"])
														makePedControllable(createdAnimals[animalId]["pedElement"], "walk", 1)
														local k = createdAnimals[animalId]["id"]
														--addPedTask(createdAnimals[animalId]["pedElement"], {"walkToPos", availableAnimals[k]["waypoints"][1][1], availableAnimals[k]["waypoints"][1][2], availableAnimals[k]["waypoints"][1][3]})
														setElementData(createdAnimals[animalId]["pedElement"], "currentWayPoint", 1)
														addPedTask(createdAnimals[animalId]["pedElement"], {"walkToPos", availableAnimals[animalId]["waypoints"][1][1], availableAnimals[animalId]["waypoints"][1][2], availableAnimals[animalId]["waypoints"][1][3], 1})
														setElementData(createdAnimals[animalId]["pedElement"], "animalPos", false)
													end
												end
											end
										--end
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

function finishTask(pedElement, taskData)
	if isElement(pedElement) then
		if not isPedDead(pedElement) then
			local animalId = tonumber(getElementData(pedElement, "animalId"))
			if animalId then
				if createdAnimals[animalId] then
					if taskData[1] == "walkToPos" then
						local currentWayPoint = tonumber(getElementData(pedElement, "currentWayPoint"))
						if currentWayPoint then
							if availableAnimals[animalId] then
								if availableAnimals[animalId]["waypoints"] then

									setPedWalkSpeed(pedElement, "walk")

									local nextWayPoint = currentWayPoint + 1
									if currentWayPoint + 1 > #availableAnimals[animalId]["waypoints"] then
										nextWayPoint = 1
									end
									if availableAnimals[animalId]["waypoints"][nextWayPoint] then
										setElementData(createdAnimals[animalId]["pedElement"], "currentWayPoint", nextWayPoint)
										addPedTask(pedElement, {"walkToPos", availableAnimals[animalId]["waypoints"][nextWayPoint][1], availableAnimals[animalId]["waypoints"][nextWayPoint][2], availableAnimals[animalId]["waypoints"][nextWayPoint][3], 1})
										setElementData(createdAnimals[animalId]["pedElement"], "animalPos", false)
									end
								end
							end
						end
					elseif taskData[1] == "killPed" then
						clearPedTasks(pedElement)
						setPedWalkSpeed(pedElement, "walk")

						local currentWayPoint = tonumber(getElementData(pedElement, "currentWayPoint"))
						if currentWayPoint then
							local currentWayPoint = currentWayPoint - 1
							if availableAnimals[animalId] then
								if availableAnimals[animalId]["waypoints"] then
									if not availableAnimals[animalId]["waypoints"][currentWayPoint] then
										currentWayPoint = 1
									end
									if availableAnimals[animalId]["waypoints"][currentWayPoint] then
										setElementData(createdAnimals[animalId]["pedElement"], "currentWayPoint", currentWayPoint)
										addPedTask(pedElement, {"walkToPos", availableAnimals[animalId]["waypoints"][currentWayPoint][1], availableAnimals[animalId]["waypoints"][currentWayPoint][2], availableAnimals[animalId]["waypoints"][currentWayPoint][3], 1})
										setElementData(createdAnimals[animalId]["pedElement"], "animalPos", false)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function makePedControllable(pedElement, walkSpeed, attackAccuracy)
	if isElement(pedElement) then
		if getElementType(pedElement) == "ped" then
			if not pedTable[pedElement] then -- Már használva lett a funkció
				if walkSpeed and not NPC_SPEED_ONFOOT[walkSpeed] then
					return false
				end

				if attackAccuracy then -- pontosság
					attackAccuracy = tonumber(attackAccuracy)
					if not attackAccuracy or attackAccuracy < 0 or attackAccuracy > 1 then
						return false
					end
				end

				addEventHandler("onElementDataChange", pedElement, cleanUpDoneTasks)
				addEventHandler("onElementDestroy", pedElement, destroyNPCInformationOnDestroy)

				pedTable[pedElement] = true
				setElementData(pedElement, "huntingAnimal.isControllable", true)
				addNPCToUnsyncedList(pedElement)
				
				setPedWalkSpeed(pedElement, walkSpeed or "sprint")
				setPedWeaponAccuracy(pedElement, attackAccuracy or 1)

				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function setPedWalkSpeed(pedElement, walkSpeed)
	if isElement(pedElement) then
		if pedTable[pedElement] then
			if walkSpeed == "walk" or walkSpeed == "run" or walkSpeed == "sprint" or walkSpeed == "sprintfast" then
				setElementData(pedElement, "huntingAnimal.walk_speed", walkSpeed)
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function setPedWeaponAccuracy(pedElement, attackAccuracy)
	if isElement(pedElement) then
		if pedTable[pedElement] then
			attackAccuracy = tonumber(attackAccuracy)
			if not attackAccuracy or attackAccuracy < 0 or attackAccuracy > 1 then
				return false
			end

			setElementData(pedElement, "huntingAnimal.attackAccuracy", attackAccuracy)
			return true
		else
			return false
		end
	else
		return false
	end
end


------------------------------------------------

function addPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		if pedTable[pedElement] then

			if not isTaskValid(selectedTask) then
				return false
			end

			local lastTask = getElementData(pedElement, "huntingAnimal.lastTask")
			if not lastTask then
				lastTask = 1
				setElementData(pedElement, "huntingAnimal.thisTask", 1)
			else
				lastTask = lastTask + 1
			end

			--outputDebugString("lastTask -> " .. lastTask)
			setElementData(pedElement, "huntingAnimal.task." .. lastTask, selectedTask)
			setElementData(pedElement, "huntingAnimal.lastTask", lastTask)
			return true
		else
			return false
		end
	else
		return false
	end
end

function clearPedTasks(pedElement)
	if isElement(pedElement) then
		if pedTable[pedElement] then
			local thisTask = getElementData(pedElement, "huntingAnimal.thisTask")
			if thisTask then
			
				local lastTask = getElementData(pedElement, "huntingAnimal.lastTask")
				for currentTask = thisTask, lastTask do
					removeElementData(pedElement,"huntingAnimal.task." .. currentTask)
				end

				removeElementData(pedElement, "huntingAnimal.thisTask")
				removeElementData(pedElement, "huntingAnimal.lastTask")
				return true
			end
		else
			return false
		end
	else
		return false
	end
end

function setPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		if pedTable[pedElement] then
			if not isTaskValid(selectedTask) then
				return false
			end

			clearPedTasks(pedElement)
			setElementData(pedElement, "huntingAnimal.task.1", selectedTask)
			setElementData(pedElement, "huntingAnimal.thisTask", 1)
			setElementData(pedElement, "huntingAnimal.lastTask", 1)
			return true
		else
			return false
		end
	else
		return false
	end
end

function isTaskValid(selectedTask)
	local taskFunction = taskValid[selectedTask[1]]
	if taskFunction then
		return taskFunction(selectedTask)
	else
		return false
	end
end

function makePedWalkToPos(pedElement, targetX, targetY, targetZ, closestDistance)
	local originalX, originalY, originalZ = targetX, targetY, targetZ
	local pedX, pedY, pedZ = getElementPosition(pedElement)
	local walkDistance = NPC_SPEED_ONFOOT[getNPCWalkSpeed(pedElement)] * closestDistance * 0.001
	local distanceX, distanceY, distanceZ = targetX - pedX, targetY - pedY, targetZ - pedZ
	local distance = getDistanceBetweenPoints3D(0, 0, 0, distanceX, distanceY, distanceZ)

	distanceX, distanceY, distanceZ = distanceX / distance, distanceY / distance, distanceZ / distance
	local closestDistanceConst = closestDistance

	if distance < walkDistance then
		closestDistance = closestDistance * distance / walkDistance
		walkDistance = distance
	end

	local model = getElementModel(pedElement)
	targetX, targetY, targetZ = pedX + distanceX * walkDistance, pedY + distanceY * walkDistance, pedZ + distanceZ * walkDistance
	local rotation = -math.deg(math.atan2(distanceX, distanceY))

	local doMove = true
	if enableCollisionChecking then
		local boxCurrent = createModelIntersectionBox(model, targetX, targetY, targetZ, rotation)
		local boxPrevious = getElementIntersectionBox(pedElement)
		doMove = not doesModelBoxIntersect(boxCurrent, getElementDimension(pedElement), boxPrevious)
	end

	if doMove then
		if isNaN(targetX) or isNaN(targetY) or isNaN(targetZ) or isNaN(rotation) then
			outputDebugString("Hunting got NaN [" .. originalX .. ", " .. originalY .. ", " .. originalZ .. "] (PED ID: " .. tostring(getElementData(pedElement, "animalId")) .. ")")
		else
 			setElementPosition(pedElement, targetX, targetY, targetZ, false)
 			setPedRotation(pedElement, rotation)
 		end

		if enableCollisionChecking then 
			updateElementColData(pedElement) 
		end
		return closestDistance
	else
		setElementPosition(pedElement, pedX, pedY, pedZ)
		setPedRotation(pedElement, getPedRotation(pedElement))
		return closestDistanceConst
	end
end

function makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off,maxtime)
	local x_this,y_this,z_this = getElementPosition(npc)
	local walk_dist = NPC_SPEED_ONFOOT[getNPCWalkSpeed(npc)]*maxtime*0.001
	local p2_this = getPercentageInLine(x_this,y_this,x1,y1,x2,y2)
	local p1_this = 1-p2_this
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	local p2_next = p2_this+walk_dist/len
	local p1_next = 1-p2_next
	local x_next,y_next,z_next
	local maxtime_unm = maxtime
	if p2_next > 1 then
		maxtime = maxtime*(1-p2_this)/(p2_next-p2_this)
		x_next,y_next,z_next = x2,y2,z2
	else
		x_next = x1*p1_next+x2*p2_next
		y_next = y1*p1_next+y2*p2_next
		z_next = z1*p1_next+z2*p2_next
	end
	local model = getElementModel(npc)
	local rot = -math.deg(math.atan2(x2-x1,y2-y1))

	local move = true
	if enableCollisionChecking then
		local box = createModelIntersectionBox(model,x_next,y_next,z_next,rot)
		local boxprev = getElementIntersectionBox(npc)
		move = not doesModelBoxIntersect(box,getElementDimension(npc),boxprev)
	end
	if move then
		setElementPosition(npc,x_next,y_next,z_next,false)
		setPedRotation(npc,rot)
		if enableCollisionChecking then updateElementColData(npc) end
		return maxtime
	else
		setElementPosition(npc,x_this,y_this,z_this)
		setPedRotation(npc,getPedRotation(npc))
		return maxtime_unm
	end
end

function makeNPCWalkAroundBend(npc,x0,y0,x1,y1,z1,x2,y2,z2,off,maxtime)
	local x_this,y_this,z_this = getElementPosition(npc)
	local walk_dist = NPC_SPEED_ONFOOT[getNPCWalkSpeed(npc)]*maxtime*0.001
	local p2_this = getAngleInBend(x_this,y_this,x0,y0,x1,y1,x2,y2)/math.pi*2
	local p1_this = 1-p2_this
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	local p2_next = p2_this+walk_dist/len
	local p1_next = 1-p2_next
	local x_next,y_next,z_next,a_next
	local maxtime_unm = maxtime
	if p2_next > 1 then
		maxtime = maxtime*(1-p2_this)/(p2_next-p2_this)
		x_next,y_next,z_next = x2,y2,z2
		a_next = -math.deg(math.atan2(x0-x1,y0-y1))
	else
		x_next,y_next = getPosFromBend(p2_next*math.pi*0.5,x0,y0,x1,y1,x2,y2)
		z_next = z1*p1_next+z2*p2_next
		local x_next_front,y_next_front = getPosFromBend(p2_next*math.pi*0.5+0.01,x0,y0,x1,y1,x2,y2)
		a_next = -math.deg(math.atan2(x_next_front-x_next,y_next_front-y_next))
	end
	local model = getElementModel(npc)

	local move = true
	if enableCollisionChecking then
		local box = createModelIntersectionBox(model,x_next,y_next,z_next,a_next)
		local boxprev = getElementIntersectionBox(npc)
		move = not doesModelBoxIntersect(box,getElementDimension(npc),boxprev)
	end
	if move then
		setElementPosition(npc,x_next,y_next,z_next,false)
		setPedRotation(npc,a_next)
		if enableCollisionChecking then updateElementColData(npc) end
		return maxtime
	else
		setElementPosition(npc,x_this,y_this,z_this)
		setPedRotation(npc,getPedRotation(npc))
		return maxtime_unm
	end
end

performTask = {}

function performTask.walkToPos(pedElement, selectedTask, closestDistance)
	if getElementSyncer(pedElement) then 
		return closestDistance
	else
		return makePedWalkToPos(pedElement, selectedTask[2], selectedTask[3], selectedTask[4], closestDistance)
	end
end

function performTask.walkAlongLine(npc,task,maxtime)
	if getElementSyncer(npc) then return maxtime end
	return makeNPCWalkAlongLine(npc,task[2],task[3],task[4],task[5],task[6],task[7],task[8],maxtime)
end

function performTask.walkAroundBend(npc,task,maxtime)
	if getElementSyncer(npc) then return maxtime end
	return makeNPCWalkAroundBend(npc,task[2],task[3],task[4],task[5],task[6],task[7],task[8],task[9],task[10],maxtime)
end

function performTask.walkFollowElement(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

function performTask.shootPoint(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

function performTask.shootElement(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

function performTask.killPed(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

taskValid = {}

function taskValid.walkToPos(task)
	local x,y,z,dist = task[2],task[3],task[4],task[5]
	return tonumber(x) and tonumber(y) and tonumber(z) and tonumber(dist) and true or false
end

function taskValid.walkAlongLine(task)
	local x1,y1,z1 = task[2],task[3],task[4]
	local x2,y2,z2 = task[5],task[6],task[7]
	local off,enddist = task[8],task[9]
	return
		tonumber(x1) and tonumber(y1) and tonumber(z1) and
		tonumber(x2) and tonumber(y2) and tonumber(z2) and
		tonumber(off) and tonumber(enddist) and true or false
end

function taskValid.walkAroundBend(task)
	local bx,by = task[2],task[3]
	local x1,y1,z1 = task[4],task[5],task[6]
	local x2,y2,z2 = task[7],task[8],task[9]
	local off,enddist = task[10],task[11]
	return
		tonumber(bx) and tonumber(by) and
		tonumber(x1) and tonumber(y1) and tonumber(z1) and
		tonumber(x2) and tonumber(y2) and tonumber(z2) and
		tonumber(off) and tonumber(enddist) and true or false
end

function taskValid.walkFollowElement(task)
	local element,dist = task[2],task[3]
	return isElement(element) and getElementPosition(element) and tonumber(dist) and true or false
end

function taskValid.shootPoint(task)
	local x,y,z = task[2],task[3],task[4]
	return tonumber(x) and tonumber(y) and tonumber(z) and true or false
end

function taskValid.shootElement(task)
	local element = task[2]
	return isElement(element) and getElementPosition(element) and true or false
end

function taskValid.killPed(task)
	local element,shootdist,followdist = task[2],task[3],task[4]
	return
		--isElement(element) and getElementType(element) == "ped" and
		isElement(element) and
		tonumber(shootdist) and tonumber(followdist) and true or false
end

function cycleNPCs()
	for npc,exists in pairs(pedTable) do
		if isHLCEnabled(npc) then

			local animalPos = getElementData(npc, "animalPos")
			if animalPos then
				local currentX, currentY, currentZ = getElementPosition(npc)
				if getDistanceBetweenPoints3D(currentX, currentY, currentZ, animalPos[1], animalPos[2], animalPos[3]) >= maximumAttackDistance then
					local animalId = tonumber(getElementData(npc, "animalId"))
					if animalId then
						clearPedTasks(npc)

						local currentWayPoint = tonumber(getElementData(npc, "currentWayPoint"))
						if currentWayPoint then
							local currentWayPoint = currentWayPoint - 1
							if availableAnimals[animalId] then
								if availableAnimals[animalId]["waypoints"] then
									if not availableAnimals[animalId]["waypoints"][currentWayPoint] then
										currentWayPoint = 1
									end
									if availableAnimals[animalId]["waypoints"][currentWayPoint] then
										setElementData(createdAnimals[animalId]["pedElement"], "currentWayPoint", currentWayPoint)
										addPedTask(createdAnimals[animalId]["pedElement"], {"walkToPos", availableAnimals[animalId]["waypoints"][currentWayPoint][1], availableAnimals[animalId]["waypoints"][currentWayPoint][2], availableAnimals[animalId]["waypoints"][currentWayPoint][3], 1})
										setPedWalkSpeed(pedElement, "walk")
									end
								end
							end
						end
					end
				end
			end

			local syncer = getElementSyncer(getPedOccupiedVehicle(npc) or npc)
			if syncer then
				if unSyncTable[npc] then
					removeNPCFromUnsyncedList(npc)
				end
			else
				if not unSyncTable[npc] then
					addNPCToUnsyncedList(npc)
				end
			end
		else
			if unSyncTable[npc] then
				removeNPCFromUnsyncedList(npc)
			end
		end
	end
	local this_time = getTickCount()
	local gamespeed = getGameSpeed()
	for npc,unsynced in pairs(unSyncTable) do
		if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			local time_diff = (this_time-getNPCLastUpdateTime(npc))*gamespeed
			while time_diff > 1 do
				local thisTask = getElementData(npc,"huntingAnimal.thisTask")
				if thisTask then
					local task = getElementData(npc,"huntingAnimal.task."..thisTask)
					if not task then
						removeElementData(npc,"huntingAnimal.thisTask")
						removeElementData(npc,"huntingAnimal.lastTask")
						break
					else
						local prev_time_diff,prev_task = time_diff,task
						time_diff = time_diff-performTask[task[1]](npc,task,time_diff)
						if time_diff ~= time_diff then
							break
						end
						if time_diff > 1 then
							setPedTaskToNext(npc)
						end
					end
				else
					break
				end
			end
			updateNPCLastUpdateTime(npc,this_time)
		end
	end
end

function setPedTaskToNext(npc)
	local thisTask = getElementData(npc,"huntingAnimal.thisTask")
	setElementData(npc,"huntingAnimal.thisTask",thisTask+1)
end

function cleanUpDoneTasks(dataName, oldValue)
	if not noTrigger then
		--outputDebugString("oldValue: " .. oldValue)
		if oldValue then
			if dataName == "huntingAnimal.thisTask" then
				local newValue = getElementData(source, dataName)
				if newValue then

					if newValue < oldValue then
						noTrigger = true
						setElementData(source, dataName, oldValue)
						noTrigger = nil
					end

					for taskNumber = oldValue, newValue-1 do
						local taskString = "huntingAnimal.task." .. taskNumber
						local taskValue = getElementData(source, taskString)
						if taskValue then
							removeElementData(source, taskString)
							finishTask(source, taskValue)
						end
					end
				end
			end
		end
	end
end


function addNPCToUnsyncedListOnStopSync()
	addNPCToUnsyncedList(source)
end

function removeNPCFromUnsyncedListOnStartSync()
	removeNPCFromUnSyncedList(source)
end

function addNPCToUnsyncedList(npc)
	unSyncTable[npc] = true
	updateNPCLastUpdateTime(npc)
end

function removeNPCFromUnsyncedList(npc)
	unSyncTable[npc] = nil
	clearNPCLastUpdateTime(npc)
end

function destroyNPCInformationOnDestroy()
	destroyNPCInformation(source)
end

function destroyNPCInformation(npc)
	removeNPCFromUnsyncedList(npc)
	pedTable[npc] = nil
end

--------------------------------

function updateNPCLastUpdateTime(npc,newtime)
	lastUpdate[npc] = newtime or getTickCount()
end

function clearNPCLastUpdateTime(npc)
	lastUpdate[npc] = nil
end

function getNPCLastUpdateTime(npc)
	return lastUpdate[npc]
end

function isNaN(number)
	if number ~= number then
		return true
	else
		return false
	end
end