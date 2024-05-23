local sx, sy = guiGetScreenSize()
local chartBrowser = nil 

function createBarChart(labels, colors, borderColors, borderWidth, values)
    chartBrowser = createBrowser(sx, sy, true, true)

    addEventHandler("onClientBrowserCreated", chartBrowser, function()
        outputChatBox("asd")
        loadBrowserURL(chartBrowser, "http://mta/local/elements/charts/types/bar.html")
        addEventHandler("onClientRender", root, webBrowserRender)
    end)

    return chartBrowser
end
--createBarChart()

function webBrowserRender()
	dxDrawImage(sx*0.3, sy*0.3, 192*5, 108*5, chartBrowser, 0, 0, 0, tocolor(255,255,255,255), true)
end