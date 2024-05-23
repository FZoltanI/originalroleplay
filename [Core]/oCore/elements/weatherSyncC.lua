local weatherNow = {}

addEvent("returnWeatherDatas > toClient", true)
addEventHandler("returnWeatherDatas > toClient", root, function(weather)
    weatherNow = weather
    setRainLevelOnClient()
end)

local rains = {
    ["Freezing rain"] = 1,
    ["Rain"] = 3,
    ["Thunderstorms"] = 6,
    ["Thunderstorm"] = 6,
    ["Moderate rain"] = 0.5,
    ["Light rain"] = 0.2,
}

function setRainLevelOnClient()
    local weather = weatherNow[1]

    if rains[weather] then 
        if type(rains[weather]) == "number" then 
          --  setRainLevel(rains[weather])
        else
            --setRainLevel(math.random(unpack(rains[weather])))
        end
    else
        if getRainLevel() > 0 then 
            --setRainLevel(0)
        end
    end
end

function getSyncedWeather()
    return weatherNow
end