-- item.lua
item = {}

function item.load()
	item.new(3, 5, 3)
	item.pieces = 2
end

function item.new(map, x, y)
	item[#item + 1] = {}
	item[#item]["map"] = map
	item[#item]["x"] = x
	item[#item]["y"] = y
	item[#item]["trigger"] = false
end

function item.update(dt)
	local a
	for a = 1, #item do
		if item[a]["map"] == map.current then
			if item[a]["trigger"] == false then
				if collision.check(player.x, player.y, 32, 32, item[a]["x"] * 32, item[a]["y"] * 32, 32, 32) == true then
					item[a]["trigger"] = true
					player.get()
				end
			end
		end
	end
end

function item.draw()
	local a
	for a = 1, #item do
		if item[a]["map"] == map.current then
			if item[a]["trigger"] == false then
				if item[a]["map"] == 1 then
					love.graphics.draw(imgtriforce, item[a]["x"] * 32 - map.scrollx * 32, item[a]["y"] * 32 - map.scrolly * 32)
				else
					love.graphics.draw(imgtriforce, item[a]["x"] * 32, item[a]["y"] * 32)
				end
			end
		end
	end	
end