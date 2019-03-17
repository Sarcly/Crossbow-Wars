include('shared.lua')
 
SWEP.PrintName = "Crossbow War Crossbow"			
SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.DrawCrosshair = true

SWEP.Author = "Sarcly and Intox"

function SWEP:ViewModelDrawn(vmodel)
    --must drawn in heated bolt here
end

function SWEP:DrawWorldModel()
    self:DrawModel()
    if(self:GetOwner():GetNWBool("cwshield"))then
        self:SetColor(Color(0,0,255,255))
    else
        self:SetColor(Color(255,255,255,255))
    end
end


function SWEP:PreDrawViewModel( vm,  weapon,  ply)
    if(ply:GetNWBool("cwshield")) then
        vm:SetColor(Color(0,0,255,255))
    else
        vm:SetColor(Color(255,255,255,255))
    end
end