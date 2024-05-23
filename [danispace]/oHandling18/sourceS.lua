local handlings = {
	[527] = {2500, 3400, 2.2, 0, 0.15, -0.03, 70, 0.8, 0.5, 0.5, 5, 190, 20, 60, 'awd', 'petrol', 13, 0.6, true, 30, 1.4, 0.12, 0, 0.3, -0.08, 0.5, 0, 0.26, 0.5}, 
	[491] = {4200, 5000, 2, 0, -0.2, -0.2, 70, 1.2, 0.9, 0.5, 5, 306, 62.2, 45, 'awd', 'petrol', 321.1, 0.45, true, 25, 1.5, 0.2, 0.98, 0.2, -0.15, 0.5, 0.6, 0.4, 0.54, 9000, 0, 0, 0, 0, 0}, 
	[545] = {4200, 4000, 2, 0, -0.2, -0.2, 70, 0.8, 0.9, 0.5, 5, 284, 28.5, 40, 'awd', 'petrol', 21.1, 0.48, true, 35, 0.92, 0.2, 0, 0.1, -0.15, 0.5, 0.6, 0.4, 0.54, 20000, 0, 0, 2, 1, 0}, 
	[529] = {6800, 4350, 2, 0, 0, 0, 70, 0.9, 0.8, 0.52, 5, 180, 9.6, 25, 'rwd', 'petrol', 8.4, 0.6, true, 30, 1.1, 0.15, 0, 0.32, -0.14, 0.5, 0, 0.26, 0.54, 19000, 40000000, 0, 0, 3, 0}, 
	[475] = {3700, 4600, 1.2, 0, -0.2, -0.2, 1, 1, 1.2, 0.49, 5, 210, 10, 45, 'awd', 'petrol', 19.1, 0.28, true, 22, 0.61, 0.2, 0, 0.1, -0.25, 0.45, 0, 0.4, 0.11, 19000, 0, 10000006, 1, 1, 0}, 
	[503] = {3200, 4500, 1.2, 0, -0.2, -0.2, 1, 1.1, 1.2, 0.49, 5, 280, 27, 35, 'awd', 'petrol', 31.1, 0.28, true, 22, 0.8, 0.2, 0, 0.1, -0.15, 0.5, 0.6, 0.4, 0.11, 45000, 1000, 4000000, 1, 1, 0}, 
	[496] = {2600, 4700, 2, 0, 0.15, -0.3, 75, 1.12, 0.82, 0.43, 5, 190, 53, 70, 'awd', 'electric', 97, 0.6, true, 50, 0.75, 0.15, 0, 0.2, -0.15, 0.56, 0.55, 0.2, 0.67, 35000, 0, 3, 1, 1, 0},  	
	[546] = {3800, 5350, 2, 0, 0.15, -0.3, 70, 0.92, 1.26, 0.52, 5, 172, 22.2, 39, 'awd', 'electric', 18.4, 0.6, true, 30, 1.69, 0.59, 0.68, 0.32, -0.15, 0.54, 0, 0.26, 0.54, 19000, 0, 1, 0, 3, 0}, 	
	[409] = {2500, 10000, 1.8, 0, 0, 0, 75, 0.6, 0.8, 0.5, 5, 110, 7.2, 25, 'rwd', 'petrol', 10, 0.4, true, 30, 1.1, 0.07, 0, 0.35, -0.2, 0.5, 0, 0.2, 0.72, 40000, 0, 0, 1, 1, 0}, 
	[411] = {4300, 2930, 1.8, 0, 0.15, -0.3, 75, 1.3, 0.9, 0.437, 5, 289, 28, 35, 'awd', 'petrol', 200, 0.4, true, 55, 1.2, 0.19, 0, 0.25, -0.1, 0.5, 0.4, 0.37, 0.64, 95000, 40002004, 1, 1, 1}, 
	[483] = {1900, 4000, 2.6, 0, -0.5, -0.4, 85, 0.6, 0.8, 0.46, 5, 82, 6.4, 20, 'rwd', 'petrol', 8.5, 0.45, true, 30, 1.1, 0.08, 0, 0.35, -0.1, 0.4, 0.5, 0.2, 0.5, 26000, 4000, 400000, 0, 1, 0}, 
	[498] = {5500, 10000, 3, 0, 0, 0, 80, 0.82, 0.7, 0.46, 5, 140, 5.6, 10, 'awd', 'diesel', 4.5, 0.6, true, 20, 0.9, 0.08, 0, 0.25, -0.25, 0.35, 0.6, 0.26, 0.4, 22000, 0, 0, 0, 3, 13},
	--[547] = {5200, 3800, 2.2, 0, 0, 0, 70, 0.8, 0.7, 0.4, 4, 144, 37, 105, 'rwd', 'petrol', 70, 0.8, true, 45, 1.1, 0.14, 0, 0.32, -0.14, 0.5, 0, 0.26, 0.62, 19000, 0, 0, 0, 3, 0},
	[445] = {2600, 4700, 2, 0, 0.15, -0.3, 75, 1.12, 0.82, 0.43, 5, 190, 53, 90, 'rwd', 'petrol', 80, 0.6, true, 50, 0.55, 0.15, 0, 0.2, -0.3, 0.5, 0.55, 0.2, 0.67, 35000, 0, 400000, 0, 1, 0},
	[602] = {5300, 6400, 2.4, 0, 0.15, -0.3, 55, 1.38, 0.86, 0.5, 5, 238.2, 38.2, 72, 'awd', 'petrol', 76, 0.55, true, 25.2, 1.4, 0.8, 0.9, 0.3, -0.15, 0.5, 0, 0.25, 0.5, 35000, 40002800, 200000, 1, 1, 0},  	
	[428] = {7000, 30916.699, 1.5, 0, 0, 0, 90, 0.5, 0.7, 0.46, 5, 170, 6, 30, 'rwd', 'diesel', 8.4, 0.45, true, 27, 1, 0.06, 0, 0.35, -0.15, 0.5, 0, 0.27, 0.35, 40000, 4001, 4, 1, 1, 13},
	--[542] = {4600, 3700, 0.8, 0, 0.15, -0.3, 75, 0.9, 0.8, 0.46, 5, 165, 20, 70, 'rwd', 'petrol', 39, 0.5, true, 55, 0.55, 0.1, 0, 0.1, -0.2, 0.5, 0.25, 0.25, 0.63, 19000, 40280000, 10008004, 1, 1, 0},
	[410] = {3600, 2300, 1.8, 0, 0.2, 0, 70, 0.8, 0.9, 0.477, 5, 210, 23, 160, 'rwd', 'petrol', 40, 0.8, true, 30, 1.2, 0.1, 5, 0.31, -0.15, 0.5, 0.2, 0.26, 0.67, 9000, 0, 0, 0, 0, 0},
	[599] = {7500, 9800, 1, 0, 0.1, -0.3, 120, 0.95, 0.85, 0.5, 5, 210, 72.2, 55, 'awd', 'diesel', 42.2, 0.6, true, 35, 0.7, 0.4, 1, 0.3, -0.25, 0.5, 0.25, 0.2, 0.2, 25000, 284020, 308800, 0, 1, 0}, 
	[505] = {4400, 3200, 2.5, 0, 0, -0.35, 80, 0.83, 0.85, 0.54, 5, 139, 15, 130, 'awd', 'petrol', 7, 0.45, true, 35, 0.8, 0.08, 0, 0.45, -0.25, 0.45, 0.3, 0.44, 0.65, 40000, 4020, 100004, 0, 1, 0},
	[507] = {3400, 3700, 1.8, 0, 0.1, -0.1, 75, 1, 0.8, 0.46, 5, 150, 12, 23, 'rwd', 'petrol', 6, 0.55, true, 30, 1, 0.1, 0, 0.35, -0.15, 0.5, 0.3, 0.2, 0.74, 35000, 40000000, 10400000, 0, 1, 0},
	[526] = {2700, 4166.4, 2, 0, 0, -0.2, 70, 0.7, 0.84, 0.53, 4, 160, 15, 10, 'awd', 'petrol', 8.17, 0.52, true, 35, 1.2, 0.15, 0, 0.3, -0.1, 0.5, 0.25, 0.3, 0.52, 19000, 40000000, 4, 1, 1, 0}, 
	[492] = {2600, 4700, 2, 0, 0.15, -0.3, 75, 1.12, 0.82, 0.43, 5, 190, 53, 90, 'rwd', 'petrol', 80, 0.6, true, 50, 0.55, 0.15, 0, 0.2, -0.3, 0.5, 0.55, 0.2, 0.67, 35000, 0, 400000, 0, 1, 0}, 
	[442] = {5000, 3500, 2.5, 0, 0, -0.3, 85, 0.75, 0.85, 0.5, 5, 222, 17, 40, 'awd', 'petrol', 10, 0.6, true, 35, 2, 0.8, 0.2, 0.75, -0.15, 0.5, 0.25, 0.27, 0.23, 10000, 0, 0, 0, 1, 0}, 
	[579] = {2500, 6000, 2.5, 0, 0, -0.2, 80, 0.62, 0.89, 0.5, 5, 160, 10, 25, 'awd', 'petrol', 7, 0.45, true, 35, 1, 0.05, 0, 0.45, -0.21, 0.45, 0.3, 0.44, 0.35, 40000, 20, 4404, 0, 1, 0},
	[565] = {2600, 3700, 2.2, 0, 0.2, -0.1, 75, 0.75, 0.9, 0.4, 5, 160, 11, 20, 'fwd', 'petrol', 5, 0.55, true, 30, 1.4, 0.15, 0, 0.28, -0.1, 0.5, 0.3, 0.25, 0.6, 35000, 2804, 4000001, 1, 1, 1}, 
	[598] = {3500, 5600, 3.9, 0, 0, 0, 40, 0.8, 1.2, 0.5, 5, 220, 17.5, 15, 'awd', 'petrol', 11, 0.45, true, 30, 1.2, 0.12, 0, 0.28, -0.24, 0.5, 0.4, 0.25, 0.5, 25000, 0, 3, 0, 1, 0},  
	[596] = {4200, 4000, 2, 0, 0.15, -0.05, 70, 0.83, 0.9, 0.5, 5, 242.2, 20.3, 20, 'awd', 'petrol', 10.4, 0.9, true, 30, 0.7, 0.9, 0.6, 0.3, -0.2, 0.55, 0, 0.26, 0.54, 25000, 0, 20000, 0, 1, 0},  
	[597] = {4200, 7000, 2, 0, 0.15, -0.1, 70, 0.75, 1.1, 0.5, 5, 242.2, 20.3, 20, 'awd', 'petrol', 10.4, 0.9, true, 30, 0.7, 0.9, 0.6, 0.3, -0.2, 0.55, 0, 0.26, 0.54, 25000, 0, 20000, 0, 1, 0},  
	--[467] = {3400, 4200, 2, 0, 0, 0, 75, 0.67, 1.2, 0.4, 5, 123, 20, 85, 'awd', 'petrol', 5, 0.55, true, 20, 1, 0.1, 0, 0.35, -0.15, 0.5, 0.5, 0.23, 0.63, 20000, 0, 10800000, 2, 1, 0},
	[586] = {800, 600, 4, 0, 0.1, 0, 103, 1.4, 0.85, 0.48, 4, 190, 16, 5, 'rwd', 'petrol', 10, 0.55, true, 35, 0.65, 0.2, 0, 0.09, -0.11, 0.55, 0, 0, 0.24, 10000, 41002000, 0, 1, 1, 8},
	[479] = {1500, 3800, 2, 0, 0.2, 0, 75, 0.65, 0.85, 0.52, 4, 210, 11.2, 25, 'fwd', 'petrol', 5, 0.6, true, 30, 1, 0.1, 0, 0.27, -0.17, 0.5, 0.2, 0.24, 0.48, 18000, 20, 1, 1, 1, 0},
	[402] = {5500, 8500, 2, 0, 0.15, -0.3, 70, 0.75, 1.2, 0.53, 5, 218, 18.6, 55, 'awd', 'petrol', 12.17, 0.52, true, 35, 1, 1.3, 1.5, 0.2, -0.15, 0.44, 0.25, 0.3, 0.52, 35000, 2800, 10200000, 1, 1, 0}, 
	[426] = {3600, 4921.3, 1.8, 0, -0.4, 0, 75, 0.75, 0.85, 0.52, 5, 200, 16.8, 55, 'awd', 'petrol', 10, 0.53, true, 35, 1.3, 0.12, 0, 0.28, -0.12, 0.38, 0, 0.2, 0.24, 25000, 0, 0, 0, 1, 0}, 
	[502] = {5600, 6600, 1.4, 0, 0.15, -0.1, 70, 0.9, 0.95, 0.47, 5, 285, 50, 70, 'awd', 'petrol', 90, 0.52, true, 30, 1.5, 0.1, 0.1, 0.2, -0.15, 0.6, 0.4, 0.2, 0.63, 45000, 0, 0, 1, 1, 0}, 
	[404] = {5500, 8500, 2.5, 0, 0, -0.3, 85, 0.75, 0.85, 0.5, 5, 200, 15, 30, 'awd', 'petrol', 10, 0.6, true, 35, 2, 0.8, 4, 0.2, -0.15, 0.5, 0.25, 0.27, 0.73, 10000, 0, 0, 1, 1, 0}, 
	[516] = {3400, 3700, 1.8, 0, 0.1, -0.1, 75, 1, 0.8, 0.46, 5, 197.2, 12, 23, 'rwd', 'petrol', 6, 0.55, true, 30, 1, 0.1, 0, 0.35, -0.15, 0.5, 0.3, 0.2, 0.74, 35000, 0, 0, 0, 1, 0}, 
	--[534] = {2500, 4166.4, 2, 0, 0, -0.2, 70, 0.7, 1, 0.53, 5, 195, 14, 20, 'awd', 'petrol', 8.17, 0.52, true, 35, 1.2, 0.15, 4, 0.4, -0.1, 0.5, 0.25, 0.3, 0.52, 30000, 0, 0, 1, 1, 1}, 
	--[536] = {3500, 5500, 2, 0, -0.2, 0.1, 70, 0.75, 0.84, 0.53, 4, 154, 8.6, 5, 'rwd', 'petrol', 8.17, 0.52, true, 35, 1, 0.1, 0, 0.3, -0.15, 0.44, 0.25, 0.3, 0.52, 19000, 40202000, 12010000, 1, 1, 0}, 
	--[540] = {4500, 6800, 2, 0, 0, -0.1, 85, 0.7, 0.9, 0.5, 5, 200, 21, 10, 'awd', 'petrol', 11, 0.45, true, 30, 1.2, 0.12, 0, 0.28, -0.24, 0.5, 0.4, 0.25, 0.5, 19000, 0, 0, 0, 3, 0},  
	[551] = {4800, 6000, 2.2, 0, 0.2, -0.1, 75, 0.65, 0.8, 0.49, 5, 195, 15, 40, 'awd', 'diesel', 9, 0.55, true, 30, 1.1, 0.15, 0, 0.27, -0.08, 0.54, 0.3, 0.2, 0.56, 35000, 40000000, 400001, 0, 1, 0}, 
	[559] = {1500, 3600, 2.2, 0, 0, -0.05, 75, 0.85, 0.8, 0.5, 5, 220, 19.6, 22, 'rwd', 'petrol', 10, 0.45, true, 30, 1.1, 0.1, 0, 0.28, -0.15, 0.5, 0.3, 0.25, 0.6, 35000, 0, 0, 1, 1, 1}, 
	[416] = {6600, 10202.8, 2.5, 0, 0, -0.1, 90, 0.75, 0.8, 0.47, 5, 182, 14.6, 55, 'awd', 'diesel', 7, 0.55, true, 35, 1, 0.07, 0, 0.4, -0.2, 0.5, 0, 0.58, 0.33, 10000, 0, 0, 0, 1, 13}, 
	[560] = {3800, 4600, 1, 0, 0.1, -0.2, 70, 1, 0.89, 0.52, 5, 187, 10.2, 72, 'awd', 'petrol', 25.4, 0.6, true, 20, 1.39, 0.89, 0.84, 0.21, -0.07, 0.5, 0, 0.26, 0.54,},  
	[585] = {3800, 5000, 2.2, 0, 0.2, 0.15, 75, 0.65, 0.8, 0.52, 5, 191, 15, 50, 'rwd', 'petrol', 8, 0.45, true, 30, 0.9, 0.13, 3, 0.3, -0.1, 0.5, 0.3, 0.2, 0.56, 35000, 40000000, 400000, 0, 1, 0}, 
	--carrera--[480] = {2400, 3200, 2.2, 0, 0.1, -0.2, 75, 0.7, 0.9, 0.5, 5, 200, 15, 10, 'awd', 'petrol', 11, 0.45, true, 30, 1.4, 0.14, 3, 0.28, -0.15, 0.5, 0.3, 0.25, 0.8, 35000, 40000800, 0, 1, 1, 19},
	[422] = {2700, 5000, 2.5, 0, 0.05, -0.2, 75, 0.85, 0.85, 0.57, 5, 165, 8, 15, 'awd', 'diesel', 8.5, 0.5, true, 35, 1.5, 0.1, 5, 0.35, -0.18, 0.4, 0, 0.26, 0.2, 26000, 40, 104004, 0, 1, 0},
	[407] = {8500, 36670.801, 3, 0, 0, 0, 90, 0.55, 0.8, 0.5, 5, 170, 5.1, 10, 'rwd', 'diesel', 10, 0.45, true, 27, 1.2, 0.08, 0, 0.47, -0.17, 0.5, 0, 0.2, 0.26, 15000, 4098, 0, 0, 1, 2},
	[544] = {8500, 36670.801, 3, 0, 0, 0, 90, 0.55, 0.8, 0.5, 5, 170, 5.1, 10, 'rwd', 'diesel', 10, 0.45, true, 27, 1.2, 0.08, 0, 0.47, -0.17, 0.5, 0, 0.2, 0.26, 15000, 4098, 0, 0, 1, 2},
	[490] = {3500, 5000, 2.2, 0, 0, -0.2, 80, 0.8, 1.3, 0.4, 5, 153, 13, 5, 'fwd', 'petrol', 8.5, 0.5, true, 35, 0.7, 0.15, 0, 0.34, -0.2, 0.5, 0.5, 0.44, 0.3, 40000, 4020, 500000, 0, 1, 0}, -- opel astra pd
	[506] = {4300, 5930, 1.8, 0, 0.15, -0.3, 75, 1.3, 0.9, 0.437, 5, 289, 28, 35, 'awd', 'petrol', 200, 0.4, true, 22, 1.2, 0.19, 0, 0.25, -0.1, 0.5, 0.4, 0.37, 0.64, 105000, 0, 0, 0, 0, 1},  
	--[604] = {2500, 3500, 2, 0, 0, 0, 70, 0.7, 1, 0.49, 5, 220, 15, 40, 'awd', 'electric', 5.4, 0.6, true, 30, 1, 0.09, 0, 0.32, -0.15, 0.54, 0, 0.26, 0.54, 19000, 0, 0, 0, 3, 0}, 
	[589] = {2620, 4000, 2, 0, 0.15, -0.3, 80, 1.23, 0.72, 0.45, 5, 270, 22, 70, 'rwd', 'petrol', 12.5, 0.6, true, 35, 0.9, 0.275, 5, 0.2, -0.05, 0.55, 0, 1, 0.3, 35000, 2000, 1, 1, 0},
	[427] = {6000, 17333.301, 2.3, 0, 0.1, 0, 85, 0.55, 0.8, 0.48, 5, 170, 8, 20, 'awd', 'diesel', 5.4, 0.45, true, 27, 1.4, 0.1, 0, 0.4, -0.25, 0.5, 0, 0.32, 0.16, 40000, 4011, 0, 0, 1, 13},
}

