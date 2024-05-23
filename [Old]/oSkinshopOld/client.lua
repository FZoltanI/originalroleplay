setElementData(localPlayer,"skinshop>hasruha",false)
setElementData(localPlayer,"skinshop>selected_skin>id",false)
setElementData(localPlayer,"skinshop>selected_skin>price",false)
setElementData(localPlayer,"skinshop>selected_skin>name",false)

local sx,sy = guiGetScreenSize()
local myX, myY = 1600, 900

local incol = false 
local colType = 1

local panelShowing = false
local tabladarab = 0 

local color, r, g, b = exports.cl_core:getServerColor()

function createSkinTables()
    for k, v in ipairs(skinTables) do
        local obj = createObject(2387, v[2], v[3], v[4]-1, 0, 0, v[5]);
        setElementData(obj, "skintable>type", v[1]);

        local col = createColSphere(v[2],v[3],v[4],1.7)
        setElementData(col, "skintableCol>type", v[1])
        --attachElements(col, obj)
    end
end
function createShopCounters()
    for k, v in ipairs(counters) do
        local obj = createObject(2626, v[1], v[2], v[3]-0.5, 0, 0, v[4]);
        setElementData(obj, "skinshopCounter", true);

        local ped = createPed(eladoSkins[math.random(#eladoSkins)], v[1], v[2], v[3], v[5])
        setElementData(ped,"ped:name","Carlos")
        setElementData(ped,"ped:prefix","Ruhaeladó")

        local col = createColSphere(v[1],v[2],v[3],1.7)
        setElementData(col, "skinshopCounterCol", true)

        attachElements(ped, obj, 0, 0.8, 0.5)
        --attachElements(col, obj)
    end
end
function createTestRooms()
    for k, v in ipairs(testRooms) do 
        local col = createColCuboid(v[1],v[2],v[3]-1,1,1,2.5)
        setElementData(col,"skinshoptetsroom",true)
    end
end
createSkinTables()
createShopCounters()
createTestRooms()

local male = dxCreateTexture("files/male.png")
local female = dxCreateTexture("files/female.png")

addEventHandler("onClientRender",root,
    function()
        for k,v in ipairs(skinTables) do 
            local pX,pY,pZ = getElementPosition(localPlayer)
            local mX,mY,mZ = v[2], v[3], v[4]

            local animTime = 1000

            if getDistanceBetweenPoints3D(pX,pY,pZ,mX,mY,mZ) < 60 then 
                if v[1] == 1 then 
                    dxDrawMaterialLine3D(mX, mY, mZ+1+1,mX, mY, mZ+1,male, 1, tocolor( 50, 123, 168, 200))
                elseif v[1] == 2 then       
                    dxDrawMaterialLine3D(mX, mY, mZ+1+1,mX, mY, mZ+1,female, 1, tocolor(199, 88, 191, 200))
                end 
            end
        end

    end 
)

setDevelopmentMode(true)

local font = fontS:getFont("roboto",15)

function interactionWithTables()
    if not panelShowing then 
        panelShowing = true 
        setElementFrozen(localPlayer, true)
        tabladarab = 0 
    else
        panelShowing = false 
        setElementFrozen(localPlayer, false)
    end
end

function ruhaProba()
    local oldSkinId = getElementModel(localPlayer)
    local newSkinId = getElementData(localPlayer,"skinshop>selected_skin>id")
    setElementModel(localPlayer,newSkinId)
    setElementFrozen(localPlayer, true)

    setTimer(function() 
        setElementModel(localPlayer, oldSkinId)
        setElementFrozen(localPlayer, false)
    end, 5000, 1)
end

function buySelectedSkin()
    local skinId = getElementData(localPlayer,"skinshop>selected_skin>id")
    local skinPrice = getElementData(localPlayer,"skinshop>selected_skin>price")
    local skinName = getElementData(localPlayer,"skinshop>selected_skin>name")
end

addEventHandler("onClientColShapeHit", getRootElement(), 
    function(element, mdim)
        if element == localPlayer then 
            if mdim then
                local tableType = getElementData(source, "skintableCol>type") or 0
                if tableType > 0 then
                    outputChatBox(tableType) 
                    incol = true 
                    colType = getElementData(source, "skintableCol>type")
                    bindKey("e", "up", interactionWithTables)
                elseif getElementData(source, "skinshopCounterCol") then 
                    colType = 3
                    bindKey("e", "up", buySelectedSkin)
                elseif getElementData(source, "skinshoptetsroom") then 
                    colType = 4
                    bindKey("e", "up", ruhaProba)
                end
            end 
        end
    end 
)

addEventHandler("onClientColShapeLeave", root, 
    function(element, mdim)
        if mdim then 
            if getElementData(source, "skintableCol>type") or getElementData(source, "skinshopCounterCol") or getElementData(source, "skinshoptetsroom") then 
                incol = false 
                colType = 0
                unbindKey("e", "up", interactionWithTables)
                unbindKey("e", "up", ruhaProba)
                unbindKey("e", "up", buySelectedSkin)
            end
        end 
    end 
)

addEventHandler("onClientRender", root, 
    function()
        if incol then 
            shadowedText("Interakcióhoz nyomd meg az "..color.."'E' #ffffffgombot. ", 0, 0, sx, sy/1.1, tocolor(255,255,255,255), myX/sx, font, "center", "bottom")
        end

        if colType == 4 then 
            if getElementData(localPlayer,"skinshop>hasruha") then 
                shadowedText("A ruha felpróbálásához nyomd meg az "..color.."'E' #ffffffgombot. ", 0, 0, sx, sy/1.1, tocolor(255,255,255,255), myX/sx, font, "center", "bottom")
            else
                shadowedText("Nincs nállad felprübálható ruha! \n ( A polcokról vehetsz le ruhákat )", 0, 0, sx, sy/1.1, tocolor(255,30,50,255), myX/sx, font, "center", "bottom")
            end
        end

        if colType == 3 then 
            if getElementData(localPlayer,"skinshop>hasruha") then 
                shadowedText("A ruha megvásárlásához nyomd meg az "..color.."'E' #ffffffgombot. ", 0, 0, sx, sy/1.1, tocolor(255,255,255,255), myX/sx, font, "center", "bottom")
            else
                shadowedText("Nincs nállad megvásárolható ruha! \n ( A polcokról vehetsz le ruhákat )", 0, 0, sx, sy/1.1, tocolor(255,30,50,255), myX/sx, font, "center", "bottom")
            end
        end

        if panelShowing then 
            if colType == 1 or colType == 2 then 
                --dxDrawRectangle(sx*0.835, sy*0.38, sx*0.16, sy*0.175, tocolor(25,25,25,255))
                for i = 1, 4 do 
                    dxDrawRectangle(sx*0.84,sy*0.35+(i*(sy*0.04)),sx*0.15,sy*0.035,tocolor(30,30,30,255))
                    dxDrawText(skins[colType][i+tabladarab][1],sx*0.842,sy*0.35+(i*(sy*0.04)),sx*0.842+sx*0.15,sy*0.35+(i*(sy*0.04))+sy*0.035, tocolor(255,255,255,230), 0.6/myX*sx, font, "left", "center")
                    dxDrawImage(sx*0.815,sy*0.35+(i*(sy*0.04)),sx*0.02625,sy*0.046,"files/tag.png")
                    dxDrawText(skins[colType][i+tabladarab][3],sx*0.815,sy*0.35+(i*(sy*0.04)),sx*0.815+sx*0.02625,sy*0.35+(i*(sy*0.04))+sy*0.046, tocolor(255,30,30,255), 0.45/myX*sx, font, "center", "center", false, false, false, true, false, 315)


                    if core:isInSlot(sx*0.84,sy*0.35+(i*(sy*0.04)),sx*0.15,sy*0.035) then 
                        core:dxDrawOutLine(sx*0.84,sy*0.35+(i*(sy*0.04)),sx*0.15,sy*0.035, tocolor(r,g,b),1)
                    end
                end
            end
        end
    end
)

addEventHandler("onClientKey", root, function(key, state)
    if state then 
        if panelShowing then
            if core:isInSlot(sx*0.835, sy*0.38, sx*0.16, sy*0.175) then 
                if key == "mouse_wheel_down" then 
                    if tabladarab+4 < #skins[colType] then 
                        tabladarab = tabladarab + 1
                    end
                end
                if key == "mouse_wheel_up" then 
                    if tabladarab > 1 then 
                        tabladarab = tabladarab - 1
                    end
                end
            end

            if key == "mouse1" then 
                for i = 1, 4 do 
                    if core:isInSlot(sx*0.84,sy*0.35+(i*(sy*0.04)),sx*0.15,sy*0.035) then 
                        outputChatBox(skins[colType][i+tabladarab][1])
                        createSkinsObject(skins[colType][i+tabladarab][1],skins[colType][i+tabladarab][2],skins[colType][i+tabladarab][3])
                    end
                end
            end
        end
    end
end)

function createSkinsObject(name,id,price)
    setElementData(localPlayer,"skinshop>selected_skin>id",id)
    setElementData(localPlayer,"skinshop>selected_skin>price",price)
    setElementData(localPlayer,"skinshop>selected_skin>name",name)
    setElementData(localPlayer,"skinshop>hasruha",true)
    triggerServerEvent("createSkinObject", getResourceRootElement(), localPlayer)
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,rot)
	if not rot then 
		rot = 0 
	end
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true, false ,rot )
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true, false, rot) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true,false,rot)
end