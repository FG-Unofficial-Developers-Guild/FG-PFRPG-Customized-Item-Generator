-- 
-- Please see the LICENSE.md file included with this distribution for 
-- attribution and copyright information.
--

local aWandLevelCosts = {
			["cleric"] = {
					[0] = 375,[1] = 750, [2] = 4500, [3] = 11250, [4] = 21000
				},
			["druid"] = {
					[0] = 375,[1] = 750, [2] = 4500, [3] = 11250, [4] = 21000
				},
			["wizard"] = {
					[0] = 375,[1] = 750, [2] = 4500, [3] = 11250, [4] = 21000
				},
			["sorcerer"] = {
					[0] = 375,[1] = 750, [2] = 6000, [3] = 13500, [4] = 24000
				},
			["bard"] = {
					[0] = 375,[1] = 750, [2] = 6000, [3] = 15750, [4] = 30000
				},
			["paladin"] = {
					[1] = 750, [2] = 6000, [3] = 15750, [4] = 30000
				},
			["ranger"] = {
					[1] = 750, [2] = 6000, [3] = 15750, [4] = 30000
				}
		}
local aScrollLevelCosts = {
		["cleric"] = {
					["0"] = 12.5,["1"] = 25, ["2"] = 150, ["3"] = 375, ["4"] = 700, ["5"] = 1125, ["6"] = 1650, ["7"] = 2275, ["8"] = 3000, ["9"] = 3825
				},
		["druid"] = {
					["0"] = 12.5,["1"] = 25, ["2"] = 150, ["3"] = 375, ["4"] = 700, ["5"] = 1125, ["6"] = 1650, ["7"] = 2275, ["8"] = 3000, ["9"] = 3825
				},
		["wizard"] = {
					["0"] = 12.5,["1"] = 25, ["2"] = 150, ["3"] = 375, ["4"] = 700, ["5"] = 1125, ["6"] = 1650, ["7"] = 2275, ["8"] = 3000, ["9"] = 3825
				},
		["sorcerer"] = {
					["0"] = 12.5,["1"] = 25, ["2"] = 200, ["3"] = 450, ["4"] = 800, ["5"] = 1250, ["6"] = 1800, ["7"] = 2450, ["8"] = 3200, ["9"] = 4050
				},
		["bard"] = {
					["0"] = 12.5,["1"] = 25, ["2"] = 200, ["3"] = 525, ["4"] = 1000, ["5"] = 1625, ["6"] = 2400
				},
		["paladin"] = {
					["1"] = 25, ["2"] = 200, ["3"] = 525, ["4"] = 1000
				},
		["ranger"] = {
					["1"] = 25, ["2"] = 200, ["3"] = 525, ["4"] = 1000
				}
		}
local aPotionLevelCosts = {
			["cleric"] = {
					["0"] = 25,["1"] = 50, ["2"] = 300, ["3"] = 750
				},
			["druid"] = {
					["0"] = 25,["1"] = 50, ["2"] = 300, ["3"] = 750
				},
			["wizard"] = {
					["0"] = 25,["1"] = 50, ["2"] = 300, ["3"] = 750
				},
			["sorcerer"] = {
					["0"] = 25,["1"] = 50, ["2"] = 400, ["3"] = 900
				},
			["bard"] = {
					["0"] = 25,["1"] = 50, ["2"] = 400, ["3"] = 1050
				},
			["paladin"] = {
					["1"] = 50, ["2"] = 400, ["3"] = 1050
				},
			["ranger"] = {
					["1"] = 50, ["2"] = 400, ["3"] = 1050
				}
		}

local function getAuraString(nCL, sSchool)
	local sAuraStrength
	if nCL > 9 then
		sAuraStrength = "Overwhelming "
	elseif nCL > 6 then
		sAuraStrength = "Strong "
	elseif nCL > 3 then
		sAuraStrength = "Moderate "
	elseif nCL > 0 then
		sAuraStrength = "Faint "
	else
		sAuraStrength = ""
	end

	return sAuraStrength .. sSchool
end

function onButtonPress()
	local nodeSpell = window.getDatabaseNode();

	local sSpellName = DB.getValue(nodeSpell, "name", "");
	local sType = window.type.getValue() or "";
	local sClass = string.lower(window.class.getValue() or "");
	local nCL = window.cl.getValue() or 0;
	if (not sClass or sClass == "") or (not sType or sType == "") or (not sSpellName or sSpellName == "") then
		return
	end

	local sItemName = sType .. " of " .. sSpellName;

	local sCost, sDesc
	local nSpellLevel = tonumber(string.lower(DB.getValue(nodeSpell, "level", "")):match(".*" .. sClass .. " (%d+).*") or -1);
	if nSpellLevel and nSpellLevel ~= -1 then
		if sType == "Wand" then
			sDesc = "A wand is a thin baton that contains a single spell of 4th level or lower. A wand has 50 charges when created—each charge allows the use of the wand’s spell one time. A wand that runs out of charges is just a stick."
			sCost = aWandLevelCosts[sClass][nSpellLevel]
			local nCharges = window.charges.getValue() or 0;
			if nCharges ~= 0 then
				sItemName = sItemName .. " [" .. nCharges .. " charges]";
			end
		elseif sType == "Scroll" then
			sDesc = "A scroll is a spell (or collection of spells) that has been stored in written form. A spell on a scroll can be used only once. The writing vanishes from the scroll when the spell is activated. Using a scroll is basically like casting a spell."
			sCost = aScrollLevelCosts[sClass][nSpellLevel]
		else
			sDesc = "A potion is a magic liquid that produces its effect when imbibed. Potions vary incredibly in appearance. Magic oils are similar to potions, except that oils are applied externally rather than imbibed. A potion or oil can be used only once. It can duplicate the effect of a spell of up to 3rd level that has a casting time of less than 1 minute and targets one or more creatures or objects."
			sCost = aPotionLevelCosts[sClass][nSpellLevel]
		end

		local nodeItem = DB.findNode("item").createChild();
		DB.setValue(nodeItem, "locked", "number", 1);
		DB.setValue(nodeItem, "name", "string", sItemName);
		DB.setValue(nodeItem, "nonid_name", "string", "Magic " .. sType);
		DB.setValue(nodeItem, "type", "string", sType);
		DB.setValue(nodeItem, "cl", "number", nCL);
		DB.setValue(nodeItem, "description", "formattedtext", sDesc);
		local sSchool = string.lower(DB.getValue(nodeSpell, "school", ""):match("(%a+).*"));
		if sSchool and sSchool == "" then
			sSchool = getAuraString(nCL, sSchool)
			DB.setValue(nodeItem, "aura", "string", sSchool);
		end
		if sCost and sCost ~= "" then
			DB.setValue(nodeItem, "cost", "string", sCost .. " gp");
		end
		Interface.openWindow("item", nodeItem);
		window.close();
	else
		ChatManager.SystemMessage(Interface.getString('magic_item_gen_error_9'));
	end
end
