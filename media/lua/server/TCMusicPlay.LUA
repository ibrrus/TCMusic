-- ****** TSARCRAFT MUSIC CONTROL **********

require "Music/TCMusicDefenitions"

local tickControl = 80 -- Сокращает количество срабатываний скрипта. Больше число - меньше срабатываний
local tickStart = 0


RADIUS = 40

function tableIsEmpty(T)
	for i,j in pairs(T) do 
		return false
	end
	return true
end

function OnRenderTickCheckMusic ()
	tickStart = tickStart + 1
	if tickStart % tickControl == 0 then
		if not tableIsEmpty(now_play) then
			for coordinats, musicID in pairs(now_play) do
				if isSoundPlaying(musicID[1]) then
					local x
					local y
					local z
					if luautils.stringStarts(coordinats, "Player") then
						local player
						if getCore():getGameMode() == "Multiplayer" then
							local nameOfPlayer = string.sub(coordinats, 8)
							player = getPlayerFromUsername(nameOfPlayer)
						else
							player = getPlayer()
						end
						if not player:getInventory():containsID(musicID[2]) then
							stopSound(musicID[1])
						end
						x = player:getX()
						y = player:getY()
						z = player:getZ()
						--print("[TSARCRAFT] Player coordinats: ", x, y ,z)
					else
						x = tonumber(string.sub(coordinats, 1, 5))
						y = tonumber(string.sub(coordinats, 6, 10))
						z = tonumber(string.sub(coordinats, 11, 12))
						--print("[TSARCRAFT] Moveable coordinats: ", x, y ,z)
					end
					addSound (nil, x, y, z, RADIUS, 1)
				else 
					now_play[coordinats] = nil
					--print ("Coordinats clear " .. coordinats)
				end
			end
		end
	end
end

Events.OnRenderTick.Add(OnRenderTickCheckMusic)