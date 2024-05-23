local cardsCache = {}

local cards = {
    ["player"] = {},
    ["dealer"] = {},
}

local inPlay = false

local bet = 0
local betPanelActive = false
local lastCardAlphaTick = getTickCount()
local lastCardAlphaTickDealer = getTickCount()

local panelOpen = false

local activeTable = false

function renderBlackJack()
    
    --[[if getPlayerPing(localPlayer) > 75 then 
        panelOpen = false
        triggerServerEvent("casino > blackjack > detachPlayer", resourceRoot, activeTable)

        inPlay = false
        removeEventHandler("onClientRender", root, renderBlackJack)
        removeEventHandler("onClientKey", root, keyBlackJack)
        removeEventHandler("onClientRender", root, renderTooltip)
        exports.oInterface:toggleHud(false)
        activeTable = false
    end]]

    if not core:getNetworkConnection() then 
        panelOpen = false
        triggerServerEvent("casino > blackjack > detachPlayer", resourceRoot, activeTable)


        inPlay = false
        removeEventHandler("onClientRender", root, renderBlackJack)
        removeEventHandler("onClientKey", root, keyBlackJack)
        removeEventHandler("onClientRender", root, renderTooltip)
        exports.oInterface:toggleHud(false)
        activeTable = false
    end

    if inPlay then 
        dxDrawRectangle(sx*0.8215, sy*0.94, sx*0.173, sy*0.05, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.8215+3/myX*sx, sy*0.94+3/myY*sy, sx*0.173-6/myX*sx, sy*0.05-6/myY*sy, tocolor(40, 40, 40, 255))

        --[[dxDrawRectangle(sx*0.75+6/myX*sx, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy, tocolor(35, 35, 35, 255))
        if core:isInSlot(sx*0.75+6/myX*sx, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy) then 
            dxDrawText("Hit", sx*0.75+6/myX*sx, sy*0.94+6/myY*sy, sx*0.75+6/myX*sx+sx*0.07, sy*0.94+6/myY*sy+sy*0.05-12/myY*sy, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "center", "center")
        else
            dxDrawText("Hit", sx*0.75+6/myX*sx, sy*0.94+6/myY*sy, sx*0.75+6/myX*sx+sx*0.07, sy*0.94+6/myY*sy+sy*0.05-12/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center")
        end]]
        
        dxDrawRectangle(sx*0.75+9/myX*sx+sx*0.07, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy, tocolor(35, 35, 35, 255))
        if core:isInSlot(sx*0.75+9/myX*sx+sx*0.07, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy) then 
            dxDrawText("Stand", sx*0.75+9/myX*sx+sx*0.07, sy*0.94+6/myY*sy, sx*0.75+9/myX*sx+sx*0.14, sy*0.94+6/myY*sy+sy*0.05-12/myY*sy, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "center", "center")
        else
            dxDrawText("Stand", sx*0.75+9/myX*sx+sx*0.07, sy*0.94+6/myY*sy, sx*0.75+9/myX*sx+sx*0.14, sy*0.94+6/myY*sy+sy*0.05-12/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center")
        end

        dxDrawRectangle(sx*0.75+12/myX*sx+sx*0.14, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy, tocolor(35, 35, 35, 255))
        if core:isInSlot(sx*0.75+12/myX*sx+sx*0.14, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy) then 
            dxDrawText("Hit", sx*0.75+12/myX*sx+sx*0.14, sy*0.94+6/myY*sy, sx*0.75+12/myX*sx+sx*0.14+sx*0.07, sy*0.94+6/myY*sy+sy*0.05-12/myY*sy, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "center", "center")
        else
            dxDrawText("Hit", sx*0.75+12/myX*sx+sx*0.14, sy*0.94+6/myY*sy, sx*0.75+12/myX*sx+sx*0.14+sx*0.07, sy*0.94+6/myY*sy+sy*0.05-12/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center")
        end

        dxDrawImage(sx*0.9695, sy*0.94+5/myY*sy, 40/myX*sx, 40/myY*sy, "files/logo.png", 0, 0, 0, tocolor(r, g, b, 255))

        local hosszabb = "player"

        if #cards["player"] >= #cards["dealer"] then 
            hosszabb = "player"
        else
            hosszabb = "dealer"
        end

        dxDrawRectangle(sx*0.995 - ((cardW/myX*sx + 5/myX*sx)*#cards[hosszabb]) - 10/myX*sx - sx*0.02, sy*0.66, ((cardW/myX*sx + 5/myX*sx)*#cards[hosszabb]) + 10/myX*sx + sx*0.02, sy*0.275, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.995 - ((cardW/myX*sx + 5/myX*sx)*#cards[hosszabb]) - 10/myX*sx + 3/myX*sx - sx*0.02, sy*0.66+3/myY*sy, ((cardW/myX*sx + 5/myX*sx)*#cards[hosszabb]) + 10/myX*sx - 6/myX*sx +sx*0.02, sy*0.275-6/myY*sy, tocolor(40, 40, 40, 255))
        dxDrawText("Osztó lapjai "..color.."(".. countCardValues("dealer")..")", sx*0.995 - ((cardW/myX*sx + 5/myX*sx)*#cards[hosszabb]) - 10/myX*sx - sx*0.02, sy*0.66, sx*0.995 - ((cardW/myX*sx + 5/myX*sx)*#cards[hosszabb]) - 10/myX*sx - sx*0.02+sx*0.025, sy*0.66+sy*0.14, tocolor(255, 255, 255, 100), 0.85/myX*sx, fonts["bebasneue-15"], "center", "center", false, false, false, true, false, 270)
        dxDrawText("Saját lapjaid " ..color.."(".. countCardValues("player")..")", sx*0.995 - ((cardW/myX*sx + 5/myX*sx)*#cards[hosszabb]) - 10/myX*sx - sx*0.02, sy*0.795, sx*0.995 - ((cardW/myX*sx + 5/myX*sx)*#cards[hosszabb]) - 10/myX*sx - sx*0.02+sx*0.025, sy*0.795+ sy*0.14, tocolor(255, 255, 255, 100), 0.85/myX*sx, fonts["bebasneue-15"], "center", "center", false, false, false, true, false, 270)

        local startx = sx*0.94
        for k, v in ipairs(cards["player"]) do 
            if k == #cards["player"] then 
                dxDrawImage(startx, sy*0.8, cardW/myX*sx, cardH/myY*sy, "files/cards/"..v[1].."_"..v[2]..".png", 0, 0, 0, tocolor(255, 255, 255, 255*interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - lastCardAlphaTick)/300, "Linear")))
            else
                dxDrawImage(startx, sy*0.8, cardW/myX*sx, cardH/myY*sy, "files/cards/"..v[1].."_"..v[2]..".png")
            end

            startx = startx - (cardW/myX*sx + 5/myX*sx)
        end

        local startx = sx*0.94
        for k, v in ipairs(cards["dealer"]) do 
            if k == #cards["dealer"] then 
                dxDrawImage(startx, sy*0.8-(cardH+5)/myY*sy, cardW/myX*sx, cardH/myY*sy, "files/cards/"..v[1].."_"..v[2]..".png", 0, 0, 0, tocolor(255, 255, 255, 255*interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - lastCardAlphaTickDealer)/300, "Linear")))
            else
                dxDrawImage(startx, sy*0.8-(cardH+5)/myY*sy, cardW/myX*sx, cardH/myY*sy, "files/cards/"..v[1].."_"..v[2]..".png")
            end

            startx = startx - (cardW/myX*sx + 5/myX*sx)
        end
    else
        dxDrawRectangle(sx*0.9, sy*0.845, sx*0.095, sy*0.137, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.9+3/myX*sx, sy*0.845+3/myY*sy, sx*0.095-6/myY*sy, sy*0.07, tocolor(40, 40, 40, 255))
        dxDrawText(bet.."#ffffffcc", sx*0.9+3/myX*sx, sy*0.845+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.845+3/myY*sy+sy*0.07, tocolor(r, g, b, 255), 0.8/myX*sx, fonts["condensed-25"], "center", "center", false, false, false, true)

        dxDrawRectangle(sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025, tocolor(40, 40, 40, 255))
            if core:isInSlot(sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then 
                dxDrawText("Tét nullázása", sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.92+3/myY*sy+sy*0.025, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
            else
                dxDrawText("Tét nullázása", sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.92+3/myY*sy+sy*0.025, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
            end
        dxDrawRectangle(sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025, tocolor(40, 40, 40, 255))
            if core:isInSlot(sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then  
                dxDrawText("All in", sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.95+3/myY*sy+sy*0.025, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
            else
                dxDrawText("All in", sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myY*sy, sy*0.95+3/myY*sy+sy*0.025, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
            end

        dxDrawRectangle(sx*0.9, sy*0.8, sx*0.095, sy*0.04, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.9+3/myX*sx, sy*0.8+3/myY*sy, sx*0.095-6/myX*sx, sy*0.04-6/myY*sy, tocolor(40, 40, 40, 255))
        dxDrawText(color..(getElementData(localPlayer, "char:cc") or 0).."#ffffffcc", sx*0.9+3/myX*sx, sy*0.8+3/myY*sy, sx*0.9+3/myX*sx+sx*0.095-6/myX*sx, sy*0.8+3/myY*sy+sy*0.04-6/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-13"], "center", "center", false, false, false, true)
   
        dxDrawRectangle(sx*0.425, sy*0.85, sx*0.15, sy*0.06, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy, tocolor(40, 40, 40, 255))
        if core:isInSlot(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy) then 
            dxDrawText("Játék kezdése", sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.425+3/myX*sx+sx*0.15-6/myX*sx, sy*0.85+3/myY*sy+sy*0.03-6/myY*sy, tocolor(r, g, b, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
        else
            dxDrawText("Játék kezdése", sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.425+3/myX*sx+sx*0.15-6/myX*sx, sy*0.85+3/myY*sy+sy*0.03-6/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
        end

        dxDrawRectangle(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy+sy*0.03, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy, tocolor(40, 40, 40, 255))
        if core:isInSlot(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy+sy*0.03, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy) then 
            dxDrawText("Kilépés", sx*0.425+3/myX*sx, sy*0.85+3/myY*sy+sy*0.03, sx*0.425+3/myX*sx+sx*0.15-6/myX*sx, sy*0.85+3/myY*sy+sy*0.03+sy*0.03-6/myY*sy, tocolor(245, 66, 66, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
        else
            dxDrawText("Kilépés", sx*0.425+3/myX*sx, sy*0.85+3/myY*sy+sy*0.03, sx*0.425+3/myX*sx+sx*0.15-6/myX*sx, sy*0.85+3/myY*sy+sy*0.03+sy*0.03-6/myY*sy, tocolor(255, 255, 255, 255), 1/myX*sx, fonts["condensed-10"], "center", "center", false, false, false, true)
        end
    end
end

local lastClick = getTickCount()
local gameState = "player"
local isUseDouble = false
local originalbet = 0
function keyBlackJack(key, state)
    if state then 
        if not inPlay then 
            if key == "mouse1" then 
                if core:isInSlot(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.15-6/myX*sx, sy*0.04-6/myY*sy) then 
                    if tonumber(bet) >= 400 then 
                        if tonumber(bet) <= 2500 then 
                            if getElementData(localPlayer, "char:cc") >= tonumber(bet) then 
                                if core:getNetworkConnection() then 
                                    cards["player"] = {}
                                    cards["dealer"] = {}

                                    triggerServerEvent("casino > blackjack > setPlayerMoney", resourceRoot, tonumber(bet), "remove")
                                    isUseDouble = false
                                    betPanelActive = false 
                                    cardsCache =  {{"1", "01"},{"1", "02"},{"1", "03"},{"1", "04"},{"1", "05"},{"1", "06"},{"1", "07"},{"1", "08"},{"1", "09"},{"1", "10"},{"1", "11"}, {"1", "12"}, {"1", "13"}, {"2", "01"},{"2", "02"},{"2", "03"},  {"2", "04"},{"2", "05"},{"2", "06"},{"2", "07"}, {"2", "08"}, {"2", "09"}, {"2", "10"},{"2", "11"}, {"2", "12"}, {"2", "13"}, {"3", "01"}, {"3", "02"}, {"3", "03"}, {"3", "04"},{"3", "05"}, {"3", "06"}, {"3", "07"}, {"3", "08"},{"3", "09"},{"3", "10"},{"3", "11"},{"3", "12"},{"3", "13"}, {"4", "01"},{"4", "02"},{"4", "03"},{"4", "04"},{"4", "05"},{"4", "06"},{"4", "07"},{"4", "08"},{"4", "09"},{"4", "10"},{"4", "11"},{"4", "12"},{"4", "13"}}

                                    gameState = "player"

                                    lastCardAlphaTick = getTickCount()

                                    local randCard = math.random(#cardsCache)
                                    table.insert(cards["player"], #cards["player"]+1, cardsCache[randCard])
                                    table.remove(cardsCache, randCard)

                                    inPlay = true 
                                else
                                    infobox:outputInfoBox("Az internetkapcsolatod nem elég stabil a játék megkezdéséhez!", "warning")
                                end
                            else
                                infobox:outputInfoBox("Nincs elegendő CasinoCoinod! ("..bet.."cc)", "error")
                                outputChatBox(core:getServerPrefix("red-dark", "CasinoCoin", 2).."Nincs elegendő CasinoCoinod! "..color.."("..bet.."cc)", 255, 255, 255, true)
                            end
                        else
                            infobox:outputInfoBox("A maximum tét 2500CC!", "error")
                        end
                    else
                        infobox:outputInfoBox("A minimum tét 400CC!", "error")
                    end
                end

                if core:isInSlot(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy+sy*0.03, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy) then 
                    panelOpen = false
                    triggerServerEvent("casino > blackjack > detachPlayer", resourceRoot, activeTable)
                    activeTable = false


                    inPlay = false
                    removeEventHandler("onClientRender", root, renderBlackJack)
                    removeEventHandler("onClientKey", root, keyBlackJack)
                    removeEventHandler("onClientRender", root, renderTooltip)
                    exports.oInterface:toggleHud(false)

                end

                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.845+3/myY*sy, sx*0.095-6/myY*sy, sy*0.07) then 
                    betPanelActive = true
                else
                    betPanelActive = false 
                end

                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then 
                    bet = 0
                end

                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then  
                    bet = (getElementData(localPlayer, "char:cc") or 0)

                    if bet > 2500 then 
                        bet = 2500
                    end
                end
    
            end

            key = key:gsub("num_", "")

            if tonumber(key) then 
                if betPanelActive then
                    if string.len(tostring(bet)) < 9 then  
                        if bet == 0 then 
                            if not (tonumber(key) == 0) then 
                                bet = key
                            end
                        else 
                            bet = bet .. key 
                        end
                    end
                end
            end

            if key == "backspace" then 
                bet = tostring(bet):gsub("[^\128-\191][\128-\191]*$", "")

                if bet == "" then 
                    bet = 0 
                end
            end

        else
            if lastClick + 1000 < getTickCount() then 
                if core:isInSlot(sx*0.75+12/myX*sx+sx*0.14, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy) then 
                    if gameState == "player" then 
                        lastClick = getTickCount()

                        local randCard = math.random(#cardsCache)

                        lastCardAlphaTick = getTickCount()

                        table.insert(cards["player"], cardsCache[randCard])
                        table.remove(cardsCache, randCard)

                        setTimer(function() 
                            local cardValue = countCardValues("player")
                            
                            if cardValue > 21 then 
                                outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 3).."Elbuktál "..color..(tonumber(bet)).."#ffffffcc-t! A lapjaid összege meghaladta a "..color.."21#ffffff-et.", 255, 255, 255, true)
                                infobox:outputInfoBox("Elbuktad! A lapjaid értéke meghaladta 21-et.", "error")
                                inPlay = false 
                                isUseDouble = false

                                if originalbet > 0 then 
                                    bet = originalbet 
                                    originalbet = 0 
                                end
                            end

                            if cardValue == 21 then -- 
                                triggerServerEvent("casino > blackjack > setPlayerMoney", resourceRoot, tonumber(bet)*2, "add")
                                outputChatBox(core:getServerPrefix("green-dark", "Blackjack", 3).."Nyertél "..color..(tonumber(bet)*2).."#ffffffcc-t! A lapjaid értéke "..color.."21#ffffff.", 255, 255, 255, true)
                                infobox:outputInfoBox("Nyertél! A lapjaid értéke 21.", "success")
                                inPlay = false 
                                isUseDouble = false

                                if tonumber(originalbet) > 0 then 
                                    bet = originalbet 
                                    originalbet = 0 
                                end
                            end
                        end, 750, 1)
                    end
                end     

                if core:isInSlot(sx*0.75+9/myX*sx+sx*0.07, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy) then 
                    if gameState == "player" then 
                        lastClick = getTickCount()
                        if countCardValues("player") > 15 then 
                            gameState = "dealer"
                            takeDealerCards()
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 3).."Még nem állhatsz meg.", 255, 255, 255, true)
                        end
                    end
                end

                --[[if core:isInSlot(sx*0.75+12/myX*sx+sx*0.14, sy*0.94+6/myY*sy, sx*0.07, sy*0.05-12/myY*sy) then  -- DOUBLE IDG KISZEDVE
                    if gameState == "player" then 
                        lastClick = getTickCount()
                        if not isUseDouble then
                            if #cards["player"] == 2 then 
                                if getElementData(localPlayer, "char:cc") >= (tonumber(bet)*2) then 
                                    isUseDouble = true 
                                    originalbet = bet
                                    bet = tonumber(bet)*2 

                                    setElementData(localPlayer, "char:cc", getElementData(localPlayer, "char:cc") - originalbet)

                                    lastCardAlphaTick = getTickCount()
                                    local randCard = math.random(#cardsCache)
                                    table.insert(cards["player"], #cards["player"]+1, cardsCache[randCard])
                                    table.remove(cardsCache, randCard)

                                    setTimer(function() 
                                        local cardValue = countCardValues("player")

                                        if cardValue < 21 then 
                                            gameState = "dealer"
                                            takeDealerCards()
                                        else
                                            if cardValue == 21 then 
                                                triggerServerEvent("casino > blackjack > setPlayerMoney", resourceRoot, tonumber(bet)*2, "add")
                                                outputChatBox(core:getServerPrefix("green-dark", "Blackjack", 3).."Nyertél "..color..(tonumber(bet)*2).."#ffffffcc-t! A lapjaid értéke "..color.."21#ffffff.", 255, 255, 255, true)
                                                infobox:outputInfoBox("Nyertél! A lapjaid értéke 21.", "success")
                                            else
                                                outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 3).."Elbuktál "..color..(tonumber(bet)).."#ffffffcc-t! A lapjaid összege meghaladta a "..color.."21#ffffff-et.", 255, 255, 255, true)
                                                infobox:outputInfoBox("Elbuktad! A lapjaid értéke meghaladta 21-et.", "error")
                                            end
                                            if tonumber(originalbet) > 0 then 
                                                bet = originalbet 
                                                originalbet = 0 
                                            end
                                            inPlay = false 
                                        end
                                    end, 750, 1)
                                else
                                    outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 3).."Nem rendelkezel elegendő coinnal a duplázáshoz.", 255, 255, 255, true)
                                    infobox:outputInfoBox("Nem rendelkezel elegendő coinnal a duplázáshoz.", "error")
                                end
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 3).."Ezt a funkciót csak akkor használhatod, ha csak kettő kártyalap van nálad.", 255, 255, 255, true)
                                infobox:outputInfoBox("Ezt a funkciót jelenleg nem használhatod!", "error")
                            end
                        else
                            outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 3).."Csak egyszer használhatod.", 255, 255, 255, true)
                            infobox:outputInfoBox("Csak egyszer használhatod.", "error")
                        end
                    end
                end]]
            end
        end
    end
end

function takeDealerCards()
    local randCard = math.random(#cardsCache)

    lastCardAlphaTickDealer = getTickCount()
    table.insert(cards["dealer"], cardsCache[randCard])
    table.remove(cardsCache, randCard)

    setTimer(function() 
        local dealerCards = countCardValues("dealer")

        if dealerCards > 21 then 
            outputChatBox(core:getServerPrefix("green-dark", "Blackjack", 3).."Nyertél "..color..(tonumber(bet)*2).."#ffffffcc-t! Az osztó lapjainak összege meghaladta a "..color.."21#ffffff-et.", 255, 255, 255, true)
            infobox:outputInfoBox("Nyertél! Az osztó lapjainak összege meghaladta a 21-et.", "success")
            triggerServerEvent("casino > blackjack > setPlayerMoney", resourceRoot, tonumber(bet)*2, "add")
            inPlay = false
            
            if tonumber(originalbet) > 0 then 
                bet = originalbet 
                originalbet = 0 
            end
            
            return
        end

        if dealerCards == 21 then 
            outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 3).."Elbuktál "..color..(tonumber(bet)).."#ffffffcc-t! Az osztó lapjainak összege "..color.."21#ffffff.", 255, 255, 255, true)
            infobox:outputInfoBox("Elbuktad! Az osztó lapjainak összege 21.", "error")
            inPlay = false
            if tonumber(originalbet) > 0 then 
                bet = originalbet 
                originalbet = 0 
            end
        elseif dealerCards >= 17 then 
            gameEnd() 
        else
            takeDealerCards()
        end
    end, math.random(1000, 1500), 1)
end

function gameEnd()
    local dealerTavolsag = 21 - countCardValues("dealer")
    local playerTavolsag = 21 - countCardValues("player")

    if dealerTavolsag > playerTavolsag then 
        outputChatBox(core:getServerPrefix("green-dark", "Blackjack", 3).."Nyertél "..color..(tonumber(bet)*2).."#ffffffcc-t! A saját lapjaid összege közelebb volt a "..color.."21#ffffff-hez mint az osztóé.", 255, 255, 255, true)
        infobox:outputInfoBox("Nyertél! A saját lapjaid összege közelebb volt a 21-hez mint az osztóé.", "success")
        triggerServerEvent("casino > blackjack > setPlayerMoney", resourceRoot, tonumber(bet)*2, "add")
    elseif dealerTavolsag < playerTavolsag then
        outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 3).."Elbuktál "..color..(tonumber(bet)).."#ffffffcc-t! Az osztó lapjainak összege közelebb volt a "..color.."21#ffffff-hez mint a sajátodé.", 255, 255, 255, true)
        infobox:outputInfoBox("Elbuktad! Az osztó lapjainak összege közelebb volt a 21-hez.", "error")
    else 
        outputChatBox(core:getServerPrefix("green-dark", "Blackjack", 3).."Nyertél "..color..tonumber(bet).."#ffffffcc-t! A lapjaitok összege egyenlő.", 255, 255, 255, true)
        infobox:outputInfoBox("Nyertél! A lapjaitok összege egyenlő.", "success")
        triggerServerEvent("casino > blackjack > setPlayerMoney", resourceRoot, tonumber(bet), "add")
    end
    inPlay = false
    if tonumber(originalbet) > 0 then 
        bet = originalbet 
        originalbet = 0 
    end
end


function countCardValues(type)
    local value = 0
    local firstOne = true

    local ones = {}
    for k, v in ipairs(cards[type]) do 
        if v[2] == "01" then 
            table.insert(ones, #ones+1, v)
        else
            value = value + cardValues[v[2]]
        end
    end

    local one_Value = 0
    for k, v in ipairs(ones) do 
        if firstOne then 
            firstOne = false 

            if one_Value + 11 <= 21 then 
                one_Value = one_Value + 11 
            else
                one_Value = one_Value + 1
            end
        else
            one_Value = one_Value + 1
        end
    end

    if (one_Value + value) > 21 then 
        value = value + #ones 
    else
        value = value + one_Value
    end

    return value
end

addEventHandler("onClientClick", root, function(key, state, _, _, _, _, _, element)
    if key == "right" then 
        if state == "up" then 
            if element then 
                if getElementData(element, "isBlackjackTable") then 
                    if core:getDistance(element, localPlayer) < 2.5 then 
                        if not panelOpen then 
                            local freePlaces = 3 - getElementData(element, "blackjack:table:use")

                            if freePlaces > 0 then 
                                activeTable = element
                                panelOpen = true
                                triggerServerEvent("casino > blackjack > attachPlayerToTable", resourceRoot, element, freePlaces)

                                tooltipDatas = {
                                    ["title"] = "Blackjack",
                                    ["controll-lines"] = {
                                        {title = "Lapkérés", key = "Hit"},
                                        {title = "Megállás", key = "Stand"},
                                    },
                                    ["other-lines"] = {},
                                    ["long-descs"] = {},
                                }

                                exports.oInterface:toggleHud(true)

                                addEventHandler("onClientRender", root, renderTooltip)

                                inPlay = false
                                addEventHandler("onClientRender", root, renderBlackJack)
                                addEventHandler("onClientKey", root, keyBlackJack)
                            else
                                outputChatBox(core:getServerPrefix("red-dark", "Blackjack", 2).."Ez az asztal tele van!", 255, 255, 255, true)
                            end
                        end
                    end
                end
            end
        end
    end
end)    