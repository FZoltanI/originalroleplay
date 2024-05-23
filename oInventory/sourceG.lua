row = 5;
column = 9;
margin = 2;
itemSize = 40;
actionSlots = 6;
actionMargin = 3;
craftSlots = 5;

core = exports.oCore
color, r, g, b = core:getServerColor()
font = exports.oFont
chat = exports.oChat
admin = exports.oAdmin

pages = {
    {
        name = "Tárgyak";
        img = "/files/images/icons/backpack.png";
        miniImg = "/files/images/miniicons/backpack.png";
        page = "bag";
    };
    {
        name = "Kulcsok";
        img = "/files/images/icons/key.png";
        miniImg = "/files/images/icons/key.png";
        page = "key";
    };
    {
        name = "Iratok";
        img = "/files/images/icons/licens.png";
        miniImg = "/files/images/icons/licens.png";
        page = "licens";
    };

	{
        name = "Széf";
        img = "/files/images/icons/safe.png";
        miniImg = "/files/images/miniicons/safe.png";
        page = "object";
	};
	{
        name = "Csomagtartó";
        img = "/files/images/icons/car.png";
        miniImg = "/files/images/miniicons/car.png";
        page = "vehicle";
    };
};

availableItems = {

	{name = "Iphone 12", weight = 0.3, description = "Apple telefon.", stacking = false, category="bag", }, -- 1

	-- Ételek
	{name = "Sült Krumpli", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 50, objectId = 2663}, -- 2
	{name = "Szendvics", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 35, objectId = 2663}, -- 3
	{name = "Taco", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 35, objectId = 2663}, -- 4
	{name = "Pizza szelet", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 30, objectId = 2663}, -- 5
	{name = "Hot-dog", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 35, objectId = 2663}, -- 6
	{name = "Hamburger", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 20, objectId = 2663}, -- 7
	{name = "Alma", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 50, objectId = 2663}, -- 8
	{name = "Zöldalma", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 50, objectId = 2663}, -- 9
	{name = "Muffin", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 35, objectId = 2663}, -- 10
	{name = "Banán", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 50, objectId = 2663}, -- 11
	{name = "Szőlő", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 50, objectId = 2663}, -- 12
	{name = "Dinnye", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 50, objectId = 2663}, -- 12
	{name = "Csokoládé", weight = 0.01, stacking = true, category="bag", eat = true, eatPercent = 50, objectId = 2663}, -- 14
	{name = "Chips", weight = 0.05, stacking = true, category="bag", eat = true, eatPercent = 50, objectId = 2663}, -- 15
	{name = "Saláta", weight = 0.06, stacking = true, category="bag", eat = true, eatPercent = 20, objectId = 2663}, -- 16
	{name = "Dürüm", weight = 0.04, stacking = true, category="bag", eat = true, eatPercent = 25, objectId = 2663}, -- 17
	{name = "Gyros", weight = 0.05, stacking = true, category="bag", eat = true, eatPercent = 20, objectId = 2663}, -- 18

	-- Italok
	{name = "Sprite", weight = 0.02, stacking = true, category="bag", drinkPercent = 25, drink = true}, -- 19
	{name = "Fanta", weight = 0.02, stacking = true, category="bag", drinkPercent = 25, drink = true}, -- 20
	{name = "Coca Cola", weight = 0.02, stacking = true, category="bag", drinkPercent = 25, drink = true}, -- 21
	{name = "Szénsavmentes víz", weight = 0.04, stacking = true, category="bag", drinkPercent = 20, drink = true}, -- 22
	{name = "Mountain Dew", weight = 0.025, stacking = true, category="bag", drinkPercent = 25, drink = true}, -- 23
	{name = "Sör", weight = 0.04, stacking = true, category="bag", alcohol = true}, -- 24
	{name = "Bor", weight = 0.04, stacking = true, category="bag", alcohol = true}, -- 25
	{name = "Kávé", weight = 0.03, stacking = true, category="bag", drinkPercent = 50, drink = true}, -- 26

	-- Fegyverek
	{name = "AK-47", weight = 4.8,  isWeapon = true, ammo = 45, stacking = false, category="bag"}, -- 27
	{name = "M4", weight = 3.13,  isWeapon = true, ammo = 45, stacking = false, category="bag"}, -- 28
	{name = "Katana", weight = 6,  isWeapon = true, stacking = false, category="bag"}, -- 29
	{name = "Desert Eagle", weight = 1.99,  isWeapon = true, ammo = 47, stacking = false, category="bag"}, -- 30
	{name = "Baseball ütő", weight = 2,  isWeapon = true, stacking = false, category="bag"}, -- 31
	{name = "Kés", weight = 1,  isWeapon = true, stacking = false, category="bag"}, -- 32
	{name = "Gumibot", weight = 1,  isWeapon = true, stacking = false, category="bag"}, -- 33
	{name = "Sörétes puska", weight = 5,  isWeapon = true, ammo = 46, stacking = false, category="bag"}, -- 34
	{name = "Lefűrészelt csövű puska", weight = 4.5,  isWeapon = true, ammo = 46, stacking = false, category="bag"}, -- 35
	{name = "Spray", weight = 0.001,  isWeapon = true, ammo = 50, stacking = false, category="bag"}, -- 36
	{name = "Colt-45", weight = 1.13,  isWeapon = true, ammo = 47, stacking = false, category="bag"}, -- 37
	{name = "Mesterlövész", weight = 8,  isWeapon = true, ammo = 49, stacking = false, category="bag"}, -- 38
	{name = "P90", weight = 3,  isWeapon = true, ammo = 48, stacking = false, category="bag"}, -- 39
	{name = "UZI", weight = 3.5,  isWeapon = true, ammo = 48, stacking = false, category="bag"}, -- 40
	{name = "Sokkoló", weight = 1.6,  isWeapon = true, stacking = false, category="bag"}, -- 41
	{name = "Tec 9", weight = 3.5,  isWeapon = true, ammo = 48, stacking = false, category="bag"}, -- 42
	{name = "Boxer", weight = 3.5,  isWeapon = true, stacking = false, category="bag"}, -- 43

	{name = "Pénzkazetta", weight = 4, stacking = false, category="bag"}, -- 44

	--Lőszerek
	{name = "Nagykaliberű töltény", weight = 0.002, stacking = true, category="bag"}, -- 45
	{name = "Sörétes töltény", weight = 0.003, stacking = true, category="bag"}, -- 46
	{name = "Kiskaliberű töltény", weight = 0.002, stacking = true, category="bag"}, -- 47
	{name = "5x9-mm töltény", weight = 0.001, stacking = true, category="bag"}, -- 48
	{name = "Vadászpuska töltény", weight = 0.005, stacking = true, category="bag"}, -- 49
	{name = "Spray patron", weight = 0.003, stacking = true, category="bag"}, -- 50

	-- Kulcsok
	{name = "Jármű kulcs", weight = 0, stacking = false, category="key"}, -- 51
	{name = "Ingatlan kulcs", weight = 0, stacking = false, category="key"}, -- 52
	{name = "Kapu távirányító", weight = 0, stacking = false, category="key"}, -- 53
	{name = "Széf kulcs", weight = 0, stacking = false, category="key"}, -- 54

	--drogok
	{name = "Joint", weight = 0.001, stacking = true, category="bag"}, -- 55
	{name = "Heroinos fecskendő", weight = 0.004, stacking = true, category="bag"}, -- 56
	{name = "Kokain", weight = 0.001, stacking = true, category="bag"}, -- 57
	{name = "Szárított marihuana", weight = 0.001, stacking = true, category="bag"}, -- 58
	{name = "Marihuana mag", weight = 0.001, stacking = true, category="bag"}, -- 59
	{name = "Kokain mag", weight = 0.001, stacking = true, category="bag"}, -- 60
	{name = "Mák", weight = 0.001, stacking = true, category="bag"}, -- 61
	{name = "Kokalevél", weight = 0.001, stacking = true, category="bag"}, -- 62
	{name = "Marihuana levél", weight = 0.001, stacking = true, category="bag"}, -- 63
	{name = "Heroin por", weight = 0.001, stacking = true, category="bag"}, -- 64

	-- Iratok
	{name = "Személyi igazolvány", weight = 0, stacking = false, category="licens"}, -- 65
	{name = "Vezetői engedély", weight = 0, stacking = false, category="licens"}, -- 66
	{name = "Flex", weight = 2, stacking = false, category="bag"}, -- 67
	{name = "Fegyvertartási engedély", weight = 0, stacking = false, category="licens"}, -- 68
	{name = "Jelvény", weight = 0, stacking = false, category="licens"}, -- 69

	{name = "Fúró", weight = 7, description = "Széfek fúrásához...", stacking = false, category="bag"}, -- 70

	-- Egyéb
	{name = "Cigaretta", weight = 0.001, stacking = false, category="bag"}, -- 71
	{name = "Öngyujtó", weight = 0.008, stacking = false, category="bag"}, -- 72
	{name = "Hifi", weight = 2.3, stacking = false, category="bag"}, -- 73
	{name = "Horgászbot", weight = 1.6, stacking = false, category="bag"}, -- 74
	{name = "Széf", weight = 5, stacking = false, category="bag"}, -- 75
	{name = "Gyógyszer", weight = 0.02, stacking = true, category="bag"}, -- 76
	{name = "Bilincs", weight = 0.003, stacking = false, category="bag"}, -- 77
	{name = "Bilincs kulcs", weight = 0.001, stacking = false, category="bag"}, -- 78

	{name = "Vadászati engedély", weight = 0, stacking = false, category="licens"}, -- 79

	{name = "Morzsoló", weight = 0.06, stacking = true, category="bag"}, -- 80
	{name = "Elsősegély csomag", weight = 0.6, stacking = true, category="bag", object = 1240}, -- 81
	{name = "Unflip kártya", weight = 0, stacking = true, category="bag"}, -- 82
	{name = "Rendőrségi fényjelző", weight = 1, stacking = false, category="bag"}, -- 83
	{name = "Hőlégfúvó", weight = 0.5, stacking = false, category="bag"}, -- 84
	{name = "Toll", weight = 0.1, stacking = false, category="bag"}, -- 85
	{name = "Fecskendő", weight = 0, stacking = true, category="bag"}, -- 86
	{name = "Szódabikarbóna", weight = 0.001, stacking = true, category="bag"}, -- 87
	{name = "Cigaretta papír", weight = 0, stacking = true, category="bag"}, -- 88
	{name = "Instant gyógyítás kártya", weight = 0, stacking = true, category="bag"}, -- 89
	{name = "Instant Fix kártya", weight = 0, stacking = true, category="bag"}, -- 90
	{name = "Instant tankolás kártya", weight = 0, stacking = true, category="bag"}, -- 91

	--pet kellékek
	{name = "Eb Egészségügyi felszerelés", weight = 0.8, stacking = true, category="bag"}, -- 92
	{name = "Itató kulacs", weight = 1, stacking = true, category="bag"}, -- 93
	{name = "Prémium Eb Táp", weight = 1, stacking = true, category="bag"}, -- 94
	{name = "Vegán Eb Táp", weight = 0.6, stacking = true, category="bag"}, -- 95
	{name = "Marhahúsos Eb Táp", weight = 0.3, stacking = true, category="bag"}, -- 96
	{name = "Sertéshúsos Eb Táp", weight = 0.3, stacking = true, category="bag"}, -- 97
	{name = "Csirkehúsos Eb Táp", weight = 0.8, stacking = true, category="bag"}, -- 98
	--

	--v2 drog
	{name = "Mák mag", weight = 0.001, stacking = true, category="bag"}, -- 99
	{name = "Varázsgomba mag", weight = 0.001, stacking = true, category="bag"}, -- 100
	{name = "Varázsgomba", weight = 0.001, stacking = true, category="bag"}, -- 101
	{name = "Ültető kanál", weight = 1.2, stacking = true, category="bag"}, -- 102
	{name = "Termőföld", weight = 0.001, stacking = true, category="bag"}, -- 103
	{name = "Prémium termőföld", weight = 0, stacking = true, category="bag"}, -- 104
	{name = "Szüretelő olló", weight = 1.4, stacking = true, category="bag"}, -- 105
	{name = "LSD", weight = 0.001, stacking = true, category="bag"}, -- 106
	{name = "Csomagolt Kokain", weight = 0.001, stacking = true, category="bag"}, -- 107
	{name = "Csomagolt Heroinos Fecskendő", weight = 0.001, stacking = true, category="bag"}, -- 108
	{name = "Csomagolt Joint", weight = 0.001, stacking = true, category="bag"}, -- 109

	--Rendőrségi dolgok
	{name = "Rendőrségi pajzs", weight = 4.5, stacking = false, category="bag"}, -- 110
	{name = "Faltörő kos", weight = 2, stacking = false, category="bag"}, -- 111

	-- Dobozos cigik
	{name = "Natural American Spirit", weight = 0.2, stacking = false, category="bag"}, -- 112
	{name = "Newport", weight = 0.2, stacking = false, category="bag"}, -- 113
	{name = "Pall Mall", weight = 0.2, stacking = false, category="bag"}, -- 114

	{name = "Prémium Jármű Protect kártya", weight = 0, description = "Prémium Item", stacking = true, category="bag"}, -- 115

	{name = "Pr", weight = 0, description = "Prémium item", stacking = true, category="bag"}, -- 116

	-- Mesterkönyvek
	{name = "AK-47 Mesterkönyv",skillid = 77, weight = 0, stacking = false, category="bag"}, -- 116
	{name = "M4 Mesterkönyv",skillid = 78, weight = 0, stacking = false, category="bag"}, -- 117
	{name = "Uzi & Tec9 Mesterkönyv",skillid = 75, weight = 0, stacking = false, category="bag"}, -- 118
	{name = "P90 Mesterkönyv",skillid = 76, weight = 0, stacking = false, category="bag"}, -- 119
	{name = "Sörétes puska Mesterkönyv",skillid = 72, weight = 0, stacking = false, category="bag"}, -- 120
	{name = "Lefűrészelt csövű puska Mesterkönyv",skillid = 73, weight = 0, stacking = false, category="bag"}, -- 121
	{name = "Colt-45 Mesterkönyv",skillid = 69, weight = 0, stacking = false, category="bag"}, -- 122
	{name = "Hangtompítós Colt-45 Mesterkönyv",skillid = 70, weight = 0, stacking = false, category="bag"}, -- 123
	{name = "Desert Eagle Mesterkönyv",skillid = 71, weight = 0, stacking = false, category="bag"}, -- 124
	{name = "Mesterlövész Mesterkönyv",skillid = 79, weight = 0, stacking = false, category="bag"}, -- 125

	-- Halak
	{name = "Ponty", weight = 1, stacking = true, category="bag"}, -- 127
	{name = "Harcsa", weight = 1.2, stacking = true, category="bag"}, -- 128
	{name = "Sügér", weight = 1, description = "Édésevizi hal.", stacking = true, category="bag"}, -- 129
	{name = "Lazac", weight = 1.5, description = "Sósvizi hal.", stacking = true, category="bag"}, -- 130
	{name = "Amur", weight = 1.3, description = "Édesvizi hal.", stacking = true, category="bag"}, -- 131
	{name = "Angolna", weight = 2.1, description = "Édesvizi hal.", stacking = true, category="bag"}, -- 132
	{name = "Törpeharcsa", weight = 0.75, description = "Édésevizi hal.", stacking = true, category="bag"}, -- 133
	{name = "Zebrahal", weight = 0.5, description = "Édésevizi hal.", stacking = true, category="bag"}, -- 134
	{name = "Béka", weight = 0.25, description = "Állat.", stacking = true, category="bag"}, -- 135

	--Szemét
	{name = "Rozsdás konzervdoboz", weight = 0.4, description = "Vízből kifogott szemét.", stacking = true, category="bag"}, -- 136
	{name = "Lyukas vödör", weight = 1.3, description = "Vízből kifogott szemét.", stacking = true, category="bag"}, -- 137
	{name = "Fa", weight = 0.8, description = "Vízből kifogott szemét.", stacking = true, category="bag"}, -- 138
	{name = "Hínár", weight = 0.2, description = "Vízből kifogott szemét.", stacking = true, category="bag"}, -- 139

	--Egyéb
	{name = "Elhasznált föld", weight = 0.2, description = "Agyagos szürke homok...", stacking = true, category="bag"}, -- 140
	{name = "Zacskó", weight = 0.02, description = "Hmmmm... Mire lehet jó egy ilyen?", stacking = false, category="bag"}, -- 141

	{name = "Ametiszt", weight = 0, description = "Drágakő", stacking = false, category="bag"}, -- 142
	{name = "Apatit", weight = 0, description = "Drágakő", stacking = false, category="bag"}, -- 143
	{name = "Törlőrongy", weight = 0, description = "Ha valami koszos!", stacking = false, category="bag"}, -- 144
	{name = "Takarítószer", weight = 0, description = "Spricc-Spricc", stacking = false, category="bag"}, -- 145

	{name = "Horgászengedély", weight = 0, description = "A horgászathoz elengedhetetlen irat.", stacking = false, category="licens"}, -- 146
	{name = "Csali", weight = 0.025, description = "Csali.", stacking = true, category="bag"}, -- 147
	{name = "Speciális csali", weight = 0.05, description = "Csali, egyéb remek tulajdonságokkal.", stacking = true, category="bag"}, -- 148
	{name = "Jegyzet", weight = 0, description = "Megtalálhatóak rajta a rendelések.", stacking = false, category="licens"}, -- 149

	{name = "Vitamin", weight = 0.025, description = "Vitamin.", stacking = true, category="bag"}, -- 150
	{name = "Golyóálló mellény", weight = 4.5, description = "A rendvédelmi szervezetek számára fontos lehet...", stacking = false, category="bag"}, -- 151
	{name = "Kamera", weight = 1, description = "Kamera", isWeapon = true, stacking = false, category="bag"}, -- 152
	{name = "Bírság", weight = 0.001, description = "Túl gyors voltál.", stacking = false, category="licens"}, -- 153
	{name = "Rádió", weight = 0.25, description = "Fontos elektronikai eszköz.", stacking = false, category="bag"}, -- 154
	{name = "Bankkártya", weight = 0.001, description = "Bankkártya.", stacking = false, category="licens"}, -- 155

	{name = "Vargánya", weight = 0.1, description = "Gomba.", stacking = true, category="bag"}, -- 156
	{name = "Gyilkos galóca", weight = 0.2, description = "Gomba.", stacking = true, category="bag"}, -- 157
	{name = "Barna csiperke", weight = 0.25, description = "Gomba.", stacking = true, category="bag"}, -- 158
	{name = "Erdei pöfeteg", weight = 0.15, description = "Gomba.", stacking = true, category="bag"}, -- 159
	{name = "Őzláb gomba", weight = 0.35, description = "Gomba.", stacking = true, category="bag"}, -- 160

	{name = "Láncfűrész", weight = 5, description = "Favágáshoz elengedhetetlen.", isWeapon = true, stacking = false, category="bag"}, -- 161
	{name = "Poroltó", weight = 3, description = "Tűzoltáshoz elengedhetetlen.", isWeapon = true, stacking = false, category="bag"}, -- 162

	{name = "Csavarbehajtó", weight = 2, description = "A barkácsolás elengedhetetlen kelléke.", stacking = false, category="bag"}, -- 163
	{name = "Feszítővas", weight = 3, description = "Sok mindenhez jól jöhet...", stacking = false, category="bag"}, -- 164

	-- Vadászat
	{name = "Medvefej", weight = 5, stacking = true, category = "bag"}, -- 165
	{name = "Rókafej", weight = 3.75, stacking = true, category = "bag"}, -- 166
	{name = "Medvebőr", weight = 1.25, stacking = true, category = "bag"}, -- 166
	{name = "Rókabőr", weight = 1, stacking = true, category = "bag"}, -- 168

	-- Bankrablás
	{name = "Tolvajkulcs", weight = 0.1, stacking = false, category = "bag"}, -- 169
	{name = "Fűrész", weight = 3.5, stacking = false, category = "bag"}, -- 170

	{name = "Cserép", weight = 2, stacking = false, category = "bag"}, -- 171
	{name = "Teli Locsoló", weight = 4, stacking = false, category = "bag"}, -- 172

	{name = "Drog Alapanyag - Narancssárga", weight = 0.025, stacking = true, category = "bag"}, -- 173
	{name = "Drog Alapanyag - Sárga", weight = 0.025, stacking = true, category = "bag"}, -- 174
	{name = "Drog Alapanyag - Lila", weight = 0.025, stacking = true, category = "bag"}, -- 175
	{name = "Drog Alapanyag - Kék", weight = 0.025, stacking = true, category = "bag"}, -- 176
	{name = "Drog Alapanyag - Zöld", weight = 0.025, stacking = true, category = "bag"}, -- 177

	{name = "C4", weight = 3.25, stacking = false, category = "bag"}, -- 178

	-- Szerencsejáték
	{name = "Dobókocka", weight = 0.02, stacking = false, category = "bag"}, -- 179
	{name = "Kártyapakli", weight = 0.03, stacking = false, category = "bag"}, -- 180
	{name = "Pénzérme", weight = 0.01, stacking = false, category = "bag"}, -- 181

	--Bankrob
	{name = "Fogó", weight = 0.5, stacking = false, category = "bag"}, -- 182

	-- Üzemanyag
	{name = "Dízeles kanna", weight = 4, stacking = false, category = "bag"}, -- 183
	{name = "Benzines kanna", weight = 4, stacking = false, category = "bag"}, -- 184

	-- Kincskeresés
	{name = "Régi váza", weight = 1.2, stacking = false, category = "bag"}, -- 185
	{name = "Díszes régi váza", weight = 1.5, stacking = false, category = "bag"}, -- 186
	{name = "Törött váza", weight = 0.5, stacking = false, category = "bag"}, -- 187
	{name = "Régi gyertyatartó", weight = 0.7, stacking = false, category = "bag"}, -- 188
	{name = "Üvegpalack üzenettel 'Segítségkérés...'", weight = 0.8, stacking = false, category = "bag"}, -- 189
	{name = "Üvegpalack üzenettel 'Az elveszett sziget...'", weight = 0.8, stacking = false, category = "bag"}, -- 190
	{name = "Üvegpalack üzenettel 'Los Santos kincse...'", weight = 0.8, stacking = false, category = "bag"}, -- 191
	{name = "Kincses térkép", weight = 0.1, stacking = false, category = "bag"}, -- 192
	{name = "Homok", weight = 0.25, stacking = true, category = "bag"}, -- 193
	{name = "Kavics", weight = 0.35, stacking = true, category = "bag"}, -- 194

	{name = "Rubin", weight = 0, stacking = false, category = "bag"}, -- 195
	{name = "Smaragd", weight = 0, stacking = false, category = "bag"}, -- 196
	{name = "Zafír", weight = 0, stacking = false, category = "bag"}, -- 197
	{name = "Borostyánkő", weight = 0, stacking = false, category = "bag"}, -- 198

	{name = "Taxi lámpa", weight = 0.3, stacking = false, category = "bag"}, -- 199
	{name = "Kincsesláda", weight = 0, description = "Vajon mit rejthet?", stacking = false, category = "bag"}, -- 200

	--
	{name = "Műanyag", weight = 0.25, stacking = true, category = "bag"}, -- 201
	{name = "Fa", weight = 0.35, stacking = true, category = "bag"}, -- 202
	{name = "Anyag vas", weight = 0.5, stacking = true, category = "bag"}, -- 203

	{name = "Kölni", weight = 0.1, stacking = false, category = "bag"}, -- 204
	{name = "Húsvéti tojás", weight = 0, stacking = false, category = "bag"}, -- 205

	{name = "Forgalmi engedély", weight = 0, stacking = false, category = "licens"}, -- 206
	{name = "Forgalmi engedély: Igénylőlap", weight = 0, stacking = false, category = "licens"}, -- 207
	{name = "OBD Scanner", weight = 0.4, stacking = false, category = "bag"}, -- 208

	{name = "Fénymásolt papír", weight = 0, stacking = false, category = "licens"}, -- 209
	{name = "Rendőrségi pajzs", weight = 5, stacking = false, category = "bag"}, -- 210
	{name = "Fegyveralkatrész", weight = 0.3, stacking = true, category = "bag"}, -- 211

	{name = "Whisky", weight = 0.3, stacking = true, category = "bag"}, -- 212
	{name = "Jim Beam", weight = 0.3, stacking = true, category = "bag"}, -- 213
	{name = "Absinth", weight = 0.3, stacking = true, category = "bag"}, -- 214
	{name = "Corona extra", weight = 0.3, stacking = true, category = "bag"}, -- 215
	{name = "Heineken", weight = 0.3, stacking = true, category = "bag"}, -- 216
	{name = "Szonda", weight = 0.14, stacking = false, category = "bag"}, -- 217

	{name = "Csokoládé (Marihuana)", weight = 0.001, stacking = true, category = "bag"}, -- 218
	{name = "Muffin (Marihuana)", weight = 0.001, stacking = true, category = "bag"}, -- 219
	{name = "Marihuana csomag", weight = 0.1, stacking = true, category = "bag"}, -- 220
	{name = "Marihuana olaj", weight = 0.1, stacking = true, category = "bag"}, -- 221
	{name = "Ragasztó", weight = 0.14, stacking = false, category = "bag"}, -- 222

	{name = "Üres Locsoló", weight = 4, stacking = false, category = "bag"}, -- 223
	{name = "ÜRES ITEM", weight = 0.1, stacking = false, category = "licens"}, -- 224

	{name = "Esernyő (Kék)", weight = 0.1, stacking = false, category = "bag"}, -- 225

	{name = "Csekk füzet (ORFK)", weight = 0, stacking = false, category="licens"}, -- 226
	{name = "Csekk füzet (OMSZ)", weight = 0, stacking = false, category="licens"}, -- 227
	{name = "Helyszíni bírság", weight = 0, stacking = false, category="licens"}, -- 228
	{name = "Orvosi ellátás (csekk)", weight = 0, stacking = false, category="licens"}, -- 229

	{name = "Dedikált mez (Fehér - Piros)", weight = 0.1, stacking = false, category="bag"}, -- 230
	{name = "Dedikált mez (Piros)", weight = 0.1, stacking = false, category="bag"}, -- 231
	{name = "Dedikált mez (Fehér - Kék)", weight = 0.1, stacking = false, category="bag"}, -- 232
	{name = "Dedikált mez (Narancssárga)", weight = 0.1, stacking = false, category="bag"}, -- 233

	{name = "Jármű kulcs #808080(Másolt)", weight = 0, stacking = false, category="key"}, -- 234
	{name = "Ingatlan kulcs #808080(Másolt)", weight = 0, stacking = false, category="key"}, -- 235

	{name = "Új zár (Jármű)", weight = 0.01, stacking = false, category="bag"}, -- 236
	{name = "Új zár (Ingatlan)", weight = 0.01, stacking = false, category="bag"}, -- 237

	{name = "Vértasak", weight = 0.01, stacking = true, category="bag"}, -- 238
	{name = "Olaj", weight = 2, stacking = true, category="bag"}, -- 239
	{name = "Taktikai szemüveg", weight = 0.5, stacking = false, category="bag"}, -- 240

	{name = "Lottószelvény", weight = 0, stacking = false, category="licens"}, -- 241
  	{name = "Flashbang", weight = 0.5,isWeapon = true, stacking = true, category="bag"}, -- 242

	{name = "Bengál égő", weight = 0.5, stacking = false, category="bag"}, -- 243
	{name = "Ördög rakéta", weight = 0.5, stacking = false, category="bag"}, -- 244
	{name = "Meteor", weight = 0.5, stacking = false, category="bag"}, -- 245
	{name = "Villanó üst", weight = 0.5, stacking = false, category="bag"}, -- 246
	{name = "Bomba telep", weight = 0.5, stacking = false, category="bag"}, -- 247
};


