local TS = CreateFrame("Frame", "Broker_TankStats")
local LDB = LibStub("LibDataBroker-1.1")
local L = L

local format = string.format
local player = "player"
local two_fp = "%.2f%%"
local dodge,block,parry,sum = 0,0,0,0

TS:RegisterEvent("UNIT_STATS")
TS:RegisterEvent("UNIT_MODEL_CHANGED")
TS:RegisterEvent("UNIT_INVENTORY_CHANGED")
TS:RegisterEvent("PLAYER_LEVEL_UP")
TS:RegisterEvent("UNIT_AURA")
TS:RegisterEvent("PLAYER_LOGIN")

TS:SetScript("OnEvent", function(self, event, unit)
	if (unit and unit ~= player) then return end
	dodge = GetDodgeChance()
	block = GetBlockChance()
	parry = GetParryChance()
	sum = dodge + block + parry
	TSframe.obj.text = format(two_fp, sum)
	TSframe.obj.value = format(two_fp, sum)
end)

if (LDB) then
	TSframe = CreateFrame("Frame", "LDB_TS")
	TSframe.obj = LDB:NewDataObject("TankStats", {
		type = "data source",
		icon = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
		text = format(two_fp, sum),
		value = format(two_fp, sum),
		suffix = "SUFFIX",
		OnEnter = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
			GameTooltip:ClearLines()
			TF3Frame.obj.OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end,
		OnLeave = function(self)
			GameTooltip:Hide()
		end,
		OnTooltipShow = function(self)
			self:AddLine("Current TankStats")
			self:AddLine(" ")
			self:AddLine(L["DODGE"] .. ": " .. format(two_fp,dodge))
			self:AddLine(L["BLOCK"] .. ": " .. format(two_fp,block))
			self:AddLine(L["PARRY"] .. ": " .. format(two_fp,parry))
		end,
	})
end
