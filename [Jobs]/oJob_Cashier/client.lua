local sx, sy = guiGetScreenSize()
local myX, myY = 1600, 900

local alpha = 0
local animType = "open"
local animTick = getTickCount()

local oldLastItemPosition, newLastItemPosition, lastItemPosition =  sx*0.005, sx*0.005, sx*0.005
local lastItemMoveTick = getTickCount()
local itemMoveTime = 750
local moveTimer = false

local shopedItems = {}

local buyedItemPrice = 0

local fonts = {
    ["lcd-15"] = dxCreateFont("files/fonts/digital7.ttf", 15),
    ["barcode-15"] = dxCreateFont("files/fonts/barcode.ttf", 15),
}

local imageTextures = {}
local textureName = {"cash_machine", "money/1", "money/5", "money/10", "money/20", "money/50", "conveyorbelt", "logo", "items/1", "items/2", "items/3", "items/4", "items/5", "items/6", "items/7", "items/8", "items/9", "items/10", "items/11", "items/12", "items/13", "items/14", "items/15", "items/16", "items/17", "items/18", "items/19", "items/20", "barcodes/1", "barcodes/2", "barcodes/3", "barcodes/4", "barcodes/5", "barcodes/6"}

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oFont" or getResourceName(res) == "oJob_Cashier" then  
		core = exports.oCore
        font = exports.oFont
        color, r, g, b = core:getServerColor()
       -- print("asd")
      
	end
end)


_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, img, ...) 
    if type(img) == "string" then 
        image = imageTextures[img]
    end
    --print()
	_dxDrawImage(x, y, w, h, image, ...)
end

local grid = {}
local conveyorBelt = {}

local selectedMethode, givedMoney, returnMoney = 0, 0, 0

