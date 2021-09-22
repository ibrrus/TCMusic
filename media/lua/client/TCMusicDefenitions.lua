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

	ItemMusicPlayer["Tsarcraft.TCBoombox"] = "TCBoombox"
	-- ItemMusicPlayer["tsarcraft_music_01_35"] = "TCBoombox"
	-- ItemMusicPlayer["tsarcraft_music_01_62"] = "TCBoombox"
	
	WorldMusicPlayer["tsarcraft_music_01_34"] = "TCBoombox"
	WorldMusicPlayer["tsarcraft_music_01_35"] = "TCBoombox"
	WorldMusicPlayer["tsarcraft_music_01_62"] = "TCBoombox"
	WorldMusicPlayer["tsarcraft_music_01_36"] = "TCVinylplayer"
	WorldMusicPlayer["tsarcraft_music_01_37"] = "TCVinylplayer"

	VehicleMusicPlayer["Radio.HamRadio1"] = "TCBoombox"
	VehicleMusicPlayer["Radio.HamRadio2"] = "TCBoombox"
	VehicleMusicPlayer["Radio.RadioBlack"] = "TCBoombox"
	VehicleMusicPlayer["Radio.RadioRed"] = "TCBoombox"