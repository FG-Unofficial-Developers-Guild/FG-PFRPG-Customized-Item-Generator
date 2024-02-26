--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals generateMagicItem getAbilityList getItemType notifyMissingTypeData
-- luacheck: globals ItemManager.isArmor ItemManager.isShield ItemManager.isWeapon

local function addCSV(sString, sAppend)
	if sString == '' then
		return sAppend
	elseif string.find(sString, sAppend) then
		return sString
	end
	return string.format('%s, %s', sString, sAppend)
end

local function usingAE()
	return StringManager.contains(Extension.getExtensions(), 'FG-PFRPG-Advanced-Effects')
end

local function getCritical(nodeItem)
	if not nodeItem then
		return 0
	end
	local nCritical = 2
	local sCritical = DB.getValue(nodeItem, 'critical')
	if sCritical then
		sCritical = sCritical:match('x%d+')
		if sCritical then
			nCritical = tonumber(sCritical:match('%d+'))
		end
	end
	return nCritical
end

local function getWeaponTypeName(nodeItem)
	if not nodeItem then
		return ''
	end
	local sItemName = string.lower(DB.getValue(nodeItem, 'name', ''))
	local sSubType = string.lower(DB.getValue(nodeItem, 'subtype', ''))
	local sType = string.lower(DB.getValue(nodeItem, 'type', ''))
	if sSubType:match('ranged') and sItemName:match('crossbow') then
		return 'Crossbow'
	elseif sSubType:match('ranged') and sItemName:match('bow') then
		return 'Bow'
	elseif sSubType:match('firearm') then
		return 'Firearm'
	elseif sType == 'ammo' or sSubType == 'ammunition' then
		if sItemName:match('arrow') then
			return 'Bow'
		elseif sItemName:match('bolt') then
			return 'Crossbow'
		elseif sItemName:match('bullet') or sItemName:match('cartridge') then
			return 'Firearm'
		end
	end
	return ''
end

local function addEffect(nodeEffectList, sEffect, nActionOnly, bIsLabel)
	if (not nodeEffectList or not sEffect) and sEffect ~= '' then
		return
	end
	local nodeEffect = DB.createChild(nodeEffectList)
	if not nodeEffect then
		return
	end
	if bIsLabel then
		DB.setValue(nodeEffect, 'type', 'string', 'label')
	end
	DB.setValue(nodeEffect, 'effect', 'string', sEffect)
	DB.setValue(nodeEffect, 'actiononly', 'number', nActionOnly)
end

local function addEffectsForAbility(nodeItem, sType, sSubType, aAbility)
	if not nodeItem then
		return
	end
	if not usingAE() then
		return
	end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then
		nodeEffectList = DB.createChild(nodeItem, 'effectlist')
	end
	local aAbilityLookup = {}
	local nCritical = 0
	if ItemManager.isWeapon(nodeItem) then
		if sSubType == 'melee' then
			aAbilityLookup = CustomItemGenItemData.aMeleeWeaponAbilities[aAbility.sAbility]
			nCritical = getCritical(nodeItem)
		elseif sSubType == 'ranged' or sSubType == 'firearm' then
			aAbilityLookup = CustomItemGenItemData.aRangedWeaponAbilities[aAbility.sAbility]
			nCritical = getCritical(nodeItem)
		end
	elseif sType == 'ammunition' then
		aAbilityLookup = CustomItemGenItemData.aAmmunitionAbilities[aAbility.sAbility]
	elseif ItemManager.isArmor(nodeItem) then
		aAbilityLookup = CustomItemGenItemData.aArmorAbilities[aAbility.sAbility]
	elseif ItemManager.isShield(nodeItem) then
		aAbilityLookup = CustomItemGenItemData.aShieldAbilities[aAbility.sAbility]
	end

	local aEffects = {}
	if aAbilityLookup then
		if aAbility.sSubAbility ~= Interface.getString('bmos_customizeitem_bonus_none') and next(aAbilityLookup.aSubSelection) ~= nil then
			if
				aAbility.sSubSubAbility ~= Interface.getString('bmos_customizeitem_bonus_none')
				and next(aAbilityLookup.aSubSelection[aAbility.sSubAbility].aSubSubSelection) ~= nil
			then
				aEffects = aAbilityLookup.aSubSelection[aAbility.sSubAbility].aSubSubSelection[aAbility.sSubSubAbility].aEffects
			else
				aEffects = aAbilityLookup.aSubSelection[aAbility.sSubAbility].aEffects
			end
		else
			aEffects = aAbilityLookup.aEffects
		end
	end
	if next(aEffects) ~= nil then
		for _, aEffect in ipairs(aEffects) do
			if not aEffect.bAERequired or (aEffect.bAERequired and CombatManagerKel) then
				if aEffect.nCritical == 0 or (aEffect.nCritical == nCritical) then
					local sEffect = aEffect.sEffect
					if sType == 'ammunition' and aEffect.sEffect:match('%%s') then
						sEffect = sEffect:format(getWeaponTypeName(nodeItem))
					end
					addEffect(nodeEffectList, sEffect, aEffect.nActionOnly, false)
				end
			end
		end
	end
	return aAbilityLookup
end

