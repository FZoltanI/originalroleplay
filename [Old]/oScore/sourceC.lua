local sx,sy = guiGetScreenSize()
local online = 0
local maxplayers = 300
local playerCache = {}
local font1 = dxCreateFont("files/font_bold.ttf",20)
local font2 = dxCreateFont("files/font_light.ttf",20)
local font3 = dxCreateFont("files/font_thin.ttf",20)
local font4 = dxCreateFont("files/sf.otf",20)
local font5 = dxCreateFont("files/sf1.otf",20)
local show = false
local start = getTickCount()
local logo = dxCreateTexture("files/logo.png")
local maxshow = 6
local scrolvaule = 0


addEventHandler("onClientResourceStart", resourceRoot, function()
    playerCache = getElementsByType("player")
    online = #playerCache
  end)
  
  
  addEventHandler("onClientPlayerJoin", getRootElement(), function()
    table.insert(playerCache, source)
    online = #playerCache
  end)
  
  addEventHandler("onClientPlayerQuit", getRootElement(), function()
    for k, v in ipairs(playerCache) do
        if v == source then
            table.remove(playerCache, k)
            online = #playerCache
        end
    end
  end)

local adminColors = {"#f7931e", "#f7931e", "#f7931e", "#f7931e", "#f7931e", "#f7931e", "#6284c9", "#ffcc00", "#ffbb5b", "#5db2f7", "#f44141"}
local adminTag = {"Admin Segéd", "Admin 1", "Admin 2", "Admin 3", "Admin 4", "Admin 5", "Fő Admin", "AdminController", "ServerManager", "Fejlesztő", "Tulajdonos"}

