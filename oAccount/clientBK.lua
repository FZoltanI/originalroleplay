local sx, sy = guiGetScreenSize()
local myX,myY = 1600,900
local rel = ((sx/1920)+(sy/1080))/2

local color,r,g,b = exports.oCore:getServerColor()
local renderRememberPanel = false 
local playerSkin = 1
local skinesped
local fontscript = exports.oFont

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oDashboard" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oCarshop" or getResourceName(res) == "oFont" then  
		guiSetInputEnabled ( false )
        infobox = exports.oInfobox
		core = exports.oCore
		color,r,g,b = exports.oCore:getServerColor()
		fontscript = exports.oFont
	end
end)


local selectedmusic = 1
local music
local soundState = true
local musicSelecting = false
local soundVolume = 1
local soundEditing = false

local dimId = getElementData(localPlayer, "playerid") or 1

local tick = getTickCount()

local fonts = {
	["font"] = exports.oFont:getFont("roboto",10),
	["font14"] = exports.oFont:getFont("roboto",12),
	["font2"] = exports.oFont:getFont("roboto",14),
	["bebasneue"] = exports.oFont:getFont("bebasneue",15),
	["icon"] = exports.oFont:getFont("fontawesome2",16),

	["bebasneue-35"] = exports.oFont:getFont("bebasneue", 35),
	["condensed-11"] = exports.oFont:getFont("condensed", 11),
	["condensed-10"] = exports.oFont:getFont("condensed", 10),
}

local camera_timers = {}

local tick_load = getTickCount()
local alpha_tick = getTickCount() 
local logoAnimTick = getTickCount()
local loadPanelAlpha = 1
local logoAlpha = 0 
local logoAnimationType = 1
local panelBgAnimation = 1
local loadPanelAlpha = 0
local loadtimes = {5000, 10000}--{10000,25000}
local selectedLoadText = 1
local ban_datas = false

local web

function jsonGET(file, private, defData)
	if private then
		file = "@"..file..".json"
	else
		file = file..".json"
	end
	local fileHandle
	local jsonDATA = {}
	if not fileExists(file) then
		return defData or {}
	else
		fileHandle = fileOpen(file)
	end
	if fileHandle then
		local buffer
		local allBuffer = ""
		while not fileIsEOF(fileHandle) do
			buffer = fileRead(fileHandle, 500)
			allBuffer = allBuffer..buffer
		end
		jsonDATA = fromJSON(allBuffer)
		fileClose(fileHandle)
	end
	return jsonDATA
end

function jsonSAVE(file, data, private)
	if private then
		file = "@".. file..".json"
	else
		file = file..".json"
	end
	if fileExists(file) then
		fileDelete(file)
	end
	local fileHandle = fileCreate(file)
	fileWrite(fileHandle, toJSON(data))
	fileFlush(fileHandle)
	fileClose(fileHandle)
	return true
end

local temp_objects = {}
local browser
local browser2

addEvent("receiveBanState",true)
addEventHandler("receiveBanState", getRootElement(), function(data)
	if data.isActive == "Y" then 
		fadeCamera(true)
		setElementPosition(localPlayer, 3750, 3750, 1500)
		setElementFrozen(localPlayer, true)
		startBanPanelRender(data)
	else 
		browser = guiCreateBrowser(0, 0, sx, sy, true, true, false)
		browser2 = guiGetBrowser(browser)
		data = jsonGET("rememberPassword", true)
		--[[addEventHandler("onClientBrowserCreated", browser2, function()
			showChat(false)
			--outputDebugString("asd")
			web = loadBrowserURL(source, "http://mta/local/index.html")
			setTimer(function()
				--if fileExists("rememberPassword.json") then 
					
				--	outputChatBox("Mentett adatok betöltése")
				--	outputChatBox(data["rememberMe"])
					if data["rememberMe"] == 1 then
						--asd = guiGetBrowser(browser)
						executeBrowserJavascript(browser2, 'rememberMe("'.. data["username"]..'", "'.. data["password"]..'", "'..data["rememberMe"]..'");')
						--outputDebugString("a")
					end
				--end
			end,1000,1)
		
			guiSetInputEnabled(true)
		end)]]
		
		--[[addEventHandler("onClientBrowserDocumentReady", browser2,
			function ()
				setTimer(function()
					--if fileExists("rememberPassword.json") then 
						
					--	outputChatBox("Mentett adatok betöltése")
					--	outputChatBox(data["rememberMe"])
						if data["rememberMe"] == 1 then
							--asd = guiGetBrowser(browser)
							executeBrowserJavascript(browser2, 'rememberMe("'.. data["username"]..'", "'.. data["password"]..'", "'..data["rememberMe"]..'");')
							--outputDebugString("a")
						end
					--end
				end,800,1)
			end)]]
		local randcam = math.random(#cams)
		local camera = setCameraMatrix(cams[randcam][1],cams[randcam][2],cams[randcam][3],cams[randcam][4],cams[randcam][5],cams[randcam][6])

		for k,v in ipairs(loginElements[randcam]) do
			if v[1] == "ped" then 
				local ped = createPed(v[2],v[3],v[4],v[5],v[6])
				setElementDimension(ped, dimId)

				if v[7] then 
					setPedAnimation(ped, v[7][1], v[7][2], -1, true, false)
				end

				if randcam == 1 and k == 4 then 
					givePedWeapon(ped,5)
					setPedWeaponSlot(ped,1)
				elseif randcam == 1 and k == 5 then 
					givePedWeapon(ped,30)
					setPedWeaponSlot(ped,5)
				elseif randcam == 1 and k == 6 then
					givePedWeapon(ped,22)
					setPedWeaponSlot(ped,2) 

				elseif randcam == 2 and k == 1 then 
					givePedWeapon(ped,29)
					setPedWeaponSlot(ped,4) 
				elseif randcam == 2 and k == 5 then 
					givePedWeapon(ped,31)
					setPedWeaponSlot(ped,5) 
				elseif randcam == 2 and k == 6 then 
					givePedWeapon(ped,31)
					setPedWeaponSlot(ped,5) 

				elseif randcam == 3 and k == 1 then 
					givePedWeapon(ped,25)
					setPedWeaponSlot(ped,3) 
				elseif randcam == 3 and k == 3 then 
					givePedWeapon(ped,34)
					setPedWeaponSlot(ped,6) 
				elseif randcam == 3 and k == 4 then 
					givePedWeapon(ped,34)
					setPedWeaponSlot(ped,6) 
				end


				table.insert(temp_objects, #temp_objects+1, ped)
			elseif v[1] == "vehicle" then 
				local vehicle = createVehicle(v[2],v[3],v[4],v[5],0,0,v[6],"Login") --createPed(v[2],v[3],v[4],v[5],v[6])
				setElementFrozen(vehicle, true)
				setElementDimension(vehicle,dimId)

				local color = v[7] or {0,0,0}
				setVehicleColor(vehicle,color[1],color[2],color[3])

				table.insert(temp_objects, #temp_objects+1, vehicle)
			end
		end
		
		addEventHandler("onClientKey", root, keyLoginV2)
		addEventHandler("onClientRender",root,renderLoginBack)
		
		local savedatas = "false"

			selectedmusic= math.random(1, #musics)
			music = playSound("music/"..musics[selectedmusic][1]..".mp3",true)
			setSoundVolume(music,soundVolume)
			setSoundPosition(music, 5.1)
			soundVolume = 1
	end
end)




local usernameRemember = false
local passwordRemember = false

addEvent("regbaszas",true)
addEventHandler("regbaszas", getRootElement(), function(username, password)
	usernameRemember = username
	passwordRemember = password
end)

addEvent("comeBackToLogin",true)
addEventHandler("comeBackToLogin",getRootElement(), function()
	setTimer(function()
		--if fileExists("rememberPassword.json") then 
			data = jsonGET("rememberPassword", false)
			
			if data["rememberMe"] == 1 then
		--		executeBrowserJavascript(browser2, 'rememberMe("'.. data["username"]..'", "'.. data["password"]..'", "'..data["rememberMe"]..'");')
				--outputDebugString("a")
			end
		--end
	end,500,1)
end)

local ralt = false
addEventHandler("onClientKey", root, function(key, state)
	if key == "ralt" then 
		ralt = state 
	end

	if key == "v" then 
		if state then 
			if ralt then 
				ralt = false
			--	executeBrowserJavascript(browser2, "if (document.activeElement == document.getElementById('email')) {document.getElementById('email').value = document.getElementById('email').value + '@'; }")
			end
		end
	end
end)

local panelW,panelH = 300, 150
local panelX, panelY = sx/2 - panelW/2, sy/2 - panelH/2
local selectedTab = 1

buttons = {}
activeButton = false

local inputLineGetStart = {}
local inputLineGetInverse = {}
local inputCursorState = false
local lastChangeCursorState = 0
local repeatTimer = false
local repeatStartTimer = false
fakeInputs = {}
selectedInput = false


function drawRememberRender()
	buttons = {}
	dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(30, 30, 30, 150))
	dxDrawRectangle(panelX + 2, panelY + 2, panelW -4, panelH-4, tocolor(35, 35, 35, 255))
	dxDrawRectangle(panelX + 2, panelY + 2, panelW - 4, 25, tocolor(30,30,30, 255))

	dxDrawText("Visszalépéshez használd a vissza gombot! \nCsak a saját, általad megadott emailcímet add meg!\nSoha ne add ki senkinek a jelszavad!\nHiba esetén keress fel egy fejlesztőt!\n©Original Roleplay", 10/myX*sx, 10/myX*sx, _, _, tocolor(255, 255, 255, 150), 1, fontscript:getFont("p_m", 13/myX*sx))

	if selectedTab == 1 then
		dxDrawText("Jelszó emlékeztető", sx/2, panelY, sx/2, panelY + 28, tocolor(255,255,255,150), 1, fonts["condensed-10"], "center", "center")

		drawInput("emailInput|50", "Email cím", panelX + 4, panelY+40 + 4, panelW - 8, 25, fonts["condensed-10"],1, tocolor(30, 30, 30, 255), 1)
		if activeButton == "nextRemember" then 
			
			--dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10, 125, 25, tocolor(r,g,b, 250))
		else
			--dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10, 125, 25, tocolor(r,g,b, 150))
		end
		if activeButton == "backwardPanel" then 
		--	dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10+ 25 + 10, 125, 25, tocolor(255, 25, 36, 250))
		else
		--	dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10+ 25 + 10, 125, 25, tocolor(255, 25, 36, 150))
		end
		core:dxDrawButton(panelX + 4, panelY+ 40 + 25 +10 + 4 + 3, panelW - 8, 30, r, g, b, 200, "Tovább", tocolor(255, 255, 255, 255), 1, fonts["condensed-10"], true, tocolor(0, 0, 0, 50))
		core:dxDrawButton(panelX + 4, panelY+ 40 + 25 +10+ 25 + 10 + 4, panelW - 8, 30, 255, 25, 36, 200, "Vissza", tocolor(255, 255, 255, 255), 1, fonts["condensed-10"], true, tocolor(0, 0, 0, 50))
		
		
		--dxDrawText("Tovább", sx/2, panelY+ 40 + 25 + 10, sx/2, panelY+ 40 + 25 + 10 + 25, tocolor(255,255,255,255),1,fonts["font"], "center", "center")
		--dxDrawText("Vissza", sx/2, panelY+ 40 + 25 + 10 + 25 + 10, sx/2, panelY+ 40 + 25 + 10 + 25 + 25+ 10, tocolor(255,255,255,255),1,fonts["font"], "center", "center")
		buttons["nextRemember"] = {panelX+ 4, panelY+ 40 + 25 +10 + 4, panelW - 8, 25}
		buttons["backwardPanel"] = {panelX+ 4, panelY+ 40 + 25 +10+ 25 + 10 + 4, panelW - 8, 25}
	elseif selectedTab == 2 then 
		if activeButton == "nextRemember2" then 
		--	dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10, 125, 25, tocolor(r,g,b, 250))
		else
		--	dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10, 125, 25, tocolor(r,g,b, 150))
		end
		if activeButton == "backwardPanel2" then 
		--	dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10+ 25 + 10, 125, 25, tocolor(255, 25, 36, 250))
		else
		--	dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10+ 25 + 10, 125, 25, tocolor(255, 25, 36, 150))
		end
		core:dxDrawButton(panelX + 4, panelY+ 40 + 25 +10 + 4 + 3, panelW - 8, 30, r, g, b, 200, "Tovább", tocolor(255, 255, 255, 255), 1, fonts["condensed-10"], true, tocolor(0, 0, 0, 50))
		core:dxDrawButton(panelX + 4, panelY+ 40 + 25 +10+ 25 + 10 + 4, panelW - 8, 30, 255, 25, 36, 200, "Vissza", tocolor(255, 255, 255, 255), 1, fonts["condensed-10"], true, tocolor(0, 0, 0, 50))
		dxDrawText("Visszaigazoló kód", sx/2, panelY, sx/2, panelY + 25, tocolor(255,255,255,255), 1, fonts["condensed-10"], "center", "center")

		buttons["nextRemember2"] = {panelX+ 4, panelY+ 40 + 25 +10 + 4, panelW - 8, 25}
		buttons["backwardPanel2"] = {panelX+ 4, panelY+ 40 + 25 +10+ 25 + 10 + 4, panelW - 8, 25}
		drawInput("recoveryCode|10", "Visszaigazoló kód", panelX + 4, panelY+40 + 4, panelW - 8, 25, fonts["condensed-10"],1, tocolor(30, 30, 30, 255), 1)
	elseif selectedTab == 3 then 
		dxDrawText("Új jelszó beállítása", sx/2, panelY, sx/2, panelY + 25, tocolor(255,255,255,255), 1, fonts["condensed-10"], "center", "center")
		drawInput("password1|20", "Jelszó 1x", panelX + 4, panelY+35 + 4, panelW - 8, 25, fonts["condensed-10"],1, tocolor(0,0,0,150), 1)
		drawInput("password2|20", "Jelszó 2x", panelX + 4, panelY+35 + 25 + 10 + 4, panelW - 8, 25, fonts["condensed-10"],1, tocolor(0,0,0,150), 1)
		if activeButton == "nextRemember3" then 
		--	dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10 + 25 +15, 125, 25, tocolor(r,g,b, 250))
		else
		--	dxDrawRectangle(panelX+ 88, panelY+ 40 + 25 +10+25+15, 125, 25, tocolor(r,g,b, 150))
		end
		core:dxDrawButton(panelX + 4, panelY+ 40 + 25 +10+25+10, panelW - 8, 30, r, g, b, 200, "Megörsítés", tocolor(255, 255, 255, 255), 1, fonts["condensed-10"], true, tocolor(0, 0, 0, 50))
		--dxDrawText("Megerősítés", sx/2, panelY+ 40 + 25 + 10 + 25 +15, sx/2, panelY+ 40 + 25 + 10 + 25 + 25 + 15, tocolor(255,255,255,255),1,fonts["font"], "center", "center")
	--	dxDrawText("Vissza", sx/2, panelY+ 40 + 25 + 10 + 25 + 10, sx/2, panelY+ 40 + 25 + 10 + 25 + 25+ 10, tocolor(255,255,255,255),1,fonts["font"], "center", "center")
		buttons["nextRemember3"] = {panelX+ 4, panelY+ 40 + 25 +10 + 25 +15 + 4, panelW -8, 25}
	end

	local relX, relY = getCursorPosition()

	activeButton = false

	if relX and relY then
		relX = relX * sx
		relY = relY * sy

		for k, v in pairs(buttons) do
			if relX >= v[1] and relX <= v[1] + v[3] and relY >= v[2] and relY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end
