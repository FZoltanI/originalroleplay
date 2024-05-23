local payDayTimer
local core = exports.oCore
local color, r, g, b = core:getServerColor()
local dashboard = exports.oDashboard

local vagyon = {
    ["vehicles"] = {},
    ["interiors"] = {},
}

local taxes = {
    ["Automobile"] = 150,
    ["Plane"] = 500,
    ["Bike"] = 100,
    ["Helicopter"] = 250,
    ["Boat"] = 200,
    ["Train"] = 1000,
    ["Trailer"] = 80,
    ["BMX"] = 20,
    ["Monster Truck"] = 350,
    ["Quad"] = 100,

    ["interior"] = 150,
}

local customVehicleTaxes = {
    [409] = 3500,
    [411] = 2000,
    [415] = 2500,
    [442] = 1000,
    [451] = 1500,
    [480] = 1000,
    [496] = 2800,
    [502] = 2000,
    [546] = 500,
}

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oPayDay" or getResourceName(res) == "oDashboard" then  
        core = exports.oCore
        color, r, g, b = core:getServerColor()
        dashboard = exports.oDashboard
	end
end)

function getPayment()
    getPlayerAllOwnedVehicle()
    getPlayerAllOwnedInterior()
    local vehTax = 0
    local intTax = #vagyon["interiors"]*taxes["interior"]

    local interest = exports.oBank:countInterest()
    
    for k, v in ipairs(vagyon["vehicles"]) do
        local model = getElementModel(v) 
        if customVehicleTaxes[model] then 
            vehTax = vehTax + customVehicleTaxes[model]
        else
            vehTax = vehTax + taxes[getVehicleType(v)]
        end
    end

    outputChatBox("")
    outputChatBox(core:getServerPrefix("server", "Fizetés", 2).."Megérkezett a fizetésed!", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Jármű adó", 3).." "..vehTax..color.."$", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Ingatlan adó", 3).." "..intTax..color.."$", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Banki kamat", 3).." "..interest..color.."$ #ffffff(Az összes számla kamatja összesen)", 255, 255, 255, true)
    triggerServerEvent("payday > getPaymentOnServer", resourceRoot, dashboard:getPlayerAllFactions(), vehTax+intTax)
end

function startTimer()
    payDayTimer = setTimer(function()
        if not (getElementData(localPlayer, "afk")) then
            setElementData(localPlayer, "char:minToPayment", (getElementData(localPlayer, "char:minToPayment") or 0) - 1)

            if getElementData(localPlayer, "char:minToPayment") <= 0 then 
                getPayment()
                setElementData(localPlayer, "char:minToPayment", 60)
            end
        end
    end, core:minToMilisec(1), 0)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "user:loggedin") then 
        startTimer()
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then 
        if data == "user:loggedin" then 
            if new then 
                startTimer()
            else
                if isTimer(payDayTimer) then 
                    killTimer(payDayTimer)
                end
            end
        end
    end
end)

function getPlayerAllOwnedVehicle()
    vagyon["vehicles"] = {}
    for k, v in ipairs(getElementsByType("vehicle")) do 
        if getElementData(v, "veh:isFactionVehice") == 0 then 
            if getElementData(v, "veh:owner") == getElementData(localPlayer,"char:id") then 
                table.insert(vagyon["vehicles"], v)
            end
        end
    end
end

function getPlayerAllOwnedInterior()
    vagyon["interiors"] = {}
    for k, v in ipairs(getElementsByType("marker")) do 
        if getElementData(v, "isIntMarker") then 
            if getElementData(v, "owner") == getElementData(localPlayer, "char:id") then 
                table.insert(vagyon["interiors"], v)
            end
        end
    end
end