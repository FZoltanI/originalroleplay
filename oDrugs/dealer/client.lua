local sellItemDatas = {}
local usedPed = false
local inSell = false

local startCamera = {}

function sellDrugItem(ped, itemID, itemCount)
    local pedName = getElementData(ped, "ped:name")
        print(itemID)
        if drugPrices[itemID] then 
            if not inSell then
                if getElementData(ped, "drugBuyer:buyedItems") < 30 then 
                    inSell = true

                    usedPed = ped

                    openTalkingAnimation()
                    sellItemDatas = {itemID, itemCount}

                    startCamera = {getCameraMatrix()}
                    return true
                else
                    outputChatBox(pedName.." mondja: Ha ennyit szívnék, akkor már rég megdöglöttem volna. Ennyi cucc nem kell még a rendőröknek sem.", 255, 255, 255, true)
                    return false
                end
            else
                return false
            end
        else
            outputChatBox(pedName.." mondja: Jól vagy? Mégis miért vennék tőled ilyet? Takarodj innen az értéktelen cuccaiddal együtt...", 255, 255, 255, true)
            return false
        end

end

 sx, sy = guiGetScreenSize()
 myX, myY = 1768, 992

local openAnimation = {0, "open", getTickCount()}
local textAnimation = {0, "open", getTickCount()}

local panelText = 1
local minigameShowing = false
local minigameStarted = false
local panelTexts = {
    "Csá tesó. Mit hoztál ma nekem? Oh egy kis {#itemName}...",
    "Ezért most neked nagyjából {#price}$-t tudok adni...",
    "",
    "Na akkor ezért a cuccért {#price}$-t tudok most neked adni.",
    "Kössz a cuccot. Pá",
}

local priceMultiplier = 0

local timeMultiplier = 12500

local barPositions = {0.1, 0.4, 0.5, 0.7, 1}
local cursorPos, cursorStart = 0, getTickCount()
local barColors = {
    tocolor(227, 62, 50, 255),
    tocolor(227, 150, 50, 255),
    tocolor(50, 227, 121, 255),
    tocolor(227, 150, 50, 255),
    tocolor(227, 62, 50, 255),
}

local spaceState = false
local lastText = false

local generatedPrice = 0

function drawTalkingAnimation()
    showCursor(true)

    if openAnimation[2] == "open" then 
        openAnimation[1] = interpolateBetween(openAnimation[1], 0, 0, 1, 0, 0, (getTickCount() - openAnimation[3])/2000, "Linear")
    else
        openAnimation[1] = interpolateBetween(openAnimation[1], 0, 0, 0, 0, 0, (getTickCount() - openAnimation[3])/2000, "Linear")
    end 

    if not lastText then
        if textAnimation[2] == "open" then 
            textAnimation[1] = interpolateBetween(textAnimation[1], 0, 0, 1, 0, 0, (getTickCount() - textAnimation[3])/(string.len(panelTexts[panelText]) * timeMultiplier), "Linear")
        else
            textAnimation[1] = interpolateBetween(textAnimation[1], 0, 0, 0, 0, 0, (getTickCount() - textAnimation[3])/(string.len(panelTexts[panelText]) * timeMultiplier), "Linear")
        end 
    end

    dxDrawRectangle(0, 0, sx, (sy*0.15 * openAnimation[1] ), tocolor(0, 0, 0))
    dxDrawRectangle(0, sy - (sy*0.15 * openAnimation[1] ), sx, sy*0.15, tocolor(0, 0, 0))

    if textAnimation[1] > 0.95 then 
        if not minigameShowing then
            textAnimation[1] = 0
            textAnimation[2] = "open"
            textAnimation[3] = getTickCount()
            panelText = panelText + 1
                
            if panelText == 3 then 
                minigameShowing = true 
            elseif panelText > #panelTexts then 
                lastText = true
                
                closePanel()
            else
                minigameShowing = false
            end
        end
    end

    generatedPrice = drugPrices[sellItemDatas[1]] * sellItemDatas[2]

    if priceMultiplier > 0 then 
        generatedPrice = math.floor(priceMultiplier * generatedPrice)
    end

    if not lastText then
        if minigameShowing then 
            dxDrawText("Ha nem vagy megelégedve a kínált árral akkor a lenti minigame segítségével finomíthatsz az áron!", 0, sy - sy*0.15, sx, sy - sy*0.1, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 12/myX*sx), "center", "center")
            dxDrawText("Akkor engedd fel a "..color.."[Space] #ffffffgombot, amikor a fehér vonal a zöld mezőbe ér!", 0, sy - sy*0.05, sx, sy, tocolor(255, 255, 255, 100), 1, font:getFont("condensed", 12/myX*sx), "center", "center", false, false, false, true)

            if not minigameStarted then
                dxDrawText("A minigame kezdéséhez tartsd lenyomva a [Space] gombot.", 0, sy - sy*0.15, sx, sy, tocolor(r, g, b, 255 * openAnimation[1]), 1, font:getFont("bebasneue", 18/myX*sx), "center", "center")
            else
                if spaceState then
                    cursorPos = interpolateBetween(cursorPos, 0, 0, 1, 0, 0, (getTickCount() - cursorStart) / 5000, "InOutQuad")
                end
            
                dxDrawRectangle(sx*0.4, sy*0.91, sx*0.2, sy*0.03, tocolor(30, 30, 30, 100))
            
                for i = 1, 5 do 
                    if i == 1 then 
                        dxDrawRectangle(sx*0.4, sy*0.91, sx*0.2 * (barPositions[i]), sy*0.03, barColors[i])
                    else
                        dxDrawRectangle(sx*0.4 + (sx*0.2 * barPositions[i-1]), sy*0.91, (barPositions[i] - barPositions[i-1]) * sx*0.2, sy*0.03, barColors[i])
                    end
                end
            
                dxDrawRectangle(sx*0.4 + sx*0.2 * cursorPos, sy*0.9, sx*0.003, sy*0.05, tocolor(255, 255, 255, 255))
            end

        else
            dxDrawText(panelTexts[panelText]:gsub("{#itemName}", inventory:getItemName(sellItemDatas[1])):gsub("{#price}", generatedPrice), sx*0.05, sy - sy*0.15, sx * textAnimation[1], sy, tocolor(255, 255, 255, 255 * openAnimation[1]), 1, font:getFont("condensed", 15/myX*sx), "left", "center", true)
        end
    end
