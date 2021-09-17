-- ****** TSARCRAFT MUSIC CONTROL **********

require "Music/TCMusicDefenitions"

local tickControl = 80 -- Сокращает количество срабатываний скрипта. Больше число - меньше срабатываний
local tickStart = 0


RADIUS = 8

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
			for coordinats, musicDATA in pairs(now_play) do
				if luautils.stringStarts(coordinats, "Player") then
					local playerNum = tonumber(string.sub(coordinats, 8))
					local player = getSpecificPlayer(playerNum)
					if not player or not player:getInventory():containsID(musicDATA[3]) then
						stopSound(musicDATA[1])
					end
					if isSoundPlaying(musicDATA[1]) then
						local x = player:getX()
						local y = player:getY()
						local z = player:getZ()
						addSound (nil, x, y, z, RADIUS * musicDATA[2], 1)
					else 
						now_play[coordinats] = nil
					end
				else
					if isSoundPlaying(musicDATA[1]) then
						local x = tonumber(string.sub(coordinats, 1, 5))
						local y = tonumber(string.sub(coordinats, 6, 10))
						local z = tonumber(string.sub(coordinats, 11, 12))
						addSound (nil, x, y, z, RADIUS * musicDATA[2], 1)
					else
						now_play[coordinats] = nil
					end
				end
			end
		end
	end
end

Events.OnRenderTick.Add(OnRenderTickCheckMusic)