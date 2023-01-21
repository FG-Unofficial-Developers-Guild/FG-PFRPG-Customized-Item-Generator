--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: no max line length
-- luacheck: globals generateMagicItem ItemManager.isArmor ItemManager.isShield ItemManager.isWeapon
-- luacheck: globals addRangedEffect addAmmoEffect cleanAbility getAbilities getAbilityList getItemType

local function addCSV(sString, sAppend)
	if sString == '' then
		return sAppend
	elseif string.find(sString, sAppend) then
		return sString
	end
	return sString .. ', ' .. sAppend
end

function getAbilityBonusAndCost(sSpecialAbility, sType, sSubType)
	local tAbilities
	if sSubType == 'melee' then
		tAbilities = MagicItemGeneratorData.aMeleeWeaponAbilities[sSpecialAbility]
	elseif sSubType == 'ranged' then
		tAbilities = MagicItemGeneratorData.aRangedWeaponAbilities[sSpecialAbility]
	elseif sType == 'armor' then
		tAbilities = MagicItemGeneratorData.aArmorAbilities[sSpecialAbility]
	elseif sType == 'shield' then
		tAbilities = MagicItemGeneratorData.aShieldAbilities[sSpecialAbility]
	elseif sType == 'ammunition' then
		tAbilities = MagicItemGeneratorData.aAmmunitionAbilities[sSpecialAbility]
	end

	local iBonus = tAbilities.iBonus or 0
	local iBonusCost = 0
	local iExtraCost = tAbilities.iCost or 0
	local sAbilityName = tAbilities.sStringName or ''
	local iCL = tAbilities.iCL or 0
	local sAura = tAbilities.sAura or ''

	if iExtraCost == 0 then iBonusCost = iBonus end

	return iBonus, iBonusCost, iExtraCost, sAbilityName, iCL, sAura
end

local function getDamageForSize(sDamage, sOriginalSize, sNewSize)
	local iSizeDifference = MagicItemGeneratorData.aItemSize[sNewSize:lower()].iPosition - MagicItemGeneratorData.aItemSize[sOriginalSize:lower()].iPosition
	if iSizeDifference == 0 then return sDamage end

	return changeDamageBySizeDifference(sDamage, iSizeDifference)
end

