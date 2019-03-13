include('shared.lua')

function ENT:Draw()
    local ply = player.GetBySteamID("STEAM_0:0:41002162")
    self:DrawModel()           
    render.SetColorMaterial()
    for i = -40, 40 do
        local baseVector = ply:GetAimVector():GetNormalized()
        local altered = ply:EyeAngles()
        altered:RotateAroundAxis(Vector(0,0,1),i*5)
        local alteredVec = altered:Forward()
        render.DrawLine(self:GetPos(), alteredVec*50+self:GetPos(), Color( 255, 0, 0, 200 ), false )
    end
end