end

local validationInput = false

emailTypes = {
	["hotmail.com"] = true,
	["gmail.com"] = true,
	["gmail.hu"] = true,
	["indamail.hu"] = true,
	["yahoo.com"] = true,
	["vipmail.hu"] = true,
	["citromail.hu"] = true,
	["freemail.hu"] = true,
}

function rememberClick(button,state)
	selectedInput = false
	guiSetInputMode("allow_binds")
	if activeButton then
		if button == "left" and state == "up" then 
			if string.find(activeButton, "input") then
				selectedInput = string.gsub(activeButton, "input:", "")
				validationInput = selectedInput
				--print(selectedInput)
				guiSetInputMode("no_binds")
			end
			local data = split(activeButton, ":")
			if data[1] == "nextRemember" and selectedTab == 1 then 
				if fakeInputs[validationInput] then 
					if utf8.len(fakeInputs[validationInput]) > 0 then
						if utf8.find(fakeInputs[validationInput], "@") and utf8.find(fakeInputs[validationInput], ".") then 
						--	outputChatBox("Ellenörzés")

							triggerServerEvent("rememberCheck", localPlayer, localPlayer, fakeInputs[validationInput])
						else
							exports.oInfobox:outputInfoBox("Adj meg egy valós email címet!","error")
						end
					else
						exports.oInfobox:outputInfoBox("Üresen nem hagyhatod ezt a mezőt!","error")
					end
				else 
					exports.oInfobox:outputInfoBox("Üresen nem hagyhatod ezt a mezőt!","error")
				end
			elseif data[1] == "backwardPanel" then 
				if renderRememberPanel then 
					removeEventHandler("onClientRender", getRootElement(), drawRememberRender)
					removeEventHandler("onClientClick", getRootElement(), rememberClick)
					removeEventHandler("onClientKey", getRootElement(), rememberKey)
					removeEventHandler("onClientCharacter", getRootElement(), rememberMe)
					renderRememberPanel = false
				end 
				--browser = guiCreateBrowser(0, 0, sx, sy, true, true, false)
				--browser2 = guiGetBrowser(browser)
				--[[addEventHandler("onClientBrowserCreated", browser2, function()
					showChat(false)
					data = jsonGET("rememberPassword", true)
					--outputDebugString("asd")
					web = loadBrowserURL(source, "http://mta/local/index.html")
					setTimer(function()
						--outputChatBox("asd")
						if data["rememberMe"] == 1 then
							
							executeBrowserJavascript(browser2, 'rememberMe("'.. data["username"]..'", "'.. data["password"]..'", "'..data["rememberMe"]..'");')
						end
					end,1000,1)
					guiSetInputEnabled(true)
				end
				)]]
			elseif data[1] == "nextRemember2" and selectedTab == 2 then
				if utf8.len(fakeInputs[validationInput]) > 0 then 
					triggerServerEvent("rememberCheck2", localPlayer, localPlayer, fakeInputs[validationInput])
				else 
					exports.oInfobox:outputInfoBox("Üresen nem hagyhatod ezt a mezőt!","error")
				end
			elseif data[1] == "backwardPanel2" and selectedTab == 2 then
				if renderRememberPanel then 
					removeEventHandler("onClientRender", getRootElement(), drawRememberRender)
					removeEventHandler("onClientClick", getRootElement(), rememberClick)
					removeEventHandler("onClientKey", getRootElement(), rememberKey)
					removeEventHandler("onClientCharacter", getRootElement(), rememberMe)
					renderRememberPanel = false
				end 
				exports.oInfobox:outputInfoBox("Mivel vissza léptél ezért a kód már nem használható fel!","error")
				triggerServerEvent("destroyCode", localPlayer, localPlayer)
			elseif data[1] == "nextRemember3" and selectedTab == 3 then
				local pw1 = fakeInputs["password1|20"]
				local pw2 = fakeInputs["password2|20"]
				if pw1 ~= "" and pw2 ~= "" then
					if pw1 == pw2 then 
						--outputChatBox("asd")
						triggerServerEvent("passwordChange", localPlayer, localPlayer, hash("sha256", "originalRoleplayAccount"..pw1.."2k20"))
					else 
						exports.oInfobox:outputInfoBox("A két jelszó nem egyezzik!","error")
					end
				else 
					exports.oInfobox:outputInfoBox("Üresen nem hagyhatod ezt a mezőt!","error")
				end
			elseif data[1] == "confirmEmail" then 
				if fakeInputs[validationInput] then 
					if utf8.len(fakeInputs[validationInput]) > 0 then
						if utf8.find(fakeInputs[validationInput], "@") and utf8.find(fakeInputs[validationInput], ".") then 
							email = split(fakeInputs[validationInput],"@")
							if emailTypes[email[2]] then 
								triggerServerEvent("changeEmail", localPlayer,localPlayer,fakeInputs[validationInput])
							else 
								exports.oInfobox:outputInfoBox("Adj meg egy valós email címet!","error")
							end
						else
							exports.oInfobox:outputInfoBox("Adj meg egy valós email címet!","error")
						end
					else 
						exports.oInfobox:outputInfoBox("Üresen nem hagyhatod ezt a mezőt!","error")
					end
				else 
					exports.oInfobox:outputInfoBox("Üresen nem hagyhatod ezt a mezőt!","error")
				end
			end
		end
	end
end

addEvent("backToLogin",true)
addEventHandler("backToLogin", getRootElement(),function()
	removeEventHandler("onClientRender", getRootElement(), drawRememberRender)
	removeEventHandler("onClientClick", getRootElement(), rememberClick)
	removeEventHandler("onClientKey", getRootElement(), rememberKey)
	removeEventHandler("onClientCharacter", getRootElement(), rememberMe)
	--browser = guiCreateBrowser(0, 0, sx, sy, true, true, false)
	--browser2 = guiGetBrowser(browser)
	addEventHandler("onClientBrowserCreated", browser2, function()
		showChat(false)
		data = jsonGET("rememberPassword", true)
		--outputDebugString("asd")
		web = loadBrowserURL(source, "http://mta/local/index.html")
		setTimer(function()
			--outputChatBox("asd")
			if data["rememberMe"] == 1 then
				
				executeBrowserJavascript(browser2, 'rememberMe("'.. data["username"]..'", "'.. data["password"]..'", "'..data["rememberMe"]..'");')
			end
		end,1000,1)
		guiSetInputEnabled(true)
	end
	)
end)

function rememberKey(button, state)
	if button == "backspace" and state and selectedInput and isCursorShowing() then 
		cancelEvent()
		if utf8.len(fakeInputs[selectedInput]) >= 1 then
		  fakeInputs[selectedInput] = utf8.sub(fakeInputs[selectedInput], 1, -2)
	
		  --searchAnim()
		end
	elseif button == "enter" and state and selectedInput and isCursorShowing() then 
		if fakeInputs[selectedInput] then 
			if utf8.len(fakeInputs[selectedInput]) > 0 then
				if utf8.find(fakeInputs[selectedInput], "@") and utf8.find(fakeInputs[selectedInput], ".") then 
					validationInput = false
				else
					exports.oInfobox:outputInfoBox("Adj meg egy valós email címet!","error")
				end
			else
				exports.oInfobox:outputInfoBox("Üresen nem hagyhatod ezt a mezőt!","error")
			end
		else 
			exports.oInfobox:outputInfoBox("Üresen nem hagyhatod ezt a mezőt!","error")
		end
	end
end


addEvent("rememberMeSelectedTab", true)
addEventHandler("rememberMeSelectedTab", getRootElement(), function(tab)
	selectedTab = tab
	validationInput = false
end)

function rememberMe(character)
	if isCursorShowing() and selectedInput then 
	  local selected = split(selectedInput, "|")
	  --print(selected[1])
	  --print(fakeInputs[selectedInput])
	  if utf8.len(fakeInputs[selectedInput]) < tonumber(selected[2]) then
		fakeInputs[selectedInput] = fakeInputs[selectedInput] .. character
		--searchAnim()
		--cancelEvent()
		
	  end
	end
  end
--addEventHandler("onClientCharacter", getRootElement(), rememberMe)

