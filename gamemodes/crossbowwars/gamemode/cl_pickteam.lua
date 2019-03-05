
local PANEL = {}

function PANEL:Init()
	self:SetSize(1000,1000)
    self:Center()
    self:MakePopup()
    self:MouseCapture(true)
    PANEL.CloseButton = vgui.Create("DButton", self)
    PANEL.CloseButton:SetText("Close")
    PANEL.CloseButton:Dock(TOP)
    PANEL.CloseButton.DoClick = function()
        self:Hide()
    end
    PANEL.ButtonOne = vgui.Create("DButton", self)
    PANEL.ButtonOne:SetText("FUCK")
    PANEL.ButtonOne:Dock(LEFT)
    PANEL.ButtonOne.DoClick = function()
        LocalPlayer():ConCommand("set_team 1")
        self:Hide()
    end
    PANEL.ButtonTwo = vgui.Create("DButton", self)
    PANEL.ButtonTwo:SetText("Spectator")
    PANEL.ButtonTwo:Dock(RIGHT)
    PANEL.ButtonTwo.DoClick = function()
        LocalPlayer():ConCommand("set_team 2")
        self:Hide()
    end
end



vgui.Register( "TeamPanel", PANEL, "DPanel" ) 