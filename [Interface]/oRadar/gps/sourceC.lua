local disallowedNodes = {

}

gpsRoute = false
gpsThread = false
gpsWaypoints = {}
nextWp = false
turnAround = false
currentWaypoint = false
waypointInterpolation = false
waypointEndInterpolation = false
reRouting = false



local gpsColshapes = false
local colshapeElements = {}
local routeInstructions = {}

local checkForRerouteTimer = false
local rerouteCheckTime = 1500

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for _, node in ipairs(disallowedNodes) do
			local area = math.floor(node[1] / 65536)
			local defaultNeighbours = shallowcopy(vehicleNodes[area][node[1]].neighbours)

			vehicleNodes[area][node[1]].neighbours = {}

			for k, v in pairs(defaultNeighbours) do
				if k ~= node[2] then
					vehicleNodes[area][node[1]].neighbours[k] = v
				end
			end
		end

		if occupiedVehicle then
			if getElementData(occupiedVehicle, "gpsDestination") then
				local destination = getElementData(occupiedVehicle, "gpsDestination")
				gpsThread = coroutine.create(makeRoute)
				coroutine.resume(gpsThread, destination[1], destination[2], true)
			end
		end
	end
)

addCommandHandler("tognodes",
	function ()
		if getElementData(localPlayer, "user:admin") >= 9 then
			--if isEventHandlerAdded("onClientRender", root, renderTheNodes) then
				removeEventHandler("onClientRender", root, renderTheNodes)
			--else
				addEventHandler("onClientRender", root, renderTheNodes)
			--end
		end
	end
)

function renderTheNodes()
	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local areaID = floor((playerPosY + 3000) / 750) * 8 + floor((playerPosX + 3000) / 750)
	local drawn = {}

	for id, node in pairs(vehicleNodes[areaID]) do
		if getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, node.x, node.y, playerPosZ) < 100 then
			local screenX, screenY = getScreenFromWorldPosition(node.x, node.y, node.z)

			if screenX and screenY then
				dxDrawText(tostring(id), screenX - 10, screenY - 5)
			end

			for neighbour in pairs(node.neighbours) do
				if not drawn[neighbour .. "-" .. id] then
					local nodeNeighbour = vehicleNodes[floor(neighbour / 65536)][neighbour]

					dxDrawLine3D(node.x, node.y, node.z + 1, nodeNeighbour.x, nodeNeighbour.y, nodeNeighbour.z + 1, tocolor(220, 163, 30), 3)
					drawn[id .. "-" .. neighbour] = true
				end
			end
		end
	end
end

