SWEP.PrintName = "Crossbow Wars Crossbow"
SWEP.Category = "Crossbow Wars"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Base = "weapon_base"

SWEP.ViewModelFlip = false 
SWEP.ViewModelFOV = 54
SWEP.ViewModel = "models/weapons/c_crossbow.mdl" 
SWEP.WorldModel = "models/weapons/w_crossbow.mdl" 
SWEP.DrawAmmo = true 

game.AddAmmoType( {
	name = "cwPowerup",
	dmgtype = DMG_GENERIC
})

SWEP.UseHands = true 
SWEP.HoldType = "Crossbow" 
SWEP.FiresUnderwater = false 

SWEP.Primary.Ammo = "XBowBolt"
SWEP.Primary.Damage = 100
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary = {Ammo="none", Automatic=false, ClipSize=-1, DefaultClip=-1}

SWEP.AccurateCrosshair = true

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1()
		self.AmmoDisplay.PrimaryAmmo = self:Ammo1()
	end
	if self.Secondary.ClipSize > 0 then
		self.AmmoDisplay.SecondaryAmmo = -1
	end
	return self.AmmoDisplay 
end

function SWEP:Initialize()
    util.PrecacheSound("Weapon_Crossbow.BoltFly")
    util.PrecacheSound(Sound("weapons/crossbow/fire1.wav"))
    util.PrecacheSound("Weapon_Crossbow.BoltElectrify")
end

function SWEP:PrimaryAttack()
    if !(self.Weapon:GetNextPrimaryFire() < CurTime()) then return end
    if (self:GetNetworkedBool("cwreloading")) then return end
    if (self:Ammo1()<=0 and self:Clip1()<=0) then return end
    if (self:Clip1()<=0) then 
        self:Reload()
        return
    end
    local ply = self.Owner
    ply:EmitSound("Weapon_Crossbow.BoltFly")
    ply:EmitSound(Sound("weapons/crossbow/fire1.wav"))
    self:TakePrimaryAmmo(1)
    self.Weapon:SetNextPrimaryFire(CurTime() + 2.4)
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    ply:MuzzleFlash()							
    ply:SetAnimation( PLAYER_ATTACK1 )
    ply:ViewPunch(Angle(-2,0,0))
    local selfclass = self:GetClass()
	local bolt = ents.Create("crossbow_bolt")
	bolt:SetOwner(ply)
	bolt:SetPos(ply:GetShootPos())
	bolt:SetAngles(ply:EyeAngles())
	bolt:Spawn()
	bolt:Activate()
	bolt:SetVelocity(ply:GetAimVector()*3475)
	bolt.IsScripted = true
    timer.Simple(.25, 
        function()
            self:Reload()
        end)
end

function SWEP:SecondaryAttack()
    if !(self:GetNetworkedBool("cwzoomed")) then
        self:SetNetworkedBool("cwzoomed", true)
        self.Owner:SetFOV( 20, 0.1 )
    else
        self.Owner:SetFOV( 0, 0.1 )
        self:SetNetworkedBool("cwzoomed", false)
    end
end

function SWEP:Reload()
    if (self:Ammo1()<=0) then return end
    if !(self.Weapon:Clip1()==0) then return end
    if (self:GetNetworkedBool("cwreloading")) then return end 
    self:SetNetworkedBool("cwreloading",true)
    self.Owner:GetActiveWeapon():SendWeaponAnim( ACT_VM_RELOAD ) 
    timer.Simple(1, 
        function() 
            self.Owner:EmitSound("Weapon_Crossbow.BoltElectrify")
            self.Owner:RemoveAmmo(1, self.Weapon:GetPrimaryAmmoType())
            self.Weapon:SetClip1(1)
            timer.Simple(1, 
                function() 
                    self:SetNetworkedBool("cwreloading",false)
                end)
        end)
end

function SWEP:TakePrimaryAmmo( num )
	if ( self.Weapon:Clip1() <= 0 ) then
		if ( self:Ammo1() <= 0 ) then return end
		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )
	    end
	self.Weapon:SetClip1( self.Weapon:Clip1() - num )
end