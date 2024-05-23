sx, sy = guiGetScreenSize()

var = false
var1 = false

rel = ((sx/1376)+(sy/768))/2

size = 0.9

myX, myY = 1366, 768

bx, by, bw, bh = sx*0.4, sy*0.75, 272/myX*sx*size, 81/myY*sy*size

color, r, g, b = exports.oCore:getServerColor()

interface = exports.oInterface

font = exports.oFont:getFont("roboto", rel*10)

core = exports.oCore

sounds = {}

local lastClick = getTickCount()

addEventHandler("onClientElementDataChange", root, function(data, old, new)
	if data == "sirenData" then 
		if new then
			local x, y, z = getElementPosition(source)

			sounds[source] = playSound3D("assets/sirens/"..new[1], x, y, z, new[2])
			setSoundMaxDistance(sounds[source], 100)
			setSoundVolume(sounds[source], 3)
			attachElements(sounds[source], source)
		else
			if isElement(sounds[source]) then 
				destroyElement(sounds[source])
				sounds[source] = false
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementData(source, "sirenData") then 
		if not sounds[source] then 
			local x, y, z = getElementPosition(source)
			local sirenData = getElementData(source, "sirenData")

			sounds[source] = playSound3D("assets/sirens/"..sirenData[1], x, y, z, sirenData[2])
			setSoundMaxDistance(sounds[source], 100)
			setSoundVolume(sounds[source], 3)
			attachElements(sounds[source], source)
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementData(source, "sirenData") then 
		if sounds[source] then 
			if isElement(sounds[source]) then 
				destroyElement(sounds[source])
				sounds[source] = false
			end
		end
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	for k, v in ipairs(getElementsByType("vehicle"), getRootElement(), true) do 
		if getElementData(v, "sirenData") then
			if isElementStreamedIn(v) then  
				if not sounds[v] then 
					local x, y, z = getElementPosition(v)
					local sirenData = getElementData(v, "sirenData")

					sounds[v] = playSound3D("assets/sirens/"..sirenData[1], x, y, z, sirenData[2])
					setSoundMaxDistance(sounds[v], 100)
					setSoundVolume(sounds[v], 3)
					attachElements(sounds[v], v)
				end
			end
		end
	end
end)

addEvent("siren > playVehicleHornSoundClient", true)
addEventHandler("siren > playVehicleHornSoundClient", root, function(veh)
	local x, y, z = getElementPosition(veh)

	local sound = playSound3D("assets/sirens/horn.wav", x, y, z, false)
	setSoundMaxDistance(sound, 100)
	setSoundVolume(sound, 3)
	attachElements(sound, veh)
end)

local tick = getTickCount()

function renderSirenEffect()
	if getPedOccupiedVehicle(localPlayer) then
		local alpha = 0
		for k, v in ipairs(getElementsByType("vehicle", root, true)) do 
			
			if getVehicleSirensOn(v) then
				local dis = core:getDistance(v, localPlayer)

				if dis < 70 then
					if dis < 50 then 
						alpha = 1
					else
						alpha = (50/dis) - 0.5
						print(alpha)
					end
				end
			end
		end

		if alpha > 0 then
			dxDrawImage(0, 0, sx, sy, "assets/light.png", 0, 0, 0, tocolor(38, 126, 240, 255 * alpha * interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 700, "SineCurve")))
			dxDrawImage(0, 0, sx, sy, "assets/light.png", 180, 0, 0, tocolor(240, 38, 38, 255 * alpha * interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - (tick + 500)) / 700, "SineCurve")))
		end
	end
end
addEventHandler("onClientRender", root, renderSirenEffect)

