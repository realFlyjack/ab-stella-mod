local ipairs = _G.ipairs
local pairs = _G.pairs
local pcall = _G.pcall
local string = _G.string
local math = _G.math
local tonumber = _G.tonumber

local SettingsPopup = ui.BasePopup.inherit(ui.BasePopup)
ui.SettingsPopup = SettingsPopup

local MAIN_EPISODES = {"Chapter01", "Chapter02"}

local TOOL_ELEMENTS = {
    "toolBackdrop",
    "txtSaveToolsTitle",
    "txtSaveStatus",
    "txtGiftInfo",
    "btnToolMainStars",
    "btnToolClaimGifts",
    "btnToolPurplePlusFive",
    "btnToolBack",
}

local GIFT_SKINS = {
    "Sweet Tunes Stella",
    "Artistic Willow",
    "Scientist Dahlia",
    "Princess Gale",
}

local MAIN_CHARACTERS = {
    "Luca",
    "Willow",
    "Dahlia",
    "Gale",
}

local MAIN_BUTTONS = {
    "btnSaveTools",
    "btnClose",
    "btnLeaderboards",
    "btnAchievements",
    "btnEULA",
    "btnPrivacyPolicy",
    "btnCredits",
    "btnRovioAccountSocialLogin",
    "btnSoundToggle",
}

local function setChildVisible(self, name, visible)
    local child = self.getChild(self, name)
    if child then
        child.setVisible(child, visible)
    end
end

local function getCurrentStars()
    local stars = SettingsWrapper.getNumber(SettingsWrapper, "starsCollected")
    if not stars then
        return 0
    end
    return math.floor(stars)
end

local function getPurpleState()
    return SettingsWrapper.getFrenemiesPlayerState(SettingsWrapper)
end

local function safeCall(fn, ...)
    if fn then
        pcall(fn, ...)
    end
end

local function repairMapScreenState(playerData)
    playerData.flags = playerData.flags or {}
    playerData.flags.islandMapButtonUnlockShownInMapScreen = true
    if PlayerState and PlayerState.setFlag then
        safeCall(
            PlayerState.setFlag,
            PlayerState,
            "islandMapButtonUnlockShownInMapScreen"
        )
    end

    if g_cloudConfig then
        g_cloudConfig.frenemiesModeEnabled = true
    end

    _G.cameraDisabled = false
    _G.ignoreCameraMovement = false
    _G.ignoreCameraSweep = false
    safeCall(_G.toggleCameraControl, false)

    if menuManager then
        safeCall(menuManager.clearAllowInput, menuManager)
        menuManager.allowInput = true
    end

    local mapScreen = nil
    if getActiveMapScreen then
        local ok, activeMap = pcall(getActiveMapScreen)
        if ok then
            mapScreen = activeMap
        end
    end
    if not mapScreen then
        return
    end

    local button = nil
    local ok, child = pcall(mapScreen.getChild, mapScreen, "btnIslandMap")
    if ok then
        button = child
    end
    if button then
        button.visible = true
        button.active = true
        safeCall(button.setVisible, button, true)
        safeCall(button.setEnabled, button, true)
    end

    if gameCamera then
        gameCamera.keepInsideOriginalCameras = true
        safeCall(gameCamera.setCameraFunction, gameCamera, "mapScreenCamera")
        safeCall(gameCamera.update, gameCamera, 0)
    end
end

local function isMainLevel(levelName)
    return string.match(levelName, "^Chapter0[12]_") ~= nil
end

local function countCurrentStars()
    local total = 0
    local threeStars = 0
    local seen = {}
    local pages = actions and actions.myPages or {}
    local levelsByPage = actions and actions.myLevels or {}

    for episode in pairs(pages) do
        local levels = levelsByPage[episode]
        if levels then
            for _, levelName in ipairs(levels) do
                local highscore = highscores[levelName]
                if not seen[levelName] and highscore and highscore.score then
                    seen[levelName] = true
                    local ok, stars = pcall(
                        getLevelStarsFromHighscores,
                        levelName,
                        highscore.score
                    )
                    if ok then
                        total = total + stars
                        if stars == 3 then
                            threeStars = threeStars + 1
                        end
                    end
                end
            end
        end
    end

    return total, threeStars
end

function SettingsPopup:init()
    self.layoutDefinitionFile = layoutPath .. "/SettingsPopup.layout.lua"
    ui.BasePopup.init(self)
    self.toolOpen = false
    self:showSaveTools(false)
end

function SettingsPopup:onEntry()
    ui.BasePopup.onEntry(self)
    self.toolOpen = false
    self:showSaveTools(false)
    self:handleGamerServiceButtons()
end

function SettingsPopup:onExit()
    ui.BasePopup.onExit(self)
end

function SettingsPopup:eventTriggered(event)
    if event.id == events.EID_GAME_RESUMED
        or event.id == events.EID_GAMERSERVICES_SIGNED_IN then
        self:handleGamerServiceButtons()
    end
