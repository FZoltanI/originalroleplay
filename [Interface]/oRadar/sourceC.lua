min, max, cos, sin, rad, deg, atan2 = math.min, math.max, math.cos, math.sin, math.rad, math.deg, math.atan2
sqrt, abs, floor, ceil, random = math.sqrt, math.abs, math.floor, math.ceil, math.random
gsub = string.gsub

screenW, screenH = guiGetScreenSize()

reMap = function(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

responsiveMultiplier = math.min(1, reMap(screenW, 1024, 1920, 0.75, 1))

resp = function(value)
	return value * responsiveMultiplier
end

respc = function(value)
	return ceil(value * responsiveMultiplier)
end

deepcopy = function(original)
	local copy
	if type(original) == "table" then
		copy = {}
		for k, v in next, original, nil do
			copy[deepcopy(k)] = deepcopy(v)
		end
		setmetatable(copy, deepcopy(getmetatable(original)))
	else
		copy = original
	end
	return copy
end

local function rotateAround(angle, x, y)
	angle = math.rad(angle)
	local cosinus, sinus = math.cos(angle), math.sin(angle)
	return x * cosinus - y * sinus, x * sinus + y * cosinus
end



local mapTextureSize = 1600
local mapRatio = 6000 / mapTextureSize

local minimapPosX = 0
local minimapPosY = 0
local minimapWidth = respc(320)
local minimapHeight = respc(225)
local minimapCenterX = minimapPosX + minimapWidth / 2
local minimapCenterY = minimapPosY + minimapHeight / 2
local minimapRenderSize = 400
local minimapRenderHalfSize = minimapRenderSize * 0.5
local minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
local playerMinimapZoom = 0.5
local minimapZoom = playerMinimapZoom
local minimapIsVisible = true

local bigmapPosX = 0
local bigmapPosY = 0
local bigmapWidth = screenW
local bigmapHeight = screenH
local bigmapCenterX = bigmapPosX + bigmapWidth / 2
local bigmapCenterY = bigmapPosY + bigmapHeight / 2
local bigmapZoom = 0.5
local bigmapIsVisible = false

local lastCursorPos = false
local mapDifferencePos = false
local mapMovedPos = false
local lastDifferencePos = false
local mapIsMoving = false
local lastMapPosX, lastMapPosY = 0, 0
local mapPlayerPosX, mapPlayerPosY = 0, 0

local zoneLineHeight = respc(25)
local screenSource = dxCreateScreenSource(screenW, screenH)

local gpsLineWidth = respc(150)
local gpsLineIconSize = respc(25)
local gpsLineIconHalfSize = gpsLineIconSize / 2
local createdTextures = {}

settingsStorage = {
	show3DBlips = false,
}

createdFonts = {}

occupiedVehicle = false

createdBlips = {}

_dxDrawImage = dxDrawImage 
local ImageTextures = {}

local sx, sy = guiGetScreenSize()

local function dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color, postGui)
	if type(image) == "string" then 
		if not ImageTextures[image] then 
			ImageTextures[image] = dxCreateTexture(image, "dxt5")
		end
		image = ImageTextures[image]
	end
	_dxDrawImage(x, y, w, h, image, rot, rotX, rotY, color, postGui)
end

local showingPlayers = false

local myX, myY = 1768, 992

local mainBlips = {
	{1489.857421875, -1766.626953125, 16.729686737061, "blips/12.png"},
	{1553.7822265625, -1675.6520996094, 16.1953125, "blips/13.png"},
	{1173.7385253906,-1323.2072753906,15.232232093811, "blips/10.png"},
	--{545.28149414063, -1286.6063232422, 17.248237609863, "blips/8.png"},

	{1940.4637451172, -1773.3197021484, 13.390598297119, "blips/9.png"},
	{1316.2996826172, -902.24835205078, 39.402648925781, "blips/1.png"},
	--{1002.5620727539, -936.96826171875, 42.328125, "blips/9.png"},
	{1366.6389160156, -1279.4897460938, 13.546875, "blips/14.png"},

	{1700.0952148438,-1169.2821044922,23.828125, "blips/2.png"},

	--{722.75079345703, -1494.7630615234, 1.9343447685242, "blips/19.png"},
	--{1008.9260864258, -1445.7407226563, 13.554634094238, "blips/31.png"}, KLUB
	--{1429.2377929688, 371.23767089844, 18.862117767334, "blips/18.png"},
	{2244.4267578125, -1663.9234619141, 15.4765625, "blips/15.png"},
	{480.7594909668, -1536.1046142578, 19.531429290771, "blips/15.png"},
	--{2514.3203125, -1957.302734375, 16.790563583374, "blips/15.png"},
	{1458.1296386719, -1138.3752441406, 24.029479980469, "blips/15.png"},
	{1679.3511962891, -2283.1064453125, 13.52857208252, "blips/16.png"},

	{2311.900390625, -8.7312088012695, 26.7421875, "blips/2.png"},
	{2330.0627441406, 1.0094584226608, 26.521738052368, "blips/7.png"},
	--{1383.4890136719, 461.93475341797, 20.130584716797, "blips/9.png"},
	{656.27130126953, -564.58215332031, 16.3359375, "blips/9.png"},
	{252.43360900879, -57.67790222168, 1.5703125, "blips/24.png"},

	--{1028.1936035156, -1904.3432617188, 12.893943786621, "blips/30.png"},
	{1832.1314697266, -1842.3851318359, 13.578125, "blips/24.png"},

	{1223.1682128906, 243.64515686035, 19.546894073486, "blips/12.png"},

	{1021.7333374023, -1123.6644287109, 23.868761062622, "blips/17.png"}, -- LS CASINO

	{2275.0703125,-2343.5190429688,13.546875, "blips/27.png"},

	--{153.6167755127, -1942.4256591797, 3.7734375, "blips/19.png"},  HAJÓBÉRLŐ
	--{1560.2463378906, -2211.001953125, 14.018497467041, "blips/20.png"},

	--{133.0544128418, -1329.1048583984, 48.128692626953, "blips/21.png"},
	--{404.5744934082, -1015.6887817383, 92.330825805664, "blips/21.png"},
	--[[{214.83201599121, -1079.3544921875, 62.203147888184, "blips/21.png"},
	{639.15393066406, -903.14489746094, 38.251518249512, "blips/21.png"},
	{293.42169189453, -1061.7191162109, 60.9130859375, "blips/21.png"},
	{775.97027587891, -908.87927246094, 43.141166687012, "blips/21.png"},
	{1204.9810791016, -629.85424804688, 57.348487854004, "blips/21.png"},
	{1638.8656005859, -16.455255508423, 36.622829437256, "blips/21.png"},
	{2886.4514160156, -601.85028076172, 11.045989990234, "blips/21.png"},]]

	{1080.7761230469, -1698.4385986328, 13.546875, "blips/36.png"},
	{811.1142578125, -1060.3983154297, 24.948221206665, "blips/24.png"},

	{820.0634765625, -575.71545410156, 16.536296844482, "blips/41.png"},
	{2164.0810546875, -103.30537414551, 2.75, "blips/42.png"},
	{1918.1340332031, 172.66697692871, 37.257614135742, "blips/43.png"},

	{2411.0686035156, -1498.8511962891, 31.908088684082, "blips/7.png"},
	{2115.6218261719, -1806.9969482422, 22.21875, "blips/7.png"},

	{1968.6666259766, -2204.0825195313, 13.546875, "blips/44.png"},

	{2192.0649414063, -1984.3500976563, 13.550954818726, "blips/45.png"},

	--{2281, -2378.7268066406, 13.432221412659, "blips/46.png"},

	{2475.7001953125, -2394.0498046875, 13.625, "blips/35.png"},


	{387.22622680664, -1870.6955566406, 7.8359375, "blips/24.png"}, --

	{2814.9345703125, -1618.3328857422, 11.023014068604, "blips/15.png"}, -- Illegál frakció ruhabolt

	{1199.3642578125, -918.19445800781, 43.122100830078, "blips/7.png"},

	--{589.11511230469, -1172.5225830078, 23.288547515869, "blips/54.png"},

	{719.44732666016, -1361.3049316406, 13.427791595459, "blips/25.png"}, --PLÁZA

	{1835.2557373047,-1682.4937744141,13.397357940674, "blips/31.png"},

	-- LV

	{103.13995361328,-291.99694824219,1.578125, "blips/64.png"}, -- gyar


	-- fegyvercraft
	{2387.1577148438, -653.70324707031, 127.5396194458, "blips/67.png"},
	{-2454.5615234375,2254.2758789062,4.9802069664001, "blips/68.png"},
	{2646.1188964844,-2089.376953125,16.953125, "blips/69.png"},


	{216.45295715332,14.669826507568,2.57080078125, "blips/46.png"}, -- aukciós telep

	{-742.4775390625,237.5651550293,3.1307954788208, "blips/37.png"}, -- kikötő blueberry
	{2613.5798339844,-2471.1716308594,3, "blips/37.png"}, -- kikötő ls2
	{-2238.0183105469,2412.5407714844,3.7793831825256, "blips/37.png"}, -- kikötő bayside

	{2713.111328125,-1104.1528320312,69.57755279541, "blips/28.png"}, -- kulcsmásoló

	{-2537.7817382812,2320.548828125,4.984375, "blips/52.png"}, -- drágakő értékbecslő
	{1085.3483886719,-1213.5087890625,17.812009811401, "blips/19.png"}, -- bútorfelvásárló
	{953.70886230469,-1336.3480224609,13.539100646973, "blips/49.png"}, -- lottózó

	--{1422.3221435547,-1177.7465820312,25.9921875, "blips/48.png"}, -- játékfejlesztő irodaház

	{-2382.7751464844,2216.4033203125,6.407133102417, "blips/42.png"}, -- Bayside hal

	{2396.9421386719,-1897.9167480469,13.561561584473, "blips/7.png"}, -- cluckinbell

	{2523.5158691406,-1525.4184570312,23.821899414062, "blips/65.png"}, -- használt autókerek
	{205.22537231445,-172.5619354248,1.578125, "blips/65.png"}, -- használt autókerek

	{1471.3944091797,-1265.3369140625,14.5625, "blips/21.png"}, -- nav 
	
}



local sotetites = dxCreateTexture("files/sotet.png")
local core = exports.oCore
local color, r, g, b = core:getServerColor()

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oRadar" then  
		core = exports.oCore
		color, r, g, b = core:getServerColor()
	end
end)

local visibleBlDipTooltip = false
local hoveredWaypointBlip = false

