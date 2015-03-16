-- main.lua

require "player"
require "map"
require "collision"
require "enemy"
require "npc"
require "item"
require "boss"
require "scene"

sound = {}
effect = {}

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	fontcms = love.graphics.newFont("graphics/comic.ttf", 12)
	love.graphics.setFont(fontcms)
	
	imgtitle = love.graphics.newImage("graphics/title.png")
	imgover = love.graphics.newImage("graphics/gameover.png")
	imgend = love.graphics.newImage("graphics/ending.png")
	
	imgtile = {}
	imgtile[1] = love.graphics.newImage("graphics/tile/ground.png")
	imgtile[2] = love.graphics.newImage("graphics/tile/door.png")
	imgtile[3] = love.graphics.newImage("graphics/tile/wall.png")
	imgtile[4] = love.graphics.newImage("graphics/tile/door.png")
	imgtile[5] = love.graphics.newImage("graphics/tile/wall.png")
	
	imgplayer = {}
	imgplayer["down"] = {}
	imgplayer["down"][1] = love.graphics.newImage("graphics/player/noru_front_1.png")
	imgplayer["down"][2] = love.graphics.newImage("graphics/player/noru_front_2.png")
	imgplayer["down"][3] = love.graphics.newImage("graphics/player/noru_front_1.png")
	imgplayer["down"][4] = love.graphics.newImage("graphics/player/noru_front_3.png")
	imgplayer["down"]["attack"] = love.graphics.newImage("graphics/player/noru_front_sword.png")
	imgplayer["up"] = {}
	imgplayer["up"][1] = love.graphics.newImage("graphics/player/noru_back_1.png")
	imgplayer["up"][2] = love.graphics.newImage("graphics/player/noru_back_2.png")
	imgplayer["up"][3] = love.graphics.newImage("graphics/player/noru_back_1.png")
	imgplayer["up"][4] = love.graphics.newImage("graphics/player/noru_back_3.png")
	imgplayer["up"]["attack"] = love.graphics.newImage("graphics/player/noru_back_sword.png")
	imgplayer["left"] = {}
	imgplayer["left"][1] = love.graphics.newImage("graphics/player/noru_left_1.png")
	imgplayer["left"][2] = love.graphics.newImage("graphics/player/noru_left_2.png")
	imgplayer["left"][3] = love.graphics.newImage("graphics/player/noru_left_1.png")
	imgplayer["left"][4] = love.graphics.newImage("graphics/player/noru_left_2.png")
	imgplayer["left"]["attack"] = love.graphics.newImage("graphics/player/noru_left_sword.png")
	imgplayer["right"] = {}
	imgplayer["right"][1] = love.graphics.newImage("graphics/player/noru_right_1.png")
	imgplayer["right"][2] = love.graphics.newImage("graphics/player/noru_right_2.png")
	imgplayer["right"][3] = love.graphics.newImage("graphics/player/noru_right_1.png")
	imgplayer["right"][4] = love.graphics.newImage("graphics/player/noru_right_2.png")
	imgplayer["right"]["attack"] = love.graphics.newImage("graphics/player/noru_right_sword.png")
	imgplayer["item"] = love.graphics.newImage("graphics/player/noru_item.png")
	imgplayer["enter"] = {}
	imgplayer["enter"][1] = love.graphics.newImage("graphics/player/noru_enter_1.png")
	imgplayer["enter"][2] = love.graphics.newImage("graphics/player/noru_enter_2.png")
	imgplayer["enter"][3] = love.graphics.newImage("graphics/player/noru_enter_3.png")
	imgplayer["enter"][4] = love.graphics.newImage("graphics/player/noru_enter_4.png")
	imgplayer["enter"][5] = love.graphics.newImage("graphics/player/noru_enter_5.png")
	imgplayer["dead"] = love.graphics.newImage("graphics/player/noru_dead.png")
	
	imgheart = {}
	imgheart[1] = love.graphics.newImage("graphics/item/heart_full.png")
	imgheart[2] = love.graphics.newImage("graphics/item/heart_empty.png")
	imgtriforce = love.graphics.newImage("graphics/item/triforce.png")
	
	imgnpc = love.graphics.newImage("graphics/npc/merchant.png")
	
	imgenemy = {}
	imgenemy[1] = love.graphics.newImage("graphics/monster/slime1.png")
	imgenemy[2] = love.graphics.newImage("graphics/monster/slime2.png")
	imgenemy[3] = love.graphics.newImage("graphics/monster/slime_pow.png")
	
	imgboss = {}
	imgboss[1] = love.graphics.newImage("graphics/boss/boss1.png")
	imgboss[2] = love.graphics.newImage("graphics/boss/boss2.png")
	imgboss[3] = love.graphics.newImage("graphics/boss/boss_pow.png")
	
	bgm = {}
	bgm[1] = love.audio.newSource("sound/bgm/epic.ogg", "stream")
	bgm[2] = love.audio.newSource("sound/bgm/field.ogg", "stream")
	bgm[3] = love.audio.newSource("sound/bgm/house.ogg", "stream")
	bgm[4] = love.audio.newSource("sound/bgm/lot.ogg", "stream")
	
	se = {}
	se[1] = love.audio.newSource("sound/se/gameover.ogg", "static")
	se[2] = love.audio.newSource("sound/se/sword.ogg", "static")
	
	scene.transition(0)
	
