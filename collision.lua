-- collision.lua
collision = {}

function collision.objtocorner(x, y, direction)
	if direction == "leftup" or direction == 0 then
		return x + 4, y + 4
	elseif direction == "leftdown" or direction == 1 then
		return x + 4, y - 4 + 32 - 1
	elseif direction == "rightup" or direction == 2 then
		return x - 4 + 32 - 1, y + 4
	elseif direction == "rightdown" or direction == 3 then
		return x - 4 + 32 - 1, y - 4 + 32 - 1
	end
end

function collision.postotile(x, y)
	local tx, ty
	tx = math.floor(x / 32) + 1
	ty = math.floor(y / 32) + 1
	return tx, ty
end

function collision.check(pic1x, pic1y, pic1width, pic1height, pic2x, pic2y, pic2width, pic2height)
-- check pix1 and pix2 are collide
-- usage: collcheck(blabla~) => true|false
    if (pic1x + pic1width) > pic2x and pic1x < (pic2x + pic2width) then
        if (pic1y + pic1height) > pic2y and pic1y < (pic2y + pic2height) then
            return true
        end
    end

	return false
end