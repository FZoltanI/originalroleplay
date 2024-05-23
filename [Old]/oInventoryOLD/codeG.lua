
row = 5
column = 9
margin = 2
itemSize = 38 -- default: 38

maxweight = {
	["player"] = 20,
	["safe_normal"] = 100,
	["safe_premium"] = 200,
}

core = exports.oCore
chat = exports.oChat
admin = exports.oAdmin
fontScript = exports.oFont
bone = exports.oBone
interface = exports.oInterface

logcolor = "#ed6b0e"
color, r, g, b = core:getServerColor()

actionSlots = 7

weaponModels = {
	[27] = {355},
	[28] = {356},
	[29] = {339},
	[30] = {348},
	[31] = {336},
	[32] = {335},
	[33] = {334},
	[34] = {349},
	[35] = {350},
	[37] = {346},
	[38] = {358},
	[39] = {353},
	[40] = {353},
	[161] = {341},
	[162] = {366},
}

weaponIndexByID = {
	[27] = 30, -- ak
	[28] = 31, -- m4
	[29] = 8, -- katana
	[30] = 24, -- deagle
	[31] = 5, -- baseball
	[32] = 4, -- kés
	[33] = 3, -- gumibot
	[34] = 25, -- shotgun
	[35] = 26, -- lefűrészelt shoti
	[36] = 41, -- spray
	[37] = 22, -- colt
	[38] = 34, -- sniper
	[39] = 29, -- mp5
	[40] = 28, -- uzi
	[41] = 23, -- silenced
	[42] = 32, -- tec9
	[49] = 43, -- kamera
	[161] = 9, -- láncfűrész
	[162] = 42, -- poroltó
	[152] = 43, -- kamera
}

weaponPositions = {
	[30] = {6, -0.09, -0.1, 0.2, 10, 155, 95},
	[31] = {5, 0.15, -0.1, 0.2, -10, 155, 90},
	[29] = {13, -0.07, 0.04, 0.06, 0, -90, 95},
	[8] = {6, -0.15, 0, -0.02, -10, -105, 90},
	[24] = {14, 0.10, 0, 0, 0, 264, 90},
	[5] = {6, -0.09, -0.1, 0.1, 10, 260, 95},
	[3] = {13, -0.05, -0.15, 0.1, 0, 10, 90},
	[25] = {5, 0.15, -0.1, 0.2, 0, 155, 90},
	[26] = {5, 0.15, 0.06, 0.2, 0, 172, 90},
	[33] = {6, -0.09, -0.1, 0.2, 10, 155, 95},
	[34] = {5, 0.15, -0.1, 0.2, -10, 155, 90},
	[27] = {6, -0.09, 0.02, 0.2, 10, 155, 95},
	[32] = {6, -0.09, 0.02, 0.2, 10, 155, 95},
	[161] = {6, -0.09, 0.02, 0.2, 10, 155, 95},
	[162] = {6, -0.09, 0.02, 0.2, 10, 155, 95},
}

hotTable = {
	--WEAPID,NUM(1-től 100-ig)
	[22] = 1.0+10, --Colt
	--[23] = 1.0+10, --Colt hangtompítós
	[24] = 1.0+18, -- deagle
	[25] = 1.0+35, --Shotgun
	[26] = 1.0+23, --Sawed off
	[28] = 1.0+3, --Uzi
	[29] = 1.0+4, --MP5
	[30] = 1.0+2.8, --AK
	[31] = 1.0+3.2, --M4
	[32] = 1.0+3, --TEC-9
	[34] = 1.0+26, --Sniper
}

food_maxvalues = {
	[2] = 2,
	[3] = 4,
	[4] = 5,
	[5] = 5,
	[6] = 6,
	[7] = 6,
	[8] = 3,
	[9] = 3,
	[10] = 3,
	[11] = 2,
	[12] = 5,
	[13] = 4,
	[14] = 2,
	[15] = 2,
	[16] = 8,
	[17] = 6,
	[18] = 6,
}

