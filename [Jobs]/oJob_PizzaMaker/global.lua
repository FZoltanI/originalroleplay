core = exports.oCore
color, r, g, b = core:getServerColor()
cmarker = exports.oCustomMarker

font = exports.oFont

sauces = {
    {name = "Paradicsomos", file = "ketchup.png", base = "pizzaalapp.png"},
    {name = "BBQ", file = "bbq.png", base = "pizzaalapb.png"},
    {name = "Tejfölös", file = "tejfolos.png", base = "pizzaalapt.png"},
}

cheeses = {
    {name = "Sajt nélkül", file = "sajtnelk.png"},
    {name = "Sajt", file = "sajt.png"},
    {name = "Extra sajt", file = "sajtextra.png"},
}

thicknesses = {
    {name = "Vékony"},
    {name = "Normál"},
    {name = "Vastag"},
}

ingredientFiles = {"pepperoni.png", "bacon.png", "kukorica.png", "gomba.png", "sonka.png", "tojas.png", "hagyma.png", "ananasz.png", "brokkoli.png", "bab.png", "gyros.png", "jalapeno.png"}

ingredients = {
	[1] = "Pepperoni",
	[2] = "Bacon",
	[3] = "Kukorica",
	[4] = "Gomba",
	[5] = "Sonka", 
	[6] = "Tojás",
	[7] = "Hagyma",
	[8] = "Ananász",
	[9] = "Brokkoli",
	[10] = "Bab",
	[11] = "Gyros hús",
	[12] = "Jalapeno"
}

drinks = {
	--{name = "Nem kér üdítőt", file = "sajtnelk.png"},
	{name = "Coca Cola 0.33l", file = "uditok/c033.png"},
	{name = "Coca Cola 0.5l", file = "uditok/c05.png"},
    {name = "Coca Cola 1.25l", file = "uditok/c125.png"},
    
    {name = "Fanta 0.33l", file = "uditok/f033.png"},
	{name = "Fanta 0.5l", file = "uditok/f05.png"},
    {name = "Fanta Zero 1.25l", file = "uditok/f125zero.png"},
    
    {name = "Sprite 0.33l", file = "uditok/s033.png"},
	{name = "Sprite 0.5l", file = "uditok/s05.png"},
	{name = "Sprite 1.25l", file = "uditok/s125.png"},
}

ing_texts = {
    {"Legyen rajta még pepperoni.", "Jut eszembe, pepperoni nem maradhat ki.", "Pepperoni mamarazzzooo, hogy is felejthettem el, pepperoni kell!", "Pepperoni már már alap.", "Nem is szólsz, hogy a Pepperonit majdnem kifelejtettem?"}, -- pepperoni
    {"Bacon is mehet rá.", "Remélem jól meg sütöd a bacont, csak olyat kérek rá!", "Zsíros bödönből szedjed kifele a bacont aztán rakjad rá.", "Ízletes, finom bacon a recept következő része."}, -- bacon
    {"Kukoricát imádom, szóval az is kell.", "Kukoricát is kérnék rá.", "Csemegekukorica is mehet rá, jó sok.", "Még mielőtt elfelejteném, a csemegekukoricát ne felejtsd le róla. ", "Azért szólhatnál, hogy a kukoricát majdnem elfelejtettem..."}, -- kukorica
    {"Gombával még nem kóstoltam, kérnék azt is rá.", "Gombát amúgy nem nagyon csípom, de pizzán valahogy szeretem, szóval kérnék rá azt is.", "Gomba, de csak elfogadható mennyiségben.", "Pár gomba is mehet rá, de ne vidd túlzásba."}, -- gomba
    {"Sonkát kérnék rá, ez alap.", "Sonka nem maradhat ki.", "Sonka az ilyen alap, azt is mondani kell?!.", "I want some ham..., ömm, izé, sonkát kérnék, ham-ham."}, -- sonka
    {"Lehet rá tojást kérni? Jöhet!"," Mi legyen a következő... tojás? Teszteljük, jöhet.", "Tojást lehet kérni rá? Rakj rá, nézzük meg milyen.", "Tojás mehet rá, de vigyázz, hogy a sárgája egyben legyen.", "Tojást kérnék rá, de ne süljön túl."}, -- tojás
    {"Lilahagymát ne felejtsd ki.", "Akkor legyen mondjuk még lilahagyma.", "Hagyma mehet rá, abból is csak a lila-féle.", "Hajrá lilák! Csak a lilahagyma."}, -- lilahagyma
    {"Sokan mondják, hogy ananász pizzán nem pizza, de én szeretem.", "Hmmm, mi legyen még... Mondjuk ananász.", "Kérek szépen ananászt rá.", "Tudtad, hogy az ananászt gyümölcskirálynak is nevezték valamikor?"}, -- ananász
    {"Fogyózom', szóval brokkolit is kérnék rá.", "Testünkre vigyázni kell, kis brokkoli feltét is lehet.", "Rakj még rá brokkolit, de csakis a borsodit!"}, -- brokkoli
    {"Finom babot kérnék.", "Minőségi bab is rá kerülhet.", "Bélszerv-mozgató babot kérnék rá."}, -- bab
    {"Gyros hús legyen rajta.", "Laktató legyen, úgyhogy csapassál rá gyros húst.", "Gyroshús mehet rá, de nekem nehogy nyers legyen!", "Jól átsült gyroshúst tegyél rá babám!"}, -- gyros hús
    {"Jalapeno jöhet, de aztán csípje a számat!", "Nagyon csípős Jalapenot kérnék rá.", "Jalapeno paprikát kérnék, viszont valami kevésbé csípőset légyszíves.", "Mexikói jalapeno paprika mehet még rá, hogy jó ízletes és csípős legyen."}, -- jalapeno
}

