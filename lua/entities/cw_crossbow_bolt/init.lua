AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

function ENT:Initialize()
    util.PrecacheModel("models/cw_crossbowbolt/cw_crossbow_bolt.mdl")
	self:SetModel( "models/cw_crossbowbolt/cw_crossbow_bolt.mdl" )
    self:PhysicsInit(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:SetGravity(.05)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
    self:SetSolid(SOLID_BBOX)
    self:SetSkin(1)
    local phys = self:GetPhysicsObject()
    if CLIENT then return end
	if (phys:IsValid()) then
		phys:Wake()
        phys:SetDamping(0,10000)
        phys:SetAngleDragCoefficient(10000)
    end
end

function ENT:SpawnFunction( ply, tr )
    if !tr.Hit then return end
    local e = ents.Create(ClassName)
    //e:SetOwner(ply)
    e:SetPos(tr.HitPos+tr.HitNormal*16) 
    e:Spawn()
    e:Activate()
    return e
end

--[[ function ENT:Touch(pOther)
    //print("collided with smthn")
    if !pOther:IsSolid() or pOther:GetSolidFlags()==FSOLID_VOLUME_CONTENTS then
        return 
    end
    if ( pOther.m_takedamage && pOther.m_takedamage != 0) then
        //print("hit something that can take damage")
        local tr = self:GetTouchTrace()
        local vecNormalizedVel = self:GetAbsVelocity():GetNormalized()
        if(pOther:IsNPC()) then
            local dmgInfo = DamageInfo(self, self.Attacker, self.m_iDamage, DMG_NEVERGIB)
            dmgInfo:SetDamagePosition(tr.HitPos)
            pOther:DispatchTraceAttack(dmgInfo,tr, vecNormalizedVel )
        else
            local dmgInfo = DamageInfo( );
            dmgInfo:SetAttacker(self.Attacker)
            dmgInfo:SetDamageType(DMG_NEVERGIB)
            dmgInfo:SetDamage(10000)
            dmgInfo:SetDamagePosition( tr.HitPos );
            pOther:DispatchTraceAttack( dmgInfo, tr, vecNormalizedVel);
        end
    else
        //print("didnt hit something that can take damage")
        local tr = self:GetTouchTrace()
        //PrintTable(tr)
        if(tr.Entity:GetClass()=="worldspawn") then
            local vecDir = self:GetVelocity()
            local hitPos = Vector(tr.HitPos[1], tr.HitPos[2], tr.HitPos[3]):GetNormalized()
            local hitDot = hitPos:Dot(vecDir*-1)
            if(hitDot<0.5 && vecDir:Length()>100) then
                print("REFLECTION DOTPRODUCT:"..hitDot)
                vReflection = 2 * hitPos * hitDot + vecDir
                reflectAngles = vReflection:Angle()
                self:SetLocalAngles(reflectAngles)
                self:SetAbsVelocity(vReflection * vecDir:GetNormalized() * .75)
                self:SetGravity(1)
            else   
                self:SetMoveType(MOVETYPE_NONE)
                vForward = self:GetAngles():Forward():GetNormalized()
                effectData = EffectData()
                effectData:SetOrigin(hitPos)
                effectData:SetNormal(vForward)
                util.Effect("BoltImpact",effectData)
            end 
        
        end
    end
end ]]

function ENT:PhysicsCollide(data, phys)
    //print("collided with smthn")
    pOther = phys:GetEntity()
    if !pOther:IsSolid() or pOther:GetSolidFlags()==FSOLID_VOLUME_CONTENTS then
        return 
    end
    if ( pOther.m_takedamage && pOther.m_takedamage != 0) then
        //print("hit something that can take damage")
        local tr = self:GetTouchTrace()
        local vecNormalizedVel = self:GetAbsVelocity():GetNormalized()
        if(pOther:IsNPC()) then
            local dmgInfo = DamageInfo(self, self.Attacker, self.m_iDamage, DMG_NEVERGIB)
            dmgInfo:SetDamagePosition(tr.HitPos)
            pOther:DispatchTraceAttack(dmgInfo,tr, vecNormalizedVel )
        else
            local dmgInfo = DamageInfo( );
            dmgInfo:SetAttacker(self.Attacker)
            dmgInfo:SetDamageType(DMG_NEVERGIB)
            dmgInfo:SetDamage(10000)
            dmgInfo:SetDamagePosition( tr.HitPos );
            pOther:DispatchTraceAttack( dmgInfo, tr, vecNormalizedVel);
        end
    else
        //print("didnt hit something that can take damage")
        local tr = self:GetTouchTrace()
        //PrintTable(tr)
        if(tr.Entity:GetClass()=="worldspawn") then
            local vecDir = self:GetVelocity()
            local hitDot = tr.HitNormal:Dot(self:GetVelocity()*-1)
            print("REFLECTION DOTPRODUCT:"..hitDot)
            if(hitDot<0.5 && data.Speed >100) then
                self:EmitSound( Sound( "Flashbang.Bounce" ))
                vReflection = 2 * tr.HitNormal * hitDot + self:GetAbsVelocity()
                reflectAngles = vReflection:Angle()
                self:SetLocalAngles(reflectAngles)
                self:SetAbsVelocity(vReflection * data.Speed * .75)
                self:SetGravity(1)
            else   
                self:GetPhysicsObject():EnableMotion(false)
                effectData = EffectData()
                effectData:SetOrigin(tr.HitPos)
                effectData:SetNormal(tr.HitNormal)
                util.Effect("BoltImpact",effectData)
            end 
        
        end
    end
end