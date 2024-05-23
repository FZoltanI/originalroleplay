cardRanks = {
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "J",
  "Q",
  "K",
  "A"
}
cardSuits = {
  "S",
  "H",
  "D",
  "C"
}
secondaryValues = {
  1,
  4,
  13,
  40,
  121,
  364,
  1093,
  3280,
  9841,
  29524,
  88573,
  265720,
  797161
}
handRankings = {
  ROYAL_FLUSH = 1,
  STRAIGHT_FLUSH = 2,
  FOUR_OF_A_KIND = 3,
  FULL_HOUSE = 4,
  FLUSH = 5,
  STRAIGHT = 6,
  THREE_OF_A_KIND = 7,
  TWO_PAIRS = 8,
  ONE_PAIR = 9,
  HIGH_HAND = 10
}
evaluationNames = {
  ROYAL_FLUSH = "Royal Flush",
  STRAIGHT_FLUSH = "Szín sor",
  FOUR_OF_A_KIND = "Póker",
  FULL_HOUSE = "Full House",
  FLUSH = "Flöss",
  STRAIGHT = "Sor",
  THREE_OF_A_KIND = "Drill",
  TWO_PAIRS = "Két Pár",
  ONE_PAIR = "Pár",
  HIGH_HAND = "Magas Lap"
}

interactionTime = 30000
minimumPlayers = 2
maximumPlayers = 9


guiPositions = {
  {-1.29, -0.95},
  {-2.35, -0.5},
  {-2.35, 0.5},
  {-1.29, 0.95},
  {0, 0.95},
  {1.29, 0.95},
  {2.35, 0.5},
  {2.35, -0.5},
  {1.29, -0.95}
}
realGuiPositions = {}
pedPositionZ = 0.9

--[[
    {0.7, 0.5},
  {1.5, -0.3},
  {2.25, -1.4},
  {1.5, -2.2},
  {0.2, -1.8},
  {-1.8, 0.2},
  {-2.2, 1.3},
]]
pedPositions = {
  {
    -1.3,
    -1.5,
    0
  },
  {
    -2.8,
    -0.7,
    -60
  },
  {
    -2.8,
    0.7,
    -120
  },
  {
    -1.3,
    1.5,
    180
  },
  {
    0,
    1.5,
    180
  },
  {
    1.3,
    1.5,
    180
  },
  {
    2.8,
    0.7,
    120
  },
  {
    2.8,
    -0.7,
    60
  },
  {
    1.3,
    -1.5,
    0
  }
}

function rotateAround(angle, x, y)
	angle = math.rad(angle)
	local cosinus, sinus = math.cos(angle), math.sin(angle)
	return x * cosinus - y * sinus, x * sinus + y * cosinus
end

pokerTables = {
  -- X,Y,Z, ROTX,ROTY,ROTZ, INT,DIM, MinBet, maxBet
  {2507.7355957031,-2393.1665039062,13.453125, 0, 0, 135, 0, 0, 200, 1000},
  {941.34515380859,-1333.4251708984,13.546875, 0, 0, 0,0,0,200,1000}
}


function generateTables()
 --iprint(pokerTables)
  for k, v in pairs(pokerTables) do
    realGuiPositions[k] = {}
    for i, u in pairs(pedPositions) do
     -- print(rotateAround(v[6], u[1], u[2]))
      realGuiPositions[k][i] = {
        v[1] + rotateAround(v[6], u[1], u[2]),
        v[2] + rotateAround(v[6], u[1], u[2]),
        v[3]
      }
    end
  end
  --iprint(realGuiPositions)
end