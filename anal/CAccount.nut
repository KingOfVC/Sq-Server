class CAccount
{
	player = null;
	Logged = false;
	Password = null;
	Level = 0;
	LastLogin = 0;
	
	constructor( player )
	{
		this.player = player;
		local q = SqSQLite.Query( "SELECT * FROM Accounts WHERE lower(Name) = '" + player.Name.tolower() + "' " );
		if( q.Step() )
		{
			this.Password = q.GetValue( "Password" );
				
			if( player.UID2 == q.GetValue( "UID2" ) )
			{
			/*	local cStats = ::CStats( player );
				Stats.rawset( player.ID, cStats );*/
					
				player.Message( "%s>> You were auto logged.", Color.Green );
					
				this.Level = q.GetValue( "Level" ).tointeger();
				this.Logged = true;
				this.LastLogin = ::time();
			}
			else 
			{
				player.Message( "%s>> You are not logged, use /login to login.", Color.Orange );
				this.Level = q.GetValue( "Level" );
			}
		}
		else player.Message( "%s>> You are not registered, please use /register to register.", Color.Orange );
	}
	
	function Register( password )
	{
		/*local cStats = ::CStats( player );
		Stats.rawset( player.ID, cStats );*/

		SqSQLite.Exec( "INSERT INTO Accounts VALUES ( '" + this.player.Name + "', '" + SqHash.GetWhirlpool( password ) + "', '1', '" + this.player.IP + "', '" + this.player.UID + "', '" + this.player.UID2 + "', '" + time() + "', '" + time() + "') " );
		
		player.Message( "%s>> You are registered.", Color.Green );
	
		this.Password = SqHash.GetWhirlpool( password );
		this.Level = 1;
		this.Logged = true;
		this.LastLogin = time();
	}

	function Login()
	{
		local cStats = ::CStats( player );
		Stats.rawset( player.ID, cStats );

		player.Message( "%s>> You are logged.", Color.Green );
	
		this.Logged = true;
		this.LastLogin = time();
	}
	
	function SaveData()
	{
		SqSQLite.Exec( "BEGIN TRANSACTION" );
		SqSQLite.Exec( "UPDATE Accounts SET Password = '" + this.Password + "', Level = '" + this.Level + "', IP = '" + this.IP + "', UID1 = '" + this.player.UID + "', UID2 = '" + this.player.UID2 + "', LastLogin = '" + this.LastLogin + "' WHERE lower(Name) = '" + this.player.Name.tolower() + "'" );
		SqSQLite.Exec( "END TRANSACTION" );
	}
}

Account <- {}