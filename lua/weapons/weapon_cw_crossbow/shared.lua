SWEP.PrintName = "Crossbow War Crossbow"
SWEP.Category = "Crossbow Wars"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Base = "weapon_base"

SWEP.ViewModelFlip = false 
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_crossbow.mdl" 
SWEP.WorldModel = "models/weapons/w_crossbow.mdl" 
SWEP.DrawAmmo = false 

SWEP.UseHands = true 
SWEP.HoldType = "Crossbow" 
SWEP.FiresUnderwater = false 
SWEP.Primary = {Ammo="none", Automatic=false, ClipSize=1, Damage=100}
SWEP.Secondary = {Ammo="none"}

SWEP.AccurateCrosshair = true



function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire( CurTime())
    local pPlayer = self.Owner;

    if ( !pPlayer ) then return end 
    local vecSrc = pPlayer:GetShootPos();
    local vecAiming = pPlayer:GetAimVector();


    //print("ok")
    if ( CLIENT ) then return end
    local pBolt = ents.Create( "cw_crossbow_bolt" );

    if(!IsValid(pBolt)) then return end
    pBolt.m_iDamage = self.Primary.Damage;
    pBolt.Attacker = self.Owner
    pBolt:Spawn()
    pBolt:SetPos( self.Owner:EyePos() + self.Owner:GetAimVector():GetNormalized() * 30 )
    pBolt:SetOwner(self.Owner)
    shootVector = self.Owner:GetVelocity() + self.Owner:GetAimVector() * 3200
    pBolt:SetAngles(self.Owner:GetAimVector():Angle())
    pBolt:GetPhysicsObject():SetVelocity(shootVector)
end

function SWEP:ShootBullet(damage, num_bullets, aimcone)
 // Only the player fires this way so we can cast
    
end

function SWEP:SecondaryAttack()

end

--[[ function SWEP:Reload()
    print("reload")
    self.Weapon:DefaultReload(ACT_VM_RELOAD)
    return true
end ]]