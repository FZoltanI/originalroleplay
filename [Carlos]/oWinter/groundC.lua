local dim = 0
local int = 0
local loadSnow = true
local loadTick = 0

setTimer(function()
	dim = getElementDimension(localPlayer)
	int = getElementInterior(localPlayer)

	if dim > 0 or int > 0 then
		loadSnow = false
		loadTick = 0

		if isElement(myShader) then
			destroyElement(myShader)
			destroyElement(myShader2)
			destroyElement(myShader_jarda)
			destroyElement(myShader_jarda2)
			destroyElement(myShader_rail)
			destroyElement(myShader_railroads)
			destroyElement(myShader_snow)
			destroyElement(myShader_stone1)
			destroyElement(myShader_stone2)
			destroyElement(myShader_wall1)
			destroyElement(myShader_wall2)
			destroyElement(myShader_zebra)

			myShader = nil 
			myShader2 = nil 
			myShader_jarda = nil 
			myShader_jarda2 = nil 
			myShader_rail = nil 
			myShader_railroads = nil 
			myShader_snow = nil 
			myShader_stone1 = nil 
			myShader_stone2 = nil 
			myShader_wall1 = nil 
			myShader_wall2 = nil 
			myShader_zebra = nil 
		end
	else
		loadSnow = true
		loadTick = 0
	end
end, 1000, 0)

