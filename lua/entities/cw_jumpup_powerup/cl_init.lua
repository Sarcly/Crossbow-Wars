include('shared.lua')

function ENT:Draw()
    self:DrawModel()       -- Draw the model.
    render.SetMaterial()
	local mins, maxes = self:GetModelBounds()
    local nx = self:GetPos()[1]+((math.abs(mins[1])+math.abs(maxes[1]))/2)
    local nz = self:GetPos()[2]+((math.abs(mins[2])+math.abs(maxes[2]))/2)
    local ny = self:GetPos()[3]+((math.abs(mins[3])+math.abs(maxes[3]))/2)
    local pos = Vector(nx, nz, ny)
    print("--")
    print(self:GetPos())
    print(pos)
	render.DrawSphere(pos, 50, 50, 50, Color( 0, 175, 175, 100 ) )
end