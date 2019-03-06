AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
 
	self:SetModel( "models/props_c17/oildrum001.mdl" )
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
    activator:SetJumpPower(320)
    if timer.Exists("JumpupTimer_"..activator:AccountID()) then
        timer.Destroy("JumpupTimer_"..activator:AccountID())
    end
    timer.Create("JumpupTimer_"..activator:AccountID(),GetConVar("cw_jumpup_duration"):GetInt(),1, function()
        activator:SetJumpPower(180)
    end)

end

function ENT:OnTakeDamage(damage)
    local activator = damage:GetAttacker()
    activator:SetJumpPower(320)

    timer.Create("JumpupTimer_"..activator:AccountID(),GetConVar("cw_jumpup_duration"):GetInt(),1, function()
        activator:SetJumpPower(180)
    end)
    self:PrecacheGibs()
    self:GibBreakClient(damage:GetDamageForce())
    self:Remove()
end

hook.Add("DoPlayerDeath", "Jumpup_Powerup_Death", function(ply)
    ply:SetJumpPower(180)
    if timer.Exists("JumpupTimer_"..ply:AccountID()) then
        timer.Destroy("JumpupTimer_"..ply:AccountID())
    end
end)

CreateConVar("cw_jumpup_duration", "15", FCVAR_LUA_SERVER, "Set Jump Powerup Duration")