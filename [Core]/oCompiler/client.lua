addCommandHandler("compile", function(cmd, file, fileType, keyID)
    if getElementData(localPlayer, "aclLogin") then 
        if file and type and keyID then 
            compileFile(file, fileType, keyID)
        else
            outputChatBox(exports.oCore:getServerPrefix("server", "Használat", 3).."/"..cmd.." [File] [Kiterjesztés] [Key]", 255, 255, 255, true)
        end
    end
end)

function compileFile(fileName, type, key)
    outputChatBox("Start file compile. File: "..fileName.."."..type)

    --if file then 
        local filePath = tostring(fileName.."."..type)
        --file = fileOpen(":oCompiler/502.dff", false)
        openedFile = fileOpen(":oCompiler/"..filePath, true)

        if openedFile then 
            local count = fileGetSize(openedFile)
            local fileData = fileRead(openedFile, fileGetSize(openedFile))

            --print(fileData)

            local newData = teaEncode(base64Encode(fileData), key)

            if fileExists(fileName..type..".originalmodel") then
                fileDelete(fileName..type..".originalmodel")
              end

            local compliedFile = fileCreate(fileName..type..".originalmodel")

            fileWrite(compliedFile, newData)
            fileClose(compliedFile)

            fileClose(openedFile)
            fileDelete(":oCompiler/"..filePath)

            outputChatBox("Compile completed")
        end
    --end
end

addCommandHandler("compile2", function(cmd, file)
    if getElementData(localPlayer, "aclLogin") then 
        if file and type then 
            compileFile2(file)
        else
            outputChatBox(exports.oCore:getServerPrefix("server", "Használat", 3).."/"..cmd.." [File] [Kiterjesztés] [Key]", 255, 255, 255, true)
        end
    end
end)


function compileFile2(fileName)

    --if file then 

        openedFile_txd = fileOpen(":oCompiler/"..fileName..".txd", true)
        openedFile_dff = fileOpen(":oCompiler/"..fileName..".dff", true)
        openedFile_col = fileOpen(":oCompiler/"..fileName..".col", true)

        fileData_key = "orp2k22" .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. "hunrp"
        fileData_txd = ""
        fileData_dff = ""
        fileData_col = ""

        if openedFile_txd then 
            local count = fileGetSize(openedFile_txd)
            local fileData = fileRead(openedFile_txd, fileGetSize(openedFile_txd))

            local fileData_txd, fileDec_txd = encodeString("aes128", fileData, {key = fileData_key})
            fileDec_txd = base64Encode(fileDec_txd)

            print(fileData_txd)

            fileClose(openedFile_txd)
            --fileDelete(":oCompiler/"..fileName..".txd")
        end

        if openedFile_dff then 
            local count = fileGetSize(openedFile_dff)
            local fileData = fileRead(openedFile_dff, fileGetSize(openedFile_dff))

            local fileData_dff, fileDec_dff = encodeString("aes128", fileData, {key = fileData_key})
            fileDec_dff= base64Encode(fileDec_dff)
            fileData_dff = base64Encode(fileData_dff)

            fileClose(openedFile_dff)
            --fileDelete(":oCompiler/"..fileName..".dff")
        end

        if openedFile_col then 
            local count = fileGetSize(openedFile_col)
            local fileData = fileRead(openedFile_col, fileGetSize(openedFile_col))

            local fileData_col, fileDec_col = encodeString("aes128", fileData, {key = fileData_key})
            fileDec_col= base64Encode(fileDec_col)
            fileData_col = base64Encode(fileData_col)

            fileClose(openedFile_col)
            --fileDelete(":oCompiler/"..fileName..".col")
        end

        --fileData_FULL = fileData_key .. "CW_CJ_OGRP" .. string.random(math.random(100, 300)) .. "CW_CJ_OGRP" .. fileData_txd .. "CW_CJ_OGRP" .. fileData_dff .. "CW_CJ_OGRP" .. fileData_col

        --setTimer(function()
            local compliedFile = fileCreate(fileName..".originalmodel")

            fileWrite(compliedFile, fileData_key, "CW_CJ_OGRP", string.random(math.random(100, 300)),  "CW_CJ_OGRP" , base64Encode(fileData_txd) , "CW_CJ_OGRP" , fileData_dff , "CW_CJ_OGRP" , fileData_col )
            fileClose(compliedFile)
        --end, 2000, 1)
        
        --end
end

local txd_cache = {}

function loadCompliedModel(modelID, key, dffSRC, txdSRC, colSRC, applyTransparency, isTXDNotComplied, eventNeeded)
    local txd = false
    local dff = false
    local col = false

    if txdSRC then 
        txd = fileOpen(txdSRC)
    end

    if dffSRC then 
        dff = fileOpen(dffSRC)
    end

    if colSRC then 
        col = fileOpen(colSRC)
    end

    local txdData = false
    local dffData = false
    local colData = false

    if txd then 
        if not txd_cache[txd] then 
            txdData = fileRead(txd, fileGetSize(txd))
        end
    end

    if dff then 
        dffData = fileRead(dff, fileGetSize(dff))
    end

    if col then 
        colData = fileRead(col, fileGetSize(col))
    end

    if txd then 
        fileClose(txd)
    end

    if dff then 
        fileClose(dff)
    end

    if col then 
        fileClose(col)
    end

    if txdData then 
        if not isTXDNotComplied then

            if not txd_cache[txdSRC] then 
                txdData = base64Decode(teaDecode(txdData, key))
                txd_cache[txdSRC] = txdData
            else
                txdData = txd_cache[txdSRC]
            end

            local loadedTXD = engineLoadTXD(txdData, true)

            if loadedTXD then 
                if not engineImportTXD(loadedTXD, modelID) then 
                    engineImportTXD(loadedTXD, modelID)
                end
            end
        else
            engineImportTXD(txdSRC, modelID)
        end
    end

    if dffData then 
        dffData = base64Decode(teaDecode(dffData, key))
        local loadedDFF = engineLoadDFF(dffData)
        engineReplaceModel(loadedDFF, modelID, applyTransparency)
    end

    if colData then 
        colData = base64Decode(teaDecode(colData, key))
        loadedCol = engineLoadCOL(colData)
        engineReplaceCOL(loadedCol, modelID)
    end

    engineSetModelLODDistance(modelID, 20000)

    if eventNeeded then 
        triggerEvent("modelLoader > buildingLoaded", root)
    end
end

function clearTXDCache()
    txd_cache = {}
end


local charset = {}

-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
    math.randomseed(os.time())
  
    if length > 0 then
      return string.random(length - 1) .. charset[math.random(1, #charset)]
    else
      return ""
    end
  end