giftDrop = {
	[75] = {
		{id = 2},
		{id = 3},
		{id = 5},
		{id = 8},
		{id = 9},
		{id = 13},
		{id = 15},
		{id = 17},
		{id = 23},
		{id = 25},
		{id = 76},
		{id = 150},
	},
	--töltények
	[15] = {
		{id = 45, maxcount = 120},
		{id = 46, maxcount = 120},
		{id = 47, maxcount = 120},
		{id = 48, maxcount = 120},
		{id = 49, maxcount = 120},
	},
	--fegyverek
	[1] = {
		{id = 27},
		{id = 28},
		{id = 29},
		{id = 30},
		{id = 31},
		{id = 34},
		{id = 35},
		{id = 37},
		{id = 38},
		{id = 39},
		{id = 40},
		{id = 42},
		{id = 31},
		{id = 34},
		{id = 35},
		{id = 37},
		{id = 38},
	},
	-- Mesterkönyvek
	[25] = {
		{id = 117},
		{id = 118},
		{id = 119},
		{id = 120},
		{id = 121},
		{id = 122},
		{id = 123},
		{id = 125},
	},
	--pps és egyéb
	[5] = {
		{id = 178},
		{id = 115},
		{id = 70},
		{id = 89},
		{id = 90},
		{id = 91},
		{id = 82},
		{id = 70},
		{id = 75},
	},
	--drokok
	[10] = {
		{id = 55},
		{id = 56},
		{id = 57},
	}
}