local farshowBlips = {}
local farshowBlipsData = {}

carCanGPSVal = false
local gpsHello = false
local gpsLines = {}
local gpsRouteImage = false
local gpsRouteImageData = {}

local state3DBlip = 1
local hover3DBlipCb = false

local playerCanSeePlayers = false

local renderedBlips = {}

local font = dxCreateFont("files/fonts/font.ttf",10)
local font2 = dxCreateFont("files/fonts/font.ttf",14)

local disabledZone = {
	["Mount Chiliad"] = true
}

local getZoneNameEx = getZoneName
function getZoneName(x, y, z, citiesonly)
	local zoneName = getZoneNameEx(x, y, z, citiesonly)
	if zoneName == "Unknown" then 
		return "Ismeretlen"
	else
		return zoneName
	end
--	return zoneName
end

function getTexture(name)
	if createdTextures[name] then
		return createdTextures[name]
	end

	return false
end

addCommandHandler("showplayers",
	function ()
		if getElementData(localPlayer, "user:admin") >= 3 then
			playerCanSeePlayers = not playerCanSeePlayers
			if playerCanSeePlayers then 
				outputChatBox(color .. " Sikeresen láthatóvá tetted a playereket a radarodon!", 255,255,255,true)
			else
				outputChatBox(color .. " Sikeresen eltüntetted a playereket a radarodon!", 255,255,255,true)
			end
		end
	end
)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
    createdTextures = {
			minimapMap = dxCreateTexture("files/map.png", "dxt3"),
			bigmapMap = dxCreateTexture("files/map.png", "dxt3"),
		}
		occupiedVehicle = getPedOccupiedVehicle(localPlayer)
		if getTexture("minimapMap") then
			dxSetTextureEdge(getTexture("minimapMap"), "border", tocolor(76, 131, 182, 230))
		end

		if getTexture("bigmapMap") then
			dxSetTextureEdge(getTexture("bigmapMap"), "border", tocolor(76, 131, 182, 220))
		end

		for k,v in ipairs(getElementsByType("blip")) do
			blipTooltips[v] = getElementData(v, "blip:name")
		end

		for k,v in ipairs(mainBlips) do
			createCustomBlip(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8])
		end

		if occupiedVehicle then
			carCanGPS()
		end

		settingsStorage.show3DBlips = 1

		if (settingsStorage.show3DBlips == 2 or settingsStorage.show3DBlips == 3) then
			addEventHandler("onClientHUDRender", getRootElement(), render3DBlips, true, "low-99999999")
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == occupiedVehicle then
			if dataName == "gpsDestination" then
				local dataValue = getElementData(source, dataName) or false

				if dataValue then
					gpsThread = coroutine.create(makeRoute)
					coroutine.resume(gpsThread, unpack(dataValue))
				else
					endRoute()
				end
			end
		end

		if getElementType(source) == "blip" and dataName == "blip:name" then
			blipTooltips[source] = getElementData(source, dataName) or "Nincs adat"
		end
	end
)


setTimer(function()
	local sx,sy = guiGetScreenSize()
	mapWidth = sx*exports.oInterface:getInterfaceElementData(1, "width")
	mapHeight = sy*exports.oInterface:getInterfaceElementData(1, "height")
	mapX = sx*exports.oInterface:getInterfaceElementData(1, "posX")
	mapY = sy*exports.oInterface:getInterfaceElementData(1, "posY")
	if (exports.oInterface:getInterfaceElementData(1, "showing")) then
		renderMinimap(mapX, mapY, mapWidth, mapHeight)
	end
end,5,0)

local bebaszfont = exports.oFont:getFont("bebasneue",13)
local fontawesome = exports.oFont:getFont("fontawesome",15)
local icon = exports.oFont:getFont("fontawesome2",35)

local gpstext = "false"
local gpstext2 = "false"

