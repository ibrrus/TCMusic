--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************

require "TCMusicDefenitions"

ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextBoombox()
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
                if TCMusic.WorldMusicPlayer[_item:getFullType()] and _item:getContainer():getType() == "floor" and _item:getWorldItem() and _item:getWorldItem():getSquare() then
					if not _item:getModData().tcmusic then
						_item:getModData().tcmusic = {}
						_item:getModData().tcmusic.playNow = nil
						_item:getModData().tcmusic.playNowId = nil
						_item:getModData().tcmusic.mediaItem = nil
						_item:getModData().tcmusic.worldObj = nil
						_item:getModData().tcmusic.needSpeaker = nil
					end
					-- ISRadioWindow.activate( _p.player, radio );
					self.invMenu.context:addOption(getText("IGUI_DeviceOptions"), self.invMenu, self.openPanel, _item );
				end
            end

            -- if self.invMenu.player:getPrimaryHandItem() == _item or self.invMenu.player:getSecondaryHandItem() == _item then
                -- self.invMenu.context:addOption(getText("IGUI_DeviceOptions"), self.invMenu, self.openPanel, _item );
            -- end
        end
    end		

    function self.openPanel( _p, _item )
        if not _item:getModData().tcmusic.worldObj then
		-- print ("searchBoombox")
			TCMusic.searchBoombox (_item, 1, 1)
		end
		if not _item:getModData().tcmusic.worldObj then
			-- print("Boombox NOT F!")
			local radio = IsoRadio.new(getCell(), _item:getWorldItem():getSquare(), getSprite(TCMusic.WorldMusicPlayer[_item:getFullType()])) -- 34 62
			_item:getWorldItem():getSquare():AddTileObject(radio)
			_item:getModData().tcmusic.worldObj = radio
			radio:getModData().tcmusic = _item:getModData().tcmusic
			radio:getDeviceData():setIsTurnedOn(false)
			radio:getDeviceData():setPower(_item:getDeviceData():getPower())
			radio:getDeviceData():setDeviceVolume(_item:getDeviceData():getDeviceVolume())
		end
		ISTCBoomboxWindow.activate( _p.player, _item:getModData().tcmusic.worldObj );
    end
	
    return self;
end