local handling_names = {"mass", "turnMass", "dragCoeff", "centerOfMass", _, _, "percentSubmerged", "tractionMultiplier", "tractionLoss", "tractionBias", "numberOfGears", "maxVelocity", "engineAcceleration", "engineInertia", "driveType", "engineType", "brakeDeceleration", "brakeBias", "ABS", "steeringLock", "suspensionForceLevel", "suspensionDamping", "suspensionHighSpeedDamping", "suspensionUpperLimit", "suspensionLowerLimit", "suspensionFrontRearBias", "suspensionAntiDiveMultiplier", "seatOffsetDistance", "collisionDamageMultiplier", "monetary", _, _, "headLight", "tailLight", "animGroup"}


--[[
	MINDEN HANDLINGBEN KELL:
	- engineAcceleration
	- maxVelocity
	- brakeDeceleration
	- brakeBias
	- engineAcceleration
	- tractionMultiplier
	- tractionBias
	- tractionLoss
	- driveType

	HA EZEK NINCSENEK BENNE MINDEN HANDLINGBEN AKKOR A TUNING RENDSZER MEG FOG BOLONDULNI!
]]

function loadHandling(veh)
	local model = getElementModel(veh)
	
	if handlings[model] then 
		for k, v in ipairs(handlings[model]) do 
			if handling_names[k] then 
				local handlingValue = v 
				if handling_names[k] == "centerOfMass" then 
					--outputChatBox(k)
					--print(handlings[model][k], handlings[model][k+1], handlings[model][k+2])
					handlingValue = {handlings[model][k], handlings[model][k+1], handlings[model][k+2]}
				end
				--[[if handling_names[k] == "tractionMultiplier" and getResourceState(getResourceFromName("oWinter")) == "running" then 
					if getElementData(veh, "veh:wheelType") ~= "W" then
						handlingValue = handlingValue - 0.5
					else 
						handlingValue = handlingValue
					end
				end]]
				setVehicleHandling(veh, handling_names[k], handlingValue)
			end
		end
	else
		if model == 467 then                                              --Lada
			    setVehicleHandling(veh, "mass", 1600)
				setVehicleHandling(veh, "turnMass", 3000)
				setVehicleHandling(veh, "dragCoeff", 1.8)
				setVehicleHandling(veh, "centerOfMass", { 0, 0.15, -0.3 } )
				setVehicleHandling(veh, "percentSubmerged", 75)
				setVehicleHandling(veh, "tractionMultiplier", 0.8)
				setVehicleHandling(veh, "tractionLoss", 0.85)
				setVehicleHandling(veh, "tractionBias", 0.497)
				setVehicleHandling(veh, "numberOfGears", 5)
				setVehicleHandling(veh, "maxVelocity", 136)
				setVehicleHandling(veh, "engineAcceleration", 5)
				setVehicleHandling(veh, "engineInertia", 90)
				setVehicleHandling(veh, "driveType", "awd")
				setVehicleHandling(veh, "engineType", "petrol")
				setVehicleHandling(veh, "brakeDeceleration", 50)
				setVehicleHandling(veh, "ABS", false)
				setVehicleHandling(veh, "steeringLock", 35)
				setVehicleHandling(veh, "monetary", 25000)
				setVehicleHandling(veh, "modelFlags", 0x40000001)
				setVehicleHandling(veh, "handlingFlags", 0x10308803)
				setVehicleHandling(veh, "headLight", 0)
				setVehicleHandling(veh, "tailLight", 1)
				setVehicleHandling(veh, "animGroup", 0)
				setVehicleHandling(veh, "suspensionUpperLimit", 0.28)
				setVehicleHandling(veh, "suspensionLowerLimit", -0.15)                                                             

        elseif model == 534 then                               --Ford Shelby GT500 Cobra
        	    setVehicleHandling(veh, "maxVelocity", 140)
				setVehicleHandling(veh, "engineAcceleration", 22.0)
				setVehicleHandling(veh, "steeringLock", 35)
				setVehicleHandling(veh, "engineInertia", 50.0)
				setVehicleHandling(veh, "driveType", "rwd")
				setVehicleHandling(veh, "tractionMultiplier", 0.75)
                setVehicleHandling(veh, "tractionLoss", 0.84)
                setVehicleHandling(veh, "tractionBias", 0.55)

        elseif model == 536 then                               --Dodge Coronet 440"      
                setVehicleHandling(veh, "maxVelocity", 138)
				setVehicleHandling(veh, "engineAcceleration", 45.0)
				setVehicleHandling(veh, "engineInertia", 45.0)
				setVehicleHandling(veh, "tractionMultiplier", 0.75)
                setVehicleHandling(veh, "tractionLoss", 0.85)
                setVehicleHandling(veh, "tractionBias", 0.52)
        elseif model == 540 then                               --Dodge Charger"
                setVehicleHandling(veh, "mass", 2600)
				setVehicleHandling(veh, "turnMass", 3000)
				setVehicleHandling(veh, "dragCoeff", 1.8)
				setVehicleHandling(veh, "centerOfMass", { 0, 0.1, -0.2 } )
				setVehicleHandling(veh, "percentSubmerged", 75)
				setVehicleHandling(veh, "tractionMultiplier", 0.9)
				setVehicleHandling(veh, "tractionLoss", 0.87)
				setVehicleHandling(veh, "tractionBias", 0.497)
				setVehicleHandling(veh, "numberOfGears", 5)
				setVehicleHandling(veh, "maxVelocity", 210)
				setVehicleHandling(veh, "engineAcceleration", 15)
				setVehicleHandling(veh, "engineInertia", 150)
				setVehicleHandling(veh, "driveType", "awd")
				setVehicleHandling(veh, "engineType", "petrol")
				setVehicleHandling(veh, "brakeDeceleration", 50)
				setVehicleHandling(veh, "ABS", false)
				setVehicleHandling(veh, "steeringLock", 35)
				setVehicleHandling(veh, "monetary", 25000)
				setVehicleHandling(veh, "modelFlags", 0x40000001)
				setVehicleHandling(veh, "handlingFlags", 0x10308803)
				setVehicleHandling(veh, "headLight", 0)
				setVehicleHandling(veh, "tailLight", 1)
				setVehicleHandling(veh, "animGroup", 0)
				setVehicleHandling(veh, "suspensionForceLevel", 1)
				setVehicleHandling(veh, "suspensionUpperLimit", 0.38)
				setVehicleHandling(veh, "suspensionLowerLimit", -0.17)

		elseif model == 542 then                               --Pontiac Firebird
		        setVehicleHandling(veh, "maxVelocity", 126)
				setVehicleHandling(veh, "engineAcceleration", 10.0)
				setVehicleHandling(veh, "engineInertia", 85.0)
				setVehicleHandling(veh, "engineType", "petrol")
				setVehicleHandling(veh, "brakeDeceleration", 500.0)
				setVehicleHandling(veh, "steeringLock", 35.0)
				setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
				setVehicleHandling(veh, "driveType", "rwd")
				setVehicleHandling(veh, "numberOfGears", 5)
				setVehicleHandling(veh, "tractionMultiplier", 0.65)
                setVehicleHandling(veh, "tractionLoss", 0.8)
                setVehicleHandling(veh, "tractionBias", 0.52)

        elseif model == 547 then                               --Volkswagen Bora
				setVehicleHandling(veh, "maxVelocity", 130)
				setVehicleHandling(veh, "engineAcceleration", 15.0)
				setVehicleHandling(veh, "engineInertia", 70.0)
				setVehicleHandling(veh, "numberOfGears", 5)
				setVehicleHandling(veh, "engineType", "petrol")
				setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
				setVehicleHandling(veh, "brakeDeceleration", 300.0)
				setVehicleHandling(veh, "steeringLock", 35.0)
				setVehicleHandling(veh, "driveType", "fwd")
				setVehicleHandling(veh, "tractionMultiplier", 0.7)
                setVehicleHandling(veh, "tractionLoss", 0.85)
                setVehicleHandling(veh, "tractionBias", 0.53)        
