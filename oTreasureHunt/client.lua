local txd = engineLoadTXD("files/txd.txd")
engineImportTXD(txd, moundModelID)

local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local occupiedTreasureCol
function renderInteraction()
    if not isElement(occupiedTreasureCol) then 
        occupiedTreasureCol = false
        removeEventHandler("onClientRender", root, renderInteraction)
        unbindKey("e", "up", startDig)
        return
    end

    core:dxDrawShadowedText("A kincs kiásásához nyomd meg az "..color.."[E] #ffffffgombot!", 0, sy*0.8, sx, sy*0.85, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1, exports.oFont:getFont("condensed", 13/myX*sx), "center", "center", false, false, false, true)
end

local lastTrigger = 0
function startDig()
    if not isElement(occupiedTreasureCol) then 
        unbindKey("e", "up", startDig)
        return 
    end
    
    local box = getElementData(occupiedTreasureCol, "treasureHunt:box")
    local mound = getElementData(box, "treasureHunt:mound")

    if lastTrigger + digTime + 1000 < getTickCount() then
        lastTrigger = getTickCount()
        triggerServerEvent("treasureHunt > startTreasureDig", resourceRoot, mound, box, occupiedTreasureCol)
        chat:sendLocalMeAction("elkezdett kiásni egy kincset.")
    end
end

addEventHandler("onClientColShapeHit", resourceRoot, function(element, mdim)
    if element == localPlayer and mdim then 
        if getElementData(source, "treasureHunt:box") then 
            if not getPedOccupiedVehicle(localPlayer) then 
                occupiedTreasureCol = source
                addEventHandler("onClientRender", root, renderInteraction)
                bindKey("e", "up", startDig)
            end 
        end
    end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(element, mdim)
    if element == localPlayer and mdim then 
        if not isElement(occupiedTreasureCol) then return end 
        removeEventHandler("onClientRender", root, renderInteraction)
        unbindKey("e", "up", startDig)

        occupiedTreasureCol = false
    end
end)

local sellItems = {}

function sellAntiqueItem(itemid, count, item)
    if antiquePrices[itemid] then 
        if not core:tableContains(sellItems, item.id) then
            table.insert(sellItems, item.id)
            triggerServerEvent("treasure > sellItem", resourceRoot, antiquePrices[itemid]*count, item, "antique", itemid)
            --triggerServerEvent("takeItem", root, localPlayer, item.item, item.count)
            return true 
        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Régiség kereskedő", 2).."Ez a tárgy itt nem adható el!", 255, 255, 255, true)
        return false
    end
end

function sellJewelryItem(itemid, count, item)
    local jewelryCount = getElementData(resourceRoot,"jewelryCount")
    if jewelryCount then
        if not core:tableContains(sellItems, item.id) then
            table.insert(sellItems, item.id)
            triggerServerEvent("treasure > sellItem", resourceRoot, math.floor(jewelryCount*count), item, "jewelry", itemid)
            --triggerServerEvent("takeItem", root, localPlayer, item.item, item.count)

        end
    else
        outputChatBox(core:getServerPrefix("red-dark", "Drágakő kereskedő", 2).."Ez a tárgy itt nem adható el!", 255, 255, 255, true)
    end
end


local jewCol = createColSphere(jew2ped[2],jew2ped[3],jew2ped[4],2)

function jewColHit ( player, matchingDimension )
    if player == localPlayer then    
        if getElementType ( player ) == "player" then
            outputChatBox("Peter (Drágakő szakértő) mondja: Szevasz! Megvizsgáljam a drágaköved? Mindössze 300$-ba kerül.",255,255,255,true)
        end
    end
end
addEventHandler ( "onClientColShapeHit", jewCol, jewColHit )
