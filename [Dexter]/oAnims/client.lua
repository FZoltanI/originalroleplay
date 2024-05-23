function stopAnim()
 if getElementData(localPlayer,"player:animation") then 
  if getElementData(localPlayer, "cuff:usePlayer") then return end
  if not (getElementData(localPlayer, "tired") or getElementData(localPlayer, "mushroom:mushroomPickingUp")) then 
    triggerServerEvent("animation > playAnim", resourceRoot, _, _, _, _, false)
  end
 end 
end 
addCommandHandler("stopAnim",stopAnim) 
addCommandHandler("stopanim",stopAnim) 
addCommandHandler("StopAnim",stopAnim) 

bindKey("space","down",stopAnim)

function listAnims()
  outputChatBox(core:getServerPrefix("server", "Animációk", 2).."/daps(1-2), /heil, /salute, /dance(1-10), /strip(1-2), /sit(1-5),",255,255,255,true)
  outputChatBox("/lay(1-2), /gsign(1-5), /rap(1-3), /cry, /puke, /vomit, /shove, /dive,",255,255,255,true)
  outputChatBox("/laugh, /plant, /grab, /putdown, /cpr, /slapass, /bitchslap,",255,255,255,true)
  outputChatBox("/cheer(1-3), /fixcar, /startrace, /carchat, /copcome, /handsup(1-2),",255,255,255,true)
  outputChatBox("/carphone(1-2), /fixing, /crack(1-4), /leanleft, /copaway, ",255,255,255,true)
  outputChatBox("/copleft, /copstop, /shake, /lean, /idle, /piss, /wank, /wait, /tired, /fallfront, /fall, /think,",255,255,255,true)
  outputChatBox("/shocked, /cover, /smoke(1-3), /smokelean, /lightup, /drag,",255,255,255,true)
  outputChatBox("/aim(1-2), /hailtaxi, /hailcab, /crouch, /crouchcome, /surrender,",255,255,255,true)
  outputChatBox("/fu(1-2), /scratch, /beg, /what, /photograph, /mourn, /roadcross(1-3)",255,255,255,true)
end
addCommandHandler("anims",listAnims)
addCommandHandler("Anims",listAnims)

function bindAnims()
  for k, v in ipairs(animations) do 
    --outputChatBox(v[1])
    addCommandHandler(v[1], function()
      if getElementData(localPlayer, "user:aduty") then return end
      if getElementData(localPlayer, "cuff:usePlayer") then return end
      if getPedOccupiedVehicle(localPlayer) then return end
      if not (getElementData(localPlayer, "tired") or getElementData(localPlayer, "mushroom:mushroomPickingUp")) then 
        --outputChatBox(v[2])
        triggerServerEvent("animation > playAnim", resourceRoot, v[2], v[3], v[4], v[5], true)
      end
    end)
  end
end
bindAnims()

engineLoadIFP("custom/dealer.ifp", "originalRPCustomAnims") --/ copidle
engineLoadIFP("custom/gangs.ifp", "originalRPCustomAnims2") --/leanidle
engineLoadIFP("custom/ped.ifp", "originalRPCustomAnims3") --/handsup2
engineLoadIFP("custom/dab.ifp", "originalRPCustomAnims4") --/handsup2
engineLoadIFP("custom/tarko.ifp", "originalRPCustomAnims5") --/handsup2
engineLoadIFP("custom/camera.ifp", "originalRPCustomAnims6") --/handsup2
engineLoadIFP("custom/cop_ambient.ifp", "originalRPCustomAnims7") --/handsup2
engineLoadIFP("custom/rapping.ifp", "originalRPCustomAnims8") --/handsup2



function setCustomAnimation(player, ...)
  setPedAnimation(player, unpack(...))
end

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName)
  if getElementType(source) == "player" then 
    if getElementData(source, "user:loggedin") then 
      if dataName == "customAnimations" then 
        if getElementData(source, dataName) then
          setCustomAnimation(source, getElementData(source, dataName))
        end
      end
    end
  end
end)

local screenX, screenY = guiGetScreenSize()
local panelW, panelH = 700,335
local panelX, panelY = screenX/2 - panelW/2, screenY/2 - panelH/2
local startTick = getTickCount()
local currentOffset = 0

