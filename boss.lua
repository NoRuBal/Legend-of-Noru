-- boss.lua
boss = {}

function boss.load()
	boss.x = 3 * 48
	boss.y = 3 * 48
	boss.hp = 3
	boss.state = "live" --live/pow/dead
	boss.direction = nil
	boss.distance = 0
	boss.animation = 1
	boss.tmrani = 0
	boss.speed = 100
end


function boss.move(direction, speed)
	local fakex, fakey
	local tx1, tx2, ty1, ty2
	local a
	
	fakex = boss.x
	fakey = boss.y
	
	if direction == "left" then
		fakex = fakex - speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 0))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 1))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakex = tx1 * 32 - 4
			boss.distance = 0 --blocked!
		end

	elseif direction == "right" then
		fakex = fakex + speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 2))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 3))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakex = (tx1 * 32) - 32 - 32 + 4
			boss.distance = 0 --blocked!
		end

	elseif direction == "up" then
		fakey = fakey - speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 0))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 2))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakey = ty1 * 32 - 4
			boss.distance = 0 --blocked!
		end
		
	elseif direction == "down" then
		fakey = fakey + speed
		
		tx1, ty1 = collision.postotile(collision.objtocorner(fakex, fakey, 1))
		tx2, ty2 = collision.postotile(collision.objtocorner(fakex, fakey, 3))
		
		if map[map.current][tx1][ty1] == 5 or map[map.current][tx2][ty2] == 5 then
			fakey = (ty1 * 32) - 32 - 32 + 4
			boss.distance = 0 --blocked!
		end
		
		if fakey >= 272 then
			fakey = 272
			boss.distance = 0 --blocked!
		end
	
	elseif direction == "rest" then
		--do nothing

	end
	
	boss.x = fakex
	boss.y = fakey
end

function boss.update(dt)
	--in checking collision with player, check if player is attacking. if attacking and collision with sword, reduce boss's hp
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
	boss.tmrani = boss.tmrani - dt
	if boss.tmrani <= 0 then
		boss.tmrani = 0.4
		if boss.state == "live" then
			--animation
			if boss["animation"] == 1 then
				boss["animation"] = 2
			elseif boss["animation"] == 2 then
				boss["animation"] = 1
			end
		elseif boss["state"] == "pow" then
			if boss.hp == 0 then
				boss.state = "dead"
				--cutscene
				player.victory = true
				player.tmrvictory = 0
			else
				if player.triforce == 3 then --cannot damage boss unless have 3 triforce pieces
					boss.hp = boss.hp - 1
				end
				boss.state = "live"
			end
		end
	end
	
	--update boss
	if boss.state == "live" then
		--move
		if boss.distance <= 0 then
			tmp = love.math.random(1, 2)
			if tmp == 1 then
				if boss.y > player.y then
					boss.direction = "up"
				elseif boss.y < player.y then
					boss.direction = "down"
				elseif boss.x > player.x == 3 then
					boss.direction = "left"
				elseif boss.x < player.x then
					boss.direction = "right"
				else
					boss.direction = "rest"
				end
			elseif tmp == 2 then
				if boss.x > player.x then
					boss.direction = "left"
				elseif boss.x < player.x then
					boss.direction = "right"
				elseif boss.y > player.y then
					boss.direction = "up"
				elseif boss.y < player.y then
					boss.direction = "down"
				else
					boss.direction = "rest"
				end
			end
			boss.distance = 48
		end
		boss.move(boss.direction, boss.speed * dt)
		boss.distance = boss.distance - boss.speed * dt
		
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
				if collision.check(player.x + 4 + playeroffsetx, player.y + 4 + playeroffsety, 32 - 8, 32 - 8, boss["x"] - 2, boss["y"] - 2, 32 - 4, 32 - 4) == true then
					--damage player
					player.health = player.health - 1
					player.invincible = true
					boss.distance = 0
					if player.health == 0 then
						player.die()
					end
				end
			end
		end
		-- check collision with player's sword
		if boss.state == "live" then
			if player.state == "attack" then
				if collision.check(swordx + playeroffsetx, swordy + playeroffsety, swordwidth, swordheight, boss["x"], boss["y"], 32, 32) == true then
					--kill monster
					boss["state"] = "pow"
					boss.move(player.direction, 15)
					effect.play(2)
				end
			end
		end
	end
end

function boss.draw()
	if map.current == 2 then
		if boss.state == "live" then
			love.graphics.draw(imgboss[boss["animation"]], boss.x , boss.y)
		elseif boss.state == "pow" then
			love.graphics.draw(imgboss[3], boss.x, boss.y )
		end
	end
end