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

    function self.createMenu( _item )
        if getCore():getGameMode() == "Tutorial" then
            return;
        end
        if instanceof(_item, "Radio") then
            if _item:getContainer() ~= self.invMenu.inventory then
                return;
            end
			local musicPlayer = ItemMusicPlayer[_item:getWorldSprite()]
			if musicPlayer then
				if self.invMenu.player:getPrimaryHandItem() == _item or self.invMenu.player:getSecondaryHandItem() == _item then
					self.invMenu.context:addOption(getText("IGUI_DeviceOptions2"), self.invMenu, self.openPanel, _item );
				end
			end
        end
    end

    function self.openPanel( _p, _item )
        ISTCBoomboxWindow.activate( _p.player, _item );
    end

    return self;
end
