
function SharkFxSplash(x,y,z)
	fxAddWaterSplash ( x,y,z+1 )
	local splash = playSound3D("files/splash.wav", x,y,z, false)
	setSoundMaxDistance(splash, 30)
	setSoundMinDistance(splash, 10)
end
addEvent("ClientSharkFxSplash",true)
addEventHandler( "ClientSharkFxSplash", root, SharkFxSplash)

function SharkFxBlood(x,y,z)
	fxAddBlood ( x,y,z+1, 0, 5, 5, 30 )
	local sharkbite = playSound3D("files/sharkbite.mp3", x,y,z, false)
	setSoundVolume(sharkbite, 0.5)
	setSoundMaxDistance(sharkbite, 30)
	setSoundMinDistance(sharkbite, 10)
end
addEvent("ClientSharkFxBlood",true)
addEventHandler( "ClientSharkFxBlood", root, SharkFxBlood)