function renderMinimap(x, y, w, h)
	if bigmapIsVisible or not minimapIsVisible then
		return
	end

	minimapWidth = w
	minimapHeight = h

	if (minimapWidth > respc(445) or minimapHeight > respc(400)) and minimapRenderSize < 800 then
		minimapRenderSize = 800
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
	end
	if minimapWidth <= respc(445) and minimapHeight <= respc(400) and minimapRenderSize > 600 then
		minimapRenderSize = 600
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
	end
	if (minimapWidth > respc(325) or minimapHeight > respc(235)) and minimapRenderSize < 600 then
		minimapRenderSize = 600
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
	end
	if minimapWidth <= respc(325) and minimapHeight <= respc(235) and minimapRenderSize > 400 then
		minimapRenderSize = 400
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
	end

	if minimapPosX ~= x or minimapPosY ~= y then
		minimapPosX = x
		minimapPosY = y
	end

	minimapCenterX = minimapPosX + minimapWidth / 2
	minimapCenterY = minimapPosY + minimapHeight / 2

	dxUpdateScreenSource(screenSource, true)

	if getKeyState("num_add") and playerMinimapZoom < 1.2 then
		playerMinimapZoom = playerMinimapZoom + 0.01
	elseif getKeyState("num_sub") and playerMinimapZoom > 0.31 then
		playerMinimapZoom = playerMinimapZoom - 0.01
	end

	minimapZoom = playerMinimapZoom

	if occupiedVehicle then
		local vehicleZoom = getVehicleSpeed(occupiedVehicle) / 1300
		if vehicleZoom >= 0.4 then
			vehicleZoom = 0.4
		end
		minimapZoom = minimapZoom - vehicleZoom
	end

	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local playerDimension = getElementDimension(localPlayer)
	local playerInt = getElementInterior(localPlayer)
	local cameraX, cameraY, _, faceTowardX, faceTowardY = getCameraMatrix()
	local cameraRotation = deg(atan2(faceTowardY - cameraY, faceTowardX - cameraX)) + 360 + 90

	local minimapRenderSizeOffset = respc(minimapRenderSize * 0.75)

	farshowBlips = {}
	farshowBlipsData = {}

	if (playerDimension == 0) and playerInt == 0 then
		local remapPlayerPosX, remapPlayerPosY = remapTheFirstWay(playerPosX), remapTheFirstWay(playerPosY)
		local farBlips = {}
		local farBlipsCount = 10000
		local manualBlipsCount = 1
		local defaultBlipsCount = 1

		dxSetRenderTarget(minimapRender)
		dxDrawImageSection(0, 0, minimapRenderSize, minimapRenderSize, remapTheSecondWay(playerPosX) - minimapRenderSize / minimapZoom / 2, remapTheFirstWay(playerPosY) - minimapRenderSize / minimapZoom / 2, minimapRenderSize / minimapZoom, minimapRenderSize / minimapZoom, getTexture("minimapMap"))

		if gpsRouteImage then
			dxDrawImage(minimapRenderSize / 2 + (remapTheFirstWay(playerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * minimapZoom - gpsRouteImageData[3] * minimapZoom / 2, minimapRenderSize / 2 - (remapTheFirstWay(playerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * minimapZoom + gpsRouteImageData[4] * minimapZoom / 2, gpsRouteImageData[3] * minimapZoom, -(gpsRouteImageData[4] * minimapZoom), gpsRouteImage, 180, 0, 0, tocolor(r, g, b))
		end

		for i = 1, #createdBlips do
			if createdBlips[i] then
				if createdBlips[i].farShow then
					farBlips[farBlipsCount + manualBlipsCount] = createdBlips[i].icon
				end
				renderBlip(createdBlips[i].icon, createdBlips[i].posX, createdBlips[i].posY, remapPlayerPosX, remapPlayerPosY, createdBlips[i].iconSize, createdBlips[i].iconSize, createdBlips[i].color, cameraRotation, createdBlips[i].farShow, i)
				manualBlipsCount = manualBlipsCount + 1
			end
		end

		local defaultBlips = getElementsByType("blip")
		for i = 1, #defaultBlips do
			if defaultBlips[i] then
				local tableId = farBlipsCount + manualBlipsCount + defaultBlipsCount
				farBlips[tableId] = "blips/target.png"
				local blipPosX, blipPosY = getElementPosition(defaultBlips[i])
				local blipType = getElementData(defaultBlips[i], "blip:type") or false
				renderBlip("blips/"..getBlipIcon(defaultBlips[i])..".png", blipPosX, blipPosY, remapPlayerPosX, remapPlayerPosY, respc(22), respc(22), 0xFFFFFFFF, cameraRotation, blipType, tableId)
				blipTooltips[defaultBlips[i]] = getElementData(defaultBlips[i], "blip:name") or "Nincs adat"
				defaultBlipsCount = defaultBlipsCount + 1
			end
		end

		if showingPlayers then 
			for k, v in ipairs(getElementsByType("player")) do 
				if not (v == localPlayer) then 
					if getElementData(v, "user:loggedin") then
						if getElementInterior(v) == 0 then
							--print("asd")
							local playerX, playerY = getElementPosition(v)

							local color = tocolor(255, 255, 255)

							if getElementData(v, "user:aduty") then 
								color = tocolor(hex2rgb(exports.oAdmin:getAdminColor(getElementData(v, "user:admin"))))
							end

							renderBlip("blips/999.png", playerX, playerY, remapPlayerPosX, remapPlayerPosY, respc(22), respc(22), color, cameraRotation)
						end
					end
				end
			end
		end

		if (exports.oDashboard:getFactionType(getElementData(localPlayer, "char:duty:faction")) == 1) then  
			for k, v in ipairs(getElementsByType("vehicle")) do 
				local unitNumber = getElementData(v, "mdc:unitNumber") or ""
				if string.len(unitNumber) > 0 then
					if getElementDimension(v) == 0 and getElementInterior(v) == 0 then
						local vehX, vehY = getElementPosition(v)

						local datas = getElementData(v, "mdc:unitState") or {0, 255, 255, 255}

						local color = tocolor(datas[2], datas[3], datas[4])

						renderBlip("blips/999.png", vehX, vehY, remapPlayerPosX, remapPlayerPosY, respc(30), respc(30), color, cameraRotation)
					end
				end
			end

			for k, v in ipairs(getElementsByType("player")) do 
				if getElementData(v, "atmRob:hasMoneyCaset") then
					if getElementDimension(v) == 0 and getElementInterior(v) == 0 then 
						local x, y = getElementPosition(v)
						renderBlip("circle.png", x, y, remapPlayerPosX, remapPlayerPosY, respc(30), respc(30), tocolor(255, 255, 255, 255), cameraRotation)
					end
				end
			end
			for k, v in ipairs(getElementsByType("vehicle")) do 
				if getElementData(v, "char:stealer") then
					if getElementDimension(v) == 0 and getElementInterior(v) == 0 then 
						local x, y = getElementPosition(v)
						renderBlip("circle.png", x, y, remapPlayerPosX, remapPlayerPosY, respc(30), respc(30), tocolor(255, 255, 255, 255), cameraRotation)
					end
				end
			end
		end

		dxSetRenderTarget()
		dxDrawImage(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2, minimapRenderSize, minimapRenderSize, minimapRender, cameraRotation - 180)

		for k in pairs(farshowBlips) do
			if createdBlips[k] then
				dxDrawImage(farshowBlipsData[k].posX, farshowBlipsData[k].posY, createdBlips[k].iconSize, createdBlips[k].iconSize, "files/" .. createdBlips[k].icon, 0, 0, 0, farshowBlipsData[k].color)
			else
				table.insert(farBlips, k)
			end
		end

		for i = 1, #farBlips do
			if farshowBlipsData[farBlips[i]] then
				dxDrawImage(farshowBlipsData[farBlips[i]].posX, farshowBlipsData[farBlips[i]].posY, farshowBlipsData[farBlips[i]].iconWidth, farshowBlipsData[farBlips[i]].iconHeight, "files/" .. farshowBlipsData[farBlips[i]].icon, 0, 0, 0, farshowBlipsData[farBlips[i]].color)
			end
		end

		dxDrawImage(mapX,mapY,mapWidth,mapHeight-zoneLineHeight,sotetites,0,0,0,tocolor(30,30,30,230))
	end

	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)
	dxDrawImageSection(minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)
	dxDrawOuterBorder(minimapPosX, minimapPosY, minimapWidth, minimapHeight, 2, tocolor(30, 30, 30, 255))

	if playerDimension == 0 and playerInt == 0 and not getElementData(localPlayer, "player:bagBAG") then
		local playerArrowSize = 60 / (4 - minimapZoom) + 3
		local playerArrowHalfSize = playerArrowSize / 2
		local _, _, playerRotation = getElementRotation(localPlayer)

		dxDrawImage(minimapCenterX - playerArrowHalfSize, minimapCenterY - playerArrowHalfSize, playerArrowSize, playerArrowSize, "files/arrow.png", abs(360 - playerRotation) + (cameraRotation - 180))
		dxDrawRectangle(minimapPosX, minimapPosY + minimapHeight - zoneLineHeight, minimapWidth, zoneLineHeight, tocolor(30, 30, 30, 255))


		dxDrawText(getZoneName(playerPosX, playerPosY, playerPosZ), minimapPosX+respc(5), minimapPosY + minimapHeight - zoneLineHeight, minimapPosX+respc(5) + minimapWidth - resp(10), minimapPosY + minimapHeight, tocolor(220, 220, 220, 255), 1, font, "right", "center")
	
		dxDrawImage(minimapPosX, minimapPosY + minimapHeight - zoneLineHeight+respc(2), respc(20), respc(20), "files/placeholder.png",0,0,0,tocolor(220,220,220,255))

		if gpsRoute or (not gpsRoute and waypointEndInterpolation) then
			local naviX = minimapPosX + minimapWidth - gpsLineWidth
			local naviCenterY = minimapPosY+minimapWidth-gpsLineWidth

			--gpstext
			if waypointEndInterpolation then
				local interpolationProgress = (getTickCount() - waypointEndInterpolation) / 1000
				local interpolateAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, interpolationProgress, "Linear")

				dxDrawRectangle(minimapPosX + respc(2), minimapPosY + respc(2), respc(40) + dxGetTextWidth(gpstext2, 1, fontScript:getFont("p_bo", 14/myX*sx)) + respc(10), respc(40), tocolor(30, 30, 30, 230 * interpolateAlpha))
				dxDrawText(gpstext2, minimapPosX + respc(20) + gpsLineIconSize, minimapPosY + respc(3.5),  minimapPosX + respc(20) + gpsLineIconSize, minimapPosY + respc(3.5) + respc(40), tocolor(255, 255, 255, 255 * interpolateAlpha), 1, fontScript:getFont("p_bo", 14/myX*sx), "left", "top")
				dxDrawText(gpstext, minimapPosX + respc(20) + gpsLineIconSize, minimapPosY + respc(3.5),  minimapPosX + respc(20) + gpsLineIconSize, minimapPosY + respc(3.5) + respc(40), tocolor(255, 255, 255, 120 * interpolateAlpha), 1, fontScript:getFont("p_m", 14/myX*sx), "left", "bottom")
				
				dxDrawImage(minimapPosX + respc(10), minimapPosY + respc(10), gpsLineIconSize, gpsLineIconSize, "gps/images/end.png", 0, 0, 0, tocolor(r, g, b, 255 * interpolateAlpha))
				gpstext = "Kellemes időtöltést!"
				gpstext2 = "Megérkezett az úti célhoz!"

				if interpolationProgress > 1 then
					waypointEndInterpolation = false
				end
			else
				dxDrawRectangle(minimapPosX + respc(2), minimapPosY + respc(2), respc(40) + dxGetTextWidth(gpstext2, 1, fontScript:getFont("p_bo", 14/myX*sx)) + respc(10), respc(40), tocolor(30, 30, 30, 230))
			dxDrawText(gpstext2, minimapPosX + respc(20) + gpsLineIconSize, minimapPosY + respc(3.5),  minimapPosX + respc(20) + gpsLineIconSize, minimapPosY + respc(3.5) + respc(40), tocolor(255, 255, 255, 255), 1, fontScript:getFont("p_bo", 14/myX*sx), "left", "top")
			dxDrawText(gpstext, minimapPosX + respc(20) + gpsLineIconSize, minimapPosY + respc(3.5),  minimapPosX + respc(20) + gpsLineIconSize, minimapPosY + respc(3.5) + respc(40), tocolor(255, 255, 255, 120), 1, fontScript:getFont("p_m", 14/myX*sx), "left", "bottom")
			end

			if nextWp then
				if currentWaypoint ~= nextWp and not tonumber(reRouting) then
					currentWaypoint = nextWp
				end

				if tonumber(reRouting) then
					currentWaypoint = nextWp

					local reRouteProgress = (getTickCount() - reRouting) / 1250
					local refreshAngle, refreshDots = interpolateBetween(0, 0, 0, 360, 3, 0, reRouteProgress, "Linear")

					dxDrawImage(minimapPosX + respc(10), minimapPosY + respc(10), gpsLineIconSize, gpsLineIconSize, "gps/images/refresh.png", refreshAngle, 0, 0, tocolor(r, g, b))

					gpstext = "Kérem várjon!"
					gpstext2 = "Újratervezés!"

					if reRouteProgress > 1 then
						reRouting = getTickCount()
					end
				elseif turnAround then
					currentWaypoint = nextWp

					dxDrawImage(minimapPosX + respc(10), minimapPosY + respc(10), gpsLineIconSize, gpsLineIconSize, "gps/images/around.png", 0, 0, 0, tocolor(r, g, b))
					gpstext2 = "Forduljon vissza!"
					gpstext = "0 méter"
				else
					dxDrawImage(minimapPosX + respc(10), minimapPosY + respc(10), gpsLineIconSize, gpsLineIconSize, "gps/images/" .. gpsWaypoints[nextWp][2] .. ".png", 0, 0, 0, tocolor(r, g, b))
					gpstext = floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10 .. " méter"
					gpstext2 = gpsUtasitasok[gpsWaypoints[nextWp][2]]
				end
			end
		end
	else
		dxDrawRectangle(minimapPosX, minimapPosY, minimapWidth, minimapHeight, tocolor(30, 30, 30, 250))

		if not lostSignalStartTick then
			lostSignalStartTick = getTickCount()
		end

		local fadeAlpha = 255
		local iconRotation = 360
		if not lostSignalFadeIn then
			fadeAlpha = 255
		else
			fadeAlpha = 0
			iconRotation = 360
		end

		local lostSignalTick = (getTickCount() - lostSignalStartTick) / 2500
		if lostSignalTick > 1 then
			lostSignalStartTick = getTickCount()
			lostSignalFadeIn = not lostSignalFadeIn
		end

		dxDrawText("A kapcsolat megszakadt...",minimapPosX, minimapPosY,minimapPosX+minimapWidth, minimapPosY+minimapHeight+respc(100),tocolor(184, 53, 53,interpolateBetween(fadeAlpha, 0, 0, 255 - fadeAlpha, 0, 0, lostSignalTick, "Linear")),1,font2,"center","center",false,false,false,true)
		dxDrawImage(minimapCenterX - 32, minimapCenterY - 32 - 16, 64, 64, "files/gpslosticon.png", 0, 0, 0, tocolor(184, 53, 53, interpolateBetween(fadeAlpha, 0, 0, 255 - fadeAlpha, 0, 0, lostSignalTick, "Linear")))
	end
end

local bigMap_OptionsHover = false
local bigMap_OptionsHoverAnimType 
local bigMap_OptionsRotationTick
local bigMap_OptionsPanelShowing = false

local Blip3DStatesNames = {"#f04f4fKikapcsolva", "#65e681Bekapcsolva"}

local backTick, startValue1, startValue2, backRenderTimer = 0, 0, 0, nil

local selectedGTAVBlip = 1
local selectedSecondaryGTAVBlip = 1
local lastKeyInteraction = 0
local bigGTAVIcon = ""

function renderTheBigmap()
	if not bigmapIsVisible then
		return
	end

	if hoveredWaypointBlip then
		hoveredWaypointBlip = false
	end

	if hover3DBlipCb then
		hover3DBlipCb = false
	end

	if getElementDimension(localPlayer) == 0 and not getElementData(localPlayer, "player:bagBAG") then
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)

		cursorX, cursorY = getHudCursorPos()
		if cursorX and cursorY then
			cursorX, cursorY = cursorX * screenW, cursorY * screenH

			if getKeyState("mouse1") then
				if not lastCursorPos then
					lastCursorPos = {cursorX, cursorY}
				end

				if not mapDifferencePos then
					mapDifferencePos = {0, 0}
				end

				if not lastDifferencePos then
					if not mapMovedPos then
						lastDifferencePos = {0, 0}
					else
						lastDifferencePos = {mapMovedPos[1], mapMovedPos[2]}
					end
				end

				mapDifferencePos = {mapDifferencePos[1] + cursorX - lastCursorPos[1], mapDifferencePos[2] + cursorY - lastCursorPos[2]}

				if not mapMovedPos then
					if abs(mapDifferencePos[1]) >= 3 or abs(mapDifferencePos[2]) >= 3 then
						mapMovedPos = {lastDifferencePos[1] - mapDifferencePos[1] / bigmapZoom, lastDifferencePos[2] + mapDifferencePos[2] / bigmapZoom}
						mapIsMoving = true
					end
				elseif mapDifferencePos[1] ~= 0 or mapDifferencePos[2] ~= 0 then
					mapMovedPos = {lastDifferencePos[1] - mapDifferencePos[1] / bigmapZoom, lastDifferencePos[2] + mapDifferencePos[2] / bigmapZoom}
					mapIsMoving = true
				end

				lastCursorPos = {cursorX, cursorY}
			else
				if mapMovedPos then
					lastDifferencePos = {mapMovedPos[1], mapMovedPos[2]}
				end

				lastCursorPos = false
				mapDifferencePos = false
			end
		end

		mapPlayerPosX, mapPlayerPosY = lastMapPosX, lastMapPosY

		if mapMovedPos then
			mapPlayerPosX = mapPlayerPosX + mapMovedPos[1]
			mapPlayerPosY = mapPlayerPosY + mapMovedPos[2]
		else
			mapPlayerPosX, mapPlayerPosY = playerPosX, playerPosY
			lastMapPosX, lastMapPosY = mapPlayerPosX, mapPlayerPosY
		end

		dxDrawImageSection(bigmapPosX, bigmapPosY, bigmapWidth, bigmapHeight, remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2, remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2, bigmapWidth / bigmapZoom, bigmapHeight / bigmapZoom, getTexture("bigmapMap"))

		if gpsRouteImage then
			dxUpdateScreenSource(screenSource, true)
			dxDrawImage(bigmapCenterX + (remapTheFirstWay(mapPlayerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * bigmapZoom - gpsRouteImageData[3] * bigmapZoom / 2, bigmapCenterY - (remapTheFirstWay(mapPlayerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * bigmapZoom + gpsRouteImageData[4] * bigmapZoom / 2, gpsRouteImageData[3] * bigmapZoom, -(gpsRouteImageData[4] * bigmapZoom), gpsRouteImage, 180, 0, 0, tocolor(r, g, b))
			dxDrawImageSection(0, 0, bigmapPosX, screenH, 0, 0, bigmapPosX, screenH, screenSource)
			dxDrawImageSection(screenW - bigmapPosX, 0, bigmapPosX, screenH, screenW - bigmapPosX, 0, bigmapPosX, screenH, screenSource)
			dxDrawImageSection(bigmapPosX, 0, screenW - 2 * bigmapPosX, bigmapPosY, bigmapPosX, 0, screenW - 2 * bigmapPosX, bigmapPosY, screenSource)
			dxDrawImageSection(bigmapPosX, screenH - bigmapPosY, screenW - 2 * bigmapPosX, bigmapPosY, bigmapPosX, screenH - bigmapPosY, screenW - 2 * bigmapPosX, bigmapPosY, screenSource)
		end

		for i = 1, #createdBlips do
			if createdBlips[i] then
				renderBigBlip(createdBlips[i].icon, createdBlips[i].posX, createdBlips[i].posY, mapPlayerPosX, mapPlayerPosY, createdBlips[i].renderDistance, createdBlips[i].iconSize, createdBlips[i].iconSize, createdBlips[i].color, false, i, playerRotation)
			end
		end

		for k,v in ipairs(getElementsByType("blip")) do
			if getElementAttachedTo(v) ~= localPlayer then
				local blipPosX, blipPosY = getElementPosition(v)

				renderBigBlip("blips/"..getBlipIcon(v)..".png", blipPosX, blipPosY, mapPlayerPosX, mapPlayerPosY, 9999, respc(22), respc(22), 0xFFFFFFFF, v, k)
			end
		end

		if showingPlayers then 
			for k, v in ipairs(getElementsByType("player")) do 
				if not (v == localPlayer) then 
					if getElementData(v, "user:loggedin") then
						if getElementInterior(v) == 0 then
							--print("asd")
							local playerX, playerY = getElementPosition(v)

							local color = tocolor(255, 255, 255)

							if getElementData(v, "user:aduty") then 
								color = tocolor(hex2rgb(exports.oAdmin:getAdminColor(getElementData(v, "user:admin"))))
							end

							renderBigBlip("blips/999.png", playerX, playerY, mapPlayerPosX, mapPlayerPosY, 9999, respc(22), respc(22), color, v)
						end
					end
				end
			end
		end

		if (exports.oDashboard:getFactionType(getElementData(localPlayer, "char:duty:faction")) == 1) then  
			for k, v in ipairs(getElementsByType("vehicle")) do 
				local unitNumber = getElementData(v, "mdc:unitNumber") or ""
				if string.len(unitNumber) > 0 then
					if getElementDimension(v) == 0 and getElementInterior(v) == 0 then
						local vehX, vehY = getElementPosition(v)

						local datas = getElementData(v, "mdc:unitState") or {0, 255, 255, 255}

						local color = tocolor(datas[2], datas[3], datas[4])

						renderBigBlip("blips/999.png", vehX, vehY, mapPlayerPosX, mapPlayerPosY, 9999, respc(30), respc(30), color, v)
					end
				end
			end

			for k, v in ipairs(getElementsByType("player")) do 
				if getElementData(v, "atmRob:hasMoneyCaset") then
					if getElementDimension(v) == 0 and getElementInterior(v) == 0 then 
						local x, y = getElementPosition(v)
						renderBigBlip("circle.png", x, y, mapPlayerPosX, mapPlayerPosY, false, respc(30), respc(30), tocolor(255, 255, 255, 255), v)
					end
				end
			end
			for k, v in ipairs(getElementsByType("vehicle")) do 
				if getElementData(v, "char:stealer") then
					if getElementDimension(v) == 0 and getElementInterior(v) == 0 then 
						local x, y = getElementPosition(v)
						renderBigBlip("circle.png", x, y, mapPlayerPosX, mapPlayerPosY, false, respc(30), respc(30), tocolor(255, 255, 255, 255), v)
					end
				end
			end
		end

		renderBigBlip("arrow.png", playerPosX, playerPosY, mapPlayerPosX, mapPlayerPosY, false, 20, 20)

		dxDrawImage(bigmapPosX,bigmapPosY,bigmapWidth,bigmapHeight,sotetites,0,0,0,tocolor(30,30,30,100))

		local zoneName = getZoneName(playerPosX, playerPosY, playerPosZ)
		local textWidth = 0
		if cursorX and cursorY then
			local zoneX = reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000)
			local zoneY = reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
			textWidth = dxGetTextWidth(getZoneName(zoneX, zoneY, 0), 1, exports.oFont:getFont("condensed", math.floor(respc(15))))
		else
			textWidth = dxGetTextWidth(zoneName, 1, exports.oFont:getFont("condensed", math.floor(respc(15))))
		end
		

		dxDrawRectangle(bigmapPosX + bigmapWidth - textWidth - respc(91), bigmapPosY+bigmapHeight-respc(75), textWidth+respc(66), respc(50),tocolor(30,30,30,255))
		dxDrawImage(bigmapPosX + bigmapWidth - respc(65), bigmapPosY + bigmapHeight - respc(75)+respc(9), respc(30), respc(30), "files/placeholder.png",0,0,0,tocolor(220,220,220,255))
	
		if cursorX and cursorY then
			local zoneX = reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000)
			local zoneY = reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)


			if visibleBlipTooltip then
				dxDrawRectangle(cursorX - dxGetTextWidth(visibleBlipTooltip,1.2,font)/2, cursorY + respc(30), dxGetTextWidth(visibleBlipTooltip,1.2,font),respc(20), tocolor(35, 35, 35, 240))
				dxDrawText(visibleBlipTooltip, cursorX - dxGetTextWidth(visibleBlipTooltip,1.2,font)/2, cursorY + respc(30), cursorX - dxGetTextWidth(visibleBlipTooltip,1.2,font)/2 + dxGetTextWidth(visibleBlipTooltip,1.2,font), cursorY + respc(30) + respc(20), tocolor(220,220,220,255), 1, font, "center", "center")
			end
			dxDrawText(getZoneName(zoneX, zoneY, 0), bigmapPosX + bigmapWidth - respc(325), bigmapPosY+bigmapHeight-respc(75), bigmapPosX + bigmapWidth - respc(325) + respc(247), bigmapPosY+bigmapHeight-respc(75) + respc(50), tocolor(220,220,220,255), 1, exports.oFont:getFont("condensed", math.floor(respc(15))), "right", "center")
		else 
			dxDrawText(zoneName, bigmapPosX + bigmapWidth - respc(325), bigmapPosY+bigmapHeight-respc(75), bigmapPosX + bigmapWidth - respc(325) + respc(247), bigmapPosY+bigmapHeight-respc(75) + respc(50), tocolor(220,220,220,255), 1, exports.oFont:getFont("condensed", math.floor(respc(15))), "right", "center")
		end

		



		if not core:isInSlot(bigmapPosX + bigmapWidth - respc(25), bigmapPosY + bigmapHeight - respc(22),respc(20),respc(20)) then 
			if bigMap_OptionsHover then 
				bigMap_OptionsRotationTick = getTickCount()
				bigMap_OptionsHoverAnimType = 2
			end
			bigMap_OptionsHover = false 
		else
			if not bigMap_OptionsHover then 
				bigMap_OptionsHover = true 
				bigMap_OptionsRotationTick = getTickCount()
				bigMap_OptionsHoverAnimType = 1
			end
		end

		local rotation = 0 
		local textalpha = 0

		if bigMap_OptionsHoverAnimType == 1 then 
			rotation = interpolateBetween(rotation,0,0,340,0,0,(getTickCount()-bigMap_OptionsRotationTick)/2500,"InOutQuad")
			textalpha = interpolateBetween(0,0,0,1,0,0,(getTickCount()-bigMap_OptionsRotationTick)/2500,"Linear")
		elseif bigMap_OptionsHoverAnimType == 2 then 
			rotation = interpolateBetween(340,0,0,0,0,0,(getTickCount()-bigMap_OptionsRotationTick)/2500,"InOutQuad")
			textalpha = interpolateBetween(1,0,0,0,0,0,(getTickCount()-bigMap_OptionsRotationTick)/2500,"Linear")
		end

		--[[if bigMap_OptionsPanelShowing then 

			dxDrawRectangle(bigmapPosX + bigmapWidth - respc(210),bigmapPosY + bigmapHeight - respc(130),respc(200),respc(90),tocolor(35,35,35,255))
			dxDrawText(color.."Radar #dcdcdc- Beállítások",bigmapPosX + bigmapWidth - respc(210),bigmapPosY + bigmapHeight - respc(130),bigmapPosX + bigmapWidth - respc(210)+respc(200),bigmapPosY + bigmapHeight - respc(130)+respc(90),tocolor(220,220,220,255),1,font,"center","top",false,false,false,true)


			dxDrawText("3D Blippek: "..color..Blip3DStatesNames[(state3DBlip)],bigmapPosX + bigmapWidth - respc(210),bigmapPosY + bigmapHeight - respc(130),bigmapPosX + bigmapWidth - respc(210)+respc(200),bigmapPosY + bigmapHeight - respc(130)+respc(90),tocolor(220,220,220,255),1,font,"center","center",false,false,false,true)

			dxDrawImage(bigmapPosX + bigmapWidth - respc(25), bigmapPosY + bigmapHeight - respc(22),respc(20),respc(20),"files/settings.png",rotation,0,0,tocolor(r,g,b,255))
			dxDrawText("Beállítások", bigmapPosX + bigmapWidth - respc(27), bigmapPosY + bigmapHeight - zoneLineHeight, bigmapPosX + bigmapWidth - respc(27), bigmapPosY + bigmapHeight, tocolor(r,g,b,255*textalpha), 1, font, "right", "center")
		else
			dxDrawImage(bigmapPosX + bigmapWidth - respc(25), bigmapPosY + bigmapHeight - respc(22),respc(20),respc(20),"files/settings.png",rotation,0,0,tocolor(220,220,220,255))
			dxDrawText("Beállítások", bigmapPosX + bigmapWidth - respc(27), bigmapPosY + bigmapHeight - zoneLineHeight, bigmapPosX + bigmapWidth - respc(27), bigmapPosY + bigmapHeight, tocolor(220,220,220,255*textalpha), 1, font, "right", "center")
		end]]

		dxDrawRectangle(bigmapPosX + respc(25), bigmapPosY+bigmapHeight-respc(75), respc(115), respc(50),tocolor(30,30,30,255))
		dxDrawText("3D BLIPPEK: ", bigmapPosX + respc(30), bigmapPosY+bigmapHeight-respc(70), bigmapPosX + respc(25)+respc(100), bigmapPosY+bigmapHeight-respc(75)+respc(50), tocolor(220,220,220,255), 1, exports.oFont:getFont("condensed", math.floor(respc(8))), "left", "top")
		dxDrawText(Blip3DStatesNames[(state3DBlip)], bigmapPosX + respc(30), bigmapPosY+bigmapHeight-respc(70), bigmapPosX + respc(25)+respc(100), bigmapPosY+bigmapHeight-respc(75)+respc(45), tocolor(220,220,220,255), 1, exports.oFont:getFont("condensed", math.floor(respc(14))), "left", "bottom", false, false, false, true)

		if isCursorShowing() then
			setCursorAlpha(0)
			local cursorX, cursorY = getCursorPosition()
			cursorX, cursorY = cursorX * screenW, cursorY * screenH 

			dxDrawImage(cursorX - respc(25), cursorY - respc(25), respc(50), respc(50), "files/focus.png")
		else
			setCursorAlpha(255)
		end

		-- GTA V Blip list |ORP v2
		local startY = sy*0.02
		local blipsOnlyOne = {}
		renderedBlips = {}
		local blipasd = {}

		for k, v in ipairs(createdBlips) do 
			local place = #renderedBlips + 1
			if blipsOnlyOne[v.icon] then 
				place = blipsOnlyOne[v.icon]
			else
				blipsOnlyOne[v.icon] = place
				table.insert(renderedBlips, place, {})
			end

			table.insert(renderedBlips[place], v)
		end 

		for k, v in ipairs(getElementsByType("blip")) do 
			if hasPermisonToSeeTheBlip("blips/" .. getBlipIcon(v) .. ".png") then 
				local blipname = getElementData(v, "blip:name")
				if not blipasd[blipname] then
					table.insert(renderedBlips, {{icon = "blips/" .. getBlipIcon(v) .. ".png", name = blipname}})
					blipasd[blipname] = true
				end
			end
		end

		local tooltipFont = fontScript:getFont("p_m", 14/myX*sx)
		local pointerPlus = math.max(0, selectedGTAVBlip - 20)
		for i = 1, 20 do
			if renderedBlips[i + pointerPlus] then
				local v = renderedBlips[i +pointerPlus][1] 
				local startX = sx*0.993

				local tooltip = ""
				
				if blipTooltips[v.icon] then 
					tooltip = blipTooltips[v.icon] 
				else
					tooltip = v.name or ""
				end

				if (i + pointerPlus) == selectedGTAVBlip then 
					bigGTAVIcon = v.icon
					--[[if (#renderedBlips[i + pointerPlus] > 1) then 
						tooltip = tooltip .. " ("..selectedSecondaryGTAVBlip.."/"..#renderedBlips[i + pointerPlus]..")"
					end]]
				end

				local width = dxGetTextWidth(tooltip, 1, tooltipFont) + sx*0.02 + 15/myX*sx
				if (i + pointerPlus) == selectedGTAVBlip then 
					dxDrawRectangle(startX - width, startY, width, sy*0.035, tocolor(255, 255, 255, 200))
					dxDrawText(tooltip, startX - width, startY, startX - 40/myX*sx, startY + sy*0.04, tocolor(30, 30, 30, 255), 1, tooltipFont, "right", "center")
				else
					dxDrawRectangle(startX - width, startY, width, sy*0.035, tocolor(30, 30, 30, 200))
					dxDrawText(tooltip, startX - width, startY, startX - 40/myX*sx, startY + sy*0.04, tocolor(255, 255, 255, 255), 1, tooltipFont, "right", "center")
				end

				dxDrawImage(startX - 35/myX*sx, startY + 4/myY*sy, 28/myX*sx, 28/myX*sx, "files/"..v.icon)
				startY = startY + sy*0.038
			end
		end


		if #renderedBlips > 20 then 
			local startX = sx*0.993
			local tooltip = selectedGTAVBlip.."/"..#renderedBlips
			local width = dxGetTextWidth(tooltip, 1, tooltipFont) + sx*0.02 + 15/myX*sx
			dxDrawRectangle(startX - width, startY, width, sy*0.035, tocolor(30, 30, 30, 200))
			dxDrawText(tooltip, startX - width, startY, startX - 40/myX*sx, startY + sy*0.04, tocolor(255, 255, 255, 255), 1, tooltipFont, "right", "center")
			dxDrawImage(startX - 35/myX*sx, startY + 4/myY*sy, 22/myX*sx, 22/myX*sx, "files/unfold.png")
		end

		if (lastKeyInteraction + 200) < getTickCount() then
			
			--[[if #renderedBlips[selectedGTAVBlip] > 1 then 
				if getKeyState("arrow_l") then
					if selectedSecondaryGTAVBlip > 1 then
						selectedSecondaryGTAVBlip = selectedSecondaryGTAVBlip - 1
						lastKeyInteraction = getTickCount()
						playSound(":oDashboard/files/sounds/select.wav")
					else
						selectedSecondaryGTAVBlip = #renderedBlips[selectedGTAVBlip]
						lastKeyInteraction = getTickCount()
						playSound(":oDashboard/files/sounds/select.wav")
					end
				elseif getKeyState("arrow_r") then 
					if selectedSecondaryGTAVBlip < #renderedBlips[selectedGTAVBlip] then
						selectedSecondaryGTAVBlip = selectedSecondaryGTAVBlip + 1
						lastKeyInteraction = getTickCount()
						playSound(":oDashboard/files/sounds/select.wav")
					else
						selectedSecondaryGTAVBlip = 1
						lastKeyInteraction = getTickCount()
						playSound(":oDashboard/files/sounds/select.wav")
					end
				end 
			end]]

			if getKeyState("arrow_d") then 
				if selectedGTAVBlip < #renderedBlips then
					selectedGTAVBlip = selectedGTAVBlip + 1
					selectedSecondaryGTAVBlip = 1
					lastKeyInteraction = getTickCount()
					playSound(":oDashboard/files/sounds/select.wav")
					--print()
					---moveRadarPositon2(renderedBlips[selectedGTAVBlip][selectedSecondaryGTAVBlip].posX, renderedBlips[selectedGTAVBlip][selectedSecondaryGTAVBlip].posY)
				else
					selectedGTAVBlip = 1
					selectedSecondaryGTAVBlip = 1
					lastKeyInteraction = getTickCount()
					playSound(":oDashboard/files/sounds/select.wav")
				end
			elseif getKeyState("arrow_u") then 
				if selectedGTAVBlip > 1 then 
					selectedGTAVBlip = selectedGTAVBlip - 1
					selectedSecondaryGTAVBlip = 1
					lastKeyInteraction = getTickCount()
					playSound(":oDashboard/files/sounds/select.wav")
				else
					selectedGTAVBlip = #renderedBlips
					selectedSecondaryGTAVBlip = 1
					lastKeyInteraction = getTickCount()
					playSound(":oDashboard/files/sounds/select.wav")
				end
			end
		end
		-- GTA V BLIP vége

		if visibleBlipTooltip then
			visibleBlipTooltip = false
		end

		if mapMovedPos then

			dxDrawRectangle(bigmapPosX + respc(25), bigmapPosY+respc(25), respc(375), respc(30),tocolor(30,30,30,255))

			dxDrawText("Nyomd meg a "..color.."[Space] #dcdcdcgombot a nézet visszaállításához.", bigmapPosX + respc(25), bigmapPosY+respc(25), bigmapPosX + respc(25) + respc(375), bigmapPosY+respc(25) + respc(30), tocolor(220,220,220,255), 1, exports.oFont:getFont("condensed", math.floor(respc(10))), "center", "center",false,false,false,true)

			if getKeyState("space") then
				moveRadarPositon(mapMovedPos[1], mapMovedPos[2])
			end
		end
	else
		dxDrawRectangle(bigmapPosX, bigmapPosY, bigmapWidth, bigmapHeight, tocolor(30, 30, 30,240))

		if not lostSignalStartTick then
			lostSignalStartTick = getTickCount()
		end

		local fadeAlpha = 255
		local iconRotation = 360
		if not lostSignalFadeIn then
			fadeAlpha = 255
		else
			fadeAlpha = 0
			iconRotation = 360
		end

		local lostSignalTick = (getTickCount() - lostSignalStartTick) / 2500
		if lostSignalTick > 1 then
			lostSignalStartTick = getTickCount()
			lostSignalFadeIn = not lostSignalFadeIn
		end

		dxDrawText("A kapcsolat megszakadt...",bigmapPosX, bigmapPosY,bigmapPosX+bigmapWidth, bigmapPosY+bigmapHeight+respc(100),tocolor(184, 53, 53,interpolateBetween(fadeAlpha, 0, 0, 255 - fadeAlpha, 0, 0, lostSignalTick, "Linear")),1,font2,"center","center",false,false,false,true)
		dxDrawImage(bigmapCenterX - 32, bigmapCenterY - 32 - 16, 64, 64, "files/gpslosticon.png",0,0,0,tocolor(184, 53, 53,interpolateBetween(fadeAlpha, 0, 0, 255 - fadeAlpha, 0, 0, lostSignalTick, "Linear")))
	end
end

function moveRadarPositon(x, y)
	if not isTimer(backRenderTimer) then 
		startValue1 = x
		startValue2 = y
		backTick = getTickCount()
		addEventHandler("onClientRender", root, radarRenderBackMove)

		backRenderTimer = setTimer(function()
			mapMovedPos = false
			lastDifferencePos = false
			removeEventHandler("onClientRender", root, radarRenderBackMove)

			if isTimer(backRenderTimer) then killTimer(backRenderTimer) end 
		end, 300, 1)
	end
end

function moveRadarPositon2(x, y)
	if not isTimer(backRenderTimer) then 
		mapMovedPos = {0, 0}
		startValue1 = x
		startValue2 = y
		backTick = getTickCount()
		addEventHandler("onClientRender", root, radarRenderBackMove2)

		backRenderTimer = setTimer(function()
			--mapMovedPos = false
			--lastDifferencePos = false
			removeEventHandler("onClientRender", root, radarRenderBackMove2)

			if isTimer(backRenderTimer) then killTimer(backRenderTimer) end 
		end, 300, 1)
	end
end

function radarRenderBackMove()
	mapMovedPos[1] = interpolateBetween(startValue1, 0, 0, 0, 0, 0, (getTickCount() - backTick) / 300, "InOutQuad")
	mapMovedPos[2] = interpolateBetween(startValue2, 0, 0, 0, 0, 0, (getTickCount() - backTick) / 300, "InOutQuad")
end

function radarRenderBackMove2()
	mapMovedPos[1] = interpolateBetween(mapMovedPos[1], 0, 0, startValue1, 0, 0, (getTickCount() - backTick) / 300, "InOutQuad")
	mapMovedPos[2] = interpolateBetween(mapMovedPos[2], 0, 0, startValue2, 0, 0, (getTickCount() - backTick) / 300, "InOutQuad")
end

local scrollTick = getTickCount()
local oldBigmapZoom = 0.5
local scrollDirection = 0

addEventHandler("onClientKey", getRootElement(),
	function (key, pressDown)
		if key == "F11" and pressDown and getElementData(localPlayer,"user:loggedin") then
			bigmapIsVisible = not bigmapIsVisible

			setElementData(localPlayer, "bigmapIsVisible", bigmapIsVisible, false)
			if bigmapIsVisible then
				exports.oInterface:toggleHud(true)
				addEventHandler("onClientRender", root, renderTheBigmap)
				setCursorAlpha(0)
				showChat(false)
				setElementData(localPlayer, "allseeoff", true)
			else
				exports.oInterface:toggleHud(false)
				removeEventHandler("onClientRender", root, renderTheBigmap)
				showChat(true)
				setCursorAlpha(255)
				setElementData(localPlayer, "allseeoff", false)
				if gpsHello and isElement(gpsHello) then
					destroyElement(gpsHello)
				end
				gpsHello = false

			end
			cancelEvent()
		elseif key == "mouse_wheel_up" then
			if pressDown then
				if bigmapIsVisible and bigmapZoom + 0.1 <= 2.1 then
					--bigmapZoom = bigmapZoom + 0.1

					scrollTick = getTickCount()
					oldBigmapZoom = bigmapZoom

					scrollDirection = 0.2
				end
			end
		elseif key == "mouse_wheel_down" then
			if pressDown then
				if bigmapIsVisible and bigmapZoom - 0.1 >= 0.1 then
					scrollTick = getTickCount()
					oldBigmapZoom = bigmapZoom

					scrollDirection = -0.2
				end
			end
		end
	end
)

function renderScroll()
	bigmapZoom = interpolateBetween(oldBigmapZoom, 0, 0, oldBigmapZoom + scrollDirection, 0, 0, (getTickCount() - scrollTick)/300, "Linear")
end
addEventHandler("onClientRender", root, renderScroll)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, cursorX, cursorY)
		if not bigmapIsVisible then
			return
		end

		if state == "up" and mapIsMoving then
			mapIsMoving = false
			return
		end

		local gpsRouteProcess = false

		if button == "left" and state == "up" then
			if occupiedVehicle and carCanGPS() then
				if getElementData(occupiedVehicle, "gpsDestination") then
					setElementData(occupiedVehicle, "gpsDestination", false)
				else
					setElementData(occupiedVehicle, "gpsDestination", {
						reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000),
						reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
					})
				end
				gpsRouteProcess = true
			end

			if core:isInSlot(bigmapPosX + bigmapWidth - respc(25), bigmapPosY + bigmapHeight - respc(22),respc(20),respc(20)) then 
				if bigMap_OptionsPanelShowing then 
					bigMap_OptionsPanelShowing = false 
				else
					bigMap_OptionsPanelShowing = true 
				end
			end

			if core:isInSlot(bigmapPosX + respc(25), bigmapPosY+bigmapHeight-respc(75), respc(110), respc(50)) then 
				if state3DBlip < 2 then 
					state3DBlip = state3DBlip + 1
				else
					state3DBlip = 1
				end
				settingsStorage.show3DBlips = state3DBlip
				if state3DBlip == 1 then 
					removeEventHandler("onClientHUDRender", getRootElement(), render3DBlips)
				else
					addEventHandler("onClientHUDRender", getRootElement(), render3DBlips, true, "low-99999999")
				end
			end
		end

		if not gpsRouteProcess then
			if state == "up" then
				if hoveredWaypointBlip then
					table.remove(createdBlips, hoveredWaypointBlip)
				else
					local blipPosX = reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000)
					local blipPosY = reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
					local blipPosZ = getGroundPosition(blipPosX, blipPosY, 400) + 3

					--createCustomBlip(blipPosX, blipPosY, blipPosZ, "blips/markblip.png", true, 9999, 18, 0xFFFFFFFF)
				end
			end
		end
	end
)

