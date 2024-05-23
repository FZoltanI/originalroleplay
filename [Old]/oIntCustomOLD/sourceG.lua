core = exports.oCore
font = exports.oFont
color, r, g, b = core:getServerColor()

defaultCustomObjects = {
	[1] = {
		{x = -225,y = 3,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -221,y = 3,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -217,y = 3,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -213,y = 3,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		
		{x = -225,y = 7,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -221,y = 7,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -217,y = 7,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -213,y = 7,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		
		{x = -225,y = 11,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -221,y = 11,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -217,y = 11,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -213,y = 11,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		
		{x = -225,y = 15,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -221,y = 15,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -217,y = 15,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		{x = -213,y = 15,z = 2352,rx = 0,ry = 0,rz = 0,model = 16010,type = "floor"};
		
		
		--előre
		{x = -227,y = 3,z = 2353.8,rx = 0,ry = 0,rz = 0,model = 16271,type = "wall"};
		{x = -227,y = 7,z = 2353.8,rx = 0,ry = 0,rz = 0,model = 16271,type = "wall"};
		{x = -227,y = 11,z = 2353.8,rx = 0,ry = 0,rz = 0,model = 16271,type = "wall"};
		{x = -227,y = 15,z = 2353.8,rx = 0,ry = 0,rz = 0,model = 16271,type = "wall"};
		--hátra
		{x = -211,y = 3,z = 2353.8,rx = 0,ry = 0,rz = 180,model = 16271,type = "wall"};
		{x = -211,y = 7,z = 2353.8,rx = 0,ry = 0,rz = 180,model = 16271,type = "wall"};
		{x = -211,y = 11,z = 2353.8,rx = 0,ry = 0,rz = 180,model = 16271,type = "wall"};
		{x = -211,y = 15,z = 2353.8,rx = 0,ry = 0,rz = 180,model = 16271,type = "wall"};
		
		--balra
		{x = -225,y = 1,z = 2353.8,rx = 0,ry = 0,rz = 90,model = 16271,type = "wall"};
		{x = -221,y = 1,z = 2353.8,rx = 0,ry = 0,rz = 90,model = 16271,type = "wall"};
		{x = -217,y = 1,z = 2353.8,rx = 0,ry = 0,rz = 90,model = 16271,type = "wall"};
		{x = -213,y = 1,z = 2353.8,rx = 0,ry = 0,rz = 90,model = 16271,type = "wall"};
		
		--jobbra
		{x = -225,y = 17,z = 2353.8,rx = 0,ry = 0,rz = -90,model = 16271,type = "wall"};
		{x = -221,y = 17,z = 2353.8,rx = 0,ry = 0,rz = -90,model = 16271,type = "wall"};
		{x = -217,y = 17,z = 2353.8,rx = 0,ry = 0,rz = -90,model = 16271,type = "wall"};
		{x = -213,y = 17,z = 2353.8,rx = 0,ry = 0,rz = -90,model = 16271,type = "wall"};
		
		
		{x = -225,y = 3,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -221,y = 3,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -217,y = 3,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -213,y = 3,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		
		{x = -225,y = 7,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -221,y = 7,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -217,y = 7,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -213,y = 7,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		
		{x = -225,y = 11,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -221,y = 11,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -217,y = 11,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -213,y = 11,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		
		{x = -225,y = 15,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -221,y = 15,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -217,y = 15,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		{x = -213,y = 15,z = 2355.6,rx = 0,ry = 0,rz = 0,model = 16010,type = "roof"};
		
		{x = -226.9,y = 3.76,z = 2352.1,rx = 0,ry = 0,rz = -90,model = 1505,type = "door",defaultDoor = true};
		
	};
};


furnitureMenus = {
	[1] = {
		name = "Burkolat lecserélése";
		[1] = {
			menu = "floor";
			name = "Padló";
			[1] = {
				typeName = "Csempe";
				type = "tile";
				[1] = 1200;
				[2] = 1200;
				[3] = 1200;
				[4] = 1200;
				[5] = 1200;
				[6] = 1200;
				[7] = 1200;
				[8] = 1200;
				[9] = 1200;
				[10] = 1200;
				[11] = 1200;
				[12] = 1200;
				[13] = 1200;
				[14] = 1200;
				[15] = 1200;
				[16] = 1200;
				[17] = 1200;
				[18] = 1200;
				[19] = 1200;
				[20] = 1200;
				[21] = 1200;
				[22] = 1200;
				[23] = 1200;
				[24] = 1200;
				[25] = 1200;
				[26] = 1200;
				[27] = 1200;
				[28] = 1200;
				[29] = 1200;
				[30] = 1200;
				[31] = 1200;
				[32] = 1200;
				[33] = 1200;
				[34] = 1200;
				[35] = 1200;
				[36] = 1200;
				[37] = 1200;
				[38] = 1200;
				[39] = 1200;
				[40] = 1200;
				[41] = 1200;
				[42] = 1200;
				[43] = 1200;
				[44] = 1200;
				[45] = 1200;
				[46] = 1200;
				[47] = 1200;
				[48] = 1200;
				[49] = 1200;
			};
			[2] = {
				typeName = "Fa";
				type = "wood";
				[1] = 600;
				[2] = 600;
				[3] = 600;
				[4] = 600;
				[5] = 600;
				[6] = 600;
				[7] = 600;
				[8] = 600;
				[9] = 600;
				[10] = 600;
				[11] = 600;
				[12] = 600;
				[13] = 600;
				[14] = 600;
				[15] = 600;
				[16] = 600;
				[17] = 600;
				[18] = 600;
				[19] = 600;
				[20] = 600;
				[21] = 600;
				[22] = 600;
				[23] = 600;
				[24] = 600;
				[25] = 600;
				[26] = 600;
				[27] = 600;
				[28] = 600;
				[29] = 600;
				[30] = 600;
				[31] = 600;
				[32] = 600;
			};
			[3] = {
				typeName = "Szőnyeg";
				type = "carpet";
				[1] = 600;
				[2] = 600;
				[3] = 600;
				[4] = 600;
				[5] = 600;
				[6] = 600;
				[7] = 600;
				[8] = 600;
				[9] = 600;
				[10] = 600;
				[11] = 600;
				[12] = 600;
				[13] = 600;
				[14] = 600;
				[15] = 600;
				[16] = 600;
				[17] = 600;
				[18] = 600;
				[19] = 600;
				[20] = 600;
				[21] = 600;
			};
		};
		[2] = {
			menu = "roof";
			name = "Mennyezet";
			[1] = {
				typeName = "Normál";
				type = "normal";
				[1] = 1600;
				[2] = 1600;
				[3] = 1600;
				[4] = 1600;
				[5] = 1600;
				[6] = 1600;
				[7] = 1600;
				[8] = 1600;
				[9] = 1600;
				[10] = 1600;
				[11] = 1600;
				[12] = 1600;
				[13] = 1600;
				[14] = 1600;
				[15] = 1600;
				[16] = 1600;
				[17] = 1600;
				[18] = 1600;
				[19] = 1600;
				[20] = 1600;
				[21] = 1600;
				[22] = 1600;
				[23] = 1600;
				[24] = 1600;
				[25] = 1600;
			};
		};
		[3] = {
			menu = "wall";
			name = "Fal";
			[1] = {
				typeName = "Festék";
				type = "paint";
				[1] = 1600;
				[2] = 1600;
				[3] = 1600;
				[4] = 1600;
				[5] = 1600;
				[6] = 1600;
				[7] = 1600;
				[8] = 1600;
				[9] = 1600;
				[10] = 1600;
				[11] = 1600;
				[12] = 1600;
				[13] = 1600;
				[14] = 1600;
				[15] = 1600;
				[16] = 1600;
				[17] = 1600;
				[18] = 1600;
				[19] = 1600;
				[20] = 1600;
				[21] = 1600;
			};
			[2] = {
				typeName = "Csempe";
				type = "tile";
				[1] = 1600;
				[2] = 1600;
				[3] = 1600;
				[4] = 1600;
				[5] = 1600;
				[6] = 1600;
				[7] = 1600;
				[8] = 1600;
				[9] = 1600;
				[10] = 1600;
				[11] = 1600;
				[12] = 1600;
				[13] = 1600;
				[14] = 1600;
				[15] = 1600;
				[16] = 1600;
				[17] = 1600;
				[18] = 1600;
				[19] = 1600;
				[20] = 1600;
			};
			[3] = {
				typeName = "Tapéta";
				type = "wallpaper";
				[1] = 3200;
				[2] = 3200;
				[3] = 3200;
				[4] = 3200;
				[5] = 3200;
				[6] = 3200;
				[7] = 3200;
				[8] = 3200;
				[9] = 3200;
				[10] = 3200;
				[11] = 3200;
				[12] = 3200;
				[13] = 3200;
				[14] = 3200;
				[15] = 3200;
				[16] = 3200;
				[17] = 3200;
				[18] = 3200;
				[19] = 3200;
				[20] = 3200;
				[21] = 3200;
				[22] = 3200;
				[23] = 3200;
				[24] = 3200;
				[25] = 3200;
				[26] = 3200;
				[27] = 3200;
				[28] = 3200;
				[29] = 3200;
				[30] = 3200;
				[31] = 3200;
				[32] = 3200;
				[33] = 3200;
				[34] = 3200;
				[35] = 3200;
				[36] = 3200;
				[37] = 3200;
				[38] = 3200;
				[39] = 3200;
				[40] = 3200;
				[41] = 3200;
				[42] = 3200;
				[43] = 3200;
				[44] = 3200;
				[45] = 3200;
				[46] = 3200;
				[47] = 3200;
				[48] = 3200;
				[49] = 3200;
				[50] = 3200;
				[51] = 3200;
				[52] = 3200;
				[53] = 3200;
				[54] = 3200;
				[55] = 3200;
				[56] = 3200;
				[57] = 3200;
				[58] = 3200;
				[59] = 3200;
				[60] = 3200;
				[61] = 3200;
				[62] = 3200;
				[63] = 3200;
				[64] = 3200;
				[65] = 3200;
				[66] = 3200;
				[67] = 3200;
				[68] = 3200;
			};
		};
		[4] = {
			menu = "door";
			name = "Ajtó";
			[1] = {
				typeName = "Festet";
				type = "painted";
				[1] = {texname = "CJ_WOODDOOR5", model = 1502, money = 800,isTextured = false};
				[2] = {texname = "CJ_WOODDOOR5",model = 1502, money = 800,isTextured = true};
				[3] = {texname = "CJ_WOODDOOR5",model = 1502, money = 800,isTextured = true};
				[4] = {texname = "CJ_WOODDOOR5",model = 1502, money = 800,isTextured = true};
				[5] = {texname = "CJ_WOODDOOR5",model = 1502, money = 800,isTextured = true};
				[6] = {texname = "CJ_WOODDOOR5",model = 1502, money = 800,isTextured = true};
				[7] = {texname = "CJ_WOODDOOR5",model = 1502, money = 800,isTextured = true};
				[8] = {texname = "CJ_WOODDOOR2",model = 1491, money = 1200,isTextured = false};
				[9] = {texname = "CJ_WOODDOOR2",model = 1491, money = 1200,isTextured = true};
				[10] = {texname = "CJ_WOODDOOR2",model = 1491, money = 1200,isTextured = true};
				[11] = {texname = "CJ_WOODDOOR2",model = 1491, money = 1200,isTextured = true};
				[12] = {texname = "CJ_WOODDOOR2",model = 1491, money = 1200,isTextured = true};
				[13] = {texname = "CJ_WOODDOOR2",model = 1491, money = 1200,isTextured = true};
				[14] = {texname = "CJ_WOODDOOR2",model = 1491, money = 1200,isTextured = true};
			};
		};
	};
	[2] = {
		name = "Fal felhúzása";
		[1] = {
			name = "Normál";
			model = 16271;
		};
		[2] = {
			name = "Fél";
			model = 8412;
		};
		[3] = {
			name = "Ajtó keret";
			model = 9104;
			[1] = {model = 1502, texture = "1502_0", money = 800};
			[2] = {model = 1502, texture = "1502_1", money = 800};
			[3] = {model = 1502, texture = "1502_2", money = 800};
			[4] = {model = 1502, texture = "1502_3", money = 800};
			[5] = {model = 1502, texture = "1502_4", money = 800};
			[6] = {model = 1502, texture = "1502_5", money = 800};
			[7] = {model = 1502, texture = "1502_6", money = 800};
			[8] = {model = 1491, texture = "1491_0", money = 600};
			[9] = {model = 1491, texture = "1491_1", money = 600};
			[10] = {model = 1491, texture = "1491_2", money = 600};
			[11] = {model = 1491, texture = "1491_3", money = 600};
			[12] = {model = 1491, texture = "1491_4", money = 600};
			[13] = {model = 1491, texture = "1491_5", money = 600};
			[14] = {model = 1491, texture = "1491_6", money = 600};
		};
	};
	[3] = {
		name = "Belépő modosítása";
	};
};

doors = {
	{model = 1504, money = 1100};
	{model = 1505, money = 1100};
	{model = 1506, money = 1300};
	{model = 1507, money = 1100};
	{model = 1536, money = 800};
	{model = 1569, money = 900};
};

bejaratiajtok = {
	[1504] = true,
	[1505] = true,
	[1506] = true,
	[1507] = true,
	[1536] = true,
	[1569] = true,
}

toolMenuButtons = {
	{icon = {
		[0] = "roof_0.png",
		[1] = "roof_1.png",
	}, tooltip = "Tető láthatósága", event = "setroofshowing"},
}