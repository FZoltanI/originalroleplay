local sx, sy = guiGetScreenSize()

local font = false
local font2 = false

local panelState = false

local dataRefreshTimer = false
local dataRefreshSampleRate = 2500

local performanceElement = false
local performanceElementType = "client"
local performanceCategory = "Lua timing"
local performanceCategoryId = 1
local performanceCategories = {
	"Lua timing",
	"Lua memory",
	"Lib memory",
	"Packet usage",
	"Server info",
	"Function stats",
	"RPC Packet usage",
	"Packet usage",
	"Event Packet usage",
	"Player packet usage"
}

local performanceStatsColumn = {}
local performanceStatsRow = {}

local panelWidth = sx * 0.5
local screenDifferenceWidth = sx - math.floor(256)
local screenDifferenceWidth2 = sx - math.floor(600)
local boxHeight = math.floor(50)

local performanceRowsLength = {}
local performanceTableCount = 0
local performanceRowsWidth = {}
local rowsSortBy = 2
local rowsSortAlign = true

local renderTarget = false

local activeDirectX = false

local titleHeight = 32
local smallBoxSize = 24
local smallBoxSize2 = 28

local panelVisibleItems = 12
local panelMaxHeight = boxHeight * panelVisibleItems
local listPanelPage = 0
local listPanelLastPage = false

local scrollbarPosition = 0
local scrollbarInterpolationTick = false

local performanceLogging = false
local performanceLogs = {}

local whiteColor = tocolor(242, 242, 242)

local fontColumns = {"Name", "Size", "Bold", "Quality", "Uses"}
local fontRows = {}
local detailsState = false
local fontPanelWidth = 0
local fontRowsWidth = {}

addCommandHandler("performancelog",
	function (command, target)
		if exports.oAdmin:isPlayerDeveloper(localPlayer) and not target then
			performanceLogging = not performanceLogging

			if performanceLogging then
				savePerformance(1)
			else
				local timestamp = getRealTime().timestamp
				local logFile = fileCreate(timestamp .. "_log/log.csv")

				for k,v in pairs(performanceLogs) do
					fileWrite(logFile, k .. ";")

					for i = 1, #v do
						fileWrite(logFile, tostring(v[i]) .. ";")
					end

					fileWrite(logFile, "\n")
				end

				performanceLogs = {}
				fileClose(logFile)
			end
		end
	end
)

function savePerformance(times)
	if performanceLogging then
		local columns, rows = getPerformanceStats("Lua timing")

		for i = 1, #rows do
			if not performanceLogs[rows[i][1]] then
				performanceLogs[rows[i][1]] = {}
			end

			performanceLogs[rows[i][1]][times] = rows[i][2]
		end

		setTimer(savePerformance, 750, 1, times + 1)
	end
end

addCommandHandler("performance",
	function (command, target)
		if exports.oAdmin:isPlayerDeveloper(localPlayer) and not target then
			performanceElementType = "client"
			performanceElement = false
			panelState = not panelState

			if isTimer(dataRefreshTimer) then
				killTimer(dataRefreshTimer)
			end

			if isElement(renderTarget) then
				destroyElement(renderTarget)
			end

			if panelState then
				--addEventHandler("onClientRender", getRootElement(), renderPerformance, true, "low-9999999999")
				createRender('renderPerformance', renderPerformance)
				addEventHandler("onClientClick", getRootElement(), clickPerformance)
				addEventHandler("onClientKey", getRootElement(), keyPerformance)

				dataRefresh()
				dataRefreshTimer = setTimer(dataRefresh, dataRefreshSampleRate, 0)
				showChat(false)
			else
				--removeEventHandler("onClientRender", getRootElement(), renderPerformance, true, "low-9999999999")
				destroyRender('renderPerformance')
				removeEventHandler("onClientClick", getRootElement(), clickPerformance)
				removeEventHandler("onClientKey", getRootElement(), keyPerformance)
				showChat(true)
			end
		end
	end
)

