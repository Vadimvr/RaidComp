local AddOnName, ns               = ...;

local MainWindow                  = CreateFrame("Frame", AddOnName .. "_MainWindow", UIParent);
local dropdown                    = CreateFrame("Frame", AddOnName .. "_RaidFrameChangeSpec", nil,
    "UIDropDownMenuTemplate")

local width                       = 800;
local height                      = 670;
local textPlayerInRaidFrame       = "%s\n|cff".."6bed5f".."%s|r";
local textPlayerInRaidFrameUpdate = "%s\n|cff".."f2f542".."%s|r";
local colorBuff                   = {
    Red = "|cFFC41E3A%s %s|r",
    Green = "|cFF15eb4d%s %s|r"
}
local raidFrame                   = {}
local raidSize                    = 25;
local textBoxes                   = {}
local Labels                      = {
    TANK = {
        --dk
        "Blood",
        --Druid
        "Feral(Beer)",
        --Pal
        "Protection Pal",
        --Warrior
        "Protection War",
    },
    HEAL = {
        --Druid
        "Restoration",
        --Priest
        "Discipline",
        "Holy",
        --Paladin
        "Holy",
        --Shaman
        "Restoration"
    },
    RDD = {
        -- hunter
        "Beast Mastery",
        "Marksmanship",
        "Survival",
        -- mage
        "Arcane",
        "Fire",
        "Frost",
        -- Warlock
        "Affliction",
        "Demonology",
        "Destruction",

        --Druid
        "Balance",
        --Priest
        "Shadow",
        --Shaman
        "Elemental",
    },
    DD = {
        --Rouge
        "Assassination",
        "Combat",
        "Subtlety",

        --Dk
        "Frost",
        "Unholy",
        --Druid
        "Feral(cat)",

        --Warrior
        "Arms",
        "Fury",
        --Paladin
        "Retribution",

        --Shaman
        "Enhancement",
    },
}
local RaidBuffs                   = {
    {
        "Raid Buffs",
        "Gift of the Wild",
        "Blessing of Kings",
        "Strength and Agility",
        "Attack Power: Static",
        "10% Attack Power",
        "5% Physical Crit",
        "20% Melee Haste",
        "3% Damage",
        "3% Haste",
        "Heroism / Bloodlust",
        "Intellect",
        "Spell Power",
        "5% Spell Crit",
        "5% Spell Haste",
        "Spirit",
        "Stamina",
        "Health",

    },
    {
        "Single-Player Buffs",
        "Focus Magic",
        "Unholy Frenzy",
        "Tricks of the Trade",
        "Power Infusion",
    },
    {
        "Damage Reduction",
        "Divine Guardian",
        "Blessing of Sanctuary",
    },
    {
        "Offensive Debuffs",
        "30% Bleed Damage",
        "4% Physical Damage",
        "3% Crit",
        "5% Spell crit",
        "3% Spell Hit",
        "13% Spell Damage",
    },
    {
        "Reduction Debuffs",
        "20% Armor (Major)",
        "5% Armor (Minor)",
        "20% Attack Speed",
        "Attack Power",
        "Physical Hit",
    },
    {
        "Resource Return",
        "Judgment of Wisdom",
        "Mana Replenishment",
        "Mana Restoration (mp5)",
        "Mana Tide Totem",
        "Hymn of Hope",
        "Rapture",
        "Revitalize",
        "Innervate",
    },
    {
        "Health Return",
        "Improved Leader of the Pack",
        "Judgement of Light",
        "Vampiric Embrace",
    }
}

