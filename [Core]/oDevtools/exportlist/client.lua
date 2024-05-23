local sx, sy = guiGetScreenSize()
local exportWindow, exportGrid, exportPane
local eW, eH = 400, 400
local spacer = 20

--outputChatBox("asd")

addEvent("exportList->open", true)
addEventHandler("exportList->open", root, 
    function(exporttable, exportType)
        if isElement(exportWindow) then return end
        local client_exports = exports

        exportWindow = guiCreateWindow(sx/2-eW/2, sy/2-eH/2, eW, eH, "Export list", false)
        guiWindowSetSizable(exportWindow, false)
        exportGrid = guiCreateGridList(0, 0.06, 1, 1, true, exportWindow)
        exportPane = guiCreateScrollPane(0, 0.06, 1, 1, true, exportWindow)
        local y = spacer
        local sharedFunctions = {}
        local clientFunctions = {}
        local serverFunctions = {}

        if exportType == "all" or exportType == "shared" then
            local tempLabel = guiCreateLabel(5, y, eW-20, 20, "Shared", false, exportPane)
            guiLabelSetHorizontalAlign(tempLabel, "center")
            guiSetFont(tempLabel, "clear-normal")
            y = y + spacer

            if exportType == "all" then
                for k,v in ipairs(exporttable["shared"]) do
                    local tempLabel = guiCreateLabel(5, y, eW-20, 20, v[1].." => "..v[2], false, exportPane)
                    guiLabelSetHorizontalAlign(tempLabel, "center")
                    guiSetFont(tempLabel, "default-small")
                    y = y + 15
                end
            else
                for k,v in ipairs(exporttable) do
                    local tempLabel = guiCreateLabel(5, y, eW-20, 20, v[1].." => "..v[2], false, exportPane)
                    guiLabelSetHorizontalAlign(tempLabel, "center")
                    guiSetFont(tempLabel, "default-small")
                    y = y + 15
                end
            end
        end

        if exportType == "all" or exportType == "client" then
            local tempLabel = guiCreateLabel(5, y, eW-20, 20, "Client", false, exportPane)
            guiLabelSetHorizontalAlign(tempLabel, "center")
            guiSetFont(tempLabel, "clear-normal")
            y = y + spacer
            if exportType == "all" then
                for k,v in ipairs(exporttable["client"]) do
                    local tempLabel = guiCreateLabel(5, y, eW-20, 20, v[1].." => "..v[2], false, exportPane)
                    guiLabelSetHorizontalAlign(tempLabel, "center")
                    guiSetFont(tempLabel, "default-small")
                    y = y + 15
                end
            else
                for k,v in ipairs(exporttable) do
                    local tempLabel = guiCreateLabel(5, y, eW-20, 20, v[1].." => "..v[2], false, exportPane)
                    guiLabelSetHorizontalAlign(tempLabel, "center")
                    guiSetFont(tempLabel, "default-small")
                    y = y + 15
                end
            end
        end

        if exportType == "all" or exportType == "server" then
            local tempLabel = guiCreateLabel(5, y, eW-20, 20, "Server", false, exportPane)
            guiLabelSetHorizontalAlign(tempLabel, "center")
            guiSetFont(tempLabel, "clear-normal")
            y = y + spacer
            if exportType == "all" then
                for k,v in ipairs(exporttable["server"]) do
                    local tempLabel = guiCreateLabel(5, y, eW-20, 20, v[1].." => "..v[2], false, exportPane)
                    guiLabelSetHorizontalAlign(tempLabel, "center")
                    guiSetFont(tempLabel, "default-small")
                    y = y + 15
                end
            else
                for k,v in ipairs(exporttable) do
                    local tempLabel = guiCreateLabel(5, y, eW-20, 20, v[1].." => "..v[2], false, exportPane)
                    guiLabelSetHorizontalAlign(tempLabel, "center")
                    guiSetFont(tempLabel, "default-small")
                    y = y + 15
                end
            end
        end
end
)

addEvent("exportList->close", true)
addEventHandler("exportList->close", root, 
    function()
        if isElement(exportPane) then
            destroyElement(exportPane)
            exportPane = nil
        end
        if isElement(exportGrid) then
            destroyElement(exportGrid)
            exportGrid = nil
        end
        if isElement(exportWindow) then
            destroyElement(exportWindow)
            exportWindow = nil
        end
    end
)