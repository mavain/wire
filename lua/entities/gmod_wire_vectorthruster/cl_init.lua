include('shared.lua')

// Thrusters only really need to be twopass when they're active.. something to think about..
ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Initialize()
	self.ShouldDraw = 1

	local mx, mn = self:GetRenderBounds()
	self:SetRenderBounds(mn + Vector(0,0,128), mx, 0)
end

function ENT:Draw()
	self.BaseClass.Draw(self)
	
	self:DrawTranslucent()
end

function ENT:DrawTranslucent()
	if self.ShouldDraw == 0 or not self:IsOn() then return end

	local EffectDraw = WireLib.ThrusterEffectDraw[self:GetEffect()]
	if EffectDraw then EffectDraw(self) end
end

function ENT:Think()
	self.BaseClass.Think(self)

	self.ShouldDraw = GetConVarNumber("cl_drawthrusterseffects")

	if self.ShouldDraw == 0 or not self:IsOn() then return end

	local EffectThink = WireLib.ThrusterEffectThink[self:GetEffect()]
	if EffectThink then EffectThink(self) end
end

function ENT:CalcOffset()
	local mode = self:GetMode()
	if mode == 1 then
		return self:GetPos() + self:GetOffset()
	elseif mode == 2 then
		local v = self:GetOffset()
		local z = v.z
		v.z = 0
		v = self:LocalToWorld(v)
		v.z = v.z + z
		return v
	else
		return self:LocalToWorld(self:GetOffset())
	end
end
