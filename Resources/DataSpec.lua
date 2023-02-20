local AddOnName, ns     = ...;

ns.Spec                 = {}
local LGT               = LibStub("LibGroupTalents-1.0")
ns.LGT                  = LGT;
ns.specIDs           = {
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
local specIDs  = ns.specIDs 
ns.spec_icon_tcoords    = {
    [0] = { name = "не определен", buffs = {} },
    [1] = { name = "pet", buffs = {} },
    [2] = { name = "unknown", buffs = {} },
    [3] = { name = "monster", buffs = {} },
    --DRUID
    [102] = { name = "Balance", buffs = { "Gift of the Wild", "3% Haste", "5% Spell Crit", "Physical Hit", "Innervate" } },
    [103] = { name = "Feral", buffs = { "5% Physical Crit", "5% Armor (Minor)", "20% Attack Speed", "Attack Power", "Innervate" } },
    [104] = { name = "Bear", buffs = { "5% Physical Crit", "5% Armor (Minor)", "20% Attack Speed", "Attack Power", "Innervate" } },
    [105] = { name = "restoration", buffs = { "Revitalize", "Innervate" } },
    --dK
    [250] = { name = "Blood tank", buffs = { "Strength and Agility", "10% Attack Power", "20% Melee Haste", "Unholy Frenzy", "20% Attack Speed" } },
    [251] = { name = "Frost", buffs = { "Strength and Agility", "20% Melee Haste", "20% Attack Speed" } },
    [252] = { name = "Unholy", buffs = { "Strength and Agility", "13% Spell Damage" } },
    --HUNTER
    [253] = { name = "Beast mastery", buffs = { "3% Damage", "20% Armor (Major)", "5% Armor (Minor)", "Physical Hit" } },
    [254] = { name = "Marksmanship", buffs = { "10% Attack Power", "5% Armor (Minor)", "Physical Hit" } },
    [255] = { name = "survival", buffs = { "5% Armor (Minor)", "Physical Hit", "Mana Replenishment" } },
    --PRIEST
    [256] = { name = "Discipline", buffs = { "Spirit", "Stamina", "Power Infusion", "Hymn of Hope", "Rapture" } },
    [257] = { name = "Holy", buffs = { "Spirit", "Stamina", "Hymn of Hope" } },
    [258] = { name = "Shadow", buffs = { "Spirit", "Stamina", "3% Spell Hit", "Mana Replenishment", "Hymn of Hope", "Vampiric Embrace" } },
    --ROGUE
    [259] = { name = "Assassination", buffs = { "Tricks of the Trade", "3% Crit", "20% Armor (Major)" } },
    [260] = { name = "Combat", buffs = { "Tricks of the Trade", "4% Physical Damage", "20% Armor (Major)" } },
    [261] = { name = "Subtlty", buffs = { "Tricks of the Trade", "20% Armor (Major)" } },
    --SHAMAN
    [262] = { name = "Elemental", buffs = { "Strength and Agility", "Heroism / Bloodlust", "Spell Power", "5% Spell Crit", "5% Spell Haste", "3% Crit", "Mana Restoration (mp5)" } },
    [263] = { name = "Enhancement", buffs = { "Strength and Agility", "10% Attack Power", "20% Melee Haste", "Heroism / Bloodlust", "Spell Power", "5% Spell Haste", "Mana Restoration (mp5)" } },
    [264] = { name = "Restoration", buffs = { "Strength and Agility", "Heroism / Bloodlust", "Spell Power", "5% Spell Haste", "Mana Restoration (mp5)", "Mana Tide Totem" } },
    --WARLOCK
    [265] = { name = "Affliction", buffs = { "Intellect", "Spirit", "5% Spell crit", "13% Spell Damage", "5% Armor (Minor)", "Attack Power" } },
    [266] = { name = "Demonology", buffs = { "Spell Power", "5% Spell crit", "13% Spell Damage", "5% Armor (Minor)", "Attack Power" } },
    [267] = { name = "Destruction", buffs = { "Health", "13% Spell Damage", "5% Armor (Minor)", "Attack Power", "Mana Replenishment" } },
    --MAGE
    [62] = { name = "Arcane", buffs = { "3% Damage", "Intellect", "Focus Magic" } },
    [63] = { name = "Fire", buffs = { "Intellect", "Focus Magic", "5% Spell crit" } },
    [64] = { name = "Frost", buffs = { "Intellect", "5% Spell crit", "Mana Replenishment" } },
    --PALADIN
    [65] = { name = "Holy", buffs = { "Blessing of Kings", "Attack Power: Static", "Mana Restoration (mp5)", "Judgment of Wisdom", "Judgement of Light" } },
    [66] = { name = "Protection", buffs = {
        "Blessing of Kings",
        "Attack Power: Static",
        "Mana Restoration (mp5)",
        "Blessing of Sanctuary",
        "Judgment of Wisdom",
        "Judgement of Light",
        "Divine Guardian",
        "20% Attack Speed",
    } },
    [70] = { name = "Retribution", buffs = {
        "Blessing of Kings",
        "Attack Power: Static",
        "Mana Restoration (mp5)",
        "Judgment of Wisdom",
        "Judgement of Light",
        "3% Damage",
        "3% Haste",
        "3% Crit",
        "Attack Power",
        "Mana Replenishment",
    } },
    --WARRIOR
    [71] = { name = "Arms", buffs = { "Attack Power: Static", "Health", "30% Bleed Damage", "4% Physical Damage", "20% Armor (Major)", "20% Attack Speed", "Attack Power" } },
    [72] = { name = "Fury", buffs = { "Attack Power: Static", "5% Physical Crit", "Health", "20% Armor (Major)", "20% Attack Speed", "Attack Power" } },
    [73] = { name = "Protection", buffs = { "Attack Power: Static", "Health", "20% Armor (Major)", "20% Attack Speed", "Attack Power", } },
}
local spec_icon_tcoords = ns.spec_icon_tcoords
local time              = 0;

local function GetDruidSubSpec(unit)
    -- 57881 : Natural Reaction -- used by druid tanks
    local points = LGT:UnitHasTalent(unit, GetSpellInfo(57881), LGT:GetActiveTalentGroup(unit))
    if points and points > 0 then
        return 3 -- druid tank
    else
        return 2
    end
end

function ns.Spec:GetPlayerSpecID(playerName, playerClass, inRaid)
    local specIdx = 0
    if playerName then
        playerClass = playerClass or select(2, UnitClass(playerName))

        if playerClass and specIDs[playerClass] then
            local talentGroup = LGT:GetActiveTalentGroup("Xta")
            if talentGroup == nil then
                talentGroup = LGT:GetActiveTalentGroup(inRaid)
                if talentGroup == nil then
                    return 0;
                end
            end
            local maxPoints, index = 0, 0

            for i = 1, MAX_TALENT_TABS do
                local name, icon, pointsSpent = LGT:GetTalentTabInfo(playerName, i, talentGroup)
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
        end
    end
    return specIdx
end
