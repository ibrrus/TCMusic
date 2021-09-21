-- --***********************************************************
-- --**                    THE INDIE STONE                    **
-- --**				  Author: turbotutone				   **
-- --***********************************************************
-- require "TCMusicDefenitions"

-- ISInventoryMenuElements = ISInventoryMenuElements or {};

-- function ISInventoryMenuElements.ContextRadio()
    -- local self 					= ISMenuElement.new();
    -- self.invMenu			    = ISContextManager.getInstance().getInventoryMenu();

    -- function self.init()
    -- end

    -- function self.createMenu( _itemMusPlayer )
        -- if getCore():getGameMode() == "Tutorial" then
            -- return;
        -- end
        -- if instanceof(_itemMusPlayer, "Radio") then
            -- if _itemMusPlayer:getContainer() ~= self.invMenu.inventory then
                -- return;
            -- end
			-- local musicPlayer = ItemMusicPlayer[_itemMusPlayer:getWorldSprite()]
			-- if musicPlayer then
				-- if self.invMenu.player:getPrimaryHandItem() == _itemMusPlayer or self.invMenu.player:getSecondaryHandItem() == _itemMusPlayer then
					-- self.invMenu.context:addOption(getText("IGUI_DeviceOptions"), self.invMenu, self.openPanel, _itemMusPlayer );
					-- if not _itemMusPlayer:getModData().tcmusic then
						-- _itemMusPlayer:getModData().tcmusic = {}
						-- _itemMusPlayer:getModData().tcmusic.playNow = nil
						-- _itemMusPlayer:getModData().tcmusic.playNowId = nil
						-- _itemMusPlayer:getModData().tcmusic.mediaItem = nil
					-- end
				-- end
			-- end
        -- end
    -- end

    -- function self.openPanel( _p, _itemMusPlayer )
        -- ISTCBoomboxWindow.activate( _p.player, _itemMusPlayer );
    -- end
    -- return self;
-- end