randomTable = {75};


--Uzi,Tec,Vadászpuska,Molotov,Kés
availableCraft = {
	[21] = {--ak47 amit kapsz
		--{item,slot,darab}
		{55,7,1}; -- Cső és előágy
		{56,8,1}; -- Elsütő szerkezet
		{57,13,1}; -- Ravasz és markolat
		{58,18,1}; -- Tár
		{59,9,1}; -- Tus
	};
	--m4
	[23] = {
		{63,8,1}; -- felső rész
		{60,12,1}; -- cső
		{61,13,1}; -- előágy
		{62,14,1}; -- elsütő
		{67,15,1}; -- tus
		{66,18,1}; -- tár
		{65,19,1}; -- ravasz
		{64,24,1}; -- markolat
	};
	[26] = { --colt45
		{69,8,1}; -- felső rész
		{68,12,1}; -- alsó rész
		{71,13,1}; -- ravasz
		{70,14,1}; -- markolat
		{72,19,1}; -- tár
	};
	[28] = { --shoti
		{73,11,1}; -- Tus
		{74,12,1}; -- Markolat
		{75,13,1}; -- Elsütő
		{77,14,1}; -- Pumpáló
		{78,15,1}; -- Cső
		{76,18,1}; -- Ravasz
	};
	[30] = { --sawed off
		{82,9,1}; -- Cső
		{79,12,1}; -- Markolat
		{81,13,1}; -- Elsütő
		{80,18,1}; -- Ravasz
		{83,19,1}; -- Tok
	};
	[49] = { --kés
		{84,7,1}; -- Penge
		{85,13,1}; -- Markolat
	};
	[40] = { --molotov
		{86,8,1}; -- Rongy
		{87,13,1}; -- Whiskey
	};
	[36] = { --vadász
		{88,12,1}; -- Tus
		{89,13,1}; -- Elsütő
		{90,18,1}; -- Ravasz
		{91,14,1}; -- Tok
		{92,15,1}; -- Cső
	};
	[33] = { --tec9
		{94,9,1}; -- Elsütő
		{93,11,1}; -- cső
		{96,12,1}; -- előágy
		{95,13,1}; -- alsó rész
		{98,14,1}; -- markolat és ravasz
		{97,18,1}; -- tár
	};
	[32] = { --tec9
		{101,7,1}; -- Felső rész
		{100,8,1}; -- Elsütő
		{99,9,1}; -- cső
		{102,12,1}; -- markolat
		{103,13,1}; -- ravasz
		{104,17,1}; -- tár
	};
}