local function getSpecialAbilityData(sSpecialAbility, sDamageType, iRange)
	local sNewDamageType = sDamageType:lower()
	local iNewRange = iRange
	if sSpecialAbility == Interface.getString('bmos_customizeitem_anarchic') then
		sNewDamageType = addCSV(sNewDamageType, 'chaotic')
	elseif sSpecialAbility == Interface.getString('bmos_customizeitem_axiomatic') then
		sNewDamageType = addCSV(sNewDamageType, 'lawful')
	elseif sSpecialAbility == Interface.getString('bmos_customizeitem_deadly') then
		sNewDamageType = string.gsub(sNewDamageType, ', nonlethal', '')
		sNewDamageType = string.gsub(sNewDamageType, 'nonlethal', '')
	elseif sSpecialAbility == Interface.getString('bmos_customizeitem_distance') then
		iNewRange = 2 * iNewRange
	elseif sSpecialAbility == Interface.getString('bmos_customizeitem_holy') then
		sNewDamageType = addCSV(sNewDamageType, 'good')
	elseif sSpecialAbility == Interface.getString('bmos_customizeitem_merciful') then
		sNewDamageType = addCSV(sNewDamageType, 'nonlethal')
	elseif sSpecialAbility == Interface.getString('bmos_customizeitem_throwing') then
		iNewRange = 10
	elseif sSpecialAbility == Interface.getString('bmos_customizeitem_unholy') then
		sNewDamageType = addCSV(sNewDamageType, 'evil')
	end
	return sNewDamageType, iNewRange
end

local function mergeDamage(aDamage)
	local sNewDamage = aDamage.dice
	if aDamage.mod > 0 then
		sNewDamage = string.format('%s+%s', sNewDamage, aDamage.mod)
	elseif aDamage.mod < 0 then
		sNewDamage = sNewDamage .. aDamage.mod
	end
	return sNewDamage
end

local function getDamageString(aDamage)
	local sNewDamage = ''
	if aDamage[2] then
		sNewDamage = mergeDamage(aDamage[2])
	end
	if aDamage[1] then
		sNewDamage = mergeDamage(aDamage[1])
	end
	return sNewDamage
end

local function changeDamageBySizeDifference(sDamage, iSizeDifference)
	if sDamage == '' or sDamage == nil then
		return sDamage
	end
	local aDamage = {}
	local aDamageSplit = StringManager.split(sDamage, '/')

	for _, vDamage in ipairs(aDamageSplit) do
		local diceDamage, nDamage = DiceManager.convertStringToDice(vDamage)
		local nDiceCount = 0
		local sDie = ''
		for _, dice in pairs(diceDamage) do
			if sDie == '' then
				sDie = dice
			end
			nDiceCount = nDiceCount + 1
		end
		table.insert(aDamage, { dice = nDiceCount .. sDie, mod = nDamage })
	end

	local aNewDamage = {}
	for _, aDmg in pairs(aDamage) do
		local sNewDamage = aDmg.dice
		local nMod = aDmg.mod
		local bIsAlt1 = false
		local bIsAlt2 = false
		local bIsAlt3 = false

		if CustomItemGenItemData.aAltDamageDice1[sNewDamage] ~= nil then
			sNewDamage = CustomItemGenItemData.aAltDamageDice1[sNewDamage].sDamage
			bIsAlt1 = true
		elseif CustomItemGenItemData.aAltDamageDice2[sNewDamage] ~= nil then
			sNewDamage = CustomItemGenItemData.aAltDamageDice2[sNewDamage].sDamage
			bIsAlt2 = true
		elseif CustomItemGenItemData.aAltDamageDice3[sNewDamage] ~= nil then
			if iSizeDifference < 0 then
				sNewDamage = CustomItemGenItemData.aAltDamageDice3[sNewDamage].sDown
				iSizeDifference = iSizeDifference + 1
			else
				sNewDamage = CustomItemGenItemData.aAltDamageDice3[sNewDamage].sUp
				iSizeDifference = iSizeDifference - 1
			end
			bIsAlt3 = true
		end

		local iChange
		for _ = 1, math.abs(iSizeDifference), 1 do
			if iSizeDifference < 0 then
				iChange = -1
			else
				iChange = 1
			end
			if CustomItemGenItemData.aDamageDice[sNewDamage].iPosition > CustomItemGenItemData.aDamageDice['1d6'].iPosition then
				iChange = iChange * 2
			end
			sNewDamage = CustomItemGenItemData.aPositionDamage[CustomItemGenItemData.aDamageDice[sNewDamage].iPosition + iChange].sDamage
		end

		if bIsAlt1 then
			if CustomItemGenItemData.aPositionDamage[CustomItemGenItemData.aDamageDice[sNewDamage].iPosition].sAltDamage1 ~= nil then
				sNewDamage = CustomItemGenItemData.aPositionDamage[CustomItemGenItemData.aDamageDice[sNewDamage].iPosition].sAltDamage1
			end
		end
		if bIsAlt2 then
			if CustomItemGenItemData.aPositionDamage[CustomItemGenItemData.aDamageDice[sNewDamage].iPosition].sAltDamage2 ~= nil then
				sNewDamage = CustomItemGenItemData.aPositionDamage[CustomItemGenItemData.aDamageDice[sNewDamage].iPosition].sAltDamage2
			end
		end
		if bIsAlt3 then
			if CustomItemGenItemData.aPositionDamage[CustomItemGenItemData.aDamageDice[sNewDamage].iPosition].sAltDamage3 ~= nil then
				sNewDamage = CustomItemGenItemData.aPositionDamage[CustomItemGenItemData.aDamageDice[sNewDamage].iPosition].sAltDamage3
			end
		end

		table.insert(aNewDamage, { dice = sNewDamage, mod = nMod })
	end

	return getDamageString(aNewDamage)
end

local function getDamageForSize(sDamage, sOriginalSize, sNewSize)
	local oldSize = CustomItemGenItemData.aItemSize[sOriginalSize:lower()].iPosition
	local newSize = CustomItemGenItemData.aItemSize[sNewSize:lower()].iPosition
	local iSizeDifference = newSize - oldSize
	if iSizeDifference == 0 then
		return sDamage
	end

	return changeDamageBySizeDifference(sDamage, iSizeDifference)
