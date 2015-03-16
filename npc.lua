-- npc.lua

npc = {}

function npc.load()
	npc.new(3, 4, 3, "Take this,\nand please defeat Lot the Slime!")
end

function npc.new(map, x, y, saying)
	npc[#npc + 1] = {}
	npc[#npc]["map"] = map
	npc[#npc]["x"] = x
	npc[#npc]["y"] = y
	npc[#npc]["trigger"] = false
	npc[#npc]["saying"] = saying
end

function npc.update(dt)
	local a
	for a = 1, #npc do
		if npc[a]["map"] == map.current then
			if collision.check(player.x, player.y, 32, 32, npc[a]["x"] * 32, npc[a]["y"] * 32, 32, 32) == true then
				npc[a]["trigger"] = true
			end
		end
	end
end

function npc.bye()
	local a
	for a = 1, #npc do
		npc[a]["trigger"] = false
	end
end

function npc.draw()
	local a
	for a = 1, #npc do
		if npc[a]["map"] == map.current then
			love.graphics.draw(imgnpc, npc[a]["x"] * 32, npc[a]["y"] * 32)
			if npc[a]["trigger"] == true then
				love.graphics.print(npc[a]["saying"], 37, 37)
			end
		end
	end	
end