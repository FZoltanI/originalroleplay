core = exports.oCore
color, r, g, b = core:getServerColor()
font = exports.oFont 
infobox = exports.oInfobox
admin = exports.oAdmin

nameColor = "#db3535"
adminMessageColor = "#557ec9"
adminMessagePrefixColor = "#276ce3"

shopX,shopY,shopZ = 720.21130371094,-1345.4952392578,19.921899795532 
sRot = 185.20558166504

reHealPedPos = {
	[1] = {742.13977050781,-1476.6439208984,5.46875,181.60893249512},
	[2] = {1130.7681884766,-1874.6494140625,13.546875,130.84843444824},
	[3] = {1641.9389648438,-1848.20703125,13.540912628174,2.4039258956909},
	[4] = {1898.6488037109,-1815.2838134766,13.546875,57.237804412842},
	[5] = {2252.1047363281,-1694.8995361328,13.759140014648,268.71640014648},
	[6] = {2096.4084472656,-1443.3568115234,23.983930587769,269.36663818359},
	[7] = {1182.6213378906,232.86819458008,19.537956237793,64.108016967773},
	[8] = {1382.4066162109,474.37222290039,20.074615478516,334.20385742188},
	[9] = {1788.6196289062,-2006.7502441406,13.56987953186,0.57103109359741},
	[10] = {1864.9208984375,-1863.5523681641,13.579242706299,181.67935180664}, 
}

function getDogCastByID(modellID)
    modellID = tonumber(modellID)

    if modellID == 269 then 
        return "Boxer"
	elseif modellID == 270 then 
        return "Fekete Pitbull"
	elseif modellID == 271 then 
		return "Barna Pitbull"
	elseif modellID == 300 then 
		return "Bull Terrier"
	elseif modellID == 311 then 
		return "Dalmata"
	elseif modellID == 293 then 
		return "Doberman"
	elseif modellID == 9 then 
		return "Malac"
	elseif modellID == 1 then 
		return "Szibériai Husky"
    end 
end 

function getDogBestFoodByID(FoodID)
    if FoodID == 1 then 
        return "Vegán Eb Táp"
    elseif FoodID == 2 then 
        return "Marhahúsos Eb Táp"
    elseif FoodID == 3 then 
        return "Sertéshúsos Eb Táp"
    elseif FoodID == 4 then 
        return "Csirkehúsos Eb Táp"
    else 
        return "Ismeretlen Eledel"
    end 
end 

function getAnimalType(modellID)
	if modellID == 9 then 
		return "Disznó"
	else 
		return "Kutya"
	end 
end 


function getPercentageInLine(x, y, x1, y1, x2, y2)
	x, y = x - x1, y - y1
	local yx, yy = x2 - x1, y2 - y1
	
	return (x * yx + y * yy) / ( yx * yx + yy * yy)
end

function getAngleInBend(x, y, x0, y0, x1, y1, x2, y2)
	x, y = x - x0, y - y0
	local yx, yy = x1 - x0, y1 - y0
	local xx, xy = x2 - x0, y2 - y0
	local rx = (x * yy - y * yx) / (xx * yy - xy * yx)
	local ry = (x * xy - y * xx) / (yx * xy - yy * xx)

	return math.atan2(rx, ry)
end

function getPosFromBend(angle, x0, y0, x1, y1, x2, y2)
	local yx, yy = x1 - x0, y1 - y0 
	local xx, xy = x2 - x0, y2 - y0
	local rx, ry = math.sin(angle), math.cos(angle)

	return
		rx * xx + ry * yx + x0,
		rx * xy + ry * yy + y0
end

function isHLCEnabled(npc)
	return isElement(npc) and getElementData(npc,"ped.isControllable") or false
end

function getNPCWalkSpeed(npc)
	if not isHLCEnabled(npc) then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	return getElementData(npc,"ped.walk_speed")
end

function getNPCWeaponAccuracy(npc)
	return getElementData(npc,"ped.accuracy")
end