addEventHandler("onClientResourceStop", resourceRoot, function()
	exports.oJSON:saveDataToJSONFile(tonumber(state3DBlip), "3dblippek", true)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	state3DBlip = (exports.oJSON:loadDataFromJSONFile("3dblippek", true) or 1)

	if state3DBlip == 2 then 
		addEventHandler("onClientHUDRender", getRootElement(), render3DBlips, true, "low-99999999")
	end
end)

addEventHandler("onClientRestore", getRootElement(),
	function ()
		if gpsRoute then
			processGPSLines()
		end
	end
)

addCommandHandler("showplayers", function()
	if getElementData(localPlayer, "user:aduty") then 
		showingPlayers = not showingPlayers 
	end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
	if source == localPlayer and data == "user:aduty" then 
		if not new then 
			showingPlayers = false
		end
	end
end)

local animatedBlipValues = {1, 1, 1, 1, 1}

function renderBlip(icon, blipX, blipY, playerPosX, playerPosY, blipWidth, blipHeight, blipColor, cameraRotation, farShow, blipTableId)
	if not hasPermisonToSeeTheBlip(icon) then 
		return 
	end

	local blipPosX = minimapRenderHalfSize + (playerPosX - remapTheFirstWay(blipX)) * minimapZoom
	local blipPosY = minimapRenderHalfSize - (playerPosY - remapTheFirstWay(blipY)) * minimapZoom

	if not farShow and (blipPosX > minimapRenderSize or 0 > blipPosX or blipPosY > minimapRenderSize or 0 > blipPosY) then
		return
	end

	local blipIsVisible = true
	if farShow then
		if blipPosX > minimapRenderSize then
			blipPosX = minimapRenderSize
		end
		if blipPosX < 0 then
			blipPosX = 0
		end
		if blipPosY > minimapRenderSize then
			blipPosY = minimapRenderSize
		end
		if blipPosY < 0 then
			blipPosY = 0
		end

		local angle = rad((cameraRotation - 270) + 90)
		local cosinus, sinus = cos(angle), sin(angle)

		local blipScreenPosX = minimapPosX - minimapRenderHalfSize + minimapWidth / 2 + (minimapRenderHalfSize + cosinus * (blipPosX - minimapRenderHalfSize) - sinus * (blipPosY - minimapRenderHalfSize) - blipWidth / 2)
		local blipScreenPosY = minimapPosY - minimapRenderHalfSize + minimapHeight / 2 + (minimapRenderHalfSize + sinus * (blipPosX - minimapRenderHalfSize) + cosinus * (blipPosY - minimapRenderHalfSize) - blipHeight / 2)

		farshowBlips[blipTableId] = nil

		if blipScreenPosX < minimapPosX or blipScreenPosX > minimapPosX + minimapWidth - blipWidth then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if blipScreenPosY < minimapPosY or blipScreenPosY > minimapPosY + minimapHeight - zoneLineHeight - blipHeight then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if farshowBlips[blipTableId] then
			farshowBlipsData[blipTableId] = {
				posX = max(minimapPosX, min(minimapPosX + minimapWidth - blipWidth, blipScreenPosX)),
				posY = max(minimapPosY, min(minimapPosY + minimapHeight - zoneLineHeight - blipHeight, blipScreenPosY)),
				icon = icon,
				iconWidth = blipWidth,
				iconHeight = blipHeight,
				color = blipColor
			}
		end
	end

	if blipIsVisible then
		if icon == "circle.png" then 
			blipWidth, blipHeight = blipWidth/2, blipHeight/2

			for i = 1, 4 do 
				if animatedBlipValues[i] > 20 then
					dxDrawImage(blipPosX - blipWidth / 2, blipPosY - blipHeight / 2, blipWidth, blipHeight, "files/" .. icon, 180 - cameraRotation, 0, 0, tocolor(235, 66, 66, animatedBlipValues[i]))
				end

				blipWidth = blipWidth + respc(7) + (respc(3) * i)
				blipHeight = blipHeight + respc(7) + (respc(3) * i)
			end
		else
			dxDrawImage(blipPosX - blipWidth / 2, blipPosY - blipHeight / 2, blipWidth, blipHeight, "files/" .. icon, 180 - cameraRotation, 0, 0, blipColor)
		end
	end
