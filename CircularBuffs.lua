CircularBuffs = CircularBuffs or {}
CircularBuffs.variableVersion = 1
local savedVars
CircularBuffs.defaults =
{
    xPosition = 1150,
    yPosition = 1040,
	buffIDs = {},
	debuffIDs = {},
}

-------------------------------------------------------------------------------------------------
--  Initialize Variables --
-------------------------------------------------------------------------------------------------
CircularBuffs.name = "CircularBuffs" 
CircularBuffs.colors = {
        white = {1, 1, 1},
        black = {0, 0, 0},
        gray = {0.5, 0.5, 0.5},
        red = {1, 0, 0},
        green = {0, 1, 0},
        yellow = {1, 1, 0},
        blue = {0, 0, 1},
        teal = {0, 1, 1},
        orange = {1, 0.5, 0},
        purple = {0.5, 0, 1},
        pink = {1, 0, 1},
        lightPink = {1, 0.5, 1},
        lightPurple = {0.75, 0.5, 1},
        lightYellow = {1, 1, 0.5},
        lightBlue = {0.5, 0.5, 1},
        lightRed = {1, 0.5, 0.5},
        lightGreen = {0.5, 1, 0.5},
        lightGray = {0.75, 0.75, 0.75},
        darkPink = {0.5, 0, 0.5},
        darkPurple = {0, 0, 0.5},
        darkYellow = {0.5, 0.5, 0},
        darkBlue = {0, 0, 0.5},
        darkRed = {0.5, 0, 0},
        darkGreen = {0, 0.5, 0},
        darkGray = {0.25, 0.25, 0.25},
        lightGray = {0.75, 0.75, 0.75},
        transparentWhite = {1, 1, 1, 0.8},
        transparentWhite2 = {1, 1, 1, 0.6},
        transparentBlack = {0, 0, 0, 0.8},
        transparentBlack2 = {0, 0, 0, 0.6},
        transparent = {0,0,0,0},
    }

--CircularBuffs.buffIDs = {61746,31816}
--CircularBuffs.debuffIDs = {31102,44369}

local SM = SCENE_MANAGER
--local xPosition = 1150
--local yPosition = 1040

-------------------------------------------------------------------------------------------------
--  OnAddOnLoaded  --
-------------------------------------------------------------------------------------------------
function CircularBuffs.OnAddOnLoaded(event, addonName)
	if addonName ~= CircularBuffs.name then return end
	CircularBuffs:Initialize()
	EVENT_MANAGER:UnregisterForEvent(CircularBuffs.name, EVENT_ADD_ON_LOADED)

end

-------------------------------------------------------------------------------------------------
--  Initialize Function --
-------------------------------------------------------------------------------------------------
function CircularBuffs:Initialize()
	CircularBuffs.savedVars = ZO_SavedVars:NewAccountWide("CircularBuffsVariables", CircularBuffs.variableVersion, nil, CircularBuffs.defaults)
	CircularBuffs.BuffsUI()
	EVENT_MANAGER:RegisterForUpdate(CircularBuffs.name.."EffectsUpdate", 50, CircularBuffs.EffectsUpdate)
end


