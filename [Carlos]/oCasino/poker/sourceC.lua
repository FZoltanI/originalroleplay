pokerTableCol = engineLoadCOL ( "poker/nagypoker.col" )
engineReplaceCOL ( pokerTableCol, 4334 )
pokerTableTXD = engineLoadTXD ( "poker/pokertextura.txd" )
engineImportTXD ( pokerTableTXD, 4334 )
pokerTableDFF = engineLoadDFF ( "poker/nagypoker.dff" )
engineReplaceModel ( pokerTableDFF, 4334 ) 

pokerCurBets = 0
pokerCurOwnChips = 1
block = false
curPot = 0

local sx, sy = guiGetScreenSize()
lp = getLocalPlayer()

local ownCards = {}
local tableCards = {}
local tableData = {}
local sittingTableId = false
local gameStage = -1
local currentCalls = -1
local currentPlayer = false
local casinoCoin = getElementData(localPlayer, "char:cc") or 0
local tableElement = {}
local tableColShape = {}
local boardId = 0
local streamedBoardId = 0

local streamedTables = {}

local bet = 0
local betPanelActive = false
local tableInSittingSelected = {}
local lastAct = getTickCount()
local lastAct2 = getTickCount()

function isint(n)
    return tonumber(n)==math.floor(tonumber(n))
end

function isNumeric(text) 
  return ((tostring(tonumber(text)) == text or tonumber(text) == text) and tonumber(text)~=nil) and isint(text)
end 

addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oDashboard" or getResourceName(res) == "oInfobox" or getResourceName(res) == "oCarshop" then  
        infobox = exports.oInfobox
		core = exports.oCore
		color,r,g,b = exports.oCore:getServerColor()
	end
end)

addEventHandler("onClientResourceStart",getRootElement(), function()
    setElementData(localPlayer,"pokerTableId", false)
    setElementData(localPlayer,"pokerTableSeat", false)
    setTimer(triggerServerEvent, 1000, 1, "requestTables", localPlayer)
    casinoCoin = getElementData(localPlayer, "char:cc") or 0
    
end)

addEvent("requestTables", true)
addEventHandler("requestTables", getRootElement(), function(element)
    if isElement(element) then 
        generateTables()
    end
end)

addEventHandler("onClientElementColShapeHit", getRootElement(), function(hitPlayer, matchDim)
    if isElement(hitPlayer) and matchDim and hitPlayer == localPlayer and not getPedOccupiedVehicle(localPlayer) and getElementData(hitPlayer, "pokerTableId") then 
        boardId = getElementData(hitPlayer, "pokerTableId")
      --  if getElementData()
    end
end)



function pokerTablePlayerUp()
    triggerServerEvent("tableUpPlayer", localPlayer, getElementData(localPlayer, "char:pokerTableElement"), getElementData(localPlayer, "char:chairId"))
    unbindKey("backspace", "down", pokerTablePlayerUp)
end

local isInTableSitting = false

addEventHandler ( "onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "left" and state == "up" then
        if clickedElement and not getElementData(localPlayer, "pokerActive") then
            local xP, yP, zP = getElementPosition(localPlayer)
            for k = 1, #streamedTables do
                local v = streamedTables[k]
                if isElement(v) then
                    local xE, yE, zE = getElementPosition(v)
                    if getElementModel(v) == 4334 then
                        if getDistanceBetweenPoints3D(xP, yP, zP, xE, yE, zE) < 5 then
                            for i,z in pairs(pedPositions) do
                                if not getElementData(v, "chairBusy"..i) then
                                    local eX, eY, eZ = getElementPosition(v)
                                    local sx2, sy2 = getScreenFromWorldPosition(eX + z[1], eY + z[2], eZ + 0.5)
                                    if sx2 and sy2 then
                                        if core:isInSlot(sx2 - 50, sy2, 150, 25) then 
                                            isInTableSitting = true
                                            tableInSittingSelected = {v, i, xE, yE, zE}
                                            print(i)
                                            --
                                            outputChatBox("leülés")

                                            bindKey("backspace", "down", pokerTablePlayerUp)
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end)

function createPokerCard(card, x, y, w, h)
	if card then
		if card > 0 then
			dxDrawImage(x, y, w, h, "files/cards/1_01.png")
		end
	end
end

local timeTick = false

addEventHandler ( "onClientElementDataChange", getRootElement(),
function ( dataName )
	if getElementType ( source ) == "object" and dataName == "currentTablePlayer" then
		if getElementData(source, dataName) == localPlayer then
			timeTick = getTickCount()+30000
		else
			timeTick = false
		end
	end
end )



