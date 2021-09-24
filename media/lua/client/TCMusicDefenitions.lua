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