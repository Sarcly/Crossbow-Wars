
local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudWeaponSelection"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function(name)
	if (hide[name]) then return false end
end)


local pos = {x=100,y=100}
local width = {x=100,y=100}
local PANEL = {}

function PANEL:Init()
    self:SetSize(width.x,width.y)
    self:ParentToHUD()
    self.HealthLabel = vgui.Create("DLabel", PANEL)
    self.PowerupLabel = vgui.Create("DLabel", PANEL)
    self.PowerupLabel:SetPos(pos.x, pos.y+10)
    self.PowerupLabel:SetWidth(100)
    self.TimeLeft = vgui.Create("DLabel", PANEL)
    self.TimeLeft:SetPos(pos.x,pos.y+20)
    self.HealthLabel:SetPos(pos.x,pos.y)
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
            print(self.TimeLeft:GetText())
        end
    else
        print(LocalPlayer())
    end

end

vgui.Register( "HudPanel", PANEL, "DFrame" ) 
