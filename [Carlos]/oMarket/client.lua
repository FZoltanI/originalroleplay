local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local sellValues = false

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oMarket" or getResourceName(res) == "oCore" or getResourceName(res) == "oInventory"  or getResourceName(res) == "oInfobox" then
		core = exports.oCore
        inventory = exports.oInventory
        infobox = exports.oInfobox

        color, r, g, b = core:getServerColor()
	end
end)

local sellItems = {}


function sellFishItem(id, count, itemData, priceMultiplier)
    if sellValues then return end
		if not exports.oInventory:hasItem(146) then return outputChatBox(core:getServerPrefix("red-dark", "Halfelvásárló", 2).."Horgászengedély nélkül nem adhatod le a halat (Városházán váltható ki)!", 255, 255, 255, true) end

    local itemPrice = fishPrices[id] or false

    if itemPrice then
        if not core:tableContains(sellItems, itemData.id) then
            table.insert(sellItems, itemData.id)

            itemPrice = itemPrice*priceMultiplier

            local price = count*itemPrice

            price = math.floor(price)

            sellValues = {price, id, count, itemData, "Halfelvásárló"}
            minigameStart()

            triggerServerEvent("deleteItem", root, localPlayer, itemData, true, localPlayer)
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Halfelvásárló", 2).."Ezt a tárgyat itt nem adhatod el!", 255, 255, 255, true)
    end
end

function sellMushroomItem(id, count, itemData, priceMultiplier)
    if sellValues then return end
    local itemPrice = mushroomPrices[id] or false

    if itemPrice then
        if not core:tableContains(sellItems, itemData.id) then
            table.insert(sellItems, itemData.id)
            itemPrice = itemPrice*priceMultiplier

            local price = count*itemPrice

            price = math.floor(price)

            sellValues = {price, id, count, itemData, "Gombafelvásárló"}
            minigameStart()

            triggerServerEvent("deleteItem", root, localPlayer, itemData, true, localPlayer)
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Gombafelvásárló", 2).."Ezt a tárgyat itt nem adhatod el!", 255, 255, 255, true)
    end
end

function sellAnimalItem(id, count, itemData, priceMultiplier)
    if sellValues then return end


    local itemPrice = animalPrices[id] or false

    if itemPrice then
        if not core:tableContains(sellItems, itemData.id) then
            table.insert(sellItems, itemData.id)
            itemPrice = itemPrice*priceMultiplier

            local price = count*itemPrice

            price = math.floor(price)

            sellValues = {price, id, count, itemData, "Állatfelvásárló"}
            minigameStart()


            triggerServerEvent("deleteItem", root, localPlayer, itemData, true, localPlayer)
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Állatfelvásárló", 2).."Ezt a tárgyat itt nem adhatod el!", 255, 255, 255, true)
    end
end

local lineWidth = 1
local tick = getTickCount()

local colorTypes = {
    {"bad", "#f54242", 0.125},
    {"normal", "#f2a41d", 0.2},
    {"good", "#19d467", 0.25},
}

local time = math.random(800, 1200)

local bars = {}

local nyomva = false

function renderMinigame()
    showCursor(true)
    local lineWidth = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-tick)/time, "CosineCurve")
    dxDrawRectangle(sx*0.5-200/myX*sx/2, sy*0.858, 200/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
    dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, 200/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))

    local color = 1

    if lineWidth <= 0.3 then
        color = 1
    elseif lineWidth <= 0.85 and lineWidth > 0.3 then
        color = 2
    elseif lineWidth > 0.85 then
        color = 3
    end

    if lineWidth < 0.1 then
        time = math.random(800, 1200)
    end

    if getKeyState("space") then
        if not nyomva then
            nyomva = true
            table.insert(bars, color)
            if #bars == 5 then
                minigameEnd()
            end
        end
    else
        nyomva = false
    end

    dxDrawRectangle(sx*0.5-200/myX*sx/2+1.5/myX*sx, sy*0.858+2/myY*sy, (200/myX*sx-4/myX*sx)*lineWidth, 10/myY*sy-4/myY*sy, tocolor(hex2rgb(colorTypes[color][2])))

    local startX = sx*0.5-200/myX*sx/2
    for i = 1, 5 do
        dxDrawRectangle(startX, sy*0.84, 38/myX*sx, 10/myY*sy, tocolor(35, 35, 35, 255))
        dxDrawRectangle(startX+2/myX*sx, sy*0.84+2/myY*sy, 38/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(40, 40, 40, 255))

        if bars[i] then
            dxDrawRectangle(startX+2/myX*sx, sy*0.84+2/myY*sy, 38/myX*sx-4/myX*sx, 10/myY*sy-4/myY*sy, tocolor(hex2rgb(colorTypes[bars[i]][2])))
        end

        startX = startX + 40.5/myX*sx
    end
end

function minigameStart()
    nyomva = false
    bars = {}
    addEventHandler("onClientRender", root, renderMinigame)
end

function minigameEnd()
    showCursor(false)
    removeEventHandler("onClientRender", root, renderMinigame)

    local multiplier = 0

    for k, v in ipairs(bars) do
        multiplier = multiplier+colorTypes[v][3]
    end
    sellValues[1] = sellValues[1]*multiplier
    sellValues[1] = math.floor(sellValues[1])

    outputChatBox(core:getServerPrefix("server", sellValues[5], 2).."Eladtál "..color..sellValues[3].."#ffffffdb "..color..inventory:getItemName(sellValues[2]).."#ffffff-(e)t "..color..sellValues[1].."#ffffff$-ért.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", sellValues[5], 2).."Eladási szorzó: "..color..multiplier.."x#ffffff.", 255, 255, 255, true)
    triggerServerEvent("market > sellItem", resourceRoot, sellValues[1])

    sellValues = false
end

function hex2rgb(hex)
    if hex then
        hex = hex:gsub("#","")
        return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    end
end