function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
end

skins = {2, 7, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 25, 27, 28, 29, 30, 32, 35, 36, 37, 40, 41, 44, 55, 56, 58, 59, 60, 67, 80, 83, 87, 90, 91, 92, 100, 101, 111, 112, 122, 123, 124, 133, 142, 147, 151, 170, 182, 183, 188}

-- fat / fatwalk
-- ped / walk_fat
-- ped / walk_civi
-- ped / walk_drunk
-- ped / walk_fatold
-- ped / walk_gang1
-- ped / walk_gang2

-- ped / WOMAN_walknorm
walks = {
    [1] = {group = "ped", name = "walk_civi"},
    [2] = {group = "ped", name = "walk_drunk"},
    [7] = {group = "ped", name = "WOMAN_walknorm"},
    [9] = {group = "ped", name = "WOMAN_walknorm"},
    [12] = {group = "ped", name = "WOMAN_walknorm"},
    [13] = {group = "ped", name = "WOMAN_walknorm"},
    [14] = {group = "ped", name = "WOMAN_walknorm"},
    [15] = {group = "ped", name = "walk_civi"},
    [16] = {group = "ped", name = "walk_gang1"},    
    [17] = {group = "ped", name = "WOMAN_walknorm"},
    [18] = {group = "ped", name = "WOMAN_walknorm"},
    [19] = {group = "ped", name = "WOMAN_walknorm"},
    [20] = {group = "ped", name = "walk_gang2"},
    [21] = {group = "ped", name = "walk_gang2"},
    [22] = {group = "ped", name = "walk_gang2"},
    [23] = {group = "ped", name = "walk_gang2"},
    [24] = {group = "ped", name = "walk_gang2"},
    [25] = {group = "ped", name = "WOMAN_walknorm"},
    [27] = {group = "ped", name = "walk_civi"},
    [28] = {group = "ped", name = "walk_civi"},
    [29] = {group = "ped", name = "walk_gang1"},
    [30] = {group = "ped", name = "fatwalk"},
    [32] = {group = "ped", name = "walk_civi"},
    [35] = {group = "ped", name = "walk_civi"},
    [36] = {group = "ped", name = "walk_civi"},
    [37] = {group = "ped", name = "walk_civi"},
    [41] = {group = "ped", name = "WOMAN_walknorm"},
    [44] = {group = "ped", name = "walk_drunk"},
    [55] = {group = "ped", name = "WOMAN_walknorm"},
    [56] = {group = "ped", name = "WOMAN_walknorm"},
    [58] = {group = "ped", name = "walk_civi"},
    [59] = {group = "ped", name = "walk_civi"},
    [60] = {group = "ped", name = "walk_civi"},
    [67] = {group = "ped", name = "walk_civi"},
    [80] = {group = "ped", name = "walk_fatold"},
    [83] = {group = "ped", name = "walk_civi"},
    [87] = {group = "ped", name = "walk_civi"},
    [90] = {group = "ped", name = "walk_gang2"},
    [91] = {group = "ped", name = "WOMAN_walknorm"},
    [92] = {group = "ped", name = "walk_drunk"},
    [100] = {group = "ped", name = "walk_gang1"},
    [101] = {group = "ped", name = "walk_gang1"},
    [111] = {group = "ped", name = "walk_fatold"},
    [112] = {group = "ped", name = "walk_fatold"},
    [122] = {group = "ped", name = "walk_fatold"},
    [123] = {group = "ped", name = "walk_civi"},
    [124] = {group = "ped", name = "walk_civi"},
    [133] = {group = "ped", name = "walk_civi"},
    [142] = {group = "ped", name = "walk_civi"},
    [147] = {group = "ped", name = "walk_civi"},
    [151] = {group = "ped", name = "WOMAN_walknorm"},
    [170] = {group = "ped", name = "walk_civi"},
    [182] = {group = "ped", name = "walk_civi"},
    [183] = {group = "ped", name = "walk_civi"},
    [188] = {group = "ped", name = "walk_civi"},
}

carryToggleControlls = {"fire", "jump", "sprint", "crouch"}