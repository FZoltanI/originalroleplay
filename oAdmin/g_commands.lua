adminCMD = {
    {command = 'fixcharger', permission = 2, shortDescription = 'Tesla frissítése'},
    {command = 'jailed', permission = 2, shortDescription = 'Jailben lévő játékosok mutatása'},
    {command = 'warn', permission = 2, shortDescription = 'Premium fegyver figyelmezetés kiosztás'},
    {command = 'fixveh', permission = 2, shortDescription = 'Jármű megjavítása'},
    {command = 'unflip', permission = 2, shortDescription = 'Jármű visszaborítása'},
    {command = 'setskin', permission = 2, shortDescription = 'Játékos kinézetének módosítása'},
    {command = 'setarmor', permission = 2, shortDescription = 'Játékos pajzsának módosítása'},
    {command = 'sethp', permission = 2, shortDescription = 'Játékos életerejének megváltoztatása'},
    {command = 'setdrunken', permission = 2, shortDescription = 'Játékos alkohol szintjének megváltoztatása'},
    {command = 'sethunger', permission = 2, shortDescription = 'Játékos éhség szintjének megváltoztatása'},
    {command = 'setthirst', permission = 2, shortDescription = 'Játékos szomjúság szintjének megváltoztatása'},
    {command = 'givemoney', permission = 7, shortDescription = 'Pénz adás játékosnak'},
    {command = 'setmoney', permission = 7, shortDescription = 'Játékos pénzének beállítása'},
    {command = 'setpp', permission = 8, shortDescription = 'Játékos prémium pontjának beállítása'},
    {command = 'givepp', permission = 8, shortDescription = 'Prémium pont adás játékosnak'},
    {command = 'goto', permission = 2, shortDescription = 'Játékoshoz teleportálás'},
    {command = 'vhspawn', permission = 2, shortDescription = 'Játékos városházára teleportálása'},
    {command = 'gethere', permission = 2, shortDescription = 'Játékoshoz magadhoz teleportálása'},
    {command = 'setadminnick', permission = 7, shortDescription = 'Adminisztrátor becenevének megváltoztatása'},
    {command = 'aduty', permission = 2, shortDescription = 'Adminisztrátor szolgálat'},
    {command = 'setadminlevel', permission = 7, shortDescription = 'Adminisztrátor szint állítása'},

    {command = 'findchar', permission = 2, shortDescription = 'Karakter név megkeresése Karakter ID alapján'},
    {command = 'findid', permission = 2, shortDescription = 'Karakter ID megkeresése Karakter Név alapján'},
    {command = 'vanish', permission = 2, shortDescription = 'Láthatatlan mód'},
    {command = 'kick', permission = 2, shortDescription = 'Játékos kirugása'},
    {command = 'freeze', permission = 2, shortDescription = 'Játékos fagyasztása'},
    {command = 'unfreeze', permission = 2, shortDescription = 'Játékos kiolvasztása'},
    {command = 'recon', permission = 1, shortDescription = 'Játékos megfigyelése'},
    {command = 'slap', permission = 2, shortDescription = 'Játékos felrepítése'},
    {command = 'showpms', permission = 6, shortDescription = 'PMek mutatása'},
    {command = 'ajail', permission = 2, shortDescription = 'Játékos bebörtönzése'},
    {command = 'unjail', permission = 2, shortDescription = 'Játékos kiszedése börtönből'},
    {command = 'aban', permission = 3, shortDescription = 'Játékos kitiltása'},
    {command = 'oban', permission = 4, shortDescription = 'Játékos kitiltása (Offline)'},
    {command = 'aunban', permission = 3, shortDescription = 'Játékos kitiltásának feloldása'},
    {command = 'setint', permission = 5, shortDescription = 'Játékos interiorjának beállítása'},
    {command = 'setdim', permission = 5, shortDescription = 'Játékos dimenziójának beállítása'},

    {command = 'removefactionmoney', permission = 7, shortDescription = 'Pénz elvétele frakciótól'},
    {command = 'givefactionmoney', permission = 7, shortDescription = 'Pénz adás frakciónak'},
    {command = 'setfactionleader', permission = 7, shortDescription = 'Leader jog adása'},
    {command = 'removeplayerfromallfaction', permission = 6, shortDescription = 'Játékos kirúgása az összes frakcióból'},
    {command = 'removeplayerfromfaction', permission = 6, shortDescription = 'Játékos kirúgása egy frakcióból'},
    {command = 'getplayerfactions', permission = 4, shortDescription = 'Játékos frakciójának lekérése'},
    {command = 'setplayerfaction', permission = 6, shortDescription = 'Játékos frakcióba rakása'},

    {command = 'fixbones', permission = 2, shortDescription = 'Játékos csontozatának meggyógyítása'},
    
    {command = 'ojail', permission = 3, shortDescription = 'Játékos bebörtönzése (Offline)'},
    {command = 'showmydatas', permission = 2, shortDescription = 'Saját adminisztrátor statisztikák megtekintése'},
    {command = 'showadminstats', permission = 8, shortDescription = 'Adminisztrátorok statisztikáinak megtekintése'},
    {command = 'clearadminstats', permission = 8, shortDescription = 'Adminisztrátorok statisztikáinak kitörlése'},
    {command = 'showplayers', permission = 2, shortDescription = 'Játékosok megtekintése a térképen'},
    {command = 'togalogs', permission = 2, shortDescription = 'Adminlogok kikapcsolása'},
    {command = 'setplayername', permission = 4, shortDescription = 'Játékos nevének módosítása'},
    {command = 'setaccountstate', permission = 7, shortDescription = 'Felhasználói fiók státuszának állítása'},

    {command = 'gotopoint', permission = 2, shortDescription = 'Checkpointra teleportálás'},
    {command = 'mypoints', permission = 2, shortDescription = 'Checkpointjaid'},
    {command = 'delpoint', permission = 2, shortDescription = 'Checkpointod törlése'},
    {command = 'addpoint', permission = 2, shortDescription = 'Checkpoint készítése'},

    {command = 'fly', permission = 2, shortDescription = 'Repülés ki/be kapcsolása'},

    {command = 'playerlogs', permission = 8, shortDescription = 'Játékosok logjai'},
    {command = 'bugreports', permission = 8, shortDescription = 'Buggjelentések'},
    {command = 'debuginventory', permission = 8, shortDescription = 'Lecsekkolja a játékos elbuggolt itemeit'},
    {command = 'takeitem', permission = 5, shortDescription = 'Item elvétele egy játékostól'},
    {command = 'giveitem', permission = 7, shortDescription = 'Item adása egy játékosnak'},
    {command = 'givelicense', permission = 5, shortDescription = 'Igazolvány adás'},
    {command = 'changelock', permission = 7, shortDescription = 'Kulcsolás'},
    {command = 'warn', permission = 7, shortDescription = 'Fegyver figyelmeztetése'},
    {command = 'playerstats', permission = 2, shortDescription = 'Játékos statisztikák megtekintése'},

    {command = 'sgoto', permission = 8, shortDescription = 'Játékosra teleportálás. (Nem jelenik meg sehol.)'},
    {command = 'srecon', permission = 8, shortDescription = 'Játékos megfigyelése. (Nem jelenik meg sehol.)'},

    {command = 'delroulette', permission = 9, shortDescription = 'Roulett asztal törlése'},
    {command = 'createroulette', permission = 9, shortDescription = 'Roulett asztal létrehozása'},
    {command = 'nearbyroulette', permission = 9, shortDescription = 'Közeledben lévő roulett asztalok'},

    {command = 'givelincese', permission = 7, shortDescription = 'Igazolvány adása játékosnak.'},
    {command = 'hideadmin', permission = 7, shortDescription = 'Rejtett admin'},
    {command = 'sethelper', permission = 6, shortDescription = 'Ideiglenes adminsegéd adás'},

    {command = 'setvehoil', permission = 2, shortDescription = 'Jármű olajszint állítása'},

    {command = 'resetbank', permission = 7, shortDescription = 'Bank visszaállítása (Sziréna kikapcsolása, széf visszacsukása)'},
    {command = 'nearbygates', permission = 7, shortDescription = 'Körülötted lévő kapuk listázása.'},
    {command = 'nearbysafe', permission = 3, shortDescription = 'Körülötted lévő széfek listázása.'},
    {command = 'nearbyvehicles', permission = 3, shortDescription = 'Körülötted lévő járművek listázása.'},
    {command = 'asay', permission = 2, shortDescription = 'Adminfelhívás létrehozása.'},
    {command = 'showinv', permission = 2, shortDescription = 'Játékos itemeinek és pénzének megtekintése'},
    {command = 'createinterior', permission = 7, shortDescription = 'Interior létrehozása'},
    {command = 'makeveh', permission = 7, shortDescription = 'Jármű létrehozása'},
    {command = 'anames', permission = 2, shortDescription = 'Nevek, élet és armor láthatóvá tétele'},

    {command = 'addcarshopmarker', permission = 7, shortDescription = 'Használtautó kereskedés marker hozzáadása'},
    {command = 'deletecarshopmarker', permission = 7, shortDescription = 'Használtatutó kereskedés marker törlése'},
    {command = 'setplayercarshop', permission = 7, shortDescription = 'Játékos használtautó kereskedésének beállítása'},
    {command = 'createcarshop', permission = 9, shortDescription = 'Használtautó kereskedés létrehozása'},
    {command = 'createlottofive', permission = 9, shortDescription = ''},
    {command = 'addweaponship', permission = 7, shortDescription = 'Fegyverhajó indítása'},
    {command = 'makepet', permission = 7, shortDescription = 'Háziállat létrehozása'},
    {command = 'delpet', permission = 7, shortDescription = 'Háziállat törlése'},
    {command = 'changepetname', permission = 6, shortDescription = 'Háziállat nevének megváltoztatása'},
    {command = 'rehealpet', permission = 6, shortDescription = 'Háziállat felélesztése'},
    
    {command = 'setcontainerplantstate', permission = 7, shortDescription = 'Konténerben lévő növények állapotának állítása'},
    {command = 'setcontainerplantgrow', permission = 7, shortDescription = 'Konténerben lévő növények növekedési szintjének állítása'},
    {command = 'weedplantcontainer', permission = 10, shortDescription = 'Növény ültetése'},
    {command = 'setcontainerfanstate', permission = 7, shortDescription = 'Konténerben lévő ventillátorok állapotának állítása'},
    {command = 'verifyplayer', permission = 7, shortDescription = 'Játékos verified státusz adás.'},
    {command = 'removeplayerverify', permission = 7, shortDescription = 'Játékos verified státusz megvonása.'},
    {command = 'getplayerserial', permission = 7, shortDescription = 'Adott játékos serialjának lekérése.'},
}

function hasPermission(element,permission)
    if ((getElementData(element, "user:admin") or 0) > 1) then
        for k, o in pairs(adminCMD) do
            if (o.command == permission) then
                if (o.permission <= getElementData(element, "user:admin")) then
                    return true
                elseif (adminSerials[getPlayerSerial(element)]) then
                    return true
                else
                    return false
                end
            end
        end
    elseif (adminSerials[getPlayerSerial(element)]) then
        return true
    end
end