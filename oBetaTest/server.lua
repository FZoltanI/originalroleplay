local testers = {
    {"","Carlos"},
}

--[[addEventHandler ( "onResourceStart", resourceRoot, function()
    for k,v in ipairs(getElementsByType("player")) do 
        local serial = getPlayerSerial(v)

        local volt = false
        for k, v in ipairs(testers) do 
            if v[1] == serial then 
                volt = true 
                break
            end
        end

        if not volt then
            if not getElementData(v,"aclLogin") then  
                kickPlayer(v, "[BétaTeszt]: A te serialod nincs engedélyezve!")
                return
            else
                outputChatBox("[BétaTeszt]: A te serialod nincs engedélyezve, de mivel fejlesztő vagy így nem kickeltelek! :)",v,255,0,0)
            end
        end
    end
end)

addEventHandler ( "onPlayerJoin", root, 
    function()
        local serial = getPlayerSerial(source)

        local volt = false
        local id = 0
        for k, v in ipairs(testers) do 
            if v[1] == serial then 
                volt = true 
                id = k
                break
            end
        end

        if not volt then
            if not getElementData(source,"aclLogin") then  
                kickPlayer(source, "[BétaTeszt]: A te serialod nincs engedélyezve!")
                cancelEvent(true, "[BétaTeszt]: A te serialod nincs engedélyezve!")
                return
            end
        end

        local name
        if id > 0 then 
            name = testers[id][2]
        else
            name = "Fejlesztő"
        end
        outputChatBox(exports.cl_core:getServerColor().."[BétaTeszt]: #ffffffÜdvözlünk a szerveren, "..exports.cl_core:getServerColor()..name.."#ffffff! Jó tesztelést kívánunk!",source,255,255,255,true)
        outputChatBox(exports.cl_core:getServerColor().."[BétaTeszt]: #ffffffHa bármi hibát találsz, akkor azt jelentsd TeamSpeak3 szerverünkön! ( ts.originalrp.com )",source,255,255,255,true)
    end 
)   ]]