addEventHandler("onClientRender",getRootElement(), function()
    setTime(12,00)
    --createPokerCard(2, sx / 2 - 82, sy - 240, 80, 120)

    if sittingTableId then 
        if timeTick then
            if getTickCount() < timeTick then
            --    outputChatBox("ass")
                dxDrawRectangle(sx/2 - 125, sy - 300, 245, 15, tocolor(35, 35, 35, 150))
                dxDrawRectangle(sx/2 - 125 - 2,sy - 300 - 2, 245 + 4, 15 + 4, tocolor(30, 30, 30, 150))
                dxDrawRectangle(sx/2 - 125, sy - 300, (timeTick-getTickCount())/125, 15, tocolor(r, g, b, 255))
            end
        end
        dxDrawRectangle(sx/2 - 150/2, 50, 150, 25, tocolor(35, 35, 35, 255))
        dxDrawRectangle(sx/2 - 150/2 - 2,50 - 2, 150 + 4, 25 + 4, tocolor(30, 30, 30, 150))
        dxDrawText("Pot:#e97619 "..curPot.."CC",sx/2,50,sx/2,50 + 25,tocolor(255,255,255,255),0.65, fonts["condensed-25"], "center", "center", false,false,false,true) 

        if ownCards[1] and ownCards[2] then
	        if ownCards[1] > 0 and ownCards[2] > 0 then
	        	createPokerCard(ownCards[1], sx / 2 - 82, sy - 240, 80, 120)
	        	createPokerCard(ownCards[2], sx / 2 + 2, sy - 240, 80, 120)
	        end
	    end

    else 
        local xP, yP, zP = getElementPosition(localPlayer)
        --
        if streamedTables[streamedBoardId] then 
            local xE, yE, zE = getElementPosition(streamedTables[streamedBoardId])
            if getDistanceBetweenPoints3D(xP, yP, zP, xE, yE, zE) < 5 then
                for k,v in pairs(pedPositions) do
                    local eX, eY, eZ = getElementPosition(streamedTables[streamedBoardId])
                    local sx2, sy2 = getScreenFromWorldPosition(v[1] + eX, v[2] + eY, eZ + 0.5)
                    if sx2 and sy2 then
                        core:dxDrawButton(sx2-40, sy2, 100, 25, r,g,b, 150, "Leülés", tocolor(255, 255, 255, 255), 1, fonts["condensed-10"], true, tocolor(0, 0, 0, 150))
                    end
                end
            end
        end
    end


    
    if isInTableSitting then 
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
end)


function keyPokerFunc(key, state)
    if state then 
        if isInTableSitting then
            if key == "mouse1" then 
                if core:isInSlot(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy, sx*0.15-6/myX*sx, sy*0.04-6/myY*sy) then 
                    --outputChatBox("Játék kezdése")
                    if tonumber(bet) >= getElementData(tableInSittingSelected[1], "minBet") then 
                        if tonumber(bet) <= getElementData(tableInSittingSelected[1], "maxBet") then 
                            if getElementData(localPlayer, "char:cc") >= tonumber(bet) then
                                if core:getNetworkConnection() then 
                                    --outputChatBox("Játék kezdés")
                                    tableId = getElementData(tableInSittingSelected[1],"pokerTableObjectId")
                                    setElementData(localPlayer, "pokerTableSeat", tableInSittingSelected[2])
                                    setElementData(localPlayer, "pokerTableId", tableId)
                                    triggerServerEvent("tableSit", localPlayer, tableInSittingSelected[2], tableInSittingSelected[3], tableInSittingSelected[4],tableInSittingSelected[5], tableInSittingSelected[1], tonumber(bet))
                                    tableInSittingSelected = {}
                                    isInTableSitting = false
                                    bet = 0
                                else
                                    infobox:outputInfoBox("Az internetkapcsolatod nem elég stabil a játék megkezdéséhez!", "warning")
                                end
                            else
                                infobox:outputInfoBox("Nincs elegendő CasinoCoinod! ("..bet.."cc)", "error")
                                outputChatBox(core:getServerPrefix("red-dark", "CasinoCoin", 2).."Nincs elegendő CasinoCoinod! "..color.."("..bet.."cc)", 255, 255, 255, true)
                            end
                        else 
                            infobox:outputInfoBox("A maximum tét "..getElementData(tableInSittingSelected[1], "maxBet").."CC!", "error")
                        end
                    else 
                        infobox:outputInfoBox("A minimum tét "..getElementData(tableInSittingSelected[1], "minBet").."CC!", "error")
                    end
                end
                if core:isInSlot(sx*0.425+3/myX*sx, sy*0.85+3/myY*sy+sy*0.03, sx*0.15-6/myX*sx, sy*0.03-6/myY*sy) then 
                    isInTableSitting = false
                    tableInSittingSelected = {}
                end
                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.845+3/myY*sy, sx*0.095-6/myY*sy, sy*0.07) then
                    betPanelActive = true
                else
                    betPanelActive = false 
                end
                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.92+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then 
                    bet = 0
                    outputChatBox("Tét null")
                end
                if core:isInSlot(sx*0.9+3/myX*sx, sy*0.95+3/myY*sy, sx*0.095-6/myY*sy, sy*0.025) then  
                    bet = (getElementData(localPlayer, "char:cc") or 0)

                    if bet > 2500 then 
                        bet = 2500
                    end
                    outputChatBox("All in")
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
        end
    end
