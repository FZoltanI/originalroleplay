--[[local sx,sy = guiGetScreenSize()
local cache = {}
cache.bebasneue = exports["oFont"]:getFont("bebasneue",20);
cache.condensed = exports["oFont"]:getFont("condensed",20);
cache.fontawesome2 = exports["oFont"]:getFont("fontawesome2",25);

cache.serverName = exports["oCore"]:getServerName();
cache.serverhex = exports["oCore"]:getServerColor();
local h,r,g,b = exports["oCore"]:getServerColor();
local y = sy*0.05
cache.ped = createPed(187,1488.8396728516, 1305.4716796875, 1093.9163867188,271.72338867188);

cache.panel = false ;
cache.choose = 0
cache.page = "menu";
cache.number = 1
cache.test = true;
cache.answers = 0
cache.correctanswers = 0
cache.question = math.random(1,#question);

setElementData(localPlayer,"char:drivinglicense",false)
setElementData(cache.ped,"ped:name","Carlos Johanson");
setElementData(cache.ped,"ped:prefix","Autósiskola");
setElementInterior(cache.ped,3);
setElementDimension(cache.ped,206);

local start = getTickCount()
local loadingBar = getTickCount()
local try2 = 0

function click ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
    if (button == "left") and (state == "down") then 
        if clickedElement == cache.ped then 
            if not cache.panel then 
                cache.panel = true;
                addEventHandler("onClientRender",root,drivingPanel);
                start = getTickCount()
                setElementFrozen(localPlayer,true);
                --cache.page = "menu"
            end 
        end 
    end 

    if (button == "left") and (state == "down") then 

        if cache.page == "menu" then 
            if isInSlot(sx*0.4015,sy*0.3 + y,sx*0.177,sy*0.055) then 
                cache.page = "learn"
                cache.number = 1 
                try2 = 0
                triggerServerEvent("takeMoney",localPlayer,localPlayer,500)
                outputChatBox(cache.serverhex.."[Autósiskola]: #ffffffElkezdted az elméleti oktatást amely a vizsgával együtt 500$-ba kerűlt.",255,255,255,true)
            elseif isInSlot(sx*0.4015,sy*0.4935 + y,sx*0.177,sy*0.055) then 
                cache.page = "menu"
                cache.number = 1 
                try2 = 0
                try = 0
                cache.panel = false;
                removeEventHandler("onClientRender",root,drivingPanel);
                setElementFrozen(localPlayer,false); 
            end 
        end 

        if cache.page == "test" then 
            if isInSlot(sx*0.4,sy*0.398 + y,sx*0.18,sy*0.02) then 
                cache.choose = 1
            elseif isInSlot(sx*0.4,sy*0.428 + y,sx*0.18 ,sy*0.02) then 
                cache.choose = 2
            elseif isInSlot(sx*0.4,sy*0.458 + y,sx*0.18 ,sy*0.02) then 
                cache.choose = 3
            elseif isInSlot(sx*0.4725,sy*0.527 + y,sx*0.04,sy*0.021) then 
                if cache.choose == 0 then 
                    exports["oInfobox"]:outputInfoBox("Egyet muszáj vagy választani!","error")
                else 
                    if cache.answers < 10 then 
                        outputChatBox("válaszoltal")
                        cache.answers = cache.answers + 1

                        if cache.choose == question[cache.question][5] then 
                            cache.correctanswers = cache.correctanswers + 1
                        end

                        cache.question = math.random(1,#question);

                        outputChatBox(cache.answers.." "..cache.correctanswers)
                    else 
                        if cache.correctanswers >= 10 then 
                            --exports["oInfobox"]:outputInfoBox("Gratulálunk, sikeresen teljesítetted az elméleti vizsga feltételeit.","succes") --MEG KELL CARLOSTOL KERDEZNI MI A SIKERES TYPE INFOBOXBAN
                            cache.test = true 
                        else 
                            exports["oInfobox"]:outputInfoBox("Sajnos megbuktál, legközelebb talán több sikerrel jársz.","error")
                        end

                        cache.choose = 0
                        cache.answers = 0
                        cache.correctanswers = 0 
                        cache.page = "menu"

                    end 
                end 
            end
        end

        if isInSlot(sx*0.49,sy*0.525 + y,sx*0.05,sy*0.025) then 
            if cache.page == "learn" then 
                if cache.number <=2 then 
                    cache.number = cache.number + 1
                else 
                    cache.answers = 0
                    cache.correctanswers = 0
                    cache.question = math.random(1,#question);
                    cache.page = "test"
                end 
            end
        elseif isInSlot(sx*0.437,sy*0.525 + y,sx*0.05,sy*0.025) then 
            if cache.number >= 2  then 
                cache.number = cache.number - 1
            end 

            if cache.page == "learn" then 
                if cache.number == 1 then 
                    if try2 == 0 then 
                        outputChatBox(cache.serverhex.."[Autósiskola]: #ffffffBiztos? (Ha igen próbáld újra.) Ha kilépsz az oktatásból ugrik a pénzed!",255,255,255,true)
                        try2 = try2 + 1
                    elseif try2 == 1 then 
                        try2 = 0
                        cache.page = "menu";
                        cache.number = 1
                        cache.question = math.random(1,#question);
                    end 
                end 
            end

        end 
    end 
end
addEventHandler ( "onClientClick", getRootElement(), click )

local try = 0

bindKey("backspace","down",function()
    if cache.panel then 

       if cache.page == "learn" then 
        if try == 0 then 
        outputChatBox(cache.serverhex.."[Autósiskola]: #ffffffBiztos? (Ha igen próbáld újra.) Ha most kilépsz újra kell kezdened!",255,255,255,true)
        try = try + 1
        elseif try == 1 then 
            try = 0
            cache.panel = false;
            removeEventHandler("onClientRender",root,drivingPanel);
            setElementFrozen(localPlayer,false); 
        end
       elseif cache.page == "menu" then 
        cache.panel = false;
        removeEventHandler("onClientRender",root,drivingPanel);
        setElementFrozen(localPlayer,false); 
       -- cache.page = "menu"
       end 

    end 
end)

local load = 0

function drivingPanel()
    if cache.panel then 
        local now = getTickCount()
        local endTime = start + 2000
        local elapsedTime = now - start
        local duration = endTime - start 
        local progress = elapsedTime/duration * 2
        local alpha,alpha2,alpha3 = interpolateBetween(0,0,0,240,255,200,progress,"OutQuad");
        local alpha4,alpha5,_ = interpolateBetween(0,0,0,10,100,0,progress,"OutQuad");


        dxDrawRectangle(sx*0.4,sy*0.25 + y,sx*0.18,sy*0.3025,tocolor(30,30,30,alpha));
        dxDrawRectangle(sx*0.4015,sy*0.253 + y,sx*0.177,sy*0.03,tocolor(40,40,40,alpha2));

        dxDrawText("Original"..cache.serverhex.."Roleplay",sx*0.406,sy*0.259 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
        dxDrawText("Driving"..cache.serverhex.."school",sx*0.53,sy*0.259 + y,_,_,tocolor(255,255,255,alpha3),0.00032*sx,cache.bebasneue,"left","top",false,false,false,true);

        if cache.page == "menu" then 
            --dxDrawRectangle(sx*0.4015,sy*0.3 + y,sx*0.0 + load,sy*0.055,tocolor(54, 111, 209,alpha2));
            dxDrawRectangle(sx*0.4015,sy*0.3 + y,sx*0.177,sy*0.055,tocolor(40,40,40,alpha2));

            dxDrawText("",sx*0.407 - 1,sy*0.31 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);
            dxDrawText("",sx*0.407,sy*0.31 + y,_,_,tocolor(255,255,255,alpha3),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);
            dxDrawText("Elméleti oktatás",sx*0.43 - 1,sy*0.31 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            dxDrawText("Elméleti oktatás",sx*0.43,sy*0.31 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

            dxDrawText("500$",sx*0.43 - 1,sy*0.327 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            dxDrawText("500$",sx*0.43,sy*0.327 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

            dxDrawText("Oktató:",sx*0.55 - 1,sy*0.31 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            dxDrawText("Oktató:",sx*0.55,sy*0.31 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

            dxDrawText("Carlos Johanson",sx*0.518 - 1,sy*0.327 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            dxDrawText("Carlos Johanson",sx*0.518,sy*0.327 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

            dxDrawRectangle(sx*0.4015,sy*0.3642 + y,sx*0.177,sy*0.055,tocolor(40,40,40,alpha2));

            if cache.test then 
                dxDrawText("",sx*0.407 - 1,sy*0.3745 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);
                dxDrawText("",sx*0.407,sy*0.3745 + y,_,_,tocolor(255,255,255,alpha3),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);

                dxDrawText("Gyakorlati oktatás",sx*0.43 - 1,sy*0.3745 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Gyakorlati oktatás",sx*0.43,sy*0.3745 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("1000$",sx*0.43 - 1,sy*0.392 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("1000$",sx*0.43,sy*0.392 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Oktató:",sx*0.55 - 1,sy*0.3745 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Oktató:",sx*0.55,sy*0.3745 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Amy Leatham",sx*0.528 - 1,sy*0.392 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Amy Leatham",sx*0.528,sy*0.392 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            else 
                dxDrawRectangle(sx*0.4015,sy*0.3645 + y,sx*0.177,sy*0.055,tocolor(10,10,10,alpha3));

                dxDrawText("",sx*0.407 - 1,sy*0.3745 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);
                dxDrawText("",sx*0.407,sy*0.3745 + y,_,_,tocolor(255,255,255,alpha4),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);

                dxDrawText("Gyakorlati oktatás",sx*0.43 - 1,sy*0.3745 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Gyakorlati oktatás",sx*0.43,sy*0.3745 + y,_,_,tocolor(255,255,255,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("1000$",sx*0.43 - 1,sy*0.392 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("1000$",sx*0.43,sy*0.392 + y,_,_,tocolor(255,255,255,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Oktató:",sx*0.55 - 1,sy*0.3745 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Oktató:",sx*0.55,sy*0.3745 + y,_,_,tocolor(255,255,255,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Amy Leatham",sx*0.528 - 1,sy*0.392 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Amy Leatham",sx*0.528,sy*0.392 + y,_,_,tocolor(255,255,255,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Elméleti vizsga után elérhető!",sx*0.44,sy*0.3827 + y,_,_,tocolor(166, 51, 55,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

            end 

            dxDrawRectangle(sx*0.4015,sy*0.4290 + y,sx*0.177,sy*0.055,tocolor(40,40,40,alpha2));

            if getElementData(localPlayer,"char:drivinglicense") then 
                dxDrawText("",sx*0.407 - 1,sy*0.4390 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);
                dxDrawText("",sx*0.407,sy*0.4390 + y,_,_,tocolor(255,255,255,alpha3),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);

                dxDrawText("Kártya megújítás",sx*0.43 - 1,sy*0.4380 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Kártya megújítás",sx*0.43,sy*0.4380 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("600$",sx*0.43 - 1,sy*0.456 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("600$",sx*0.43,sy*0.456 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Ügyintéző:",sx*0.538 - 1,sy*0.4380 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Ügyintéző:",sx*0.538,sy*0.4380 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Jack Rodrigez",sx*0.526 - 1,sy*0.456 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Jack Rodrigez",sx*0.526,sy*0.456 + y,_,_,tocolor(255,255,255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            else 
                dxDrawRectangle(sx*0.4015,sy*0.4290 + y,sx*0.177,sy*0.055,tocolor(10,10,10,alpha3));

                dxDrawText("",sx*0.407 - 1,sy*0.4390 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);
                dxDrawText("",sx*0.407,sy*0.4390 + y,_,_,tocolor(255,255,255,alpha4),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);

                dxDrawText("Kártya megújítás",sx*0.43 - 1,sy*0.4380 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Kártya megújítás",sx*0.43,sy*0.4380 + y,_,_,tocolor(255,255,255,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("600$",sx*0.43 - 1,sy*0.456 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("600$",sx*0.43,sy*0.456 + y,_,_,tocolor(255,255,255,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Ügyintéző:",sx*0.538 - 1,sy*0.4380 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Ügyintéző:",sx*0.538,sy*0.4380 + y,_,_,tocolor(255,255,255,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Jack Rodrigez",sx*0.526 - 1,sy*0.456 + 1 + y,_,_,tocolor(0, 0, 0,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
                dxDrawText("Jack Rodrigez",sx*0.526,sy*0.456 + y,_,_,tocolor(255,255,255,alpha4),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

                dxDrawText("Még nincs jogosítványod!",sx*0.446,sy*0.448 + y,_,_,tocolor(166, 51, 55,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            end
            dxDrawRectangle(sx*0.4015,sy*0.4935 + y,sx*0.177,sy*0.055,tocolor(40,40,40,alpha2));

            dxDrawText("",sx*0.411 - 1,sy*0.5035 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);
            dxDrawText("",sx*0.411,sy*0.5035 + y,_,_,tocolor(166, 51, 55,alpha3),0.00045*sx,cache.fontawesome2,"left","top",false,false,false,true);

            dxDrawText("Bezárás",sx*0.43 - 1,sy*0.5025 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            dxDrawText("Bezárás",sx*0.43,sy*0.5025 + y,_,_,tocolor(166, 51, 55,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

            dxDrawText("Autósiskola bezárása",sx*0.43 - 1,sy*0.52 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            dxDrawText("Autósiskola bezárása",sx*0.43,sy*0.52 + y,_,_,tocolor(166, 51, 55,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

            if isInSlot(sx*0.4015,sy*0.3 + y,sx*0.177,sy*0.055) then 
                dxDrawRectangle(sx*0.4015,sy*0.3 + y,sx*0.177,sy*0.055,tocolor(255,255,255,100));
            end 

            if isInSlot(sx*0.4015,sy*0.3645 + y,sx*0.177,sy*0.055) then 
                if cache.test then 
                dxDrawRectangle(sx*0.4015,sy*0.3645 + y,sx*0.177,sy*0.055,tocolor(255,255,255,100));
                end
            end 

            if isInSlot(sx*0.4015,sy*0.4290 + y,sx*0.177,sy*0.055) then 
                if getElementData(localPlayer,"char:drivinglicense") then 
                dxDrawRectangle(sx*0.4015,sy*0.4290 + y,sx*0.177,sy*0.055,tocolor(255,255,255,100));
                end
            end 

            if isInSlot(sx*0.4015,sy*0.4935 + y,sx*0.177,sy*0.055) then 
                dxDrawRectangle(sx*0.4015,sy*0.4935 + y,sx*0.177,sy*0.055,tocolor(166, 51, 55,100));
            end

        elseif cache.page == "learn" then
            dxDrawText(carlossay[cache.number][1],sx*0.405,sy*0.288 + y,_,_,tocolor(255, 255, 255,alpha3),0.00027*sx,cache.condensed,"left","top",false,false,false,true);

            dxDrawText(learn[cache.number][1],sx*0.405,sy*0.35 + y,_,_,tocolor(255, 255, 255,alpha3),0.00027*sx,cache.condensed,"left","top",false,false,false,true);

            if isInSlot(sx*0.49,sy*0.525 + y,sx*0.05,sy*0.025) then
            dxDrawRectangle(sx*0.49,sy*0.525 + y,sx*0.05,sy*0.025,tocolor(40,40,40,alpha2));
            dxDrawRectangle(sx*0.49,sy*0.525 + y,sx*0.05,sy*0.025,tocolor(r,g,b,alpha2));
            else 
            dxDrawRectangle(sx*0.49,sy*0.525 + y,sx*0.05,sy*0.025,tocolor(40,40,40,alpha2));
            end

            dxDrawText("Tovább",sx*0.5025 - 1,sy*0.5285 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            dxDrawText("Tovább",sx*0.5025,sy*0.5285 + y,_,_,tocolor(255, 255, 255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

            if isInSlot(sx*0.437,sy*0.525 + y,sx*0.05,sy*0.025) then
                dxDrawRectangle(sx*0.437,sy*0.525 + y,sx*0.05,sy*0.025,tocolor(40,40,40,alpha2));
                dxDrawRectangle(sx*0.437,sy*0.525 + y,sx*0.05,sy*0.025,tocolor(166, 51, 55,alpha2));
            else 
                dxDrawRectangle(sx*0.437,sy*0.525 + y,sx*0.05,sy*0.025,tocolor(40,40,40,alpha2));
            end

            dxDrawText("Vissza",sx*0.45 - 1,sy*0.5285 + 1 + y,_,_,tocolor(0, 0, 0,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);
            dxDrawText("Vissza",sx*0.45,sy*0.5285 + y,_,_,tocolor(255, 255, 255,alpha3),0.00029*sx,cache.condensed,"left","top",false,false,false,true);

        elseif cache.page == "test" then 

            
            dxDrawText(question[cache.question][1],sx*0.405,sy*0.288 + y,_,_,tocolor(255, 255, 255,alpha3),0.00027*sx,cache.condensed,"left","top",false,false,false,true);

            if cache.choose == 1 then 
            local r, g, b = interpolateBetween(255, 255, 255, 227, 136, 32, getTickCount() / 1000, "CosineCurve");
            dxDrawText("#1. "..question[cache.question][2],sx*0.975,sy*0.4 + y,_,_,tocolor(r, g, b,alpha3),0.00027*sx,cache.condensed,"center","top",false,false,false,true);
            else 
            dxDrawText("#e38820#1.#ffffff "..question[cache.question][2],sx*0.975,sy*0.4 + y,_,_,tocolor(255, 255, 255,alpha3),0.00027*sx,cache.condensed,"center","top",false,false,false,true);
            end

            if cache.choose == 2 then 
                local r, g, b = interpolateBetween(255, 255, 255, 227, 136, 32, getTickCount() / 1000, "CosineCurve");
                dxDrawText("#2. "..question[cache.question][3],sx*0.975,sy*0.43 + y,_,_,tocolor(r,g,b,alpha3),0.00027*sx,cache.condensed,"center","top",false,false,false,true);
            else 
                dxDrawText("#e38820#2.#ffffff "..question[cache.question][3],sx*0.975,sy*0.43 + y,_,_,tocolor(255, 255, 255,alpha3),0.00027*sx,cache.condensed,"center","top",false,false,false,true);
            end 

            if cache.choose == 3 then 
                local r, g, b = interpolateBetween(255, 255, 255, 227, 136, 32, getTickCount() / 1000, "CosineCurve");
                dxDrawText("#3. "..question[cache.question][4],sx*0.975,sy*0.46 + y,_,_,tocolor(r, g, b,alpha3),0.00027*sx,cache.condensed,"center","top",false,false,false,true);
            else 
                dxDrawText("#e38820#3.#ffffff "..question[cache.question][4],sx*0.975,sy*0.46 + y,_,_,tocolor(255, 255, 255,alpha3),0.00027*sx,cache.condensed,"center","top",false,false,false,true);
            end 

            dxDrawRectangle(sx*0.4725,sy*0.527 + y,sx*0.04,sy*0.021,tocolor(0,0,0,alpha5))
            dxDrawText("Tovább",sx*0.48,sy*0.53 + y,_,_,tocolor(255,255,255,alpha3),0.00028*sx,cache.condensed,"left","top",false,false,false,true);

        end
    end 
end

local sign = {}
local cols = {}

local signs = {
    {9071,1342.0632324219, -918.31097412109, 34.553508758545,170},
    {9072,1269.233203125, -919.47061767578, 42.512683868408,95},
    {9070,1172.3498535156, -936.04315185547, 41.868340301514,95},
    {9072,1157.6309814453, -1023.710144043, 32.086742401123,170},
    {9071,1157.0014648438, -1130.5552978516, 22.743761444092,170},
    {9072,1093.9026367188, -1135.2565380859, 22.728125,97},
    {9072,973.7421875, -1135.3422851563, 22.728125,97},
    {9070,811.99483642578, -1135.05208496094, 23.528125,95},
    {9072,791.97521972656, -1308.9146728516, 12.346875,173},
    {9070,791.81188964844, -1383.0995849609, 13.246875,173},
    {9071,906.41442871094, -1411.4598388672, 12.377653121948,-97},
    {9070,912.24420166016, -1478.5734375, 13.554977416992,170},
    {9070,1038.8075, -1499.17002197266, 13.5546875,-105},
    {9072,1184.1566162109, -1411.7867431641, 12.38644695282,-95},
    {9071,1068.4288330078, -1421.2977294922, 12.394561958313,0},
    {9070,1331.453125, -1411.2818603516, 12.552037239075,-95},
    {9072,1362.7535400391, -1163.1536865234, 22.9195728302,0},
    {9072,1374.1195068359, -1047.4995117188, 25.686262130737,0},
    {9070,1382.7158203125, -959.36560058594, 33.300399780273,0},
}

function createDriveSign()
    for k,v in pairs(signs) do 
        sign[k] = createObject(v[1],v[2],v[3],v[4],0,0,v[5]); 
        exports.oCore:createOutline(sign[k], {r,g,b})
    end

    col1 = createColCuboid(signs[1][2] - 5,signs[1][3],signs[1][4],5,10,5);

    col2 = createColCuboid(signs[1][2],signs[1][3] - 9,signs[1][4] - 1,5,10,5);
    col3 = createColCuboid(signs[1][2],signs[1][3] - 9,signs[1][4] - 1,5,10,5);
    col6 = createColCuboid(signs[1][2],signs[1][3] - 9,signs[1][4] - 1,5,10,5);
    col7 = createColCuboid(signs[1][2],signs[1][3] - 9,signs[1][4] - 1,5,10,5);
    col8 = createColCuboid(signs[1][2],signs[1][3] - 9,signs[1][4] - 1,5,10,5);

    col4 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);
    col5 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);
    col9 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);
    col10 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);
    col11 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);
    col12 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);
    col13 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);
    col14 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);
    col16 = createColCuboid(signs[1][2],signs[1][3],signs[1][4] - 1,5,10,5);

    col15 = createColCuboid(signs[1][2] - 10,signs[1][3],signs[1][4] - 1,10,10,5);
    col17 = createColCuboid(signs[1][2] - 10,signs[1][3],signs[1][4] - 1,10,10,5);
    col18 = createColCuboid(signs[1][2] - 10,signs[1][3],signs[1][4] - 1,10,10,5);
    col19 = createColCuboid(signs[1][2] - 10,signs[1][3],signs[1][4] - 1,10,10,5);
end 

function colHit(element,dim)
    col = getElementsByType("colshape")
        for k,v in pairs(col) do 
            if getElementData(v,"drive:col") then 
                if getElementData(v,"col:stat") then 
                    outputChatBox("ebben már voltál")
                else     
                    outputChatBox("ebben még nem.")
                    setElementData(v,"col:stat",true)
                end 
                return
            end 
        end 
end 
addEventHandler("onClientColShapeHit",root,colHit)

createDriveSign()

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(isInBox(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end

function isInBox(dX, dY, dSZ, dM, eX, eY)
	if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
		return true
	else
		return false
	end
end
]]