function makeRoute(destinationX, destinationY, uTurned)
	waypointInterpolation = false

	if isElement(currentGPSSound) then
		destroyElement(currentGPSSound)
	end

	if isTimer(currentGPSSoundTimer) then
		killTimer(currentGPSSoundTimer)
	end

	if isTimer(checkForRerouteTimer) then
		killTimer(checkForRerouteTimer)
	end

	clearGPSRoute()
	gpsWaypoints = {}
	turnAround = false
	gpsLines = {}
	gpsRoute = false

	if gpsColshapes then
		for k, v in pairs(gpsColshapes) do
			colshapeElements[gpsColshapes[k]] = nil

			if isElement(v) then
				destroyElement(v)
			end

			gpsColshapes[k] = nil
		end
	end

	gpsColshapes = {}
	colshapeElements = {}

	if not occupiedVehicle then
		return
	end

	local vehiclePosX, vehiclePosY = getElementPosition(occupiedVehicle)

	local currentZoneName = getZoneName(vehiclePosX, vehiclePosY, 0)
	local currentCityName = getZoneName(vehiclePosX, vehiclePosY, 0, true)
	local zoneName = getZoneName(destinationX, destinationY, 0)
	local cityName = getZoneName(destinationX, destinationY, 0, true)

	local disallowedZones = {
		["Unknown"] = true,

		["San Fierro"] = true,
		["San Fierro Bay"] = true,
		["Gant Bridge"] = true,
		["Flint County"] = true,
		["Whetstone"] = true,

		["Las Venturas"] = false,
		["Bone County"] = false,
		["Tierra Robada"] = false
	}

	if (disallowedZones[cityName]) then exports.oInfobox:outputInfoBox("Nem található útvonal a kiválasztott célhoz.", "error") return end

	if disallowedZones[currentZoneName] or disallowedZones[currentCityName] then
		playOneGPSSound("nincskapcs")
		setElementData(occupiedVehicle, "gpsDestination", false)
		return false
	end

	if disallowedZones[zoneName] or disallowedZones[cityName] then
		exports.oInfobox:outputInfoBox("Nem található útvonal a kiválasztott célhoz.", "error")
		playOneGPSSound("masikuticel")
		setElementData(occupiedVehicle, "gpsDestination", false)
		return false
	end

	local routePath = calculateRoute(vehiclePosX, vehiclePosY, destinationX, destinationY)

	if not routePath then
		if not uTurned then
			playOneGPSSound("masikuticel")
			exports.oInfobox:outputInfoBox("Nem található útvonal a kiválasztott célhoz.", "error")
		else
			playOneGPSSound("nincskapcs")
		end

		setElementData(occupiedVehicle, "gpsDestination", false)
		return false
	end

	gpsRoute = routePath
	nextWp = 1
	currentWaypoint = 0
	currentNode = 1
	checkForRerouteTimer = setTimer(checkForReroute, rerouteCheckTime, 1)
	local waypointTurns = {}

	for i, node in ipairs(gpsRoute) do
		local nextNode = gpsRoute[i + 1]
		local previousNode = gpsRoute[i - 1]

		if i > 1 and i < #gpsRoute then
			for k in pairs(node.neighbours) do
				if previousNode and nextNode and k ~= previousNode.id and k ~= nextNode.id then
					local turnAngle = math.deg(getAngle(node.x - previousNode.x, node.y - previousNode.y, nextNode.x - node.x, nextNode.y - node.y))

					if turnAngle > 10 then
						table.insert(waypointTurns, {i, "right"})
						break
					end

					if turnAngle < -10 then
						table.insert(waypointTurns, {i, "left"})
					end

					break
				end
			end
		end

		gpsColshapes[i] = createColTube(node.x, node.y, node.z - 0.3, 8, 5)
		setElementData(gpsColshapes[i], "gps:col", true)
		colshapeElements[gpsColshapes[i]] = i
		addGPSLine(node.x, node.y)
	end

	local lastTurnNodeId = 1
	local nextTurnId = 1
	local nextTurnNode = waypointTurns[1][1]

	for turn = 1, #waypointTurns do
		local nextTurnNodeId = waypointTurns[nextTurnId][1]
		nextTurnNode = waypointTurns[turn][1]

		if turn == 1 then
			nextTurnNode = 1
			nextTurnId = 1
			lastTurnNodeId = 1
			nextTurnNodeId = 1
		end

		local distanceBetweenWaypoints = 0 + getDistanceBetweenPoints2D(gpsRoute[nextTurnNode].x, gpsRoute[nextTurnNode].y, gpsRoute[waypointTurns[nextTurnId][1]].x, gpsRoute[waypointTurns[nextTurnId][1]].y)

		if distanceBetweenWaypoints > 600 then
			if turn == 1 then
				nextTurnNode = waypointTurns[turn][1]
			end

			for i = lastTurnNodeId, tonumber(nextTurnNode) or #gpsRoute do
				if 0 + getDistanceBetweenPoints2D(gpsRoute[i].x, gpsRoute[i].y, gpsRoute[nextTurnNodeId].x, gpsRoute[nextTurnNodeId].y) > distanceBetweenWaypoints - 500 then
					table.insert(gpsWaypoints, {i, "forward"})
					break
				end
			end
		end

		lastTurnNodeId = waypointTurns[turn][1]
		nextTurnId = turn

		table.insert(gpsWaypoints, waypointTurns[turn])
	end

	table.insert(gpsWaypoints, {"end", "end"})

	for i = 1, tonumber(gpsWaypoints[nextWp][1]) or #gpsRoute do
		gpsWaypoints[nextWp][3] = getDistanceBetweenPoints2D(gpsRoute[i].x, gpsRoute[i].y, gpsRoute[1].x, gpsRoute[1].y) / 0.9
	end

	local vehicleOffsetX, vehicleOffsetY = getPositionFromElementOffset(occupiedVehicle, -1, 0, 0)
	local vehicleAngle = math.deg(getAngle(gpsRoute[2].x - gpsRoute[1].x, gpsRoute[2].y - gpsRoute[1].y, vehicleOffsetX - vehiclePosX, vehicleOffsetY - vehiclePosY))

	if vehicleAngle > 0 then
		turnAroundCheckTick = getTickCount()

		if not uTurned then
			currentGPSSound = setTimer(playGPSSound, 1750, 1, "forduljvissza")
		else
			playGPSSound("forduljvissza")
		end

		turnAround = true
	end

	lastDestinationX = destinationX
	lastDestinationY = destinationY
	processGPSLines()

	if isElement(selectedRouteSound) then
		destroyElement(selectedRouteSound)
	end

	selectedRouteSound = false

	if not uTurned then
		--selectedRouteSound = playSound("gps/sounds/" .. carCanGPSVal .. "/uticel.mp3")
	end