function CircularBuffs.BuffsUI()
	local WM = GetWindowManager()
    local EffectsContainer = WM:CreateTopLevelWindow("EffectsContainer")

    EffectsContainer:SetResizeToFitDescendents(true)
    EffectsContainer:SetMovable(false)
    EffectsContainer:SetMouseEnabled(true)
    --EffectsContainer:SetClampedToScreen(true)
    EffectsContainer:SetHandler("OnMoveStop", function()
        CircularBuffs.savedVars.xPosition = math.floor(EffectsContainer:GetLeft())
        CircularBuffs.savedVars.yPosition = math.floor(EffectsContainer:GetTop())	
    end)
    EffectsContainer:SetHidden(false)
    EffectsContainer:SetDrawTier(DT_HIGH)

    for i = 1, 10 do
			local buffBackground = WM:CreateControl("$(parent)buffBackground" .. i, EffectsContainer, CT_TEXTURE, 4)
            buffBackground:SetDimensions(52, 52)
            buffBackground:SetAnchor(TOPLEFT, EffectsContainer, TOPLEFT, 52 * (i - 1), 0)
            buffBackground:SetHidden(false)
            buffBackground:SetDrawLayer(0)
			buffBackground:SetTexture("CircularBuffs/glow_green.dds")


            local buffsIcon = WM:CreateControl("$(parent)buffsIcon" .. i, buffBackground, CT_TEXTURE, 4)
            buffsIcon:SetDimensions(48, 48)
            buffsIcon:SetAnchor(CENTER, buffBackground, CENTER, 0, 0)
            buffsIcon:SetHidden(false)
            buffsIcon:SetDrawLayer(1)
			buffsIcon:SetMaskMode(CONTROL_MASK_MODE_BASIC)
			buffsIcon:SetMaskTexture("CircularBuffs/mask.dds") 

            local buffsLabel = WM:CreateControl("$(parent)buffsLabel" .. i, buffsIcon, CT_LABEL)
            buffsLabel:SetFont("CircularBuffs/genericaBold.otf" .. "|" .. 24 .. "|" .. "outline")
            buffsLabel:SetDrawLayer(2)
            buffsLabel:SetAnchor(CENTER, buffsIcon, CENTER, 0, 0)
            buffsLabel:SetDimensions(48, 48)
            buffsLabel:SetHidden(false)
            buffsLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
            buffsLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)

            local buffsStackLabel = WM:CreateControl("$(parent)buffsStackLabel" .. i, buffBackground, CT_LABEL)
            buffsStackLabel:SetFont("CircularBuffs/genericaBold.otf" .. "|" .. 20 .. "|" .. "outline")
            buffsStackLabel:SetDrawLayer(2)
            buffsStackLabel:SetAnchor(CENTER, buffsIcon, CENTER, 18, 18)
            buffsStackLabel:SetDimensions(48, 48)
            buffsStackLabel:SetHidden(false)
            buffsStackLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
            buffsStackLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
        
    end

	for i = 1, 10 do
			local debuffBackground = WM:CreateControl("$(parent)debuffBackground" .. i, EffectsContainer, CT_TEXTURE, 4)
            debuffBackground:SetDimensions(52, 52)
            debuffBackground:SetAnchor(TOPLEFT, EffectsContainer, TOPLEFT, - 52 - 52 * (i - 1), 0)
            debuffBackground:SetHidden(false)
            debuffBackground:SetDrawLayer(0)
			debuffBackground:SetTexture("CircularBuffs/glow_red.dds")


            local debuffsIcon = WM:CreateControl("$(parent)debuffsIcon" .. i, debuffBackground, CT_TEXTURE, 4)
            debuffsIcon:SetDimensions(48, 48)
            debuffsIcon:SetAnchor(CENTER, debuffBackground, CENTER, 0, 0)
            debuffsIcon:SetHidden(false)
            debuffsIcon:SetDrawLayer(1)
			debuffsIcon:SetMaskMode(CONTROL_MASK_MODE_BASIC)
			debuffsIcon:SetMaskTexture("CircularBuffs/mask.dds") 

            local debuffsLabel = WM:CreateControl("$(parent)debuffsLabel" .. i, debuffsIcon, CT_LABEL)
            debuffsLabel:SetFont("CircularBuffs/genericaBold.otf" .. "|" .. 24 .. "|" .. "outline")
            debuffsLabel:SetDrawLayer(2)
            debuffsLabel:SetAnchor(CENTER, debuffsIcon, CENTER, 0, 0)
            debuffsLabel:SetDimensions(48, 48)
            debuffsLabel:SetHidden(false)
            debuffsLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
            debuffsLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)

            local debuffsStackLabel = WM:CreateControl("$(parent)debuffsStackLabel" .. i, debuffBackground, CT_LABEL)
            debuffsStackLabel:SetFont("CircularBuffs/genericaBold.otf" .. "|" .. 20 .. "|" .. "outline")
            debuffsStackLabel:SetDrawLayer(2)
            debuffsStackLabel:SetAnchor(CENTER, debuffsIcon, CENTER, 18, 18)
            debuffsStackLabel:SetDimensions(48, 48)
            debuffsStackLabel:SetHidden(false)
            debuffsStackLabel:SetHorizontalAlignment(TEXT_ALIGN_CENTER)
            debuffsStackLabel:SetVerticalAlignment(TEXT_ALIGN_CENTER)
        
    end

    EffectsContainer:ClearAnchors()
    EffectsContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT,CircularBuffs.savedVars.xPosition, CircularBuffs.savedVars.yPosition)
    local function onSceneChange(_, scene)
            if scene == SCENE_SHOWN then
                EffectsContainer:SetHidden(false)
            else
                EffectsContainer:SetHidden(true)
            end
    end
    SCENE_MANAGER:GetScene("hud"):RegisterCallback("StateChange", onSceneChange)
    SCENE_MANAGER:GetScene("hudui"):RegisterCallback("StateChange", onSceneChange)		
