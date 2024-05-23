core = exports.oCore
serverColor = {core:getServerColor()}

function loadWindowPos()
	if (fileExists("@complementaryPos.xml")) then
		local xmlNode = xmlLoadFile("@complementaryPos.xml", true)
		for i,v in ipairs(ownComplementary) do
		local index = v
			for i,v in ipairs(ownComplementary[index]) do
				v[3] = xmlNodeSetAttribute(xmlNode, v[1]) or {0, 0, 0, 0, 0, 0}
			end
		end
		xmlUnloadFile(xmlNode)
	end
end
loadWindowPos()

function saveWindowPos()
	local xmlNode
	if (fileExists("@complementaryPos.xml")) then
		xmlNode = xmlLoadFile("@complementaryPos.xml")
	else
		xmlNode = xmlCreateFile("@complementaryPos.xml", "root")
	end
	for i,v in ipairs(ownComplementary) do
	local index = v
		for i,v in ipairs(ownComplementary[index]) do
			xmlNodeSetAttribute(xmlNode, v[1], v[3])
		end
	end
	xmlSaveFile(xmlNode)
	xmlUnloadFile(xmlNode)
end

complementaryTypes = {
	{"Police", _, 1},
	{"Órák", _, 11},
	{"Szemüvegek", _, 1},
	{"Sapkák", _, 1},
	{"Egyéb", _, 1},
}

complementaryBones = {
	["Police"] = 1,
	["Órák"] = 11,
	["Szemüvegek"] = 1,
	["Sapkák"] = 1,
	["Egyéb"] = 11,
}

complementaryElements = {
	["Police"] = { 
		{"Police baseball sapka 1", 1000, 18386, 1},
		{"Police baseball sapka 2", 1000, 18358, 1},
		{"Police kalap", 1000, 4298, 1},
		{"Fekete police sisak", 2000, 18453, 1},
		{"Szürke police sisak", 2000, 18338, 1},
		{"Fekete golyóálló mellény", 2500, 4291, 3},
		{"Szürke golyóálló mellény", 2500, 18459, 3},
		{"Police pajzs", 3000, 18622, 3},  
	},
	["Órák"] = { 
		{"Szürke ezüst karóra", 4000, 18301},
		{"Fekete ezüst karóra", 4000, 18630},
		{"Szürke arany karóra", 5000, 18309}, 
		{"Fekete arany karóra", 5000, 18302}, 
		{"Fehérarany karóra", 7500, 18446}, 
	},
	["Szemüvegek"] = { 
		{"Fekete szemüveg", 1500, 18204},
		{"Barna szemüveg", 1500, 18214},
		{"Bordó szemüveg", 1500, 18376},	
		{"Fekete napszemüveg", 2000, 18206},
		{"Narancs napszemüveg", 2000, 18336},
		{"Kék napszemüveg", 2000, 18342},	
		{"Zöld napszemüveg", 2000, 18625},
		{"Rózsaszín napszemüveg", 2000, 18385},
		{"Lila napszemüveg", 2000, 18352},
		{"Sötétlila napszemüveg", 2000, 18475},
		{"Matt napszemüveg", 2000, 18477},
		{"Narancs farsangi szemüveg", 3000, 18343},	
		{"Zöld farsangi szemüveg", 3000, 18344},
		{"Kék farsangi szemüveg", 3000, 18351},
		{"Piros farsangi szemüveg", 3000, 18383},				
	},
	["Sapkák"] = {
		{"Fekete téli sapka", 2500, 18457},
		{"Fekete-szürke téli sapka", 2500, 18211},
		{"Zöld téli sapka", 2500, 18353},
		{"Piros téli sapka", 2500, 18479},
		{"Színes téli sapka", 3000, 18291},
		{"Szürke baseball sapka", 2500, 18359},
		{"Zöld baseball sapka", 2500, 18620},
		{"Fekete-szürke baseball sapka", 2750, 18213},
		{"Fekete-sárga baseball sapka", 2750, 18280},
		{"Piros-sárga baseball sapka", 2750, 4297},
		{"Sötétkék-világoskék baseball sapka", 2750, 18281},
		{"Óceán mintás baseball sapka", 2750, 18337},
		{"Katonás mintás baseball sapka", 2750, 18621},
		{"Fehér kalap", 2500, 18473},
		{"Színes kalap", 3000, 18345},
		{"Fehér-fekete kalap", 2750, 18485},
		{"Narancs-feket kalap", 2750, 4296},
		{"Kígyó mintás kalap", 2750, 18360},
	},
	["Egyéb"] = {
		{"Esőkabát", 2500, 325},
	},
}

ownComplementary = {
	----Név, id, pozíció, feltéve(true vagy false)
}