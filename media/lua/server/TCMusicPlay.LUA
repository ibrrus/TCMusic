
require "TCMusicDefenitions"

local tickControl = 100 -- Сокращает количество срабатываний скрипта. Больше число - меньше срабатываний
local tickStart = 0


local RADIUS = 30

local function tableIsEmpty(T)
	for i,j in pairs(T) do 
		return false
	end
	return true
end

function OnRenderTickCheckMusic ()
	tickStart = tickStart + 1
	if tickStart % tickControl == 0 then
		tickStart = 0
		if not tableIsEmpty(TCMusic.now_play) then
			for playId, musicData in pairs(TCMusic.now_play) do
				local haveHeadphone = musicData[3]
				if isSoundPlaying(playId) and not haveHeadphone then
					local musicObj = musicData[1]
					local musicVolume = musicData[2]
					if instanceof(musicObj, "DeviceData") then
						local isoObj = musicObj:getParent()
						addSound (nil, isoObj:getX(), isoObj:getY(), isoObj:getZ(), RADIUS * musicVolume, 1)
					elseif instanceof(musicObj, "BaseVehicle") then
						if musicObj:isAnyListenerInside() then
							musicObj:getEmitter():set3D(playId, false);
						else
							musicObj:getEmitter():set3D(playId, true);
						end
						addSound (nil, musicObj:getX(), musicObj:getY(), musicObj:getZ(), RADIUS * musicVolume, 1)
					end
				else 
					TCMusic.now_play[playId] = nil
				end
			end
		end
	end
end

Events.OnRenderTick.Add(OnRenderTickCheckMusic)