function panel()
	if isPedInVehicle(localPlayer) == false then
		removeEventHandler("onClientRender", root, panel)
		removeEventHandler("onClientKey", root, key)
	end

	if interface:getInterfaceElementData(8, "showing") then
		bx, by = interface:getInterfaceElementData(8, "posX")*sx, interface:getInterfaceElementData(8, "posY")*sy
		dxDrawImage(bx, by, bw, bh, "assets/bg.png")

		if core:isInSlot(bx*1.14, by*1.018, 31/myX*sx*size, 27/myY*sy*size) then
			dxDrawImage(bx + sx*0.055, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_light_active.png")
		else
			dxDrawImage(bx + sx*0.055, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_light_deactive.png")
		end

		if core:isInSlot(bx + sx*0.079, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size) then
			dxDrawImage(bx + sx*0.079, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_light_active.png")
		else
			dxDrawImage(bx + sx*0.079, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_light_deactive.png")
		end

		if core:isInSlot(bx + sx*0.103, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size) then
			dxDrawImage(bx + sx*0.103, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_light_active.png")
		else
			dxDrawImage(bx + sx*0.103, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_light_deactive.png")
		end

		if core:isInSlot(bx + sx*0.103, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size) then
			dxDrawImage(bx + sx*0.103, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_sound_active.png")
		else
			dxDrawImage(bx + sx*0.103, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_sound_deactive.png")
		end

		if core:isInSlot(bx + sx*0.079, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size) then
			dxDrawImage(bx + sx*0.079, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_sound_active.png")
		else
			dxDrawImage(bx + sx*0.079, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_sound_deactive.png")
		end

		if core:isInSlot(bx + sx*0.055, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size) then
			dxDrawImage(bx + sx*0.055, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_horn_active.png")
		else
			dxDrawImage(bx + sx*0.055, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size, "assets/siren_horn_deactive.png")
		end
	end
end

function key(button,state)
	if button=="mouse1" and state then
		if core:isInSlot(bx + sx*0.055, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size) then
			if lastClick + 500 < getTickCount() then
				if not var then
					triggerServerEvent("onClientSirensOn", getRootElement(), 1)
				else
					triggerServerEvent("onClientSirensOff", getRootElement())
				end
				exports.oChat:sendLocalMeAction("megnyom egy gombot a műszerfalon.")
				lastClick = getTickCount()

				var = not var
			end
		end

		if core:isInSlot(bx + sx*0.079, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size) then
			if lastClick + 500 < getTickCount() then
				if not var then
					triggerServerEvent("onClientSirensOn", getRootElement(), 2)
				else
					triggerServerEvent("onClientSirensOff", getRootElement())
				end
				exports.oChat:sendLocalMeAction("megnyom egy gombot a műszerfalon.")
				lastClick = getTickCount()

				var = not var
			end
		end

		if core:isInSlot(bx + sx*0.103, by + sy*0.013, 31/myX*sx*size, 27/myY*sy*size) then
			if lastClick + 500 < getTickCount() then
				if not var then
					triggerServerEvent("onClientSirensOn", getRootElement(), 3)
				else
					triggerServerEvent("onClientSirensOff", getRootElement())
				end
				exports.oChat:sendLocalMeAction("megnyom egy gombot a műszerfalon.")
				lastClick = getTickCount()

				var = not var	
			end
		end

		
		if core:isInSlot(bx + sx*0.103, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size) then
			if not (getElementModel(getPedOccupiedVehicle(localPlayer)) == 525) then
				if lastClick + 500 < getTickCount() then
					local vehModel = getElementModel(getPedOccupiedVehicle(localPlayer))
					if vehicleSirenTypes[vehModel] then 
						lastClick = getTickCount()
						triggerServerEvent("siren > setVehicleSirenSound", resourceRoot, getPedOccupiedVehicle(localPlayer), vehicleSirenTypes[vehModel].."2.wav", true)
						exports.oChat:sendLocalMeAction("megnyom egy gombot a műszerfalon.")
					end
				end
			end
		end

		if core:isInSlot(bx + sx*0.079, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size) then
			if not (getElementModel(getPedOccupiedVehicle(localPlayer)) == 525) then
				if lastClick + 500 < getTickCount() then
					local vehModel = getElementModel(getPedOccupiedVehicle(localPlayer))
					if vehicleSirenTypes[vehModel] then 
						lastClick = getTickCount()
						triggerServerEvent("siren > setVehicleSirenSound", resourceRoot, getPedOccupiedVehicle(localPlayer), vehicleSirenTypes[vehModel].."1.wav", true)
						exports.oChat:sendLocalMeAction("megnyom egy gombot a műszerfalon.")
					end
				end
			end
		end

		if core:isInSlot(bx + sx*0.055, by + sy*0.05, 31/myX*sx*size, 27/myY*sy*size) then	
			if not (getElementModel(getPedOccupiedVehicle(localPlayer)) == 525) then
				if lastClick + 1000 < getTickCount() then
					lastClick = getTickCount()
					triggerServerEvent("siren > playVehicleHornSound", resourceRoot, getPedOccupiedVehicle(localPlayer))
				end
			end
		end

	elseif button == "h" and state then 
		if not isChatBoxInputActive() then
			if not (getElementModel(getPedOccupiedVehicle(localPlayer)) == 525) then
				cancelEvent()
				if lastClick + 1000 < getTickCount() then
					if isCursorShowing() then return end
					lastClick = getTickCount()
					triggerServerEvent("siren > playVehicleHornSound", resourceRoot, getPedOccupiedVehicle(localPlayer))
				end
			end
		end
	end
end

addEventHandler("onClientVehicleEnter", getRootElement(),
	function(thePlayer,seat)
		if thePlayer == localPlayer and seat == 0 or seat == 1 then
			v = getPedOccupiedVehicle(localPlayer)
			if isElement(v) then
				if sirens[getElementModel(v)] then
					addEventHandler("onClientRender", root, panel)
					addEventHandler("onClientKey", root, key)
				end
			end
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		v = getPedOccupiedVehicle(localPlayer)
		if v then
			if sirens[getElementModel(v)] then
				addEventHandler("onClientRender", getRootElement(), panel)
				addEventHandler("onClientKey", root, key)
			end 
		end
	end
)

-- betűvel kezelés, sziréna
addCommandHandler("lights", function()
	if not var then
		triggerServerEvent("onClientSirensOn", getRootElement(), 1)
	else
		triggerServerEvent("onClientSirensOff", getRootElement())
	end
	exports.oChat:sendLocalMeAction("megnyom egy gombot a műszerfalon.")

	var = not var
end)

addCommandHandler("sirens", function()
	local vehModel = getElementModel(getPedOccupiedVehicle(localPlayer))
	triggerServerEvent("siren > setVehicleSirenSound", resourceRoot, getPedOccupiedVehicle(localPlayer), vehicleSirenTypes[vehModel].."1.wav", true)
	exports.oChat:sendLocalMeAction("megnyom egy gombot a műszerfalon.")
end)


-- P betű villogó
local flashingVehicles = { }

function bindKeys(res)
	bindKey("p", "down", toggleFlashers)
	
	for key, value in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(value) then
			local flasherState = getElementData(value, "pd_flashers")
			if flasherState and flasherState > 0 then
				flashingVehicles[value] = true
			end
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeys)

function toggleFlashers()
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
	
	if (theVehicle) then
		triggerServerEvent("pd:toggleFlashers", theVehicle)
	end
end

function streamIn()
	if getElementType( source ) == "vehicle" and getElementData( source, "pd_flashers" ) then
		local flasherState = getElementData(source, "pd_flashers")
		if flasherState and flasherState > 0 then
			flashingVehicles[source] = true
		end
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function streamOut()
	if getElementType( source ) == "vehicle" then
		flashingVehicles[source] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), streamOut)

function updateSirens( name )
	if name == "pd_flashers" and isElementStreamedIn( source ) and getElementType( source ) == "vehicle" then
		local flasherState = getElementData(source, "pd_flashers")
		if flasherState and flasherState > 0 then
			flashingVehicles[source] = true
		else
			flashingVehicles[source] = false
		end
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateSirens)

function doFlashes()
	for veh in pairs(flashingVehicles) do
		if not (isElement(veh)) then
			flashingVehicles[veh] = nil
		else
			local flasherState = getElementData(veh, "pd_flashers")
			if flasherState and flasherState == 0 then
				flashingVehicles[veh] = nil
				setVehicleHeadLightColor(veh, 255, 255, 255)
				setVehicleLightState(veh, 0, 0)
				setVehicleLightState(veh, 1, 0)
				setVehicleLightState(veh, 2, 0)
				setVehicleLightState(veh, 3, 0)
			else
				local state = getVehicleLightState(veh, 0)
				if flasherState == 2 then
					setVehicleHeadLightColor(veh, 128, 64, 0)
				else
					if (state==0) then
						setVehicleHeadLightColor(veh, 0, 0, 255)
					else
						setVehicleHeadLightColor(veh, 255, 0, 0)
					end
				end
				setVehicleLightState(veh, 0, 1-state)
				setVehicleLightState(veh, 1, state)
				setVehicleLightState(veh, 2, 1-state)
				setVehicleLightState(veh, 3, state)
			end
		end		
	end
end
setTimer(doFlashes, 250, 0)
