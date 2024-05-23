setTime(12,00)

local boxok = {
	{1771.3548583984, -1786.2309570313, 52.46875},
}

function betoltes()
	for k,v in ipairs(boxok) do 
		local col = createColCuboid( v[1], v[2], v[3]-1, 10, 10, 10)
		setElementData(col, "mechanic>boxcol", true)
	end
end
betoltes()
-----------

addEventHandler("onColShapeHit", getRootElement(), 
	function( player, mdim)
		if (mdim) and (getElementData(source,"mechanic>boxcol")) then 

			if tonumber(getElementData(player,"char:factionID")) == 4 then 
				triggerClientEvent(getRootElement(), "setMechanicPanelVisible", player, true, source)
			end

		end
	end
)

addEventHandler("onColShapeLeave", getRootElement(), 
	function( player, mdim)
		if (mdim) and (getElementData(source,"mechanic>boxcol")) then 
			triggerClientEvent(getRootElement(), "setMechanicPanelVisible", player, false)
		end
	end
)