function generateMagicItem(nodeItem)
	if not nodeItem then return false end
	local sEnhancementBonus = DB.getValue(nodeItem, 'combobox_bonus', '')
	local sSpecialMaterial = DB.getValue(nodeItem, 'combobox_material', '')
	local sItemSize = DB.getValue(nodeItem, 'combobox_item_size', '')
	local sType, sSubType = getItemType(nodeItem)
	if notifyMissingTypeData(sType, sSubType) then return end

	local aAbilities = getAbilities(nodeItem, sType, sSubType)

	local _, bMaterial, nErrorCode, aConflicts = checkComboboxes(sType, sSubType, nil, sSpecialMaterial, aAbilities)
	if nErrorCode == 1 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('magic_item_gen_error_4'), aConflicts.sAbility1),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	elseif nErrorCode == 2 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('magic_item_gen_error_5'), aConflicts.sAbility1, aConflicts.sAbility2),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	elseif nErrorCode == 3 then
		Comm.addChatMessage({
			text = string.format(Interface.getString('magic_item_gen_error_6'), aConflicts.sAbility1),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	local sItemName, iItemCost, iItemWeight, sFullSubType, sItemProperties, iArmorPenalty, iArmorMaxDex, iArmorSpellFailure, iSpeed30, iSpeed20, iRange, sDamageType, sDamage, sOriginalSize =
		getItemData(nodeItem)
	local sNewDamage = sDamage

	if ItemManager.isWeapon(nodeItem) or ItemManager.isShield(nodeItem) then sNewDamage = getDamageForSize(sDamage, sOriginalSize, sItemSize) end

	local iEnchancementBonus = getEnhancementBonus(sEnhancementBonus)
	local iEffectiveBonus = iEnchancementBonus
	local iCostBonus = iEnchancementBonus
	local iExtraCost = 0
	local iTotalAbilityBonus = 0

	if (iEnchancementBonus == 0) and (next(aAbilities) ~= nil) then
		Comm.addChatMessage({
			text = Interface.getString('magic_item_gen_error_1'),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	local aCL, aAura = {}, {}
	for _, aAbility in ipairs(aAbilities) do
		local iAbilityBonus, iAbilityCostBonus, iAbilityExtraCost, sAbilityName, iCL, sAura =
			getAbilityBonusAndCost(aAbility.sAbility, sType, sSubType)
		iEffectiveBonus = iEffectiveBonus + iAbilityBonus
		iTotalAbilityBonus = iTotalAbilityBonus + iAbilityBonus
		iCostBonus = iCostBonus + iAbilityCostBonus
		iExtraCost = iExtraCost + iAbilityExtraCost
		sDamageType, iRange = getSpecialAbilityData(aAbility.sAbility, sDamageType, iRange)
		local sFullSpecialAbility = aAbility.sAbility
		if aAbility.sSubAbility ~= Interface.getString('itemnone') then
			sFullSpecialAbility = sFullSpecialAbility .. '(' .. aAbility.sSubAbility
			if aAbility.sSubSubAbility ~= Interface.getString('itemnone') then
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
			text = Interface.getString('magic_item_gen_error_7'),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	if iEffectiveBonus > MagicItemGeneratorData.nMaxTotalBonus then
		Comm.addChatMessage({
			text = Interface.getString('magic_item_gen_error_2'),
			secret = true,
			icon = 'ct_faction_foe',
		})
		return false
	end

	local iMaterialCost, iNewWeight, iNewArmorPenalty, iNewArmorMaxDex, iNewArmorSpellFailure, iNewSpeed30, iNewSpeed20, bMasterworkMaterial, bFragileMaterial, sItemProperties, sDamageType, sAddDescription =
		getMaterialData(
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

	local iNewWeight = getWeightBySize(iNewWeight, sOriginalSize, sItemSize)

	local iMasterworkCost = 0
	if bMasterworkMaterial or sEnhancementBonus ~= Interface.getString('itemnone') then
		iMasterworkCost = getMasterworkPrice(sType, sItemProperties)
		sItemProperties = addCSV(sItemProperties, 'masterwork')
		iNewArmorPenalty = iNewArmorPenalty + 1
		if iNewArmorPenalty > 0 then iNewArmorPenalty = 0 end
	end

	if bFragileMaterial then sItemProperties = addCSV(sItemProperties, 'fragile') end

	local iEnhancementCost = getEnchancementCost(iCostBonus, sType)
	local iTotalCost = iMaterialCost + iMasterworkCost + iEnhancementCost + iExtraCost

	local sItemNewName =
		getItemNewName(sItemName, sEnhancementBonus, iEnchancementBonus, sSpecialMaterial, aAbilities, bMasterworkMaterial, sItemSize)

	local iNewBonus = 0
	if iEnchancementBonus > 0 then
		iNewBonus = iEnchancementBonus
		sDamageType = addCSV(sDamageType, 'magic')
		if DataCommon.isPFRPG() and (ItemManager.isWeapon(nodeItem) or sType == 'ammunition') then
			sDamageType = getDamageTypeByEnhancementBonus(sDamageType, iEnchancementBonus)
		end
	end
	local sNewNonIdentifiedName = 'Unidentified ' .. sItemName:lower()

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
	end

	local sItemDescription = DB.getValue(nodeItem, 'description', '')
	if sAddDescription ~= '' then sItemDescription = sItemDescription .. '<h>' .. sSpecialMaterial .. '</h>' .. sAddDescription end

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
	for _, aAbility in pairs(aAbilities) do
		addEffectsForAbility(nodeItem, sType, sSubType, aAbility.sAbility, aAbility.sSubAbility, aAbility.sSubSubAbility)
	end
	if ItemManager.isWeapon(nodeItem) and (sSubType == 'ranged' or sSubType == 'firearm') then addRangedEffect(nodeItem) end
	if sType == 'ammunition' then addAmmoEffect(nodeItem) end
	Comm.addChatMessage({ text = 'Generated ' .. sItemNewName, secret = true, icon = 'ct_faction_friend' }) -- ]]

	return true
end

function getAbilities(nodeItem, sType, sSubType)
	if not nodeItem then return end
	local aAbilities = {}
	for _, nodeAbility in pairs(DB.getChildren(nodeItem, 'abilitieslist')) do
		local aAbility = {}
		aAbility.sAbility = DB.getValue(nodeAbility, 'combobox_ability')
		aAbility.sSubAbility = DB.getValue(nodeAbility, 'combobox_ability_sub_select')
		aAbility.sSubSubAbility = DB.getValue(nodeAbility, 'combobox_ability_sub_sub_select')
		aAbility = cleanAbility(aAbility, sType, sSubType)
		if next(aAbility) ~= nil then table.insert(aAbilities, aAbility) end
	end
	return aAbilities
end

function cleanAbility(aAbility, sType, sSubType)
	local aNewAbility = {}
	local aAbilityList = getAbilityList(sType, sSubType)

	if aAbility.sAbility == Interface.getString('itemnone') then return aNewAbility end
	aNewAbility.sAbility = aAbility.sAbility

	if next(aAbilityList[aAbility.sAbility].aSubSelection) == nil then
		aNewAbility.sSubAbility = Interface.getString('itemnone')
		aNewAbility.sSubSubAbility = Interface.getString('itemnone')
	else
		aNewAbility.sSubAbility = aAbility.sSubAbility
		if
			aAbility.sSubAbility ~= Interface.getString('itemnone')
			and next(aAbilityList[aAbility.sAbility].aSubSelection[aAbility.sSubAbility].aSubSubSelection) == nil
		then
			aNewAbility.sSubSubAbility = Interface.getString('itemnone')
		else
			aNewAbility.sSubSubAbility = aAbility.sSubSubAbility
		end
	end
	return aNewAbility
end

function getAbilityList(sType, sSubType)
	if sType == 'weapon' then
		if sSubType == 'melee' then
			return MagicItemGeneratorData.aMeleeWeaponAbilities
		elseif sSubType == 'ranged' or sSubType == 'firearm' then
			return MagicItemGeneratorData.aRangedWeaponAbilities
		end
	elseif sType == 'ammunition' then
		return MagicItemGeneratorData.aAmmunitionAbilities
	elseif sType == 'armor' then
		return MagicItemGeneratorData.aArmorAbilities
	elseif sType == 'shield' then
		return MagicItemGeneratorData.aShieldAbilities
	end
end

function getItemType(nodeItem)
	local sItemType = ''
	local sItemSubType = ''
	local sType = string.lower(DB.getChild(nodeItem, 'type').getValue() or '')
	local sSubType = string.lower(DB.getChild(nodeItem, 'subtype').getValue() or '')
	if sType == 'weapon' then
		sItemType = 'weapon'
	elseif sType == 'armor' then
		if sSubType:match('shield') then
			sItemType = 'shield'
		else
			sItemType = 'armor'
		end
	end

	if sSubType:match('ammunition') or sType == 'ammo' or sSubType == 'ammo' then sItemType = 'ammunition' end

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

function checkComboboxes(sType, sSubType, sBonus, sMaterial, aAbilities)
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
		if next(aAbilityList[aAbility1.sAbility].aSubSelection) ~= nil and aAbility1.sSubAbility == Interface.getString('itemnone') then
			aConflicts.sAbility1 = aAbility1.sAbility
			return bBonus, bMaterial, 3, aConflicts
		elseif
			next(aAbilityList[aAbility1.sAbility].aSubSelection) ~= nil
			and next(aAbilityList[aAbility1.sAbility].aSubSelection[aAbility1.sSubAbility].aSubSubSelection) ~= nil
			and aAbility1.sSubSubAbility == Interface.getString('itemnone')
		then
			aConflicts.sAbility1 = aAbility1.sAbility
			return bBonus, bMaterial, 3, aConflicts
		end
	end
	return bBonus, bMaterial, 0
end

function checkForAbilitySelectionError(sType, sSubType, aAbility1, aAbility2)
	if aAbility1.sAbility == aAbility2.sAbility then
		return 1
	elseif areExclusive(sType, sSubType, aAbility1.sAbility, aAbility2.sAbility) then
		return 2
	end
	return 0
end

function checkSelection(sSelection) return (sSelection ~= Interface.getString('itemnone')) end

function areExclusive(sType, sSubType, sAbility1, sAbility2)
	local aAbilityList = getAbilityList(sType, sSubType)
	return StringManager.contains(aAbilityList[sAbility1].aExclusions, sAbility2)
end

function getEnhancementBonus(sEnhancementBonus)
	local iEnchancementBonus = 0
	if sEnhancementBonus == Interface.getString('bonus_1') then
		iEnchancementBonus = 1
	elseif sEnhancementBonus == Interface.getString('bonus_2') then
		iEnchancementBonus = 2
	elseif sEnhancementBonus == Interface.getString('bonus_3') then
		iEnchancementBonus = 3
	elseif sEnhancementBonus == Interface.getString('bonus_4') then
		iEnchancementBonus = 4
	elseif sEnhancementBonus == Interface.getString('bonus_5') then
		iEnchancementBonus = 5
	end
	return iEnchancementBonus
end

function getDamageTypeByEnhancementBonus(sDamageType, iEnchancementBonus)
	local sNewDamageType = sDamageType
	if iEnchancementBonus == 5 then
		sNewDamageType = addCSV(sNewDamageType, 'chaotic')
		sNewDamageType = addCSV(sNewDamageType, 'evil')
		sNewDamageType = addCSV(sNewDamageType, 'good')
		sNewDamageType = addCSV(sNewDamageType, 'lawful')
	end
	if iEnchancementBonus >= 4 then sNewDamageType = addCSV(sNewDamageType, 'adamantine') end
	if iEnchancementBonus >= 3 then
		sNewDamageType = addCSV(sNewDamageType, 'cold iron')
		sNewDamageType = addCSV(sNewDamageType, 'silver')
	end
	if iEnchancementBonus >= 1 then sNewDamageType = addCSV(sNewDamageType, 'magic') end
	return sNewDamageType
end

function getMaterialData(
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

	if MagicItemGeneratorData.aSpecialMaterials[sMaterial] and MagicItemGeneratorData.aSpecialMaterials[sMaterial].sAddDescription then
		sAddDescription = MagicItemGeneratorData.aSpecialMaterials[sMaterial].sAddDescription
	end

	if sMaterial == Interface.getString('adamantine') then
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
	elseif sMaterial == Interface.getString('alchemical_silver') then
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
	elseif sMaterial == Interface.getString('angelskin') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1000
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 2000
		end
	elseif sMaterial == Interface.getString('blood_crystal') then
		if sType == 'weapon' then
			iMaterialCost = iMaterialCost + 1500
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 30
		end
	elseif sMaterial == Interface.getString('cold_iron') then
		iMaterialCost = 2 * iMaterialCost
		if iEnhancingBonus > 0 then iMaterialCost = iMaterialCost + 2000 end
		sNewDamageType = addCSV(sNewDamageType, 'cold iron')
	elseif sMaterial == Interface.getString('darkleaf_cloth') then
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
		if iNewArmorSpellFailure < 5 then iNewArmorSpellFailure = 5 end
	elseif sMaterial == Interface.getString('darkwood') then
		if sType == 'shield' then iNewArmorPenalty = iNewArmorPenalty + 2 end
		iMaterialCost = iWeight * 10 + getMasterworkPrice(sType, sProperties)
		iNewWeight = iNewWeight / 2
	elseif sMaterial == Interface.getString('dragonhide') then
		iMaterialCost = 2 * getMasterworkPrice(sType, sProperties)
	elseif sMaterial == Interface.getString('eel_hide') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 1200
		elseif sSubType == 'medium' then
			iMaterialCost = iMaterialCost + 1800
		end
		iNewArmorPenalty = iArmorPenalty + 1
		iNewArmorMaxDex = iNewArmorMaxDex + 1
		iNewArmorSpellFailure = iNewArmorSpellFailure - 10
	elseif sMaterial == Interface.getString('elysian_bronze') then
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
	elseif sMaterial == Interface.getString('fire_forged_steel') or sMaterial == Interface.getString('frost_forged_steel') then
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
	elseif sMaterial == Interface.getString('greenwood') then
		iMaterialCost = iWeight * 50 + getMasterworkPrice(sType, sProperties)
	elseif sMaterial == Interface.getString('griffon_mane') then
		if sSubType == 'light' then
			iMaterialCost = iMaterialCost + 200
		else
			iMaterialCost = iMaterialCost + iWeight * 50
		end
	elseif sMaterial == Interface.getString('living_steel') then
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
	elseif sMaterial == Interface.getString('mithral') then
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
		if iNewArmorMaxDex > 0 then iNewArmorMaxDex = iNewArmorMaxDex + 2 end
		iNewArmorSpellFailure = iNewArmorSpellFailure - 10
		if iNewArmorSpellFailure < 0 then iNewArmorSpellFailure = 0 end
	elseif sMaterial == Interface.getString('viridium') then
		if sType == 'weapon' then
			iMaterialCost = iMaterialCost + 200
		elseif sType == 'ammunition' then
			iMaterialCost = iMaterialCost + 20
		end
	elseif sMaterial == Interface.getString('whipwood') then
		iMaterialCost = iMaterialCost + 500
	elseif sMaterial == Interface.getString('wyroot') then
		iMaterialCost = iMaterialCost + 1000
	elseif sMaterial == Interface.getString('bone') then
		iMaterialCost = iItemBaseCost / 2
		-- elseif sMaterial == Interface.getString("bronze") then
	elseif sMaterial == Interface.getString('gold') then
		iNewArmorPenalty = iNewArmorPenalty - 2
		iNewWeight = iNewWeight * 1.5
		iMaterialCost = 10 * iMaterialCost
	elseif sMaterial == Interface.getString('obsidian') then
		iNewWeight = iNewWeight * 0.75
		iMaterialCost = iNewWeight / 2
	elseif sMaterial == Interface.getString('stone') then
		iNewWeight = iNewWeight * 0.75
		iMaterialCost = iNewWeight / 4
	end

	local bAlwaysMasterwork = false
	if MagicItemGeneratorData.aSpecialMaterials[sMaterial] and MagicItemGeneratorData.aSpecialMaterials[sMaterial].bAlwaysMasterwork then
		bAlwaysMasterwork = MagicItemGeneratorData.aSpecialMaterials[sMaterial].bAlwaysMasterwork
		if sType == 'armor' and iNewArmorPenalty == iArmorPenalty then
			iNewArmorPenalty = iArmorPenalty + 1
		end
	end
	if iNewArmorPenalty > 0 then iNewArmorPenalty = 0 end

	local bFragile = false
	if MagicItemGeneratorData.aSpecialMaterials[sMaterial] and MagicItemGeneratorData.aSpecialMaterials[sMaterial].bFragile then bFragile = MagicItemGeneratorData.aSpecialMaterials[sMaterial].bFragile end

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

function getMasterworkPrice(sType, sProperties)
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

function getItemData(databasenode)
	local dItemName = DB.getChild(databasenode, 'name')
	local dItemProperties = DB.getChild(databasenode, 'properties')
	local dItemWeight = DB.getChild(databasenode, 'weight')
	local dItemCost = DB.getChild(databasenode, 'cost')
	local dSubtype = DB.getChild(databasenode, 'subtype')
	local dArmorPenalty = DB.getChild(databasenode, 'checkpenalty')
	local dArmorMaxDex = DB.getChild(databasenode, 'maxstatbonus')
	local dArmorSpellFailure = DB.getChild(databasenode, 'spellfailure')
	local dSpeed30 = DB.getChild(databasenode, 'speed30')
	local dSpeed20 = DB.getChild(databasenode, 'speed20')
	local dDamageType = DB.getChild(databasenode, 'damagetype')
	local dRange = DB.getChild(databasenode, 'range')
	local dDamage = DB.getChild(databasenode, 'damage')
	local dSize = DB.getChild(databasenode, 'size')

	local sItemName, iItemCost, iItemWeight, sFullSubType, sItemProperties, iArmorPenalty, iArmorMaxDex, iArmorSpellFailure, iSpeed30, iSpeed20, sItemCost, sDamageType, iRange, sDamage, sOriginalSize =
		'', 0, 0, '', '', 0, 0, 0, 0, 0, '', '', 0, '', ''

	if dItemName then sItemName = dItemName.getValue() end
	if dItemProperties then
		sItemProperties = dItemProperties.getValue()
		if sItemProperties == '-' then sItemProperties = '' end
	end
	if dItemWeight then iItemWeight = dItemWeight.getValue() end
	if dItemCost then sItemCost = dItemCost.getValue() end
	if dSubtype then sFullSubType = dSubtype.getValue() end
	if dArmorPenalty then iArmorPenalty = dArmorPenalty.getValue() end
	if dArmorMaxDex then iArmorMaxDex = dArmorMaxDex.getValue() end
	if dArmorSpellFailure then iArmorSpellFailure = dArmorSpellFailure.getValue() end
	if dSpeed30 then iSpeed30 = dSpeed30.getValue() end
	if dSpeed20 then iSpeed20 = dSpeed20.getValue() end
	if dDamageType then sDamageType = dDamageType.getValue() end
	if dRange then iRange = dRange.getValue() end
	if dDamage then sDamage = dDamage.getValue() end
	if dSize then sOriginalSize = dSize.getValue() end
	if not sOriginalSize or sOriginalSize == '' then sOriginalSize = Interface.getString('item_size_medium') end

	local sCoinValue, sCoin = sItemCost:match('^%s*([%d,]+)%s*([^%d]*)$')
	if not sCoinValue then
		sCoin, sCoinValue = sItemCost:match('^%s*([^%d]+)%s*([%d,]+)%s*$')
	end
	if sCoinValue then
		sCoinValue = string.gsub(sCoinValue, ',', '')
		iItemCost = tonumber(sCoinValue) or 0
		sCoin = StringManager.trim(sCoin)
		if sCoin == 'pp' then
			iItemCost = 10 * iItemCost
		elseif sCoin == 'sp' then
			iItemCost = iItemCost / 10
		elseif sCoin == 'cp' then
			iItemCost = iItemCost / 100
		end
	end
	return sItemName,
		iItemCost,
		iItemWeight,
		sFullSubType,
		sItemProperties,
		iArmorPenalty,
		iArmorMaxDex,
		iArmorSpellFailure,
		iSpeed30,
		iSpeed20,
		iRange,
		sDamageType,
		sDamage,
		sOriginalSize
end

function getEnchancementCost(iEnchancementBonus, sType)
	local aBonusPriceArmor = { 0, 1000, 4000, 9000, 16000, 25000, 36000, 49000, 64000, 81000, 100000 }
	local aBonusPriceWeapon = { 0, 2000, 8000, 18000, 32000, 50000, 72000, 98000, 128000, 162000, 200000 }
	local aBonusPriceAmmunition = { 0, 40, 160, 360, 640, 1000, 1440, 1960, 2560, 3240, 4000 }
	local iEnchantmentCost = 0

	if sType == 'weapon' then
		iEnchantmentCost = aBonusPriceWeapon[iEnchancementBonus + 1]
	elseif sType == 'armor' or sType == 'shield' then
		iEnchantmentCost = aBonusPriceArmor[iEnchancementBonus + 1]
	elseif sType == 'ammunition' then
		iEnchantmentCost = aBonusPriceAmmunition[iEnchancementBonus + 1]
	end
	return iEnchantmentCost
end

function figureAbilityName(sAbility, sSubAbility, sSubSubAbility)
	local sAbilityName = ''
	sAbilityName = sAbilityName .. sAbility
	if sSubAbility ~= Interface.getString('itemnone') then
		sAbilityName = sAbilityName .. '(' .. sSubAbility
		if sSubSubAbility ~= Interface.getString('itemnone') then sAbilityName = sAbilityName .. '(' .. sSubSubAbility .. ')' end
		sAbilityName = sAbilityName .. ')'
	end
	sAbilityName = sAbilityName .. ' '
	return sAbilityName
end

function getItemNewName(sItemName, sEnhancementBonus, iEnchancementBonus, sSpecialMaterial, aAbilities, bMasterworkMaterial, sItemSize)
	local sItemNewName = ''
	if sItemSize:lower() ~= Interface.getString('item_size_medium'):lower() then sItemNewName = sItemNewName .. sItemSize .. ' ' end
	if sEnhancementBonus == Interface.getString('bonus_mwk') and not bMasterworkMaterial then sItemNewName = sItemNewName .. 'masterwork' .. ' ' end
	if iEnchancementBonus > 0 then sItemNewName = sItemNewName .. '+' .. tostring(iEnchancementBonus) .. ' ' end
	if sSpecialMaterial ~= Interface.getString('itemnone') then
		sItemNewName = sItemNewName .. MagicItemGeneratorData.aSpecialMaterials[sSpecialMaterial].sStringName .. ' '
	end

	for _, aAbility in pairs(aAbilities) do
		sItemNewName = sItemNewName .. figureAbilityName(aAbility.sAbility, aAbility.sSubAbility, aAbility.sSubSubAbility)
	end

	sItemNewName = sItemNewName .. sItemName
	sItemNewName = sItemNewName:lower()

	sItemNewName = sItemNewName:gsub('^%l', string.upper)

	return sItemNewName
end

function getSpecialAbilityData(sSpecialAbility, sDamageType, iRange)
	local sNewDamageType = sDamageType:lower()
	local iNewRange = iRange
	if sSpecialAbility == Interface.getString('anarchic') then
		sNewDamageType = addCSV(sNewDamageType, 'chaotic')
	elseif sSpecialAbility == Interface.getString('axiomatic') then
		sNewDamageType = addCSV(sNewDamageType, 'lawful')
	elseif sSpecialAbility == Interface.getString('deadly') then
		sNewDamageType = string.gsub(sNewDamageType, ', nonlethal', '')
		sNewDamageType = string.gsub(sNewDamageType, 'nonlethal', '')
	elseif sSpecialAbility == Interface.getString('distance') then
		iNewRange = 2 * iNewRange
	elseif sSpecialAbility == Interface.getString('holy') then
		sNewDamageType = addCSV(sNewDamageType, 'good')
	elseif sSpecialAbility == Interface.getString('merciful') then
		sNewDamageType = addCSV(sNewDamageType, 'nonlethal')
	elseif sSpecialAbility == Interface.getString('throwing') then
		iNewRange = 10
	elseif sSpecialAbility == Interface.getString('unholy') then
		sNewDamageType = addCSV(sNewDamageType, 'evil')
	end
	return sNewDamageType, iNewRange
end

function changeDamageBySizeDifference(sDamage, iSizeDifference)
	if sDamage == '' or sDamage == nil then return sDamage end
	local aDamage = {}
	local aDamageSplit = StringManager.split(sDamage, '/')

	for kDamage, vDamage in ipairs(aDamageSplit) do
		local diceDamage, nDamage = DiceManager.convertStringToDice(vDamage)
		local nDiceCount = 0
		local sDie = ''
		for _, dice in pairs(diceDamage) do
			if sDie == '' then sDie = dice end
			nDiceCount = nDiceCount + 1
		end
		table.insert(aDamage, { dice = nDiceCount .. sDie, mod = nDamage })
	end

	local aNewDamage = {}
	for _, aDmg in pairs(aDamage) do
		local sNewDamage = aDmg.dice
		local nMod = aDmg.mod
		local iPosition = 0
		local bIsAlt1 = false
		local bIsAlt2 = false
		local bIsAlt3 = false

		if MagicItemGeneratorData.aDamageDice[sNewDamage] ~= nil then
			iPosition = MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition
		elseif MagicItemGeneratorData.aAltDamageDice1[sNewDamage] ~= nil then
			sNewDamage = MagicItemGeneratorData.aAltDamageDice1[sNewDamage].sDamage
			iPosition = MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition
			bIsAlt1 = true
		elseif MagicItemGeneratorData.aAltDamageDice2[sNewDamage] ~= nil then
			sNewDamage = MagicItemGeneratorData.aAltDamageDice2[sNewDamage].sDamage
			iPosition = MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition
			bIsAlt2 = true
		elseif MagicItemGeneratorData.aAltDamageDice3[sNewDamage] ~= nil then
			if iSizeDifference < 0 then
				sNewDamage = MagicItemGeneratorData.aAltDamageDice3[sNewDamage].sDown
				iPosition = MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition
				iSizeDifference = iSizeDifference + 1
			else
				sNewDamage = MagicItemGeneratorData.aAltDamageDice3[sNewDamage].sUp
				iPosition = MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition
				iSizeDifference = iSizeDifference - 1
			end
			bIsAlt3 = true
		end

		local iChange
		for iVar = 1, math.abs(iSizeDifference), 1 do
			if iSizeDifference < 0 then
				iChange = -1
			else
				iChange = 1
			end
			if MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition > MagicItemGeneratorData.aDamageDice['1d6'].iPosition then iChange = iChange * 2 end
			sNewDamage = MagicItemGeneratorData.aArmorAbilities[MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition + iChange].sDamage
		end

		if bIsAlt1 then
			if MagicItemGeneratorData.aArmorAbilities[MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition].sAltDamage1 ~= nil then
				sNewDamage = MagicItemGeneratorData.aArmorAbilities[MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition].sAltDamage1
			end
		end
		if bIsAlt2 then
			if MagicItemGeneratorData.aArmorAbilities[MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition].sAltDamage2 ~= nil then
				sNewDamage = MagicItemGeneratorData.aArmorAbilities[MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition].sAltDamage2
			end
		end
		if bIsAlt3 then
			if MagicItemGeneratorData.aArmorAbilities[MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition].sAltDamage3 ~= nil then
				sNewDamage = MagicItemGeneratorData.aArmorAbilities[MagicItemGeneratorData.aDamageDice[sNewDamage].iPosition].sAltDamage3
			end
		end

		table.insert(aNewDamage, { dice = sNewDamage, mod = nMod })
	end

	return getDamageString(aNewDamage)
end

local function mergeDamage(aDamage)
	local sNewDamage = aDamage.dice
	if aDamage.mod > 0 then
		sNewDamage = sNewDamage .. '+' .. aDamage.mod
	elseif aDamage.mod < 0 then
		sNewDamage = sNewDamage .. aDamage.mod
	end
	return sNewDamage
end

function getDamageString(aDamage)
	local sNewDamage = ''
	if aDamage[2] then sNewDamage = mergeDamage(aDamage[2]) end
	if aDamage[1] then
		if sNewDamage ~= '' then sNewDamage = sNewDamage .. '/' end
		sNewDamage = mergeDamage(aDamage[1])
	end
	return sNewDamage
end

local function usingAE() return StringManager.contains(Extension.getExtensions(), 'FG-PFRPG-Advanced-Effects') end

function addEffectsForAbility(nodeItem, sType, sSubType, sAbility, sSubAbility, sSubSubAbility)
	if not nodeItem then return end
	if not usingAE() then return end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then nodeEffectList = DB.createChild(nodeItem, 'effectlist') end
	local aAbility = {}
	local nCritical = 0
	if ItemManager.isWeapon(nodeItem) then
		if sSubType == 'melee' then
			aAbility = MagicItemGeneratorData.aMeleeWeaponAbilities[sAbility]
			nCritical = getCritical(nodeItem)
		elseif sSubType == 'ranged' or sSubType == 'firearm' then
			aAbility = MagicItemGeneratorData.aRangedWeaponAbilities[sAbility]
			nCritical = getCritical(nodeItem)
		end
	elseif sType == 'ammunition' then
		aAbility = MagicItemGeneratorData.aAmmunitionAbilities[sAbility]
	elseif ItemManager.isArmor(nodeItem) then
		aAbility = MagicItemGeneratorData.aArmorAbilities[sAbility]
	elseif ItemManager.isShield(nodeItem) then
		aAbility = MagicItemGeneratorData.aShieldAbilities[sAbility]
	end

	local aEffects = {}
	if aAbility then
		if sSubAbility ~= Interface.getString('itemnone') and next(aAbility.aSubSelection) ~= nil then
			if sSubSubAbility ~= Interface.getString('itemnone') and next(aAbility.aSubSelection[sSubAbility].aSubSubSelection) ~= nil then
				aEffects = aAbility.aSubSelection[sSubAbility].aSubSubSelection[sSubSubAbility].aEffects
			else
				aEffects = aAbility.aSubSelection[sSubAbility].aEffects
			end
		else
			aEffects = aAbility.aEffects
		end
	end
	if next(aEffects) ~= nil then
		for _, aEffect in ipairs(aEffects) do
			if not aEffect.bAERequired or (aEffect.bAERequired and CombatManagerKel) then
				if aEffect.nCritical == 0 or (aEffect.nCritical == nCritical) then
					local sEffect = aEffect.sEffect
					if sType == 'ammunition' and aEffect.sEffect:match('%%s') then sEffect = sEffect:format(getWeaponTypeName(nodeItem)) end
					addEffect(nodeEffectList, sEffect, aEffect.nActionOnly, false)
				end
			end
		end
	end
end

function addEffect(nodeEffectList, sEffect, nActionOnly, bIsLabel)
	if (not nodeEffectList or not sEffect) and sEffect ~= '' then return end
	local nodeEffect = DB.createChild(nodeEffectList)
	if not nodeEffect then return end
	if bIsLabel then DB.setValue(nodeEffect, 'type', 'string', 'label') end
	DB.setValue(nodeEffect, 'effect', 'string', sEffect)
	DB.setValue(nodeEffect, 'actiononly', 'number', nActionOnly)
end

function getCritical(nodeItem)
	if not nodeItem then return 0 end
	local nCritical = 2
	local sCritical = DB.getValue(nodeItem, 'critical')
	if sCritical then
		sCritical = sCritical:match('x%d+')
		if sCritical then nCritical = tonumber(sCritical:match('%d+')) end
	end
	return nCritical
end

function addRangedEffect(nodeItem)
	if not nodeItem then return end
	if not usingAE() then return end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then nodeEffectList = DB.createChild(nodeItem, 'effectlist') end
	addEffect(nodeEffectList, getWeaponTypeName(nodeItem) .. ' Attack', 1, true)
	addEffect(nodeEffectList, 'Crit' .. getCritical(nodeItem), 1, true)
end

function addAmmoEffect(nodeItem)
	if not nodeItem then return end
	if not usingAE() then return end
	local nodeEffectList = DB.getChild(nodeItem, 'effectlist')
	if not nodeEffectList then nodeEffectList = DB.createChild(nodeItem, 'effectlist') end
	local nBonus = DB.getValue(nodeItem, 'bonus', 0)
	addEffect(nodeEffectList, 'IF: CUSTOM(' .. getWeaponTypeName(nodeItem) .. ' Attack); ATK: ' .. nBonus .. ' ranged; DMG: ' .. nBonus, 0, false)
end

function getWeaponTypeName(nodeItem)
	if not nodeItem then return '' end
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

function getWeightBySize(iItemWeight, sOriginalSize, sItemSize)
	if sOriginalSize:lower() == sItemSize:lower() then return iItemWeight end
	return iItemWeight / MagicItemGeneratorData.aWeightMultiplier[sOriginalSize:lower()].nMultiplier * MagicItemGeneratorData.aWeightMultiplier[sItemSize:lower()].nMultiplier
end

---	This function returns true if either supplied string is nil or blank.
function notifyMissingTypeData(sType, sSubType)
	local bNotified
	if not sType or sType == '' then
		ChatManager.SystemMessage(string.format(Interface.getString('magic_item_gen_error_8'), 'type'))
		bNotified = true
	end
	if (not sSubType or sSubType == '') and not sType == 'ammunition' then
		ChatManager.SystemMessage(string.format(Interface.getString('magic_item_gen_error_8'), 'subtype'))
		bNotified = true
	end
	return bNotified
end
