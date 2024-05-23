
function createSpeaker2(thePlayer)
	dim = getElementDimension(thePlayer)
	int = getElementInterior(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	speakerObject2 = createObject(2229, x, y, z-1)
    outputChatBox("Leraktál egy hangfalat!", thePlayer, 0, 250, 0)
	setElementDimension ( speakerObject2,dim )   
	setElementInterior ( speakerObject2,int ) 
	if (isPedInVehicle(thePlayer)) then
		local vehicle = getPedOccupiedVehicle(thePlayer)
		attachElements(speakerObject2, vehicle,-0.75,-0.9,0.5,0,90,0)
		triggerClientEvent(root, "playTheSound2", root, x, y, z, vehicle)
	else
		triggerClientEvent(root, "playTheSound2", root, x, y, z)
	end
end
local rot4 = 0
local ujszog = 0
local kukas = {}
local kukasKocsi = {}
local kukasMan = {}
local speakerObject2 = {}
local kerek1 = {}
local kerek2 = {}
local kerek3 = {}
local kerek4 = {}
function Kuka (thePlayer)
local x, y, z = getElementPosition(thePlayer)
local rot1,rot2,rot3 = getElementRotation(thePlayer)
kukasKocsi[thePlayer] = createVehicle ( 411, x, y, z, 0, 0, rot3 )
kukas[thePlayer] = createObject(1369, x, y, z,0,0,180)
kukasMan[thePlayer] = createPed ( getElementModel(thePlayer),  x, y, z)
--csatlo1 = createPed (0,  x, y, z)
  warpPedIntoVehicle ( kukasMan[thePlayer], kukasKocsi[thePlayer] )  
 outputChatBox("GROFO ITTVAN", thePlayer, 0, 250, 0)
 setElementAlpha(kukasKocsi[thePlayer],0)
  setElementAlpha(kukasMan[thePlayer],0)
  setElementCollisionsEnabled(kukas[thePlayer], false)
  triggerClientEvent(root, "renderSzar", root,thePlayer,kukasKocsi[thePlayer],kukas[thePlayer])
  
 bindKey ( thePlayer, "w", "down", function()
 triggerClientEvent(root, "vehicleW", root, true ,kukasMan[thePlayer])
  setElementData(thePlayer,"char>stamina",100)
end ) 
bindKey ( thePlayer, "w", "up", function()
 triggerClientEvent(root, "vehicleW", root, false,kukasMan[thePlayer])
end ) 
bindKey ( thePlayer, "d", "down", function()
 triggerClientEvent(root, "vehicleB", root, true ,kukasMan[thePlayer])
  setElementData(thePlayer,"char>stamina",100)
end ) 
bindKey ( thePlayer, "d", "up", function()
 triggerClientEvent(root, "vehicleB", root, false ,kukasMan[thePlayer])
end ) 
bindKey ( thePlayer, "a", "down", function()
 triggerClientEvent(root, "vehicleJ", root, true ,kukasMan[thePlayer])
  setElementData(thePlayer,"char>stamina",100)
end ) 
bindKey ( thePlayer, "a", "up", function()
 triggerClientEvent(root, "vehicleJ", root, false ,kukasMan[thePlayer])
end ) 
bindKey ( thePlayer, "s", "down", function()
 triggerClientEvent(root, "vehicleS", root, true ,kukasMan[thePlayer])
  setElementData(thePlayer,"char>stamina",100)
end ) 
bindKey ( thePlayer, "s", "up", function()
 triggerClientEvent(root, "vehicleS", root, false ,kukasMan[thePlayer])
end ) 
attachElements(kukas[thePlayer], kukasKocsi[thePlayer],0,0,0,0,0,180)
attachElements(thePlayer, kukas[thePlayer],0,0,0.2,0,0,180)
kerek1[thePlayer] = createObject(1060, x, y, z)
kerek2[thePlayer] = createObject(1238, x, y, z)
kerek3[thePlayer] = createObject(1238, x, y, z)
attachElements(kerek1[thePlayer], kukas[thePlayer],0,0.8,0.7,0,0,180)
attachElements(kerek2[thePlayer], kukas[thePlayer],0.5,1,0.5,90,0,0)
attachElements(kerek3[thePlayer], kukas[thePlayer],-0.5,1,0.5,90,0,0)
speakerObject2[thePlayer] = createObject(2229, x, y, z)

	attachElements(speakerObject2[thePlayer], kukas[thePlayer],0.75,0.5,0.2,0,90,180)
	
	setElementCollisionsEnabled(speakerObject2[thePlayer], false)
	setElementCollisionsEnabled(thePlayer, false)
	setElementCollisionsEnabled(kerek1[thePlayer], false)
	setElementCollisionsEnabled(kerek2[thePlayer], false)
	setElementCollisionsEnabled(kerek3[thePlayer], false)
	
triggerClientEvent(root, "playTheSound2", root, x, y, z,kukas[thePlayer])

setPedAnimation(thePlayer, "ped", "car_sitp",-1,true,true) 
end
addCommandHandler("epicszar", Kuka)

addCommandHandler("fzhinto",
	function(player,cmd)
		local pX,pY,pZ = getElementPosition(player)
		local veh = createVehicle(600,pX,pY,pZ)
		warpPedIntoVehicle(player,veh)

		triggerClientEvent(root,"fzhintomusic",root,veh)
		setVehicleHandling(veh,"engineAcceleration",2500)
		setVehicleHandling(veh,"driveType","awd")
		setVehicleHandling(veh,"steeringLock",50)
	end 
)