addEvent("clientPerformance", true)
addEventHandler("clientPerformance", getRootElement(),
	function ()
		performanceElement = source
		performanceElementType = "anotherClient"
		panelState = not panelState

		if isTimer(dataRefreshTimer) then
			killTimer(dataRefreshTimer)
		end

		if isElement(renderTarget) then
			destroyElement(renderTarget)
		end

		if panelState then
			--addEventHandler("onClientRender", getRootElement(), renderPerformance, true, "low-9999999999")
			createRender('renderPerformance', renderPerformance)
			addEventHandler("onClientClick", getRootElement(), clickPerformance)
			addEventHandler("onClientKey", getRootElement(), keyPerformance)

			dataRefresh()
			dataRefreshTimer = setTimer(dataRefresh, dataRefreshSampleRate, 0)
			showChat(false)
		else
			--removeEventHandler("onClientRender", getRootElement(), renderPerformance, true, "low-9999999999")
			destroyRender('renderPerformance')
			removeEventHandler("onClientClick", getRootElement(), clickPerformance)
			removeEventHandler("onClientKey", getRootElement(), keyPerformance)
			showChat(true)
		end
	end
)

addEvent("getServerPerformanceStats", true)
addEventHandler("getServerPerformanceStats", getRootElement(),
	function (columns, rows, playerName)
		performanceStatsColumn, performanceStatsRow = columns, rows
		performanceElement = source

		if #performanceStatsRow < 1 then
			local columns2 = {}

			for i = 1, #performanceStatsColumn do
				table.insert(columns2, "")
			end

			table.insert(performanceStatsRow, columns2)
		end

		dataProcess()
	end
)

addEvent("clientFromAnotherClient", true)
addEventHandler("clientFromAnotherClient", getRootElement(),
	function (category)
		triggerServerEvent("sendToAnother", source, localPlayer, getPerformanceStats(category))
	end
)

function dataRefresh()
	if detailsState then
		fontRows = exports.sarp_assets:getFontsDetail()
		dataProcess()
	elseif performanceElementType == "anotherClient" then
		triggerServerEvent("performanceFromAnotherClient", localPlayer, performanceElement, performanceCategory)
	elseif performanceElementType == "client" then
		performanceStatsColumn, performanceStatsRow = getPerformanceStats(performanceCategory)
		dataProcess()
	else
		triggerServerEvent("getServerPerformanceStats", localPlayer, performanceCategory)
	end
end

function dataProcess()
	if detailsState then
		local rowsLength = {}
		local totalLength = 0
		fontPanelWidth = 0

		for i = 1, #fontColumns do
			rowsLength[i] = {}

			table.insert(rowsLength[i], utf8.len(fontColumns[i]))

			for j = 1, #fontRows do
				table.insert(rowsLength[i], utf8.len(fontRows[j][i]))
			end

			table.sort(rowsLength[i],
				function (a, b)
					return b < a
				end
			)

			totalLength = totalLength + rowsLength[i][1]
		end

		for i = 1, #rowsLength do
			fontRowsWidth[i] = rowsLength[i][1] / totalLength * screenDifferenceWidth2
			fontPanelWidth = fontPanelWidth + fontRowsWidth[i] 
		end

		if listPanelPage > #fontRows - panelVisibleItems then
			scrollbarInterpolationTick = getTickCount()
			listPanelPage = #fontRows - panelVisibleItems
		end
	else
		performanceRowsLength = {}
		performanceTableCount = 0
		panelWidth = 0

		for i = 1, #performanceStatsColumn do
			performanceRowsLength[i] = {}

			table.insert(performanceRowsLength[i], utf8.len(performanceStatsColumn[i]))

			for j = 1, #performanceStatsRow do
				table.insert(performanceRowsLength[i], utf8.len(performanceStatsRow[j][i]))
			end

			table.sort(performanceRowsLength[i],
				function (a, b)
					return b < a
				end
			)

			performanceTableCount = performanceTableCount + performanceRowsLength[i][1]
		end

		for i = 1, #performanceRowsLength do
			performanceRowsWidth[i] = performanceRowsLength[i][1] / performanceTableCount * screenDifferenceWidth
			panelWidth = panelWidth + performanceRowsWidth[i]
		end

		table.sort(performanceStatsRow,
			function (a, b)
				local data = a[rowsSortBy] and utf8.gsub(a[rowsSortBy], "%%", "") or ""
				local data2 = b[rowsSortBy] and utf8.gsub(b[rowsSortBy], "%%", "") or ""

				if tonumber(data) then
					data = tonumber(data)
				end

				if tonumber(data2) then
					data2 = tonumber(data2)
				end

				if (data and not data2 or type(data) ~= type(data2)) then
					data = tostring(data)
					data2 = tostring(data2)
				end

				if rowsSortAlign then
					return data > data2
				else
					return data < data2
				end
			end
		)

		if listPanelPage > #performanceStatsRow - panelVisibleItems then
			scrollbarInterpolationTick = getTickCount()
			listPanelPage = #performanceStatsRow - panelVisibleItems
		end
	end

	if listPanelPage < 0 then
		scrollbarInterpolationTick = getTickCount()
		listPanelPage = 0
	end

	processRT()
