AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

local DEFAULT_WALKSPEED = 270
local DEFAULT_RUNSPEED = 360

function ENT:Initialize()
 
	self:SetModel( "models/props_junk/wood_crate001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

--[[ function GM:PostGamemodeLoaded()
    print("Loaded Powerup")
end ]]

function ENT:SpawnFunction( ply, tr )
    if !tr.Hit then return end
    local e = ents.Create(ClassName)
    e:SetPos(tr.HitPos+tr.HitNormal*16) 
    e:Spawn()
    e:Activate()
    return e
end
 
function ENT:Use( activator, caller )
    activator:SetWalkSpeed(500)
    activator:SetRunSpeed(500)
    if timer.Exists("SpeedupTimer_"..ply:AccountID()) then
        print("Destroying Timer")
        timer.Destroy("SpeedupTimer_"..ply:AccountID())
    end
    timer.Create("SpeedupTimer_"..activator:AccountID(),GetConVar("cw_powerupduration"):GetInt(),1, function()
        print("Speedup turns off")
        activator:SetWalkSpeed(DEFAULT_WALKSPEED)
        activator:SetRunSpeed(DEFAULT_RUNSPEED)
    end)

end

function ENT:OnTakeDamage(damage)
    local activator = damage:GetAttacker()
    activator:SetWalkSpeed(500)
    activator:SetRunSpeed(500)

    timer.Create("SpeedupTimer_"..activator:AccountID(),GetConVar("cw_powerupduration"):GetInt(),1, function()
        print("Speedup turns off")
        activator:SetWalkSpeed(DEFAULT_WALKSPEED)
        activator:SetRunSpeed(DEFAULT_RUNSPEED)
    end)
    self:PrecacheGibs()
    self:GibBreakClient(damage:GetDamageForce())
    self:Remove()
end

hook.Add("DoPlayerDeath", "Speedup_Powerup_Death", function(ply)
    ply:SetWalkSpeed(DEFAULT_WALKSPEED)
    ply:SetRunSpeed(DEFAULT_RUNSPEED)
    if timer.Exists("SpeedupTimer_"..ply:AccountID()) then
        print("Destroying Timer")
        timer.Destroy("SpeedupTimer_"..ply:AccountID())
    end
end)

CreateConVar("cw_powerupduration", "15", FCVAR_LUA_SERVER, "Set Powerup Duration")