local sX, sY = guiGetScreenSize()
local pX, pY = 1680, 1050
local core = exports.oCore
local serverColor = {core:getServerColor()}
local sName = core:getServerName()
local getDuty = false
local onDuty = false
local barpanel = false
local barmarker

local fonts = {
	{exports.oFont:getFont("condensed", 12)},
	{exports.oFont:getFont("bebasneue", 12)},
	{exports.oFont:getFont("bebasneue", 20)},
	{exports.oFont:getFont("condensed", 10)},
	{exports.oFont:getFont("condensed", 8)},
}

local makingstypes = {"Whiskey", "Bor", "Pezsgő", "Sör", "Pálinka", "Tequila", "Vodka", "Koktél"}

local makings = {
	["Whiskey"] = {
		{"Whiskys pohár"},
		{"Jack Daniel’s", "Jim Beam", "Hennessy", "Johnnie Walker"},
		{"Jég nélkül", "Egy kocka jéggel", "Két kocka jéggel", "Három kocka jéggel"},
		{"Citrom nélkül"},
		{"Nincs koktél esernyő"}
	},
	["Bor"] = {
		{"Boros pohár"},
		{"Vörösbor", "Édes Vörösbor", "Száraz Vörösbor", "Édes Bor"},
		{"Jég nélkül"},
		{"Citrom nélkül"},
		{"Nincs koktél esernyő"},
	},
	["Pezsgő"] = {
		{"Pezsgős pohár"},
		{"Martini Pezsgő", "Törley Pezsgő", "Blue Nun Arany Pezsgő"},
		{"Jég nélkül"},
		{"Citrom nélkül"},
		{"Nincs koktél esernyő"},
	},
	["Sör"] = {
		{"Sörös pohár", "Sörös korsó"},
		{"Csíki Sör", "Soproni Sör", "Dreher Sör", "Paulaner Sör", "Zywiec Sör", "Bernard Sör"},
		{"Jég nélkül"},
		{"Citrom nélkül"},
		{"nincs koktél esernyő"},
	},
	["Pálinka"] = {
		{"Feles pohár", "Stampedlis pohár"},
		{"Szilva Pálinka", "Barack Pálinka", "Körte Pálinka", "Chili Pálinka", "Vegyes Pálinka", "Alma Pálinka", "Áfonya Pálinka"},
		{"Jég nélkül"},
		{"Citrom nélkül"},
		{"Nincs koktél esernyő"},
	},
	["Tequila"] = {
		{"Feles pohár"},
		{"Sierra Silver Tequila", "Sierra Gold Tequila", "Tequila Rose", "Casamigos Blanco Tequila"},
		{"Jég nélkül"},
		{"Citrommal"},
		{"Nincs koktél esernyő"}
	},
	["Vodka"] = {
		{"Feles pohár"},
		{"Royal Vodka", "Kalinka Vodka", "Absolut Vodka", "Nicolaus Vodka", "Kaiser Vodka"},
		{"Jég nélkül"},
		{"Citrom nélkül"},
		{"Nincs koktél esernyő"},
	},
	["Koktél"] = {
		{"Koktélos pohár"},
		{"Bacardi", "Harvard", "Shamrock", "Tantalus", "Mojito"},
		{"Jég nélkül", "Egy kocka jéggel", "Két kocka jéggel", "Három kocka jéggel"},
		{"Citrommal"},
		{"Van koktél esernyő"},
	}
}

local orders = {}--típus, pohár, pia, jég, citrom, esernyő 
local gotorder = {}

