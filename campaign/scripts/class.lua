--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

local function getSpellNode()
	local _, sRecord = DB.getValue(window.getDatabaseNode(), 'spellshortcut', '')
	if sRecord ~= '' then return DB.findNode(sRecord) end
end

-- luacheck: globals onValueChanged
function onValueChanged()
	if super and super.onValueChanged then super.onValueChanged() end

	local sClass = (self.getValue() or ''):lower()
	if sClass == '' then return end

	local nodeSpell = getSpellNode()
	if not nodeSpell then return end

	local sLevelData = DB.getValue(nodeSpell, 'level', ''):lower()
	local nSpellLevel = tonumber(sLevelData:match('.*' .. sClass .. ' (%d+).*') or -1)
	if not nSpellLevel or nSpellLevel == -1 then return end

	if window.button_generate.aScrollLevelCosts[sClass][nSpellLevel] then window.type.add('Scroll') end
	if window.button_generate.aPotionLevelCosts[sClass][nSpellLevel] then window.type.add('Potion') end
	if window.button_generate.aWandLevelCosts[sClass][nSpellLevel] then window.type.add('Wand') end

	if nSpellLevel == 0 then
		window.cl.setValue(1)
	else
		local nMinCL = (nSpellLevel * 2) - 1
		window.cl.setMinValue(nMinCL)
		window.cl.setValue(nMinCL)
	end
end

function onInit()
	if super and super.onInit then super.onInit() end
	clear()

	local nodeSpell = getSpellNode()
	if not nodeSpell then return end

	local sLevelData = DB.getValue(nodeSpell, 'level', ''):lower()
	local tClasses = { 'cleric', 'druid', 'wizard', 'sorcerer', 'bard', 'paladin', 'ranger' }
	for _, v in ipairs(tClasses) do
		if sLevelData:match(v) then self.add(v, StringManager.titleCase(v), false) end
	end
end
