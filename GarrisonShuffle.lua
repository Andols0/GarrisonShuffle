local Shown, Nametable, SortList

------------Random Button
local RandomButton= CreateFrame("Button", "$parentRandomButton", GossipFrame, "UIPanelButtonTemplate")
RandomButton:SetPoint("BOTTOMLEFT",GossipFrame, "BOTTOMLEFT",6,4)
RandomButton:SetSize(78,22)
RandomButton:SetText("Shuffle")
RandomButton:Hide()
RandomButton:SetScript("OnClick", function()
	local Options = C_GossipInfo.GetOptions()
	local number = random(1,#Options)
	C_GossipInfo.SelectOption(Options[number].gossipOptionID)
	if string.find(Options[number].name,"Default") then
		print("Now playing Default Garrison Music")
	else
		print("Now playing "..string.sub(Options[number].name,7,-2))
	end
	end)

-----------CheckButton
local SortOption = CreateFrame("CheckButton", "$parentSortButton", GossipFrame, "ChatConfigSmallCheckButtonTemplate")
SortOption:SetPoint("BOTTOMLEFT",GossipFrame, "BOTTOMLEFT",85,4)
GossipFrameSortButtonText:SetText("Alphabetical Order")
SortOption:Hide()
SortOption:SetScript("OnClick", function(self)
	if self:GetChecked() then
		Gshuffle_sort=true
		SortList()
	else
		Gshuffle_sort=false
		GossipFrame:Update()
	end
end)
------ Sorter function
local function sorter(a,b)
	if a.buttonType == 1 then --Gossip title
	   return true
	elseif a.buttonType < b.buttonType then --Empty spaces above the songs
	   return true
	elseif a.buttonType == b.buttonType and b.buttonType == 3 then --Compare names
	   return a.info.name < b.info.name
	elseif a.buttonType == b.buttonType then --hope for the best
	   return true
	end
	return false
 end

function SortList()
	if UnitName("npc")=="Tune-O-Tron 5000" or UnitName("npc")=="B.O.O.M. Box" then
		RandomButton:Show()
		SortOption:Show()
		GossipFrameSortButton:SetChecked(Gshuffle_sort)
		if Gshuffle_sort then
			GossipFrame.GreetingPanel.ScrollBox:GetDataProvider():SetSortComparator(sorter)
		end
	else
		SortOption:Hide()
		RandomButton:Hide()
	end
end

hooksecurefunc(GossipFrame,"Update", SortList)

