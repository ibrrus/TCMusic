--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************
require "Music/TCMusicDefenitions"
ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextRadio()
    local self 					= ISMenuElement.new();
    self.invMenu			    = ISContextManager.getInstance().getInventoryMenu();

    function self.init()
    end

    function self.createMenu( _itemMusPlayer )
        if getCore():getGameMode() == "Tutorial" then
            return;
        end
        if instanceof(_itemMusPlayer, "Radio") then
            if _itemMusPlayer:getContainer() ~= self.invMenu.inventory then
                return;
            end
			local musicPlayer = ItemMusicPlayer[_itemMusPlayer:getWorldSprite()]
			if musicPlayer then
				if self.invMenu.player:getPrimaryHandItem() == _itemMusPlayer or self.invMenu.player:getSecondaryHandItem() == _itemMusPlayer then
					self.invMenu.context:addOption(getText("IGUI_DeviceOptions2"), self.invMenu, self.openPanel, _itemMusPlayer );
					if not _itemMusPlayer:getModData().tcmusic then
						_itemMusPlayer:getModData().tcmusic = {}
					end
					if _itemMusPlayer:getDeviceData():getIsTurnedOn() then
						local player = self.invMenu.player
						local _context = self.invMenu.context
						local playerInv = player:getInventory()
						local newPlayOption
						local subMenu
						if not _itemMusPlayer:getModData().tcmusic.playNow or not _itemMusPlayer:getDeviceData():getEmitter():isPlaying(_itemMusPlayer:getModData().tcmusic.playNow) then
							_itemMusPlayer:getModData().tcmusic.playNow = nil
							_itemMusPlayer:getModData().tcmusic.playNowId = nil
							for i=0, playerInv:getItemsFromCategory("Item"):size()-1 do
								local itemTape = playerInv:getItemsFromCategory("Item"):get(i)
								local music = itemTape:getType()
								if GlobalMusic[music] and musicPlayer == GlobalMusic[music] then
									if not newPlayOption then 
										newPlayOption = _context:addOption(getText("ContextMenu_Play_music"), nil, nil)
										subMenu = ISContextMenu:getNew(_context)
										_context:addSubMenu(newPlayOption,subMenu)
									end
									subMenu:addOption(string.sub(itemTape:getDisplayName(), 10), nil, self.tape_play, player, _itemMusPlayer, music, musicPlayer)
								end
							end
						else
							_context:addOption(getText("ContextMenu_Stop_music"), nil, self.tape_stop, player, _itemMusPlayer, musicPlayer);
						end
					end
				end
			end
        end
    end

    function self.openPanel( _p, _itemMusPlayer )
        ISTCBoomboxWindow.activate( _p.player, _itemMusPlayer );
    end
	
	function self.tape_stop( _p, player, _itemMusPlayer, musicPlayer)
        local service_sound = musicPlayer .. "_stop"
		ISTimedActionQueue.add(ISTapePocketsStop:new(player, _itemMusPlayer, service_sound, 5))
    end
	
	function self.tape_play(_p, player, _itemMusPlayer, music, musicPlayer)
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
		ISTimedActionQueue.add(ISTapePockets:new(player, _itemMusPlayer, music, service_sound, music_time[service_sound] * 50))
    end
	
    return self;
end
