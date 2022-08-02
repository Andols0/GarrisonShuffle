-----Version 9.0.2  Game verison 9.0.2
local Shown, Nametable

------------Random Button
local RandomButton= CreateFrame("Button", "$parentRandomButton", GossipFrame, "UIPanelButtonTemplate")
RandomButton:SetPoint("BOTTOMLEFT",GossipFrame, "BOTTOMLEFT",6,4)
RandomButton:SetSize(78,22)
RandomButton:SetText("Shuffle")
RandomButton:Hide()
RandomButton:SetScript("OnClick", function()
	local strings=C_GossipInfo.GetOptions()
	local number=random(1,C_GossipInfo.GetNumOptions())
	C_GossipInfo.SelectOption(number)
		if string.find(strings[number].name,"Default") then
		print("Now playing Default Garrison Music")
	else
		print("Now playing "..string.sub(strings[number].name,7,-2))
	end
	end)

-----------CheckButton
local SortOption=CreateFrame("CheckButton", "$parentSortButton", GossipFrame, "OptionsSmallCheckButtonTemplate")
SortOption:SetPoint("BOTTOMLEFT",GossipFrame, "BOTTOMLEFT",80,1)
GossipFrameSortButtonText:SetText("Alphabetical Order")
SortOption:Hide()
SortOption:SetScript("OnClick", function(self)
	if self:GetChecked() then
		Gshuffle_sort=true
	else
		Gshuffle_sort=false
	end
	GossipFrameUpdate()
end)

	----Events
local function eventHandler()
	if Shown==true then
		RandomButton:Hide()
		SortOption:Hide()
		Shown=false
	end
end

local eventframe = CreateFrame("FRAME")
eventframe:SetScript("OnEvent", eventHandler)
eventframe:RegisterEvent("GOSSIP_CLOSED")

--------------Click it
function GossipTitleButton_OnClick(self)--, button)
	if ( self.type == "Available" ) then
		C_GossipInfo.SelectAvailableQuest(self:GetID());
	elseif ( self.type == "Active" ) then
		C_GossipInfo.SelectActiveQuest(self:GetID());
	else
		if Gshuffle_sort==true and Shown==true then
			C_GossipInfo.SelectOption((Nametable[self:GetText()]));
		else
			C_GossipInfo.SelectOption(self:GetID());
		end
	end
end

local function GossipUpdate()
	if UnitName("npc")=="Tune-O-Tron 5000" or UnitName("npc")=="B.O.O.M. Box" then
		Shown=true
		RandomButton:Show()
		SortOption:Show()
		GossipFrameSortButton:SetChecked(Gshuffle_sort)
		if Gshuffle_sort==true and Shown==true  then
			GossipFrame.titleButtonPool:ReleaseAll();
			GossipFrame.buttons = {};
			--majority of below is from function GossipFrameOptionsUpdate
			local sortedgossipOptions = {}
			local unsortedgossipOptions = C_GossipInfo.GetOptions()

			Nametable = {}
			local sort = {}
			for i, v in ipairs(unsortedgossipOptions) do
				Nametable[v.name] = i
				table.insert(sort,v.name)
			end
			table.sort(sort)
			for i, v in ipairs(sort) do
				sortedgossipOptions[i] = unsortedgossipOptions[Nametable[v]]
			end

			for titleIndex, optionInfo in ipairs(sortedgossipOptions) do

				local button = GossipFrame.titleButtonPool:Acquire();
				table.insert(GossipFrame.buttons, button);
				button:Show();
				button:SetOption(optionInfo.name, optionInfo.type);

				button:SetID(titleIndex);
				--GossipFrame_AnchorTitleButton(button); yay it's a local function code below
					local buttonCount = GossipFrame_GetTitleButtonCount();
					if buttonCount > 1 then
						button:SetPoint("TOPLEFT", GossipFrame_GetTitleButton(buttonCount - 1), "BOTTOMLEFT", 0, (GossipFrame.insertSeparator and -19 or 0) - 3);
					else
						button:SetPoint("TOPLEFT", GossipGreetingText, "BOTTOMLEFT", -10, -20);
					end
					--GossipFrame_CancelTitleSeparator(); also a local function...
						GossipFrame.insertSeparator = false;
					--
				--
			end
		end
	end
end
hooksecurefunc("GossipFrameUpdate",GossipUpdate)
