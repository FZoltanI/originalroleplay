local playedTime_timer = false

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then 
        if data == "user:loggedin" then 
            if new == true then 
                startCounting()
            elseif new == false then 
                if isTimer(playedTime_timer) then 
                    killTimer(playedTime_timer)
                end
            end
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "user:loggedin") then 
        startCounting()
    end
end)

function startCounting()
    if not isTimer(playedTime_timer) then 
        playedTime_timer = setTimer(function()
            local afk = getElementData(localPlayer, "char:afk") or false
            if not afk then 
                local playedTime = getElementData(localPlayer, "char:playedTime") or {0, 0}

                playedTime[2] = playedTime[2] + 1

                if playedTime[2] == 60 then 
                    playedTime[2] = 0
                    playedTime[1] = playedTime[1] + 1
                end

                setElementData(localPlayer, "char:playedTime", playedTime)
            end
        end, exports.oCore:minToMilisec(1), 0)
    end
end

function countPlayerLevel(playedHours)
    local last_level_hours = levels[#levels]

    if playedHours > last_level_hours then 
        playedHours = last_level_hours 
    end 

    local level = 1
    for k, v in pairs(levels) do 

        if v <= playedHours then 
            level = level + 1
        end

    end

    return level
end