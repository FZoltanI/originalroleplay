addEventHandler("onResourceStart", resourceRoot, function()
	updateTime()
end)

local weatherNow = "false"

addEventHandler("onPlayerJoin", root, function()
    triggerClientEvent(source, "returnWeatherDatas > toClient", source, weatherNow)
end)

--- idő beállítása
local months = {
	[0] = 4, -- Január
	[1] = 4, -- Február
	[2] = 4, -- Március
	[3] = 3, -- Április
	[4] = 1, -- Május
	[5] = 1, -- Június
	[6] = 1, -- Július
	[7] = 1, -- Augusztus
	[8] = 2, -- Szeptember
	[9] = 3, -- Október
	[10] = 3, -- November
	[11] = 4, -- December
}

local month = getRealTime().month
local monthday = getRealTime().monthday
local idoeltolodas = months[month]

if month == 7 and monthday == 21 then
	idoeltolodas = 3
end

function getTimeZoneMinus()
	return idoeltolodas
end

local winterTime = true
local winterTimes = {
	[0] = 22,
	[1] = 22,
	[2] = 22,
	[3] = 22,
	[4] = 22,
	[5] = 22,
	[6] = 22,
	[7] = 5,
	[8] = 7,
	[9] = 9,
	[10] = 10,
	[11] = 11,
	[12] = 12,
	[13] = 13,
	[14] = 14,
	[15] = 15,
	[16] = 20,
	[17] = 21,
	[18] = 22,
	[19] = 22,
	[20] = 22,
	[21] = 22,
	[22] = 22,
	[23] = 22,
}

-- valós idő
local nt = nil
function updateTime()
	local realtime = getRealTime()
	local hour = realtime.hour
	
	if winterTime then
		hour = winterTimes[hour]
	else
		hour = hour + idoeltolodas
		
		if hour >= 24 then
			hour = hour - 24
		elseif hour < 0 then
			hour = hour + 24
		end
	end

	minute = realtime.minute

	setTime(hour, minute)
	
	nextupdate = (60-realtime.second) * 1000
	setMinuteDuration(nextupdate)
    if isTimer(nt) then
        killTimer(nt)
    end
	nt = setTimer(setMinuteDuration, nextupdate + 5, 1, 60000)
end


local weatherIDs = {
	["Haze"] = math.random(12,15),
	["Mostly Cloudy"] = 2,
	["Clear"] = 10,
	["Cloudy"] = math.random(0,7),
	["Flurries"] = 32,
	["Fog"] = math.random(0,7),
	["Mostly Sunny"] = math.random(0,7),
	["Partly Cloudy"] = math.random(0,7),
	["Partly Sunny"] = math.random(0,7),
	["Freezing Rain"] = 2,
	["Rain"] = 2,
	["Sleet"] = 2,
	-- ["Snow"] = 31,
	["Sunny"] = 11,
	["Thunderstorms"] = 8,
	["Thunderstorm"] = 8,
	["Unknown"] = 0,
	["Overcast"] = 7,
	["Scattered Clouds"] = 7,
	["Broken Clouds"] = 7,
	["Light Snow"] = 4,
	["Light Rain"] = 4,
}

local weatherNames = {
	["Haze"] = "Ködös",
	["Mostly Cloudy"] = "Többnyire felhős",
	["Clear"] = "Tiszta",
	["Cloudy"] = "Felhős",
	["Flurries"] = "Havas",
	["Fog"] = "Ködös",
	["Mostly Sunny"] = "Túlnyomóan napos",
	["Partly Cloudy"] = "Részben felhős",
	["Partly Sunny"] = "Részben napos",
	["Freezing Rain"] = "Ónos esős",
	["Rain"] = "Esős",
	["Sleet"] = "Havas esős",
	["Snow"] = "Havas",
	["Sunny"] = "Napos",
	["Thunderstorms"] = "Zivataros",
	["Thunderstorm"] = "Zivataros",
	["Unknown"] = "Ismeretlen",
	["Overcast"] = "Felhős",
	["Scattered Clouds"] = "Közepesen felhős",
	["Broken Clouds"] = "Közepesen felhős",
	["Light Rain"] = "Enyhén esős",
	["Light Snow"] = "Enyhén havas",
}


local temperature = 0;
-- apikey: 82211fac04f5878eec467bbc96c06531
function fetchWeather()
	updateTime()
	--setRainLevel(0)
	fetchRemote("https://api.openweathermap.org/data/2.5/weather?q=Budapest&units=metric&appid=82211fac04f5878eec467bbc96c06531", function(data)
		local isFlooding = false
		local new = fromJSON(data)
       -- iprint(new)
       -- if new then
            local temp = tonumber(new["main"]["temp"])
			local wind = new["wind"]["speed"]*3.6
            --print(new["weather"]["description"])
            
            local weather = capitalize(new["weather"][1]["description"]) --new["weather"][1]["description"]:sub(1, 1):upper() .. new["weather"][1]["description"]:sub(2) or "Overcast"
            --print(weather)
            if isFlooding then
                weather = "Thunderstorm"
            end
            if not weatherNames[weather] then
                outputDebugString("ismeretlen időjárás: "..weather)
                weather = "Cloudy"
            end
			weatherNow = {weather, wind, temp}
            outputDebugString("Időjárás változás: (".. weather .. ") | "..weatherNames[weather])
            iprint("Időjárás: ",weatherNow)
			triggerClientEvent(getRootElement(), "returnWeatherDatas > toClient", getRootElement(), weatherNow)
            if weatherNames[weather] == "Rain" then 
                setRainLevel(0.3)
                --rainLevel = 0.3
            elseif weatherNames[weather] == "Thunderstorms" or weatherNames[weather] == "Thunderstorm" then 
                setRainLevel(0.5)
                --rainLevel = 0.5
            else 
                setRainLevel(0)
             --   rainLevel = 0
            end
            
            if not isFlooding then
                if weatherIDs[weather] then
                    setWeather(weatherIDs[weather])
                else
                    setWeather(0)
                end
            end
       -- else 
         --   outputDebugString("Hibás weatherAPI!")
        --end
	end, nil, true )
end
setTimer(fetchWeather, 60*60*1000, 0)
addEventHandler("onResourceStart", resourceRoot, fetchWeather)

setTimer(function()
    if getRainLevel() > 0 then 
        setRainLevel(getRainLevel())
    end
end, 350, 0)


local function doCapitalizing( substring )
    -- Upper the first character and leave the rest as they are
    return substring:sub( 1, 1 ):upper( ) .. substring:sub( 2 )
end

function capitalize( text )
    -- Sanity check
    assert( type( text ) == "string", "Bad argument 1 @ capitalize [String expected, got " .. type( text ) .. "]")

    -- We don't care about the number of words, so return only the first result string.gsub provides
    return ( { string.gsub( text, "%a+", doCapitalizing ) } )[1]
end

function getTemperature()
	return temperature;
end