drink_maxvalues = {
	[19] = 5,
	[20] = 5,
	[21] = 5,
	[22] = 5,
	[23] = 5,
	[24] = 4,
	[25] = 6,
	[26] = 5,
}

items = {	
	{name = "Iphone X", weight = 0.3, description = "Apple telefon.", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 1
	
	-- Ételek
	{name = "Sült Krumpli", weight = 0.01, description = "Finom, ropogós.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 2
	{name = "Szendvics", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 3
	{name = "Taco", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2769}, -- 4
	{name = "Pizza szelet", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2702}, -- 5
	{name = "Hot-dog", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2769}, -- 6
	{name = "Hamburger", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 7
	{name = "Alma", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 8
	{name = "Zöldalma", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 9
	{name = "Körte", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 10
	{name = "Banán", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 11
	{name = "Szőlő", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 12
	{name = "Dinnye", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 12
	{name = "Sajt", weight = 0.01, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 14
	{name = "Chips", weight = 0.05, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 15
	{name = "Saláta", weight = 0.06, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2703}, -- 16
	{name = "Dürüm", weight = 0.04, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2769}, -- 17
	{name = "Gyros", weight = 0.05, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2769}, -- 18

	-- Italok
	{name = "Sprite", weight = 0.02, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 1546}, -- 19
	{name = "Fanta", weight = 0.02, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2647}, -- 20
	{name = "Coca Cola", weight = 0.02, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 1666}, -- 21
	{name = "Szénsavmentes víz", weight = 0.04, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 1951}, -- 22
	{name = "Mountain Dew", weight = 0.025, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 1950}, -- 23
	{name = "Sör", weight = 0.04, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 1509}, -- 24
	{name = "Bor", weight = 0.04, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 1664}, -- 25
	{name = "Kávé", weight = 0.03, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2647}, -- 26

	-- Fegyverek
	{name = "AK-47", weight = 4.8, description = "", isWeapon = true, ammo = 45, stackable = false, typ="bag", object = 6969}, -- 27
	{name = "M4", weight = 4.3, description = "", isWeapon = true, ammo = 45, stackable = false, typ="bag", object = 6969}, -- 28
	{name = "Katana", weight = 6, description = "", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 6969}, -- 29
	{name = "Desert Eagle", weight = 2.8, description = "", isWeapon = true, ammo = 47, stackable = false, typ="bag", object = 6969}, -- 30
	{name = "Baseball ütő", weight = 2, description = "", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 6969}, -- 31
	{name = "Kés", weight = 1, description = "", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 6969}, -- 32
	{name = "Gumibot", weight = 1, description = "", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 6969}, -- 33
	{name = "Sörétes puska", weight = 5, description = "", isWeapon = true, ammo = 46, stackable = false, typ="bag", object = 6969}, -- 34
	{name = "Lefűrészelt csövű puska", weight = 4.5, description = "", isWeapon = true, ammo = 46, stackable = false, typ="bag", object = 6969}, -- 35
	{name = "Spray", weight = 0.001, description = "", isWeapon = true, ammo = 50, stackable = true, typ="bag", object = 6969}, -- 36
	{name = "Colt-45", weight = 2.2, description = "", isWeapon = true, ammo = 47, stackable = false, typ="bag", object = 6969}, -- 37
	{name = "Mesterlövész", weight = 8, description = "", isWeapon = true, ammo = 49, stackable = false, typ="bag", object = 6969}, -- 38
	{name = "Mp5", weight = 4.2, description = "", isWeapon = true, ammo = 48, stackable = false, typ="bag", object = 6969}, -- 39
	{name = "Uzi", weight = 3.5, description = "", isWeapon = true, ammo = 48, stackable = false, typ="bag", object = 6969}, -- 40
	{name = "Sokkoló", weight = 2.4, description = "", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 347}, -- 41
	{name = "Tec 9", weight = 3.5, description = "", isWeapon = true, ammo = 48, stackable = false, typ="bag", object = 372}, -- 42
	{name = "Boxer", weight = 3.5, description = "", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 372}, -- 43
	{name = "Sokkoló", weight = 2, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 44

	--Lőszerek
	{name = "Nagykaliberű töltény", weight = 0.002, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2969}, -- 45
	{name = "Sörétes töltény", weight = 0.003, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2969}, -- 46
	{name = "Kiskaliberű töltény", weight = 0.002, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2969}, -- 47
	{name = "5x9-mm töltény", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2969}, -- 48
	{name = "Vadászpuska töltény", weight = 0.005, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2969}, -- 49
	{name = "Spray patron", weight = 0.003, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2969}, -- 50

	-- Kulcsok
	{name = "Jármű kulcs", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="key", object = 6969}, -- 51
	{name = "Ingatlan kulcs", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="key", object = 6969}, -- 52
	{name = "Kapu távirányító", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="key", object = 6969}, -- 53
	{name = "Széf kulcs", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="key", object = 6969}, -- 54

	--drogok
	{name = "Joint", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 55
	{name = "Heroinos fecskendő", weight = 0.004, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 56
	{name = "Kokain", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 57
	{name = "Szárított marihuana", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 58
	{name = "Marihuana mag", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 59
	{name = "Kokain mag", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 60
	{name = "Mák", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 61
	{name = "Kokalevél", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 62
	{name = "Marihuana levél", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 63
	{name = "Heroin por", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 64

	-- Iratok
	{name = "Személyi igazolvány", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 65
	{name = "Vezetői engedély", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 66
	{name = "Forgalmi engedély", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 67
	{name = "Fegyvertartási engedély", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 68
	{name = "Jelvény", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 69

	{name = "Fúró", weight = 7, description = "Széfek fúrásához...", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 70

	-- Egyéb
	{name = "Cigaretta", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 1485}, -- 71
	{name = "Öngyujtó", weight = 0.008, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 72
	{name = "Hifi", weight = 2.3, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 73
	{name = "Horgászbot", weight = 1.6, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 74
	{name = "Széf", weight = 5, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 75
	{name = "Gyógyszer", weight = 0.02, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 2217}, -- 76
	{name = "Bilincs", weight = 0.003, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 77
	{name = "Bilincs kulcs", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 78

	{name = "Vadászati engedély", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 79

	{name = "Kötszer", weight = 0.06, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 80
	{name = "Elsősegély csomag", weight = 0.6, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 1240}, -- 81
	{name = "Unflip kártya", weight = 0, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 82
	{name = "Rendőrségi fényjelző", weight = 1, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 83
	{name = "Csekk", weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 84
	{name = "Toll", weight = 0.1, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 85
	{name = "Fecskendő", weight = 0, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 86
	{name = "Szódabikarbóna", weight = 0.001, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 87
	{name = "Cigaretta papír", weight = 0, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 88
	{name = "Istant gyógyítás kártya", weight = 0, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 89
	{name = "Fix kártya", weight = 0, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 90
	{name = "Istant tankolás kártya", weight = 0, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 90

	--fegyver alkatrészek
	{name = "Tus", weight = 0.8, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 91
	{name = "Elsütő szerkezet és ravasz", weight = 1, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 92
	{name = "Pumpáló", weight = 1, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 93
	{name = "Cső", weight = 0.6, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 94
	{name = "Felső rész", weight = 0.3, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 95
	{name = "Alsó rész", weight = 0.3, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 96
	{name = "Markolat", weight = 0.8, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 97
	{name = "Ravasz", weight = 0.28, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 98
	{name = "Tár", weight = 0.5, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 99
	{name = "Elsütő szerkezet", weight = 1.4, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 100
	{name = "Markolat és ravasz", weight = 1.2, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 101
	{name = "Elsütő és ravasz", weight = 0.8, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 102
	{name = "Előágy", weight = 1, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 103
	{name = "Elsütő szerkezet", weight = 1.4, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 104
	{name = "Előágy", weight = 1, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 105
	{name = "Töltőrész", weight = 1, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 106
	{name = "Elsütő és felső rész", weight = 1.3, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 107
	{name = "Penge", weight = 0.6, description = "", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 108

	--Rendőrségi dolgok
	{name = "Rendőrségi pajzs", weight = 4.5, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 109
	{name = "Faltörő kos", weight = 2, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 110

	-- Dobozos cigik
	{name = "Natural American Spirit", weight = 0.2, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 112
	{name = "Newport", weight = 0.2, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 113
	{name = "Pall Mall", weight = 0.2, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 114
	
	{name = "Prémium Jármű Protect kártya", weight = 0, description = "Prémium Item", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 115

	{name = "Pr", weight = 0, description = "Prémium item", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 116
	
	-- Mesterkönyvek
	{name = "AK-47 Mesterkönyv",skillid = 77, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 116
	{name = "M4 Mesterkönyv",skillid = 78, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 117
	{name = "Uzi & Tec9 Mesterkönyv",skillid = 75, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 118
	{name = "Mp5 Mesterkönyv",skillid = 76, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 119
	{name = "Sörétes puska Mesterkönyv",skillid = 72, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 120
	{name = "Lefűrészelt csövű puska Mesterkönyv",skillid = 73, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 121
	{name = "Colt-45 Mesterkönyv",skillid = 69, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 122
	{name = "Hangtompítós Colt-45 Mesterkönyv",skillid = 70, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 123
	{name = "Desert Eagle Mesterkönyv",skillid = 71, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 124
	{name = "Mesterlövész Mesterkönyv",skillid = 79, weight = 0, description = "", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 125
	
	-- Halak
	{name = "Ponty", weight = 1, description = "Édésevizi hal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 127
	{name = "Harcsa", weight = 1.2, description = "Édésevizi hal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 128
	{name = "Sügér", weight = 1, description = "Édésevizi hal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 129
	{name = "Lazac", weight = 1.5, description = "Sósvizi hal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 130
	{name = "Amur", weight = 1.3, description = "Édesvizi hal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 131
	{name = "Angolna", weight = 2.1, description = "Édesvizi hal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 132
	{name = "Törpeharcsa", weight = 0.75, description = "Édésevizi hal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 133
	{name = "Zebrahal", weight = 0.5, description = "Édésevizi hal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 134
	{name = "Béka", weight = 0.25, description = "Állat.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 135

	--Szemét
	{name = "Rozsdás konzervdoboz", weight = 0.4, description = "Vízből kifogott szemét.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 136
	{name = "Lyukas vödör", weight = 1.3, description = "Vízből kifogott szemét.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 137
	{name = "Fa", weight = 0.8, description = "Vízből kifogott szemét.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 138
	{name = "Hínár", weight = 0.2, description = "Vízből kifogott szemét.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 139

	--Egyéb
	{name = "Kincsesláda", weight = 1.5, description = "Ki tudja mikori és mit rejthet?", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 140
	{name = "Zacskó", weight = 0.02, description = "Hmmmm... Mire lehet jó egy ilyen?", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 141

	{name = "5$-os bankjegy", weight = 0, description = "Bankjegy", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 142
	{name = "10$-os bankjegy", weight = 0, description = "Bankjegy", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 143
	{name = "20$-os bankjegy", weight = 0, description = "Bankjegy", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 144
	{name = "1$-os bankjegy", weight = 0, description = "Bankjegy", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 145

	{name = "Horgászengedély", weight = 0, description = "A horgászathoz elengedhetetlen irat.", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 146
	{name = "Csali", weight = 0.025, description = "Csali.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 147
	{name = "Speciális csali", weight = 0.05, description = "Csali, egyéb remek tulajdonságokkal.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 148
	{name = "Jegyzet", weight = 0, description = "Megtalálhatóak rajta a rendelések.", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 149

	{name = "Vitamin", weight = 0.025, description = "Vitamin.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 150
	{name = "Golyóálló mellény", weight = 4.5, description = "A rendvédelmi szervezetek számára fontos lehet...", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 151
	{name = "Kamera", weight = 1, description = "Kamera", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 6969}, -- 152
	{name = "Bírság", weight = 0.001, description = "Túl gyors voltál.", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 153
	{name = "Rádió", weight = 0.25, description = "Fontos elektronikai eszköz.", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 154
	{name = "Bankkártya", weight = 0.001, description = "Bankkártya.", isWeapon = false, ammo = false, stackable = false, typ="licens", object = 6969}, -- 155

	{name = "Vargánya", weight = 0.1, description = "Gomba.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 156
	{name = "Gyilkos galóca", weight = 0.2, description = "Gomba.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 157
	{name = "Barna csiperke", weight = 0.25, description = "Gomba.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 158
	{name = "Erdelyi pöfeteg", weight = 0.15, description = "Gomba.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 159
	{name = "Őzláb gomba", weight = 0.35, description = "Gomba.", isWeapon = false, ammo = false, stackable = true, typ="bag", object = 6969}, -- 160

	{name = "Láncfűrész", weight = 5, description = "Favágáshoz elengedhetetlen.", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 6969}, -- 161
	{name = "Poroltó", weight = 3, description = "Tűzoltáshoz elengedhetetlen.", isWeapon = true, ammo = false, stackable = false, typ="bag", object = 6969}, -- 162

	{name = "Fúró", weight = 2, description = "A barkácsolás elengedhetetlen kelléke.", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 163
	{name = "Feszítővas", weight = 3, description = "Sok mindenhez jól jöhet...", isWeapon = false, ammo = false, stackable = false, typ="bag", object = 6969}, -- 164

	-- Vadászat
	{name = "Medvefej", weight = 5, description = "", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 165
	{name = "Rókafej", weight = 3.75, description = "", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 166
	{name = "Medvebőr", weight = 1.25, description = "", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 166
	{name = "Rókabőr", weight = 1, description = "", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 168

	-- Bankrablás
	{name = "Tolvajkulcs", weight = 0.1, description = "A betörések elengedhetetlen kelléke...", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 169
	{name = "Fűrész", weight = 3.5, description = "A betörések elengedhetetlen kelléke...", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 170

	{name = "Cserép", weight = 2, description = "Növények ültetéséhez...", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 171
	{name = "Locsoló", weight = 4, description = "Növények locsolásához...", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 172

	{name = "Drog Alapanyag - Narancssárga", weight = 0.025, description = "Drogok készítéséhez...", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 173
	{name = "Drog Alapanyag - Sárga", weight = 0.025, description = "Drogok készítéséhez...", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 174
	{name = "Drog Alapanyag - Lila", weight = 0.025, description = "Drogok készítéséhez...", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 175
	{name = "Drog Alapanyag - Kék", weight = 0.025, description = "Drogok készítéséhez...", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 176
	{name = "Drog Alapanyag - Zöld", weight = 0.025, description = "Drogok készítéséhez...", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 177

	{name = "C4", weight = 3.25, description = "Ha robbantásra lenne szükség.", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 178

	-- Szerencsejáték
	{name = "Dobókocka", weight = 0.02, description = "Dobókocka.", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 179
	{name = "Kártyapakli", weight = 0.03, description = "Kártyapakli.", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 180
	{name = "Pénzérme", weight = 0.01, description = "Pénzérme.", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 181

	--Bankrob
	{name = "Fogó", weight = 0.5, description = "Barkácsoláshoz még jól jöhet.", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 182

	-- Üzemanyag
	{name = "Dízeles kanna", weight = 4, description = "Ha esetleg kifogyna az üzemanyag...", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 183
	{name = "Benzines kanna", weight = 4, description = "Ha esetleg kifogyna az üzemanyag...", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 184

	-- Kincskeresés
	{name = "Régi váza", weight = 1.2, description = "Kincs", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 185
	{name = "Díszes régi váza", weight = 1.5, description = "Kincs", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 186
	{name = "Törött váza", weight = 0.5, description = "Kincs", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 187
	{name = "Régi gyertyatartó", weight = 0.7, description = "Kincs", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 188
	{name = "Üvegpalack üzenettel 'Segítségkérés...'", weight = 0.8, description = "Kincs", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 189
	{name = "Üvegpalack üzenettel 'Az elveszett sziget...'", weight = 0.8, description = "Kincs", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 190
	{name = "Üvegpalack üzenettel 'Los Santos kincse...'", weight = 0.8, description = "Kincs", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 191
	{name = "Kincses térkép", weight = 0.1, description = "Kincs", isWeapon = false, ammo = false, stackable = false, typ = "bag"}, -- 192
	{name = "Homok", weight = 0.25, description = "Értéktelen", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 193
	{name = "Kavics", weight = 0.35, description = "Értéktelen", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 194

	{name = "Rubin", weight = 0.3, description = "Drágakő", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 195
	{name = "Smaragd", weight = 0.3, description = "Drágakő", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 196
	{name = "Zafír", weight = 0.3, description = "Drágakő", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 197
	{name = "Borostyánkő", weight = 0.3, description = "Drágakő", isWeapon = false, ammo = false, stackable = true, typ = "bag"}, -- 198
}

function getItemName(item,value)
	if not value then
		value = 0
	else
		value = tonumber(value)
	end
	if items[item] then	
		return items[item].name
	end
end

function getItemWeight(id)
	if items[id] then
		return items[id].weight
	end
end

function getItemDescription(id)
	if items[id] then
		return items[id].description
	end
end

function getItemTable()
	return items
end

function getItemStackable(id)
	if items[id] then
		return items[id].stackable
	end
end

function getTypeOfElement(element,item)
	if not isElement(element) then return false end
	--if not item then return false end
	if getElementType(element) == "player" then
		if not item then
			item = 1
		end
		return {items[item].typ, "user:id", 20}
	elseif getElementType(element) == "vehicle" then
		local maxWeight = exports.oVehicle:getVehicleTrunkMaxSize(getElementModel(element)) or 100
		return {"vehicle", "veh:id", maxWeight}
	else
		return {"object", "dbid", 100}
	end
end

function getPlayerDistanceFromElement(player, element)
	if not player or not element then return end
	local x, y, z = getElementPosition(player)
	local T_Pos = {getElementPosition(element)}
	return getDistanceBetweenPoints3D(x, y, z, unpack(T_Pos))
end

randomItems = {
	{14,1},{14,20},{14,21},{17,20},{17,21},{15,21},
	{15,22},{2,1},{3,1},{4,1},{5,1},{6,1},{7,1},{8,1},
	{9,1},{10,1},{11,1},{12,1},{13,1},{101,1},{102,1},
	{103,1},{104,1},{105,1},{106,1},{107,1},{108,1},
	{109,1},{110,1},{111,1},{112,1},{113,1},{114,1},
	{115,1},{116,1},{117,1},{118,1},{119,1},{120,1},
	{121,1},{122,1},{123,1},{124,1},{125,1},{126,1},
	{127,1},{128,1},{129,1},{130,1},{131,1},{132,1},
	{133,1},{148,1},{96,1},{97,1},
}

function generateSerial()
	return string.char(math.random(65,90)) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9)..string.char(math.random(65,90))..string.char(math.random(65,90))
end

function sendToAdmins(message)
	for k,v in ipairs(getElementsByType("player")) do 
		if exports.cl_admin:getPlayerAdminLevel(v) >= 2 then
			outputChatBox(message,v,255,255,255,true) 
		end
	end
end

function getItemImage(image) 
	return itemImageTextures[image]
	--[[if fileExists("files/items/"..image..".png") then 
		return ":oInventory/files/items/"..image..".png"
	else
		return ":oInventory/files/items/0.png"
	end]]
end

protectedPlaces = {
	{pos = Vector3(1426.5222167969, -1828.3203125, 12.421875), w = 133, d = 86, h = 25},
	{pos = Vector3(1274.8253173828, -1385.1062011719, 10.342861175537), w = 57, d = 60, h = 25},
}