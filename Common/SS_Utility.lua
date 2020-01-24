
class "Utility"

require('HPred')
require('SS_Common')

function Utility:__init()
  self:Menu()
  Callback.Add("Tick", function() self:Tick() end)
end

function Utility:Menu()
    SSUtil = MenuElement({type = MENU, id = "SSUtil", name = "Simple - Utils"})

    SSUtil:MenuElement({type = MENU, id = "Combo", name = "Combo"})
    SSUtil.Combo:MenuElement({id = "Ignite", name = "Ignite", value = true})
    SSUtil.Combo:MenuElement({id = "Smite", name = "Smite", value = true})
    SSUtil.Combo:MenuElement({id = "Exhaust", name = "Exhaust", value = true})
    SSUtil.Combo:MenuElement({id = " ", name = " ", type = SPACE})
    SSUtil.Combo:MenuElement({id = "Tiamat", name = "Tiamat", value = true})
    SSUtil.Combo:MenuElement({id = "TitanicHydra", name = "Titanic Hydra", value = true})

    SSUtil:MenuElement({type = MENU, id = "Heal", name = "Heal"})
    SSUtil.Heal:MenuElement({id = "Heal", name = "Heal", value = true})
    SSUtil.Heal:MenuElement({id = "HPS1", name = "Health % to Heal", value = 15, min = 0, max = 100})
    SSUtil.Heal:MenuElement({id = " ", name = " ", type = SPACE})
    SSUtil.Heal:MenuElement({id = "Redemption", name = "Redemption", value = true})
    SSUtil.Heal:MenuElement({id = "HP1", name = "Health % to Heal", value = 15, min = 0, max = 100})

   
end

function Utility:Tick()
    
    self:Heal()
    local mode = GetMode()
    if mode == "Combo" then
        self:Combo()
    end
  
end

function Utility:Combo()
    local PostAttack = myHero.attackData.state == STATE_WINDDOWN
    local items = {}
  for slot = ITEM_1,ITEM_6 do
    local id = myHero:GetItemData(slot).itemID 
    if id > 0 then
      items[id] = slot
    end
    end
    
    local Tiamat = items[3077]
    local TitanicHydra = items[3748]
    
   
    local TiamatTarget = GetTarget(400)
    if Tiamat and Ready(Tiamat) and TiamatTarget and SSUtil.Combo.Tiamat:Value() and PostAttack then
        Control.CastSpell(HKITEM[Tiamat], TiamatTarget)
    end
  
    local TitanicHydraTarget = GetTarget(400)
    if TitanicHydra and Ready(TitanicHydra) and TitanicHydraTarget and SSUtil.Combo.TitanicHydra:Value() and PostAttack then
        Control.CastSpell(HKITEM[TitanicHydra], TitanicHydraTarget)
    end

    local ExistIgnite = ExistSpell("SummonerDot")
    local IgniteSlot = SummonerSlot("SummonerDot")
    local IgniteTarget = GetTarget(600)
    if ExistIgnite and Ready(IgniteSlot) and IgniteTarget and SSUtil.Combo.Ignite:Value() then
        Control.CastSpell(HKSPELL[IgniteSlot], IgniteTarget)
    end
    local ExistExhaust = ExistSpell("SummonerExhaust")
    local ExhaustSlot = SummonerSlot("SummonerExhaust")
    local ExhaustTarget = GetTarget(650)
    if ExistExhaust and Ready(ExhaustSlot) and ExhaustTarget and SSUtil.Combo.Exhaust:Value() then
        Control.CastSpell(HKSPELL[ExhaustSlot], ExhaustTarget)
    end
    local ExistSmite = ExistSpell("S5_SummonerSmitePlayerGanker") or ExistSpell("S5_SummonerSmiteDuel")
    local SmiteSlot = SummonerSlot("S5_SummonerSmitePlayerGanker") or SummonerSlot("S5_SummonerSmiteDuel")
    local SmiteTarget = GetTarget(500 + myHero.boundingRadius)
    if ExistSmite and Ready(SmiteSlot) and IsUp(SmiteSlot) and SmiteTarget and SSUtil.Combo.Smite:Value() then
        Control.CastSpell(HKSPELL[SmiteSlot], SmiteTarget)
    end