--DANISPACE
		elseif model == 518 then                               --Volkswagen 7R
				setVehicleHandling(veh, "maxVelocity", 200)
				setVehicleHandling(veh, "mass", 3200)
				setVehicleHandling(veh, "turnMass", 3600)				
				setVehicleHandling(veh, "engineAcceleration", 13)
				setVehicleHandling(veh, "engineInertia", 150)
				setVehicleHandling(veh, "numberOfGears", 5)
				setVehicleHandling(veh, "centerOfMass", { 0, 0.15, -0.01 } )
				setVehicleHandling(veh, "suspensionForceLevel", 0.7)	
				setVehicleHandling(veh, "engineType", "petrol")
				setVehicleHandling(veh, "brakeDeceleration", 210.0)
				setVehicleHandling(veh, "steeringLock", 35.0)
				setVehicleHandling(veh, "driveType", "awd")
				setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
				setVehicleHandling(veh, "tractionMultiplier", 0.86)
                setVehicleHandling(veh, "tractionLoss", 0.81)
                setVehicleHandling(veh, "tractionBias", 0.49)  

		elseif model == 451 then  --ferrari f40
					setVehicleHandling(veh, "mass", 4400)
					setVehicleHandling(veh, "turnMass", 3200)
					setVehicleHandling(veh, "tractionMultiplier", 0.73)
					setVehicleHandling(veh, "engineAcceleration", 60.0)
					setVehicleHandling(veh, "engineInertia", 200.0)
					setVehicleHandling(veh, "ABS", true)
					setVehicleHandling(veh, "driveType", "awd")
					setVehicleHandling(veh, "maxVelocity", 295)
					setVehicleHandling(veh, "tractionLoss", 0.76)
					setVehicleHandling(veh, "tractionBias", 0.47)
					setVehicleHandling(veh, "tractionMultiplier", 0.9)
					setVehicleHandling(veh, "engineAcceleration", 57)
					setVehicleHandling(veh, "engineInertia", 97)
					setVehicleHandling(veh, "brakeDeceleration", 90)
					setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)

		elseif model == 480 then --Carrera
					setVehicleHandling(veh, "mass", 4400)
					setVehicleHandling(veh, "turnMass", 3800)
					setVehicleHandling(veh, "maxVelocity", 257)
					setVehicleHandling(veh, "engineAcceleration", 50)
					setVehicleHandling(veh, "engineInertia", 135)
					setVehicleHandling(veh, "tractionMultiplier", 0.883)
					setVehicleHandling(veh, "tractionLoss", 0.962)
					setVehicleHandling(veh, "tractionBias", 0.47)
					setVehicleHandling(veh, "numberOfGears", 5)
					setVehicleHandling(veh, "brakeDeceleration", 90)
					setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)

		elseif model == 562 then --skyline
					setVehicleHandling(veh, "turnMass", 3900)
					setVehicleHandling(veh, "dragCoeff", 1.2)
					setVehicleHandling(veh, "centerOfMass", { 0.02, 0.10, 0.02 } )
					setVehicleHandling(veh, "percentSubmerged", 70)
					setVehicleHandling(veh, "tractionMultiplier", 0.87)
					setVehicleHandling(veh, "tractionLoss", 0.76)
					setVehicleHandling(veh, "tractionBias", 0.51)
					setVehicleHandling(veh, "numberOfGears", 5)
          		  	setVehicleHandling(veh, "maxVelocity", 182)       
					setVehicleHandling(veh, "engineAcceleration", 16)
					setVehicleHandling(veh, "engineInertia", 53)
					setVehicleHandling(veh, "driveType", "rwd")
					setVehicleHandling(veh, "engineType", "petrol")
					setVehicleHandling(veh, "brakeDeceleration", 40)
					setVehicleHandling(veh, "ABS", false)
					setVehicleHandling(veh, "steeringLock", 45)
					setVehicleHandling(veh, "headLight", 0)
					setVehicleHandling(veh, "tailLight", 1)
					setVehicleHandling(veh, "animGroup", 0)
					setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
					setVehicleHandling(veh, "suspensionUpperLimit", 0.0) -- magasság
					setVehicleHandling(veh, "suspensionLowerLimit", -0.1)

		elseif model == 405 then
						setVehicleHandling(veh, "mass", 4600) --bmw m5 e34
						setVehicleHandling(veh, "turnMass", 5700)
						setVehicleHandling(veh, "dragCoeff", 0.6)
						setVehicleHandling(veh, "centerOfMass", { 0, 0.12, -0.3 } )
						setVehicleHandling(veh, "percentSubmerged", 75)
						setVehicleHandling(veh, "tractionMultiplier", 0.91)
						setVehicleHandling(veh, "tractionLoss", 0.8)
						setVehicleHandling(veh, "tractionBias", 0.42)
						setVehicleHandling(veh, "numberOfGears", 5)
						setVehicleHandling(veh, "maxVelocity", 189)       
						setVehicleHandling(veh, "engineAcceleration", 40)
						setVehicleHandling(veh, "engineInertia", 130)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
						setVehicleHandling(veh, "driveType", "rwd")
						setVehicleHandling(veh, "engineType", "petrol")
						setVehicleHandling(veh, "brakeDeceleration", 20)
						setVehicleHandling(veh, "ABS", false)
						setVehicleHandling(veh, "steeringLock", 45)
						setVehicleHandling(veh, "headLight", 0)
						setVehicleHandling(veh, "tailLight", 1)
						setVehicleHandling(veh, "animGroup", 0)
						setVehicleHandling(veh, "suspensionUpperLimit", -3) -- magasság
						setVehicleHandling(veh, "suspensionLowerLimit", -0.21)
						setVehicleHandling(veh, "suspensionDampingLevel", 0.05)

					 --alacsonyabbr
		elseif model == 604 then  --cadillac 
						setVehicleHandling(veh, "mass", 4000)
						setVehicleHandling(veh, "turnMass", 3200)
						setVehicleHandling(veh, "dragCoeff", 0.6)
						setVehicleHandling(veh, "ABS", true)
						setVehicleHandling(veh, "driveType", "awd")
						setVehicleHandling(veh, "maxVelocity", 166)
						setVehicleHandling(veh, "tractionMultiplier", 0.83)
						setVehicleHandling(veh, "engineAcceleration", 10)
						setVehicleHandling(veh, "centerOfMass", { 0, 0.15, -0.3 } )
						setVehicleHandling(veh, "engineInertia", 75)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
						setVehicleHandling(veh, "brakeDeceleration", 50)
						setVehicleHandling(veh, "suspensionForceLevel", 1)
						setVehicleHandling(veh, "suspensionUpperLimit", -0.83) -- magasság
						setVehicleHandling(veh, "suspensionLowerLimit", -0.4)

		elseif model == 421 then -- type r
						setVehicleHandling(veh, "mass", 2100)
						setVehicleHandling(veh, "turnMass", 2700)
						setVehicleHandling(veh, "ABS", false)
						setVehicleHandling(veh, "maxVelocity", 196)
						setVehicleHandling(veh, "engineAcceleration", 15)
						setVehicleHandling(veh, "engineInertia", 90)
						setVehicleHandling(veh, "tractionLoss", 0.83)
						setVehicleHandling(veh, "tractionBias", 0.46)
						setVehicleHandling(veh, "tractionMultiplier", 0.83)
						setVehicleHandling(veh, "driveType", "fwd")
						setVehicleHandling(veh, "steeringLock", 45)
						setVehicleHandling(veh, "brakeDeceleration", 19)
						setVehicleHandling(veh, "brakeBias", 0.8)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.65)
						
		elseif model == 415 then 		 -- McLaren P1
						setVehicleHandling(veh, "mass", 4300)
						setVehicleHandling(veh, "turnMass", 2930)
						setVehicleHandling(veh, "dragCoeff", 1)
						setVehicleHandling(veh, "centerOfMass", { 0, 0.15, -0.2 } )
						setVehicleHandling(veh, "percentSubmerged", 75)
						setVehicleHandling(veh, "tractionMultiplier", 1.2)
						setVehicleHandling(veh, "tractionLoss", 0.9) --
						setVehicleHandling(veh, "tractionBias", 0.46) --
						setVehicleHandling(veh, "numberOfGears", 5)
						setVehicleHandling(veh, "maxVelocity", 293)       
						setVehicleHandling(veh, "engineAcceleration", 63)
						setVehicleHandling(veh, "engineInertia", 100)
						setVehicleHandling(veh, "driveType", "awd")
						setVehicleHandling(veh, "engineType", "petrol")
						setVehicleHandling(veh, "brakeDeceleration", 110)
						setVehicleHandling(veh, "brakeBias", 0.6)
						setVehicleHandling(veh, "ABS", true)
						setVehicleHandling(veh, "steeringLock", 55)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.64)	 --asd
						setVehicleHandling(veh, "suspensionHighSpeedDamping", 0.1)

					elseif model == 558 then 		 -- forma 1 redbull
						setVehicleHandling(veh, "mass", 3300)
						setVehicleHandling(veh, "turnMass", 4210)
						setVehicleHandling(veh, "dragCoeff", 0.2)
						setVehicleHandling(veh, "centerOfMass", { 0, -0.12, 0.02 } )
						setVehicleHandling(veh, "tractionMultiplier", 1.25)
						setVehicleHandling(veh, "tractionLoss", 0.906) --
						setVehicleHandling(veh, "tractionBias", 0.317) --
						setVehicleHandling(veh, "numberOfGears", 5)
						setVehicleHandling(veh, "maxVelocity", 270)       
						setVehicleHandling(veh, "engineAcceleration", 32)
						setVehicleHandling(veh, "engineInertia", 70)
						setVehicleHandling(veh, "driveType", "fwd")
						setVehicleHandling(veh, "engineType", "petrol")
						setVehicleHandling(veh, "brakeDeceleration", 200)
						setVehicleHandling(veh, "brakeBias", 3)
						setVehicleHandling(veh, "ABS", false)
						setVehicleHandling(veh, "steeringLock", 50)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.2)	 --asd
						setVehicleHandling(veh, "suspensionHighSpeedDamping", 0.1)		
										
					elseif model == 587 then 		 -- forma 1
						setVehicleHandling(veh, "mass", 3300)
						setVehicleHandling(veh, "turnMass", 4210)
						setVehicleHandling(veh, "dragCoeff", 0.2)
						setVehicleHandling(veh, "centerOfMass", { 0, -0.12, 0.02 } )
						setVehicleHandling(veh, "tractionMultiplier", 1.25)
						setVehicleHandling(veh, "tractionLoss", 0.906) --
						setVehicleHandling(veh, "tractionBias", 0.317) --
						setVehicleHandling(veh, "numberOfGears", 5)
						setVehicleHandling(veh, "maxVelocity", 270)       
						setVehicleHandling(veh, "engineAcceleration", 32)
						setVehicleHandling(veh, "engineInertia", 70)
						setVehicleHandling(veh, "driveType", "fwd")
						setVehicleHandling(veh, "engineType", "petrol")
						setVehicleHandling(veh, "brakeDeceleration", 200)
						setVehicleHandling(veh, "brakeBias", 3)
						setVehicleHandling(veh, "ABS", false)
						setVehicleHandling(veh, "steeringLock", 50)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.2)	 --asd
						setVehicleHandling(veh, "suspensionHighSpeedDamping", 0.1)	

					elseif model == 555 then 		 -- forma 1
						setVehicleHandling(veh, "mass", 3300)
						setVehicleHandling(veh, "turnMass", 4210)
						setVehicleHandling(veh, "dragCoeff", 0.2)
						setVehicleHandling(veh, "centerOfMass", { 0, -0.12, 0.02 } )
						setVehicleHandling(veh, "tractionMultiplier", 1.25)
						setVehicleHandling(veh, "tractionLoss", 0.906) --
						setVehicleHandling(veh, "tractionBias", 0.317) --
						setVehicleHandling(veh, "numberOfGears", 5)
						setVehicleHandling(veh, "maxVelocity", 270)       
						setVehicleHandling(veh, "engineAcceleration", 32)
						setVehicleHandling(veh, "engineInertia", 70)
						setVehicleHandling(veh, "driveType", "fwd")
						setVehicleHandling(veh, "engineType", "petrol")
						setVehicleHandling(veh, "brakeDeceleration", 200)
						setVehicleHandling(veh, "brakeBias", 3)
						setVehicleHandling(veh, "ABS", false)
						setVehicleHandling(veh, "steeringLock", 50)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.2)	 --asd
						setVehicleHandling(veh, "suspensionHighSpeedDamping", 0.1)	

		elseif model == 541 then 		 -- ferrari
						setVehicleHandling(veh, "mass", 4300)
						setVehicleHandling(veh, "turnMass", 5230)
						setVehicleHandling(veh, "dragCoeff", 1)
						setVehicleHandling(veh, "centerOfMass", { 0, 0.15, -0.05 } )
						setVehicleHandling(veh, "percentSubmerged", 75)
						setVehicleHandling(veh, "tractionMultiplier", 1)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
						setVehicleHandling(veh, "tractionLoss", 0.89) --
						setVehicleHandling(veh, "tractionBias", 0.47) --
						setVehicleHandling(veh, "numberOfGears", 5)
						setVehicleHandling(veh, "maxVelocity", 253)       
						setVehicleHandling(veh, "engineAcceleration", 47)
						setVehicleHandling(veh, "engineInertia", 160)
						setVehicleHandling(veh, "driveType", "awd")

		elseif model == 550 then --URUS
						setVehicleHandling(veh, "mass", 3500)
						setVehicleHandling(veh, "turnMass", 4600)
						setVehicleHandling(veh, "centerOfMass", { 0.1, -0.1, -0.13 } )
						setVehicleHandling(veh, "maxVelocity", 239)
						setVehicleHandling(veh, "driveType", "awd")
						setVehicleHandling(veh, "engineAcceleration", 20)
						setVehicleHandling(veh, "engineInertia", 162)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
						setVehicleHandling(veh, "tractionBias", 0.45)
						setVehicleHandling(veh, "tractionLoss", 0.82)
						setVehicleHandling(veh, "tractionMultiplier", 0.835)
						setVehicleHandling(veh, "brakeDeceleration", 70)
						setVehicleHandling(veh, "brakeBias", 0.5)
						setVehicleHandling(veh, "suspensionForceLevel", 0.5)
						setVehicleHandling(veh, "suspensionLowerLimit", -0.1)
						setVehicleHandling(veh, "suspensionUpperLimit", 0.03)

		elseif model == 566 then 		 -- GT63S
						setVehicleHandling(veh, "mass", 4300)
						setVehicleHandling(veh, "turnMass", 4130)
						setVehicleHandling(veh, "dragCoeff", 1)
						setVehicleHandling(veh, "centerOfMass", { 0, -0.25, -0.04 } )
						setVehicleHandling(veh, "percentSubmerged", 75)
						setVehicleHandling(veh, "tractionMultiplier", 0.852)
						setVehicleHandling(veh, "tractionLoss", 0.89) --
						setVehicleHandling(veh, "tractionBias", 0.46) --
						setVehicleHandling(veh, "numberOfGears", 5)
						setVehicleHandling(veh, "maxVelocity", 235)       
						setVehicleHandling(veh, "engineAcceleration", 21)
						setVehicleHandling(veh, "engineInertia", 150)
						setVehicleHandling(veh, "driveType", "awd")
						setVehicleHandling(veh, "engineType", "petrol")
						setVehicleHandling(veh, "brakeDeceleration", 110)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
						setVehicleHandling(veh, "brakeBias", 0.6)
						setVehicleHandling(veh, "ABS", true)
						setVehicleHandling(veh, "steeringLock", 55)
						setVehicleHandling(veh, "suspensionHighSpeedDamping", 0.1)	
						setVehicleHandling(veh, "suspensionForceLevel", 1.35)			
		
		elseif model == 494 then --Ford Mustang GT
						setVehicleHandling(veh, "mass", 3500)
						setVehicleHandling(veh, "turnMass", 4200)
						setVehicleHandling(veh, "tractionLoss", 0.82)
						setVehicleHandling(veh, "tractionBias", 0.5)
						setVehicleHandling(veh, "tractionMultiplier", 0.83)
						setVehicleHandling(veh, "maxVelocity", 210)
						setVehicleHandling(veh, "engineAcceleration", 17)
						setVehicleHandling(veh, "driveType", "rwd")
						setVehicleHandling(veh, "engineInertia", 131)
						setVehicleHandling(veh, "suspensionLowerLimit", -0.15)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)

		elseif model == 517 then --audi aronka
					setVehicleHandling(veh, "suspensionUpperLimit", 0.1)
					setVehicleHandling(veh, "suspensionLowerLimit", -0.57)

		elseif model == 400 then --Range Rover
						setVehicleHandling(veh, "mass", 5000)
						setVehicleHandling(veh, "turnMass", 6200)
						setVehicleHandling(veh, "centerOfMass", { 0.1, -0.03, -0.13 } )
						setVehicleHandling(veh, "maxVelocity", 177)
						setVehicleHandling(veh, "engineAcceleration", 20)
						setVehicleHandling(veh, "engineInertia", 150)
						setVehicleHandling(veh, "tractionMultiplier", 0.83)
						setVehicleHandling(veh, "collisionDamageMultiplier", 0.63)
						setVehicleHandling(veh, "tractionBias", 0.48)
						setVehicleHandling(veh, "suspensionForceLevel", 1)
						setVehicleHandling(veh, "suspensionDampingLevel", 0.25)
						setVehicleHandling(veh, "suspensionUpperLimit", 0.1)
						setVehicleHandling(veh, "suspensionLowerLimit", -0.27)

		elseif model == 549 then --BMW Series 5 E28
					setVehicleHandling(veh, "mass", 3600)
					setVehicleHandling(veh, "turnMass", 3700)
					setVehicleHandling(veh, "ABS", true)
					setVehicleHandling(veh, "maxVelocity", 185)
					setVehicleHandling(veh, "centerOfMass", { 0.02, -0.05, 0.02 } )
					setVehicleHandling(veh, "percentSubmerged", 70)
					setVehicleHandling(veh, "tractionMultiplier", 0.77)
					setVehicleHandling(veh, "tractionLoss", 0.72)
					setVehicleHandling(veh, "tractionBias", 0.49)
					setVehicleHandling(veh, "tractionMultiplier", 0.75)
					setVehicleHandling(veh, "engineAcceleration", 10)
					setVehicleHandling(veh, "engineInertia", 88)
					setVehicleHandling(veh, "collisionDamageMultiplier", 0.64)
		end
	end
