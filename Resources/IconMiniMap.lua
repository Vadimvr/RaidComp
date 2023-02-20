local AddOnName, ns = ...;
local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("RaidComp", {
    type = "data source",
    text = tostring(AddOnName),
    icon = [[Interface\Icons\Ability_Druid_HealingInstincts]],
})
local icon = LibStub("LibDBIcon-1.0")
ns.Icon = icon;
local core;
function icon:ADDON_LOADED(addOnName, Frame)
    core = Frame;
    icon:Register(tostring(addOnName), ldb, { hide = false, })
end

function ldb:OnTooltipShow()
    GameTooltip:AddLine("RaidComp", 1, .8, 0)
    GameTooltip:AddLine("Left-Click update specs")
    GameTooltip:AddLine("Shift + Left-Click  show or hide main window")
end

function ldb:OnClick(button)
    if button == "LeftButton" then
        if IsShiftKeyDown() then
            ns.MainWindow:ShowHide();
        else
            core:Check()
        end
    end
end
