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
            if (!ent:GetNWBool("IsFakeHit")) then
                if (!ent:GetNWBool("cwshield")) then
                    ent:Kill()
                    ent.Ragdoll:GetPhysicsObject():AddVelocity(inf:GetVelocity()*2)
                else
                    inf:Remove()
                    ent:SetNWBool("cwshield", false)
                end
                print("True")
                ent:SetNWBool("IsFakeHit",true)
                timer.Simple(1,  
                    function()
                        print("false")
                        ent:SetNWBool("IsFakeHit",false)
                end)
            else
                return
            end
        end
    end)