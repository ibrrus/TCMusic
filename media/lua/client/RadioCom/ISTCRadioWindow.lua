-- @filename - ISTCRadioWindow.lua
require "TCMusicClientFunctions"

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
                TCMusic.oldISRadioWindow_activate( _player, _item, bol );
            end
        elseif instanceof(_item, "IsoWaveSignal") then
            boomboxFound = false
            for i=0, _item:getSquare():getWorldObjects():size()-1 do
                local itemObj = _item:getSquare():getWorldObjects():get(i)
                if instanceof(itemObj:getItem(), "Radio") then
                    if itemObj:getItem():getID() == _item:getModData().RadioItemID then
                        if TCMusic.WorldMusicPlayer[itemObj:getItem():getFullType()] then
                            boomboxFound = true
                            if not _item:getSprite() or not TCMusic.WorldMusicPlayer[_item:getSprite():getName()] then
                                if itemObj:getItem():getType() == "TCBoombox" then
                                    _item:setSpriteFromName("tsarcraft_music_01_62");
                                    _item:transmitUpdatedSpriteToServer();
                                else
                                    _item:setSpriteFromName("tsarcraft_music_01_63");
                                    _item:transmitUpdatedSpriteToServer();
                                end
                            end
                            if itemObj:getItem():getModData().tcmusic then
                                _item:getModData().tcmusic = itemObj:getItem():getModData().tcmusic
                                _item:getModData().tcmusic.isPlaying = false
                                _item:getModData().tcmusic.deviceType = "IsoObject"
                                _item:transmitModData()
                            end
                            ISTCBoomboxWindow.activate( _player, _item );
                            break
                        end
                    end
                end
            end
            if not boomboxFound then
                TCMusic.oldISRadioWindow_activate( _player, _item, bol );
            end
        else
            TCMusic.oldISRadioWindow_activate( _player, _item, bol );
        end
    end
end
