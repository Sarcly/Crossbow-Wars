include("shared.lua")
include("cl_pickteam.lua")

local teamPanel = vgui.Create("TeamPanel")

function GM:Think()
	if input.IsKeyDown(KEY_F1) then
		teamPanel:Show()
	end	
end

function GM:HUDPaint()
	//surface.DrawRect( 50, 50, 128, 128 )
	print(LocalPlayer().PoweredUp)
	print(LocalPlayer().PowerupFraction)
	if(LocalPlayer().PoweredUp) then
		print("drawing")
		local originX = 100
		local originY = 100
		local radius = 100
		surface.DrawCircle(originX,originY,radius,0, 0, 0)
		local angle = math.rad(LocalPlayer().PowerupFraction*360 - 90) 
		local newX = originX + math.cos(angle) * radius
		local newY = originY + math.sin(angle) * radius
		surface.DrawLine(originX,originY, newX, newY)
	end
end