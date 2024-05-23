local sx, sy = guiGetScreenSize();
local e = exports.oCore;
local movePanel = false;
local tag = "";
local pos = {
    x = sx/2-600, 
    y = sy/2-300, 
    w = 1200,
    h = 650,
    procx = sx/2-200, 
    procy = sy/2-200,
    procw = 400,
    proch = 200,
};

local termeles = "";
local price = "";
local businessPrice = 2000
localPlayer:setData("haveBusiness", false)
local moneyText = ""

local playerBarrels = {}

local businessMarker = Marker(1503.9116210938, -1547.2606201172, 66.2109375, "cylinder", 0.7, 255, 255, 255, 255)
businessMarker:setData("Wbusiness", true)

addEventHandler("onClientElementDataChange", root, 
    function(key, oldV, newV)
        if (key == "haveBusiness") then 
            if (newV == true) then 
                removeCommandHandler("rentbusiness", rentPlayerBusiness)
            end 
        end 
    end 
);

addEventHandler("onClientMarkerHit", root, 
    function()
        if (source:getData("Wbusiness")) then 
            if not (localPlayer:getData("haveBusiness")) then 
                addCommandHandler("rentbusiness", rentPlayerBusiness)
            else
                addCommandHandler("unrentbusiness", unrentPlayerBusiness)
            end 
        end 
    end 
);

addEventHandler("onClientMarkerLeave", root, 
    function()
        if (source:getData("Wbusiness")) then 
            removeCommandHandler("rentbusiness", rentPlayerBusiness)
            removeCommandHandler("unrentbusiness", unrentPlayerBusiness)
        end 
    end 
);

function sendServerData(level, date)
    spawnPlayerBarrel(level, date)
end 
addEvent("sendServerData", true)
addEventHandler("sendServerData", root, sendServerData)


function rentPlayerBusiness()
    if (localPlayer:getData("char:money") >= businessPrice) then 
        localPlayer:setData("char:money", localPlayer:getData("char:money") - businessPrice)
        localPlayer:setData("haveBusiness", true)
        exports.oInfobox:outputInfoBox("Sikeresen béreltél egy Whisky bizniszt", "success")
        localPlayer:setData("whisky.barrel", 1)
        --spawnPlayerBarrel(0)
    end 
end 

function spawnPlayerBarrel(level, date)
    local barID = localPlayer:getData("whisky.barrel") or 1
    iprint(barID)
    local idByIndex = 0;
    local yGap = 0
    for i=1, barID do 
        idByIndex = i
        if (barID > 1) then 
            yGap = 1*(i-1)
        else
            yGap = 0
        end
        playerBarrels[i] = {};
        playerBarrels[i][1] = Object(3632, 1516.8415527344, -1535.4057617188 + yGap, 67.2109375)
        playerBarrels[i][1]:setData("barrel.level", level)
        playerBarrels[1][1]:setData("barrel.level", level)
        playerBarrels[i][1]:setData("barrel.id", idByIndex)
        playerBarrels[i][1]:setData("barrel.date", tostring(date))
        playerBarrels[i][2] = playerBarrels[i][1]:getData("barrel.level")
        playerBarrels[i][3] = playerBarrels[i][1]:getData("barrel.date")
        triggerServerEvent("uploadBarrelData", localPlayer, localPlayer, 0, i)
    end 
end

for i=1,10 do
    outputChatBox(i)
    spawnPlayerBarrel(i)
end


function unrentPlayerBusiness()
    if (localPlayer:getData("haveBusiness")) then 
        localPlayer:setData("haveBusiness", false)
        localPlayer:setData("whisky.barrel", 0)
        exports.oInfobox:outputInfoBox("Sikeresen lemondtad a Whisky biznisz bérleted", "success")
    end 
end 

local barrels = {};
local barrelTimer = {}
local playerDis = {}
local loadedBarrels = 0;
local xGap = 0;
local yGap = 0;
local id = 0


local elementDataTable = {
    "whisky.dis",
    "whisky.liter",
    "whisky.barrel",
    "whisky.balance",
    "whisky.take",
    "whisky.model"
};

local hover = {
    show = true;
    texting = false;
    textingalpha = 255;
    moneyTextColor = tocolor(25, 25, 25, 255);
    process = false;
    dis = 1;
    disPrice = 500;
    buybarrel = false;
    barrel = 1;
    barrelPrice = 250;
};

