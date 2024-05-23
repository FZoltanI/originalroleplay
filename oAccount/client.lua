

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oDashboard" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oCarshop" or getResourceName(res) == "oFont" then  
        infobox = exports.oInfobox
		core = exports.oCore
		color,r,g,b = exports.oCore:getServerColor()
		fontscript = exports.oFont
	end
end)

sx, sy = guiGetScreenSize()
myX,myY = 1600,900
rel = ((sx/1920)+(sy/1080))/2

renderRememberPanel = false -- jelszó emlékeztető panel render 
emailChangeShowing = false -- email change panel látszik-e
local savedatas = false -- Adatok mentése? ne itt változtasd

-- Zeneválasztó --
local selectedmusic = 1
local music
local soundState = true
local musicSelecting = false
local soundVolume = 1
local soundEditing = false
------------------

local dimId = getElementData(localPlayer, "playerid") or 1

local tick = getTickCount()
local spinnerRot = 0 -- karakter létrehozás töltéséhez kell
local charLoadAnimationShowing = false

fonts = {
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

local ban_datas = false -- ban infók

local temp_objects = {}

local pendingCharCreate = false

addEvent("receiveBanState",true)
addEventHandler("receiveBanState", getRootElement(), function(data)
	if data.isActive == "Y" then 
		fadeCamera(true)
		setElementPosition(localPlayer, 3750, 3750, 1500)
		setElementFrozen(localPlayer, true)
		startBanPanelRender(data)
	else 
		showLoginPanel()
	end
end)

function showLoginPanel()
	showChat(false)
	createLoginBGObjects()
		
	addEventHandler("onClientKey", root, keyLoginV2)
	addEventHandler("onClientRender",root,renderLoginV2)
	
	
	local musicInfo = exports.oJSON:loadDataFromJSONFile("loginMusic", true)

	if musicInfo then 
		selectedmusic, soundVolume = unpack(musicInfo)
	else 
		selectedmusic= math.random(1, #musics)
		soundVolume = 1
	end

	music = playSound("music/"..musics[selectedmusic][1]..".mp3",true)
	setSoundVolume(music,soundVolume)
	setSoundPosition(music, 5.1)
end

function createLoginBGObjects()
	local randcam = math.random(#cams)
	local camera = setCameraMatrix(cams[randcam][1],cams[randcam][2],cams[randcam][3],cams[randcam][4],cams[randcam][5],cams[randcam][6])

	for k,v in ipairs(loginElements[randcam]) do
		if v[1] == "ped" then 
			local ped = createPed(v[2],v[3],v[4],v[5],v[6])
			setElementDimension(ped, dimId)

			if v[7] then 
				setPedAnimation(ped, v[7][1], v[7][2], -1, true, false)
			end

			if v.weapon then 
				givePedWeapon(ped, v.weapon[1])
				setPedWeaponSlot(ped, v.weapon[2])
			end

			if v.warpToVeh then 
				warpPedIntoVehicle( ped, temp_objects[v.warpToVeh])
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
end





local mehetaclick = true
local floodclick = 0

setTimer(function()
	if floodclick > 1 then 
		floodclick = floodclick - 1
	end
end, 
4000,0)



----------------------------
-- INNEN KEZDŐDIK A LOGIN --
----------------------------

local baralpha = {200,150,215,100,125,255,150,180,120,210,220,230,200,150,120,190,200,180,230}

local loginPanelPage = "login"
local barHeight = sy*0.045

local loginpanelboxok = {
	["login"] = {
		{name = "username", displaytext = "Felhasználónév", icon = "user.png", secret = false, maxlen = 30, text = "", input = true},
		{name = "password", displaytext = "Jelszó", icon = "pw.png", secret = true, showing = false, maxlen = 30, text = "", input = true},
		{name = "savepw", displaytext = "Adatok megjegyzése", onoff = true, tick = true, animation = {getTickCount()}},
		{name = "loginbutton", displaytext = "Bejelentkezés", icon = "login.png", button = true},
	},

	["register"] = {
		{name = "username", displaytext = "Felhasználónév", icon = "user.png", secret = false, maxlen = 30, text = "", input = true},
		{name = "password", displaytext = "Jelszó", icon = "pw.png", secret = true, showing = false, maxlen = 30, text = "", input = true},
		{name = "password2", displaytext = "Jelszó x2", icon = "pw.png", secret = true, showing = false, maxlen = 30, text = "", input = true},
		{name = "email", displaytext = "E-mail", icon = "mail.png", secret = false, maxlen = 30, text = "", input = true},
		{name = "invitecode", displaytext = "Meghívó kód", icon = "invite.png", secret = false, maxlen = 30, text = "", input = true},
		{name = "registerbutton", displaytext = "Regisztráció", icon = "reg.png", button = true},
	},

	["char_create"] = {
		{name = "charname", displaytext = "Karaktered neve", icon = "name.png", secret = false, maxlen = 30, text = "", input = true},
		{name = "borncity", displaytext = "Születési hely", icon = "borncity.png", secret = false, maxlen = 30, text = "", input = true},
		{name = "age", displaytext = "Életkor", icon = "age.png", secret = false, maxlen = 30, text = "", input = true, suffix = "év"},
		{name = "weight", displaytext = "Súly", icon = "weight.png", secret = false, maxlen = 30, text = "", input = true, suffix = "kg"},
		{name = "height", displaytext = "Magasság", icon = "height.png", secret = false, maxlen = 30, text = "", input = true, suffix = "cm"},
	}
}

local loginpanelEditbox = guiCreateEdit(-sx*0.2, 0, sx*0.2, barHeight, "", false) -- ez az edit kezeli az összes input mezőt
guiEditSetMaxLength(loginpanelEditbox, 45)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		triggerServerEvent("checkPlayerBanState", localPlayer)
		
		fadeCamera(true)
		setElementData(localPlayer,"user:loggedin",false)
		setElementDimension(localPlayer, dimId)
		showCursor(true)

		savedatas = fromJSON(exports.oJSON:loadDataFromJSONFile("loginSavePW", true))

		if savedatas == true then 
			local savedValues = exports.oJSON:loadDataFromJSONFile("loginDatas", true)
			if savedValues then 
				local savedUsername, savedPassword = unpack(savedValues)
				loginpanelboxok["login"][1].text = savedUsername
				loginpanelboxok["login"][2].text = savedPassword
			end
		end 

	end 
)

local selectedv2Editbox = nil

local iconMargin = 12
local loginColors = {237, 145, 47}
local loginPanelShowing = true

local pointerTick = getTickCount()
local pointerShowing = false

local hoveverdInput = false

function renderLoginV2()
	guiBringToFront(loginpanelEditbox)
	guiEditSetCaretIndex(loginpanelEditbox, string.len(guiGetText(loginpanelEditbox)))

	dxDrawRectangle(0,0,sx,sy,tocolor(15, 15, 15, 220))

	-- V2 login panel
	if not renderRememberPanel and not emailChangeShowing then 

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
				local displayText = v.text
				local displayAlpha = 200

				local textWidth = 0

				if (selectedv2Editbox == v.name) then 
					v.text = guiGetText(loginpanelEditbox)
				end

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

				if savedatas == true then 
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

	if soundEditing then -- ZENE HANGERŐ ÁLLÍTÁS
		local cx, cy = getCursorPosition()
		local newMusicValue = math.max(0, math.min((cx*sx - 100/myX*sx)/(sx*0.15), 1))
		updateSongSoundLevel(newMusicValue)

		if newMusicValue == 0 then 
			soundEditing = false 
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
				if not renderRememberPanel and not emailChangeShowing then
					if v.input then
						if v.secret then 
							if core:isInSlot(sx*0.6 - barHeight + (iconMargin * 0.9)/myY*sy, startY + (iconMargin * 0.9)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy, barHeight - ((iconMargin * 0.9)*2)/myY*sy) then 
								v.showing = not v.showing
							end
						end

						if core:isInSlot(sx*0.4, startY, sx*0.2, barHeight) then 
							selectedv2Editbox = v.name 
							guiSetText(loginpanelEditbox, v.text)
							--for i = 1, 200 do 
								--guiBringToFront( v._edit )
								--guiFocus(v._edit)
								--guiEditSetCaretIndex( v._edit, string.len( guiGetText(v._edit) ) )

							--end
							break
						
						else
							selectedv2Editbox = false
						end
					elseif v.onoff then 
						if core:isInSlot(sx*0.4, startY, sy*0.025, sy*0.025) then
							v.animation = {getTickCount()}
							savedatas = not savedatas
							exports.oJSON:saveDataToJSONFile(toJSON(savedatas), "loginSavePW", true)

							if savedatas then 
								exports.oJSON:saveDataToJSONFile({loginpanelboxok["login"][1].text, loginpanelboxok["login"][2].text}, "loginDatas", true)
							else
								exports.oJSON:saveDataToJSONFile({"", ""}, "loginDatas", true)
							end
						end
					elseif v.button then 
						if core:isInSlot(sx*0.4, startY, sx*0.2, barHeight) then 
							if v.name == "loginbutton" then 
								if mehetaclick then
									if (getElementData(localPlayer, "model:isLoading") or false) then exports.oInfobox:outputInfoBox("Amíg a modellek töltődnek nem tudsz bejelentkezni!","error") return end


									local user = false 
									local pass = false 

									for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
										if v.name == "username" then 
											user = v.text
										elseif v.name == "password" then 
											pass = v.text
										end
									end
									--outputChatBox(user)

									if user and pass then
										if savedatas then 
											exports.oJSON:saveDataToJSONFile({loginpanelboxok["login"][1].text, loginpanelboxok["login"][2].text}, "loginDatas", true)
										end

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
							elseif v.name == "registerbutton" then 
								if mehetaclick then
									if (getElementData(localPlayer, "model:isLoading") or false) then exports.oInfobox:outputInfoBox("Amíg a modellek töltődnek nem tudsz regisztrálni!","error") return end

									local user = false 
									local pass = false 
									local pass2 = false 
									local email = false 
									local invite = false

									for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
										if v.name == "username" then 
											user = v.text
										elseif v.name == "password" then 
											pass = v.text
										elseif v.name == "password2" then 
											pass2 = v.text
										elseif v.name == "email" then 
											email = v.text
										elseif v.name == "invitecode" then 
											invite = v.text
										end
									end

									if user and pass and string.len(user) >= 3 and string.len(pass) >= 5 and string.len(pass2) >= 5 and string.len(email) >= 5 then
										if pass == pass2 then 
											triggerServerEvent("registerOnServer", root, localPlayer,user, hash("sha256", "originalRoleplayAccount"..pass.."2k20"), hash("sha256", "originalRoleplayAccount"..pass2.."2k20"), email, inviteCode)
											mehetaclick = false 
											setTimer(function() mehetaclick= true end, 1000,1)
										else 
											exports.oInfobox:outputInfoBox("A két jelszó nem egyezik meg!","error")
										end 
									else 
										exports.oInfobox:outputInfoBox("Kötelező megadnod 3 karakternél hosszabb felhasználó nevet és 5 karakternél hosszabb jelszót!","error")
										exports.oInfobox:outputInfoBox("Ugyan ezek vonatkoznak a Jelszó 2x és az Email mezőre is!","error")
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
	
			if v.onoff then 
				startY = startY  + sy*0.03
			else
				startY = startY + barHeight + sy*0.005
			end
		end

		if key == "tab" then 
			if loginPanelPage == "login" then 
				if selectedv2Editbox == "username" then 
					selectedv2Editbox = "password"
				elseif selectedv2Editbox == "password" then 
					selectedv2Editbox = "username"
				end 

				for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
					if v.input then 
						if selectedv2Editbox == v.name then 
							guiSetText(loginpanelEditbox, v.text)
							break
						end
					end 
				end
			elseif loginPanelPage == "register" then 
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

				for k, v in ipairs(loginpanelboxok[loginPanelPage]) do 
					if v.input then 
						if selectedv2Editbox == v.name then 
							guiSetText(loginpanelEditbox, v.text)
							break
						end
					end 
				end
			end
		end

		if key == "mouse1" then
			if core:isInSlot(sx*0.005, sy*0.03, sx*0.075, sy*0.025 ) then 
				if not renderRememberPanel then 
					renderRememberPanel = true 
					addEventHandler("onClientRender", getRootElement(), drawForgotPassword)
					addEventHandler("onClientClick", getRootElement(), forgotPasswordClick)
					addEventHandler("onClientKey", getRootElement(), rememberKey)
					addEventHandler("onClientCharacter", getRootElement(), rememberMe)
				end
			end 

			if core:isInSlot(sx*0.4, startY + sy*0.03, sx*0.2, sy*0.01) then 
				if not hoveverdInput then
					if loginPanelPage == "login" then 	
						loginPanelPage = "register"	
					elseif loginPanelPage == "register" then 	
						loginPanelPage = "login"
					end
				end
			end
			
			-- hang állítás
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

			if isInBox(100/myX*sx,sy*0.975, (sx*0.15), sy*0.005) then 
				soundEditing = true
			end
		end 
	else
		if key == "mouse_wheel_down" then 
			if isInBox(100/myX*sx,sy*0.975, (sx*0.15), sy*0.005) then 
				if soundVolume > 0 then 
					updateSongSoundLevel(soundVolume - 0.01)
				elseif soundVolume <= 0.01 then
					updateSongSoundLevel(0)
				end
			end
		end

		if key == "mouse_wheel_up" then 
			if isInBox(100/myX*sx,sy*0.975, (sx*0.15), sy*0.005) then 
				if soundVolume < 1 then 
					updateSongSoundLevel(soundVolume + 0.01)
				end
			end
		end


		if key == "mouse1" then 
			soundEditing = false
		end

	end
end

local keySounds = {"k1.mp3", "k2.mp3", "k3.mp3"}
function playRandomKeySound()
	playSound("sounds/"..keySounds[math.random(#keySounds)])
end

addEventHandler("onClientGUIChanged", loginpanelEditbox, function()
	if selectedv2Editbox then
		if not (guiGetText(source) == "") then
			if not (guiGetText(source) == getActiveEditboxText()) then
				playRandomKeySound()
			end
		end
	end
end)

function getActiveEditboxText()
	for k, v in pairs(loginpanelboxok) do 
		for k2, v2 in ipairs(v) do
			if v2.name == selectedv2Editbox then
				return v2.text
			end
		end
	end
	return false
end

-----------------------------------character create -------------------------------
local charCreateShow = false
local selected_nem = 1
local selected_skin = 1
local charCreateState = 1
local selected_avatar = 1
local selectedStartPos = 1
local charCreatePed = nil

function renderCharCreate()
	guiBringToFront(loginpanelEditbox)
	guiEditSetCaretIndex(loginpanelEditbox, string.len(guiGetText(loginpanelEditbox)))

	dxDrawImage(0, 0, sx, sy, "bg.png", 0, 0, 0, tocolor(255, 255, 255, 200))

	dxDrawText("ORIGINAL ROLEPLAY", sx*0.135, sy*0.2, sx*0.6, sy*0.2, tocolor(loginColors[1], loginColors[2], loginColors[3], 240), 1, fontscript:getFont("p_ba", 17/myX*sx), "left", "center")
	dxDrawImage(sx*0.1, sy*0.2 - sy*0.02, 50/myX*sx, 50/myX*sx, "img/logo.png", 0, 0, 0, tocolor(loginColors[1], loginColors[2], loginColors[3], 240))
	dxDrawText("Karakter létrehozás", sx*0.135, sy*0.22, sx*0.6, startY, tocolor(255, 255, 255, 240), 1, fontscript:getFont("p_m", 13/myX*sx), "left", "center")

	local startY = sy*0.25
	for k, v in ipairs(loginpanelboxok["char_create"]) do 
		local panelIsHovered = false 

		if core:isInSlot(sx*0.1, startY, sx*0.2, barHeight) then 
			panelIsHovered = true 
			hoveverdInput = true
		end

		if v.input then
			dxDrawRectangle(sx*0.1, startY, sx*0.2, barHeight, tocolor(35, 35, 35, 245))
		end

		if v.input then
			local displayText = v.text
			local displayAlpha = 200

			local textWidth = 0

			if (selectedv2Editbox == v.name) then 
				v.text = guiGetText(loginpanelEditbox)
			end

			if displayText == "" and not (selectedv2Editbox == v.name) then 
				displayText = v.displaytext
				displayAlpha = 100
			else
				textWidth = dxGetTextWidth(displayText, 1, fontscript:getFont("p_m", 11/myX*sx))

				if selectedv2Editbox == v.name then 
					if pointerTick + 400 < getTickCount() then 
						pointerTick = getTickCount()
						pointerShowing = not pointerShowing
					end

					if pointerShowing then
						displayText = displayText .. " |"
					end
				else
					if v.suffix then 
						displayText = displayText .. color .. " " .. v.suffix
					end
				end
			end

			if panelIsHovered or selectedv2Editbox == v.name then 
				displayAlpha = displayAlpha + 40
			end

		
			local maxLen = 333 


			if (textWidth/myX*sx > 333) then 
				dxDrawText(displayText, sx*0.1 + barHeight, startY, sx*0.595, startY + sy*0.045, tocolor(255, 255, 255, displayAlpha), 1, fontscript:getFont("p_m", 11/myX*sx), "right", "center", true, false, false, true)
			else
				dxDrawText(displayText, sx*0.1 + barHeight, startY, sx*0.595, startY + sy*0.045, tocolor(255, 255, 255, displayAlpha), 1, fontscript:getFont("p_m", 11/myX*sx), "left", "center", false, false, false, true)
			end
			dxDrawImage(sx*0.1 + iconMargin/myX*sx, startY + iconMargin/myY*sy, barHeight - (iconMargin*2)/myY*sy, barHeight - (iconMargin*2)/myY*sy, "img/v2_icons/"..v.icon, 0, 0, 0, tocolor(255, 255, 255, displayAlpha))
		end

		startY = startY + barHeight + sy*0.005
	end

	startY = startY + sy*0.02
	dxDrawText("Kinézet kiválasztása:", sx*0.1, startY, sx*0.6, startY, tocolor(255, 255, 255, 255), 1, fontscript:getFont("p_m", 13/myX*sx), "left", "center")
	startY = startY + sy*0.02

	if selected_nem == 1 or core:isInSlot(sx*0.1, startY, 40/myX*sx, 40/myX*sx) then 
		dxDrawImage(sx*0.1, startY, 40/myX*sx, 40/myX*sx, "img/no.png", 0, 0, 0, tocolor(loginColors[1], loginColors[2], loginColors[3], 240))
	else
		dxDrawImage(sx*0.1, startY, 40/myX*sx, 40/myX*sx, "img/no.png", 0, 0, 0, tocolor(255, 255, 255, 150))
	end

	if selected_nem == 2 or core:isInSlot(sx*0.1 + 45/myX*sx, startY, 40/myX*sx, 40/myX*sx) then
		dxDrawImage(sx*0.1 + 45/myX*sx, startY, 40/myX*sx, 40/myX*sx, "img/ferfi.png", 0, 0, 0, tocolor(loginColors[1], loginColors[2], loginColors[3], 240))
	else
		dxDrawImage(sx*0.1 + 45/myX*sx, startY, 40/myX*sx, 40/myX*sx, "img/ferfi.png", 0, 0, 0, tocolor(255, 255, 255, 150))
	end

	if core:isInSlot(sx*0.3 - 40/myX*sx, startY, 40/myX*sx, 40/myX*sx) then 
		dxDrawImage(sx*0.3 - 40/myX*sx, startY, 40/myX*sx, 40/myX*sx, "img/arrow.png", 0, 0, 0, tocolor(loginColors[1], loginColors[2], loginColors[3], 240))
	else
		dxDrawImage(sx*0.3 - 40/myX*sx, startY, 40/myX*sx, 40/myX*sx, "img/arrow.png", 0, 0, 0, tocolor(255, 255, 255, 150))
	end

	if core:isInSlot(sx*0.3 - 85/myX*sx, startY, 40/myX*sx, 40/myX*sx) then 
		dxDrawImage(sx*0.3 - 85/myX*sx, startY, 40/myX*sx, 40/myX*sx, "img/arrow.png", -180, 0, 0, tocolor(loginColors[1], loginColors[2], loginColors[3], 240))
	else
		dxDrawImage(sx*0.3 - 85/myX*sx, startY, 40/myX*sx, 40/myX*sx, "img/arrow.png", -180, 0, 0, tocolor(255, 255, 255, 150))
	end

	startY = startY + sy*0.07
	dxDrawText("Avatar kiválasztása:", sx*0.1, startY, sx*0.6, startY, tocolor(255, 255, 255, 255), 1, fontscript:getFont("p_m", 13/myX*sx), "left", "center")
	startY = startY + sy*0.02

	if fileExists("avatars/"..(selected_avatar-1)..".png") then 
		dxDrawImage(sx*0.1,startY + sy*0.005,sx*0.03125,sy*0.055,"avatars/"..(selected_avatar-1)..".png",0,0,0,tocolor(255,255,255,150))
	else
		dxDrawImage(sx*0.1,startY + sy*0.005,sx*0.03125,sy*0.055,"avatars/50.png",0,0,0,tocolor(255,255,255,150))
	end

	dxDrawImage(sx*0.135,startY,sx*0.0375,sy*0.066,"avatars/"..selected_avatar..".png",0,0,0,tocolor(255,255,255,255))

	if fileExists("avatars/"..(selected_avatar+1)..".png") then 
		dxDrawImage(sx*0.1765,startY + sy*0.005,sx*0.03125,sy*0.055,"avatars/"..(selected_avatar+1)..".png",0,0,0,tocolor(255,255,255,150))
	else
		dxDrawImage(sx*0.1765,startY + sy*0.005,sx*0.03125,sy*0.055,"avatars/1.png",0,0,0,tocolor(255,255,255,150))
	end

	startY = startY + sy*0.09
	dxDrawText("Érkezés a városba:", sx*0.1, startY, sx*0.6, startY, tocolor(255, 255, 255, 255), 1, fontscript:getFont("p_m", 13/myX*sx), "left", "center")
	startY = startY + sy*0.015

	for k, v in ipairs(availableStartPositions) do 
		if k == selectedStartPos then 
			dxDrawRectangle(sx*0.1, startY, sx*0.2, sy*0.025, tocolor(35, 35, 35, 245))
			dxDrawText(v[1] .. ": " .. color .. v[2], sx*0.1, startY, sx*0.3, startY + sy*0.027, tocolor(255, 255, 255, 200), 1, fontscript:getFont("p_m", 13/myX*sx), "center", "center", false, false, false, true)
		else
			dxDrawRectangle(sx*0.1, startY, sx*0.2, sy*0.025, tocolor(35, 35, 35, 100))
			dxDrawText(v[1] .. ": " .. color .. v[2], sx*0.1, startY, sx*0.3, startY + sy*0.027, tocolor(255, 255, 255, 100), 1, fontscript:getFont("p_m", 13/myX*sx), "center", "center", false, false, false, true)
		end
		startY = startY + sy*0.03
	end

	startY = startY + sy*0.01
	if core:isInSlot(sx*0.1, startY, sx*0.2, barHeight) then
		dxDrawRectangle(sx*0.1, startY, sx*0.2, barHeight, tocolor(loginColors[1], loginColors[2], loginColors[3], 220))
	else
		dxDrawRectangle(sx*0.1, startY, sx*0.2, barHeight, tocolor(loginColors[1], loginColors[2], loginColors[3], 200))
	end

	
	if pendingCharCreate then 
		spinnerRot = spinnerRot + 2
		dxDrawImage(((sx*0.1 + sx*0.2 / 2) - 10/myX * sx ), startY + barHeight / 2 - 10/myX*sx, 20/myX*sx, 20/myX*sx, "img/v2_icons/loading.png", spinnerRot, 0, 0, tocolor(255, 255, 255, 255))
	else
		dxDrawText("Karakter létrehozása", sx*0.1, startY, sx*0.3 - 30/myX*sx, startY + barHeight + sy*0.004, tocolor(255, 255, 255, 255), 1, fontscript:getFont("p_bo", 13/myX*sx), "center", "center")
		dxDrawImage((sx*0.1 + sx*0.2 / 2) - 10/myX * sx + dxGetTextWidth("Karakter létrehozása",1, fontscript:getFont("p_bo", 13/myX*sx))/2, startY + barHeight / 2 - 10/myX*sx, 20/myX*sx, 20/myX*sx, "img/v2_icons/reg.png", 0, 0, 0, tocolor(255, 255, 255, 255))
	end
end 

local camindex = 1
local animationTime = 120000

addEvent("successfulLogin", true)
addEventHandler("successfulLogin", root,
	function(type)
		if type == "login" then 
			removeEventHandler("onClientRender",root,renderLoginV2)
			removeEventHandler("onClientKey", root, keyLoginV2)

			startCharLoadAnimation()
			
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
			for k, v in ipairs(loginpanelboxok["char_create"]) do 
				v.text = ""
			end

			addEventHandler("onClientRender", root, renderCharCreate)
			addEventHandler("onClientKey", root, keyCharCreate)
			removeEventHandler("onClientRender", root, renderLoginV2)
			removeEventHandler("onClientKey", root, keyLoginV2)

			tick = getTickCount()

			charCreateShow = true
			exports.oInfobox:outputInfoBox("Nincs karaktered! Hozz létre egyet!","info")

			setCameraMatrix(unpack(charCreateCameraPosition))
			charCreatePed = createPed(1, charCreatePedPosition[1], charCreatePedPosition[2], charCreatePedPosition[3], charCreatePedPosition[4])
			setElementFrozen(charCreatePed, true)
			setElementDimension(charCreatePed, dimId)

			updatePlayerSkin()

			guiSetInputEnabled(false)
			showCursor(true)
			showChat(false)
		end

		for k, v in pairs(temp_objects) do 
			if isElement(v) then
				destroyElement(v)
			end
		end
		
		if isTimer(clockTimer) then 
			killTimer(clockTimer)
		end

		setSoundPaused(music,true)
	end 
)

local invalidChars = {
	["á"] = false,
	["é"] = false,
	["í"] = false,
	["ö"] = false,
	["ő"] = false,
	["ü"] = false,
	["ű"] = false,
	["ó"] = false,
	["1"] = false,
	["2"] = false,
	["3"] = false,
	["4"] = false, 
	["5"] = false,
	["6"] = false,
	["7"] = false,
	["8"] = false, 
	["9"] = false,
	["0"] = false,
}

function keyCharCreate(key, state)
	if state and charCreateShow then
		if key == "mouse1" then 
			local startY = sy*0.25

			for k, v in ipairs(loginpanelboxok["char_create"]) do 
				if key == "mouse1" then
					if v.input then
						if core:isInSlot(sx*0.1, startY, sx*0.2, barHeight) then 
							selectedv2Editbox = v.name 
							guiSetText(loginpanelEditbox, v.text)
							break
						else
							selectedv2Editbox = false
						end
					end
				end
		
				if v.onoff then 
					startY = startY  + sy*0.03
				else
					startY = startY + barHeight + sy*0.005
				end
			end
			startY = startY + sy*0.02
			startY = startY + sy*0.02

			if core:isInSlot(sx*0.1, startY, 40/myX*sx, 40/myX*sx) then 
				selected_nem = 1
				selected_skin = 1
				updatePlayerSkin()
			end 

			if core:isInSlot(sx*0.1 + 45/myX*sx, startY, 40/myX*sx, 40/myX*sx) then  
				selected_nem = 2
				selected_skin = 1
				updatePlayerSkin()
			end

			if core:isInSlot(sx*0.3 - 40/myX*sx, startY, 40/myX*sx, 40/myX*sx) then 
				if selected_skin < #skins[selected_nem] then 
					selected_skin = selected_skin + 1 
					updatePlayerSkin()
				end
			end

			if core:isInSlot(sx*0.3 - 85/myX*sx, startY, 40/myX*sx, 40/myX*sx) then 
				if selected_skin > 1 then 
					selected_skin = selected_skin - 1
					updatePlayerSkin()
				end
			end

			startY = startY + sy*0.09
			if core:isInSlot(sx*0.1765,startY + sy*0.005,sx*0.03125,sy*0.055) then 
				if selected_avatar < 50 then 
					selected_avatar = selected_avatar + 1
				else
					selected_avatar = 1
				end
			end

			if isInBox(sx*0.1,startY + sy*0.005,sx*0.03125,sy*0.055) then 
				if selected_avatar > 1 then 
					selected_avatar = selected_avatar - 1
				else
					selected_avatar = 50
				end
			end

			startY = startY + sy*0.09
			startY = startY + sy*0.015

			for k, v in ipairs(availableStartPositions) do 
				if core:isInSlot(sx*0.1, startY, sx*0.2, sy*0.025) then 
					selectedStartPos = k 
					print(selectedStartPos)
				end
				startY = startY + sy*0.03
			end

			startY = startY + sy*0.01
			if core:isInSlot(sx*0.1, startY, sx*0.2, barHeight) then
				if pendingCharCreate then return end 

				local characterName = loginpanelboxok["char_create"][1].text 
				local bornCity = loginpanelboxok["char_create"][2].text 
				local age = tonumber(loginpanelboxok["char_create"][3].text )
				local weight = tonumber(loginpanelboxok["char_create"][4].text )
				local height = tonumber(loginpanelboxok["char_create"][5].text )
				
				for k,v in pairs(invalidChars) do 
					if string.find(characterName,k) then return infobox:outputInfoBox("Karaktered neve nem tartalmazhat ékezetes betűket vagy számokat!", "error") end
				end 

					if string.find(characterName, " ") then
						if string.len(characterName) > 7 then
							if string.len(characterName) <= 25 then
								characterName = string.gsub(characterName, " ", "_")
								if string.len(bornCity) > 4 and string.len(bornCity) <= 25  then
									if age and (age >= 18 and age <= 99) then 
										if weight and (weight >= 50 and weight <= 200) then 
											if height and (height >= 150 and height <= 240) then 
												print(characterName, bornCity, age, weight, height)

												pendingCharCreate = true
												exports.oInterface:toggleHud(true)
												triggerServerEvent("createCharacterOnServer",root,localPlayer, characterName, bornCity:gsub(" ","_"), age, height, weight,selected_nem,skins[selected_nem][selected_skin],selected_avatar,selectedStartPos)

												setTimer(function()
													pendingCharCreate = false
												end, 2500, 1)
											else
												infobox:outputInfoBox("A magasságnak 150cm és 240cm közé kell esnie!", "error")
											end
										else
											infobox:outputInfoBox("A súlynak 50kg és 200kg közé kell esnie!", "error")
										end
									else
										infobox:outputInfoBox("Az életkornak 18 és 99 közé kell esnie!", "error")
									end
								else
									infobox:outputInfoBox("Hibás a megadott születési hely!", "error")
								end
							else
								infobox:outputInfoBox("Túl hosszú a megadott karakternév!", "error")
							end
						else
							infobox:outputInfoBox("Túl rövid a megadott karakternév!", "error")
						end
					else
						infobox:outputInfoBox("Hibás a megadott karakternév! [Kötelező a vezeték és keresztneved space-val való elválasztása!]", "error")
					end
			end
		elseif (key == "tab") then 
			if (selectedv2Editbox == "charname") then 
				selectedv2Editbox = "borncity"
			elseif (selectedv2Editbox == "borncity") then 
				selectedv2Editbox = "age"
			elseif (selectedv2Editbox == "age") then 
				selectedv2Editbox = "weight"
			elseif (selectedv2Editbox == "weight") then
				selectedv2Editbox = "height"
			elseif (selectedv2Editbox == "height") then 
				selectedv2Editbox = "charname"
			end

			for k, v in ipairs(loginpanelboxok["char_create"]) do 
				if v.input then
					if v.name == selectedv2Editbox then 
						guiSetText(loginpanelEditbox, v.text)
						break
					end
				end
			end
		end
	end
end

function updatePlayerSkin()
	setElementModel(localPlayer,skins[selected_nem][selected_skin])
	setElementModel(charCreatePed,skins[selected_nem][selected_skin])
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

	exports.oJSON:saveDataToJSONFile({selectedmusic, soundVolume}, "loginMusic", true)
end

function updateSongSoundLevel(newlevel)
	soundVolume = newlevel
	setSoundVolume(music,soundVolume)
	exports.oJSON:saveDataToJSONFile({selectedmusic, soundVolume}, "loginMusic", true)
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
			exports.oInterface:toggleHud(false)
			showCursor(false)
			showChat(true)
		end
	end



	--dxDrawRectangle(0,0,sx,sy,tocolor(35,35,35,255*loadPanelAlpha))

	dxDrawImage(0, 0, sx, sy, ":oLoading/files/load.jpg", 0, 0, 0, tocolor(255, 255, 255, 255 * loadPanelAlpha))
	dxDrawRectangle(0,sy*0.99,sx*load,sy,tocolor(255,255,255,255*loadPanelAlpha))
	dxDrawText(math.floor(load*100).."%",0,sy*0.99,0+sx*load,sy*0.99+sy*0.0125,tocolor(0, 0, 0,255*loadPanelAlpha),0.65/myX*sx,fonts["font"],"center","center")

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

	

	dxDrawText("OriginalRoleplay", 0, sy*0.15, sx, sy*0.15, tocolor(255, 255, 255, 100 * loadPanelAlpha), 1, fontscript:getFont("p_ba", 14/myX*sx), "center", "center")
	dxDrawText("ÜDVÖZLÜNK A SZERVEREN!", 0, sy*0.18, sx, sy*0.18, tocolor(255, 255, 255, 255 * loadPanelAlpha), 1, fontscript:getFont("p_ba", 30/myX*sx), "center", "center")
	dxDrawText("Karakter betöltése folyamatban...", 0, sy*0.21, sx, sy*0.21, tocolor(255, 255, 255, 150 * loadPanelAlpha), 1, fontscript:getFont("p_bo", 14/myX*sx), "center", "center")

	dxDrawImage(sx/2-200/myX*sx + 7/myX*sx,sy/2-200/myX*sx,400/myX*sx, 400/myX*sx,"img/logo.png",0,0,0,tocolor(255,255,255,30*loadPanelAlpha))
	local skinId = getElementModel(localPlayer)
	dxDrawImage(sx/2-100/myX*sx,sy/2 - 496/2/myY*sy,200/myX*sx,496/myY*sy,"img/peds/"..skinId..".png",0,0,0,tocolor(255,255,255,100*loadPanelAlpha))
	dxDrawImageSection(sx/2-100/myX*sx,(sy/2 - 496/2/myY*sy),200/myX*sx,496/myY*sy * load, 0, 0, 200,496 * load,"img/peds/"..skinId..".png",0, 0,0,tocolor(255,255,255,255*loadPanelAlpha))

	--dxDrawImage(0,0,sx,sy,"img/logo1.png",0,0,0,tocolor(255,255,255,255*logoAlpha*loadPanelAlpha))

	local greatingText = "Problémába ütköztél? Segítségre szorulsz? Keresd adminisztrátorjainkat a szerveren, discordon vagy fórumon!"
	local rectangleWidth = dxGetTextWidth(greatingText, 1, fontscript:getFont("p_m", 14/myX*sx)) + 15/myX*sx
	core:dxDrawRoundedRectangle(sx/2 - rectangleWidth/2, sy*0.85, rectangleWidth, sy*0.035, tocolor(255, 255, 255, 200 * loadPanelAlpha), tocolor(255, 255, 255, 200 * loadPanelAlpha))
	dxDrawText(greatingText,sx/2 - rectangleWidth/2, sy*0.85,sx/2 - rectangleWidth/2 + rectangleWidth, sy*0.85 + sy*0.04,tocolor(0,0,0,255*loadPanelAlpha),1, fontscript:getFont("p_m", 14/myX*sx),"center","center")

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

local resetCount = 0
function resetCharCreation() -- EZT VISSZA KELL ÁLLÍTANI
	pendingCharCreate = false

	if resetCount == 5 then
		resetCount = 0
		showLoginPanel()
		return
	end

	loginpanelboxok["char_create"][1].text = ""
	--addEventHandler("onClientRender", root, renderCharCreate)
	charCreateShow = true

	guiSetInputEnabled(false)
	showCursor(true)
	showChat(false)

	resetCount = resetCount + 1
end
addEvent("resetCharCreatByReason",true)
addEventHandler("resetCharCreatByReason",root,resetCharCreation)

addEvent("createCharacterSuccessfully", true)
addEventHandler("createCharacterSuccessfully", root, function()
	removeEventHandler("onClientRender", root, renderCharCreate)	
	removeEventHandler("onClientKey", root, keyCharCreate)
	charCreateShow = false
	startCharLoadAnimation()
end)



function startCharLoadAnimation()
	if charLoadAnimationShowing then return end 

	charLoadAnimationShowing = true
	exports.oInterface:toggleHud(true)
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

end 

local ban_datas = {"", "", "", "", "", ""}

function renderBanPanel() 
	local pA = interpolateBetween(0,0,0,1,0,0,(getTickCount()-alpha_tick)/500, "Linear")



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

	removeEventHandler("onClientRender",root,renderLoginV2)
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

function backToLogin()
	loginPanelPage = "login"
end 
addEvent("backToLogin",true)
addEventHandler("backToLogin",root,backToLogin)

function getPlayerAccountsTableC(player, id)
	return databaseAccounts[id]
end

function getPlayerCharactersTableC(player, id)
	return databaseCharacters[id]
end