end

function renderminigame()
    
end

function generateBarPoitions()
    for i = 1, 4 do 
        if i == 1 then 
            barPositions[i] = math.random(10, 40) / 100
        else
            barPositions[i] = math.random(barPositions[i - 1] * 100, (barPositions[i - 1] * 100) + 5) / 100
            barPositions[i] =  barPositions[i] + 0.05
            print(barPositions[i - 1])
        end
    end
end
--addCommandHandler("asd", generateBarPoitions)
--addEventHandler("onClientRender", root, renderminigame)

local colorNames = {"piros", "sárga", "zöld", "sárga", "piros"}
local colorMultipliers = {0.85, 1, 1.1, 1, 0.85}

function onKey(key, state)
    if panelText == 3 then 
        if key == "space" then 
            if state then 
                cursorPos = 0
                cursorStart = getTickCount()
                minigameStarted = true
                spaceState = true
            else
                spaceState = false
                minigameShowing = false
                textAnimation[1] = 0
                textAnimation[2] = "open"
                textAnimation[3] = getTickCount()

                for i = 1, 5 do 
                    if cursorPos > 0.95 then 
                        priceMultiplier = colorMultipliers[5]
                    elseif cursorPos < barPositions[i] then 
                        priceMultiplier = colorMultipliers[i]
                        break
                    end
                end

                panelText = panelText + 1
            end
        end
    end
end

local bgSound
function openTalkingAnimation()
    showChat(false)
    exports.oInterface:toggleHud(true)

    setPedAnimation(usedPed, "ghands", "gsign5")

    setElementFrozen(localPlayer, true)
    lastText = false 

    panelText = 1 
    cursorPos = 0
    priceMultiplier = 0

    openAnimation[2] = "open"
    openAnimation[3] = getTickCount()

    textAnimation[2] = "open"
    textAnimation[3] = getTickCount()

    addEventHandler("onClientRender", root, drawTalkingAnimation)
    addEventHandler("onClientKey", root, onKey)

    bgSound = playSound("files/music.mp3", true)

    local camNow = {getCameraMatrix()}
    local pedPos = {getElementPosition(usedPed)}
    local playerPos = {getElementPosition(localPlayer)}

    local pedRot = getPedRotation(usedPed)

    local addX, addY = -4, 0

    if pedRot > 0 and pedRot <= 90 then 
        addX = 0
        addY = -4
    elseif pedRot > 90 and pedRot <= 180 then 
        addX = -4
        addY = 0
    elseif pedRot > 180 and pedRot <= 270 then 
        addX = 0
        addY = 4
    elseif pedRot > 270 and pedRot <= 360 then 
        addX = 4
        addY = 0
    end

    smoothMoveCamera(camNow[1], camNow[2], camNow[3], camNow[4], camNow[5], camNow[6], pedPos[1] + addX, pedPos[2] + addY, pedPos[3] + 0.7, pedPos[1], pedPos[2], pedPos[3] + 0.7, 2000)
end 

function closePanel()
    openAnimation[2] = "close"
    openAnimation[3] = getTickCount()

    local camNow = {getCameraMatrix()}
    smoothMoveCamera(camNow[1], camNow[2], camNow[3], camNow[4], camNow[5], camNow[6], startCamera[1], startCamera[2], startCamera[3], startCamera[4], startCamera[5], startCamera[6], 2000)
    setPedAnimation(usedPed)

    setTimer(function()

        if isElement(bgSound) then 
            destroyElement(bgSound) 
        end

        setElementFrozen(localPlayer, false)
        showCursor(false)

        outputChatBox(core:getServerPrefix("server", "Dealer", 2).."Sikeresen eladtál a dealernek "..color..sellItemDatas[2].."#ffffffdb "..color..inventory:getItemName(sellItemDatas[1]).."#ffffff-et #7de05e"..generatedPrice.."$#ffffff-ért.", 255, 255, 255, true)
        setElementData(localPlayer, "char:money", getElementData(localPlayer, "char:money") + generatedPrice)
        generatedPrice = 0
        panelText = 1

        setElementData(usedPed, "drugBuyer:buyedItems", getElementData(usedPed, "drugBuyer:buyedItems") + sellItemDatas[2])

        removeEventHandler("onClientRender", root, drawTalkingAnimation)
        removeEventHandler("onClientKey", root, onKey)
        
        setCameraTarget(localPlayer, localPlayer)
        
        inSell = false
        showChat(true)
        exports.oInterface:toggleHud(false)
    end, 2000, 1)

    showCursor(false)
end

-- Cam move
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
	if(sm.moov == 1)then return false end
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
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end