local serverColor = e:getServerColor()
local r, g, b = e:getServerColor()
local x = "files/X.png"

addCommandHandler("panel", 
    function()
        if not (hover.process) or not (hover.buybarrel) then 
            hover.show = not hover.show
            movePanel = false;
        end 
    end 
);

addEventHandler("onClientResourceStart", root, 
    function(res)
        if (res == getThisResource()) then 
            
            for i,v in ipairs(elementDataTable) do 
                localPlayer:setData(v, 27)
                localPlayer:setData("whisky.dis", 1)
                localPlayer:setData("whisky.barrel", 9)
                localPlayer:setData("whisky.balance", 5500)
            end 
            local xGap = 0;
            local yGap = 0;
            local loadedBarrels = 0;
            loadPlayerDisClientSide()
        end 
    end
);

function loadPlayerDisClientSide()
    for i=1, localPlayer:getData("whisky.dis") do 
        yGap = 1*(i-1)
        if not (playerDis[i]) then 
            playerDis[i] = Object(1292, 932.64440917969, 2103.7221679688 + yGap, 1010.5234375, 0, 0, 90)
            playerDis[i].dimension = 265
            playerDis[i].interior = 1
            iprint(playerDis[i])
        end 
    end 
end 

local fontTable = {};

function getFont(name, size)
    local key = name..size
    if not (fontTable[key]) then 
        local font = exports.oFont:getFont(name, size)
        fontTable[key] = font
    end 
    return fontTable[key]
end

