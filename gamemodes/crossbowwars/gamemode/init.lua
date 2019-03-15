AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_pickteam.lua")

include("shared.lua")

local interval = .01
local intinv = 1/interval

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
	print(ply.PoweredUp)
	if(key==IN_RELOAD) then
		if(ply.Powerup) then
			ply.PoweredUp = true
			ply:SendLua("LocalPlayer().PowereupFraction="..ply.PowerupFraction)
			ply:SendLua("LocalPlayer().PoweredUp=true")
			ply.Powerup:Powerup(ply)
			ply.PowerupIntervalCount = 0
			ply.PowerupFraction = 0
			ply.LastPowerup = ply.Powerup
			timer.Create("PowerupDurationUpdater_"..ply:UserID(),interval,ply.LastPowerup.duration*intinv,function()
				print(ply.PowerupFraction)
				local pu = ply.LastPowerup
				ply.PowerupIntervalCount = ply.PowerupIntervalCount + 1
				ply.PowerupFraction = ply.PowerupIntervalCount/(pu.duration*intinv)
				ply:SendLua("LocalPlayer().PowerupFraction="..ply.PowerupFraction)
			end)
			timer.Create("PowerupStatus_"..ply:UserID(),ply.LastPowerup.duration,1,function()
				ply.PoweredUp = false
				ply:SendLua("LocalPlayer().PoweredUp=false")
			end)
			ply.Powerup = nil
		else
			print("no powerup")
		end
	end
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if(victim.Powerup) then victim.Powerup = nil end
	if(timer.Exists("PowerupTimer_"..victim:UserID())) then
		timer.Adjust("PowerupTimer_"..victim:UserID(), 0, 1)
	end
	if(timer.Exists("PowerupDurationUpdater_"..victim:UserID())) then
		timer.Adjust("PowerupDurationUpdater_"..victim:UserID(), 0, 1)
	end
	if(timer.Exists("PowerupStatus_"..victim:UserID())) then
		timer.Adjust("PowerupStatus_"..victim:UserID(), 0, 1)
	end
end

