include("shared.lua")
include("cl_pickteam.lua")
include("cl_drawhud.lua")

local teamPanel = vgui.Create("TeamPanel")
local hudPanel = vgui.Create("HudPanel")

function GM:Think()

end

function GM:PlayerButtonDown(ply, key)
	if key == KEY_F1 then
		teamPanel:Show()
	end	
end

