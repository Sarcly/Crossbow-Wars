
local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudWeaponSelection"] = true,
    ["CHudCrosshair"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function(name)
	if (hide[name]) then return false end
end)

local margin = 50
local elementXPadding = 10
local size = {x=300,y=100}
local pos = {x=margin,y=ScrH()-size.y-margin}
local PANEL = {}
local fontsize = 10
local backgroundColor = Color(100,100,100,255)
local progressColor = Color(255,0,0,255)

function PANEL:Init()
    self:SetPos(pos.x,pos.y)
    self:SetSize(size.x,size.y)
    self:ParentToHUD()
    self.HealthLabel = vgui.Create("DLabel", PANEL)
    self.PowerupLabel = vgui.Create("DLabel", PANEL)
    self.TimeLeft = vgui.Create("DLabel", PANEL)
    self.PowerupProgressBar = vgui.Create("DProgress", PANEL)
    self.HealthLabel:SetPos(pos.x+elementXPadding,pos.y+10)
    self.PowerupLabel:SetPos(pos.x+elementXPadding, pos.y+20)
    self.TimeLeft:SetPos(pos.x+elementXPadding,pos.y+30)
    self.PowerupProgressBar:SetPos(pos.x+elementXPadding, pos.y+45)
    self.PowerupProgressBar:SetWidth(size.x-2*elementXPadding)
    self.PowerupLabel:SetWidth(100)
    function self.PowerupProgressBar:Paint(w,h)
        if(self:GetFraction()!=0) then
            draw.RoundedBox(8, 0, 0, w*(1-self:GetFraction()), h, progressColor)
        end
    end
end

--[[ function PANEL.PowerupProgressBar:Paint(w,h)
end ]]

function PANEL:Paint(w,h)
    draw.RoundedBox(20, 0, 0,w, h, backgroundColor)
    if(IsValid(LocalPlayer())) then
        self.HealthLabel:SetText(LocalPlayer():Health())
        if(LocalPlayer():GetNWString("PowerupName")!="") then
            self.PowerupLabel:SetText(LocalPlayer():GetNWString("PowerupName"))
        else
            self.PowerupLabel:SetText("None")
        end
        if(LocalPlayer():GetNWBool("PoweredUp")) then
            self.TimeLeft:SetText(LocalPlayer():GetNWInt("PowerupDuration")-LocalPlayer():GetNWInt("PowerupDuration")*LocalPlayer():GetNWFloat("PowerupFraction"))
            self.PowerupProgressBar:SetFraction(LocalPlayer():GetNWFloat("PowerupFraction"))
        else
            self.PowerupProgressBar:SetFraction(0)
            self.TimeLeft:SetText("")
        end
    else
    end
end

vgui.Register( "HudPanel", PANEL, "DPanel" ) 
