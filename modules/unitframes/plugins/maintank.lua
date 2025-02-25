local parent, ns = ...
local oUF = ns.oUF

local GetRaidRosterInfo = _G.GetRaidRosterInfo
local UnitHasVehicleUI = _G.UnitHasVehicleUI
local UnitInRaid = _G.UnitInRaid

local Update = function(self, event)
	local raidID = UnitInRaid(self.unit)
	if(not raidID) then return end

	local _, _, _, _, _, _, _, _, _, rinfo = GetRaidRosterInfo(raidID)
	if(rinfo == 'MAINTANK' and not UnitHasVehicleUI(self.unit)) then
		self.MainTank:Show()
	else
		self.MainTank:Hide()
	end
end

local Path = function(self, ...)
	return (self.MainTank.Override or Update)(self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate')
end

local Enable = function(self)
	local mt = self.MainTank

	if(mt) then
		mt.__owner = self
		mt.ForceUpdate = ForceUpdate

		self:RegisterEvent('GROUP_ROSTER_UPDATE', Path)

		if(mt:IsObjectType'Texture' and not mt:GetTexture()) then
			mt:SetTexture[[Interface\GROUPFRAME\UI-GROUP-MAINTANKICON]]
		end

		return true
	end
end

local Disable = function(self)
	local mt = self.MainTank

	if (mt) then
		self:UnregisterEvent('GROUP_ROSTER_UPDATE', Path)
	end
end

oUF:AddElement('MainTank', Path, Enable, Disable)
