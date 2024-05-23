addEventHandler("onClientResourceStart", root, function(res)
	if getResourceName(res) == "oCore" or getResourceName(res) == "oCarLicences" or getResourceName(res) == "oPreview" or getResourceName(res) == "oInventory" or getResourceName(res) == "oInterface" or getResourceName(res) == "oFont" then  
		serverColor, sR, sG, sB = exports.oCore:getServerColor()
		core = exports.oCore
		font = exports.oFont:getFont("condensed", 18);
		font1 = exports.oFont:getFont("condensed", 13);
		--exports.oInterface:toggleHud(false);
		is = exports.oInventory:hasItem(66, 1);
	end
end)

local sX, sY = guiGetScreenSize();
local pX, pY = 1920, 1080;

local autosiskolaped = createPed(80, 1315.4069824219, -898.2744140625, 39.578125, 180 , 0, 0);
setElementFrozen(autosiskolaped, true);
setElementData(autosiskolaped, "ped:name", "Huana Rodríguez");
setElementData(autosiskolaped, "ped:prefix", "Oktató");

local licenceped = createPed(122, 1434.9337158203, -1817.6734619141, 14.5703125, 359, 0, 0);
setElementFrozen(licenceped, true);
setElementData(licenceped, "ped:name", "Jax Finn");
setElementData(licenceped, "ped:prefix", "Jogosítvány átvétel");

local serverColor, sR, sG, sB = exports.oCore:getServerColor()
local iskolaTimer;
local showing = 0;
local core = exports.oCore;
local text = "Üdvözöllek az autósiskolában! Az én nevem Huana Rodríguez.";
local font = exports.oFont:getFont("condensed", 18);
local font1 = exports.oFont:getFont("condensed", 13);
local osszeg = 1000;
local index;
local pont = 0;
local theMarker;
local number;

