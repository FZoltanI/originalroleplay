local sX, sY = guiGetScreenSize()
local pX, pY = 1680, 1050

local preview = exports.oPreview
local oElementEditor = exports.oComplementary
local boneattach = exports.oBone
local sName = core:getServerName()
local sColor, sR, sG, sB= core:getServerColor()
local showShoppingPanel = false
local complementaryIndex = "Órák"
local complementaryIndexNum = 2
local ownComplementarysPanel = false
local scrolling = false
local isEditing = false
local slider = 0
local cursorPos = {false, false}

local fonts = {
	{exports.oFont:getFont("condensed", 8)},
	{exports.oFont:getFont("bebasneue", 12)},
	{exports.oFont:getFont("bebasneue", 20)},
	{exports.oFont:getFont("condensed", 10)},
	{exports.oFont:getFont("condensed", 8)},
}

local elementShopMenu = {"Előnézet","Vásárlás", "Beállítás", "Felhelyez", "Levesz"}
local rotCursorPos = {false, false}
local rotY, rotX = 0, 140
local startX, startY, width, height = 695, 355, 390, 440

addEventHandler("onClientRender", root,
	function ()

		if (showShoppingPanel) then
			dxDrawRectangle( 590/pX*sX, 250/pY*sY, 500/pX*sX, 550/pY*sY, tocolor(35, 35, 35, 200))
			if (mainPanel) then
				dxDrawRectangle( 592/pX*sX, 252/pY*sY, 496/pX*sX, 546/pY*sY, tocolor(35, 35, 35, 255))
				dxDrawRectangle( 592/pX*sX, 252/pY*sY, 496/pX*sX, 22/pY*sY, tocolor(30, 30, 30, 255))
				dxDrawText(sColor..sName.."#ffffff - Kiegészítő bolt",  592/pX*sX, 252/pY*sY, 1088/pX*sX, 274/pY*sY, tocolor(225, 225, 225, 125), 1, fonts[1][1], "center", "center", false, false, false, true)
				dxDrawRectangle( 594/pX*sX, 719/pY*sY, 492/pX*sX, 77/pY*sY, tocolor(30, 30, 30, 200))
				dxDrawRectangle( 1075.5/pX*sX, 276/pY*sY, 6/pX*sX, 441/pY*sY, tocolor(sR, sG, sB, 50))
				if (#complementaryElements[complementaryIndex] > 10) then
					scrollheight = 441/(#complementaryElements[complementaryIndex]-9)
					scrollY = (276+(slider*scrollheight))
				else
					scrollheight = 441
					scrollY = 276
				end	
				dxDrawRectangle( 1075.5/pX*sX, scrollY/pY*sY, 6/pX*sX, scrollheight/pY*sY, tocolor(sR, sG, sB, 255))
				for i=1, 3 do
					if (i==2) then
						mainmenualpha = 255
						fontindex = 3
					else
						mainmenualpha = 180
						fontindex = 2
					end	
					if (complementaryIndexNum == 1) and (i==1) then
						text = complementaryTypes[#complementaryTypes][1]
					elseif (complementaryIndexNum == #complementaryTypes) and (i==3) then	
						text = complementaryTypes[1][1]
					elseif (i==2) then
						text = complementaryTypes[complementaryIndexNum][1]	
					elseif (i==3) then 
						text = complementaryTypes[1+complementaryIndexNum][1]	
					elseif (i==1) then
						text = complementaryTypes[complementaryIndexNum-1][1]		
					end	
					dxDrawText(text,  (430+(i*164))/pX*sX, 719/pY*sY, (594+(i*164))/pX*sX, 796/pY*sY, tocolor(225, 225, 225, mainmenualpha), 1, fonts[fontindex][1], "center", "center", false, false, false, true)
				end	
				for i=1, 10 do
				local index = i
					if (complementaryElements[complementaryIndex][i+slider]) then
						if (i%2==0) then
							alpha5 = 255
						else
							alpha5 = 130	
						end	
						dxDrawRectangle( 594/pX*sX, (231.7+(i*44.1))/pY*sY, 477/pX*sX, 44.1/pY*sY, tocolor(30, 30, 30, alpha5))
						dxDrawText(complementaryElements[complementaryIndex][i+slider][1].." #86d468("..complementaryElements[complementaryIndex][i+slider][2].."$)", 598/pX*sX, (231.7+(i*44.1))/pY*sY, 744/pX*sX, (276+(i*44.1))/pY*sY, tocolor(225, 225, 225, 255), 1, fonts[4][1], "left", "center", false, false, false, true)
						local isOwned = false
						if (ownComplementary[complementaryIndex]) then	
							for i,v in ipairs(ownComplementary[complementaryIndex]) do
								if (v[1] == complementaryElements[complementaryIndex][index+slider][1]) then
									isOwned = true
									break
								end	
							end
						end	
						if (isOwned) then
							dxDrawText("Megvásárolva", 598/pX*sX, (231.7+(index*44.1))/pY*sY, 1067/pX*sX, (276+(index*44.1))/pY*sY, tocolor(sR, sG, sB, 255), 1, fonts[4][1], "right", "center", false, false, false, true)
						else	
							for i=1,2 do
								if (i==1) then
									bR, bG, bB = 76, 175, 237
									if core:isInSlot(859.5/pX*sX, (238.3+(index*44.1))/pY*sY, 100/pX*sX, 31/pY*sY) then
										cInBox = true
										cId = complementaryElements[complementaryIndex][index+slider][3]
									end	
								else
									bR, bG, bB = 134, 212, 104, 255	
								end
								exports.oCore:dxDrawButton( (753+(i*106.5))/pX*sX, (238.3+(index*44.1))/pY*sY, 100/pX*sX, 31/pY*sY, bR, bG, bB, 255, elementShopMenu[i], tocolor(225, 225, 225, 255), 1,  fonts[4][1], true, tocolor(0, 0, 0, 100))
							end
						end	
					end	
				end	
				if (cInBox) and (cId) then
					local cX, cY = getCursorPosition ()
					cursorPos = {cX*sX, cY*sY}
				else
					cursorPos = {false, false}	
				end	
				if (cursorPos[1]) and (cId) then
					dxDrawRectangle( cursorPos[1]/pX*sX, cursorPos[2]/pY*sY, 160/pX*sX, 90/pY*sY, tocolor(35, 35, 35, 255))
					dxDrawRectangle( (cursorPos[1]+2)/pX*sX, (cursorPos[2]+2)/pY*sY, 156/pX*sX, 86/pY*sY, tocolor(30, 30, 30, 255))
					dxDrawImage( (cursorPos[1]+4)/pX*sX, (cursorPos[2]+4)/pY*sY, 152/pX*sX, 82/pY*sY, "files/items/"..cId..".jpeg")
				end	
				cInBox = false
				cId = false
			end	
		elseif (ownComplementarysPanel)	then
			dxDrawRectangle( 642/pX*sX, 302/pY*sY, 396/pX*sX, 446/pY*sY, tocolor(35, 35, 35, 255))
			dxDrawRectangle( 642/pX*sX, 302/pY*sY, 396/pX*sX, 22/pY*sY, tocolor(30, 30, 30, 255))
			dxDrawText(sColor..sName.."#ffffff - Kiegészítő bolt",  642/pX*sX, 302/pY*sY, 1038/pX*sX, 324/pY*sY, tocolor(225, 225, 225, 125), 1, fonts[1][1], "center", "center", false, false, false, true)
			local used = checkUsed()
			local complementaryslot = getElementData(localPlayer, "char:complementaryslot") or 2
			dxDrawText(used.."/"..sColor..complementaryslot,  642/pX*sX, 302/pY*sY, 1031.5/pX*sX, 324/pY*sY, tocolor(225, 225, 225, 125), 1, fonts[1][1], "right", "center", false, false, false, true)
			exports.oCore:dxDrawButton( 950/pX*sX, 304/pY*sY, 50/pX*sX, 18/pY*sY, 134, 212, 104, 255, "+ Slot", tocolor(225, 225, 225, 255), 1,  fonts[5][1], true, tocolor(0, 0, 0, 100))
			dxDrawRectangle( 644/pX*sX, 667/pY*sY, 392/pX*sX, 77/pY*sY, tocolor(30, 30, 30, 200))
			dxDrawRectangle( 1025.5/pX*sX, 326/pY*sY, 6/pX*sX, 337/pY*sY, tocolor(sR, sG, sB, 50))
			if (ownComplementary[complementaryIndex]) and (#ownComplementary[complementaryIndex] > 10) then
					scrollheight = 337/(#ownComplementary[complementaryIndex]-9)
					scrollY = (326+(slider*scrollheight))
				else
					scrollheight = 337
					scrollY = 326
				end	
			dxDrawRectangle( 1025.5/pX*sX, scrollY/pY*sY, 6/pX*sX, scrollheight/pY*sY, tocolor(sR, sG, sB, 255))
			for i=1, 3 do
				if (i==2) then
					mainmenualpha = 255
					fontindex = 3
				else
					mainmenualpha = 180
					fontindex = 2
				end	
				if (complementaryIndexNum == 1) and (i==1) then
					text = complementaryTypes[#complementaryTypes][1]
				elseif (complementaryIndexNum == #complementaryTypes) and (i==3) then	
					text = complementaryTypes[1][1]
				elseif (i==2) then
					text = complementaryTypes[complementaryIndexNum][1]	
				elseif (i==3) then 
					text = complementaryTypes[1+complementaryIndexNum][1]	
				elseif (i==1) then
					text = complementaryTypes[complementaryIndexNum-1][1]		
				end	
				dxDrawText(text,  (513.3+(i*130.6666666666667))/pX*sX, 667/pY*sY, (644+(i*130.6666666666667))/pX*sX, 744/pY*sY, tocolor(225, 225, 225, mainmenualpha), 1, fonts[fontindex][1], "center", "center", false, false, false, true)
			end	
			for i=1, 10 do
			local index = i	
				if (ownComplementary[complementaryIndex]) and (ownComplementary[complementaryIndex][i+slider]) then
					if ((i+slider)%2==0) then
						alpha5 = 255	
					else
						alpha5 = 130	
					end	
					dxDrawRectangle( 644/pX*sX, (292.3+(i*33.7))/pY*sY, 377/pX*sX, 33.7/pY*sY, tocolor(30, 30, 30, alpha5))
					dxDrawText(ownComplementary[complementaryIndex][i+slider][1], 648/pX*sX, (292.3+(i*33.7))/pY*sY, 377/pX*sX, (326+(i*33.7))/pY*sY, tocolor(225, 225, 225, 255), 1, fonts[4][1], "left", "center", false, false, false, true)	
					for i=1,2 do
						elementShopMenuIndex = 2
						if (ownComplementary[complementaryIndex][index+slider][4]) and (i==2) then
							elementShopMenuIndex = 3
						end	
						if (i==1) then
							bR, bG, bB = 76, 175, 237
						else
							bR, bG, bB = 134, 212, 104	
						end	
						exports.oCore:dxDrawButton( (785.5+(i*78.5))/pX*sX, (295.8+(index*33.7))/pY*sY, 75/pX*sX, 26.7/pY*sY, bR, bG, bB, 255, elementShopMenu[i+elementShopMenuIndex], tocolor(225, 225, 225, 255), 1,  fonts[4][1], true, tocolor(0, 0, 0, 100))
					end	
				end	
			end
		end	
	end
)

addEventHandler("onClientKey", root,
	function ( button, state)
		if (showShoppingPanel) then
			if (button=="mouse1") and (state) then	
				if (mainPanel) then
					for i=1, 10 do
					local index = i	
						if (complementaryElements[complementaryIndex][i+slider]) then
						local isOwned = false	
							if (ownComplementary[complementaryIndex]) then	
								for i,v in ipairs(ownComplementary[complementaryIndex]) do
									if (v[1] == complementaryElements[complementaryIndex][index+slider][1]) then
										isOwned = true
										break
									end	
								end
							end	
							if not (isOwned) then
								for i=1, 2 do
									if core:isInSlot((753+(i*106.5))/pX*sX, (238.3+(index*44.1))/pY*sY, 100/pX*sX, 31/pY*sY) then
										if (i==2) then
										local buyable =	true
											if not((exports.oDashboard:isPlayerFactionMember(1)) or (exports.oDashboard:isPlayerFactionMember(33))) and (complementaryIndex=="Police") then
												buyable = false	
											end	
											if (buyable) then
											local got = false	
											local ctable = getElementData(localPlayer, "complementarytable")
												if (ctable[etype]) then
													for i,v in pairs(ctable[etype]) do
														if (v[2] == complementaryElements[etype][index][3]) then
															got = true
															break
														end		
													end	
												end	
												if not got then
													triggerServerEvent("Complementary:Buy", root, localPlayer, complementaryIndex, index+slider)
													break
												end
											end
										end	
									end	
								end	
							end	
						end	
					end
					for i=1, 2 do
						if core:isInSlot((266+(i*328))/pX*sX, 719/pY*sY, 174/pX*sX, 77/pY*sY) then
							if (complementaryIndexNum == #complementaryTypes) and (i==2) then
								complementaryIndex = complementaryTypes[1][1]
								complementaryIndexNum = 1
							elseif (complementaryIndexNum == 1)	and (i==1) then
								complementaryIndex = complementaryTypes[#complementaryTypes][1]
								complementaryIndexNum = #complementaryTypes
							elseif (i==1) then	
								complementaryIndex = complementaryTypes[complementaryIndexNum-1][1]
								complementaryIndexNum = complementaryIndexNum - 1
							elseif (i==2) then	
								complementaryIndex = complementaryTypes[complementaryIndexNum+1][1]	
								complementaryIndexNum = complementaryIndexNum + 1
							end
							slider=0
							scrolling=false
						end	
					end	
					if core:isInSlot(1075.5/pX*sX, 276/pY*sY, 6/pX*sX, 441/pY*sY) then
						scrolling = true
					else
						scrolling = false
					end	
				end	
			elseif ((button=="mouse_wheel_up") and state) and (mainPanel) then
				if (showShoppingPanel) then
					if (#complementaryElements[complementaryIndex] > 10) then
						if not(slider ==  0) then
							slider = slider-1
						end	
					end	
				end	
			elseif ((button=="mouse_wheel_down") and state) and (mainPanel) then
				if (showShoppingPanel)  then
					if (#complementaryElements[complementaryIndex] > 10) then
						if not(slider ==  #complementaryElements[complementaryIndex]-10) then
							slider = slider+1
						end	
					end	
				end		
			end
		elseif (ownComplementarysPanel) then
			if (button=="mouse1") and (state) then	
				for i=1, 10 do
				local index = i	
					if (ownComplementary[complementaryIndex]) and (ownComplementary[complementaryIndex][i+slider]) then	
						for i=1, 2 do
							if core:isInSlot((785.5+(i*78.5))/pX*sX, (295.8+(index*33.7))/pY*sY, 75/pX*sX, 26.7/pY*sY) then
								if (i==1) and not(ownComplementary[complementaryIndex][i+slider][4]) then
									isEditing = true
									setElementFrozen(localPlayer, true)
									local thebone = complementaryTypes[complementaryIndexNum][3]	
									local x, y, z = getElementPosition( localPlayer)
									local obj = createObject( ownComplementary[complementaryIndex][index+slider][2], x, y, z)
									setElementStreamable(obj, false)
									local thetable = ownComplementary[complementaryIndex][index+slider]
									if (complementaryIndex == "Police") then
										for i,v in ipairs(complementaryElements["Police"]) do
											if (v[1] == thetable[1]) then
												thebone = v[4]
											end	
										end
									end
									setElementDimension(obj, getElementDimension(localPlayer))	
									setElementInterior(obj, getElementInterior(localPlayer))
									exports.oBone:attachElementToBone(obj, localPlayer, thebone, thetable[3][1], thetable[3][2], thetable[3][3], thetable[3][4], thetable[3][5], thetable[3][6])
									if (thetable[3][7]) then
										setObjectScale(obj,  thetable[3][7], thetable[3][8], thetable[3][9])
									end	
									oElementEditor:toggleEditor(obj, complementaryIndex)
									ownComplementarysPanel = false
									break
								elseif (i==2) then	
									local used = checkUsed()
									local slot = getElementData(localPlayer, "char:complementaryslot") or 2 
									local usedintype = false
									if not (complementaryIndex=="Police") then
										for i,v in ipairs(ownComplementary[complementaryIndex]) do
											if (v[4]==true) then
												usedintype = true
											end	
										end
									end	
									if not(usedintype) and not(used>=slot) and not(ownComplementary[complementaryIndex][index+slider][4]) then
										ownComplementary[complementaryIndex][index+slider][4] = true
										if ownComplementary[complementaryIndex][index+slider][1] == "Esőkabát" then 
											setElementData(localPlayer, "char:raincoat", true)
											outputChatBox("Felvetted az esőkabátot így nem fogsz megfázni az esőben!")
										end
										setElementData(localPlayer, "complementarytable", ownComplementary)
										--iprint(ownComplementary[complementaryIndex][index+slider])
										triggerServerEvent("Complementary:Attach", root, localPlayer, ownComplementary[complementaryIndex][index+slider], complementaryTypes[complementaryIndexNum][3], complementaryIndex)
									elseif ownComplementary[complementaryIndex][index+slider][4] then
										ownComplementary[complementaryIndex][index+slider][4] = false
										if ownComplementary[complementaryIndex][index+slider][1] == "Esőkabát" then 
											setElementData(localPlayer, "char:raincoat", false)
											print("eső kabát down")
										end
										setElementData(localPlayer, "complementarytable", ownComplementary)

										triggerServerEvent("Complementary:DelObject", root, localPlayer, ownComplementary[complementaryIndex][index+slider][2])	
									end	
								end	
							end	
						end	
					end	
				end
				for i=1, 2 do
					if core:isInSlot((382.6333333333333+(i*261.3333333333334))/pX*sX, 667/pY*sY, 130.6666666666667/pX*sX, 744/pY*sY) then
						if (complementaryIndexNum == #complementaryTypes) and (i==2) then
							complementaryIndex = complementaryTypes[1][1]
							complementaryIndexNum = 1
						elseif (complementaryIndexNum == 1)	and (i==1) then
							complementaryIndex = complementaryTypes[#complementaryTypes][1]
							complementaryIndexNum = #complementaryTypes
						elseif (i==1) then	
							complementaryIndex = complementaryTypes[complementaryIndexNum-1][1]
							complementaryIndexNum = complementaryIndexNum - 1
						elseif (i==2) then	
							complementaryIndex = complementaryTypes[complementaryIndexNum+1][1]	
							complementaryIndexNum = complementaryIndexNum + 1
						end
						slider=0
						scrolling=false
					end	
				end	
				if core:isInSlot(1025.5/pX*sX, 326/pY*sY, 6/pX*sX, 337) then
					scrolling = true
				else
					scrolling = false
				end
				if core:isInSlot(950/pX*sX, 304/pY*sY, 50/pX*sX, 18/pY*sY) then
					triggerServerEvent("Complementary:BuySlot", root, localPlayer)
				end	
			elseif ((button=="mouse_wheel_up") and state) then
				if (ownComplementarysPanel) then
					if (#ownComplementary[complementaryIndex] > 10) then
						if not(slider ==  0) then
							slider = slider-1
						end	
					end	
				end	
			elseif ((button=="mouse_wheel_down") and state) then
				if (ownComplementarysPanel) then
					if (#ownComplementary[complementaryIndex] > 10) then
						if not(slider ==  #ownComplementary[complementaryIndex]-10) then	
							slider = slider+1
						end	
					end	
				end		
			end	
		end			
	end
)

addEventHandler("onClientMarkerHit", root,
	function (hitPlayer, mDim)
		if ((hitPlayer == localPlayer) and (mDim)) then
			if (getElementData(source, "complementary:marker")) then
				if not (showShoppingPanel) then
					if core:getDistance(localPlayer, source) < 3 then
						complementaryIndex = "Órák"
						ownComplementarysPanel = false
						complementaryIndexNum = 2
						showShoppingPanel = true
						mainPanel = true
					end
				end	
			end	
		end		
	end
)

addEventHandler("onClientMarkerLeave", root, 
	function (leftPlayer, mDim)
		if ((leftPlayer == localPlayer) and (mDim)) then
			if (getElementData(source, "complementary:marker")) then
				if (showShoppingPanel) then
					if core:getDistance(localPlayer, source) < 3 then
						out()
					end
				end	
			end	
		end	
	end
)

function togOwnComplementarys(cmd)
	if not(showShoppingPanel) and not(isEditing) then
		if (ownComplementarysPanel) then
			ownComplementarysPanel = false
			out()
		else	
			ownComplementarysPanel = true
		end	
	end	
end
addCommandHandler("cuccaim", togOwnComplementarys)

function editEnd(posDatas)
	isEditing = false
	ownComplementarysPanel = true

	local compTable = getElementData(localPlayer, "complementarytable")
	if (posDatas) then
		local model = getElementModel(posDatas[1])

		for k, v in pairs(compTable) do 
			for k2, v2 in pairs(v) do 
				if v2[2] == model then 
					v2[3] = {posDatas[2], posDatas[3], posDatas[4], posDatas[5], posDatas[6], posDatas[7], posDatas[8], posDatas[9], posDatas[10]}

					setElementData(localPlayer, "complementarytable", compTable)
					break
				end
			end 
		end
	end	
end

function out()
	startX, startY, width, height = 695, 355, 390, 440
	showShoppingPanel = false
	complementaryIndex = "Órák"
	mainPanel = false
	watchPanel = false
	ownComplementarysPanel = false
	scrolling = false
	complementaryIndexNum = 2
	slider = 0
	if (isElement(obj)) then
		destroyElement(obj)
	end	
	isEditing = false
end

function checkUsed()
	local used = 0
	for i=1,#complementaryTypes do
		local ctype = complementaryTypes[i][1] 
		if (ownComplementary[ctype]) then 
			for i,v in ipairs(ownComplementary[ctype]) do
				if (v[4]) then
					used = used + 1
				end	
			end
		end
	end	
	return used
end

addEvent("complementary:getthetable", true)
addEventHandler("complementary:getthetable", localPlayer,
	function (thetable)
		ownComplementary = thetable
	end
)

addEvent("complementary:newcomplementary", true)
addEventHandler("complementary:newcomplementary", localPlayer,
	function (etype, newcomp)
		if (ownComplementary[etype]) then
			table.insert(ownComplementary[etype], newcomp)
		end	
	end
)

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	--325
	txd = engineLoadTXD ("files/models/flowera.txd")
    engineImportTXD (txd, 325)
    dff = engineLoadDFF ("files/models/flowera.dff")
    engineReplaceModel (dff, 325)
end)

function onQuitGame( reason )
    out()
end
addEventHandler( "onClientPlayerQuit", getRootElement(), onQuitGame )