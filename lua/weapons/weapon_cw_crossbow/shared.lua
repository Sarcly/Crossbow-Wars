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
    self:SetNextPrimaryFire( CurTime() + 1 )
    local pPlayer = self.Owner;

    if ( !pPlayer ) then return end 
    local vecSrc = pPlayer:GetShootPos();
    local vecAiming = pPlayer:GetAimVector();

    local info = { Num = 1, Src = vecSrc, Dir = vecAiming, Spread = .01, Damage = 100 };
    info.Attacker = pPlayer;
    //print("ok")
    if ( CLIENT ) then return end
        local Src = Vector(info.Spread,info.Spread,info.Spread)// || vec3_origin
        local Dir = info.Dir// + Vector( math.Rand( -Src.x, Src.x ), math.Rand( -Src.y, Src.y ), math.Rand( -Src.y, Src.y ) )
        //if CLIENT then return end
        local pBolt = ents.Create( "cw_crossbow_bolt" );
        pBolt:SetPos( info.Src + ( Dir * 32 ) )
        pBolt:SetAngles( Dir:Angle() );
        pBolt.m_iDamage = self.Primary.Damage;
        pBolt.Attacker = self.Owner
        pBolt:Spawn()
        
        pBolt:SetPos( info.Src + ( Dir * pBolt:BoundingRadius() ) );

        if ( pPlayer:WaterLevel() == 3 ) then
            pBolt:SetVelocity( Dir * 500 );
        else
            print("set vel")
            pBolt:GetPhysicsObject():AddVelocity( Dir * 3400);
            print(pBolt:GetVelocity())
        end
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