weaponCache = {

	[33] = {
		isBack = true,
		hotTable = false,
		model = 334,
		position = {13, -0.05, -0.07, 0.2, 0, 0, 90},
		weapon = 3,
		ammo = -1,
	}, -- Gumibot
	[32] = {
		isBack = true,
		hotTable = false,
		model = 335,
		position = {14, 0.1, -0.07, 0.1, 0, 0, 90},
		weapon = 4,
		ammo = -1,
	}, -- Kés

	[31] = {
		isBack = true,
		model = 336,
		position = {6, -0.1, -0.1, 0.2, 10, 260, 95},
		hotTable = false,
		weapon = 5,
		ammo = -1,
	}, -- Basketball

	[161] = {
		isBack = false,
		hotTable = false,
		weapon = 9,
		ammo = -1,
	}, -- Láncfűrész

	[27] = {
		isBack = true,
		hotTable = 8,
		model = 355,
		position = {6, -0.09, -0.1, 0.2, 10, 155, 95},
		weapon = 30,
		ammo = 45,
	}, -- AK-47

	[28] = {
		isBack = true,
		hotTable = 6,
		model = 356,
		position = {5, 0.15, -0.1, 0.2, -10, 155, 90},
		weapon = 31,
		ammo = 45,
	}, -- M4

	[37] = {
		isBack = false,
		hotTable = 16,
		weapon = 22,
		ammo = 47,
	}, -- Colt-45

	[30] = {
		isBack = true,
		hotTable = 16,
		weapon = 24,
		model = 348,
		position = {14, 0.08, 0, 0.1, 0, 270, 90},
		ammo = 47,
	}, -- Desert Eagle

	[41] = {
		isBack = true,
		hotTable = false,

		model = 347,
		position = {13, -0.06, 0, 0.1, 0, 270, 90},

		weapon = 23,
		ammo = -1,
	}, -- Sokkoló

	[34] = {
		isBack = true,
		hotTable = 40,
		model = 349,
		position = {5, 0.15, -0.1, 0.2, 0, 155, 90},
		weapon = 25,
		ammo = 46,
	}, -- Sörétes puska

	[35] = {
		isBack = true,
		hotTable = 38,
		model = 350,
		position = {5, 0.15, 0.06, 0.2, 0, 172, 90},
		weapon = 26,
		ammo = 46,
	}, -- Rövid csövű sörétes puska

	[29] = { -- ?
		isBack = true,
		hotTable = false,
		model = 339,
		position = {6, -0.1, 0.1, 0.05, 10, -110, 95},
		weapon = 8,
		ammo = -1,
	}, -- Katana

	[40] = {
		isBack = false,
		hotTable = 7,
		weapon = 28,
		ammo = 48,
	}, -- Uzi

	[39] = {
		isBack = true,
		hotTable = 6,
		model = 353,
		position = {13, -0.07, 0.04, 0.06, 0, -90, 95},
		weapon = 29,
		ammo = 48,
	}, -- p90

	[42] = {
		isBack = false,
		hotTable = 6,
		weapon = 32,
		ammo = 48,
	}, -- TEC-9

	[36] = { -- ?
		isBack = false,
		hotTable = false,
		weapon = 41,
		ammo = 50,
	}, -- Spray

	[38] = {
		isBack = true,
		hotTable = 42,
		model = 358,
		position = {5, 0.15, -0.1, 0.2, -10, 155, 90},
		weapon = 34,
		ammo = 49,
	}, -- Mesterlövész
	[162] = {
		isBack = false,
		notAnim = true,
		hotTable = false,
		weapon = 42,
		ammo = -1,
	}, -- Poroltó
	[152] = {
		isBack = false,
		notAnim = true,
		hotTable = false,
		weapon = 43,
		ammo = -1,
	}, -- Kamera
	[43] = {
		isBack = false,
		notAnim = true,
		hotTable = false,
		weapon = 1,
		ammo = -1,
	}, -- Boxer
  [242] = {
    isBack = false,
    notAnim = true,
    hotTable = false,
    weapon = 16,
    ammo = -1,
  }, -- Flashbang (ALAPJÁRATON GRENADE)
};
identityItems = {};