end

local blipTicks = {getTickCount(), getTickCount(), getTickCount(), getTickCount()}
local animationState = "start"
addEventHandler("onClientRender", root, function()
	for i = 1, 4 do
		if animationState == "start" then 
			animatedBlipValues[i] = interpolateBetween(10, 0, 0, 170, 0, 0, (getTickCount() - blipTicks[i]) / (500 + (i * 400)), "InOutQuad")

			if animatedBlipValues[4] >= 169 then 
				blipTicks = {getTickCount(), getTickCount(), getTickCount(), getTickCount()}
				animationState = "close"
			end
		else
			animatedBlipValues[i] = interpolateBetween(170, 0, 0, 10, 0, 0, (getTickCount() - blipTicks[i]) / (500 + (i * 550)), "InOutQuad")

			if animatedBlipValues[4] <= 11 then 
				blipTicks = {getTickCount(), getTickCount(), getTickCount(), getTickCount()}
				animationState = "start"
			end
		end
		
	end 
end)

local hoverWarp = false
local lastAct = 0

function toggleWarp()
	hoverWarp = not hoverWarp
	if hoverWarp then 
		outputChatBox(color .. " Bekapcsoltad a hover warpot!", 255,255,255,true)
	else
		outputChatBox(color .. " kikapcsoltad a hover warpot!", 255,255,255,true)
	end
