local fishingrods = {}
local fishingfloats = {}

function giveElementFishingRod(element)
	if not fishingrods[element] then 
    fishingrods[element] = createObject(338, 0, 0, -10000)
    setElementData(element,"user:fishingrod",true)
    exports["oChat"]:sendLocalMeAction(element,"elővesz egy horgászbotot.")
	exports["oBone"]:attachElementToBone(fishingrods[element],element,12,0,0,0.07,0,260,0)
	triggerClientEvent ( getRootElement(), "syncfishing", getRootElement(),fishingrods,fishingfloats)
    end
end 

function takeElementFishingRod(element)
	if fishingrods[element] then 
	exports["oBone"]:detachElementFromBone(fishingrods[element])
	destroyElement(fishingrods[element])
	setElementData(element,"user:fishingrod",false)
	exports["oChat"]:sendLocalMeAction(element,"elrak egy horgászbotot.")
	fishingrods[element] = nil
	if fishingfloats[element] then
		destroyElement(fishingfloats[element])
		fishingfloats[element] = nil
	end
	triggerClientEvent ( getRootElement(), "syncfishing", getRootElement(),fishingrods,fishingfloats)

	end
end

function dropFloatWater(element,x,y,z)
	if not fishingfloats[element] then 
	fishingfloats[element] = createObject(2995, x, y, z)
    setObjectScale(fishingfloats[element], 2)
    setElementData(element,"user:floatinwater",true)
	exports["oChat"]:sendLocalMeAction(element,"bedob egy csalit a vízbe.")
	triggerClientEvent ( getRootElement(), "syncfishing", getRootElement(),fishingrods,fishingfloats)
    end
end
addEvent( "dropFloatWater", true )
addEventHandler( "dropFloatWater", root, dropFloatWater )

function takeFloatWater(element)
	if fishingfloats[element] then
		exports["oChat"]:sendLocalMeAction(element,"kivesz egy csalit a vízből.")
		destroyElement(fishingfloats[element])
		setElementData(element,"user:floatinwater",false)
		fishingfloats[element] = nil
		triggerClientEvent ( getRootElement(), "syncfishing", getRootElement(),fishingrods,fishingfloats)
	end
end
addEvent( "takeFloatWater", true )
addEventHandler( "takeFloatWater", root, takeFloatWater )

function onFishing(element)
    setPedAnimation(element,"SWORD","sword_IDLE")
end 
addEvent("onFishing",true)
addEventHandler("onFishing",root,onFishing)

function stopanim(thePlayer)
    setPedAnimation(thePlayer,false)
end 
addEvent("stopanim",true)
addEventHandler("stopanim",root,stopanim)

function addItemToPlayer(element,itemID,itemName)
	local serial = getPlayerSerial(element)
	exports["oInventory"]:giveItem(element, itemID, 1, 1, 0,0,itemName,serial)
	outputChatBox("additem for "..serial)
end 
addEvent("addItemToPlayer",true)
addEventHandler("addItemToPlayer",root,addItemToPlayer)