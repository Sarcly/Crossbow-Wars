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
    if !(self.Weapon:GetNextPrimaryFire() < CurTime()) then return end
    self.Owner:EmitSound("Weapon_Crossbow.BoltFly")
    self.Owner:EmitSound(Sound("weapons/crossbow/fire1.wav"))
    self.Weapon:SetNextPrimaryFire(CurTime() + 2.4)
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:MuzzleFlash()							
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Owner:ViewPunch(Angle(-2,0,0))
    local ply = self.Owner
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
	bolt:SetOwner(self.Owner)
	bolt:SetPos(self.Owner:GetShootPos())
	bolt:SetAngles(self.Owner:EyeAngles())
	bolt:Spawn()
	bolt:Activate()
	bolt:SetVelocity(self.Owner:GetAimVector()*3000)
	bolt.IsScripted = true
end

function SWEP:SecondaryAttack()
    if !(self.Weapon:GetNextPrimaryFire() < CurTime()) then return end
    self.Weapon:SetNextPrimaryFire(CurTime() + 0.6)
    if !self:GetNetworkedBool( "Ironsights" ) then
        self:SetNetworkedBool( "Ironsights", true )
        self.Owner:SetFOV( 55, 0.1 )
    else
        self.Owner:SetFOV( 0, 0.1 )
        self:SetNetworkedBool( "Ironsights", false )
    end
end