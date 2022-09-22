--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals onValueChanged getValue add
function onValueChanged()
	if super and super.onValueChanged then super.onValueChanged(); end

	local sClass = (getValue() or ""):lower();
	if sClass ~= "" then
		local sLevelData = DB.getValue(window.getDatabaseNode(), "level", ""):lower()
		local nSpellLevel = tonumber(sLevelData:match(".*" .. sClass .. " (%d+).*") or -1);
		if nSpellLevel and nSpellLevel ~= -1 then
			if window.button_generate.aScrollLevelCosts[sClass][nSpellLevel] then
				window.type.add("Scroll");
			end
			if window.button_generate.aPotionLevelCosts[sClass][nSpellLevel] then
				window.type.add("Potion");
			end
			if window.button_generate.aWandLevelCosts[sClass][nSpellLevel] then
				window.type.add("Wand");
			end
			if nSpellLevel == 0 then
				window.cl.setValue(1)
			else
				local nMinCL = (nSpellLevel * 2) - 1
				window.cl.setMinValue(nMinCL)
				window.cl.setValue(nMinCL)
			end
		end
	end
end

function onInit()
	if super and super.onInit then super.onInit(); end
	clear();

	local sLevelData = DB.getValue(window.getDatabaseNode(), "level", ""):lower()
	local tClasses = { "cleric", "druid", "wizard", "sorcerer", "bard", "paladin", "ranger" };
	for _,v in ipairs(tClasses) do
		if sLevelData:match(v) then
			add(v);
		end
	end
	onValueChanged()
end