local panel = {
    render = function()
        local datasByPlayer = {
            {name = "Lepárlók", data = localPlayer:getData("whisky.dis"), tag = " db"},
            {name = "Eltárolt whisky", data = localPlayer:getData("whisky.liter"), tag =" l"},
            {name = "Hordók", data = localPlayer:getData("whisky.barrel"), tag = " db"},
            {name = "Számla egyenleg", data = localPlayer:getData("whisky.balance"), tag = " $"},
            {name = "Bevétel", data = localPlayer:getData("whisky.take"), tag = " $"},
            {name = "Kinézet", data = localPlayer:getData("whisky.model")}
        };
        e:dxDrawRoundedRectangle(pos.x, pos.y, pos.w, pos.h, tocolor(40, 40, 40, 255), false) ---- Alap rectangle
        e:dxDrawRoundedRectangle(pos.x, pos.y, 80, pos.h, tocolor(30, 30, 30, 255), false) ---- Bal oldali sötét csík
        e:dxDrawRoundedRectangle(pos.x, pos.y, pos.w, 60, tocolor(30, 30, 30, 200), false) ---- Felső sötét csík
        dxDrawImage(pos.x + 15, pos.y + 10, 50, 45, "files/logo.png")
        dxDrawImage(pos.x + 1160, pos.y + 15, 35, 35, x)
        dxDrawRectangle(pos.x+100, pos.y + 80, 480, 290, tocolor(35, 35, 35, 255), false) ---- Adatok háttere
        dxDrawRectangle(pos.x+100, pos.y + 80, 480, 60, tocolor(25, 25, 25, 255), false) ---- Adatok háttere felső csík
        e:dxDrawShadowedText("original"..serverColor.."Roleplay", pos.x + 90, pos.y - 25, pos.x + pos.w, pos.y + 60, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 16), "left", "center", false, false, false, true)
        e:dxDrawShadowedText("Whisky"..serverColor.."Business", pos.x + 100, pos.y + 25, pos.x + pos.w, pos.y + 60, tocolor(200, 200, 200, 200), tocolor(10, 10, 10, 200), 1, getFont("condensed", 14), "left", "center", false, false, false, true)
        e:dxDrawShadowedText("WHISKY BUSINESS STATISZTIKÁK", pos.x+100, pos.y + 80, pos.x+100 + 480, pos.y + 80 + 60, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 18), "center", "center", false, false, false, true)
        for i,v in ipairs(datasByPlayer) do  ---- Adatok lekérdezése táblából, kirajzolás
            yGap = 37*(i-1)

            local BG_COLOR;

            if (i%2 == 0) then 
                BG_COLOR = tocolor(25, 25, 25, 255)
            else 
                BG_COLOR = tocolor(30, 30, 30, 255)
            end 

            dxDrawRectangle(pos.x+100, pos.y + 145 + yGap, 480, 35, BG_COLOR, false)
            e:dxDrawShadowedText(v.name, pos.x+100 + 10, pos.y + 145 + yGap, pos.x+100 + 480, pos.y + 145 + yGap + 35, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 12), "left", "center", false, false, false, true)
            
            if (v.tag) then 
                tag = v.tag 
            else
                tag = ""
            end 
            e:dxDrawShadowedText(serverColor..v.data..tag, pos.x+100, pos.y + 145 + yGap, pos.x+100 + 480 - 10, pos.y + 145 + yGap + 35, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 12), "right", "center", false, false, false, true)
        end 

        e:dxDrawRoundedRectangle(pos.x+100, pos.y + 400, 480, 45, hover.moneyTextColor, false) ---- Pénz text panel
        if (e:isInSlot(pos.x+100, pos.y + 460, 480, 50)) then 
            e:dxDrawRoundedRectangle(pos.x+100, pos.y + 460, 480, 50, tocolor(20, 20, 20, 255), false) ---- Pénz kivétel gomb
        else
            e:dxDrawRoundedRectangle(pos.x+100, pos.y + 460, 480, 50, tocolor(25, 25, 25, 255), false) ---- Pénz kivétel gomb
        end 
        e:dxDrawShadowedText("PÉNZ KIVÉTELE", pos.x+100, pos.y + 460, pos.x+100 + 480, pos.y + 460 + 50, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 15), "center", "center", false, false, false, true)
    
        if (hover.texting) then 
            if (moneyText == "") then 
                dxDrawText("|", pos.x+100, pos.y + 400, pos.x+100 + 480, pos.y + 400 + 45, tocolor(255, 255, 255, hover.textingalpha), 1, getFont("condensed", 15), "center", "center", false, false, false, true)
            end 
            if not (moneyText == "") then 
                dxDrawText(serverColor..moneyText.."#FFFFFF|", pos.x+100, pos.y + 400, pos.x+100 + 480, pos.y + 400 + 45, tocolor(255, 255, 255, 255), 1, getFont("condensed", 15), "center", "center", false, false, false, true)
            end 
        end 
        if not (moneyText == "") then 
            if not (hover.texting) then 
                dxDrawText(serverColor..moneyText.." $", pos.x+100, pos.y + 400, pos.x+100 + 480, pos.y + 400 + 45, tocolor(255, 255, 255, 255), 1, getFont("condensed", 15), "center", "center", false, false, false, true)
            end 
        end 
        if (movePanel) then 
            if (isCursorShowing()) then 
                local cX, cY = getCursorPosition()
                pos.x = cX*sx-movePanel.x 
                pos.y = cY*sy-movePanel.y
            else
                movePanel = false;
            end 
        end 

        ----- lepárló vásárlás ----------

        if (localPlayer:getData("whisky.dis") == 0) then 
            termeles = "0"
            price = "0"
        elseif (localPlayer:getData("whisky.dis") == 1) then 
            termeles = "50"
            price = "2000"
        elseif (localPlayer:getData("whisky.dis") == 2) then 
            termeles = "100"
            price = "4000"
        elseif (localPlayer:getData("whisky.dis") == 3) then 
            termeles = "150"
            price = "6000"
        elseif (localPlayer:getData("whisky.dis") == 4) then 
            termeles = "200"
            price = "8000"
        end 


        dxDrawImage(pos.x + 780, pos.y + 140, 230, 200, "files/logoalpha.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(pos.x + 670, pos.y + 235, 196, 40, "files/line1.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(pos.x + 903, pos.y + 235, 144, 40, "files/line2.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        e:dxDrawShadowedText("TERMELÉS"..serverColor..": "..termeles.."L/NAP", pos.x + 670, pos.y + 235 - 56, pos.x + 670 + 196, pos.y + 235 + 40, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 9), "left", "center", false, false, false, true)
        e:dxDrawShadowedText("ÁR#7CD66B: "..price.."$", pos.x + 903, pos.y + 235 + 15, pos.x + 903 + 144 + 70, pos.y + 235 + 40, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 9), "center", "center", false, false, false, true)
        if (e:isInSlot(pos.x+790, pos.y + 370, 200, 50)) then 
            e:dxDrawRoundedRectangle(pos.x+790, pos.y + 370, 200, 50, tocolor(20, 20, 20, 255), false) ---- lepárló vásárlás gomb
        else
            e:dxDrawRoundedRectangle(pos.x+790, pos.y + 370, 200, 50, tocolor(25, 25, 25, 255), false) ---- lepárló vásárlás gomb
        end
        e:dxDrawShadowedText("LEPÁRLÓ VÁSÁRLÁS", pos.x+790, pos.y + 370, pos.x+790 + 200, pos.y + 370 + 50, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 13), "center", "center", false, false, false, true)

        if (e:isInSlot(pos.x+790, pos.y + 430, 200, 50)) then 
            e:dxDrawRoundedRectangle(pos.x+790, pos.y + 430, 200, 50, tocolor(20, 20, 20, 255), false) ---- lepárló vásárlás gomb
        else
            e:dxDrawRoundedRectangle(pos.x+790, pos.y + 430, 200, 50, tocolor(25, 25, 25, 255), false) ---- lepárló vásárlás gomb
        end
        e:dxDrawShadowedText("HORDÓ VÁSÁRLÁS", pos.x+790, pos.y + 430, pos.x+790 + 200, pos.y + 430 + 50, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 13), "center", "center", false, false, false, true)
    end;
    process = function()
        e:dxDrawRoundedRectangle(pos.procx, pos.procy, pos.procw, pos.proch, tocolor(40, 40, 40, 255), false) ---- Process panel
        e:dxDrawRoundedRectangle(pos.procx, pos.procy, pos.procw, 30, tocolor(30, 30, 30, 255), false) ---- Process panel felső rész
        dxDrawImage(pos.procx + 370, pos.procy + 3, 25, 25, x)
        e:dxDrawShadowedText("LEPÁRLÓ VÁSÁRLÁS", pos.procx, pos.procy, pos.procx + pos.procw, pos.procy + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 13), "center", "center", false, false, false, true)
        dxDrawImage(pos.x + 740, pos.y + 250, 53, 44, "files/logoalpha.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        if (e:isInSlot(pos.procx + 135, pos.procy + 50, 30, 30)) then 
            e:dxDrawRoundedRectangle(pos.procx + 135, pos.procy + 50, 30, 30, tocolor(25, 25, 25, 255), false) ---- Process gomb bal
        else
            e:dxDrawRoundedRectangle(pos.procx + 135, pos.procy + 50, 30, 30, tocolor(30, 30, 30, 255), false) ---- Process gomb bal
        end 
        if (e:isInSlot(pos.procx + 235, pos.procy + 50, 30, 30)) then 
            e:dxDrawRoundedRectangle(pos.procx + 235, pos.procy + 50, 30, 30, tocolor(25, 25, 25, 255), false) ---- Process gomb jobb
        else
            e:dxDrawRoundedRectangle(pos.procx + 235, pos.procy + 50, 30, 30, tocolor(30, 30, 30, 255), false) ---- Process gomb jobb
        end 
        e:dxDrawShadowedText(serverColor..hover.dis.." db", pos.procx + 20, pos.procy + 50, pos.procx + 20 + pos.procw-40, pos.procy + 50 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 13), "center", "center", false, false, false, true)
        e:dxDrawShadowedText("+", pos.procx + 235, pos.procy + 50, pos.procx + 235 + 30, pos.procy + 50 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 16), "center", "center", false, false, false, true)
        e:dxDrawShadowedText("-", pos.procx + 135, pos.procy + 50, pos.procx + 135 + 30, pos.procy + 50 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 20), "center", "center", false, false, false, true)
        e:dxDrawShadowedText("ÁR: #7CD66B"..hover.disPrice.." $", pos.procx + 20, pos.procy + 50 + 80, pos.procx + 20 + pos.procw-40, pos.procy + 50 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 13), "center", "center", false, false, false, true)
        if (e:isInSlot(pos.procx + 140, pos.procy + 135, pos.procw - 280, 30)) then 
            e:dxDrawRoundedRectangle(pos.procx + 140, pos.procy + 135, pos.procw - 280, 30, tocolor(25, 25, 25, 255), false) ---- Process panel vásárlás
        else
            e:dxDrawRoundedRectangle(pos.procx + 140, pos.procy + 135, pos.procw - 280, 30, tocolor(30, 30, 30, 255), false) ---- Process panel vásárlás
        end 
        e:dxDrawShadowedText("VÁSÁRLÁS", pos.procx + 140, pos.procy + 135, pos.procx + 140 + pos.procw - 280, pos.procy + 135 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 10), "center", "center", false, false, false, true)
    end;
    buybarrel = function()
        e:dxDrawRoundedRectangle(pos.procx, pos.procy, pos.procw, pos.proch, tocolor(40, 40, 40, 255), false) ---- Process panel
        e:dxDrawRoundedRectangle(pos.procx, pos.procy, pos.procw, 30, tocolor(30, 30, 30, 255), false) ---- Process panel felső rész
        dxDrawImage(pos.procx + 370, pos.procy + 3, 25, 25, x)
        e:dxDrawShadowedText("HORDÓ VÁSÁRLÁS", pos.procx, pos.procy, pos.procx + pos.procw, pos.procy + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 13), "center", "center", false, false, false, true)
        dxDrawImage(pos.x + 740, pos.y + 250, 53, 44, "files/logoalpha.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        if (e:isInSlot(pos.procx + 135, pos.procy + 50, 30, 30)) then 
            e:dxDrawRoundedRectangle(pos.procx + 135, pos.procy + 50, 30, 30, tocolor(25, 25, 25, 255), false) ---- Process gomb bal
        else
            e:dxDrawRoundedRectangle(pos.procx + 135, pos.procy + 50, 30, 30, tocolor(30, 30, 30, 255), false) ---- Process gomb bal
        end 
        if (e:isInSlot(pos.procx + 235, pos.procy + 50, 30, 30)) then 
            e:dxDrawRoundedRectangle(pos.procx + 235, pos.procy + 50, 30, 30, tocolor(25, 25, 25, 255), false) ---- Process gomb jobb
        else
            e:dxDrawRoundedRectangle(pos.procx + 235, pos.procy + 50, 30, 30, tocolor(30, 30, 30, 255), false) ---- Process gomb jobb
        end 
        e:dxDrawShadowedText(serverColor..hover.barrel.." db", pos.procx + 20, pos.procy + 50, pos.procx + 20 + pos.procw-40, pos.procy + 50 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 13), "center", "center", false, false, false, true)
        e:dxDrawShadowedText("+", pos.procx + 235, pos.procy + 50, pos.procx + 235 + 30, pos.procy + 50 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 16), "center", "center", false, false, false, true)
        e:dxDrawShadowedText("-", pos.procx + 135, pos.procy + 50, pos.procx + 135 + 30, pos.procy + 50 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 20), "center", "center", false, false, false, true)
        e:dxDrawShadowedText("ÁR: #7CD66B"..hover.barrelPrice.." $", pos.procx + 20, pos.procy + 50 + 80, pos.procx + 20 + pos.procw-40, pos.procy + 50 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 13), "center", "center", false, false, false, true)
        if (e:isInSlot(pos.procx + 140, pos.procy + 135, pos.procw - 280, 30)) then 
            e:dxDrawRoundedRectangle(pos.procx + 140, pos.procy + 135, pos.procw - 280, 30, tocolor(25, 25, 25, 255), false) ---- Process panel vásárlás
        else
            e:dxDrawRoundedRectangle(pos.procx + 140, pos.procy + 135, pos.procw - 280, 30, tocolor(30, 30, 30, 255), false) ---- Process panel vásárlás
        end 
        e:dxDrawShadowedText("VÁSÁRLÁS", pos.procx + 140, pos.procy + 135, pos.procx + 140 + pos.procw - 280, pos.procy + 135 + 30, tocolor(200, 200, 200, 255), tocolor(10, 10, 10, 255), 1, getFont("condensed", 10), "center", "center", false, false, false, true)
    end;
};

