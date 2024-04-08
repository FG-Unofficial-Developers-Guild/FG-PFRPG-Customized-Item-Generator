--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals addItems add getValue
function onInit()
	if super and super.onInit then
		super.onInit()
	end

	local nodeItem = DB.getChild(window.getDatabaseNode(), '...')
	if not nodeItem then
		return
	end

	local sType, sSubType = window.windowlist.window.getItemType(nodeItem)
	if window.windowlist.window.notifyMissingTypeData(sType, sSubType) then
		return
	end

	local aAbilityList = window.windowlist.window.getAbilityList(sType, sSubType)

	local dDamageType = DB.getChild(nodeItem, 'damagetype')
	local sName = DB.getValue(nodeItem, 'name')

	local bMeleeWeapon = (sType == 'Weapon' and sSubType == 'Melee')
	local bRangedWeapon = (sType == 'Weapon' and sSubType == 'Ranged')
	local bSlashingWeapon = false
	local bPiercingWeapon = false
	local bBludgeoningWeapon = false
	if dDamageType then
		bSlashingWeapon = dDamageType.getValue():lower():match('slashing')
		bPiercingWeapon = dDamageType.getValue():lower():match('piercing')
		bBludgeoningWeapon = dDamageType.getValue():lower():match('bludgeoning')
	end
	local bCrossbow = (sName:lower():match('crossbow'))
	local bBow = (sName:lower():match('bow') and not bCrossbow)
	local bFirearm = (sType == 'Firearm')

	addItems({ Interface.getString('bmos_customizeitem_bonus_none') })

	for key, value in pairs(aAbilityList) do
		if
			bMeleeWeapon
			and ((bSlashingWeapon and value.bSlashing) or (bPiercingWeapon and value.bPiercing) or (bBludgeoningWeapon and value.bBludgeoning))
		then
			add(key)
		elseif bRangedWeapon then
			if
				(value.bCrossbow or value.bBow or value.bFirearm)
				and ((bCrossbow and value.bCrossbow) or (bBow and value.bBow) or (bFirearm and value.bFirearm))
			then
				add(key)
			elseif not (value.bCrossbow or value.bBow or value.bFirearm or value.bThrown) then
				add(key)
			end
		else
			add(key)
		end
	end
end

-- luacheck: globals onValueChanged
function onValueChanged(...)
	if super and super.onValueChanged then
		super.onValueChanged(...)
	end

	local nodeItem = DB.getChild(window.getDatabaseNode(), '...')
	if not nodeItem then
		return
	end

	local sType, sSubType = window.windowlist.window.getItemType(nodeItem)
	if window.windowlist.window.notifyMissingTypeData(sType, sSubType) then
		return
	end

	local aAbilityList = window.windowlist.window.getAbilityList(sType, sSubType)
	local sAbility = getValue()
	if aAbilityList ~= nil and next(aAbilityList[sAbility].aSubSelection) ~= nil then
		window.ability_sub_select.clear()
		window.ability_sub_select.addItems({ Interface.getString('bmos_customizeitem_bonus_none') })
		for key, _ in pairs(aAbilityList[sAbility].aSubSelection) do
			window.ability_sub_select.add(key)
		end
		window.ability_sub_select.setValue(Interface.getString('bmos_customizeitem_bonus_none'))
		window.ability_sub_select.setComboBoxVisible(true)
		window.ability_sub_select_label.setVisible(true)
		return
	end

	window.ability_sub_select.setComboBoxVisible(false)
	window.ability_sub_select_label.setVisible(false)
end