customItemNamesByValue = {
	[27] = { -- AK
		[2] = "Winter AK-47",
		[3] = "Camo AK-47",
		[4] = "Digit AK-47",
		[5] = "Gold AK-47",
		[6] = "Gilded AK-47",
		[7] = "Hello Kitty AK-47",
		[8] = "Silver AK-47",
	},

	[28] = { -- M4
		[2] = "Camo M4",
		[3] = "Winter M4",
		[4] = "Bloody M4",
		[5] = "Gold M4",
		[6] = "Winter Light M4",
		[7] = "Hello Kitty M4",
		[8] = "Bronze M4",
		[9] = "Silver M4",
	},

	[30] = { -- Deagle
		[2] = "Camo Desert Eagle",
		[3] = "Gold Desert Eagle",
		[4] = "Hello Kitty Desert Eagle",
	},

	[32] = { -- Kés
		[2] = "Camo Knife",
		[3] = "Rust Knife",
		[4] = "Carbon Knife",
		[5] = "Tiger Knife",
		[6] = "Digit Knife",
		[7] = "Spider Knife",
	},

	[38] = { -- Sniper
		[2] = "Winter Camo Sniper",
		[3] = "Camo Sniper",
	},

	[39] = { -- P90
		[2] = "Camo P90",
		[3] = "Winter Camo P90",
		[4] = "Black P90",
		[5] = "Gold Flow P90",
		[6] = "No Limit P90",
		[7] = "Oni P90",
		[8] = "Carbon P90",
		[9] = "Wood P90",
		[10] = "Halloween P90",
	},

	[40] = { -- UZI
		[2] = "Bronze UZI",
		[3] = "Camo UZI",
		[4] = "Gold UZI",
		[5] = "Winter UZI",
	},

	[42] = { -- TEC 9
		[2] = "Bronze TEC 9",
		[3] = "Camo TEC 9",
		[4] = "Gold TEC 9",
		[5] = "Winter TEC 9",
	},

	[209] = { -- Fénymásolt irat
		[1] = "Fénymásolt személyi igazolvány",
		[2] = "Fénymásolt vezetői engedély",
		[3] = "Fénymásolt fegyvertartási engedély",
		[4] = "Fénymásolt vadászati engedély",
		[5] = "Fénymásolt forgalmi engedély",
	},

	[225] = {
		[2] = "Esernyő (Narancs)",
		[3] = "Esernyő (Piros)",
		[4] = "Esernyő (Fekete)",
		[5] = "Esernyő (Zöld)",
		[6] = "Esernyő (Fehér)",
		[7] = "Esernyő (Lila)",
	}
}

