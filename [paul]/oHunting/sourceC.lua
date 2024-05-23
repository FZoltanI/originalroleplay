exports.oCompiler:loadCompliedModel(199, "jH8X&B-TUTj!Pk-S", ":oHunting/files/models/beardff.originalmodel", ":oHunting/files/models/beartxd.originalmodel", _, false)
exports.oCompiler:loadCompliedModel(218, "jH8X&B-TUTj!Pk-S", ":oHunting/files/models/foxdff.originalmodel", ":oHunting/files/models/foxtxd.originalmodel", _, false)

local cpString = ""
addCommandHandler("gencp", function()
    outputChatBox("újcp")
    local x,y,z = getElementPosition(localPlayer)
    cpString = cpString.."\n".."{"..x..","..y..","..z.."},"
    setClipboard(cpString)
end)

UPDATE_COUNT = 16
UPDATE_INTERVAL_MS = 2000

local screenX, screenY = guiGetScreenSize()

local maxDistance = 120
local zombieTable = {}

local interactionDistance = 5

local interactionTimer = false

local panelData = {}

local panelState = false
currentAnimalId = false
currentAnimalPosition = false
currentActionType = false

actionTimer = false

local moveDifferenceX, moveDifferenceY = 0, 0
local currentAnimalElement = false

addEventHandler("onClientResourceStart",getResourceRootElement(),
	function ()
		addEventHandler("onClientPreRender", getRootElement(), cycleNPCs)

		if debugMode then
			addEventHandler("onClientRender", getRootElement(), renderWayPoints)
		end
	end,
true, "high+999999")

addEventHandler("onClientPedDamage", getRootElement(),
	function (attackerElement, weapon, body, loss)
		if isElement(attackerElement) and tonumber(weapon) and tonumber(weapon) > 0 then
			if getElementType(attackerElement) == "vehicle" then
				--setElementHealth(source, getElementHealth(source) + loss)
				cancelEvent()
			end
			if getElementType(attackerElement) == "player" then
                if getElementData(source, "animalId") then
                    setPedVoice(source, "PED_TYPE_DISABLED", "")
	              --  if weapon == 33 then
	                --	setElementHealth(source, getElementHealth(source) - availableTypes[getElementData(source, "animal:type")]["damageMultipler"])
                       -- setElementData(source, "char:health", getElementHealth(source))
	               -- else
                        local health = getElementHealth(source)
	                	setElementHealth(source, health - availableTypes[getElementData(source, "animal:type")]["damageMultipler"])
                        outputChatBox(getElementHealth(source))
	                --	cancelEvent()
	                --end
                end
                --outputChatBox(loss)
                
				if isHLCEnabled(source) then
					local thisTask = getElementData(source, "huntingAnimal.thisTask")
					if thisTask then
						local lastTask = getElementData(source, "huntingAnimal.task." .. thisTask)
						if lastTask then
							if lastTask[1] ~= "killPed" then
								local animalId = getElementData(source, "animalId")
								if animalId then
									if not getElementData(source, "animalPos") then
										local posX, posY, posZ = getElementPosition(source)
										setElementPosition(source, posX, posY, posZ+0.5)
										setElementData(source, "animalPos", {posX, posY, posZ+0.5})
										setElementData(source, "huntingAnimal.walk_speed", "walk")
										clearPedTasks(source)
										addPedTask(source, {"killPed", attackerElement, 5, 1})
									end
								end
							end
						end
					end
				end
			end
		else
		--	setElementHealth(source, getElementHealth(source) + loss)
			cancelEvent()
		end
	end
)


