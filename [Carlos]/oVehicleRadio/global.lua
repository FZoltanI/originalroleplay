font = exports.oFont
core = exports.oCore
color, r, g, b = core:getServerColor()

stations = {
    --{"MagicRádió", "http://playing.magicradio.net:14210/adas.mp3", 0},
    {"Rádió 1", "https://icast.connectmedia.hu/5201/live.mp3", 0},
    --{"Retró rádió", "http://stream.retroradio.hu/mid.mp3", 0},
    {"Petőfi rádió", "https://icast.connectmedia.hu/4738/mr2.mp3", 0},
    --{"Best FM", "https://stream1.bestfmbudapest.hu:443/bestfm_128.mp3", 0},
    {"Mega Dance", "http://megadanceradio.hopto.org:8000/livemega.mp3", 0},
    {"Sláger FM", "http://92.61.114.159:7812/slagerfm256.mp3", 0},
    {"Szünet Rádió", "http://92.61.114.191:1101/stream", 0},
    {"Klubrádió", "http://stream.klubradio.hu:8080/bpstream", 0},
    --{"Radio Record - Hardbass", "https://air.radiorecord.ru:805/hbass_128", 0},
    --{"Bátyus FM", "https://node-35.zeno.fm/u6v02bbc9f0uv.aac?rj-ttl=5&rj-tok=AAABdhPj_lcAE9_OuhuiBLQ1LQ", 0},

    {"PulsRadio", "https://sc4.gergosnet.com/pulsHD.mp3", 0},
    {"I love the beach", "https://streams.ilovemusic.de/iloveradio7.mp3", 0},
    {"Crucial Velocity Radio", "https://ais-sa2.cdnstream1.com/1369_128", 0},
    {"American Roots", "https://igor.torontocast.com:1945/stream", 0},
    {"06AM Ibiza Underground Radio", "https://streams.radio.co/sd1bcd1376/listen", 0},
    {"24/7 Reggae", "https://ssl.shoutcaststreaming.us:8045/;", 0},
    --{"Urban Hitz Radio", "https://str2b.openstream.co/691?aw_...8&stationId=5838&publisherId=715&k=1610056433", 0},
    {"The Hip Hop Station", "https://streaming.radio.co/s97881c7e0/listen", 0},
    {"bigFM Oldschool Rap&Hip-Hop", "https://streams.bigfm.de/bigfm-oldschool-128-mp3?usid=0-0-H-M-D-02", 0},
    {"Best FM", "http://stream1.bestfmbudapest.hu/bestfm_128.mp3?time=1609775974", 0},
    {"Rádió88", "http://stream.radio88.hu:8000/;stream.nsv#.mp3?time=16097759", 0},
    {"Mix Rádió", "http://adas.adasszerver.hu/live", 0},
    {"Jazzy Rádió", "https://s04.diazol.hu:9502/live.mp3?time=1609776543", 0},
    {"Dance Wave!", "https://dancewave.online/dance.mp3", 0},
    --{"Mercy Rádió", "http://stream.mercyradio.eu:80/mercyradio.mp3", 0},
    --{"Retro Rádió", "http://stream.retroradio.hu/mid.mp3", 0},
    {"Sunshine FM", "http://stream.composeit.hu:8100/sunshine", 0},
    {"Rise FM", "http://188.165.11.30:8080/risefm_hq", 0},
}