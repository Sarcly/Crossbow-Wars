AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props_junk/harpoon002a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetGravity(10)
    local phys = self:GetPhysicsObject()
    if CLIENT then return end
	if (phys:IsValid()) then
		phys:Wake()
    end
end

--[[ function ENT:SpawnFunction( ply, tr )
    if !tr.Hit then return end
    local e = ents.Create(ClassName)
    //e:SetOwner(ply)
    e:SetPos(tr.HitPos+tr.HitNormal*16) 
    e:Spawn()
    e:Activate()
    return e
end ]]
 

function ENT:PhysicsCollide(collisionData, physObj)
    pOther = physObj:GetEntity()
    if !pOther:IsSolid() or pOther:GetSolidFlags()==FSOLID_VOLUME_CONTENTS then
        return 
    end
    if ( pOther.m_takedamage && pOther.m_takedamage != 0) then
        local tr = self:GetTouchTrace()
        local vecNormalizedVel = self:GetAbsVelocity():GetNormalized()
        if(pOther:IsNPC()) then
            local dmgInfo = DamageInfo(self, self:GetOwner(), self.m_iDamage, DMG_NEVERGIB)
            dmgInfo:SetDamagePosition(tr.HitPos)
            pOther:DispatchTraceAttack(dmgInfo,tr, vecNormalizedVel )
        else
            local dmgInfo = DamageInfo( self, self:GetOwner(),self.m_iDamage, DMG_BULLET || DMG_NEVERGIB );
            dmgInfo:SetDamagePosition( tr.HitPos );
            pOther:DispatchTraceAttack( dmgInfo, tr, vecNormalizedVel);
        end
    else

        local tr = self:GetTouchTrace()
        if(collisionData.HitEntity:GetClass()=="worldspawn") then
            local vecDir = self:GetVelocity()
            local hitPos = Vector(tr.HitPos[1], tr.HitPos[2], tr.HitPos[3]):GetNormalized()

            local hitDot = hitPos:Dot(vecDir*-1)
            if(hitDot<0.5 && vecDir:Length()>100) then
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
end
