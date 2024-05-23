local screenW, screenH = guiGetScreenSize()

local mainFont = font:getFont("condensed", 14)
local mainFontHeight = dxGetFontHeight(1, mainFont)

local iconSize = 15
local headerSize = 15
local menuSize = 50
local marginOffset = 10
local marginOffsetHalf = marginOffset / 2

local paintAreaWidth = 580
local paintAreaHeight = 360

local panelWidth = paintAreaWidth + marginOffset
local panelHeight = paintAreaHeight - marginOffset * 2

local panelPosX = (screenW - panelWidth) / 2
local panelPosY = (screenH - panelHeight) / 2

local moveDifferenceX = 0
local moveDifferenceY = 0
local panelIsMoving = false

local paintAreaPosX = panelPosX + marginOffset / 2
local paintAreaPosY = panelPosY + headerSize + marginOffset

local panelTheme = "dark"
local panelColors = {
	main_dark = tocolor(41, 41, 41),
	header_dark = tocolor(28, 28, 28),
	menu_dark = tocolor(32, 32, 32),
	footer_dark = tocolor(28, 28, 28),
	normaltext_dark = tocolor(255, 255, 255),
	scrollbarBg_dark = tocolor(228, 228, 228, 75),
	scrollbar_dark = tocolor(228, 228, 228),
	
	main_light = tocolor(202, 202, 204),
	header_light = tocolor(0, 0, 0, 200),
	menu_light = tocolor(0, 0, 0, 175),
	footer_light = tocolor(50, 50, 50),
	normaltext_light = tocolor(0, 0, 0),
	scrollbarBg_light = tocolor(25, 25, 25, 75),
	scrollbar_light = tocolor(25, 25, 25),
}

local brushData = {
	isActive = false,
	barColor = tocolor(r, g, b, 230),
	barWidth = panelWidth - marginOffset * 2,
	barHeight = 10,
	minimumSize = 2,
	maximumSize = 32,
	currentSize = 8,
	currentColor = 1
}

local activecolorInput = false
local colorData = {
	isActive = false,
	paletteHeight = paintAreaHeight - 50,
	hue = 0.5,
	saturation = 0.5,
	lightness = 0.5,
	colorInputs = {
		rgb = {
			width = dxGetTextWidth("255", 0.75, mainFont) + 10,
			red = 255,
			green = 255,
			blue = 255
		},
		hex = {
			width = dxGetTextWidth("#FFFFFF", 0.75, mainFont) + 10,
			hex = "#FFFFFF"
		}
	},
	luminance = {
		barWidth = paintAreaWidth,
		barHeight = 10
	}
}

local savedGraffitisMenu = {
	isActive = false,
	imageWidth = (paintAreaWidth / 2) - marginOffsetHalf,
	imageHeight = (paintAreaHeight / 2) - marginOffsetHalf,
	page = 0,
	lastPage = false,
	imagePerPage = 4
}

local loadImagePanel = {
	isActive = false,
	browserElement = createBrowser(screenW, screenH, true, true),
	resized = false,
	playerCanDownload = true,
	tryToDownloadTick = 0,
	downloadingDotsTick = 0
}

local panelMenu = {
	{"Új", tocolor(r, g, b), "new"},
	{"Vissza", tocolor(61, 146, 191, 230), "undo"},
	{"Előre", tocolor(61, 146, 191, 230), "redo"},
	{"Mentés", tocolor(89, 171, 87), "save"},
	{"Színválasztás", tocolor(201, 191, 95, 230), "palette", false,
		activeWhen = function()
			if colorData.isActive then
				return true
			end
		end
	},
	{"Vastagság állítás", tocolor(91, 189, 138, 230), "brushsize", false,
		activeWhen = function()
			if brushData.isActive then
				return true
			end
		end
	},
	{"Mentett graffitik", tocolor(139, 132, 240), "savedgraffitis", 10,
		activeWhen = function()
			if savedGraffitisMenu.isActive then
				return true
			end
		end
	},
	{"Kép feltöltése URL-alapján", tocolor(150, 220, 242), "url_image", 11,
		activeWhen = function()
			if loadImagePanel.isActive then
				return true
			end
		end
	}
}

local recentlyUsedColors = {
	tocolor(0, 0, 0),
	tocolor(255, 255, 255),
	tocolor(215, 89, 89),
	tocolor(208, 89, 215),
	tocolor(166, 89, 215),
	tocolor(89, 98, 215),
	tocolor(89, 184, 215),
	tocolor(89, 215, 202),
	tocolor(89, 215, 119),
	tocolor(157, 215, 89),
	tocolor(214, 215, 89),
	tocolor(215, 154, 89),
}

local settingsTable = {
	savedGraffitisPath = "savedGraffitis.json",
	savedGraffitisFolder = "files/saved_graffitis/",
	serverGraffitisPath = "serverGraffitisCache.json",
	serverGraffitisFolder = "files/server_graffitis/"
}

local savedGraffitis = {}
local serverGraffitis = {}
local loadedGraffitiTextures = {}
local loadedGraffitis = {}

local emptyPixels = false
local lastDrawedPixels = false
local pixelsBeforeSpray = false
local drawingSteps = {}
local currentStep = 1

local streamedGraffitis = {}
local graffitisVisibleDistance = 100
local graffitiThread = false
local graffitiSize = 2

local startedGraffiti = {
	isActive = false,
	actionDisabled = false,
	value = 0,
	texture = false,
	data = false
}

local tryToSprayGraffitiTick = 0
local nextSprayingAfterTick = 0

local progressbarWidth, progressbarHeight = 350, 25 -- spraying, cleaning graffiti progressbar
local progressbarPosX, progressbarPosY = (screenW - progressbarWidth) / 2, screenH - progressbarHeight * 2 -- spraying, cleaning graffiti progressbar

local cleaningGraffitiTimer = false
local graffitiCleanTime = 15000 -- milliseconds, this used in SERVER SIDE to -> graffitiCleanAnimation event

local adminMode = false
local graffitiCleanMode = false

local selectedButton = false
local selected3DButton = false

local promptDialog = {
	isActive = false,
	text = "",
	value = false
}

addEventHandler("onClientResourceStart", root, function(res)
    if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oChat" or getResourceName(res) == "oAdmin" or getResourceName(res) == "oInventory" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oDashboard" then  
		core = exports.oCore;
		color, r, g, b = core:getServerColor();
		font = exports.oFont;
		chat = exports.oChat;
		admin = exports.oAdmin;
		inventory = exports.oInventory;
		infobox = exports.oInfobox;
		faction = exports.oDashboard;
    end
end)

addCommandHandler("graffiti",
	function ()
		local aLevel = getElementData(localPlayer,"user:admin")
		if aLevel >= 2 or faction:isPlayerFactionTypeMember({3,4}) then 
			showTheEditor()
			setElementData(localPlayer,"toggleInterface",true)
		end 
	end
)

addCommandHandler("nearbygraffitis",
	function ()
		local aLevel = getElementData(localPlayer,"user:admin")
		if aLevel >= 2 then 

			if adminMode then 
				adminMode = false 
			else 
				adminMode = true 
				outputChatBox(color.."[Graffiti]: #ffffffKözeledben lévő graffitik megjelenítve!", 255, 255, 255, true)
			end 

		end 
	end
)

addEventHandler("onClientBrowserCreated", getRootElement(),
	function ()
		if source == loadImagePanel.browserElement then
			loadBrowserURL(loadImagePanel.browserElement, "http://mta/local/files/imageURL.html")
		end
	end
)

addEventHandler("onClientBrowserDocumentReady", getRootElement(),
	function ()
		if source == loadImagePanel.browserElement then
			executeBrowserJavascript(loadImagePanel.browserElement, "document.getElementById(\"main\").style.left=\"" .. paintAreaPosX .. "px\"; document.getElementById(\"main\").style.top=\"" .. paintAreaPosY .. "px\"; document.getElementById(\"main\").style.width=\"" .. paintAreaWidth .. "px\"; document.getElementById(\"main\").style.height=\"" .. paintAreaHeight .. "px\"; changeTheme(\"" .. panelTheme .. "\");")
			setTimer(
				function()
					loadImagePanel.resized = true
					focusBrowser(loadImagePanel.browserElement)
				end, 2000, 1
			)
		end
	end
)

addEventHandler("onClientCursorMove", getRootElement(),
	function (relativeX, relativeY, absoluteX, absoluteY)
		if drawingSurface and loadImagePanel.isActive and loadImagePanel.browserElement and not isBrowserLoading(loadImagePanel.browserElement) then
			injectBrowserMouseMove(loadImagePanel.browserElement, absoluteX, absoluteY)
			
			if guiGetInputMode() ~= "no_binds" then
				guiSetInputMode("no_binds")
			end
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if drawingSurface and loadImagePanel.isActive and loadImagePanel.browserElement and not isBrowserLoading(loadImagePanel.browserElement) and loadImagePanel.playerCanDownload then
			if state == "down" then
				injectBrowserMouseDown(loadImagePanel.browserElement, button)
			else
				injectBrowserMouseUp(loadImagePanel.browserElement, button)
			end
			
			if guiGetInputMode() ~= "no_binds" then
				guiSetInputMode("no_binds")
			end
		end
	end
)

addEvent("onClientTryToDownloadImage", true)
addEventHandler("onClientTryToDownloadImage", getResourceRootElement(),
	function (path)
		if drawingSurface then
			if loadImagePanel.playerCanDownload then
				local deltaTime = getTickCount() - loadImagePanel.tryToDownloadTick
				
				if deltaTime >= 3000 then
					if utf8.len(path) > 0 then
						local fileExtension = string.match(path, "^.+(%..+)$")
						
						if fileExtension and fileExtension == ".png" or fileExtension == ".jpg" or fileExtension == ".jpeg" or fileExtension == ".bmp" then
							triggerServerEvent("onTryToDownloadClientImage", localPlayer, path)
							loadImagePanel.playerCanDownload = false
							outputChatBox(color.."[Graffiti]: #ffffffA letöltés megkezdődött kérlek várj!", 255, 255, 255, true)
						else
							outputChatBox(color.."[Graffiti]: #ffffffA megadott link nem megfelelő!", 255, 255, 255, true)
						end
					else
						outputChatBox(color.."[Graffiti]: #ffffffElőször illeszd be az URL-linket!", 255, 255, 255, true)
					end
				else
					outputChatBox(color.."[Graffiti]: #ffffffVárnod kell "..color.. 3 - math.floor(deltaTime / 1000) .. " másodpercet#ffffff a következő letöltésig.", 255, 255, 255, true)
				end
			else
				outputChatBox(color.."[Graffiti]: #ffffffEgy letöltés már folyamatban van!", 255, 255, 255, true)
			end
		end
	end
)

