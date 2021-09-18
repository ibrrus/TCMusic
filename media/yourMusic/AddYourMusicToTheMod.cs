// TCSounds
// MusicScrits
// TCLoading
// TCMusicDefenitionsStr


using System;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections;
using System.Collections.Generic;

public class MusicGenerator
{
    public static void Main(string[] args)
    {
		convertFolder("TCBoombox");
		Console.WriteLine();
		convertFolder("TCVinylplayer");
		Console.WriteLine("\nPress any key..");
		Console.ReadKey();
		
    }
	
	private static string TR(string str)
	{
		
		   str = str.Replace("а", "a");
           str = str.Replace("А", "A");
	       str = str.Replace("б", "b");
           str = str.Replace("Б", "B");
           str = str.Replace("в", "v");
           str = str.Replace("В", "V");
           str = str.Replace("г", "g");
           str = str.Replace("Г", "G");
           str = str.Replace("д", "d");
           str = str.Replace("Д", "D");
           str = str.Replace("е", "e");
           str = str.Replace("Е", "E");
		   str = str.Replace("ё", "e");
           str = str.Replace("Ё", "E");
           str = str.Replace("ж", "zh");
           str = str.Replace("Ж", "ZH");
           str = str.Replace("з", "z");
           str = str.Replace("З", "Z");
           str = str.Replace("и", "i");
           str = str.Replace("И", "I");
           str = str.Replace("й", "y");
           str = str.Replace("Й", "Y");
           str = str.Replace("к", "k");
           str = str.Replace("К", "K");
           str = str.Replace("л", "l");
           str = str.Replace("Л", "L");
           str = str.Replace("м", "m");
           str = str.Replace("М", "M");
           str = str.Replace("н", "n");
           str = str.Replace("Н", "N");
           str = str.Replace("о", "o");
           str = str.Replace("О", "O");
           str = str.Replace("п", "p");
           str = str.Replace("П", "P");
           str = str.Replace("р", "r");
           str = str.Replace("Р", "R");
           str = str.Replace("с", "s");
           str = str.Replace("С", "S");
           str = str.Replace("т", "t");
           str = str.Replace("Т", "T");
           str = str.Replace("У", "U");
           str = str.Replace("у", "u");
           str = str.Replace("ф", "f");
           str = str.Replace("Ф", "F");
           str = str.Replace("х", "h");
           str = str.Replace("Х", "H");
           str = str.Replace("ц", "ts");
           str = str.Replace("Ц", "TS");		   
           str = str.Replace("ч", "ch");
           str = str.Replace("Ч", "CH");
           str = str.Replace("ш", "sh");
           str = str.Replace("Ш", "SH");
           str = str.Replace("щ", "shch");
           str = str.Replace("Щ", "SHCH");
           str = str.Replace("ы", "y");
           str = str.Replace("Ы", "Y");
		   str = str.Replace("э", "e");
           str = str.Replace("Э", "E");
           str = str.Replace("ю", "yu");
           str = str.Replace("Ю", "YU");
           str = str.Replace("Я", "YA");
           str = str.Replace("я", "ya");
           str = str.Replace("ь", "");
           str = str.Replace("Ь", "");
           str = str.Replace("ъ", "");
           str = str.Replace("Ъ", "");
           return str;
      
	}
	
	public static string RemoveDiacritics(string value)
	{
		if (String.IsNullOrEmpty(value))
			return value;

		string normalized = value.Normalize(NormalizationForm.FormD);
		StringBuilder sb = new StringBuilder();

		foreach (char c in normalized)
		{
			if (System.Globalization.CharUnicodeInfo.GetUnicodeCategory(c) != System.Globalization.UnicodeCategory.NonSpacingMark)
				sb.Append(c);
		}

		Encoding nonunicode = Encoding.GetEncoding(850);
		Encoding unicode = Encoding.Unicode;

		byte[] nonunicodeBytes = Encoding.Convert(unicode, nonunicode, unicode.GetBytes(sb.ToString()));
		char[] nonunicodeChars = new char[nonunicode.GetCharCount(nonunicodeBytes, 0, nonunicodeBytes.Length)];
		nonunicode.GetChars(nonunicodeBytes, 0, nonunicodeBytes.Length, nonunicodeChars, 0);

		return new string(nonunicodeChars);
	}
	
