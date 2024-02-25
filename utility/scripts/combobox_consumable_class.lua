--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

local tClasses = { 'cleric', 'druid', 'wizard', 'sorcerer', 'bard', 'paladin', 'ranger' }
local tTypes = { 'Scroll', 'Potion', 'Wand' }

local function getSpellLevelData()
	local nodeSpell = window.getDatabaseNode()
	return DB.getValue(nodeSpell, 'level', ''):lower()
end

local function setConsumableTypes(sClass, nSpellLevel)
	for _, sType in ipairs(tTypes) do
		local sTypeLevelCosts = string.format('a%sLevelCosts', sType)
		if CustomItemGenConsumablesData[sTypeLevelCosts][sClass][nSpellLevel] then
			window.type.add(sType)
		end
	end
end

local function setCasterLevel(nSpellLevel)
	if nSpellLevel == 0 then
		window.casterlevel.setValue(1)
	else
		local nMinCL = (nSpellLevel * 2) - 1
		window.casterlevel.setMinValue(nMinCL)
		window.casterlevel.setValue(nMinCL)
	end
end

-- luacheck: globals onValueChanged
function onValueChanged()
	if super and super.onValueChanged then
		super.onValueChanged()
	end

	local sClass = (self.getValue() or ''):lower()
	if sClass == '' then
		return
	end

	local sLevelData = getSpellLevelData()
	local nSpellLevel = tonumber(string.match(sLevelData, '.*' .. sClass .. ' (%d+).*') or -1)
	if not nSpellLevel or nSpellLevel == -1 then
		return
	end

	setConsumableTypes(sClass, nSpellLevel)
	setCasterLevel(nSpellLevel)
end

function onInit()
	if super and super.onInit then
		super.onInit()
	end

	local sLevelData = getSpellLevelData()
	for _, v in ipairs(tClasses) do
		if string.match(sLevelData, v) then
			self.add(v, StringManager.titleCase(v), false)
		end
	end
end
