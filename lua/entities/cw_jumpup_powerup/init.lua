AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

CreateConVar("cw_jumpup_duration", "15", FCVAR_LUA_SERVER, "Set Jump Powerup Duration")

function ENT:Initialize()
	self:SetModel( "models/props_c17/oildrum001.mdl" )
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
            ent:SetJumpPower(320)
            if timer.Exists("JumpupTimer_"..ent:UserID()) then
                timer.Destroy("JumpupTimer_"..ent:UserID())
            end
            timer.Create("JumpupTimer_"..ent:UserID(),GetConVar("cw_jumpup_duration"):GetInt(),1, function()
                ent:SetJumpPower(180)
            end)
            self:Remove()
        end
    end
end

hook.Add("DoPlayerDeath", "Jumpup_Powerup_Death", function(ply)
    ply:SetJumpPower(180)
    print(ply:UserID())
    print("BRUG FUCG")
    if timer.Exists("JumpupTimer_"..ply:UserID()) then
        timer.Destroy("JumpupTimer_"..ply:UserID())
    end
end)