	public static void convertFolder(string type)
	{	

		string path = type;
		Random rnd = new Random();
		var dir=new DirectoryInfo(path);
		var files = new List<string>(); 
		var songs = new List<string>(); 
		
		
		string TCSoundsStr = "module Tsarcraft\n" + "{\n";
		string TCMusicScriptsStr = "module Tsarcraft\n" +
                                   "{\n" +
                                   "\timports\n" +
                                   "\t{\n" +
                                   "\t\tBase\n" +
                                   "\t}\n" +
                                   "/********************Generated Music Carriers********************/\n" +
                                   "\n";
		
		string TCMusicDefenitionsStr = "if (GlobalMusic == nil) then GlobalMusic = {} end\n" +
                                       "if (MusicPlayer == nil) then MusicPlayer = {} end\n" +
                                       "if (now_play == nil) then now_play = {} end\n\n";
									   
		string TCLoading = "";
							// "require \"Items/Distributions\"\n" + 
							// "require \"Items/ProceduralDistributions\"\n" + 
							// "require \"Items/ItemPicker\"\n\n";
		string unit = "";
		string icon = "";
		int maxIcon = 0;
		if (type == "TCBoombox") 
		{
			unit = "Cassette";
			icon = "TCTape";
			maxIcon = 7;
				
		}
		else if (type == "TCVinylplayer") 
		{
			unit = "Vinyl";
			icon = "TCVinylrecord";
			maxIcon = 5;
		}
		
		
		foreach (FileInfo file in dir.GetFiles())
		{ 
			try 
			{	
				string nameOfExt = Path.GetExtension(file.Name);
				if (nameOfExt == ".mp3" || nameOfExt == ".wav" || nameOfExt == ".ogg")
				{
					string nameOfFile = file.Name.Replace(",", "");
					//Console.WriteLine(nameOfFile);

					
					string nameOfFolder = file.Directory.Name;
					//Console.WriteLine(file.Directory);
					
					string item = "";
					if (Regex.IsMatch(nameOfFile, @"\p{IsCyrillic}+"))
					{
						nameOfFile = TR(nameOfFile);
					}
					nameOfFile = RemoveDiacritics(nameOfFile);			
					
					string nameOfFileWOExt = Path.GetFileNameWithoutExtension(nameOfFile);
					
					if (songs.Contains(nameOfFileWOExt))
					{
						continue;
					}
					//File.Delete(file.Directory + "\\" + nameOfFile); // Delete the existing file if exists
					
					File.Move(file.Directory + "\\" + file.Name, file.Directory + "\\" + nameOfFile);
					// Console.WriteLine(nameOfExt);
					if (nameOfExt == ".mp3")
					{
						// Console.WriteLine("mp3");
						System.Diagnostics.Process process = new System.Diagnostics.Process();
						System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo();
						startInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
						startInfo.WorkingDirectory = Directory.GetCurrentDirectory();
						string cmdRun = "/C audioConverter\\sox.exe \""+ path +"\\" + nameOfFile + "\" \"" + path + "\\" + nameOfFileWOExt + ".ogg\"";
						//Console.WriteLine(cmdRun);
						startInfo.FileName = "cmd.exe";
						startInfo.Arguments = cmdRun;
						process.StartInfo = startInfo;
						process.Start();
						//Console.WriteLine(nameOfFile + " converting to OGG.");
						nameOfFile = nameOfFileWOExt + ".ogg";
					}

					
					item = nameOfFileWOExt.Replace(" ", "").Replace(".", "_");
					
					TCSoundsStr += "\tsound " + item + "\n" +
									"\t{\n" +
									"\t\tcategory = Item,\n" +
									"\t\tclip\n" +
									"\t\t{\n" +
									"\t\t\tfile = media/yourMusic/" + nameOfFolder +"/"+ nameOfFile +",\n" +
									"\t\t\tdistanceMax = 150,\n" +
									"\t\t}\n" +
									"\t}\n";
					int numOfIcon = rnd.Next(1, maxIcon);
					TCMusicScriptsStr += "item " + item + "\n" +
										"\t{\n" +
										"\t\tType\t\t\t=\tNormal,\n" +
										"\t\tWeight\t\t\t=\t0.2,\n" +
										"\t\tIcon\t\t\t=\t" + icon + numOfIcon + ",\n" +
										"\t\tResizeWorldIcon\t=\t0.5,\n" +
										"\t\tDisplayName\t\t=\t" + unit + " " + nameOfFileWOExt + ",\n" +
										"\t}\n\n";
					TCMusicDefenitionsStr += "\tGlobalMusic[\"" + item + "\"] = \"" + nameOfFolder + "\"\n";
					
					if (type == "TCBoombox") 
					{
						TCLoading += "\ttable.insert(ProceduralDistributions[\"list\"][\"BedroomDresser\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"BedroomDresser\"].junk.items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"BedroomSideTable\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"BedroomSideTable\"].junk.items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"CrateCompactDiscs\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"CrateCompactDiscs\"].items, 3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"DeskGeneric\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"DeskGeneric\"].junk.items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"DresserGeneric\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"DresserGeneric\"].junk.items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ElectronicStoreMusic\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ElectronicStoreMusic\"].items, 3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ElectronicStoreMusic\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ElectronicStoreMusic\"].junk.items, 3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LivingRoomShelf\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LivingRoomShelf\"].items, 1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LivingRoomShelfNoTapes\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LivingRoomShelfNoTapes\"].items, 1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"Locker\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"Locker\"].items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LockerClassy\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LockerClassy\"].items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"MusicStoreCDs\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"MusicStoreCDs\"].items, 3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"MusicStoreSpeaker\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"MusicStoreSpeaker\"].items, 3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"OfficeDesk\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"OfficeDesk\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"OfficeDeskHome\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"OfficeDeskHome\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeChild\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeChild\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeMan\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeMan\"].junk.items, 0.1);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeManClassy\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeManClassy\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeRedneck\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeRedneck\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeWoman\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeWoman\"].junk.items, 0.1);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeWomanClassy\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeWomanClassy\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"PoliceDesk\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"PoliceDesk\"].items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"SchoolLockers\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"SchoolLockers\"].items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ShelfGeneric\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ShelfGeneric\"].items, 0.2);\n";
					}
					else if (type == "TCVinylplayer") 
					{
						TCLoading += 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"BedroomDresser\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"BedroomDresser\"].junk.items, 0.3);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"BedroomSideTable\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"BedroomSideTable\"].junk.items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"CrateCompactDiscs\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"CrateCompactDiscs\"].items, 3);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"DeskGeneric\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"DeskGeneric\"].junk.items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"DresserGeneric\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"DresserGeneric\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ElectronicStoreMusic\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ElectronicStoreMusic\"].items, 1);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"ElectronicStoreMusic\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"ElectronicStoreMusic\"].junk.items, 1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LivingRoomShelf\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LivingRoomShelf\"].items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LivingRoomShelfNoTapes\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LivingRoomShelfNoTapes\"].items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"Locker\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"Locker\"].items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LockerClassy\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"LockerClassy\"].items, 0.3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"MusicStoreCDs\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"MusicStoreCDs\"].items, 3);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"MusicStoreSpeaker\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"MusicStoreSpeaker\"].items, 3);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"OfficeDesk\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"OfficeDesk\"].junk.items, 0.1);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"OfficeDeskHome\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"OfficeDeskHome\"].junk.items, 0.1);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeChild\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeChild\"].junk.items, 0.1);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeMan\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeMan\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeManClassy\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeManClassy\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeRedneck\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeRedneck\"].junk.items, 0.1);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeWoman\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeWoman\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeWomanClassy\"].junk.items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"WardrobeWomanClassy\"].junk.items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"PoliceDesk\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"PoliceDesk\"].items, 0.1);\n" +
								 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"SchoolLockers\"].items, \"Tsarcraft." + item + "\");\n" + 
								 // "\ttable.insert(ProceduralDistributions[\"list\"][\"SchoolLockers\"].items, 0.1);\n" +
								 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ShelfGeneric\"].items, \"Tsarcraft." + item + "\");\n" + 
								 "\ttable.insert(ProceduralDistributions[\"list\"][\"ShelfGeneric\"].items, 0.2);\n";
					}					 
								 
					songs.Add(nameOfFileWOExt);
				}
			}
			catch (Exception e) 
			{
				using (StreamWriter sw = new StreamWriter(@"error.log", true, System.Text.Encoding.Default))
                {
                    Console.WriteLine("Some error with file: " + file.Name);
					Console.WriteLine(e);
					sw.WriteLine("Some error with file: " + file.Name);
					sw.WriteLine(e);
                }
			}
		}
		TCSoundsStr += "}";
		TCMusicScriptsStr += "}";
		// Console.WriteLine("TCSoundsStr");
		// Console.WriteLine(TCSoundsStr);
		// Console.WriteLine("TCMusicScriptsStr");
		// Console.WriteLine(TCMusicScriptsStr);
		// Console.WriteLine("TCMusicDefenitionsStr");
		// Console.WriteLine(TCMusicDefenitionsStr);
		using (StreamWriter sw = new StreamWriter(@"../scripts/TCGSounds" + type + ".txt", false, System.Text.Encoding.Default))
                {
                    sw.WriteLine(TCSoundsStr);
                }
		using (StreamWriter sw = new StreamWriter(@"../scripts/TCGMusicScript" + type + ".txt", false, System.Text.Encoding.Default))
                {
                    sw.WriteLine(TCMusicScriptsStr);
                }
		using (StreamWriter sw = new StreamWriter(@"../lua/client/Music/TCGMusicDefenitions" + type + ".lua", false, System.Text.Encoding.Default))
                {
                    sw.WriteLine(TCMusicDefenitionsStr);
                }
		using (StreamWriter sw = new StreamWriter(@"../lua/server/Items/TCGLoading" + type + ".lua", false, System.Text.Encoding.Default))
				{
					sw.WriteLine(TCLoading);
				}
		Console.WriteLine("Completed for " + type + ".\nAdded new music:");
		foreach (String song in songs)
		{
			 Console.WriteLine(song);
		}
	}
}
