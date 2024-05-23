tex = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

cache = {
    paintjobs = {},
}

tex = dxCreateShader(tex)

function createWeaponPaintJob(weapon, texture, replace)
    if not cache.paintsjobs[texture] then cache.paintsjobs[texture] = dxCreateShader('/assets/'..texture..'.png') end
    dxSetShaderValue(tex, "tex", texture)
    engineApplyShaderToWorldTexture(tex, "*remap*", weapon)
end


function destoryWeaponPaintJob(weapon, texture, replace)

end