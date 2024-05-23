collisionObjectId = 2983

debugMode = true
core = exports.oCore

availableTypes = {
    [1] = {
        ["name"] = "Medve",
        ["loot"] = {
            {165, 1},
            {167, 4},
        },
        ["skin"] = 199,
		["health"] = 110,
        ["damageMultipler"] = 5,
		["hitDamage"] = 20,
        ["autoAttack"] = true,
    },
    [2] = {
        ["name"] = "Róka",
        ["loot"] = {
            {166, 1}, 
            {168, 2},
        },
        ["skin"] = 218,
		["health"] = 100,
        ["damageMultipler"] = 3,
		["hitDamage"] = 20,
        ["autoAttack"] = true,
    },
}

availableAnimals = {
    [1] = {
        ["animalType"] = 1,
        ["health"] = 1000,
        ["hitDamage"] = 1000,
        ["waypoints"] = {
            {192.60575866699,-543.85687255859,48.363327026367},
            {209.9175567627,-536.89654541016,50.159973144531},
            {224.58114624023,-554.15588378906,51.952423095703},
            {198.58532714844,-589.03070068359,48.006763458252},
            {210.60862731934,-701.73223876953,37.900405883789},
            {202.07496643066,-742.67333984375,29.735649108887},
            {188.38885498047,-760.62652587891,30.657054901123},
            {156.47738647461,-937.87152099609,25.319965362549},
            {160.23066711426,-959.89978027344,31.001239776611},
            {159.01342773438,-976.13220214844,37.994003295898},
        },
    },
    [2] = {
        ["animalType"] = 2,
        ["health"] = 1000,
        ["hitDamage"] = 1000,
        ["waypoints"] = {
            {404.41470336914,-880.06860351562,21.630407333374},
            {405.85321044922,-858.70465087891,25.685413360596},
            {455.24301147461,-893.91076660156,29.754201889038},
            {443.8857421875,-930.85821533203,47.772388458252},
            {380.53997802734,-914.40045166016,23.253910064697},
        },
    },    
    [3] = {
        ["animalType"] = 2,
        ["health"] = 1000,
        ["hitDamage"] = 1000,
        ["waypoints"] = {
            {378.1535949707,-896.11157226562,18.901298522949},
            {352.21820068359,-905.03057861328,20.010456085205},
            {288.7565612793,-905.04376220703,22.326671600342},
            {262.45944213867,-880.73175048828,11.329538345337},
            {262.75372314453,-851.23217773438,9.444206237793},
            {278.58511352539,-836.60943603516,7.4485340118408},
        },
    },
}

NPC_SPEED_ONFOOT = {
	walk = 1.5559, 
	run = 3.706, 
	sprint = 9.562, 
	sprintfast = 12.281
}

NPC_DATAINFO_NPC = -1
NPC_DATAINFO_TRUEDATA = -2

NPC_DATA_BEHAVIOR_WALK_SPEED = 1
NPC_DATA_BEHAVIOR_WEAPON_ACCURACY = 2
NPC_DATA_TASKNUM_FIRST = 3
NPC_DATA_TASKNUM_LAST = 4
NPC_DATA_TASKNUM_THIS = 5

NPC_TASK_WALK_TO_POS = 1
NPC_TASK_WALK_ALONG_LINE = 2
NPC_TASK_WALK_FOLLOW_ELEMENT = 3
NPC_TASK_SHOOT_POINT = 4
NPC_TASK_SHOOT_ELEMENT = 5
NPC_TASK_KILL_PED = 6

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
	return isElement(npc) and getElementData(npc,"huntingAnimal.isControllable") or false
end

function getNPCWalkSpeed(npc)
	if not isHLCEnabled(npc) then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	return getElementData(npc,"huntingAnimal.walk_speed")
end

function getNPCWeaponAccuracy(npc)
	--if not isHLCEnabled(npc) then
	--	outputDebugString("Invalid ped argument",2)
	--	return false
	--end
	return getElementData(npc,"huntingAnimal.accuracy")
end