addEvent("onClientReceiveDownloadedImage", true)
addEventHandler("onClientReceiveDownloadedImage", getRootElement(),
	function (imagePixels, errno)
		if errno == 0 then
			local fileName = getRealTime().timestamp
			local savedGraffiti = fileCreate(settingsTable.savedGraffitisFolder .. fileName .. ".png")
			
			if savedGraffiti then
				local theImage = dxCreateTexture(dxConvertPixels(imagePixels, "png"))
				local originalWidth, originalHeight = dxGetMaterialSize(theImage)
				local fitWidth, fitHeight = fitImageSize(originalWidth, originalHeight, paintAreaWidth, paintAreaHeight)
				local tempRenderTarget = dxCreateRenderTarget(paintAreaWidth, paintAreaHeight, true)
				
				dxSetRenderTarget(tempRenderTarget)
				dxSetBlendMode("modulate_add")
				dxDrawImage((paintAreaWidth - fitWidth) / 2, (paintAreaHeight - fitHeight) / 2, fitWidth, fitHeight, theImage)
				dxSetBlendMode("blend")
				dxSetRenderTarget()
				
				fileWrite(savedGraffiti, dxConvertPixels(dxGetTexturePixels(tempRenderTarget), "png"))
				fileClose(savedGraffiti)
				
				table.insert(savedGraffitis, fileName)
				rebuildSavedGraffitis()
				
				destroyElement(tempRenderTarget)
				destroyElement(theImage)
			end
			
			outputChatBox(color.."[Graffiti]: #ffffffA kiválasztott kép elmentve, megtalálhatod a 'Mentett graffitik' között.", 255, 255, 255, true)
		else
			outputChatBox(color.."#e56b6b[Graffiti]: #ffffffEz a kép nem elérhető!", 255, 255, 255, true)
		end
		
		loadImagePanel.playerCanDownload = true
		loadImagePanel.tryToDownloadTick = getTickCount()
	end
)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		guiSetInputMode("allow_binds")
		
		if fileExists(settingsTable.savedGraffitisPath) then
			local loadedGraffitis = fileOpen(settingsTable.savedGraffitisPath)
			if loadedGraffitis then
				savedGraffitis = fromJSON(fileRead(loadedGraffitis, fileGetSize(loadedGraffitis))) or {}
				fileClose(loadedGraffitis)
				
				table.sort(savedGraffitis,
					function (a, b)
						return a > b
					end
				)
			end
		end
		
		if fileExists(settingsTable.serverGraffitisPath) then
			local loadedGraffitis = fileOpen(settingsTable.serverGraffitisPath)
			if loadedGraffitis then
				serverGraffitis = fromJSON(fileRead(loadedGraffitis, fileGetSize(loadedGraffitis))) or {}
				fileClose(loadedGraffitis)
			end
		end
		
		for fileName, data in pairs(serverGraffitis) do
			if fileExists(settingsTable.serverGraffitisFolder .. fileName .. ".png") then
				loadedGraffitiTextures[fileName] = dxCreateTexture(settingsTable.serverGraffitisFolder .. fileName .. ".png", "dxt3")
			end
		end
		
		graffitiThread = coroutine.create(streamGraffitis)
		setTimer(triggerServerEvent, 1000, 1, "requestGraffitiList", localPlayer)
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if fileExists(settingsTable.savedGraffitisPath) then
			fileDelete(settingsTable.savedGraffitisPath)
		end
		
		if fileExists(settingsTable.serverGraffitisPath) then
			fileDelete(settingsTable.serverGraffitisPath)
		end
		
		local savedGraffitisFile = fileCreate(settingsTable.savedGraffitisPath)
		if savedGraffitisFile then
			fileWrite(savedGraffitisFile, toJSON(savedGraffitis))
			fileClose(savedGraffitisFile)
		end
		
		local serverGraffitisFile = fileCreate(settingsTable.serverGraffitisPath)
		if serverGraffitisFile then
			fileWrite(serverGraffitisFile, toJSON(serverGraffitis))
			fileClose(serverGraffitisFile)
		end
	end
)

addEventHandler("onClientMinimize", getRootElement(),
	function ()
		if drawingSurface and isElement(drawingSurface) then
			lastDrawedPixels = dxGetTexturePixels(drawingSurface)
		end
	end
)
addEventHandler("onClientRestore", getRootElement(),
	function (didClearRenderTargets)
		if didClearRenderTargets and drawingSurface and isElement(drawingSurface) and lastDrawedPixels then
			dxSetTexturePixels(drawingSurface, lastDrawedPixels)
		end
	end
)

addEvent("receiveGraffitiList", true)
addEventHandler("receiveGraffitiList", getRootElement(),
	function (graffitis)
		if graffitis then
			local requestGraffitis = {}
			
			for fileName in pairs(graffitis) do
				if not loadedGraffitiTextures[fileName] and not fileExists(settingsTable.serverGraffitisFolder .. fileName .. ".png") then
					table.insert(requestGraffitis, fileName)
				else
					loadedGraffitis[fileName] = graffitis[fileName]
				end
				
				if not serverGraffitis[fileName] then
					if fileExists(settingsTable.serverGraffitisFolder .. fileName .. ".png") then
						fileDelete(settingsTable.serverGraffitisFolder .. fileName .. ".png")
					end
					
					if isElement(loadedGraffitiTextures[fileName]) then
						destroyElement(loadedGraffitiTextures[fileName])
					end
					
					loadedGraffitis[fileName] = nil
					loadedGraffitiTextures[fileName] = nil
				end
			end
			
			if #requestGraffitis >= 1 then
				triggerServerEvent("requestGraffitis", localPlayer, requestGraffitis)
			end
			
			serverGraffitis = graffitis
		end
	end
)

addEvent("receiveGraffitis", true)
addEventHandler("receiveGraffitis", getRootElement(),
	function (data)
		if data then
			for i = 1, #data do
				local fileName = data[i][1]
				local graffitiFile = fileCreate(settingsTable.serverGraffitisFolder .. fileName .. ".png")
				
				if graffitiFile then
					fileWrite(graffitiFile, data[i][2])
					fileClose(graffitiFile)
					
					loadedGraffitis[fileName] = serverGraffitis[fileName]
					loadedGraffitiTextures[fileName] = dxCreateTexture(settingsTable.serverGraffitisFolder .. fileName .. ".png", "dxt3")
				end
			end
		end
	end
)

addEvent("createGraffiti", true)
addEventHandler("createGraffiti", getRootElement(),
	function (fromClient, pixels, data)
		local fileName = data.fileName
		local graffitiFile = fileCreate(settingsTable.serverGraffitisFolder .. fileName .. ".png")
		
		if graffitiFile then
			fileWrite(graffitiFile, pixels)
			fileClose(graffitiFile)
			
			serverGraffitis[fileName] = data
			loadedGraffitis[fileName] = data
			loadedGraffitiTextures[fileName] = dxCreateTexture(settingsTable.serverGraffitisFolder .. fileName .. ".png", "dxt3")
			
			if fromClient == localPlayer then
				nextSprayingAfterTick = getTickCount() + 2000
				
				startedGraffiti.actionDisabled = false
				startedGraffiti.isActive = false
				if isElement(startedGraffiti.texture) then
					destroyElement(startedGraffiti.texture)
				end
				startedGraffiti.texture = nil
				startedGraffiti.data = nil
				startedGraffiti.value = 0
				
				outputChatBox(color.."[Graffiti]: #ffffffGraffiti sikeresen felfújva.", 255, 255, 255, true)
			end
		end
	end
)

--[[addEvent("protectGraffiti", true)
addEventHandler("protectGraffiti", getRootElement(),
	function (fileName, state)
		if serverGraffitis[fileName] then
			serverGraffitis[fileName].isProtected = state
			loadedGraffitis[fileName].isProtected = state
		end
	end
)]]

addEvent("deleteGraffiti", true)
addEventHandler("deleteGraffiti", getRootElement(),
	function (fileName)
		if serverGraffitis[fileName] then
			serverGraffitis[fileName] = nil
			loadedGraffitis[fileName] = nil
			
			if streamedGraffitis[fileName] then
				streamedGraffitis[fileName] = nil
			end
			
			if loadedGraffitiTextures[fileName] then
				if isElement(loadedGraffitiTextures[fileName]) then
					destroyElement(loadedGraffitiTextures[fileName])
				end
				loadedGraffitiTextures[fileName] = nil
			end
			
			if fileExists(settingsTable.serverGraffitisFolder .. fileName .. ".png") then
				fileDelete(settingsTable.serverGraffitisFolder .. fileName .. ".png")
			end
		end
	end
)

addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(),
	function (weapon, _, _, hitX, hitY, hitZ)
		if weapon ~= 41 then
			return
		end
		
		if lastDrawedPixels and not startedGraffiti.isActive and not startedGraffiti.actionDisabled and #drawingSteps >= 2 and getTickCount() >= nextSprayingAfterTick then
			if getTickCount() >= tryToSprayGraffitiTick then
				--!! Math, calculations thanks to CrystalMV !!--
				local elbowX, elbowY, elbowZ = getPedBonePosition(source, 23)
				hitX, hitY, hitZ = hitX - elbowX, hitY - elbowY, hitZ - elbowZ
				local hitDistance = 2 / math.sqrt(hitX * hitX + hitY * hitY + hitZ * hitZ)
				hitX, hitY, hitZ = hitX * hitDistance, hitY * hitDistance, hitZ * hitDistance
				
				local hit, x0, y0, z0, hitElement, normalX, normalY, normalZ = processLineOfSight(elbowX, elbowY, elbowZ, elbowX + hitX, elbowY + hitY, elbowZ + hitZ, true, false, false, true, false, false, false, false)
				if not hit then
					return
				end
			
				local xx, xy, xz, yx, yy, yz
				do
					local x1, y1, z1 = getWorldFromScreenPosition(screenW * 0.5, screenH * 0.5, 1)
					local x2, y2, z2 = getWorldFromScreenPosition(screenW * 0.5, 0, 1)
					x2, y2, z2 = x2 - x1, y2 - y1, z2 - z1
					
					xx, xy, xz = normalY * z2 - normalZ * y2, normalZ * x2 - normalX * z2, normalX * y2 - normalY * x2
					yx, yy, yz = xy * normalZ - xz * normalY, xz * normalX - xx * normalZ, xx * normalY - xy * normalX
				end
				
				local xLength = graffitiSize * 0.5 / math.sqrt(xx * xx + xy * xy + xz * xz)
				local yLength = graffitiSize * 0.5 / math.sqrt(yx * yx + yy * yy + yz * yz)
				xx, xy, xz = xx * xLength, xy * xLength, xz * xLength
				yx, yy, yz = yx * yLength, yy * yLength, yz * yLength

				local cx, cy, cz = x0 + normalX, y0 + normalY, z0 + normalZ
				local bx, by, bz = x0 - normalX * 0.01, y0 - normalY * 0.01, z0 - normalZ * 0.01
				local col, x, y, z, hit
				
				col, x, y, z, hit = processLineOfSight(cx, cy, cz, bx + xx + yx, by + xy + yy, bz + xz + yz, true, true, false, true, false, false, false, false) if not col or hit ~= hitElement then return end
				col, x, y, z, hit = processLineOfSight(cx, cy, cz, bx + xx - yx, by + xy - yy, bz + xz - yz, true, true, false, true, false, false, false, false) if not col or hit ~= hitElement then return end
				col, x, y, z, hit = processLineOfSight(cx, cy, cz, bx - xx + yx, by - xy + yy, bz - xz + yz, true, true, false, true, false, false, false, false) if not col or hit ~= hitElement then return end
				col, x, y, z, hit = processLineOfSight(cx, cy, cz, bx - xx - yx, by - xy - yy, bz - xz - yz, true, true, false, true, false, false, false, false) if not col or hit ~= hitElement then return end
				
				local fx, fy, fz = x0 + normalX * 0.01, y0 + normalY * 0.01, z0 + normalZ * 0.01
				if not isLineOfSightClear(cx, cy, cz, fx + xx + yx, fy + xy + yy, fz + xz + yz, true, true, false, true, false, true, false) then return end
				if not isLineOfSightClear(cx, cy, cz, fx + xx - yx, fy + xy - yy, fz + xz - yz, true, true, false, true, false, true, false) then return end
				if not isLineOfSightClear(cx, cy, cz, fx - xx + yx, fy - xy + yy, fz - xz + yz, true, true, false, true, false, true, false) then return end
				if not isLineOfSightClear(cx, cy, cz, fx - xx - yx, fy - xy - yy, fz - xz - yz, true, true, false, true, false, true, false) then return end
				
				local zLength = 1 / math.sqrt(normalX * normalX + normalY * normalY + normalZ * normalZ)
				normalX, normalY, normalZ = normalX * zLength, normalY * zLength, normalZ * zLength

				local x1, y1, z1 = x0 + normalX * 0.01 + yx, y0 + normalY * 0.01 + yy, z0 + normalZ * 0.01 + yz
				local x2, y2, z2 = x0 + normalX * 0.04 - yx, y0 + normalY * 0.04 - yy, z0 + normalZ * 0.04 - yz
				
				tryToSprayGraffitiTick = getTickCount() + 1000
				startedGraffiti.isActive = true
				startedGraffiti.texture = dxCreateTexture(lastDrawedPixels)
				startedGraffiti.data = {x1, y1, z1, x2, y2, z2, x1 + normalX, y1 + normalY, z1 + normalZ, x0, y0, z0, graffitiSize + 2, getElementInterior(localPlayer), getElementDimension(localPlayer)}
				
				outputChatBox(color.."[Graffiti]: #ffffffElkezdet felfújni a graffitit a falra, tartsd nyomva az egered amíg az el nem éri végleges méretét!", 255, 255, 255, true)
			end
		elseif startedGraffiti.isActive and startedGraffiti.texture and startedGraffiti.data and not startedGraffiti.actionDisabled then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local playerInterior, playerDimension = getElementInterior(localPlayer), getElementDimension(localPlayer)
			
			if playerInterior == startedGraffiti.data[14] and playerDimension == startedGraffiti.data[15] then
				if getDistanceBetweenPoints3D(playerX, playerY, playerZ, startedGraffiti.data[10], startedGraffiti.data[11], startedGraffiti.data[12]) <= 3 then
					if startedGraffiti.value < 100 then
						startedGraffiti.value = startedGraffiti.value + 0.75
					else
						startedGraffiti.actionDisabled = true
						startedGraffiti.isActive = false
						nextSprayingAfterTick = math.huge
						
						triggerServerEvent("createGraffiti", localPlayer, lastDrawedPixels, {
							x1 = startedGraffiti.data[1],
							y1 = startedGraffiti.data[2],
							z1 = startedGraffiti.data[3],
							x2 = startedGraffiti.data[4],
							y2 = startedGraffiti.data[5],
							z2 = startedGraffiti.data[6],
							x3 = startedGraffiti.data[7],
							y3 = startedGraffiti.data[8],
							z3 = startedGraffiti.data[9],
							cx = startedGraffiti.data[10],
							cy = startedGraffiti.data[11],
							cz = startedGraffiti.data[12],
							size = startedGraffiti.data[13],
							interior = startedGraffiti.data[14],
							dimension = startedGraffiti.data[15],
							isProtected = false,
						})
					end
				end
			end
		end
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if drawingSurface then
			return
		end
		
		local cursorX, cursorY = 0, 0
		if isCursorShowing() then
			local relX, relY = getCursorPosition()
			cursorX, cursorY = relX * screenW, relY * screenH
		end
		
		if selected3DButton then
			selected3DButton = false
		end
		
		if faction:isPlayerFactionTypeMember({1}) then 
			local cameraX, cameraY, cameraZ = getCameraMatrix()
			local playerInterior, playerDimension = getElementInterior(localPlayer), getElementDimension(localPlayer)
			
			for k in pairs(streamedGraffitis) do
				if loadedGraffitis[k] and loadedGraffitiTextures[loadedGraffitis[k].fileName] then
					if loadedGraffitis[k].interior == playerInterior and loadedGraffitis[k].dimension == playerDimension then
						local screenX, screenY = getScreenFromWorldPosition(loadedGraffitis[k].cx, loadedGraffitis[k].cy, loadedGraffitis[k].cz, 0, false)
						
						if screenX and screenY then
							local distanceBetweenGraffiti = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, loadedGraffitis[k].cx, loadedGraffitis[k].cy, loadedGraffitis[k].cz)
							
							if distanceBetweenGraffiti <= 15 then
								local deltaDistance = distanceBetweenGraffiti / 30
								local distanceMultiplier = interpolateBetween(1, 0, 0, 0, 0, 0, deltaDistance, "OutQuad")
								local alphaMultiplier = interpolateBetween(255, 0, 0, 0, 0, 0, deltaDistance, "Linear")
								
								local iconSize = 64 * distanceMultiplier
								local iconPosX, iconPosY = screenX - (iconSize / 2), screenY - (iconSize / 2)
								
								dxDrawImage(iconPosX + 1, iconPosY + 1, iconSize + 1, iconSize + 1, "files/images/clean.png", 0, 0, 0, tocolor(0, 0, 0, alphaMultiplier))
								if isCursorWithinArea(cursorX, cursorY, iconPosX, iconPosY, iconSize, iconSize) then
									dxDrawImage(iconPosX, iconPosY, iconSize, iconSize, "files/images/clean.png", 0, 0, 0, tocolor(21, 219, 114, alphaMultiplier))
									selected3DButton = "clean|" .. k
								else
									dxDrawImage(iconPosX, iconPosY, iconSize, iconSize, "files/images/clean.png", 0, 0, 0, tocolor(50, 179, 239, alphaMultiplier))
								end
							end
						end
					end
				end
			end
		elseif adminMode then
			local cameraX, cameraY, cameraZ = getCameraMatrix()
			local playerInterior, playerDimension = getElementInterior(localPlayer), getElementDimension(localPlayer)
			
			for k in pairs(streamedGraffitis) do
				if loadedGraffitis[k] and loadedGraffitiTextures[k] then
					if loadedGraffitis[k].interior == playerInterior and loadedGraffitis[k].dimension == playerDimension then
						local screenX, screenY = getScreenFromWorldPosition(loadedGraffitis[k].cx, loadedGraffitis[k].cy, loadedGraffitis[k].cz + 0.35, 0, false)
						
						if screenX and screenY then
							local distanceBetweenGraffiti = getDistanceBetweenPoints3D(cameraX, cameraY, cameraZ, loadedGraffitis[k].cx, loadedGraffitis[k].cy, loadedGraffitis[k].cz)
							
							if distanceBetweenGraffiti <= 15 then
								local deltaDistance = distanceBetweenGraffiti / 30
								local distanceMultiplier = interpolateBetween(1, 0, 0, 0, 0, 0, deltaDistance, "OutQuad")
								local alphaMultiplier = interpolateBetween(255, 0, 0, 0, 0, 0, deltaDistance, "Linear")
								local fontScale = 1 * distanceMultiplier
								local nameSplit = split(k, "-")
								
								local drawedTimestamp = getRealTime(tonumber(nameSplit[1]))
								local drawedTime = string.format("%.4i/%.2i/%.2i %.2i:%.2i:%.2i", drawedTimestamp.year + 1900, drawedTimestamp.month + 1, drawedTimestamp.monthday, drawedTimestamp.hour, drawedTimestamp.minute, drawedTimestamp.second)
								
								local labelText = "Létrehozta: "..color..nameSplit[2] .. "\n" .. "#ffffffDátum: "..color.. drawedTime
								local labelWidth, labelHeight = dxGetTextWidth(labelText, fontScale, mainFont, true), mainFontHeight * distanceMultiplier
								local labelPosX, labelPosY = screenX - (labelWidth / 2), screenY - ((labelHeight * distanceMultiplier) / 2)
								
								dxDrawText(string.gsub(labelText, "#%x%x%x%x%x%x", ""), labelPosX + 1, labelPosY + 1, labelPosX + labelWidth + 1, labelPosY + labelHeight + 1, tocolor(0, 0, 0, alphaMultiplier), fontScale, mainFont, "center", "center", false, false, false, true, true)
								dxDrawText(labelText, labelPosX, labelPosY, labelPosX + labelWidth, labelPosY + labelHeight, tocolor(255, 255, 255, alphaMultiplier), fontScale, mainFont, "center", "center", false, false, false, true, true)
							
								local iconSize = 64 * distanceMultiplier
								local iconPosX, iconPosY = screenX - ((iconSize * 2) / 2) + menuSize / 2.5, (labelPosY + labelHeight) + (iconSize / 2) - marginOffset
								
								dxDrawImageSection(iconPosX + 1, iconPosY + 1, iconSize + 1, iconSize + 1, 0, 32 * 8, 32, 32, "files/images/icons.png", 0, 0, 0, tocolor(0, 0, 0, alphaMultiplier))
								if isCursorWithinArea(cursorX, cursorY, iconPosX, iconPosY, iconSize, iconSize) then
									dxDrawImageSection(iconPosX, iconPosY, iconSize, iconSize, 0, 32 * 8, 32, 32, "files/images/icons.png", 0, 0, 0, tocolor(21, 219, 114, alphaMultiplier))
									selected3DButton = "trash|" .. k
								else
									dxDrawImageSection(iconPosX, iconPosY, iconSize, iconSize, 0, 32 * 8, 32, 32, "files/images/icons.png", 0, 0, 0, tocolor(212, 0, 40, alphaMultiplier))
								end
								
								local iconPosX = iconPosX + iconSize
								--[[dxDrawImage(iconPosX + 1, iconPosY + 1, iconSize + 1, iconSize + 1, "files/images/protect.png", 0, 0, 0, tocolor(0, 0, 0, alphaMultiplier))
								if isCursorWithinArea(cursorX, cursorY, iconPosX, iconPosY, iconSize, iconSize) then
									dxDrawImage(iconPosX, iconPosY, iconSize, iconSize, "files/images/protect.png", 0, 0, 0, tocolor(21, 219, 114, alphaMultiplier))
									selected3DButton = "protect|" .. k
								else
									dxDrawImage(iconPosX, iconPosY, iconSize, iconSize, "files/images/protect.png", 0, 0, 0, tocolor(175, 175, 175, alphaMultiplier))
								end]]
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if adminMode or faction:isPlayerFactionTypeMember({1}) then
			if selected3DButton then
				if button == "left" and state == "up" then
					if string.find(selected3DButton, "trash|") then
						local fileName = string.gsub(selected3DButton, "trash|", "")
						
						if serverGraffitis[fileName].isProtected then
							outputChatBox(color.."[Graffiti]: #ffffffEz egy védett graffiti, nem törölheted le!.", 255, 255, 255, true)
							return
						end
						
						triggerServerEvent("deleteGraffiti", localPlayer, fileName)

					elseif string.find(selected3DButton, "protect|") then
						triggerServerEvent("protectGraffiti", localPlayer, string.gsub(selected3DButton, "protect|", ""))
					elseif string.find(selected3DButton, "clean|") then
						local fileName = string.gsub(selected3DButton, "clean|", "")
						
						if not getPedOccupiedVehicle(localPlayer) then
							if not isTimer(cleaningGraffitiTimer) then
								if serverGraffitis[fileName].isProtected then
									outputChatBox(color.."[Graffiti]: #ffffffEz egy védett graffiti, nem takaríthatod le!.", 255, 255, 255, true)
									return
								end
								

								cleanGraffiti(fileName)
							else
								outputChatBox(color.."[Graffiti]: #ffffffMár van egy takarítási folyamatod elkezdve.", 255, 255, 255, true)
							end
						else
							outputChatBox(color.."[Graffiti]: #ffffffJárműböl űlve nem lehet.", 255, 255, 255, true)
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientPreRender", getRootElement(),
	function ()
		coroutine.resume(graffitiThread)
		
		local playerInterior, playerDimension = getElementInterior(localPlayer), getElementDimension(localPlayer)
		
		for k in pairs(streamedGraffitis) do
			if loadedGraffitis[k] and loadedGraffitiTextures[loadedGraffitis[k].fileName] then
				if loadedGraffitis[k].interior == playerInterior and loadedGraffitis[k].dimension == playerDimension then
					dxDrawMaterialLine3D(loadedGraffitis[k].x1, loadedGraffitis[k].y1, loadedGraffitis[k].z1, loadedGraffitis[k].x2, loadedGraffitis[k].y2, loadedGraffitis[k].z2, loadedGraffitiTextures[loadedGraffitis[k].fileName], loadedGraffitis[k].size, -1, loadedGraffitis[k].x3, loadedGraffitis[k].y3, loadedGraffitis[k].z3)
				end
			end
		end
		
		if startedGraffiti.isActive and startedGraffiti.texture and startedGraffiti.data then
			if playerInterior == startedGraffiti.data[14] and playerDimension == startedGraffiti.data[15] then
				dxDrawMaterialLine3D(startedGraffiti.data[1], startedGraffiti.data[2], startedGraffiti.data[3], reMap(startedGraffiti.value, 0, 100, startedGraffiti.data[1], startedGraffiti.data[4]), reMap(startedGraffiti.value, 0, 100, startedGraffiti.data[2], startedGraffiti.data[5]), reMap(startedGraffiti.value, 0, 100, startedGraffiti.data[3], startedGraffiti.data[6]), startedGraffiti.texture, reMap(startedGraffiti.value, 0, 100, 0, startedGraffiti.data[13]), -1, startedGraffiti.data[7], startedGraffiti.data[8], startedGraffiti.data[9])
				
				--[[local playerX, playerY, playerZ = getElementPosition(localPlayer)
				if getDistanceBetweenPoints3D(playerX, playerY, playerZ, startedGraffiti.data[10], startedGraffiti.data[11], startedGraffiti.data[12]) <= 3 then
					dxDrawRectangle(progressbarPosX - 2, progressbarPosY - 2, progressbarWidth + 4, progressbarHeight + 4, tocolor(0, 0, 0, 160))
					dxDrawRectangle(progressbarPosX, progressbarPosY, reMap(startedGraffiti.value, 0, 100, 0, progressbarWidth), progressbarHeight, tocolor(50, 239, 125, 220))
					dxDrawText("Spraying:", progressbarPosX, progressbarPosY - progressbarHeight - 20, progressbarPosX + progressbarWidth, progressbarPosY + progressbarHeight, tocolor(255, 255, 255), 0.75, mainFont, "left", "center")
					dxDrawText(math.floor(startedGraffiti.value) .. "%", progressbarPosX, progressbarPosY, progressbarPosX + math.max(40, (progressbarWidth - 10) * startedGraffiti.value / 100), progressbarPosY + progressbarHeight, tocolor(255, 255, 255), 0.75, mainFont, "right", "center")
				end]]
			end
		end
		
		--[[if cleaningGraffitiTimer then
			local barValue = reMap(graffitiCleanTime - getTimerDetails(cleaningGraffitiTimer), 0, graffitiCleanTime, 0, 100)
			dxDrawRectangle(progressbarPosX - 2, progressbarPosY - 2, progressbarWidth + 4, progressbarHeight + 4, tocolor(0, 0, 0, 160))
			dxDrawRectangle(progressbarPosX, progressbarPosY, progressbarWidth * barValue / 100, progressbarHeight, tocolor(50, 179, 239, 220))
			dxDrawText("Cleaning:", progressbarPosX, progressbarPosY - progressbarHeight - 20, progressbarPosX + progressbarWidth, progressbarPosY + progressbarHeight, tocolor(255, 255, 255), 0.75, mainFont, "left", "center")
			dxDrawText(math.floor(barValue) .. "%", progressbarPosX, progressbarPosY, progressbarPosX + math.max(40, (progressbarWidth - 10) * barValue / 100), progressbarPosY + progressbarHeight, tocolor(255, 255, 255), 0.75, mainFont, "right", "center")
		end]]
	end
)