local RaidBuffsDescription        = {
    ["Gift of the Wild"] = { 21850, },
    ["Blessing of Kings"] = { 25898 },
    ["Strength and Agility"] = { 57330, 58643 },
    ["Attack Power: Static"] = { 25782, 6673 },
    ["10% Attack Power"] = { 30809, 53138, 19506 },
    ["5% Physical Crit"] = { 17007, 29801 },
    ["20% Melee Haste"] = { 29193, 55610 },
    ["3% Damage"] = { 31869, 34460, 31583 },
    ["3% Haste"] = { 48396, 53648 },
    ["Heroism / Bloodlust"] = { 53648, 2825 },
    ["Intellect"] = { 8097, 57567 },
    ["Spell Power"] = { 57722, 58656, 48090 },
    ["5% Spell Crit"] = { 24907, 51470 },
    ["5% Spell Haste"] = { 3738 },
    ["Spirit"] = { 48073, 6203 },
    ["Stamina"] = { 48161 },
    ["Health"] = { 47982, 47440 },
    ["Focus Magic"] = { 54648 },
    ["Unholy Frenzy"] = { 49016 },
    ["Tricks of the Trade"] = { 57934 },
    ["Power Infusion"] = { 10060 },
    ["Divine Guardian"] = { 53530 },
    ["Blessing of Sanctuary"] = { 25899 },
    ["30% Bleed Damage"] = { 33917, 46855, 57393 },
    ["4% Physical Damage"] = { 29859, 58413 },
    ["3% Crit"] = { 57722, 20337, 58410 },
    ["5% Spell crit"] = { 12873, 28593, 17803 },
    ["3% Spell Hit"] = { 33602, 33193 },
    ["13% Spell Damage"] = { 47865, 48511, 51161 },
    ["20% Armor (Major)"] = { 7386, 8647, 55754 },
    ["5% Armor (Minor)"] = { 50511, 770, 56631 },
    ["20% Attack Speed"] = { 12666, 53696, 48485, 59921 },
    ["Attack Power"] = { 47437, 48560, 26017, 50511, 55487 },
    ["Physical Hit"] = { 3043, 48468 },
    ["Judgment of Wisdom"] = { 53408 },
    ["Mana Replenishment"] = { 48160, 31878, 53292, 54118, 44561, 54118 },
    ["Mana Restoration (mp5)"] = { 48936, 58774 },
    ["Mana Tide Totem"] = { 16191 },
    ["Hymn of Hope"] = { 64901 },
    ["Rapture"] = { 47537 },
    ["Revitalize"] = { 48545 },
    ["Innervate"] = { 29166 },
    ["Improved Leader of the Pack"] = { 34300 },
    ["Judgement of Light"] = { 20271 },
    ["Vampiric Embrace"] = { 15286 },
}



ns.MainWindow = MainWindow;
function MainWindow:Init()
    MainWindow:CreateWindows();
    MainWindow:AddRaidFrames();
    MainWindow:AddBuffs()
    MainWindow:AddButtonToRaidFrame()
    --MainWindow:Hide();
end

function MainWindow:AddButtonToRaidFrame()
    local btn = CreateFrame("button", nil, RaidFrame, "UIPanelButtonTemplate")
    btn:SetPoint("TOPRIGHT", -60, -13)
    btn:SetSize(50, 20)
    btn:SetText("Show")
    btn:SetScript("OnMouseDown", function()
        MainWindow:ShowHide();
    end)
end

function MainWindow:CreateWindows()
    MainWindow:SetPoint("CENTER", 0, 0)
    MainWindow.width  = width
    MainWindow.height = height
    MainWindow:SetSize(MainWindow.width, MainWindow.height)


    MainWindow:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
        edgeSize = 16,
        insets = { left = 8, right = 6, top = 8, bottom = 8 },
    })
    MainWindow:SetBackdropBorderColor(0, .44, .87, 0.5);
    MainWindow:EnableMouse(true)

    -- Movable
    MainWindow:SetMovable(true)
    MainWindow:SetClampedToScreen(false)
    MainWindow:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            MainWindow:StartMoving()
        end
    end)

    MainWindow:SetScript("OnMouseUp", MainWindow.StopMovingOrSizing)
    local btn = CreateFrame("button", nil, MainWindow, "UIPanelCloseButton")
    btn:SetPoint("TOPRIGHT", -15, -15)
    btn:SetSize(30, 30)
    btn:SetScript("OnMouseDown", function()
        MainWindow:ShowHide();
    end)
end

function MainWindow:ShowHide()
    if (MainWindow:IsVisible()) then
        MainWindow:Hide()
    else
        MainWindow:Show()
    end
end

