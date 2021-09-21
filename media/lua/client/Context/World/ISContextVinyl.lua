--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************

require "TCMusicDefenitions"
require "CommonTemplates/ISUI/ISContextMenuExtension" 


ISWorldMenuElements = ISWorldMenuElements or {};

function ISWorldMenuElements.ContextVinyl()
    local self 					= ISMenuElement.new();
    --self.worldMenu 				= ISContextManager.getInstance().getWorldMenu();
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
        if getCore():getGameMode() == "Tutorial" then
            return;
        end
        
        for _,item in ipairs(_data.objects) do
			-- print(item)
            if instanceof( item, "IsoWaveSignal") then
                local sprite = item:getSprite()
				-- print("sprite: ", sprite)
				if sprite ~= nil then
					local name_sprite = item:getSprite():getName()
					local musicPlayer = WorldMusicPlayer[name_sprite]
					if musicPlayer then
						-- _data.context:removeOptionTsar(_data.context:getOptionFromName(getText("IGUI_DeviceOptions")))
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
	end
	
	function self.openPanel( _data, _itemMusPlayer )
        ISTCBoomboxWindow.activate( _data.player, _itemMusPlayer);
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