end

function Utility:Heal()
    local items = {}
  for slot = ITEM_1,ITEM_6 do
    local id = myHero:GetItemData(slot).itemID 
    if id > 0 then
      items[id] = slot
    end
    end
    local CorruptingPotion = items[2033]
    local HealthPotion = items[2003]
    local HuntersPotion = items[2032]
    local RefillablePotion = items[2031]
    local ManaPotion = items[2004]
    local PilferedHealthPotion = items[2061]
    local TotalBiscuitofEverlastingWill = items[2010]
    local Redemption = items[3107] or items[3382]

    local RedemptionAlly = ClosestInjuredHero(5500,friend,SSUtil.Heal.HP1:Value(),true)
    if Redemption and Ready(Redemption) and RedemptionAlly and HeroesAround(1500,RedemptionAlly.pos) ~= 0 and SSUtil.Heal.Redemption:Value() then
        Control.CastSpell(HKITEM[Redemption], RedemptionAlly)
    end

    local ExistHeal = ExistSpell("SummonerHeal")
    local HealSlot = SummonerSlot("SummonerHeal")
    local HealTarget = ClosestHero(1500,foe)
    if ExistHeal and Ready(HealSlot) and HealTarget and SSUtil.Heal.Heal:Value() and Hp() < SSUtil.Heal.HPS1:Value() then
        Control.CastSpell(HKSPELL[HealSlot])
    end

    if BuffByType(13,0.1) then return end

    local CorruptingPotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if CorruptingPotion and Ready(CorruptingPotion) and CorruptingPotionTarget and SSUtil.Potion.CorruptingPotion:Value() and (Hp() < SSUtil.Potion.HP1:Value() or Mp() < SSUtil.Potion.MP1:Value()) then
        Control.CastSpell(HKITEM[CorruptingPotion])
    end
    local HealthPotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if HealthPotion and Ready(HealthPotion) and HealthPotionTarget and SSUtil.Potion.HealthPotion:Value() and Hp() < SSUtil.Potion.HP2:Value() then
        Control.CastSpell(HKITEM[HealthPotion])
    end
    local HuntersPotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if HuntersPotion and Ready(HuntersPotion) and HuntersPotionTarget and SSUtil.Potion.HuntersPotion:Value() and (Hp() < SSUtil.Potion.HP3:Value() or Mp() < SSUtil.Potion.MP3:Value()) then
        Control.CastSpell(HKITEM[HuntersPotion])
    end
    local RefillablePotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if RefillablePotion and Ready(RefillablePotion) and RefillablePotionTarget and SSUtil.Potion.RefillablePotion:Value() and Hp() < SSUtil.Potion.HP4:Value() then
        Control.CastSpell(HKITEM[RefillablePotion])
    end
    local ManaPotionTarget = ClosestHero(1500,foe)
    if ManaPotion and Ready(ManaPotion) and ManaPotionTarget and SSUtil.Potion.ManaPotion:Value() and Mp() < SSUtil.Potion.MP5:Value() then
        Control.CastSpell(HKITEM[ManaPotion])
    end
    local PilferedHealthPotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if PilferedHealthPotion and Ready(PilferedHealthPotion) and PilferedHealthPotionTarget and SSUtil.Potion.PilferedHealthPotion:Value() and Hp() < SSUtil.Potion.HP6:Value() then
        Control.CastSpell(HKITEM[PilferedHealthPotion])
    end
    local TotalBiscuitofEverlastingWillTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if TotalBiscuitofEverlastingWill and Ready(TotalBiscuitofEverlastingWill) and TotalBiscuitofEverlastingWillTarget and SSUtil.Potion.TotalBiscuitofEverlastingWill:Value() and (Hp() < SSUtil.Potion.HP7:Value() or Mp() < SSUtil.Potion.MP7:Value()) then
        Control.CastSpell(HKITEM[TotalBiscuitofEverlastingWill])
    end
end
