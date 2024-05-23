local conn = exports.oMysql:getDBConnection();
local qh
local datas = {
	["accounts"] = {},
	["penalcodes"] = {},
	["wantedperson"] = {},
	["wantedcar"] = {},
};


function displayLoadedRes ( res )
	if(getResourceName(res) == "oMDC") then
	setTimer(
		function()
			qh = dbQuery(conn, "SELECT * FROM mdc_accounts");
			datas["accounts"] = dbPoll(qh, 500);
			qh2 = dbQuery(conn, "SELECT * FROM mdc_penalcode");
			datas["penalcodes"] = dbPoll(qh2, 500);	
			qh3 = dbQuery(conn, "SELECT * FROM mdc_wantedperson");
			datas["wantedperson"] = dbPoll(qh3, 500);
			qh4 = dbQuery(conn, "SELECT * FROM mdc_wantedcar");
			datas["wantedcar"] = dbPoll(qh4, 500);									
			triggerClientEvent("mdc:tabelExport", resourceRoot, datas["accounts"], datas["penalcodes"], datas["wantedperson"], datas["wantedcar"]);
		end
	,1000,1);	
	end 
end
addEventHandler ( "onResourceStart", getRootElement(), displayLoadedRes );
addEventHandler ( "onPlayerJoin", getRootElement(), 
	function ()		
		triggerClientEvent(source, "mdc:tabelExport", source, datas["accounts"], datas["penalcodes"], datas["wantedperson"], datas["wantedcar"]);
	end	
);

addEvent("mdc:addWanted_Person", true);
addEventHandler("mdc:addWanted_Person", root,
	function (name ,age, height, weight, reasons, issued, faction, date, sexual)
		dbExec(conn, "INSERT INTO mdc_wantedperson SET name=?, age=?, height=?, weight=?, reasons=?, issued=?, faction=?, date=?, other=?, sexual=?", name ,age, height, weight, toJSON(reasons), issued, faction, toJSON(date), "-", sexual);	
		table.insert(datas["wantedperson"], #datas["wantedperson"]+1,name ,age, height, weight, toJSON(reasons), issued, faction, toJSON(date), "-", sexual);
		triggerClientEvent("mdc:getWanted_Person", root, datas["wantedperson"]);					
	end
);

addEvent("mdc:addWanted_Car", true);
addEventHandler("mdc:addWanted_Car", root,
	function (number_plate , typev, color, reasons, issued, faction, date, newtable)
		dbExec(conn, "INSERT INTO mdc_wantedcar SET placetext=?, type=?, color=?, reasons=?, issued=?, faction=?, date=?, other=?", number_plate, typev, color, toJSON(reasons), issued, faction, toJSON(date), "-");	
		datas["wantedcar"] = newtable;
		triggerClientEvent("mdc:getWanted_Car", root, datas["wantedcar"]);					
	end
);

addEvent("delReport", true);
addEventHandler("delReport", root,
	function (tableID, newtable)
		dbExec(conn, "DELETE FROM mdc_wantedperson WHERE id=?", tableID);
		datas["wantedperson"] = newtable;
		triggerClientEvent("mdc:getWanted_Person", root, datas["wantedperson"]);
	end
);

addEvent("delReport_car", true);
addEventHandler("delReport_car", root,
	function (tableID, newtable)
		dbExec(conn, "DELETE FROM mdc_wantedcar WHERE id=?", tableID);
		datas["mdc_wantedcar"] = newtable;
		triggerClientEvent("mdc:getWanted_Car", root, datas["mdc_wantedcar"]);
	end
);

addEvent("updateReport", true);
addEventHandler("updateReport", root,
	function (name, other, reasons, id, newtable)
		dbQuery(conn, "UPDATE mdc_wantedperson SET name=?, other=?, reasons=? WHERE id=?", name, other, toJSON(reasons), id);
		datas["wantedperson"] = newtable;
		triggerClientEvent("mdc:getWanted_Person", root, datas["wantedperson"]);
	end
);

addEvent("updateReport_car", true);
addEventHandler("updateReport_car", root,
	function (number_plate, other, reasons, id)
		dbQuery(conn, "UPDATE mdc_wantedcar SET placetext=?, other=?, reasons=? WHERE id=?", number_plate, other, reasons, id);
		triggerClientEvent("mdc:getWanted_Car", root, datas["mdc_wantedcar"]);
	end
);