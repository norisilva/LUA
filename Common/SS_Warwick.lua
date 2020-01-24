require('HPred')
require('SS_Common')

class "Warwick"

function Warwick:__init()
  self:LoadSpells()
  self:LoadMenu()
  Callback.Add("Tick", function() self:Tick() end)
end

function Warwick:LoadSpells()
    Q = { Range = 337}
    E = { Range = 355}
    R = { Range = 0,  Speed = 1600, Width = 45}
end

function Warwick:LoadMenu()
  Warwick = MenuElement({type = MENU, id = "Warwick", name = "Simple - Warwick"})
    
    Warwick:MenuElement({type = MENU, id = "Combo", name = "Combo"})
    Warwick.Combo:MenuElement({id = "Q", name = "Q", value = true})
    Warwick.Combo:MenuElement({id = "E", name = "E", value = true})
    Warwick.Combo:MenuElement({id = "R", name = "R", value = true})
    
    Warwick:MenuElement({type = MENU, id = "Harass", name = "Harass"})
    Warwick.Harass:MenuElement({id = "Q", name = "Q", value = true})
    Warwick.Harass:MenuElement({id = "E", name = "E", value = true})
    Warwick.Harass:MenuElement({id = "R", name = "R", value = true})
    
    Warwick:MenuElement({type = MENU, id = "Clear", name = "Clear"})
    Warwick.Clear:MenuElement({id = "Q", name = "Q", value = true})

    Warwick:MenuElement({type = MENU, id = "Flee", name = "Escape"})
    Warwick.Flee:MenuElement({id = "E", name = "E", value = true})
end

function Warwick:Tick()
    if not Warwick.Enable:Value() then return end
    self:Rrange()
    local mode = GetMode()
    if mode == "Combo" then
        local Rtarget = GetTarget(R.Range)
        if Rtarget and Warwick.Combo.R:Value() then
            self:CastR(Rtarget)
        end
        local Etarget = GetTarget(E.Range) 
        if Etarget and Warwick.Combo.E:Value() then
            self:CastE()
        end
        local Qtarget = GetTarget(Q.Range)
        if Qtarget and Warwick.Combo.Q:Value() then
            self:CastQ(Qtarget)
        end
    end
    if mode == "Harass" and Warwick.Harass.T:Value() then
        local Rtarget = GetTarget(R.Range)
        if Rtarget and Warwick.Harass.R:Value() then
            self:CastR(Rtarget)
        end
        local Etarget = GetTarget(E.Range) 
        if Etarget and Warwick.Harass.E:Value() then
            self:CastE()
        end
        local Qtarget = GetTarget(Q.Range)
        if Qtarget and Warwick.Harass.Q:Value() then
            self:CastQ(Qtarget)
        end
    end
    if mode == "Clear" and Warwick.Clear.T:Value() then
        local Qtarget = GetClearMinion(Q.Range)
        if Qtarget and Warwick.Clear.Q:Value() then
            self:CastQ(Qtarget)
        end
    end
    if mode == "Flee" then
        local Etarget = ClosestHero(E.Range,foe) 
        if Etarget and Warwick.Flee.E:Value() then
            self:CastE()
        end
    end
end

function Warwick:CastR(target,precision)
    local precision = precision or 1
  if Ready(_R) and IsUp(_R) then
        if target and HPred:CanTarget(target) then
            local hitChance, aimPosition = HPred:GetHitchance(myHero.pos, target, R.Range, R.Delay, R.Speed, R.Width, false, nil)
            if hitChance and hitChance >= precision and HPred:GetDistance(myHero.pos, aimPosition) <= R.Range then
                EnableOrb(false)
                Control.CastSpell(HK_R, aimPosition)
                EnableOrb(true)
            end
        end
    end
end

function Warwick:Rrange()
    R.Range = myHero.ms * 2.50 - 275
end

function Warwick:CastQ(target)
  if Ready(_Q) and IsUp(_Q) then
        EnableOrb(false)
        Control.CastSpell(HK_Q,target)
        EnableOrb(true)
    end
end

function Warwick:CastE()
    if Ready(_E) and IsUp(_E) then
        EnableOrb(false)
        Control.CastSpell(HK_E)
        EnableOrb(true)
    end
end