addEvent("emailForceChange", true)
addEventHandler("emailForceChange", getRootElement(), function(player)
	if isElement(browser) then 
		destroyElement(browser)
		browser = false
	end

	addEventHandler("onClientRender", getRootElement(), drawForceEmailChange)
	addEventHandler("onClientClick", getRootElement(), rememberClick)
	addEventHandler("onClientKey", getRootElement(), rememberKey)
	addEventHandler("onClientCharacter", getRootElement(), rememberMe)

end)

addEvent("closeEmailForce",true)
addEventHandler("closeEmailForce", getRootElement(), function()
	removeEventHandler("onClientRender", getRootElement(), drawForceEmailChange)
	removeEventHandler("onClientClick", getRootElement(), rememberClick)
	removeEventHandler("onClientKey", getRootElement(), rememberKey)
	removeEventHandler("onClientCharacter", getRootElement(), rememberMe)
end)

local panelW2,panelH2 = 300, 200
local panelX2, panelY2 = sx/2 - panelW2/2, sy/2 - panelH2/2

function drawForceEmailChange()
	dxDrawRectangle(panelX2, panelY2, panelW2, panelH2, tocolor(30, 30, 30, 150))
	dxDrawRectangle(panelX2 + 2, panelY2 + 2, panelW2 -4, panelH2-4, tocolor(35, 35, 35, 255))
	dxDrawRectangle(panelX2 + 2, panelY2 + 2, panelW2 - 4, 25, tocolor(30,30,30, 255))

	buttons = {}
	dxDrawText("Email cím változtatás", sx/2, panelY2, sx/2, panelY2 + 28, tocolor(255,255,255,150), 1, fonts["condensed-10"], "center", "center")
	dxDrawText("Kérlek változtasd meg az\nemail-címed amit használsz!\n\n#eb5146Fontos hogy hiteles email címet adj meg\n A későbbiekben szükséged lesz rá!", sx/2, panelY2 + 80, sx/2, panelY2 + 63, tocolor(255,255,255,150), 1, fonts["condensed-10"], "center", "center",false,false,false,true)
	drawInput("emailInput|50", "Email cím", panelX2 + 4, panelY2+120 + 4, panelW2 - 8, 25, fonts["condensed-10"],1, tocolor(30, 30, 30, 255), 1)
	core:dxDrawButton(panelX2 + 4, panelY2+ 120 + 25 +10 + 4 + 3, panelW2 - 8, 30, r, g, b, 200, "Megváltoztatás", tocolor(255, 255, 255, 255), 1, fonts["condensed-10"], true, tocolor(0, 0, 0, 50))
	buttons["confirmEmail"] = {panelX2 + 4, panelY2+ 120 + 25 +10 + 4 + 3, panelW2 - 8, 30}



	local relX, relY = getCursorPosition()

	activeButton = false

	if relX and relY then
		relX = relX * sx
		relY = relY * sy

		for k, v in pairs(buttons) do
			if relX >= v[1] and relX <= v[1] + v[3] and relY >= v[2] and relY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end
end

function drawInput(key, label, x, y, sx, sy, font, fontScale, color, a)
 -- a = a or 1

  if not fakeInputs[key] then
    fakeInputs[key] = ""
  end

  dxDrawRectangle(x, y, sx, sy, color)

  if selectedInput == key then
    if not inputLineGetStart[key] then
      inputLineGetInverse[key] = false
      inputLineGetStart[key] = getTickCount()
    end
  elseif inputLineGetStart[key] then
    inputLineGetInverse[key] = getTickCount()
    inputLineGetStart[key] = false
  end

  local lineProgress = 0

  if inputLineGetStart[key] then
    local elapsedTime = getTickCount() - inputLineGetStart[key]
    local progress = elapsedTime / 300

    lineProgress = interpolateBetween(
      0, 0, 0,
      1, 0, 0,
      progress, "Linear")
  elseif inputLineGetInverse[key] then
    local elapsedTime = getTickCount() - inputLineGetInverse[key]
    local progress = elapsedTime / 300

    lineProgress = interpolateBetween(
      1, 0, 0,
      0, 0, 0,
      progress, "Linear")
  end

  sy = sy - 2

  if utf8.len(fakeInputs[key]) > 0 then
    dxDrawText(fakeInputs[key], x + 3, y, x + sx - 3, y + sy, tocolor(255, 255, 255, 230 * a), fontScale, font, "left", "center", true)
  elseif label then
    dxDrawText(label, x, y, x+sx, y + sy, tocolor(255, 255, 255, 150 * a), fontScale, font, "center", "center", true)
  end

  if selectedInput == key then
    if inputCursorState then
      --outputChatBox("asd")
      local contentSizeX = dxGetTextWidth(fakeInputs[key], fontScale, font)

      dxDrawLine(x + 3 + contentSizeX, y + 5, x + 3 + contentSizeX, y + sy - 5, tocolor(230, 230, 230, 255 * a))
    end
    if getTickCount() - lastChangeCursorState >= 500 then
      inputCursorState = not inputCursorState
      lastChangeCursorState = getTickCount()
    end
  end

  buttons["input:" .. key] = {x, y, sx, sy}
end


--[[addEvent("startRecoveryPW",true)
addEventHandler("startRecoveryPW", getRootElement(), function()
	--outputChatBox("come back value = RecoveryPW")
	if isElement(browser) then 
		destroyElement(browser)
	end
	addEventHandler("onClientRender", getRootElement(), drawRememberRender)
	addEventHandler("onClientClick", getRootElement(), rememberClick)
	addEventHandler("onClientKey", getRootElement(), rememberKey)
	addEventHandler("onClientCharacter", getRootElement(), rememberMe)
end)
triggerEvent("startRecoveryPW",localPlayer)]]

local mehetaclick = true
local floodclick = 0

addEvent("dataToLua",true)
addEventHandler("dataToLua",getRootElement(),
	function(type,user,pass,pass2,email,inviteCode)
		if type == "login" then 
			
		elseif type == "register" then
			if mehetaclick then
				triggerServerEvent("registerOnServer", root, localPlayer,user, hash("sha256", "originalRoleplayAccount"..pass.."2k20"), hash("sha256", "originalRoleplayAccount"..pass2.."2k20"), email, inviteCode)
				mehetaclick = false 
				setTimer(function() mehetaclick= true end, 1000,1)
			else 
				floodclick = floodclick + 1
				if floodclick >= 6 then 
					triggerServerEvent("kickFlooder",root,localPlayer)
				end
			end
		end
	end
)




setTimer(function()
	if floodclick > 1 then 
		floodclick = floodclick - 1
	end
end, 
4000,0)

addEvent("javascriptNotification",true)
addEventHandler("javascriptNotification", getRootElement(),
	function(msg,type)
		exports.oInfobox:outputInfoBox(msg,type)
	end 
)

local baralpha = {200,150,215,100,125,255,150,180,120,210,220,230,200,150,120,190,200,180,230}

local loginPanelPage = "login"
local barHeight = sy*0.045

local loginpanelboxok = {
	["login"] = {
		{name = "username", displaytext = "Felhasználónév", icon = "user.png", secret = false, maxlen = 30, text = "", input = true, _edit = guiCreateEdit(0, 0, sx*0.2, barHeight, "", false)},
		{name = "password", displaytext = "Jelszó", icon = "pw.png", secret = true, showing = false, maxlen = 30, text = "", input = true, _edit = guiCreateEdit(0, 0, sx*0.2, barHeight, "", false)},
		{name = "savepw", displaytext = "Adatok megjegyzése", onoff = true, tick = true, animation = {getTickCount()}},
		{name = "loginbutton", displaytext = "Bejelentkezés", icon = "login.png", button = true},
	},

	["register"] = {
		{name = "username", displaytext = "Felhasználónév", icon = "user.png", secret = false, maxlen = 30, text = "", input = true,  _edit = guiCreateEdit(0, 0, sx*0.2, barHeight, "", false)},
		{name = "password", displaytext = "Jelszó", icon = "pw.png", secret = true, showing = false, maxlen = 30, text = "", input = true,  _edit = guiCreateEdit(0, 0, sx*0.2, barHeight, "", false)},
		{name = "password2", displaytext = "Jelszó x2", icon = "pw.png", secret = true, showing = false, maxlen = 30, text = "", input = true,  _edit = guiCreateEdit(0, 0, sx*0.2, barHeight, "", false)},
		{name = "email", displaytext = "E-mail", icon = "mail.png", secret = false, maxlen = 30, text = "", input = true,  _edit = guiCreateEdit(0, 0, sx*0.2, barHeight, "", false)},
		{name = "invitecode", displaytext = "Meghívó kód", icon = "invite.png", secret = false, maxlen = 30, text = "", input = true,  _edit = guiCreateEdit(0, 0, sx*0.2, barHeight, "", false)},
		{name = "registerbutton", displaytext = "Regisztráció", icon = "reg.png", button = true},
	},
}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		if getElementData(localPlayer,"user:loggedin") then return end

		triggerServerEvent("checkPlayerBanState", localPlayer)
		
		fadeCamera(true)
		setElementData(localPlayer,"user:loggedin",false)
		setElementDimension(localPlayer, dimId)
		showCursor(true)

		if savedatas == "true" then 
			
		else 

			for k, v in ipairs(loginpanelboxok["login"]) do 
				if v.name == "username" then 
					guiSetText(v._edit,"")
				elseif v.name == "password" then 
					guiSetText(v._edit,"")
				end 
			end
		end 

	end 
)

for k, v in ipairs(loginpanelboxok["login"]) do 
	if v._edit then 
		guiSetAlpha( v._edit, 0 )
		--guiMoveToBack(v._edit)
		guiEditSetMaxLength( v._edit, 40 )
		--guiSetVisible( v._edit, false )

	end
end

for k, v in ipairs(loginpanelboxok["register"]) do 
	if v._edit then 
		guiSetAlpha( v._edit, 0 )
		--guiMoveToBack(v._edit)
		guiEditSetMaxLength( v._edit, 45 )
	end
end

function saveData()
			destroy3dped()
		--fileDelete("index.html")

end 
addEventHandler("onClientResourceStop",resourceRoot,saveData)


local selectedv2Editbox = nil

local iconMargin = 12
local loginColors = {237, 145, 47}
local loginPanelShowing = true

local pointerTick = getTickCount()
local pointerShowing = false

local hoveverdInput = false