end
addCommandHandler("togglewarp",toggleWarp)
addCommandHandler("togwarp",toggleWarp)
addCommandHandler("togglewp",toggleWarp)
addCommandHandler("togwp",toggleWarp)

function renderBigBlip(icon, blipX, blipY, playerPosX, playerPosY, renderDistance, blipWidth, blipHeight, blipColor, blipElement, blipId)
	if renderDistance and getDistanceBetweenPoints2D(playerPosX, playerPosY, blipX, blipY) > renderDistance then
		return
	end

	if not hasPermisonToSeeTheBlip(icon) then 
		return 
	end

	local normalWidth, normalHeight = blipWidth, blipHeight
	blipWidth = (blipWidth / (4 - bigmapZoom) + 3) * 2.25
	blipHeight = (blipHeight / (4 - bigmapZoom) + 3) * 2.25

	local blipHalfWidth = blipWidth / 2
	local blipHalfHeight = blipHeight / 2

	local isHovered = false
	local selectedBlip = false

	blipX = max(bigmapPosX + blipHalfWidth, min(bigmapPosX + bigmapWidth - blipHalfWidth, bigmapCenterX + (remapTheFirstWay(playerPosX) - remapTheFirstWay(blipX)) * bigmapZoom))
	blipY = max(bigmapPosY + blipHalfHeight, min(bigmapPosY + bigmapHeight - blipHalfHeight, bigmapCenterY - (remapTheFirstWay(playerPosY) - remapTheFirstWay(blipY)) * bigmapZoom))

	if cursorX and cursorY then
		if isElement(blipElement) then
			if isCursorWithinArea(cursorX, cursorY, blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight) then
				--print("asd")
				if blipTooltips[blipElement] then
					visibleBlipTooltip = blipTooltips[blipElement]
				elseif getElementType(blipElement) == "player" and playerCanSeePlayers then
					local playername = getElementData(blipElement, "char:name")

					if getElementData(blipElement, "user:aduty") then 
						playername = getElementData(blipElement, "user:adminnick")
					end

					visibleBlipTooltip = string.gsub(string.gsub(getElementData(blipElement, "blip:name") or playername, "#%x%x%x%x%x%x", ""), "_", " ") .. " (" .. getElementData(blipElement, "playerid") .. ")"
				elseif (exports.oDashboard:getFactionType(getElementData(localPlayer, "char:duty:faction")) == 1) then  
					local unitNumber = getElementData(blipElement, "mdc:unitNumber") or ""
					if string.len(unitNumber) > 0 then
						visibleBlipTooltip = unitNumber 
					end
				end
				if getElementData(localPlayer, "user:aduty") and hoverWarp then 
					if getTickCount()-lastAct >= 1000 and getKeyState("mouse1") then
						lastAct = getTickCount()
						x,y,z = getElementPosition(blipElement)
						setElementPosition(localPlayer, x,y,z+0.1)
					end
				end
				--print(visibleBlipTooltip)
				isHovered = true
			end
		else
			if blipTooltips[icon] and isCursorWithinArea(cursorX, cursorY, blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight) then
				visibleBlipTooltip = blipTooltips[icon]
				if getElementData(localPlayer, "user:aduty") and hoverWarp then 
					if getTickCount()-lastAct >= 1000 and getKeyState("mouse1") then
						lastAct = getTickCount()
						x,y,z = createdBlips[blipId].posX, createdBlips[blipId].posY, createdBlips[blipId].posZ
						setElementPosition(localPlayer, x,y,z+0.1)
					end
				end
				if icon == "blips/markblip.png" then
					hoveredWaypointBlip = blipId
				end

				isHovered = true
			end
		end
	end

	--print(selectedSecondaryGTAVBlip, toJSON(renderedBlips[selectedGTAVBlip][2]))
	--if== blipX and renderedBlips[selectedGTAVBlip][selectedSecondaryGTAVBlip].posY == blipY then 
	--	isHovered = true 
	--end

	if icon == "arrow.png" then
		local _, _, playerRotation = getElementRotation(localPlayer)
		dxDrawImage(blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight, "files/" .. icon, abs(360 - playerRotation))
	elseif icon == "circle.png" then 
		blipWidth, blipHeight = blipWidth/2, blipHeight/2

		for i = 1, 4 do 
			if animatedBlipValues[i] > 20 then
				dxDrawImage(blipX - blipWidth / 2, blipY - blipHeight / 2, blipWidth, blipHeight, "files/" .. icon, 0, 0, 0, tocolor(235, 66, 66, animatedBlipValues[i]))
			end

			blipWidth = blipWidth + respc(7) + (respc(3) * i)
			blipHeight = blipHeight + respc(7) + (respc(3) * i)
		end
	else
		if isHovered or bigGTAVIcon == icon then
			local plusSize = 1.35
			dxDrawImage(blipX - blipHalfWidth * plusSize, blipY - blipHalfHeight * plusSize, blipWidth * plusSize, blipHeight * plusSize, "files/" .. icon, 0, 0, 0, blipColor)
		else
			dxDrawImage(blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight, "files/" .. icon, 0, 0, 0, blipColor)
		end
	end
