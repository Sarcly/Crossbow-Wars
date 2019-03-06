 AddCSLuaFile( "cl_init.lua" )
 AddCSLuaFile( "shared.lua" )
 include('shared.lua')

--[[ hook.Add("InitPostEntity","crossbow_bolt_damage", function()
    local ENT_ = scripted_ents.GetStored("crossbow_bolt").t
    local oldTouch = ENT.Touch
    function ENT_:Touch(ent)
        //ent:AddDamage(10000)
        oldTouch(self,ent)
        print("touching")
    end
) ]]