function renderLoginBack()
	dxDrawRectangle(0,0,sx,sy,tocolor(15, 15, 15, 220))

	-- V2 login panel
	if not renderRememberPanel then 

		dxDrawText("Elfelejtetted a jelszavadat? Kérj jelszóemlékeztetőt!", 10/myX*sx, 10/myX*sx, _, _, tocolor(255, 255, 255, 150), 1, fontscript:getFont("p_m", 13/myX*sx))
		dxDrawText("Jelszóemlékeztető", 10/myX*sx, 28/myX*sx, _, _, tocolor(loginColors[1], loginColors[2], loginColors[3], 150), 1, fontscript:getFont("p_bo", 13/myX*sx))

		local startY = sy*0.5 - (((barHeight + sy*0.005) * #loginpanelboxok[loginPanelPage] + (sy*0.02 * 2)) / 2)

		-- dxDrawLine(0, sy*0.5, sx, sy*0.5)

		dxDrawText("ORIGINAL ROLEPLAY", sx*0.435, startY, sx*0.6, startY, tocolor(loginColors[1], loginColors[2], loginColors[3], 240), 1, fontscript:getFont("p_ba", 17/myX*sx), "left", "center")
		dxDrawImage(sx*0.4, startY - sy*0.02, 50/myX*sx, 50/myX*sx, "img/logo.png", 0, 0, 0, tocolor(loginColors[1], loginColors[2], loginColors[3], 240))

		startY = startY + sy*0.02


		hoveverdInput = false 

		if loginPanelPage == "login" then 	
			dxDrawText("Bejelentkezés", sx*0.435, startY, sx*0.6, startY, tocolor(255, 255, 255, 240), 1, fontscript:getFont("p_m", 13/myX*sx), "left", "center")
			startY = startY + sy*0.02
		elseif loginPanelPage == "register" then 
			dxDrawText("Regisztráció", sx*0.435, startY, sx*0.6, startY, tocolor(255, 255, 255, 240), 1, fontscript:getFont("p_m", 13/myX*sx), "left", "center")
			startY = startY + sy*0.02
		end

		for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
			local panelIsHovered = false 

			if core:isInSlot(sx*0.4, startY, sx*0.2, barHeight) then 
				panelIsHovered = true 
				hoveverdInput = true
			end

			if v.input then
				dxDrawRectangle(sx*0.4, startY, sx*0.2, barHeight, tocolor(35, 35, 35, 245))
				guiSetPosition( v._edit, sx*0.4, startY, false)
			elseif v.button then
				if panelIsHovered then 
					dxDrawRectangle(sx*0.4, startY, sx*0.2, barHeight, tocolor(loginColors[1], loginColors[2], loginColors[3], 220))
				else
					dxDrawRectangle(sx*0.4, startY, sx*0.2, barHeight, tocolor(loginColors[1], loginColors[2], loginColors[3], 200))
				end
			elseif v.onoff then 
				dxDrawRectangle(sx*0.4, startY, sy*0.025, sy*0.025, tocolor(35, 35, 35, 245))
			end

			if v.input then

				local displayText = guiGetText(v._edit)
				local displayAlpha = 200

				--guiEditSetCaretIndex( v._edit, string.len( displayText ) )


				local textWidth = 0

				if displayText == "" and not (selectedv2Editbox == v.name) then 
					displayText = v.displaytext
					displayAlpha = 100
				else
					if v.secret then 
						if not v.showing then
							displayText = string.rep("*", string.len(displayText))
						end
					end

					textWidth = dxGetTextWidth(displayText, 1, fontscript:getFont("p_m", 11/myX*sx))

					if selectedv2Editbox == v.name then 
						if pointerTick + 400 < getTickCount() then 
							pointerTick = getTickCount()
							pointerShowing = not pointerShowing
						end

						if pointerShowing then
							displayText = displayText .. " |"
						end
					end
				end

				if panelIsHovered or selectedv2Editbox == v.name then 
					displayAlpha = displayAlpha + 40
				end

			
				local maxLen = 333 
				if v.secret then 
					maxLen = 300
				end

				if (textWidth/myX*sx > 333) then 
					dxDrawText(displayText, sx*0.4 + barHeight, startY, sx*0.595, startY + sy*0.045, tocolor(255, 255, 255, displayAlpha), 1, fontscript:getFont("p_m", 11/myX*sx), "right", "center", true)
				else
					dxDrawText(displayText, sx*0.4 + barHeight, startY, sx*0.595, startY + sy*0.045, tocolor(255, 255, 255, displayAlpha), 1, fontscript:getFont("p_m", 11/myX*sx), "left", "center")
				end
				dxDrawImage(sx*0.4 + iconMargin/myX*sx, startY + iconMargin/myY*sy, barHeight - (iconMargin*2)/myY*sy, barHeight - (iconMargin*2)/myY*sy, "img/v2_icons/"..v.icon, 0, 0, 0, tocolor(255, 255, 255, displayAlpha))

				if v.secret then 
					if core:isInSlot(sx*0.6 - barHeight + (iconMargin * 0.9)/myY*sy, startY + (iconMargin * 0.9)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy) then 
						dxDrawImage(sx*0.6 - barHeight + (iconMargin * 0.9)/myY*sy, startY + (iconMargin * 0.9)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy, "img/v2_icons/toggle.png", 0, 0, 0, tocolor(255, 255, 255, 140))
					else
						dxDrawImage(sx*0.6 - barHeight + (iconMargin * 0.9)/myY*sy, startY + (iconMargin * 0.9)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy, "img/v2_icons/toggle.png", 0, 0, 0, tocolor(255, 255, 255, 100))
					end
				end
			elseif v.button then 
				dxDrawText(v.displaytext, sx*0.4, startY, sx*0.6 - 30/myX*sx, startY + barHeight + sy*0.004, tocolor(255, 255, 255, 255), 1, fontscript:getFont("p_bo", 13/myX*sx), "center", "center")

				-- dxGetTextWidth(v.displaytext,1, fontscript:getFont("p_bo", 12/myX*sx)) + 
				dxDrawImage((sx*0.4 + sx*0.2 / 2) - 10/myX * sx + dxGetTextWidth(v.displaytext,1, fontscript:getFont("p_bo", 12/myX*sx))/2, startY + barHeight / 2 - 10/myX*sx, 20/myX*sx, 20/myX*sx, "img/v2_icons/"..v.icon, 0, 0, 0, tocolor(255, 255, 255, 255))

			elseif v.onoff then 
				dxDrawText(v.displaytext, sx*0.4 + sy*0.035, startY, sx*0.6, startY + sy*0.025, tocolor(255, 255, 255, 100), 1, fontscript:getFont("p_m", 11/myX*sx), "left", "center")

				if savedatas == "true" then 
					local animalpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - v.animation[1]) / 250, "Linear")
					dxDrawImage(sx*0.4, startY, sy*0.025, sy*0.025, "img/v2_icons/check.png", 0, 0, 0, tocolor(loginColors[1], loginColors[2], loginColors[3], 255 * animalpha))
				end
			end


			if v.onoff then 
				startY = startY  + sy*0.03
			else
				startY = startY + barHeight + sy*0.005
			end
		end

		if loginPanelPage == "login" then 
			dxDrawText("Nincs még felhasználód? Regisztrálj egyet!", sx*0.4, startY + sy*0.02, sx*0.6, startY + sy*0.02, tocolor(255, 255, 255, 100), 1, fontscript:getFont("p_r", 12/myX*sx), "center", "center")

			if core:isInSlot(sx*0.4, startY + sy*0.03, sx*0.2, sy*0.01) then 
				dxDrawText("Regisztráció", sx*0.4, startY + sy*0.035, sx*0.6, startY + sy*0.035, tocolor(loginColors[1], loginColors[2], loginColors[3], 240), 1, fontscript:getFont("p_m", 12/myX*sx), "center", "center")
			else
				dxDrawText("Regisztráció", sx*0.4, startY + sy*0.035, sx*0.6, startY + sy*0.035, tocolor(loginColors[1], loginColors[2], loginColors[3], 200), 1, fontscript:getFont("p_m", 12/myX*sx), "center", "center")
			end

			--dxDrawText("Nincs még felhasználód? Regisztrálj egyet!", sx*0.4, startY + sy*0.007, sx*0.6, startY + sy*0.007, tocolor(255, 255, 255, 100), 1, fontscript:getFont("p_m", 11/myX*sx), "center", "center")
		elseif loginPanelPage == "register" then 
			dxDrawText("Van már regisztrált fiókod?", sx*0.4, startY + sy*0.02, sx*0.6, startY + sy*0.02, tocolor(255, 255, 255, 100), 1, fontscript:getFont("p_r", 12/myX*sx), "center", "center")

			if core:isInSlot(sx*0.4, startY + sy*0.03, sx*0.2, sy*0.01) then 
				dxDrawText("Bejelentkezés", sx*0.4, startY + sy*0.035, sx*0.6, startY + sy*0.035, tocolor(loginColors[1], loginColors[2], loginColors[3], 240), 1, fontscript:getFont("p_m", 12/myX*sx), "center", "center")
			else
				dxDrawText("Bejelentkezés", sx*0.4, startY + sy*0.035, sx*0.6, startY + sy*0.035, tocolor(loginColors[1], loginColors[2], loginColors[3], 200), 1, fontscript:getFont("p_m", 12/myX*sx), "center", "center")
			end
		end

	end 
	--music 

	dxDrawRectangle(100/myX*sx,sy*0.975, (sx*0.15), sy*0.005,tocolor(200,200,200,100))

	if isInBox(100/myX*sx,sy*0.975, (sx*0.15), sy*0.005) then 
		dxDrawRectangle(100/myX*sx,sy*0.975, (sx*0.15)/1*soundVolume, sy*0.005,tocolor(200,200,200,150))
	else
		dxDrawRectangle(100/myX*sx,sy*0.975, (sx*0.15)/1*soundVolume, sy*0.005,tocolor(200,200,200,100))
	end


	if isElement(music) then
		local soundFFT = getSoundFFTData ( music, 16384, 16)
		if ( soundFFT ) and not musicSelecting then
			for i = 0, 15 do
				if soundFFT[i] ~= nil then 
					local numb = soundFFT[i] or 0
					local multipler = 2.0 * (soundVolume)
                	local sr = (numb * multipler) or 0
					if sr > 0 then
					--szamToMinus(math.sqrt( soundFFT[i] ) * (256*100/100))*0.2
						dxDrawRectangle (((sx*0.025)*i),sy, sx*0.025,szamToMinus(math.sqrt( soundFFT[i] ) * (256*100/100))*0.6,tocolor(255,255,255,((baralpha[i]) or 255) * 0.3))
					end
				end
			end
		end
	end

	if isInBox(30/myX*sx,sy*0.97, 15/myX*sx, 15/myX*sx) then 
		if soundState then 
			dxDrawImage(30/myX*sx,sy*0.97, 15/myX*sx, 15/myX*sx,"img/pause.png",0,0,0,tocolor(255,255,255,255))
		else
			dxDrawImage(30/myX*sx,sy*0.97, 15/myX*sx, 15/myX*sx,"img/play.png",0,0,0,tocolor(255,255,255,255))
		end
	else
		if soundState then
			dxDrawImage(30/myX*sx,sy*0.97, 15/myX*sx, 15/myX*sx,"img/pause.png",0,0,0,tocolor(255,255,255,100))
		else
			dxDrawImage(30/myX*sx,sy*0.97, 15/myX*sx, 15/myX*sx,"img/play.png",0,0,0,tocolor(255,255,255,100))
		end
	end

	if isInBox(50/myX*sx,sy*0.97,15/myX*sx, 15/myX*sx) then 
		dxDrawImage(50/myX*sx,sy*0.97,15/myX*sx, 15/myX*sx,"img/next-track.png",0,0,0,tocolor(255,255,255,255))
	else
		dxDrawImage(50/myX*sx,sy*0.97,15/myX*sx, 15/myX*sx,"img/next-track.png",0,0,0,tocolor(255,255,255,100))
	end

	if isInBox(10/myX*sx,sy*0.97,15/myX*sx, 15/myX*sx) then 
		dxDrawImage(10/myX*sx,sy*0.97,15/myX*sx, 15/myX*sx,"img/next-track.png",180,0,0,tocolor(255,255,255,255))
	else
		dxDrawImage(10/myX*sx,sy*0.97,15/myX*sx, 15/myX*sx,"img/next-track.png",180,0,0,tocolor(255,255,255,100))
	end

	dxDrawImage(80/myX*sx,sy*0.97,15/myX*sx, 15/myX*sx,"img/v2_icons/volume.png",0,0,0,tocolor(255,255,255,100))
	--dxDrawRectangle(sx*0.005, sy*0.03, sx*0.075, sy*0.025 ,tocolor(255,255,255,100))
	
	local musicText = musics[tonumber(selectedmusic)][2]
	dxDrawText(musicText, 10/myX*sx, sy*0.94, _, _, tocolor(255,255,255,100), 1, fontscript:getFont("p_bo", 19/myX*sx))

	if soundEditing then 
		local cx, cy = getCursorPosition()
		katt = ((80/myX)-(cx))*7
		katt = math.abs(katt)

		if katt > 1 then 
			katt = 1 
		end

		soundVolume = katt

		if cx <= 0.8475 then 
			soundVolume = 0
		else 
			setSoundVolume(music,soundVolume)
		end
	end 

end

