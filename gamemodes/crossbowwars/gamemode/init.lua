AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_pickteam.lua")

include("shared.lua")

function GM:CreateTeams()
    team.SetUp(1,"Fighters", Color(255,0,0))
	team.SetUp(2,"Spectators",Color(150,150,150))
end

function ChangeMyTeam( ply, cmd, args )
	local _team = args[ 1 ] && tonumber( args[ 1 ] ) || 0;
	ply:SetTeam( _team );
	ply:Spawn( );
end
concommand.Add( "set_team", ChangeMyTeam );

function GM:PlayerSpawn(ply)
	if ply:Team()==1 then
		ply:UnSpectate()
		ply:Give("weapon_cw_crossbow")
		ply:SetAmmo(36, "XBowBolt", true)
	elseif ply:Team()==2 then
		ply:Spectate(OBS_MODE_CHASE)
	end
end

function GM:KeyPress(ply, key)
	if(key==IN_RELOAD) then
		if(ply.Powerup) then
			ply.Powerup.powerup()
			ply.Powerup = nil
		else
			print("no powerup")
		end
	end
end