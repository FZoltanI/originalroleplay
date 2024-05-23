function createCarshops()
    for k,v in ipairs(carshops) do
        local blipName = carshop_names[v[7]] or "Járműkereskedés"
        local ped = createPed(v[6],v[1],v[2],v[3],v[4])
        setElementData(ped,"ped:name",v[5]) 
        setElementData(ped,"ped:prefix",blipName)
        setElementData(ped,"vehicle:dealer:type",v[7])

        setElementFrozen(ped, true)

        local blip = createBlipAttachedTo(ped, carshopBlipIDs[v[7]])
        setElementData(blip, "blip:name", blipName)
    end
end
createCarshops()

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oInventory" or getResourceName(res) == "oInterface" or getResourceName(res) == "oVehicle" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oBlur" then  
        font = exports.oFont
		core = exports.oCore
		color, r, g, b = core:getServerColor()
		interface = exports.oInterface
		blur = exports.oBlur
		vehicle = exports.oVehicle
		infobox = exports.oInfobox
		inventory = exports.oInventory
	end
end)

--=========[ Változók ]========
local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local buySelect = false

local selectedVehicle = 1
local fonts = {
	["condensed-18"] = font:getFont("condensed",18),
    ["condensed-13"] = font:getFont("condensed",13),
    ["condensed-12"] = font:getFont("condensed",12),
    ["condensed-11"] = font:getFont("condensed",11),
	["condensed-10"] = font:getFont("condensed",10),
	
	["bebasneue-13"] = font:getFont("bebasneue",13),
	["bebasneue-18"] = font:getFont("bebasneue",18),
	["fontawesome"] = font:getFont("fontawesome2",10),
}

local carshopShowing = false
local componentShow = false
local panelTick = getTickCount()
local panelAnimType = 1

local a
local a_testdrive = 0

local testDrivePanelTick = getTickCount()
local testDriveAnimType = 1

local showVehicle

local vehicleAlphaAnimType = 1
local vehicleAlphaAnimTick = getTickCount()
local vehicelAlpha = 0
local vehicleAlphaAnimTime = 500
local vehicleAnimating = false

local vehicleColor = {255,255,255}
local vehicleColorType = "default"

local testDrivePanelShowing = false

local shopType = 1

local factionsWherePlayerIsLeader = {1, 13}
local selectedFactionID = 0

local activeColorInput = false

local bgMusic = false

local selectedVehicleCategory = 1
local categoryScroll = 0

local animateTimer = nil
--=============================

local testTarget = dxCreateRenderTarget(sx*0.1,sy*0.1)

local pageTick = getTickCount()

