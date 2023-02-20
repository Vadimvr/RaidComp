-- Author      : Maraka
-- Create Date : 18.02.2023

---------------------------
local AddOnName, ns = ...;
local _delay = false
local _delayTime = false
ns.RaidSpec = {}
local Core = CreateFrame("Frame", AddOnName .. "_mainFrame", UIParent);
ns.Core = Core;
Core:RegisterEvent("ADDON_LOADED");
Core:RegisterEvent("PLAYER_LOGOUT");
Core:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end);


ns.LGT = LibStub("LibGroupTalents-1.0")

local function Delay(Obj, Time, delay)
    Obj:SetScript("OnUpdate", function(self, elapsed)
        if (Time + delay) < GetTime() then
            Core:Check()
            Core:SetScript("OnUpdate", nil);
        end
    end);
end
function Core:PLAYER_LOGOUT()
    WrathRaidComp.RaidSpe = ns.RaidSpec or {}
end

function Core:ADDON_LOADED(addOnName)
    WrathRaidComp = WrathRaidComp or {};
    ns.RaidSpec = WrathRaidComp.RaidSpe or {}
    if AddOnName ~= addOnName then return; end
    ns.Icon:ADDON_LOADED(addOnName, Core)
    ns.MainWindow:Init();
    Core:UnregisterEvent("ADDON_LOADED");
    Core:RegisterEvent("RAID_ROSTER_UPDATE");
    Core:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function Core:PLAYER_ENTERING_WORLD()
    Core:Check__Delay()
    Core:UnregisterEvent("PLAYER_ENTERING_WORLD");
end

function Core:Check__Delay()
    if UnitInRaid("player") then
        local time = 1.5;
        Delay(Core, GetTime(), time);
    end
end

function Core:RAID_ROSTER_UPDATE()
    Delay(Core, GetTime(), 0.2);
end

function Core:UpdatePlayersRaidFrame(player)
    if (player and ns.RaidSpec[player]) then
        local spec = ns.Spec:GetPlayerSpecID(ns.RaidSpec[player].name, ns.RaidSpec[player].class,
            ns.RaidSpec[player].inRaid);
        if (spec > 0) then
            ns.RaidSpec[player].spec = spec;
            ns.RaidSpec[player].isUpdate = false;
        end
    end
end

function ns.Core:UpdatePlayerSpec(name, newSpec)
    if (name and newSpec) then
        ns.RaidSpec[name].spec = newSpec;
        ns.RaidSpec[name].isUpdate = true;
    end
end

function Core:Check()
    local raidSpe = {}
    for key, value in pairs(ns.RaidSpec) do
        ns.RaidSpec[key].inRaid = nil
    end

    for i = 1, GetRealNumRaidMembers() do
        --    Xta    2     2          80  Ïàëàäèí PALADIN Äàëàðàí 1 nil nil nil nil nil nil
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
        if (online == 1) then
            if (name ~= nil) then
                if (ns.RaidSpec[name] == nil) then
                    ns.RaidSpec[name] = {}
                end
                ns.RaidSpec[name].name = name;
                ns.RaidSpec[name].color = ns:GetColor(fileName);
                ns.RaidSpec[name].colorName = ns.RaidSpec[name].color .. name .. "|r";
                ns.RaidSpec[name].class = fileName;
                ns.RaidSpec[name].group = subgroup;
                ns.RaidSpec[name].inRaid = "raid" .. i;
                ns.RaidSpec[name].isUpdate = false;

                if ns.RaidSpec[name].spec == nil or ns.RaidSpec[name].spec == 0 then
                    ns.RaidSpec[name].spec = ns.Spec:GetPlayerSpecID(name, fileName, "raid" .. i);
                end
            end
        end
    end

    for key, value in pairs(ns.RaidSpec) do
        if (ns.RaidSpec[key].inRaid == nil) then
            print(value.name, value.inRaid, "Is removed")
            ns.RaidSpec[key] = nil;
        end
    end
    -- print("-----------------------------------------------------------")
    -- for key, value in pairs(ns.RaidSpe) do
    --     print(key, value.class, value.spec)
    -- end
    -- print("-----------------------------------------------------------")
    ns.MainWindow:AddRolesInFrame()
end

function ns:GetColor(classFilename, name)
    local color = "|cFFFFFFFF";
    if (classFilename == "DEATHKNIGHT") then
        color = "|cFFC41E3A";
    elseif (classFilename == "WARLOCK") then
        color = "|cFF8788EE";
    elseif (classFilename == "DRUID") then
        color = "|cFFFF7C0A";
    elseif (classFilename == "MAGE") then
        color = "|cFF3FC7EB";
    elseif (classFilename == "HUNTER") then
        color = "|cFFAAD372";
    elseif (classFilename == "PALADIN") then
        color = "|cFFF48CBA";
    elseif (classFilename == "WARRIOR") then
        color = "|cFFC69B6D";
    elseif (classFilename == "ROGUE") then
        color = "|cFFFFF468";
    elseif (classFilename == "SHAMAN") then
        color = "|cFf0070DD";
    elseif (classFilename == "PRIEST") then
        color = "|cFFFFFFFF"
    end
    return color;
end