function startSnowShader()
	if not loadSnow then return end
	applySnowGround()


	loadTick = loadTick + 1
	if loadTick == 1 then
		local myShader = dxCreateShader("fx/shader.fx")
		local myShader2 = dxCreateShader("fx/shader.fx")
		local myShader_zebra = dxCreateShader("fx/shader.fx")
		local myShader_jarda = dxCreateShader("fx/shader.fx")
		local myShader_jarda2 = dxCreateShader("fx/shader.fx")
		local myShader_snow = dxCreateShader("fx/shader.fx")
		local myShader_wall1 = dxCreateShader("fx/shader.fx")
		local myShader_wall2 = dxCreateShader("fx/shader.fx")
		local myShader_stone1 = dxCreateShader("fx/shader.fx")
		local myShader_stone2 = dxCreateShader("fx/shader.fx")
		local myShader_rail = dxCreateShader("fx/shader.fx")
		local myShader_tree1 = dxCreateShader("fx/shader.fx")

		local myShader_Tyre1 = dxCreateShader("fx/shader.fx")
		local myShader_Tyre2 = dxCreateShader("fx/shader.fx")
		local myShader_Tyre3 = dxCreateShader("fx/shader.fx")
		local myShader_Tyre4 = dxCreateShader("fx/shader.fx")

		if myShader then
			local texture = dxCreateTexture("img/snow_street.jpg")
			local texture2 = dxCreateTexture("img/snow_street2.jpg")
			local texture_zebra = dxCreateTexture("img/snow_street_zebra.jpg")
			local texture_jarda = dxCreateTexture("img/snow_street_jarda.jpg")
			local texture_jarda2 = dxCreateTexture("img/snow_street_jarda2.jpg")
			local texture_snow = dxCreateTexture("img/snow.jpg")
			local texture_wall1 = dxCreateTexture("img/snow_wall1.jpg")
			local texture_wall2 = dxCreateTexture("img/snow_wall2.jpg")
			local texture_stone1 = dxCreateTexture("img/snow_stone1.jpg")
			local texture_stone2 = dxCreateTexture("img/snow_stone2.jpg")
			local texture_rail = dxCreateTexture("img/snow_railroads.jpg")
			local texture_tree1 = dxCreateTexture("img/newtreea128.png")

			local texture_tyre1 = dxCreateTexture("img/xvehicleenv128.png")
			local texture_tyre2 = dxCreateTexture("img/vehicletyres128.png")
			local texture_tyre3 = dxCreateTexture("img/thread.png")
			local texture_tyre4 = dxCreateTexture("img/tyre64a.png")
			
			resetWaterColor()
			
			--Value a texturának
			dxSetShaderValue(myShader, "TextSnow", texture)
			dxSetShaderValue(myShader2, "TextSnow", texture2)
			dxSetShaderValue(myShader_zebra, "TextSnow", texture_zebra)
			dxSetShaderValue(myShader_jarda, "TextSnow", texture_jarda)
			dxSetShaderValue(myShader_jarda2, "TextSnow", texture_jarda2)
			dxSetShaderValue(myShader_snow, "TextSnow", texture_snow)
			dxSetShaderValue(myShader_wall1, "TextSnow", texture_wall1)
			dxSetShaderValue(myShader_wall2, "TextSnow", texture_wall2)
			dxSetShaderValue(myShader_stone1, "TextSnow", texture_stone1)
			dxSetShaderValue(myShader_stone2, "TextSnow", texture_stone2)
			dxSetShaderValue(myShader_rail, "TextSnow", texture_rail)
			dxSetShaderValue(myShader_tree1, "TextSnow", texture_tree1)

			dxSetShaderValue(myShader_Tyre1, "TextSnow", texture_tyre1)
			dxSetShaderValue(myShader_Tyre2, "TextSnow", texture_tyre2)
			dxSetShaderValue(myShader_Tyre3, "TextSnow", texture_tyre3)
			dxSetShaderValue(myShader_Tyre4, "TextSnow", texture_tyre4)

			-- ORIGINAL MODELLEZÉSEK 
			--VH
			engineApplyShaderToWorldTexture(myShader_snow, "fu")

			--DÉLI
			engineApplyShaderToWorldTexture(myShader_snow, "grassburshed")
			


			-- Globalis TXD Betoltese
			--engineApplyShaderToWorldTexture(myShader_tree1, "*tree*")
			--engineApplyShaderToWorldTexture(myShader_rail, "*train*")
			engineApplyShaderToWorldTexture(myShader_Tyre1, "xvehicleenv128")
			engineApplyShaderToWorldTexture(myShader_Tyre2, "vehicletyres128")
			engineApplyShaderToWorldTexture(myShader_Tyre3, "thread")
			engineApplyShaderToWorldTexture(myShader_Tyre4, "tyre64a")
			

			engineApplyShaderToWorldTexture(myShader, "snpedtest1")

			engineApplyShaderToWorldTexture(myShader, "snpedtest1BLND")
			engineApplyShaderToWorldTexture(myShader, "dt_road")
			
			engineApplyShaderToWorldTexture(myShader, "ws_freeway3")
			engineApplyShaderToWorldTexture(myShader, "cos_hiwaymid_256")
			engineApplyShaderToWorldTexture(myShader_snow, "craproad3_LAe")
			engineApplyShaderToWorldTexture(myShader, "craproad7_LAe7")
			engineApplyShaderToWorldTexture(myShader, "craproad1_LAe")
			engineApplyShaderToWorldTexture(myShader, "hiwaymidlle_256")
			engineApplyShaderToWorldTexture(myShader, "dirttracksgrass256")
			engineApplyShaderToWorldTexture(myShader2, "Tar_1line256HV")
			engineApplyShaderToWorldTexture(myShader, "dt_roadblend")
			engineApplyShaderToWorldTexture(myShader, "desmudtrail")
			engineApplyShaderToWorldTexture(myShader, "roadnew4_256")
			engineApplyShaderToWorldTexture(myShader, "roadnew4_512")
			--engineApplyShaderToWorldTexture(myShader, "ws_carpark3")
			engineApplyShaderToWorldTexture(myShader2, "Tar_1line256HVblend")
			engineApplyShaderToWorldTexture(myShader2, "roaddgrassblnd")
			engineApplyShaderToWorldTexture(myShader, "desmudtrail2")
			engineApplyShaderToWorldTexture(myShader2, "Tar_freewyright")
			engineApplyShaderToWorldTexture(myShader2, "Tar_freewyleft")
			engineApplyShaderToWorldTexture(myShader, "roadnew4blend_256")
			engineApplyShaderToWorldTexture(myShader, "sl_freew2road1")
			engineApplyShaderToWorldTexture(myShader2, "desmudgrass")
			engineApplyShaderToWorldTexture(myShader, "sf_road5")
			engineApplyShaderToWorldTexture(myShader_jarda, "sf_pave6")
			engineApplyShaderToWorldTexture(myShader_zebra, "sf_junction5")
			engineApplyShaderToWorldTexture(myShader_jarda2, "sf_junction3")
			engineApplyShaderToWorldTexture(myShader2, "Tar_1line*")
			engineApplyShaderToWorldTexture(myShader_snow, "tarmacplain2_bank")
			engineApplyShaderToWorldTexture(myShader_snow, "newcrop3")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype5*")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype4*")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype10*")
			engineApplyShaderToWorldTexture(myShader_snow, "grass4dirtytrans")
			engineApplyShaderToWorldTexture(myShader_snow, "dirttracksgrass*")
			engineApplyShaderToWorldTexture(myShader, "cw2_weeroad1")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdead1")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_sandgrass4")
			engineApplyShaderToWorldTexture(myShader_snow, "rocktq128_grass4blend")
			engineApplyShaderToWorldTexture(myShader_snow, "forestfloor*")
			engineApplyShaderToWorldTexture(myShader_stone1, "rocktq128_forestblend")
			engineApplyShaderToWorldTexture(myShader_stone2, "desertstones256")
			engineApplyShaderToWorldTexture(myShader_snow, "cw2_mounttrail")
			engineApplyShaderToWorldTexture(myShader_stone1, "rocktq128*")
			engineApplyShaderToWorldTexture(myShader_snow, "forest_rocks")
			engineApplyShaderToWorldTexture(myShader_snow, "cw2_mounttrailblank")
			engineApplyShaderToWorldTexture(myShader_snow, "des_dirtgrassmix*")
			engineApplyShaderToWorldTexture(myShader, "sw_farmroad*")
			engineApplyShaderToWorldTexture(myShader, "dirttracksgrass*")
			engineApplyShaderToWorldTexture(myShader_snow, "bow_church_dirt")
			engineApplyShaderToWorldTexture(myShader_snow, "grassgrnbrnx*")
			engineApplyShaderToWorldTexture(myShader, "grassshort?long*")
			engineApplyShaderToWorldTexture(myShader_snow, "grass?_des_dirt*")
			engineApplyShaderToWorldTexture(myShader_snow, "grass*forest")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype*_rail")
			engineApplyShaderToWorldTexture(myShader_snow, "grass10*")
			engineApplyShaderToWorldTexture(myShader_snow, "roadblendcunt")
			engineApplyShaderToWorldTexture(myShader_snow, "forestfloor256")
			engineApplyShaderToWorldTexture(myShader_snow, "ws_airpt_concrete")
			engineApplyShaderToWorldTexture(myShader_snow, "ws_runwaytarmac")
			engineApplyShaderToWorldTexture(myShader_stone2, "cw2_mountroad")
			engineApplyShaderToWorldTexture(myShader_stone1, "cw2_mountdirtscree")
			engineApplyShaderToWorldTexture(myShader_stone1, "cuntbrncliff*")
			engineApplyShaderToWorldTexture(myShader_snow, "gm_lacarpark1")
			engineApplyShaderToWorldTexture(myShader_snow, "rodeo3sjm")
			engineApplyShaderToWorldTexture(myShader_snow, "dt_road2grasstype4")
			engineApplyShaderToWorldTexture(myShader2, "des_dirttrack1")
			engineApplyShaderToWorldTexture(myShader_snow, "brickgrey")
			engineApplyShaderToWorldTexture(myShader_stone1, "des_yelrock")
			engineApplyShaderToWorldTexture(myShader_snow, "des_grass2*")
			engineApplyShaderToWorldTexture(myShader_snow, "des_scrub*")
			engineApplyShaderToWorldTexture(myShader2, "des_1line*")
			engineApplyShaderToWorldTexture(myShader, "vegasdirtyroad1*")
			engineApplyShaderToWorldTexture(myShader_snow, "vegasdirtypave1*")
			engineApplyShaderToWorldTexture(myShader_zebra, "crossing_law*")
			
			engineApplyShaderToWorldTexture(myShader_snow, "des_dirt*")
			engineApplyShaderToWorldTexture(myShader_snow, "des_ripplsand")
			engineApplyShaderToWorldTexture(myShader_stone1, "des_redrock*")
			engineApplyShaderToWorldTexture(myShader_stone1, "des_rocky*")
			engineApplyShaderToWorldTexture(myShader_snow, "desstones_dirt*")
			engineApplyShaderToWorldTexture(myShader, "tar*")
			engineApplyShaderToWorldTexture(myShader2, "tar_lineslipway")
			engineApplyShaderToWorldTexture(myShader, "hiway*")
			engineApplyShaderToWorldTexture(myShader_snow, "hiwaygravel*")
			engineApplyShaderToWorldTexture(myShader_snow, "sandgrnd*")
			engineApplyShaderToWorldTexture(myShader2, "desert_1line*")
			
			engineApplyShaderToWorldTexture(myShader_snow, "waterclear*")

			--Zebra
			engineApplyShaderToWorldTexture(myShader_zebra, "crossing_law")
			engineApplyShaderToWorldTexture(myShader_zebra, "dt_road_stoplinea")
			engineApplyShaderToWorldTexture(myShader_zebra, "craproad2_LAe")
			engineApplyShaderToWorldTexture(myShader_zebra, "lasunion994")
			engineApplyShaderToWorldTexture(myShader_zebra, "aarprt8LAS")
				
			--Jardak
			engineApplyShaderToWorldTexture(myShader_snow, "lasjmhoodcrb")
			engineApplyShaderToWorldTexture(myShader_jarda, "kbpavement_test")
			engineApplyShaderToWorldTexture(myShader_jarda, "LAroad_offroad1")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmhoodlawn41")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewgrass1")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewgrass2")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewgrass3")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewgrass5")
			engineApplyShaderToWorldTexture(myShader_jarda, "Grass_concpath2")
			engineApplyShaderToWorldTexture(myShader_jarda2, "grassdry_path_128HV")
			engineApplyShaderToWorldTexture(myShader_jarda, "pavebsand256")
			engineApplyShaderToWorldTexture(myShader_jarda, "craproad5_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "craproad6_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidelatino1_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda2, "sjmhoodlawn4")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmhoodlawn42")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmhoodlawn41")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmndukwal2")
			engineApplyShaderToWorldTexture(myShader_jarda2, "grifnewtex1b")
			engineApplyShaderToWorldTexture(myShader_jarda2, "dockpave_256")
			engineApplyShaderToWorldTexture(myShader_jarda, "scumtiles3_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda2, "macpath_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "scumtiles2_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "scumtiles1_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "cos_hiwayins_256")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmhoodlawn42B")
			engineApplyShaderToWorldTexture(myShader_jarda, "kbpavementblend")
			engineApplyShaderToWorldTexture(myShader_jarda, "sl_pavebutt1")
			engineApplyShaderToWorldTexture(myShader_jarda2, "Newpavement")
			engineApplyShaderToWorldTexture(myShader_jarda, "starpave_law")
			engineApplyShaderToWorldTexture(myShader_jarda, "starpaveb_law")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewalk4_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewalk4_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "nicepavegras_LA")
			engineApplyShaderToWorldTexture(myShader_jarda, "ws_nicepave")
			engineApplyShaderToWorldTexture(myShader_jarda, "cuntroad01_law")
			engineApplyShaderToWorldTexture(myShader_jarda, "pavebsand256blueblend")
			engineApplyShaderToWorldTexture(myShader_jarda, "paveb256")
			engineApplyShaderToWorldTexture(myShader_jarda, "LAroad_offroad1")
			engineApplyShaderToWorldTexture(myShader_jarda, "kbpavement_test")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmhoodlawn41")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewgrass1")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewgrass2")
			engineApplyShaderToWorldTexture(myShader_jarda, "sw_path1")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewgrass3")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidewgrass5")
			engineApplyShaderToWorldTexture(myShader_jarda, "Grass_concpath2")
			engineApplyShaderToWorldTexture(myShader_jarda2, "grassdry_path_128HV")
			engineApplyShaderToWorldTexture(myShader_jarda, "pavebsand256")
			engineApplyShaderToWorldTexture(myShader_jarda, "craproad5_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "craproad6_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "sidelatino1_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda2, "sjmhoodlawn4")
			engineApplyShaderToWorldTexture(myShader_jarda2, "sjmhoodlawn4")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmhoodlawn42")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmhoodlawn41")
			engineApplyShaderToWorldTexture(myShader_jarda, "sjmndukwal2")
			engineApplyShaderToWorldTexture(myShader_jarda2, "dockpave_256")
			engineApplyShaderToWorldTexture(myShader_jarda2, "grifnewtex1b")
			engineApplyShaderToWorldTexture(myShader_jarda2, "macpath_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "scumtiles3_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "scumtiles2_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "scumtiles1_LAe")
			engineApplyShaderToWorldTexture(myShader_jarda, "cos_hiwayins_256")

			--Falak
			engineApplyShaderToWorldTexture(myShader_wall2, "ws_rottenwall")
			engineApplyShaderToWorldTexture(myShader_wall2, "newall10")
			engineApplyShaderToWorldTexture(myShader_wall1, "comptwall10")
			engineApplyShaderToWorldTexture(myShader_wall1, "stormdrain2_nt")
			engineApplyShaderToWorldTexture(myShader_wall1, "stonewalls1_LA")
			engineApplyShaderToWorldTexture(myShader_wall2, "BLOCK")				
			engineApplyShaderToWorldTexture(myShader_wall2, "BLOCK2")
			engineApplyShaderToWorldTexture(myShader_wall2, "adeta")
			engineApplyShaderToWorldTexture(myShader_wall2, "roughwall_kb_semless")
			
			--Homok,Szikla stb..
			engineApplyShaderToWorldTexture(myShader_stone1, "stones256")
			engineApplyShaderToWorldTexture(myShader_stone1, "mountainskree_stones256")
			engineApplyShaderToWorldTexture(myShader_stone2, "lasclifface")
			engineApplyShaderToWorldTexture(myShader_stone1, "hllblf2_LAE")
			engineApplyShaderToWorldTexture(myShader_stone1, "obhilltex1")
			engineApplyShaderToWorldTexture(myShader_stone1, "forestfloor3")
			engineApplyShaderToWorldTexture(myShader_stone1, "sm_rock2_desert")
			engineApplyShaderToWorldTexture(myShader_stone2, "desertstones256")
			engineApplyShaderToWorldTexture(myShader_stone2, "rocktbrn128")
			engineApplyShaderToWorldTexture(myShader_stone2, "grassbrn2rockbrn")
			engineApplyShaderToWorldTexture(myShader_stone1, "rocktbrn128blndlit")
			engineApplyShaderToWorldTexture(myShader_stone1, "cw2_mountrock")
			engineApplyShaderToWorldTexture(myShader_stone1, "sw_rockgrassB2")
			engineApplyShaderToWorldTexture(myShader_stone1, "sw_rockgrassB1")
			engineApplyShaderToWorldTexture(myShader_stone1, "sw_stonesgrass")
			engineApplyShaderToWorldTexture(myShader_stone1, "sw_stones")
			engineApplyShaderToWorldTexture(myShader_stone2, "deserstones256")
			engineApplyShaderToWorldTexture(myShader_stone2, "rockwall2_LAe2")
			engineApplyShaderToWorldTexture(myShader_stone2, "rockwall1_LAe2")
			engineApplyShaderToWorldTexture(myShader_stone2, "sw_rockgrass1")
			engineApplyShaderToWorldTexture(myShader_stone1, "cs_rockdetail2")
			engineApplyShaderToWorldTexture(myShader_stone1, "grassbrn2rockbrnG")
			engineApplyShaderToWorldTexture(myShader_stone1, "desclifftypebsmix")
			engineApplyShaderToWorldTexture(myShader_stone1, "desclifftypebs")
			engineApplyShaderToWorldTexture(myShader_stone1, "rocktbrn128blnd")
			engineApplyShaderToWorldTexture(myShader_stone2, "redclifftop256")
			engineApplyShaderToWorldTexture(myShader_stone2, "dirtblendlit")
			engineApplyShaderToWorldTexture(myShader_stone2, "sw_rock1a")
				
			--Vasúti sínek
			engineApplyShaderToWorldTexture(myShader_snow, "ws_traingravel")
			engineApplyShaderToWorldTexture(myShader_rail, "ws_traintrax1")
				
			--Hó	
			engineApplyShaderToWorldTexture(myShader_snow, "plaintarmac1")
			engineApplyShaderToWorldTexture(myShader_snow, "trainground3")
			engineApplyShaderToWorldTexture(myShader_snow, "trainground1")
			engineApplyShaderToWorldTexture(myShader_snow, "brick")
			engineApplyShaderToWorldTexture(myShader_snow, "Heliconcrete")
			engineApplyShaderToWorldTexture(myShader_snow, "alleygroundb256")
			engineApplyShaderToWorldTexture(myShader_snow, "grasspatch_64HV")
			engineApplyShaderToWorldTexture(myShader_snow, "dirtKB_64HV")
			engineApplyShaderToWorldTexture(myShader_snow, "pavetilealley256128")
			engineApplyShaderToWorldTexture(myShader_snow, "backalley3_LAe")
			engineApplyShaderToWorldTexture(myShader_snow, "backalley1_LAe")
			engineApplyShaderToWorldTexture(myShader_snow, "comptwall15")
			engineApplyShaderToWorldTexture(myShader_snow, "rufwaldock1")
			engineApplyShaderToWorldTexture(myShader_snow, "yardgrass1")
			engineApplyShaderToWorldTexture(myShader_snow, "yardgrass2")
			engineApplyShaderToWorldTexture(myShader_snow, "sidewgrass4")
			engineApplyShaderToWorldTexture(myShader_snow, "sidewgrass_fuked")
			engineApplyShaderToWorldTexture(myShader_snow, "tarmcplaing_bank")
			engineApplyShaderToWorldTexture(myShader_snow, "cos_hiwayout_256")
			engineApplyShaderToWorldTexture(myShader_snow, "pavemiddirt_law")
			engineApplyShaderToWorldTexture(myShader_snow, "golf_heavygrass")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdry_128HV")
			engineApplyShaderToWorldTexture(myShader_snow, "sjmscorclawn")
			engineApplyShaderToWorldTexture(myShader_snow, "newgrnd1brn_128")
			engineApplyShaderToWorldTexture(myShader_snow, "ws_rooftarmac1")
			engineApplyShaderToWorldTexture(myShader_snow, "brickred")
			engineApplyShaderToWorldTexture(myShader_snow, "brickred2")
			engineApplyShaderToWorldTexture(myShader_snow, "indund_64")
			engineApplyShaderToWorldTexture(myShader_snow, "tarmacplain_bank")
			engineApplyShaderToWorldTexture(myShader_snow, "concretemanky")
			--engineApplyShaderToWorldTexture(myShader_snow, "dirt64b2")
			engineApplyShaderToWorldTexture(myShader_snow, "dirtgaz64b")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdirtblend")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype7")
			engineApplyShaderToWorldTexture(myShader_snow, "alley256")
			engineApplyShaderToWorldTexture(myShader_snow, "Grass")
			engineApplyShaderToWorldTexture(myShader_snow, "boardwalk_la")
			engineApplyShaderToWorldTexture(myShader_snow, "LAroad_centre1")
			engineApplyShaderToWorldTexture(myShader_snow, "concretedust2_256128")
			engineApplyShaderToWorldTexture(myShader_snow, "GB_nastybar08")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_sand")
			engineApplyShaderToWorldTexture(myShader_snow, "luxorwall02_128sandblend")
			engineApplyShaderToWorldTexture(myShader_snow, "Bow_Abattoir_Conc2")
			engineApplyShaderToWorldTexture(myShader_snow, "greyground256sand")
			engineApplyShaderToWorldTexture(myShader_snow, "sjmcargr")
			engineApplyShaderToWorldTexture(myShader_snow, "GB_nastybar07")
			engineApplyShaderToWorldTexture(myShader_snow, "Bow_Abpave_Gen")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdeep2")
			engineApplyShaderToWorldTexture(myShader_snow, "concretenewb256")
			engineApplyShaderToWorldTexture(myShader_snow, "backstagefloor1_256")
			engineApplyShaderToWorldTexture(myShader_snow, "snpdwargrn1")
			engineApplyShaderToWorldTexture(myShader_snow, "smjlahus28")
			engineApplyShaderToWorldTexture(myShader_snow, "lasjmslumwall")
			engineApplyShaderToWorldTexture(myShader_snow, "sjmlahus28")
			engineApplyShaderToWorldTexture(myShader_snow, "greyground256128")
			engineApplyShaderToWorldTexture(myShader_snow, "ws_carparknew2a")
			engineApplyShaderToWorldTexture(myShader_snow, "sjmndukwal3")
			engineApplyShaderToWorldTexture(myShader_snow, "sandnew_law")
			engineApplyShaderToWorldTexture(myShader_snow, "sandstonemixb")
			engineApplyShaderToWorldTexture(myShader_snow, "Grass_128HV")
			engineApplyShaderToWorldTexture(myShader_snow, "greyground256")
			engineApplyShaderToWorldTexture(myShader_snow, "bathtile01_int")
			--engineApplyShaderToWorldTexture(myShader_snow, "ws_carpark2")
			--engineApplyShaderToWorldTexture(myShader_snow, "ws_carpark1")
			engineApplyShaderToWorldTexture(myShader_snow, "stones256128")
			engineApplyShaderToWorldTexture(myShader_snow, "grifnewtex1x_LAS")
			engineApplyShaderToWorldTexture(myShader_snow, "sjmscorclawn3")
			engineApplyShaderToWorldTexture(myShader_snow, "Grass_dirt_64HV")
			engineApplyShaderToWorldTexture(myShader_snow, "carlot1")
			engineApplyShaderToWorldTexture(myShader_snow, "crazypave")
			engineApplyShaderToWorldTexture(myShader_snow, "concretenewgery256")
			engineApplyShaderToWorldTexture(myShader_snow, "concretebigc256128")
			engineApplyShaderToWorldTexture(myShader_snow, "trainground2")
			--engineApplyShaderToWorldTexture(myShader_snow, "concretebig4256128")
			engineApplyShaderToWorldTexture(myShader_snow, "stormdrain7")
			engineApplyShaderToWorldTexture(myShader_snow, "sl_sfngrssdrt01")
			engineApplyShaderToWorldTexture(myShader_snow, "sl_sfngrass01")
			engineApplyShaderToWorldTexture(myShader_snow, "dirty256")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdeep1")
			engineApplyShaderToWorldTexture(myShader_snow, "man_cellarfloor128")
			engineApplyShaderToWorldTexture(myShader_snow, "ws_carparknew2")
			engineApplyShaderToWorldTexture(myShader_snow, "ws_carparknew1")
			engineApplyShaderToWorldTexture(myShader_snow, "redbrickground256")
			engineApplyShaderToWorldTexture(myShader_snow, "sjmhoodlawn9s")
			engineApplyShaderToWorldTexture(myShader_snow, "conc_slabgrey_256128")
			engineApplyShaderToWorldTexture(myShader_snow, "mudyforest256")
			engineApplyShaderToWorldTexture(myShader_snow, "grasslong256")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdead1")
			engineApplyShaderToWorldTexture(myShader_snow, "concretebig4256")
			engineApplyShaderToWorldTexture(myShader_snow, "sl_plazatile01")
			engineApplyShaderToWorldTexture(myShader_snow, "desmuddesgrsblend_sw")
			engineApplyShaderToWorldTexture(myShader_snow, "desertgravelgrass256")
			engineApplyShaderToWorldTexture(myShader_snow, "degreengrass")
			engineApplyShaderToWorldTexture(myShader_snow, "desmud")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdeadbrn256")
			engineApplyShaderToWorldTexture(myShader_snow, "brngrss2stones")
			engineApplyShaderToWorldTexture(myShader_snow, "desgrassbrn")
			engineApplyShaderToWorldTexture(myShader_snow, "desgreengrass")
			engineApplyShaderToWorldTexture(myShader_snow, "grasspave256")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype4-3")
			engineApplyShaderToWorldTexture(myShader_snow, "Grass_dry_64HV")
			engineApplyShaderToWorldTexture(myShader_snow, "forestfloorbranch256")
			engineApplyShaderToWorldTexture(myShader_snow, "desgreengrassmix")
			engineApplyShaderToWorldTexture(myShader_snow, "desertgryard256")
			engineApplyShaderToWorldTexture(myShader_snow, "desertgravelgrassroad")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_sandgrass")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_grass01")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_grass01a")
			engineApplyShaderToWorldTexture(myShader_snow, "desertgryard256grs2")
			engineApplyShaderToWorldTexture(myShader_snow, "grassgrnbrn256")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_crops")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_grassB01")
			engineApplyShaderToWorldTexture(myShader_snow, "Bow_church_dirt_to_grass_side_t")
			engineApplyShaderToWorldTexture(myShader_snow, "Bow_church_grass_gen")
			engineApplyShaderToWorldTexture(myShader_snow, "sl_plazatile02")
			engineApplyShaderToWorldTexture(myShader_snow, "greytile_LA")
			engineApplyShaderToWorldTexture(myShader_snow, "Bow_church_grass_alt")
			engineApplyShaderToWorldTexture(myShader_snow, "ws_hextile")
			engineApplyShaderToWorldTexture(myShader_snow, "sl_LAbedingsoil")
			engineApplyShaderToWorldTexture(myShader_snow, "sl_flagstone1")
			engineApplyShaderToWorldTexture(myShader_snow, "badmarb1_LAn")
			engineApplyShaderToWorldTexture(myShader_snow, "mono2_sfe")
			engineApplyShaderToWorldTexture(myShader_snow, "mono1_sfe")
			engineApplyShaderToWorldTexture(myShader_snow, "grassgrn256")
			engineApplyShaderToWorldTexture(myShader_snow, "fancy_slab128")
			engineApplyShaderToWorldTexture(myShader_snow, "law_gazwhitefloor")
			engineApplyShaderToWorldTexture(myShader_snow, "backstageceiling1_128")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype10")
			engineApplyShaderToWorldTexture(myShader_snow, "rooftiles2")
			engineApplyShaderToWorldTexture(myShader_snow, "boardwalk2_la")
			engineApplyShaderToWorldTexture(myShader_snow, "pierplanks_128")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype3")
			engineApplyShaderToWorldTexture(myShader_snow, "redcliffroof_LA")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdeep256")
			engineApplyShaderToWorldTexture(myShader_snow, "tenniscourt1_256")
			engineApplyShaderToWorldTexture(myShader_snow, "Grass_lawn_128HV")
			engineApplyShaderToWorldTexture(myShader_snow, "forestfloor256")
			engineApplyShaderToWorldTexture(myShader_snow, "forestfloorgrass")
			engineApplyShaderToWorldTexture(myShader_snow, "grassdead1blnd")
			engineApplyShaderToWorldTexture(myShader_snow, "desegravelgrassroadLA")
			engineApplyShaderToWorldTexture(myShader_snow, "vegaspavement2_256")
			engineApplyShaderToWorldTexture(myShader_snow, "desgreengrasstrckend")
			engineApplyShaderToWorldTexture(myShader_snow, "cw2_mountdirt2grass")
			engineApplyShaderToWorldTexture(myShader_snow, "des_dirt2grass")
			engineApplyShaderToWorldTexture(myShader_snow, "des_dirt2track")
			engineApplyShaderToWorldTexture(myShader_snow, "des_dirt2")
			engineApplyShaderToWorldTexture(myShader_snow, "cw2_mountdirt")
			engineApplyShaderToWorldTexture(myShader_snow, "des_dirt2 trackl")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_copgrass01")
			engineApplyShaderToWorldTexture(myShader_snow, "des_dirt1Grass")
			engineApplyShaderToWorldTexture(myShader_snow, "des_dirt1")
			engineApplyShaderToWorldTexture(myShader_snow, "desgrassbrn_grn")
			engineApplyShaderToWorldTexture(myShader_snow, "grasstype4")
			engineApplyShaderToWorldTexture(myShader_snow, "sw_dirt01")

			-- bayside fix 
			engineApplyShaderToWorldTexture(myShader_snow, "sfn_grass1")
			engineApplyShaderToWorldTexture(myShader_snow, "sfn_rocktbrn128")
			engineApplyShaderToWorldTexture(myShader_snow, "sfn_rockhole")
			engineApplyShaderToWorldTexture(myShader_snow, "sfncn_rockgrass4")
			engineApplyShaderToWorldTexture(myShader_snow, "sfn_sfn.rocktbrn128")
			engineApplyShaderToWorldTexture(myShader_snow, "sfncn_rockgrass3")
			engineApplyShaderToWorldTexture(myShader_snow, "oldflowerbed")
			engineApplyShaderToWorldTexture(myShader_snow, "sl_sfndirt01")
			engineApplyShaderToWorldTexture(myShader_jarda2, "sf_junction2")
			engineApplyShaderToWorldTexture(myShader_jarda2, "sf_junction1")

			-- ls fix
			engineApplyShaderToWorldTexture(myShader_jarda, "sl_pavebutt2")
			engineApplyShaderToWorldTexture(myShader, "sl_roadbutt1")
			--outputChatBox("asd")

			engineRemoveShaderFromWorldTexture(myShader, "target*")
			--engineRemoveShaderFromWorldTexture( element shader, string textureName [, element targetElement = nil ] )

		end
	end