end

---	This function returns true if either supplied string is nil or blank.
function notifyMissingTypeData(sType, sSubType)
	local bNotified
	if not sType or sType == '' then
		ChatManager.SystemMessage(string.format(Interface.getString('error_bmos_customizeitem_itemhasno'), 'type'))
		bNotified = true
	end
	if (not sSubType or sSubType == '') and sType ~= 'ammunition' then
		ChatManager.SystemMessage(string.format(Interface.getString('error_bmos_customizeitem_itemhasno'), 'subtype'))
		bNotified = true
	end
	return bNotified
end

local function getDamageTypeByEnhancementBonus(sDamageType, iEnchancementBonus)
	local sNewDamageType = sDamageType
	if iEnchancementBonus == 5 then
		sNewDamageType = addCSV(sNewDamageType, 'chaotic')
		sNewDamageType = addCSV(sNewDamageType, 'evil')
		sNewDamageType = addCSV(sNewDamageType, 'good')
		sNewDamageType = addCSV(sNewDamageType, 'lawful')
	end
	if iEnchancementBonus >= 4 then
		sNewDamageType = addCSV(sNewDamageType, 'adamantine')
	end
	if iEnchancementBonus >= 3 then
		sNewDamageType = addCSV(sNewDamageType, 'cold iron')
		sNewDamageType = addCSV(sNewDamageType, 'silver')
	end
	if iEnchancementBonus >= 1 then
		sNewDamageType = addCSV(sNewDamageType, 'magic')
	end
	return sNewDamageType
end

local function getWeightBySize(iItemWeight, sOriginalSize, sItemSize)
	if sOriginalSize:lower() == sItemSize:lower() then
		return iItemWeight
	end
	return iItemWeight
		/ CustomItemGenItemData.aWeightMultiplier[sOriginalSize:lower()].nMultiplier
		* CustomItemGenItemData.aWeightMultiplier[sItemSize:lower()].nMultiplier
end

local function figureAbilityName(sAbility, sSubAbility, sSubSubAbility)
	local sAbilityName = sAbility
	if sSubAbility ~= Interface.getString('bmos_customizeitem_bonus_none') then
		sAbilityName = string.format('%s (%s', sAbilityName, sSubAbility)
		if sSubSubAbility ~= Interface.getString('bmos_customizeitem_bonus_none') then
			sAbilityName = string.format('%s (%s)', sAbilityName, sSubSubAbility)
		end
		sAbilityName = sAbilityName .. ')'
	end
	sAbilityName = sAbilityName .. ' '
	return sAbilityName
end

local function getItemNewName(sItemName, sEnhancementBonus, iEnchancementBonus, sSpecialMaterial, aAbilities, bMasterworkMaterial, sItemSize)
	local sItemNewName = ''
	if sItemSize:lower() ~= Interface.getString('bmos_customizeitem_size_medium'):lower() then
		sItemNewName = sItemNewName .. sItemSize .. ' '
	end
	if sEnhancementBonus == Interface.getString('bmos_customizeitem_bonus_mwk') and not bMasterworkMaterial then
		sItemNewName = sItemNewName .. 'masterwork' .. ' '
	end
	if iEnchancementBonus > 0 then
		sItemNewName = sItemNewName .. '+' .. tostring(iEnchancementBonus) .. ' '
	end
	if sSpecialMaterial ~= Interface.getString('bmos_customizeitem_bonus_none') then
		sItemNewName = sItemNewName .. CustomItemGenItemData.aSpecialMaterials[sSpecialMaterial].sStringName .. ' '
	end
	for _, aAbility in pairs(aAbilities) do
		sItemNewName = sItemNewName .. figureAbilityName(aAbility.sAbility, aAbility.sSubAbility, aAbility.sSubSubAbility)
	end
	return StringManager.titleCase(sItemNewName .. sItemName)
end

local function getEnchancementCost(iEnchancementBonus, sType)
	local iEnchantmentCost = 0

	if sType == 'weapon' then
		iEnchantmentCost = CustomItemGenItemData.aBonusPriceWeapon[iEnchancementBonus + 1]
	elseif sType == 'armor' or sType == 'shield' then
		iEnchantmentCost = CustomItemGenItemData.aBonusPriceArmor[iEnchancementBonus + 1]
	elseif sType == 'ammunition' then
		iEnchantmentCost = CustomItemGenItemData.aBonusPriceAmmunition[iEnchancementBonus + 1]
	end
	return iEnchantmentCost
end

local function getMasterworkPrice(sType, sProperties)
	if sType == 'armor' or sType == 'shield' then
		return 150
	elseif sType == 'ammunition' then
		return 6
	elseif sType == 'weapon' then
		if sProperties:lower():match('double') then
			return 600
		end
		return 300
	end
	return 0
end

local function getEnhancementBonus(sEnhancementBonus)
	local iEnchancementBonus = 0
	if sEnhancementBonus == Interface.getString('bmos_customizeitem_bonus_1') then
		iEnchancementBonus = 1
	elseif sEnhancementBonus == Interface.getString('bmos_customizeitem_bonus_2') then
		iEnchancementBonus = 2
	elseif sEnhancementBonus == Interface.getString('bmos_customizeitem_bonus_3') then
		iEnchancementBonus = 3
	elseif sEnhancementBonus == Interface.getString('bmos_customizeitem_bonus_4') then
		iEnchancementBonus = 4
	elseif sEnhancementBonus == Interface.getString('bmos_customizeitem_bonus_5') then
		iEnchancementBonus = 5
	end
	return iEnchancementBonus