local borders = {}
function createBorderWalls()
	borders = {}
	for k, v in pairs(borderWalls) do 
		local obj = createObject(8681, v[1], v[2], v[3], 0, 0, v[4])
		setElementAlpha(obj, 0)
		setElementDimension(obj, (700 + (getElementData(localPlayer, "char:id") * 2)))
		table.insert(borders, #borders+1, obj)
	end
end

function destroyBorders()
	for k, v in pairs(borders) do
		destroyElement(v)
	end 
	borders = {}
end


function drawPanel()
	if testDriveAnimType == 1 then 
		a_testdrive = interpolateBetween(0,0,0,1,0,0,(getTickCount() - testDrivePanelTick)/500,"Linear")
    else
        a_testdrive = interpolateBetween(1,0,0,0,0,0,(getTickCount() - testDrivePanelTick)/500,"Linear")
	end


	--[[if testDrivePanelShowing then -- tesztvezetés panel
		blur:createBlur(0,0,sx,sy,200*a_testdrive)
	end]]

    if panelAnimType == 1 then 
        a = interpolateBetween(0,0,0,1,0,0,(getTickCount() - panelTick)/500,"Linear")
    else
        a = interpolateBetween(1,0,0,0,0,0,(getTickCount() - panelTick)/500,"Linear")
    end

    dxDrawRectangle(0,sy*0.9,sx*a,sy*0.1,tocolor(40,40,40,245*a))
	dxDrawRectangle(0,0,sx*0.2,sy*0.9,tocolor(40,40,40,240*a))
	dxDrawLine(sx*0.2,0,sx*0.2,sy*0.9,tocolor(r,g,b,200*a), 2)

	--if selectedFactionID > 0 then 
		--dxDrawText(color.."ORIGINAL ROLEPLAY#dcdcdc - SZERVEZETI JÁRMŰKERESKEDÉS",0,0,sx*0.2,0+sy*0.095,tocolor(220,220,220,255*a),0.9/myX*sx,fonts["condensed-13"],"center","center",false,false,false,true)
	--else
		dxDrawText(color.."ORIGINAL ROLEPLAY#dcdcdc - JÁRMŰKERESKEDÉS",0,0,sx*0.2,0+sy*0.095,tocolor(220,220,220,255*a),0.9/myX*sx,fonts["condensed-13"],"center","center",false,false,false,true)
	--end
	dxDrawLine(sx*0.005,sy*0.095,sx*0.01+sx*0.185,sy*0.095,tocolor(220,220,220,100*a), 2)

	dxDrawText("Fényezés",0,sy*0.1,sx*0.2,sy*0.1+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-11"],"center","center",false,false,false,true)
		local colorX, colorY = sx*0.045,sy*0.13
		for k,v in ipairs(vehicle_default_colors) do 
			if k == 5 then 
				colorX, colorY = sx*0.045, colorY + sy*0.05
			end

			if core:isInSlot(colorX, colorY, 35/myX*sx, 35/myY*sy) or selectedColor == k then 
				dxDrawImage(colorX, colorY, 35/myX*sx, 35/myY*sy, "files/dot2.png", 0, 0, 0, tocolor(v[1], v[2], v[3], 255*a))
			else
				dxDrawImage(colorX, colorY, 35/myX*sx, 35/myY*sy, "files/dot1.png", 0, 0, 0, tocolor(v[1], v[2], v[3], 220*a))
			end

			colorX = colorX + 40/myX*sx
		end
	dxDrawLine(sx*0.005,sy*0.23,sx*0.01+sx*0.185,sy*0.23,tocolor(220,220,220,100*a), 2)

	dxDrawText("Egyedi Fényezés",0,sy*0.235,sx*0.2,sy*0.235+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-11"],"center","center",false,false,false,true)
	dxDrawText("+30%",0,sy*0.255,sx*0.2,sy*0.255+sy*0.03,tocolor(220,220,220,255*a),0.9/myX*sx,fonts["condensed-10"],"center","center",false,false,false,true)
	drawColorPicker()

	--dxDrawText("",0 - 50 - 1,sy*0.85 + 1,sx,sy*1,tocolor(0,0,0,255*a),1/myX*sx,fonts["fontawesome"],"center","center",false,false,false,true)
	dxDrawText("",0 - 25,sy*0.85,sx,sy*1,tocolor(220,220,220,255*a),1/myX*sx,fonts["fontawesome"],"center","center",false,false,false,true)
	--dxDrawRectangle(sx*0.485,sy*0.908,sx*0.015,sy*0.03,tocolor(25,123,23,150))

	--dxDrawText("",0 + 10 - 1,sy*0.85 + 1,sx,sy*1,tocolor(0,0,0,255*a),1/myX*sx,fonts["fontawesome"],"center","center",false,false,false,true)
	dxDrawText("",0 + 25,sy*0.85,sx,sy*1,tocolor(220,220,220,255*a),1/myX*sx,fonts["fontawesome"],"center","center",false,false,false,true)
	--dxDrawRectangle(sx*0.499,sy*0.908,sx*0.015,sy*0.03,tocolor(25,123,23,150))

    if selectedVehicle > 0 then
    	dxDrawText(vehicle:getModdedVehName(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2]),0,sy*0.91,sx,sy*1,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-18"],"center","center",false,false,false,true)
    end
	--dxDrawText("Ára:",sx*0.88,sy*0.915,sx*0.88+sx*0.115,sy*0.915+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-12"],"left","center",false,false,false,true)
	
	--dxDrawText("Limit:",sx*0.88,sy*0.95,sx*0.88+sx*0.115,sy*0.95+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-12"],"left","center",false,false,false,true)

	------------- Jármű komponensek -------------
	if componentShow then 
		for v in pairs ( getVehicleComponents(showVehicle) ) do
			local x,y,z = getVehicleComponentPosition ( showVehicle, v, "world" )
			local wx,wy,wz = getScreenFromWorldPosition ( x, y, z )
			if wx and wy then
				if components[v] then 
					dxDrawText(tostring(components[v][1]), wx + 1, wy - 1, 0, 0, tocolor(0,0,0,255), 1,fonts["condensed-10"])
					dxDrawText(tostring(components[v][1]), wx - 1, wy + 1, 0, 0, tocolor(0,0,0,255), 1,fonts["condensed-10"])
					dxDrawText(tostring(components[v][1]), wx, wy, 0, 0, tocolor(255,255,255,255), 1,fonts["condensed-10"])
				end 
			end
		end
	end
	---------------------------------------------

	dxDrawLine(sx*0.005,sy*0.6,sx*0.01+sx*0.185,sy*0.6,tocolor(220,220,220,100*a), 2)

	dxDrawText("Jármű adatai",0,sy*0.605,sx*0.2,sy*0.605+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-11"],"center","center",false,false,false,true)

	if selectedFactionID == 0 then 
		local dataY = 0.65
		for k, v in ipairs(vehicleDataPoints) do 

			local mertek = ""

			local data = vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][4+k]

			if k == 1 then 
				mertek = "Km/H"
			elseif k == 2 then 
				data = exports.oVehicle:getVehicleModelFuelType(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2])

				if data == "95" then 
					data = "Benzin"
				elseif data == "D" then 
					data = "Dízel"
				elseif data == "electric" then 
					data = "Elektromos"
				end
			elseif k == 3 then 
				data = exports.oVehicle:getVehicleMaxFuel(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2])

				mertek = "liter"
			elseif k == 5 then 
				data = exports.oVehicle:getVehicleTrunkMaxSize(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2])
				mertek = "kg"
			elseif k == 8 then
				data = vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][13] 
				if data then
					mertek = "doboz"
				else
					data = "Alkalmatlan" 
				end
			end

			dxDrawText(v..": "..color..tostring(data).." #dcdcdc"..mertek, sx*0.01, sy*dataY, _,_, tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-10"], _, _, false, false, false, true)
			dataY = dataY + 0.03
		end
	else
		if tableContains(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle].allowedFactions, selectedFactionID) then 
			local dataY = 0.65
			for k, v in ipairs(vehicleDataPoints) do 

				local mertek = ""

				local data = vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][4+k]

			if k == 1 then 
				mertek = "Km/H"
			elseif k == 2 then 
				data = exports.oVehicle:getVehicleModelFuelType(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2])

				if data == "95" then 
					data = "Benzin"
				elseif data == "D" then 
					data = "Dízel"
				elseif data == "electric" then 
					data = "Elektromos"
				end
			elseif k == 3 then 
				data = exports.oVehicle:getVehicleMaxFuel(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2])

				mertek = "liter"
			elseif k == 5 then 
				data = exports.oVehicle:getVehicleTrunkMaxSize(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2])
				mertek = "kg"
			end


				dxDrawText(v..": "..color..tostring(data).." #dcdcdc"..mertek, sx*0.01, sy*dataY, _,_, tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-10"], _, _, false, false, false, true)
				dataY = dataY + 0.03
			end
		else
			dxDrawText("Ez a jármű nem engedélyezett a kiválasztott frakció számára!", 0, sy*0.65, sx*0.2, sy*0.65+sy*0.25, tocolor(194, 29, 29, 255*a), 0.9/myX*sx, fonts["condensed-18"], "center", "center", false, true)
		end
	end
	
	
	if vehicleColorType == "custom" then
		if vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3] == 0 then
			dxDrawText('Ára: #49aade'..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][12])..'#cdcdcdPP',sx*0.88,sy*0.915,sx*0.88+sx*0.115,sy*0.915+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-12"],"right","center",false,false,false,true)
		else
			if vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][12] == 0 then
				dxDrawText('Ára:  '..color..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]).."#dcdcdc + "..color..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]*0.3).."#dcdcdc$",sx*0.88,sy*0.915,sx*0.88+sx*0.115,sy*0.915+sy*0.03,tocolor(220,220,220,255*a),0.9/myX*sx,fonts["condensed-12"],"right","center",false,false,false,true)
			else
				dxDrawText('Ára:  '..color..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]).."#dcdcdc + "..color..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]*0.3).."#dcdcdc$ | #49aade"..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][12])..'#cdcdcdPP',sx*0.88,sy*0.915,sx*0.88+sx*0.115,sy*0.915+sy*0.03,tocolor(220,220,220,255*a),0.9/myX*sx,fonts["condensed-12"],"right","center",false,false,false,true)
			end
		end
	else
		if vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3] == 0 then 
			dxDrawText('Ára: #49aade'..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][12])..'#cdcdcdPP',sx*0.88,sy*0.915,sx*0.88+sx*0.115,sy*0.915+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-12"],"right","center",false,false,false,true)
		else
			if vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][12] == 0 then
				dxDrawText('Ára:  '..color..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]).."#dcdcdc$",sx*0.88,sy*0.915,sx*0.88+sx*0.115,sy*0.915+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-12"],"right","center",false,false,false,true)	
			else
				dxDrawText('Ára:  '..color..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]).."#dcdcdc$ | #49aade"..comma_value(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][12])..'#cdcdcdPP',sx*0.88,sy*0.915,sx*0.88+sx*0.115,sy*0.915+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-12"],"right","center",false,false,false,true)	
			end
		end
	end

    if not vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][4] then 
        dxDrawText('Limit:  '..color.."Nincs",sx*0.88,sy*0.95,sx*0.88+sx*0.115,sy*0.95+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-12"],"right","center",false,false,false,true)
    else
        dxDrawText('Limit:  '..color..getVehicleCount(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2]).."#dcdcdc/"..tostring(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][4]),sx*0.88,sy*0.95,sx*0.88+sx*0.115,sy*0.95+sy*0.03,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-12"],"right","center",false,false,false,true)
    end

    if core:isInSlot(0,sy*0.94,sx*0.115,sy*0.025) then 
        dxDrawText("Megvásárlás", sx*0.018,sy*0.97,sx*0.018+sx*0.115,sy*0.91+sy*0.025,tocolor(greenR, greenG, greenB,255*a),1/myX*sx,fonts["condensed-11"],"left","center",false,false,false,true)
            dxDrawImage(sx*0.002,sy*0.94,20/myX*sx,20/myY*sy,"files/buy.png",0,0,0,tocolor(greenR, greenG, greenB,255*a))
    else
        dxDrawText("Megvásárlás", sx*0.018,sy*0.97,sx*0.018+sx*0.115,sy*0.91+sy*0.025,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-11"],"left","center",false,false,false,true)
            dxDrawImage(sx*0.002,sy*0.94,20/myX*sx,20/myY*sy,"files/buy.png",0,0,0,tocolor(220,220,220,255*a))
    end

   --[[if core:isInSlot(0,sy*0.94,sx*0.115,sy*0.025) then 
        dxDrawText("Teszt vezetés", sx*0.018,sy*0.94,sx*0.018+sx*0.115,sy*0.94+sy*0.025,tocolor(blueR, blueG, blueB,255*a),1/myX*sx,fonts["condensed-11"],"left","center",false,false,false,true)
            dxDrawImage(sx*0.002,sy*0.94,20/myX*sx,20/myY*sy,"files/drive.png",0,0,0,tocolor(blueR, blueG, blueB,255*a))
    else
        dxDrawText("Teszt vezetés", sx*0.018,sy*0.94,sx*0.018+sx*0.115,sy*0.94+sy*0.025,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-11"],"left","center",false,false,false,true)
            dxDrawImage(sx*0.002,sy*0.94,20/myX*sx,20/myY*sy,"files/drive.png",0,0,0,tocolor(220,220,220,255*a))
    end]]

    if core:isInSlot(0,sy*0.97,sx*0.115,sy*0.025) then  
        dxDrawText("Kilépés", sx*0.018,sy*0.97,sx*0.018+sx*0.115,sy*0.97+sy*0.025,tocolor(redR, redG, redB,255*a),1/myX*sx,fonts["condensed-11"],"left","center",false,false,false,true)
            dxDrawImage(sx*0.002,sy*0.97,20/myX*sx,20/myY*sy,"files/exit.png",0,0,0,tocolor(redR, redG, redB,255*a))
    else
        dxDrawText("Kilépés", sx*0.018,sy*0.97,sx*0.018+sx*0.115,sy*0.97+sy*0.025,tocolor(220,220,220,255*a),1/myX*sx,fonts["condensed-11"],"left","center",false,false,false,true)
            dxDrawImage(sx*0.002,sy*0.97,20/myX*sx,20/myY*sy,"files/exit.png",0,0,0,tocolor(220,220,220,255*a))
	end

	----járműforgatás----
	if vehRotate then 
		local vx,vy,vz = getElementRotation(showVehicle)
		setElementRotation(showVehicle,vx,vy,vz + 0.5)
	end 
	---------------------

	roundedRectangle(sx*0.8,sy*0.005,sx*0.197,sy*0.05,tocolor(40,40,40,220*a),tocolor(40,40,40,220*a),false)
	dxDrawRectangle(sx*0.8,sy*0.005,sx*0.197,sy*0.05,tocolor(40,40,40,220*a))

	if selectedFactionID == 0 then 
		dxDrawImage(sx*0.802,sy*0.008,40/myX*sx,40/myY*sy,":oAccount/avatars/"..getElementData(localPlayer, "char:avatarID")..".png",0,0,0,tocolor(255,255,255,255*a))
		dxDrawText("Készpénz: #7ecc7a"..comma_value(getElementData(localPlayer, "char:money")).." #cdcdcd$",sx*0.832,sy*0.008,_,_,tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-10"], _, _, false, false, false, true)
		dxDrawText("Prémiumpont: #49aade"..comma_value(getElementData(localPlayer, "char:pp")).." #cdcdcdPP",sx*0.832,sy*0.035,_,_,tocolor(220,220,220,255*a), 1/myX*sx, fonts["condensed-10"], _, _, false, false, false, true)

		local ownedVehicle = getPlayerAllOwnedVehicle()
		local szazalek = tonumber(#ownedVehicle/getElementData(localPlayer, "char:vehSlot"))*100
		local textColor = color

		if szazalek < 25 then 
			textColor = "#6ba348"
		elseif szazalek >= 25 and szazalek < 75 then 
			textColor = color
		elseif szazalek >= 75 then 
			textColor = "#c21d1d"
		end 
		dxDrawText(textColor..#ownedVehicle.."#dcdcdc/"..getElementData(localPlayer, "char:vehSlot"),sx*0.8, sy*0.005, sx*0.8+sx*0.192,sy*0.005+sy*0.05, tocolor(255,255,255,255*a),1/myX*sx,fonts["bebasneue-18"], "right", "center", false, false, false, true)

	else
		dxDrawImage(sx*0.802,sy*0.007,42/myX*sx,40/myY*sy,"files/logo.png",0,0,0,tocolor(r, g, b, 255*a))
		dxDrawText("Frakció egyenleg: #7ecc7a"..comma_value(exports.oDashboard:getFactionMoney(selectedFactionID)).." #cdcdcd$",sx*0.832,sy*0.018,_,_,tocolor(220,220,220,255*a), 0.9/myX*sx, fonts["condensed-12"], _, _, false, false, false, true)
	end

	local realStartY = sy*0.5 - sy*0.405/2
	dxDrawRectangle(sx*0.85, realStartY, sx*0.145, sy*0.405,tocolor(40,40,40,240*a))
	local startY = realStartY + sy*0.002
	for i = 1, 20 do 
		local bgcolor = tocolor(30, 30, 30, 100*a)

		if ((i+categoryScroll) % 2) == 0 then 
			bgcolor = tocolor(30, 30, 30, 200*a)
		end

		dxDrawRectangle(sx*0.851, startY, sx*0.14, sy*0.02, bgcolor)

		if vehicles[shopType][i+categoryScroll] then 
			if i+categoryScroll == selectedVehicleCategory then
				dxDrawText(vehicles[shopType][i+categoryScroll].category_name .. " ("..#vehicles[shopType][i+categoryScroll].category_cars..")", sx*0.851, startY, sx*0.851+ sx*0.14, startY+ sy*0.02, tocolor(r, g, b, 255 * a), 0.45/myX*sx, fonts["condensed-18"], "center", "center", false, false, false, true)
			else
				dxDrawText(vehicles[shopType][i+categoryScroll].category_name .. color .. " ("..#vehicles[shopType][i+categoryScroll].category_cars..")", sx*0.851, startY, sx*0.851+ sx*0.14, startY+ sy*0.02, tocolor(255, 255, 255, 255 * a), 0.45/myX*sx, fonts["condensed-18"], "center", "center", false, false, false, true)
			end
		end
		startY = startY + sy*0.02
	end

	dxDrawRectangle(sx*0.992, realStartY + sy*0.002, sx*0.0015, sy*0.4, tocolor(r, g, b, 100*a))

	local lineHeight = math.min(20 / #vehicles[shopType], 1)
	dxDrawRectangle(sx*0.992, realStartY + sy*0.002 + (sy*0.4*(lineHeight*categoryScroll/20)), sx*0.0015, sy*0.4*lineHeight, tocolor(r, g, b, 255*a))

	if (buySelect) then
		dxDrawRectangle((sx * 0.5) - 2, (sy * 0.5 - sy * 0.1 / 2) - 2, sx * 0.1+4, sy * 0.1+4, tocolor(40,40,40,230*a))
		dxDrawRectangle(sx * 0.5, sy * 0.5 - sy * 0.1 / 2, sx * 0.1, sy * 0.1, tocolor(40,40,40,245*a))

		dxDrawText('Fizetési mód', (sx * 0.5+sx * 0.01) + sx * 0.08 / 2, sy * 0.505 - sy * 0.1 / 2, _, _, tocolor(205, 205, 205, 240*a), 0.00052083333*sx, fonts["condensed-11"], 'center', 'top')
		dxDrawRectangle(sx * 0.5+sx * 0.01, sy * 0.525 - sy * 0.1 / 2, sx * 0.08, 2, tocolor(205, 205, 205, 210*a))

		

		--dxDrawRectangle(sx * 0.5+4, sy * 0.53 - sy * 0.1 / 2 + 4, sx * 0.1-8, sy * 0.04-12, tocolor(73, 170, 222,230*a))
		--dxDrawRectangle(sx * 0.5+6, sy * 0.53 - sy * 0.1 / 2 + 6, sx * 0.1-12, sy * 0.04-16, tocolor(73, 170, 222,245*a))
		--dxDrawText('Prémiumpont', (sx * 0.5+sx * 0.01) + sx * 0.08 / 2, sy * 0.54 - sy * 0.1 / 2, _, _, tocolor(255, 255, 255, 240*a), 0.00052083333*sx, fonts["condensed-11"], 'center', 'top')

		core:dxDrawButton(sx * 0.5+4, sy * 0.53 - sy * 0.1 / 2 + 4, sx * 0.1-8, sy * 0.04-12, 73, 170, 222,230*a, 'Prémiumpont', tocolor(255, 255, 255, 240*a), 0.00052083333*sx, fonts["condensed-11"], true, tocolor(14,14,14,100))
		--if core:isInSlot(sx * 0.5+6, sy * 0.53 - sy * 0.1 / 2 + 6, sx * 0.1-12, sy * 0.04-16) then
		--	dxDrawRectangle(sx * 0.5+6, sy * 0.53 - sy * 0.1 / 2 + 6, sx * 0.1-12, sy * 0.04-16, tocolor(0, 0, 0,50*a))	
		--end

		core:dxDrawButton(sx * 0.5+4, sy * 0.563 - sy * 0.1 / 2 + 4, sx * 0.1-8, sy * 0.04-12, 126, 204, 122,230*a, 'Készpénz', tocolor(255, 255, 255, 240*a), 0.00052083333*sx, fonts["condensed-11"], true, tocolor(14,14,14,100))
		--dxDrawRectangle(sx * 0.5+4, sy * 0.563 - sy * 0.1 / 2 + 4, sx * 0.1-8, sy * 0.04-12, tocolor(126, 204, 122,230*a))
		--dxDrawRectangle(sx * 0.5+6, sy * 0.563 - sy * 0.1 / 2 + 6, sx * 0.1-12, sy * 0.04-16, tocolor(126, 204, 122,245*a))
		--dxDrawText('Készpénz', (sx * 0.5+sx * 0.01) + sx * 0.08 / 2, sy * 0.573 - sy * 0.1 / 2, _, _, tocolor(255, 255, 255, 240*a), 0.00052083333*sx, fonts["condensed-11"], 'center', 'top')

		--if core:isInSlot(sx * 0.5+6, sy * 0.563 - sy * 0.1 / 2 + 6, sx * 0.1-12, sy * 0.04-16) then
		--	dxDrawRectangle(sx * 0.5+6, sy * 0.563 - sy * 0.1 / 2 + 6, sx * 0.1-12, sy * 0.04-16, tocolor(0, 0, 0,50*a))	
		--end
		--dxDrawRectangle(sx * 0.5, sy * 0.5 - sy * 0.1 / 2, sx * 0.1, sy * 0.04, tocolor(40,40,40,245*a))

		--dxDrawTextfonts["condensed-18"]
	end
	--[[if testDrivePanelShowing then -- tesztvezetés panel
		--dxDrawRectangle(sx*0.3,sy*0.2,sx*0.2,sy*0.1,tocolor(40,40,40,255))
		
		local startY = sy*0.1
		for i=1, 3 do 
			if core:isInSlot(sx*0.45,startY,320/myX*sx,180/myY*sy) then 
				dxDrawImage(sx*0.45,startY,320/myX*sx,180/myY*sy,"files/"..tostring(i)..".png",0,0,0,tocolor(255,255,255,255*a_testdrive))
				dxDrawText(testDrives[i],sx*0.45,startY,sx*0.45+320/myX*sx,startY+180/myY*sy,tocolor(220,220,220,220*a_testdrive),1/myX*sx,fonts["condensed-18"],"center","center")
			else
				dxDrawImage(sx*0.45,startY,320/myX*sx,180/myY*sy,"files/"..tostring(i)..".png",0,0,0,tocolor(255,255,255,220*a_testdrive))
				dxDrawText(testDrives[i],sx*0.45,startY,sx*0.45+320/myX*sx,startY+180/myY*sy,tocolor(220,220,220,150*a_testdrive),1/myX*sx,fonts["condensed-18"],"center","center")
			end
			startY = startY + sy*0.21
		end
	end]]
end

local renderChooser = false

function closeChooser()
	renderChooser = false
	removeEventHandler("onClientRender", root, renderFactionChooser)
	removeEventHandler("onClientKey", root, chooserKey)
	unbindKey("backspace", "up", closeChooser)
	buySelect = false
	setElementFrozen(localPlayer, false)
end

function renderFactionChooser()
	local starty = 0

	starty = sy*0.5 - (#factionsWherePlayerIsLeader * (sy*0.045/2))

	--dxDrawLine(0, sy*0.5, sx, sy*0.5)

	dxDrawRectangle(sx*0.4, starty, sx*0.2, sy*0.046*#factionsWherePlayerIsLeader, tocolor(40, 40, 40, 255))

	local textStart = starty + 3/myY*sy 

	for k, v in ipairs(factionsWherePlayerIsLeader) do 
		dxDrawRectangle(sx*0.4+3/myX*sx, textStart, sx*0.2-6/myX*sx, sy*0.04, tocolor(30, 30, 30, 255))

		if core:isInSlot(sx*0.4+3/myX*sx, textStart, sx*0.2-6/myX*sx, sy*0.04) then 
			dxDrawText(exports.oDashboard:getFactionName(v), sx*0.4+3/myX*sx, textStart, sx*0.4+3/myX*sx+sx*0.2-6/myX*sx, textStart+sy*0.04, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-11"], "center", "center")
		else
			dxDrawText(exports.oDashboard:getFactionName(v), sx*0.4+3/myX*sx, textStart, sx*0.4+3/myX*sx+sx*0.2-6/myX*sx, textStart+sy*0.04, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-11"], "center", "center")
		end

		textStart = textStart + sy*0.045
	end
end

function chooserKey(key, state)
	if state then 
		if key == "mouse1" then 
			local starty = 0

			starty = sy*0.5 - (#factionsWherePlayerIsLeader * (sy*0.045/2))

			local textStart = starty + 3/myY*sy 

			for k, v in ipairs(factionsWherePlayerIsLeader) do 
				if core:isInSlot(sx*0.4+3/myX*sx, textStart, sx*0.2-6/myX*sx, sy*0.04) then 
					selectedFactionID = v 

					showCarshop()
					renderChooser = false
					removeEventHandler("onClientRender", root, renderFactionChooser)
					buySelect = false
					removeEventHandler("onClientKey", root, chooserKey)
					unbindKey("backspace", "up", closeChooser)
					break
				end

				textStart = textStart + sy*0.045
			end
		end
	end
end

function pedClick(button, state, _, _, _, _, _, element)

	if carshopShowing then 
		if button == "left" then 
			if core:isInSlot(sx*0.485,sy*0.908,sx*0.015,sy*0.03) then  --sx*0.48,sy*0.908,sx*0.015,sy*0.03
				if state == "down" then 
					vehRotate = true 
					setElementFrozen(showVehicle,true)
				else 
					vehRotate = false
					setElementFrozen(showVehicle,false)
				end 
			elseif core:isInSlot(sx*0.499,sy*0.908,sx*0.015,sy*0.03) then 
				if state == "down" then 
					if not componentShow then 
						componentShow = true 
					else 
						componentShow = false 
					end
				end
			end

		------------- Jármű komponensek -------------
		if state == "down" then
			if componentShow then 
				for v in pairs ( getVehicleComponents(showVehicle) ) do
					local x,y,z = getVehicleComponentPosition ( showVehicle, v, "world" )
					local wx,wy,wz = getScreenFromWorldPosition ( x, y, z )
					if wx and wy then
						if components[v] then 
							if core:isInSlot(wx, wy, 2*dxGetTextWidth(components[v][1], 1,fonts["condensed-10"])/2, 15) then 

								--[[if components[v][2] == 10 then 
									if not components[v][3] then
										local x,y,z = getVehicleComponentPosition ( showVehicle, v, "world" )
										setCameraMatrix(x + 1,y - 1,z,x,y,z - 0.5,0,100)
										components[v][1] = "Exterior"
										components[v][3] = true
										return
									else 
										setCameraMatrix(vehicle_show_camera[shopType][1],vehicle_show_camera[shopType][2],vehicle_show_camera[shopType][3],vehicle_show_camera[shopType][4],vehicle_show_camera[shopType][5],vehicle_show_camera[shopType][6])
										components[v][1] = "Interior"
										components[v][3] = false
										return
									end
								end ]]

								if not components[v][3] then 
									setVehicleDoorOpenRatio(showVehicle,components[v][2],1, 400)
									components[v][3] = true
								else 
									setVehicleDoorOpenRatio(showVehicle,components[v][2],0, 400)
									components[v][3] = false
								end 
							end 
						end 
					end
				end
			end
		end
		---------------------------------------------

		end 
	end 

	if button == "right" and state == "up" then 
		if element then 
			if getElementData(element, "vehicle:dealer:type") then 
				if core:getDistance(element,localPlayer) < 3 then 
					if not carshopShowing then 
						shopType = getElementData(element, "vehicle:dealer:type") or 1

						selectedFactionID = 0

						if not (shopType == 2) then 
							--selectedVehicle = 1
							showCarshop()
						else
							if not renderChooser then 
								local factions = exports.oDashboard:getPlayerAllFactions()
								factionsWherePlayerIsLeader = {}

								for k, v in pairs(factions) do 
									if exports.oDashboard:isPlayerLeader(v) then 
										table.insert(factionsWherePlayerIsLeader, #factionsWherePlayerIsLeader+1, v)
									end
								end

								if #factionsWherePlayerIsLeader == 0 then 
									outputChatBox(core:getServerPrefix("red-dark", "Járműkereskedés", 3).."Nem vagy egyetlen szervezet vezetője sem!", 255, 255, 255, true)
								else
									setElementFrozen(localPlayer, true)
									setElementAlpha(localPlayer, 150)
									outputChatBox(core:getServerPrefix("server", "Járműkereskedés", 3).."Válaszd ki, hogy melyik szervezet számára szeretnéd a járművet vásárolni!", 255, 255, 255, true)
									renderChooser = true
									addEventHandler("onClientRender", root, renderFactionChooser)
									addEventHandler("onClientKey", root, chooserKey)

									bindKey("backspace", "up", closeChooser)
								end
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientClick", root, pedClick)

function carshopInteraction(key, state)
	if carshopShowing then 
		if state then 
			if not vehicleAnimating then 
				if key == "arrow_r" then 
					if selectedVehicle < #vehicles[shopType][selectedVehicleCategory].category_cars then 
						selectedVehicle = selectedVehicle + 1
						changeShowVehicle()
					else
						selectedVehicle = 1
						changeShowVehicle()
					end
				end
				if key == "arrow_l" then 
					if selectedVehicle > 1 then 
						selectedVehicle = selectedVehicle - 1
						changeShowVehicle()
					else
						selectedVehicle = #vehicles[shopType][selectedVehicleCategory].category_cars
						changeShowVehicle()
					end
				end
			end

			if key == "mouse1" then 
				if core:isInSlot(0,sy*0.97,sx*0.115,sy*0.025) then 
					showCarshop()
					return 
				end

				--[[if core:isInSlot(0,sy*0.94,sx*0.115,sy*0.025) then 
					if shopType == 1 then
						triggerServerEvent("makeTestveh", resourceRoot, {2840.0612792969, -2054.8725585938, 10.495502471924+3, 359.90957641602}, vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2], vehicleColor)
						addEventHandler("onClientVehicleExit", resourceRoot, exitTestVehicle)
						infobox:outputInfoBox("Elkezdted a tesztvezetést! Befejezéshez szállj ki a járműből!","info")
						showCarshop()
						createBorderWalls()

						return 
					else
						infobox:outputInfoBox("Ez a funkció ebben a típusú kereskedésben nem érhető el!","error")
					end
				end]]

				if core:isInSlot(0,sy*0.94,sx*0.115,sy*0.025) then 
					local price = countVehiclePrice()

					if selectedFactionID == 0 then 
						if not buySelect then
							buySelect = true
						else
							buySelect = false
						end
					else
						if exports.oDashboard:getFactionMoney(selectedFactionID) >= price[1] then 
							if tableContains(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle].allowedFactions, selectedFactionID) then 
								triggerServerEvent("buyCarshopVehicleToFaction", resourceRoot, vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2], vehicleColor, selectedFactionID, price[1], price[2], shopType, vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle].pj or 0)
								showCarshop()
								infobox:outputInfoBox("Sikeresen megvásároltad a kiválasztott járművet!","success")
							else
								infobox:outputInfoBox("Nem engedélyezett!","warning")
							end
						else
							infobox:outputInfoBox("Nincs elegendő pénz a frakció számláján vásárláshoz! ("..comma_value(price[1]).."$)", "error")
						end
						return 
					end
				end

				if buySelect then
					if core:isInSlot(sx * 0.5+6, sy * 0.53 - sy * 0.1 / 2 + 6, sx * 0.1-12, sy * 0.04-16) then
						local playerVehicles = getPlayerAllOwnedVehicle()
						if (getElementData(localPlayer, "char:vehSlot") > #playerVehicles) then
							local x, y, z = getElementPosition(localPlayer)
							local city = getZoneName(x, y, z, true)
							triggerServerEvent("buyCarshopVehicle", resourceRoot, vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2], vehicleColor, 0, vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][12], shopType, city)
							showCarshop()
						else
							infobox:outputInfoBox("Nincs szabad jármű slotod!", "error")
						end

					elseif core:isInSlot(sx * 0.5+6, sy * 0.563 - sy * 0.1 / 2 + 6, sx * 0.1-12, sy * 0.04-16) then
						if not (vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3] == 0) then
							local playerVehicles = getPlayerAllOwnedVehicle()
							if (getElementData(localPlayer, "char:vehSlot") > #playerVehicles) then
								if (vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][4]) then
									if tonumber(getVehicleCount(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2])) <= vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][4] then 
										local price = countVehiclePrice()
										local x, y, z = getElementPosition(localPlayer)
										local city = getZoneName(x, y, z, true)
										triggerServerEvent("buyCarshopVehicle", resourceRoot, vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2], vehicleColor, price[1], 0, shopType, city)
										showCarshop()
									else
										infobox:outputInfoBox("Ez a jarmű limites!", "error")
									end
								else
									local price = countVehiclePrice()
									local x, y, z = getElementPosition(localPlayer)
									local city = getZoneName(x, y, z, true)
									triggerServerEvent("buyCarshopVehicle", resourceRoot, vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2], vehicleColor, price[1], 0, shopType, city)
									showCarshop()
								end
							else
								infobox:outputInfoBox("Nincs szabad jármű slotod!", "error")
							end
						else
							infobox:outputInfoBox("Ez a jármű csak prémiumpontból vásárolható!", "error")
						end
					end
				end


				local colorX, colorY = sx*0.045,sy*0.13
				for k,v in ipairs(vehicle_default_colors) do 
					if k == 5 then 
						colorX, colorY = sx*0.045, colorY + sy*0.05
					end

					if core:isInSlot(colorX, colorY, 35/myX*sx, 35/myY*sy) then 
						vehicleColor = {v[1],v[2],v[3]}
						setVehicleColor(showVehicle, vehicleColor[1],vehicleColor[2],vehicleColor[3])
						vehicleColorType = "default"
						activeColorInput = false
						selectedColor = k
						return
					end

					colorX = colorX + 40/myX*sx
				end

				--[[if testDrivePanelShowing then -- tesztvezetés panel
					local startY = sy*0.1
					for i=1, 3 do 
						if core:isInSlot(sx*0.45,startY,320/myX*sx,180/myY*sy) then 
							triggerServerEvent("makeTestveh", resourceRoot, i, vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2], vehicleColor[1], vehicleColor[2], vehicleColor[3], localPlayer)
							addEventHandler("onClientVehicleExit", resourceRoot, exitTestVehicle)
							infobox:outputInfoBox("Elkezdted a tesztvezetést! Befejezéshez szálj ki a járműből!","info")
							showCarshop()
						end
						startY = startY + sy*0.21
					end
				end]]

				local realStartY = sy*0.5 - sy*0.405/2
				local startY = realStartY + sy*0.002
				for i = 1, 20 do 
					if vehicles[shopType][i+categoryScroll] then 
						if core:isInSlot(sx*0.851, startY, sx*0.14, sy*0.02) then
							if (i + categoryScroll) == selectedVehicleCategory then 
							else
								if isTimer(animateTimer) then return end
								selectedVehicleCategory = i + categoryScroll
								selectedVehicle = 1
								changeShowVehicle()
							end
						end
					end
					startY = startY + sy*0.02
				end
			elseif key == "mouse_wheel_down" then 
				local realStartY = sy*0.5 - sy*0.405/2
				if core:isInSlot(sx*0.85, realStartY, sx*0.145, sy*0.405) then 
					if vehicles[shopType][categoryScroll + 21] then 
						categoryScroll = categoryScroll + 1
					end
				end 
			elseif key == "mouse_wheel_up" then 
				local realStartY = sy*0.5 - sy*0.405/2
				if core:isInSlot(sx*0.85, realStartY, sx*0.145, sy*0.405) then 
					if categoryScroll > 0 then 
						categoryScroll = categoryScroll - 1
					end
				end
			end
		end
	end
end
addEventHandler("onClientKey", root, carshopInteraction)

function getVehicleCount(vehicleID)
    limitnum = exports.oVehicle:getVehicleLimits(vehicleID) or 10
    return tostring(limitnum)
end

function countVehiclePrice()
	local price = {0,0}

	if vehicleColorType == "custom" then
		price[1] = vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]+(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]*0.3)
	else
		price[1] = vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][3]
	end

	if vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][4] then 
		if tonumber(getVehicleCount(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2])) >= vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][4] then 
			price[2] = 2000
		end
	end

	return price
