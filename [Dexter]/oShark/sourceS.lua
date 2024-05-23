local lastActive = {}
local last = 0

local sharkCol = createColSphere(-1646.8360595703,1200.6684570312,-3.7853269577026, 1200)

function check()
	for k,v in ipairs (getElementsWithinColShape(sharkCol, "player")) do
		if (v ~= false) then
			if (getElementType(v) == "player") then
				if last > 3 then
                    local num = math.random(0,1)
                    if num == 0 then
                    	lastActive[v] = true
                    else
                    	lastActive[v] = false
                    end
                --    lastActive[v] = true
                end
				if (isElementInWater(v) and lastActive[v]) then
					if (isPedInVehicle(v) == false ) then
                     --   outputChatBox(getElementData ( v, "sharksPass" ))
						if (getElementData ( v, "sharksPass" ) or 0) < 9 then
                            
							setElementData ( v, "sharksPass",getElementData ( v, "sharksPass" )+1 )
						end
						if (getElementData ( v, "sharksPass" ) or 0) == 0 then
							setElementData ( v, "sharksPass",1 )
						end
						x,y,z = getElementPosition ( v )
						if z < 1 then
							if (isElement(getElementData ( v, "sharknullObject" )) == false) then
								if isElement(getElementData ( v, "sharknullObject" )) then
									destroyElement(getElementData ( v, "sharknullObject" ))
									setElementData ( v, "sharknullObject",nil )
								end
								if isElement(getElementData ( v, "sharkshark1" )) then
									destroyElement(getElementData ( v, "sharkshark1" ))
									setElementData ( v, "sharkshark1",nil )
								end
								nullObject = createObject( 3027,x,y,z-5)
								setElementData ( v, "sharknullObject", nullObject )
								setElementData ( nullObject, "sharkOwner", v )
								setElementAlpha(nullObject,0)
								shark1 = createObject (1608,x+10,y,z-5)
								setElementData ( v, "sharkshark1", shark1 )
								attachElements(getElementData ( v, "sharkshark1" ),getElementData ( v, "sharknullObject" ),0+10,0,-0.3)
							end
							moveObject(getElementData ( v, "sharknullObject" ),5000,x,y,z,0,0,179.9)
							if getElementData ( v, "sharksPass" ) > 8 then
								setElementData ( v, "sharksPass",0 )
								shark2 = createObject (1608,x,y-15,z-10,45,0,0)
								setElementData ( v, "sharkshark2", shark2 )
								moveObject(getElementData ( v, "sharkshark2" ),2500,x,y-5,z+1,-45,0,0)
								setTimer (function (v)
									x,y,z = getElementPosition (getElementData ( getElementData ( v, "sharknullObject"), "sharkOwner" ))
									v = getElementData ( getElementData ( v, "sharknullObject"), "sharkOwner" )
									local vx, vy, vz = getElementPosition (getElementData ( v, "sharkshark2" ))
									local sx = x - vx
									local sy = y - vy
									local sz = z - vz
									local new = sx^2 + sy^2 + sz^2
                                    setElementHealth (v,0)
                                    setPedHeadless  (v,true)
                                    setTimer (function (v)
                                        killPed ( v, nil, nil, 9 )
                                    end,2500, 1,v)	
                                    setTimer (function (v)
                                        setPedHeadless  (v,false)
                                    end,4500, 1,v)
									    triggerClientEvent ( "ClientSharkFxBlood", getRootElement(), x, y, z )
									    triggerClientEvent ( "ClientSharkFxSplash", getRootElement(), x, y, z )
									moveObject(getElementData ( v, "sharkshark2" ),2500,x,y+15,z-10,-45,0,0)
								end,2500, 1,v)
								setTimer (function (v)
									destroyElement(getElementData ( v, "sharkshark2" ))
									setElementData ( v, "sharkshark2",nil )
									setElementData ( v, "sharksPass",0 )
								end,5000, 1,v)
							end
						else
							deleteSharks(v)
						end
					else
						deleteSharks(v)
					end
				else
					deleteSharks(v)
				end
			end
		end
	end
	if last > 3 then
        last = 0
    end
    last = last + 1
--    outputChatBox(last)
end

function deleteSharks (v)
	if isElement(v) then
		if isElement(getElementData ( v, "sharknullObject" )) then
			moveObject(getElementData ( v, "sharknullObject" ),5000,x,y,z-10,0,0,179.9)
			setTimer (function (v)
				if isElement(getElementData ( v, "sharknullObject" )) then
					destroyElement(getElementData ( v, "sharknullObject" ))
				end
				if isElement(getElementData ( v, "sharkshark1" )) then
					destroyElement(getElementData ( v, "sharkshark1" ))
				end
				if isElement(getElementData ( v, "sharkshark2" )) then
					destroyElement(getElementData ( v, "sharkshark2" ))
				end
				setElementData ( v, "sharknullObject",nil )
				setElementData ( v, "sharkshark1",nil )
				setElementData ( v, "sharkshark2",nil )
				setElementData ( v, "sharksPass",0 )
			end,2000, 1,v)
		end
	end
end

function onLoad ( )
	for k,v in ipairs (getElementsByType( "player" )) do
		if isElement(getElementData ( v, "sharknullObject" )) then
			destroyElement(getElementData ( v, "sharknullObject" ))
		end
		if isElement(getElementData ( v, "sharkshark1" )) then
			destroyElement(getElementData ( v, "sharkshark1" ))
		end
		if isElement(getElementData ( v, "sharkshark2" )) then
			destroyElement(getElementData ( v, "sharkshark2" ))
		end
		setElementData ( v, "sharknullObject",nil )
		setElementData ( v, "sharkshark1",nil )
		setElementData ( v, "sharkshark2",nil )
		setElementData ( v, "sharksPass",0 )
	end
	setTimer(check,2000,0)
end
addEventHandler( "onMapLoad", getRootElement(), onLoad)
onLoad()

function onQuit ( )
	if isElement(getElementData ( source, "sharknullObject" )) then
		destroyElement(getElementData ( source, "sharknullObject" ))
	end
	if isElement(getElementData ( source, "sharkshark1" )) then
		destroyElement(getElementData ( source, "sharkshark1" ))
	end
	if isElement(getElementData ( source, "sharkshark2" )) then
		destroyElement(getElementData ( source, "sharkshark2" ))
	end
	setElementData ( source, "sharknullObject",nil )
	setElementData ( source, "sharkshark1",nil )
	setElementData ( source, "sharkshark2",nil )
	setElementData ( source, "sharksPass",0 )
end
addEventHandler( "onPlayerQuit", getRootElement(), onQuit)