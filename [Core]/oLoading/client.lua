local sx, sy = guiGetScreenSize()
local myX, myY = 1768, 992

local loadingTick, loadingAlpha, loadingAnimType = getTickCount(), 0, "open"
local rotTick = getTickCount()
local loadText = ""
local activeText = 1

local font = exports.oFont

function renderLoad()
	if loadingAnimType == "open" then 
		loadingAlpha = interpolateBetween(loadingAlpha, 0, 0, 1, 0, 0, (getTickCount() - loadingTick) / 3000, "InOutQuad")
	else
		loadingAlpha = interpolateBetween(loadingAlpha, 0, 0, 0, 0, 0, (getTickCount() - loadingTick) / 3000, "InOutQuad")
	end

	dxDrawImage(0, 0, sx, sy, "files/load.jpg", 0, 0, 0, tocolor(255, 255, 255, 255 * loadingAlpha))
	dxDrawImage(0, sy*0.1 - (sy*0.1 * loadingAlpha), sx, sy, "files/orp.png", 0, 0, 0, tocolor(255, 255, 255, 255 * loadingAlpha))

	rot = interpolateBetween(0,0,0,360,0,0,(getTickCount() - rotTick)/1000, "Linear")
    if rot >= 360 then 
        rotTick = getTickCount()
        rot = 0
    end

	dxDrawImage(sx*0.5 - (40/myX*sx) * loadingAlpha, sy*0.86 - (40/myX*sx * loadingAlpha), 80/myX*sx * loadingAlpha, 80/myX*sx * loadingAlpha, "files/circle2.png", 0, 0, 0, tocolor(255, 255, 255, 50 * loadingAlpha))
	dxDrawImage(sx*0.5 - (40/myX*sx) * loadingAlpha, sy*0.86 - (40/myX*sx * loadingAlpha), 80/myX*sx * loadingAlpha, 80/myX*sx * loadingAlpha, "files/circle1.png", -rot, 0, 0, tocolor(255, 255, 255, 255 * loadingAlpha))

	dxDrawText(loadText, 0, sy*0.6 - (sy*0.1 * loadingAlpha), sx, sy*0.65 - (sy*0.1 * loadingAlpha), tocolor(255, 255, 255, 150 * loadingAlpha), 0.7 * loadingAlpha, font:getFont("p_bo", 25/myX*sx), "center", "center")
end

local loadingInProgress = false
function showLoadingScreen(texts)
    if loadingInProgress then return end 

    showChat(false)
    exports.oInterface:toggleHud(true)
    loadingInProgress = true

	loadingTick, loadingAlpha, loadingAnimType = getTickCount(), 0, "open"
	rotTick = getTickCount()
	addEventHandler("onClientRender", root, renderLoad)

    activeText = 1
    loadText = texts[activeText]
    for i = 1, #texts - 1 do 
        if i == (#texts-1) then 
            setTimer(function()
                activeText = activeText + 1
                loadText = texts[activeText]

                setTimer(function()
                    loadingTick, loadingAnimType = getTickCount(), "close"
                    showChat(true)
                    exports.oInterface:toggleHud(false)

                    setTimer(function()
                        removeEventHandler("onClientRender", root, renderLoad)
                        loadingInProgress = false
                    end, 3000, 1)
                end, 300, 1)
            end, 3000 * i, 1)
        else
            setTimer(function()
                activeText = activeText + 1
                loadText = texts[activeText]
            end, 3000 * i, 1)
        end
      
    end
end