end

function createShowVehicle()
	showVehicle = createVehicle(vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle][2],vehicle_show_pos[shopType][1],vehicle_show_pos[shopType][2],vehicle_show_pos[shopType][3],0,0,vehicle_show_pos[shopType][4])
	setVehicleVariant(showVehicle, 255, 255)
	setVehicleColor(showVehicle, vehicleColor[1],vehicleColor[2],vehicleColor[3])
	setElementAlpha(showVehicle,0)
	setElementData(showVehicle, "showVehicle", true)

	if vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle].pj then 
		setElementData(showVehicle, "veh:paintjob", vehicles[shopType][selectedVehicleCategory].category_cars[selectedVehicle].pj)
	end
end

function changeShowVehicle()
	vehicleAlphaAnimType = 2
	vehicleAlphaAnimTick = getTickCount()
	pageTick = getTickCount()

	animateShowVehicle()
	animateTimer = setTimer(function() 
		if showVehicle then 
			destroyElement(showVehicle)
			showVehicle = false
		end
		vehicleAlphaAnimType = 1
		createShowVehicle() 
		setTimer(function() 
			vehicleAlphaAnimTick = getTickCount()
			animateShowVehicle()
		end, 150, 1)

		--[[setTimer(function()
			if components["windscreen_dummy"][3] then 
				if getVehicleType(showVehicle) == "Automobile" then
					local x,y,z = getVehicleComponentPosition ( showVehicle, "windscreen_dummy", "world" )
					setCameraMatrix(x + 1,y - 1,z,x,y,z - 0.5,0,100)
				else 
					setCameraMatrix(vehicle_show_camera[shopType][1],vehicle_show_camera[shopType][2],vehicle_show_camera[shopType][3],vehicle_show_camera[shopType][4],vehicle_show_camera[shopType][5],vehicle_show_camera[shopType][6])
					components["windscreen_dummy"][1] = "Interior"
					components["windscreen_dummy"][3] = false
				end 
			end
		end,500,1)]]--

	end, vehicleAlphaAnimTime, 1)
