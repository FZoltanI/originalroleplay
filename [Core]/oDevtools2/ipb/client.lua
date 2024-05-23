local resX, resY = guiGetScreenSize()
local comboCategories = {"Server info", "Lua timing", "Lua time recordings", "Lua memory", "Packet usage", "Sqlite timing", "Bandwidth reduction", "Bandwidth usage", "Server timing", "Function stats", "Debug info", "Debug table", "Help", "Lib memory"}
local optionsAndFilterTyping = nil
local width,height = 1024,768
local sx,sy = guiGetScreenSize()

function setHD(hd)
	if hd then
		width,height = 1366,768
		guiSetPosition(window,resX/2-width/2,resY/2-height/2,false)
		guiSetSize(window, width, height, false)
		guiSetSize(grid, width, height, false)
	else
		width,height = 850,650
		guiSetPosition(window,resX/2-width/2,resY/2-height/2,false)
		guiSetSize(window, width, height, false)
		guiSetSize(grid, width, height, false)
	end
end

function onStart(hd)
	window = guiCreateWindow((resX / 2) - width/2, (resY / 2) - height/2, width, height, "MTA:SA Ingame Performance Browser", false)
	guiSetAlpha(window, 0.97)
	guiSetVisible(window, false)
	
	labelCategory = guiCreateLabel(193, 25, 56, 19, "Kategória:", false, window)
	
	comboCategory = guiCreateComboBox(259, 25, 150, 300, "Szerver figyelő", false, window)
	for i, cat in ipairs(comboCategories) do
		guiComboBoxAddItem(comboCategory, cat)
	end
	addEventHandler("onClientGUIComboBoxAccepted", comboCategory, askForAnotherCategory, false)
	
	grid = guiCreateGridList(0, 60, width, height, false, window)
	guiGridListSetSelectionMode(grid, 0)
	guiGridListSetSortingEnabled(grid, false)
	
	closeButton = guiCreateButton(730, 25, 56, 30, "Bezár", false, window)
	addEventHandler("onClientGUIClick", closeButton, closeStats, false)
end
addEventHandler("onClientResourceStart", resourceRoot, onStart)

function optionsAndFilterUpdate()
	local options = guiGetText(optionsBox)
	local filter = guiGetText(filterBox)
	triggerServerEvent("ipb.changeOptionsAndFilter", root, options, filter)
end

function askForAnotherCategory()
	local item = guiComboBoxGetSelected(comboCategory)
	local text = guiComboBoxGetItemText(comboCategory, item)
	triggerServerEvent("ipb.changeCat", root, text)
end

function closeStats()
	guiSetVisible(window, false)
end

function receiveStats(rtype, stat1, stat2, hd)
	if (rtype == 1) then
		setHD(hd)
		guiSetVisible(window, true)
		guiGridListClear(grid)
		removeColumns()
		for index, data in pairs(stat1) do
			guiGridListAddColumn(grid, stat1[index], 0.2)
		end
	elseif (rtype == 2) then
		guiGridListClear(grid)
		removeColumns()
		for index, data in pairs(stat1) do
			guiGridListAddColumn(grid, data, 0.2)
		end
	end
	for index, data in pairs(stat2) do
		if (guiGridListGetRowCount(grid) < index) then
			guiGridListAddRow(grid)
		end
		for index2, data2 in pairs(data) do
			if (#tostring(data2) < 2) then
				guiGridListSetItemText(grid, index - 1, index2, tostring(data2).."            ", false, false)
			else
				guiGridListSetItemText(grid, index - 1, index2, tostring(data2).."   ", false, false)
			end
		end
	end
	for index, data in pairs(stat1) do
		guiGridListAutoSizeColumn(grid, index)
	end
end
addEvent("ipb.recStats", true)
addEventHandler("ipb.recStats", root, receiveStats)

function removeColumns()
	for i=0, guiGridListGetColumnCount(grid) do
		guiGridListRemoveColumn(grid, i)
	end
	for i=0, guiGridListGetColumnCount(grid) do
		guiGridListRemoveColumn(grid, i)
	end
	for i=0, guiGridListGetColumnCount(grid) do
		guiGridListRemoveColumn(grid, i)
	end
	for i=0, guiGridListGetColumnCount(grid) do
		guiGridListRemoveColumn(grid, i)
	end
	for i=0, guiGridListGetColumnCount(grid) do
		guiGridListRemoveColumn(grid, i)
	end
end