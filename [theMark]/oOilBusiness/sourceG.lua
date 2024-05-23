testingMarker = {
    {2119.12109375, 1186.4558105469, 10.8203125},
    {2119.12109375+10, 1186.4558105469, 10.8203125},
    {2119.12109375+20, 1186.4558105469, 10.8203125},
}

oilStation = {
    oilPump = {
        {3426, 668.23266601563,1366.9119873047,12.093702316284},
        {3426, 668.23266601573+10,1366.9119873047,12.093702316284},
        {3426, 668.23266601573+20,1366.9119873047,12.093702316284},
        {3426, 668.23266601573+30,1366.9119873047,12.093702316284},
        {3426, 668.23266601573+40,1366.9119873047,12.093702316284},
    },
}

oilDatas = {}
oilTimers = {}
oilTimersErrors = {}

--2134.9453125, 1192.802734375, 10.671875

function getOilStationById(id)
    for k,v in ipairs(getElementsByType("marker")) do 
        if getElementData(v, "oilMarker.isOil") then 
            if id == getElementData(v, "oilMarker.dbId") then 
                return v
            end
        end
    end
    return false
end

function getOilStationByOwner(charID)
	for k,v in ipairs(getElementsByType("marker")) do 
		if getElementData(v, "oilMarker.isOil") then 
			if getElementData(v,"oilMarker.datas").owner == charID then 
				return v
			end
		end
	end
	return false
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