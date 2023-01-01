require "TCMusicDefenitions"

--- Поиск WO-бумбокса вокруг Item-бумбокса и запись ссылки на него в ModData
-- @param _item - Item-бумбокс
-- @param dx - дельта по x
-- @param dy - дельта по y
function TCMusic.searchBoombox (_item, dx, dy)
    local square = _item:getWorldItem():getSquare()
    if square == nil then return end
    for y=square:getY() - dy, square:getY() + dy do
        for x=square:getX() - dx, square:getX() + dx do
            local square2 = getCell():getGridSquare(x, y, square:getZ())
            if square2 ~= nil then
                for i=1,square2:getObjects():size() do
                    local object = square2:getObjects():get(i-1)
                    if instanceof( object, "IsoWaveSignal") then
                        local sprite = object:getSprite()
                        if sprite ~= nil then
                            local name_sprite = object:getSprite():getName()
                            if TCMusic.WorldMusicPlayer[name_sprite] == TCMusic.WorldMusicPlayer[_item:getFullType()] then
                                if object:getModData().tcmusic and 
                                        object:getModData().tcmusic.itemid == 
                                        _item:getWorldItem():getSquare():getX() .. 
                                        _item:getWorldItem():getSquare():getY() .. 
                                        _item:getWorldItem():getSquare():getZ() then
                                    -- print("Boombox found!")
                                    if not _item:getModData().tcmusic then
                                        _item:getModData().tcmusic = {}
                                    end
                                    _item:getModData().tcmusic.worldObj = object
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--- Удаление невидимого WO-бумбокса
function TCMusic.OnObjectAboutToBeRemoved(object)
    if instanceof(object, "IsoWorldInventoryObject") then
        local _item = object:getItem()
        if _item and instanceof(_item, "Radio") and TCMusic.WorldMusicPlayer[_item:getFullType()] then
            TCMusic.searchBoombox (_item, 1, 1)
        end
        if _item:getModData().tcmusic and _item:getModData().tcmusic.worldObj then
            local radio = _item:getModData().tcmusic.worldObj
            if radio then
                if radio:getSquare() then
                    _item:getModData().tcmusic = radio:getModData().tcmusic
                    if radio:getDeviceData():getIsBatteryPowered() and radio:getDeviceData():getHasBattery() then
                        _item:getDeviceData():setHasBattery(true)
                        _item:getDeviceData():setPower(radio:getDeviceData():getPower())
                    else
                        _item:getDeviceData():setHasBattery(false)
                    end
                    _item:getDeviceData():setDeviceVolume(radio:getDeviceData():getDeviceVolume())
                    sendClientCommand(getPlayer(), 'truemusic', 'deleteWO', { 
                        x = radio:getX(), 
                        y = radio:getY(), 
                        z = radio:getZ(),
                        nameSprite = TCMusic.WorldMusicPlayer[_item:getFullType()],
                    })
                end
                _item:getModData().tcmusic.isPlaying = false
                _item:getModData().tcmusic.worldObj = nil
                _item:getModData().tcmusic.deviceType = "InventoryItem"
            end
        end
    -- TODO обработка случая, если "невидимое" радио было уничтожено
    elseif instanceof(object, "IsoRadio") then
        -- local sprite = object:getSprite()
        -- if sprite ~= nil then
            -- local name_sprite = object:getSprite():getName()
            -- if TCMusic.WorldMusicPlayer[name_sprite] then
                
            -- end
        -- end
    end
end

--- Активация расширенного меню управления звуками
function TCMusic.AdvancedSoundOptions()
    SystemDisabler.setEnableAdvancedSoundOptions(true)
end

Events.OnObjectAboutToBeRemoved.Add(TCMusic.OnObjectAboutToBeRemoved)
Events.OnGameBoot.Add(TCMusic.AdvancedSoundOptions)