end

local is3dBlipRenderable = {
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[11] = true,
	[12] = true,
	[51] = true,
	[18] = true,
	[56] = true,
	[57] = true,
	[58] = true,
	[59] = true,
	[60] = true,
	[25] = true,
	[29] = true,
	[27] = true,
	[51] = true,
	[56] = true,
	[57] = true,
	[59] = true,
}

local is3dBlipRenderable2 = {
	["blips/3.png"] = true,
	["blips/4.png"] = true,
	["blips/5.png"] = true,
	["blips/6.png"] = true,
	["blips/11.png"] = true,
	["blips/51.png"] = true,
	["blips/18.png"] = true,
	["blips/12.png"] = true,
	["blips/25.png"] = true,
	["blips/29.png"] = true,
	["blips/27.png"] = true,
	["blips/51.png"] = true,
}

function render3DBlips()
	if getElementDimension(localPlayer) == 0 then
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)

		for i = 1, #createdBlips do
			if createdBlips[i] then
				if is3dBlipRenderable2[createdBlips[i].icon] then 

					local screenX, screenY = getScreenFromWorldPosition(createdBlips[i].posX, createdBlips[i].posY, createdBlips[i].posZ)

					if screenX and screenY then
						local distanceBetweenBlip = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, createdBlips[i].posX, createdBlips[i].posY, createdBlips[i].posZ)
						if distanceBetweenBlip <= 999 then
							local blipHalfSize = createdBlips[i].iconSize / 2

							--dxDrawText(floor(distanceBetweenBlip) .. " m", screenX + 1, screenY + 1 + blipHalfSize + respc(100), screenX, 0, tocolor(0, 0, 0, 255), 0.75, font, "center", "top")
							--dxDrawText(floor(distanceBetweenBlip) .. " m", screenX, screenY + blipHalfSize + respc(100), screenX, 0, 0xFFFFFFFF, 0.75, font, "center", "top")
							local blipName = blipTooltips[createdBlips[i].icon]
							--outputChatBox(createdBlips[i].icon)
							dxDrawText(blipName, screenX + 1, screenY + 1 + blipHalfSize + respc(4), screenX, 0, tocolor(0, 0, 0, 255), 0.75, font, "center", "top")
							dxDrawText(blipName, screenX, screenY + blipHalfSize + respc(4), screenX, 0, 0xFFFFFFFF, 0.75, font, "center", "top")

							dxDrawText(floor(distanceBetweenBlip) .. " m", screenX + 1, screenY + 1 + blipHalfSize + respc(14), screenX, 0, tocolor(0, 0, 0, 255), 0.75, font, "center", "top")
							dxDrawText(floor(distanceBetweenBlip) .. " m", screenX, screenY + blipHalfSize + respc(14), screenX, 0, 0xFFFFFFFF, 0.75, font, "center", "top")

							dxDrawImage(screenX - blipHalfSize, screenY - blipHalfSize, createdBlips[i].iconSize, createdBlips[i].iconSize, "files/" .. createdBlips[i].icon, 0, 0, 0, tocolor(255, 255, 255, 200))
						end
					end
				end
			end
		end

		local blipTable = getElementsByType("blip")
		for i = 1, #blipTable do
			if blipTable[i] then
				if getElementAttachedTo(blipTable[i]) ~= localPlayer then
					local blipPosX, blipPosY, blipPosZ = getElementPosition(blipTable[i])
					local screenX, screenY = getScreenFromWorldPosition(blipPosX, blipPosY, blipPosZ)

					if screenX and screenY then
						local distanceBetweenBlip = core:getDistance(blipTable[i], localPlayer)
						local blipHalfSize = 0 

						if createdBlips[i] then
							blipHalfSize = createdBlips[i].iconSize / 2
						else
							blipHalfSize = 11
						end

						local blipIcon = getBlipIcon(blipTable[i])

						if is3dBlipRenderable[tonumber(blipIcon)] then 

							if blipIcon == 38 or blipIcon == 39 then 
								if not (getElementData(localPlayer, "char:duty:faction") == exports.oFactionScripts:getFireFactionID()) then 
									return
								end
							elseif blipIcon == 18 then 
								if not (exports.oDashboard:getFactionType(getElementData(localPlayer, "char:duty:faction")) == 1) then 
									return
								end
							elseif blipIcon == 51 then 
								local occupiedVeh = getPedOccupiedVehicle(localPlayer)
						
								if occupiedVeh then 
									local model = getElementModel(occupiedVeh)
									if not (model == 546 or model == 496 or model == 585) then
										return  
									end
								else
									return
								end
							end
	
							--print("asd")
							dxDrawText(floor(distanceBetweenBlip) .. " m", screenX + 1, screenY + 1 + blipHalfSize + respc(14), screenX, 0, tocolor(0, 0, 0, 255), 0.75, font, "center", "top")
							dxDrawText(floor(distanceBetweenBlip) .. " m", screenX, screenY + blipHalfSize + respc(14), screenX, 0, 0xFFFFFFFF, 0.75, font, "center", "top")

							local blipName = getElementData(blipTable[i], "blip:name") or blipTooltips["blips/" .. blipIcon ..".png"]
							dxDrawText(blipName, screenX + 1, screenY + 1 + blipHalfSize + respc(4), screenX, 0, tocolor(0, 0, 0, 255), 0.75, font, "center", "top")
							dxDrawText(blipName, screenX, screenY + blipHalfSize + respc(4), screenX, 0, 0xFFFFFFFF, 0.75, font, "center", "top")

							if createdBlips[i] then
								dxDrawImage(screenX - blipHalfSize, screenY - blipHalfSize, createdBlips[i].iconSize, createdBlips[i].iconSize, "files/blips/" .. blipIcon ..".png", 0, 0, 0, tocolor(255, 255, 255, 200))
							else
								dxDrawImage(screenX - blipHalfSize, screenY - blipHalfSize, 22, 22, "files/blips/" .. blipIcon ..".png", 0, 0, 0, tocolor(255, 255, 255, 200))
							end
						end
					end
				end
			end
		end
	end