end 


function CircularBuffs.EffectsUpdate()
    local now = GetGameTimeSeconds()
    local effectTable = {}
	local amountOfBuffsFilteredOut = 0
	local amountOfDebuffsFilteredOut = 0
		
	for i = 1, GetNumBuffs('player') do
		local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo('player', i)
        effectTable[i] = {
            effectName = buffName,
            timeStarted = timeStarted,
            timeEnding = timeEnding,
            iconFilename = iconFilename,
            stackCount = stackCount,
            castByPlayer = castByPlayer,
            timer = timeEnding - now,
            abilityId = abilityId,
			buffType = buffType,
			effectType = effectType, -- 1 = buff , 2 debuff
        }
    end
	
	local buffTable = {}

    for _, effect in pairs(effectTable) do
		local permanent = IsAbilityPermanent(effect.abilityId)
        if effect.effectType==1 and not permanent and effect.timer>=0 and inArray(CircularBuffs.savedVars.buffIDs,effect.abilityId) then
            table.insert(buffTable, effect)
            amountOfBuffsFilteredOut = amountOfBuffsFilteredOut + 1
        end
    end
	
	table.sort(buffTable, function(x, y)
        return (x and x.timer > y.timer)
    end)
	
	local debuffTable = {}

    for _, effect in pairs(effectTable) do
		local permanent = IsAbilityPermanent(effect.abilityId)
        if effect.effectType==2 and not permanent and effect.timer>=0 and inArray(CircularBuffs.savedVars.debuffIDs,effect.abilityId) then
            table.insert(debuffTable, effect)
            amountOfDebuffsFilteredOut = amountOfDebuffsFilteredOut + 1
        end
    end
	
	table.sort(debuffTable, function(x, y)
        return (x and x.timer > y.timer)
    end)
	
	for i = 1, math.min(amountOfBuffsFilteredOut, 10) do
        local buffBackground = EffectsContainer:GetNamedChild('buffBackground' .. i)
		local buffsIcon = buffBackground:GetNamedChild('buffsIcon' .. i)
        local buffsLabel = buffsIcon:GetNamedChild('buffsLabel' .. i)
        local buffsStackLabel = buffBackground:GetNamedChild('buffsStackLabel' .. i)

        buffsIcon:SetTexture(buffTable[i].iconFilename)

        local remainingTime = buffTable[i].timeEnding - now
        local timerText = math.floor(remainingTime)
        if remainingTime <= 0 then
            timerText = '0.0'
        elseif remainingTime <= 3 then
            timerText = processTimer(remainingTime)
        end

        buffsLabel:SetText(timerText)
        if buffTable[i].stackCount > 0 then
            buffsStackLabel:SetText(buffTable[i].stackCount)
        else
            buffsStackLabel:SetText('')
        end
		
		--buffBackground:SetHidden(false)
		buffBackground:SetAlpha(1)
		
    end
	
	for i = math.min(amountOfBuffsFilteredOut, 10)+1 , 10 do 
			local buffBackground = EffectsContainer:GetNamedChild('buffBackground' .. i)
			--buffBackground:SetHidden(true)
			buffBackground:SetAlpha(0)
	end
	
	for i = 1, math.min(amountOfDebuffsFilteredOut, 10) do
        local debuffBackground = EffectsContainer:GetNamedChild('debuffBackground' .. i)
		local debuffsIcon = debuffBackground:GetNamedChild('debuffsIcon' .. i)
        local debuffsLabel = debuffsIcon:GetNamedChild('debuffsLabel' .. i)
        local debuffsStackLabel = debuffBackground:GetNamedChild('debuffsStackLabel' .. i)

        debuffsIcon:SetTexture(debuffTable[i].iconFilename)

        local remainingTime = debuffTable[i].timeEnding - now
        local timerText = math.floor(remainingTime)
        if remainingTime <= 0 then
            timerText = '0.0'
        elseif remainingTime <= 3 then
            timerText = processTimer(remainingTime)
        end

        debuffsLabel:SetText(timerText)
        if debuffTable[i].stackCount > 0 then
            debuffsStackLabel:SetText(debuffTable[i].stackCount)
        else
           debuffsStackLabel:SetText('')
        end

		debuffBackground:SetHidden(false)
		debuffBackground:SetAlpha(1)
		
    end
	
	for i = math.min(amountOfDebuffsFilteredOut, 10)+1 , 10 do 
			local debuffBackground = EffectsContainer:GetNamedChild('debuffBackground' .. i)
			--debuffBackground:SetHidden(true)
			debuffBackground:SetAlpha(0)
	end
