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
                if _item:getType() == "TCBoombox" and _item:getContainer():getType() == "floor" and _item:getWorldItem() and _item:getWorldItem():getSquare() then
					if not _item:getModData().tcmusic then
						_item:getModData().tcmusic = {}
						_item:getModData().tcmusic.playNow = nil
						_item:getModData().tcmusic.playNowId = nil
						_item:getModData().tcmusic.mediaItem = nil
						_item:getModData().tcmusic.worldObj = nil
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
			local radio = IsoRadio.new(getCell(), _item:getWorldItem():getSquare(), getSprite("tsarcraft_music_01_34"))
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


function TCMusic.searchBoombox (_item, dx, dy)
	local square = _item:getWorldItem():getSquare()
	if square == nil then return end
	for y=square:getY() - dy, square:getY() + dy do
		for x=square:getX() - dx, square:getX() + dx do
			local square2 = getCell():getGridSquare(x, y, 0)
			if square2 ~= nil then
				for i=1,square2:getObjects():size() do
					local object = square:getObjects():get(i-1)
					if instanceof( object, "IsoWaveSignal") then
						local sprite = object:getSprite()
						if sprite ~= nil then
							local name_sprite = object:getSprite():getName()
							if WorldMusicPlayer[name_sprite] == ItemMusicPlayer[_item:getWorldSprite()] then
								-- print("Boombox found!")
								_item:getModData().tcmusic.worldObj = object
								object:getModData().tcmusic.worldObj = object
							end
						end
					end
				end
			end
		end
	end
end	