local sx,sy = guiGetScreenSize()

    soundHandler = playSound ("http://stream3.radio1.hu/mid.mp3")
    setSoundVolume(soundHandler,0.1)

local colors = {}

local radioShowing = true
local otherShow = false 

local radioOn = false
local radioIsMute = false
local selectedRadioStation = 1
local vol = 100
local roboto = dxCreateFont("font.ttf",15)

local chat = exports.cl_chat
local core = exports.cl_core

local rX,rY = sx*0.35,sy*0.35
local rW,rH = sx*0.3,sy*0.05

equalizerShow = true

local radioStations  = {
    {"http://stream3.radio1.hu/mid.mp3","Rádió 1"},
	{"http://79.172.241.238:8000/musicfm.mp3","Music FM"},
	{"http://www.radio88.hu/stream/radio88.pls","Rádió 88"},
	{"http://mr-stream.mediaconnect.hu:80/4738/mr2.mp3","Petőfi Rádió"},
	{"http://www.partyviberadio.com:8016/listen.pls","Rap Radio"},
	{"http://stream.mercyradio.eu/romaaut.mp3","Románo Ungriko Discoso"},
	{"http://stream.mercyradio.eu/mulatos.mp3", "Mercy Rádió Mulatós"},
	{"http://stream.lazaradio.com/mulatos.mp3", "Laza Rádió Mulatós"},
	{"http://stream.laut.fm/jahfari.m3u","UK top 40"},
	{"http://jbmedia-edge1.cdnstream.com/hot108?cb=868901.mp3","Hot 108 JAMZ"},
}

local textures = {
    ["button"] = dxCreateTexture("power.png"),
    ["next_button"] = dxCreateTexture("next.png"),
    ["speaker"] = dxCreateTexture("speaker.png"),
    ["mute"] = dxCreateTexture("mute.png"),
}

local menus = {
    {textures["button"],0},
    {textures["next_button"],0},
    {textures["next_button"],180},
    {textures["speaker"],0},
}

local bebasz1 = dxCreateFont("bebasz.ttf",20)
local bebasz2 = dxCreateFont("bebasz.ttf",16)

for i=1, 450 do 
    local color = tocolor(255,255,255,255)
    if i < 50 then 
        color = tocolor(247, 179, 56,255)
    elseif i >= 50 and i <= 100 then
        color = tocolor(240, 179, 56,255) 
    elseif i >= 100 and i <= 150 then
        color = tocolor(235, 179, 56,255) 
    elseif i >= 150 and i <= 200 then
        color = tocolor(228, 179, 560,255) 
    elseif i >= 200 and i <= 250 then
        color = tocolor(221, 179, 56,255) 
    elseif i >= 250 and i <= 300 then
        color = tocolor(216, 179, 56,255) 
    elseif i >= 300 and i <= 350 then
        color = tocolor(210, 179, 56,255) 
    elseif i >= 350 then
        color = tocolor(204, 179, 56,255)
    end
    table.insert(colors,i,{color})
end

setTime(12,00)

addEventHandler("onClientRender",root,
    function ()
        if radioShowing then 

            dxDrawRectangle(rX,rY,rW,rH,tocolor(50,50,50,240))

            --core:dxDrawButton(rX+sx*0.002,rY+sy*0.004,rW-sx*0.1,rH-sy*0.008,40,40,40,true,roboto,1, "Rádió kikapcsolva!")
            dxDrawRectangle(rX+sx*0.002,rY+sy*0.004,rW-sx*0.1,rH-sy*0.008,tocolor(40,40,40,240))
            dxDrawRectangle(rX+sx*0.255,rY+sy*0.004,rW-sx*0.257,rH-sy*0.008,tocolor(30,30,30,220))

            local newy = 0.01
            for i=1, #menus do 
                if isInSlot(rX+sx*0.267,rY+sy*newy,40,40) then 
                    if i == 4 and radioIsMute then 
                        dxDrawImage(rX+sx*0.267,rY+sy*newy,40,40,textures["mute"],0,0,0,tocolor(247, 179, 56,255))
                    else
                        dxDrawImage(rX+sx*0.267,rY+sy*newy,40,40,menus[i][1],menus[i][2],0,0,tocolor(247, 179, 56,255))
                    end
                else 
                    if i == 4 and radioIsMute then 
                        dxDrawImage(rX+sx*0.267,rY+sy*newy,40,40,textures["mute"],0,0,0,tocolor(255,255,255,255))
                    else
                        dxDrawImage(rX+sx*0.267,rY+sy*newy,40,40,menus[i][1],menus[i][2],0,0,tocolor(255,255,255,255))
                    end
                end 

                newy = newy + 0.06
            end

            if radioOn then 
                if  soundHandler and equalizerShow then
                    local soundFFT = getSoundFFTData ( soundHandler, 2048, 450)
                    if ( soundFFT ) then
                        for i = 0, 449 do
                            dxDrawRectangle ( rX+sx*0.003+(i+2),rY+sy*0.24, 3,szamToMinus(math.sqrt( soundFFT[i] ) * (256*vol/100)),colors[i+1][1])
                        end
                    end
                end

                dxDrawText(radioStations[selectedRadioStation][2],rX+sx*0.002,rY+sy*0.004,rX+sx*0.002+rW-sx*0.1,rY+sy*0.004+rH-sy*0.008,tocolor(255,255,255,255),1,roboto,"center","center")
            else 
                dxDrawText("Rádió kikapcsolva!",rX+sx*0.002,rY+sy*0.004,rX+sx*0.002+rW-sx*0.1,rY+sy*0.004+rH-sy*0.008,tocolor(255,255,255,255),1,roboto,"center","center")
            end
        end
    end
)

addEventHandler("onClientKey",root,
    function(key,state)
        if key == "mouse1" and state and radioShowing then 
            
            local newy = 0.01
            for i=1, #menus do 
                if isInSlot(rX+sx*0.267,rY+sy*newy,40,40) then 

                    if i == 1 then  -- on/of
                        if radioOn then 
                            radioOn = false 
                            chat:sendLocalMeAction("kikapcsolja a rádiót.")
                        else 
                            radioOn = true 
                            chat:sendLocalMeAction("bekapcsolja a rádiót.")
                        end
                    elseif i == 2 then --csatorna+
                        if selectedRadioStation < #radioStations and radioOn then 
                            selectedRadioStation = selectedRadioStation + 1
                            chat:sendLocalMeAction("átállítja a rádió csatornáját.")
                        end
                    elseif i == 3 then --csatorna-
                        if selectedRadioStation > 1 and radioOn then 
                            selectedRadioStation = selectedRadioStation - 1
                            chat:sendLocalMeAction("átállítja a rádió csatornáját.")
                        end
                    elseif i == 4 then --hang -/+
                        if radioIsMute then 
                            radioIsMute = false 
                            chat:sendLocalMeAction("hangot ad a rádióra.")
                        else 
                            radioIsMute = true 
                            chat:sendLocalMeAction("leveszi a hangot a rádióról.")
                        end
                    end

                end 

                newy = newy + 0.06
            end

        end
    end 
)

function isInSlot(x,y,w,h)
    if isCursorShowing() then 
        local cX,cY = getCursorPosition()
        if cX and cY then 
            local sx,sy = guiGetScreenSize()
            cX,cY = cX*sx,cY*sy 

            if cX > x and cX < x + w and cY > y and cY < y + h then 
                return true 
            else 
                return false 
            end
        else 
            return false 
        end
    else 
        return false
    end
end

function szamToMinus(number)
    return number - (number*2)
end