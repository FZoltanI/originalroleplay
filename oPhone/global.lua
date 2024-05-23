core = exports.oCore
blur = exports.oBlur
interface = exports.oInterface
chat = exports.oChat
infobox = exports.oInfobox

color, r, g, b = core:getServerColor()

phoneServices = {
    {
		name = "Sprint",
		logo = "sprint",
		color = {"#ffdd05", 255, 221, 5},
		packages = {
			{name = "Kezdő", radius = 100, pricePerHour = 3, neededTime = 0},
			{name = "Biznisz", radius = 750, pricePerHour = 75, neededTime = 15},
			{name = "Kezdő", radius = 100, pricePerHour = 3, neededTime = 20},
			{name = "Biznisz", radius = 750, pricePerHour = 75, neededTime = 30},
			{name = "Kezdő", radius = 100, pricePerHour = 3, neededTime = 15},
			{name = "Biznisz", radius = 750, pricePerHour = 75, neededTime = 15},
		},
		towerPositons = Vector3(600.28576660156, -1459.1546630859, 80.15625),
		ped = {name = "Lara Brown", pos = Vector3(606.58630371094, -1462.755859375, 14.44877243042), rot = 271, skin = 150},
	},

	{
		name = "AT&T",
		logo = "att",
		color = {"#00a8e5", 0, 168, 229},
		packages = {
			{name = "Kezdő", radius = 100, pricePerHour = 3, neededTime = 0},
			{name = "Biznisz", radius = 750, pricePerHour = 75, neededTime = 15},
		},
		towerPositons = Vector3(913.60369873047, -1023.0577392578, 111.0546875),
		ped = {name = "Lara Brown", pos = Vector3(914.21942138672, -1004.6281738281, 37.979461669922), rot = 360, skin = 150},
	},

	{
		name = "verizon",
		logo = "verizon",
		color = {"#ed2127", 237, 33, 39},
		packages = {
			{name = "Kezdő", radius = 100, pricePerHour = 3, neededTime = 0},
			{name = "Városi", radius = 500, pricePerHour = 75, neededTime = 15},
			{name = "Biznisz", radius = 750, pricePerHour = 75, neededTime = 61},
		},
		towerPositons = Vector3(1566.7012939453, -1253.6917724609, 277.87973022461),
		ped = {name = "Lara Brown", pos = Vector3(1565.2108154297, -1274.0858154297, 17.407676696777), rot = 180, skin = 150},
	},
}


options = {
    {name = "Háttérkép", desc = "Háttérkép beállítása.", icon = "back.png", type = "menu"},
	{name = "Csengőhang", desc = "Csengőhang beállítása.", icon = "ringstone.png", type = "menu"},
	{name = "Értesítési hang", desc = "Értesítő hang beállítása.", icon = "ringstone.png", type = "menu"},
	{name = "Biztonság", desc = "Biztonsági beállítások.", icon = "privacy.png", type = "menu"},
    {name = "Dark Mode", desc = "Sötét mód használata.", icon = "darkmode.png", type = "on/off"},
}

uiColors = {
	["light"] = {
		["bg"] = tocolor(220, 220, 220, 255),
		["bar"] = tocolor(210, 210, 210, 255),
		["bar-2"] = tocolor(210, 210, 210, 150),

		["text-title"] = tocolor(60, 60, 60, 255),
		["text"] = tocolor(50, 50, 50, 255),
		["text2"] = tocolor(50, 50, 50, 155),
		["text-light"] = tocolor(50, 50, 50, 150),
		["text-time"] = tocolor(35, 35, 35, 255),
		["sms-time"] = tocolor(40, 40, 40, 50),
	},

	["dark"] = {
		["bg"] = tocolor(30, 30, 30, 255),
		["bar"] = tocolor(40, 40, 40, 255),
		["bar-2"] = tocolor(40, 40, 40, 150),

		["text-title"] = tocolor(220, 220, 220, 255),
		["text"] = tocolor(200, 200, 200, 255),
		["text2"] = tocolor(200, 200, 200, 155),
		["text-light"] = tocolor(200, 200, 200, 150),
		["text-time"] = tocolor(230, 230, 230, 255),
		["sms-time"] = tocolor(255, 255, 255, 50),
	},
}

appNames = {
	[10] = "Hírdetések",
	[11] = "Időjárás",
	[12] = "Dark Web",
--	[16] = "Taxi",
}

extraAppSizes = {
	[11] = {{1, 1}, {2, 2}, {4, 2}},
	[16] = {{1, 1}, {2, 2}},
}

defaultApps = {
	[1] = 10,
	[2] = {11, 1},
	[3] = 12,
--	[4] = {16, 1},
}