local font = dxCreateFont("Roboto.ttf", 14)

local animDesc = {
  ["fall"] = "Háton fekvés a földön, széttárt kezekkel és lábakkal",
  ["fallfront"] = "Hason fekvés a földön, széttárt kezekkel és lábakkal",
  ["what"] = "Kezek felemelése ismételve, majd lépegetés egy helyben",
  ["dive"] = "Előre vetődés a földön, majd hason fekve maradás",
  ["shocked"] = "Meglepődés, majd a kéz szájra tétele és úgy maradás",
  ["bitchslap"] = "Örömlányás verés a földre térdelve, kéz csapkodással",
  ["shove"] = "Legugolás majd az ajtónak feszülés oldalasan",
  ["grabbottle"] = "Üveg kivétele a pult alól, láb felemeléssel",
  ["tired"] = "Kezek térde tétele, madj enyhén előre dőlve kifáradás",
  ["carchat"] = "Enyhén előre dőlés, majd kéz kocsira tétele és beszéd",
  ["startrace"] = "Bal kéz felemelése, majd verseny indítása lecsapással",
  ["laugh"] = "Jobb kéz meglendítése, majd hosszas nevetés/röhögés",
  ["drag"] = "Jobb kéz szájra tétele majd cigaretta/egyéb szívás",
  ["smokelean"] = "Falnak dőlés, majd bal kézzel cigaretta szívás",
  ["aim"] = "Jobb kézzel előre célzás, majd úgy maradás",
  ["aim2"] = "Horgász animáció",
  ["hailcab"] = "Stoppolás",
  ["crouchcome"] = "Gugolás és magad fele terelés",
  ["surrender"] = "Kéz feltétel mind 2 kéz",
  ["puke"] = "Oldalra fordulás, majd rókázás előre dőlve",
  ["cry"] = "Bal kéz arcra tétele, majd hosszas sírás",
  ["mourn"] = "Fej előre lógatása, majd gyászolás",
  ["beg"] = "Viszakozás valamitől, majd kézfeltétel",
  ["drink"] = "Jobb kézzel való ivás majd abbahagyás",
  ["heil"] = "Bal kéz kiemelése a magasba majd úgy maradás",
  ["lightup"] = "Öngyűjtó gyújtás bal és jobb kézzel",
  ["fu"] = "Bemutatás az adott félnek jobb kézzel",
  ["fu2"] = "Bemutatás az adott félnek jobb kézzel",
  ["photograph"] = "Fényképezés",
  ["vomit"] = "Hányás",
  ["plant"] = "El ültetés",
  ["grab"] = "Felvesz valamit a földről",
  ["putdown"] = "Lerak valamit a földre",
  ["roadcross"] = "Jobbra balra figyelés",
  ["roadcross2"] = "Jobbra balra figyelés",
  ["roadcross3"] = "Jobbra balra figyelés",
  ["scratch"] = "Nemi szerv vakargatás jobb és bal kézzel",
  ["hailtaxi"] = "Gépjármű stoppolás jobb kézzel, kissé elhajolva",
  ["handsup"] = "Kezek feltétele fej mellé, majd úgy maradás",
  ["handsup2"] = "Kezek feltétele fej mellé, majd úgy maradás",
  ["leanidle"] = "Falnak dőlés csípőre tett kézzel",
  ["copidle"] = "Magad előtt össze kulcsolt kézzel körbe tekintés",
  ["fixcar"] = "Gépjármű alá befekés háton, majd szerelése",
  ["slapass"] = "Fenékre csapás bal kézzel kisebb erővel",
  ["wank"] = "Maszturbáció jobb kézzel kissé begörnyedve",
  ["piss"] = "Pisilés jobb kézzel, széttárt lábakkal",
  ["idle"] = "Várakozás, jobb kézzel ismétlődő fejbiccentéssel",
  ["lean"] = "Falnak dőlés csípőre tett bal kézzel",
  ["leanleft"] = "Falnak dőlés csípőre tett jobb kézzel és a bal lábbal keresztezve",
  ["shake"] = "Várakozás, mind a két kézzel csipőre téve ismételve",
  ["think"] = "Gondolkodás kezeit egymásra téve ismételve",
  ["wait"] = "Egyszerű várakozás, összekulcsolt kezekkel",
  ["copstop"] = "Gépjárműnek való 'megálj'-jelzés előröl, ismételve",
  ["copleft"] = "Gépjárműn átirányítása bal oldalra ismételve",
  ["copcome"] = "Gépjárműnek való haladás engedélyezés ismételve",
  ["copaway"] = "Gépjármű elküldése az adott helyszínről",
  ["cpr"] = "Újraélesztés összekulcsolt kezekkel, letérdeve",
  ["crouch"] = "Gugolás",
  ["cover"] = "Legugolva, védi a fejét tarkóra tett kézzel",
  ["daps"] = "Kezelés az adott féllel ismételve",
  ["daps2"] = "Kezelés az adott féllel magadhoz húzva az illetőt",
  ["salute"] = "Tisztelgés",
  ["walk"] = "Sétálás megállás nélkül",
  ["win"] = "Győzelem nyilvánítás/kikiáltás",
  ["bat"] = "Baseball ütő megtartása/lengetése",
  ["sit"] = "Leülés",
  ["sit2"] = "Leülés",
  ["sit3"] = "Leülés",
  ["sit4"] = "Leülés",
  ["sit5"] = "Leülés",
  ["strip"] = "Sztriptíz tánc a földön/állva",
  ["strip2"] = "Sztriptíz tánc a földön/térdelve",
  ["lay"] = "Földön fekvés nyugalmi állapotban",
  ["lay2"] = "Földön fekvés nyugalmi állapotban",
  ["cheer"] = "Éljenezés az adott szituációnak",
  ["dance"] = "Táncolás",
  ["dance2"] = "Táncolás",
  ["dance3"] = "Táncolás",
  ["dance4"] = "Táncolás",
  ["dance5"] = "Táncolás",
  ["dance6"] = "Táncolás",
  ["dance7"] = "Táncolás",
  ["dance8"] = "Táncolás",
  ["dance9"] = "Táncolás",
  ["dance10"] = "Táncolás",
  ["crack"] = "Önkívületi állapot kimutatása",
  ["crack2"] = "Önkívületi állapot kimutatása",
  ["crack3"] = "Önkívületi állapot kimutatása",
  ["crack4"] = "Önkívületi állapot kimutatása",
  ["gsign"] = "Két kézzel való gesztikulálás",
  ["gsign2"] = "Két kézzel való gesztikulálás",
  ["gsign3"] = "Két kézzel való gesztikulálás",
  ["gsign4"] = "Két kézzel való gesztikulálás",
  ["gsign5"] = "Két kézzel való gesztikulálás",
  ["rap"] = "Rappelés az adott szituációban",
  ["rap2"] = "Rappelés az adott szituációban",
  ["rap3"] = "Rappelés az adott szituációban",
  ["cheer"] = "Éljenzés",
  ["cheer2"] = "Éljenzés",
  ["cheer3"] = "Éljenzés",
  ["carphone"] = "Kocsiban telefonálás",
  ["carphone2"] = "Kocsiban telefonálás",
  ["fixing"] = "Javítás",
  ["smoke"] = "Cigarettázás", 
  ["smoke2"] = "Cigarettázás", 
  ["smoke3"] = "Cigarettázás", 
  ["surrender"] = "Térdelés hátratett kezekkel", 
  ["surrender2"] = "Félelemtől összekuporodva a kezedet a tarkódra helyezed", 
  ["surrender3"] = "Tarkóra teszi a kezét", 
  ["sign"] = "Crip Gang Sign", 
  ["sign2"] = "Crip Gang Sign2", 




}