function cleanGraffiti(fileName)
	if inventory:hasItem(144) then 
		if inventory:hasItem(145) then 
			setElementFrozen(localPlayer, true)
			triggerServerEvent("graffitiCleanAnimation", localPlayer)
			chat:sendLocalMeAction("előveszi a nála lévő takarítószert és törlőkendőt majd rá spriccel vele.")

			setTimer(function()
				chat:sendLocalDoAction("Spricc-Spricc.")
				setTimer(function()
					chat:sendLocalMeAction("elkezdi körkörös mozdulatokkal letakarítani a falra fújt festéket.")
					setTimer(function()
						chat:sendLocalDoAction("a festék szépen lassan kopik le.")
						setTimer(function()
							chat:sendLocalMeAction("hosszas sikálás után a festék lejött a falról.")
							setTimer(function()
								chat:sendLocalDoAction("a falon már nem látható a festék.")
								triggerServerEvent("deleteGraffiti", localPlayer, fileName)

								setTimer(function()
									inventory:takeItem(144)
									setElementFrozen(localPlayer, false)
									if isTimer(cleaningGraffitiTimer) then
										killTimer(cleaningGraffitiTimer)
									end

									outputChatBox(core:getServerPrefix('server', 'Graffiti', 3).."Sikeresen letakarítottad a graffitit, a törlőkendőd viszont elhasználódott!", 255, 255, 255, true)

								end,3000,1)
								
							end,5000,1)
						end,15000,1)
					end,5000,1)
				end,5000,1)
			end,3000,1)

		else
			outputChatBox(core:getServerPrefix('red-dark', 'Graffiti', 3).."Nincs nálad a takarításhoz szükséges takarítószer.", 255, 255, 255, true)
		end 
	else 
		outputChatBox(core:getServerPrefix('red-dark', 'Graffiti', 3).."Nincs nálad a takarításhoz szükséges törlőrongy.", 255, 255, 255, true)
	end 
end

function streamGraffitis()
	while true do
		local cameraX, cameraY, cameraZ = getCameraMatrix()
		local processedThreads = 0
		
		for _, v in pairs(serverGraffitis) do
			local x, y, z = v.x1 - cameraX, v.y1 - cameraY, v.z1 - cameraZ
			local graffitiDistance = x * x + y * y + z * z
			local graffitiVisibility = v.size * graffitisVisibleDistance
			graffitiVisibility = graffitiVisibility * graffitiVisibility
			
			if streamedGraffitis[v.fileName] then
				if graffitiDistance > graffitiVisibility then
					streamedGraffitis[v.fileName] = nil
				end
			elseif graffitiDistance <= graffitiVisibility then
				streamedGraffitis[v.fileName] = true
			end
			
			processedThreads = processedThreads + 1
			if processedThreads == 64 then
				coroutine.yield()
				processedThreads = 0
				cameraX, cameraY, cameraZ = getCameraMatrix()
			end
		end
		
		coroutine.yield()
	end
end

