AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

local POWERUP_SPEED = GetConVar("cw_speedup_speed"):GetInt()
local DEFAULT_WALKSPEED = 270
local DEFAULT_RUNSPEED = 360

function ENT:Initialize()
 
	self:SetModel( "models/props_junk/wood_crate001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:SpawnFunction( ply, tr )
    if !tr.Hit then return end
    local e = ents.Create(ClassName)
    e:SetPos(tr.HitPos+tr.HitNormal*16) 
    e:Spawn()
    e:Activate()
    return e
end

function ENT:Think()
    local entNear = ents.FindInSphere(self:WorldSpaceCenter(), 50)
    for index, ent in pairs(entNear) do 
        if ent:IsPlayer() then 
            ent:SetWalkSpeed(POWERUP_SPEED)
            ent:SetRunSpeed(POWERUP_SPEED)
            if timer.Exists("SpeedupTimer_"..ent:AccountID()) then
                timer.Destroy("SpeedupTimer_"..ent:AccountID())
            end
            timer.Create("SpeedupTimer_"..ent:AccountID(),GetConVar("cw_speedup_duration"):GetInt(),1, function()
                ent:SetWalkSpeed(DEFAULT_WALKSPEED)
                ent:SetRunSpeed(DEFAULT_RUNSPEED)
            end)
            self:Remove()
        end
    end
end

hook.Add("DoPlayerDeath", "Speedup_Powerup_Death", function(ply)
    ply:SetWalkSpeed(DEFAULT_WALKSPEED)
    ply:SetRunSpeed(DEFAULT_RUNSPEED)
    if timer.Exists("SpeedupTimer_"..ply:AccountID()) then
        timer.Destroy("SpeedupTimer_"..ply:AccountID())
    end
end)

CreateConVar("cw_speedup_duration", "15", FCVAR_LUA_SERVER, "Set Speed Powerup Duration")
CreateConVar("cw_speedup_speed", "600", FCVAR_LUA_SERVER, "Set how fast the speed up power up makes you. Normal runspeed is 360")