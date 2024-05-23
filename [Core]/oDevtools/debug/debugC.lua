local screenW, screenH = guiGetScreenSize()

local chatData = getChatboxLayout()
local lines = 10--chatData["chat_lines"]
local debugLines = {}
local font = false

local debugTypes = {"#ff0000[ERROR]: ", "#FF8D00[WARNING]: ", "#7cc576[INFO]: "}
debugTypes[0] = "[INFO]: "

local colors = {"#ff0000", "#FF8D00", "#7cc576"}

addCommandHandler("debugrefresh", function()
	if getElementData(localPlayer, "aclLogin") then
    	debugLines = {}
	end
end)

local positions = {screenW/2 - screenW/4, screenH - 80}
local panelHeight = 0

addEvent("debug->ChangeState", true)
addEventHandler("debug->ChangeState", root, function()
	debugShow = not debugShow

	if debugShow then
		outputChatBox(exports.oCore:getServerPrefix("server", "Debugscript", 1).."Debug megjelentítve!", 255, 255, 255, true)
        font = dxCreateFont(":oAccount/assets/font/roboto.ttf", 14)
        RobotoHeight = dxGetFontHeight(0.75, font)
        panelHeight = RobotoHeight * 20
        panelPosY = screenH - 20 - (36 + 30) - RobotoHeight * 20
        addEventHandler("onClientRender",getRootElement(), renderTheNewDebug, true, "low-999")
	else
		if isElement(font) then 
			destroyElement(font)
		end
		font = false
        removeEventHandler("onClientRender", getRootElement(), renderTheNewDebug)
		outputChatBox(exports.oCore:getServerPrefix("server", "Debugscript", 1).."Debug eltüntetve!", 255, 255, 255, true)
	end
end)


addCommandHandler("cdebug",
    function()
		if getElementData(localPlayer, "aclLogin") then
	        debugLines = {}
		end
    end
)


addEventHandler("onClientDebugMessage", getRootElement(),
	function (message, level, file, line, r, g, b)
		if debugShow then
			local color
			if level == 1 then
				level = "[ERROR] "
				color = tocolor(215, 89, 89)
			elseif level == 2 then
				level = "[WARNING] "
				color = tocolor(255, 150, 0)
			elseif level == 3 then
				level = "[INFO] "
				color = tocolor(50, 179, 239)
			else
				level = "[INFO] "
				color = tocolor(r, g, b)
			end

			local time = getRealTime()
			local timeStr = "[" .. string.format("%02d:%02d:%02d", time.hour, time.minute, time.second) .. "]"
		
			if file and line then
				addDebugLine(level .. file .. ":" .. line .. ", " .. message, color, timeStr)
			else
				addDebugLine(level .. message, color, timeStr)
			end
		end
	end
)

addEvent("addDebugLine", true)
function addDebugLine(message, color, timeStr)
	if debugShow then
		local lines = {}

		for i = 1, #debugLines do
			if debugLines[i][2] == message then
				debugLines[i] = {debugLines[i][1] + 1, debugLines[i][2], debugLines[i][3], timeStr}
				return
			end
		end
		
		for i = 1, 20 do
			if debugLines[i] then
				lines[i + 1] = debugLines[i]
			end
		end
		
		debugLines = lines
		debugLines[1] = {1, message, color, timeStr}
		
		if #debugLines >= 20 then
			debugLines[#debugLines] = nil
		end


		if isTimer(debugTimer) then 
			killTimer(debugTimer)
		end
		debugTimer = setTimer(function()
			debugLines = {}
		end, 5*60*1000,1)
	end
end
addEventHandler("addDebugLine", getRootElement(), addDebugLine)

function dxDrawBorderText(text, x, y, w, h, color, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	text = text:gsub("#......", "")
	dxDrawText(text, x - 1, y - 1, w - 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
	dxDrawText(text, x - 1, y + 1, w - 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
	dxDrawText(text, x + 1, y - 1, w + 1, h - 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
	dxDrawText(text, x + 1, y + 1, w + 1, h + 1, borderColor, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
	dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
end

function renderTheNewDebug()
	if debugShow then
		for k = 1, 20 do
			if debugLines[k] then
				v = debugLines[k]
			--	outputChatBox("a")
				local y = panelPosY + panelHeight - RobotoHeight * (k - 1)
				local textWidth = dxGetTextWidth(v[4] .. " " .. v[1] .. "x", 0.75, font)

				dxDrawBorderText(v[4] .. " " .. v[1] .. "x", positions[1], y, 0, 0, tocolor(255, 255, 255), tocolor(0, 0, 0, 200), 0.75, font, "left", "top")
				dxDrawBorderText(v[2], positions[1] + textWidth + 5, y, 0, 0, v[3], tocolor(0, 0, 0, 200), 0.75, font, "left", "top")
			end
		end
	end
end