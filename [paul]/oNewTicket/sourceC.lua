local screenX, screenY = guiGetScreenSize()


function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(value)
    return value * responsiveMultipler
end

function respc(value)
    return math.ceil(value * responsiveMultipler)
end

local picW, picH = respc(500), respc(700)
local picX, picY = screenX/2 - picW/2, screenY/2 - picH/2

local thePictures = dxCreateTexture("files/orfk.png", "dxt5")
local isEdit = false
bebasneue = exports["oFont"]:getFont("bebasneue",resp(28));
condensed = exports["oFont"]:getFont("condensed",resp(20));
handFont = exports.oFont:getFont("desyrel", resp(28))
Tickets = {}
Tickets["orfk"] = {}
Tickets["omsz"] = {}


core = exports.oCore
color = core:getServerColor()
local ticketTarget = nil 
local signStart = false 
local writeSound = false

Tickets["orfk"]["Render"] = function(ticketData, isEdit)
    dxDrawImage(picX, picY, picW, picH, thePictures)

    if isEdit then 
        drawInput("name|-|28",picX, picY + respc(110),picW, respc(45), handFont, 0.85, tocolor(0, 84, 166), false, "center", "center")
        drawInput("location|-|15",picX + respc(80), picY + respc(200),respc(175), respc(60), handFont, 0.85, tocolor(0, 84, 166), false, "center", "center")
        drawInput("date|-|12",picX + respc(255), picY + respc(200),respc(160), respc(60), handFont, 0.85, tocolor(0, 84, 166), false, "center", "center")
        drawInput("money|num-only|5",picX, picY + respc(205 + 65),picW, respc(60), handFont, 0.85, tocolor(0, 84, 166), "$", "center", "center")
        drawInput("numberplate|-|8",picX, picY + respc(205 + 135),picW, respc(60), handFont, 0.85, tocolor(0, 84, 166), false, "center", "center")
        drawInput("reason|-|28",picX, picY + respc(205 + 205),picW, respc(60), handFont, 0.85, tocolor(0, 84, 166), false, "center", "center")

        if signStart then
			local elapsedTime = getTickCount() - signStart
			local progress = elapsedTime / 3579
            local theName = getElementData(localPlayer, "char:name"):gsub("_", " ")
			local nameWidth = dxGetTextWidth(theName, 0.7, handFont)
 
            exports["oDx"]:dxDrawCorrectText(theName, picX + picW - respc(220), picY + respc(180) , nameWidth * progress, picH, tocolor(0, 84, 166), 0.7, handFont, "left", "center", true) -- VÉTSÉG
            if progress > 1 then 
				if isElement(writeSound) then
					outputChatBox("kesz")
                	destroyElement(writeSound)
				end
            end
        end
    else
        exports["oDx"]:dxDrawCorrectText("Mahiana Rosszáló", picX, picY + respc(125), picW, picH, tocolor(0,84,166,255), 0.85, handFont, "center", "top")
        exports["oDx"]:dxDrawCorrectText("Los Santos", picX + respc(98), picY + respc(215), picW, picH, tocolor(0,84,166,255), 0.7, handFont, "left", "top")
        exports["oDx"]:dxDrawCorrectText("2021.12.23", picX - respc(105), picY + respc(215), picW, picH, tocolor(0,84,166,255), 0.7, handFont, "right", "top")
        exports["oDx"]:dxDrawCorrectText("500.000$", picX, picY-respc(45), picW, picH, tocolor(0,84,166,255), 0.85, handFont, "center", "center")
        exports["oDx"]:dxDrawCorrectText("REM,RUM,FF,GV", picX, picY+ respc(25), picW, picH, tocolor(0,84,166,255), 0.7, handFont, "center", "center")
        exports["oDx"]:dxDrawCorrectText("ABC-123", picX, picY+ respc(100), picW, picH, tocolor(0,84,166,255), 0.7, handFont, "center", "center")
        exports["oDx"]:dxDrawCorrectText("Mahiana Rosszáló", picX + respc(40), picY+ respc(180), picW, picH, tocolor(0,84,166,255), 0.55, handFont, "left", "center")
        exports["oDx"]:dxDrawCorrectText("Dexter Power", picX - respc(70), picY+ respc(180), picW, picH, tocolor(0,84,166,255), 0.55, handFont, "right", "center")
    end
