Setting <-
{
	ServerName = "Anal's server",
	ServerGamemode = "DM v1.0",
	ServerPassword = "",
	ServerMaxPlayers = 100,
	
	ScriptPath = "anal/",
	
	DatabaseName = "database",
}

dofile( Setting.ScriptPath + "Main.nut", true );
InitServer();