function getItemName(item, value)
	if not value then value = 1 end

	if not (item == 209) then
		value = tonumber(value)
	end
	--print(value)
	if availableItems[item] then
		if item == 209 then
			if value == 1 then
				return availableItems[item].name;
			else
				value = fromJSON(value)[1][1] or false

				if customItemNamesByValue[item] then
					if (customItemNamesByValue[item][value] or false) then
						return customItemNamesByValue[item][value];
					else
						return availableItems[item].name;
					end
				else
					return availableItems[item].name;
				end
			end
		else
			if (value or 1) > 1 then
				if customItemNamesByValue[item] then
					if (customItemNamesByValue[item][value] or false) then
						return customItemNamesByValue[item][value];
					else
						return availableItems[item].name;
					end
				else
					return availableItems[item].name;
				end
			else
				return availableItems[item].name;
			end
		end
	end
end

function getItemImage(item, value)
	if availableItems[item] then

		if (fileExists(":oInventory/files/items/" .. item .. ".png")) then
			if item == 83 then
				if value == 2 then
					return ":oInventory/files/items/" .. item .. "_"..value..".png";
				else
					return ":oInventory/files/items/" .. item .. ".png";
				end
			elseif item == 209 then
				if value then
					value = fromJSON(value)[1][1] or false
					if fileExists(":oInventory/files/items/" .. item .. "_"..value..".png") then
						return ":oInventory/files/items/" .. item .. "_"..value..".png";
					else
						return ":oInventory/files/items/" .. item .. ".png";
					end
				else
					return ":oInventory/files/items/" .. item .. ".png";
				end
			else
				if not value then value = 0 end

				if (tonumber(value) or 0) > 0 then
					if fileExists(":oInventory/files/items/" .. item .. "_"..value..".png") then
						return ":oInventory/files/items/" .. item .. "_"..value..".png";
					else
						return ":oInventory/files/items/" .. item .. ".png";
					end
				else
					return ":oInventory/files/items/" .. item .. ".png";
				end
			end
		end
		return ":oInventory/files/items/0.png";
	end
	return ":oInventory/files/items/0.png";