function renderWayPoints()
	for k,v in ipairs(availableAnimals) do
		for i = 1, #v["waypoints"] do
			if v["waypoints"][i] and v["waypoints"][i + 1] then
				dxDrawLine3D(v["waypoints"][i][1], v["waypoints"][i][2], v["waypoints"][i][3], v["waypoints"][i + 1][1], v["waypoints"][i + 1][2], v["waypoints"][i + 1][3], tocolor(255, 0, 0, 255), 12)
			end
		end
		dxDrawLine3D(v["waypoints"][1][1], v["waypoints"][1][2], v["waypoints"][1][3], v["waypoints"][#v["waypoints"]][1], v["waypoints"][#v["waypoints"]][2], v["waypoints"][#v["waypoints"]][3], tocolor(255, 0, 0, 255), 12)
	end
end


function stopAllNPCActions(npc)
	stopNPCWalkingActions(npc)
	stopNPCWeaponActions(npc)

	setPedControlState(npc,"vehicle_fire",false)
	setPedControlState(npc,"vehicle_secondary_fire",false)
	setPedControlState(npc,"steer_forward",false)
	setPedControlState(npc,"steer_back",false)
	setPedControlState(npc,"horn",false)
	setPedControlState(npc,"handbrake",false)
end

function stopNPCWalkingActions(npc)
	setPedControlState(npc,"forwards",false)
	setPedControlState(npc,"sprint",false)
	setPedControlState(npc,"walk",false)
end

function stopNPCWeaponActions(npc)
	setPedControlState(npc,"aim_weapon",false)
	setPedControlState(npc,"fire",false)
end

function makeNPCWalkToPos(npc,x,y)
	local px,py = getElementPosition(npc)
	setPedCameraRotation(npc,math.deg(math.atan2(x-px,y-py)))
	setPedControlState(npc,"forwards",true)
	local speed = getNPCWalkSpeed(npc)
	setPedControlState(npc,"walk",speed == "walk")
	setPedControlState(npc,"sprint",
		speed == "sprint" or
		speed == "sprintfast" and not getPedControlState(npc,"sprint")
	)
end

function makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
	local x,y,z = getElementPosition(npc)
	local p2 = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	p2 = p2+off/len
	local p1 = 1-p2
	local destx,desty = p1*x1+p2*x2,p1*y1+p2*y2
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
	local x,y,z = getElementPosition(npc)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local p2 = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)/math.pi*2+off/len
	local destx,desty = getPosFromBend(p2*math.pi*0.5,x0,y0,x1,y1,x2,y2)
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCShootAtPos(npc,x,y,z)
	local sx,sy,sz = getElementPosition(npc)
	x,y,z = x-sx,y-sy,z-sz
	local yx,yy,yz = 0,0,1
	local xx,xy,xz = yy*z-yz*y,yz*x-yx*z,yx*y-yy*x
	yx,yy,yz = y*xz-z*xy,z*xx-x*xz,x*xy-y*xx
	local inacc = 1-getNPCWeaponAccuracy(npc)
	local ticks = getTickCount()
	local xmult = inacc*math.sin(ticks*0.01 )*1000/math.sqrt(xx*xx+xy*xy+xz*xz)
	local ymult = inacc*math.cos(ticks*0.011)*1000/math.sqrt(yx*yx+yy*yy+yz*yz)
	local mult = 1000/math.sqrt(x*x+y*y+z*z)
	xx,xy,xz = xx*xmult,xy*xmult,xz*xmult
	yx,yy,yz = yx*ymult,yy*ymult,yz*ymult
	x,y,z = x*mult,y*mult,z*mult
	
	setPedAimTarget(npc,sx+xx+yx+x,sy+xy+yy+y,sz+xz+yz+z)
	if isPedInVehicle(npc) then
		setPedControlState(npc,"vehicle_fire",not getPedControlState(npc,"vehicle_fire"))
	else
		setPedControlState(npc,"aim_weapon",true)
		setPedControlState(npc,"fire",not getPedControlState(npc,"fire"))
	end
end

function makeNPCShootAtElement(npc,target)
	local x,y,z = getElementPosition(target)
	local vx,vy,vz = getElementVelocity(target)
	local tgtype = getElementType(target)
	if tgtype == "ped" or tgtype == "player" then
		x,y,z = getPedBonePosition(target,3)
		local vehicle = getPedOccupiedVehicle(target)
		if vehicle then
			vx,vy,vz = getElementVelocity(vehicle)
		end
	end
	vx,vy,vz = vx*6,vy*6,vz*6
	makeNPCShootAtPos(npc,x+vx,y+vy,z+vz)
end

function stopAllNPCActions(npc)
	stopNPCWalkingActions(npc)
	stopNPCWeaponActions(npc)

	setPedControlState(npc,"vehicle_fire",false)
	setPedControlState(npc,"vehicle_secondary_fire",false)
	setPedControlState(npc,"steer_forward",false)
	setPedControlState(npc,"steer_back",false)
	setPedControlState(npc,"horn",false)
	setPedControlState(npc,"handbrake",false)
end

function stopNPCWalkingActions(npc)
	setPedControlState(npc,"forwards",false)
	setPedControlState(npc,"sprint",false)
	setPedControlState(npc,"walk",false)
end

function stopNPCWeaponActions(npc)
	setPedControlState(npc,"aim_weapon",false)
	setPedControlState(npc,"fire",false)
end

function makeNPCWalkToPos(npc,x,y)
	local px,py = getElementPosition(npc)
	setPedCameraRotation(npc,math.deg(math.atan2(x-px,y-py)))
	setPedControlState(npc,"forwards",true)
	local speed = getNPCWalkSpeed(npc)
	setPedControlState(npc,"walk",speed == "walk")
	setPedControlState(npc,"sprint",
		speed == "sprint" or
		speed == "sprintfast" and not getPedControlState(npc,"sprint")
	)
end

function makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
	local x,y,z = getElementPosition(npc)
	local p2 = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	p2 = p2+off/len
	local p1 = 1-p2
	local destx,desty = p1*x1+p2*x2,p1*y1+p2*y2
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
	local x,y,z = getElementPosition(npc)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local p2 = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)/math.pi*2+off/len
	local destx,desty = getPosFromBend(p2*math.pi*0.5,x0,y0,x1,y1,x2,y2)
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCShootAtPos(npc,x,y,z)
	local sx,sy,sz = getElementPosition(npc)
	x,y,z = x-sx,y-sy,z-sz
	local yx,yy,yz = 0,0,1
	local xx,xy,xz = yy*z-yz*y,yz*x-yx*z,yx*y-yy*x
	yx,yy,yz = y*xz-z*xy,z*xx-x*xz,x*xy-y*xx
	--local inacc = 1-getNPCWeaponAccuracy(npc)
	local inacc = 0
	local ticks = getTickCount()
	local xmult = inacc*math.sin(ticks*0.01 )*1000/math.sqrt(xx*xx+xy*xy+xz*xz)
	local ymult = inacc*math.cos(ticks*0.011)*1000/math.sqrt(yx*yx+yy*yy+yz*yz)
	local mult = 1000/math.sqrt(x*x+y*y+z*z)
	xx,xy,xz = xx*xmult,xy*xmult,xz*xmult
	yx,yy,yz = yx*ymult,yy*ymult,yz*ymult
	x,y,z = x*mult,y*mult,z*mult
	
	setPedAimTarget(npc,sx+xx+yx+x,sy+xy+yy+y,sz+xz+yz+z)
	if isPedInVehicle(npc) then
		setPedControlState(npc,"vehicle_fire",not getPedControlState(npc,"vehicle_fire"))
	else
		setPedControlState(npc,"aim_weapon",true)
		setPedControlState(npc,"fire",not getPedControlState(npc,"fire"))
	end
