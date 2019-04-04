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
            if (!ent.FakeHitAlready) then
                if (!ent:GetNWBool("cwshield")) then
                    dmg:SetDamage(100)
                    ent.deathCrossbowVelocity=inf:GetVelocity()
                else
                    inf:Remove()
                    ent:EmitSound("npc/roller/mine/rmine_shockvehicle1.wav")
                    ent:SetNWBool("cwshield", false)
                end
                ent.FakeHitAlready=true
                timer.Simple(.01,  
                    function()
                        ent.FakeHitAlready=false
                end)
            else
                ent.FakeHitAlready=false
                dmg:SetDamage(0)
                return
            end
        end
    end)