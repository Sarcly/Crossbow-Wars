SWEP.PrintName = "Crossbow Wars Crossbow"
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
    if !(self.Weapon:GetNextPrimaryFire() < CurTime()) then return end
    local ply = self.Owner
    ply:EmitSound("Weapon_Crossbow.BoltFly")
    ply:EmitSound(Sound("weapons/crossbow/fire1.wav"))
    self.Weapon:SetNextPrimaryFire(CurTime() + 2.4)
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    ply:MuzzleFlash()							
    ply:SetAnimation( PLAYER_ATTACK1 )
    ply:ViewPunch(Angle(-2,0,0))
    local selfclass = self:GetClass()
    timer.Simple( 0.6, 
        function() 
            if (IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()==selfclass) then 
                ply:GetActiveWeapon():SendWeaponAnim( ACT_VM_RELOAD ) 
                timer.Simple(1,
                    function()
                        if (IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass()==selfclass) then 
                            ply:EmitSound("Weapon_Crossbow.BoltElectrify") 
                        end 
                    end) 
                end 
            end)
	local bolt = ents.Create("crossbow_bolt")
	bolt:SetOwner(ply)
	bolt:SetPos(ply:GetShootPos())
	bolt:SetAngles(ply:EyeAngles())
	bolt:Spawn()
	bolt:Activate()
	bolt:SetVelocity(ply:GetAimVector()*3000)
	bolt.IsScripted = true
end

function SWEP:SecondaryAttack()
    if !(self:GetNetworkedBool("zoomed")) then
        self:SetNetworkedBool("zoomed", true)
        self.Owner:SetFOV( 20, 0.1 )
    else
        self.Owner:SetFOV( 0, 0.1 )
        self:SetNetworkedBool("zoomed", false)
    end
end