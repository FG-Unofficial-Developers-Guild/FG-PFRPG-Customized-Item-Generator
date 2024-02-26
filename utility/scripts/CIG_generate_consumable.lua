--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals getWandData
function getWandData(sSpellName, nCL, sClass, nSpellLevel)
	local sItemName = string.format('Wand of %s', sSpellName)

	local nCost = CustomItemGenConsumablesData.aWandLevelCosts[sClass][nSpellLevel]
	if nCost and nSpellLevel ~= 0 then
		local nMinCL = (nSpellLevel * 2) - 1
		nCost = nCost + (750 * (nCL - nMinCL))
	end

	local nCharges = charges.getValue() or 50
	sItemName = string.format('%s [%d charges]', sItemName, nCharges)
	if nCharges ~= 50 then
		nCost = nCost * (nCharges / 50)
	end

	return sItemName, nCost, Interface.getString('desc_bmos_wand')
end

-- luacheck: globals getScrollData
function getScrollData(sSpellName, nCL, sClass, nSpellLevel)
	local sItemName = string.format('Scroll of %s', sSpellName)
	if not CustomItemGenConsumablesData.tArcaneClass[sClass] then
		sItemName = string.format('Divine %s', sItemName)
	end

	local nCost = CustomItemGenConsumablesData.aScrollLevelCosts[sClass][nSpellLevel]
	if nCost and nSpellLevel ~= 0 then
		local nMinCL = (nSpellLevel * 2) - 1
		nCost = nCost + (25 * (nCL - nMinCL))
	end

	return sItemName, nCost, Interface.getString('desc_bmos_scroll')
end

-- luacheck: globals getPotionData
function getPotionData(sSpellName, nCL, sClass, nSpellLevel)
	local sItemName = string.format('Potion of %s', sSpellName)

	local nCost = CustomItemGenConsumablesData.aPotionLevelCosts[sClass][nSpellLevel]
	if nCost and nSpellLevel ~= 0 then
		local nMinCL = (nSpellLevel * 2) - 1
		nCost = nCost + (50 * (nCL - nMinCL))
	end

	return sItemName, nCost, Interface.getString('desc_bmos_potion')
end

local function getSpellLink(nodeSpell)
	return string.format(
		'<linklist><link class="spelldesc" recordname="%s">%s</link></linklist>',
		UtilityManager.encodeXML(DB.getPath(nodeSpell)),
		DB.getValue(nodeSpell, 'name', '')
	)
end

local function getAuraStrength(nCL)
	if nCL > 9 then
		return 'Overwhelming '
	elseif nCL > 6 then
		return 'Strong '
	elseif nCL > 3 then
		return 'Moderate '
	elseif nCL > 0 then
		return 'Faint '
	end

	return ''
end

-- luacheck: globals getSpellLevel
function getSpellLevel(nodeSpell, sClass)
	local sSpellLevels = string.lower(DB.getValue(nodeSpell, 'level', ''))
	if sSpellLevels == '' then
		ChatManager.SystemMessage(Interface.getString('error_bmos_createconsumable_spellhasnoleveldata'))
	end

	local sSpellLevel = string.match(sSpellLevels, '.*' .. sClass .. ' (%d+).*') or '-1'
	return tonumber(sSpellLevel)
end

-- luacheck: globals createConsumable casterlevel
function createConsumable(nodeSpell, sSpellName, sType, sClass, nSpellLevel)
	local nCL = casterlevel.getValue() or 0
	local sItemName, nCost, sDesc = self[string.format('get%sData', sType)](sSpellName, nCL, sClass, nSpellLevel)

	local nodeItem = DB.createChild(DB.createNode('item'))
	DB.setValue(nodeItem, 'locked', 'number', 1)
	DB.setValue(nodeItem, 'name', 'string', sItemName)
	DB.setValue(nodeItem, 'nonid_name', 'string', string.format('Magic %s', sType))
	DB.setValue(nodeItem, 'type', 'string', sType)
	DB.setValue(nodeItem, 'cl', 'number', nCL)
	DB.setValue(nodeItem, 'description', 'formattedtext', sDesc .. getSpellLink(nodeSpell))
	DB.setValue(nodeItem, 'cost', 'string', string.format('%d gp', nCost))

	local sSchool = string.lower(DB.getValue(nodeSpell, 'school', ''):match('(%a+).*'))
	if sSchool ~= '' then
		DB.setValue(nodeItem, 'aura', 'string', getAuraStrength(nCL) .. sSchool)
	end

	return nodeItem
end