end

local function areExclusive(sType, sSubType, sAbility1, sAbility2)
	local aAbilityList = getAbilityList(sType, sSubType)
	return StringManager.contains(aAbilityList[sAbility1].aExclusions, sAbility2)
end

local function checkForAbilitySelectionError(sType, sSubType, aAbility1, aAbility2)
	if aAbility1.sAbility == aAbility2.sAbility then
		return 1
	elseif areExclusive(sType, sSubType, aAbility1.sAbility, aAbility2.sAbility) then
		return 2
	end
	return 0
end

local function checkSelection(sSelection)
	return (sSelection ~= Interface.getString('bmos_customizeitem_bonus_none'))
end

local function checkComboboxes(sType, sSubType, sBonus, sMaterial, aAbilities)
	local bBonus = checkSelection(sBonus)
	local bMaterial = checkSelection(sMaterial)
	local aConflicts = {}

	for key1, aAbility1 in ipairs(aAbilities) do
		for key2, aAbility2 in ipairs(aAbilities) do
			if key1 ~= key2 then
				local nError = checkForAbilitySelectionError(sType, sSubType, aAbility1, aAbility2)
				if nError > 0 then
					aConflicts.sAbility1 = aAbility1.sAbility
					aConflicts.sAbility2 = aAbility2.sAbility
					return bBonus, bMaterial, nError, aConflicts
				end
			end
		end
		local aAbilityList = getAbilityList(sType, sSubType)
		if next(aAbilityList[aAbility1.sAbility].aSubSelection) ~= nil and aAbility1.sSubAbility == Interface.getString('bmos_customizeitem_bonus_none') then
			aConflicts.sAbility1 = aAbility1.sAbility
			return bBonus, bMaterial, 3, aConflicts
		elseif
			next(aAbilityList[aAbility1.sAbility].aSubSelection) ~= nil
			and next(aAbilityList[aAbility1.sAbility].aSubSelection[aAbility1.sSubAbility].aSubSubSelection) ~= nil
			and aAbility1.sSubSubAbility == Interface.getString('bmos_customizeitem_bonus_none')
		then
			aConflicts.sAbility1 = aAbility1.sAbility
			return bBonus, bMaterial, 3, aConflicts
		end
	end
	return bBonus, bMaterial, 0
end

local function getAbilityBonusAndCost(sSpecialAbility, sType, sSubType)
	local tAbilities
	if sSubType == 'melee' then
		tAbilities = CustomItemGenItemData.aMeleeWeaponAbilities[sSpecialAbility]
	elseif sSubType == 'ranged' then
		tAbilities = CustomItemGenItemData.aRangedWeaponAbilities[sSpecialAbility]
	elseif sType == 'armor' then
		tAbilities = CustomItemGenItemData.aArmorAbilities[sSpecialAbility]
	elseif sType == 'shield' then
		tAbilities = CustomItemGenItemData.aShieldAbilities[sSpecialAbility]
	elseif sType == 'ammunition' then
		tAbilities = CustomItemGenItemData.aAmmunitionAbilities[sSpecialAbility]
	end

	local iBonus = tAbilities.iBonus or 0
	local iBonusCost = 0
	local iExtraCost = tAbilities.iCost or 0
	local sAbilityName = tAbilities.sStringName or ''
	local iCL = tAbilities.iCL or 0
	local sAura = tAbilities.sAura or ''

	if iExtraCost == 0 then
		iBonusCost = iBonus
	end

	return iBonus, iBonusCost, iExtraCost, sAbilityName, iCL, sAura
end

local function addRangedEffect(nodeItem)
	if not nodeItem then
		return
	end
	if not usingAE() then
		return
	end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then
		nodeEffectList = DB.createChild(nodeItem, 'effectlist')
	end
	addEffect(nodeEffectList, getWeaponTypeName(nodeItem) .. ' Attack', 1, true)
	addEffect(nodeEffectList, 'Crit' .. getCritical(nodeItem), 1, true)
end

local function addAmmoEffect(nodeItem)
	if not nodeItem then
		return
	end
	if not usingAE() then
		return
	end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then
		nodeEffectList = DB.createChild(nodeItem, 'effectlist')
	end
	local nBonus = bonus.getValue()
	addEffect(nodeEffectList, 'IF: CUSTOM(' .. getWeaponTypeName(nodeItem) .. ' Attack); ATK: ' .. nBonus .. ' ranged; DMG: ' .. nBonus, 0, false)
end

local function cleanAbility(aAbility, sType, sSubType)
	local aNewAbility = {}
	local aAbilityList = getAbilityList(sType, sSubType)

	if aAbility.sAbility == Interface.getString('bmos_customizeitem_bonus_none') then
		return aNewAbility
	end
	aNewAbility.sAbility = aAbility.sAbility

	if next(aAbilityList[aAbility.sAbility].aSubSelection) == nil then
		aNewAbility.sSubAbility = Interface.getString('bmos_customizeitem_bonus_none')
		aNewAbility.sSubSubAbility = Interface.getString('bmos_customizeitem_bonus_none')
	else
		aNewAbility.sSubAbility = aAbility.sSubAbility
		if
			aAbility.sSubAbility ~= Interface.getString('bmos_customizeitem_bonus_none')
			and next(aAbilityList[aAbility.sAbility].aSubSelection[aAbility.sSubAbility].aSubSubSelection) == nil
		then
			aNewAbility.sSubSubAbility = Interface.getString('bmos_customizeitem_bonus_none')
		else
			aNewAbility.sSubSubAbility = aAbility.sSubSubAbility
		end
	end
	return aNewAbility
