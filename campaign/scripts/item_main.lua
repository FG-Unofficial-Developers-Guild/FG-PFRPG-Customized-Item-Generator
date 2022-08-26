--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals update

function update(...)
	if super and super.update then super.update(...); end

	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = LibraryData.getIDState("item", nodeRecord);

	local bSection1 = false;
	if Session.IsHost then
		if self.updateControl("nonid_name", bReadOnly, true) then bSection1 = true; end;
	else
		self.updateControl("nonid_name", false);
	end
	if (Session.IsHost or not bID) then
		if self.updateControl("nonidentified", bReadOnly, true) then bSection1 = true; end;
	else
		self.updateControl("nonidentified", false);
	end

	local bSection2 = false;
	if self.updateControl("type", bReadOnly, bID) then bSection2 = true; end
	if self.updateControl("subtype", bReadOnly, bID) then bSection2 = true; end

	local bSection3 = false;
	if self.updateControl("cost", bReadOnly, bID) then bSection3 = true; end
	if self.updateControl("weight", bReadOnly, bID) then bSection3 = true; end
	if self.updateControl("size", bReadOnly, bID) then bSection3 = true; end

	if not divider.isVisible() then divider.setVisible(bSection1 and bSection2); end
	if not divider2.isVisible() then divider2.setVisible((bSection1 or bSection2) and bSection3); end
end