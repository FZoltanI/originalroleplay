local rootElement = getRootElement()

function outputConsoleR(message, toElement)
	if toElement == false then
		outputServerLog(message)
	else
		toElement = toElement or rootElement
		outputConsole(message, toElement)
		if toElement == rootElement then
			outputServerLog(message)
		end
	end
end

function outputChatBoxR(message, toElement, forceLog)
	if toElement == false then
		outputServerLog(message)
	else
        local syntax = exports['oCore']:getServerPrefix("freen-dark", "Dev", 2)    
		toElement = toElement or rootElement
		--outputChatBox(syntax .. message, toElement, 250, 200, 200, true)
        exports['oAdmin']:sendMessageToAdmin(toElement, syntax .. message, 10)
		--if toElement == rootElement or forceLog then
        outputServerLog(message)
		--end
	end
end

-- dump the element tree
function map(element, outputTo, level)
	level = level or 0
	element = element or getRootElement()
	local indent = string.rep('  ', level)
	local eType = getElementType(element)
	local eID = getElementID(element)
	local eChildren = getElementChildren(element)
	
	local tagStart = '<'..eType
	if eID then
		tagStart = tagStart..' id="'..eID..'"'
	end
	for dataField, dataValue in pairs(getAllElementData(element)) do
		tagStart = tagStart..' '..dataField..'="'..tostring(dataValue)..'"'
	end
	
	if #eChildren < 1 then
		outputConsoleR(indent..tagStart..'"/>', outputTo)
	else
		outputConsoleR(indent..tagStart..'">', outputTo)
		for k, child in ipairs(eChildren) do
			map(child, outputTo, level+1)
		end
		outputConsoleR(indent..'</'..eType..'>', outputTo)
	end
end

local rootElement = getRootElement()

local triggered = {}
function runString(commandstring, outputTo, source)
	if not exports['oAdmin']:isPlayerDeveloper(source) then return end
	
	local sourceName
	if source then
		sourceName = getElementData(source, "user:adminnick")
	else
		sourceName = "Console"
	end
	
    exports['cr_logs']:createLog(source, "sql", "srun", "SRUN -> "..sourceName.." lefutatta: "..tostring(commandstring))
	outputDebugString("SRUN -> "..sourceName.." lefutatta: "..tostring(commandstring), 0, 255, 255, 87)
	
	function getLocalPlayer( )
		return source
	end
    localPlayer = source
    
	_G['source'] = source
	if getElementType(source) == 'player' then
		vehicle = getPedOccupiedVehicle(source) or getPedContactElement(source)
		car = vehicle
	end
	settingsSet = set
	settingsGet = get
	p = getPlayerFromName
	c = getPedOccupiedVehicle
	set = setElementData
	get = getElementData
    me = source
	id = function(a) return exports['oCore']:getPlayerFronName(localPlayer, tostring(a)) end

	local notReturned
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		notReturned = true
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		outputChatBoxR("Hiba: "..errorMsg, outputTo)
		return
	end
	results = { pcall(commandFunction) }
	if not results[1] then
		outputChatBoxR("Hiba: "..results[2], outputTo)
		return
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			if isElement(results[i]) then
				resultType = "element:"..getElementType(results[i])
			end
			resultsString = resultsString..inspect(results[i]).." ["..resultType.."]"
		end
		outputChatBoxR("Eredmény: "..resultsString, outputTo)
	elseif not errorMsg then
		outputChatBoxR("Parancs lefuttatva!", outputTo)
	end
end

addCommandHandler("run", 
    function(player, command, ...)
        if not exports['oAdmin']:isPlayerDeveloper(player) then return end
        local commandstring = table.concat({...}, " ")
        return runString(commandstring, rootElement, player)
    end, true
)

addCommandHandler("srun", 
    function(player, command, ...)
        if not exports['oAdmin']:isPlayerDeveloper(player) then return end
        local commandstring = table.concat({...}, " ")
        return runString(commandstring, player, player)
    end, true
)

addCommandHandler("crun", 
    function(player, command, ...)
        if not exports['oAdmin']:isPlayerDeveloper(player) then return end
        local commandstring = table.concat({...}, " ")
        if player then
            --exports.al_logs:logMessage("Runcode: "..exports['cr_admin']:getAdminName(player).." lefuttatva "..tostring(commandstring).." (client-oldal)", 5)
            --exports['cr_logs']:createLog(player, "sql", "crun", "CRUN -> "..exports['cr_admin']:getAdminName(player).." lefuttata: "..tostring(commandstring))
            outputDebugString("CRUN -> "..getElementData(player, "user:adminnick").." lefuttata: "..tostring(commandstring), 0, 87, 255, 255)
            return triggerClientEvent(player, "doCrun", rootElement, commandstring)
        else
            return runString(commandstring, false, false)
        end
    end, true
)