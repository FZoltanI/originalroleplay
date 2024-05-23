local sx,sy = guiGetScreenSize()
local syncFloat = {}
local syncFishingrod = {}
setElementData(localPlayer,"user:fishingrod",false)
local floatState = true
local fishingStat = false

local fishingTimer = false

fishsprecent = {}
fishsinprecent = 0
fishs = {
    {"Ponty",1,127},
    {"Harcsa",2,128},
    {"Rozsdás kanna",3,136},
    {"Lyukas vödör",4,137},
    {"Sügér",5,129},
    {"Lazac",6,130},
    {"Amur",7,131},
    {"Angolna",8,132},
    {"Törpeharcsa",9,133},
    {"Zebrahal",10,134},
    {"Béka",12,135},
    {"Nád",13,138},
    {"Kincsesláda",0.5,140},
    {"Pénztárca",1,141},
}

function chooseFish()
for _,v in pairs(fishs) do
	for i=fishsinprecent,v[2] do
	fishsprecent[i] = {v[1]}

	fishsinprecent = fishsinprecent +1
	end
end
end 





addEventHandler('onClientResourceStart', resourceRoot,
function()
	txd = engineLoadTXD( "files/fishingrod.txd" )
	dff = engineLoadDFF( "files/fishingrod.dff" )
    
	engineImportTXD( txd, 338 )
	engineReplaceModel( dff, 338 )
end
)

function syncfishing(fishingrods,fishingfloats)
    syncFloat = fishingfloats
	syncFishingrod = fishingrods
end
addEvent( "syncfishing", true )
addEventHandler( "syncfishing", root, syncfishing )

function onClientClick(button, state, x,y,wordx,wordy,wordz,clickedElement)
 if not exports["oInventory"]:hasItem(148,1) then return end
 if fishingTimer then return end
 if getElementData(localPlayer,"user:fishingrod") then 
 if button == "left" and state == "down" then 
   if testLineAgainstWater(wordx,wordy,wordz,wordx,wordx,wordz+500) then 
      wordx, wordy, wordz = getWorldFromScreenPosition(x,y,20)

      if isLineOfSightClear(wordx,wordy,wordz,wordx,wordy,wordz+500) then 

        local px,py,pz = getElementPosition(localPlayer)
        local distance = getDistanceBetweenPoints3D(px,py,pz, wordx, wordy, wordz)

         if distance < 35 then 

           if floatState then 
      
            triggerServerEvent("takeFloatWater",root,localPlayer)
            floatState = false 
           else 
            startFishing()
            triggerServerEvent ( "dropFloatWater", root,localPlayer,wordx, wordy, wordz + 1)
            floatState = true 
           end 
         end 

      end 

   end 
 end 
 end 
end 
addEventHandler("onClientClick",root,onClientClick)

function renderLine()
 if getElementData(localPlayer,"user:fishingrod") then 
	for k,v in ipairs(getElementsByType("player")) do
		if (syncFloat[v]) and (syncFishingrod[v]) then
			local kx, ky, kz = getPositionFromElementOffset(syncFloat[v], 0.015, 0.00, 0.13)
			local px, py, pz = getPositionFromElementOffset(syncFishingrod[v], 0.015, 0.000, 2.18)
            dxDrawLine3D(kx, ky, kz, px, py, pz, tocolor(150, 150, 150, 150), 0.4, false)
		end
  end
 end 
end
addEventHandler("onClientRender", getRootElement(), renderLine)

function startFishing()
    times = {{2000}} --times = {{75000,14000,19000,28000,35000,45000}}
    local num = math.random(1,1)
    time = times[1][num]
    setTimer(function()
      if floatState then 
        triggerServerEvent("onFishing",localPlayer,localPlayer)
        setTimer(function()
        addEventHandler("onClientRender",root,minigame)
        end,2000,1)
        setCursorPosition(sx*0.5,sy*0.3)
        showCursor(true)
        exports["cl_infobox"]:outputInfoBox("Tartsd a cursort a körön belűl.","info")
      end 
    end,time,1)
 end


function minigame()
  if floatState then 
      timesTwo = {{3000,3000,3000}} --timesTwo = {{15000,30000,50000}}
      local numTwo = math.random(1,3)
      timeTwo = timesTwo[1][numTwo]

      cx,cy = getCursorPosition()
      cx,cy = cx*sx,cy*sy
      
    setCursorPosition(cx + 2.5,cy + 2)
    dxDrawCircle(sx*0.5,sy*0.3,sx*0.03,0,360,tocolor(60,60,60,140),tocolor(0,0,0,0),1024 )

    timer = setTimer(function()
    if floatState then 
    if isInSlot(sx*0.47,sy*0.245,sx*0.059,sy*0.11) then 
    
      fishingTimer = true
      setTimer(function ()
        fishingTimer = false 
      end,5000,1)

      removeEventHandler("onClientRender",root,minigame)
      outputChatBox("lefut a timer")
      chooseFish()
      triggerServerEvent("stopanim",localPlayer,localPlayer)
      fish = math.random(0,#fishsprecent)
      outputChatBox(fishsprecent[fish][1])
      triggerServerEvent("takeFloatWater",root,localPlayer)
      showCursor(false)
      floatState = false 
      triggerServerEvent("addItemToPlayer",localPlayer,localPlayer,fishsprecent[fish][3],fishsprecent[fish][1])
      exports["cl_infobox"]:outputInfoBox("Sikeresen kifogtál valamit a vízből.","success")
    end 
    end
    end,timeTwo,1)

    if not isInSlot(sx*0.47,sy*0.245,sx*0.059,sy*0.11) then 
      removeEventHandler("onClientRender",root,minigame)
      exports["cl_infobox"]:outputInfoBox("Elrontottad a fárasztást így a damíl elszakadt.","error")
      triggerServerEvent("stopanim",localPlayer,localPlayer)
      showCursor(false)
      triggerServerEvent("takeFloatWater",root,localPlayer)
      floatState = false 
      fishingTimer = true

      setTimer(function() 
        fishingTimer = false 
      end,5000,1)

      if isTimer ( timer ) then killTimer ( timer )  end
    end
  end
end