end

function makeNPCShootAtElement(npc,target)
	local x,y,z = getElementPosition(target)
	local vx,vy,vz = getElementVelocity(target)
	local tgtype = getElementType(target)
	if tgtype == "ped" or tgtype == "player" then
		x,y,z = getPedBonePosition(target,3)
		local vehicle = getPedOccupiedVehicle(target)
		if vehicle then
			vx,vy,vz = getElementVelocity(vehicle)
		end
	end
	vx,vy,vz = vx*6,vy*6,vz*6
	makeNPCShootAtPos(npc,x+vx,y+vy,z+vz)
end


performTask = {}

function performTask.walkToPos(npc,task)
	if isPedInVehicle(npc) then return true end
	local destx,desty,destz,dest_dist = task[2],task[3],task[4],task[5]
	local x,y = getElementPosition(npc)
	local distx,disty = destx-x,desty-y
	local dist = distx*distx+disty*disty
	local dest_dist = task[5]
	if dist < dest_dist*dest_dist then return true end
	makeNPCWalkToPos(npc,destx,desty)
end

function performTask.walkAlongLine(npc,task)
	if isPedInVehicle(npc) then return true end
	local x1,y1,z1,x2,y2,z2 = task[2],task[3],task[4],task[5],task[6],task[7]
	local off,enddist = task[8],task[9]
	local x,y,z = getElementPosition(npc)
	local pos = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if pos >= 1-enddist/len then return true end
	makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
end

function performTask.walkAroundBend(npc,task)
	if isPedInVehicle(npc) then return true end
	local x0,y0 = task[2],task[3]
	local x1,y1,z1 = task[4],task[5],task[6]
	local x2,y2,z2 = task[7],task[8],task[9]
	local off,enddist = task[10],task[11]
	local x,y,z = getElementPosition(npc)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local angle = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)+enddist/len
	if angle >= math.pi*0.5 then return true end
	makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
end

