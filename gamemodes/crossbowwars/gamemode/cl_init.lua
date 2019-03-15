include("shared.lua")
include("cl_pickteam.lua")
include("drawarc.lua")

local teamPanel = vgui.Create("TeamPanel")

function GM:Think()
	if input.IsKeyDown(KEY_F1) then
		teamPanel:Show()
	end	
end


function GM:HUDPaint()
	draw.NoTexture()
	draw.Arc(ScrW()/2,ScrH()/2,100,5,0,360,1, Color(255,255,255))

	if(LocalPlayer():GetNWBool("PoweredUp")) then

		local radius = 100
		local originX = ScrW()-3*radius
		local originY = ScrH()-3*radius
		//surface.DrawCircle(originX,originY,radius,0, 0, 0)
		local angle = math.rad(LocalPlayer():GetNWFloat("PowerupFraction")*360 - 90)
		print(math.deg(angle))
		local newX = originX + math.cos(angle) * radius
		local newY = originY + math.sin(angle) * radius
		//surface.DrawLine(originX,originY, newX, newY)
	end
end