end

function sound.play(index)
	love.audio.stop()
	love.audio.rewind(bgm[index])
	love.audio.play(bgm[index])
	bgm[index]:setLooping(true)
end

function effect.play(index)
	love.audio.rewind(se[index])
	love.audio.play(se[index])
end

function love.update(dt)
	if scene.current == 1 then
		if player.victory == false then
			if map.scrollamx == 0 and map.scrollamy == 0 then
				player.update(dt)
				npc.update(dt)
				item.update(dt)
				if not(player.state == "item") then
					enemy.update(dt)
					if map.current == 2 then
						boss.update(dt)
					end
				end
				
			else --map is scrolling
				map.scrolltimer = map.scrolltimer + dt
				if map.scrolltimer >= 0.2 then
					map.scrolltimer = map.scrolltimer - 0.2
					if map.scrollamx == 0 then --scroll y
						if map.scrollamy > 0 then
							map.scrollamy = map.scrollamy - 1
							map.scroll("down")
							
						elseif map.scrollamy < 0 then
							map.scrollamy = map.scrollamy + 1
							map.scroll("up")
							
						end
						
						if map.scrollamy == 0 then --scroll finished
							map.scrolltimer = 0
						end

					elseif map.scrollamy == 0 then --scroll x
						if map.scrollamx > 0 then
							map.scrollamx = map.scrollamx - 1
							map.scroll("right")
							
						elseif map.scrollamx < 0 then
							map.scrollamx = map.scrollamx + 1
							map.scroll("left")
							
						end
						
						if map.scrollamx == 0 then --scroll finished
							map.scrolltimer = 0
						end
					end
				end
			end
		else
			player.tmrvictory = player.tmrvictory + dt
			if player.tmrvictory >= 3 then
				scene.transition(3)
			end
		end
	end
end

function love.keypressed()
	if scene.current == 0 then
		scene.transition(1) --debug:to 1
	end
end

function love.draw()
	local a
	local b
	if scene.current == 0 then
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(imgtitle, 0, 0)
	elseif scene.current == 1 then
		love.graphics.setColor(255, 255, 255)
		map.draw()
		npc.draw()
		boss.draw()
		item.draw()
		enemy.draw()
		player.draw()
		
		--draw UI
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 320, 320, 96)
		love.graphics.setColor(255, 255, 255)
		
		--Map
		love.graphics.setColor(195, 195, 195)
		love.graphics.rectangle("fill", 7, 328, 80, 80) --map
		love.graphics.setColor(112, 146, 190) --player
		love.graphics.rectangle("fill", 7 + math.floor(map.scrollx / 10) * 10, 328 + math.floor(map.scrolly / 10) * 10, 10, 10)
		
		--Life
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("-LIFE-", 200, 325)
		for a = 1, 3 do
			if player.health >= a then
				love.graphics.draw(imgheart[1], 160 + (a * 40), 350)
			else
				love.graphics.draw(imgheart[2], 160 + (a * 40), 350)
			end	
		end
		
		--triforce
		if player.triforce == 1 then
			love.graphics.draw(imgtriforce, 125, 330)
		elseif player.triforce == 2 then
			love.graphics.draw(imgtriforce, 125, 330)
			love.graphics.draw(imgtriforce, 109, 362)
		elseif player.triforce == 3 then
			love.graphics.draw(imgtriforce, 125, 330)
			love.graphics.draw(imgtriforce, 109, 362)
			love.graphics.draw(imgtriforce, 141, 362)
		end
	elseif scene.current == 2 then
		love.graphics.draw(imgover, 0, 0)
	elseif scene.current == 3 then
		love.graphics.draw(imgend, 0, 0)
		love.graphics.print("Thanks for saving my kingdom, Noru!\nYou're our hero!", 37, 37)
	end
end