local cam_posok = {
    ["clothshop"] = {
        [1] = {2267.6064453125,-1648.1971435547,20.09580039978,2267.2810058594,-1649.111328125,19.854221343994, 2227.4675292969,-1643.0617675781,19.733499526978,2227.8544921875,-1643.9516601563,19.491920471191, 2500},
        [2] = {511.36529541016,-1574.1159667969,23.086700439453,510.37744140625,-1574.1293945313,22.931858062744, 497.33331298828,-1533.3093261719,22.771900177002,496.34545898438,-1533.3227539063,22.617057800293, 2800},
        [3] = {1447.1042480469,-1166.8446044922,25.94700050354,1446.9315185547,-1165.8616943359,25.882982254028, 1485.9644775391,-1142.3669433594,26.004600524902,1485.1208496094,-1141.837890625,25.912544250488, 3500},
    }
}

addCommandHandler("videozas", function(command, name, number)
    number = tonumber(number)
    smoothMoveCamera(cam_posok[name][number][1], cam_posok[name][number][2], cam_posok[name][number][3], cam_posok[name][number][4], cam_posok[name][number][5], cam_posok[name][number][6], cam_posok[name][number][7], cam_posok[name][number][8], cam_posok[name][number][9], cam_posok[name][number][10], cam_posok[name][number][11], cam_posok[name][number][12], cam_posok[name][number][13])

    setTimer(function() 
        setCameraTarget(localPlayer, localPlayer)
    end, cam_posok[name][number][13], 1)
end)

-------------------
local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1)
		local x2,y2,z2 = getElementPosition(sm.object2)
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientPreRender",root,camRender)
	end
end

 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1)
	sm.object2 = createObject(1337,x1t,y1t,z1t)
        setElementCollisionsEnabled (sm.object1,false) 
	setElementCollisionsEnabled (sm.object2,false) 
	setElementAlpha(sm.object1,0)
	setElementAlpha(sm.object2,0)
	setObjectScale(sm.object1,0.01)
	setObjectScale(sm.object2,0.01)
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
	sm.moov = 1
	setTimer(removeCamHandler,time,1)
	setTimer(destroyElement,time,1,sm.object1)
	setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end