end

--[[function exitTestVehicle()
	if getElementData(localPlayer, "carshop:inTest") then 
		if getElementData(localPlayer,"carshop:testveh") == source then 
			triggerServerEvent("deleteTestveh", resourceRoot)
			infobox:outputInfoBox("Befejezted a tesztvezetést!","info")
			showCarshop()
			removeEventHandler("onClientVehicleExit", resourceRoot, exitTestVehicle)

			destroyBorders()
		end
	end
end]]

function renderAlpha()
	if vehicleAlphaAnimType == 1 then 
		vehicleAlpha = interpolateBetween(0,0,0,255,0,0,(getTickCount()-vehicleAlphaAnimTick)/vehicleAlphaAnimTime,"Linear")
	else
		vehicleAlpha = interpolateBetween(255,0,0,0,0,0,(getTickCount()-vehicleAlphaAnimTick)/vehicleAlphaAnimTime,"Linear")
	end
	setElementAlpha(showVehicle, vehicleAlpha)
end

function animateShowVehicle()
	if not vehicleAnimating then 
		vehicleAnimating = true 
		addEventHandler("onClientRender", root, renderAlpha)

		setTimer(function() 
			removeEventHandler("onClientRender", root, renderAlpha)
			vehicleAnimating = false
		end, vehicleAlphaAnimTime,1)
	end
