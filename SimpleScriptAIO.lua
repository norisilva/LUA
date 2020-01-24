-- Welcome! Simple Script aims to bring together the simplest and most functional GOS libs to produce quick-running champs scripts 
-- and access the minimum of possible functions to help you not be detected. The project is part of a larger project of indetection.
-- This script will always be open and can contain parts of other scripts! If any DEV wants me to remove something, just talk!

-- File loads
if not FileExist(COMMON_PATH .. "HPred.lua") then
  print("HPred installed, press f6 x 2")
  DownloadFileAsync("https://raw.githubusercontent.com/Sikaka/GOSExternal/master/HPred.lua", COMMON_PATH .. "HPred.lua", function() end)
  while not FileExist(COMMON_PATH .. "HPred.lua") do end
end
    
require('HPred')
require('SS_Poppy')
require('SS_DrMundo')
require('SS_Warwick')
require('SS_Utility')

-- Champs String List
local champs = {"Poppy","DrMundo","Warwick"}
local champsLoad = false
local utilLoad = false

-- Load submodels
Callback.Add("Load", function()
    if table.contains(champs, myHero.charName) and champsLoad == false then
        _G[myHero.charName]()
        champsLoad = true
    end
    if utilLoad == false then
        Utility()
        utilLoad = true
    end
end)