addEventHandler("onClientRender", root,
	function ()
		if (getDuty) then
			if not(getElementData(localPlayer, "mixer:duty")) then
				dxDrawText("A munka felvételéhez nyomd meg az "..serverColor[1].."[E]#ffffff gombot.", 690/pX*sX, 800/pY*sY, 990/pX*sX, 950/pY*sY, tocolor(255, 255, 255), 1, fonts[4][1], "center", "center", false, false, false, true)
			else
				dxDrawText("A munka leadásához nyomd meg az "..serverColor[1].."[E]#ffffff gombot.", 690/pX*sX, 800/pY*sY, 990/pX*sX, 950/pY*sY, tocolor(255, 255, 255), 1, fonts[4][1], "center", "center", false, false, false, true)
			end	
		elseif (onDuty) then
			dxDrawText("A rendelés felvételéhez nyomd meg az "..serverColor[1].."[E]#ffffff gombot.", 690/pX*sX, 800/pY*sY, 990/pX*sX, 950/pY*sY, tocolor(255, 255, 255), 1, fonts[4][1], "center", "center", false, false, false, true)
			if (#orders > 0) then
				dxDrawRectangle(0/pX*sX, 0/pY*sY, 1680/pX*sX, 250/pY*sY, tocolor(32, 32, 32, 175))
				for i=1,5 do
					if (orders[i]) then
						dxDrawRectangle((-333.5+(i*336))/pX*sX, 2.5/pY*sY, 333.5/pX*sX, 245/pY*sY, tocolor(40, 40, 40, 255))
						dxDrawText("Ital típusa: "..serverColor[1]..orders[i][1], (-331+(i*336))/pX*sX, 3.5/pY*sY, (0+(i*336))/pX*sX, 43.5/pY*sY, tocolor(220, 220, 220, 255), 1, fonts[1][1], "left", "center", false, false, false, true)
						dxDrawText("Pohár fajtája: "..serverColor[1]..orders[i][2], (-331+(i*336))/pX*sX, 43.5/pY*sY, (0+(i*336))/pX*sX, 84/pY*sY, tocolor(220, 220, 220, 255), 1, fonts[1][1], "left", "center", false, false, false, true)
						dxDrawText("Ital fajtája: "..serverColor[1]..orders[i][3], (-331+(i*336))/pX*sX, 84/pY*sY, (0+(i*336))/pX*sX, 124.5/pY*sY, tocolor(220, 220, 220, 255), 1, fonts[1][1], "left", "center", false, false, false, true)
						dxDrawText("Jég mennyisége: "..serverColor[1]..orders[i][4], (-331+(i*336))/pX*sX, 124.5/pY*sY, (0+(i*336))/pX*sX, 165/pY*sY, tocolor(220, 220, 220, 255), 1, fonts[1][1], "left", "center", false, false, false, true)
						dxDrawText("Citrom: "..serverColor[1]..orders[i][5], (-331+(i*336))/pX*sX, 165/pY*sY, (0+(i*336))/pX*sX, 205.5/pY*sY, tocolor(220, 220, 220, 255), 1, fonts[1][1], "left", "center", false, false, false, true)
						dxDrawText("Koktél esernyő: "..serverColor[1]..orders[i][6], (-331+(i*336))/pX*sX, 205.5/pY*sY, (0+(i*336))/pX*sX, 246/pY*sY, tocolor(220, 220, 220, 255), 1, fonts[1][1], "left", "center", false, false, false, true)
						core:dxDrawButton((-105+(i*336))/pX*sX, 5/pY*sY, 100/pX*sX, 25/pY*sY, serverColor[2], serverColor[3], serverColor[4], 255, "Elkészítés", tocolor(225, 225, 225, 255), 1,  fonts[4][1], true, tocolor(0, 0, 0, 100))
					end	
				end
			end	
		elseif (barpanel) then
			for i=1,2 do
				dxDrawRectangle((-1330+(i*1330))/pX*sX, 0/pY*sY, 350/pX*sX, 1050/pY*sY, tocolor(32, 32, 32, 175))	
				dxDrawRectangle((-1325+(i*1330))/pX*sX, 5/pY*sY, 340/pX*sX, 1040/pY*sY, tocolor(40, 40, 40, 255))
				dxDrawText(sName.." - "..serverColor[1].."Bartender", (-1320+(i*1330))/pX*sX, 10/pY*sY, (-970+(i*1330))/pX*sX, 1050/pY*sY, tocolor(220, 220, 220, 255), 1, fonts[2][1], "left", "top", false, false, false, true)
			end
		end	
	end
)

addEventHandler("onClientKey", root,
	function ( button, state)
		if (getDuty) then
			if (button=="e") and state then
				if (getElementData(localPlayer, "mixer:duty")) then
					triggerServerEvent("Mixer:DutyChange", root, localPlayer, false)
				else
					orders = {}
					gotorder = {}
					triggerServerEvent("Mixer:DutyChange", root, localPlayer, true)
				end	
			end	
		elseif (onDuty) then
			if (button=="e") and state then
				newOrder()
			elseif (button=="mouse1") and state then
				if (#orders > 0) then
					for i=1,5 do
						if (orders[i]) then
							if core:isInSlot((-333.5+(i*336))/pX*sX, 2.5/pY*sY, 333.5/pX*sX, 245/pY*sY) then
								if not(#gotorder > 0) then
									table.insert(gotorder, orders[i])
									table.remove(orders, i)
									barmarker = createMarker(2094.6162109375, -1665.2355957031, 13.573991775513 - 1, "cylinder", 2, serverColor[2], serverColor[3], serverColor[4], 155)
								end	
							end	
						end	
					end
				end	
			end	
		end	
	end
)		

addEventHandler("onClientMarkerHit", root,
	function (thePlayer, mDim)
		if (localPlayer == thePlayer) and (mDim) then
			if (getElementData(localPlayer, "mixer:job")) and (getElementData(source, "mixer:dutymarker")) then
				getDuty = true
			elseif (getElementData(localPlayer, "mixer:duty")) and (getElementData(source, "mixer:jobmarker")) then	
				onDuty = true
				showChat(false)
			elseif (getElementData(localPlayer, "mixer:duty")) and (source == barmarker) and (#gotorder > 0) then 	
				barpanel = true
				showChat(false)
			end	
		end	
	end
)

addEventHandler("onClientMarkerLeave", root,
	function (thePlayer, mDim)
		if (localPlayer == thePlayer) and (mDim) then
			if (getElementData(source, "mixer:dutymarker")) or (getElementData(source, "mixer:jobmarker")) then
				out()
			end	
		end		
	end
)

function newOrder()
	if not(#orders >= 5 ) then
		local num  = math.random(1, #makingstypes)
		local dtype = makingstypes[num]
		table.insert(orders, {dtype})
		for i,v in ipairs(makings[dtype]) do
			num  = math.random(1, #v)
			dtype = v[num]
			table.insert(orders[#orders], dtype)
		end
	end	
end

function out()
	showChat(true)
	getDuty = false
	onDuty = false
	barpanel = false
end