end

function showCarshop()
	if carshopShowing then 
		panelTick = getTickCount()
		panelAnimType = 2
		vehicleAnimating = false
		buySelect = false
		vehicleAlphaAnimType = 2
		vehicleAlphaAnimTick = getTickCount()
		vehicelAlpha = 255
		animateShowVehicle()
		removeEventHandler("onClientCharacter", getRootElement(), onClientPanelCharacter)
		setTimer(function() removeEventHandler("onClientHUDRender", root, drawPanel) end, 500, 1)
		removeEventHandler("onClientKey", getRootElement(), onClientPanelKey)
		removeEventHandler("onClientClick", getRootElement(), onClientPanelClick)
		setElementData(localPlayer,"inCarshop",false)

		setTimer( function() 
			setCameraTarget(localPlayer, localPlayer)
			if showVehicle then
				showChat(true) 
				destroyElement(showVehicle)
				showVehicle = false
				carshopShowing = false	
				interface:toggleHud()
				testDrivePanelShowing = false
			end
		end, vehicleAlphaAnimTime, 1)

		setTimer(function() 
			setElementFrozen(localPlayer, false) 
			setElementAlpha(localPlayer, 255)
		end, 3000, 1)

		if isElement(bgMusic) then destroyElement(bgMusic) end
	else
		selectedVehicle = 1 
		selectedVehicleCategory = 1
		setElementFrozen(localPlayer, true)
		setElementAlpha(localPlayer, 150)
		showChat(false)
		categoryScroll = 0
		carshopShowing = true
		panelTick = getTickCount()
		pageTick = getTickCount()
		panelAnimType = 1
		vehicleAlphaAnimType = 1
		vehicleAlphaAnimTick = getTickCount()
		vehicelAlpha = 0
		vehicleAnimating = false
		interface:toggleHud()
		addEventHandler("onClientCharacter", getRootElement(), onClientPanelCharacter)
		addEventHandler("onClientHUDRender", root, drawPanel)
		addEventHandler("onClientKey", getRootElement(), onClientPanelKey)
		addEventHandler("onClientClick", getRootElement(), onClientPanelClick)
		setElementData(localPlayer,"inCarshop",true)
		createShowVehicle()
		animateShowVehicle()
		setCameraMatrix(vehicle_show_camera[shopType][1],vehicle_show_camera[shopType][2],vehicle_show_camera[shopType][3],vehicle_show_camera[shopType][4],vehicle_show_camera[shopType][5],vehicle_show_camera[shopType][6])

		local px, py, pz = getElementPosition(localPlayer)

		bgMusic = playSound("files/music.wav", true)
		setSoundVolume(bgMusic, 0.7)
	end
