--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

local function createConsumable()
    --whatever
end

local function customizeItem()
    --whatever
end

function onInit()
    ToolbarManager.registerButton("bmos_customizeitem",
        {
            sType = "action",
            sIcon = "button_bmos_customizeitem",
            sTooltipRes = "tooltip_bmos_customizeitem",
            fnActivate = customizeItem,
        });
    ToolbarManager.registerButton("bmos_createconsumable",
        {
            sType = "action",
            sIcon = "button_bmos_customizeitem",
            sTooltipRes = "tooltip_bmos_createconsumable",
            fnActivate = createConsumable,
        });
end