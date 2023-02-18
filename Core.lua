-- Author      : Maraka
-- Create Date : 18.02.2023

---------------------------
local AddOnName, ns = ...;


local MSG_LEAVES = ERR_RAID_MEMBER_REMOVED_S:gsub("%%s", ""); --	has left the raid group.
local MSG_INVITE = ERR_RAID_MEMBER_ADDED_S:gsub("%%s", ""); --	has joined the raid group.
local MSG_LEFT_RAID = ERR_RAID_YOU_LEFT; -- You have left the raid group.
local MSG_JOINED_RAID = ERR_RAID_YOU_JOINED; -- You have joined a raid group.

local Core = CreateFrame("Frame", AddOnName .. "_mainFrame", UIParent);
ns.Core = Core;
Core:RegisterEvent("ADDON_LOADED");
Core:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end);


local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("RaidComp", {
    type = "data source",
    text = "raidComp",
    icon = [[Interface\Icons\Ability_Rogue_ShadowDance]],
})
local icon = LibStub("LibDBIcon-1.0")
ns.LGT = LibStub("LibGroupTalents-1.0")

local function Delay(Obj, Time,delay)
     Obj:SetScript("OnUpdate", function(self, elapsed)
         if (Time + delay) < GetTime() then
             Core:Check()
             Core:SetScript("OnUpdate", nil);
         end;
     end);
 end;

function Core:ADDON_LOADED(addOnName)
    if AddOnName ~= addOnName then return; end
    icon:Register("raidComp", ldb, { hide = false, })
    Core:UnregisterEvent("ADDON_LOADED");
    Core:RegisterEvent("RAID_ROSTER_UPDATE");
	Core:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function Core:PLAYER_ENTERING_WORLD()
	if  UnitInRaid("player") then
        Delay(Core, GetTime(), 1);
	end;
	Core:UnregisterEvent("PLAYER_ENTERING_WORLD");
end;

function ldb:OnTooltipShow()
    GameTooltip:AddLine("RaidComp", 1, .8, 0)
    GameTooltip:AddLine("Left-Click")
    GameTooltip:AddLine("Shift + Left-Click ")
end

function Core:RAID_ROSTER_UPDATE()
    Delay(Core, GetTime(),2);
end

local nameAndSpeck = {}
local res = {}

function Core:Check()
    res = {}
    for i = 1, GetRealNumRaidMembers() do
        local name, realm = UnitName("raid" .. i)
        local localizedClass, englishClass, classIndex = UnitClass("raid" .. i);
        if (name ~= nil) then
            nameAndSpeck[name] = {}
            nameAndSpeck[name]["class"] = englishClass
            nameAndSpeck[name]["inRaid"] = "raid" .. i
        end
    end
    for key, value in pairs(nameAndSpeck) do
        Core:GetPlayerSpecID(value["inRaid"], value["class"])
    end
    print("-----------------------------------------------------------")
    for key, value in pairs(res) do
        print(key, value[1], value[2])
    end
    print("-----------------------------------------------------------")
end

function ldb:OnClick(button)
    if button == "LeftButton" then
        if IsShiftKeyDown() then
        else
            Core:Check()
        end
    end
end

function Core:PLAYER_LOGOUT()

end


    local specIDs = {
        ["MAGE"] = { 62, 63, 64 },
        ["PRIEST"] = { 256, 257, 258 },
        ["ROGUE"] = { 259, 260, 261 },
        ["WARLOCK"] = { 265, 266, 267 },
        ["WARRIOR"] = { 71, 72, 73 },
        ["PALADIN"] = { 65, 66, 70 },
        ["DEATHKNIGHT"] = { 250, 251, 252 },
        ["DRUID"] = { 102, 103, 104, 105 },
        ["HUNTER"] = { 253, 254, 255 },
        ["SHAMAN"] = { 262, 263, 264 }
    }

    local spec_icon_tcoords = {
        [1] = "pet",
        [2] = "unknown",
        [3] = "monster",
        [102] = "druid balance",
        [103] = "druid feral",
        [104] = "druid tank",
        [105] = "druid restoration",
        [250] = "blood dk",
        [251] = "frost dk",
        [252] = "unholy dk",
        [253] = "hunter beast mastery",
        [254] = "hunter marksmalship",
        [255] = "hunter survival",
        [256] = "priest discipline",
        [257] = "priest holy",
        [258] = "priest shadow",
        [259] = "rogue assassination",
        [260] = "rogue combat",
        [261] = "rogue subtlty",
        [262] = "shaman elemental",
        [263] = "shaman enhancement",
        [264] = "shaman restoration",
        [265] = "warlock affliction",
        [266] = "warlock demonology",
        [267] = "warlock destruction",
        [62] = "mage arcane",
        [63] = "mage fire",
        [64] = "mage frost",
        [65] = "paladin holy",
        [66] = "paladin protection",
        [70] = "paladin ret",
        [71] = "warrior arms",
        [72] = "warrior fury",
        [73] = "warrior protection",
    }
    local time              = 0;

function Core:GetPlayerSpecID(playerName, playerClass)

    local specIdx = 0
    if playerName then
        playerClass = playerClass or select(2, UnitClass(playerName))

        if playerClass and specIDs[playerClass] then
            local talentGroup = ns.LGT:GetActiveTalentGroup(playerName)
            if(talentGroup==nil) then 
                talentGroup= ns.LGT:GetActiveTalentGroup(playerName)
            end
            local maxPoints, index = 0, 0

            for i = 1, MAX_TALENT_TABS do
                local name, icon, pointsSpent = ns.LGT:GetTalentTabInfo(playerName, i, talentGroup)
                if pointsSpent ~= nil then
                    if maxPoints < pointsSpent then
                        maxPoints = pointsSpent
                        if playerClass == "DRUID" and i >= 2 then
                            if i == 3 then
                                index = 4
                            elseif i == 2 then
                                index = GetDruidSubSpec(playerName)
                            end
                        else
                            index = i
                        end
                    end
                end
            end

            if specIDs[playerClass][index] then
                specIdx = specIDs[playerClass][index]
            end
            talentGroup, maxPoints, index = nil, nil, nil
            res[playerName] = {playerClass,spec_icon_tcoords[specIdx]}
        --    print(playerName, playerClass, spec_icon_tcoords[specIdx])
        end
    end
end
