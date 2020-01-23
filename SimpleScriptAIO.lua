-- Welcome! Simple Script aims to bring together the simplest and most functional GOS libs to produce quick-running champs scripts 
-- and access the minimum of possible functions to help you not be detected. The project is part of a larger project of indetection.
-- This script will always be open and can contain parts of other scripts! If any DEV wants me to remove something, just talk!

-- Carregamentos de arquivos
if not FileExist(COMMON_PATH .. "HPred.lua") then
  print("HPred installed, press f6 x 2")
  DownloadFileAsync("https://raw.githubusercontent.com/Sikaka/GOSExternal/master/HPred.lua", COMMON_PATH .. "HPred.lua", function() end)
  while not FileExist(COMMON_PATH .. "HPred.lua") do end
end
    
require('SS_DrMundo')
require('SS_Warwick')
require('SS_Utility')


local Heroes = {"DrMundo","Warwick"}
local Heroloaded = false
local ActivatorLoaded = false
Callback.Add("Load", function()
    if table.contains(Heroes, myHero.charName) and Heroloaded == false then
        _G[myHero.charName]()
        Heroloaded = true
    end
    if ActivatorLoaded == false then
        Utility()
        ActivatorLoaded = true
    end
end)



