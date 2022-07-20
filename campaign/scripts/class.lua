--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals onValueChanged
function onValueChanged()
	if super and super.onValueChanged then
		super.onValueChanged();
	end
	local sClass = string.lower(getValue() or "");
	if sClass ~= "" then
		local nSpellLevel = tonumber(string.lower(DB.getValue(window.getDatabaseNode(), "level", "")):match(".*" .. sClass .. " (%d+).*") or -1);
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
	if super and super.onInit then
		super.onInit();
	end
	local tClasses = { "Cleric", "Druid", "Wizard", "Sorcerer", "Bard", "Paladin", "Ranger" };
	clear();
	for _,v in ipairs(tClasses) do
		if string.lower(DB.getValue(window.getDatabaseNode(), "level", "")):find(string.lower(v)) then
			add(v);
		end
	end
end