end

local isTicketShowing = false
local activeTicketType = "orfk"

function renderTicket()
	buttons = {}
    Tickets[activeTicketType]["Render"](false, true)

    local cx, cy = getCursorPosition()

	activeButton = false

	if cx and cy then
		cx, cy = screenX * cx, screenY * cy

		for k, v in pairs(buttons) do
			if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end
end

function toggleTicket(type, datas)
	if isTicketShowing then 
		removeEventHandler("onClientRender", root, renderTicket)
		isTicketShowing = false
	else
		print(type)
		activeTicketType = type
		addEventHandler("onClientRender", root, renderTicket)
		isTicketShowing = true
	end

	return isTicketShowing
end

---------------------------------------------------------------------------
----------------------Utils------------------------------------------------
---------------------------------------------------------------------------

buttons = {}
activeButton = false
activeInput = false
inputValues = {}

local currentInputCaretState = false
local lastInputCaretTick = 0

function clearInputs()
	for k, v in pairs(inputValues) do
		inputValues[k] = ""
	end
end

function drawInput(k, x, y, sx, sy, font, fontScale, color, extra, alignX, alignY)
	if not inputValues[k] then
		inputValues[k] = ""
	end

	if extra then
        if activeInput then
            local selected = split(activeInput, "|") 
            if selected[2] == "num-only" and inputValues[k]:len() > 0 then 
                dxDrawText(format(inputValues[k]) .. extra, x + respc(3), y + respc(15), x + sx - respc(12), y + sy, color, fontScale - (dxGetTextWidth(inputValues[k], fontScale, font)  * 0.0015), font, alignX, alignY, true)
            else 
                dxDrawText(inputValues[k] .. extra, x + respc(3), y + respc(15), x + sx - respc(12), y + sy, color, fontScale - (dxGetTextWidth(inputValues[k], fontScale, font)  * 0.0015), font, alignX, alignY, true)  
            end
        else 
            dxDrawText(inputValues[k] .. extra, x + respc(3), y + respc(15), x + sx - respc(12), y + sy, color, fontScale - (dxGetTextWidth(inputValues[k], fontScale, font)  * 0.0015), font, alignX, alignY, true)
        end 
		--dxDrawText(inputValues[k] .. extra, x + respc(3), y + respc(15), x + sx - respc(12), y + sy, color, fontScale, font, "left", "center", true)
	else
        if activeInput then 
            local selected = split(activeInput, "|") 
            if selected[2] == "num-only" and inputValues[k]:len() > 0 then 
                dxDrawText(format(inputValues[k]), x + respc(3), y + respc(15), x + sx - respc(12), y + sy, color, fontScale - (dxGetTextWidth(inputValues[k], fontScale, font)  * 0.0015), font, alignX, alignY, true)
            else
                dxDrawText(inputValues[k], x + respc(3), y + respc(15), x + sx - respc(12), y + sy, color, fontScale - (dxGetTextWidth(inputValues[k], fontScale, font)  * 0.0015), font, alignX, alignY, true)
            end
		else
			dxDrawText(inputValues[k], x + respc(3), y + respc(15), x + sx - respc(12), y + sy, color, fontScale - (dxGetTextWidth(inputValues[k], fontScale, font)  * 0.0015), font, alignX, alignY, true)
        end
	end

	--[[if activeInput == k then
		local textWidth = dxGetTextWidth(inputValues[k], fontScale, font) + 2
		local r, g, b = bitExtract(color, 16, 8), bitExtract(color, 8, 8), bitExtract(color, 0, 8)
		local a = currentInputCaretState and 255 or 0

		local caretPosX = x + respc(3) + textWidth

		if caretPosX > x + sx - respc(12) then
			caretPosX = x + sx - respc(12)
		end

		--dxDrawRectangle(caretPosX, y + respc(15), 2, sy - respc(20), tocolor(r, g, b, a))

		if getTickCount() - lastInputCaretTick >= 375 then
			lastInputCaretTick = getTickCount()
			currentInputCaretState = not currentInputCaretState
		end
	end]]

	buttons["setInput:" .. k] = {x, y, sx, sy}
