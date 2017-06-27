class CCommands
{
	Cmd = null;
	
	Register = null;
	Login = null;
	Changepass = null;
	
	constructor()
	{
		this.Cmd = SqCmd.Manager();
		
		this.Cmd.BindFail( this, this.funcFailCommand );
		
		this.Register = this.Cmd.Create("register", "s", [ "Password" ], 1, 1, -1, true, true );
		this.Login = this.Cmd.Create("login", "s", [ "Password" ], 1, 1, -1, true, true );
		this.Changepass = this.Cmd.Create("changepass", "s|s", [ "OldPassword", "NewPassword" ], 2, 2, -1, true, true );

		this.Register.BindExec( this.Register, this.funcRegister );
		this.Login.BindExec( this.Login, this.funcLogin );
		this.Changepass.BindExec( this.Changepass, this.funcChangePass );
		
	}
	
	function funcFailCommand( type, msg, payload )
	{
		local player = this.Cmd.Invoker, cmd = this.Cmd.Command;
		
		switch( type )
		{
			case SqCmdErr.EmptyCommand:
			player.Message( "%s>> %s", Color.Red, msg );
			break;
			
			case SqCmdErr.InvalidCommand:
			player.Message( "%s>> %s", Color.Red, msg );
			break;

			case SqCmdErr.UnknownCommand:
			player.Message( "%s>> %s", Color.Red, msg );
			break;

			case SqCmdErr.MissingExecuter:
			player.Message( "%s>> %s", Color.Red, msg );
			break;
			
			case SqCmdErr.IncompleteArgs:
			player.Message( "%s>> %s", Color.Red, msg );
			break;
	
			case SqCmdErr.ExtraneousArgs:
			player.Message( "%s>> %s", Color.Red, msg );
			break;

			case SqCmdErr.UnsupportedArg:
			player.Message( "%s>> %s", Color.Red, msg );
			break;
		}
	}
	
	function funcRegister( player, args )
	{
		local account = Account[ player.ID ];
		if( account.Level == 0 )
		{
			if( args.Password.len() > 5 )
			{
				account.Register( args.Password );
			}
			else player.Message( "%s>> Password lengh must greater than 5.", Color.Red );
		}
		else player.Message( "%s>> You already registered.", Color.Red );
		
		return true;
	}
	
	function funcLogin( player, args )
	{
		local account = Account[ player.ID ];
		if( account.Level != 0 )
		{
			if( account.Logged == false )
			{
				if( account.Password == SqHash.GetWhirlpool( args.Password ) )
				{
					account.Login();
				}
				else player.Message( "%s>> Wrong password.", Color.Red );
			}
			else player.Message( "%s>> You already logged.", Color.Red );
		}
		else player.Message( "%s>> You are not registered.", Color.Red );
	
		return true;
	}

	function funcChangePass( player, args )
	{
		local account = Account[ player.ID ];
		if( account.Level != 0 )
		{
			if( account.Logged == true )
			{
				if( account.Password == SqHash.GetWhirlpool( args.OldPassword ) )
				{
					if( args.NewPassword.len() > 5 )
					{
						account.Password = SqHash.GetWhirlpool( args.NewPassword );
						player.Message( "%s>> You account password has been changed.", Color.Green );
					}
					else player.Message( "%s>> New password lengh must greater than 5.", Color.Red );
				}
				else player.Message( "%s>> You entered wrong old password.", Color.Red );
			}
			else player.Message( "%s>> You are not logged.", Color.Red );
		}
		else player.Message( "%s>> You are not registered.", Color.Red );
		
		return true;
	}
	
}

Cmd <- CCommands();