include("shared.lua")
include("cl_pickteam.lua")
include("cl_drawhud.lua")

local teamPanel = vgui.Create("TeamPanel")
local hudpanel = vgui.Create("HudPanel")

function GM:Think()

end

function GM:HUDPaint()
	//hudpanel = vgui.Create("HudPanel")
end

function GM:PostDrawHUD()
	//hudpanel:Remove()
end

function GM:PlayerButtonDown(ply, key)
	if key == KEY_F1 then
		teamPanel:Show()
	end	
end

