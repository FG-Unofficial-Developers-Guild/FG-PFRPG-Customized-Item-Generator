--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

local function createConsumable(c)
	local nodeSpell = c.window.getDatabaseNode()
	Interface.openWindow('bmos_createconsumable_window', nodeSpell)
end

local function customizeItem(c)
	local nodeItem = DB.copyNode(c.window.getDatabaseNode(), DB.createChild(DB.createNode('item')))
	Interface.openWindow('bmos_customizeitem_window', nodeItem)
end

function onInit()
	ToolbarManager.registerButton('bmos_customizeitem', {
		sType = 'action',
		sIcon = 'button_bmos_customizeitem',
		sTooltipRes = 'tooltip_bmos_customizeitem',
		fnActivate = customizeItem,
		bHostOnly = true,
	})
	ToolbarManager.registerButton('bmos_createconsumable', {
		sType = 'action',
		sIcon = 'button_bmos_customizeitem',
		sTooltipRes = 'tooltip_bmos_createconsumable',
		fnActivate = createConsumable,
		bHostOnly = true,
	})
end