end

function loadHandlings()
	for k, v in ipairs(getElementsByType("vehicle")) do
		loadHandling(v)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), loadHandlings)

--[[function vehicleEnter()
	loadHandling(source)
end
addEventHandler("onVehicleEnter", getRootElement(), vehicleEnter)]]

function resetHandling(veh)
	for k1,v1 in pairs(getOriginalHandling(getElementModel(veh))) do
		setVehicleHandling(veh, k1, v1)
	end
end

function resetHandlings()
	for k, v in ipairs(getElementsByType("vehicle")) do
		resetHandling(v)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), resetHandlings)

function getHandlingElement(veh, handlingElemet) --24
	local model = getElementModel(veh)

	if handlings[veh] then 
		return handlings[veh][handlingElemet]
	end
end	

--[[function loadHandling(v)	
		if getElementModel(v) == 492 then 									-- BMW F10
			setVehicleHandling(v, "mass", 6100)
			setVehicleHandling(v, "turnMass", 7700)
			setVehicleHandling(v, "dragCoeff", 0.1)
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
			setVehicleHandling(v, "percentSubmerged", 75)
			setVehicleHandling(v, "tractionMultiplier", 0.96)
			setVehicleHandling(v, "tractionLoss", 0.9)
			setVehicleHandling(v, "tractionBias", 0.497)
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 223)       
			setVehicleHandling(v, "engineAcceleration", 25)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
			setVehicleHandling(v, "engineInertia", 50)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 40)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "steeringLock", 35)
			setVehicleHandling(v, "headLight", 0)
			setVehicleHandling(v, "tailLight", 1)
			setVehicleHandling(v, "animGroup", 0)
			setVehicleHandling(v, "suspensionUpperLimit", 0.2) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.1) --alacsonyabbra
		end
		if getElementModel(v) == 596 then 									-- Dodge Police
			setVehicleHandling(v, "mass", 4600)
			setVehicleHandling(v, "turnMass", 4700)
			setVehicleHandling(v, "dragCoeff", 0.8)
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.2 } )
			setVehicleHandling(v, "percentSubmerged", 75)
			setVehicleHandling(v, "tractionMultiplier", 1.13)
			setVehicleHandling(v, "tractionLoss", 0.92)
			setVehicleHandling(v, "tractionBias", 0.47) --kibillenés
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 201)       
			setVehicleHandling(v, "engineAcceleration", 62) -- kipördülést okozhat
			setVehicleHandling(v, "engineInertia", 70) -- kipördülést okozhat ()
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 125)
			setVehicleHandling(v, "ABS", false)
			setVehicleHandling(v, "steeringLock", 55)
			setVehicleHandling(v, "headLight", 0)
			setVehicleHandling(v, "tailLight", 1)
			setVehicleHandling(v, "animGroup", 0)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
        	setVehicleHandling(v, "suspensionForceLevel", 0.67)			
			setVehicleHandling(v, "suspensionUpperLimit", 0.2) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.1)
		end
		if getElementModel(v) == 458 then 									-- Cyber Truck
			setVehicleHandling(v, "mass", 5600)
			setVehicleHandling(v, "turnMass", 4700)
			setVehicleHandling(v, "dragCoeff", 1.8)
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
			setVehicleHandling(v, "percentSubmerged", 15)
			setVehicleHandling(v, "tractionMultiplier", 0.7)
			setVehicleHandling(v, "tractionLoss", 0.9)
			setVehicleHandling(v, "tractionBias", 0.497)
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 215)       
			setVehicleHandling(v, "engineAcceleration", 10)
			setVehicleHandling(v, "engineInertia", 50)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 40)
			setVehicleHandling(v, "ABS", false)
			setVehicleHandling(v, "steeringLock", 35)
			setVehicleHandling(v, "headLight", 0)
			setVehicleHandling(v, "tailLight", 1)
			setVehicleHandling(v, "animGroup", 0)
			setVehicleHandling(v, "suspensionUpperLimit", 0.2) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.3)
		end	
		if getElementModel(v) == 542 then 									-- pontiac
			setVehicleHandling(v, "mass", 4600)
			setVehicleHandling(v, "turnMass", 3700)
			setVehicleHandling(v, "dragCoeff", 0.8)
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
			setVehicleHandling(v, "percentSubmerged", 75)
			setVehicleHandling(v, "tractionMultiplier", 0.9)
			setVehicleHandling(v, "tractionLoss", 0.8)
			setVehicleHandling(v, "tractionBias", 0.46) --kibillenés
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 165)       
			setVehicleHandling(v, "engineAcceleration", 38) -- kipördülést okozhat
			setVehicleHandling(v, "engineInertia", 70) -- kipördülést okozhat ()
			setVehicleHandling(v, "driveType", "rwd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 39)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
			setVehicleHandling(v, "ABS", false)
			setVehicleHandling(v, "steeringLock", 55)
			setVehicleHandling(v, "headLight", 0)
			setVehicleHandling(v, "tailLight", 1)
			setVehicleHandling(v, "animGroup", 0)
        	setVehicleHandling(v, "suspensionForceLevel", 0.55)			
			setVehicleHandling(v, "suspensionUpperLimit", 0.1) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.2)
		end
		if getElementModel(v) == 411 then 		 -- Koenigsegg CCX
			setVehicleHandling(v, "mass", 4300)
			setVehicleHandling(v, "turnMass", 2930)
			setVehicleHandling(v, "dragCoeff", 1.8)
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
			setVehicleHandling(v, "percentSubmerged", 75)
			setVehicleHandling(v, "tractionMultiplier", 1.3)
			setVehicleHandling(v, "tractionLoss", 0.9) --
			setVehicleHandling(v, "tractionBias", 0.437) --
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 301)
            setVehicleHandling(v, "brakeBias", 0.4)
			setVehicleHandling(v, "engineAcceleration", 57)
			setVehicleHandling(v, "engineInertia", 35)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 200)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "steeringLock", 55)
			setVehicleHandling(v, "collisionDamageMultiplier", 0.64)						
		end	

		if getElementModel(v) == 415 then 		 -- McLaren P1
			setVehicleHandling(v, "mass", 4300)
			setVehicleHandling(v, "turnMass", 2930)
			setVehicleHandling(v, "dragCoeff", 1.8)
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
			setVehicleHandling(v, "percentSubmerged", 75)
			setVehicleHandling(v, "tractionMultiplier", 1.2)
			setVehicleHandling(v, "tractionLoss", 0.88) --
			setVehicleHandling(v, "tractionBias", 0.44) --
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 321)       
			setVehicleHandling(v, "engineAcceleration", 77)
			setVehicleHandling(v, "engineInertia", 75)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 110)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
			setVehicleHandling(v, "brakeBias", 0.6)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "steeringLock", 55)
			setVehicleHandling(v, "collisionDamageMultiplier", 0.64)	 --asd
			setVehicleHandling(v, "suspensionHighSpeedDamping", 0.1)					
		end	

		if getElementModel(v) == 402 then 		 -- Dodge Demon SRT
			setVehicleHandling(v, "mass", 5500)
			setVehicleHandling(v, "turnMass", 7200)
			setVehicleHandling(v, "dragCoeff", 0.8)
			setVehicleHandling(v, "centerOfMass", { 0.03, -0.15, -0.1 } )
			setVehicleHandling(v, "percentSubmerged", 75)
			setVehicleHandling(v, "tractionMultiplier", 0.93)
			setVehicleHandling(v, "tractionLoss", 0.9) --
			setVehicleHandling(v, "tractionBias", 0.44) --
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 215)       
			setVehicleHandling(v, "engineAcceleration", 50)
			setVehicleHandling(v, "engineInertia", 60)
			setVehicleHandling(v, "driveType", "rwd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 60)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "steeringLock", 35)
            setVehicleHandling(v, "suspensionForceLevel", 1.35)			
			setVehicleHandling(v, "suspensionUpperLimit", 0.2) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.2)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
		end	
        if getElementModel(v) == 405 then
    		setVehicleHandling(v, "mass", 4600) --bmw m5 e34
			setVehicleHandling(v, "turnMass", 5700)
			setVehicleHandling(v, "dragCoeff", 0.6)
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
			setVehicleHandling(v, "percentSubmerged", 75)
			setVehicleHandling(v, "tractionMultiplier", 0.91)
			setVehicleHandling(v, "tractionLoss", 0.8)
			setVehicleHandling(v, "tractionBias", 0.42)
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 170)       
			setVehicleHandling(v, "engineAcceleration", 36)
			setVehicleHandling(v, "engineInertia", 90)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
			setVehicleHandling(v, "driveType", "rwd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 20)
			setVehicleHandling(v, "ABS", false)
			setVehicleHandling(v, "steeringLock", 45)
			setVehicleHandling(v, "headLight", 0)
			setVehicleHandling(v, "tailLight", 1)
			setVehicleHandling(v, "animGroup", 0)
			setVehicleHandling(v, "suspensionUpperLimit", 0.0) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.19)
        end --alacsonyabbr
    
		if getElementModel(v) == 410 then --1973 Ford Pinto Runabout
			setVehicleHandling(v, "mass", 3600)
			setVehicleHandling(v, "turnMass", 2300)
			setVehicleHandling(v, "dragCoeff", 1.8)
			setVehicleHandling(v, "tractionMultiplier", 0.8)
			setVehicleHandling(v, "tractionLoss", 0.9)
			setVehicleHandling(v, "tractionBias", 0.477)
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 95)       
			setVehicleHandling(v, "engineAcceleration", 17)
			setVehicleHandling(v, "engineInertia", 70)
			setVehicleHandling(v, "driveType", "rwd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 40)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.67)
		end

		if getElementModel(v) == 598 then 									-- pd
			setVehicleHandling(v, "mass", 2600)
			setVehicleHandling(v, "turnMass", 3700)
			setVehicleHandling(v, "dragCoeff", 0.8)
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.1 } )
			setVehicleHandling(v, "percentSubmerged", 75)
			setVehicleHandling(v, "tractionMultiplier", 0.7)
			setVehicleHandling(v, "tractionLoss", 0.73)
			setVehicleHandling(v, "tractionBias", 0.477) --kibillenés
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 160)       
			setVehicleHandling(v, "engineAcceleration", 38) -- kipördülést okozhat
			setVehicleHandling(v, "engineInertia", 124) -- kipördülést okozhat ()
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 39)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "steeringLock", 65)
			setVehicleHandling(v, "headLight", 0)
			setVehicleHandling(v, "tailLight", 1)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
			setVehicleHandling(v, "animGroup", 0)
        	setVehicleHandling(v, "suspensionForceLevel", 0.55)			
			setVehicleHandling(v, "suspensionUpperLimit", 0.3) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.1)
		end		

		if getElementModel(v) == 445 then -- M5 E60
			setVehicleHandling(v, "mass", 2600)
			setVehicleHandling(v, "turnMass", 4700)
			setVehicleHandling(v, "driveType", "rwd")
			setVehicleHandling(v, "tractionMultiplier", 1.12)
			setVehicleHandling(v, "tractionLoss", 0.82)
			setVehicleHandling(v, "tractionBias", 0.43)	
			setVehicleHandling(v, "steeringLock", 50)       
			setVehicleHandling(v, "engineAcceleration", 53) -- kipördülést okozhat
			setVehicleHandling(v, "engineInertia", 90)
			setVehicleHandling(v, "brakeDeceleration", 80)
			setVehicleHandling(v, "brakeBias", 0.6)
            setVehicleHandling(v, "maxVelocity", 190) ---EEEEEEEEEEEEEEEEEEEEEEEE
			setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.3 } )
			setVehicleHandling(v, "suspensionForceLevel", 0.55)			
			setVehicleHandling(v, "suspensionUpperLimit", 0.2) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.3)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.67)
		end

		if getElementModel(v) == 546 then --Tesla Model S
			setVehicleHandling(v, "mass", 3600)
			setVehicleHandling(v, "turnMass", 5700)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "maxVelocity", 199)
			setVehicleHandling(v, "tractionMultiplier", 0.85)
			setVehicleHandling(v, "engineAcceleration", 35)
			setVehicleHandling(v, "engineInertia", 50)
			setVehicleHandling(v, "tractionLoss", 0.921)
			setVehicleHandling(v, "tractionBias", 0.537)
			setVehicleHandling(v, "tractionMultiplier", 0.8)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "steeringLock", 45)
			setVehicleHandling(v, "brakeDeceleration", 25)
			setVehicleHandling(v, "brakeBias", 0.6)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
		end
    
        if getElementModel(v) == 547 then --Cadilac Fletwood
			setVehicleHandling(v, "mass", 3600)
			setVehicleHandling(v, "turnMass", 4300)
			setVehicleHandling(v, "ABS", false)
			setVehicleHandling(v, "maxVelocity", 144)
			setVehicleHandling(v, "engineAcceleration", 37)
			setVehicleHandling(v, "engineInertia", 105)
			setVehicleHandling(v, "tractionLoss", 0.83)
			setVehicleHandling(v, "tractionBias", 0.45)
			setVehicleHandling(v, "tractionMultiplier", 1.05)
			setVehicleHandling(v, "driveType", "fwd")
			setVehicleHandling(v, "steeringLock", 45)
			setVehicleHandling(v, "brakeDeceleration", 70)
			setVehicleHandling(v, "brakeBias", 0.8)
			setVehicleHandling(v, "collisionDamageMultiplier", 0.62)
        end
		if getElementModel(v) == 496 then --Tesla Roadster Sport
			setVehicleHandling(v, "mass", 3600)
			setVehicleHandling(v, "turnMass", 4700)
			setVehicleHandling(v, "ABS", false)
			setVehicleHandling(v, "maxVelocity", 377)
			setVehicleHandling(v, "engineAcceleration", 55)
			setVehicleHandling(v, "engineInertia", 150)
			setVehicleHandling(v, "tractionLoss", 0.83)
			setVehicleHandling(v, "tractionBias", 0.46)
			setVehicleHandling(v, "tractionMultiplier", 0.8)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "steeringLock", 45)
			setVehicleHandling(v, "brakeDeceleration", 50)
			setVehicleHandling(v, "brakeBias", 0.8)
			setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
		end

		if getElementModel(v) == 565 then --AMC Gremlin X V8
            setVehicleHandling(v, "mass", 2600)
			setVehicleHandling(v, "turnMass", 3700)
			setVehicleHandling(v, "maxVelocity", 93)	
			setVehicleHandling(v, "engineAcceleration", 6)
			setVehicleHandling(v, "engineInertia", 5)
			setVehicleHandling(v, "brakeDeceleration", 5)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.6)
		end

		if getElementModel(v) == 479 then -- volvo köcsög
			setVehicleHandling(v, "mass", 2600)
			setVehicleHandling(v, "turnMass", 3700)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "maxVelocity", 155)
			setVehicleHandling(v, "tractionMultiplier", 0.8)
			setVehicleHandling(v, "engineAcceleration", 10)
			setVehicleHandling(v, "engineInertia", 70)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.64)
		end	

		if getElementModel(v) == 507 then -- Mercedes E500
			setVehicleHandling(v, "mass", 3400)
			setVehicleHandling(v, "turnMass", 3700)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "maxVelocity", 150)
			setVehicleHandling(v, "tractionMultiplier", 1)
			setVehicleHandling(v, "engineAcceleration", 20)
			setVehicleHandling(v, "engineInertia", 70)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.74)
		end
    
        if getElementModel(v) == 558 then --Subaru Impreza 1998 
            setVehicleHandling(v, "mass", 3500)
            setVehicleHandling(v, "maxVelocity", 215)
            setVehicleHandling(v, "engineAcceleration", 30)
            setVehicleHandling(v, "engineInertia", 60)
            setVehicleHandling(v, "driveType", "awd")
            setVehicleHandling(v, "collisionDamageMultiplier", 0.65)
            setVehicleHandling(v, "steeringLock", 45)
        end
    
		if getElementModel(v) == 602 then --GTR
			setVehicleHandling(v, "mass", 5600)
			setVehicleHandling(v, "turnMass", 4700)
			setVehicleHandling(v, "ABS", false)
			setVehicleHandling(v, "maxVelocity", 206)
			setVehicleHandling(v, "engineAcceleration", 75)
			setVehicleHandling(v, "engineInertia", 90)
			setVehicleHandling(v, "tractionLoss", 0.91)
			setVehicleHandling(v, "tractionBias", 0.53)
			setVehicleHandling(v, "tractionMultiplier", 1)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "steeringLock", 45)
			setVehicleHandling(v, "brakeDeceleration", 70)
			setVehicleHandling(v, "brakeBias", 0.8)
			setVehicleHandling(v, "collisionDamageMultiplier", 0.65)
		end
        
        if getElementModel(v) == 416 then --Mentő 
			setVehicleHandling(v, "mass", 6400)
			setVehicleHandling(v, "turnMass", 4700)
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "maxVelocity", 160)
			setVehicleHandling(v, "tractionMultiplier", 1)
			setVehicleHandling(v, "engineAcceleration", 42)
			setVehicleHandling(v, "engineInertia", 70)
		end
    
        if getElementModel(v) == 579 then  --Cadilac Esclade
			setVehicleHandling(v, "mass", 4400)
			setVehicleHandling(v, "turnMass", 3200)
			setVehicleHandling(v, "ABS", true)
            setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "maxVelocity", 156)
			setVehicleHandling(v, "tractionMultiplier", 0.83)
			setVehicleHandling(v, "engineAcceleration", 25)
			setVehicleHandling(v, "engineInertia", 100)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
		end
    
        if getElementModel(v) == 426 then -- Audi RS6 Avant
            setVehicleHandling(v, "mass", 4300)
            setVehicleHandling(v, "turnMass", 6730)
            setVehicleHandling(v, "maxVelocity", 196)
            setVehicleHandling(v, "engineAcceleration", 40)
            setVehicleHandling(v, "tractionBias", 0.485)
            setVehicleHandling(v, "tractionLoss", 0.9)
            setVehicleHandling(v, "tractionMultiplier", 0.8)
			setVehicleHandling(v, "engineInertia", 60)
            setVehicleHandling(v, "suspensionForceLevel", 1.13)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
        end
    
        if getElementModel(v) == 404 then -- Chevrolet Suburban Z11
            setVehicleHandling(v, "mass", 4300)
            setVehicleHandling(v, "maxVelocity", 130)
            setVehicleHandling(v, "engineAcceleration", 15)
			setVehicleHandling(v, "engineInertia", 130)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
        end
    
        if getElementModel(v) == 400 then -- Range Rover Sport
			setVehicleHandling(v, "mass", 5600)
			setVehicleHandling(v, "turnMass", 6600)
            setVehicleHandling(v, "centerOfMass", { 0.1, 0.2, -0.13 } )
            setVehicleHandling(v, "maxVelocity", 170)
            setVehicleHandling(v, "engineAcceleration", 35)
			setVehicleHandling(v, "engineInertia", 90)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
            setVehicleHandling(v, "tractionBias", 0.48)
            setVehicleHandling(v, "suspensionForceLevel", 1.5)
        end
    
        if getElementModel(v) == 505 then  --Ford Bronco XLT
			setVehicleHandling(v, "mass", 4400)
			setVehicleHandling(v, "turnMass", 3200)
			setVehicleHandling(v, "ABS", true)
            setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "maxVelocity", 139)
			setVehicleHandling(v, "tractionMultiplier", 0.83)
			setVehicleHandling(v, "engineAcceleration", 27)
			setVehicleHandling(v, "engineInertia", 87)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.65)
		end
        if getElementModel(v) == 451 then  --ferrari f40
			setVehicleHandling(v, "mass", 4400)
			setVehicleHandling(v, "turnMass", 3200)
			setVehicleHandling(v, "ABS", true)
            setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "maxVelocity", 295)
			setVehicleHandling(v, "tractionMultiplier", 0.9)
			setVehicleHandling(v, "engineAcceleration", 57)
			setVehicleHandling(v, "engineInertia", 97)
            setVehicleHandling(v, "brakeDeceleration", 90)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
		end
    
        if getElementModel(v) == 599 then
            setVehicleHandling(v, "mass", 4300)
            setVehicleHandling(v, "maxVelocity", 152)
            setVehicleHandling(v, "engineInertia", 50)
            setVehicleHandling(v, "engineAcceleration", 23)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
        end
        
        if getElementModel(v) == 502 then  --Bugatti veyron
			setVehicleHandling(v, "mass", 5600)
			setVehicleHandling(v, "turnMass", 6600)
            setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.1 } )
			setVehicleHandling(v, "tractionMultiplier", 0.9)
			setVehicleHandling(v, "tractionLoss", 0.95)
			setVehicleHandling(v, "tractionBias", 0.47)
			setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "maxVelocity", 312)       
			setVehicleHandling(v, "engineAcceleration", 50)
			setVehicleHandling(v, "engineInertia", 70)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "engineType", "petrol")
			setVehicleHandling(v, "brakeDeceleration", 90)
            setVehicleHandling(v, "suspensionHighSpeedDamping", 0.1)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
            setVehicleHandling(v, "suspensionUpperLimit", 0.2) -- magasság
			setVehicleHandling(v, "suspensionLowerLimit", -0.15)
		end
    
        if getElementModel(v) == 526 then --Ford Mustang GT500
            setVehicleHandling(v, "mass", 4400)
			setVehicleHandling(v, "turnMass", 3200)
			setVehicleHandling(v, "maxVelocity", 203)
			setVehicleHandling(v, "engineAcceleration", 56)
			setVehicleHandling(v, "engineInertia", 155)
            setVehicleHandling(v, "centerOfMass", { 0, 0.15, -0.1 } )
			setVehicleHandling(v, "tractionMultiplier", 0.87)
			setVehicleHandling(v, "tractionLoss", 0.86)
			setVehicleHandling(v, "tractionBias", 0.4)
            setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "brakeDeceleration", 90)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
        end
        if getElementModel(v) == 467 then -- Chevrolet Impala LS 2006
            setVehicleHandling(v, "mass", 3400)
			setVehicleHandling(v, "turnMass", 3200)
            setVehicleHandling(v, "tractionLoss", 0.86)
			setVehicleHandling(v, "tractionBias", 0.4)
            setVehicleHandling(v, "maxVelocity", 123)
            setVehicleHandling(v, "engineAcceleration", 20)
			setVehicleHandling(v, "engineInertia", 85)
            setVehicleHandling(v, "suspensionLowerLimit", -0.15)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
        end
        if getElementModel(v) == 480 then --Porsche 911 Carrera S
            setVehicleHandling(v, "mass", 4400)
			setVehicleHandling(v, "turnMass", 3200)
			setVehicleHandling(v, "maxVelocity", 245)
			setVehicleHandling(v, "engineAcceleration", 71)
			setVehicleHandling(v, "engineInertia", 135)
			setVehicleHandling(v, "tractionMultiplier", 0.87)
			setVehicleHandling(v, "tractionLoss", 0.91)
			setVehicleHandling(v, "tractionBias", 0.4)
            setVehicleHandling(v, "numberOfGears", 5)
            setVehicleHandling(v, "brakeDeceleration", 90)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
        end
        if getElementModel(v) == 551 then --AudiA8
            setVehicleHandling(v, "mass", 3600)
			setVehicleHandling(v, "turnMass", 4700)
            setVehicleHandling(v, "centerOfMass", { 0.1, 0.2, -0.13 } )
			setVehicleHandling(v, "ABS", true)
			setVehicleHandling(v, "maxVelocity", 172)
			setVehicleHandling(v, "tractionMultiplier", 0.8)
			setVehicleHandling(v, "engineAcceleration", 27)
			setVehicleHandling(v, "engineInertia", 70)
			setVehicleHandling(v, "tractionLoss", 0.9)
			setVehicleHandling(v, "tractionBias", 0.52)
			setVehicleHandling(v, "tractionMultiplier", 0.81)
			setVehicleHandling(v, "driveType", "awd")
			setVehicleHandling(v, "steeringLock", 45)
			setVehicleHandling(v, "brakeDeceleration", 100)
			setVehicleHandling(v, "brakeBias", 0)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.63)
        end
        if getElementModel(v) == 422 then -- Chevrolet C10 1965
            setVehicleHandling(v, "mass", 2100)
            setVehicleHandling(v, "collisionDamageMultiplier", 0.57)
        end
    
        if getElementModel(v) == 490 then -- Tűzoltó FBI Rancher
            setVehicleHandling(v, "maxVelocity", 163)
            setVehicleHandling(v, "engineInteria", 151)
            setVehicleHandling(v, "engineAcceleration", 17)
            setVehicleHandling(v, "steeringLock", 35)
            setVehicleHandling(v, "tractionLoss", 0.91)
			setVehicleHandling(v, "tractionBias", 0.4)
        end
     
		if getElementModel(v) == 510 then --Bicikli!
			setVehicleHandling(v, "maxVelocity", 35)
			setVehicleHandling(v, "engineAcceleration", 31)
			setVehicleHandling(v, "engineInertia", 200)
		end	
    --end	
end]]