end
addEventHandler("onClientResourceStart", resourceRoot, startSnowShader)

local snowGroundRemoveList = {
	"", "vehicle*", "?emap*", "?hite*", "*92*", "*wheel*", "*interior*", "*handle*", "*body*", "*decal*", "*8bit*",
	"*logos*", "*badge*", "*plate*", "*sign*", "headlight", "headlight1", "shad*", "coronastar", "tx*", "lod*",
	"cj_w_grad", "*cloud*", "*smoke*", "sphere_cj", "particle*", "*water*", "sw_sand", "coral", "unnamed", "chromelip", "chromelip2",
	"tirelowr1", "*window*", "target3"
}

local snowTreesList = {
	"sm_des_bush*", "*tree*", "*ivy*", "*pine*", "veg_*", "*largefur*", "hazelbr*", "weeelm",
	"*branch*", "cypress*", "*bark*", "gen_log", "trunk5", "bchamae", "vegaspalm01_128", "iron",
	"hedgealphad1", "ahoodfence2", "oakleaf1", "oakleaf2", "cedar1", "cedar2", "bthuja1", "berrybush1",
	"stormdrain1_nt", "stormdrain2_nt", "stormdrain_lod", "lasrmd2_sjm", "lasrmd3_sjm", "dead_agave",
	"kbplanter_plants1", "dead_fuzzy", "sm_quarry_conv_belt", "sm_quarry_crusher1", "sm_quarry_crusher2",
	"hedge2", "hedge2lod", "aamanbev96x", "aamanbev96xlod", "hedge", "hedge3", "hedge3_blur", "dirt64b2", "dryhedge_128", "hedge1"
}