addEventHandler("onClientRender", root, 
    function()
        -- if (localPlayer.name == "Carlos") then 
            if (hover.show) then 
                panel:render()
            end
            if (hover.process) then 
                panel:process()
            end 
            if (hover.buybarrel) then 
                panel:buybarrel()
            end  
        -- end 
    end 
);

addEventHandler("onClientRender", root, 
    function()
        for i=1, localPlayer:getData("whisky.barrel") do 
            dxDrawTextOnElement(playerBarrels[i][1], "Tárolási idő kezdete: "..playerBarrels[i][3],1,20,255,255,255,255, 10, 10, 10, 255, 1.3,getFont("condensed", 10))
            dxDrawTextOnElement(playerBarrels[i][1], playerBarrels[i][2].."/50 liter",0.92,20,255,255,255,255, 10, 10, 10, 255, 1.3,getFont("condensed", 10))
        end 
    end
);

addEventHandler("onClientClick", root, 
    function(button, state)
        if (hover.show) then 
            if (button == "left") then 
                if (state == "down") then 
                    if (e:isInSlot(pos.x, pos.y, pos.w, 60)) then 
                        local cX, cY = getCursorPosition();
                        movePanel = Vector2(cX*sx-pos.x, cY*sy-pos.y)
                    end 
                    if (e:isInSlot(pos.x + 1160, pos.y + 15, 35, 35)) then 
                        if (hover.show) then 
                            hover.show = false;
                            moneyText = ""
                        end 
                    end 
                    if (e:isInSlot(pos.x+100, pos.y + 400, 480, 45)) then 
                        hover.texting = true;
                        hover.moneyTextColor = tocolor(20, 20, 20, 255)
                        guiSetInputEnabled(true)
                        if not (isTimer(hoverTimer)) then 
                            hoverTimer = setTimer(function()
                                if (hover.textingalpha == 255) then 
                                    hover.textingalpha = 0
                                elseif (hover.textingalpha == 0) then 
                                    hover.textingalpha = 255
                                end 
                            end, 700, 0)
                        end 
                    else
                        hover.moneyTextColor = tocolor(25, 25, 25, 255)
                        guiSetInputEnabled(false)
                        hover.texting = false;
                        if (isTimer(hoverTimer)) then 
                            killTimer(hoverTimer)
                        end 
                    end 
                    if (e:isInSlot(pos.x+100, pos.y + 460, 480, 50)) then 
                        if not (moneyText == "") then 
                            if (localPlayer:getData("whisky.balance") >= tonumber(moneyText)) then 
                                if (tonumber(moneyText) >= 20) then 
                                    localPlayer:setData("char:money", localPlayer:getData("char:money") + moneyText)
                                    localPlayer:setData("whisky.balance", localPlayer:getData("whisky.balance") - moneyText)
                                    exports.oInfobox:outputInfoBox("Levettél a biznisz számlájáról "..moneyText.." $ összegű pénzt! Jelenlegi összeg: "..localPlayer:getData("whisky.balance").." $", "success")
                                    moneyText = ""
                                else
                                    exports.oInfobox:outputInfoBox("Minimum érték 20!", "error")
                                end 
                            else 
                                exports.oInfobox:outputInfoBox("Nincs ennyi pénz a biznisz számlán!", "error")
                            end 
                        else
                            exports.oInfobox:outputInfoBox("Adj meg értéket! Minimum érték 20.", "error")
                        end
                    end 
                    if (e:isInSlot(pos.x+790, pos.y + 370, 200, 50)) then 
                        hover.process = true;
                        hover.show = false;
                    end 
                    if (e:isInSlot(pos.x+790, pos.y + 430, 200, 50)) then 
                        hover.buybarrel = true;
                        hover.show = false;
                    end 
                else
                    movePanel = false;
                end 
            end 
        end 
        if (hover.process) then 
            if (button == "left") then 
                if (state == "down") then 
                    if (e:isInSlot(pos.procx + 235, pos.procy + 50, 30, 30)) then 
                        local maxDis = (4) - (localPlayer:getData("whisky.dis"))
                        if (hover.dis < maxDis) then 
                            hover.dis = hover.dis + 1
                            hover.disPrice = hover.disPrice + 500
                        else
                            exports.oInfobox:outputInfoBox("Maximum 10 lepárlót vehetsz! Már rendelkezel "..maxDis.." lepárlóval.", "error")
                        end 
                    end 
                    if (e:isInSlot(pos.procx + 135, pos.procy + 50, 30, 30)) then 
                        if (hover.dis > 1) then 
                            hover.dis = hover.dis - 1
                            hover.disPrice = hover.disPrice - 500
                        end 
                    end 
                    if (e:isInSlot(pos.procx + 370, pos.procy + 3, 25, 25)) then 
                        hover.process = false;
                        hover.show = true;
                        hover.disPrice = 500;
                        hover.dis = 1;
                    end 
                    if (e:isInSlot(pos.procx + 140, pos.procy + 135, pos.procw - 280, 30)) then 
                        ------ Vásárlás véglegesítése
                        local maxDis = (4) - (localPlayer:getData("whisky.dis"))
                        if (hover.dis <= maxDis) then 
                            if (localPlayer:getData("whisky.balance") >= hover.disPrice) then 
                                localPlayer:setData("whisky.dis", localPlayer:getData("whisky.dis") + hover.dis)
                                localPlayer:setData("whisky.balance", localPlayer:getData("whisky.balance") - hover.disPrice)
                                exports.oInfobox:outputInfoBox("Sikeresen vettél "..hover.dis.." lepárlót!", "success")
                                loadPlayerDisClientSide()
                            else
                                exports.oInfobox:outputInfoBox("Nincs elég pénzed a biznisz számláján!", "error")
                            end
                        else
                            exports.oInfobox:outputInfoBox("Nem vehetsz több lepárlót elérted a maximális összeget!", "error")
                        end 
                    end 
                end
            end 
        end 
        if (hover.buybarrel) then 
            if (button == "left") then 
                if (state == "down") then 
                    if (e:isInSlot(pos.procx + 235, pos.procy + 50, 30, 30)) then 
                        local maxBarrel = (28) - (localPlayer:getData("whisky.barrel"))
                        if (hover.barrel < maxBarrel) then 
                            hover.barrel = hover.barrel + 1
                            hover.barrelPrice = hover.barrelPrice + 250
                        else
                            exports.oInfobox:outputInfoBox("Maximum 28 hordót vehetsz! Már rendelkezel "..localPlayer:getData("whisky.barrel").." hordóval.", "error")
                        end 
                    end 
                    if (e:isInSlot(pos.procx + 135, pos.procy + 50, 30, 30)) then 
                        if (hover.barrel > 1) then 
                            hover.barrel = hover.barrel - 1
                            hover.barrelPrice = hover.barrelPrice - 250
                        end 
                    end 
                    if (e:isInSlot(pos.procx + 370, pos.procy + 3, 25, 25)) then 
                        hover.buybarrel = false;
                        hover.show = true;
                        hover.barrelPrice = 250;
                        hover.barrel = 1;
                    end 
                    if (e:isInSlot(pos.procx + 140, pos.procy + 135, pos.procw - 280, 30)) then 
                        ------ Vásárlás véglegesítése
                        local maxBarrel = (28) - (localPlayer:getData("whisky.dis"))
                        if (hover.barrel <= maxBarrel) then 
                            if (localPlayer:getData("whisky.balance") >= hover.barrelPrice) then 
                                localPlayer:setData("whisky.barrel", localPlayer:getData("whisky.barrel") + hover.barrel)
                                localPlayer:setData("whisky.balance", localPlayer:getData("whisky.balance") - hover.barrelPrice)
                                exports.oInfobox:outputInfoBox("Sikeresen vettél "..hover.barrel.." hordót!", "success")
                                spawnPlayerBarrel(0)
                            else
                                exports.oInfobox:outputInfoBox("Nincs elég pénzed a biznisz számláján!", "error")
                            end
                        else
                            exports.oInfobox:outputInfoBox("Nem vehetsz több hordót elérted a maximális összeget!", "error")
                        end 
                    end 
                end
            end 
        end 
    end 
);


addEventHandler("onClientCharacter", root, 
    function(char)
        if (hover.show) then 
            if (hover.texting) then 
                if (string.len(moneyText) < 26) then
                    if (tonumber(char)) then 
                        moneyText = moneyText..char
                    else
                        cancelEvent()
                    end 
                end 
            end 
        end 
    end 
);


addEventHandler("onClientKey", root, 
    function(button, state)
        if (button == "backspace") then 
            if (hover.show) then 
                if (hover.texting) then 
                    if (state) then 
                        moneyText = string.sub(moneyText, 0, string.len(moneyText)-1)
                        delTimer = setTimer(function()
                            moneyText = string.sub(moneyText, 0, string.len(moneyText)-1)
                        end, 100, 0)
                    else
                        if (isTimer(delTimer)) then 
                            killTimer(delTimer);
                        end 	
                    end 
                end 
            end 
        end 
    end 
);

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B, alpha, backR, backG, backB, backalpha ,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				e:dxDrawShadowedText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), tocolor(backR or 255, backG or 255, backB or 255, backalpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end