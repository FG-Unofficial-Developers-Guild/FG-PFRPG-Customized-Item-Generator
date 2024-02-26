--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals addItems
function onInit()
	if super and super.onInit then
		super.onInit()
	end
	clear()
	addItems({
		Interface.getString('bmos_customizeitem_bonus_none'),
		Interface.getString('bmos_customizeitem_bonus_mwk'),
		Interface.getString('bmos_customizeitem_bonus_1'),
		Interface.getString('bmos_customizeitem_bonus_2'),
		Interface.getString('bmos_customizeitem_bonus_3'),
		Interface.getString('bmos_customizeitem_bonus_4'),
		Interface.getString('bmos_customizeitem_bonus_5'),
	})
end