function drawScore()
 if show and getElementData(localPlayer,"user:loggedin") then 
    local now = getTickCount()
    local elapsedTime = now - start
    local endTime = start + 500
    local duration = endTime - start
    local progress = elapsedTime / duration
    local playersline,alpha,alpha2 = interpolateBetween ( 0, 0, 0, (355/maxplayers)*online, 230, 255, progress, "InQuad")
    local alpha3,_,_ = interpolateBetween ( 0, 0, 0, 150,0,0, progress, "InQuad")

    dxDrawRectangle(sx/2 - 200,sy/2 - 225,400,395,tocolor(40,40,40,alpha2))
    dxDrawImage(sx/2 - 380,sy/2 - 225,750,400,logo,0,0,0,tocolor(255,255,255,alpha3))

    dxDrawRectangle(sx/2 - 190,sy/2 - 214,380,35,tocolor(30,30,30,alpha))
    dxDrawRectangle(sx/2 - 190,sy/2 - 172,380,35,tocolor(30,30,30,alpha))
    dxDrawRectangle(sx/2 - 190,sy/2 - 130,380,35,tocolor(30,30,30,alpha))
    dxDrawRectangle(sx/2 - 190,sy/2 - 88,380,35,tocolor(30,30,30,alpha))
    dxDrawRectangle(sx/2 - 190,sy/2 - 46,380,35,tocolor(30,30,30,alpha))
    dxDrawRectangle(sx/2 - 190,sy/2 - 4,380,35,tocolor(30,30,30,alpha))
    dxDrawRectangle(sx/2 - 190,sy/2 + 38,380,35,tocolor(30,30,30,alpha))
    dxDrawRectangle(sx/2 - 190,sy/2 + 80,380,35,tocolor(30,30,30,alpha))
    dxDrawRectangle(sx/2 - 190,sy/2 + 122,380,35,tocolor(30,30,30,alpha))

    dxDrawRectangle(sx/2 - 190,sy/2 + 122,playersline,35,tocolor(233, 118, 25,alpha))

 dxDrawText("ID",sx/2 - 180,sy/2 - 207,_,_,tocolor(255,255,255,alpha2),0.6,font1)
 dxDrawText("Név",sx/2 - 80,sy/2 - 207,_,_,tocolor(255,255,255,alpha2),0.6,font1)
 dxDrawText("Szint",sx/2 + 40,sy/2 - 207,_,_,tocolor(255,255,255,alpha2),0.6,font1)
 dxDrawText("Ping",sx/2 + 141,sy/2 - 207,_,_,tocolor(255,255,255,alpha2),0.6,font1)


 dxDrawText("ORIGINAL",sx/2 - 90,sy/2 + 87,_,_,tocolor(255,255,255,alpha2),0.6,font1)
 dxDrawText("ROLEPLAY",sx/2 -5,sy/2 + 87,_,_,tocolor(255,255,255,alpha2),0.6,font3)
 dxDrawText(online.."/"..maxplayers,sx/2 -5-dxGetTextWidth(online.."/"..maxplayers,0.6,font3 )/2,sy/2 + 129,_,_,tocolor(255,255,255,alpha2),0.6,font3)

  for k,v in pairs(playerCache) do
    
   if k <= maxshow and (k > scrolvaule) then
    local name = getPlayerName(v)
    local rank = getElementData(v, "user:admin") 

    local playerping = getPlayerPing(v)
    local fixedping = getPlayerPing(v)
     
    if playerping < 25 then 
        playerping = playerping
    elseif playerping >= 25 and playerping < 40 then 
        playerping = playerping
    elseif playerping >= 40 and playerping < 75 then 
        playerping = "#e97619"..playerping
    elseif playerping > 75 then 
        playerping = "#b32424"..playerping
    end


    if getElementData(v,"user:loggedin") then 
      dxDrawText("("..getElementData(v,"playerid")..")",sx/2-182,sy/2-165+41*(k-scrolvaule-1),_,_,tocolor(255,255,255,alpha2),0.6,font1)

    dxDrawText("5",sx/2+62-dxGetTextWidth("5",0.6,font1 )/2,sy/2-165+41*(k-scrolvaule - 1),_,_,tocolor(255,255,255,alpha2),0.6,font1)
   dxDrawText(playerping,sx/2+160 -dxGetTextWidth(fixedping,0.6,font1 )/2,sy/2-165+41*(k-scrolvaule - 1),_,_,tocolor(255,255,255,alpha2),0.6,font1,"left","top",false,false,false,true)
    end

    if not getElementData(v,"user:aduty") then 
     if getElementData(v,"user:loggedin") then 
      dxDrawText(name:gsub("_", " "),sx/2-65-dxGetTextWidth(name:gsub("_", " "),0.6,font2 )/2,sy/2-165+41*(k-scrolvaule - 1),_,_,tocolor(255,255,255,alpha2),0.6,font2,"left","top",false,false,false,true)
     else 
      dxDrawText("Nincs Bejelentkezve",sx/2-2-dxGetTextWidth("Nincs Bejelentkezve",0.6,font2 )/2,sy/2-165+41*(k-scrolvaule - 1),_,_,tocolor(255,255,255,alpha2),0.6,font2,"left","top",false,false,false,true)
     end 
    else 

    dxDrawText(adminColors[rank] .. "("..adminTag[rank]..") #dcdcdc".. name,sx/2-10-dxGetTextWidth(adminColors[rank] .. "("..adminTag[rank]..") #dcdcdc".. name,0.55,font2 )/2,sy/2-164+41*(k-scrolvaule - 1),_,_,tocolor(255,255,255,alpha2),0.55,font4,"left","top",false,false,false,true)
   end 
    end 
  end 
end 
end
addEventHandler("onClientRender",root,drawScore)

bindKey("tab", "down", function()
    if show then
      show = false
    else
      show = true
      start = getTickCount()
      
    end
  end)
  
  bindKey("tab", "up", function()
    if show then
      show = false
    else
      show = true
      start = getTickCount()
    end
  end)
  
  addEventHandler("onClientKey", getRootElement(), function(button, press)
    if press and show then
        if button == "mouse_wheel_up" then
          if scrolvaule > 0  then
            scrolvaule = scrolvaule -1
            maxshow = maxshow -1
          end
        elseif button == "mouse_wheel_down" then
          if maxshow < #playerCache then
            scrolvaule = scrolvaule +1
            maxshow = maxshow +1
          end
        end
    end
  end)