for i = 1, 5 do 
    table.insert(grid, {sx*0.005 + (#grid*250/myX*sx), sy*0.715, 250/myX*sx, 250/myY*sy})
end

function generateConveyors()
    conveyorBelt = {}
    for i = 1, 20 do 
        table.insert(conveyorBelt, {{0-sx*0.005 + ((i-1)*sx*0.05), sy*0.715, 141/myX*sx, 250/myY*sy}, {"open", 0, getTickCount()}, {false, getTickCount()}, true})
    end
    table.insert(conveyorBelt, {{0-141/myX*sx, sy*0.715, 141/myX*sx, 250/myY*sy}, {"open", 0, getTickCount()}, {false, getTickCount()}, true})
end
generateConveyors()

local posIndex = 0

local renderButtons = false

local buttonValues = {0, 0}

local movePed = false

function outputJobTips()
    outputChatBox(core:getServerPrefix("server", "Pénztáros", 3).."A munka kezdéséhez menj el egy, a térképen megjelölt bolthoz "..color.."(Sárga táska ikon)#ffffff.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Pénztáros", 3).."Menj be a boltba, majd állj be a kassza mögé #33a6f2(Kék marker)#ffffff.", 255, 255, 255, true)
    outputChatBox(core:getServerPrefix("server", "Pénztáros", 3).."Húzd le a pénztárgépen a vásárolni kívánt termékeket.", 255, 255, 255, true)
end 

function renderJobPanel()
    if animType == "open" then 
        alpha = interpolateBetween(alpha, 0, 0, 1, 0, 0, (getTickCount()-animTick)/300, "Linear")
    else
        alpha = interpolateBetween(alpha, 0, 0, 0, 0, 0, (getTickCount()-animTick)/300, "Linear")
    end

    dxDrawRectangle(0, sy*0.7, sx, sy*0.4, tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(0, sy*0.66, sx*0.2, sy*0.045, tocolor(35, 35, 35, 255*alpha))
    dxDrawRectangle(sx*0.83, sy*0.41, sx*0.5, sy*0.3, tocolor(35, 35, 35, 255*alpha))
    --dxDrawRectangle(sx*0.03, sy*0.66, sx*0.2, sy*0.03)
    dxDrawText("OriginalRoleplay", sx*0.03, sy*0.66, sx*0.03+sx*0.2, sy*0.66+sy*0.03, tocolor(r, g, b, 255*alpha), 1, font:getFont("bebasneue", 15/myX*sx), "left", "center")
    dxDrawText("Pénztáros", sx*0.03, sy*0.685, sx*0.03+sx*0.2, sy*0.685+sy*0.02, tocolor(255, 255, 255, 230*alpha), 1, font:getFont("bebasneue", 12/myX*sx), "left", "center")
    dxDrawImage(0, sy*0.659, 45/myX*sx, 45/myY*sy, "files/logo.png", 0, 0, 0, tocolor(r, g, b, 255*alpha))

    if selectedMethode > 0 then
        dxDrawRectangle(sx*0.4, sy*0.65, sx*0.2, sy*0.05, tocolor(35, 35, 35, 255*alpha))

        if selectedMethode == 3 then 
            dxDrawText("A vásárló "..color..givedMoney.."$-t adott, #ffffffvisszajáró: "..color..returnMoney.."$", sx*0.4, sy*0.65, sx*0.6, sy*0.7, tocolor(255, 255, 255, 255 * alpha), 0.8/myX*sx, font:getFont("condensed", 15/myX*sx), "center", "center", false, false, false, true)

            local panelW = #dollars * sx*0.106
            local startX = sx*0.5 - panelW / 2
            dxDrawRectangle(startX, sy*0.54, panelW, sy*0.1, tocolor(35, 35, 35, 255*alpha))

            local startY = sy*0.55

            startX = startX + sx*0.005
            for k, v in ipairs(dollars) do 
                if core:isInSlot(startX, startY, sx*0.1, sy*0.08) then 
                    dxDrawImage(startX, startY, sx*0.1, sy*0.08, "files/money/"..v..".png", 0, 0, 0, tocolor(255, 255, 255, 255 * alpha))
                else
                    dxDrawImage(startX, startY, sx*0.1, sy*0.08, "files/money/"..v..".png", 0, 0, 0, tocolor(255, 255, 255, 200 * alpha))
                end

                startX = startX + sx*0.105
            end

            dxDrawRectangle(sx*0.3, sy*0.65, sx*0.09, sy*0.05, tocolor(35, 35, 35, 255*alpha))
            if core:isInSlot(sx*0.3, sy*0.65, sx*0.09, sy*0.05) then 
                dxDrawText("Újra", sx*0.3, sy*0.65, sx*0.3 + sx*0.09, sy*0.7, tocolor(235, 55, 52, 255 * alpha), 0.9/myX*sx, font:getFont("condensed", 12/myX*sx), "center", "center")
            else
                dxDrawText("Újra", sx*0.3, sy*0.65, sx*0.3 + sx*0.09, sy*0.7, tocolor(235, 55, 52, 150 * alpha), 0.9/myX*sx, font:getFont("condensed", 12/myX*sx), "center", "center")
            end

            dxDrawRectangle(sx*0.61, sy*0.65, sx*0.09, sy*0.05, tocolor(35, 35, 35, 255*alpha))
            if core:isInSlot(sx*0.61, sy*0.65, sx*0.09, sy*0.05 ) then 
                dxDrawText("Visszajáró átadása", sx*0.61, sy*0.65, sx*0.61 + sx*0.09, sy*0.7, tocolor(r, g, b, 255 * alpha), 0.9/myX*sx, font:getFont("condensed", 12/myX*sx), "center", "center")
            else
                dxDrawText("Visszajáró átadása", sx*0.61, sy*0.65, sx*0.61 + sx*0.09, sy*0.7, tocolor(r, g, b, 150 * alpha), 0.9/myX*sx, font:getFont("condensed", 12/myX*sx), "center", "center")
            end
        else
            dxDrawText(paymentMethodes[selectedMethode], sx*0.4, sy*0.65, sx*0.6, sy*0.7, tocolor(255, 255, 255, 255 * alpha), 0.9/myX*sx, font:getFont("condensed", 15/myX*sx), "center", "center", false, false, false, true)
        end
    end

    if renderButtons then 
        --dxDrawRectangle(sx*0.45 - sx*0.05*buttonValues[1], sy*0.79, (sx*0.1*buttonValues[1]), sy*0.05)
        dxDrawText("Új vásárló", sx*0.45, sy*0.8, sx*0.45+sx*0.1, sy*0.8+sy*0.05, tocolor(255, 255, 255, 50*alpha), 1, font:getFont("condensed", 17/myX*sx), "center", "center")
            dxDrawText("Új vásárló", sx*0.5 - sx*0.05*buttonValues[1], sy*0.8, (sx*0.5 - sx*0.05*buttonValues[1])  + (sx*0.1*buttonValues[1]), sy*0.8+sy*0.05, tocolor(131, 217, 91, 255*alpha), 1, font:getFont("condensed", 17/myX*sx), "center", "center", true)
            if core:isInSlot(sx*0.45, sy*0.79, sx*0.1, sy*0.05) and getKeyState("mouse1") then 
                if buttonValues[1] < 1 then 
                    buttonValues[1] = buttonValues[1] + 0.01
                else 
                    renderButtons = false
                    buttonValues = {0, 0}
                    startPedMovement(1)
                    selectedMethode = 0
                end
            else
                if buttonValues[1] > 0 then 
                    buttonValues[1] = buttonValues[1] - 0.01
                end
            end

            --217, 91, 91
        dxDrawText("Kilépés", sx*0.45, sy*0.86, sx*0.45+sx*0.1, sy*0.86+sy*0.05, tocolor(255, 255, 255, 50*alpha), 1, font:getFont("condensed", 17/myX*sx), "center", "center")
            dxDrawText("Kilépés", sx*0.5 - sx*0.05*buttonValues[2], sy*0.86, (sx*0.5 - sx*0.05*buttonValues[2])  + (sx*0.1*buttonValues[2]), sy*0.86+sy*0.05, tocolor(217, 91, 91, 255*alpha), 1, font:getFont("condensed", 17/myX*sx), "center", "center", true)
            if core:isInSlot(sx*0.45, sy*0.86, sx*0.1, sy*0.05) and getKeyState("mouse1") then 
                if buttonValues[2] < 1 then 
                    buttonValues[2] = buttonValues[2] + 0.01
                else
                    renderButtons = false 
                    buttonValues = {0, 0}
                    closePanel()
                end
            else
                if buttonValues[2] > 0 then 
                    buttonValues[2] = buttonValues[2] - 0.01
                end
            end
    else
        for k, v in ipairs(conveyorBelt) do 
            if v[2][1] == "open" then 
                v[2][2] = interpolateBetween(v[2][2], 0, 0, 1, 0, 0, (getTickCount() - v[2][3])/300, "Linear")
            else
                v[2][2] = interpolateBetween(v[2][2], 0, 0, 0, 0, 0, (getTickCount() - v[2][3])/300, "Linear")
            end
    
            if v[3][1] then 
                v[1][1] = interpolateBetween(v[1][1], 0, 0, v[1][1] + 5/myX*sx, 0, 0, (getTickCount() - v[3][2])/itemMoveTime, "Linear")
            end
    
            if v[4] then 
                if v[1][1] > sx then 
                    v[4] = false 
                    v[2][1] = "close"
                    v[2][3] = getTickCount()
                    table.insert(conveyorBelt, {{0 - 141/myX*sx, sy*0.715, 141/myX*sx, 250/myY*sy}, {"open", 0, getTickCount()}, {true, getTickCount()}, true})
                end
            end
    
            dxDrawRectangle(v[1][1], v[1][2], v[1][3], v[1][4], tocolor(30, 30, 30, 255*v[2][2]*alpha))
            dxDrawImage(v[1][1], v[1][2], v[1][3], v[1][4], "files/conveyorbelt.png", 0, 0, 0, tocolor(255, 255, 255, 255*v[2][2]*alpha))
        end

        for k, v in ipairs(shopedItems) do 
            if v[3] == "show" then 
                v[4] = interpolateBetween(v[4], 0, 0, 1, 0, 0, (getTickCount()-v[2])/300, "Linear")
            else
                v[4] = interpolateBetween(v[4], 0, 0, 0, 0, 0, (getTickCount()-v[2])/300, "Linear")
            end
            
            dxDrawImage(lastItemPosition + ((k-1)*250/myX*sx), sy*0.715, 250/myX*sx, 250/myY*sy, "files/items/"..v[1]..".png", 0, 0, 0, tocolor(255, 255, 255, 255*v[4]))
            --dxDrawRectangle(lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1], sy*0.715 + buyableItems[v[1]][2], sx*0.03, sy*0.03, tocolor(255, 150, 30))
            dxDrawImage(lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1], sy*0.715 + buyableItems[v[1]][2], sx*0.04, sy*0.03,"files/barcodes/"..v[5]..".png", 0, 0, 0, tocolor(255, 255, 255, 255*v[4]))
            dxDrawText(v[5], lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1], sy*0.715 + buyableItems[v[1]][2], lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1] + sx*0.03, sy*0.715 + buyableItems[v[1]][2] + sy*0.03, tocolor(0, 0, 0, 255*v[4]), 0.7/myX*sx, fonts["barcode-15"], "center", "center")

            --dxDrawText(lastItemPosition + ((k-1)*250/myX*sx), lastItemPosition + ((k-1)*250/myX*sx), sy*0.715, lastItemPosition + ((k-1)*250/myX*sx)+250/myX/sx, sy*0.715+250/myY*sy, _, _, "default-bold", "center", "center")
        end

        lastItemPosition = interpolateBetween(oldLastItemPosition, 0, 0, newLastItemPosition, 0, 0, (getTickCount() - lastItemMoveTick)/itemMoveTime, "Linear")
    end

    dxDrawImage(sx*0.84, sy*0.43, 250/myX*sx, 250/myY*sy, "files/cash_machine.png", 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
    dxDrawText("$ "..buyedItemPrice, sx*0.873, sy*0.44, sx*0.873+sx*0.09, sy*0.44+sy*0.045, tocolor(84, 212, 49, 255*alpha), 0.9/myX*sx, fonts["lcd-15"], "center", "center")

    if not renderButtons then 
        if isCursorShowing() then 
            local cx, cy = getCursorPosition()
            cx, cy = cx*sx, cy*sy 

            dxDrawLine(cx-sx*0.025, cy, cx+sx*0.025, cy, tocolor(212, 49, 49, 255*alpha), 5)
        end
    end
end

function keyJobPanel(key, state)
    if key == "mouse1" and state then 
        for k, v in ipairs(shopedItems) do 
            if core:isInSlot(grid[5][1], grid[5][2], grid[5][3], grid[5][4]) then 
                if core:isInSlot(lastItemPosition + ((k-1)*250/myX*sx) + buyableItems[v[1]][1], sy*0.715 + buyableItems[v[1]][2], sx*0.03, sy*0.03) then 
                    if v[6] then 
                        if exports.oJob:isJobHasDoublePaymant(2) then 
                            buyedItemPrice = buyedItemPrice + buyableItems[v[1]][3]*2
                        else
                            buyedItemPrice = buyedItemPrice + buyableItems[v[1]][3]
                        end
                        playSound("files/scanner.wav")
                        v[6] = false 
                        v[2] = getTickCount()
                        v[3] = "dissappear"
                        setTimer(function()
                            table.remove(shopedItems, #shopedItems)

                            if #shopedItems == 0 then 
                                selectedMethode = math.random(#paymentMethodes)

                                if selectedMethode == 3 then 
                                    givedMoney = math.ceil(buyedItemPrice/10) * 10
                                else
                                    triggerServerEvent("giveMoney", resourceRoot, buyedItemPrice)
                                    
                                    startPedMovement(2)
                                end
                            else
                                moveConveyorBelt(1)
                            end
                        end, 300, 1)
                    end                    
                end
            end
        end

        if selectedMethode > 0 then    
            if selectedMethode == 3 then 
                local panelW = #dollars * sx*0.106
                local startX = sx*0.5 - panelW / 2    
                local startY = sy*0.55
    
                startX = startX + sx*0.005
                for k, v in ipairs(dollars) do 
                    if core:isInSlot(startX, startY, sx*0.1, sy*0.08) then 
                        returnMoney = returnMoney + v
                    end
    
                    startX = startX + sx*0.105
                end

                if core:isInSlot(sx*0.3, sy*0.65, sx*0.09, sy*0.05) then 
                    returnMoney = 0
                end
                
                if core:isInSlot(sx*0.61, sy*0.65, sx*0.09, sy*0.05) then 
                    local difference = givedMoney - buyedItemPrice

                    if difference == returnMoney then 
                        selectedMethode = 0
                        triggerServerEvent("giveMoney", resourceRoot, buyedItemPrice)

                        startPedMovement(2)
                    else
                        if not isElement(errorSound) then 
                            errorSound = playSound("files/error.mp3")
                        end
                    end
                end
            end
        end
    end
end

function moveConveyorBelt(count)
    for i = 1, count do 
        setTimer(function() 
            posIndex = posIndex + 1
            lastItemMoveTick = getTickCount()
            oldLastItemPosition = lastItemPosition 
            newLastItemPosition = lastItemPosition + 250/myX*sx

            for k, v in ipairs(conveyorBelt) do 
                v[3][1] = true 
                v[3][2] = getTickCount()
            end

        end, math.max(itemMoveTime*(i-1), 100), 1) 
    end

    setTimer(function()
        for k, v in ipairs(conveyorBelt) do 
            v[3][1] = false
        end
    end, math.max(itemMoveTime*count, 100), 1)
end

function startItemMove()
    local difference = 5 - #shopedItems

    if difference > 0 then 
        moveConveyorBelt(difference)
    end
end

function generateRandomItems()
    buyedItemPrice = 0
    shopedItems = {}
    posIndex = 0
    oldLastItemPosition, newLastItemPosition, lastItemPosition =  sx*0.005, sx*0.005, sx*0.005

    for i = 1, math.random(1, 5) do 
        table.insert(shopedItems, {math.random(#buyableItems), getTickCount(), "show", 0, math.random(1, 6), true})
    end

    startItemMove()
end

local pedStopCol, pedDelCol = false, false
local erintes = false
function startPedMovement(state)
    if state == 1 then 
        movePed = createPed(skins[math.random(#skins)], -33.079513549805, -137.84886169434, 1003.546875, 270)
        setElementInterior(movePed, 16)
        setElementDimension(movePed, 9000 + getElementData(localPlayer, "playerid"))
        setPedAnimation(movePed, "ped", "walk_civi")
        setElementData(movePed, "ped:name", "Vásárló")

        selectedMethode, givedMoney, returnMoney = 0, 0, 0

        erintes = false
    elseif state == 2 then 
        setPedAnimation(movePed, "dealer", "shop_pay", _, false)

        setTimer(function()
            setElementRotation(movePed, 0, 0, 270)
            setPedAnimation(movePed, "ped", "walk_civi")
        end, 5000, 1)
    end
end

addEventHandler("onClientColShapeHit", resourceRoot, function(element, mdim)
    if not mdim then return end
    if element == movePed then 
        if source == pedStopCol then
            if erintes then return end 
            generateRandomItems()
            setElementRotation(movePed, 0, 0, 180)
            setPedAnimation(movePed)
            erintes = true
        elseif source == pedDelCol then 
            destroyElement(movePed)
            renderButtons = true

            generateConveyors()
        end
    end
end)

function openPanel()
    animType = "open"
    animTick = getTickCount()
    addEventHandler("onClientRender", root, renderJobPanel)
    addEventHandler("onClientKey", root, keyJobPanel)
    startPedMovement(1)
    setElementAlpha(localPlayer, 0)
    setElementFrozen(localPlayer, true)

    local x1,y1,z1,x1t,y1t,z1t = getCameraMatrix()
    smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t, -21.911600112915,-140.68899536133,1004.2025756836,-21.932523727417,-139.70083618164,1004.0505981445, 1000)
    showChat(false)
    exports.oInterface:toggleHud(true)
end

function closePanel()
    animType = "close"
    animTick = getTickCount()
    removeEventHandler("onClientKey", root, keyJobPanel)

    setTimer(function()
        removeEventHandler("onClientRender", root, renderJobPanel)

        setElementAlpha(localPlayer, 255)
        setElementFrozen(localPlayer, false)

        --[[jobStartMarker = exports.oCustomMarker:createCustomMarker(-22.244277954102, -140.57881164551, 1003.546875, 2.5, 66, 149, 245, 200, "cashmachine", "circle")
        setElementInterior(jobStartMarker, 16)
        setElementDimension(jobStartMarker, 9000 + getElementData(localPlayer, "playerid"))]]
    end, 300, 1)

    

    setCameraTarget(localPlayer, localPlayer)
    showChat(true)
    exports.oInterface:toggleHud(false)
end

local createdJobElements = {}

function interactionRender()
    core:dxDrawShadowedText("Az interakcióhoz nyomd meg az "..color.."[E] #ffffffgombot.", 0, sy*0.89, sx, sy*0.89+sy*0.05, tocolor(255, 255, 255, 255), tocolor(0, 0, 0, 255), 1, font:getFont("condensed", 12/myX*sx), "center", "center", false, false, false, true)
end

local startPos = {}
local inInterior = false
local outMarker = false 
local jobStartMarker = false 

function warpToShop()
    inInterior = true
    startPos = {getElementPosition(localPlayer)}

    setElementPosition(localPlayer, -26.048749923706, -141.0009765625, 1003.546875)
    setElementInterior(localPlayer, 16)
    setElementDimension(localPlayer, 9000 + getElementData(localPlayer, "playerid"))
    
    outMarker = exports.oCustomMarker:createCustomMarker(-26.048749923706, -141.0009765625, 1003.546875, 2.5, 129, 201, 71, 200, "cashmachine", "circle")
    setElementInterior(outMarker, 16)
    setElementDimension(outMarker, 9000 + getElementData(localPlayer, "playerid"))

    jobStartMarker = exports.oCustomMarker:createCustomMarker(-22.244277954102, -140.57881164551, 1003.546875, 2.5, 66, 149, 245, 200, "cashmachine", "circle")
    setElementInterior(jobStartMarker, 16)
    setElementDimension(jobStartMarker, 9000 + getElementData(localPlayer, "playerid"))

    pedStopCol = createColTube(-21.196887969971, -138.61964416504, 1002.5468755, 1.3, 3)
    setElementInterior(pedStopCol, 16)
    setElementDimension(pedStopCol, 9000 + getElementData(localPlayer, "playerid"))

    pedDelCol = createColTube(-14.912612915039, -138.51348876953, 1002.546875, 1, 3)
    setElementInterior(pedDelCol, 16)
    setElementDimension(pedDelCol, 9000 + getElementData(localPlayer, "playerid"))

    setElementData(localPlayer, "playerInClientsideJobInterior", startPos)

    exports.oLoading:showLoadingScreen({"Interior betöltése", "Textúrák létrehozása"})

    for k,v in pairs(textureName) do 
        imageTextures["files/"..v ..".png"] = dxCreateTexture("files/"..v..".png", "dxt3")
   end
end

function warpOutFromInterior()
    setElementPosition(localPlayer, unpack(startPos))
    setElementDimension(localPlayer, 0)
    setElementInterior(localPlayer, 0)

    inInterior = false

    destroyElement(outMarker)
    destroyElement(jobStartMarker)
    destroyElement(pedStopCol)
    destroyElement(pedDelCol)
    setCameraTarget(localPlayer, localPlayer)

    setElementData(localPlayer, "playerInClientsideJobInterior", false)

    for k, v in pairs(imageTextures) do 
        destroyElement(v)
    end
    imageTextures = {}
end

addEventHandler("onClientMarkerHit", root, function(player, mdim)
    if (player == localPlayer and mdim) then 
        if not isElement(source) then return end
        
        if getElementData(source, "isCashierJobMarker") then 
            addEventHandler("onClientRender", root, interactionRender)
            bindKey("e", "up", warpToShop)
        elseif source == outMarker then 
            addEventHandler("onClientRender", root, interactionRender)
            bindKey("e", "up", warpOutFromInterior)
        elseif source == jobStartMarker then 
            openPanel()
        end
    end
end)

addEventHandler("onClientMarkerLeave", root, function(player, mdim)
    if (player == localPlayer and mdim) then 
        if getElementData(source, "isCashierJobMarker") then 
            removeEventHandler("onClientRender", root, interactionRender)
            unbindKey("e", "up", warpToShop)
        elseif source == outMarker then 
            removeEventHandler("onClientRender", root, interactionRender)
            unbindKey("e", "up", warpOutFromInterior)
        end
    end
end)

function createJobElements()
    for k, v in ipairs(markerPositions) do 
        local marker = exports.oCustomMarker:createCustomMarker(v[1], v[2], v[3], 2.5, 129, 201, 71, 200, "cashmachine", "circle")
        setElementData(marker, "isCashierJobMarker", true)
        table.insert(createdJobElements, marker)

        local blip = createBlipAttachedTo(marker, 11)
        setElementData(blip, "blip:name", "Pénztáros munkahely")
        table.insert(createdJobElements, blip)
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "char:job") == 2 then 
        createJobElements()
        outputJobTips()
    end
end)

addEventHandler("onClientElementDataChange", root, function(data, old, new)
    if source == localPlayer then 
        if data == "char:job" then 
            if old == 2 then 
                for k, v in ipairs(createdJobElements) do 
                    destroyElement(v)
                end
            elseif new == 2 then 
                createJobElements()
                outputJobTips()
            end
        end
    end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    for k, v in ipairs(createdJobElements) do 
        destroyElement(v)
    end

    if inInterior then 
        warpOutFromInterior()
        setElementFrozen(localPlayer, false)
        setElementAlpha(localPlayer, 255)
    end
end)

-----SmoothCamera
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then
		destroyElement(sm.object1)
		destroyElement(sm.object2)
		killTimer(timer1)
		killTimer(timer2)
		killTimer(timer3)
		removeEventHandler("onClientPreRender",root,camRender)
	end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	timer1 = setTimer(removeCamHandler,time,1)
	timer2 = setTimer(destroyElement,time,1,sm.object1)
	timer3 = setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end