end

function SettingsPopup:showSaveTools(visible)
    self.toolOpen = visible

    for _, name in ipairs(MAIN_BUTTONS) do
        setChildVisible(self, name, not visible)
    end
    for _, name in ipairs(TOOL_ELEMENTS) do
        setChildVisible(self, name, visible)
    end

    if visible then
        self:updateSaveStatus("")
    else
        self:handleGamerServiceButtons()
    end
end

function SettingsPopup:updateSaveStatus(message)
    local status = self.getChild(self, "txtSaveStatus")
    if not status then
        return
    end

    local playerData = getPurpleState()
    local level = playerData.level or 1
    local maxLevel = PlayerLevels and #PlayerLevels or 35
    local line
    if level >= maxLevel then
        line = string.format("PURPLE LEVEL %d  MAX", level)
    else
        local currentMinimum = PlayerState.getMinimumExperience(
            PlayerState,
            level
        )
        local nextMinimum = PlayerState.getMinimumExperience(
            PlayerState,
            level + 1
        )
        line = string.format(
            "PURPLE LEVEL %d  XP %d/%d",
            level,
            (playerData.experience or 0) - currentMinimum,
            nextMinimum - currentMinimum
        )
    end
    line = line .. string.format("\nMAIN STARS %d", getCurrentStars())
    if message and message ~= "" then
        line = line .. "\n" .. message
    end
    status.text = line
end

function SettingsPopup:applyMainStars(starCount)
    local count = 0
    local levelsByPage = actions and actions.myLevels or {}
    local levelStats = settings.root.levelStats
    if not levelStats then
        levelStats = {}
        settings.root.levelStats = levelStats
    end

    for _, episode in ipairs(MAIN_EPISODES) do
        local levels = levelsByPage[episode] or {}
        local lastLevel = nil
        local lastNumber = -1

        for _, levelName in ipairs(levels) do
            if isMainLevel(levelName) then
                local metadata = getLevelMetadata(levelName)
                if metadata and metadata.type ~= "comic"
                    and metadata.ignoreScore ~= true then
                    local limits = starTable[levelName] or starTable.default
                    local score = 1
                    if starCount == 2 then
                        score = limits.silverScore
                    elseif starCount == 3 then
                        score = limits.goldScore
                    end

                    local highscore = highscores[levelName]
                    if not highscore then
                        highscore = {}
                        highscores[levelName] = highscore
                    end
                    highscore.score = score

                    local stats = levelStats[levelName]
                    if not stats then
                        stats = {starts = 0, fails = 0, completes = 0}
                        levelStats[levelName] = stats
                    end
                    stats.starts = math.max(stats.starts or 0, 1)
                    stats.fails = stats.fails or 0
                    stats.completes = math.max(stats.completes or 0, 1)

                    count = count + 1
                    local levelNumber = tonumber(
                        string.match(levelName, "_L(%d+)$")
                    )
                    if levelNumber and levelNumber > lastNumber then
                        lastNumber = levelNumber
                        lastLevel = levelName
                    end
                end
            end
        end

        if lastLevel then
            SettingsWrapper.setProgress(SettingsWrapper, episode, {
                level = lastLevel,
                nextOpenLevel = lastLevel,
            })
        end
    end

    settings.mapAreaProgress = settings.mapAreaProgress or {}
    settings.mapAreaProgress.Chapter01 = 13
    settings.mapAreaProgress.Chapter02 = 15

    settings.mapScreenProgress = settings.mapScreenProgress or {}
    settings.mapScreenProgress.Chapter01 = 66
    settings.mapScreenProgress.Chapter02 = 65
    settings.playedSinceLastMapScreenVisit = {}

    local playerData = getPurpleState()
    safeCall(SettingsWrapper.clearFlag, SettingsWrapper, "shouldUnlockArea")
    safeCall(
        SettingsWrapper.clearFlag,
        SettingsWrapper,
        "gateShouldBeDestroyed"
    )
    repairMapScreenState(playerData)
    safeCall(
        SettingsWrapper.setFlag,
        SettingsWrapper,
        "powerUpButtonUnlocked"
    )

    for _, character in ipairs(MAIN_CHARACTERS) do
        SettingsWrapper.unlockBirdSkin(SettingsWrapper, character)
        if not SettingsWrapper.getActiveBirdSkin(SettingsWrapper, character) then
            SettingsWrapper.setActiveBirdSkin(
                SettingsWrapper,
                character,
                character
            )
        end
    end

    local total, threeStars = countCurrentStars()
    SettingsWrapper.setNumber(SettingsWrapper, "starsCollected", total)
    settings.root.achievementCounters = settings.root.achievementCounters or {}
    settings.root.achievementCounters.threeStarredLevels = threeStars
    settings.root.achievementCounters.earnedStars = math.max(
        settings.root.achievementCounters.earnedStars or 0,
        total
    )

    saveSettings()
    self:updateSaveStatus(
        string.format("SET %d MAIN LEVELS TO %d STAR", count, starCount)
    )
