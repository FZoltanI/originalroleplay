raceMarker = {
    {588.6484375,-1171.6782226562,23.429067611694}
}

sectorDetails = {
    
}

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end   

function formatIntoTime(a, isPlus)
    local string = ""
    --outputChatBox(a)
    if tonumber(a) <= 0 then
        a = a * -1
        if math.floor(a / 1000 / 60) >= 1 then -- Perces szitu
            local a1 = math.floor(a / 1000 / 60)
            local a2 = math.floor((a / 1000 - (a1 * 60)))
            local a3 = math.round(a - ((a2 + (a1 * 60)) * 1000), 3)
            if a1 < 10 then
                a1 = "0" .. a1
            end
            if a2 < 10 then
                a2 = "0" .. a2
            end
            string = "-" .. a1 .. ":" .. a2 .. ".".. a3
        else -- Másodperces szitu
            local a1 = math.floor(a / 1000)
            local a2 = math.round(a - (a1 * 1000), 3)
            if a1 < 10 then
                a1 = "0" .. a1
            end
            string = "-" .. a1 .. "." .. a2
        end
    else
        if math.floor(a / 1000 / 60) >= 1 then -- Perces szitu
            local a1 = math.floor(a / 1000 / 60)
            local a2 = math.floor((a / 1000 - (a1 * 60)))
            local a3 = math.round(a - ((a2 + (a1 * 60)) * 1000), 3)
            if a1 < 10 then
                a1 = "0" .. a1
            end
            if a2 < 10 then
                a2 = "0" .. a2
            end
            string = (isPlus and "+" or "") .. a1 .. ":" .. a2 .. ".".. a3
        else -- Másodperces szitu
            local a1 = math.floor(a / 1000)
            local a2 = math.round(a - (a1 * 1000), 3)
            if a1 < 10 then
                a1 = "0" .. a1
            end
            string = (isPlus and "+" or "") .. a1 .. "." .. a2
        end
    end

    return string
end

for k,v in pairs(sectorDetails) do
    local v = v
    v[3] = v[3] - 0.4
    sectorDetails[k] = v
end