end

function format(n) 
    return n
end 

addEventHandler("onClientCharacter", root,
	function (character)
		if activeInput then
			local selected = split(activeInput, "|")

			if selected[3] then
				local maxCharacter = tonumber(selected[3])

				if utf8.len(inputValues[activeInput]) >= maxCharacter then
					return
				end
			end

			if selected[2] == "num-only" then
				if tonumber(character) then
					cancelEvent()

					inputValues[activeInput] = inputValues[activeInput] .. character
				end
			else
				cancelEvent()

				inputValues[activeInput] = inputValues[activeInput] .. character
			end
		end
	end
)

addEventHandler("onClientKey", root,
	function (key, press)
		if activeInput and inputValues[activeInput] then
			if press then
				cancelEvent()

				if key == "backspace" then
					if utf8.len(inputValues[activeInput]) > 0 then
						inputValues[activeInput] = utf8.sub(inputValues[activeInput], 1, -2)
					end
				end
			end
		end
	end
)

addEventHandler("onClientClick", root,
	function (button, state)
		if  button == "left" then
			if state == "down" then
				if not signStart then
					activeInput = false

					if activeButton then
						local selected = split(activeButton, ":")

						if selected[1] == "setInput" then
							activeInput = selected[2]
						end
					end

					if cursorInBox(picX + picW - respc(220), picY + picH - respc(190) , respc(180), respc(60)) then 
						if not signStart then 
							if string.len(inputValues["name|-|28"]) > 8 then
								local target = core:getPlayerFromPartialName(localPlayer, inputValues["name|-|28"]:gsub(" ", "_"), true)
								ticketTarget = target
								if target then 
									--if not (target == localPlayer) then 
										if core:getDistance(target, localPlayer) < 2 then 
											if string.len(inputValues["location|-|15"]) > 5 then
												if string.len(inputValues["date|-|12"]) > 5 then
													if ((tonumber(inputValues["money|num-only|5"]) or 0) < 50000) and ((tonumber(inputValues["money|num-only|5"]) or 0) > 100) then
														if string.len(inputValues["reason|-|28"]) > 3 then
															signStart = getTickCount()
															writeSound = playSound("files/write.mp3", true)
														else 
															outputChatBox(core:getServerPrefix("red-dark", "Ticket", 3).."Adj meg legalább egy okot!", 255, 255, 255, true)
														end
													else
														outputChatBox(core:getServerPrefix("red-dark", "Ticket", 3).."Egyszerre maximum csak "..color.."100$-50.000$#ffffff között ticketelhetsz.", 255, 255, 255, true)
													end
												end
											end
										else
											outputChatBox(core:getServerPrefix("red-dark", "Ticket", 2).."Túl messze vagy!", 255, 255, 255, true)
										end
									--else
									--	outputChatBox(core:getServerPrefix("red-dark", "Ticket", 2).."Magadnak nem adhatsz bírságot!", 255, 255, 255, true)
									--end
								else
									outputChatBox(core:getServerPrefix("red-dark", "Ticket", 2).."Nem található elkövető!", 255, 255, 255, true)
								end
							end
						end
					end
				end
			end
		end
	end
)



function cursorInBox(x, y, w, h)
	if x and y and w and h then
		if isCursorShowing() then
			if not isMTAWindowActive() then
				local cursorX, cursorY = getCursorPosition()
				
				cursorX, cursorY = cursorX * screenX, cursorY * screenY
				
				if cursorX >= x and cursorX <= x + w and cursorY >= y and cursorY <= y + h then
					return true
				end
			end
		end
	end
	
	return false
end
