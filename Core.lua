-- Author      : Maraka
-- Create Date : 18.02.2023

---------------------------
local AddOnName, ns = ...;
local _delay = false
local _delayTime = false
local RaidSpe = {}
local Core = CreateFrame("Frame", AddOnName .. "_mainFrame", UIParent);
ns.Core = Core;
Core:RegisterEvent("ADDON_LOADED");
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

function Core:ADDON_LOADED(addOnName)
    if AddOnName ~= addOnName then return; end
    ns.Icon:ADDON_LOADED(addOnName, Core)
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
    Delay(Core, GetTime(), 2);
end

function Core:Check()
    RaidSpe = {}
    for i = 1, GetRealNumRaidMembers() do
        if (UnitIsConnected("raid" .. i)) then
            local name, realm = UnitName("raid" .. i)
            local localizedClass, englishClass, classIndex = UnitClass("raid" .. i);
            if (name ~= nil) then
                RaidSpe[name] = {}
                RaidSpe[name]["class"] = englishClass
                RaidSpe[name]["inRaid"] = "raid" .. i
                RaidSpe[name]["spec"] = ns.Spec:GetPlayerSpecID("raid" .. i, englishClass)
            end
        end
    end
    print("-----------------------------------------------------------")
    for key, value in pairs(RaidSpe) do
        print(key, RaidSpe[key]["class"], RaidSpe[key]["spec"])
    end
    print("-----------------------------------------------------------")
end