end

function processTimer(time)
    time = math.floor((time) * 10) / 10
    if time%1 == 0 then
        return time..".0"
    end
    return time
end

function inArray (array, val)
    for _, value in ipairs(array) do
        if value == val then
            return true
        end
    end
    return false
end

local showL = false
local function Move()
	if showL then 
		EVENT_MANAGER:RegisterForUpdate(CircularBuffs.name.."EffectsUpdate", 50, CircularBuffs.EffectsUpdate)
		for i = 1, 10 do
			local buffBackground = EffectsContainer:GetNamedChild('buffBackground' .. i)
			local debuffBackground = EffectsContainer:GetNamedChild('debuffBackground' .. i)
			--buffBackground:SetHidden(false)
			buffBackground:SetAlpha(0)
			debuffBackground:SetAlpha(0)
		end
	end
	if not showL then 
		EVENT_MANAGER:UnregisterForUpdate(CircularBuffs.name.."EffectsUpdate", 50, CircularBuffs.EffectsUpdate)
		for i = 1, 10 do
			local buffBackground = EffectsContainer:GetNamedChild('buffBackground' .. i)
			local debuffBackground = EffectsContainer:GetNamedChild('debuffBackground' .. i)
			EffectsContainer:SetMovable(true)
			--buffBackground:SetHidden(false)
			buffBackground:SetAlpha(1)
			debuffBackground:SetAlpha(1)
		end
	end
	showL = not showL
end

local function ShowIDs()
	local now = GetGameTimeSeconds()
    local effectTable = {}
		
	for i = 1, GetNumBuffs('player') do
		local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, canClickOff, castByPlayer = GetUnitBuffInfo('player', i)
        effectTable[i] = {
            effectName = buffName,
            timeStarted = timeStarted,
            timeEnding = timeEnding,
            iconFilename = iconFilename,
            stackCount = stackCount,
            castByPlayer = castByPlayer,
            timer = timeEnding - now,
            abilityId = abilityId,
			buffType = buffType,
			effectType = effectType, -- 1 = buff , 2 debuff
        }
		d(effectTable[i].effectName.." - ".. effectTable[i].abilityId)
    end