end

local function getAbilities(nodeItem, sType, sSubType)
	if not nodeItem then
		return
	end
	local aAbilities = {}
	for _, winAbilityEntry in ipairs(item_ability_list.getWindows()) do
		local aAbility = {}
		aAbility.sAbility = winAbilityEntry.ability_select.getValue()
		aAbility.sSubAbility = winAbilityEntry.ability_sub_select.getValue()
		aAbility.sSubSubAbility = winAbilityEntry.ability_sub_sub_select.getValue()
		aAbility = cleanAbility(aAbility, sType, sSubType)
		if next(aAbility) ~= nil then
			table.insert(aAbilities, aAbility)
		end
	end
	return aAbilities
end

function getAbilityList(sType, sSubType)
	if sType == 'weapon' then
		if sSubType == 'melee' then
			return CustomItemGenItemData.aMeleeWeaponAbilities
		elseif sSubType == 'ranged' or sSubType == 'firearm' then
			return CustomItemGenItemData.aRangedWeaponAbilities
		end
	elseif sType == 'ammunition' then
		return CustomItemGenItemData.aAmmunitionAbilities
	elseif sType == 'armor' then
		return CustomItemGenItemData.aArmorAbilities
	elseif sType == 'shield' then
		return CustomItemGenItemData.aShieldAbilities
	end
end

function getItemType(nodeItem)
	local sItemType = ''
	local sItemSubType = ''
	local sType = string.lower(DB.getValue(nodeItem, 'type', ''))
	local sSubType = string.lower(DB.getValue(nodeItem, 'subtype', ''))
	if sType == 'weapon' then
		sItemType = 'weapon'
	elseif sSubType:match('shield') then
		sItemType = 'shield'
	elseif sType == 'armor' then
		sItemType = 'armor'
	end

	if sType == 'ammo' or sSubType == 'ammo' or sSubType:match('ammunition') then
		sItemType = 'ammunition'
	end

	if sType == 'weapon' then
		if sSubType:match('melee') then
			sItemSubType = 'melee'
		elseif sSubType:match('ranged') then
			sItemSubType = 'ranged'
		elseif sSubType:match('firearm') then
			sItemSubType = 'firearm'
		else
			sItemSubType = ''
		end
	elseif sType == 'armor' then
		if sSubType:match('light') then
			sItemSubType = 'light'
		elseif sSubType:match('medium') then
			sItemSubType = 'medium'
		elseif sSubType:match('heavy') then
			sItemSubType = 'heavy'
		end
	end
	return sItemType, sItemSubType
end

