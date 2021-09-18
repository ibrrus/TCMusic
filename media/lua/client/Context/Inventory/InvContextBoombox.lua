ISInventoryMenuElements = ISInventoryMenuElements or {};
require "Music/TCMusicDefenitions"


function ISInventoryMenuElements.ContextBoombox()
    local self 					= ISMenuElement.new();
    self.invMenu			    = ISContextManager.getInstance().getInventoryMenu();

    function self.init()
    end

    function self.createMenu( _itemMusPlayer )
		-- print(_itemMusPlayer)
        if getCore():getGameMode() == "Tutorial" then
            return;
        end
        if instanceof(_itemMusPlayer, "Radio") then
			local musicPlayer = ItemMusicPlayer[_itemMusPlayer:getWorldSprite()]
			if musicPlayer then
				local player = self.invMenu.player
				local _context = self.invMenu.context
				local playerInv = player:getInventory()
				local newPlayOption
				local subMenu
				local songID
				-- if getCore():getGameMode() == "Multiplayer" then
				songID = "Player_" .. player:getPlayerNum()
				-- else
					-- songID = "Player_0"
				-- end
				for i=0, playerInv:getItemsFromCategory("Item"):size()-1 do
					local itemTape = playerInv:getItemsFromCategory("Item"):get(i)
					local music = itemTape:getType()
					if GlobalMusic[music] and musicPlayer == GlobalMusic[music] then	
						if (now_play[songID]~=nil) and isSoundPlaying(now_play[songID][1]) then
							_context:addOption(getText("ContextMenu_Stop_music"), nil, self.tape_stop, player, songID, musicPlayer);
							break
						else
							if not newPlayOption then 
								newPlayOption = _context:addOption(getText("ContextMenu_Play_music"), nil, nil)
								subMenu = ISContextMenu:getNew(_context)
								_context:addSubMenu(newPlayOption,subMenu)
							end
							subMenu:addOption(string.sub(itemTape:getDisplayName(), 10), nil, self.tape_play, player, _itemMusPlayer, music, musicPlayer, songID)
						end	
					end
				end
			end
		
            -- if _itemMusPlayer:getContainer() ~= self.invMenu.inventory then
                -- return;
            -- end

            -- if (self.invMenu.player:getPrimaryHandItem() == _itemMusPlayer or self.invMenu.player:getSecondaryHandItem() == _itemMusPlayer) and 
			-- _itemMusPlayer:getName() == "Boombox" then
				-- self.invMenu.context:removeOptionTsar(self.invMenu.context:getOptionFromName(getText("IGUI_DeviceOptions")))
				-- local deviceData = _itemMusPlayer:getDeviceData():setMediaType(7)
                -- self.invMenu.context:addOption(getText("IGUI_DeviceOptions2"), self.invMenu, self.openPanel, _itemMusPlayer );
            -- end
        end
    end

    function self.tape_stop( _p, player, songID, musicPlayer)
        local service_sound = musicPlayer .. "_stop"
		ISTimedActionQueue.add(ISTapePocketsStop:new(player, songID, service_sound, 5))
    end
	
	function self.tape_play(_p, player, _itemMusPlayer, music, musicPlayer, songID)
        if _itemMusPlayer:getContainer() ~= player:getInventory() then
			ISTimedActionQueue.add(ISInventoryTransferAction:new(player, _itemMusPlayer, _itemMusPlayer:getContainer(), player:getInventory(), nil));
		end
		if not _itemMusPlayer:getModData().TCMusic then
			_itemMusPlayer:getModData().TCMusic = {}
		end
		if not _itemMusPlayer:getModData().TCMusic.volume then
			_itemMusPlayer:getModData().TCMusic.volume = 5
		end
		local service_sound = musicPlayer .. "_service"
		ISTimedActionQueue.add(ISTapePockets:new(player, _itemMusPlayer, music, service_sound, songID, music_time[service_sound] * 50, _itemMusPlayer:getModData().TCMusic.volume))
    end

    return self;
end
