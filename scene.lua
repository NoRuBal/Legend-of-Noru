--scenes.lua
scene = {}

function scene.load()
	scene.current = 0 --0:title 1:in-game 2:game over 3:ending cut-scene
end

function scene.transition(index)
	if index == 0 then --title
		sound.play(1)
	elseif index == 1 then --in-game
		love.audio.stop()
		map.load()
		player.load()
		npc.load()
		item.load()
		enemy.load()
		sound.play(2)
	elseif index == 2 then --game over
		love.audio.stop()
		effect.play(1)
	elseif index == 3 then --ending
		love.audio.stop()
		sound.play(1)
	end
	scene.current = index
end