end

addEventHandler("onClientColShapeHit", getRootElement(),
	function (element)
		if colshapeElements[source] and element == localPlayer then
			local currentShape = colshapeElements[source]

			clearGPSRoute()

			if currentShape >= 2 then
				if isTimer(checkForRerouteTimer) then
					killTimer(checkForRerouteTimer)
				end

				checkForRerouteTimer = false
				turnAround = false
			end

			if currentShape == #gpsRoute then
				playGPSSound("finish")

				for i = 1, currentShape do
					if isElement(gpsColshapes[i]) then
						destroyElement(gpsColshapes[i])
					end

					gpsColshapes[i] = nil
				end

				nextWp = false

				if isTimer(checkForRerouteTimer) then
					killTimer(checkForRerouteTimer)
				end

				checkForRerouteTimer = false
				setElementData(occupiedVehicle, "gpsDestination", false)
				return
			else
				for i = 1, currentShape do
					if isElement(gpsColshapes[i]) then
						destroyElement(gpsColshapes[i])
					end

					gpsColshapes[i] = nil
				end

				for i = currentShape, #gpsRoute do
					addGPSLine(gpsRoute[i].x, gpsRoute[i].y)
				end

				if isTimer(checkForRerouteTimer) then
					killTimer(checkForRerouteTimer)
				end

				currentNode = currentShape + 1
				turnAroundCheckTick = getTickCount()
				checkForRerouteTimer = setTimer(checkForReroute, rerouteCheckTime, 1)
				reRouting = false
				processGPSLines()
			end

			if gpsWaypoints[nextWp] and gpsWaypoints[nextWp][1] ~= "end" then
				if currentShape >= gpsWaypoints[nextWp][1] then
					nextWp = nextWp + 1
					routeInstructions = {}

					for i = currentShape, tonumber(gpsWaypoints[nextWp][1]) or #gpsRoute do
						gpsWaypoints[nextWp][3] = getDistanceBetweenPoints2D(gpsRoute[i].x, gpsRoute[i].y, gpsRoute[currentShape].x, gpsRoute[currentShape].y) / 0.9
					end
				else
					gpsWaypoints[nextWp][3] = getDistanceBetweenPoints2D(gpsRoute[currentShape].x, gpsRoute[currentShape].y, gpsRoute[gpsWaypoints[nextWp][1]].x, gpsRoute[gpsWaypoints[nextWp][1]].y) / 0.9

					if gpsWaypoints[nextWp][2] == "forward" and not routeInstructions["forward"] and currentShape > 2 then
						if gpsWaypoints[nextWp - 1] and currentShape < 2 + gpsWaypoints[nextWp - 1][1] then
							return
						end

						routeInstructions["forward"] = true
						playGPSSound("egyenes")
						return
					end

					local nextWaypointDistance = math.floor(gpsWaypoints[nextWp][3] / 10) * 10

					if nextWaypointDistance <= 50 and not routeInstructions[50] then
						routeInstructions[50] = true
						routeInstructions[250] = true
						routeInstructions[500] = true
						routeInstructions[1200] = true
						routeInstructions[1500] = true

						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("jobbra")
						end

						return
					end

					if nextWaypointDistance > 230 and nextWaypointDistance <= 250 and not routeInstructions[250] then
						routeInstructions[250] = true
						routeInstructions[500] = true
						routeInstructions[1200] = true
						routeInstructions[1500] = true

						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("menj;200;50;metert;majd;balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("menj;200;50;metert;majd;jobbra")
						end

						return
					end

					if nextWaypointDistance > 480 and nextWaypointDistance <= 500 and not routeInstructions[500] then
						routeInstructions[500] = true
						routeInstructions[1200] = true
						routeInstructions[1500] = true

						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("menj;500;metert;majd;balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("menj;500;metert;majd;jobbra")
						end

						return
					end

					if nextWaypointDistance > 1180 and nextWaypointDistance <= 1200 and not routeInstructions[1200] then
						routeInstructions[1200] = true
						routeInstructions[1500] = true

						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("menj;1000;200;metert;majd;balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("menj;1000;200;metert;majd;jobbra")
						end

						return
					end

					if nextWaypointDistance > 1480 and nextWaypointDistance <= 1500 and not routeInstructions[1500] then
						routeInstructions[1500] = true

						if gpsWaypoints[nextWp][2] == "left" then
							playGPSSound("menj;1000;500;metert;majd;balra")
						elseif gpsWaypoints[nextWp][2] == "right" then
							playGPSSound("menj;1000;500;metert;majd;jobbra")
						end

						return
					end
				end
			else
				for i = currentShape, #gpsRoute do
					gpsWaypoints[nextWp][3] = getDistanceBetweenPoints2D(gpsRoute[i].x, gpsRoute[i].y, gpsRoute[currentShape].x, gpsRoute[currentShape].y) / 0.9
				end
			end
		end
	end
)

addEventHandler("onClientVehicleEnter", getRootElement(),
	function (player)
		if player == localPlayer and getElementData(source, "gpsDestination") then
			local destination = getElementData(source, "gpsDestination")
			gpsThread = coroutine.create(makeRoute)
			coroutine.resume(gpsThread, destination[1], destination[2], true)
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (player)
		if player == localPlayer and gpsRoute then
			endRoute()
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if source == occupiedVehicle and getElementData(source, "gpsDestination") then
			setElementData(source, "gpsDestination", false)

			if gpsRoute then
				endRoute()
			end
		end
	end
)

function calculateRoute(x1, y1, x2, y2)
	local startNode = getVehicleNodeClosestToPoint(x1, y1)
	local endNode = getVehicleNodeClosestToPoint(x2, y2)

	if not startNode then
		playOneGPSSound("nincskapcs")
		return false
	end

	if not endNode then
		playOneGPSSound("masikuticel")
		return false
	end

	return calculatePath(startNode, endNode)
end

function endRoute()
	if gpsRoute then
		if gpsColshapes then
			for k, v in pairs(gpsColshapes) do
				colshapeElements[gpsColshapes[k]] = nil

				if isElement(v) then
					destroyElement(v)
				end

				gpsColshapes[k] = nil
			end
		end

		nextWp = false

		if isTimer(checkForRerouteTimer) then
			killTimer(checkForRerouteTimer)
		end

		checkForRerouteTimer = false
		clearGPSRoute()
		waypointEndInterpolation = getTickCount()
		gpsRoute = false
		gpsThread = false
	end
end

function reRoute(checkShape)
	if not gpsRoute or not occupiedVehicle then
		return
	end

	local vehiclePosX, vehiclePosY = getElementPosition(occupiedVehicle)

	if getDistanceBetweenPoints2D(gpsRoute[checkShape].x, gpsRoute[checkShape].y, vehiclePosX, vehiclePosY) >= 50 then
		if not makeRoute(lastDestinationX, lastDestinationY, true) then
			checkForRerouteTimer = setTimer(checkForReroute, 10000, 1)
			reRouting = true
		end
	else
		checkForRerouteTimer = setTimer(checkForReroute, rerouteCheckTime, 1)
		reRouting = false
	end
end

function checkForReroute()
	if not gpsRoute or not occupiedVehicle then
		return
	end

	local vehiclePosX, vehiclePosY = getElementPosition(occupiedVehicle)
	local nextColshapeDistance = getDistanceBetweenPoints2D(gpsRoute[currentNode].x, gpsRoute[currentNode].y, vehiclePosX, vehiclePosY)

	if nextColshapeDistance >= 30 and nextColshapeDistance < 80 and gpsRoute[currentNode + 1] and turnAroundCheckTick and getTickCount() - turnAroundCheckTick > 5000 then
		local vehicleOffsetX, vehicleOffsetY = getPositionFromElementOffset(occupiedVehicle, -1, 0, 0)
		local vehicleAngle = math.deg(getAngle(gpsRoute[currentNode + 1].x - gpsRoute[currentNode].x, gpsRoute[currentNode + 1].y - gpsRoute[currentNode].y, vehicleOffsetX - vehiclePosX, vehicleOffsetY - vehiclePosY))

		if vehicleAngle > 0 then
			turnAroundCheckTick = getTickCount()
			checkForRerouteTimer = setTimer(checkForReroute, rerouteCheckTime, 1)
			playGPSSound("forduljvissza")
			turnAround = true
			reRouting = false
			return
		else
			turnAround = false
			reRouting = false
		end
	end

	if isTimer(checkForRerouteTimer) then
		killTimer(checkForRerouteTimer)
	end

	if nextColshapeDistance > 100 then
		checkForRerouteTimer = setTimer(reRoute, math.random(3000, 5000), 1, currentNode)
		playGPSSound("ujratervezes")
		reRouting = getTickCount()
	else
		checkForRerouteTimer = setTimer(checkForReroute, rerouteCheckTime, 1)
	end
end

function playGPSSound(sounds)
	if isElement(currentGPSSound) then
		destroyElement(currentGPSSound)
	end

	if isTimer(currentGPSSoundTimer) then
		killTimer(currentGPSSoundTimer)
	end

	--currentGPSSound = playSound("gps/sounds/" .. carCanGPSVal .. "/ding.mp3")
	--currentGPSSoundTimer = setTimer(playNextGPSSound, getSoundLength(currentGPSSound) * 0.9 * 1000, 1, split(sounds, ";"), 1)
end

function playNextGPSSound(sounds, count)
	--currentGPSSound = playSound("gps/sounds/" .. carCanGPSVal .. "/" .. sounds[count] .. ".mp3")

	if count < #sounds then
		--currentGPSSoundTimer = setTimer(playNextGPSSound, getSoundLength(currentGPSSound) * 0.9 * 1000, 1, sounds, count + 1)
	end
end

function playOneGPSSound(sound)
	if isElement(currentGPSSound) then
		destroyElement(currentGPSSound)
	end

	if isTimer(currentGPSSoundTimer) then
		killTimer(currentGPSSoundTimer)
	end

	--currentGPSSound = playSound("gps/sounds/" .. carCanGPSVal .. "/" .. sound .. ".mp3")
end

function getPositionFromElementOffset(element, x, y, z)
	local elementMatrix = getElementMatrix(element)

	local offsetX = x * elementMatrix[1][1] + y * elementMatrix[2][1] + z * elementMatrix[3][1] + elementMatrix[4][1]
	local offsetY = x * elementMatrix[1][2] + y * elementMatrix[2][2] + z * elementMatrix[3][2] + elementMatrix[4][2]
	local offsetZ = x * elementMatrix[1][3] + y * elementMatrix[2][3] + z * elementMatrix[3][3] + elementMatrix[4][3]

	return offsetX, offsetY, offsetZ
end

function getAngle(x1, y1, x2, y2)
	local angle = math.atan2(x2, y2) - math.atan2(x1, y1)

	if angle <= -math.pi then
		angle = angle + math.pi * 2
	elseif angle > math.pi then
		angle = angle - math.pi * 2
	end

	return angle
end

function shallowcopy(t)
	if type(t) ~= "table" then
		return t
	end

	local target = {}
	for k, v in pairs(t) do
		target[k] = v
	end
	return target
end

function calculatePath(startNode, endNode)
	local usedNodes = {[startNode.id] = true}
	local currentNodes = {}
	local ways = {}

	for id, distance in pairs(startNode.neighbours) do
		usedNodes[id] = true
		currentNodes[id] = distance
		ways[id] = {startNode.id}
	end

	while true do
		local currentNode = -1
		local maxDistance = 10000

		for id, distance in pairs(currentNodes) do
			if distance < maxDistance then
				currentNode = id
				maxDistance = distance
			end
		end

		if currentNode == -1 then
			return false
		end

		if endNode.id == currentNode then
			local lastNode = currentNode
			local foundedNodes = {}

			while (tonumber(lastNode) ~= nil) do
				local node = getVehicleNodeByID(lastNode)
				table.insert(foundedNodes, 1, node)
				lastNode = ways[lastNode]
			end

			return foundedNodes
		end

		for id, distance in pairs(getVehicleNodeByID(currentNode).neighbours) do
			if not usedNodes[id] then
				ways[id] = currentNode
				currentNodes[id] = maxDistance + distance
				usedNodes[id] = true
			end
		end

		currentNodes[currentNode] = nil
	end
end

function getVehicleNodeByID(nodeID)
	local areaID = floor(nodeID / 65536)
	if areaID >= 0 and areaID <= 63 then
		return vehicleNodes[areaID][nodeID]
	end
end

function getVehicleNodeClosestToPoint(x, y)
	local foundedNode = -1
	local lastNodeDistance = 10000
	local areaID = floor((y + 3000) / 750) * 8 + floor((x + 3000) / 750)

	if not vehicleNodes[areaID] then
		return false
	end

	for _, node in pairs(vehicleNodes[areaID]) do
		local nodeDistance = getDistanceBetweenPoints2D(x, y, node.x, node.y)

		if lastNodeDistance > nodeDistance then
			lastNodeDistance = nodeDistance
			foundedNode = node
		end
	end

	return foundedNode
end