local function getMaterialData(
	nodeItem,
	sMaterial,
	iEnhancingBonus,
	sType,
	sSubType,
	sFullSubType,
	iWeight,
	iArmorPenalty,
	iArmorMaxDex,
	iArmorSpellFailure,
	iSpeed30,
	iSpeed20,
	iItemBaseCost,
	sProperties,
	sDamageType
)
	local iMaterialCost = iItemBaseCost
	local iNewWeight = iWeight
	local iNewArmorPenalty = iArmorPenalty
	local iNewArmorMaxDex = iArmorMaxDex
	local iNewArmorSpellFailure = iArmorSpellFailure
	local iNewSpeed30 = iSpeed30
	local iNewSpeed20 = iSpeed20
	local sNewProperties = sProperties
	local sNewDamageType = sDamageType
	local sAddDescription = ''

	if CustomItemGenItemData.aSpecialMaterials[sMaterial] and CustomItemGenItemData.aSpecialMaterials[sMaterial].sAddDescription then
		sAddDescription = CustomItemGenItemData.aSpecialMaterials[sMaterial].sAddDescription
	end

	if sMaterial == Interface.getString('bmos_customizeitem_adamantine') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 5000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 10000
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 15000
		elseif sType == 'weapon' then
			iMaterialCost = iMaterialCost + 3000
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 60
		end
		sNewProperties = addCSV(sNewProperties, 'adamantine')
		sNewDamageType = addCSV(sNewDamageType, 'adamantine')
	elseif sMaterial == Interface.getString('bmos_customizeitem_alchemical_silver') then
		if sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 2
		else
			if sFullSubType:lower():match('light') then
				iMaterialCost = iMaterialCost + 20
			elseif sFullSubType:lower():match('one-handed') then
				iMaterialCost = iMaterialCost + 90
			elseif sFullSubType:lower():match('two-handed') then
				iMaterialCost = iMaterialCost + 180
			elseif sProperties:lower():match('double') then
				iMaterialCost = iMaterialCost + 180
			end
		end
		sNewDamageType = addCSV(sNewDamageType, 'silver')
	elseif sMaterial == Interface.getString('bmos_customizeitem_angelskin') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 2000
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_blood_crystal') then
		if sType == 'weapon' then
			iMaterialCost = iMaterialCost + 1500
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 30
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_cold_iron') then
		iMaterialCost = iMaterialCost * 2
		if iEnhancingBonus > 0 then
			iMaterialCost = iMaterialCost + 2000
		end
		sNewDamageType = addCSV(sNewDamageType, 'cold iron')
	elseif sMaterial == Interface.getString('bmos_customizeitem_darkleaf_cloth') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 750
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 1500
		else
			iMaterialCost = iMaterialCost + 375 * iWeight
		end
		iNewArmorPenalty = iArmorPenalty + 3
		iNewArmorMaxDex = iNewArmorMaxDex + 2
		iNewArmorSpellFailure = iNewArmorSpellFailure - 10
		if iNewArmorSpellFailure < 5 then
			iNewArmorSpellFailure = 5
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_darkwood') then
		iMaterialCost = iMaterialCost + (iWeight * 10)
		iNewWeight = iNewWeight / 2
		iNewArmorPenalty = iArmorPenalty - 2
		if sType == 'shield' then
			iNewArmorPenalty = iNewArmorPenalty + 2
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_dragonhide') then
		iMaterialCost = (iMaterialCost * 2) + getMasterworkPrice(sType, sProperties)
	elseif sMaterial == Interface.getString('bmos_customizeitem_siccatite') then
		if ItemManager.isArmor(nodeItem) then
			iMaterialCost = iMaterialCost + 6000
		elseif ItemManager.isWeapon(nodeItem) then
			iMaterialCost = iMaterialCost + 1000
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_eel_hide') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1200
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 1800
		end
		iNewArmorPenalty = iArmorPenalty + 1
		iNewArmorMaxDex = iNewArmorMaxDex + 1
		iNewArmorSpellFailure = iNewArmorSpellFailure - 10
	elseif sMaterial == Interface.getString('bmos_customizeitem_elysian_bronze') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 2000
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 3000
		elseif sType == 'weapon' then
			iMaterialCost = iMaterialCost + 1000
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 20
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_fire_forged_steel') or sMaterial == Interface.getString('frost_forged_steel') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 2500
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 3000
		elseif sType == 'weapon' then
			iMaterialCost = iMaterialCost + 600
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 15
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_greenwood') then
		iMaterialCost = iMaterialCost + (iWeight * 50)
	elseif sMaterial == Interface.getString('bmos_customizeitem_griffon_mane') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 200
		else
			iMaterialCost = iMaterialCost + iWeight * 50
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_living_steel') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 500
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 1500
		elseif sType == 'weapon' then
			iMaterialCost = iMaterialCost + 500
		elseif sType == 'shield' then
			iMaterialCost = iMaterialCost + 100
		elseif sType == 'ammunition' then
			iMaterialCost = 10
		else
			iMaterialCost = iMaterialCost + 250 * iWeight
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_mithral') then
		sNewDamageType = addCSV(sNewDamageType, 'silver')
		iNewWeight = iNewWeight / 2
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 4000
			iNewSpeed30 = 30
			iNewSpeed20 = 20
		elseif sSubType == 'heavy' then
			iMaterialCost = iMaterialCost + 9000
			iNewSpeed30 = 20
			iNewSpeed20 = 15
		elseif sType == 'shield' then
			iMaterialCost = iMaterialCost + 1000
		else
			iMaterialCost = iMaterialCost + 500 * iWeight
		end
		iNewArmorPenalty = iArmorPenalty + 3
		if iNewArmorMaxDex > 0 then
			iNewArmorMaxDex = iNewArmorMaxDex + 2
		end
		iNewArmorSpellFailure = iNewArmorSpellFailure - 10
		if iNewArmorSpellFailure < 0 then
			iNewArmorSpellFailure = 0
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_viridium') then
		if sType == 'weapon' then
			iMaterialCost = iMaterialCost + 200
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 20
		end
	elseif sMaterial == Interface.getString('bmos_customizeitem_whipwood') then
		iMaterialCost = iMaterialCost + 500
	elseif sMaterial == Interface.getString('bmos_customizeitem_wyroot') then
		iMaterialCost = iMaterialCost + 1000
		--elseif sMaterial == Interface.getString('bmos_customizeitem_bone') then
		--iMaterialCost = iMaterialCost / 2 -- disabled as could not find source
		-- elseif sMaterial == Interface.getString("bronze") then
	elseif sMaterial == Interface.getString('bmos_customizeitem_gold') then
		iNewArmorPenalty = iNewArmorPenalty - 2
		iNewWeight = iNewWeight * 1.5
		iMaterialCost = iMaterialCost * 10
	elseif sMaterial == Interface.getString('bmos_customizeitem_obsidian') then
		iNewWeight = iNewWeight * 0.75
		iMaterialCost = iMaterialCost / 2
	elseif sMaterial == Interface.getString('bmos_customizeitem_stone') then
		iNewWeight = iNewWeight * 0.75
		iMaterialCost = iMaterialCost / 4
	end

	local bAlwaysMasterwork = false
	if CustomItemGenItemData.aSpecialMaterials[sMaterial] and CustomItemGenItemData.aSpecialMaterials[sMaterial].bAlwaysMasterwork then
		bAlwaysMasterwork = CustomItemGenItemData.aSpecialMaterials[sMaterial].bAlwaysMasterwork
		if sType == 'armor' and iNewArmorPenalty == iArmorPenalty then
			iNewArmorPenalty = iArmorPenalty + 1
		end
	end
	if iNewArmorPenalty > 0 then
		iNewArmorPenalty = 0
	end

	local bFragile = false
	if CustomItemGenItemData.aSpecialMaterials[sMaterial] and CustomItemGenItemData.aSpecialMaterials[sMaterial].bFragile then
		bFragile = CustomItemGenItemData.aSpecialMaterials[sMaterial].bFragile
	end

	return iMaterialCost,
		iNewWeight,
		iNewArmorPenalty,
		iNewArmorMaxDex,
		iNewArmorSpellFailure,
		iNewSpeed30,
		iNewSpeed20,
		bAlwaysMasterwork,
		bFragile,
		sNewProperties,
		sNewDamageType,
		sAddDescription
end

