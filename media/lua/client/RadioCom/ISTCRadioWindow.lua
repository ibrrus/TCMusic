-- @filename - ISTCRadioWindow.lua
require "TCMusicDefenitions"

TCMusic.oldISRadioWindow_activate = ISRadioWindow.activate

function ISRadioWindow.activate( _player, _item, bol)
    if _player == getPlayer() then
        if instanceof(_item, "Radio") then
            if TCMusic.ItemMusicPlayer[_item:getFullType()] then
                if _player:getSecondaryHandItem() == _item then
                    ISTCBoomboxWindow.activate( _player, _item );
                end
            elseif TCMusic.WorldMusicPlayer[_item:getFullType()] then
                
            else
                -- print("1")
                TCMusic.oldISRadioWindow_activate( _player, _item, bol );
            end
        elseif instanceof(_item, "IsoWaveSignal") then
            -- print(_item)
            -- print(_item:getSprite())
            -- print(_item:getSprite():getName())
            -- print(_item:getSprite():getParentObjectName())
            -- print(_item:getSprite():getProperties())
            if _item:getSprite() and TCMusic.WorldMusicPlayer[_item:getSprite():getName()] then
                ISTCBoomboxWindow.activate( _player, _item );
            else
                -- print("2")
                -- ISTCBoomboxWindow.activate( _player, _item );
                TCMusic.oldISRadioWindow_activate( _player, _item, bol );
            end
        else
            -- print("3")
            TCMusic.oldISRadioWindow_activate( _player, _item, bol );
        end
    end
end

function ISRadioWindow.activateBoombox( _player, _item, bol)
    if _player == getPlayer() then
        ISRadioWindow.searchBoombox( _player, _item)
        ISTCBoomboxWindow.activate( _player, _item:getModData().tcmusic.worldObj );
    end
end

function ISRadioWindow.searchBoombox( _p, _item)
    if not _item:getModData().tcmusic then
        _item:getModData().tcmusic = {}
        _item:getModData().tcmusic.mediaItem = nil
        _item:getModData().tcmusic.worldObj = nil
        _item:getModData().tcmusic.needSpeaker = nil
    end
    if not _item:getModData().tcmusic.worldObj then
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
        radio:getModData().RadioItemID = _item:getID()
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
        -- sendClientCommand(_p.player, 'truemusic', 'createWO', { x = radio:getX(), y = radio:getY(), z = radio:getZ() }) -- @warning забыл для чего это
    end
end