end

function processRT()
	font = exports['oFont']:getFont('condensed', 12)
	font2 = exports['oFont']:getFont('bebasneue', 18)

	if isElement(renderTarget) then
		destroyElement(renderTarget)
	end

	if detailsState then
		renderTarget = dxCreateRenderTarget(fontPanelWidth, boxHeight * #fontRows, true)

		dxSetRenderTarget(renderTarget)
		dxSetBlendMode("modulate_add")

		local x = 0

		for i = 1, #fontColumns do
			local w = fontRowsWidth[i]

			for j = 1, #fontRows do
				local y = 0 + boxHeight * (j - 1)

				if j ~= 1 then
					dxDrawRectangle(0, y, panelWidth, 1, tocolor(0, 0, 0, 255))
				end

				if i ~= 1 then
					dxDrawRectangle(x, y, 1, boxHeight, tocolor(0, 0, 0, 255))
				end

				if j % 2 == 0 then
					dxDrawRectangle(x + 1, y + 1, w - 1, boxHeight - 1, tocolor(0, 0, 0, 125))
				else
					dxDrawRectangle(x + 1, y + 1, w - 1, boxHeight - 1, tocolor(0, 0, 0, 75))
				end

				dxDrawText(fontRows[j][i], x + 1, y, x + 1 + w - 1, y + boxHeight, whiteColor, 1, font, "center", "center", true)
			end

			x = x + w
		end

		dxSetBlendMode("blend")
		dxSetRenderTarget()
	else
		renderTarget = dxCreateRenderTarget(panelWidth, boxHeight * #performanceStatsRow, true)

		dxSetRenderTarget(renderTarget)
		dxSetBlendMode("modulate_add")

		local x_offset = 0

		for i = 1, #performanceStatsColumn do
			local rowWidth = performanceRowsWidth[i]

			for j = 1, #performanceStatsRow do
				local y = 0 + boxHeight * (j - 1)

				if j ~= 1 then
					dxDrawRectangle(0, y, panelWidth, 1, tocolor(0, 0, 0, 255))
				end

				if i ~= 1 then
					dxDrawRectangle(x_offset, y, 1, boxHeight, tocolor(0, 0, 0, 255))
				end

				if performanceCategory == "Lua timing" and (i == 2 or i == 7 or i == 12) then
					local rowColor = tocolor(0, 255, 0, 125)

					if performanceStatsRow[j] and performanceStatsRow[j][i] then
						local number = utf8.gsub(performanceStatsRow[j][i], "%%", "")

						if number and tonumber(number) then
							local progress = tonumber(number) / 30
							local r, g, b = 0, 255, 0

							if progress > 0.5 then
								r, g, b = interpolateBetween(255, 255, 0, 255, 0, 0, progress, "Linear")
							else
								r, g, b = interpolateBetween(0, 255, 0, 255, 255, 0, progress, "Linear")
							end

							rowColor = tocolor(r, g, b, 125)
						end
					end

					dxDrawRectangle(x_offset + 1, y + 1, rowWidth - 1, boxHeight - 1, rowColor)
				else
					if j % 2 == 0 then
						dxDrawRectangle(x_offset + 1, y + 1, rowWidth - 1, boxHeight - 1, tocolor(0, 0, 0, 125))
					else
						dxDrawRectangle(x_offset + 1, y + 1, rowWidth - 1, boxHeight - 1, tocolor(0, 0, 0, 75))
					end
				end

				dxDrawText(performanceStatsRow[j][i], x_offset + 1, y, x_offset + 1 + rowWidth - 1, y + boxHeight, whiteColor, 1.0, font, "center", "center", true)
			end

			x_offset = x_offset + rowWidth
		end

		dxSetBlendMode("blend")
		dxSetRenderTarget()
	end
end

function renderPerformance()
	font = exports['oFont']:getFont('condensed', 12)
	font2 = exports['oFont']:getFont('bebasneue', 18)

	local cursorX, cursorY = getCursorPosition()
	if cursorX and cursorY then
		cursorX, cursorY = cursorX * sx, cursorY * sy
	else
		cursorX, cursorY = -99, -99
	end

	activeDirectX = false

	local fullPanelHeight = boxHeight * #performanceStatsRow
	local panelHeight = fullPanelHeight

	if panelHeight < titleHeight + boxHeight then
		panelHeight = titleHeight + boxHeight
	elseif panelHeight > panelMaxHeight then
		panelHeight = panelMaxHeight
	end

	local x = (sx - panelWidth) * 0.5
	local y = (sy - panelHeight) * 0.5

	local y2 = y - titleHeight

	dxDrawRoundedRectangle(x, y - titleHeight, panelWidth, panelHeight + titleHeight + boxHeight)
	dxDrawRectangle(x, y2, panelWidth, titleHeight, tocolor(50, 50, 50, 75))

	local titleWidth = dxGetTextWidth("CS-RP", 1, font2, true) + 5

	dxDrawText("CS-RP", x + 5, y2, 0, y, whiteColor, 1, font2, "left", "center", false, false, false, true)
	dxDrawText("Performance Browser - ", x + titleWidth + 10, y2, x, y, whiteColor, 1, font, "left", "center")

	titleWidth = titleWidth + dxGetTextWidth("Performance Browser - ", 1, font)

	dxDrawText("SampleRate: " .. dataRefreshSampleRate, x + titleWidth + 10, y2, x, y, whiteColor, 0.8, font, "left", "center")
	
	titleWidth = titleWidth + dxGetTextWidth("SampleRate: " .. dataRefreshSampleRate, 0.8, font) + 5

	if cursorX >= x + titleWidth + 10 and cursorY >= y - smallBoxSize2 and cursorX <= x + titleWidth + 10 + smallBoxSize and cursorY <= y - smallBoxSize2 + smallBoxSize then
		dxDrawRoundedRectangle(x + titleWidth + 10, y - smallBoxSize2, smallBoxSize, smallBoxSize, tocolor(50, 179, 239, 175))
		activeDirectX = "sampleRate:plus"
	else
		dxDrawRoundedRectangle(x + titleWidth + 10, y - smallBoxSize2, smallBoxSize, smallBoxSize, tocolor(50, 50, 50, 200))
	end
	dxDrawText("+", x + titleWidth + 10, y - smallBoxSize2, x + titleWidth + 10 + smallBoxSize, y - smallBoxSize2 + smallBoxSize, whiteColor, 1, font, "center", "center")

	titleWidth = titleWidth + smallBoxSize + 5

	if cursorX >= x + titleWidth + 10 and cursorY >= y - smallBoxSize2 and cursorX <= x + titleWidth + 10 + smallBoxSize and cursorY <= y - smallBoxSize2 + smallBoxSize then
		dxDrawRoundedRectangle(x + titleWidth + 10, y - smallBoxSize2, smallBoxSize, smallBoxSize, tocolor(50, 179, 239, 175))
		activeDirectX = "sampleRate:minus"
	else
		dxDrawRoundedRectangle(x + titleWidth + 10, y - smallBoxSize2, smallBoxSize, smallBoxSize, tocolor(50, 50, 50, 200))
	end
	dxDrawText("-", x + titleWidth + 10, y - smallBoxSize2, x + titleWidth + 10 + smallBoxSize, y - smallBoxSize2 + smallBoxSize, whiteColor, 1, font, "center", "center")

	titleWidth = titleWidth + smallBoxSize + 5

	dxDrawText("Type: " .. performanceElementType .. "-" .. performanceCategory, x + titleWidth + 10, y2, x, y, whiteColor, 0.8, font, "left", "center")

	titleWidth = titleWidth + dxGetTextWidth("Type: " .. performanceElementType .. "-" .. performanceCategory, 0.8, font) + 10
	
	local performanceSide = performanceElementType == "client" and "server" or "client"
	local sideWidth = dxGetTextWidth("Switch to " .. performanceSide .. " side", 1, font) + 10

	if cursorX >= x + titleWidth + 10 and cursorY >= y - smallBoxSize2 and cursorX <= x + titleWidth + 10 + sideWidth and cursorY <= y - smallBoxSize2 + smallBoxSize then
		dxDrawRoundedRectangle(x + titleWidth + 10, y - smallBoxSize2, sideWidth, smallBoxSize, tocolor(50, 179, 239, 175))
		activeDirectX = "side:" .. performanceSide
	else
		dxDrawRoundedRectangle(x + titleWidth + 10, y - smallBoxSize2, sideWidth, smallBoxSize, tocolor(50, 50, 50, 200))
	end
	dxDrawText("Switch to " .. performanceSide .. " side", x + titleWidth + 10, y - smallBoxSize2, x + titleWidth + 10 + sideWidth, y - smallBoxSize2 + smallBoxSize, whiteColor, 1, font, "center", "center")

	titleWidth = titleWidth + sideWidth + 5
	sideWidth = dxGetTextWidth(performanceCategories[performanceCategoryId + 1] or performanceCategories[1], 1, font) + 10

	if cursorX >= x + titleWidth + 10 and cursorY >= y - smallBoxSize2 and cursorX <= x + titleWidth + 10 + sideWidth and cursorY <= y - smallBoxSize2 + smallBoxSize then
		dxDrawRoundedRectangle(x + titleWidth + 10, y - smallBoxSize2, sideWidth, smallBoxSize, tocolor(50, 179, 239, 175))
		activeDirectX = "switchCategory"
	else
		dxDrawRoundedRectangle(x + titleWidth + 10, y - smallBoxSize2, sideWidth, smallBoxSize, tocolor(50, 50, 50, 200))
	end
	dxDrawText(performanceCategories[performanceCategoryId + 1] or performanceCategories[1], x + titleWidth + 10, y - smallBoxSize2, x + titleWidth + 10 + sideWidth, y - smallBoxSize2 + smallBoxSize, whiteColor, 1, font, "center", "center")

	if performanceElementType == "anotherClient" and isElement(performanceElement) then
		dxDrawText("Client: " .. string.gsub(string.gsub(getPlayerName(performanceElement), "_", " "), "#%x%x%x%x%x%x", ""), x, y2, x + panelWidth - 10, y, whiteColor, 0.8, font, "right", "center")
	end

	dxDrawRectangle(x, y, panelWidth, boxHeight, tocolor(0, 0, 0, 125))

	local x_offset = x

	for i = 1, #performanceStatsColumn do
		local rowWidth = performanceRowsWidth[i]

		if cursorX >= x_offset and cursorY >= y and cursorX <= x_offset + rowWidth and cursorY <= y + boxHeight and not activeDirectX then
			activeDirectX = "sortBy:" .. i
			dxDrawRectangle(x_offset, y, rowWidth, boxHeight, tocolor(50, 179, 239, 175))
		end

		if i ~= 1 then
			dxDrawRectangle(x_offset, y, 1, boxHeight, tocolor(0, 0, 0, 255))
		end
		dxDrawText(performanceStatsColumn[i], x_offset + 1, y, x_offset + 1 + rowWidth - 1, y + boxHeight, whiteColor, 1.0, font, "center", "center", true)

		x_offset = x_offset + rowWidth
	end

	dxDrawRectangle(x, y + boxHeight, panelWidth, 2, tocolor(0, 0, 0, 255))

	if isElement(renderTarget) then
		y = y + boxHeight

		local currentTick = getTickCount()

		if scrollbarInterpolationTick and currentTick >= scrollbarInterpolationTick then
			local scrollbarMoveAnimation = interpolateBetween(scrollbarPosition, 0, 0, listPanelPage, 0, 0, (currentTick - scrollbarInterpolationTick) / 500, "OutQuad")
			scrollbarPosition = scrollbarMoveAnimation
		end

		dxDrawImageSection(x, y, panelWidth, panelHeight, 0, scrollbarPosition * boxHeight, panelWidth, panelHeight, renderTarget)

		if #performanceStatsRow > panelVisibleItems then
			dxDrawRectangle(x + panelWidth - 5, y, 5, panelHeight, tocolor(30, 30, 30, 200))
			dxDrawRectangle(x + panelWidth - 5, y + (panelHeight / #performanceStatsRow) * scrollbarPosition, 5, (panelHeight / #performanceStatsRow) * panelVisibleItems, tocolor(50, 179, 239, 200))
		end
	end
end

function keyPerformance(key)
	if #performanceStatsRow > panelVisibleItems then
		if key == "mouse_wheel_down" and listPanelPage < #performanceStatsRow - panelVisibleItems then
			scrollbarInterpolationTick = getTickCount()
			listPanelPage = listPanelPage + panelVisibleItems
	
			if listPanelPage > #performanceStatsRow - panelVisibleItems then
				listPanelPage = #performanceStatsRow - panelVisibleItems
			end
		elseif key == "mouse_wheel_up" and listPanelPage > 0 then
			scrollbarInterpolationTick = getTickCount()
			listPanelPage = listPanelPage - panelVisibleItems
			
			if listPanelPage < 0 then
				listPanelPage = 0
			end
		end
	end
end

function clickPerformance(button, state)
	if state == "up" then
		if activeDirectX then
			local subStrings = split(activeDirectX, ":")

			if subStrings[1] == "sortBy" then
				local columnId = tonumber(subStrings[2])

				if columnId == rowsSortBy then
					rowsSortAlign = not rowsSortAlign
				else
					rowsSortAlign = true
					rowsSortBy = columnId
				end
			elseif subStrings[1] == "sampleRate" then
				if subStrings[2] == "plus" then
					if isTimer(dataRefreshTimer) then
						killTimer(dataRefreshTimer)
					end

					if dataRefreshSampleRate < 10000 then
						dataRefreshSampleRate = dataRefreshSampleRate + 500
					end

					dataRefreshTimer = setTimer(dataRefresh, dataRefreshSampleRate, 0)
				elseif subStrings[2] == "minus" then
					if isTimer(dataRefreshTimer) then
						killTimer(dataRefreshTimer)
					end

					if dataRefreshSampleRate > 500 then
						dataRefreshSampleRate = dataRefreshSampleRate - 500
					end

					dataRefreshTimer = setTimer(dataRefresh, dataRefreshSampleRate, 0)
				end
			elseif subStrings[1] == "side" then
				performanceElementType = subStrings[2]
			elseif subStrings[1] == "switchCategory" then
				performanceCategoryId = performanceCategoryId + 1

				if performanceCategoryId > #performanceCategories then
					performanceCategoryId = 1
				end

				performanceCategory = performanceCategories[performanceCategoryId]
			end

			if subStrings[1] then
				dataRefresh()
			end
		end
	end
end

function dxDrawRoundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	borderColor = borderColor or tocolor(0, 0, 0, 200)
	bgColor = bgColor or borderColor

	dxDrawRectangle(x, y, w, h, bgColor, postGUI)
	dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI)
	dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI)
	dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI)
	dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI)
end