local function getItemData(databasenode)
	local sItemCost = DB.getValue(databasenode, 'cost', '')
	local sCoinValue, sCoin = sItemCost:match('^%s*([%d,]+)%s*([^%d]*)$')
	if not sCoinValue then
		sCoin, sCoinValue = sItemCost:match('^%s*([^%d]+)%s*([%d,]+)%s*$')
	end
	local nItemCost = 0
	if sCoinValue then
		sCoinValue = string.gsub(sCoinValue, ',', '')
		nItemCost = tonumber(sCoinValue) or 0
		sCoin = StringManager.trim(sCoin)

		local tCurrency = CurrencyManager.getCurrencyRecord(sCoin)
		if tCurrency then
			nItemCost = nItemCost * tCurrency['nValue']
		end
	end

	local sItemProperties = DB.getValue(databasenode, 'properties', '')
	if sItemProperties == '-' then
		sItemProperties = ''
	end

	local sSize = DB.getValue(databasenode, 'size', '')
	if sSize == '' then
		sSize = Interface.getString('bmos_customizeitem_size_medium')
	end

	return DB.getValue(databasenode, 'name', ''),
		nItemCost,
		DB.getValue(databasenode, 'weight', 0),
		DB.getValue(databasenode, 'subtype', ''),
		sItemProperties,
		DB.getValue(databasenode, 'checkpenalty', 0),
		DB.getValue(databasenode, 'maxstatbonus', 0),
		DB.getValue(databasenode, 'spellfailure', 0),
		DB.getValue(databasenode, 'speed30', 0),
		DB.getValue(databasenode, 'speed20', 0),
		DB.getValue(databasenode, 'range', 0),
		DB.getValue(databasenode, 'damagetype', ''),
		DB.getValue(databasenode, 'damage', ''),
		sSize
end

