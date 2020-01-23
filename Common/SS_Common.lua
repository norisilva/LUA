
 neutral = 300
 friend = myHero.team
 foe = neutral - friend

 mathhuge = math.huge
 mathsqrt = math.sqrt
 mathpow = math.pow
 mathmax = math.max
 mathfloor = math.floor

 HKITEM = {[ITEM_1] = HK_ITEM_1,[ITEM_2] = HK_ITEM_2,[ITEM_3] = HK_ITEM_3,[ITEM_4] = HK_ITEM_4,[ITEM_5] = HK_ITEM_5,[ITEM_6] = HK_ITEM_6,[ITEM_7] = HK_ITEM_7}
 HKSPELL = {[SUMMONER_1] = HK_SUMMONER_1,[SUMMONER_2] = HK_SUMMONER_2,}

 function Ready(slot)
  return myHero:GetSpellData(slot).currentCd == 0
end

 function IsUp(slot)
    return Game.CanUseSpell(slot) == 0
end

 function GetDistanceSqr(Pos1, Pos2)
     Pos2 = Pos2 or myHero.pos
     dx = Pos1.x - Pos2.x
     dz = (Pos1.z or Pos1.y) - (Pos2.z or Pos2.y)
    return dx^2 + dz^2
end

 function GetDistance(Pos1, Pos2)
  return mathsqrt(GetDistanceSqr(Pos1, Pos2))
end

 function GetDistance2D(p1,p2)
     p2 = p2 or myHero
    return  mathsqrt(mathpow((p2.x - p1.x),2) + mathpow((p2.y - p1.y),2))
end

 function GetMode()
    if _G.SDK then
        if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
            return "Combo"
        elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
            return "Harass" 
        elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] or _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR]     then return "Clear"
        elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then
            return "LastHit"
        elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_FLEE] then
            return "Escape"
        end
    elseif _G.gsoSDK then
        return _G.gsoSDK.Orbwalker:UOL_GetMode()
    else
        return GOS.GetMode()
    end
end

 function GetTarget(range) 
     target = nil 
    if _G.EOWLoaded then 
        target = EOW:GetTarget(range) 
    elseif _G.SDK and _G.SDK.Orbwalker then 
        target = _G.SDK.TargetSelector:GetTarget(range) 
    else 
        target = GOS:GetTarget(range) 
    end 
    return target 
end

 function EnableOrb(bool)
  if _G.EOWLoaded then
    EOW:SetMovements(bool)
    EOW:SetAttacks(bool)
  elseif _G.SDK and _G.SDK.Orbwalker then
    _G.SDK.Orbwalker:SetMovement(bool)
        _G.SDK.Orbwalker:SetAttack(bool)
    else
    GOS.BlockMovement = not bool
    GOS.BlockAttack = not bool
  end
end

 function CalcPhysicalDamage(source, target, amount)
     ArmorPenPercent = source.armorPenPercent
     ArmorPenFlat = (0.4 + target.levelData.lvl / 30) * source.armorPen
     BonusArmorPen = source.bonusArmorPenPercent
     armor = target.armor
     bonusArmor = target.bonusArmor
     value = 100 / (100 + (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat)
    if armor < 0 then
        value = 2 - 100 / (100 - armor)
    elseif (armor * ArmorPenPercent) - (bonusArmor * (1 - BonusArmorPen)) - ArmorPenFlat < 0 then
        value = 1
    end
    return value * amount
  end

 function CalcMagicalDamage(source, target, amount)
     mr = target.magicResist
     value = 100 / (100 + (mr * source.magicPenPercent) - source.magicPen)  
    if mr < 0 then
        value = 2 - 100 / (100 - mr)
    elseif (mr * source.magicPenPercent) - source.magicPen < 0 then
        value = 1
    end
    return value * amount
end

 function ClosestHero(range,team)
     bestHero = nil
     closest = math.huge
    for i = 1, Game.HeroCount() do
         hero = Game.Hero(i)
        if GetDistance(hero.pos) < range and hero.team == team and not hero.dead then
             Distance = GetDistance(hero.pos, mousePos)
            if Distance < closest then
                bestHero = hero
                closest = Distance
            end
        end
    end
    return bestHero
end

 function ClosestMinion(range,team)
     bestMinion = nil
     closest = math.huge
    for i = 1, Game.MinionCount() do
         minion = Game.Minion(i)
        if GetDistance(minion.pos) < range and minion.team == team and not minion.dead then
             Distance = GetDistance(minion.pos, mousePos)
            if Distance < closest then
                bestMinion = minion
                closest = Distance
            end
        end
    end
    return bestMinion
end

 function GetClearMinion(range)
    for i = 1, Game.MinionCount() do
         minion = Game.Minion(i)
        if GetDistance(minion.pos) < range and not minion.dead and (minion.team == neutral or minion.team == foe) then
            return minion
        end
    end
end

 function Hp(source)
     source = source or myHero
    return source.health/source.maxHealth * 100
end

 function Mp(source)
     source = source or myHero
    return source.mana/source.maxMana * 100
end

 function ClosestInjuredHero(range,team,life,includeMe)
     includeMe = includeMe or true
     life = life or 101
     bestHero = nil
     closest = math.huge
    for i = 1, Game.HeroCount() do
         hero = Game.Hero(i)
        if GetDistance(hero.pos) < range and hero.team == team and not hero.dead and Hp(hero) < life then
            if includeMe == false and hero.isMe then return end
             Distance = GetDistance(hero.pos, mousePos)
            if Distance < closest then
                bestHero = hero
                closest = Distance
            end
        end
    end
    return bestHero
end

 function HeroesAround(range, pos, team)
     pos = pos or myHero.pos
     team = team or foe
     Count = 0
  for i = 1, Game.HeroCount() do
     hero = Game.Hero(i)
    if hero and hero.team == team and not hero.dead and GetDistance(pos, hero.pos) < range then
      Count = Count + 1
    end
  end
  return Count
end

 function BuffByType(wich,time)
  for i = 0, myHero.buffCount do 
   buff = myHero:GetBuff(i)
    if buff.type == wich and buff.duration > time then 
      return true
    end
  end
  return false
end

 function ExistSpell(spellname)
    if myHero:GetSpellData(SUMMONER_1).name == spellname or myHero:GetSpellData(SUMMONER_2).name == spellname then
        return true
    end
    return false
end

 function SummonerSlot(spellname)
    if myHero:GetSpellData(SUMMONER_1).name == spellname then
        return SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name == spellname then
        return SUMMONER_2
    end
end
