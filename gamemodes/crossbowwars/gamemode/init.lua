AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_pickteam.lua")

include("shared.lua")

function GM:CreateTeams()
    team.SetUp(1,"Fighters", Color(255,0,0))
	team.SetUp(2,"Spectators",Color(150,150,150))
end

function GM:PlayerSpawn( ply )
	//PrintMessage(4, "Knot my thrussy pwease")
end

function ChangeMyTeam( ply, cmd, args )
	// _team is set to the first argument converted to a number, if an argument has been provided, or it is set to 0 as a default value.
	// local _team =              && tonumber( args[ 1 ] )     ,                args[ 1 ]         ,              || 0
	local _team = args[ 1 ] && tonumber( args[ 1 ] ) || 0;
	ply:SetTeam( _team );
	ply:Spawn( );
end
concommand.Add( "set_team", ChangeMyTeam );

function GM:PlayerSpawn(ply)
	if ply:Team()==1 then
		ply:UnSpectate()
	elseif ply:Team()==2 then
		ply:Spectate(OBS_MODE_CHASE)
	end
end
