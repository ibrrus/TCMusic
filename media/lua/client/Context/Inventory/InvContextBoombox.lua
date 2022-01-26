--***********************************************************
--**                    THE INDIE STONE                    **
--**                  Author: turbotutone                   **
--***********************************************************

require "TCMusicDefenitions"
require "TCTickCheckMusic"

ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextBoombox()
    local self                     = ISMenuElement.new();
    self.invMenu                = ISContextManager.getInstance().getInventoryMenu();

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
                        -- print("NEW MODDATA")
                        _item:getModData().tcmusic = {}
                        _item:getModData().tcmusic.mediaItem = nil
                        _item:getModData().tcmusic.worldObj = nil
                        _item:getModData().tcmusic.needSpeaker = nil
                    end
                    self.invMenu.context:addOption(getText("IGUI_DeviceOptions"), self.invMenu, self.openPanel, _item );
                end
            else
                if TCMusic.WorldMusicPlayer[_item:getFullType()] then
                    self.invMenu.context:removeOptionTsar(self.invMenu.context:getOptionFromName(getText("IGUI_PlaceObject")))
                    self.invMenu.context:removeOptionTsar(self.invMenu.context:getOptionFromName(getText("ContextMenu_Equip_Primary")))
                    -- запрещаем активировать радио, если оно в основной руке (это заглушка для мультиплеера, чтобы игроки не включали больше одной песни)
                    if self.invMenu.player:getPrimaryHandItem() == _item then
                        self.invMenu.context:removeOptionTsar(self.invMenu.context:getOptionFromName(getText("IGUI_DeviceOptions")))
                    end
                end
            end
            -- if self.invMenu.player:getPrimaryHandItem() == _item or self.invMenu.player:getSecondaryHandItem() == _item then
                -- self.invMenu.context:addOption(getText("IGUI_DeviceOptions"), self.invMenu, self.openPanel, _item );
            -- end
        end
    end        

    function self.openPanel( _p, _item )
        if not _item:getModData().tcmusic.worldObj then
            -- print ("SearchBoombox")
            TCMusic.searchBoombox (_item, 1, 1)
        end
        if not _item:getModData().tcmusic.worldObj then
            -- print("BOOMBOX NOT FOUND!")
            local radio = IsoRadio.new(getCell(), _item:getWorldItem():getSquare(), getSprite(TCMusic.WorldMusicPlayer[_item:getFullType()])) -- 34 62
            _item:getWorldItem():getSquare():AddTileObject(radio)
            radio:getModData().tcmusic = _item:getModData().tcmusic
            radio:getModData().tcmusic.itemid = _item:getWorldItem():getSquare():getX() .. 
                                                _item:getWorldItem():getSquare():getY() .. 
                                                _item:getWorldItem():getSquare():getZ()
            _item:getModData().tcmusic.worldObj = radio
            radio:getModData().tcmusic.deviceType = "IsoObject"
            radio:getDeviceData():setIsTurnedOn(false)
            radio:getDeviceData():setPower(_item:getDeviceData():getPower())
            radio:getDeviceData():setDeviceVolume(_item:getDeviceData():getDeviceVolume())
            if _item:getDeviceData():getIsBatteryPowered() and _item:getDeviceData():getHasBattery() then
                radio:getDeviceData():setPower(_item:getDeviceData():getPower())
            else
                radio:getDeviceData():setHasBattery(false)
            end

            if _item:getDeviceData():getHeadphoneType() >= 0 then
                _item:getDeviceData():getHeadphones(_p.player:getInventory())
            end
            if isClient() then 
                radio:transmitCompleteItemToServer(); 
            end
            -- local id = "#" .. radio:getX() .. "-" .. radio:getY() .. "-" .. radio:getZ()
            sendClientCommand(_p.player, 'truemusic', 'createWO', { x = radio:getX(), y = radio:getY(), z = radio:getZ() })
        end
        ISTCBoomboxWindow.activate( _p.player, _item:getModData().tcmusic.worldObj );
    end
    return self;
end