local snowNaughtyTreesList = {
	"planta256", "plantb256", "sm_josh_leaf", "kbtree4_test", "trunk3", "newtreeleaves128", "ashbrnch", "pinelo128", "tree19mi",
	"lod_largefurs07", "veg_largefurs05","veg_largefurs06", "fuzzyplant256", "foliage256", "cypress1", "cypress2",
	"sm_agave_1", "sm_agave_2", "sm_agave_bloom", "sm_des_bush1", "sm_minipalm1", "kbtree3_test",
}

function applySnowGround()
	snowGroundShader = dxCreateShader("fx/ground.fx", 0, 250)
	snowTreesShader = dxCreateShader("fx/snow_trees.fx")
	snowNaughtyTreesShader = dxCreateShader("fx/snow_naughty_trees.fx")
	noiseTexture = dxCreateTexture("fx/smallnoise3d.dds")
	
	if not snowGroundShader or not snowTreesShader or not snowNaughtyTreesShader or not noiseTexture then
		return nil
	end
	
	dxSetShaderValue(snowTreesShader, "noiseTexture", noiseTexture)
	dxSetShaderValue(snowNaughtyTreesShader, "noiseTexture", noiseTexture)
	--dxSetShaderValue(snowGroundShader, "noiseTexture", noiseTexture)
	--dxSetShaderValue(snowGroundShader, "snowFadeEnd", 250)
	--dxSetShaderValue(snowGroundShader, "snowFadeStart", 250 / 2)
	
	engineApplyShaderToWorldTexture(snowGroundShader, "*")

	for _, removeMatch in ipairs(snowGroundRemoveList) do
		engineRemoveShaderFromWorldTexture(snowGroundShader, removeMatch)

	end

	for _, applyMatch in ipairs(snowTreesList) do
		engineApplyShaderToWorldTexture(snowTreesShader, applyMatch)
	end

	for _, applyMatch in ipairs(snowNaughtyTreesList) do
		engineApplyShaderToWorldTexture(snowNaughtyTreesShader, applyMatch)
	end

end