ui = {
  BasePopup = {},
}
ui.BasePopup.inherit = function()
  return {}
end
ui.BasePopup.init = function()
end
ui.BasePopup.onEntry = function()
end
ui.BasePopup.onExit = function()
end
ui.BasePopup.onPointerEvent = function()
  return nil
end
ui.BasePopup.onKeyEvent = function()
  return nil
end

layoutPath = "/menus/layouts"
events = {
  EID_GAME_RESUMED = "resumed",
  EID_GAMERSERVICES_SIGNED_IN = "signed-in",
}

local mainLevels = {
  "Chapter01_L01",
  "Chapter01_L61",
  "Chapter01_G05",
}
local beachLevels = {
  "Chapter02_L01",
  "Chapter02_L61",
  "Chapter02_G04",
}

actions = {
  myPages = {
    Chapter01 = true,
    Chapter02 = true,
    BirdRun = true,
    Duplicate = true,
  },
  myLevels = {
    Chapter01 = mainLevels,
    Chapter02 = beachLevels,
    BirdRun = {"BirdRun_L01"},
    Duplicate = {"Chapter01_L01"},
  },
}

starTable = {
  default = {
    silverScore = 100,
    goldScore = 200,
  },
}

highscores = {
  BirdRun_L01 = {
    score = 150,
  },
}

settings = {
  root = {
    levelStats = {},
    achievementCounters = {
      earnedStars = 0,
      threeStarredLevels = 0,
    },
  },
  frenemiesPlayerData = {
    level = 3,
    experience = 0,
    passedEventsInCurrentLevel = 4,
    shouldPromptLevelUp = true,
  },
  flagTable = {
    shouldUnlockArea = true,
    gateShouldBeDestroyed = true,
  },
}

PlayerLevels = {}
for level = 1, 10 do
  PlayerLevels[level] = {unlocks = {}}
end

local playerStateInitCalls = 0
PlayerState = {}

function PlayerState.getMinimumExperience(_, level)
  return (level - 1) * 100
end

function PlayerState.init()
  playerStateInitCalls = playerStateInitCalls + 1
end

function PlayerState.setFlag(_, name)
  settings.frenemiesPlayerData.flags[name] = true
end

function getLevelMetadata()
  return {
    type = "level",
    ignoreScore = false,
  }
end

function getLevelStarsFromHighscores(_, score)
  if score >= 200 then
    return 3
  elseif score >= 100 then
    return 2
  elseif score > 0 then
    return 1
  end
  return 0
end

SettingsWrapper = {}

function SettingsWrapper.getNumber(_, name)
  return settings.numberTable and settings.numberTable[name]
end

function SettingsWrapper.setNumber(_, name, value)
  settings.numberTable = settings.numberTable or {}
  settings.numberTable[name] = value
end

function SettingsWrapper.setProgress(_, episode, progress)
  settings.progress = settings.progress or {}
  settings.progress[episode] = progress
end

function SettingsWrapper.getFrenemiesPlayerState()
  return settings.frenemiesPlayerData
end

function SettingsWrapper.unlockBirdSkin(_, skinName)
  settings.root.unlockedBirdSkins = settings.root.unlockedBirdSkins or {}
  settings.root.unlockedBirdSkins[skinName] = true
end

function SettingsWrapper.getActiveBirdSkin()
  settings.root.activeBirdSkins = settings.root.activeBirdSkins or {}
  return nil
end

function SettingsWrapper.clearFlag(_, name)
  settings.flagTable[name] = nil
end

function SettingsWrapper.setActiveBirdSkin(_, character, skinName)
  settings.root.activeBirdSkins = settings.root.activeBirdSkins or {}
  settings.root.activeBirdSkins[character] = skinName
end

local mapButton = {
  visible = false,
  enabled = false,
  active = false,
}

function mapButton.setVisible(self, visible)
  self.visible = visible
end

function mapButton.setEnabled(self, enabled)
  self.enabled = enabled
end

local activeMapScreen = {}

function activeMapScreen.getChild(_, name)
  if name == "btnIslandMap" then
    return mapButton
  end
  return nil
end

function getActiveMapScreen()
  return activeMapScreen
end

g_cloudConfig = {
  frenemiesModeEnabled = false,
}

cameraDisabled = true
ignoreCameraMovement = true
ignoreCameraSweep = true

local cameraControlCalls = 0
function toggleCameraControl(value)
  cameraControlCalls = cameraControlCalls + 1
  ignoreCameraMovement = value
  ignoreCameraSweep = value
end

menuManager = {
  allowInput = false,
  inputBlockers = {
    mapProgress = true,
    mapReveal = true,
  },
}

