-- enemy.lua
enemy = {}

function enemy.randomxy()
	local a
	randomx = love.math.random(12, 18)
	randomy = love.math.random(1, 8)
	
	return randomx, randomy
end

function enemy.load()
	local a
	local randomx, randomy
	enemy.count = 5
	enemy.tmrani = 0.4
	enemy.speed = 100
	for a = 1, enemy.count do
		randomx, randomy = enemy.randomxy()
		enemy.new(a, randomx * 32, randomy * 32, 10, 0, false)
	end
end

function enemy.new(index, x, y, habitx, habity)
	enemy[index] = {}
	enemy[index]["x"] = x
	enemy[index]["y"] = y
	enemy[index]["habitx"] = habitx
	enemy[index]["habity"] = habity
	enemy[index]["state"] = "live" --live/pow/dead
	enemy[index]["direction"] = nil
	enemy[index]["distance"] = 0
	enemy[index]["animation"] = 1
end

function enemy.move(direction, speed, index)
	local fakex, fakey
	local tx1, tx2, ty1, ty2
	local a
	
	fakex = enemy[index].x
	fakey = enemy[index].y
	
	if direction == "left" then
		fakex = fakex - speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 0))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 1))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakex = tx1 * 32 - 4
			enemy[index].distance = 0 --blocked!
		end
		
		if fakex - (map.scrollx * 32) <= 0 then
			fakex = map.scrollx * 32
			enemy[index].distance = 0 --blocked!
		end
	elseif direction == "right" then
		fakex = fakex + speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 2))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 3))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakex = (tx1 * 32) - 32 - 32 + 4
			enemy[index].distance = 0 --blocked!
		end

	elseif direction == "up" then
		fakey = fakey - speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 0))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 2))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakey = ty1 * 32 - 4
			enemy[index].distance = 0 --blocked!
		end
		
	elseif direction == "down" then
		fakey = fakey + speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 1))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 3))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakey = (ty1 * 32) - 32 - 32 + 4
			enemy[index].distance = 0 --blocked!
		end
	
	elseif direction == "rest" then
		--do nothing

	end
	
	enemy[index].x = fakex
	enemy[index].y = fakey
end

function enemy.update(dt)
	local a
	local tmp
	local swordx, swordy, swordwith, swordheight
	local playeroffsetx, playeroffsety
	
	playeroffsetx = 0
	playeroffsety = 0
	--in checking collision with player, check if player is attacking. if attacking and collision with sword, kill enemy
	--check collision with player. if collide, reduce player's heart by 1, make player invincible, and knock back player by 5 pixel.
	
	--drop triforce piece randomly, and reduce enemy.count by 1
	
	--animation
	enemy.tmrani = enemy.tmrani - dt
	if enemy.tmrani <= 0 then
		enemy.tmrani = 0.4
		for a = 1, #enemy do
			if (enemy[a]["habitx"] == map.scrollx) and (enemy[a]["habity"] == map.scrolly) then
				if enemy[a]["state"] == "live" then
					--animation
					if enemy[a]["animation"] == 1 then
						enemy[a]["animation"] = 2
					elseif enemy[a]["animation"] == 2 then
						enemy[a]["animation"] = 1
					end
				elseif enemy[a]["state"] == "pow" then
					enemy[a]["state"] = "dead"
					if not(item.pieces == 0) then
						tmp = love.math.random(1, 4)
						if tmp == 3 then
							item.pieces = item.pieces - 1
							item.new(1, math.floor(enemy[a]["x"] / 32), math.floor(enemy[a]["y"] / 32))
						end
					end
				end
			end
		end	
	end
	
	--update enemy
	for a = 1, #enemy do
		if (enemy[a]["habitx"] == map.scrollx) and (enemy[a]["habity"] == map.scrolly) then
			if enemy[a].state == "live" then
				--move
				if enemy[a].distance <= 0 then
					tmp = love.math.random(1, 5)
					if tmp == 1 then
						enemy[a].direction = "up"
					elseif tmp == 2 then
						enemy[a].direction = "down"
					elseif tmp == 3 then
						enemy[a].direction = "left"
					elseif tmp == 4 then
						enemy[a].direction = "right"
					elseif tmp == 5 then
						enemy[a].direction = "rest"
					end
					enemy[a].distance = math.floor(love.math.random(48, 144) / 48) * 48
				end
				enemy.move(enemy[a].direction, enemy.speed * dt, a)
				enemy[a].distance = enemy[a].distance - enemy.speed * dt
				
				--prepare player's location
				if player.state == "attack" then
					if player.direction == "up" then
						swordx = player.x + 0
						swordy = player.y - 32
						swordwidth = 16
						swordheight = 32
						playeroffsety = 32
					elseif player.direction == "down" then
						swordx = player.x + 16
						swordy = player.y + 32
						swordwidth = 16
						swordheight = 32
					elseif player.direction == "left" then
						swordx = player.x - 32
						swordy = player.y + 16
						swordwidth = 32
						swordheight = 16
						playeroffsetx = 32
					elseif player.direction == "right" then
						swordx = player.x + 32
						swordy = player.y + 16
						swordwidth = 32
						swordheight = 16
					end
				end
				
				--check collision with player
				if not(player.state == "die") then
					if player.invincible == false then
						if collision.check(player.x + 4 + playeroffsetx, player.y + 4 + playeroffsety, 32 - 8, 32 - 8, enemy[a]["x"] - 2, enemy[a]["y"] - 2, 32 - 4, 32 - 4) == true then
							--damage player
							player.health = player.health - 1
							player.invincible = true
							enemy[a].distance = 0
							if player.health == 0 then
								player.die()
							end
						end
					end
				end
				
				-- check collision with player's sword
				if player.state == "attack" then
					if collision.check(swordx + playeroffsetx, swordy + playeroffsety, swordwidth, swordheight, enemy[a]["x"], enemy[a]["y"], 32, 32) == true then
						--kill monster
						enemy[a]["state"] = "pow"
						enemy.move(player.direction, 15, a)
						effect.play(2)
					end
				end
			end
		end
	end
end

function enemy.draw()
	local a
	for a = 1, #enemy do
		if (enemy[a]["habitx"] == map.scrollx) and (enemy[a]["habity"] == map.scrolly) then
			if enemy[a]["state"] == "live" then
				love.graphics.draw(imgenemy[enemy[a]["animation"]], enemy[a].x - (map.scrollx * 32), enemy[a].y - (map.scrolly * 32))
			elseif enemy[a]["state"] == "pow" then
				love.graphics.draw(imgenemy[3], enemy[a].x - (map.scrollx * 32), enemy[a].y - (map.scrolly * 32))
			end
		end
	end	
end