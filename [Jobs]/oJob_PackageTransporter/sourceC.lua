local jobId = 8

local screenX, screenY = guiGetScreenSize()
local jobPed = false 
local jobStarted = false
local jobData = false

local selection = dxCreateTexture("files/selection.png")
local selectionSize = 16 * (1 / 75)

local boxModels = 1271

local jobColShape = createColCuboid(2195.3273925781,-2264.6147460938,13.546875, 10, 10, 10)

local clockRT = false

local ocr25Bold = dxCreateFont("files/ocr.ttf", 25)

addEventHandler("onClientResourceStart",getRootElement(),function()
    clockRT = dxCreateRenderTarget(180, 90)
    refreshClockRT()
    clockRefreshTimer = setTimer(refreshClockRT, 10000, 0)

    quantityRT = dxCreateRenderTarget(250, 90, true)
end)

function refreshClockRT()
	if isElement(clockRT) then
		local realTime = getRealTime()

		dxSetRenderTarget(clockRT)

		dxDrawRectangle(0, 0, 180, 90, tocolor(40, 40, 40))
		dxDrawRectangle(10, 10, 160, 70, tocolor(0, 0, 0))

		dxDrawText(string.format("%02d:%02d", realTime.hour, realTime.minute), 0, 0, 180, 90, tocolor(245, 10, 10), 1, ocr25Bold, "center", "center")

		dxSetRenderTarget()
	end
end

x,y,z = 2186.5493164062,-2266.3684082031,13.479597091675

-- posterid : 5846

size = 2.4
function renderClock()
    if isElement(clockRT) then
      --  dxDrawImage(0,0,180,90,clockRT)
		dxDrawMaterialLine3D(2152.9431152344,-2237.3630371094-1,17.423120498657, 2152.9431152344,-2237.3630371094+1,17.423120498657, clockRT, 2.4, -1, 2152.9431152344,-2237.3630371094,17.423120498657)
	end
end
addEventHandler("onClientRender", getRootElement(), renderClock)

addEventHandler("onClientMarkerHit", getRootElement(), function(hitPlayer,mdim)
    if hitPlayer == localPlayer and mdim then
        if source == jobColShape then 
            outputChatBox("hited")
        end
    end
end)

addEventHandler("onClientMarkerLeave", getRootElement(), function(hitPlayer,mdim)
    if hitPlayer == localPlayer and mdim then
        if source == jobColShape then 
            outputChatBox("Leave")
        end
    end
end)
