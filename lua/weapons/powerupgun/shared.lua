SWEP.PrintName = "Kitchen Gun"
SWEP.Category = "Other"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Base = "weapon_base"

SWEP.ViewModelFlip = false 
SWEP.ViewModelFOV = 60 
SWEP.ViewModel = "models/weapons/c_pistol.mdl" 
SWEP.WorldModel = "models/weapons/w_pistol.mdl" 

SWEP.UseHands = true 
SWEP.HoldType = "Pistol" 
SWEP.FiresUnderwater = false 
SWEP.CSMuzzleFlashes = true

function SWEP:PrimaryAttack()
    local tr = self.Owner:GetEyeTrace()
    //if(tr.HitWorld) then return end

    local ent
    ent = ents.Create("speedup_powerup")
    ent:SetPos(tr.HitPos+ self.Owner:GetAimVector()*-16)
    ent:SetAngles(tr.HitNormal:Angle() )
    ent:Spawn()
end