local road1 = {
	[1] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1359.8999023438, -951.34313964844, 33.1875},
		[3] = {1343.6650390625, -1123.1329345703, 22.690504074097},
		[4] = {1312.8310546875, -1140.1573486328, 20.65625};
		[5] = {1183.6988525391, -1140.3038330078, 20.690244674683},
		[6] = {1069.931640625, -1140.4577636719, 20},
		[7] = {1055.2863769531, -1165.8770751953, 20},
		[8] = {1055.7575683594, -1267.2281494141, 12},
		[9] = {1055.0914306641, -1381.8870849609, 12},
		[10] = {1088.7639160156, -1408.8116455078, 12},
		[11] = {1328.1256103516, -1408.55859375, 12},
		[12] = {1355.8046875, -1383.619140625, 13.521018028259},
		[13] = {1354.8570556641, -1294.6945800781, 12},
		[14] = {1354.9542236328, -1204.5863037109, 16},
		[15] = {1356.5803222656, -1112.2412109375, 22},
		[16] = {1366.3389892578, -1054.7985839844, 25},
		[17] = {1374.5399169922, -958.81927490234, 33},
		[18] = {1322.2857666016, -921.28546142578, 36},
	},
	[2] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1384.3061523438, -923.84973144531, 34.161808013916},
		[3] = {1501.9542236328, -875.44787597656, 60.895580291748},
		[4] = {1460.8608398438, -750.22937011719, 94.960891723633};
		[5] = {1235.5120849609, -733.96075439453, 95.715591430664},
		[6] = {986.25634765625, -801.8271484375, 99.03727722168},
		[7] = {844.41802978516, -866.61785888672, 70.963973999023},
		[8] = {721.65557861328, -976.93737792969, 53.091148376465},
		[9] = {615.58331298828, -1110.5874023438, 46.873992919922},
		[10] = {464.85879516602, -1219.5770263672, 47.988349914551},
		[11] = {394.33096313477, -1221.2705078125, 52.011741638184},
		[12] = {498.06939697266, -1261.4298095703, 15.896375656128},
		[13] = {537.54772949219, -1254.3972167969, 16.482187271118},
		[14] = {670.14862060547, -1186.9586181641, 16.445676803589},
		[15] = {747.94030761719, -1064.5949707031, 23.444610595703},
		[16] = {840.31396484375, -1032.9052734375, 25.596263885498},
		[17] = {994.42279052734, -966.76837158203, 40.672389984131},
		[18] = {1187.6960449219, -947.5712890625, 42.681915283203},
		[19] = {1322.2857666016, -921.28546142578, 36},
	},
	[3] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1349.0671386719, -939.69305419922, 34.65795135498},
		[3] = {1466.3583984375, -956.6181640625, 36.1328125},
		[4] = {1661.1407470703, -979.97985839844, 37.945442199707},
		[5] = {1854.3419189453, -1015.9268798828, 36.1328125};
		[6] = {2032.2445068359, -1033.8596191406, 35.528846740723},
		[7] = {2182.5361328125, -1110.6276855469, 24.853134155273},
		[8] = {2259.8869628906, -1147.1888427734, 26.800489425659},
		[9] = {2268.068359375, -1204.5189208984, 24.151586532593},
		[10] = {2235.1459960938, -1218.51953125, 23.815523147583},
		[11] = {2085.552734375, -1218.4757080078, 23.8046875},
		[12] = {2066.0808105469, -1247.1647949219, 23.817977905273},
		[13] = {2008.1750488281, -1258.6892089844, 23.8203125},
		[14] = {1909.7316894531, -1258.5081787109, 13.774201393127},
		[15] = {1829.3309326172, -1257.8526611328, 13.46875},
		[16] = {1727.6644287109, -1297.5046386719, 13.407717704773},
		[17] = {1623.1301269531, -1297.0368652344, 17.092088699341},
		[18] = {1467.4742431641, -1297.2081298828, 13.420311927795},
		[19] = {1457.5111083984, -1255.0574951172, 13.390607833862},
		[20] = {1369.8680419922, -1238.353515625, 13.3828125},
		[21] = {1360.3063964844, -1164.6405029297, 23.746591567993},
		[22] = {1370.6550292969, -1055.6850585938, 26.612159729004},
		[23] = {1379.8713378906, -958.15887451172, 34.123031616211},
		[24] = {1322.2857666016, -921.28546142578, 36},
	},
	[4] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1349.0671386719, -939.69305419922, 34.65795135498},
		[3] = {1360.4814453125, -954.69891357422, 34.154621124268},
		[4] = {1350.4450683594, -1056.0838623047, 26.637506484985},
		[5] = {1340.1990966797, -1164.0251464844, 23.747058868408};
		[6] = {1340.4975585938, -1291.7861328125, 13.547131538391},
		[7] = {1339.9680175781, -1421.7380371094, 13.3828125},
		[8] = {1295.4548339844, -1561.0173339844, 13.390605926514},
		[9] = {1295.3441162109, -1701.7386474609, 13.3828125},
		[10] = {1295.0776367188, -1842.1149902344, 13.3828125},
		[11] = {1193.7130126953, -1850.0241699219, 13.398164749146},
		[12] = {1073.5634765625, -1849.9873046875, 13.391500473022},
		[13] = {1021.7821655273, -1794.6463623047, 13.753044128418},
		[14] = {930.25860595703, -1771.6759033203, 13.457194328308},
		[15] = {822.34539794922, -1766.8747558594, 13.400257110596},
		[16] = {739.82489013672, -1758.7780761719, 13.445707321167},
		[17] = {609.80139160156, -1724.3093261719, 13.863800048828},
		[18] = {428.78247070313, -1700.1428222656, 9.8776512145996},
		[19] = {276.29934692383, -1683.6604003906, 7.9712910652161},
		[20] = {164.95330810547, -1569.8358154297, 12.252655029297},
		[21] = {199.2311706543, -1500.1292724609, 12.70192527771},
		[22] = {279.32318115234, -1423.1577148438, 13.719581604004},
		[23] = {392.90161132813, -1364.5338134766, 14.624900817871},
		[24] = {496.65957641602, -1292.8004150391, 15.628150939941},
		[25] = {656.18145751953, -1203.9626464844, 18.10984992981},
		[26] = {717.548828125, -1115.2568359375, 18.36720085144},
		[27] = {810.45013427734, -1055.5013427734, 24.845523834229},
		[28] = {871.52801513672, -1007.1984863281, 33.833755493164},
		[29] = {983.59259033203, -972.6494140625, 39.632095336914},
		[30] = {1111.4406738281, -958.73944091797, 42.551902770996},
		[31] = {1186.2640380859, -952.02038574219, 42.663078308105},
		[32] = {1277.9727783203, -936.18341064453, 41.941181182861},
		[33] = {1322.2857666016, -921.28546142578, 36},
	},
	[5] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1297.6536865234, -919.95172119141, 39.823577880859},
		[3] = {1145.4698486328, -941.81750488281, 42.767726898193},
		[4] = {1035.6147460938, -951.99652099609, 42.510810852051};
		[5] = {946.05139160156, -962.81756591797, 38.820487976074},
		[6] = {845.65374755859, -1013.1893310547, 28.606555938721},
		[7] = {780.58184814453, -1042.1859130859, 24.330472946167},
		[8] = {685.90277099609, -1143.8063964844, 15.687732696533},
		[9] = {600.80114746094, -1211.9324951172, 18.049501419067},
		[10] = {489.23336791992, -1279.1721191406, 15.552842140198},
		[11] = {384.95742797852, -1351.6635742188, 14.54248714447},
		[12] = {338.30010986328, -1340.8489990234, 14.5078125},
		[13] = {363.98764038086, -1381.2478027344, 14.409571647644},
		[14] = {495.759765625, -1293.5037841797, 15.615175247192},
		[15] = {651.51013183594, -1207.2044677734, 18.162300109863},
		[16] = {740.51867675781, -1078.4808349609, 22.348068237305},
		[17] = {832.45495605469, -1046.2562255859, 25.096208572388},
		[18] = {893.6806640625, -993.12115478516, 36.816528320313},
		[19] = {989.94201660156, -972.390625, 40.179504394531},
		[20] = {1105.5310058594, -959.10687255859, 42.389423370361},
		[21] = {1189.6434326172, -951.45288085938, 42.672157287598},
		[22] = {1276.5222167969, -936.49951171875, 41.986862182617},
		[23] = {1322.2857666016, -921.28546142578, 36},
	},
	[6] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1293.6027832031, -919.89208984375, 40.293434143066},
		[3] = {1258.7911376953, -951.02899169922, 41.61962890625},
		[4] = {1260.7019042969, -1028.396484375, 32.12427520752};
		[5] = {1260.3961181641, -1128.7056884766, 23.771039962769},
		[6] = {1330.5111083984, -1150.4770507813, 23.648445129395},
		[7] = {1369.7020263672, -1144.0694580078, 23.65625},
		[8] = {1469.5091552734, -1163.0838623047, 23.828907012939},
		[9] = {1592.7727050781, -1163.5933837891, 23.90625},
		[10] = {1639.8448486328, -1148.0974121094, 23.90625},
		[11] = {1668.0268554688, -1123.2232666016, 23.90625},
		[12] = {1681.0823974609, -1077.6336669922, 23.8984375},
		[13] = {1705.4639892578, -1085.4138183594, 23.90625},
		[14] = {1678.8138427734, -1075.8376464844, 23.8984375},
		[15] = {1637.1693115234, -1068.939453125, 23.8984375},
		[16] = {1634.7100830078, -1148.2230224609, 23.90625},
		[17] = {1565.7067871094, -1158.2814941406, 23.90625},
		[18] = {1460.1942138672, -1157.9681396484, 23.672286987305},
		[19] = {1369.4332275391, -1138.2644042969, 23.65625},
		[20] = {1371.4671630859, -1055.8176269531, 26.615154266357},
		[21] = {1380.0500488281, -959.01763916016, 34.102687835693},
		[22] = {1322.2857666016, -921.28546142578, 36},
	},
	[7] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1350.3919677734, -944.26123046875, 34.502178192139},
		[3] = {1394.0314941406, -949.81475830078, 34.529499053955},
		[4] = {1495.0733642578, -986.07489013672, 37.739326477051};
		[5] = {1581.8692626953, -1083.5288085938, 56.582023620605},
		[6] = {1612.3233642578, -1189.4406738281, 54.056762695313},
		[7] = {1603.4481201172, -1300.5968017578, 37.956897735596},
		[8] = {1590.6102294922, -1382.5, 28.57834815979},
		[9] = {1556.732421875, -1474.9063720703, 25.806356430054},
		[10] = {1659.6203613281, -1546.3288574219, 24.056228637695},
		[11] = {1758.8658447266, -1522.9721679688, 13.283677101135},
		[12] = {1859.3035888672, -1520.4206542969, 3.4170536994934},
		[13] = {1959.6234130859, -1518.7478027344, 3.3557720184326},
		[14] = {2023.6822509766, -1539.6931152344, 4.0987958908081},
		[15] = {2038.1593017578, -1600.5266113281, 13.328330993652},
		[16] = {1999.3010253906, -1624.419921875, 13.3828125},
		[17] = {1999.1159667969, -1740.2852783203, 13.3828125},
		[18] = {1955.3072509766, -1749.5811767578, 13.381875038147},
		[19] = {1833.5537109375, -1749.7186279297, 13.381875038147},
		[20] = {1824.1682128906, -1696.1159667969, 13.3828125},
		[21] = {1824.3996582031, -1598.5717773438, 13.35897731781},
		[22] = {1852.9864501953, -1479.7077636719, 13.387564659119},
		[23] = {1853.1422119141, -1353.7694091797, 13.389897346497},	
		[24] = {1853.5318603516, -1245.7307128906, 14.049966812134},
		[25] = {1822.9125976563, -1178.2602539063, 23.627477645874},
		[26] = {1728.0349121094, -1158.2395019531, 23.642120361328},
		[27] = {1648.1068115234, -1158.3421630859, 23.89035987854},
		[28] = {1590.0288085938, -1158.5228271484, 23.90625},
		[29] = {1563.8731689453, -1072.8944091797, 23.548425674438},
		[30] = {1494.3977050781, -1031.7508544922, 23.638814926147},
		[31] = {1379.8218994141, -1033.3305664063, 26.342800140381},
		[32] = {1379.9393310547, -957.96160888672, 34.127708435059},
		[33] = {1322.2857666016, -921.28546142578, 36},
	},
	[8] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1294.1130371094, -920.15570068359, 40.242176055908},
		[3] = {1171.3037109375, -938.9375, 42.832736968994},
		[4] = {1157.8959960938, -877.47894287109, 43.967559814453};
		[5] = {1161.8929443359, -752.986328125, 59.825233459473},
		[6] = {1197.9357910156, -651.04547119141, 59.948173522949},
		[7] = {1247.0718994141, -516.15954589844, 29.581336975098},
		[8] = {1263.0935058594, -429.87353515625, 3.9446983337402},
		[9] = {1216.583984375, -417.38861083984, 6.5857582092285},
		[10] = {1142.0306396484, -426.45629882813, 30.685943603516},
		[11] = {1044.3293457031, -446.97436523438, 51.533752441406},
		[12] = {967.736328125, -492.86450195313, 46.560943603516},
		[13] = {843.73187255859, -563.68243408203, 16.423582077026},
		[14] = {820.74884033203, -527.35113525391, 16.1875},
		[15] = {790.35382080078, -526.6923828125, 16.1875},
		[16] = {789.41864013672, -587.47106933594, 16.1875},
		[17] = {834.91235351563, -584.14343261719, 16.1875},
		[18] = {851.19995117188, -568.22650146484, 16.896831512451},
		[19] = {915.76232910156, -542.93841552734, 28.612113952637},
		[20] = {981.08911132813, -489.74664306641, 47.858364105225},
		[21] = {1099.1130371094, -438.96166992188, 43.876781463623},
		[22] = {1249.5386962891, -419.08016967773, 2.586067199707},
		[23] = {1250.6379394531, -474.97424316406, 17.06929397583},	
		[24] = {1213.3913574219, -600.671875, 52.230686187744},
		[25] = {1171.8865966797, -694.86370849609, 62.193698883057},
		[26] = {1152.9064941406, -791.18292236328, 56.049427032471},
		[27] = {1156.3542480469, -931.42059326172, 43.0299949646},
		[28] = {1178.3029785156, -953.08825683594, 42.576320648193},
		[29] = {1276.7857666016, -936.16156005859, 41.9733543396},
		[30] = {1322.2857666016, -921.28546142578, 36},
	},	
	[9] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1350.1212158203, -938.74530029297, 34.575374603271},
		[3] = {1421.8469238281, -949.42883300781, 36.14395904541},
		[4] = {1537.35546875, -965.45166015625, 36.88729095459};
		[5] = {1686.4808349609, -983.69738769531, 37.765289306641},
		[6] = {1856.5054931641, -1016.6060791016, 36.1328125},
		[7] = {1950.2366943359, -1028.6107177734, 33.272109985352},
		[8] = {2071.6467285156, -1045.2459716797, 32.783424377441},
		[9] = {2184.5815429688, -1111.2384033203, 24.749269485474},
		[10] = {2221.865234375, -1108.6743164063, 26.231575012207},
		[11] = {2176.8049316406, -1049.0338134766, 55.321208953857},
		[12] = {2165.9934082031, -1017.770690918, 62.662078857422},
		[13] = {2127.7905273438, -992.17492675781, 58.741645812988},
		[14] = {2036.9505615234, -977.19915771484, 41.496837615967},
		[15] = {1983.2902832031, -1040.0155029297, 24.410835266113},
		[16] = {1968.8275146484, -1124.4368896484, 25.800228118896},
		[17] = {1950.6156005859, -1133.2230224609, 25.578832626343},
		[18] = {1878.6744384766, -1133.1627197266, 23.778675079346},
		[19] = {1857.5939941406, -1178.169921875, 23.643768310547},
		[20] = {1777.1003417969, -1167.033203125, 23.659385681152},
		[21] = {1684.0446777344, -1158.2530517578, 23.65625},
		[22] = {1590.2026367188, -1158.3016357422, 23.90625},
		[23] = {1495.8127441406, -1158.3408203125, 23.914041519165},	
		[24] = {1420.9468994141, -1155.4808349609, 23.664012908936},
		[25] = {1369.1857910156, -1138.3640136719, 23.65625},
		[26] = {1371.1333007813, -1054.9943847656, 26.610355377197},
		[27] = {1379.9324951172, -957.37774658203, 34.141540527344},
		[28] = {1322.2857666016, -921.28546142578, 36},
	},	
	[10] ={
		[1] = {1336.0512695313, -920.05377197266, 35.070732116699},
		[2] = {1351.6545410156, -939.04724121094, 34.440425872803},
		[3] = {1384.6943359375, -918.70446777344, 34.22163772583},
		[4] = {1423.6130371094, -869.97216796875, 49.490783691406};
		[5] = {1517.5513916016, -851.76214599609, 65.237281799316},
		[6] = {1500.4991455078, -772.59979248047, 84.023880004883},
		[7] = {1432.6228027344, -694.38122558594, 87.975433349609},
		[8] = {1317.5822753906, -703.15057373047, 92.571899414063},
		[9] = {1189.1246337891, -754.86901855469, 102.65369415283},
		[10] = {1056.7635498047, -773.37701416016, 106.1752166748},
		[11] = {949.79382324219, -787.06683349609, 107.49663543701},
		[12] = {918.84100341797, -754.02954101563, 102.95853424072},
		[13] = {799.03485107422, -795.39288330078, 66.720542907715},
		[14] = {679.67358398438, -853.25598144531, 70.18367767334},
		[15] = {594.88629150391, -901.66156005859, 63.91674041748},
		[16] = {513.76043701172, -918.94885253906, 74.897773742676},
		[17] = {478.96240234375, -1003.0209350586, 92.090461730957},
		[18] = {328.9440612793, -1024.1920166016, 93.110870361328},
		[19] = {271.10995483398, -1114.5008544922, 79.400039672852},
		[20] = {197.91799926758, -1156.8582763672, 59.903713226318},
		[21] = {137.23175048828, -1246.5788574219, 45.282783508301},
		[22] = {138.35453796387, -1371.1713867188, 50.021133422852},
		[23] = {160.42903137207, -1411.0227050781, 45.041091918945},	
		[24] = {92.671188354492, -1516.3057861328, 5.9945831298828},
		[25] = {129.34991455078, -1558.8505859375, 9.2043724060059},
		[26] = {165.17167663574, -1553.0128173828, 11.650577545166},
		[27] = {208.31576538086, -1486.9609375, 12.858200073242},
		[28] = {269.60006713867, -1428.6334228516, 13.63188457489},
		[29] = {378.67446899414, -1372.7186279297, 14.51730632782},
		[30] = {496.69915771484, -1292.4886474609, 15.629055023193},
		[31] = {579.06787109375, -1237.5953369141, 17.510986328125},
		[32] = {661.24798583984, -1200.5523681641, 18.047698974609},
		[33] = {719.67150878906, -1112.0661621094, 18.66223526001},
		[34] = {764.29827880859, -1060.7310791016, 24.376541137695},
		[35] = {846.26605224609, -1035.1794433594, 25.580104827881},
		[36] = {895.28930664063, -991.75366210938, 37.011058807373},
		[37] = {985.38800048828, -972.57666015625, 39.713439941406},
		[38] = {1068.3612060547, -962.34259033203, 42.590538024902},
		[39] = {1147.7185058594, -956.41461181641, 42.618595123291},
		[40] = {1223.58984375, -945.26300048828, 42.596294403076},
		[41] = {1277.3541259766, -935.84136962891, 41.95446395874},
		[42] = {1322.2857666016, -921.28546142578, 36},
	},				
};