-- luacheck: globals generateMagicItem material
function generateMagicItem(nodeItem)
	if not nodeItem then
		return false
	end
	local sEnhancementBonus = bonus.getValue() or ''
	local sSpecialMaterial = material.getValue() or ''
	local sItemSize = size.getValue() or ''
	local sType, sSubType = getItemType(nodeItem)
	if notifyMissingTypeData(sType, sSubType) then
		return
	end

	local aAbilities = getAbilities(nodeItem, sType, sSubType)

	local _, _, nErrorCode, aConflicts = checkComboboxes(sType, sSubType, nil, sSpecialMaterial, aAbilities)
	if nErrorCode == 1 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('error_bmos_customizeitem_identicalabilities'), aConflicts.sAbility1),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	elseif nErrorCode == 2 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('error_bmos_customizeitem_conflictingabilities'), aConflicts.sAbility1, aConflicts.sAbility2),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	elseif nErrorCode == 3 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('error_bmos_customizeitem_subabilitynotconfigured'), aConflicts.sAbility1),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	-- luacheck: no max line length
	local sItemName, iItemCost, iItemWeight, sFullSubType, sItemProperties, iArmorPenalty, iArmorMaxDex, iArmorSpellFailure, iSpeed30, iSpeed20, iRange, sDamageType, sDamage, sOriginalSize =
		getItemData(nodeItem)
	local sNewDamage = sDamage

	if ItemManager.isWeapon(nodeItem) or ItemManager.isShield(nodeItem) then
		sNewDamage = getDamageForSize(sDamage, sOriginalSize, sItemSize)
	end

	local iEnchancementBonus = getEnhancementBonus(sEnhancementBonus)
	local iEffectiveBonus = iEnchancementBonus
	local iCostBonus = iEnchancementBonus
	local iExtraCost = 0
	local iTotalAbilityBonus = 0

	if (iEnchancementBonus == 0) and (next(aAbilities) ~= nil) then
		Comm.addChatMessage({
			text = Interface.getString('error_bmos_customizeitem_enhancementbonustoolow'),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	local aCL, aAura = {}, {}
	for _, aAbility in ipairs(aAbilities) do
		local iAbilityBonus, iAbilityCostBonus, iAbilityExtraCost, _, iCL, sAura = getAbilityBonusAndCost(aAbility.sAbility, sType, sSubType)
		iEffectiveBonus = iEffectiveBonus + iAbilityBonus
		iTotalAbilityBonus = iTotalAbilityBonus + iAbilityBonus
		iCostBonus = iCostBonus + iAbilityCostBonus
		iExtraCost = iExtraCost + iAbilityExtraCost
		sDamageType, iRange = getSpecialAbilityData(aAbility.sAbility, sDamageType, iRange)
		local sFullSpecialAbility = aAbility.sAbility
		if aAbility.sSubAbility ~= Interface.getString('bmos_customizeitem_bonus_none') then
			sFullSpecialAbility = sFullSpecialAbility .. '(' .. aAbility.sSubAbility
			if aAbility.sSubSubAbility ~= Interface.getString('bmos_customizeitem_bonus_none') then
				sFullSpecialAbility = sFullSpecialAbility .. '(' .. aAbility.sSubSubAbility .. ')'
			end
			sFullSpecialAbility = sFullSpecialAbility .. ')'
		end
		sItemProperties = addCSV(sItemProperties, sFullSpecialAbility)
		table.insert(aCL, iCL)
		table.insert(aAura, sAura)
	end

	if iEffectiveBonus == iTotalAbilityBonus and iTotalAbilityBonus ~= 0 then
		Comm.addChatMessage({
			text = Interface.getString('error_bmos_customizeitem_needsenhancementbonus'),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	if iEffectiveBonus > CustomItemGenItemData.nMaxTotalBonus then
		Comm.addChatMessage({
			text = string.format(Interface.getString('error_bmos_customizeitem_effectivebonustoohigh'), tostring(CustomItemGenItemData.nMaxTotalBonus)),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	local iMaterialCost, iNewWeight, iNewArmorPenalty, iNewArmorMaxDex, iNewArmorSpellFailure, iNewSpeed30, iNewSpeed20, bMasterworkMaterial, bFragileMaterial, sMaterialItemProperties, sMaterialDamageType, sAddDescription =
		getMaterialData(
			nodeItem,
			sSpecialMaterial,
			iEnchancementBonus,
			sType,
			sSubType,
			sFullSubType,
			iItemWeight,
			iArmorPenalty,
			iArmorMaxDex,
			iArmorSpellFailure,
			iSpeed30,
			iSpeed20,
			iItemCost,
			sItemProperties,
			sDamageType
		)
	sDamageType = sMaterialDamageType
	sItemProperties = sMaterialItemProperties
	iNewWeight = getWeightBySize(iNewWeight, sOriginalSize, sItemSize)

	local iMasterworkCost = 0
	if bMasterworkMaterial or sEnhancementBonus ~= Interface.getString('bmos_customizeitem_bonus_none') then
		iMasterworkCost = getMasterworkPrice(sType, sItemProperties)
		sItemProperties = addCSV(sItemProperties, 'masterwork')
		iNewArmorPenalty = iNewArmorPenalty + 1
		if iNewArmorPenalty > 0 then
			iNewArmorPenalty = 0
		end
	end

	if bFragileMaterial then
		sItemProperties = addCSV(sItemProperties, 'fragile')
	end

	local iEnhancementCost = getEnchancementCost(iCostBonus, sType)
	local iTotalCost = iMaterialCost + iMasterworkCost + iEnhancementCost + iExtraCost

	local sItemNewName = getItemNewName(sItemName, sEnhancementBonus, iEnchancementBonus, sSpecialMaterial, aAbilities, bMasterworkMaterial, sItemSize)

	local iNewBonus = 0
	if iEnchancementBonus > 0 then
		iNewBonus = iEnchancementBonus
		sDamageType = addCSV(sDamageType, 'magic')
		if DataCommon.isPFRPG() and (ItemManager.isWeapon(nodeItem) or sType == 'ammunition') then
			sDamageType = getDamageTypeByEnhancementBonus(sDamageType, iEnchancementBonus)
		end
	end
	local sNewNonIdentifiedName = string.format('Unidentified %s', sItemName:lower())

	local iCL = 3 * iNewBonus
	for _, iCL1 in pairs(aCL) do
		iCL = math.max(iCL, iCL1)
	end

	local sAura = ''
	for _, sAura1 in pairs(aAura) do
		sAura = addCSV(sAura, sAura1)
	end

	for _, aAbility in pairs(aAbilities) do
		if aAbility.sAbility == 'Impact' then
			sNewDamage = changeDamageBySizeDifference(sNewDamage, 1)
			break
		elseif aAbility.sAbility == 'Bashing' then
			sNewDamage = changeDamageBySizeDifference(sNewDamage, 2)
			break
		end
		local aAbilityLookup = addEffectsForAbility(nodeItem, sType, sSubType, aAbility)
		if aAbilityLookup and aAbilityLookup.sAddDescription then
			sAddDescription = sAddDescription .. aAbilityLookup.sAddDescription
		end
	end
	if ItemManager.isWeapon(nodeItem) and (sSubType == 'ranged' or sSubType == 'firearm') then
		addRangedEffect(nodeItem)
	end
	if sType == 'ammunition' then
		addAmmoEffect(nodeItem)
	end

	local sItemDescription = DB.getValue(nodeItem, 'description', '')
	if sAddDescription ~= '' then
		string.format('%s<h>%s</h>%s', sItemDescription, sSpecialMaterial, sAddDescription)
	end

	-- Update fields in DB
	DB.setValue(nodeItem, 'aura', 'string', sAura)
	DB.setValue(nodeItem, 'bonus', 'number', iNewBonus)
	DB.setValue(nodeItem, 'cl', 'number', iCL)
	DB.setValue(nodeItem, 'cost', 'string', tostring(iTotalCost) .. ' gp')
	DB.setValue(nodeItem, 'description', 'formattedtext', sItemDescription)
	DB.setValue(nodeItem, 'isidentified', 'number', 0)
	DB.setValue(nodeItem, 'locked', 'number', 1)
	DB.setValue(nodeItem, 'name', 'string', StringManager.capitalize(sItemNewName))
	DB.setValue(nodeItem, 'nonid_name', 'string', StringManager.capitalize(sNewNonIdentifiedName))
	DB.setValue(nodeItem, 'properties', 'string', sItemProperties)
	DB.setValue(nodeItem, 'weight', 'number', iNewWeight)
	DB.setValue(nodeItem, 'damage', 'string', sNewDamage)
	DB.setValue(nodeItem, 'substance', 'string', sSpecialMaterial)
	DB.setValue(nodeItem, 'size', 'string', sItemSize)

	if ItemManager.isWeapon(nodeItem) or sType == 'ammunition' then
		DB.setValue(nodeItem, 'damagetype', 'string', sDamageType)
		DB.setValue(nodeItem, 'range', 'number', iRange)
	end

	if ItemManager.isArmor(nodeItem) or ItemManager.isShield(nodeItem) then
		DB.setValue(nodeItem, 'checkpenalty', 'number', iNewArmorPenalty)
		DB.setValue(nodeItem, 'maxstatbonus', 'number', iNewArmorMaxDex)
		DB.setValue(nodeItem, 'speed20', 'number', iNewSpeed20)
		DB.setValue(nodeItem, 'speed30', 'number', iNewSpeed30)
		DB.setValue(nodeItem, 'spellfailure', 'number', iNewArmorSpellFailure)
	end
	Comm.addChatMessage({ text = string.format('Generated %s', sItemNewName), secret = true, icon = 'ct_faction_friend' })

	return nodeItem
end