end
--setTimer(showCarshop,100,1)

function selectedVehicleShow()
	outputChatBox(selectedVehicle, 255, 255, 255, true)
end
addCommandHandler("selectedveh", selectedVehicleShow)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if carshopShowing then 
		interface:toggleHud()
		setCameraTarget(localPlayer, localPlayer)
	elseif getElementData(localPlayer, "carshop:inTest") then 
		triggerServerEvent("deleteTestveh", resourceRoot, localPlayer)
		deleteTestvehh()
	end
end)
--setTimer(showCarshop,150,1)

function getPlayerAllOwnedVehicle()
	local vehicles = {}
	for k, v in ipairs(getElementsByType("vehicle")) do 
		if getElementData(v, "veh:isFactionVehice") == 0 then 
			if getElementData(v, "veh:owner") == getElementData(localPlayer,"char:id") then 
				table.insert(vehicles, #vehicles+1, v)
			end	
		end
	end
	
	return vehicles
end


--=======[ Colorpicker ]=========

local activeItem = false
local hoveredInputfield = false

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local colorPanel = {
	isActive = false,
	hue = 0.5,
	saturation = 0,
	lightness = 1,
	colorInputs = {
		rgb = {
			width = dxGetTextWidth("255", 1, fonts["condensed-11"]) + 10,
			red = 255,
			green = 255,
			blue = 255
		},
		hex = {
			width = dxGetTextWidth("#FFFFFF", 1, fonts["condensed-11"]) + 10,
			hex = "#FFFFFF"
		}
	},
	selectedColor = tocolor(255, 255, 255)
}


colorPanel.width = 290/myX*sx
colorPanel.height = 280/myX*sx
colorPanel.posX = (sx - colorPanel.width) * 0.01
colorPanel.posY = sy*0.28
colorPanel.barHeight = 25/myX*sx
colorPanel.paletteWidth = colorPanel.width - 20/myX*sx
colorPanel.paletteHeight = colorPanel.height - 20/myY*sy - colorPanel.barHeight * 2
colorPanel.palettePosX = colorPanel.posX + 10/myX*sx
colorPanel.palettePosY = colorPanel.posY + 10/myX*sx
colorPanel.inputPosY = colorPanel.palettePosY + colorPanel.paletteHeight + 5/myX*sx
colorPanel.luminancePosY = colorPanel.inputPosY + colorPanel.barHeight + 5
colorPanel.luminanceHeight = 10/myX*sx
function drawColorPicker()
	local cursorX, cursorY = getCursorPosition()
	dxDrawImage(colorPanel.palettePosX, colorPanel.palettePosY, colorPanel.paletteWidth, colorPanel.paletteHeight, "files/colorpalette.png", 0, 0, 0, tocolor(255, 255, 255, 255*a))
	
	if core:isInSlot(colorPanel.palettePosX, colorPanel.palettePosY, colorPanel.paletteWidth, colorPanel.paletteHeight) and getKeyState("mouse1") then
		colorPanel.hue = (cursorX*sx - colorPanel.palettePosX) / colorPanel.paletteWidth
		colorPanel.saturation = (colorPanel.paletteHeight + colorPanel.palettePosY - cursorY*sy) / colorPanel.paletteHeight

		local r, g, b = hslToRgb(colorPanel.hue, colorPanel.saturation, colorPanel.lightness)
		colorPanel.selectedColor = tocolor(r * 255, g * 255, b * 255, 255)
		
		processColorpickerUpdate(true)
	end
	
	local colorX = (colorPanel.palettePosX + (colorPanel.hue * colorPanel.paletteWidth)) - 5
	local colorY = (colorPanel.palettePosY + (1 - colorPanel.saturation) * colorPanel.paletteHeight) - 5
	local r, g, b = hslToRgb(colorPanel.hue, colorPanel.saturation, 0.5)
	
	dxDrawRectangle(colorX - 1, colorY - 1, 10 + 2, 10 + 2, tocolor(35, 35, 35, 255*a))
	dxDrawRectangle(colorX, colorY, 10, 10, tocolor(r * 255, g * 255, b * 255, 255*a))
	
	dxDrawText("RGB:", colorPanel.palettePosX, colorPanel.inputPosY, colorPanel.palettePosX + colorPanel.paletteWidth, colorPanel.inputPosY + colorPanel.barHeight, tocolor(220, 220, 220, 255*a), 1/myX*sx, fonts["condensed-11"], "left", "center")
	
	for k, v in ipairs({"red", "green", "blue"}) do
		local rowX = colorPanel.palettePosX + 45 + ((k - 1) * (colorPanel.colorInputs.rgb.width + 3))
		
		if activeColorInput == v then
			dxDrawRectangle(rowX - 2/myX*sx+1, colorPanel.inputPosY - 2, colorPanel.colorInputs.rgb.width + 4, colorPanel.barHeight + 4, tocolor(233, 118, 25, 255*a))
		end
		dxDrawRectangle(rowX, colorPanel.inputPosY, colorPanel.colorInputs.rgb.width, colorPanel.barHeight, tocolor(30, 30, 30, 220 * a))
	
		if core:isInSlot(rowX, colorPanel.inputPosY, colorPanel.colorInputs.rgb.width, colorPanel.barHeight) then
			hoveredInputfield = v
		end
		
		dxDrawText(colorPanel.colorInputs.rgb[v], rowX, colorPanel.inputPosY, rowX + colorPanel.colorInputs.rgb.width, colorPanel.inputPosY + colorPanel.barHeight, tocolor(220, 220, 220, 255*a), 1/myX*sx, fonts["condensed-11"], "center", "center")
	end
	
	dxDrawText("HEX:", colorPanel.palettePosX, colorPanel.inputPosY, colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width - 5, colorPanel.inputPosY + colorPanel.barHeight, tocolor(220, 220, 220, 255*a), 1, fonts["condensed-11"], "right", "center")
	if activeColorInput == "hex" then
		dxDrawRectangle(colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width - 2, colorPanel.inputPosY - 2, colorPanel.colorInputs.hex.width + 4, colorPanel.barHeight + 4, tocolor(233, 118, 25, 255*a))
	end
	dxDrawRectangle(colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width, colorPanel.inputPosY, colorPanel.colorInputs.hex.width, colorPanel.barHeight, tocolor(30, 30, 30, 220 * a))
	
	if core:isInSlot(colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width, colorPanel.inputPosY, colorPanel.colorInputs.hex.width, colorPanel.barHeight) then
		hoveredInputfield = "hex"
	end
	dxDrawText(colorPanel.colorInputs.hex.hex, colorPanel.palettePosX + colorPanel.paletteWidth - colorPanel.colorInputs.hex.width, colorPanel.inputPosY, colorPanel.palettePosX + colorPanel.paletteWidth, colorPanel.inputPosY + colorPanel.barHeight, tocolor(220, 220, 220, 255*a), 1, fonts["condensed-11"], "center", "center")
	
	dxDrawRectangle(colorPanel.palettePosX - 1, colorPanel.luminancePosY - 1, colorPanel.paletteWidth + 2, colorPanel.luminanceHeight + 2, tocolor(220, 220, 220, 255*a))
	
	for i = 0, colorPanel.paletteWidth do
		local r, g, b = hslToRgb(colorPanel.hue, colorPanel.saturation, i / colorPanel.paletteWidth)
		
		dxDrawRectangle(colorPanel.palettePosX + i, colorPanel.luminancePosY, 1, colorPanel.luminanceHeight, tocolor(r * 255, g * 255, b * 255, 255*a))
	end
	
	dxDrawRectangle(colorPanel.palettePosX + reMap(colorPanel.lightness, 0, 1, 0, colorPanel.paletteWidth), colorPanel.luminancePosY - 5, 5, colorPanel.luminanceHeight + 10, tocolor(220, 220, 220, 255*a))
	
	if core:isInSlot(colorPanel.palettePosX - 5, colorPanel.luminancePosY - 5, colorPanel.paletteWidth + 10, colorPanel.luminanceHeight + 10) and getKeyState("mouse1")  then
		colorPanel.lightness = reMap(cursorX*sx - colorPanel.palettePosX, 0, colorPanel.paletteWidth, 0, 1)
		processColorpickerUpdate(true)
	end
end

function onClientPanelClick(button, state, _, _, worldX, worldY, worldZ)
	if button == "left" and state == "down" then
		activeColorInput = false
		if hoveredInputfield then
			activeColorInput = hoveredInputfield
		else
			activeColorInput = false
		end
	end
end

function onClientPanelKey(key, press)
	if not press then
		return
	end
	if key == "backspace" then
		cancelEvent()
		
		if activeColorInput then 
			if activeColorInput == "hex" then
				if utf8.len(colorPanel.colorInputs.hex[activeColorInput]) > 1 then
					colorPanel.colorInputs.hex[activeColorInput] = utf8.sub(colorPanel.colorInputs.hex[activeColorInput], 1, utf8.len(colorPanel.colorInputs.hex[activeColorInput]) - 1)

					setVehicleColor(showVehicle, colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
					vehicleColorType = "custom"
					selectedColor = 0
					vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
				end
			else
				if utf8.len(colorPanel.colorInputs.rgb[activeColorInput]) > 0 then
					colorPanel.colorInputs.rgb[activeColorInput] = tonumber(utf8.sub(colorPanel.colorInputs.rgb[activeColorInput], 1, utf8.len(colorPanel.colorInputs.rgb[activeColorInput]) - 1)) or 0
					
					colorPanel.hue, colorPanel.saturation, colorPanel.lightness = rgbToHsl(colorPanel.colorInputs.rgb.red / 255, colorPanel.colorInputs.rgb.green / 255, colorPanel.colorInputs.rgb.blue / 255)
					colorPanel.colorInputs.hex.hex = rgbToHex(colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
					colorPanel.selectedColor = tocolor(colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)

					setVehicleColor(showVehicle, colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
					vehicleColorType = "custom"
					selectedColor = 0
					vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
					
					if activeItem then
						activeItem.color = colorPanel.selectedColor
					end
				end
			end
		end
	end
end

function onClientPanelCharacter(character)
	character = utf8.upper(character)

	if not activeColorInput then return end
	
	if activeColorInput == "hex" then
		if utf8.len(colorPanel.colorInputs.hex[activeColorInput]) < 7 and utf8.find("0123456789ABCDEF", character) then
			colorPanel.colorInputs.hex[activeColorInput] = colorPanel.colorInputs.hex[activeColorInput] .. character
		end
		
		if utf8.len(colorPanel.colorInputs.hex[activeColorInput]) >= 7 then
			local r, g, b = fixRGB(hexToRgb(colorPanel.colorInputs.hex[activeColorInput]))
			
			colorPanel.hue, colorPanel.saturation, colorPanel.lightness = rgbToHsl(r / 255, g / 255, b / 255)
			colorPanel.colorInputs.rgb.red = r
			colorPanel.colorInputs.rgb.green = g
			colorPanel.colorInputs.rgb.blue = b
			colorPanel.selectedColor = tocolor(r, g, b)

			setVehicleColor(showVehicle, colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
			vehicleColorType = "custom"
			selectedColor = 0
			vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
			
			if activeItem then
				activeItem.color = colorPanel.selectedColor
			end
		end
	else
		if tonumber(character) then
			if utf8.len(colorPanel.colorInputs.rgb[activeColorInput]) < 3 then
				colorPanel.colorInputs.rgb[activeColorInput] = tonumber(colorPanel.colorInputs.rgb[activeColorInput] .. character)
			end
			
			colorPanel.hue, colorPanel.saturation, colorPanel.lightness = rgbToHsl(colorPanel.colorInputs.rgb.red / 255, colorPanel.colorInputs.rgb.green / 255, colorPanel.colorInputs.rgb.blue / 255)
			colorPanel.colorInputs.hex.hex = rgbToHex(colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
			colorPanel.selectedColor = tocolor(colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)

			setVehicleColor(showVehicle, colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
			vehicleColorType = "custom"
			selectedColor = 0
			vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
			
			if activeItem then
				activeItem.color = colorPanel.selectedColor
			end
		end
	end
end

function processColorpickerUpdate(selecting)
	if selecting then
		local r, g, b = hslToRgb(colorPanel.hue, colorPanel.saturation, colorPanel.lightness)
		r, g, b = fixRGB(r * 255, g * 255, b * 255)
		
		colorPanel.colorInputs.rgb.red = r
		colorPanel.colorInputs.rgb.green = g
		colorPanel.colorInputs.rgb.blue = b
		colorPanel.colorInputs.hex.hex = rgbToHex(r, g, b)
		colorPanel.selectedColor = tocolor(r, g, b)
		
		if activeItem then
			activeItem.color = colorPanel.selectedColor
		end
		setVehicleColor(showVehicle, colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
		vehicleColorType = "custom"
		selectedColor = 0
		vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
	else
		local r, g, b, a = fixRGB(getColorFromDecimal(colorPanel.selectedColor))
		
		colorPanel.hue, colorPanel.saturation, colorPanel.lightness = rgbToHsl(r / 255, g / 255, b / 255)
		colorPanel.colorInputs.rgb.red = r
		colorPanel.colorInputs.rgb.green = g
		colorPanel.colorInputs.rgb.blue = b
		colorPanel.colorInputs.hex.hex = rgbToHex(r, g, b)

		setVehicleColor(showVehicle, colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue)
		vehicleColorType = "custom"
		selectedColor = 0
		vehicleColor = {colorPanel.colorInputs.rgb.red, colorPanel.colorInputs.rgb.green, colorPanel.colorInputs.rgb.blue}
	end
end

function fixRGB(r, g, b, a)
	r = math.max(0, math.min(255, math.floor(r)))
	g = math.max(0, math.min(255, math.floor(g)))
	b = math.max(0, math.min(255, math.floor(b)))
	a = a and math.max(0, math.min(255, math.floor(a))) or 255
	
	return r, g, b, a
end

function hexToRgb(code)
	code = string.gsub(code, "#", "")
	return tonumber("0x" .. string.sub(code, 1, 2)), tonumber("0x" .. string.sub(code, 3, 4)), tonumber("0x" .. string.sub(code, 5, 6))
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

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end