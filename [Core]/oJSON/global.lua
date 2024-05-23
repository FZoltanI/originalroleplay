function saveDataToJSONFile(data, dataTitle, privateFile)
    if not data or not dataTitle then return end
    local fileName = dataTitle 

    if (privateFile or false) then 
        fileName = "@"..fileName
    end

    if fileExists("savedFiles/"..fileName..".json") then 
        fileDelete("savedFiles/"..fileName..".json")
    end

    local file = fileCreate("savedFiles/"..fileName..".json")
    fileWrite(file, toJSON(data))
    fileClose(file)
end

function loadDataFromJSONFile(dataTitle, privateFile)
    if not dataTitle then return end 

    local fileName = dataTitle 

    if (privateFile or false) then 
        fileName = "@"..fileName
    end

    if fileExists("savedFiles/"..fileName..".json") then 
        local file = fileOpen("savedFiles/"..fileName..".json", true)
        local data = fromJSON(fileRead(file, fileGetSize(file)))
        fileClose(file)

        return data 
    else
        return false
    end
end