end

local function addBuff(id)
	local tempBuffs = CircularBuffs.savedVars.buffIDs
	if not inArray(tempBuffs, tonumber(id)) then
		table.insert(tempBuffs,tonumber(id))
	end
	
	d("Adding " .. GetAbilityName(id))
	d("Current bufflist:")
	for k, value in ipairs(tempBuffs) do 
		local name = GetAbilityName(value)
		d(k .. ": " .. value .. " - " .. name)
	end
	
	CircularBuffs.savedVars.buffIDs = tempBuffs
end

local function removeBuff(id)
	local tempBuffs = CircularBuffs.savedVars.buffIDs
	for k, value in ipairs(tempBuffs) do
		if value == tonumber(id) then
			table.remove(tempBuffs,k)
		end
	end
	
	d("Removing " .. GetAbilityName(id))
	d("Current bufflist:")
	for k, value in ipairs(tempBuffs) do 
		local name = GetAbilityName(value)
		d(k .. ": " .. value .. " - " .. name)
	end
	
	CircularBuffs.savedVars.buffIDs = tempBuffs
end

local function addDebuff(id)
	local tempDebuffs = CircularBuffs.savedVars.debuffIDs
	if not inArray(tempDebuffs, tonumber(id)) then
		table.insert(tempDebuffs,tonumber(id))
	end
	
	d("Adding " .. GetAbilityName(id))
	d("Current debufflist:")
	for k, value in ipairs(tempDebuffs) do 
		local name = GetAbilityName(value)
		d(k .. ": " .. value .. " - " .. name)
	end
	
	CircularBuffs.savedVars.debuffIDs = tempDebuffs
end

local function removeDebuff(id)
	local tempDebuffs = CircularBuffs.savedVars.debuffIDs
	for k, value in ipairs(tempDebuffs) do
		if value == tonumber(id) then
			table.remove(tempDebuffs,k)
		end
	end
	
	d("Removing " .. GetAbilityName(id))
	d("Current debufflist:")
	for k, value in ipairs(tempDebuffs) do 
		local name = GetAbilityName(value)
		d(k .. ": " .. value .. " - " .. name)
	end
	
	CircularBuffs.savedVars.debuffIDs = tempDebuffs
end

local function resetpos()
	CircularBuffs.savedVars.xPosition = 1150
    CircularBuffs.savedVars.yPosition = 1040
	EffectsContainer:ClearAnchors()
    EffectsContainer:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT,CircularBuffs.savedVars.xPosition, CircularBuffs.savedVars.yPosition)
	--CircularBuffs.savedVars.buffIDs = {}
	--CircularBuffs.savedVars.debuffIDs = {}
end

local function resetIDlists()
	CircularBuffs.savedVars.buffIDs = {}
	CircularBuffs.savedVars.debuffIDs = {}
end

-------------------------------------------------------------------------------------------------
--  Register Events --
-------------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(CircularBuffs.name, EVENT_ADD_ON_LOADED, CircularBuffs.OnAddOnLoaded)
SLASH_COMMANDS["/cbmove"] = Move
SLASH_COMMANDS["/cbids"] = ShowIDs
SLASH_COMMANDS["/cbaddbuff"] = addBuff
SLASH_COMMANDS["/cbremovebuff"] = removeBuff
SLASH_COMMANDS["/cbadddebuff"] = addDebuff
SLASH_COMMANDS["/cbremovedebuff"] = removeDebuff
SLASH_COMMANDS["/cbresetpos"] = resetpos
SLASH_COMMANDS["/cbresetids"] = resetIDlists