setElementData(localPlayer, "customAnimations", false)

local favList = {}

local font = false
local panelState = false
local animState = "show"
local hex, r,g,b = exports["oCore"]:getServerColor()
local selectedMenu = 1

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()), function()
  data = jsonGET("favorites")
  --outputChatBox()
  favList = data
  --outputChatBox(#favList)
end)

local mainCategory = {
  {"Táncolás"},
  {"Bandás"},
}

bindKey("F2","down", function()
  if getElementData(localPlayer, "user:loggedin") then
    if isTimer(theTimer) then return end
    panelState = not panelState
    if panelState then 
      animState = "show"
      --selectedMenu = 1
      startTick = getTickCount()
      animationList = {}
      for k,v in pairs(animations) do 
        --outputChatBox(v[1])
        table.insert(animationList, {v[1]})
      end
      hex, r,g,b = exports["oCore"]:getServerColor()
      font = dxCreateFont("Roboto.ttf", 14)
      addEventHandler("onClientRender",getRootElement(), drawAnimPanel, true, "low-999")
      addEventHandler("onClientCharacter", getRootElement(), animationCharacter)
      addEventHandler("onClientClick", getRootElement(), animationClick)
      addEventHandler("onClientKey",getRootElement(), animationsKey)
    else
      animState = "hide"
      startTick = getTickCount()
    -- removeEventHandler("onClientRender",getRootElement(), drawAnimPanel)
    end
    theTimer = setTimer(function() end, 500, 1)
  end
end)

