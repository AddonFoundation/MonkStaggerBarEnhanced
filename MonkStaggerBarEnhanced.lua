-- MonkStaggerBarEnhanced - Simple moveable stagger bar for Brewmaster Monks
-- Version 1.8 (addon Sounds folder + custom scrollable dropdown)

local addonName = ...

-- Stagger spell IDs for icons
local STAGGER_LIGHT    = 124275
local STAGGER_MODERATE = 124274
local STAGGER_HEAVY    = 124273

-- Get icon textures
local function GetSpellIcon(spellId)
    if C_Spell and C_Spell.GetSpellTexture then
        local icon = C_Spell.GetSpellTexture(spellId)
        if icon then return icon end
    end
    return "Interface\\Icons\\monk_stance_drunkenox"
end

local iconLight    = GetSpellIcon(STAGGER_LIGHT)
local iconModerate = GetSpellIcon(STAGGER_MODERATE)
local iconHeavy    = GetSpellIcon(STAGGER_HEAVY)
local iconNone     = "Interface\\Icons\\monk_stance_drunkenox"

local function Clamp(n, minv, maxv)
    if n < minv then return minv end
    if n > maxv then return maxv end
    return n
end

-- ============================================================================
-- Addon Sounds (MANUAL LIST)
-- Folder: Interface\AddOns\MonkStaggerBarEnhanced\Sounds\
-- ============================================================================
local addonSounds = {
    -- Sound files in the Sounds folder
    { name = "Aggro", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Aggro.mp3" },
    { name = "Arrow Swoosh", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Arrow_Swoosh.mp3" },
    { name = "Bam", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Bam.mp3" },
    { name = "Bear Polar", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Bear Polar.mp3" },
    { name = "Big Kiss", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Big Kiss.mp3" },
    { name = "Bite", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Bite.mp3" },
    { name = "Bloodbath", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Bloodbath.mp3" },
    { name = "Burp", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Burp.mp3" },
    { name = "Cat", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Cat.mp3" },
    { name = "Chant1", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Chant1.mp3" },
    { name = "Chant2", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Chant2.mp3" },
    { name = "Chimes", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Chimes.mp3" },
    { name = "Cookie", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Cookie.mp3" },
    { name = "Espark", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Espark.mp3" },
    { name = "Fireball", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Fireball.mp3" },
    { name = "Gasp", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Gasp.mp3" },
    { name = "Health Low", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Health_Low.mp3" },
    { name = "Heartbeat", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Heartbeat.mp3" },
    { name = "Hic", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Hic.mp3" },
    { name = "Huh", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Huh.mp3" },
    { name = "Hurricane", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Hurricane.mp3" },
    { name = "Hyena", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Hyena.mp3" },
    { name = "Kaching", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Kaching.mp3" },
    { name = "Mana Low", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Mana_Low.mp3" },
    { name = "Moan", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Moan.mp3" },
    { name = "Panther", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Panther.mp3" },
    { name = "Phone", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Phone.mp3" },
    { name = "Punch", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Punch.mp3" },
    { name = "Rainroof", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Rainroof.mp3" },
    { name = "Rocket", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Rocket.mp3" },
    { name = "Ship Horn", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Ship_Horn.mp3" },
    { name = "Shot", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Shot.mp3" },
    { name = "Snake", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Snake.mp3" },
    { name = "Sneeze", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Sneeze.mp3" },
    { name = "Sonar", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Sonar.mp3" },
    { name = "Splash", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Splash.mp3" },
    { name = "Squeaky", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Squeaky.mp3" },
    { name = "Sword", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Sword.mp3" },
    { name = "Throw", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Throw.mp3" },
    { name = "Thunder", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Thunder.mp3" },
    { name = "Vengeance", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Vengeance.mp3" },
    { name = "Warpath", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Warpath.mp3" },
    { name = "Wicked Laugh Female", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Wicked_Laugh_Female.mp3" },
    { name = "Wicked Laugh Male", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Wicked_Laugh_Male.mp3" },
    { name = "Wilhelm", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Wilhelm.mp3" },
    { name = "Wolf", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Wolf.mp3" },
    { name = "Yeehaw", path = "Interface\\AddOns\\MonkStaggerBarEnhanced\\Sounds\\Yeehaw.mp3" },
}

local function GetSelectedAddonSound(db)
    local idx = tonumber(db.alertSoundIndex) or 1
    idx = Clamp(idx, 1, math.max(#addonSounds, 1))
    db.alertSoundIndex = idx
    return addonSounds[idx], idx
end

local function TryPlaySelectedSound()
    local db = MonkStaggerBarEnhancedDB
    if not db or #addonSounds == 0 then return end

    local s = GetSelectedAddonSound(db)
    if s and s.path then
        PlaySoundFile(s.path, "Master")
    end
end

-- Defaults
local defaults = {
    locked = false,
    width = 200,
    height = 24,
    fontSize = 12,
    posX = 0,
    posY = -200,
    texture = 1,
    hideOOC = false,
    hideZeroStagger = false,
    displayMode = 1, -- 1 = Bar Only, 2 = Icon Only, 3 = Icon + Bar
    iconSize = 32,

    -- Alert options
    alertEnabled = true,
    alertThreshold = 40, -- percent
    alertSoundIndex = 1,
}

-- Display mode names
local displayModeNames = {
    [1] = "Bar Only",
    [2] = "Icon Only",
    [3] = "Icon + Bar",
}

-- Texture options
local texturePaths = {
    [1] = "Interface\\TargetingFrame\\UI-StatusBar",
    [2] = "Interface\\Buttons\\WHITE8x8",
    [3] = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill",
}
local textureNames = {
    [1] = "Default",
    [2] = "Smooth",
    [3] = "Raid",
}

-- Stagger colors
local colorNone     = {0.3,  0.3,  0.3,  1}
local colorLight    = {0.52, 0.90, 0.52, 1}
local colorModerate = {1.0,  0.85, 0.36, 1}
local colorHeavy    = {1.0,  0.42, 0.42, 1}

-- State
local inCombat = false
local testMode = false

-- Sound alert anti-spam
local wasAboveAlert = false
local lastAlertTime = 0

-- ============================================================================
-- Main bar frame
-- ============================================================================
local frame = CreateFrame("Frame", "MonkStaggerBarEnhancedFrame", UIParent)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)

-- Icon frame
local iconFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
iconFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
})
iconFrame:SetBackdropColor(0, 0, 0, 0.8)
iconFrame:SetBackdropBorderColor(0, 0, 0, 1)

local icon = iconFrame:CreateTexture(nil, "ARTWORK")
icon:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", 2, -2)
icon:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", -2, 2)
icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

-- Bar frame
local barFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
barFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\Buttons\\WHITE8x8",
    edgeSize = 1,
})
barFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
barFrame:SetBackdropBorderColor(0, 0, 0, 1)

-- Status bar
local bar = CreateFrame("StatusBar", nil, barFrame)
bar:SetMinMaxValues(0, 1)
bar:SetValue(0)
bar:SetPoint("TOPLEFT", barFrame, "TOPLEFT", 2, -2)
bar:SetPoint("BOTTOMRIGHT", barFrame, "BOTTOMRIGHT", -2, 2)

-- Text
local text = bar:CreateFontString(nil, "OVERLAY")
text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
text:SetPoint("CENTER", bar, "CENTER", 0, 0)
text:SetTextColor(1, 1, 1, 1)
text:SetText("Stagger: 0")

-- Apply layout based on display mode
local function UpdateLayout()
    local db = MonkStaggerBarEnhancedDB
    if not db then return end

    local mode = db.displayMode or 1
    local iconSize = db.iconSize or 32
    local barWidth = db.width or 200
    local barHeight = db.height or 24

    iconFrame:SetSize(iconSize, iconSize)
    barFrame:SetSize(barWidth, barHeight)

    if mode == 1 then
        iconFrame:Hide()
        barFrame:Show()
        barFrame:ClearAllPoints()
        barFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
        frame:SetSize(barWidth, barHeight)
    elseif mode == 2 then
        iconFrame:Show()
        barFrame:Hide()
        iconFrame:ClearAllPoints()
        iconFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
        frame:SetSize(iconSize, iconSize)
    else
        iconFrame:Show()
        barFrame:Show()
        iconFrame:ClearAllPoints()
        barFrame:ClearAllPoints()
        iconFrame:SetPoint("LEFT", frame, "LEFT", 0, 0)
        barFrame:SetPoint("LEFT", iconFrame, "RIGHT", 4, 0)
        frame:SetSize(iconSize + 4 + barWidth, math.max(iconSize, barHeight))
    end
end

local function ApplySettings()
    local db = MonkStaggerBarEnhancedDB
    if not db then return end

    frame:ClearAllPoints()
    frame:SetPoint("CENTER", UIParent, "CENTER", db.posX, db.posY)

    local texIdx = db.texture or 1
    if texIdx < 1 or texIdx > 3 then texIdx = 1 end
    bar:SetStatusBarTexture(texturePaths[texIdx])

    local fontSize = db.fontSize or 12
    text:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")

    UpdateLayout()
end

-- Dragging
frame:SetScript("OnDragStart", function(self)
    if MonkStaggerBarEnhancedDB and not MonkStaggerBarEnhancedDB.locked then
        self:StartMoving()
    end
end)

frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    if MonkStaggerBarEnhancedDB then
        local _, _, _, x, y = self:GetPoint()
        MonkStaggerBarEnhancedDB.posX = math.floor(x + 0.5)
        MonkStaggerBarEnhancedDB.posY = math.floor(y + 0.5)
    end
end)

-- Helpers
local function FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    end
    return tostring(math.floor(num))
end

local function IsBrewmaster()
    local _, class = UnitClass("player")
    if class ~= "MONK" then return false end
    local spec = GetSpecialization()
    return spec == 1
end

-- Update bar
local function UpdateBar()
    if testMode then
        frame:Show()
        return
    end

    if not IsBrewmaster() then
        frame:Hide()
        return
    end

    local db = MonkStaggerBarEnhancedDB
    local stagger = UnitStagger("player") or 0
    local maxHP = UnitHealthMax("player") or 1
    local pct = stagger / maxHP

    if db.hideOOC and not inCombat then
        frame:Hide()
        return
    end

    if db.hideZeroStagger and stagger == 0 then
        frame:Hide()
        return
    end

    frame:Show()

    -- Alert sound logic (only once when crossing above threshold, only in combat)
    do
        local enabled = db.alertEnabled
        local thresholdPct = (tonumber(db.alertThreshold) or 40) / 100
        thresholdPct = Clamp(thresholdPct, 0, 1)

        local now = GetTime()
        local above = enabled and (stagger > 0) and (pct >= thresholdPct)

        if not inCombat then
            above = false
        end

        local cooldown = 2.0
        if above and (not wasAboveAlert) and (now - lastAlertTime >= cooldown) then
            TryPlaySelectedSound()
            lastAlertTime = now
        end

        wasAboveAlert = above
    end

    bar:SetValue(math.min(pct, 1))

    local color = colorNone
    local currentIcon = iconNone

    if pct >= 0.6 then
        color = colorHeavy
        currentIcon = iconHeavy
    elseif pct >= 0.3 then
        color = colorModerate
        currentIcon = iconModerate
    elseif pct > 0 then
        color = colorLight
        currentIcon = iconLight
    end

    bar:SetStatusBarColor(color[1], color[2], color[3], color[4])
    icon:SetTexture(currentIcon)
    iconFrame:SetBackdropBorderColor(color[1], color[2], color[3], 1)

    text:SetText(string.format("Stagger: %s (%.0f%%)", FormatNumber(stagger), pct * 100))
end

-- ============================================================================
-- UI Helpers
-- ============================================================================
local function CreateButton(parent, label, x, y, w, h, onClick)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(w, h)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    btn:SetText(label)
    btn:SetScript("OnClick", onClick)
    return btn
end

local function CreateEditBox(parent, x, y, w, h)
    local eb = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    eb:SetSize(w, h)
    eb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    eb:SetAutoFocus(false)
    return eb
end

local function CreateLabel(parent, txt, x, y)
    local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    fs:SetText(txt)
    return fs
end

local function CreateCheckbox(parent, label, x, y, onClick)
    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    local cbLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    cbLabel:SetPoint("LEFT", cb, "RIGHT", 4, 0)
    cbLabel:SetText(label)
    cb:SetScript("OnClick", onClick)
    return cb
end

-- ============================================================================
-- Custom Scroll Dropdown (replaces UIDropDownMenu)
-- ============================================================================
local dropdownCatcher = nil

local function EnsureDropdownCatcher()
    if dropdownCatcher then return end
    dropdownCatcher = CreateFrame("Frame", nil, UIParent)
    dropdownCatcher:SetAllPoints(UIParent)
    dropdownCatcher:EnableMouse(true)
    dropdownCatcher:SetFrameStrata("DIALOG")
    dropdownCatcher:Hide()
end

-- Creates a dropdown that can scroll (hard maxVisible rows)
-- items: array { {name=..., path=...}, ... }
-- getIndex(): returns selectedIndex
-- setIndex(i): sets selectedIndex
local function CreateScrollDropdown(parent, x, y, width, maxVisible, items, getIndex, setIndex)
    EnsureDropdownCatcher()

    local dd = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    dd:SetSize(width, 22)
    dd:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)

    dd:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 10,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    dd:SetBackdropColor(0.08, 0.08, 0.08, 0.95)
    dd:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)

    local textFS = dd:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    textFS:SetPoint("LEFT", dd, "LEFT", 6, 0)
    textFS:SetPoint("RIGHT", dd, "RIGHT", -22, 0)
    textFS:SetJustifyH("LEFT")
    textFS:SetText("")

    local arrow = CreateFrame("Button", nil, dd, "UIPanelButtonTemplate")
    arrow:SetSize(18, 18)
    arrow:SetPoint("RIGHT", dd, "RIGHT", -2, 0)
    arrow:SetText("v")

    -- Popup
    local popup = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    popup:SetFrameStrata("FULLSCREEN_DIALOG")
    popup:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 },
    })
    popup:SetBackdropColor(0.05, 0.05, 0.05, 0.98)
    popup:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
    popup:EnableMouse(true)
    popup:Hide()

    -- Hard max height
    local rowH = 18
    local visible = Clamp(maxVisible or 10, 4, 25)
    local maxH = (visible * rowH) + 6
    popup:SetSize(width, maxH)

    -- ScrollFrame
    local scroll = CreateFrame("ScrollFrame", nil, popup, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", popup, "TOPLEFT", 4, -4)
    scroll:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -24, 4)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(width - 30, 1)
    scroll:SetScrollChild(content)

    -- Create buttons
    local buttons = {}

    local function UpdateText()
        local idx = getIndex()
        idx = Clamp(idx or 1, 1, math.max(#items, 1))
        local item = items[idx]
        textFS:SetText(item and item.name or "None")
    end

    local function ClosePopup()
        popup:Hide()
        dropdownCatcher:Hide()
    end

    local function OpenPopup()
        if popup:IsShown() then
            ClosePopup()
            return
        end

        -- Position under the dropdown
        popup:ClearAllPoints()
        popup:SetPoint("TOPLEFT", dd, "BOTTOMLEFT", 0, -2)

        -- Catch outside clicks
        dropdownCatcher:Show()
        dropdownCatcher:SetScript("OnMouseDown", function()
            ClosePopup()
        end)

        popup:Show()
    end

    local function RefreshButtons()
        -- Height based on item count
        content:SetHeight(#items * rowH)

        for i = 1, #items do
            if not buttons[i] then
                local b = CreateFrame("Button", nil, content, "BackdropTemplate")
                b:SetHeight(rowH)
                b:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -((i - 1) * rowH))
                b:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -((i - 1) * rowH))
                b:EnableMouse(true)

                b:SetBackdrop({
                    bgFile = "Interface\\Buttons\\WHITE8x8",
                })
                b:SetBackdropColor(0, 0, 0, 0)

                local dot = b:CreateTexture(nil, "OVERLAY")
                dot:SetSize(10, 10)
                dot:SetPoint("LEFT", b, "LEFT", 6, 0)
                dot:SetTexture("Interface\\Buttons\\UI-RadioButton")
                dot:SetTexCoord(0, 0.25, 0, 0.25)

                local label = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                label:SetPoint("LEFT", b, "LEFT", 20, 0)
                label:SetJustifyH("LEFT")

                b._dot = dot
                b._label = label

                b:SetScript("OnEnter", function(self)
                    self:SetBackdropColor(1, 1, 1, 0.06)
                end)
                b:SetScript("OnLeave", function(self)
                    self:SetBackdropColor(0, 0, 0, 0)
                end)

                b:SetScript("OnClick", function()
                    setIndex(i)
                    UpdateText()

                    -- update radio dots
                    for j = 1, #items do
                        if buttons[j] then
                            local on = (j == getIndex())
                            if on then
                                buttons[j]._dot:SetTexCoord(0.25, 0.5, 0, 0.25) -- selected
                            else
                                buttons[j]._dot:SetTexCoord(0, 0.25, 0, 0.25) -- unselected
                            end
                        end
                    end

                    ClosePopup()
                end)

                buttons[i] = b
            end

            local b = buttons[i]
            b._label:SetText(items[i].name)

            local on = (i == getIndex())
            if on then
                b._dot:SetTexCoord(0.25, 0.5, 0, 0.25)
            else
                b._dot:SetTexCoord(0, 0.25, 0, 0.25)
            end

            b:Show()
        end

        -- Hide any extra buttons if list shrank
        for i = #items + 1, #buttons do
            if buttons[i] then buttons[i]:Hide() end
        end
    end

    -- Mouse wheel scrolling
    popup:EnableMouseWheel(true)
    popup:SetScript("OnMouseWheel", function(_, delta)
        local cur = scroll:GetVerticalScroll()
        local step = rowH * 2
        local maxScroll = math.max(0, content:GetHeight() - (maxH - 10))
        local next = Clamp(cur - (delta * step), 0, maxScroll)
        scroll:SetVerticalScroll(next)
    end)

    dd:EnableMouse(true)
    dd:SetScript("OnMouseDown", OpenPopup)
    arrow:SetScript("OnClick", OpenPopup)

    dd.Update = function()
        UpdateText()
        RefreshButtons()
    end

    dd.Close = ClosePopup

    -- ESC close support
    table.insert(UISpecialFrames, popup:GetName() or "")

    -- If popup has no name, we still close via catcher click / selecting item.
    -- (UISpecialFrames requires a global name; optional.)

    -- Initialize
    dd.Update()

    return dd
end

-- ============================================================================
-- Options UI
-- ============================================================================
local optionsFrame = nil

local function CreateOptions()
    if optionsFrame then return optionsFrame end

    local opt = CreateFrame("Frame", "MonkStaggerBarEnhancedOptionsFrame", UIParent, "BackdropTemplate")
    opt:SetSize(300, 560)
    opt:SetPoint("CENTER")
    opt:SetMovable(true)
    opt:EnableMouse(true)
    opt:RegisterForDrag("LeftButton")
    opt:SetClampedToScreen(true)
    opt:SetFrameStrata("DIALOG")
    opt:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4},
    })
    opt:SetBackdropColor(0.1, 0.1, 0.1, 0.95)
    opt:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    opt:Hide()

    opt:SetScript("OnDragStart", opt.StartMoving)
    opt:SetScript("OnDragStop", opt.StopMovingOrSizing)

    local title = opt:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -10)
    title:SetText("Monk Stagger Bar")

    local closeBtn = CreateFrame("Button", nil, opt, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -2, -2)

    local y = -40

    -- Display Mode
    CreateLabel(opt, "Display:", 15, y)
    local modeLabel = opt:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    modeLabel:SetPoint("TOPLEFT", 80, y)
    modeLabel:SetWidth(120)
    CreateButton(opt, "<", 200, y, 25, 22, function()
        local newMode = MonkStaggerBarEnhancedDB.displayMode - 1
        if newMode < 1 then newMode = 3 end
        MonkStaggerBarEnhancedDB.displayMode = newMode
        modeLabel:SetText(displayModeNames[newMode])
        ApplySettings()
    end)
    CreateButton(opt, ">", 228, y, 25, 22, function()
        local newMode = MonkStaggerBarEnhancedDB.displayMode + 1
        if newMode > 3 then newMode = 1 end
        MonkStaggerBarEnhancedDB.displayMode = newMode
        modeLabel:SetText(displayModeNames[newMode])
        ApplySettings()
    end)
    y = y - 30

    -- Icon Size
    CreateLabel(opt, "Icon Size:", 15, y)
    local iconSizeBox = CreateEditBox(opt, 80, y, 60, 20)
    CreateButton(opt, "Set", 150, y, 50, 22, function()
        local val = tonumber(iconSizeBox:GetText())
        if val and val >= 16 and val <= 128 then
            MonkStaggerBarEnhancedDB.iconSize = val
            ApplySettings()
        end
    end)
    y = y - 30

    -- Width
    CreateLabel(opt, "Bar Width:", 15, y)
    local widthBox = CreateEditBox(opt, 80, y, 60, 20)
    CreateButton(opt, "Set", 150, y, 50, 22, function()
        local val = tonumber(widthBox:GetText())
        if val and val >= 50 and val <= 500 then
            MonkStaggerBarEnhancedDB.width = val
            ApplySettings()
        end
    end)
    y = y - 30

    -- Height
    CreateLabel(opt, "Bar Height:", 15, y)
    local heightBox = CreateEditBox(opt, 80, y, 60, 20)
    CreateButton(opt, "Set", 150, y, 50, 22, function()
        local val = tonumber(heightBox:GetText())
        if val and val >= 10 and val <= 100 then
            MonkStaggerBarEnhancedDB.height = val
            ApplySettings()
        end
    end)
    y = y - 30

    -- Font Size
    CreateLabel(opt, "Font Size:", 15, y)
    local fontSizeBox = CreateEditBox(opt, 80, y, 60, 20)
    CreateButton(opt, "Set", 150, y, 50, 22, function()
        local val = tonumber(fontSizeBox:GetText())
        if val and val >= 6 and val <= 30 then
            MonkStaggerBarEnhancedDB.fontSize = val
            ApplySettings()
        end
    end)
    y = y - 30

    -- Position X
    CreateLabel(opt, "Pos X:", 15, y)
    local posXBox = CreateEditBox(opt, 80, y, 60, 20)
    CreateButton(opt, "Set", 150, y, 40, 22, function()
        local val = tonumber(posXBox:GetText())
        if val then
            MonkStaggerBarEnhancedDB.posX = val
            ApplySettings()
        end
    end)
    y = y - 30

    -- Position Y
    CreateLabel(opt, "Pos Y:", 15, y)
    local posYBox = CreateEditBox(opt, 80, y, 60, 20)
    CreateButton(opt, "Set", 150, y, 40, 22, function()
        local val = tonumber(posYBox:GetText())
        if val then
            MonkStaggerBarEnhancedDB.posY = val
            ApplySettings()
        end
    end)
    y = y - 35

    -- Texture selector
    CreateLabel(opt, "Texture:", 15, y)
    local texLabel = opt:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    texLabel:SetPoint("TOPLEFT", 80, y)
    texLabel:SetWidth(100)
    CreateButton(opt, "<", 190, y, 25, 22, function()
        local newTex = MonkStaggerBarEnhancedDB.texture - 1
        if newTex < 1 then newTex = 3 end
        MonkStaggerBarEnhancedDB.texture = newTex
        texLabel:SetText(textureNames[newTex])
        ApplySettings()
    end)
    CreateButton(opt, ">", 220, y, 25, 22, function()
        local newTex = MonkStaggerBarEnhancedDB.texture + 1
        if newTex > 3 then newTex = 1 end
        MonkStaggerBarEnhancedDB.texture = newTex
        texLabel:SetText(textureNames[newTex])
        ApplySettings()
    end)
    y = y - 35

    -- Lock checkbox
    local lockCheck = CreateCheckbox(opt, "Lock Bar Position", 12, y, function(self)
        MonkStaggerBarEnhancedDB.locked = self:GetChecked()
    end)
    y = y - 30

    -- Hide out of combat
    local hideOOCCheck = CreateCheckbox(opt, "Hide Out of Combat", 12, y, function(self)
        MonkStaggerBarEnhancedDB.hideOOC = self:GetChecked()
        UpdateBar()
    end)
    y = y - 30

    -- Hide when stagger is 0
    local hideZeroCheck = CreateCheckbox(opt, "Hide When Stagger is 0", 12, y, function(self)
        MonkStaggerBarEnhancedDB.hideZeroStagger = self:GetChecked()
        UpdateBar()
    end)
    y = y - 35

    -- Alert header
    CreateLabel(opt, "Alert:", 15, y)
    y = y - 22

    -- Enable alert
    local alertEnableCheck = CreateCheckbox(opt, "Enable alert sound", 12, y, function(self)
        MonkStaggerBarEnhancedDB.alertEnabled = self:GetChecked()
    end)
    y = y - 30

    -- Threshold %
    CreateLabel(opt, "Threshold %:", 15, y)
    local thresholdBox = CreateEditBox(opt, 105, y, 50, 20)
    CreateButton(opt, "Set", 160, y, 45, 22, function()
        local val = tonumber(thresholdBox:GetText())
        if val then
            val = Clamp(val, 0, 100)
            MonkStaggerBarEnhancedDB.alertThreshold = val
            thresholdBox:SetText(tostring(val))
        end
    end)
    y = y - 34

    -- Sound (custom scroll dropdown)
    CreateLabel(opt, "Sound:", 15, y)

    local soundDropdown = CreateScrollDropdown(
        opt,
        65, y - 2,
        170,
        12,                 -- max visible rows before scroll
        addonSounds,
        function() return Clamp(MonkStaggerBarEnhancedDB.alertSoundIndex or 1, 1, math.max(#addonSounds, 1)) end,
        function(i) MonkStaggerBarEnhancedDB.alertSoundIndex = i end
    )

    local playSoundBtn = CreateButton(opt, "Play", 0, 0, 45, 22, function()
        TryPlaySelectedSound()
    end)
    playSoundBtn:ClearAllPoints()
    playSoundBtn:SetPoint("LEFT", soundDropdown, "RIGHT", 6, 0)

    -- Bottom buttons anchored
    local resetBtn = CreateButton(opt, "Reset All", 0, 0, 80, 25, function()
        for k, v in pairs(defaults) do
            MonkStaggerBarEnhancedDB[k] = v
        end
        ApplySettings()
        UpdateBar()
        opt:Hide()
        opt:Show()
    end)

    local testBtn = CreateButton(opt, "Test Mode", 0, 0, 80, 25, function()
        testMode = not testMode
        if testMode then
            frame:Show()
            bar:SetValue(0.5)
            bar:SetStatusBarColor(colorModerate[1], colorModerate[2], colorModerate[3], 1)
            icon:SetTexture(iconModerate)
            iconFrame:SetBackdropBorderColor(colorModerate[1], colorModerate[2], colorModerate[3], 1)
            text:SetText("TEST MODE")
            print("|cff00ff00MonkStaggerBarEnhanced:|r Test mode ON")
        else
            print("|cff00ff00MonkStaggerBarEnhanced:|r Test mode OFF")
            UpdateBar()
        end
    end)

    resetBtn:ClearAllPoints()
    resetBtn:SetPoint("BOTTOMLEFT", opt, "BOTTOMLEFT", 15, 15)

    testBtn:ClearAllPoints()
    testBtn:SetPoint("LEFT", resetBtn, "RIGHT", 10, 0)

    -- Refresh UI
    opt:SetScript("OnShow", function()
        local db = MonkStaggerBarEnhancedDB

        iconSizeBox:SetText(tostring(db.iconSize))
        widthBox:SetText(tostring(db.width))
        heightBox:SetText(tostring(db.height))
        fontSizeBox:SetText(tostring(db.fontSize))
        posXBox:SetText(tostring(db.posX))
        posYBox:SetText(tostring(db.posY))

        local mode = db.displayMode or 1
        modeLabel:SetText(displayModeNames[mode])

        local tIdx = db.texture or 1
        if tIdx < 1 or tIdx > 3 then tIdx = 1 end
        texLabel:SetText(textureNames[tIdx])

        lockCheck:SetChecked(db.locked)
        hideOOCCheck:SetChecked(db.hideOOC)
        hideZeroCheck:SetChecked(db.hideZeroStagger)

        alertEnableCheck:SetChecked(db.alertEnabled)
        thresholdBox:SetText(tostring(db.alertThreshold or 40))

        -- Update dropdown selection text + radios
        soundDropdown:Update()
    end)

    optionsFrame = opt
    return opt
end

-- ============================================================================
-- Events
-- ============================================================================
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
frame:RegisterEvent("UNIT_HEALTH")
frame:RegisterEvent("UNIT_MAXHEALTH")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        MonkStaggerBarEnhancedDB = MonkStaggerBarEnhancedDB or {}
        for k, v in pairs(defaults) do
            if MonkStaggerBarEnhancedDB[k] == nil then
                MonkStaggerBarEnhancedDB[k] = v
            end
        end

        if #addonSounds > 0 then
            MonkStaggerBarEnhancedDB.alertSoundIndex = Clamp(tonumber(MonkStaggerBarEnhancedDB.alertSoundIndex) or 1, 1, #addonSounds)
        else
            MonkStaggerBarEnhancedDB.alertSoundIndex = 1
        end

        iconLight    = GetSpellIcon(STAGGER_LIGHT)
        iconModerate = GetSpellIcon(STAGGER_MODERATE)
        iconHeavy    = GetSpellIcon(STAGGER_HEAVY)

        ApplySettings()

    elseif event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
        UpdateBar()

    elseif (event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH") and arg1 == "player" then
        UpdateBar()

    elseif event == "PLAYER_REGEN_DISABLED" then
        inCombat = true
        UpdateBar()

    elseif event == "PLAYER_REGEN_ENABLED" then
        inCombat = false
        UpdateBar()
    end
end)

-- OnUpdate
local elapsed = 0
frame:SetScript("OnUpdate", function(self, delta)
    elapsed = elapsed + delta
    if elapsed >= 0.05 then
        elapsed = 0
        if self:IsShown() or not testMode then
            UpdateBar()
        end
    end
end)

-- ============================================================================
-- Slash command
-- ============================================================================
SLASH_MONKSTAGGERBAR1 = "/msb"
SLASH_MONKSTAGGERBAR2 = "/staggerbar"

SlashCmdList["MONKSTAGGERBAR"] = function(msg)
    local cmd = (msg or ""):lower():match("^%s*(%S*)") or ""

    if cmd == "" then
        local opt = CreateOptions()
        if opt:IsShown() then opt:Hide() else opt:Show() end

    elseif cmd == "sound" then
        TryPlaySelectedSound()

    else
        print("|cff00ff00MonkStaggerBarEnhanced:|r /msb to open options (or /msb sound to test)")
    end
end

print("|cff00ff00MonkStaggerBarEnhanced v1.8|r loaded - /msb for options")
