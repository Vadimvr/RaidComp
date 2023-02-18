local AddOnName, ns = ...;
local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("RaidComp", {
    type = "data source",
    text = tostring(AddOnName),
    icon = [[Interface\Icons\Ability_Rogue_ShadowDance]],
})
local icon = LibStub("LibDBIcon-1.0")
ns.Icon = icon;
local core;
function icon:ADDON_LOADED(addOnName, Frame)
    core = Frame;
   print("load")
   icon:Register(tostring(addOnName), ldb, { hide = false, })

end

function ldb:OnTooltipShow()
    GameTooltip:AddLine("RaidComp", 1, .8, 0)
    GameTooltip:AddLine("Left-Click")
    GameTooltip:AddLine("Shift + Left-Click ")
end

function ldb:OnClick(button)
    if button == "LeftButton" then
        if IsShiftKeyDown() then
        else
            core:Check()
        end
    end
end