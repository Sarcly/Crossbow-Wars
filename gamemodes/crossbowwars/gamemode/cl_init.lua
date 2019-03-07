include("shared.lua")
include("cl_pickteam.lua")

local teamPanel = vgui.Create("TeamPanel")

function GM:Think()
	if input.IsKeyDown(KEY_F1) then
		teamPanel:Show()
	end	
end