end

function createCustomBlip(x, y, z, icon, farShow, visibleDistance, size, color)
	table.insert(createdBlips, {
		posX = x,
		posY = y,
		posZ = z,
		icon = icon,
		farShow = farShow,
		renderDistance = visibleDistance or 9999,
		iconSize = size or 22,
		color = color or tocolor(255, 255, 255)
	})
end

function deleteCustomBlip(count)
	table.remove(createdBlips, count)
end

function remapTheFirstWay(coord)
	return (-coord + 3000) / mapRatio
end

function remapTheSecondWay(coord)
	return (coord + 3000) / mapRatio
end

function carCanGPS()
	--if getElementData(occupiedVehicle, "dbid") then
	--	carCanGPSVal = getElementData(occupiedVehicle, "vehicle.tuning.navigation") or false
	--else
		carCanGPSVal = 1
	--end

	return carCanGPSVal
end

function addGPSLine(x, y)
	table.insert(gpsLines, {remapTheFirstWay(x), remapTheFirstWay(y)})
end

function processGPSLines()
	local routeStartPosX, routeStartPosY = 99999, 99999
	local routeEndPosX, routeEndPosY = -99999, -99999

	for i = 1, #gpsLines do
		if gpsLines[i][1] < routeStartPosX then
			routeStartPosX = gpsLines[i][1]
		end

		if gpsLines[i][2] < routeStartPosY then
			routeStartPosY = gpsLines[i][2]
		end

		if gpsLines[i][1] > routeEndPosX then
			routeEndPosX = gpsLines[i][1]
		end

		if gpsLines[i][2] > routeEndPosY then
			routeEndPosY = gpsLines[i][2]
		end
	end

	local routeWidth = (routeEndPosX - routeStartPosX) + 16
	local routeHeight = (routeEndPosY - routeStartPosY) + 16

	if isElement(gpsRouteImage) then
		destroyElement(gpsRouteImage)
	end

	gpsRouteImage = dxCreateRenderTarget(routeWidth, routeHeight, true)
	gpsRouteImageData = {routeStartPosX - 8, routeStartPosY - 8, routeWidth, routeHeight}

	dxSetRenderTarget(gpsRouteImage)
	dxSetBlendMode("modulate_add")

	dxDrawImage(gpsLines[1][1] - routeStartPosX + 8 - 4, gpsLines[1][2] - routeStartPosY + 8 - 4, 8, 8, "gps/images/dot.png")

	for i = 2, #gpsLines do
		if gpsLines[i - 1] then
			local startX = gpsLines[i][1] - routeStartPosX + 8
			local startY = gpsLines[i][2] - routeStartPosY + 8
			local endX = gpsLines[i - 1][1] - routeStartPosX + 8
			local endY = gpsLines[i - 1][2] - routeStartPosY + 8

			dxDrawImage(startX - 4, startY - 4, 8, 8, "gps/images/dot.png")
			dxDrawLine(startX, startY, endX, endY, tocolor(255, 255, 255), 9)
		end
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end

function clearGPSRoute()
	gpsLines = {}

	if isElement(gpsRouteImage) then
		destroyElement(gpsRouteImage)
	end
	gpsRouteImage = false
end


function dxDrawInnerBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)

	dxDrawRectangle(x, y, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h - borderSize, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + borderSize, borderSize, h - (borderSize * 2), borderColor, postGUI)
	dxDrawRectangle(x + w - borderSize, y + borderSize, borderSize, h - (borderSize * 2), borderColor, postGUI)
end

function dxDrawOuterBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)

	dxDrawRectangle(x - borderSize, y - borderSize, w + (borderSize * 2), borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x - borderSize, y, borderSize, h + borderSize, borderColor, postGUI)
	dxDrawRectangle(x + w, y, borderSize, h + borderSize, borderColor, postGUI)
end

function dxDrawBorderedImageSection(x, y, w, h, ux, uy, uw, uh, path, rx, ry, rz, color, postGUI)
	dxDrawImageSection(x - 1, y - 1, w, h, ux, uy, uw, uh, path, rx, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	dxDrawImageSection(x - 1, y + 1, w, h, ux, uy, uw, uh, path, rx, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	dxDrawImageSection(x + 1, y - 1, w, h, ux, uy, uw, uh, path, rx, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	dxDrawImageSection(x + 1, y + 1, w, h, ux, uy, uw, uh, path, rx, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	dxDrawImageSection(x, y, w, h, ux, uy, uw, uh, path, rx, ry, rz, color, postGUI)
end

function dxDrawBorderedText(text, x, y, w, h, color, ...)
	local textWithoutHEX = gsub(text, "#%x%x%x%x%x%x", "")
	dxDrawText(textWithoutHEX, x - 1, y - 1, w - 1, h - 1, tocolor(0, 0, 0, 255), ...)
	dxDrawText(textWithoutHEX, x - 1, y + 1, w - 1, h + 1, tocolor(0, 0, 0, 255), ...)
	dxDrawText(textWithoutHEX, x + 1, y - 1, w + 1, h - 1, tocolor(0, 0, 0, 255), ...)
	dxDrawText(textWithoutHEX, x + 1, y + 1, w + 1, h + 1, tocolor(0, 0, 0, 255), ...)
	dxDrawText(text, x, y, w, h, color, ...)
end

function dxDrawRoundedRectangle(x, y, w, h, color, postGUI, subPixelPositioning, radius)
	radius = radius or 5

	dxDrawImage(x, y, radius, radius, getTexture("round"), 0, 0, 0, color, postGUI)
	dxDrawRectangle(x, y + radius, radius, h - radius * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x, y + h - radius, radius, radius, getTexture("round"), 270, 0, 0, color, postGUI)
	dxDrawRectangle(x + radius, y, w - radius * 2, h, color, postGUI, subPixelPositioning)
	dxDrawImage(x + w - radius, y, radius, radius, getTexture("round"), 90, 0, 0, color, postGUI)
	dxDrawRectangle(x + w - radius, y + radius, radius, h - radius * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x + w - radius, y + h - radius, radius, radius, getTexture("round"), 180, 0, 0, color, postGUI)
end

function getHudCursorPos()
	if isCursorShowing() then
		return getCursorPosition()
	end
	return false
end

function getFont(name)
	if createdFonts[name] then
		return createdFonts[name]
	end

	return "default"
end

function initFont(name, path, size)
	if not createdFonts[name] then
		createdFonts[name] = dxCreateFont("files/fonts/" .. path, resp(size), false, "antialiased")
	else
		return createdFonts[name]
	end
end

function isCursorWithinArea(cx, cy, x, y, w, h)
	if isCursorShowing() then
		if cx >= x and cx <= x + w and cy >= y and cy <= y + h then
			return true
		end
	end

	return false
end

addEventHandler("onClientVehicleEnter", getRootElement(),
	function (player)
		if player == localPlayer then
			if occupiedVehicle ~= source then
				occupiedVehicle = source
			end
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (player)
		if player == localPlayer then
			if occupiedVehicle == source then
				occupiedVehicle = false
			end
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)

addEventHandler("onClientVehicleExplode", getRootElement(),
	function ()
		if occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)

function getVehicleSpeed(vehicle)
	local velocityX, velocityY, velocityZ = getElementVelocity(vehicle)
	return ((velocityX * velocityX + velocityY * velocityY + velocityZ * velocityZ) ^ 0.5) * 187.5
end

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

function hasPermisonToSeeTheBlip(icon)
	if icon == "blips/38.png" or icon == "blips/39.png" then 
		if not (getElementData(localPlayer, "char:duty:faction") == exports.oFactionScripts:getFireFactionID()) then 
			return false 
		else
			return true
		end
	elseif icon == "blips/18.png" or icon == "blips/26.png" then 
		if not (exports.oDashboard:getFactionType(getElementData(localPlayer, "char:duty:faction")) == 1) then 
			return false 
		else
			return true 
		end
	elseif icon == "blips/51.png" then 
		local occupiedVeh = getPedOccupiedVehicle(localPlayer)

		if occupiedVeh then 
			local model = getElementModel(occupiedVeh)
			if (model == 546 or model == 496 or model == 585) then
				return true  
			else
				return false
			end
		else
			return false
		end
	else
		return true
	end
end