extraAppTypes = {
	[11] = {
		{"Kicsi", "dot"},
		{"Közepes", "dot"},
		{"Nagy", "dot"},
	},

--	[16] = {
--		{"Kicsi", "dot"},
--		{"Közepes", "dot"},
--	},
}


phoneButtonTexts = {7, 8, 9, 4, 5, 6, 1, 2, 3, "<", 0, "#"}

weatherIcons = {
	["Haze"] = "fog",
	["Mostly Cloudy"] = "cloud",
	["Clear sky"] = "sun_1",
	["Clouds"] = "sun_2",
	["Fog"] = "fog",
	["Mostly sunny"] = "sun_1",
	["Partly cloudy"] = "sun_2",
	["Partly sunny"] = "cloud",
	["Freezing rain"] = "rain",
	["Rain"] = "rain",
	["Sleet"] = "snow",
	["Snow"] = "snow",
	["Sunny"] = "sun_1",
	["Thunderstorms"] = "thunder",
	["Thunderstorm"] = "thunder",
	["Overcast clouds"] = "cloud",
	["Overcast Clouds"] = "cloud",
	["Scattered clouds"] = "cloud",
	["Broken Clouds"] = "cloud",
	["Scattered Clouds"] = "cloud",
	["Few clouds"] = "sun_2",
	["Moderate rain"] = "rain",
	["Light rain"] = "rain",
}

homeScreenFontColors = {
	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},
	{tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255)},
	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},
	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},
	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},

	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},
	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},
	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},
    {tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},

	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},
	
	{tocolor(255, 255, 255, 255), tocolor(255, 255, 255, 255)},
}

callingScreenColos = {
    tocolor(255, 255, 255, 255),
    tocolor(0, 0, 0, 255),
    tocolor(255, 255, 255, 255),
    tocolor(255, 255, 255, 255),
    tocolor(255, 255, 255, 255),
    tocolor(255, 255, 255, 255),
    tocolor(255, 255, 255, 255),
    tocolor(255, 255, 255, 255),
    tocolor(255, 255, 255, 255),
    tocolor(255, 255, 255, 255),
    tocolor(255, 255, 255, 255),
}

tiltottgombok = {
	["backspace"] = true,
	["tab"] = true,
	--["-"] = true,
	--["."] = true,
	--[","] = true,
	["lctrl"] = true,
	["rctrl"] = true,
	["lalt"] = true,
	["mouse1"] = true,
	["mouse2"] = true,
	["mouse3"] = true,
	["F1"] = true,
	["F2"] = true,
	["F3"] = true,
	["F4"] = true,
	["F5"] = true,
	["F6"] = true,
	["F7"] = true,
	["F8"] = true,
	["F9"] = true,
	["F10"] = true,
	["F11"] = true,
	["F12"] = true,
	["lshift"] = true,
	["rshift"] = true,
	["space"] = true,
	["Pgdn"] = true,
	["num_div"] = true,
	["num_mul"] = true,
	["num_sub"] = true,
	["num_add"] = true,
	["num_sub"] = true,
	["escape"] = true,
	["inster"] = true,
	["home"] = true,
	["delete"] = true,
	["end"] = true,
	["pgup"] = true,
	["scroll"] = true,
	["pause"] = true,
	["ralt"] = true,
	["enter"] = true,
	["capslock"] = true,
	["mouse_wheel_up"] = true,
	["mouse_wheel_down"] = true,
}

customKeys = {
    ["="] = "ó",
    ["#"] = "á",
    [";"] = "é",
    ["]"] = "ú",
    ["["] = "ő",
    ["'"] = "ö",
    ["/"] = "ü",
}

hungarianBigLetters = {
	["ó"] = "Ó",
	["á"] = "Á",
	["é"] = "É",
	["ú"] = "Ú",
	["ő"] = "Ő",
	["ö"] = "Ö",
	["ü"] = "Ü",
}

shiftKeys = {
	["4"] = "!",
	["5"] = "%",
	["6"] = "/",
	["7"] = "=",
	[","] = "?",
	["."] = ":",
}

altgrKeys = {
	["é"] = "$",
	["c"] = "&",
	["w"] = "|",
}

Menus911 = {
	{"ORFK", 1, "pd"},
	{"OMSZ", 19, "medic"},
	{"Autószerviz", 3, "mechanic"},
}

defaultContacts = { -- fordított sorrend
	{"Jack", "28362556398", "bj"},
	{"112", "112", "112"},
}

customCalls = {
	["bankrob"] = {
		["beforeMission"] = {
			"Csá, tesó!",
			"Úgy hallom készültök valami nagyra...",
			"Van valamim amire biztosan szükségetek lesz.",
			"Találkozzunk. Elküldöm a koordinátákat.",
		}
	}
}