function showTheEditor()
	if isEventHandlerAdded("onClientRender", getRootElement(), renderTheEditor) then
		removeEventHandler("onClientClick", getRootElement(), processTheEditorButtons)
		removeEventHandler("onClientRender", getRootElement(), renderTheEditor)
		removeEventHandler("onClientCharacter", getRootElement(), colorInputInsert)
		removeEventHandler("onClientKey", getRootElement(), processEditorKeys)
		
		if isElement(drawingSurface) then
			destroyElement(drawingSurface)
		end
		drawingSurface = nil
		
	else
		if not drawingSurface or not isElement(drawingSurface) then
			drawingSurface = dxCreateRenderTarget(paintAreaWidth, paintAreaHeight, true)
		
			if not emptyPixels then
				emptyPixels = dxGetTexturePixels(drawingSurface)
				table.insert(drawingSteps, 1, emptyPixels)
			end
			
			if pixelsBeforeSpray then
				dxSetTexturePixels(drawingSurface, pixelsBeforeSpray)
				pixelsBeforeSpray = false
			elseif drawingSteps[currentStep] then
				dxSetTexturePixels(drawingSurface, drawingSteps[currentStep])
			end
		end
		
		addEventHandler("onClientRender", getRootElement(), renderTheEditor)
		addEventHandler("onClientClick", getRootElement(), processTheEditorButtons)
		addEventHandler("onClientCharacter", getRootElement(), colorInputInsert)
		addEventHandler("onClientKey", getRootElement(), processEditorKeys)
	end
	
	guiSetInputMode("allow_binds")
end

