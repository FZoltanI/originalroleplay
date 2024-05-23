setTimer( function()
stopResource( getResourceFromName("shader_wet_roads") )
stopResource( getResourceFromName("shader_snow_ground") )
end, 300, 1 )
function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end


function waveHeights()
local weather = getWeather()
local waves = math.round(getWaveHeight(), 3)

if weather == 8 or weather == 16 then


if waves < 5.9 then
setWaveHeight( waves + 0.8 )
else
setWaveHeight( 6 )
end


else 
if waves > 0.80 then
setWaveHeight( waves - 0.8 )

elseif waves < 0.78 then
setWaveHeight( 0.79 )
end


end
end
setTimer(waveHeights, 30000, 0 )

function makeitwet()
local weather = getWeather()
local waves = math.round(getWaveHeight(), 3)

if weather == 8 or weather == 16 then



if getResourceState( getResourceFromName("shader_wet_roads") ) == "running" then return 
end
startResource( getResourceFromName("shader_wet_roads"), true, true )

else 
if getResourceState( getResourceFromName("shader_wet_roads") ) == "running" then  
stopResource( getResourceFromName("shader_wet_roads") )
end


end
end

setTimer( makeitwet,  60000, 0 )


function Check(funcname, ...)
    local arg = {...}
 
    if (type(funcname) ~= "string") then
        error("Argument type mismatch at 'Check' ('funcname'). Expected 'string', got '"..type(funcname).."'.", 2)
    end
    if (#arg % 3 > 0) then
        error("Argument number mismatch at 'Check'. Expected #arg % 3 to be 0, but it is "..(#arg % 3)..".", 2)
    end
 
    for i=1, #arg-2, 3 do
        if (type(arg[i]) ~= "string" and type(arg[i]) ~= "table") then
            error("Argument type mismatch at 'Check' (arg #"..i.."). Expected 'string' or 'table', got '"..type(arg[i]).."'.", 2)
        elseif (type(arg[i+2]) ~= "string") then
            error("Argument type mismatch at 'Check' (arg #"..(i+2).."). Expected 'string', got '"..type(arg[i+2]).."'.", 2)
        end
 
        if (type(arg[i]) == "table") then
            local aType = type(arg[i+1])
            for _, pType in next, arg[i] do
                if (aType == pType) then
                    aType = nil
                    break
                end
            end
            if (aType) then
                error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..table.concat(arg[i], "' or '").."', got '"..aType.."'.", 3)
            end
        elseif (type(arg[i+1]) ~= arg[i]) then
            error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..arg[i].."', got '"..type(arg[i+1]).."'.", 3)
        end
    end
end


local gWeekDays = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
function FormatDate(format, escaper, timestamp)
	Check("FormatDate", "string", format, "format", {"nil","string"}, escaper, "escaper", {"nil","string"}, timestamp, "timestamp")
 
	escaper = (escaper or "'"):sub(1, 1)
	local time = getRealTime(timestamp)
	local formattedDate = ""
	local escaped = false
 
	time.year = time.year + 1900
	time.month = time.month + 1
 
	local datetime = { d = ("%02d"):format(time.monthday), h = ("%02d"):format(time.hour), i = ("%02d"):format(time.minute), m = ("%02d"):format(time.month), s = ("%02d"):format(time.second), w = gWeekDays[time.weekday+1]:sub(1, 2), W = gWeekDays[time.weekday+1], y = tostring(time.year):sub(-2), Y = time.year }
 
	for char in format:gmatch(".") do
		if (char == escaper) then escaped = not escaped
		else formattedDate = formattedDate..(not escaped and datetime[char] or char) end
	end
 
	return formattedDate
end





function checkWinter( )
if FormatDate("m") == "11" or FormatDate("m") == "01" or FormatDate("m") == "12" then
startResource( getResourceFromName("shader_snow_ground") )
else
if getResourceState( getResourceFromName("shader_snow_ground") ) == "running" then
stopResource( getResourceFromName("shader_snow_ground") )
end
end
end
addEventHandler("onResourceStart", root, checkWinter)
setTimer( checkWinter, 259200000, 0 )