function drawAnimPanel()
  --if getPlayerSerial(localPlayer) == "8B23EC8A49888EB7A5778CE0AF7D88A2" or getPlayerSerial(localPlayer) == "2D565C706DC4646D99D06A8D68A53BE3" then 
    buttons = {}
    local nowTick = getTickCount()
    
    if animState == "show" then
      local progress = (nowTick - startTick) / 250
      if progress < 1 then
        alpha = interpolateBetween(
          0, 0, 0,
          1, 0, 0,
          progress, "Linear"
        )
      else
        alpha = 1
        progress = 1 
      end
     -- outputChatBox(progress)
    elseif animState == "hide" then
      local progress = (nowTick - startTick) / 250
      if progress < 1 then
        alpha = interpolateBetween(
          1, 0, 0,
          0, 0, 0,
          progress, "Linear"
        )
      else
        --animState =
        alpha = 0
        progress = 1
      end
      --outputChatBox(progress)
      if progress >= 1 then 
      
        removeEventHandler("onClientRender",getRootElement(), drawAnimPanel)
        removeEventHandler("onClientCharacter", getRootElement(), animationCharacter)
        removeEventHandler("onClientClick", getRootElement(), animationClick)
        removeEventHandler("onClientKey",getRootElement(), animationsKey)
        panelState = false
        selectedInput = false
      end
    end
      dxDrawRectangle(panelX, panelY-30, panelW, 30, tocolor(32, 32, 32,255*alpha))
      dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(32, 32, 32,150*alpha))
      if getElementData(localPlayer, "player:animation") then 
        if activeButton == "stopAnim" then 
          dxDrawText("Animáció leállítása", panelX, panelY, panelX + panelW - 35, panelY - 30, tocolor(r,g,b,255*alpha), 0.85, font, "right", "center")
          dxDrawImageSection(panelX + panelW - 24 - 5, panelY - 28, 24, 24, 0, 7, 261, 250, "files/img/stop.png", 0, 0, 0, tocolor(r, g, b,255*alpha))
        else 
          dxDrawText("Animáció leállítása", panelX, panelY, panelX + panelW - 35, panelY - 30, tocolor(255,255,255,255*alpha), 0.85, font, "right", "center")
          dxDrawImageSection(panelX + panelW - 24 - 5, panelY - 28, 24, 24, 0, 7, 261, 250, "files/img/stop.png", 0, 0, 0, tocolor(255, 255, 255,255*alpha))
        end
        --dxDrawRectangle(panelX + panelW - 180 - 5, panelY - 28, 180, 24, tocolor(255, 0, 0, 150))

        buttons["stopAnim"] = {panelX + panelW - 180 - 5, panelY - 28, 180, 24}
      end
      --if isInSlot(panelX + 5, panelY - 28, 24, 24) then 
      --dxDrawRectangle(panelX-110, panelY, 200, panelH, tocolor(0,0,0,150))

      dxDrawText("Original Roleplay - Animpanel", screenX/2, panelY, screenX/2, panelY - 30, tocolor(255,255,255,255*alpha), 0.85, font, "center", "center")
      if selectedMenu == 1 then 
        if activeButton == "favorites" then
          create_tooltip("Kedvencek")
          dxDrawImageSection(panelX + 5, panelY - 28, 24, 24, 0, 7, 261, 250, "files/img/starfull.png", 0, 0, 0, tocolor(r,g,b,255*alpha))
        else
          dxDrawImageSection(panelX + 5, panelY - 28, 24, 24, 0, 7, 261, 250, "files/img/star.png", 0, 0, 0, tocolor(255,255,255,255*alpha))
        end
        buttons["favorites"] = {panelX + 5, panelY - 28, 24, 24}
        local x,y = panelX,panelY
        for k = 1, 10 do 
          local v = animationList[k + currentOffset]
          if v then
            if k%2 == 1 then 
              if activeButton == "anims:"..k + currentOffset..":"..v[1] then 
                dxDrawRectangle(x,y+5, panelW, 32, tocolor(r,g,b, 150*alpha))
              else 
                dxDrawRectangle(x,y+5, panelW, 32, tocolor(20, 20, 20, 150*alpha))
              end
            else
              if activeButton == "anims:"..k + currentOffset..":"..v[1] then 
                dxDrawRectangle(x,y+5, panelW, 32, tocolor(r,g,b, 150*alpha))
              else 
                dxDrawRectangle(x,y+5, panelW, 32, tocolor(32, 32, 32, 150*alpha))
              end
            end
            buttons["anims:".. k + currentOffset..":"..v[1]] = {x,y+5, panelW - 24 - 24, 32}

            if activeButton == "addFav:"..k + currentOffset then
              dxDrawImageSection(x + panelW - 24 - 5, y+8, 24, 24, 0, 7, 261, 250, "files/img/star.png", 0, 0, 0, tocolor(r,g,b,255*alpha))
            else 
              if table.find(favList, v[1]) then 
                dxDrawImageSection(x + panelW - 24 - 5, y+8, 24, 24, 0, 7, 261, 250, "files/img/starfull.png", 0, 0, 0, tocolor(r,g,b,255*alpha))
              else
                dxDrawImageSection(x + panelW - 24 - 5, y+8, 24, 24, 0, 7, 261, 250, "files/img/star.png", 0, 0, 0, tocolor(255,255,255,255*alpha))
              end
            end
            buttons["addFav:"..k + currentOffset] = {x + panelW - 24 - 5, y+8, 24, 24}
            dxDrawText("/"..v[1] .." - " .. (animDesc[v[1]] or "ismeretlen"), x + 5, y+ 5, x + 5, y + 32 + 5,tocolor(255,255,255,255*alpha),0.75, font, "left", "center")
          end
          y = y + 32 + 1
        end
        local sy = (panelH) / 10
        if #animationList > 10 then 
          local listSize = sy * 10
          dxDrawRectangle(panelX + panelW + 3, panelY-2, 5, listSize, tocolor(32, 32, 32, 255*alpha))
          dxDrawOuterBorder(panelX + panelW + 3, panelY-2, 5, listSize,1,tocolor(32,32,32,255*alpha))
          dxDrawRectangle(panelX + panelW + 3, panelY - 2 + (listSize / #animationList) * math.min(currentOffset, #animationList - 10), 5, (listSize / #animationList) * 10, tocolor(r,g,b, 255*alpha))
        end
      -- dxDrawRectangle(panelX,panelY + panelH +10, 200, 25, tocolor(32, 32, 32, 160*alpha))
        drawInput("search|20", "Keresés", panelX, panelY + panelH + 10, 200, 25, font, 0.85, tocolor(32, 32, 32, 160*alpha), alpha)
    elseif selectedMenu == 2 then 
      if activeButton == "favoritesBack" then
        create_tooltip("Vissza")
        dxDrawImageSection(panelX + 5, panelY - 28, 24, 24, 0, 7, 261, 250, "files/img/starfull.png", 0, 0, 0, tocolor(r,g,b,255*alpha))
      else
        dxDrawImageSection(panelX + 5, panelY - 28, 24, 24, 0, 7, 261, 250, "files/img/star.png", 0, 0, 0, tocolor(255,255,255,255*alpha))
      end
      buttons["favoritesBack"] = {panelX + 5, panelY - 28, 24, 24}
      if #favList > 0 then
        local x,y = panelX,panelY
        for k = 1, 10 do 
          local v = favList[k + currentOffset]
          if v then 
            if k%2 == 1 then 
              if activeButton == "anims:"..k + currentOffset .. ":"..v[1] then 
                dxDrawRectangle(x,y+5, panelW, 32, tocolor(r,g,b, 150*alpha))
              else 
                dxDrawRectangle(x,y+5, panelW, 32, tocolor(20, 20, 20, 150*alpha))
              end
            else
              if activeButton == "anims:"..k + currentOffset .. ":"..v[1] then 
                dxDrawRectangle(x,y+5, panelW, 32, tocolor(r,g,b, 150*alpha))
              else 
                dxDrawRectangle(x,y+5, panelW, 32, tocolor(32, 32, 32, 150*alpha))
              end
            end
            buttons["anims:".. k + currentOffset..":"..v[1]] = {x,y+5, panelW - 24 - 24, 32}
            dxDrawText("/"..v[1] .." - " .. (animDesc[v[1]] or "ismeretlen"), x + 5, y+ 5, x + 5, y + 32 + 5,tocolor(255,255,255,255*alpha),0.75, font, "left", "center")
            if activeButton == "removeFav:"..k + currentOffset then
              dxDrawImageSection(x + panelW - 24 - 5, y+8, 24, 24, 0, 7, 261, 250, "files/img/starfull.png", 0, 0, 0, tocolor(r,g,b,255*alpha))
            else 
              dxDrawImageSection(x + panelW - 24 - 5, y+8, 24, 24, 0, 7, 261, 250, "files/img/starfull.png", 0, 0, 0, tocolor(255,255,255,255*alpha))
            end
            buttons["removeFav:"..k + currentOffset] = {x + panelW - 24 - 5, y+8, 24, 24}
          end
          y = y + 32 + 1
        end
        local sy = (panelH) / 10
        if #favList > 10 then 
          local listSize = sy * 10
          dxDrawRectangle(panelX + panelW + 3, panelY-2, 5, listSize, tocolor(32, 32, 32, 255*alpha))
          dxDrawOuterBorder(panelX + panelW + 3, panelY-2, 5, listSize,1,tocolor(32,32,32,255*alpha))
          dxDrawRectangle(panelX + panelW + 3, panelY - 2 + (listSize / #favList) * math.min(currentOffset, #favList - 10), 5, (listSize / #favList) * 10, tocolor(r,g,b, 255*alpha))
        end
      else
        dxDrawText("Nincs egyetlen kedvenc animáció kiválasztva!",screenX/2, panelY, screenX/2, panelY + 150,tocolor(255,255,255,255*alpha),0.75, font, "center", "center")
      end
    end

    local relX, relY = getCursorPosition()

		activeButton = false

		if relX and relY then
			relX = relX * screenX
			relY = relY * screenY

			for k, v in pairs(buttons) do
				if relX >= v[1] and relX <= v[1] + v[3] and relY >= v[2] and relY <= v[2] + v[4] then
					activeButton = k
					break
				end
			end
		end
  --end
end

function isInSlot(rectX, rectY, rectW, rectH)
  if isCursorShowing() then
    local cursorX, cursorY = getCursorPosition()
    local cursorX, cursorY = cursorX * screenX, cursorY * screenY
    return (cursorX >= rectX and cursorX <= rectX+rectW) and (cursorY >= rectY and cursorY <= rectY+rectH)
  end
end

function animationsKey(key, state)
  if key == "mouse_wheel_down" and currentOffset < #animationList - 10 and selectedMenu == 1 then 
    currentOffset = currentOffset + 10
  elseif key == "mouse_wheel_up" and currentOffset > 0 and selectedMenu == 1 then 
    currentOffset = currentOffset - 10  
  elseif key == "mouse_wheel_down" and currentOffset < #favList - 10 and selectedMenu == 2 then 
    currentOffset = currentOffset + 10
  elseif key == "mouse_wheel_up" and currentOffset > 0 and selectedMenu == 2 then 
    currentOffset = currentOffset - 10
  elseif key == "backspace" and selectedInput and state and isCursorShowing() then 
    cancelEvent()
    if utf8.len(fakeInputs[selectedInput]) >= 1 then
      fakeInputs[selectedInput] = utf8.sub(fakeInputs[selectedInput], 1, -2)

      searchAnim()
    end
  end
end


function jsonGET(file, private, defData)
	if private then
		file = file..".json"
	else
		file = file..".json"
	end
	local fileHandle
	local jsonDATA = {}
	if not fileExists(file) then
		return defData or {}
	else
		fileHandle = fileOpen(file)
	end
	if fileHandle then
		local buffer
		local allBuffer = ""
		while not fileIsEOF(fileHandle) do
			buffer = fileRead(fileHandle, 500)
			allBuffer = allBuffer..buffer
		end
		jsonDATA = fromJSON(allBuffer)
		fileClose(fileHandle)
	end
	return jsonDATA
end

function jsonSAVE(file, data, private)
	if private then
		file = file..".json"
	else
		file = file..".json"
	end
	if fileExists(file) then
		fileDelete(file)
	end
	local fileHandle = fileCreate(file)
	fileWrite(fileHandle, toJSON(data))
	fileFlush(fileHandle)
	fileClose(fileHandle)
	return true
end

addEventHandler("onClientResourceStop",getResourceRootElement(getThisResource()), function()
  jsonSAVE("favorites", favList, false)
end)

function removeHex (text)
  return type(text)=="string" and string.gsub(text, "#%x%x%x%x%x%x", "") or text
end

function create_tooltip(text)
  if isCursorShowing() then
    local cx, cy = getCursorPosition()
    cx, cy = cx * screenX, cy * screenY
    if text then
      local textWidth = dxGetTextWidth(removeHex(text), 0.85, font)
          dxDrawRectangle(cx, cy, textWidth+5, 50, tocolor(0, 0, 0, 180), true)
          dxDrawText(text, cx, cy,cx + textWidth+5, cy+50 , tocolor(255, 255, 255, 255), 0.85, font, "center", "center", false, false, true, true)
    end
	end
end

function dxDrawOuterBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)
	
	dxDrawRectangle(x - borderSize, y - borderSize, w + (borderSize * 2), borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x - borderSize, y, borderSize, h + borderSize, borderColor, postGUI)
	dxDrawRectangle(x + w, y, borderSize, h + borderSize, borderColor, postGUI)
end

function animationClick(button,state)
  selectedInput = false
  guiSetInputMode("allow_binds")
  if activeButton then
    if button == "left" and state == "up" then 
      if string.find(activeButton, "input") then
				selectedInput = string.gsub(activeButton, "input:", "")
        --outputChatBox(tostring(selectedInput))
        guiSetInputMode("no_binds")
			end
      local data = split(activeButton, ":")
      if data[1] == "anims" then 
        if getElementData(localPlayer, "user:aduty") then return end
        if getElementData(localPlayer, "cuff:usePlayer") then return end
        if getPedOccupiedVehicle(localPlayer) then return end
        if not (getElementData(localPlayer, "tired") or getElementData(localPlayer, "mushroom:mushroomPickingUp")) then 
          --outputChatBox(data[3])
          if isTimer(theTimer) then return end
          executeCommandHandler(data[3])
          theTimer = setTimer(function() end, 500, 1)
        end
      elseif data[1] == "addFav" then 
        local id = data[2]
        if table.find(favList, animationList[tonumber(data[2])][1]) then
          outputChatBox(hex .. "[OriginalRoleplay]#FFFFFF Ez az animáció már a kedvencekhez lett adva!",255,255,255,true)
          return
        end
        outputChatBox(hex .. "[OriginalRoleplay]#FFFFFF Sikeresen hozzáadta a kiválasztott elemet a kedvencekbe!",255,255,255,true)
        table.insert(favList, {animationList[tonumber(data[2])][1], true})
      elseif data[1] == "favorites" then 
        selectedMenu = 2    
        currentOffset = 0  
      elseif data[1] == "favoritesBack" then 
        selectedMenu = 1   
        currentOffset = 0  
      elseif data[1] == "stopAnim" then 
        if getElementData(localPlayer, "player:animation") then 
          if getElementData(localPlayer, "cuff:usePlayer") then return end
          if not (getElementData(localPlayer, "tired") or getElementData(localPlayer, "mushroom:mushroomPickingUp")) then 
            triggerServerEvent("animation > playAnim", resourceRoot, _, _, _, _, false)
          end
        end
      elseif data[1] == "removeFav" then 
        local id = data[2]
        outputChatBox(hex .. "[OriginalRoleplay]#FFFFFF Sikeresen eltávolítottad a kedvencekből!",255,255,255,true)
        table.remove(favList,id)
      end
    end
  end
end


function animationCharacter(character)
  if isCursorShowing() and selectedInput then 
    local selected = split(selectedInput, "|")
    if utf8.len(fakeInputs[selectedInput]) < tonumber(selected[2]) then
      fakeInputs[selectedInput] = fakeInputs[selectedInput] .. character
      searchAnim()
      --cancelEvent()
      
    end
  end
end


function searchAnim()
  animationList = {}
  if utf8.len(fakeInputs[selectedInput]) < 1 then
		for k, v in pairs(animations) do
			table.insert(animationList, {v[1]})
		end
	else
		for k, v in pairs(animations) do
			if utf8.find(utf8.lower(v[1]), utf8.lower(fakeInputs[selectedInput])) or utf8.find(utf8.lower(animDesc[v[1]]), utf8.lower(fakeInputs[selectedInput])) then
        --outputChatBox(v[1])
        	table.insert(animationList, {v[1]})
			end
		end
	end
  currentOffset = 0
end

buttons = {}
activeButton = false

local inputLineGetStart = {}
local inputLineGetInverse = {}
local inputCursorState = false
local lastChangeCursorState = 0
local repeatTimer = false
local repeatStartTimer = false
fakeInputs = {}
selectedInput = false

function drawInput(key, label, x, y, sx, sy, font, fontScale, color, a)
 -- a = a or 1

  if not fakeInputs[key] then
    fakeInputs[key] = ""
  end

  dxDrawRectangle(x, y, sx, sy, color)

  if selectedInput == key then
    if not inputLineGetStart[key] then
      inputLineGetInverse[key] = false
      inputLineGetStart[key] = getTickCount()
    end
  elseif inputLineGetStart[key] then
    inputLineGetInverse[key] = getTickCount()
    inputLineGetStart[key] = false
  end

  local lineProgress = 0

  if inputLineGetStart[key] then
    local elapsedTime = getTickCount() - inputLineGetStart[key]
    local progress = elapsedTime / 300

    lineProgress = interpolateBetween(
      0, 0, 0,
      1, 0, 0,
      progress, "Linear")
  elseif inputLineGetInverse[key] then
    local elapsedTime = getTickCount() - inputLineGetInverse[key]
    local progress = elapsedTime / 300

    lineProgress = interpolateBetween(
      1, 0, 0,
      0, 0, 0,
      progress, "Linear")
  end

  sy = sy - 2

  if utf8.len(fakeInputs[key]) > 0 then
    dxDrawText(fakeInputs[key], x + 3, y, x + sx - 3, y + sy, tocolor(255, 255, 255, 230 * a), fontScale, font, "left", "center", true)
  elseif label then
    dxDrawText(label, x + 3, y, x + sx - 3, y + sy, tocolor(100, 100, 100, 200 * a), fontScale, font, "left", "center", true)
  end

  if selectedInput == key then
    if inputCursorState then
      --outputChatBox("asd")
      local contentSizeX = dxGetTextWidth(fakeInputs[key], fontScale, font)

      dxDrawLine(x + 3 + contentSizeX, y + 5, x + 3 + contentSizeX, y + sy - 5, tocolor(230, 230, 230, 255 * a))
    end
    if getTickCount() - lastChangeCursorState >= 500 then
      inputCursorState = not inputCursorState
      lastChangeCursorState = getTickCount()
    end
  end

  buttons["input:" .. key] = {x, y, sx, sy}
end

function table.find(tabl,word) 
  if type(tabl) ~= "table" or word == nil then 
  return false 
  else 
  local ret = false 
    for k,v in pairs(tabl) do 
       --outputChatBox(v)
        if v[1] == word then 
        return k 
        end 
    end 
  end 
end 