local sentences = {
	"Kezdő vagy, de nem örökre!",
	"Ne a kanyarban fékezz, hanem a kanyar előtt vegyél vissza a sebességből!",
	"Eső esetén kezdőként mindenképp óvatosan vezess!",
	"Lassan hajts tovább érsz",
	"Mindig érdemes odadigyelni a táblákra!",
	"A zebrák közelében mindig nagyon óvatosan vezess!",
	"Indulás előtt mindig ellenőrizd át alaposan a járművedet!",
	"Vezetés közben soha ne használd a telefonodat!",
	"Vezetés közben igyekezz mindig az útra koncentrálni!",
	"A hangos zene hallgatás hátráltathat vezetés közben!",
	"Ha valami gondod van,akkor mindig kérd ki egy szakértő tanácsát!",
	"Próbálj meg a kijelölt útvonalon maradni!",
	"A kölcsönös bizalom nagyon fontos a vezető társaid és közted!",
	"Minden esetben maradj higgadt állapotban és próbálj meg átgondolt döntéseket hozni!",
	"Vezess óvatosan,mert a szereltetés nem egy olcsó mulatság!",
};

if (getElementData(localPlayer, "van") == true) then	
	setElementFrozen(localPlayer, false);
	setElementAlpha(localPlayer, 255);
	setCameraTarget(localPlayer);
	showChat(true);
	setElementData(localPlayer, "van", false);
	exports.oInterface:toggleHud(false);
