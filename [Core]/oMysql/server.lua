local serverDatabase
local logsDatabase 

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		serverDatabase = dbConnect("mysql", "dbname=dbname;host=127.0.0.1;charset=utf8", "username", "pw", "multi_statements=1")
		logsDatabase = dbConnect("mysql", "dbname=dbname;host=127.0.0.1;charset=utf8", "username", "pw", "multi_statements=1")
		
		if not serverDatabase then
			outputServerLog("[MySQL]: Failed to connect the database.")
			outputDebugString("[MySQL]: Sikertelen kapcsolódás az adatbázishoz!", 1)
			cancelEvent()
		else
			dbExec(serverDatabase, "SET NAMES utf8")
			outputDebugString("[MySQL]: Sikeres kapcsolódás az adatbázishoz.")
		end

		if not logsDatabase then
			outputServerLog("[MySQL]: Failed to connect the LOGS database.")
			outputDebugString("[MySQL]: Sikertelen kapcsolódás a LOG adatbázishoz!", 1)
		else
			dbExec(logsDatabase, "SET NAMES utf8")
			outputDebugString("[MySQL]: Sikeres kapcsolódás a LOG adatbázishoz.")
		end
	end
)

function getDBConnection()
	return serverDatabase
end

function getLogsDBConnection()
	return logsDatabase
end
