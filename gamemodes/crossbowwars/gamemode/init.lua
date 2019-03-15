AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_pickteam.lua")
AddCSLuaFile("drawarc.lua")
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
	ply:SetWalkSpeed(GetConVar("cw_walkspeed"):GetInt() or 270)
	ply:SetRunSpeed(GetConVar("cw_runspeed"):GetInt() or 360)
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
			PrintTable(ply.Powerup)
			ply.PoweredUp = true
			ply:SetNWFloat("PowerupFraction", 0)
			ply:SetNWBool("PoweredUp", true)
			ply.Powerup:Powerup(ply)
			ply.PowerupIntervalCount = 0
			ply.PowerupFraction = 0
			local powerup = ply.Powerup
			local duration = GetConVar(powerup.duration):GetInt()
			print("DURATION:"..duration)
			timer.Create("PowerupDurationUpdater_"..ply:UserID(),interval,duration*intinv,function()
				print("fraction:"..ply.PowerupFraction)
				print("intervalcount:"..ply.PowerupIntervalCount)
				ply.PowerupIntervalCount = ply.PowerupIntervalCount + 1
				ply.PowerupFraction = ply.PowerupIntervalCount/(duration*intinv)
				ply:SetNWFloat("PowerupFraction", ply.PowerupFraction)
			end)
			timer.Create("PowerupStatus_"..ply:UserID(),duration,1,function()
				ply.PoweredUp = false
				ply:SetNWFloat("PowerupFraction", 0)
				ply:SetNWBool("PoweredUp", false)
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

