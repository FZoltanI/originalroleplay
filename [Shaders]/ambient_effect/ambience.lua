local sounds = {"sounds/thunder.mp3","sounds/lightning.wav","sounds/thunder1.wav","sounds/thunder2.wav"}

local function downloadsounds()
for sound,theSound in ipairs(sounds) do
downloadFile( theSound )
setWorldSoundEnabled( 4, 1, false )
setWorldSoundEnabled( 4, 4, false )
end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), downloadsounds )

--[[
function playsound()

 playSound(sounds[math.random(1, #sounds)])
 setSoundVolume(sound, 300.0)
	
     
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),playsound)
--]]

local thunders = { "sounds/thunder.mp3", "sounds/lightning.wav", "sounds/thunder.mp3", "sounds/thunder1.wav", "sounds/thunder2.wav" }
local soundvar =  { 0.85, 1.0, 1.50, 1.25, 1.80 }

function thunder()


local weather = getWeather()

if weather == 8 or weather == 16 then

local effect = playSound(thunders[math.random(1, #thunders)])
setSoundVolume( effect, math.random(1, #soundvar ) )

end
end
setTimer(thunder, 20000,0)
