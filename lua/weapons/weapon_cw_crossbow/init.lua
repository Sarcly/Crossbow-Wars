 AddCSLuaFile( "cl_init.lua" )
 AddCSLuaFile( "shared.lua" )
 include('shared.lua')

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

hook.Add("EntityTakeDamage", "crossbowbolt_dmg", 
    function(ent, dmg)
        if !ent:IsPlayer() then return end
        local inf = dmg:GetInflictor()
	    if IsValid(inf) and inf:GetClass() == "crossbow_bolt" then
            if (!ent:GetNetworkedBool("cwshield")) then
                ent:Kill()
                ent.Ragdoll:GetPhysicsObject():AddVelocity(inf:GetVelocity()*2)
            else
                ent:SetNetworkedBool("cwshield", false)
            end
        end
    end)