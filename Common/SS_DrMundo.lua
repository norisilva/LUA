require('HPred')
require('SS_Common')

class "DrMundo"



function DrMundo:__init()
  self:LoadSpells()
  self:LoadMenu()
  Callback.Add("Tick", function() self:Tick() end)
end

function DrMundo:LoadSpells()
    Q = { Range = 975, Delay = 0.25, Width = 60, Speed = 1850}
    W = { Range = 325}
    E = { Range = 300}
    R = { Range = 0}
end

function DrMundo:LoadMenu()
  DrMundo = MenuElement({type = MENU, id = "DrMundo", name = "Simple - Dr. Mundo"})
    
    DrMundo:MenuElement({id = "Enable", name = "Enable Hero", value = true})
    
    DrMundo:MenuElement({type = MENU, id = "Combo", name = "Combo"})
    DrMundo.Combo:MenuElement({id = "Q", name = "Q - Infected Cleaver", value = true})
    DrMundo.Combo:MenuElement({id = "W", name = "W - Burning Agony", value = true})
    DrMundo.Combo:MenuElement({id = "E", name = "E - Masochism", value = true})
    
    DrMundo:MenuElement({type = MENU, id = "Harass", name = "Harass"})
    DrMundo.Harass:MenuElement({id = "T", name = "Toggle Spells", key = string.byte("S"), toggle = true, value = true})
    DrMundo.Harass:MenuElement({id = "Q", name = "Q - Infected Cleaver", value = true})
    DrMundo.Harass:MenuElement({id = "AQ", name = "Auto Q", value = true})
    DrMundo.Harass:MenuElement({id = "W", name = "W - Burning Agony", value = true})
    DrMundo.Harass:MenuElement({id = "E", name = "E - Masochism", value = true})
    
    DrMundo:MenuElement({type = MENU, id = "Clear", name = "Clear"})
    DrMundo.Clear:MenuElement({id = "T", name = "Toggle Spells", key = string.byte("A"), toggle = true, value = true})
    DrMundo.Clear:MenuElement({id = "Q", name = "Q - Infected Cleaver", value = true})
    DrMundo.Clear:MenuElement({id = "W", name = "W - Burning Agony", value = true})
    DrMundo.Clear:MenuElement({id = "E", name = "E - Masochism", value = true})

    DrMundo:MenuElement({type = MENU, id = "Flee", name = "Flee"})
    DrMundo.Flee:MenuElement({id = "Q", name = "Q - Infected Cleaver", value = true})
    
    DrMundo:MenuElement({type = MENU, id = "Lifesaver", name = "Life Saver"})
    DrMundo.Lifesaver:MenuElement({id = "R", name = "R - Sadism", value = true})
    DrMundo.Lifesaver:MenuElement({id = "HP", name = "Health % to Life Saver", value = 15, min = 0, max = 100})
    
end

function DrMundo:Tick()
    if not DrMundo.Enable:Value() then return end
    if Hp() < DrMundo.Lifesaver.HP:Value() and HeroesAround(1500,myHero.pos) ~= 0 and DrMundo.Lifesaver.R:Value() then
        self:CastR()
    end
    if DrMundo.Harass.T:Value() then
        local Qtarget = GetTarget(Q.Range)
        if Qtarget and DrMundo.Harass.AQ:Value() then
            self:CastQ(Qtarget,2)
        end
    end
    local mode = GetMode()
    if mode == "Combo" then
        local Qtarget = GetTarget(Q.Range)
        if Qtarget and DrMundo.Combo.Q:Value() then
            self:CastQ(Qtarget)
        end
        local Wtarget = GetTarget(W.Range) 
        if Wtarget and DrMundo.Combo.W:Value() then
            self:CastW()
        end
        local Etarget = GetTarget(E.Range) 
        if Etarget and DrMundo.Combo.E:Value() then
            self:CastE()
        end
    end
    if mode == "Harass" and DrMundo.Harass.T:Value() then
        local Qtarget = GetTarget(Q.Range)
        if Qtarget and DrMundo.Harass.Q:Value() then
            self:CastQ(Qtarget)
        end
        local Wtarget = GetTarget(W.Range) 
        if Wtarget and DrMundo.Harass.W:Value() then
            self:CastW()
        end
        local Etarget = GetTarget(E.Range) 
        if Etarget and DrMundo.Harass.E:Value() then
            self:CastE()
        end
    end
    if mode == "Clear" and DrMundo.Clear.T:Value() then
        local Qtarget = GetClearMinion(Q.Range)
        if Qtarget and DrMundo.Clear.Q:Value() then
            self:CastQMinion(Qtarget)
        end
        local Wtarget = GetClearMinion(W.Range)
        if Wtarget and DrMundo.Clear.W:Value() then
            self:CastW()
        end
        local Etarget = GetClearMinion(E.Range)
        if Etarget and DrMundo.Clear.E:Value() then
            self:CastE()
        end
    end
    if mode == "Flee" then
        local Qtarget = ClosestHero(Q.Range,foe)
        if Qtarget and DrMundo.Flee.Q:Value() then
            self:CastQ(Qtarget)
        end
    end
end

function DrMundo:CastQ(target,precision)
    local precision = precision or 1
  if Ready(_Q) and IsUp(_Q) then
        if target and HPred:CanTarget(target) then
            local hitChance, aimPosition = HPred:GetHitchance(myHero.pos, target, Q.Range, Q.Delay, Q.Speed, Q.Width, true, nil)
            if hitChance and hitChance >= precision and HPred:GetDistance(myHero.pos, aimPosition) <= Q.Range then
                EnableOrb(false)
                Control.CastSpell(HK_Q, aimPosition)
                EnableOrb(true)
            end
        end
    end
end

function DrMundo:CastQMinion(target)
  if Ready(_Q) and IsUp(_Q) then
        if target then
            local pred = target:GetPrediction(Q.Speed, Q.Delay)
            if target:GetCollision(Q.Width, Q.Speed, Q.Delay) <= 1 then
                Control.CastSpell(HK_Q, pred)
            end
        end
    end
end

function DrMundo:CastW()
  if Ready(_W) and IsUp(_W) and myHero:GetSpellData(_W).toggleState ~= 2 then
        EnableOrb(false)
        Control.CastSpell(HK_W)
        EnableOrb(true)
    end
end

function DrMundo:CastE()
  if Ready(_E) and IsUp(_E) then
        EnableOrb(false)
        Control.CastSpell(HK_E)
        EnableOrb(true)
    end
end

function DrMundo:CastR()
  if Ready(_R) and IsUp(_R) then
        EnableOrb(false)
        Control.CastSpell(HK_R)
        EnableOrb(true)
    end
end