end
addEventHandler("onClientKey",getRootElement(), keyPokerFunc)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
    if getElementData(source, "pokerTableObjectId") then
        for k,v in pairs(realGuiPositions[getElementData(source, "pokerTableObjectId")]) do 
      --      outputChatBox(k .. " "..table.concat(v, ","))
        end
        streamedBoardId =  getElementData(source, "pokerTableObjectId")
    end
end)


addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
        if getElementType( source ) == "object" then
            if getElementModel(source) == 4334 then
            	streamedTables[#streamedTables+1] = source
            end
        end
    end
);

addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
        if getElementType( source ) == "object" then
            if getElementModel(source) == 4334  then
            	for k = 1, #streamedTables do
            		if streamedTables[k] == source then
            			streamedTables[k] = nil
            		end
            	end
            end
        end
    end
);

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "object" then
        if getElementModel(source) == 4334 then
        	for k = 1, #streamedTables do
        		if streamedTables[k] == source then
        			streamedTables[k] = nil
        		end
        	end
        end
	end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, newValue)
    if source == localPlayer then 
        if dataName == "pokerTableId" then 
            if getElementData(source, dataName) then 
                sittingTableId = getElementData(source, dataName)
                tableData = {}
                for k,v in pairs(getElementsByType("player", getRootElement(), false)) do 
                    if getElementData(v, "pokerTableId") and getElementData(source, dataName) == getElementData(v, "pokerTableId") and getElementData(v, "pokerTableSeat") then 
                        tableData[v] = {
                            getElementData(v, "pokerTableSeat"),
                            getElementData(resourceRoot, "pokerBoard."..getElementData(v, "pokerTableId") ..".seat.".. getElementData(v, "pokerTableSeat").. ".pokerCoins") or 0,
                            getElementData(resourceRoot, "pokerBoard."..getElementData(v, "pokerTableId") ..".seat.".. getElementData(v, "pokerTableSeat").. ".pokerCards") or {},
                            getElementData(resourceRoot, "pokerBoard."..getElementData(v, "pokerTableId") ..".seat.".. getElementData(v, "pokerTableSeat").. ".currentCall") or 0,
                        }
                    end
                end
                tableCards = getElementData(resourceRoot, "pokerBoard."..getElementData(source, dataName)..".boardCards") or {}
                gameStage = getElementData(resourceRoot, "pokerBoard."..getElementData(source, dataName)..".gameStage") or -1
                currentCall = getElementData(resourceRoot, "pokerBoard."..getElementData(source, dataName)..".currentCall") or -1
                currentPlayer = getElementData(resourceRoot, "pokerBoard."..getElementData(source, dataName)..".currentPlayer") or 0

            else
                tableCards = {}
                gameStage = -1
                currentCall = -1
                currentPlayer = false
            end
        elseif dataName == "char:cc" then 
            casinoCoin = getElementData(localPlayer, "char:cc") or 0
        end
    elseif source == resourceRoot and string.find(dataName, "pokerBoard") then 
        if getElementData(localPlayer, "pokerTableId") and getElementData(localPlayer, "pokerTableId") == tonumber(split(dataName, ".")[2]) then 
            if split(dataName, ".")[3] == "boardCards" then 
                tableCards = getElementData(source, dataName) or {}
            elseif split(dataName, ".")[3] == "gameStage" then 
                gameStage = getElementData(source, dataName) or -1
            elseif split(dataName, ".")[3] == "currentPlayer" then 

            elseif split(dataName, ".")[3] == "currentCall" then 
                currentCall = getElementData(source, dataName) or 0
            elseif split(dataName, ".")[3] == "seat" then 

            elseif split(dataName, ".")[3] == "pokerCoins" then 

            elseif split(dataName, ".")[3] == "pokerCards" then 

            elseif split(dataName, ".")[3] == "currentCall" then 

            end
        end
        if split(dataName, ".")[3] == "gameStage" then 
            if getElementData(source, dataName) > 0 then 

            end
        end
    end
end)