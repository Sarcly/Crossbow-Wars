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


function GM:PreDrawHalos()
	for i, ply in pairs(player.GetAll()) do
		//print(ply)
		if(ply:GetNWBool("cwshield")) then
			halo.Add( {ply,ply:GetWeapon("weapon_cw_crossbow")} , Color( 0, 0, 255 ), 5, 5, 2 )
		end
	end
--[[     if (IsValid(LocalPlayer():GetEyeTrace().Entity)) then
		halo.Add( {LocalPlayer():GetEyeTrace().Entity,LocalPlayer():GetEyeTrace().Entity:GetWeapon("weapon_cw_crossbow")} , Color( 255, 255, 255 ), 1, 1, 1 )
    end ]]
end