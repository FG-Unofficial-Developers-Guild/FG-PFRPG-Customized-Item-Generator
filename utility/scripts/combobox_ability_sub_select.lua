--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals getValue onValueChanged
function onValueChanged()
	if super and super.onValueChanged then
		super.onValueChanged()
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
	local sAbility = window.ability_select.getValue()
	local aSubSelection = {}
	if aAbilityList ~= nil and next(aAbilityList[sAbility].aSubSelection) ~= nil then
		aSubSelection = aAbilityList[sAbility].aSubSelection[getValue()]
	end
	if aSubSelection ~= nil and next(aSubSelection) ~= nil and next(aSubSelection.aSubSubSelection) ~= nil then
		window.ability_sub_sub_select.clear()
		window.ability_sub_sub_select.add(Interface.getString('bmos_customizeitem_bonus_none'))
		for key, _ in pairs(aSubSelection.aSubSubSelection) do
			window.ability_sub_sub_select.add(key)
		end
		window.ability_sub_sub_select.setValue(Interface.getString('bmos_customizeitem_bonus_none'))
		window.ability_sub_sub_select.setComboBoxVisible(true)
		window.ability_sub_sub_select_label.setVisible(true)
		return
	end

	window.ability_sub_sub_select.setComboBoxVisible(false)
	window.ability_sub_sub_select_label.setVisible(false)
end

-- luacheck: globals onVisibilityChanged
function onVisibilityChanged()
	window.ability_sub_sub_select.setComboBoxVisible(false)
	window.ability_sub_sub_select_label.setVisible(false)
end
