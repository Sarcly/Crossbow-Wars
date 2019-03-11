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



-- function SWEP:PrimaryAttack()
--     self:SetNextPrimaryFire( CurTime())
--     local pPlayer = self.Owner;

--     if ( !pPlayer ) then return end 
--     local vecSrc = pPlayer:GetShootPos();
--     local vecAiming = pPlayer:GetAimVector();


--     //print("ok")
--     if ( CLIENT ) then return end
--     local pBolt = ents.Create( "cw_crossbow_bolt" );

--     if(!IsValid(pBolt)) then return end
--     pBolt.m_iDamage = self.Primary.Damage;
--     pBolt.Attacker = self.Owner
--     pBolt:Spawn()
--     pBolt:SetPos( self.Owner:EyePos() + self.Owner:GetAimVector():GetNormalized() * 30 )
--     pBolt:SetOwner(self.Owner)
--     shootVector = self.Owner:GetVelocity() + self.Owner:GetAimVector() * 3200
--     pBolt:SetAngles(self.Owner:GetAimVector():Angle())
--     pBolt:GetPhysicsObject():SetVelocity(shootVector)
-- end

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

function SWEP:ShootBullet(damage, num_bullets, aimcone)
 // Only the player fires this way so we can cast
    
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

--[[ function SWEP:Reload()
    print("reload")
    self.Weapon:DefaultReload(ACT_VM_RELOAD)
    return true
end ]]