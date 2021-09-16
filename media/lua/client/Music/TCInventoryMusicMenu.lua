--***********************************************************
--**                    TSAR VYACHESLAV                    **
--***********************************************************
require "Music/TCMusicDefenitions"

ISInventoryMusicMenu = {}

ISInventoryMusicMenu.createMenuEntries = function(_player, _context, _itemMusPlayers)
	for i,v in ipairs(_itemMusPlayers) do
		if (type(v) == "table") then
			_itemMusPlayer = v.items[1]
		else 
			_itemMusPlayer = v
		end
	end
	
	if instanceof(_itemMusPlayer, "Radio") then
		local musicPlayer = ItemMusicPlayer[_itemMusPlayer:getWorldSprite()]
		if musicPlayer then
			local player = getSpecificPlayer(_player)
			local playerInv = player:getInventory()
			local newPlayOption
			local subMenu
			local songID
			if getCore():getGameMode() == "Multiplayer" then
				songID = "Player_" .. tostring(player:getUsername())
			else
				songID = "Player_0"
			end
			for i=0, playerInv:getItemsFromCategory("Item"):size()-1 do
				local itemTape = playerInv:getItemsFromCategory("Item"):get(i)
				local music = itemTape:getType()
				if GlobalMusic[music] and musicPlayer == GlobalMusic[music] then	
					if (now_play[songID]~=nil) and isSoundPlaying(now_play[songID][1]) then
						_context:addOption(getText("ContextMenu_Stop_music"), nil, tape_stop, player, songID, musicPlayer);
						break
					else
						if not newPlayOption then 
							newPlayOption = _context:addOption(getText("ContextMenu_Play_music"), nil, nil)
							subMenu = ISContextMenu:getNew(_context)
							_context:addSubMenu(newPlayOption,subMenu)
						end
						subMenu:addOption(string.sub(itemTape:getDisplayName(), 10), nil, ISInventoryMusicMenu.tape_play, player, _itemMusPlayer, music, musicPlayer, songID)
					end	
				end
			end
		end
	end
	
	function tape_stop( _p, player, songID, musicPlayer)
		local service_sound = musicPlayer .. "_stop"
		ISTimedActionQueue.add(ISTapePocketsStop:new(player, songID, service_sound, 5))
    end
end	

ISInventoryMusicMenu.tape_play = function (_p, player, _itemMusPlayer, music, musicPlayer, songID)
		if _itemMusPlayer:getContainer() ~= player:getInventory() then
			ISTimedActionQueue.add(ISInventoryTransferAction:new(player, _itemMusPlayer, _itemMusPlayer:getContainer(), player:getInventory(), nil));
		end
		local _itemMusPlayerID = _itemMusPlayer:getID()
		local service_sound = musicPlayer .. "_service"
		ISTimedActionQueue.add(ISTapePockets:new(player, _itemMusPlayerID, music, service_sound, songID, music_time[service_sound] * 50))
	end

Events.OnPreFillInventoryObjectContextMenu.Add( ISInventoryMusicMenu.createMenuEntries )