end

function getItemImageTexture(item)
	return itemImageTextures[item]
end

function getItemWeight(item)
	if availableItems[item] then
		return availableItems[item].weight;
	end
end

function getItemStackable(item)
	if availableItems[item] then
		return availableItems[item].stacking;
	end
end

function getItemObject(item)
	if availableItems[item] then
		return availableItems[item].object;
	end
end

function getCache(item)
	return availableItems
end

alcoholItemDiff = {
	[24] = 10,
	[25] = 10,
	[212] = 20,
	[213] = 30,
	[214] = 10,
	[215] = 10,
	[216] = 10,
}

function isAlcoholDrink(item)
	return (item >= 212 and item <= 216) or item == 24 or item == 25
end

function getTypeElement(element,item)
	if isElement(element) then
		if getElementType(element) == "player" then
			if not item then
				item = 1
			end
			category = availableItems[item].category or "bag"
			return {category, "user:id", 20}
		elseif getElementType(element) == "vehicle" then
			return {"vehicle", "veh:id", exports.oVehicle:getVehicleTrunkMaxSize(getElementModel(element))}
		else
			return {"object", getElementType(element)..":dbid", 65}
		end
	else
		return false
	end
end

function getItemTooltipWorldItem(item,value,count,state)
	local name = getItemName(item,value);
	local drawName = color..name.."#ffffff";
	local drawWeight = "Súly: #3D7ABC"..getItemWeight(item)*count.."#ffffff kg.";
	if state >= 75 and state <= 100 then
		stateHtml = "#7cc576";
	elseif state >= 50 and state < 75 then
		stateHtml = "#eda828";
	elseif state < 50 then
		stateHtml = "#D23131";
	else
		stateHtml = color;
	end
	local drawState = "Állapot: "..stateHtml..(state or 0).."#ffffff %";
	local countText = "#7cc576"..count .. "#ffffff db"

	if weaponCache[item] and weaponCache[item].hotTable then
		tooltip = {drawName,drawState,"#ffffff",drawWeight,countText}
	elseif availableItems[item].eat or availableItems[item].drink then
		tooltip = {drawName,drawState,drawWeight,countText}
	elseif item == 51 or item == 52 or item == 54 or item == 53 or item == 69 then
		tooltip = {drawName}
	--elseif item == 127 then
	--	tooltip = {drawName,"#f68934["..tostring(weaponSerial):gsub("_", " ").."] "..value.."#ffffff"};
	--elseif item == 129 then
	--	tooltip = {drawName,drawState};
	elseif item == 1 then
		tooltip = {drawName,drawWeight,countText};
	elseif item == 68 then
		tooltip = {drawName,countText};
	elseif item == 65 then
		tooltip = {drawName,countText};
	elseif item == 66 then
		tooltip = {drawName,countText};
	elseif item == 79 then
		tooltip = {drawName,countText};
	elseif item == 112 or item == 113 or item == 114 then
		tooltip = {drawName,"#f68934"..(state/10).." #ffffffszál",drawWeight,countText};
	elseif item == 154 then
		tooltip = {drawName,countText};
	elseif item == 155 then
		tooltip = {drawName,countText};
	elseif item == 163 or item == 164 then
		tooltip = {drawName,"#f68934"..(state).." #ffffff%",drawWeight,countText};
	elseif item == 183 or item == 184 then
		tooltip = {drawName,"#f68934"..(state/10).." #ffffffl",drawWeight,countText};
	elseif item == 204 then
		tooltip = {drawName,"#f68934"..(state).." #ffffffalkalom",drawWeight,countText};
	elseif item == 209 then
		local data = fromJSON(value)[1]
		valueText = "N/A"
		if data[1] == 1 then
			valueText = "#3D7ABCSzemélyi igazolvány másolat#ffffff"
		elseif data[1] == 2 then
			valueText = "#3D7ABCVezetői engedély másolat#ffffff"
		elseif data[1] == 3 then
			valueText = "#3D7ABCFegyvertartási engedély másolat#ffffff"
		elseif data[1] == 4 then
			valueText = "#3D7ABCVadászati engedély másolat#ffffff"
		end
		tooltip = {drawName, drawWeight,countText}
	else
		tooltip = {drawName,drawWeight,countText};
	end

	return tooltip or "";
end



