-- map.lua
map = {}

function map.load()
	local a
	local b
	
	for a = 1, 3 do
		map[a] = {}
	end
	
	map[1]["width"] = 20
	map[1]["height"] = 20
	
	map[2]["width"] = 10
	map[2]["height"] = 10
	
	map[3]["width"] = 10
	map[3]["height"] = 10
	
	for a = 1, 20 do
		map[1][a] = {}
		for b = 1, 20 do
			map[1][a][b] = 1 --1:brown ground 2:door 3:passable wall 4:black ground 5:wall
		end
	end
	
	for a = 1, 10 do
		map[2][a] = {}
		map[3][a] = {}
		for b = 1, 10 do
			map[2][a][b] = 4
			map[3][a][b] = 4
		end
	end

	-- door
	map[1]["door"] = {}
	map[1]["door"][1] = {}
	map[1]["door"][1]["x"] = 4
	map[1]["door"][1]["y"] = 4
	map[1]["door"][1]["direction"] = 2
	map[1]["door"][2] = {}
	map[1]["door"][2]["x"] = 18
	map[1]["door"][2]["y"] = 17
	map[1]["door"][2]["direction"] = 3
	
	map[2]["door"] = {}
	map[2]["door"][1] = {}
	map[2]["door"][1]["x"] = 0
	map[2]["door"][1]["y"] = 0
	map[2]["door"][1]["direction"] = 1
	map[2]["door"][2] = {}
	map[2]["door"][2]["x"] = 0
	map[2]["door"][2]["y"] = 0
	map[2]["door"][2]["direction"] = 1
	
	map[3]["door"] = {}
	map[3]["door"][1] = {}
	map[3]["door"][1]["x"] = 0
	map[3]["door"][1]["y"] = 0
	map[3]["door"][1]["direction"] = 1
	map[3]["door"][2] = {}
	map[3]["door"][2]["x"] = 0
	map[3]["door"][2]["y"] = 0
	map[3]["door"][2]["direction"] = 1
	
	--map of field
	for a = 1, 20 do
		map[1][a][1] = 5
		map[1][a][20] = 5
		map[1][1][a] = 5
		map[1][20][a] = 5
	end
	
	for b = 2, 4 do
		for a = 2, 5 do
			map[1][a][b] = 5
		end
	end
	map[1][4][3] = 3
	map[1][4][4] = 2
	
	map[1][5][10] = 5
	map[1][5][11] = 5
	map[1][7][10] = 5
	map[1][7][11] = 5
	for a = 10, 20 do
		map[1][a][10] = 5
		map[1][a][11] = 5
	end
	
	map[1][10][4] = 5
	map[1][10][5] = 5
	map[1][11][4] = 5
	map[1][11][5] = 5
	
	map[1][3][13] = 5
	map[1][3][14] = 5
	map[1][3][15] = 5
	map[1][4][15] = 5
	map[1][5][15] = 5
	
	map[1][8][16] = 5
	map[1][8][17] = 5
	map[1][8][18] = 5
	map[1][7][18] = 5
	map[1][6][18] = 5
	
	map[1][16][17] = 5
	map[1][16][17] = 5
	map[1][17][17] = 5
	map[1][18][17] = 5
	map[1][19][17] = 5
	map[1][17][16] = 5
	map[1][18][16] = 5
	map[1][19][16] = 5
	map[1][17][15] = 5
	map[1][18][15] = 5
	map[1][19][15] = 5
	
	map[1][18][16] = 3
	map[1][18][17] = 2
	
	--map of boss room
	
	for a = 1, 10 do
		map[2][a][1] = 5
		map[2][a][10] = 5
		map[2][1][a] = 5
		map[2][10][a] = 5
		
		map[3][a][1] = 5
		map[3][a][10] = 5
		map[3][1][a] = 5
		map[3][10][a] = 5
	end
	map[2][5][10] = 2
	map[3][5][10] = 2
	
	--map of item room
	map[3][2][4] = 5
	map[3][3][4] = 5
	map[3][8][4] = 5
	map[3][9][4] = 5
	
	map.screenheight = 10
	map.screenwidth = 10
	map.scrollx = 0
	map.scrolly = 0
	map.scrollamx = 0 --if you wanna scroll map x tiles, change this value to not 0
	map.scrollamy = 0 --if you wanna scroll map y tiles, change this value to not 0
	--example: map.scrollamx = 10 (scroll 10 tiles right left)
	map.scrolltimer = 0
	
	map.current = 1
end

function map.scroll(direction)
	local a
	if direction == "left" then
		if map.scrollx == 0 then
			return
		end
		map.scrollx = map.scrollx - 1
	elseif direction == "right" then
		if map.scrollx == 10 then
			return
		end
		map.scrollx = map.scrollx + 1
	elseif direction == "up" then
		if map.scrolly == 0 then
			return
		end
		map.scrolly = map.scrolly - 1
	elseif direction == "down" then
		if map.scrolly == 10 then
			return
		end
		map.scrolly = map.scrolly + 1
	end
	
	for a = 1, #enemy do
		if (enemy[a]["habitx"] == map.scrollx) and (enemy[a]["habity"] == map.scrolly) then
			enemy.load()
			break
		end
	end
end

function map.draw()
	local a
	local b
	for b = 1, map.screenheight do
		for a = 1, map.screenwidth do
			if map.current == 1 then --on field
				love.graphics.draw(imgtile[map[map.current][a + map.scrollx][b + map.scrolly]], (a - 1) * 32, (b - 1) * 32)
			else --room: no scrolling
				love.graphics.draw(imgtile[map[map.current][a][b]], (a - 1) * 32, (b - 1) * 32)
			end
		end
	end
end