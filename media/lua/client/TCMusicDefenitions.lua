-- require "TCMusicDefenitions"

if (GlobalMusic == nil) then GlobalMusic = {} end
if (ItemMusicPlayer == nil) then ItemMusicPlayer = {} end
if (WorldMusicPlayer == nil) then WorldMusicPlayer = {} end
if (VehicleMusicPlayer == nil) then VehicleMusicPlayer = {} end
if (now_play == nil) then now_play = {} end
if (music_time == nil) then music_time = {} end
if not TCMusic then TCMusic = {} end


	music_time["tsar_bass"] = 4.48
	music_time["tsar_drum"] = 4.41
	music_time["tsar_grandpiano"] = 9.33
	music_time["tsar_organ"] = 12.5
	music_time["tsar_piano"] = 8.91
	music_time["tsar_standartpiano"] = 17.48
	music_time["tsar_vocal"] = 4.47
	music_time["TCBoombox_service"] = 3
	music_time["TCVinylplayer_service"] = 5.4

	ItemMusicPlayer["Tsarcraft.TCBoombox"] = "tsarcraft_music_01_62"
	-- ItemMusicPlayer["Tsarcraft.TCVinylplayer"] = "TCVinylplayer"
	-- ItemMusicPlayer["tsarcraft_music_01_35"] = "TCBoombox"
	-- ItemMusicPlayer["tsarcraft_music_01_62"] = "TCBoombox"
	
	WorldMusicPlayer["tsarcraft_music_01_34"] = "tsarcraft_music_01_62"
	WorldMusicPlayer["tsarcraft_music_01_35"] = "tsarcraft_music_01_62"
	WorldMusicPlayer["tsarcraft_music_01_62"] = "tsarcraft_music_01_62"
	WorldMusicPlayer["tsarcraft_music_01_36"] = "tsarcraft_music_01_63"
	WorldMusicPlayer["tsarcraft_music_01_37"] = "tsarcraft_music_01_63"
	WorldMusicPlayer["tsarcraft_music_01_63"] = "tsarcraft_music_01_63"
	WorldMusicPlayer["Tsarcraft.TCBoombox"] = "tsarcraft_music_01_62"
	WorldMusicPlayer["Tsarcraft.TCVinylplayer"] = "tsarcraft_music_01_63"

	VehicleMusicPlayer["Radio.HamRadio1"] = "tsarcraft_music_01_62"
	VehicleMusicPlayer["Radio.HamRadio2"] = "tsarcraft_music_01_62"
	VehicleMusicPlayer["Radio.RadioBlack"] = "tsarcraft_music_01_62"
	VehicleMusicPlayer["Radio.RadioRed"] = "tsarcraft_music_01_62"
	
	
	
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
							if WorldMusicPlayer[name_sprite] == WorldMusicPlayer[_item:getFullType()] then
								-- print("Boombox found!")
								if not object:getModData().tcmusic.worldObj then
									_item:getModData().tcmusic.worldObj = object
									object:getModData().tcmusic.worldObj = object
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

TCMusic.oldISRadioWindow_activate = ISRadioWindow.activate

function ISRadioWindow.activate( _player, _item, bol)
	-- print(_item)
	if _player == getPlayer() then
		if instanceof(_item, "Radio") then
			if ItemMusicPlayer[_item:getFullType()] then
				ISTCBoomboxWindow.activate( _player, _item );
			elseif WorldMusicPlayer[_item:getFullType()] then
				
			else
				TCMusic.oldISRadioWindow_activate( _player, _item, bol );
			end
		elseif instanceof(_item, "IsoWaveSignal") then
			if WorldMusicPlayer[_item:getSprite():getName()] then
				ISTCBoomboxWindow.activate( _player, _item );
			else
				TCMusic.oldISRadioWindow_activate( _player, _item, bol );
			end
		else
			TCMusic.oldISRadioWindow_activate( _player, _item, bol );
		end
	end
end

function TCMusic.OnObjectAboutToBeRemoved(object)
	if instanceof(object, "IsoWorldInventoryObject") then
		if object:getModData().tcmusic and object:getModData().tcmusic.connectTo then
			object:getModData().tcmusic.connectTo:getModData().tcmusic.connectTo = nil
			object:getModData().tcmusic.connectTo:getDeviceData():getEmitter():stopAll()
			object:getModData().tcmusic.connectTo = nil
		else
			local _item = object:getItem()
			if _item and instanceof(_item, "Radio") and WorldMusicPlayer[_item:getFullType()] and _item:getModData().tcmusic then
				if not _item:getModData().tcmusic.worldObj then
					TCMusic.searchBoombox (_item, 1, 1)
				end
				if _item:getModData().tcmusic and _item:getModData().tcmusic.worldObj then
					local radio = _item:getModData().tcmusic.worldObj
					_item:getModData().tcmusic = radio:getModData().tcmusic
					_item:getDeviceData():setPower(radio:getDeviceData():getPower())
					_item:getDeviceData():setDeviceVolume(radio:getDeviceData():getDeviceVolume())
					radio:removeFromWorld()
					radio:removeFromSquare()
					_item:getModData().tcmusic.playNow = nil
					_item:getModData().tcmusic.playNowId = nil
					_item:getModData().tcmusic.worldObj = nil
					if _item:getModData().tcmusic.connectTo then
						_item:getModData().tcmusic.connectTo:getModData().tcmusic.connectTo = nil
						_item:getModData().tcmusic.connectTo = nil
					end
				end
			end
		end
	end
end

Events.OnObjectAboutToBeRemoved.Add(TCMusic.OnObjectAboutToBeRemoved)