function MainWindow:AddRolesInFrame()
    -- сбрасываем значения

    for key, value in pairs(textBoxes) do
        textBoxes[key].count = 0;
    end
    for i = 1, #raidFrame do
        raidFrame[i].Text:SetText("")
    end

    for key, value in pairs(ns.RaidSpec) do
        local spec = value.spec;
        local group = value.group;
        if (group <= raidSize / 5) then
            for i = 5 * (group - 1) + 1, (5 * group), 1 do
                if (raidFrame[i].Text:GetText() == nil) then
                    if (value.isUpdate) then
                        raidFrame[i].Text:SetText(textPlayerInRaidFrameUpdate:format(value.colorName,
                            ns.spec_icon_tcoords[value.spec].name))
                    else
                        raidFrame[i].Text:SetText(textPlayerInRaidFrame:format(value.colorName,
                            ns.spec_icon_tcoords[value.spec].name))
                    end
                    raidFrame[i].player = value.name;
                    raidFrame[i].class = value.class;
                    raidFrame[i].color = value.color;
                    raidFrame[i].spec = value.spec;
                    local arr = ns.spec_icon_tcoords[spec].buffs;
                    for j = 1, #arr do
                        textBoxes[arr[j]].count = textBoxes[arr[j]].count + 1;
                    end
                    break;
                end
            end
        else
            local arr = ns.spec_icon_tcoords[spec].buffs;
            for j = 1, #arr do
                textBoxes[arr[j]].count = textBoxes[arr[j]].count + 1;
            end
        end
    end
    -- устанавливаем значения
    for key, value in pairs(textBoxes) do
        if (value.count > 0) then
            value.setText(colorBuff.Green:format(value.count, value.text))
        else
            value.setText(colorBuff.Red:format(value.count, value.text))
        end
    end
end

do --MainWindow:AddRaidFrames()
    local font = CreateFont("MUI_ButtonFont");
    font:SetFont("Fonts\\ARIALN.ttf", 16)
    local x         = 20;
    local xDefault  = 20;
    local y         = -20;
    local yDefault  = -20;
    local count     = 1;
    local rowWight  = 150;
    local rowHeight = 50;
    local menuTable = {}

    function MainWindow:AddRaidFrames()
        local i1 = 0;
        for i = 1, raidSize, 1 do
            i1 = i;
            local playerFrame = CreateFrame("Frame", nil, MainWindow);
            playerFrame:SetSize(rowWight, rowHeight)
            playerFrame:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
                edgeSize = 16,
                insets = { left = 2, right = 2, top = 2, bottom = 2 },
            })

            playerFrame:SetBackdropColor(.91, .0, .67, .08)
            playerFrame:SetBackdropBorderColor(.52, .235, .210, 1);
            playerFrame:SetPoint("TOPLEFT", x, y);


            local title = playerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
            title:SetPoint("CENTER", 0, 0);
            title:SetSize(rowWight - 5, rowHeight - 3)

            title:SetJustifyH("CENTER")
            title:SetJustifyV("CENTER")
            title:SetFont("Fonts\\ARIALN.ttf", 16)
            playerFrame:EnableMouse(true)
            -- link to text
            playerFrame.Text = title;
            -- player info
            playerFrame.player = nil;
            playerFrame.class = nil;
            playerFrame.color = nil;
            playerFrame.spec = nil;
            playerFrame:SetScript("OnMouseDown", function(self, button)
                if (playerFrame.player) then
                    if (button == "LeftButton") then
                        if (playerFrame.player) then
                            ns.Core:UpdatePlayersRaidFrame(playerFrame.player)
                            MainWindow:AddRolesInFrame()
                        end
                    elseif button == "RightButton" then
                        menuTable = {}
                        local j;
                        for i = 1, #ns.specIDs[playerFrame.class] do
                            j = i;
                            menuTable[i] = {
                                fontObject = font,
                                colorCode = playerFrame.color,
                                text = ns.spec_icon_tcoords[ns.specIDs[playerFrame.class][i]].name,
                                func = function()
                                    ns.Core:UpdatePlayerSpec(playerFrame.player, ns.specIDs[playerFrame.class][i])
                                    MainWindow:AddRolesInFrame()
                                end,
                                notCheckable = 1,
                                padding = 5,
                            };
                        end
                        menuTable[j + 1] = {
                            fontObject   = font,
                            justifyH     = "CENTER",
                            colorCode    = "|cFFFFFFFF",
                            text         = "Close",
                            func         = function()
                            end,
                            notCheckable = 1,
                            padding      = 5,
                        };

                        EasyMenu(menuTable, dropdown, "cursor", 0, 0, "MENU")
                    end
                end
            end)
            y = y - rowHeight * 0.8

            raidFrame[i] = playerFrame;
            if (i1 % 10 == 0) then
                x = xDefault - rowWight;
                yDefault = y - 10;
            end

            if (i % 5 == 0) then
                y = yDefault;
                x = x + rowWight;
            end
        end
    end
