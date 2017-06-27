function InitServer()
{
	print( "== Start loading " + Setting.ServerName + " script ==" );
	SqSQLite <- SQLite.Connection( "database.db" );
	
	dofile( Setting.ScriptPath + "Color.nut", true );
	dofile( Setting.ScriptPath + "CAccount.nut", true );
	dofile( Setting.ScriptPath + "CCommands.nut", true );
	dofile( Setting.ScriptPath + "CStats.nut", true );
	
	SqServer.SetServerName( Setting.ServerName );
	SqServer.SetGameModeText( Setting.ServerGamemode );
	SqServer.SetPassword( Setting.ServerPassword );
	SqServer.SetMaxPlayers( Setting.ServerMaxPlayers );


	SqSQLite.Exec( "CREATE TABLE IF NOT EXISTS Accounts ( Name TEXT, Password TEXT, Level NUMBERIC, IP TEXT, UID1 TEXT, UID2 TEXT, LastLogin NUMBERIC, RegTime NUMBERIC )" );
}

SqCore.On().PlayerCommand.Connect( this, function( player, command ) 
{
	Cmd.Cmd.Run( player,command );
});

SqCore.On().PlayerCreated.Connect( this, function( player, header, payload ) 
{
	local initAccount = CAccount( player );
	Account.rawset( player.ID, initAccount );
});

SqCore.On().PlayerDestroyed.Connect( this, function( player, header, payload )
{
	local account = Account[ player.ID ];
	if( account.Logged == true )
	{
		if( Stats.rawin( player.ID ) )
		{
			local stats = Stats[ player.ID ];
			account.SaveData();
			stats.SaveData();
			
			Stats.rawdelete( player.ID );
		}
	}
	Account.rawdelete( player.ID );
});