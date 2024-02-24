--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals update

local function sectionVis(tSections)
	for k, v in ipairs(tSections) do
		local num, bool = k, nil
		if k == 2 then
			local bVis = self['divider'] and (self['divider'].getVisible and not self['divider'].getVisible())
			if bVis then
				self['divider'].setVisible(v and tSections[k - 1])
			end
		elseif k > 2 then
			repeat
				num = num - 1
				bool = tSections[num] or bool
			until num == 1

			local sDivName = 'divider' .. tostring(k - 1)
			local bVis = self[sDivName] and (self[sDivName].getVisible and not self[sDivName].getVisible())
			if bVis then
				self[sDivName].setVisible(v and bool)
			end
		end
	end
end

function update(...)
	if super and super.update then
		super.update(...)
	end

	local nodeRecord = getDatabaseNode()
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord)
	local bID = LibraryData.getIDState('item', nodeRecord)

	local tSections = {}

	if Session.IsHost then
		if WindowManager.callSafeControlUpdate(self, 'nonid_name', bReadOnly) then
			tSections[1] = true
		end
	else
		WindowManager.callSafeControlUpdate(self, 'nonid_name', true)
	end
	if Session.IsHost or not bID then
		if WindowManager.callSafeControlUpdate(self, 'nonidentified', bReadOnly) then
			tSections[1] = true
		end
	else
		WindowManager.callSafeControlUpdate(self, 'nonidentified', true)
	end

	if WindowManager.callSafeControlUpdate(self, 'type', bReadOnly, not bID) then
		tSections[2] = true
	end
	if WindowManager.callSafeControlUpdate(self, 'subtype', bReadOnly, not bID) then
		tSections[2] = true
	end

	if WindowManager.callSafeControlUpdate(self, 'cost', bReadOnly, not bID) then
		tSections[3] = true
	end
	if WindowManager.callSafeControlUpdate(self, 'weight', bReadOnly, not bID) then
		tSections[3] = true
	end
	if WindowManager.callSafeControlUpdate(self, 'size', bReadOnly, not bID) then
		tSections[3] = true
	end

	sectionVis(tSections)
end