end

function MainWindow:AddBuffs()
    textBoxes = {}
    local lines = 27;
    local countLines = 1;
    local x = 350
    local defY = 20;
    local y = -defY;
    for i = 1, #RaidBuffs do
        local title = MainWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        title:SetPoint("TOPLEFT", x, y);
        title:SetText("|cFFFFFFFF" .. RaidBuffs[i][1] .. "|r")
        title:SetJustifyH("LEFT")
        title:SetJustifyV("CENTER")
        title:SetFont("Fonts\\ARIALN.ttf", 18)
        y = y - 20
        countLines = countLines + 1;
        if (countLines % lines == 0) then
            x = x + 150;
            y = defY;
        end
        for j = 2, #RaidBuffs[i] do
            local textFrame = CreateFrame("Frame", nil, MainWindow);
            textFrame:SetSize(150, 30)
            textFrame:SetPoint("TOPLEFT", x, y);
            textFrame:EnableMouse(true)

            textFrame.tooltip = CreateToolTip(textFrame, RaidBuffs[i][j]);

            textFrame:SetScript("OnMouseDown", function()
                textFrame.tooltip:Show()
            end)
            textFrame:SetScript("OnMouseUp", function()
                textFrame.tooltip:Hide()
            end)
            local text = textFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
            text:SetPoint("TOPLEFT", 0, 0);
            text:SetJustifyH("LEFT")
            text:SetJustifyV("CENTER")
            text:SetFont("Fonts\\ARIALN.ttf", 15)
            text:SetText(colorBuff.Red:format(0, RaidBuffs[i][j]))
            y = y - 25
            countLines = countLines + 1;
            if (countLines % lines == 0) then
                x = x + 200;
                y = -defY;
            end
            textBoxes[RaidBuffs[i][j]] = {
                count = 0,
                text = RaidBuffs[i][j],
                setText = function(message)
                    text:SetText(message);
                end
            }
        end
    end
end

function CreateToolTip(frame, category)
    local sizeIcon = 45;
    local spacingBetweenIcons = 60
    local iconPadding = 15
    local tooltip = CreateFrame("Frame", nil, frame)
    tooltip:EnableMouse(true)

    tooltip:SetPoint("LEFT")
    tooltip:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    })
    tooltip:SetBackdropColor(0.9, 0.9, 0.9, 0.9)
    local spells = RaidBuffsDescription[category];
    for i = 1, #spells do
        local name, rank, icon1, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(spells[i])
        local title = tooltip:CreateFontString(nil, "OVERLAY", "GameFontNormal");
        title:SetPoint("TOPLEFT", sizeIcon + iconPadding, -iconPadding - spacingBetweenIcons * (i - 1));
        title:SetText(name)
        title:SetJustifyH("LEFT")
        title:SetJustifyV("CENTER")
        title:SetFont("Fonts\\ARIALN.ttf", 14)
        title:SetSize(100, 40)
        local icon = CreateFrame("Frame", nil, tooltip)
        icon:EnableMouse(true)

        icon:SetPoint("TOPLEFT", iconPadding * 0.2, -iconPadding - spacingBetweenIcons * (i - 1))
        icon:SetSize(sizeIcon, sizeIcon)
        icon.tex = icon:CreateTexture()
        icon.tex:SetAllPoints(icon)
        icon.tex:SetTexture(icon1)
        icon:SetScript("OnEnter", function()
            GameTooltip:SetOwner(icon, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink("spell:" .. spells[i])
            GameTooltip:Show();
        end)
        icon:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end
    tooltip:SetSize(spacingBetweenIcons * 3, spacingBetweenIcons * #spells + iconPadding)
    tooltip:Hide()
    tooltip:SetScript("OnMouseDown", function()
        tooltip:Hide()
    end)
    return tooltip;
end