function keyLoginV2(key, state)
	cancelEvent()
	if selectedv2Editbox then
	--s	cancelEvent()
	end

	if state then 
		local startY = sy*0.5 - (((barHeight + sy*0.005) * #loginpanelboxok[loginPanelPage] + (sy*0.02 * 2)) / 2) + sy*0.04

		for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
			if key == "mouse1" then
				if not renderRememberPanel then
					if v.input then
						if v.secret then 
							if core:isInSlot(sx*0.6 - barHeight + (iconMargin * 0.9)/myY*sy, startY + (iconMargin * 0.9)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy) then 
								v.showing = not v.showing
							end
						end

						if core:isInSlot(sx*0.4, startY, sx*0.2, barHeight) then 
							outputChatBox("a")
							selectedv2Editbox = v.name 
							--for i = 1, 200 do 
								guiBringToFront( v._edit )
								guiFocus(v._edit)
								guiEditSetCaretIndex( v._edit, string.len( guiGetText(v._edit) ) )

							--end
							break
						
						else
							selectedv2Editbox = false
						end
					elseif v.onoff then 
						if core:isInSlot(sx*0.4, startY, sy*0.025, sy*0.025) then
							if savedatas == "true" then 
								v.animation = {getTickCount()}
								savedatas = "false"
							else 
								v.animation = {getTickCount()}
								savedatas = "true"
							end 
						end
					elseif v.button then 
						if core:isInSlot(sx*0.4, startY, sx*0.2, barHeight) then 
							if v.name == "loginbutton" then 
							--	if checkActiveEditboxValues() then 
									if mehetaclick then
										if (getElementData(localPlayer, "model:isLoading") or false) then exports.oInfobox:outputInfoBox("Amíg a modellek töltődnek nem tudsz bejelentkezni!","error") return end


										local user = false 
										local pass = false 

										for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
											if v.name == "username" then 
												user = guiGetText(v._edit)
											elseif v.name == "password" then 
												pass = guiGetText(v._edit)
											end
										end
										outputChatBox(user)

										if user and pass then
											triggerServerEvent("loginOnServer", root, localPlayer, user, hash("sha256", "originalRoleplayAccount"..pass.."2k20"))
											mehetaclick = false 
											setTimer(function() mehetaclick= true end, 1000,1)
										end
									else 
										floodclick = floodclick + 1
										if floodclick >= 6 then 
											triggerServerEvent("kickFlooder",root,localPlayer)
										end
									end
							--	end
							elseif v.name == "registerbutton" then 
								if checkActiveEditboxValues() then 
									if mehetaclick then
										if (getElementData(localPlayer, "model:isLoading") or false) then exports.oInfobox:outputInfoBox("Amíg a modellek töltődnek nem tudsz regisztrálni!","error") return end


										local user = false 
										local pass = false 
										local pass2 = false 
										local email = false 
										local invite = false

										for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
											if v.name == "username" then 
												user = guiGetText(v._edit)
											elseif v.name == "password" then 
												pass = guiGetText(v._edit)
											elseif v.name == "password2" then 
												pass2 = guiGetText(v._edit)
											elseif v.name == "email" then 
												email = guiGetText(v._edit)
											elseif v.name == "invitecode" then 
												invite = guiGetText(v._edit)
											end
										end

										if user and pass then
											triggerServerEvent("registerOnServer", root, localPlayer,user, hash("sha256", "originalRoleplayAccount"..pass.."2k20"), hash("sha256", "originalRoleplayAccount"..pass2.."2k20"), email, inviteCode)
											mehetaclick = false 
											setTimer(function() mehetaclick= true end, 1000,1)
										end
									else 
										floodclick = floodclick + 1
										if floodclick >= 6 then 
											triggerServerEvent("kickFlooder",root,localPlayer)
										end
									end
								end
							end
						end
					end
				end
			end
	
			if v.onoff then 
				startY = startY  + sy*0.03
			else
				startY = startY + barHeight + sy*0.005
			end
		end

		if key == "tab" then 
			if charCreateState == 1 then 
				if active_editbox < 6 then 
					active_editbox = active_editbox + 1					
				else
					active_editbox = 1
				end
			end

			if loginPanelPage == "login" then 
				for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
					if v.input then 
						if selectedv2Editbox == v.name then 
							selectedv2Editbox = "password"

						elseif selectedv2Editbox == "password" then 
							selectedv2Editbox = "username"
						
						end 
					end 
				end 
			elseif loginPanelPage == "register" then 
				for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
					if v.input then 
						if selectedv2Editbox == "username" then 
							selectedv2Editbox = "password"
						elseif selectedv2Editbox == "password" then 
							selectedv2Editbox = "password2"
						elseif selectedv2Editbox == "password2" then 
							selectedv2Editbox = "email"
						elseif selectedv2Editbox == "email" then 
							selectedv2Editbox = "invitecode"
						elseif selectedv2Editbox == "invitecode" then 
							selectedv2Editbox = "username"
						end 
						outputChatBox(tostring(selectedV2Editbox))
					end 
				end
			end

		end

		if key == "mouse1" then
				
			if core:isInSlot(sx*0.005, sy*0.03, sx*0.075, sy*0.025 ) then 
				if not renderRememberPanel then 
				renderRememberPanel = true 
					addEventHandler("onClientRender", getRootElement(), drawRememberRender)
					addEventHandler("onClientClick", getRootElement(), rememberClick)
					addEventHandler("onClientKey", getRootElement(), rememberKey)
					addEventHandler("onClientCharacter", getRootElement(), rememberMe)
				end
			end 
			
		end 
	
		if key == "mouse1" then 
			if core:isInSlot(sx*0.4, startY + sy*0.03, sx*0.2, sy*0.01) then 
				if not hoveverdInput then
					if loginPanelPage == "login" then 	
						loginPanelPage = "register"	
					elseif loginPanelPage == "register" then 	
						loginPanelPage = "login"
					end
				end
			end
		end

		if selectedv2Editbox then 
			for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
				if v.name == selectedv2Editbox then 
					if not tiltottgombok[key] then 
						playRandomKeySound()

						--[[cancelEvent()
						key = key:gsub("num_", "")
					
						if string.len(v.text) < v.maxlen then
							if getKeyState("lshift") or getKeyState("rshift") then 
								key = string.upper( key )
							end

							if getKeyState("lctrl") and getKeyState("lalt") then 
								if key == "v" then 
									key = "@"
								elseif key == "c" then 
									key = "&"
								elseif key == "x" then 
									key = "#" 
								elseif key == "y" then 
									key = ">"
								elseif key == "í" then 
									key = "<"
								end
							end

							v.text = v.text .. key
						end]]
					elseif key == "backspace" then 
						--v.text = v.text:sub(1, -2)
						playRandomKeySound()
					end
				end
			end			
		end
	end
end

local keySounds = {"k1.mp3", "k2.mp3", "k3.mp3"}
function playRandomKeySound()
	playSound("sounds/"..keySounds[math.random(#keySounds)])
end

function checkActiveEditboxValues()
	-- adatok ellenőrzése

	return true
end

-----------------------------------character create -------------------------------
local charCreateShow = false

local active_editbox = 1
local selected_tevekenyseg = 1
local selected_nem = 1
local selected_skin = 1

local charCreateState = 1
local charCreateStateOld = 0

local selected_avatar = 1

local Player3dView

local editboxok = {
	{""}, -- Karakter keresztneve
	{""}, -- Karakter vezetékneve
	{""}, -- Születési hely 
	{""}, -- életkor
	{""}, -- magasság
	{""}, -- súly 
}

local editbok_posok = {
	{sx*0.425,sy*0.38,sx*0.15,sy*0.045},
	{sx*0.425,sy*0.43,sx*0.15,sy*0.045},
	{sx*0.425,sy*0.48,sx*0.15,sy*0.045},
	{sx*0.427,sy*0.53,sx*0.045,sy*0.045},
	{sx*0.477,sy*0.53,sx*0.045,sy*0.045},
	{sx*0.527,sy*0.53,sx*0.045,sy*0.045},
}

local editNames = {"Keresztnév", "Vezetéknév", "Születési hely","Életkor", "Magasság", "Súly"}

function renderCharCreate()
	dxDrawRectangle(0,0,sx,sy,tocolor(25,25,25,220))
	if charCreateState == 1 then -- alap adatok
		dxDrawText("Karaktered főbb adatai",sx*0.425,sy*0.345,sx*0.425+sx*0.15,sy*0.345+sy*0.045,tocolor(255,255,255,255),1/myX*sx,fonts["bebasneue"],"center","center")
		for k, v in ipairs(editboxok) do 

			local text = v[1]
			local utotag = ""

			if k == 4 then 
				utotag = "év"
			elseif k == 5 then 
				utotag = "cm"
			elseif k == 6 then 
				utotag = "kg"
			end

			if text == "" then 
				text = editNames[k] 
				utotag = ""
			end

			dxDrawRectangle(editbok_posok[k][1],editbok_posok[k][2],editbok_posok[k][3],editbok_posok[k][4],tocolor(30,30,30,240))
			dxDrawText(text.." "..utotag,editbok_posok[k][1],editbok_posok[k][2],editbok_posok[k][1]+editbok_posok[k][3],editbok_posok[k][2]+editbok_posok[k][4],tocolor(200,200,200,200),1/myX*sx,fonts["font"],"center","center")

			if active_editbox == k then 
				dxDrawOutLine(editbok_posok[k][1],editbok_posok[k][2],editbok_posok[k][3],editbok_posok[k][4],tocolor(r,g,b,255),1)
			end
		end
	elseif charCreateState == 2 then -- tulajdonságok
		dxDrawText("Karaktered tulajdonságai",sx*0.425,sy*0.345,sx*0.425+sx*0.15,sy*0.345+sy*0.045,tocolor(255,255,255,255),1/myX*sx,fonts["bebasneue"],"center","center")
		dxDrawText("Kedvenc tevékenység",sx*0.425,sy*0.37,sx*0.425+sx*0.15,sy*0.37+sy*0.045,tocolor(255,255,255,255),0.7/myX*sx,fonts["bebasneue"],"center","center")

		dxDrawText(kedvenc_tevekenyseg[selected_tevekenyseg],sx*0.425,sy*0.46,sx*0.425+sx*0.15,sy*0.46+sy*0.045,tocolor(255,255,255,255),1/myX*sx,fonts["font"],"center","center")
		if kedvenc_tevekenyseg[selected_tevekenyseg+1] then 
			dxDrawText(kedvenc_tevekenyseg[selected_tevekenyseg+1],sx*0.425,sy*0.48,sx*0.425+sx*0.15,sy*0.48+sy*0.045,tocolor(255,255,255,150),0.95/myX*sx,fonts["font"],"center","center")
		end
		if kedvenc_tevekenyseg[selected_tevekenyseg-1] then 
			dxDrawText(kedvenc_tevekenyseg[selected_tevekenyseg-1],sx*0.425,sy*0.44,sx*0.425+sx*0.15,sy*0.44+sy*0.045,tocolor(255,255,255,150),0.95/myX*sx,fonts["font"],"center","center")
		end

		if isInBox(sx*0.49,sy*0.518,sx*0.0187,sy*0.03) then 
			dxDrawImage(sx*0.49,sy*0.518,sx*0.0187,sy*0.03,"img/arrow.png",90,0,0,tocolor(r,g,b,255))
		else
			dxDrawImage(sx*0.49,sy*0.518,sx*0.0187,sy*0.03,"img/arrow.png",90,0,0,tocolor(200,200,200,255))
		end

		if isInBox(sx*0.49,sy*0.42,sx*0.0187,sy*0.03) then 
			dxDrawImage(sx*0.49,sy*0.42,sx*0.0187,sy*0.03,"img/arrow.png",270,0,0,tocolor(r,g,b,255))
		else
			dxDrawImage(sx*0.49,sy*0.42,sx*0.0187,sy*0.03,"img/arrow.png",270,0,0,tocolor(200,200,200,255))
		end
	elseif charCreateState == 3 then -- kinézet
		dxDrawText("Karaktered kinézete",sx*0.425,sy*0.305,sx*0.425+sx*0.15,sy*0.305+sy*0.045,tocolor(255,255,255,255),1/myX*sx,fonts["bebasneue"],"center","center")

		if selected_nem == 1 or isInBox(sx*0.425,sy*0.48,sx*0.018,sy*0.03) then 
			dxDrawImage(sx*0.425,sy*0.48,sx*0.018,sy*0.03,"img/no.png",0,0,0,tocolor(227, 154, 227))
		else
			dxDrawImage(sx*0.425,sy*0.48,sx*0.018,sy*0.03,"img/no.png",0,0,0,tocolor(255,255,255,200))
		end

		if selected_nem == 2 or isInBox(sx*0.425,sy*0.52,sx*0.018,sy*0.03) then 
			dxDrawImage(sx*0.425,sy*0.52,sx*0.018,sy*0.03,"img/ferfi.png",0,0,0,tocolor(154, 210, 227))
		else
			dxDrawImage(sx*0.425,sy*0.52,sx*0.018,sy*0.03,"img/ferfi.png",0,0,0,tocolor(255,255,255,200))
		end

		if isInBox(sx*0.56,sy*0.48,sx*0.0156,sy*0.027) then 
			dxDrawImage(sx*0.56,sy*0.48,sx*0.0156,sy*0.027,"img/arrow.png",0,0,0,tocolor(r,g,b,255))
		else
			dxDrawImage(sx*0.56,sy*0.48,sx*0.0156,sy*0.027,"img/arrow.png",0,0,0,tocolor(255,255,255,200))
		end

		if isInBox(sx*0.56,sy*0.52,sx*0.018,sy*0.03) then 
			dxDrawImage(sx*0.56,sy*0.52,sx*0.0156,sy*0.027,"img/arrow.png",180,0,0,tocolor(r,g,b,255))
		else
			dxDrawImage(sx*0.56,sy*0.52,sx*0.0156,sy*0.027,"img/arrow.png",180,0,0,tocolor(255,255,255,200))
		end
	elseif charCreateState == 4 then -- avatar
		dxDrawText("Avatár beállítása",sx*0.425,sy*0.345,sx*0.425+sx*0.15,sy*0.345+sy*0.045,tocolor(255,255,255,255),1/myX*sx,fonts["bebasneue"],"center","center")
		
		if fileExists("avatars/"..(selected_avatar-1)..".png") then 
			dxDrawImage(sx*0.4465,sy*0.455,sx*0.03125,sy*0.055,"avatars/"..(selected_avatar-1)..".png",0,0,0,tocolor(255,255,255,200))
		else
			dxDrawImage(sx*0.4465,sy*0.455,sx*0.03125,sy*0.055,"avatars/50.png",0,0,0,tocolor(255,255,255,200))
		end

		dxDrawImage(sx*0.48,sy*0.45,sx*0.0375,sy*0.066,"avatars/"..selected_avatar..".png",0,0,0,tocolor(255,255,255,255))

		if fileExists("avatars/"..(selected_avatar+1)..".png") then 
			dxDrawImage(sx*0.52,sy*0.455,sx*0.03125,sy*0.055,"avatars/"..(selected_avatar+1)..".png",0,0,0,tocolor(255,255,255,200))
		else
			dxDrawImage(sx*0.52,sy*0.455,sx*0.03125,sy*0.055,"avatars/1.png",0,0,0,tocolor(255,255,255,200))
		end
	end

	dxDrawRectangle(sx*0.45,sy*0.58,sx*0.1,sy*0.045,tocolor(30,30,30,240))
	dxDrawRectangle(0,sy*0.99,sx*1,sy*0.2,tocolor(30,30,30,240))

	local lineHossz = interpolateBetween(sx/4*charCreateStateOld,0,0,sx/4*charCreateState,0,0,(getTickCount() - tick)/1000,"Linear")
	dxDrawRectangle(0,sy*0.992,lineHossz,sy*0.05,tocolor(r,g,b,240))

	if isInBox(sx*0.45,sy*0.58,sx*0.1,sy*0.045) then 
		dxDrawOutLine(sx*0.45,sy*0.58,sx*0.1,sy*0.045,tocolor(r,g,b,255),1)
	end

	if not ( charCreateState == 4 ) then 
		dxDrawText("Folytatás",sx*0.45,sy*0.58,sx*0.45+sx*0.1,sy*0.58+sy*0.045,tocolor(255,255,255,200),1/myX*sx,fonts["font"],"center","center")
	else
		dxDrawText("Karakter létrehozása",sx*0.45,sy*0.58,sx*0.45+sx*0.1,sy*0.58+sy*0.045,tocolor(255,255,255,200),1/myX*sx,fonts["font"],"center","center")
	end
end 

local camindex = 1
local animationTime = 120000

addEvent("successfulLogin", true)
addEventHandler("successfulLogin", root,
	function(type)
		if type == "login" then 
		--	outputChatBox("a")
			removeEventHandler("onClientRender",root,renderLoginBack)
			removeEventHandler("onClientKey", root, keyLoginV2)

			if isElement(browser) then 
				destroyElement(browser)
--				destroyElement(browser2)
			end
			browser = false
			browser2 = false

			loadPanelAlpha = 1
			logoAlpha = 0 
			logoAnimationType = 1
			panelBgAnimation = 1
			loadPanelAlpha = 0
			selectedLoadText = 1


			tick_load = getTickCount()
			alpha_tick = getTickCount() 
			logoAnimTick = getTickCount()
			addEventHandler("onClientRender",root,charLoadAnimation)

			guiSetInputEnabled(false)
			showCursor(false)

			setElementAlpha(localPlayer, 200)
			for k, v in ipairs(getElementsByType("vehicle")) do 
				setElementCollidableWith(localPlayer, v,  false)
			end

			setTimer(function()
				setElementAlpha(localPlayer, 255)
				for k, v in ipairs(getElementsByType("vehicle")) do 
					setElementCollidableWith(localPlayer, v,  true)
				end
			end, loadtimes[2]+15000, 1)

			for k, v in ipairs(loginpanelboxok["login"]) do 
				if v._edit then 
					destroyElement( v._edit)
				end
			end
			
			for k, v in ipairs(loginpanelboxok["register"]) do 
				if v._edit then 
					destroyElement( v._edit)
				end
			end
		elseif type == "createChar" then 
			addEventHandler("onClientRender", root, renderCharCreate)
			removeEventHandler("onClientRender", root, renderLoginBack)
			removeEventHandler("onClientKey", root, keyLoginV2)

			tick = getTickCount()

			charCreateShow = true
			exports.oInfobox:outputInfoBox("Nincs karaktered! Hozz létre egyet!","info")
			
			for k,v in ipairs(hatter_cams) do 
				if k == 1 then 
					smoothMoveCamera(hatter_cams[k][1],hatter_cams[k][2],hatter_cams[k][3],hatter_cams[k][4],hatter_cams[k][5],hatter_cams[k][6],hatter_cams[k+1][1],hatter_cams[k+1][2],hatter_cams[k+1][3],hatter_cams[k+1][4],hatter_cams[k+1][5],hatter_cams[camindex+1][6],animationTime)
				else 
					if hatter_cams[k+1] then 
						local timer = setTimer(function() smoothMoveCamera(hatter_cams[k][1],hatter_cams[k][2],hatter_cams[k][3],hatter_cams[k][4],hatter_cams[k][5],hatter_cams[k][6],hatter_cams[k+1][1],hatter_cams[k+1][2],hatter_cams[k+1][3],hatter_cams[k+1][4],hatter_cams[k+1][5],hatter_cams[k+1][6],animationTime) end, animationTime*k, 1)
						table.insert(camera_timers,k-1,timer)
					end
				end
			end

			guiSetInputEnabled(false)
			showCursor(true)
			showChat(false)
		end

		for k, v in pairs(temp_objects) do 
			destroyElement(v)
		end
		
		if isTimer(clockTimer) then 
			killTimer(clockTimer)
		end

		setSoundPaused(music,true)
		setTimer(function() browser = false end, 50, 1)

		if isElement(browser) then 
			destroyElement(browser)
		end
	end 
)

local usingShift = false
local clapslockState = false

addEventHandler("onClientKey",root,
	function(key,state)
		if state and charCreateShow then

			if key == "mouse1" then 
				
				if charCreateState == 1 then -- alap adatok
					for k, v in ipairs(editboxok) do 
						if isInBox(editbok_posok[k][1],editbok_posok[k][2],editbok_posok[k][3],editbok_posok[k][4]) then 
							active_editbox = k
						end
					end
				elseif charCreateState == 2 then -- tulajdonságok
					if isInBox(sx*0.49,sy*0.518,sx*0.0187,sy*0.03) then 
						if selected_tevekenyseg < #kedvenc_tevekenyseg then 
							selected_tevekenyseg = selected_tevekenyseg + 1
						end
					end
			
					if isInBox(sx*0.49,sy*0.42,sx*0.0187,sy*0.03) then 
						if selected_tevekenyseg > 1 then 
							selected_tevekenyseg = selected_tevekenyseg - 1
						end
					end
				elseif charCreateState == 3 then -- kinézet
					if isInBox(sx*0.425,sy*0.48,sx*0.018,sy*0.03) then 
						selected_nem = 1
						selected_skin = 1
						updatePlayerSkin()
					end
			
					if isInBox(sx*0.425,sy*0.52,sx*0.018,sy*0.03) then 
						selected_nem = 2
						selected_skin = 1
						updatePlayerSkin()
					end

					if isInBox(sx*0.56,sy*0.48,sx*0.0156,sy*0.027) then 
						if selected_skin < #skins[selected_nem] then 
							selected_skin = selected_skin + 1 
							updatePlayerSkin()
						end
					end
			
					if isInBox(sx*0.56,sy*0.52,sx*0.0156,sy*0.027) then 
						if selected_skin > 1 then 
							selected_skin = selected_skin - 1
							updatePlayerSkin()
						end
					end
				elseif charCreateState == 4 then -- avatar
					if isInBox(sx*0.4465,sy*0.455,sx*0.03125,sy*0.055) then 
						if selected_avatar > 1 then 
							selected_avatar = selected_avatar - 1
						else
							selected_avatar = 50
						end
					end
			
			
					if isInBox(sx*0.52,sy*0.455,sx*0.03125,sy*0.055) then 
						if selected_avatar < 50 then 
							selected_avatar = selected_avatar + 1
						else
							selected_avatar = 1
						end
					end
				end

				if isInBox(sx*0.45,sy*0.58,sx*0.1,sy*0.045) then 
					if not ( charCreateState == 4 ) then 
						if charCreateState == 1 then 
							if string.len(editboxok[1][1]) >= 3 then 
								if string.len(editboxok[2][1]) >= 3 then 
									if string.len(editboxok[3][1]) >= 3 then 
										if tonumber(editboxok[4][1]) >= 18 and tonumber(editboxok[4][1]) <= 99 then 
											if tonumber(editboxok[6][1]) >= 40 then 
												if not (tonumber(editboxok[5][1]) >= 135) then 
													infobox:outputInfoBox("A karaktered magasságának meg kell haladnia a 100cm-t!","error")
													return
												end
											else
												infobox:outputInfoBox("A karaktered súlyának meg kell haladnia a 30kg-ot!","error")
												return
											end
										else
											infobox:outputInfoBox("A karaktered életkorának meg kell haladnia a 18 évet!","error")
											return
										end
									else
										infobox:outputInfoBox("A születési helyednek meg kell haladnia a 3 karaktert!","error")
										return
									end
								else
									infobox:outputInfoBox("A karaktered vezetéknevének minimum 3 betűből kell állnia!","error")
									return
								end
							else
								infobox:outputInfoBox("A karaktered keresztnevének minimum 3 betűből kell állnia!","error")
								return
							end
						elseif charCreateState == 2 then 
						elseif charCreateState == 3 then 
						end
						charCreateStateOld = charCreateState
						charCreateState = charCreateState + 1
						tick = getTickCount()

						if charCreateState == 3 then 
							create3dped()
							setElementModel(localPlayer,skins[selected_nem][selected_skin])
						else
							destroy3dped()
						end
					else
						startCharLoadAnimation()
						createCharacter()
					end
				end
			end

			if not tiltottgombok[key] then
				if #editboxok[active_editbox][1] <= 28 then
					if usingShift then

						if active_editbox == 1 or active_editbox == 2 or active_editbox == 3  then
							if not szamok[key] then
								local betu = (key:gsub("num_","")):gsub("^%l", string.upper)
								local szoveg = editboxok[active_editbox][1]..betu
								editboxok[active_editbox][1] = szoveg
							end
						end

					else 
						if active_editbox == 1 or active_editbox == 2 or active_editbox == 3 then
							if not szamok[key] then
								if clapslockState then 
									key = string.upper(key)
								end
								local szoveg = (editboxok[active_editbox][1]..key:gsub("num_",""))
								editboxok[active_editbox][1] = szoveg
							end
						else
							if szamok[key] then 
								local hosszusag = 3 

								if active_editbox == 4 then 
									hosszusag = 2
								end
								
								if #editboxok[active_editbox][1] < hosszusag then
									if editboxok[active_editbox][1] == "" then
										if key == "0" or key == "num_0" then 
											return 
										end
									end
									local betu = (key:gsub("num_",""))
									local szoveg = editboxok[active_editbox][1]..betu
									editboxok[active_editbox][1] = szoveg
								end
							end
						end
					end
				end
			end

			if key == "backspace" then 
				editboxok[active_editbox][1] = editboxok[active_editbox][1]:gsub("[^\128-\191][\128-\191]*$", "")
			end

			if key == "space" then 
				editboxok[active_editbox][1] = editboxok[active_editbox][1].." "
			end
		end

		if state and loginPanelShowing then 
			if key == "mouse1" then 
				if isInBox(30/myX*sx,sy*0.97, 15/myX*sx, 15/myX*sx) then 
					if soundState then 
						setSoundPaused(music,true)
						soundState = false 
					else
						setSoundPaused(music,false)
						soundState = true 
					end 
				end 

				if isInBox(sx*0.029,sy*0.966,sx*0.0125,sy*0.022) then  --zene+
					if selectedmusic < #musics then 
						selectedmusic = selectedmusic + 1
						musicSelecting = true  
					else
						selectedmusic = 1
					end
					updateSong()
				end
			
				if isInBox(sx*0.005,sy*0.966,sx*0.0125,sy*0.022) then --zene-
					if selectedmusic > 1 then 
						selectedmusic = selectedmusic - 1
						musicSelecting = true
					else
						selectedmusic = #musics
					end
					updateSong()
				end
			end
		end

		if loginPanelShowing then 
			if key == "mouse_wheel_down" then 
				if isInBox(100/myX*sx,sy*0.975, (sx*0.15), sy*0.005) then 
					if soundVolume > 0 then 
						soundVolume = soundVolume - 0.01
						setSoundVolume(music,soundVolume)
					elseif soundVolume <= 0.01 then 
						setTimer(function()
							soundVolume = 0
						end,1000,1)
					end
				end
			end

			if key == "mouse_wheel_up" then 
				if isInBox(100/myX*sx,sy*0.975, (sx*0.15), sy*0.005) then 
					if soundVolume < 1 then 
						soundVolume = soundVolume + 0.01
						setSoundVolume(music,soundVolume)
					end
				end
			end

			--[[if state then 
				if key == "mouse1" then 
					if isInBox(100/myX*sx,sy*0.975, (sx*0.15), sy*0.005) then 
						soundEditing = true
					end
				end
			else
				if key == "mouse1" then 
					soundEditing = false
				end
			end]]
		end

		if key == "lshift" or key == "rshift" then 
			if state then 
				usingShift = true 
			else 
				usingShift = false
			end
		end

		if key == "capslock" then 
			if state then 
				clapslockState = not clapslockState
			end
		end
	end 
)

function create3dped()
    Player3dView = exports.oPreview:createObjectPreview(localPlayer, 0, 0, 180, sx*0.42,sy*0.28, 300*rel, 350*rel, false, true)
end

function update3dped()
    destroy3dped()
    create3dped()
end

function destroy3dped()
	exports.oPreview:destroyObjectPreview(Player3dView)
end

function updatePlayerSkin()
	setElementModel(localPlayer,skins[selected_nem][selected_skin])
	update3dped()
end

function updateSong()
	setSoundPaused(music,true)
	music = playSound("music/"..musics[selectedmusic][1]..".mp3",true)
	setSoundVolume(music,soundVolume)
	soundState = true
	if isElement(music) then
		setTimer(function()
			musicSelecting = false
		end,1000,1)
		
	end
end

function createCharacter()
	------------------------------------------------- játékos ------------------név--------------------------születési hely----------------életkor-------------------magasság-------------------súly-----------------szabadidős tev.--neme-------------kinézet,------------------------------avatar
	triggerServerEvent("createCharacterOnServer",root,localPlayer,editboxok[1][1].."_"..editboxok[2][1],editboxok[3][1]:gsub(" ","_"),tonumber(editboxok[4][1]),tonumber(editboxok[5][1]),tonumber(editboxok[6][1]),selected_tevekenyseg,selected_nem,skins[selected_nem][selected_skin],selected_avatar)
end

function dxDrawOutLine(x,y,w,h,color,size)
	dxDrawLine(x,y,x+w,y,color,size)
	dxDrawLine(x,y,x,y+h,color,size)
	dxDrawLine(x,y+h,x+w,y+h,color,size)
	dxDrawLine(x+w,y,x+w,y+h,color,size)
end

function isInBox(x, y, w, h)
    if isCursorShowing( ) then
        local cx,cy = getCursorPosition(  )
        cx, cy = cx*sx, cy*sy
        if cx>=x and cx<=x+w and cy>=y and cy<=y+h then
            return true
        end
        return false
    else
        return false
    end
end
-------------------------------------------//////////-------------------------------

local voltvaltozas = false
local selected_tipp_text = 1

function charLoadAnimation()

	local load = interpolateBetween(0.05,0,0,1,0,0,(getTickCount()-tick_load)/loadtimes[2],"Linear")

	if panelBgAnimation == 1 then 
		if load == 1 then 
			panelBgAnimation = 2
			alpha_tick = getTickCount() 
			setCameraTarget(localPlayer,localPlayer)
		end

		loadPanelAlpha = interpolateBetween(0,0,0,1,0,0,(getTickCount()-alpha_tick)/500,"Linear")
	else
		loadPanelAlpha = interpolateBetween(1,1,1,0,0,0,(getTickCount()-alpha_tick)/1500,"Linear")

		if loadPanelAlpha == 0 then 
			removeEventHandler("onClientRender",root,charLoadAnimation)
			showCursor(false)
			showChat(true)
		end
	end


	dxDrawRectangle(0,0,sx,sy,tocolor(35,35,35,255*loadPanelAlpha))

	dxDrawRectangle(0,sy*0.99,sx*load,sy,tocolor(r,g,b,255*loadPanelAlpha))
	dxDrawText(math.floor(load*100).."%",0,sy*0.99,0+sx*load,sy*0.99+sy*0.0125,tocolor(35,35,35,255*loadPanelAlpha),0.65/myX*sx,fonts["font"],"center","center")

	if logoAnimationType == 1 then 

		if logoAlpha == 1 then 
			logoAnimTick = getTickCount()
			logoAnimationType = 2
		else
			logoAlpha = interpolateBetween(0,0,0,1,0,0,(getTickCount()-logoAnimTick)/2500,"Linear")
		end
	else
		if logoAlpha == 0 then 
			logoAnimTick = getTickCount()
			logoAnimationType = 1
		else
			logoAlpha = interpolateBetween(1,0,0,0,0,0,(getTickCount()-logoAnimTick)/2500,"Linear")
		end

	end

	dxDrawImage(0,0,sx,sy,"img/logo2.png",0,0,0,tocolor(255,255,255,255*loadPanelAlpha))

	dxDrawImage(0,0,sx,sy,"img/logo1.png",0,0,0,tocolor(255,255,255,255*logoAlpha*loadPanelAlpha))

	dxDrawText(loading_texts[selected_tipp_text],0,sy*0.85,sx,sy*0.85+sy*0.05,tocolor(r,g,b,255*logoAlpha*loadPanelAlpha),0.8/myX*sx,fonts["font2"],"center","center")

	if logoAlpha < 0.05 then 
		if not volt then 
			if selected_tipp_text == #loading_texts then 
				selected_tipp_text = 1 
			else
				selected_tipp_text = selected_tipp_text + 1 
			end
		end
	end

	if volt then 
		if logoAlpha > 9.95 then 
			volt = false
		end
	end
end

function resetCharCreation() 
	addEventHandler("onClientRender", root, renderCharCreate)
	charCreateShow = true
	charCreateState = 1
	removeEventHandler("onClientRender",root,charLoadAnimation)

	for k,v in ipairs(hatter_cams) do 
		if k == 1 then 
			smoothMoveCamera(hatter_cams[k][1],hatter_cams[k][2],hatter_cams[k][3],hatter_cams[k][4],hatter_cams[k][5],hatter_cams[k][6],hatter_cams[k+1][1],hatter_cams[k+1][2],hatter_cams[k+1][3],hatter_cams[k+1][4],hatter_cams[k+1][5],hatter_cams[camindex+1][6],animationTime)
		else 
			if hatter_cams[k+1] then 
				local timer = setTimer(function() smoothMoveCamera(hatter_cams[k][1],hatter_cams[k][2],hatter_cams[k][3],hatter_cams[k][4],hatter_cams[k][5],hatter_cams[k][6],hatter_cams[k+1][1],hatter_cams[k+1][2],hatter_cams[k+1][3],hatter_cams[k+1][4],hatter_cams[k+1][5],hatter_cams[k+1][6],animationTime) end, animationTime*k, 1)
				table.insert(camera_timers,k-1,timer)
			end
		end
	end

	active_editbox = 1

	guiSetInputEnabled(false)
	showCursor(true)
	showChat(false)
end
addEvent("resetCharCreatByReason",true)
addEventHandler("resetCharCreatByReason",root,resetCharCreation)

function startCharLoadAnimation()

	loadPanelAlpha = 1
	logoAlpha = 0 
	logoAnimationType = 1
	panelBgAnimation = 1
	loadPanelAlpha = 0
	selectedLoadText = 1

	tick_load = getTickCount()
	alpha_tick = getTickCount() 
	logoAnimTick = getTickCount()
	charCreateShow = false
	removeEventHandler("onClientRender", root, renderCharCreate)
	addEventHandler("onClientRender",root,charLoadAnimation)

	removeBgAnimation()
end 

function removeBgAnimation() 
	removeCamHandler() 

	for k, v in ipairs(camera_timers) do 
		if isTimer(v) then 
			killTimer(v)
		end
	end
end

local ban_datas = {"", "", "", "", "", ""}

function renderBanPanel() 
	local pA = interpolateBetween(0,0,0,1,0,0,(getTickCount()-alpha_tick)/500, "Linear")


	
	dxDrawRectangle(0,0,sx,sy,tocolor(35,35,35,255*pA))

		--music 

		dxDrawRectangle(sx*0.845,sy*0.9,sx*0.2,sy*0.08,tocolor(30,30,30,255))
		dxDrawRectangle(sx*0.8475,sy*0.89,sx*0.15,sy*0.015,tocolor(30,30,30,255))
	
		if isInBox(sx*0.8475,sy*0.89,(sx*0.15),sy*0.015) then 
			dxDrawRectangle(sx*0.8475,sy*0.89,(sx*0.15)/1*soundVolume,sy*0.015,tocolor(200,200,200,250))
		else
			dxDrawRectangle(sx*0.8475,sy*0.89,(sx*0.15)/1*soundVolume,sy*0.015,tocolor(200,200,200,200))
		end
	
		if (math.floor(soundVolume*100)) > 45 then 
			dxDrawText((math.floor(soundVolume*100)).."%",sx*0.8475,sy*0.89,sx*0.8475+sx*0.15,sy*0.89+sy*0.015,tocolor(30,30,30,255),0.7/myX*sx,fonts["font"],"center","center")
		else
			dxDrawText((math.floor(soundVolume*100)).."%",sx*0.8475,sy*0.89,sx*0.8475+sx*0.15,sy*0.89+sy*0.015,tocolor(200,200,200,255),0.7/myX*sx,fonts["font"],"center","center")
		end
		if isElement(music) then
			local soundFFT = getSoundFFTData ( music, 16384, 16)
			if ( soundFFT ) and not musicSelecting then
				for i = 0, 15 do
					if soundFFT[i] ~= nil then 
						local numb = soundFFT[i] or 0
						local multipler = 2.0 * (soundVolume)
						local sr = (numb * multipler) or 0
						if sr > 0 then
						--szamToMinus(math.sqrt( soundFFT[i] ) * (256*100/100))*0.2
							dxDrawRectangle ( (sx*0.845)+((sx*0.01)*i),sy*0.9+sy*0.08, sx*0.01,szamToMinus(math.sqrt( soundFFT[i] ) * (256*100/100))*0.2,tocolor(255,255,255,(baralpha[i]) or 255))
						end
					end
				end
			end
		end
	
		if isInBox(sx*0.91,sy*0.93,sx*0.01875,sy*0.033) then 
			if soundState then 
				dxDrawImage(sx*0.91,sy*0.93,sx*0.01875,sy*0.033,"img/pause.png",0,0,0,tocolor(255,255,255,255))
			else
				dxDrawImage(sx*0.91,sy*0.93,sx*0.01875,sy*0.033,"img/play.png",0,0,0,tocolor(255,255,255,255))
			end
		else
			if soundState then
				dxDrawImage(sx*0.91,sy*0.93,sx*0.01875,sy*0.033,"img/pause.png",0,0,0,tocolor(255,255,255,100))
			else
				dxDrawImage(sx*0.91,sy*0.93,sx*0.01875,sy*0.033,"img/play.png",0,0,0,tocolor(255,255,255,100))
			end
		end
	
		if isInBox(sx*0.937,sy*0.935,sx*0.0125,sy*0.022) then 
			dxDrawImage(sx*0.937,sy*0.935,sx*0.0125,sy*0.022,"img/arrow.png",0,0,0,tocolor(255,255,255,255))
		else
			dxDrawImage(sx*0.937,sy*0.935,sx*0.0125,sy*0.022,"img/arrow.png",0,0,0,tocolor(255,255,255,100))
		end
	
		if isInBox(sx*0.89,sy*0.935,sx*0.0125,sy*0.022) then 
			dxDrawImage(sx*0.89,sy*0.935,sx*0.0125,sy*0.022,"img/arrow.png",180,0,0,tocolor(255,255,255,255))
		else
			dxDrawImage(sx*0.89,sy*0.935,sx*0.0125,sy*0.022,"img/arrow.png",180,0,0,tocolor(255,255,255,100))
		end
		
		local musicText = musics[selectedmusic][2]
		dxDrawText(musicText,sx*0.845,sy*0.9,sx*0.845+sx*0.15,sy*0.9+sy*0.04,tocolor(255,255,255,255),0.8/myX*sx,fonts["font"],"center","center")
	
		if soundEditing then 
			local cx, cy = getCursorPosition()
			katt = ((0.8475)-(cx))*7
			katt = math.abs(katt)
	
			if katt > 1 then 
				katt = 1 
			end
	
			soundVolume = katt
	
			if cx <= 0.8475 then 
				soundVolume = 0
			else 
				setSoundVolume(music,soundVolume)
			end
		end

	local logoAlpha = interpolateBetween(1,0,0,0,0,0,(getTickCount()-logoAnimTick)/4000, "CosineCurve")

	--dxDrawImage(0,0,sx,sy,"img/logo2.png",0,0,0,tocolor(255,255,255,255*pA))

	--dxDrawImage(0,0,sx,sy,"img/logo1.png",0,0,0,tocolor(255,255,255,255*logoAlpha))

	dxDrawText("Ki lettél tilva a szerverről!", 0, sy*0.1, sx, sy*0.1+sy*0.1, tocolor(255, 0, 0, 255*logoAlpha), 1/myX*sx, fonts["bebasneue-35"], "center", "center")
	dxDrawRectangle(sx*0.357, sy*0.35, sx*0.286, sy*0.3, tocolor(40, 40, 40, 220*pA))

	local starty = sy*0.355
	for i = 1, #ban_menus do 
		local color
		local color2 

		if i%2 == 0 then 
			color = tocolor(r, g, b, 100*pA)
			color2 = tocolor(42, 42, 42, 250*pA)
		else
			color = tocolor(r, g, b, 250*pA)
			color2 = tocolor(45, 45, 45, 250*pA)
		end

		dxDrawRectangle(sx*0.36, starty, sx*0.28, sy*0.04, color2)
		dxDrawRectangle(sx*0.36, starty, sx*0.001, sy*0.04, color)

		dxDrawText(ban_menus[i]..":", sx*0.365, starty, sx*0.365+sx*0.28, starty+sy*0.04, tocolor(220, 220, 220, 255*pA), 1/myX*sx, fonts["condensed-11"], "left", "center")

		--[[local text = ban_datas[i]

		if i == 3 then 
			local date = fromJSON(ban_datas[i])
			text = (date["year"]+1900)..". "..(date["month"]+1)..". "..date["monthday"]..". "..date["hour"]..":"..date["minute"]..":"..date["second"]	
		elseif i == 4 then 
			local date = fromJSON(ban_datas[i])
			text = (date["year"]+1900)..". "..(date["month"]+1)..". "..date["monthday"]..". "..date["hour"]..":"..date["minute"]..":"..date["second"]	
		end]]
		local text = "false"
		if i == 1 then 
			text = ban_datas.adminName
		elseif i == 2 then 
			text = ban_datas.banReason		
		elseif i == 3 then 
			text = formatDate("Y/m/d h:i:s", "'", tostring(ban_datas.banTimestamp))		
		elseif i == 4 then 
			text = formatDate("Y/m/d h:i:s", "'", tostring(ban_datas.expireTimestamp))		
		elseif i == 5 then 
			text = ban_datas.playerSerial		
		elseif i == 6 then 
			text = ban_datas.playerName
		end
		dxDrawText(text, sx*0.355, starty, sx*0.355+sx*0.28, starty+sy*0.04, tocolor(r, g, b, 255*pA), 1/myX*sx, fonts["condensed-11"], "right", "center")
		starty = starty + sy*0.05
	end
end


local weekDays = {"Vasárnap", "Hétfő", "Kedd", "Szerda", "Csütörtök", "Péntek", "Szombat"}

function formatDate(format, escaper, timestamp)
	escaper = escaper or "'"
	escaper = string.sub(escaper, 1, 1)

	local time = getRealTime(timestamp)
	local formattedDate = ""
	local escaped = false

	time.year = time.year + 1900
	time.month = time.month + 1
	
	local datetime = {
		d = string.format("%02d", time.monthday),
		h = string.format("%02d", time.hour),
		i = string.format("%02d", time.minute),
		m = string.format("%02d", time.month),
		s = string.format("%02d", time.second),
		w = string.sub(weekDays[time.weekday + 1], 1, 2),
		W = weekDays[time.weekday + 1],
		y = string.sub(tostring(time.year), -2),
		Y = time.year
	}
	
	for char in string.gmatch(format, ".") do
		if char == escaper then
			escaped = not escaped
		else
			formattedDate = formattedDate .. (not escaped and datetime[char] or char)
		end
	end
	
	return formattedDate
end


function startBanPanelRender(data) 
	ban_datas = data
	showChat(false)
	addEventHandler("onClientRender", root, renderBanPanel)
	addEventHandler("onClientKey", getRootElement(), musicHandler)
	loadPanelAlpha = 1
	logoAlpha = 0 
	logoAnimationType = 1
	panelBgAnimation = 1
	loadPanelAlpha = 0
	selectedLoadText = 1

	if isTimer(clockTimer) then 
		killTimer(clockTimer)
	end
	local saveFile = xmlLoadFile("data.xml")

	selectedmusic= math.random(1, #musics)

	if xmlFindSubNode ( saveFile, "volume", 0 ) then 
		local node = xmlFindSubNode( saveFile, "volume", 0 )
		soundVolume = tonumber(xmlNodeGetValue ( node ))
	else
		soundVolume = 1
	end
	xmlUnloadFile(saveFile)

	music = playSound("music/"..musics[selectedmusic][1]..".mp3",true)
	setSoundVolume(music,soundVolume)
		--setSoundPosition(music, 5.1)

	guiSetInputEnabled(false)

	tick_load = getTickCount()
	alpha_tick = getTickCount() 
	logoAnimTick = getTickCount()
end

function musicHandler(key, state)
	if key == "mouse1" then 
		if state then
			if isInBox(sx*0.91,sy*0.93,sx*0.01875,sy*0.033) then 
				if soundState then 
					setSoundPaused(music,true)
					soundState = false 
				else 
					setSoundPaused(music,false)
					soundState = true 
				end 
			end
			if isInBox(sx*0.029,sy*0.966,sx*0.0125,sy*0.022) then  --zene+
				if selectedmusic < #musics then 
					selectedmusic = selectedmusic + 1
					musicSelecting = true
				else
					selectedmusic = 1
				end
				updateSong()
			end
		
			if isInBox(sx*0.005,sy*0.966,sx*0.0125,sy*0.022) then --zene-
				if selectedmusic > 1 then 
					selectedmusic = selectedmusic - 1
					musicSelecting = true
				else
					selectedmusic = #musics
				end
				updateSong()
			end

			if key == "mouse_wheel_down" then 
				if isInBox(sx*0.8475,sy*0.89,(sx*0.15),sy*0.015) then 
					if soundVolume > 0 then 
						soundVolume = soundVolume - 0.01
						setSoundVolume(music,soundVolume)
					end
				end
			end

			if key == "mouse_wheel_up" then 
				if isInBox(sx*0.8475,sy*0.89,(sx*0.15),sy*0.015) then 
					if soundVolume < 1 then 
						soundVolume = soundVolume + 0.01
						setSoundVolume(music,soundVolume)
					end
				end
			end
		end
		
		if state then 
			if key == "mouse1" then 
				if isInBox(sx*0.8475,sy*0.89,(sx*0.15),sy*0.015) then 
					soundEditing = true
				end
			end
		--	outputChatBox("b")
		else
			if key == "mouse1" then 
			--	outputChatBox("a")
				soundEditing = false
			end
		end
	end
end

addEvent("banPanel -> render", true)
addEventHandler("banPanel -> render", root, function(banDatas)
	ban_datas = banDatas
	startBanPanelRender()

	removeEventHandler("onClientRender",root,renderLoginBack)
	removeEventHandler("onClientKey", root, keyLoginV2)

	loadPanelAlpha = 1
	logoAlpha = 0 
	logoAnimationType = 1
	panelBgAnimation = 1
	loadPanelAlpha = 0
	selectedLoadText = 1

	tick_load = getTickCount()
	alpha_tick = getTickCount() 
	logoAnimTick = getTickCount()

	guiSetInputEnabled(false)
	showCursor(false)

	if isTimer(clockTimer) then 
		killTimer(clockTimer)
	end
	setSoundPaused(music,true)

	destroyElement(browser)
	browser = false
end)
------------------------------------------------------------------------------------

function szamToMinus(number)
    return number - (number*2)
end

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end

exports.oAdmin:addAdminCMD("setaccountstate", 6, "Felhasználói fiók státuszának állítása.")

local databaseAccounts = {}
local databaseCharacters = {}

addEvent("recieveDatabaseDataCharacter",true)
addEventHandler("recieveDatabaseDataCharacter", getRootElement(), function(key,data)
	--databaseAccounts = data1
	databaseCharacters[key] = data
end)

addEvent("recieveDatabaseDataAccounts",true)
addEventHandler("recieveDatabaseDataAccounts", getRootElement(), function(key,data)
	--databaseAccounts = data1
	databaseAccounts[key] = data
end)



function getPlayerAccountsTableC(player, id)
	return databaseAccounts[id]
end

function getPlayerCharactersTableC(player, id)
	return databaseCharacters[id]
end