function renderTheEditor()
	local cursorX, cursorY = 0, 0
	if isCursorShowing() then
		local relX, relY = getCursorPosition()
		cursorX, cursorY = relX * screenW, relY * screenH
		
		if panelIsMoving then
			panelPosX = cursorX - moveDifferenceX
			panelPosY = cursorY - moveDifferenceY
			paintAreaPosX = panelPosX + marginOffset / 2
			paintAreaPosY = panelPosY + headerSize + marginOffset
		end
	end
	
	if selectedButton then
		selectedButton = false
	end
	
	--** Background @ Title
	core:drawWindow(panelPosX, panelPosY, panelWidth, panelHeight + 40 + marginOffset, "", 1)
	--xDrawRectangle(panelPosX, panelPosY, panelWidth, panelHeight + 40 + marginOffset, panelColors["main_" .. panelTheme])
	--dxDrawRectangle(panelPosX, panelPosY, panelWidth, headerSize, panelColors["header_" .. panelTheme])
	
	if colorData.isActive then
		dxDrawText(color.."Graffiti #ffffff- #ccccccColorpicker", panelPosX + marginOffset, panelPosY + 5, panelPosX + panelWidth, panelPosY + headerSize + 7, tocolor(255, 255, 255), 0.8, mainFont, "left", "center", false, false, false, true)
	elseif savedGraffitisMenu.isActive then
		dxDrawText(color.."Graffiti - #ccccccMentett graffitik", panelPosX + marginOffset, panelPosY + 5, panelPosX + panelWidth, panelPosY + headerSize + 7, tocolor(255, 255, 255), 0.8, mainFont, "left", "center", false, false, false, true)
	elseif loadImagePanel.isActive then
		dxDrawText(color.."Graffiti - #ccccccKépfeltöltés", panelPosX + marginOffset, panelPosY + 5, panelPosX + panelWidth, panelPosY + headerSize + 7, tocolor(255, 255, 255), 0.8, mainFont, "left", "center", false, false, false, true)
	else
		dxDrawText(color.."Graffiti", panelPosX + marginOffset, panelPosY + 5, panelPosX + panelWidth, panelPosY + headerSize + 7, tocolor(255, 255, 255), 0.8, mainFont, "left", "center", false, false, false, true)
	end
	
	if not promptDialog.isActive and isCursorWithinArea(cursorX, cursorY, panelPosX + panelWidth - iconSize - marginOffsetHalf, panelPosY + marginOffset / 1.9, iconSize, headerSize) then
		dxDrawImageSection(panelPosX + panelWidth - iconSize - marginOffsetHalf, panelPosY + marginOffset / 1.9, iconSize, iconSize, 0, 0, 32, 32, "files/images/icons.png", 0, 0, 0, tocolor(217, 83, 79))
		selectedButton = "close"
	else
		dxDrawImageSection(panelPosX + panelWidth - iconSize - marginOffsetHalf, panelPosY + marginOffset / 1.9, iconSize, iconSize, 0, 0, 32, 32, "files/images/icons.png")
	end
	
	--** Drawing surface
	if not colorData.isActive and not savedGraffitisMenu.isActive and not loadImagePanel.isActive then
		dxDrawImage(paintAreaPosX, paintAreaPosY, paintAreaWidth, paintAreaHeight, "files/images/paintarea_" .. panelTheme .. ".png")

		if drawingSurface then
			dxDrawImage(paintAreaPosX, paintAreaPosY, paintAreaWidth, paintAreaHeight, drawingSurface)
			
			if isCursorWithinArea(cursorX, cursorY, paintAreaPosX, paintAreaPosY, paintAreaWidth, paintAreaHeight) then
				selectedButton = "paintArea"
				
				local circleX = cursorX - paintAreaPosX
				local circleY = cursorY - paintAreaPosY
				
				dxSetBlendMode("modulate_add")
				if drawingActive then
					dxSetRenderTarget(drawingSurface)
					
					dxDrawLine(drawStartedX, drawStartedY, circleX, circleY, recentlyUsedColors[brushData.currentColor], brushData.currentSize * 2)
					dxDrawCircle(drawStartedX, drawStartedY, brushData.currentSize, recentlyUsedColors[brushData.currentColor])
					dxDrawCircle(circleX, circleY, brushData.currentSize, recentlyUsedColors[brushData.currentColor])
					
					dxSetRenderTarget()
				end
				dxDrawTrimmedCircle(cursorX, cursorY, brushData.currentSize, recentlyUsedColors[brushData.currentColor], paintAreaPosX, paintAreaPosY, paintAreaPosX + paintAreaWidth, paintAreaPosY + paintAreaHeight)
				dxSetBlendMode("blend")
				
				drawStartedX = circleX
				drawStartedY = circleY
			end
		end
	end
	
	--** Colorpicker
	if colorData.isActive and not savedGraffitisMenu.isActive and not loadImagePanel.isActive then
		dxDrawImage(paintAreaPosX, paintAreaPosY, paintAreaWidth, colorData.paletteHeight, "files/images/colorpalette.png")
		
		if isCursorWithinArea(cursorX, cursorY, paintAreaPosX, paintAreaPosY, paintAreaWidth, colorData.paletteHeight) and getKeyState("mouse1") then
			colorData.hue = (cursorX - paintAreaPosX) / paintAreaWidth
			colorData.saturation = (colorData.paletteHeight + paintAreaPosY - cursorY) / colorData.paletteHeight

			local r, g, b = hslToRgb(colorData.hue, colorData.saturation, colorData.lightness)
			recentlyUsedColors[brushData.currentColor] = tocolor(r * 255, g * 255, b * 255, 255)
			
			processColorpickerUpdate(true)
		end
		
		local colorX = (paintAreaPosX + (colorData.hue * paintAreaWidth)) - 5
		local colorY = (paintAreaPosY + (1 - colorData.saturation) * colorData.paletteHeight) - 5
		local r, g, b = hslToRgb(colorData.hue, colorData.saturation, 0.5)
		
		dxDrawRectangle(colorX - 1, colorY - 1, 10 + 2, 10 + 2, tocolor(0, 0, 0, 255))
		dxDrawRectangle(colorX, colorY, 10, 10, tocolor(r * 255, g * 255, b * 255, 255))
		
		--> RGB @ HEX inputfields
		dxDrawText("RGB:", paintAreaPosX, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, paintAreaPosX + paintAreaWidth, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf + 25, panelColors["normaltext_" .. panelTheme], 0.8, mainFont, "left", "center")
		
		for k, v in ipairs({"red", "green", "blue"}) do
			local rowX = paintAreaPosX + 40 + ((k - 1) * (colorData.colorInputs.rgb.width + marginOffsetHalf))
			
			if activecolorInput == v then
				dxDrawRectangle(rowX, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, colorData.colorInputs.rgb.width, 25, tocolor(50, 179, 239, 125))
			else
				dxDrawRectangle(rowX, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, colorData.colorInputs.rgb.width, 25, tocolor(0, 0, 0, 75))
			
				if isCursorWithinArea(cursorX, cursorY, rowX, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, colorData.colorInputs.rgb.width, 25) then
					selectedButton = "colorInput|rgb;" .. v
				end
			end
			
			dxDrawText(colorData.colorInputs.rgb[v], rowX, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, rowX + colorData.colorInputs.rgb.width, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf + 25, tocolor(255, 255, 255), 0.75, mainFont, "center", "center")
		end
		
		dxDrawText("HEX:", paintAreaPosX, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, paintAreaPosX + paintAreaWidth - colorData.colorInputs.hex.width - 5, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf + 25, panelColors["normaltext_" .. panelTheme], 0.8, mainFont, "right", "center")
		if activecolorInput == "hex" then
			dxDrawRectangle(paintAreaPosX + paintAreaWidth - colorData.colorInputs.hex.width, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, colorData.colorInputs.hex.width, 25, tocolor(50, 179, 239, 125))
		else
			dxDrawRectangle(paintAreaPosX + paintAreaWidth - colorData.colorInputs.hex.width, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, colorData.colorInputs.hex.width, 25, tocolor(0, 0, 0, 75))
		
			if isCursorWithinArea(cursorX, cursorY, paintAreaPosX + paintAreaWidth - colorData.colorInputs.hex.width, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, colorData.colorInputs.hex.width, 25) then
				selectedButton = "colorInput|hex;hex"
			end
		end
		dxDrawText(colorData.colorInputs.hex.hex, paintAreaPosX + paintAreaWidth - colorData.colorInputs.hex.width, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf, paintAreaPosX + paintAreaWidth, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf + 25, tocolor(255, 255, 255), 0.75, mainFont, "center", "center")
		
		--> Luminance slider
		dxDrawRectangle(paintAreaPosX - 1, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf + 35 - 1, colorData.luminance.barWidth + 2, colorData.luminance.barHeight + 2, tocolor(255, 255, 255))
		for i = 0, colorData.luminance.barWidth do
			local r, g, b = hslToRgb(colorData.hue, colorData.saturation, i / colorData.luminance.barWidth)
			
			dxDrawRectangle(paintAreaPosX + i, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf + 35, 1, colorData.luminance.barHeight, tocolor(r * 255, g * 255, b * 255))
		end
		dxDrawRectangle(paintAreaPosX + reMap(colorData.lightness, 0, 1, 0, colorData.luminance.barWidth), paintAreaPosY + colorData.paletteHeight + marginOffsetHalf + 35 - 5, 5, colorData.luminance.barHeight + 10, tocolor(255, 255, 255))
		
		if isCursorWithinArea(cursorX, cursorY, paintAreaPosX, paintAreaPosY + colorData.paletteHeight + marginOffsetHalf + 35, colorData.luminance.barWidth, colorData.luminance.barHeight) and getKeyState("mouse1") then
			colorData.lightness = reMap(cursorX - paintAreaPosX, 0, colorData.luminance.barWidth, 0, 1)
			processColorpickerUpdate(true)
		end
	end
	
	--** Recently used colors
	--[[dxDrawRectangle(panelPosX, paintAreaPosY + paintAreaHeight + marginOffset, panelWidth, 40 + marginOffset, panelColors["header_" .. panelTheme])
	for i = 1, #recentlyUsedColors do
		if recentlyUsedColors[i] then
			local width = (panelWidth - marginOffset) / #recentlyUsedColors
			local columnX = panelPosX + marginOffsetHalf + ((i - 1) * width)
		
			if isCursorWithinArea(cursorX, cursorY, columnX, paintAreaPosY + paintAreaHeight + marginOffset + marginOffsetHalf, width, 40) then
				selectedButton = "palette_color|" .. i
			end
			
			dxDrawRectangle(columnX, paintAreaPosY + paintAreaHeight + marginOffset + marginOffsetHalf, width, 40, recentlyUsedColors[i])
		end
	end]]
	
	--** Saved graffitis
	if savedGraffitisMenu.isActive and not loadImagePanel.isActive then
		if #savedGraffitis >= 1 then
			for i = 1, savedGraffitisMenu.imagePerPage do
				local fileName = savedGraffitis[i + savedGraffitisMenu.page]
				
				if fileName then
					if fileExists(settingsTable.savedGraffitisFolder .. fileName .. ".png") then
						local column, row = (i - 1) % 2, math.floor((i - 1) / 2)
						local columnX = paintAreaPosX + column * savedGraffitisMenu.imageWidth + column * marginOffset
						local rowY = paintAreaPosY + row * savedGraffitisMenu.imageHeight + row * marginOffset
						
						if not promptDialog.isActive and isCursorWithinArea(cursorX, cursorY, columnX, rowY, savedGraffitisMenu.imageWidth, savedGraffitisMenu.imageHeight) then
							dxDrawRectangle(columnX, rowY, savedGraffitisMenu.imageWidth, savedGraffitisMenu.imageHeight, tocolor(0, 0, 0, 50))
							dxDrawImage(columnX, rowY, savedGraffitisMenu.imageWidth, savedGraffitisMenu.imageHeight, settingsTable.savedGraffitisFolder .. fileName .. ".png")
							selectedButton = "select|" .. fileName
						else
							dxDrawRectangle(columnX, rowY, savedGraffitisMenu.imageWidth, savedGraffitisMenu.imageHeight, tocolor(0, 0, 0, 100))
							dxDrawImage(columnX, rowY, savedGraffitisMenu.imageWidth, savedGraffitisMenu.imageHeight, settingsTable.savedGraffitisFolder .. fileName .. ".png", 0, 0, 0, tocolor(255, 255, 255, 128))
						end
						
						local drawedTimestamp = getRealTime(tonumber(fileName))
						
						dxDrawRectangle(columnX, rowY + savedGraffitisMenu.imageHeight - 32, savedGraffitisMenu.imageWidth, 32, tocolor(0, 0, 0, 125))
						dxDrawText(string.format("%.4i/%.2i/%.2i %.2i:%.2i:%.2i", drawedTimestamp.year + 1900, drawedTimestamp.month + 1, drawedTimestamp.monthday, drawedTimestamp.hour, drawedTimestamp.minute, drawedTimestamp.second), columnX + 5, rowY + savedGraffitisMenu.imageHeight - 32, columnX + 5 + savedGraffitisMenu.imageWidth - 10, rowY + savedGraffitisMenu.imageHeight, tocolor(255, 255, 255), 0.75, mainFont, "left", "center")
						
						if not promptDialog.isActive and isCursorWithinArea(cursorX, cursorY, columnX + savedGraffitisMenu.imageWidth - 32, rowY + savedGraffitisMenu.imageHeight - 32, 32, 32) then
							dxDrawImageSection(columnX + savedGraffitisMenu.imageWidth - 32, rowY + savedGraffitisMenu.imageHeight - 32, 32, 32, 0, 8 * 32, 32, 32, "files/images/icons.png", 0, 0, 0, tocolor(215, 89, 89, 255))
							selectedButton = "remove|" .. fileName .. "|" .. i + savedGraffitisMenu.page
						else
							dxDrawImageSection(columnX + savedGraffitisMenu.imageWidth - 32, rowY + savedGraffitisMenu.imageHeight - 32, 32, 32, 0, 8 * 32, 32, 32, "files/images/icons.png")
						end
					else
						savedGraffitis[i + savedGraffitisMenu.page] = nil
					end
				end
			end
		else
			dxDrawText("Még nincs egy elmentett graffitid se!\n☹", paintAreaPosX, paintAreaPosY, paintAreaPosX + paintAreaWidth, paintAreaPosY + paintAreaHeight, tocolor(255, 255, 255), 1.0, mainFont, "center", "center")
		end
		
		--> Scrollbar
		if #savedGraffitis > savedGraffitisMenu.imagePerPage then
			core:dxDrawScrollbar(paintAreaPosX + paintAreaWidth + marginOffsetHalf / 2, paintAreaPosY, 5, panelHeight / 1.58, savedGraffitis, savedGraffitisMenu.page, #savedGraffitis, r, g, b, 1, false)
		end
	end
	
	--** Load image from URL
	if loadImagePanel.isActive then
		if not loadImagePanel.resized then
			local waitingProgress = (getTickCount() - (waitingTick or 0)) / 1000
			local dotsInterpolation = interpolateBetween(0, 0, 0, 3, 0, 0, waitingProgress, "Linear")
			local dots = ""
			
			if dotsInterpolation > 2 then
				dots = "..."
			elseif dotsInterpolation > 1 then
				dots = ".."
			elseif dotsInterpolation > 0 then
				dots = "."
			end
			
			dxDrawText("Betöltés" .. dots, paintAreaPosX, paintAreaPosY, paintAreaPosX + paintAreaWidth, paintAreaPosY + paintAreaHeight, tocolor(255, 255, 255), 1.0, mainFont, "center", "center", false, false, false, true)
			
			if waitingProgress > 1 then
				waitingTick = getTickCount()
			end
		else
			if not panelIsMoving then 
				dxDrawImage(0, 0, screenW, screenH, loadImagePanel.browserElement)
			end

			if not loadImagePanel.playerCanDownload then
				--dxDrawRectangle(panelPosX + menuSize, panelPosY + headerSize, panelWidth - menuSize, paintAreaHeight + marginOffset * 2, tocolor(0, 0, 0, 200))
				
				local waitingProgress = (getTickCount() - (loadImagePanel.downloadingDotsTick or 0)) / 1000
				local dotsInterpolation = interpolateBetween(0, 0, 0, 3, 0, 0, waitingProgress, "Linear")
				local dots = ""
			
				if dotsInterpolation > 2 then
					dots = "..."
				elseif dotsInterpolation > 1 then
					dots = ".."
				elseif dotsInterpolation > 0 then
					dots = "."
				end

				dxDrawText("Letöltés folyamatban" .. dots, paintAreaPosX - marginOffset - 1, paintAreaPosY - (menuSize * 9) + 1, paintAreaPosX + paintAreaWidth, paintAreaPosY + paintAreaHeight, tocolor(0, 0, 0), 0.8, mainFont, "center", "center", false, false, false, true)
				dxDrawText("Letöltés folyamatban" .. dots, paintAreaPosX - marginOffset, paintAreaPosY - (menuSize * 9), paintAreaPosX + paintAreaWidth, paintAreaPosY + paintAreaHeight, tocolor(255, 255, 255), 0.8, mainFont, "center", "center", false, false, false, true)
				
				if waitingProgress > 1 then
					loadImagePanel.downloadingDotsTick = getTickCount()
				end
			end
		end
	end
	
	--** Menu
	--dxDrawRectangle(panelPosX, panelPosY + headerSize, menuSize, panelHeight - headerSize, panelColors["menu_" .. panelTheme])
	for i = 1, #panelMenu do
		if panelMenu[i] then
			local row = panelPosX + headerSize + marginOffset + ((i + 6) * (iconSize + marginOffset))
			--panelPosX + ((menuSize - iconSize) / 2), row, iconSize, iconSize, 0, (panelMenu[i][4] and panelMenu[i][4] - 1 or i) * 32, 32, 32, "files/images/icons.png"
			if panelMenu[i].activeWhen and panelMenu[i].activeWhen() then
				dxDrawImageSection(row, panelPosY + ((menuSize - iconSize) / 5), iconSize, iconSize, 0, (panelMenu[i][4] and panelMenu[i][4] - 1 or i) * 32, 32, 32, "files/images/icons.png", 0, 0, 0, panelMenu[i][2])
				
				if isCursorWithinArea(cursorX, cursorY, row , panelPosY + ((menuSize - iconSize) / 5), iconSize, iconSize) then
					selectedButton = "menu|" .. i .. "|not_selectable"
				end
			else
				if isCursorWithinArea(cursorX, cursorY, row , panelPosY + ((menuSize - iconSize) / 5), iconSize, iconSize) and not promptDialog.isActive then
					dxDrawImageSection(row, panelPosY + ((menuSize - iconSize) / 5), iconSize, iconSize, 0, (panelMenu[i][4] and panelMenu[i][4] - 1 or i) * 32, 32, 32, "files/images/icons.png", 0, 0, 0, panelMenu[i][2])
					selectedButton = "menu|" .. i
				else
					dxDrawImageSection(row , panelPosY + ((menuSize - iconSize) / 5), iconSize, iconSize, 0, (panelMenu[i][4] and panelMenu[i][4] - 1 or i) * 32, 32, 32, "files/images/icons.png")
				end
			end
		end
	end
	
	if not promptDialog.isActive then
		if selectedButton and string.find(selectedButton, "menu|") and not string.find(selectedButton, "|not_selectable") then
			local menuId = string.gsub(selectedButton, "menu|", "")
			local menuId = tonumber(menuId)
			local textWidth = dxGetTextWidth(panelMenu[menuId][1], 0.75, mainFont) + marginOffset
			
			dxDrawRectangle(cursorX + 8, cursorY + 8, textWidth, 25, tocolor(10, 10, 10, 200))
			dxDrawText(panelMenu[menuId][1], cursorX + 8, cursorY + 8, cursorX + 8 + textWidth, cursorY + 8 + 25, tocolor(255, 255, 255), 0.75, mainFont, "center", "center")
		end
	end
	
	--** Brush size
	if brushData.isActive then
		local barX = panelPosX + marginOffset
		local barY = paintAreaPosY + paintAreaHeight + marginOffset * 2 + 40 + ((30 - brushData.barHeight) / 2) - menuSize
		local brushRemap = reMap(brushData.currentSize, brushData.minimumSize, brushData.maximumSize, 0, brushData.barWidth)
				
		dxDrawRectangle(barX, barY, brushData.barWidth, brushData.barHeight, tocolor(255, 255, 255, 50))
		dxDrawRectangle(barX, barY, brushRemap, brushData.barHeight, brushData.barColor)
		dxDrawImage(barX + brushRemap - 10, barY + ((brushData.barHeight - 20) / 2), 20, 20, "files/images/circle.png")
		
		if isCursorWithinArea(cursorX, cursorY, barX, barY, brushData.barWidth, brushData.barHeight) and getKeyState("mouse1") then
			brushData.currentSize = reMap(cursorX - barX, 0, brushData.barWidth, brushData.minimumSize, brushData.maximumSize)
		end
	end
	
	--** Prompt dialog
	if promptDialog.isActive then
		--dxDrawRectangle(panelPosX, panelPosY, panelWidth, panelHeight, tocolor(0, 0, 0, 225))
		dxDrawText(promptDialog.text .. "\nElfogadáshoz használd az ENTER-t elutasításhoz pedig a BACKSPACE-t!", panelPosX - 1, panelPosY - (menuSize * 8) + 1, panelPosX + panelWidth, panelPosY + panelHeight, tocolor(0, 0, 0), 0.8, mainFont, "center", "center", false, false, false, true)
		dxDrawText(promptDialog.text .. "\nElfogadáshoz használd az "..color.."ENTER#ffffff-t elutasításhoz pedig a "..color.."BACKSPACE#ffffff-t!", panelPosX, panelPosY - (menuSize * 8), panelPosX + panelWidth, panelPosY + panelHeight, tocolor(255, 255, 255), 0.8, mainFont, "center", "center", false, false, false, true)
	end
end

function processTheEditorButtons(button, state, cursorX, cursorY)
	if button == "left" and state == "down" then
		activecolorInput = false
		
		if cursorX >= panelPosX and cursorX <= panelPosX + panelWidth - iconSize - marginOffsetHalf and cursorY >= panelPosY and cursorY <= panelPosY + headerSize then
			moveDifferenceX = cursorX - panelPosX
			moveDifferenceY = cursorY - panelPosY
			panelIsMoving = true
		end
		
		guiSetInputMode("allow_binds")
		
		if selectedButton and not promptDialog.isActive then
			if selectedButton == "close" then
				lastDrawedPixels = dxConvertPixels(dxGetTexturePixels(drawingSurface), "png")
				showTheEditor()
				setElementData(localPlayer,"toggleInterface",false)
				panelIsMoving = false
			elseif string.find(selectedButton, "menu|") then
				local menuId = string.gsub(selectedButton, "menu|", "")
				local menuId = string.gsub(menuId, "|not_selectable", "")
				local menuId = tonumber(menuId)
				
				if panelMenu[menuId][3] == "theme" then
					panelTheme = (panelTheme == "dark" and "light") or "dark"
					
					if loadImagePanel.browserElement and not isBrowserLoading(loadImagePanel.browserElement) then
						executeBrowserJavascript(loadImagePanel.browserElement, "changeTheme(\"" .. panelTheme .. "\");")
					end
				elseif panelMenu[menuId][3] == "brushsize" then
					brushData.isActive = not brushData.isActive
				elseif panelMenu[menuId][3] == "palette" then
					savedGraffitisMenu.isActive = false
					loadImagePanel.isActive = false
					colorData.isActive = not colorData.isActive
					
					if colorData.isActive then
						processColorpickerUpdate()
					end
				elseif panelMenu[menuId][3] == "new" then
					local drawedPixels = dxGetTexturePixels(drawingSurface)
					if drawedPixels then
						drawingSteps = {}
						currentStep = 1
						dxSetTexturePixels(drawingSurface, emptyPixels)
						table.insert(drawingSteps, 1, emptyPixels)
					end
				elseif panelMenu[menuId][3] == "undo" then
					if drawingSteps[currentStep + 1] then
						currentStep = currentStep + 1
						dxSetTexturePixels(drawingSurface, drawingSteps[currentStep])
					end
				elseif panelMenu[menuId][3] == "redo" then
					if drawingSteps[currentStep - 1] then
						currentStep = currentStep - 1
						dxSetTexturePixels(drawingSurface, drawingSteps[currentStep])
					end
				elseif panelMenu[menuId][3] == "save" then
					local drawedPixels = dxGetTexturePixels(drawingSurface)
					if drawedPixels then
						local fileName = getRealTime().timestamp
						local savedGraffiti = fileCreate(settingsTable.savedGraffitisFolder .. fileName .. ".png")
						
						if savedGraffiti then
							local drawedPixels = dxConvertPixels(drawedPixels, "png")
							
							fileWrite(savedGraffiti, drawedPixels)
							fileClose(savedGraffiti)
							
							table.insert(savedGraffitis, fileName)
							rebuildSavedGraffitis()
							
							lastDrawedPixels = drawedPixels
						end
					end
					
					showTheEditor()
					panelIsMoving = false
					setElementData(localPlayer,"toggleInterface",false)

				elseif panelMenu[menuId][3] == "savedgraffitis" then
					colorData.isActive = false
					loadImagePanel.isActive = false
					savedGraffitisMenu.isActive = not savedGraffitisMenu.isActive
				elseif panelMenu[menuId][3] == "url_image" then
					colorData.isActive = false
					savedGraffitisMenu.isActive = false
					loadImagePanel.isActive = not loadImagePanel.isActive
				end
			else
				if savedGraffitisMenu.isActive then
					if string.find(selectedButton, "select|") then
						promptDialog.isActive = true
						promptDialog.text = "Biztos vagy benne hogy módisítani akarod a kiválasztott graffitit?\nEzzel felülírod a jelenleg kirajzolt graffitit is!"
						promptDialog.value = selectedButton
					elseif string.find(selectedButton, "remove|") then
						promptDialog.isActive = true
						promptDialog.text = "Biztos vagy benne hogy törlöd?\nEz nem vonható vissza!"
						promptDialog.value = selectedButton
					end
				else
					if selectedButton == "paintArea" then
						if not colorData.isActive and drawingSurface then
							drawStartedX = cursorX - paintAreaPosX
							drawStartedY = cursorY - paintAreaPosY
							drawingActive = true
						end
					elseif string.find(selectedButton, "colorInput|") then
						local stringData = string.gsub(selectedButton, "colorInput|", "")
						local colorInput = split(stringData, ";")[1]
						local inputId = split(stringData, ";")[2]
						
						if colorData.colorInputs[colorInput][inputId] then
							activecolorInput = inputId
						end
					elseif string.find(selectedButton, "palette_color|") then
						local selectedColor = string.gsub(selectedButton, "palette_color|", "")
						selectedColor = tonumber(selectedColor)
						
						if brushData.currentColor ~= selectedColor then
							brushData.currentColor = selectedColor
							processColorpickerUpdate()
						end
					end
				end
			end
		end
	elseif button == "left" and state == "up" then
		panelIsMoving = false
		executeBrowserJavascript(loadImagePanel.browserElement, "document.getElementById(\"main\").style.left=\"" .. paintAreaPosX .. "px\"; document.getElementById(\"main\").style.top=\"" .. paintAreaPosY .. "px\"; document.getElementById(\"main\").style.width=\"" .. paintAreaWidth .. "px\"; document.getElementById(\"main\").style.height=\"" .. paintAreaHeight .. "px\";")
		
		if drawingActive then
			local drawedPixels = dxGetTexturePixels(drawingSurface)
			if drawedPixels then
				table.insert(drawingSteps, 1, drawedPixels)
				currentStep = 1
				
				if #drawingSteps > 75 then
					table.remove(drawingSteps, #drawingSteps)
				end
			end
			
			drawingActive = false
		end
	end
end

function colorInputInsert(character)
	if not activecolorInput then
		return
	end
	
	character = utf8.upper(character)
	
	if activecolorInput == "hex" then
		if utf8.len(colorData.colorInputs.hex[activecolorInput]) < 7 and utf8.find("0123456789ABCDEF", character) then
			colorData.colorInputs.hex[activecolorInput] = colorData.colorInputs.hex[activecolorInput] .. character
		end
		
		if utf8.len(colorData.colorInputs.hex[activecolorInput]) >= 7 then
			local r, g, b = fixRGB(hexToRgb(colorData.colorInputs.hex[activecolorInput]))
			
			colorData.hue, colorData.saturation, colorData.lightness = rgbToHsl(r / 255, g / 255, b / 255)
			colorData.colorInputs.rgb.red = r
			colorData.colorInputs.rgb.green = g
			colorData.colorInputs.rgb.blue = b
			recentlyUsedColors[brushData.currentColor] = tocolor(r, g, b)
		end
	else
		if tonumber(character) then
			if utf8.len(colorData.colorInputs.rgb[activecolorInput]) < 3 then
				colorData.colorInputs.rgb[activecolorInput] = tonumber(colorData.colorInputs.rgb[activecolorInput] .. character)
			end
			
			colorData.hue, colorData.saturation, colorData.lightness = rgbToHsl(colorData.colorInputs.rgb.red / 255, colorData.colorInputs.rgb.green / 255, colorData.colorInputs.rgb.blue / 255)
			colorData.colorInputs.hex.hex = rgbToHex(colorData.colorInputs.rgb.red, colorData.colorInputs.rgb.green, colorData.colorInputs.rgb.blue)
			recentlyUsedColors[brushData.currentColor] = tocolor(colorData.colorInputs.rgb.red, colorData.colorInputs.rgb.green, colorData.colorInputs.rgb.blue)
		end
	end
end

function processEditorKeys(key, pressDown)
	if activecolorInput then
		if key == "backspace" and pressDown then
			if activecolorInput == "hex" then
				if utf8.len(colorData.colorInputs.hex[activecolorInput]) > 1 then
					colorData.colorInputs.hex[activecolorInput] = utf8.sub(colorData.colorInputs.hex[activecolorInput], 1, utf8.len(colorData.colorInputs.hex[activecolorInput]) - 1)
				end
			else
				if utf8.len(colorData.colorInputs.rgb[activecolorInput]) > 0 then
					colorData.colorInputs.rgb[activecolorInput] = tonumber(utf8.sub(colorData.colorInputs.rgb[activecolorInput], 1, utf8.len(colorData.colorInputs.rgb[activecolorInput]) - 1)) or 0
					
					colorData.hue, colorData.saturation, colorData.lightness = rgbToHsl(colorData.colorInputs.rgb.red / 255, colorData.colorInputs.rgb.green / 255, colorData.colorInputs.rgb.blue / 255)
					colorData.colorInputs.hex.hex = rgbToHex(colorData.colorInputs.rgb.red, colorData.colorInputs.rgb.green, colorData.colorInputs.rgb.blue)
					recentlyUsedColors[brushData.currentColor] = tocolor(colorData.colorInputs.rgb.red, colorData.colorInputs.rgb.green, colorData.colorInputs.rgb.blue)
				end
			end
		end
	elseif savedGraffitisMenu.isActive then
		if pressDown then
			if promptDialog.isActive then
				if key == "enter" then
					if string.find(promptDialog.value, "select|") then
						local fileName = string.gsub(promptDialog.value, "select|", "")
					
						if fileExists(settingsTable.savedGraffitisFolder .. fileName .. ".png") then
							local selectedTexture = dxCreateTexture(settingsTable.savedGraffitisFolder .. fileName .. ".png")
							if selectedTexture and isElement(selectedTexture) then
								local texturePixels = dxGetTexturePixels(selectedTexture)
								destroyElement(selectedTexture)
								dxSetTexturePixels(drawingSurface, texturePixels)
								
								drawingSteps = {}
								currentStep = 1
								table.insert(drawingSteps, 1, emptyPixels)
								
								local drawedPixels = dxGetTexturePixels(drawingSurface)
								if drawedPixels then
									table.insert(drawingSteps, 1, drawedPixels)
								end
								
								savedGraffitisMenu.isActive = false
							end
						end
						
						promptDialog.isActive = false
					elseif string.find(promptDialog.value, "remove|") then
						local stringData = string.gsub(promptDialog.value, "remove|", "")
						local fileName = split(stringData, "|")[1]
					
						if fileExists(settingsTable.savedGraffitisFolder .. fileName .. ".png") then
							fileDelete(settingsTable.savedGraffitisFolder .. fileName .. ".png")
						end
						
						table.remove(savedGraffitis, tonumber(split(stringData, "|")[2]))
						rebuildSavedGraffitis()
						
						if #savedGraffitis > savedGraffitisMenu.imagePerPage then
							if savedGraffitisMenu.page > #savedGraffitis - savedGraffitisMenu.imagePerPage then
								savedGraffitisMenu.page = #savedGraffitis - savedGraffitisMenu.imagePerPage
							end
						else
							savedGraffitisMenu.page = 0
						end
						
						promptDialog.isActive = false
					end
				elseif key == "backspace" then
					promptDialog.isActive = false
					promptDialog.text = ""
					promptDialog.value = false
				end
			else
				if #savedGraffitis > savedGraffitisMenu.imagePerPage then
					if key == "mouse_wheel_down" and savedGraffitisMenu.page < #savedGraffitis - savedGraffitisMenu.imagePerPage then
						savedGraffitisMenu.page = savedGraffitisMenu.page + savedGraffitisMenu.imagePerPage
				
						if savedGraffitisMenu.page > #savedGraffitis - savedGraffitisMenu.imagePerPage then
							savedGraffitisMenu.lastPage = savedGraffitisMenu.page - (#savedGraffitis - savedGraffitisMenu.imagePerPage)
							savedGraffitisMenu.page = #savedGraffitis - savedGraffitisMenu.imagePerPage
						end
					elseif key == "mouse_wheel_up" and savedGraffitisMenu.page > 0 then
						if savedGraffitisMenu.lastPage then
							savedGraffitisMenu.page = savedGraffitisMenu.page - savedGraffitisMenu.imagePerPage + savedGraffitisMenu.lastPage
							savedGraffitisMenu.lastPage = false
						else
							savedGraffitisMenu.page = savedGraffitisMenu.page - savedGraffitisMenu.imagePerPage
						end
						
						if savedGraffitisMenu.page < 0 then
							savedGraffitisMenu.page = 0
						end
					end
				end
			end
		end
	end
end

function rebuildSavedGraffitis()
	local rebuildedList = {}
	
	for k,v in pairs(savedGraffitis) do
		table.insert(rebuildedList, v)
	end
	
	table.sort(rebuildedList,
		function (a, b)
			return a > b
		end
	)
	
	savedGraffitis = rebuildedList
	rebuildedList = nil
end

function fitImageSize(defaultWidth, defaultHeight, fitWidth, fitHeight, enlarge)
	local scaleFactor = fitHeight / defaultHeight
	local newWidth = defaultWidth * scaleFactor
	
	if newWidth > fitWidth then
		scaleFactor = fitWidth / defaultWidth
	end
	
	if not enlarge and scaleFactor > 1 then
		return defaultWidth, defaultHeight
	end
	
	return defaultWidth * scaleFactor, defaultHeight * scaleFactor
end

function processColorpickerUpdate(selecting)
	if selecting then
		local r, g, b = hslToRgb(colorData.hue, colorData.saturation, colorData.lightness)
		r, g, b = fixRGB(r * 255, g * 255, b * 255)
		
		colorData.colorInputs.rgb.red = r
		colorData.colorInputs.rgb.green = g
		colorData.colorInputs.rgb.blue = b
		colorData.colorInputs.hex.hex = rgbToHex(r, g, b)
		recentlyUsedColors[brushData.currentColor] = tocolor(r, g, b)
	else
		local r, g, b, a = fixRGB(getColorFromDecimal(recentlyUsedColors[brushData.currentColor]))
		
		colorData.hue, colorData.saturation, colorData.lightness = rgbToHsl(r / 255, g / 255, b / 255)
		colorData.colorInputs.rgb.red = r
		colorData.colorInputs.rgb.green = g
		colorData.colorInputs.rgb.blue = b
		colorData.colorInputs.hex.hex = rgbToHex(r, g, b)
	end
end

function dxDrawCircle(x, y, r, color)
	for yoff = math.floor(-r) + 0.5, r + 0.5 do
		local xoff = math.sqrt(r * r - yoff * yoff)
		
		if not isNaN(xoff) then
			dxDrawRectangle(x - xoff, y + yoff, xoff * 2, 1, color)
		end
	end
end

function dxDrawTrimmedCircle(x, y, r, color, x1, y1, x2, y2)
	local dy1, dy2 = math.max(-r, y1 - y), math.min(r, y2 - y - 1)
	
	for yoff = math.floor(dy1) + 0.5, dy2 + 0.5 do
		local xoff = math.sqrt(r * r - yoff * yoff)
		local dx1, dx2 = math.max(x - xoff, x1), math.min(x + xoff, x2)
		
		if not isNaN(xoff) then
			dxDrawRectangle(dx1, y + yoff, dx2 - dx1, 1, color)
		end
	end
end

function isNaN(val)
	return val ~= val
end

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function isCursorWithinArea(cx, cy, x, y, w, h)
	if isCursorShowing() then
		if cx >= x and cx <= x + w and cy >= y and cy <= y + h then
			return true
		end
	end
	
	return false
end

function isEventHandlerAdded(eventName, attachedTo, func)
	if type(eventName) == "string" and  isElement(attachedTo) and type(func) == "function" then
		local isAttached = getEventHandlers(eventName, attachedTo)
		
		if type(isAttached) == "table" and #isAttached > 0 then
			for i, v in ipairs(isAttached) do
				if v == func then
					return true
				end
			end
		end
	end
	
	return false
end

function fixRGB(r, g, b, a)
	r = math.max(0, math.min(255, math.floor(r)))
	g = math.max(0, math.min(255, math.floor(g)))
	b = math.max(0, math.min(255, math.floor(b)))
	a = a and math.max(0, math.min(255, math.floor(a))) or 255
	
	return r, g, b, a
end

function hexToRgb(code)
	code = code:gsub("#", "")
	return tonumber("0x" .. code:sub(1, 2)), tonumber("0x" .. code:sub(3, 4)), tonumber("0x" .. code:sub(5, 6))
end

function rgbToHex(r, g, b, a)
	if (r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) or (a and (a < 0 or a > 255)) then
		return nil
	end
	
	if a then
		return string.format("#%.2X%.2X%.2X%.2X", r, g, b, a)
	else
		return string.format("#%.2X%.2X%.2X", r, g, b)
	end
end

function hslToRgb(h, s, l)
	local lightnessValue
	
	if l < 0.5 then
		lightnessValue = l * (s + 1)
	else
		lightnessValue = (l + s) - (l * s)
	end
	
	local lightnessValue2 = l * 2 - lightnessValue
	local r = hueToRgb(lightnessValue2, lightnessValue, h + 1 / 3)
	local g = hueToRgb(lightnessValue2, lightnessValue, h)
	local b = hueToRgb(lightnessValue2, lightnessValue, h - 1 / 3)
	
	return r, g, b
end

function hueToRgb(l, l2, h)
	if h < 0 then
		h = h + 1
	elseif h > 1 then
		h = h - 1
	end

	if h * 6 < 1 then
		return l + (l2 - l) * h * 6
	elseif h * 2 < 1 then
		return l2
	elseif h * 3 < 2 then
		return l + (l2 - l) * (2 / 3 - h) * 6
	else
		return l
	end
end

function rgbToHsl(r, g, b)
	local maxValue = math.max(r, g, b)
	local minValue = math.min(r, g, b)
	local h, s, l = 0, 0, (minValue + maxValue) / 2

	if maxValue == minValue then
		h, s = 0, 0
	else
		local different = maxValue - minValue

		if l < 0.5 then
			s = different / (maxValue + minValue)
		else
			s = different / (2 - maxValue - minValue)
		end

		if maxValue == r then
			h = (g - b) / different
			
			if g < b then
				h = h + 6
			end
		elseif maxValue == g then
			h = (b - r) / different + 2
		else
			h = (r - g) / different + 4
		end

		h = h / 6
	end

	return h, s, l
end

function getColorFromDecimal(decimal)
	local red = bitExtract(decimal, 16, 8)
	local green = bitExtract(decimal, 8, 8)
	local blue = bitExtract(decimal, 0, 8)
	local alpha = bitExtract(decimal, 24, 8)
	
	return red, green, blue, alpha
end