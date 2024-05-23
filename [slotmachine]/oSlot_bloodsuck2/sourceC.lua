local screenX, screenY = guiGetScreenSize()
local posX, posY = screenX/2-799/2, screenY/2-661/2 --képernyő közepe
local logoW, logoH = 1280/1.2, 720/1.2
local logoX, logoY = screenX/2 - logoW/2, screenY/2 - logoH/2

local currentLoot = {}
local slots = {}
local jokerSymbolIndex = 10
local credit = 0
local moneyInMachine = nil
local currentAwards = {}
local winnerSymbols = {}
local winnerSlots = {}
local isSpinning = nil
local betPerLineTableCounter = 1
local totalBet = 4
local maximumSlots = 15
local totalWinOverAll = 0

local freePlayCurrentAmount = 0

local gameState = false

local availableSymbols = {
    [1] = {
        "1",
        {--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/1.png",
    },    
    [2] = {
        "2",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/2.png",
    },    
    [3] = {
        "3",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/3.png",
    },    
    [4] = {
        "4",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/4.png",
    },    
    [5] = {
        "5",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/5.png",
    },    
    [6] = {
        "6",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/6.png",
    },    
    [7] = {
        "7",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/7.png",
    },    
    [8] = {
        "8",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/8.png",
    },    
    [9] = {
        "9",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/demon.png",
    },    
    [10] = {
        "10",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/wild.png",
    },    
    [11] = {
        "11",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/scatter.png",
    },
    [12] = {
        "12",
				{--1es vonal[4]
                [3] = 10,
                [4] = 50,
                [5] = 200,
        },
        {--2es vonal[5]
                [3] = 12,
                [4] = 75,
                [5] = 300,
        },
        {--3es vonal[8]
                [3] = 10,
                [4] = 100,
                [5] = 400,
        },
        {--4s vonal[10]
                [3] = 25,
                [4] = 125,
                [5] = 500,
        },
        {--5es vonal[15]
                [3] = 35,
                [4] = 180,
                [5] = 750,
        },
        {--6es vonal[20]
                [3] = 50,
                [4] = 250,
                [5] = 1000,
        },
        {--7es vonal[30]
                [3] = 150,
                [4] = 750,
                [5] = 3000,
        },
        {--8es vonal[40]
                [3] = 200,
                [4] = 1000,
                [5] = 4000,
        },
        {--9es vonal[50]
                [3] = 250,
                [4] = 1250,
                [5] = 5000,
        },
        {--10es vonal[100]
                [3] = 500,
                [4] = 2500,
                [5] = 10000,
        },
        {--11es vonal[200]
                [3] = 1000,
                [4] = 5000,
                [5] = 20000,
        },
        {--11es vonal[500]
                [3] = 2500,
                [4] = 12500,
                [5] = 50000,
        },
        "files/img/bonus.png",
    },
}

local lineWayPoints = {
	[1] = {6, 7, 8, 9, 10},
	[2] = {1, 2, 3, 4, 5},
	[3] = {11, 12, 13, 14, 15},
	[4] = {1, 7, 13, 9, 5},
	[5] = {11, 7, 3, 9, 15},
	[6] = {1, 2, 8, 14, 15},
	[7] = {6, 12, 13, 14, 10},
	[8] = {6, 2, 3, 4, 10},
	[9] = {11, 12, 8, 4, 5},
	[10] = {11, 7, 8, 9, 5},
}

local linesInUse = {
	[1] = true,
	[2] = false,
	[3] = false,
	[4] = false,
	[5] = false,
	[6] = false,
	[7] = false,
	[8] = false,
	[9] = false,
	[10] = false,
}

function fillUpGameSlots()	
	local i=1
	for line=1,3 do
		for row=1,5 do
			slots[i] = {posX-10+140*row,posY-190+140*line, i}
			i=i+1
		end
	end
end

fillUpGameSlots()

--Randomizálás elkezdése, Van benne pár misc, módosítanivaló
function startRandomizingSlots()
	--ha nem pörög [[biztonsági cucc]]
        if not isSpinning then

        --ha indul freeplay
        if freePlayStarting then
                freePlayRandomizer() --freeplay randomizálót elindítjuk
                freePlayRandomizerSpinning = true --a randomizáló pörög
                isSpinning = true --a gép pörög, addig nemenged kattintani amíg a randomizáló pörög
        end

        if credit > 0 and not freePlayMode and not freePlayStarting and credit - totalBet > 0 then
                credit = credit - totalBet --akkor levesszük
                setMachineCredit(credit)
        end

        roundAward = 0

        --ha freeplay mód akkor számolja lefelé a köröket
        if freePlayMode and freePlayRoundCount > 0 then
                freePlayRoundCount = freePlayRoundCount - 1
                allFreePlayRounds = allFreePlayRounds + 1
                if freePlayRoundCount == 0 then
                        freePlayLastRound = true
                else
                        freePlayLastRound = false
                end
                status = "Hátralévő szabadjátékok: "..freePlayRoundCount
        else
                status = "Pörgetés.."
        end


        --ha nem indul szabadjáték, akkor indítjuk a sima játékot
        if not freePlayStarting then
                initFakeLootGenerating()
                isSpinning = true

                --[[randomizer = setTimer(function() 
                        isSpinning = true
                        fillUpGameSlots()
                end, 50, 0)
                setTimer(function()
                        killTimer(randomizer)
                        loopThroughLines()
                end, 6000, 1)]]--
        end

        --kikapcsoljuk a tétvonalakat
        linesEnabled = false
        end 
end


--Lootgenerálás táblái--
local fakeLootTick = 1
local fakeGenerateTimer = false
local currentLoot = {}
local finalLoot = {}
local columnGeneration = {}
local columnSound = {}
 -----------------------

function generateFakeLoot()
	
	--kiürítjük a loot táblát
	currentLoot = {}

	if not columnGeneration[1] then
		currentLoot[1] = finalLoot[1]
		currentLoot[6] = finalLoot[6]
		currentLoot[11] = finalLoot[11]
		if not columnSound[1] then
			columnSound[1] = true

			if soundsEnabled then
			--	playSound("files/slot.mp3")
			end

			if currentLoot[1] == 10 or currentLoot[6] == 10 or currentLoot[11] == 10 then
				if soundsEnabled then
				--	oszlop = playSound("files/oszlop1.mp3")
				end
			end
		end
	end
	if not columnGeneration[2] then
		currentLoot[2] = finalLoot[2]
		currentLoot[7] = finalLoot[7]
		currentLoot[12] = finalLoot[12]
		if not columnSound[2] then
			columnSound[2] = true

			if soundsEnabled then
			--	oszlop = playSound("files/slot.mp3")
			end

			if currentLoot[2] == 10 or currentLoot[7] == 10 or currentLoot[12] == 10 then
			--	playSound("files/droid.mp3")
			end
		end
	end
	if not columnGeneration[3] then
		currentLoot[3] = finalLoot[3]
		currentLoot[8] = finalLoot[8]
		currentLoot[13] = finalLoot[13]
		if not columnSound[3] then
			columnSound[3] = true

			if soundsEnabled then
			--	playSound("files/slot.mp3")
			end

			if currentLoot[3] == 10 or currentLoot[8] == 10 or currentLoot[13] == 10 then
				if soundsEnabled then
				--	oszlop = playSound("files/oszlop3.mp3")
				end
			end
		end
	end
	if not columnGeneration[4] then
		currentLoot[4] = finalLoot[4]
		currentLoot[9] = finalLoot[9]
		currentLoot[14] = finalLoot[14]
		if not columnSound[4] then
			columnSound[4] = true

			if soundsEnabled then
			--	playSound("files/slot.mp3")
			end

			if currentLoot[4] == 10 or currentLoot[9] == 10 or currentLoot[14] == 10 then
			--	playSound("files/droid.mp3")
			end
		end
	end
	if not columnGeneration[5] then
		currentLoot[5] = finalLoot[5]
		currentLoot[10] = finalLoot[10]
		currentLoot[15] = finalLoot[15]
		if not columnSound[5] then
			columnSound[5] = true
			if soundsEnabled then
			--	playSound("files/slot.mp3")
			end

			if currentLoot[5] == 10 or currentLoot[10] == 10 or currentLoot[15] == 10 then
				if soundsEnabled then
				--	oszlop = playSound("files/oszlop5.mp3")
				end
			end
		end
	end
 
	for i = 1, maximumSlots do
		local currentNumber = math.random(1, #availableSymbols)
		if availableSymbols[currentNumber] then
			if not currentLoot[i] then
				currentLoot[i] = currentNumber
			end
		end
	end
	   
	fakeLootTick = fakeLootTick + 1 -- 1 tick -> 50ms

	 if fakeLootTick >= 20 and fakeLootTick < 40 then -- Első oszlop
		columnGeneration[1] = false

	elseif fakeLootTick >= 40 and fakeLootTick < 60 then -- Második oszlop
		columnGeneration[2] = false

	elseif fakeLootTick >= 60 and fakeLootTick < 80 then -- Harmadik oszlop
		columnGeneration[3] = false

	elseif fakeLootTick >= 80 and fakeLootTick < 98 then -- Negyedik oszlop
		columnGeneration[4] = false

	elseif fakeLootTick >= 98 and fakeLootTick < 100 then -- Ötödik oszlop
		columnGeneration[5] = false

	elseif fakeLootTick >= 100 then

		-- Leállítjuk
		if isTimer(fakeGenerateTimer) then
				killTimer(fakeGenerateTimer)
		end
		fakeGenerateTimer = false
		currentLoot = finalLoot

		setTimer(
			function ()
				loopThroughLines()
                isSpinning = false
			end,
		800, 1)
	end
end
--generateFakeLoot()

function initFakeLootGenerating()
	finalLoot = {}
 
	finalLoot = generateLoot(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
	--finalLoot = currentLoot
	fakeLootTick = 1
 
	columnGeneration[1] = true
	columnGeneration[2] = true
	columnGeneration[3] = true
	columnGeneration[4] = true
	columnGeneration[5] = true		

	columnSound[1] = false
	columnSound[2] = false
	columnSound[3] = false
	columnSound[4] = false
	columnSound[5] = false
	fakeGenerateTimer = setTimer(generateFakeLoot, 50, 0) -- Ezzel indítod a generálást
end


--loot generálás, táblába pakolgatás, randomizálás
function generateLoot(...)
	currentLoot = {}
	local localLoot = {}
	counter = 0
	local specialItems = {...}
	local placedSpecialItems = {} -- Speciális itemek oszloponként
	placedSpecialItems[1] = {}
	placedSpecialItems[2] = {}
	placedSpecialItems[3] = {}
	placedSpecialItems[4] = {}
	placedSpecialItems[5] = {}
 
	for i = 1, maximumSlots do
 
		local shallRepeat = true
 
		repeat

			local currentNumber = math.random(1, #availableSymbols)

			if availableSymbols[currentNumber] then
				local canPlace = true
				for k,v in pairs(specialItems) do              
					if currentNumber == v then
						if i == 1 or i == 6 or i == 11 then -- Első oszlop
							if placedSpecialItems[1][v] then
									canPlace = false
							else
									placedSpecialItems[1][v] = true
									canPlace = true
							end
						elseif i == 2 or i == 7 or i == 12 then -- Második oszlop
								if placedSpecialItems[2][v] or currentNumber == 10 then
										canPlace = false
								else
										placedSpecialItems[2][v] = true
										canPlace = true
								end
						elseif i == 3 or i == 8 or i == 13 then -- Harmadik oszlop
								if placedSpecialItems[3][v] then
										canPlace = false
								else
										placedSpecialItems[3][v] = true
										canPlace = true
								end
						elseif i == 4 or i == 9 or i == 14 then -- Negyedik oszlop
								if placedSpecialItems[4][v] or currentNumber == 10 then
										canPlace = false
								else
										placedSpecialItems[4][v] = true
										canPlace = true
								end
						elseif i == 5 or i == 10 or i == 15 then -- Ötödik oszlop
								if placedSpecialItems[5][v] then
										canPlace = false
								else
										placedSpecialItems[5][v] = true
										canPlace = true
								end
						end
						break
					end
				end
 
				if canPlace then
					localLoot[tonumber(i)] = currentNumber
					shallRepeat = false
				else
					shallRepeat = true
				end
			end	
		until not shallRepeat
	end

	currentLoot = localLoot

	return localLoot
end
currentLoot = generateLoot()
fillUpGameSlots()

--startRandomizingSlots()

addEventHandler("onClientResourceStart",getRootElement(), function(startResource)
    if startResource == getThisResource() then 
        core = exports.oCore
        infobox = exports.oInfobox
        font = exports.oFont
        color, r, g, b = core:getServerColor()
        serverColor, r, g, b = core:getServerColor()
    elseif getResourceName(startResource) == "oCore" or getResourceName(startResource) == "oInfobox" or getResourceName(startResource) == "oFont" then 
        core = exports.oCore
        infobox = exports.oInfobox
        font = exports.oFont
        color, r, g, b = core:getServerColor()
        serverColor, r, g, b = core:getServerColor()
    end
end)

addEventHandler("onClientRender",getRootElement(), function()
    
    
    dxDrawRoundedRectangle(logoX-2.5,logoY-2.5, logoW+5, logoH+5, tocolor(0, 0, 0, 255), 8)
    dxDrawImage(logoX,logoY, logoW, logoH, "files/img/bg.png")


    for i,slot in pairs(slots) do
        --iprint(availableSymbols[currentLoot[slot[3]]][14])
        if freePlayMode and currentLoot[slot[3]] == freePlaySymbolIndex then
            dxDrawImage(slot[1]+56, slot[2]+155, 115, 115, availableSymbols[currentLoot[slot[3]]][14])
        elseif freePlayMode then
            dxDrawImage(slot[1]+56, slot[2]+155, 115, 115, availableSymbols[currentLoot[slot[3]]][14])
        else 
            dxDrawImage(slot[1]+56, slot[2]+155, 115, 115, availableSymbols[currentLoot[slot[3]]][14])
        end
    end
end)

addEventHandler("onClientClick", getRootElement(), function(button, state)
    if button == "left" and state == "down" then 
        if isInSlot(posX + 350, posY + 661 - 150, 100, 100) then 
            startRandomizingSlots()
        end
    end
end)

function loopThroughLines()

end

local corner = dxCreateTexture("files/img/corner.png", "argb", true, "clamp")

function dxDrawRoundedRectangle(x, y, w, h, color, radius, postGUI, subPixelPositioning)
	radius = radius or 5
	color = color or tocolor(0, 0, 0, 200)
	
	dxDrawImage(x, y, radius, radius, corner, 0, 0, 0, color, postGUI)
	dxDrawImage(x, y + h - radius, radius, radius, corner, 270, 0, 0, color, postGUI)
	dxDrawImage(x + w - radius, y, radius, radius, corner, 90, 0, 0, color, postGUI)
	dxDrawImage(x + w - radius, y + h - radius, radius, radius, corner, 180, 0, 0, color, postGUI)
	
	dxDrawRectangle(x, y + radius, radius, h - radius * 2, color, postGUI, subPixelPositioning)
	dxDrawRectangle(x + radius, y, w - radius * 2, h, color, postGUI, subPixelPositioning)
	dxDrawRectangle(x + w - radius, y + radius, radius, h - radius * 2, color, postGUI, subPixelPositioning)
end