end	

function gombok3()
local startX = -400;
	for i = 1, 4 do
		if core:isInSlot(startX+(i*464)/pX*sX, 930/pY*sY, 400/pX*sX, 40/pY*sY) then
			color7 = tocolor(sR, sG, sB, 250);	
		else
			color7 = tocolor(250, 250, 250, 250);
		end			
		dxDrawRectangle((startX+(i*464))/pX*sX, 930/pY*sY, 400/pX*sX, 40/pY*sY, tocolor(46, 46, 46, 250), false);
		dxDrawText(answer[i + 1],(startX+(i*464))/pX*sX, 930/pY*sY, ((startX+(i*464))+388)/pX*sX, 970/pY*sY, color7, 1/pX*sX, font1, "center", "center", false, false, false, true);
	end
end

function gombok2()
	dxDrawRectangle(760/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY, tocolor(46, 46, 46, 250), false);
	dxDrawRectangle(1010/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY, tocolor(46, 46, 46, 250), false);
	dxDrawText("NEM",1010/pX*sX, 930/pY*sY, 1160/pX*sX, 970/pY*sY, color6, 1/pX*sX, font1, "center", "center", false, false, false, true);	
	dxDrawText("IGEN",760/pX*sX, 930/pY*sY, 910/pX*sX, 970/pY*sY, color5, 1/pX*sX, font1, "center", "center", false, false, false, true);
	if core:isInSlot(760/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
		color5 = tocolor(sR, sG, sB, 250);	
	elseif core:isInSlot(1010/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
		color6 = tocolor(245, 66, 66, 250);
	else
		color5 = tocolor(250, 250, 250, 250);
		color6 = tocolor(250, 250, 250, 250);	
	end	
end	

function gombok()
	dxDrawRectangle(600/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY, tocolor(46, 46, 46, 250), false);
	dxDrawRectangle(770/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY, tocolor(46, 46, 46, 250), false);
	dxDrawRectangle(940/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY, tocolor(46, 46, 46, 250), false);
	dxDrawRectangle(1110/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY, tocolor(46, 46, 46, 250), false);
	dxDrawText("MÉGSEM",1110/pX*sX, 930/pY*sY, 1260/pX*sX, 970/pY*sY, color4, 1/pX*sX, font1, "center", "center", false, false, false, true);	
	dxDrawText("KRESZ",600/pX*sX, 930/pY*sY, 750/pX*sX, 970/pY*sY, color1, 1/pX*sX, font1, "center", "center", false, false, false, true);	
	dxDrawText("RUTIN",770/pX*sX, 930/pY*sY, 920/pX*sX, 970/pY*sY, color2, 1/pX*sX, font1, "center", "center", false, false, false, true);	
	dxDrawText("MEGÚJÍTÁS",940/pX*sX, 930/pY*sY, 1090/pX*sX, 970/pY*sY, color3, 1/pX*sX, font1, "center", "center", false, false, false, true);
	if core:isInSlot(600/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
		color1 = tocolor(sR, sG, sB, 250);
		color2 = tocolor(250, 250, 250, 250);
		color3 = tocolor(250, 250, 250, 250);
		color4 = tocolor(250, 250, 250, 250);		
	elseif core:isInSlot(770/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
		color2 = tocolor(sR, sG, sB, 250);
		color1 = tocolor(250, 250, 250, 250);
		color3 = tocolor(250, 250, 250, 250);
		color4 = tocolor(250, 250, 250, 250);		
	elseif core:isInSlot(940/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
		color3 = tocolor(sR, sG, sB, 250);
		color1 = tocolor(250, 250, 250, 250);
		color2 = tocolor(250, 250, 250, 250);
		color4 = tocolor(250, 250, 250, 250);		
	elseif core:isInSlot(1110/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
		color4 = tocolor(245, 66, 66, 250);
		color1 = tocolor(250, 250, 250, 250);
		color2 = tocolor(250, 250, 250, 250);
		color3 = tocolor(250, 250, 250, 250);		
	else
		color1 = tocolor(250, 250, 250, 250);
		color2 = tocolor(250, 250, 250, 250);
		color3 = tocolor(250, 250, 250, 250);
		color4 = tocolor(250, 250, 250, 250);
	end	
end

function rajz()
	dxDrawRectangle(0/pX*sX, 990/pY*sY, 1920/pX*sX, 180/pY*sY, tocolor(46, 46, 46, 250), false);
	dxDrawText(core:getServerPrefix("server", "Huana Rodríguez", 3)..text,0/pX*sX, 990/pY*sY, 1920/pX*sX, 1080/pY*sY, tocolor(250, 250, 250, 250), 1, font, "center", "center", false, false, false, true);	
end	

function kattint(button, state, _, _, _, _, _, clickedElement)
	if (button == "right") and (state == "up") then
		if (clickedElement == autosiskolaped) then
			if (showing == 0) then
			local doing = getElementData(localPlayer, "doing") or false;	
				if not (doing) then
					messze(clickedElement);
					showing = 1;
				end	
			end
		elseif (clickedElement == licenceped) then
		local newlicence = getElementData(localPlayer, "newlicence") or false;
			if (newlicence) then
				triggerServerEvent("givelicence", root, localPlayer);
				outputChatBox(core:getServerPrefix("green-dark", "Jogosítvány", 3).."Sikeresen átvetted a jogosítványodat!", 0, 0, 0, true);	
			else
				outputChatBox(core:getServerPrefix("red-dark", "Jogosítvány", 3).."Nem tudod átvenni a jogosítványodat,mivel nem végeztél még mindennel,vagy már van jogosítványod!", 0, 0, 0, true);			
			end	
		end	
	end	
end
addEventHandler("onClientClick", root, kattint);

function messze(clickedElement)
	local mutat = 0;
	iskolaTimer = setTimer(
		function ()
		local distance = core:getDistance(localPlayer, clickedElement);
			if (distance <= 4) then
			local vehicle = getPedOccupiedVehicle(localPlayer);
				if not(vehicle) then
					if (mutat == 0) then
						addEventHandler("onClientRender", root, rajz);
						exports.oInterface:toggleHud(true);
						setElementFrozen(localPlayer, true);
						message();
						setElementData(localPlayer, "van", true);
						local pC1x, pC1y, pC1z, pC2x, pC2y, pC2z = getCameraMatrix();
						local Ped =  Vector3(getElementPosition(autosiskolaped));
						smoothMoveCamera(pC1x, pC1y, pC1z, pC2x, pC2y, pC2z, Ped.x, Ped.y-3, Ped.z+0.6, Ped.x, Ped.y, Ped.z+0.6, 1000);						
						setPedAnimation(autosiskolaped, "ghands", "gsign2", -1, true, false, false);
						setElementAlpha(localPlayer, 0);
						showChat(false);
						mutat = 1;
					end	
				else
					outputChatBox(core:getServerPrefix("server", "Jogosítvány", 3).."Ha beszélni szeretnél az oktatóval, akkor előtte szállj ki a kocsiból!", 0, 0, 0, true);	
					elmegy();
				end	
			else
				outputChatBox(core:getServerPrefix("server", "Jogosítvány", 3).."Túl messze vagy az oktatótól!", 0, 0, 0, true);
				elmegy();
			end	
		end,
	50,0);
end

function kezeles(button, key)
	if (button == "mouse1") then
		if (key) then
			if core:isInSlot(1110/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
				removeEventHandler("onClientKey", root, kezeles);
				removeEventHandler("onClientRender", root, gombok);				
				setTimer(
					function()
						text = "Rendben van. Remélem, hogy még viszont látjuk egymást, viszlát!";	
							setTimer(
								function()
									elmegy();
								end,
							5000,1);
					end,	
				2000,1);
				elseif core:isInSlot(600/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
				removeEventHandler("onClientKey", root, kezeles);
				removeEventHandler("onClientRender", root, gombok);	
				local basic = getElementData(localPlayer, "basic") or 0;
					if (basic == 0) then
					local kresz = getElementData(localPlayer, "kresz");			
						if not (kresz == 4) then
							setTimer(
								function()
								if (kresz == 1) then
									osszeg = 900;
									text = "Mivel már másodjára vagy itt, ezért csak "..osszeg.."$ lesz a vizsga. Bele szeretnél kezdeni?";
								elseif (kresz == 2) then
									osszeg = 850;
									text = "Mivel már harmadjára vagy itt, ezért csak "..osszeg.."$ lesz a vizsga. Bele szeretnél kezdeni?";
								elseif (kresz == 3) then
									osszeg = 800;
									text = "Mivel már negyedjére vagy itt, ezért csak "..osszeg.."$ lesz a vizsga. Bele szeretnél kezdeni?";
								else
								  	text = "Ahhoz, hogy elkezdd a kreszt be kell fizetned "..osszeg.."$-t. Bele szeretnél kezdeni?";		
								end	
										setTimer(
											function()
												addEventHandler("onClientKey", root, kezeles2);
												addEventHandler("onClientRender", root, gombok2);
											end,
										5000,1);
								end,	
							2000,1);
						else
						text = "Neked már van kresz vizsgád!";	
							setTimer(
								function()
									text = "Más valamiben még segíthetek?";	
									addEventHandler("onClientKey", root, kezeles);
									addEventHandler("onClientRender", root, gombok);	
								end,
							3500,1);
						end
					else	
					text = "Neked már van kresz vizsgád!";	
					setTimer(
						function()
							text = "Más valamiben még segíthetek?";	
							addEventHandler("onClientKey", root, kezeles);
							addEventHandler("onClientRender", root, gombok);	
						end,
					3500,1);						
					end	
			elseif core:isInSlot(770/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
			removeEventHandler("onClientKey", root, kezeles);
			removeEventHandler("onClientRender", root, gombok);
			local basic = getElementData(localPlayer, "basic") or 0;
				if  (basic == 0) then
				local kresz = getElementData(localPlayer, "kresz") or 0;				
					if (kresz == 4) then
					setTimer(
						function()
						text = "Ahhoz, hogy elkezdd a rutin vizsgát be kell fizetned 1000$-t. Bele szeretnél kezdeni?";		
						setTimer(
							function()
								addEventHandler("onClientKey", root, kezeles4);
								addEventHandler("onClientRender", root, gombok2);
							end,
						5000,1);
						end,	
					2000,1);					
					else
					text = "Neked még nincs kresz vizsgád!";	
						setTimer(
							function()
								text = "Más valamiben még segíthetek?";	
								addEventHandler("onClientKey", root, kezeles);
								addEventHandler("onClientRender", root, gombok);	
							end,
						3500,1);						
					end
					else
					text = "Neked már van rutin vizsgád!";	
					setTimer(
						function()
							text = "Más valamiben még segíthetek?";	
							addEventHandler("onClientKey", root, kezeles);
							addEventHandler("onClientRender", root, gombok);	
						end,
					3500,1);										
					end				
			elseif core:isInSlot(940/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then		
			removeEventHandler("onClientKey", root, kezeles);
			removeEventHandler("onClientRender", root, gombok);	
			local islicence = getElementData(localPlayer, "islicence") or false;
				if (islicence == true) then
				local newlicence = getElementData(localPlayer, "newlicence") or false;	
					if not(newlicence) then
						setTimer(
							function()
							text = "Ahhoz, hogy megújítsd a jogosítványod be kell fizetned 100$-t. Bele szeretnél kezdeni?";		
							setTimer(
								function()
									addEventHandler("onClientKey", root, kezeles5);
									addEventHandler("onClientRender", root, gombok2);
								end,
							5000,1);
							end,	
						2000,1);
					else
						text = "Nem rég végezted el a jogosítvány megújítást. Menj és váltsd ki az új jogosítványod!";	
						setTimer(
							function()
								text = "Más valamiben még segíthetek?";	
								addEventHandler("onClientKey", root, kezeles);
								addEventHandler("onClientRender", root, gombok);	
							end,
						3500,1);	
					end						
				else
					text = "Neked még nincs jogosítványod!";	
					setTimer(
						function()
							text = "Más valamiben még segíthetek?";	
							addEventHandler("onClientKey", root, kezeles);
							addEventHandler("onClientRender", root, gombok);	
						end,
					3500,1);					
				end			
			end	
		end	
	end	
end	

function kezeles2(button, key)
	if (button == "mouse1") then
		if (key) then
			if core:isInSlot(760/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
			local pMoney = getElementData(localPlayer, "char:money");
				removeEventHandler("onClientKey", root, kezeles2);
				removeEventHandler("onClientRender", root, gombok2);				
				if (pMoney >= osszeg) then
				triggerServerEvent("kresz", root, localPlayer, osszeg);	
					setTimer(
						function()
							text = "Most akkor fel fogok tenni neked 10 kérdést."	
							setTimer(
								function()
									 questions = {
										{"Mennyi a megengedett alkohol-szint vezetés közben?", "0.07%", "0.00%", "0.20%", "0.09%", 1},
										{"Mennyi a megengedett sebesség lakott területen belül?", "30km/h", "60 km/h", "80 km/h", "45 km/h", 2},
									    {"Mennyi a megengedett sebesség lakott területen kívül?", "100 km/h", "80 km/h", "150 km/h", "50 km/h", 2},
										{"Mennyi a megengedett sebesség autópályán?", "90 km/h", "130 km/h", "180 km/h", "140 km/h", 4},
										{"Mikor kell alkalmaznunk a biztonsági övet?", "Mindig, amikor utazó járműben tartózkodunk", "Ha rendőrt látunk", "Orvos utasítására", "Saját felelősségre nem kötelező", 1},
										{"Egyenrangú kereszteződésnél minden irányban STOP-tábla látható. Ki haladhat először?", "Jobb kéz szabály alapján", "Az utolsó érkező", "Az első érkező", "Aki először elindul", 3},
										--{"Piros lámpánál keresztül haladhat-e, ha jobbra szeretne menni?", "Amennyiben biztosak vagyunk, hogy senki nem jön balról és szemből sem", "Nem, szigorúan tilos", "Igen, mindig", "Csak ha sietek", 1},
										--{"Haladhat-e defektes kerékkel rendelkező járművel?", "Igen, amennyiben biztos vagyok benne, hogy tudom vezetni a járművet", "Igen, ha csak 1 kerék defektes", "Nem, minden esetben tiltott", "Igen, ha egyből szerelőhöz megyek", 3},
										{"Baleset észlelése esetén köteles-e segíteni és további segítséget hívni?", "Ha épp nem sietek, akkor igen", "Igen, minden esetben", "Nem, csak ha kedvem tartja", "Igen, ha egy ismerősöm a sérült", 2},
										{"Áthaladhat-e piros lámpán, ha Ön mögött nem tud haladni egy megkülönböztetőjelzéssel ellátott jármű?", "Igen, minden esetben", "Nem, meg kell várni a zöldet", "Csak ha külön erre felszólítanak", "Igen, megfelelő körültekintéssel", 4},
									    {"Visszafordulhat-e autópályán?", "Nem, semmi esetben", "Igen, ha rossz irányba indultam el", "Igen, ha még épp csak felmentem", "Igen, ha lassan haladok", 1},
										--{"Mekkora a kötelező követési távolság két jármű közt?", "Az első jármű hirtelen fékezése esetén a második is biztonságosan meg tudjon állni", "Akkora, hogy három személygépkocsi is beférjen", "Egy teherautó mérete", "Amekkorát biztonságosnak lát", 1},
										{"Az útnak melyik oldalán kell haladnia?", "Amelyik szimpatikus", "Bal oldalon", "Jobb oldalon", "Úgy, hogy a vonal pont a jármű közepén haladjon át", 3},
										{"Jármű tetején utazhat-e utas?", "Igen, ha ugyanúgy használ biztonságos kötözést", "Igen, saját felelősségre", "Nem, szigorúan tilos", "Ha rendőr nem látja, akkor igen ", 3},
										--{"Milyen célból használhatjuk a hangjelzést lakott területen belül?", "Balesetet követően jelezzük, hogy baleset történt", "Balesetveszély esetén/A baleset megelőzése érdekében", "Előzés céljából", "Ha valaki szabálytalankodott, akkor ezzel fejezem ki nemtetszésemet", 2},
										{"Milyen célból használhatjuk a hangjelzést lakott területen kívül?", "Ha valaki megpróbálna minket megelőzni", "Gyorsulási verseny kezdetekor", "Szórakozási célból", "Balesetveszély esetén/megelőzése érdekében", 4},
										{"Mikor jelezzük irányváltási szándékunkat a közlekedésben?", "Az irányváltás megkezdése előtt", "Az irányváltás megkezdésének pillanatában", "Az irányváltás során", "Az irányváltást követően", 1},
										--{"Mit jelent a bizalmi elv a közlekedésben résztvevők számára?", "Bízik benne, hogy a rendvédelem teszi a dolgát", "Bízik benne, hogy mások is betartják a közlekedési szabályokat", "Bízik benne, hogy a szabályok be vannak tartatva", "Bízik benne, hogy mindenki megkapja a büntetést a szabályszegést követően", 2},
										--{"Kötelező elsősegély dobozt tárolni a járművében?", "Igen, kötelező", "Nem, nem kötelező", "Csak akkor, ha épp van elég hely", "Nem, csak akkor kell, ha biztonságban akarom érezni magam", 1},
										{"Elhaladhat-e megkülönböztető fényjelzését használó álló gépjármű mellett?", "Igen, ha egy rendőr engedélyt ad erre", "Amíg a fényjelzés tart, addig nem szabad", "Igen, ilyenkor fokozott óvatossággal kell haladnunk", "Nem, szigorúan tilos", 3},
										--{"Kinek nem kötelező becsatolt biztonsági övvel utaznia?", "Annak, aki rosszul van", "Annak, akinek erről orvos által kiállított igazolása van", "Annak, aki a hátsó ülésen utazik", "Annak, aki várandós", 2},
										{"El nem zárt magánúton köteles-e a közlekedési szabályokat betartani?", "Csak akkor, ha ezt tábla jelzi", "Nem", "Csak akkor, ha szemből is jöhetnek", "Igen", 4},
										{"Előre be nem látható útkanyarulatban...", "...tilos megállni.", "...csak 5 percig állhatunk meg.", "...csak megállhatunk, tilos várakozni.", "...csak 10 percig állhatunk meg.", 1},
										--{"Ha egy balesetben résztvevő bármely fél rendőri intézkedést szeretne, akkor...", "...ha nincs személyi sérülés, akkor nem kell minden résztvevőnek megvárnia a rendőrt.", "...a balesetben összes résztvevő személynek köteles megvárnia.", "...csak a rendőri intézkedést igénylő személynek kell megvárnia.", "...ha nincs haláleset, akkor nem kell minden résztvevőnek megvárnia a rendőrt.", 2},
									};
									index = math.random(1,(#questions-1));
									text = questions[index][1];
									answer = questions[index];
									table.remove(questions, index);										
									addEventHandler("onClientKey", root, kezeles3);
									addEventHandler("onClientRender", root, gombok3);
								end,
							5000,1);
						end,	
					5000,1);											
				else
				removeEventHandler("onClientKey", root, kezeles2);
				removeEventHandler("onClientRender", root, gombok2);					
					setTimer(
						function()
							text = "Nincs elegendő pénzed, ahogy látom!";	
							setTimer(
								function()
									text = "Más valamiben még segíthetek?";	
									addEventHandler("onClientKey", root, kezeles);
									addEventHandler("onClientRender", root, gombok);
								end,
							5000,1);
						end,	
					2000,1);					
				end	
			elseif core:isInSlot(1010/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
				removeEventHandler("onClientKey", root, kezeles2);
				removeEventHandler("onClientRender", root, gombok2);
			setTimer(
				function()
					text = "Más valamiben még segíthetek?";	
						setTimer(
							function()
								addEventHandler("onClientKey", root, kezeles);
								addEventHandler("onClientRender", root, gombok);
							end,
						5000,1);
				end,	
			2000,1);
			end	
		end	
	end	
end

function kezeles3(button, key)
	if (button == "mouse1") then
 		if (key) then				 			
 			local startX = -400;
 			for a = 1, 4 do
 				 if core:isInSlot(startX+(a*464)/pX*sX, 930/pY*sY, 400/pX*sX, 40/pY*sY)  then
					if  not ((#questions) <= 6) then
						if (a == answer[6]) then
							pont = pont + 1;
						end	
						index = math.random(1,(#questions));
						text = questions[index][1];
						answer = questions[index];
						table.remove(questions, index);
					else
						removeEventHandler("onClientKey", root, kezeles3);
						removeEventHandler("onClientRender", root, gombok3);
						text = "Pillanat, csak összeszámolom az elért pontjaidat.";
						setTimer(
							function()
								if (pont >= 7) then
									text = "Gratulálok! Sikeresen letetted a kresz vizsgát, mostmár neki is állhatsz a rutin pályának is."
									triggerServerEvent("success", root, localPlayer);
								else
									text = "Sajnálom, de nem sikerült letenned a kresz vizsgát."
									triggerServerEvent("failure", root, localPlayer);	
								end
								setTimer(
									function()
										pont = 0;
										text = "Más valamiben még segíthetek?";
										addEventHandler("onClientKey", root, kezeles);
										addEventHandler("onClientRender", root, gombok);
									end,
								3500,1);	
							end,
						5000,1);							
					end	
 				 end	
 			end	 
 		end		
	end	
end

function kezeles4(button, key)
	if (button == "mouse1") then
		if (key) then
			if core:isInSlot(760/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
			local pMoney = getElementData(localPlayer, "char:money");
			removeEventHandler("onClientKey", root, kezeles4);
			removeEventHandler("onClientRender", root, gombok2);
			osszeg = 1000;				
				if (pMoney >= osszeg) then
				triggerServerEvent("ocarlicences:pay", root, localPlayer, osszeg);	
					setTimer(
						function()
							text = "Most akkor, majd végig kell vezetned egy kijelölt útvonalon."	
							setTimer(
								function()
									triggerServerEvent("drivetest", root, localPlayer);
									elmegy();
									number = 1;
									line = math.random(1, #road1);
									theMarker = createMarker(road1[line][number][1], road1[line][number][2], road1[line][number][3], "checkpoint", 4.0,  sR, sG, sB, 170);
									theBlip = createBlip ( road1[line][number][1], road1[line][number][2], road1[line][number][3], 3, 1,sR, sG, sB, 170, 255);
									addEventHandler("onClientMarkerHit", root, road);
									speakTimer = setTimer(
										function ()
											numeric = math.random(1, #sentences);
											outputChatBox(core:getServerPrefix("server", "Huana Alex", 3)..sentences[numeric], 0, 0, 0, true);	
										end
									,60000,0);
								end,
							5000,1);
						end,	
					5000,1);											
				else
				removeEventHandler("onClientKey", root, kezeles4);
				removeEventHandler("onClientRender", root, gombok2);	
					setTimer(
						function()
							text = "Nincs elegendő pénzed, ahogy látom!";	
							setTimer(
								function()
									text = "Más valamiben még segíthetek?";	
									addEventHandler("onClientKey", root, kezeles);
									addEventHandler("onClientRender", root, gombok);
								end,
							5000,1);
						end,	
					2000,1);					
				end	
			elseif core:isInSlot(1010/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
				removeEventHandler("onClientKey", root, kezeles4);
				removeEventHandler("onClientRender", root, gombok2);
			setTimer(
				function()
					text = "Más valamiben még segíthetek?";	
						setTimer(
							function()
								addEventHandler("onClientKey", root, kezeles);
								addEventHandler("onClientRender", root, gombok);
							end,
						5000,1);
				end,	
			2000,1);
			end	
		end	
	end	
end

function kezeles5(button, key)
	if (button == "mouse1") then
		if (key) then
			if core:isInSlot(760/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
			local pMoney = getElementData(localPlayer, "char:money");
			removeEventHandler("onClientKey", root, kezeles5);
			removeEventHandler("onClientRender", root, gombok2);
			osszeg = 100				
				if (pMoney >= osszeg) then
				triggerServerEvent("ocarlicences:pay", root, localPlayer, osszeg);	
					setTimer(
						function()
							text = "Most akkor, majd végig kell vezetned egy kijelölt útvonalon."	
							setTimer(
								function()
									triggerServerEvent("drivetest", root, localPlayer);
									elmegy();
									number = 1;
									line = math.random(1, #road1);
									theMarker = createMarker(road1[line][number][1], road1[line][number][2], road1[line][number][3], "checkpoint", 4.0,  sR, sG, sB, 170);
									theBlip = createBlip ( road1[line][number][1], road1[line][number][2], road1[line][number][3], 3, 1,sR, sG, sB, 170, 255);
									addEventHandler("onClientMarkerHit", root, road2);
									speakTimer = setTimer(
										function ()
											numeric = math.random(1, #sentences);
											outputChatBox(core:getServerPrefix("server", "Huana Alex", 3)..sentences[numeric], 0, 0, 0, true);	
										end
									,60000,0);
								end,
							5000,1);
						end,	
					5000,1);											
				else
				removeEventHandler("onClientKey", root, kezeles5);
				removeEventHandler("onClientRender", root, gombok2);	
					setTimer(
						function()
							text = "Nincs elegendő pénzed, ahogy látom!";	
							setTimer(
								function()
									text = "Más valamiben még segíthetek?";	
									addEventHandler("onClientKey", root, kezeles);
									addEventHandler("onClientRender", root, gombok);
								end,
							5000,1);
						end,	
					2000,1);					
				end	
			elseif core:isInSlot(1010/pX*sX, 930/pY*sY, 150/pX*sX, 40/pY*sY) then
			removeEventHandler("onClientKey", root, kezeles5);
			removeEventHandler("onClientRender", root, gombok2);
			setTimer(
				function()
					text = "Más valamiben még segíthetek?";	
						setTimer(
							function()
								addEventHandler("onClientKey", root, kezeles);
								addEventHandler("onClientRender", root, gombok);
							end,
						5000,1);
				end,	
			2000,1);
			end	
		end	
	end	
end

function message()
	setTimer(
		function()
			text = "Miben segíthetek?";
			addEventHandler("onClientRender", root, gombok);
			addEventHandler("onClientKey", root, kezeles);		
		end,
	7500,1);
end

function road()
	if (source == theMarker) then
		if (localPlayer) then
		local vehicle = getPedOccupiedVehicle(localPlayer);	
			if (vehicle) then
			local drivecar = getElementData(vehicle, "drivecar") or false;
				if (drivecar) then
					destroyElement(theMarker);
					destroyElement(theBlip);
					if (#road1[line] > number) then
						number = number + 1;
						theBlip = createBlip ( road1[line][number][1], road1[line][number][2], road1[line][number][3], 3, 1,sR, sG, sB, 170, 255);
						theMarker = createMarker(road1[line][number][1], road1[line][number][2], road1[line][number][3], "checkpoint", 4.0,  sR, sG, sB, 170);
					else
						removeEventHandler("onClientMarkerHit", root, road);
						triggerServerEvent("drivetestout", root, localPlayer);
						if (isTimer(speakTimer)) then
							killTimer(speakTimer);
						end	
					end	
				end	
			end	
		end
	end		
end	

function road2()
	if (source == theMarker) then
		if (localPlayer) then
		local vehicle = getPedOccupiedVehicle(localPlayer);	
			if (vehicle) then
			local drivecar = getElementData(vehicle, "drivecar") or false;
				if (drivecar) then
					destroyElement(theMarker);
					destroyElement(theBlip);
					if (#road1[line] > number) then
						number = number + 1;
						theBlip = createBlip ( road1[line][number][1], road1[line][number][2], road1[line][number][3], 3, 1,sR, sG, sB, 170, 255);
						theMarker = createMarker(road1[line][number][1], road1[line][number][2], road1[line][number][3], "checkpoint", 4.0,  sR, sG, sB, 170);
					else
						removeEventHandler("onClientMarkerHit", root, road);
						triggerServerEvent("drivetestout2", root, localPlayer);
						if (isTimer(speakTimer)) then
							killTimer(speakTimer);
						end	
					end	
				end	
			end	
		end
	end		
end	

addEvent("failed", true);
addEventHandler("failed", root,
	function ()
		destroyElement(theMarker);
		removeEventHandler("onClientMarkerHit", root, road);
	end
);
----------------------------

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local function camRender()
	if (sm.moov == 1) then
		local x1,y1,z1 = getElementPosition(sm.object1);
		local x2,y2,z2 = getElementPosition(sm.object2);
		setCameraMatrix(x1,y1,z1,x2,y2,z2);
	else
		removeEventHandler("onClientPreRender",root,camRender);
	end
end

 
function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1)then return false end
	sm.object1 = createObject(1337,x1,y1,z1);
	sm.object2 = createObject(1337,x1t,y1t,z1t);
        setElementCollisionsEnabled (sm.object1,false); 
	setElementCollisionsEnabled (sm.object2,false);
	setElementAlpha(sm.object1,0);
	setElementAlpha(sm.object2,0);
	setObjectScale(sm.object1,0.01);
	setObjectScale(sm.object2,0.01);
	moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad");
	moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad");
	sm.moov = 1
	setTimer(removeCamHandler,time,1);
	setTimer(destroyElement,time,1,sm.object1);
	setTimer(destroyElement,time,1,sm.object2);
	addEventHandler("onClientPreRender",root,camRender);
	return true
end

function elmegy()
	mutat = 0;
	removeEventHandler("onClientRender", root, rajz);
	removeEventHandler("onClientKey", root, kezeles);
	removeEventHandler("onClientRender", root, gombok);
	setElementFrozen(localPlayer, false);
	setElementData(localPlayer, "van", false);
	setCameraTarget (localPlayer);
	killTimer(iskolaTimer);
	setPedAnimation(autosiskolaped, _, _);	
	setElementAlpha(localPlayer, 255);
	showChat(true);
	showing = 0;
	text = "Üdvözöllek az autósiskolában! Az én nevem Huana Rodríguez.";
	pont = 0;
	exports.oInterface:toggleHud(false);
	if (isTimer(speakTimer)) then
		killTimer(speakTimer);
	end	
end	
