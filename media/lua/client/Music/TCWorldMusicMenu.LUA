--***********************************************************
--**                    TSAR VYACHESLAV                    **
--***********************************************************
require "Music/TCMusicDefenitions"
require 'Music/TCPlayMusic'

ISWorldMenuElements = ISWorldMenuElements or {};

function ISWorldMenuElements.ContextMusic()
    local self = ISMenuElement.new();
	local song_t = {
		["tsarcraft_music_01_32"] = "tsar_vocal",
		["tsarcraft_music_01_33"] = "tsar_vocal",
	}
	
	local music_t = {
		["tsarcraft_music_01_2"] = "tsar_piano",
		["tsarcraft_music_01_3"] = "tsar_piano",
		["tsarcraft_music_01_4"] = "tsar_piano",
		["tsarcraft_music_01_5"] = "tsar_piano",
		["tsarcraft_music_01_8"] = "tsar_grandpiano",
		["tsarcraft_music_01_9"] = "tsar_grandpiano",
		["tsarcraft_music_01_16"] = "tsar_grandpiano",
		["tsarcraft_music_01_17"] = "tsar_grandpiano",
		["tsarcraft_music_01_24"] = "tsar_drum",
		["tsarcraft_music_01_25"] = "tsar_drum",
		["tsarcraft_music_01_26"] = "tsar_drum",
		["tsarcraft_music_01_27"] = "tsar_drum",
		["tsarcraft_music_01_28"] = "tsar_bass",
		["location_community_church_small_01_96"] = "tsar_organ",
		["location_community_church_small_01_97"] = "tsar_organ",
		["location_community_church_small_01_98"] = "tsar_organ",
		["recreational_01_8"] = "tsar_standartpiano",
		["recreational_01_9"] = "tsar_standartpiano",
		["recreational_01_12"] = "tsar_standartpiano",
		["recreational_01_13"] = "tsar_standartpiano",
	}
	
    function self.init()
    end

    function self.createMenu( _data )
		local player = _data.player
		-- local player2 = GetPlayerName()
		-- print(player2)
		-- print(_data)
		-- for a, b in pairs(_data) do
			-- print(a)
			-- print(b)
		-- end
        for _,item in ipairs(_data.objects) do
			local sprite = item:getSprite()
			if sprite ~= nil then
				local name_sprite = item:getSprite():getName()
				local musicPlayer = WorldMusicPlayer[name_sprite]
				if musicPlayer then
					itemContainer = item:getContainer()
					local newPlayOption
					local subMenu
					local songID = string.format("%05d", item:getX()) .. string.format("%05d", item:getY()) .. string.format("%02d", item:getZ())
									
					if (now_play[songID]~=nil) and isSoundPlaying(now_play[songID][1]) then
						_data.context:addOption(getText("ContextMenu_Stop_music"), _data, self.tape_stop, item, musicPlayer, player)
						break
					else
						for i=0, itemContainer:getItemsFromCategory("Item"):size()-1 do
							local itemInContainer = itemContainer:getItemsFromCategory("Item"):get(i)
							local musicCarrier = GlobalMusic[itemInContainer:getType()]
							if musicCarrier and musicCarrier == musicPlayer then	
								if not newPlayOption then 
									newPlayOption = _data.context:addOption(getText("ContextMenu_Play_music"), nil, nil)
									subMenu = ISContextMenu:getNew(_data.context)
									_data.context:addSubMenu(newPlayOption,subMenu)
								end
								a, b = string.find(itemInContainer:getDisplayName(), " ")
								subMenu:addOption(string.sub(itemInContainer:getDisplayName(), a + 1), _data, self.tape_play, item, itemInContainer:getType(), musicPlayer, player)
							end
						end
					end
					if not newPlayOption then 
						_data.context:addOption(getText("ContextMenu_Sound_carrier_not_install"), nil, nil)
					end

				elseif song_t[name_sprite] then
					_data.context:addOption(getText("ContextMenu_Song"), _data, self.song, item, player)
					break
				elseif music_t[name_sprite] then
					_data.context:addOption(getText("ContextMenu_Play_music"), _data, self.playMusic, item, player)
					break
				end
			end
        end
    end

	function self.tape_play ( worldobjects, instrument, music, musicPlayer, player )
		if not luautils.walkAdj(player, instrument:getSquare(), true) then
			return
		end
		local service_sound = musicPlayer .. "_service"
		ISTimedActionQueue.add(ISTape:new(player, instrument, service_sound, music, music_time[service_sound] * 50))
	end
	
	function self.tape_stop ( worldobjects, instrument, musicPlayer,  player )
		if not luautils.walkAdj(player, instrument:getSquare(), true) then
			return
		end
		local service_sound = musicPlayer .. "_stop"
		ISTimedActionQueue.add(ISTapeMusicStop:new(player, instrument, service_sound, 5))
	end
	
	function self.song( worldobjects, instrument, player )
		if not luautils.walkAdj(player, instrument:getSquare(), true) then
			return
		end
		local song = song_t[instrument:getSprite():getName()]
		ISTimedActionQueue.add(ISPlayMusic:new(player, instrument, song, music_time[song] * 50)) -- 50 = 1s
    end

    function self.playMusic( worldobjects, instrument, player)
		if not luautils.walkAdj(player, instrument:getSquare(), true) then
			return
		end
		local music = music_t[instrument:getSprite():getName()]
		ISTimedActionQueue.add(ISPlayMusic:new(player, instrument, music, music_time[music] * 50))
    end
	
    return self;
end

function OnObjectAboutToBeRemoved(object)
	if instanceof(object, "IsoObject") then
		local songID = string.format("%05d", object:getX()) .. string.format("%05d", object:getY()) .. string.format("%02d", object:getZ())
		if (now_play[songID]~=nil) and isSoundPlaying(now_play[songID][1]) then
			stopSound(now_play[songID][1])
		end
	end
end

Events.OnObjectAboutToBeRemoved.Add(OnObjectAboutToBeRemoved)
	
