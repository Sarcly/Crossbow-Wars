AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

CreateConVar("cw_jump_powerup_duration", "15", FCVAR_LUA_SERVER, "Set Jump Powerup Duration")
CreateConVar("cw_speed_powerup_duration", "15", FCVAR_LUA_SERVER, "Set Speed Powerup Duration")
CreateConVar("cw_speed_powerup_speed", "600", FCVAR_LUA_SERVER, "Set how fast the speed up power up makes you")
CreateConVar("cw_multishot_powerup_duration", "30", FCVAR_LUA_SERVER, "How long the multishot powerup lasts")
CreateConVar("cw_walkspeed", "270", FCVAR_LUA_SERVER, "Set how fast the player walks without powerups")
CreateConVar("cw_runspeed", "360", FCVAR_LUA_SERVER, "Set how fast the player runs without powerups")
CreateConVar("cw_jumpheight", "180", FCVAR_LUA_SERVER, "Set how high the player jumps without powerups")
CreateConVar("cw_jump_powerup_height", "320", FCVAR_LUA_SERVER, "Set how high the player jumps with the jump powerup")

local powerup_table = {}

local speed_powerup = {
    duration="cw_speed_powerup_duration",
    name="Speed Powerup"
}
function speed_powerup:Powerup(ent)
    ent:SetWalkSpeed(GetConVar("cw_speed_powerup_speed"):GetInt())
    ent:SetRunSpeed(GetConVar("cw_speed_powerup_speed"):GetInt())
    if timer.Exists("PowerupTimer_"..ent:UserID()) then
        timer.Remove("PowerupTimer_"..ent:UserID())
    end
    timer.Create("PowerupTimer_"..ent:UserID(),GetConVar(self.duration):GetInt(),1, function()
        ent:SetWalkSpeed(GetConVar("cw_walkspeed"):GetInt())
        ent:SetRunSpeed(GetConVar("cw_runspeed"):GetInt())
    end)
end

local multishot_powerup = {
    duration="cw_multishot_powerup_duration",
    name="Multishot Powerup"
}

function multishot_powerup:Powerup(ent)
    ent.Multishot = true
    if timer.Exists("PowerupTimer_"..ent:UserID()) then
        timer.Remove("PowerupTimer_"..ent:UserID())
    end
    timer.Create("PowerupTimer_"..ent:UserID(),GetConVar(self.duration):GetInt(),1, function()
        ent.Multishot = false
    end)
end

local jump_powerup = {
    duration="cw_jump_powerup_duration",
    name="Jump Powerup"
}

function jump_powerup:Powerup(ent)
    ent:SetJumpPower(GetConVar("cw_jump_powerup_height"):GetInt())
    if timer.Exists("PowerupTimer_"..ent:UserID()) then
        timer.Remove("PowerupTimer_"..ent:UserID())
    end
    timer.Create("PowerupTimer_"..ent:UserID(),GetConVar(self.duration):GetInt(),1, function()
        ent:SetJumpPower(GetConVar("cw_jumpheight"):GetInt())
    end)
end

local shield_powerup = {
    duration=0,
    name="Shield Powerup"
}

function  shield_powerup:Powerup(ent)
    ent:SetNWBool("cwshield", true)
end

powerup_table[#powerup_table+1]=speed_powerup
powerup_table[#powerup_table+1]=multishot_powerup
powerup_table[#powerup_table+1]=jump_powerup
powerup_table[#powerup_table+1]=shield_powerup

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
        if (ent:IsPlayer() --[[ && !ent.Powerup ]]  && !ent.PoweredUp) then
            local powerup_index = math.random(#powerup_table)
            ent:ChatPrint("Picked up "..powerup_table[powerup_index].name)
            ent.Powerup = powerup_table[powerup_index]
            ent:SetNWString("PowerupName", ent.Powerup.name)
            self:Remove()
        end
    end
end

