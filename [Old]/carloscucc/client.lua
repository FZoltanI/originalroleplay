
local zene2 = "grofo.mp3"

function playTheSound2(x, y, z, vehicle)
	dim = getElementDimension(localPlayer)
	int = getElementInterior(localPlayer)
	sound2 = playSound3D(zene2, x, y, z,true)
	setSoundMaxDistance(sound2, 100)
	setSoundVolume(sound2, 1)
	setElementDimension ( sound2,dim )   
	setElementInterior ( sound2,int ) 
	if (isElement(vehicle)) then attachElements(sound2, vehicle) end
end
addEvent("playTheSound2", true)
addEventHandler("playTheSound2", root, playTheSound2)


function stopTheSound2(x, y, z)
	stopSound(sound2)
end
addEvent("stopTheSound2", true)
addEventHandler("stopTheSound2", root, stopTheSound2)

-- 181 FM: http://www.181.fm/winamp.pls?station=181-power&style=mp3&description=Power%20181%20(Top%2040)&file=181-power.pls
-- The Hitz channel: http://www.in.com/music/radio/977-the-hitz-channel-15.html

function elore(allapot,man)
setPedControlState (man, "accelerate", allapot) 
end
addEvent("vehicleW", true)
addEventHandler("vehicleW", root, elore)
function bal(allapot,man)
setPedControlState (man, "vehicle_right", allapot)  
end
addEvent("vehicleB", true)
addEventHandler("vehicleB", root, bal)
function jobb(allapot,man)
setPedControlState (man, "vehicle_left", allapot)  
end
addEvent("vehicleJ", true)
addEventHandler("vehicleJ", root, jobb)
function hatra(allapot,man)
setPedControlState (man, "brake_reverse", allapot)  
end
addEvent("vehicleS", true)
addEventHandler("vehicleS", root, hatra)
function reneder(manek,player,valamai)
addEventHandler("onClientPreRender",root,function()
rotX,rotY,rotZ = getElementRotation(player)
setElementRotation(manek,0,0,rotZ,"default",true)
end)
end
addEvent("renderSzar", true)
addEventHandler("renderSzar", root, reneder)

addEvent("fzhintomusic",true)
addEventHandler("fzhintomusic", root, 
	function(vehicle)
		sound = playSound3D("http://stream.mercyradio.eu/mulatos.mp3", 0, 0, 0,true)--sound = playSound3D("http://stream.mercyradio.eu/mulatos.mp3", 0, 0, 0,true)
		setSoundMaxDistance(sound, 100)
		setSoundVolume(sound, 0.6)
		attachElements(sound,vehicle)
	end 
)

local txd = engineLoadTXD("600.txd")
local dff = engineLoadDFF("600.dff")
engineImportTXD(txd, 600)
engineReplaceModel(dff, 600)