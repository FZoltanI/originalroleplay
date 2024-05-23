local sx,sy = guiGetScreenSize()
local font = exports.oFont:getFont("condensed", 15)
local font2 = exports.oFont:getFont("condensed", 7)

local intro = "sound.mp3"

local text = ""
local text2 = ""

local menuAnimationTick,menuState = getTickCount(),false

local logoTick,logostate = getTickCount(),false
local moveTick = getTickCount()
local alpha = 0
local alpha2 = 0
function renderIntro()


		text = "original#e97619V2"
		text2 = "The Future Is Ours"


	if menuStatet then 
		alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - menuAnimationTick)/5000, "InOutQuad")
	end 

	fg,move,gf = interpolateBetween(0, 0, 0, 255, 100, 150, (getTickCount() - moveTick)/1000, "InOutQuad")

	dxDrawRectangle(0,0,sx,sy,tocolor(20,20,20,150))

	if logostate then 
		alpha2 = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - logoTick)/1000, "InOutQuad")
	end

	dxDrawImage(sx*0.49,sy*0.41,sx*0.06,sy*0.1,"logo.png",0,0,0,tocolor(255,255,255,alpha2))

	dxDrawText(text,sx*0.5 - move,sy*0.45,_,_,tocolor(255,255,255,255),1,font,"center","center",false,false,false,true)
	dxDrawText(text2,sx*0.5 - move,sy*0.47,_,_,tocolor(255,255,255,alpha),1,font2,"center","center",false,false,false,true)

end 

function startIntro()

	addEventHandler("onClientRender",root,renderIntro)
	moveTick = getTickCount()
	sound = playSound(intro)
	setSoundVolume(sound,15)
	setCameraMatrix(1472.8338623047,-1709.4357910156,23.919200897217,1473.3957519531,-1710.2583007812,23.831033706665)

	setTimer(function()
		menuAnimationTick = getTickCount()
		menuStatet = true
		setTimer(function()
			logoTick = getTickCount()
			logostate = true
		end,4500,1)
	end,2000,1)

end
addCommandHandler("start_intro",startIntro)

function stopIntro()
	removeEventHandler("onClientRender",root,renderIntro)
	setCameraTarget(localPlayer,localPlayer)
end 
addCommandHandler("stop_intro",stopIntro)

local allowed = { { 48, 57 }, { 65, 90 }, { 97, 122 } } -- numbers/lowercase chars/uppercase chars

function generateString ( len )
    if tonumber ( len ) then
        math.randomseed ( getTickCount () )

        local str = ""
        for i = 1, len do
            local charlist = allowed[math.random ( 1, 3 )]
            str = str .. string.char ( math.random ( charlist[1], charlist[2] ) )
        end

        return str
    end
    return false
end

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