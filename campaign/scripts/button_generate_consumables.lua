-- 
-- Please see the LICENSE.md file included with this distribution for 
-- attribution and copyright information.
--

local aWandLevelCosts = {
			["Cleric, Druid, Wizard"] = {
					["0"] = 375,["1"] = 750, ["2"] = 4500, ["3"] = 11250, ["4"] = 21000
				},
			["Sorcerer"] = {
					["0"] = 375,["1"] = 750, ["2"] = 6000, ["3"] = 13500, ["4"] = 24000
				},
			["Bard"] = {
					["0"] = 375,["1"] = 750, ["2"] = 6000, ["3"] = 15750, ["4"] = 30000
				},
			["Paladin, Ranger"] = {
					["1"] = 750, ["2"] = 6000, ["3"] = 15750, ["4"] = 30000
				}
		}
local aScrollLevelCosts = {
		["Cleric, Druid, Wizard"] = {
					["0"] = 12.5,["1"] = 25, ["2"] = 150, ["3"] = 375, ["4"] = 700, ["5"] = 1125, ["6"] = 1650, ["7"] = 2275, ["8"] = 3000, ["9"] = 3825
				},
		["Sorcerer"] = {
					["0"] = 12.5,["1"] = 25, ["2"] = 200, ["3"] = 450, ["4"] = 800, ["5"] = 1250, ["6"] = 1800, ["7"] = 2450, ["8"] = 3200, ["9"] = 4050
				},
		["Bard"] = {
					["0"] = 12.5,["1"] = 25, ["2"] = 200, ["3"] = 525, ["4"] = 1000, ["5"] = 1625, ["6"] = 2400
				},
		["Paladin, Ranger"] = {
					["1"] = 25, ["2"] = 200, ["3"] = 525, ["4"] = 1000
				}
		}
local aPotionLevelCosts = {
			["Cleric, Druid, Wizard"] = {
					["0"] = 25,["1"] = 50, ["2"] = 300, ["3"] = 750
				},
			["Sorcerer"] = {
					["0"] = 25,["1"] = 50, ["2"] = 400, ["3"] = 900
				},
			["Bard"] = {
					["0"] = 25,["1"] = 50, ["2"] = 400, ["3"] = 1050
				},
			["Paladin, Ranger"] = {
					["1"] = 50, ["2"] = 400, ["3"] = 1050
				}
		}

function onButtonPress()
	local nodeSpell = window.getDatabaseNode();

	local sSpellName = DB.getValue(nodeSpell, "name", "");
	local sType = window.type.getValue() or "";
	local sClass = window.class.getValue() or "";
	-- local nCL = window.cl.getValue() or 0;
	if (not sClass or sClass == "") or (not sType or sType == "") or (not sSpellName or sSpellName == "") then
		return
	end

	local sItemName = sType .. " of " .. sSpellName;
	
	local sCost
	local nSpellLevel = DB.getValue(nodeSpell, "level", ""):match("")
	if sType == "Wand" then
		sCost = aWandLevelCosts[sClass][nSpellLevel]
		local nCharges = window.charges.getValue() or 0;
		if nCharges ~= 0 then
			sItemName = sItemName .. " [" .. nCharges .. " charges]";
		end
	elseif sType == "Scroll" then
		sCost = aScrollLevelCosts[sClass][nSpellLevel]
	else
		sCost = aPotionLevelCosts[sClass][nSpellLevel]
	end

	local nodeItem = DB.findNode("item").createChild();
	DB.setValue(nodeItem, "name", "string", sItemName);
	DB.setValue(nodeItem, "nonid_name", "string", "Magic " .. sType);
	DB.setValue(nodeItem, "type", "string", sType);
	local sSchool = DB.getValue(nodeSpell, "school", ""):match("(%a+).*");
	if sSchool and sSchool == "" then
		DB.setValue(nodeItem, "aura", "string", sSchool);
	end
	if sCost and sCost ~= "" then
		DB.setValue(nodeItem, "cost", "string", sCost .. " gp");
	end
end
