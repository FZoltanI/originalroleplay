local sx,sy = guiGetScreenSize()
local myX, myY = 1600,900

local font = exports.oFont:getFont("p_ba", 25)
local font2 = exports.oFont:getFont("p_m", 25)

local bannerText1 = "ORIGINAL ROLEPLAY - CLOSED TEST 22DECEMBER "
local bannerText2 = "FIGYELEM! A szerver TESZT fázisban van, ahol előfordulhatnak hibák! \n Amennyiben valamilyen hibát találtál, azt kötelességed discordon jelenteni! \nKép- és videófelvétel készítése tilos!"

local logoSize = 2

local tick = getTickCount()

addEventHandler("onClientRender", root, function()
    --dxDrawImage(0, 0, sx, sy, "closed.png")
    --dxDrawImage(sx*0.03, sy*0.15, 100/myX*sx*logoSize, 91/myY*sy*logoSize, "beta_logo.png", 0, 0, 0, tocolor(255, 255, 255, 255*interpolateBetween(0, 0, 0, 1, 0, 0, (tick-getTickCount())/1000, "CosineCurve")))
    --dxDrawRectangle(sx*0.45, sy*0.015, sx*0.1, sy*0.04)
    dxDrawText(bannerText1, 1/myX*sx, sy*0.025+1/myY*sy, sx+1/myX*sx, sy*0.025+sy*0.02+1/myY*sy, tocolor(0, 0, 0, 255), 1/myX*sx, font, "center", "center")
    dxDrawText(bannerText1, 0, sy*0.025, sx, sy*0.025+sy*0.02, tocolor(185, 49, 49, 255), 1/myX*sx, font, "center", "center")

    dxDrawText(bannerText2, 1/myX*sx, sy*0.055+1/myY*sy, sx+1/myX*sx, sy*0.055+sy*0.02+1/myY*sy, tocolor(0, 0, 0, 255), 0.6/myX*sx, font2, "center", "top")
    dxDrawText(bannerText2, 0, sy*0.055, sx, sy*0.055+sy*0.02, tocolor(185, 49, 49, 255), 0.6/myX*sx, font2, "center", "top")

    --dxDrawText("CLOSED BETA TEST", sx*0.45+1/myX*sx, sy*0.055+1/myY*sy, sx*0.45+sx*0.1+1/myX*sx, sy*0.055+sy*0.04+1/myY*sy, tocolor(0, 0, 0, 255), 0.8/myX*sx, font2, "left", "center")
    --dxDrawText("CLOSED BETA TEST", sx*0.45, sy*0.055, sx*0.45+sx*0.1, sy*0.055+sy*0.04, tocolor(185, 49, 49, 255), 0.8/myX*sx, font2, "left", "center")
end)

setTimer(function()
    outputChatBox(exports.oCore:getServerPrefix("red-dark", "Closed test", 3).."A szever tesz fázisban van! Amennyiben hibát találtál, azt discordon keresztül kell jelentened!", 255, 255, 255, true)
end, exports.oCore:minToMilisec(15), 0)