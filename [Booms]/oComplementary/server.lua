local boneattach = exports.oBone
local conn = exports.oMysql:getDBConnection()

local markers = {
	{2376.953125,-1740.5885009766,13.546875, 0, 0},
}

for i,v in ipairs(markers) do
	local marker = createMarker( v[1], v[2], v[3] - 1, "cylinder", 2, serverColor[2], serverColor[3], serverColor[4], 155)
	setElementDimension ( marker, v[4])
	setElementInterior( marker, v[5])
	setElementData(marker, "complementary:marker", true)
end

addEvent("Complementary:Buy", true)
addEventHandler("Complementary:Buy", root,
	function (thePlayer, etype ,index)
	local pMoney = getElementData(thePlayer, "char:money")	
		if (pMoney >= complementaryElements[etype][index][2]) then
			setElementData(thePlayer, "char:money" ,pMoney-complementaryElements[etype][index][2])
			triggerClientEvent(thePlayer, "complementary:newcomplementary", thePlayer, etype, {complementaryElements[etype][index][1], complementaryElements[etype][index][3], {0, 0, 0, 0, 0, 0}, false})
			local comptable = getElementData(thePlayer, "complementarytable") or {["Police"]={},["Órák"]={},["Szemüvegek"]={},["Sapkák"]={},}	 
			if (comptable[etype]) then
				table.insert(comptable[etype], {complementaryElements[etype][index][1], complementaryElements[etype][index][3], {0, 0, 0, 0, 0, 0}, false})
			end	
			setElementData(thePlayer,  "complementarytable", comptable)
		end
	end
)

function attachComplementary(thePlayer, thetable, thebone, etype)
	local thebone = complementaryBones[etype]
	if (thePlayer) and (thetable) then	
		if (etype == "Police") then
			for i,v in ipairs(complementaryElements["Police"]) do
				if (v[1] == thetable[1]) then
					thebone = v[4]
				end	
			end
		end	
		local obj = createObject(thetable[2], 0, 0, 0)
		local objtable = getElementData(thePlayer, "comeplementary.table") or {}
		boneattach:attachElementToBone(obj, thePlayer, thebone, thetable[3][1], thetable[3][2], thetable[3][3], thetable[3][4], thetable[3][5], thetable[3][6])
		if (thetable[3][7]) then
			setObjectScale(obj, thetable[3][7], thetable[3][8], thetable[3][9])
		end	
		table.insert(objtable, obj)
		setElementData(thePlayer, "comeplementary.table", objtable)	
	end	
end
addEvent("Complementary:Attach", true)
addEventHandler("Complementary:Attach", root, attachComplementary)

addEvent("Complementary:DelObject", true)
addEventHandler("Complementary:DelObject", root,
	function (thePlayer, objType)
		local objtable = getElementData(thePlayer, "comeplementary.table") or {}

		if (#objtable > 0) then
			for k, v in pairs(objtable) do
				if isElement(v) then 
					if (objType == getElementModel(v)) then
						destroyElement (v)
						table.remove(objtable, k)
						setElementData(thePlayer, "comeplementary.table", objtable)
						break
					end
				end	
			end
		end	
	end
)

function loadComplementary(thePlayer)
	local id = getElementData(thePlayer, "char:id")
	local qh = dbQuery(conn, "SELECT complementarys, complementaryslot FROM characters WHERE id=?", id)
	local severcomplementary = dbPoll(qh, 150)
	if (severcomplementary) then
		if (#severcomplementary > 0) then
			setTimer(function ()
				local ctable = fromJSON(severcomplementary[1]["complementarys"]) or {["Police"]={},["Órák"]={},["Szemüvegek"]={},["Sapkák"]={},}	
				for i,v in ipairs(complementaryTypes) do
					if not(ctable[v[1]]) then
						ctable[v[1]] = {}
					end	
				end
				setElementData(thePlayer, "char:complementaryslot", severcomplementary[1]["complementaryslot"])
				triggerClientEvent(thePlayer , "complementary:getthetable", thePlayer, ctable)
				setElementData(thePlayer, "complementarytable", ctable)

				for k, v in pairs(ctable) do 	
				local etype = k	
					for k2, v2 in pairs(v) do 
						if v2[4] then 
							attachComplementary(thePlayer, v2, complementaryBones[k], etype)
						end
					end
				end
			end, 2000, 1)
		end
	end
end

addEventHandler( "onResourceStop", resourceRoot,
    function( resource )
    for i, player in ipairs(getElementsByType("player")) do 
    	local comptable = getElementData(player, "complementarytable") or {["Police"]={},["Órák"]={},["Szemüvegek"]={},["Sapkák"]={},}	
		local id = getElementData(player, "char:id")
		local slots = getElementData(player, "char:complementaryslot") or 2
		dbExec(conn, "UPDATE characters SET complementarys=?, complementaryslot=?  WHERE id=?", toJSON(comptable), slots, id)
	    end
	end	
)

for i, player in ipairs(getElementsByType("player")) do 
	loadComplementary(player)
end

addEventHandler("onElementDataChange", root,
	function(key, oldv, newv)
		if (getElementType(source) == "player") and (key=="char:id") then
			loadComplementary(source)
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		local objtable = getElementData(source, "comeplementary.table")
		local comptable = getElementData(source, "complementarytable") or {["Police"]={},["Órák"]={},["Szemüvegek"]={},["Sapkák"]={},}	
		local id = getElementData(source, "char:id")
		local slots = getElementData(source, "char:complementaryslot") or 2
		dbExec(conn, "UPDATE characters SET complementarys=?, complementaryslot=?  WHERE id=?", toJSON(comptable), slots, id)
		if (#objtable > 0) then
			for i=1,#objtable do
				if objtable[i] and (isElement(objtable[i])) then
					destroyElement (objtable[i])
				end	
			end
		end    
	end
)

addEvent("Complementary:BuySlot", true)
addEventHandler("Complementary:BuySlot", root,
	function (thePlayer)
		local premium  = getElementData(thePlayer, "char:pp")
		local slots = getElementData(thePlayer, "char:complementaryslot") or 2
		if (premium>=1000) then
			setElementData(thePlayer, "char:pp", premium-1000)
			setElementData(thePlayer, "char:complementaryslot", slots+1)
		end
	end
)