function getItemTooltip(id,item,value,count,state,weaponSerial,pp,warn)
	local name = getItemName(item,value);

	if not pp then
		pp = 0;
	end

	if not warn then
		warn = 0;
	end

	local drawName = color..name.."#ffffff";
	if pp == 1 then
		drawName = "#FFD700[Premium] "..color..name.."#ffffff";
	end
	local drawWeight = "Súly: #3D7ABC"..getItemWeight(item)*count.."#ffffff kg.";

	if state >= 75 and state <= 100 then
		stateHtml = "#7cc576";
	elseif state >= 50 and state < 75 then
		stateHtml = "#eda828";
	elseif state < 50 then
		stateHtml = "#D23131";
	else
		stateHtml = color;
	end
	local drawState = "Állapot: "..stateHtml..(state or 0).."#ffffff %";

	if weaponCache[item] and weaponCache[item].hotTable then
		tooltip = {drawName.." #787878["..weaponSerial.."]#ffffff",drawState,"Figyelmeztetések: "..color..warn.."#ffffff",drawWeight}
	elseif availableItems[item].eat or availableItems[item].drink then
		tooltip = {drawName,drawState,drawWeight}
	elseif item == 51 or item == 52 or item == 54 or item == 53 or item == 69 or item == 234 or item == 235 then
		tooltip = {drawName,"Azonosító: #f68934"..value.."#ffffff"}
	--elseif item == 127 then
	--	tooltip = {drawName,"#f68934["..tostring(weaponSerial):gsub("_", " ").."] "..value.."#ffffff"};
	--elseif item == 129 then
	--	tooltip = {drawName,drawState};
	elseif item == 1 then
		tooltip = {drawName,"Telefonszám: #f68934"..value.."#ffffff",drawWeight};
	elseif item == 68 then
		tooltip = {drawName,"Név: #f68934"..string.sub(value,20):gsub("_", " ").."#ffffff", "Lejárat: #3D7ABC"..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."."};
	elseif item == 65 then
		tooltip = {drawName,"Név: #f68934"..string.sub(value,23):gsub("_", " ").."#ffffff", "Lejárat: #3D7ABC"..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."."};
	elseif item == 146 then
		tooltip = {drawName,"Név: #f68934"..string.sub(value,23):gsub("_", " ").."#ffffff", "Lejárat: #3D7ABC"..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."."};
	elseif item == 66 then
		tooltip = {drawName,"Név: #f68934"..string.sub(value,22):gsub("_", " ").."#ffffff", "Lejárat: #3D7ABC"..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."."};
	elseif item == 79 then
		tooltip = {drawName,"Név: #f68934"..string.sub(value,20):gsub("_", " ").."#ffffff", "Lejárat: #3D7ABC"..string.sub(value,9,12).."."..string.sub(value,13,14).."."..string.sub(value,15,16).."."};
	elseif item == 112 or item == 113 or item == 114 then
		tooltip = {drawName,"#f68934"..(state/10).." #ffffffszál",drawWeight};
	elseif item == 154 then
		tooltip = {drawName,"Frekvencia: #f68934"..getElementData(localPlayer, "char:radioStation").."#ffffff Hz"};
	elseif item == 155 then
		tooltip = {drawName,"Bankszámlaszám: #f68934"..value};
	elseif item == 163 or item == 164 then
		tooltip = {drawName,"#f68934"..(state).." #ffffff%",drawWeight};
	elseif item == 183 or item == 184 then
		tooltip = {drawName,"#f68934"..(state/10).." #ffffffl",drawWeight};
	elseif item == 142 or item == 143 or item == 195 or item == 196 or item == 197 or item == 198 then
		value = tonumber(value)
		if value == 1 then
			tooltip = {drawName,"#f68934? #ffffffgramm"};
		elseif value == 101 then
			tooltip = {drawName,"#f689341 #ffffffgramm"};
		elseif value == 102 then
			tooltip = {drawName,"#f689342 #ffffffgramm"};
		elseif value == 103 then
			tooltip = {drawName,"#f689343 #ffffffgramm"};
		elseif value == 104 then
			tooltip = {drawName,"#f689344 #ffffffgramm"};
		elseif value == 105 then
			tooltip = {drawName,"#f689345 #ffffffgramm"};
		end
	elseif item == 204 then
		tooltip = {drawName,"#f68934"..(state).." #ffffffalkalom",drawWeight};
	elseif item == 209 then
		local data = fromJSON(value)[1]
		valueText = "N/A"
		if data[1] == 1 then
			valueText = "#3D7ABCSzemélyi igazolvány másolat#ffffff"
		elseif data[1] == 2 then
			valueText = "#3D7ABCVezetői engedély másolat#ffffff"
		elseif data[1] == 3 then
			valueText = "#3D7ABCFegyvertartási engedély másolat#ffffff"
		elseif data[1] == 4 then
			valueText = "#3D7ABCVadászati engedély másolat#ffffff"
    elseif data[1] == 6 then
      valueText = "#3D7ABCHorgász engedély másolat#ffffff"
		end
		tooltip = {drawName, valueText, drawWeight}
	elseif item == 84 then
		tooltip = {drawName,"#f68934"..(value).." #fffffflap maradt",drawWeight};
	elseif item == 226 or item == 227 then
		tooltip = {drawName,"#f68934"..(value).." #fffffflap maradt"};
	elseif item == 228 or item == 229 then
		value = fromJSON(value)
		tooltip = {drawName,"#f68934"..(value["minutes"] or 0).." #ffffffperc a határidő végéig."};
	elseif item == 241 then
		tooltip = {drawName,"Szelvényszám: #f68934"..tonumber(value).."#ffffff"};
	else
		tooltip = {drawName,drawWeight};
	end

	return tooltip or "";
end

function generateSerial()
	return string.char(math.random(65,90)) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9)..string.char(math.random(65,90))..string.char(math.random(65,90))
end

function formatMoney(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

protectedPlaces = {
	{pos = Vector3(1426.5222167969, -1828.3203125, 12.421875), w = 133, d = 86, h = 25}, -- Városháza
	{pos = Vector3(1672.8151855469, -1200.0639648438, 23.000004331055), w = 37, d = 30, h = 10}, -- Bank
	{pos = Vector3(1138.9544677734, -1388.8897705078, 12.803576469421), w = 60, d = 100, h = 25}, -- Korház
	{pos = Vector3(2097.501953125, -1823.7355957031, 12.000002229004), w = 30, d = 35, h = 10}, -- Pizza hut, déli mellett
	{pos = Vector3(2404.0458984375, -1514.1313476562, 22.006782531738), w = 20, d = 25, h = 10}, -- étterem, east los santos
}

printerItems = {
	[65] = 1,
	[66] = 2,
	--[67] = 5,
	[68] = 3,
	[79] = 4,
	[209] = 209,
}

notDropItems = {
	[1] = true,
	[44] = true,
	[51] = true,
	[52] = true,
	[53] = true,
	[54] = true,
	[65] = true,
	[66] = true,
	[67] = true,
	[68] = true,
	[69] = true,
	[77] = true,
	[78] = true,
	[79] = true,
	[82] = true,
	[83] = true,
	[84] = true,
	[85] = true,
	[86] = true,
	[87] = true,
	[88] = true,
	[89] = true,
	[90] = true,
	[91] = true,
	[109] = true,
	[115] = true,
	[117] = true,
	[118] = true,
	[119] = true,
	[120] = true,
	[121] = true,
	[122] = true,
	[123] = true,
	[124] = true,
	[125] = true,
	[126] = true,
	[127] = true,
	[128] = true,
	[129] = true,
	[130] = true,
	[131] = true,
	[132] = true,
	[133] = true,
	[134] = true,
	[135] = true,
	[136] = true,
	[137] = true,
	[138] = true,
	[139] = true,
	[140] = true,
	[141] = true,
	[146] = true,
	[147] = true,
	[148] = true,
	[149] = true,
	[155] = true,
	[200] = true,
	[205] = true,
	[206] = true,
	[207] = true,
	[209] = true,
	[224] = true,
}
