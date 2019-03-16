AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_pickteam.lua")
AddCSLuaFile("cl_drawhud.lua")
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
	if (IsValid(ply.ragdoll)) then
		ply.ragdoll:Remove()
	end
	ply:SetModel("models/player/gasmask.mdl")
	ply:SetupHands()
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

function GM:PlayerSetHandsModel(ply, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end
end

function GM:KeyPress(ply, key)
	if(key==IN_RELOAD) then
		if(ply.Powerup) then
			local powerup = ply.Powerup
			local duration = GetConVar(powerup.duration):GetInt()
			ply.PoweredUp = true
			ply:SetNWFloat("PowerupFraction", 0)
			ply:SetNWBool("PoweredUp", true)
			ply:SetNWInt("PowerupDuration", duration)
			ply.Powerup:Powerup(ply)
			ply.PowerupIntervalCount = 0
			ply.PowerupFraction = 0
			timer.Create("PowerupDurationUpdater_"..ply:UserID(),interval,duration*intinv,function()
				ply.PowerupIntervalCount = ply.PowerupIntervalCount + 1
				ply.PowerupFraction = ply.PowerupIntervalCount/(duration*intinv)
				ply:SetNWFloat("PowerupFraction", ply.PowerupFraction)
			end)
			timer.Create("PowerupStatus_"..ply:UserID(),duration,1,function()
				ply.PoweredUp = false
				ply:SetNWFloat("PowerupFraction", 0)
				ply:SetNWBool("PoweredUp", false)
				ply:SetNWString("PowerupName","")
			end)
			ply.Powerup = nil
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

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:CreateRagdoll()
	ply.ragdoll = ents.Create("prop_ragdoll")
	ply.ragdoll:SetPos(ply:GetPos())
   	ply.ragdoll:SetModel(ply:GetModel())
  	ply.ragdoll:SetSkin(ply:GetSkin())
   	for key, value in pairs(ply:GetBodyGroups()) do
    	ply.ragdoll:SetBodygroup(value.id, ply:GetBodygroup(value.id))	
   	end
   	ply.ragdoll:SetAngles(ply:GetAngles())
   	ply.ragdoll:SetColor(ply:GetColor())
   	ply.ragdoll:Spawn()
   	ply.ragdoll:Activate()
	local num = ply.ragdoll:GetPhysicsObjectCount()-1
   	local v = ply:GetVelocity()
   	if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_SLASH) then
    	v = v / 5
   	end
   	for i=0, num do
      	local bone = ply.ragdoll:GetPhysicsObjectNum(i)
      	if IsValid(bone) then
        	local bp, ba = ply:GetBonePosition(ply.ragdoll:TranslatePhysBoneToBone(i))
        	if bp and ba then
        		bone:SetPos(bp)
        		bone:SetAngles(ba)
        	end
        	bone:SetVelocity(v)
    	end
   	end
end