end

function SettingsPopup:claimGiftSkins()
    for _, skinName in ipairs(GIFT_SKINS) do
        SettingsWrapper.unlockBirdSkin(SettingsWrapper, skinName)
    end
    saveSettings()
    self:updateSaveStatus("FOUR BEACH GIFT SKINS CLAIMED")
end

function SettingsPopup:adjustPurpleLevel(delta)
    local playerData = getPurpleState()
    local maxLevel = PlayerLevels and #PlayerLevels or 35
    local targetLevel = math.max(
        1,
        math.min(maxLevel, (playerData.level or 1) + delta)
    )

    playerData.level = targetLevel
    playerData.experience = PlayerState.getMinimumExperience(
        PlayerState,
        targetLevel
    )
    playerData.passedEventsInCurrentLevel = 0
    playerData.shouldPromptLevelUp = nil

    PlayerState.init(PlayerState)
    saveSettings()
    self:updateSaveStatus(
        string.format("PURPLE LEVEL SET TO %d", targetLevel)
    )
end

function SettingsPopup:onPointerEvent(x, y, pointer)
    local result = ui.BasePopup.onPointerEvent(self, x, y, pointer)

    if result == "OPEN_SAVE_TOOLS" then
        self:showSaveTools(true)
    elseif result == "SAVE_TOOLS_BACK" then
        self:showSaveTools(false)
    elseif result == "SAVE_MAIN_ONE_STAR" then
        self:applyMainStars(1)
    elseif result == "SAVE_CLAIM_GIFTS" then
        self:claimGiftSkins()
    elseif result == "SAVE_PURPLE_STAR_LEVEL_PLUS_FIVE" then
        self:adjustPurpleLevel(5)
    elseif result == "OPEN_LEADERBOARDS" then
        SubsystemManager.get("FusionGamerServices"):showLeaderboards()
    elseif result == "OPEN_ACHIEVEMENTS" then
        SubsystemManager.get("FusionGamerServices"):showAchievements()
    elseif result == "GOTO_CREDITS" then
        LevelLoad.transitionToLevel("minigames", 2)
        self:close()
    elseif result == "GOTO_EULA" then
        openURL(
            generateRedirectURL("eula"),
            "TEXT_EXIT_CONFIRMATION_EULA",
            "",
            true,
            "EULA_URL"
        )
    elseif result == "GOTO_PRIVACY_POLICY" then
        openURL(
            generateRedirectURL("privacypolicy"),
            "TEXT_EXIT_CONFIRMATION_PRIVACY",
            "",
            true,
            "PRIVACY_POLICY_URL"
        )
    elseif result == "ACCOUNT_ACTION" and SkynestAccount then
        if SkynestAccount.isAccountLoggedIn() then
            SkynestAccount.logout()
        else
            SkynestAccount.login(true, false, false)
        end
    elseif result == "ACCOUNT_LOGOUT" and SkynestAccount then
        if SkynestAccount.isAccountLoggedIn() then
            SkynestAccount.unRegister()
        end
    elseif result == "SOCIAL_LOGIN" and SkynestAccount then
        if SkynestAccount.isAccountLoggedIn() then
            SkynestAccount.logout()
        else
            SkynestAccount.login(false, true, false)
        end
    end

    return "BLOCK"
end

function SettingsPopup:onKeyEvent(action, key)
    if self.toolOpen and action == "PRESS"
        and (key == "KEY_BACK" or key == "ESCAPE") then
        self:showSaveTools(false)
        return "BLOCK"
    end
    return ui.BasePopup.onKeyEvent(self, action, key)
end

function SettingsPopup:handleGamerServiceButtons()
    if not SubsystemManager.isRegistered("FusionGamerServices") then
        return
    end

    local service = SubsystemManager.get("FusionGamerServices")
    local leaderboards = self.getChild(self, "btnLeaderboards")
    local achievements = self.getChild(self, "btnAchievements")

    if service.getBackendName() == "googleplay" then
        leaderboards.setImage(
            leaderboards,
            "BTN_GOOGLE_LEADERBOARDS",
            "BTN_GOOGLE_LEADERBOARDS_GREY"
        )
        achievements.setImage(
            achievements,
            "BTN_GOOGLE_ACHIEVEMENTS",
            "BTN_GOOGLE_ACHIEVEMENTS_GREY"
        )
    end

    local available = service.isAvailable()
    leaderboards.setVisible(leaderboards, available and not self.toolOpen)
    achievements.setVisible(achievements, available and not self.toolOpen)
    local authenticated = service.isPlayerAuthenticated()
    leaderboards.setEnabled(leaderboards, authenticated)
    achievements.setEnabled(achievements, authenticated)
end
