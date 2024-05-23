hifiObject = 2103
soundMultiplier = 2.5

lines = 16

core = exports.oCore
color, r, g, b = core:getServerColor()

font = exports.oFont

chat = exports.oChat

stations = {
   -- {"MagicRádió", "http://playing.magicradio.net:14210/adas.mp3"},
    {"Rádió 1", "https://icast.connectmedia.hu/5201/live.mp3"},
    {"Retró rádió", "https://icast.connectmedia.hu/5001/live.mp3"},
    {"Petőfi rádió", "https://icast.connectmedia.hu/4738/mr2.mp3"},
    {"Sláger FM", "https://slagerfm.netregator.hu:7813/slagerfm128.mp3"},
    {"MegaDance Rádió", "https://gamershouse.hu:8080/livemega.mp3"},
    {"Bátyus FM", "https://node-35.zeno.fm/u6v02bbc9f0uv.aac?rj-ttl=5&rj-tok=AAABdhPj_lcAE9_OuhuiBLQ1LQ"},
    {"Best FM", "https://icast.connectmedia.hu/5101/live.mp3"},
    {"MixRadio", "http://adas.adasszerver.hu:80/live"},
    {"Magyar Mulatós Rádió", "http://radio.orszagnet.hu:8030/live"},
    {"ISIS Rádió", "http://92.61.114.191:9651/stream"},
    {"Mex Rádió", "https://stream.mexradio.hu:8014/stream"},
    -- újak
    {"Rise FM", "http://188.165.11.30:8080/risefm_hq"},
    {"Base FM", "https://icast.connectmedia.hu/5401/live.mp3"},
    {"bigFM Oldschool Rap&Hip-Hop", "https://streams.bigfm.de/bigfm-oldschool-128-mp3?usid=0-0-H-M-D-02"},
    {"24/7 Reggae", "https://ssl.shoutcaststreaming.us:8045/;"},
    {"The Hip Hop Station", "https://streaming.radio.co/s97881c7e0/listen"},
    {"06AM Ibiza Underground Radio", "https://streams.radio.co/sd1bcd1376/listen"},
    {"Urban Hitz Radio", "https://str2b.openstream.co/691?aw_...8&stationId=5838&publisherId=715&k=1610056433"},
}

attachableVehicleModels = {
    --[422] = true,
}

intCustomHifis = {
    [2226] = {_},
	[2099] = {1.1, -0.4, _, 0.15},
	[2100] = {1.1, -0.25, _, 0.2},

	[2103] = {0.4, 0, 16, 0},

	[2101] = {0.6, 0, 11, 0.025},
	[2225] = {0.9, -0.25, 13, -0.12},
	[2227] = {1, -0.35, 6, -0.25},
}