function menuManager.clearAllowInput(self)
  self.allowInput = true
  self.inputBlockers = {}
end

local saves = 0
function saveSettings()
  saves = saves + 1
end

dofile("src/lua/SettingsPopup.lua")

local popup = setmetatable({}, {__index = ui.SettingsPopup})
function popup.getChild()
  return nil
end

local function assertEqual(actual, expected, label)
  if actual ~= expected then
    error(string.format("%s: expected %s, got %s", label, expected, actual))
  end
end

ui.SettingsPopup.applyMainStars(popup, 1)
for _, level in ipairs(mainLevels) do
  assertEqual(highscores[level].score, 1, level .. " one-star score")
  assertEqual(settings.root.levelStats[level].completes, 1, level .. " completes")
end
for _, level in ipairs(beachLevels) do
  assertEqual(highscores[level].score, 1, level .. " one-star score")
end
assertEqual(highscores.BirdRun_L01.score, 150, "non-main level preserved")
assertEqual(settings.numberTable.starsCollected, 8, "one-star total")
assertEqual(settings.root.achievementCounters.threeStarredLevels, 0, "three-star count")
assertEqual(settings.progress.Chapter01.level, "Chapter01_L61", "Chapter01 progress")
assertEqual(settings.progress.Chapter02.nextOpenLevel, "Chapter02_L61", "Chapter02 progress")
assertEqual(settings.mapAreaProgress.Chapter01, 13, "Chapter01 map reveal")
assertEqual(settings.mapAreaProgress.Chapter02, 15, "Chapter02 map reveal")
assertEqual(
  settings.frenemiesPlayerData.flags.islandMapButtonUnlockShownInMapScreen,
  true,
  "island map button flag"
)
assertEqual(g_cloudConfig.frenemiesModeEnabled, true, "island map mode enabled")
assertEqual(cameraDisabled, false, "camera disabled reset")
assertEqual(ignoreCameraMovement, false, "camera movement reset")
assertEqual(ignoreCameraSweep, false, "camera sweep reset")
assertEqual(cameraControlCalls, 1, "camera control refreshed")
assertEqual(menuManager.allowInput, true, "menu input restored")
assertEqual(next(menuManager.inputBlockers), nil, "map input blockers cleared")
assertEqual(mapButton.visible, true, "island map button visible")
assertEqual(mapButton.enabled, true, "island map button enabled")
assertEqual(settings.flagTable.shouldUnlockArea, nil, "area reveal flag cleared")
assertEqual(
  settings.flagTable.gateShouldBeDestroyed,
  nil,
  "gate reveal flag cleared"
)
assertEqual(settings.root.unlockedBirdSkins.Luca, true, "Luca unlock")
assertEqual(settings.root.unlockedBirdSkins.Willow, true, "Willow unlock")
assertEqual(settings.root.unlockedBirdSkins.Dahlia, true, "Dahlia unlock")
assertEqual(settings.root.unlockedBirdSkins.Gale, true, "Gale unlock")
assertEqual(settings.root.activeBirdSkins.Luca, "Luca", "Luca default skin")

ui.SettingsPopup.claimGiftSkins(popup)
assertEqual(settings.root.unlockedBirdSkins["Sweet Tunes Stella"], true, "gift skin 1")
assertEqual(settings.root.unlockedBirdSkins["Artistic Willow"], true, "gift skin 2")
assertEqual(settings.root.unlockedBirdSkins["Scientist Dahlia"], true, "gift skin 3")
assertEqual(settings.root.unlockedBirdSkins["Princess Gale"], true, "gift skin 4")

ui.SettingsPopup.adjustPurpleLevel(popup, 1)
assertEqual(settings.frenemiesPlayerData.level, 4, "purple level plus one")
assertEqual(settings.frenemiesPlayerData.experience, 300, "purple level minimum xp")

ui.SettingsPopup.adjustPurpleLevel(popup, 5)
assertEqual(settings.frenemiesPlayerData.level, 9, "purple level plus five")
ui.SettingsPopup.adjustPurpleLevel(popup, 5)
assertEqual(settings.frenemiesPlayerData.level, 10, "purple level clamps at max")
ui.SettingsPopup.adjustPurpleLevel(popup, -5)
assertEqual(settings.frenemiesPlayerData.level, 5, "purple level minus five")
assertEqual(settings.frenemiesPlayerData.passedEventsInCurrentLevel, 0, "event counter reset")
assertEqual(settings.frenemiesPlayerData.shouldPromptLevelUp, nil, "level-up prompt reset")
assertEqual(playerStateInitCalls, 4, "player state refreshed")

if saves ~= 6 then
  error("expected 6 saves, got " .. saves)
end

print("settings popup save-tool tests passed")
