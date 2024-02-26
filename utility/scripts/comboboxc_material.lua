--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals addItems add
function onInit()
	if super and super.onInit then
		super.onInit()
	end
	local nodeItem = window.getDatabaseNode()

	local sType, sSubType = window.getItemType(nodeItem)
	if window.notifyMissingTypeData(sType, sSubType) then
		return
	end

	local bLightArmor = (sType == 'armor' and sSubType == 'light')
	local bMediumArmor = (sType == 'armor' and sSubType == 'medium')
	local bHeavyArmor = (sType == 'armor' and sSubType == 'heavy')
	local bShield = (sType == 'shield')
	local bMeleeWeapon = (sType == 'weapon' and sSubType == 'melee')
	local bRangedWeapon = (sType == 'weapon' and sSubType == 'ranged')
	local bAmmunition = (sType == 'ammunition')

	addItems({ Interface.getString('bmos_customizeitem_bonus_none') })
	for key, value in pairs(CustomItemGenItemData.aSpecialMaterials) do
		if bLightArmor and value.bLightArmor then
			add(key)
		elseif bMediumArmor and value.bMediumArmor then
			add(key)
		elseif bHeavyArmor and value.bHeavyArmor then
			add(key)
		elseif bShield and value.bShield then
			add(key)
		elseif bMeleeWeapon and value.bMeleeWeapon then
			add(key)
		elseif bRangedWeapon and value.bRangedWeapon then
			add(key)
		elseif bAmmunition and value.bAmmunition then
			add(key)
		end
	end
end
