-- player.lua
player = {}

function player.load()
	player.direction = "down"
	player.state = "stop" --stop/walk/attack/enter/item/die
	player.tmrani = 0
	player.animation = 1
	player.x = 160
	player.y = 160
	player.health = 3
	player.triforce = 0
	player.speed = 120
	player.invincible = false
	player.blink = false
	player.tmrinvin = 0
	player.tmrblink = 0
	player.tmrdeath = 0
	player.victory = false
	player.tmrvictory = 0
end

function player.update(dt)
	local a
	
	--invincible!
	if player.invincible == true then
		player.tmrinvin = player.tmrinvin + dt
		if player.tmrinvin >= 1 then
			player.tmrinvin = 0
			player.blink = false
			player.tmrblink = 0
			player.invincible = false
		end
		
		player.tmrblink = player.tmrblink + dt
		if player.tmrblink >= 0.1 then
			player.tmrblink = player.tmrblink - 0.1
			if player.blink == false then
				player.blink = true
			else
				player.blink = false
			end
		end
	end
	
	--move player
	if (player.state == "stop") or (player.state == "walk") then
		if love.keyboard.isDown("left") then
			player.move("left", player.speed * dt)
		elseif love.keyboard.isDown("right") then
			player.move("right", player.speed * dt)
		elseif love.keyboard.isDown("up") then
			player.move("up", player.speed * dt)
		elseif love.keyboard.isDown("down") then
			player.move("down", player.speed * dt)
		else
			player.stop()
		end
	end
	
	--attack
	if (player.state == "stop") or (player.state == "walk") then
		if love.keyboard.isDown("z") then
			player.attack()
		end
	end
	
	--player animation
	if player.state == "walk" then
		player.tmrani = player.tmrani + dt
		if player.tmrani >= 0.2 then
			player.tmrani = player.tmrani - 0.2
			if player.animation == 4 then
				player.animation = 1
			else
				player.animation = player.animation + 1
			end
		end
	elseif player.state == "attack" then
		player.tmrani = player.tmrani - dt
		if player.tmrani <= 0 then
			if player.direction == "up" then
				player.y = player.y + 32
			elseif player.direction == "left" then
				player.x = player.x + 32
			end
			player.stop()
		end
	elseif player.state == "enter" then
		player.tmrani = player.tmrani + dt
		if player.tmrani >= 0.2 then
			player.tmrani  = player.tmrani - 0.2
			if player.animation == 5 then
				for a = 1, 2 do
					if collision.check(player.x, player.y, 32, 32, (map[map.current]["door"][a]["x"] - 1) * 32, (map[map.current]["door"][a]["y"] - 1) * 32, 32, 32) == true then
						player.x = (map[map.current]["door"][a]["x"] - 1) * 32
						player.y = (map[map.current]["door"][a]["y"] - 1) * 32
						player.state = "enter"
						player.tmrani = 0
						player.direction = "enter"
						player.animation = 1
						
						map.current = map[map.current]["door"][a]["direction"]
						player.direction = "up"
						player.stop()
						player.x = 4 * 32
						player.y = 9 * 32
						
						if map.current == 2 then
							sound.play(4)
						elseif map.current == 3 then
							sound.play(3)
						end
						
						if map.current == 2 then --boss room
							boss.load()
						end
						print(map.current)
					end
				end
			else
				player.animation = player.animation + 1
			end
		end
	elseif player.state == "item" then
		player.tmrani = player.tmrani - dt
		if player.tmrani <= 0 then
			player.stop()
			player.triforce = player.triforce + 1
		end
	elseif player.state == "die" then
		player.tmrdeath = player.tmrdeath + dt
		if player.tmrdeath >= 3 then
			scene.transition(2)
		end
	end
end

function player.stop()
	player.state = "stop"
	player.animation = 1
end

function player.get()
	player.state = "item"
	player.tmrani = 2.5
end

function player.die()
	--kill player
	if not (player.state == "die") then
		player.state = "die"
		player.tmrdeath = 0
	end
end

function player.attack()
	player.state = "attack"
	player.animation = "attack"
	player.tmrani = 0.3
	if player.direction == "up" then
		player.y = player.y - 32
	elseif player.direction == "left" then
		player.x = player.x - 32
	end
end

function player.move(direction, speed)
	local fakex, fakey
	local tx1, tx2, ty1, ty2
	local a
	
	player.state = "walk"
	player.direction = direction
	
	fakex = player.x
	fakey = player.y
	
	if direction == "left" then
		fakex = player.x - speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 0))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 1))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakex = tx1 * 32 - 4
		end
		
		if fakex - (map.scrollx * 32) <= -16 then
			if map.current == 1 then 
				map.scrollamx = -10
			end
		end
	elseif direction == "right" then
		fakex = player.x + speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 2))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 3))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakex = (tx1 * 32) - 32 - 32 + 4
		end
		
		if fakex - (map.scrollx * 32) >= 304 then
			if map.current == 1 then 
				map.scrollamx = 10
			end
		end
	elseif direction == "up" then
		fakey = player.y - speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 0))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 2))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakey = ty1 * 32 - 4
		end
		
		if fakey - (map.scrolly * 32) <= -16 then
			if map.current == 1 then 
				map.scrollamy = -10
			end
		end
	elseif direction == "down" then
		fakey = player.y + speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 1))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 3))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakey = (ty1 * 32) - 32 - 32 + 4
		end
		
		if map.current == 1 then
			if fakey - (map.scrolly * 32) >= 304 then
				if map.current == 1 then 
					map.scrollamy = 10
				end
			end
		else --move out to field
			if fakey >= 304 then
				for a = 1, 2 do
					if map[1]["door"][a]["direction"] == map.current then
						map.current = 1
						fakex = (map[1]["door"][a]["x"] - 1) * 32
						fakey = (map[1]["door"][a]["y"] - 1) * 32
						player.direction = "down"
						npc.bye()
						sound.play(2)
					end
				end
			end
		end
		
		
	end
	
	player.x = fakex
	player.y = fakey
	
	--collision detection with door
	for a = 1, 2 do
		if collision.check(player.x, player.y, 32, 32, (map[map.current]["door"][a]["x"] - 1) * 32, (map[map.current]["door"][a]["y"] - 2) * 32, 32, 32) == true then
			player.x = (map[map.current]["door"][a]["x"] - 1) * 32
			player.y = (map[map.current]["door"][a]["y"] - 1) * 32
			player.state = "enter"
			player.tmrani = 0
			player.direction = "enter"
			player.animation = 1
		end
	end
	
end

function player.draw()
	if player.blink == false then
		if map.current == 1 then
			if player.state == "item" then
				love.graphics.draw(imgtriforce, player.x - (map.scrollx * 32), player.y - (map.scrolly * 32) - 32)
				love.graphics.draw(imgplayer["item"], player.x - (map.scrollx * 32), player.y - (map.scrolly * 32))
			elseif player.state == "die" then
				love.graphics.draw(imgplayer["dead"], player.x - (map.scrollx * 32), player.y - (map.scrolly * 32))
			else
				love.graphics.draw(imgplayer[player.direction][player.animation], player.x - (map.scrollx * 32), player.y - (map.scrolly * 32))
			end
		else --ignore scroll in room
			if player.state == "item" then
				love.graphics.draw(imgtriforce, player.x, player.y - 32)
				love.graphics.draw(imgplayer["item"], player.x, player.y)
			elseif player.state == "die" then
				love.graphics.draw(imgplayer["dead"], player.x, player.y)
			else
				love.graphics.draw(imgplayer[player.direction][player.animation], player.x, player.y)
			end
		end
	end
end