function performTask.walkFollowElement(npc,task)
	if isPedInVehicle(npc) then return true end
	local followed,mindist = task[2],task[3]
	if not isElement(followed) then return true end
	local x,y = getElementPosition(npc)
	local fx,fy = getElementPosition(followed)
	local dx,dy = fx-x,fy-y
	if dx*dx+dy*dy > mindist*mindist then
		makeNPCWalkToPos(npc,fx,fy)
	else
		stopAllNPCActions(npc)
	end
end

function performTask.shootPoint(npc,task)
	local x,y,z = task[2],task[3],task[4]
	makeNPCShootAtPos(npc,x,y,z)
end

function performTask.shootElement(npc,task)
	local target = task[2]
	if not isElement(target) then return true end
	makeNPCShootAtElement(npc,target)
end

function performTask.killPed(npc,task)
	if isPedInVehicle(npc) then return true end
	local target,shootdist,followdist = task[2],task[3],task[4]
	if not isElement(target) or getElementHealth(target) < 1 then return true end

	local x,y,z = getElementPosition(npc)
	local tx,ty,tz = getElementPosition(target)
	local dx,dy = tx-x,ty-y
	local distsq = dx*dx+dy*dy

	if distsq < shootdist*shootdist then
		makeNPCShootAtElement(npc,target)
		setPedRotation(npc,-math.deg(math.atan2(dx,dy)))
	else
		stopNPCWeaponActions(npc)
	end
	if distsq > followdist*followdist then
		makeNPCWalkToPos(npc,tx,ty)
	else
		stopNPCWalkingActions(npc)
	end

	return false
end

local attackDistance = 10

function addPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		local lastTask = getElementData(pedElement, "huntingAnimal.lastTask")
		if not lastTask then
			lastTask = 1
			setElementData(pedElement, "huntingAnimal.thisTask", 1)
		else
			lastTask = lastTask + 1
		end
		setElementData(pedElement, "huntingAnimal.task." .. lastTask, selectedTask)
		setElementData(pedElement, "huntingAnimal.lastTask", lastTask)
		return true
	else
		return false
	end
end

function clearPedTasks(pedElement)
	if isElement(pedElement) then
		local thisTask = getElementData(pedElement, "huntingAnimal.thisTask")
		if thisTask then
		
			local lastTask = getElementData(pedElement, "huntingAnimal.lastTask")
			for currentTask = thisTask, lastTask do
				--removeElementData(pedElement,"huntingAnimal.task." .. currentTask)
				setElementData(pedElement, "huntingAnimal.task." .. currentTask, nil)
			end

			--removeElementData(pedElement, "huntingAnimal.thisTask")
			setElementData(pedElement, "huntingAnimal.thisTask", nil)
			--removeElementData(pedElement, "huntingAnimal.lastTask")
			setElementData(pedElement, "huntingAnimal.lastTask", nil)
			return true
		end
	else
		return false
	end
end

function setPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		clearPedTasks(pedElement)
		setElementData(pedElement, "huntingAnimal.task.1", selectedTask)
		setElementData(pedElement, "huntingAnimal.thisTask", 1)
		setElementData(pedElement, "huntingAnimal.lastTask", 1)
		return true
	else
		return false
	end
end


function doRefreshing()
	local localX, localY, localZ = getElementPosition(localPlayer)
	for pednum,ped in ipairs(getElementsByType("ped",root,true)) do
		if getElementData(ped,"huntingAnimal.isControllable") then
			local pedX, pedY, pedZ = getElementPosition(ped)
			if getDistanceBetweenPoints3D(localX, localY, localZ, pedX, pedY, pedZ) <= attackDistance then
				addPedTask(ped, {"killPed", localPlayer, 5, 1})
			end
		end
	end
end

function cycleNPCs()
	local streamedPeds = {}
	for pednum,ped in ipairs(getElementsByType("ped",root,true)) do
		if getElementData(ped,"huntingAnimal.isControllable") then
			streamedPeds[ped] = true
		end
	end
	for npc,streamedin in pairs(streamedPeds) do
		if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			while true do
				local thisTask = getElementData(npc,"huntingAnimal.thisTask")
				if thisTask then
					local task = getElementData(npc,"huntingAnimal.task."..thisTask)
					if task then
						
						if performTask[task[1]](npc,task) then
							setNPCTaskToNext(npc)
						else
							break
						end
					else
						stopAllNPCActions(npc)
						break
					end
				else
					stopAllNPCActions(npc)
					break
				end
			end
		else
			stopAllNPCActions(npc)
		end
	end
end

function setNPCTaskToNext(npc)
	setElementData(
		npc,"huntingAnimal.thisTask",
		getElementData(npc,"huntingAnimal.thisTask")+1,
		true
	)
end