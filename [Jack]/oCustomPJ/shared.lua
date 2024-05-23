stickerTable = {
	['shape'] = {
		{'circle', 250},
	},

	['abc'] = {
		-- texture, price
		{'0', 50},
		{'1', 50},
		{'2', 50},
		{'3', 50},
		{'4', 50},
		{'5', 50},
		{'6', 50},
		{'7', 50},
		{'8', 50},
		{'9', 50},
		{'a', 50},
		{'b', 50},
		{'c', 50},
		{'d', 50},
		{'e', 50},
		{'f', 50},
		{'g', 50},
		{'h', 50},
		{'i', 50},
		{'j', 50},
		{'k', 50},
		{'l', 50},
		{'m', 50},
		{'n', 50},
		{'o', 50},
		{'p', 50},
		{'q', 50},
		{'r', 50},
		{'s', 50},
		{'t', 50},
		{'u', 50},
		{'v', 50},
		{'w', 50},
		{'x', 50},
		{'y', 50},
		{'z', 50},
	},

	['liveries'] = {
		{'liveries/1', 250},
		{'liveries/2', 250},
		{'liveries/3', 250},
		{'liveries/4', 250},
		{'liveries/5', 250},
		{'liveries/6', 250},
		{'liveries/7', 250},
		{'liveries/8', 250},
		{'liveries/9', 250},
		{'liveries/10', 250},
		{'liveries/11', 250},
		{'liveries/12', 250},
		{'liveries/13', 250},
		{'liveries/14', 250},
		{'liveries/15', 250},
		{'liveries/16', 250},
		{'liveries/17', 250},
	},



}

colorableTextures = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"} 

core = exports.oCore
color, r, g, b = core:getServerColor()
fonts = exports.oFont

categories = {'shape','abc','liveries','character','money'}

shader_data = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

function rotateAround(angle, x, y, x2, y2)
	x2 = x2 or 0
	y2 = y2 or 0

	local theta = math.rad(angle)
	local rotatedX = x * math.cos(theta) - y * math.sin(theta) + x2
	local rotatedY = x * math.sin(theta) + y * math.cos(theta) + y2

	return rotatedX, rotatedY
end


function dxDrawCircle3D( x, y, z, radius, segments, color, width ) 
    segments = segments or 16; -- circle is divided into segments -> higher number = smoother circle = more calculations 
    color = color or tocolor( 255, 255, 0 ); 
    width = width or 1; 
    local segAngle = 360 / segments; 
    local fX, fY, tX, tY; -- drawing line: from - to 
    for i = 1, segments do 
    fX = x + math.cos( math.rad( segAngle * i ) ) * radius; 
    fY = y + math.sin( math.rad( segAngle * i ) ) * radius; 
    tX = x + math.cos( math.rad( segAngle * (i+1) ) ) * radius; 
    tY = y + math.sin( math.rad( segAngle * (i+1) ) ) * radius; 
    dxDrawLine3D( fX, fY, z, tX, tY, z, color, width ); 
    end 
end 

function nameCheck(player, name)
	if ( getPlayerName ( player ) == name ) then
		return true
	else
		return false
	end
end

function relX(x)
	return x*game.screen.x
end

function relY(y)
	return y*game.screen.y
end

function valueToRGB(c)
	if(c >= 0 and c <= (1/6)) then
        red = 255;
        green = 1530 * c;
        blue = 0;
    elseif( c > (1/6) and c <= (1/3) )then
        red = 255 - (1530 * (c - 1/6));
        green = 255;
        blue = 0;
	elseif( c > (1/3) and c <= (1/2))then
        red = 0;
        green = 255;
        blue = 1530 * (c - 1/3);
    elseif(c > (1/2)and c <= (2/3))then
        red = 0;
        green = 255 - ((c - 0.5) * 1530);
        blue = 255;
	elseif( c > (2/3) and c <= (5/6) )then
        red = (c - (2/3)) * 1530;
        green = 0;
        blue = 255;
    elseif(c > (5/6) and c <= 1 )then
        red = 255;
        green = 0;
        blue = 255 - ((c - (5/6)) * 1530);
	end
	return red, green, blue
end