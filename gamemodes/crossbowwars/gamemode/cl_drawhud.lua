
local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudWeaponSelection"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function(name)
	if (hide[name]) then return false end
end)

local padding = 100
local width = {x=100,y=100}
local pos = {x=0,y=ScrH()-width.y}
local PANEL = {}
local fontsize = 10


function PANEL:Init()
    self:SetSize(width.x,width.y)
    self:SetPos(pos.x,pos.y)
    self:ParentToHUD()
    self.HealthLabel = vgui.Create("DLabel", PANEL)
    self.PowerupLabel = vgui.Create("DLabel", PANEL)
    self.PowerupLabel:SetPos(10, 20)
    self.PowerupLabel:SetWidth(100)
    self.TimeLeft = vgui.Create("DLabel", PANEL)
    self.TimeLeft:SetPos(10, 10)
    self.HealthLabel:SetPos(10,30)
end

function PANEL:Paint(w,h)
    if(IsValid(LocalPlayer())) then
        self.HealthLabel:SetText(LocalPlayer():Health())
        if(LocalPlayer():GetNWString("PowerupName")!="") then
            self.PowerupLabel:SetText(LocalPlayer():GetNWString("PowerupName"))
        else
            self.PowerupLabel:SetText("None")
        end
        if(LocalPlayer():GetNWBool("PoweredUp")) then
            self.TimeLeft:SetText(LocalPlayer():GetNWInt("PowerupDuration")-LocalPlayer():GetNWInt("PowerupDuration")*LocalPlayer():GetNWFloat("PowerupFraction"))
        else
            self.TimeLeft:SetText("")
        end
    else
        print(LocalPlayer())
    end

end

vgui.Register( "HudPanel", PANEL, "DPanel" ) 
