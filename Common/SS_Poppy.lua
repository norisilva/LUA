require('HPred')
require("MapPositionGoS")
require('SS_Common')

class "Poppy"

function Poppy:__init()
  self:LoadSpells()
  self:LoadMenu()
  Callback.Add("Tick", function() self:Tick() end)
end

function Poppy:LoadSpells()
    Q = { Range = 175, Width = 50}
    W = { Range = 275}
    E = { Range = 625}
    R = { Range = 175, Width = 50}
end

function Poppy:LoadMenu()
  Poppy = MenuElement({type = MENU, id = "Poppy", name = "Simple - Poppy"})
    
    Poppy:MenuElement({id = "Enable", name = "Enable Champ", value = true})

    Poppy:MenuElement({type = MENU, id = "Combo", name = "Combo"})
    Poppy.Combo:MenuElement({id = "Q", name = "Q", value = true})
    Poppy.Combo:MenuElement({id = "W", name = "W", value = true})
    Poppy.Combo:MenuElement({id = "E", name = "E", value = true})
    Poppy.Combo:MenuElement({id = "R", name = "R", value = true})
    
    Poppy:MenuElement({type = MENU, id = "Harass", name = "Harass"})
    Poppy.Harass:MenuElement({id = "T", name = "Toggle Spells", key = string.byte("S"), toggle = true, value = true})
    Poppy.Harass:MenuElement({id = "Q", name = "Q", value = true})
    Poppy.Harass:MenuElement({id = "E", name = "E", value = true})
    Poppy.Harass:MenuElement({id = "R", name = "R ", value = true})
    
    Poppy:MenuElement({type = MENU, id = "Clear", name = "Clear"})
    Poppy.Clear:MenuElement({id = "T", name = "Toggle Spells", key = string.byte("A"), toggle = true, value = true})
    Poppy.Clear:MenuElement({id = "Q", name = "Q", value = true})

    Poppy:MenuElement({type = MENU, id = "Flee", name = "Escape"})
    Poppy.Flee:MenuElement({id = "W", name = "W", value = true})
end

function Poppy:Tick()
    if not Poppy.Enable:Value() then return end
 
    local mode = GetMode()
    
    if mode == "Combo" then
        -- W pra ninguem pular em mim
        local Wtarget = GetTarget(W.Range) 
        if Wtarget and Poppy.Combo.W:Value() then
            self:CastW()
        end
        -- Empurro para parede
        local Etarget = GetTarget(E.Range) 
        if Etarget and Poppy.Combo.E:Value() then
            self:CastE(Etarget)
        end
        -- Dou o Q
        local Qtarget = GetTarget(Q.Range)
        if Qtarget and Poppy.Combo.Q:Value() then
            self:CastQ(Qtarget)
        end
        -- Jogo pra cima
         local Rtarget = GetTarget(R.Range)
        if Rtarget and Poppy.Combo.R:Value() then
            self:CastR(Rtarget)
        end
        
        -- Dou o Q de novo
        local Qtarget = GetTarget(Q.Range)
        if Qtarget and Poppy.Combo.Q:Value() then
            self:CastQ(Qtarget)
        end
        
    end
    
    if mode == "Harass" and Poppy.Harass.T:Value() then
          -- W pra ninguem pular em mim
        local Wtarget = GetTarget(W.Range) 
        if Wtarget and Poppy.Combo.W:Value() then
            self:CastW()
        end
        -- Empurro para parede
        local Etarget = GetTarget(E.Range) 
        if Etarget and Poppy.Combo.E:Value() then
            self:CastE(Etarget)
        end
        -- Dou o Q
        local Qtarget = GetTarget(Q.Range)
        if Qtarget and Poppy.Combo.Q:Value() then
            self:CastQ(Qtarget)
        end
    end
    if mode == "Clear" and Poppy.Clear.T:Value() then
        local Qtarget = GetClearMinion(Q.Range)
        if Qtarget and Poppy.Clear.Q:Value() then
            self:CastQ(Qtarget)
        end
    end
    if mode == "Flee" then
        local Wtarget = ClosestHero(W.Range,foe) 
        if Wtarget and Poppy.Flee.W:Value() then
            self:CastW()
        end
    end
end

function Poppy:CastR(target,precision)
    if Ready(_R) and IsUp(_R) then
        EnableOrb(false)
        if isValidTarget(target, myHero:GetSpellData(_R).range, false, myHero.pos) then
          Control.CastSpell(HK_R)
        end
        EnableOrb(true)
    end
end

function Poppy:CastQ(target)
  if Ready(_Q) and IsUp(_Q) then
        EnableOrb(false)
        Control.CastSpell(HK_Q,target)
        EnableOrb(true)
    end
end

function Poppy:CastE(target)
    if Ready(_E) and IsUp(_E) then
        EnableOrb(false)
        local finalPos = target.pos:Extended(myHero.pos, -425)
        if MapPosition:inWall(finalPos) then 
          Control.CastSpell(HK_E, target) 
         end
        EnableOrb(true)
    end
end

function Poppy:CastW()
    if Ready(_W) and IsUp(_W) then
        EnableOrb(false)
        if isValidTarget(target, myHero:GetSpellData(_W).range, false, myHero.pos) then
          Control.CastSpell(HK_W)
        end
        EnableOrb(true)
    end
end

function isValidTarget(unit, range, checkTeam, from)
    local range = range == nil and math.huge or range
    if unit == nil or not unit.valid or not unit.visible or unit.dead or not unit.isTargetable 
      or (checkTeam and unit.isAlly) then 
        return false 
    end 
    return unit.pos:DistanceTo(from and from or myHero) < range 
end

function E_EndPos(target)
  return target.pos:Extended(myHero.pos, -425)
end