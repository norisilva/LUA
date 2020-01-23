
class "Utility"

require('HPred')
require('SS_Common')

function Utility:__init()
  self:Menu()
  Callback.Add("Tick", function() self:Tick() end)
end

function Utility:Menu()
    Vaper = MenuElement({type = MENU, id = "Vaper", name = "Rugal Vaper - Activator"})

    Vaper:MenuElement({id = "Enable", name = "Enable Activator", value = true})

    Vaper:MenuElement({type = MENU, id = "Potion", name = "Potion"})
    Vaper.Potion:MenuElement({id = "CorruptingPotion", name = "Corrupting Potion", value = true})
    Vaper.Potion:MenuElement({id = "HP1", name = "Health % to Potion", value = 60, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "MP1", name = "Mana % to Potion", value = 25, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "HealthPotion", name = "Health Potion", value = true})
    Vaper.Potion:MenuElement({id = "HP2", name = "Health % to Potion", value = 60, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "HuntersPotion", name = "Hunter's Potion", value = true})
    Vaper.Potion:MenuElement({id = "HP3", name = "Health % to Potion", value = 60, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "MP3", name = "Mana % to Potion", value = 25, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "RefillablePotion", name = "Refillable Potion", value = true})
    Vaper.Potion:MenuElement({id = "HP4", name = "Health % to Potion", value = 60, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "ManaPotion", name = "Mana Potion", value = true})
    Vaper.Potion:MenuElement({id = "MP5", name = "Mana % to Potion", value = 25, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "PilferedHealthPotion", name = "Pilfered Health Potion", value = true})
    Vaper.Potion:MenuElement({id = "HP6", name = "Health % to Potion", value = 60, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "TotalBiscuitofEverlastingWill", name = "Total Biscuit of Everlasting Will", value = true})
    Vaper.Potion:MenuElement({id = "HP7", name = "Health % to Potion", value = 60, min = 0, max = 100})
    Vaper.Potion:MenuElement({id = "MP7", name = "Mana % to Potion", value = 25, min = 0, max = 100})
    
    Vaper:MenuElement({type = MENU, id = "Combo", name = "Combo"})
    Vaper.Combo:MenuElement({id = "Ignite", name = "Ignite", value = true})
    Vaper.Combo:MenuElement({id = "Smite", name = "Smite", value = true})
    Vaper.Combo:MenuElement({id = "Exhaust", name = "Exhaust", value = true})
    Vaper.Combo:MenuElement({id = " ", name = " ", type = SPACE})
    Vaper.Combo:MenuElement({id = "BilgewaterCutlass", name = "Bilgewater Cutlass", value = true})
    Vaper.Combo:MenuElement({id = "Tiamat", name = "Tiamat", value = true})
    Vaper.Combo:MenuElement({id = "BladeoftheRuinedKing", name = "Blade of the Ruined King", value = true})
    Vaper.Combo:MenuElement({id = "HextechGLP800", name = "Hextech GLP-800", value = true})
    Vaper.Combo:MenuElement({id = "HextechGunblade", name = "Hextech Gunblade", value = true})
    Vaper.Combo:MenuElement({id = "HextechProtobelt01", name = "Hextech Protobelt-01", value = true})
    Vaper.Combo:MenuElement({id = "RanduinsOmen", name = "Randuin's Omen", value = true})
    Vaper.Combo:MenuElement({id = "RavenousHydra", name = "Ravenous Hydra", value = true})
    Vaper.Combo:MenuElement({id = "Spellbinder", name = "Spellbinder", value = true})
    Vaper.Combo:MenuElement({id = "TitanicHydra", name = "Titanic Hydra", value = true})

    Vaper:MenuElement({type = MENU, id = "Harass", name = "Harass"})
    Vaper.Harass:MenuElement({id = "Ignite", name = "Ignite", value = true})
    Vaper.Harass:MenuElement({id = "Smite", name = "Smite", value = true})
    Vaper.Harass:MenuElement({id = "Exhaust", name = "Exhaust", value = true})
    Vaper.Harass:MenuElement({id = " ", name = " ", type = SPACE})
    Vaper.Harass:MenuElement({id = "BilgewaterCutlass", name = "Bilgewater Cutlass", value = true})
    Vaper.Harass:MenuElement({id = "Tiamat", name = "Tiamat", value = true})
    Vaper.Harass:MenuElement({id = "BladeoftheRuinedKing", name = "Blade of the Ruined King", value = true})
    Vaper.Harass:MenuElement({id = "HextechGLP800", name = "Hextech GLP-800", value = true})
    Vaper.Harass:MenuElement({id = "HextechGunblade", name = "Hextech Gunblade", value = true})
    Vaper.Harass:MenuElement({id = "HextechProtobelt01", name = "Hextech Protobelt-01", value = true})
    Vaper.Harass:MenuElement({id = "RanduinsOmen", name = "Randuin's Omen", value = true})
    Vaper.Harass:MenuElement({id = "RavenousHydra", name = "Ravenous Hydra", value = true})
    Vaper.Harass:MenuElement({id = "Spellbinder", name = "Spellbinder", value = true})
    Vaper.Harass:MenuElement({id = "TitanicHydra", name = "Titanic Hydra", value = true})

    Vaper:MenuElement({type = MENU, id = "Clear", name = "Clear"})
    Vaper.Clear:MenuElement({id = "Tiamat", name = "Tiamat", value = true})
    Vaper.Clear:MenuElement({id = "HextechGLP800", name = "Hextech GLP-800", value = true})
    Vaper.Clear:MenuElement({id = "HextechProtobelt01", name = "Hextech Protobelt-01", value = true})
    Vaper.Clear:MenuElement({id = "RavenousHydra", name = "Ravenous Hydra", value = true})
    Vaper.Clear:MenuElement({id = "TitanicHydra", name = "Titanic Hydra", value = true})

    Vaper:MenuElement({type = MENU, id = "Flee", name = "Flee"})
    Vaper.Flee:MenuElement({id = "Exhaust", name = "Exhaust", value = true})
    Vaper.Flee:MenuElement({id = " ", name = " ", type = SPACE})
    Vaper.Flee:MenuElement({id = "BilgewaterCutlass", name = "Bilgewater Cutlass", value = true})
    Vaper.Flee:MenuElement({id = "BladeoftheRuinedKing", name = "Blade of the Ruined King", value = true})
    Vaper.Flee:MenuElement({id = "HextechGLP800", name = "Hextech GLP-800", value = true})
    Vaper.Flee:MenuElement({id = "HextechGunblade", name = "Hextech Gunblade", value = true})
    Vaper.Flee:MenuElement({id = "HextechProtobelt01", name = "Hextech Protobelt-01", value = true})
    Vaper.Flee:MenuElement({id = "RanduinsOmen", name = "Randuin's Omen", value = true})
    Vaper.Flee:MenuElement({id = "RighteousGlory", name = "Righteous Glory", value = true})
    Vaper.Flee:MenuElement({id = "TwinShadows", name = "Twin Shadows", value = true})
    Vaper.Flee:MenuElement({id = "YoumuusGhostblade", name = "Youmuu's Ghostblade", value = true})

    Vaper:MenuElement({type = MENU, id = "Shield", name = "Shield"})
    Vaper.Shield:MenuElement({id = "Barrier", name = "Barrier", value = true})
    Vaper.Shield:MenuElement({id = "HPS1", name = "Health % to Shield", value = 15, min = 0, max = 100})
    Vaper.Shield:MenuElement({id = " ", name = " ", type = SPACE})
    Vaper.Shield:MenuElement({id = "Stopwatch", name = "Stopwatch", value = true})
    Vaper.Shield:MenuElement({id = "HP1", name = "Health % to Shield", value = 15, min = 0, max = 100})
    Vaper.Shield:MenuElement({id = "GargoyleStoneplate", name = "Gargoyle Stoneplate", value = true})
    Vaper.Shield:MenuElement({id = "HP2", name = "Health % to Shield", value = 15, min = 0, max = 100})
    Vaper.Shield:MenuElement({id = "LocketoftheIronSolari", name = "Locket of the Iron Solari", value = true})
    Vaper.Shield:MenuElement({id = "HP3", name = "Health % to Shield", value = 15, min = 0, max = 100})
    Vaper.Shield:MenuElement({id = "SeraphsEmbrace", name = "Seraph's Embrace", value = true})
    Vaper.Shield:MenuElement({id = "HP4", name = "Health % to Shield", value = 15, min = 0, max = 100})
    Vaper.Shield:MenuElement({id = "WoogletsWitchcap", name = "Wooglet's Witchcap", value = true})
    Vaper.Shield:MenuElement({id = "HP5", name = "Health % to Shield", value = 15, min = 0, max = 100})
    Vaper.Shield:MenuElement({id = "ZhonyasHourglass", name = "Zhonya's Hourglass", value = true})
    Vaper.Shield:MenuElement({id = "HP6", name = "Health % to Shield", value = 15, min = 0, max = 100})

    Vaper:MenuElement({type = MENU, id = "Heal", name = "Heal"})
    Vaper.Heal:MenuElement({id = "Heal", name = "Heal", value = true})
    Vaper.Heal:MenuElement({id = "HPS1", name = "Health % to Heal", value = 15, min = 0, max = 100})
    Vaper.Heal:MenuElement({id = " ", name = " ", type = SPACE})
    Vaper.Heal:MenuElement({id = "Redemption", name = "Redemption", value = true})
    Vaper.Heal:MenuElement({id = "HP1", name = "Health % to Heal", value = 15, min = 0, max = 100})

    Vaper:MenuElement({type = MENU, id = "Auto", name = "Auto"})
    Vaper.Auto:MenuElement({id = "Ignite", name = "Ignite", value = true})

    Vaper:MenuElement({type = MENU, id = "Cleanse", name = "Cleanse"})
    Vaper.Cleanse:MenuElement({id = "Cleanse", name = "Cleanse", value = true})
    Vaper.Cleanse:MenuElement({id = "DS1", name = "Duration to Cleanse", value = 1, min = .1, max = 5, step = .1})
    Vaper.Cleanse:MenuElement({id = " ", name = " ", type = SPACE})
    Vaper.Cleanse:MenuElement({id = "QuicksilverSash", name = "Quicksilver Sash", value = true})
    Vaper.Cleanse:MenuElement({id = "D1", name = "Duration to Cleanse", value = 1, min = .1, max = 5, step = .1})
    Vaper.Cleanse:MenuElement({id = "MercurialScimitar", name = "Mercurial Scimitar", value = true})
    Vaper.Cleanse:MenuElement({id = "D2", name = "Duration to Cleanse", value = 1, min = .1, max = 5, step = .1})
    Vaper.Cleanse:MenuElement({id = "MikaelsCrucible", name = "Mikael's Crucible", value = true})
    Vaper.Cleanse:MenuElement({id = "D3", name = "Duration to Cleanse", value = 1, min = .1, max = 5, step = .1})
    Vaper.Cleanse:MenuElement({id = " ", name = " ", type = SPACE})
    Vaper.Cleanse:MenuElement({id = "Stun", name = "Stun", value = true})
    Vaper.Cleanse:MenuElement({id = "Root", name = "Root", value = true})
    Vaper.Cleanse:MenuElement({id = "Taunt", name = "Taunt", value = true})
    Vaper.Cleanse:MenuElement({id = "Fear", name = "Fear", value = true})
    Vaper.Cleanse:MenuElement({id = "Charm", name = "Charm", value = true})
    Vaper.Cleanse:MenuElement({id = "Silence", name = "Silence", value = true})
    Vaper.Cleanse:MenuElement({id = "Slow", name = "Slow", value = true})
    Vaper.Cleanse:MenuElement({id = "Blind", name = "Blind", value = true})
    Vaper.Cleanse:MenuElement({id = "Disarm", name = "Disarm", value = true})
    Vaper.Cleanse:MenuElement({id = "Sleep", name = "Sleep", value = true})
    Vaper.Cleanse:MenuElement({id = "Nearsight", name = "Nearsight", value = true})
    Vaper.Cleanse:MenuElement({id = "Suppression", name = "Suppression", value = true})
end

function Utility:Tick()
    if not Vaper.Enable:Value() then return end
    self:Auto()
    self:Cleanse()
    self:Shield()
    self:Heal()
    local mode = GetMode()
    if mode == "Combo" then
        self:Combo()
    end
    if mode == "Harass" then
        self:Harass()
    end
    if mode == "Clear" then
        self:Clear()
    end
    if mode == "Flee" then
        self:Flee()
    end
end

function Utility:Auto()
    local ExistIgnite = ExistSpell("SummonerDot")
    local IgniteSlot = SummonerSlot("SummonerDot")
    local IgniteDamage = 70 + 20 * myHero.levelData.lvl
    local IgniteTarget = ClosestHero(600,foe)
    if ExistIgnite and Ready(IgniteSlot) and IgniteTarget and Vaper.Auto.Ignite:Value() then
        if IgniteDamage > IgniteTarget.health then
            Control.CastSpell(HKSPELL[IgniteSlot], IgniteTarget)
        end
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
    local BilgewaterCutlass = items[3144]
    local Tiamat = items[3077]
    local BladeoftheRuinedKing = items[3153]
    local HextechGLP800 = items[3030]
    local HextechGunblade = items[3146]
    local HextechProtobelt01 = items[3152]
    local RanduinsOmen = items[3143]
    local RavenousHydra = items[3074]
    local Spellbinder = items[3907]
    local TitanicHydra = items[3748]
    
    local BilgewaterCutlassTarget = GetTarget(550)
    if BilgewaterCutlass and Ready(BilgewaterCutlass) and BilgewaterCutlassTarget and Vaper.Combo.BilgewaterCutlass:Value() then
        Control.CastSpell(HKITEM[BilgewaterCutlass], BilgewaterCutlassTarget)
    end
    local TiamatTarget = GetTarget(400)
    if Tiamat and Ready(Tiamat) and TiamatTarget and Vaper.Combo.Tiamat:Value() and PostAttack then
        Control.CastSpell(HKITEM[Tiamat], TiamatTarget)
    end
    local BladeoftheRuinedKingTarget = GetTarget(550)
    if BladeoftheRuinedKing and Ready(BladeoftheRuinedKing) and BladeoftheRuinedKingTarget and Vaper.Combo.BladeoftheRuinedKing:Value() then
        Control.CastSpell(HKITEM[BladeoftheRuinedKing], BladeoftheRuinedKingTarget)
    end
    local HextechGLP800Target = GetTarget(700)
    if HextechGLP800 and Ready(HextechGLP800) and HextechGLP800Target and Vaper.Combo.HextechGLP800:Value() then
        Control.CastSpell(HKITEM[HextechGLP800], HextechGLP800Target)
    end
    local HextechGunbladeTarget = GetTarget(700)
    if HextechGunblade and Ready(HextechGunblade) and HextechGunbladeTarget and Vaper.Combo.HextechGunblade:Value() then
        Control.CastSpell(HKITEM[HextechGunblade], HextechGunbladeTarget)
    end
    local HextechProtobelt01Target = GetTarget(700)
    if HextechProtobelt01 and Ready(HextechProtobelt01) and HextechProtobelt01Target and Vaper.Combo.HextechProtobelt01:Value() then
        Control.CastSpell(HKITEM[HextechProtobelt01], HextechProtobelt01Target)
    end
    local RanduinsOmenTarget = GetTarget(500)
    if RanduinsOmen and Ready(RanduinsOmen) and RanduinsOmenTarget and Vaper.Combo.RanduinsOmen:Value() then
        Control.CastSpell(HKITEM[RanduinsOmen])
    end
    local RavenousHydraTarget = GetTarget(400)
    if RavenousHydra and Ready(RavenousHydra) and RavenousHydraTarget and Vaper.Combo.RavenousHydra:Value() and PostAttack then
        Control.CastSpell(HKITEM[RavenousHydra], RavenousHydraTarget)
    end
    local SpellbinderTarget = GetTarget(900)
    if Spellbinder and Ready(Spellbinder) and SpellbinderTarget and Vaper.Combo.Spellbinder:Value() then
        Control.CastSpell(HKITEM[Spellbinder])
    end
    local TitanicHydraTarget = GetTarget(400)
    if TitanicHydra and Ready(TitanicHydra) and TitanicHydraTarget and Vaper.Combo.TitanicHydra:Value() and PostAttack then
        Control.CastSpell(HKITEM[TitanicHydra], TitanicHydraTarget)
    end

    local ExistIgnite = ExistSpell("SummonerDot")
    local IgniteSlot = SummonerSlot("SummonerDot")
    local IgniteTarget = GetTarget(600)
    if ExistIgnite and Ready(IgniteSlot) and IgniteTarget and Vaper.Combo.Ignite:Value() then
        Control.CastSpell(HKSPELL[IgniteSlot], IgniteTarget)
    end
    local ExistExhaust = ExistSpell("SummonerExhaust")
    local ExhaustSlot = SummonerSlot("SummonerExhaust")
    local ExhaustTarget = GetTarget(650)
    if ExistExhaust and Ready(ExhaustSlot) and ExhaustTarget and Vaper.Combo.Exhaust:Value() then
        Control.CastSpell(HKSPELL[ExhaustSlot], ExhaustTarget)
    end
    local ExistSmite = ExistSpell("S5_SummonerSmitePlayerGanker") or ExistSpell("S5_SummonerSmiteDuel")
    local SmiteSlot = SummonerSlot("S5_SummonerSmitePlayerGanker") or SummonerSlot("S5_SummonerSmiteDuel")
    local SmiteTarget = GetTarget(500 + myHero.boundingRadius)
    if ExistSmite and Ready(SmiteSlot) and IsUp(SmiteSlot) and SmiteTarget and Vaper.Combo.Smite:Value() then
        Control.CastSpell(HKSPELL[SmiteSlot], SmiteTarget)
    end
end

function Utility:Harass()
    local PostAttack = myHero.attackData.state == STATE_WINDDOWN
    local items = {}
  for slot = ITEM_1,ITEM_6 do
    local id = myHero:GetItemData(slot).itemID 
    if id > 0 then
      items[id] = slot
    end
    end
    local BilgewaterCutlass = items[3144]
    local Tiamat = items[3077]
    local BladeoftheRuinedKing = items[3153]
    local HextechGLP800 = items[3030]
    local HextechGunblade = items[3146]
    local HextechProtobelt01 = items[3152]
    local RanduinsOmen = items[3143]
    local RavenousHydra = items[3074]
    local Spellbinder = items[3907]
    local TitanicHydra = items[3748]
    
    local BilgewaterCutlassTarget = GetTarget(550)
    if BilgewaterCutlass and Ready(BilgewaterCutlass) and BilgewaterCutlassTarget and Vaper.Harass.BilgewaterCutlass:Value() then
        Control.CastSpell(HKITEM[BilgewaterCutlass], BilgewaterCutlassTarget)
    end
    local TiamatTarget = GetTarget(400)
    if Tiamat and Ready(Tiamat) and TiamatTarget and Vaper.Harass.Tiamat:Value() and PostAttack then
        Control.CastSpell(HKITEM[Tiamat], TiamatTarget)
    end
    local BladeoftheRuinedKingTarget = GetTarget(550)
    if BladeoftheRuinedKing and Ready(BladeoftheRuinedKing) and BladeoftheRuinedKingTarget and Vaper.Harass.BladeoftheRuinedKing:Value() then
        Control.CastSpell(HKITEM[BladeoftheRuinedKing], BladeoftheRuinedKingTarget)
    end
    local HextechGLP800Target = GetTarget(700)
    if HextechGLP800 and Ready(HextechGLP800) and HextechGLP800Target and Vaper.Harass.HextechGLP800:Value() then
        Control.CastSpell(HKITEM[HextechGLP800], HextechGLP800Target)
    end
    local HextechGunbladeTarget = GetTarget(700)
    if HextechGunblade and Ready(HextechGunblade) and HextechGunbladeTarget and Vaper.Harass.HextechGunblade:Value() then
        Control.CastSpell(HKITEM[HextechGunblade], HextechGunbladeTarget)
    end
    local HextechProtobelt01Target = GetTarget(700)
    if HextechProtobelt01 and Ready(HextechProtobelt01) and HextechProtobelt01Target and Vaper.Harass.HextechProtobelt01:Value() then
        Control.CastSpell(HKITEM[HextechProtobelt01], HextechProtobelt01Target)
    end
    local RanduinsOmenTarget = GetTarget(500)
    if RanduinsOmen and Ready(RanduinsOmen) and RanduinsOmenTarget and Vaper.Harass.RanduinsOmen:Value() then
        Control.CastSpell(HKITEM[RanduinsOmen])
    end
    local RavenousHydraTarget = GetTarget(400)
    if RavenousHydra and Ready(RavenousHydra) and RavenousHydraTarget and Vaper.Harass.RavenousHydra:Value() and PostAttack then
        Control.CastSpell(HKITEM[RavenousHydra], RavenousHydraTarget)
    end
    local SpellbinderTarget = GetTarget(900)
    if Spellbinder and Ready(Spellbinder) and SpellbinderTarget and Vaper.Harass.Spellbinder:Value() then
        Control.CastSpell(HKITEM[Spellbinder])
    end
    local TitanicHydraTarget = GetTarget(400)
    if TitanicHydra and Ready(TitanicHydra) and TitanicHydraTarget and Vaper.Harass.TitanicHydra:Value() and PostAttack then
        Control.CastSpell(HKITEM[TitanicHydra], TitanicHydraTarget)
    end

    local ExistIgnite = ExistSpell("SummonerDot")
    local IgniteSlot = SummonerSlot("SummonerDot")
    local IgniteTarget = GetTarget(600)
    if ExistIgnite and Ready(IgniteSlot) and IgniteTarget and Vaper.Harass.Ignite:Value() then
        Control.CastSpell(HKSPELL[IgniteSlot], IgniteTarget)
    end
    local ExistExhaust = ExistSpell("SummonerExhaust")
    local ExhaustSlot = SummonerSlot("SummonerExhaust")
    local ExhaustTarget = GetTarget(650)
    if ExistExhaust and Ready(ExhaustSlot) and ExhaustTarget and Vaper.Harass.Exhaust:Value() then
        Control.CastSpell(HKSPELL[ExhaustSlot], ExhaustTarget)
    end
    local ExistSmite = ExistSpell("S5_SummonerSmitePlayerGanker") or ExistSpell("S5_SummonerSmiteDuel")
    local SmiteSlot = SummonerSlot("S5_SummonerSmitePlayerGanker") or SummonerSlot("S5_SummonerSmiteDuel")
    local SmiteTarget = GetTarget(500 + myHero.boundingRadius)
    if ExistSmite and Ready(SmiteSlot) and IsUp(SmiteSlot) and SmiteTarget and Vaper.Harass.Smite:Value() then
        Control.CastSpell(HKSPELL[SmiteSlot], SmiteTarget)
    end
end

function Utility:Clear()
    local PostAttack = myHero.attackData.state == STATE_WINDDOWN
    local items = {}
  for slot = ITEM_1,ITEM_6 do
    local id = myHero:GetItemData(slot).itemID 
    if id > 0 then
      items[id] = slot
    end
    end
    local Tiamat = items[3077]
    local HextechGLP800 = items[3030]
    local HextechProtobelt01 = items[3152]
    local RavenousHydra = items[3074]
    local TitanicHydra = items[3748]

    local TiamatTarget = GetClearMinion(400)
    if Tiamat and Ready(Tiamat) and TiamatTarget and Vaper.Clear.Tiamat:Value() and PostAttack then
        Control.CastSpell(HKITEM[Tiamat], TiamatTarget)
    end
    local HextechGLP800Target = GetClearMinion(700)
    if HextechGLP800 and Ready(HextechGLP800) and HextechGLP800Target and Vaper.Clear.HextechGLP800:Value() then
        Control.CastSpell(HKITEM[HextechGLP800], HextechGLP800Target)
    end
    local HextechProtobelt01Target = GetClearMinion(700)
    if HextechProtobelt01 and Ready(HextechProtobelt01) and HextechProtobelt01Target and Vaper.Clear.HextechProtobelt01:Value() then
        Control.CastSpell(HKITEM[HextechProtobelt01], HextechProtobelt01Target)
    end
    local RavenousHydraTarget = GetClearMinion(400)
    if RavenousHydra and Ready(RavenousHydra) and RavenousHydraTarget and Vaper.Clear.RavenousHydra:Value() and PostAttack then
        Control.CastSpell(HKITEM[RavenousHydra], RavenousHydraTarget)
    end
    local TitanicHydraTarget = GetClearMinion(400)
    if TitanicHydra and Ready(TitanicHydra) and TitanicHydraTarget and Vaper.Clear.TitanicHydra:Value() and PostAttack then
        Control.CastSpell(HKITEM[TitanicHydra], TitanicHydraTarget)
    end
end

function Utility:Flee()
    local items = {}
  for slot = ITEM_1,ITEM_6 do
    local id = myHero:GetItemData(slot).itemID 
    if id > 0 then
      items[id] = slot
    end
    end
    local BilgewaterCutlass = items[3144]
    local BladeoftheRuinedKing = items[3153]
    local HextechGLP800 = items[3030]
    local HextechGunblade = items[3146]
    local HextechProtobelt01 = items[3152]
    local RanduinsOmen = items[3143]
    local RighteousGlory = items[3800]
    local ShurelyasReverie = items[2056]
    local TwinShadows = items[3905]
    local YoumuusGhostblade = items[3142]

    local BilgewaterCutlassTarget = ClosestHero(550,foe)
    if BilgewaterCutlass and Ready(BilgewaterCutlass) and BilgewaterCutlassTarget and Vaper.Flee.BilgewaterCutlass:Value() then
        Control.CastSpell(HKITEM[BilgewaterCutlass], BilgewaterCutlassTarget)
    end
    local BladeoftheRuinedKingTarget = ClosestHero(550,foe)
    if BladeoftheRuinedKing and Ready(BladeoftheRuinedKing) and BladeoftheRuinedKingTarget and Vaper.Flee.BladeoftheRuinedKing:Value() then
        Control.CastSpell(HKITEM[BladeoftheRuinedKing], BladeoftheRuinedKingTarget)
    end
    local HextechGLP800Target = ClosestHero(700,foe)
    if HextechGLP800 and Ready(HextechGLP800) and HextechGLP800Target and Vaper.Flee.HextechGLP800:Value() then
        Control.CastSpell(HKITEM[HextechGLP800], HextechGLP800Target)
    end
    local HextechGunbladeTarget = ClosestHero(700,foe)
    if HextechGunblade and Ready(HextechGunblade) and HextechGunbladeTarget and Vaper.Flee.HextechGunblade:Value() then
        Control.CastSpell(HKITEM[HextechGunblade], HextechGunbladeTarget)
    end
    if HextechProtobelt01 and Ready(HextechProtobelt01) and Vaper.Flee.HextechProtobelt01:Value() then
        Control.CastSpell(HKITEM[HextechProtobelt01], Game.cursorPos())
    end
    local RanduinsOmenTarget = ClosestHero(500,foe)
    if RanduinsOmen and Ready(RanduinsOmen) and RanduinsOmenTarget and Vaper.Flee.RanduinsOmen:Value() then
        Control.CastSpell(HKITEM[RanduinsOmen])
    end
    if RighteousGlory and Ready(RighteousGlory) and Vaper.Flee.RighteousGlory:Value() then
        Control.CastSpell(HKITEM[RighteousGlory])
    end
    local TwinShadowsTarget = ClosestHero(1500,foe)
    if TwinShadows and Ready(TwinShadows) and TwinShadowsTarget and Vaper.Flee.TwinShadows:Value() then
        Control.CastSpell(HKITEM[TwinShadows])
    end
    if YoumuusGhostblade and Ready(YoumuusGhostblade) and Vaper.Flee.YoumuusGhostblade:Value() then
        Control.CastSpell(HKITEM[YoumuusGhostblade])
    end

    local ExistExhaust = ExistSpell("SummonerExhaust")
    local ExhaustSlot = SummonerSlot("SummonerExhaust")
    local ExhaustTarget = GetTarget(650)
    if ExistExhaust and Ready(ExhaustSlot) and ExhaustTarget and Vaper.Flee.Exhaust:Value() then
        Control.CastSpell(HKSPELL[ExhaustSlot], ExhaustTarget)
    end
end

function Utility:Shield()
    local items = {}
  for slot = ITEM_1,ITEM_6 do
    local id = myHero:GetItemData(slot).itemID 
    if id > 0 then
      items[id] = slot
    end
    end
    local Stopwatch = items[2420] or items[2423]
    local GargoyleStoneplate = items[3193]
    local LocketoftheIronSolari = items[3190] or items[3383]
    local SeraphsEmbrace = items[3040] or items[3048]
    local WoogletsWitchcap = items[3090] or items[3385]
    local ZhonyasHourglass = items[3157] or items[3386]

    local StopwatchTarget = ClosestHero(700,foe)
    if Stopwatch and Ready(Stopwatch) and StopwatchTarget and Vaper.Shield.Stopwatch:Value() and Hp() < Vaper.Shield.HP1:Value() then
        Control.CastSpell(HKITEM[Stopwatch])
    end
    local GargoyleStoneplateTarget = ClosestHero(1500,foe)
    if GargoyleStoneplate and Ready(GargoyleStoneplate) and GargoyleStoneplateTarget and Vaper.Shield.GargoyleStoneplate:Value() and Hp() < Vaper.Shield.HP2:Value() then
        Control.CastSpell(HKITEM[GargoyleStoneplate])
    end
    local LocketoftheIronSolariAlly = ClosestInjuredHero(600,friend,Vaper.Shield.HP3:Value(),true)
    if LocketoftheIronSolari and Ready(LocketoftheIronSolari) and LocketoftheIronSolariAlly and HeroesAround(1500,LocketoftheIronSolariAlly.pos) ~= 0 and Vaper.Shield.LocketoftheIronSolari:Value() then
        Control.CastSpell(HKITEM[LocketoftheIronSolari])
    end
    local SeraphsEmbraceTarget = ClosestHero(1500,foe)
    if SeraphsEmbrace and Ready(SeraphsEmbrace) and SeraphsEmbraceTarget and Vaper.Shield.SeraphsEmbrace:Value() and Hp() < Vaper.Shield.HP4:Value() then
        Control.CastSpell(HKITEM[SeraphsEmbrace])
    end
    local WoogletsWitchcapTarget = ClosestHero(700,foe)
    if WoogletsWitchcap and Ready(WoogletsWitchcap) and WoogletsWitchcapTarget and Vaper.Shield.WoogletsWitchcap:Value() and Hp() < Vaper.Shield.HP5:Value() then
        Control.CastSpell(HKITEM[WoogletsWitchcap])
    end
    local ZhonyasHourglassTarget = ClosestHero(700,foe)
    if ZhonyasHourglass and Ready(ZhonyasHourglass) and ZhonyasHourglassTarget and Vaper.Shield.ZhonyasHourglass:Value() and Hp() < Vaper.Shield.HP6:Value() then
        Control.CastSpell(HKITEM[ZhonyasHourglass])
    end

    local ExistBarrier = ExistSpell("SummonerBarrier")
    local BarrierSlot = SummonerSlot("SummonerBarrier")
    local BarrierTarget = ClosestHero(1500,foe)
    if ExistBarrier and Ready(BarrierSlot) and BarrierTarget and Vaper.Shield.Barrier:Value() and Hp() < Vaper.Shield.HPS1:Value() then
        Control.CastSpell(HKSPELL[BarrierSlot])
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

    local RedemptionAlly = ClosestInjuredHero(5500,friend,Vaper.Heal.HP1:Value(),true)
    if Redemption and Ready(Redemption) and RedemptionAlly and HeroesAround(1500,RedemptionAlly.pos) ~= 0 and Vaper.Heal.Redemption:Value() then
        Control.CastSpell(HKITEM[Redemption], RedemptionAlly)
    end

    local ExistHeal = ExistSpell("SummonerHeal")
    local HealSlot = SummonerSlot("SummonerHeal")
    local HealTarget = ClosestHero(1500,foe)
    if ExistHeal and Ready(HealSlot) and HealTarget and Vaper.Heal.Heal:Value() and Hp() < Vaper.Heal.HPS1:Value() then
        Control.CastSpell(HKSPELL[HealSlot])
    end

    if BuffByType(13,0.1) then return end

    local CorruptingPotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if CorruptingPotion and Ready(CorruptingPotion) and CorruptingPotionTarget and Vaper.Potion.CorruptingPotion:Value() and (Hp() < Vaper.Potion.HP1:Value() or Mp() < Vaper.Potion.MP1:Value()) then
        Control.CastSpell(HKITEM[CorruptingPotion])
    end
    local HealthPotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if HealthPotion and Ready(HealthPotion) and HealthPotionTarget and Vaper.Potion.HealthPotion:Value() and Hp() < Vaper.Potion.HP2:Value() then
        Control.CastSpell(HKITEM[HealthPotion])
    end
    local HuntersPotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if HuntersPotion and Ready(HuntersPotion) and HuntersPotionTarget and Vaper.Potion.HuntersPotion:Value() and (Hp() < Vaper.Potion.HP3:Value() or Mp() < Vaper.Potion.MP3:Value()) then
        Control.CastSpell(HKITEM[HuntersPotion])
    end
    local RefillablePotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if RefillablePotion and Ready(RefillablePotion) and RefillablePotionTarget and Vaper.Potion.RefillablePotion:Value() and Hp() < Vaper.Potion.HP4:Value() then
        Control.CastSpell(HKITEM[RefillablePotion])
    end
    local ManaPotionTarget = ClosestHero(1500,foe)
    if ManaPotion and Ready(ManaPotion) and ManaPotionTarget and Vaper.Potion.ManaPotion:Value() and Mp() < Vaper.Potion.MP5:Value() then
        Control.CastSpell(HKITEM[ManaPotion])
    end
    local PilferedHealthPotionTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if PilferedHealthPotion and Ready(PilferedHealthPotion) and PilferedHealthPotionTarget and Vaper.Potion.PilferedHealthPotion:Value() and Hp() < Vaper.Potion.HP6:Value() then
        Control.CastSpell(HKITEM[PilferedHealthPotion])
    end
    local TotalBiscuitofEverlastingWillTarget = ClosestHero(1500,foe) or ClosestMinion(400,neutral)
    if TotalBiscuitofEverlastingWill and Ready(TotalBiscuitofEverlastingWill) and TotalBiscuitofEverlastingWillTarget and Vaper.Potion.TotalBiscuitofEverlastingWill:Value() and (Hp() < Vaper.Potion.HP7:Value() or Mp() < Vaper.Potion.MP7:Value()) then
        Control.CastSpell(HKITEM[TotalBiscuitofEverlastingWill])
    end
end

function Utility:Cleanse()
    local items = {}
  for slot = ITEM_1,ITEM_6 do
    local id = myHero:GetItemData(slot).itemID 
    if id > 0 then
      items[id] = slot
    end
    end
    local QuicksilverSash = items[3140]
    local MercurialScimitar = items[3139]
    local MikaelsCrucible = items[3222]

    local QuicksilverSashTarget = ClosestHero(1500,foe)
    if QuicksilverSash and Ready(QuicksilverSash) and QuicksilverSashTarget and Vaper.Cleanse.QuicksilverSash:Value() then
        if (BuffByType(5,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Stun:Value()) or
            (BuffByType(7,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Silence:Value()) or
            (BuffByType(8,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Taunt:Value()) or
            ((BuffByType(9,Vaper.Cleanse.D1:Value()) or BuffByType(31,Vaper.Cleanse.D1:Value())) and Vaper.Cleanse.Disarm:Value()) or
            (BuffByType(10,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Slow:Value()) or
            (BuffByType(11,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Root:Value()) or
            (BuffByType(18,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Sleep:Value()) or
            (BuffByType(19,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Nearsight:Value()) or
            ((BuffByType(21,Vaper.Cleanse.D1:Value()) or BuffByType(28,Vaper.Cleanse.D1:Value())) and Vaper.Cleanse.Fear:Value()) or
            (BuffByType(22,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Charm:Value()) or
            (BuffByType(24,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Suppression:Value()) or
            (BuffByType(25,Vaper.Cleanse.D1:Value()) and Vaper.Cleanse.Blind:Value()) then
            Control.CastSpell(HKITEM[QuicksilverSash])
        end
    end
    local MercurialScimitarTarget = ClosestHero(1500,foe)
    if MercurialScimitar and Ready(MercurialScimitar) and MercurialScimitarTarget and Vaper.Cleanse.MercurialScimitar:Value() then
        if (BuffByType(5,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Stun:Value()) or
            (BuffByType(7,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Silence:Value()) or
            (BuffByType(8,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Taunt:Value()) or
            ((BuffByType(9,Vaper.Cleanse.D2:Value()) or BuffByType(31,Vaper.Cleanse.D2:Value())) and Vaper.Cleanse.Disarm:Value()) or
            (BuffByType(10,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Slow:Value()) or
            (BuffByType(11,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Root:Value()) or
            (BuffByType(18,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Sleep:Value()) or
            (BuffByType(19,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Nearsight:Value()) or
            ((BuffByType(21,Vaper.Cleanse.D2:Value()) or BuffByType(28,Vaper.Cleanse.D2:Value())) and Vaper.Cleanse.Fear:Value()) or
            (BuffByType(22,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Charm:Value()) or
            (BuffByType(24,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Suppression:Value()) or
            (BuffByType(25,Vaper.Cleanse.D2:Value()) and Vaper.Cleanse.Blind:Value()) then
            Control.CastSpell(HKITEM[MercurialScimitar])
        end
    end
    local MikaelsCrucibleAlly = ClosestInjuredHero(750,friend,101,false)
    if MikaelsCrucible and Ready(MikaelsCrucible) and MikaelsCrucibleAlly and HeroesAround(1500,MikaelsCrucibleAlly.pos) ~= 0 and Vaper.Cleanse.MikaelsCrucible:Value() then
        if (BuffByType(5,Vaper.Cleanse.D3:Value()) and Vaper.Cleanse.Stun:Value()) or
            (BuffByType(7,Vaper.Cleanse.D3:Value()) and Vaper.Cleanse.Silence:Value()) or
            (BuffByType(8,Vaper.Cleanse.D3:Value()) and Vaper.Cleanse.Taunt:Value()) or
            ((BuffByType(9,Vaper.Cleanse.D3:Value()) or BuffByType(31,Vaper.Cleanse.D3:Value())) and Vaper.Cleanse.Disarm:Value()) or
            (BuffByType(10,Vaper.Cleanse.D3:Value()) and Vaper.Cleanse.Slow:Value()) or
            (BuffByType(11,Vaper.Cleanse.D3:Value()) and Vaper.Cleanse.Root:Value()) or
            (BuffByType(18,Vaper.Cleanse.D3:Value()) and Vaper.Cleanse.Sleep:Value()) or
            (BuffByType(19,Vaper.Cleanse.D3:Value()) and Vaper.Cleanse.Nearsight:Value()) or
            ((BuffByType(21,Vaper.Cleanse.D3:Value()) or BuffByType(28,Vaper.Cleanse.D3:Value())) and Vaper.Cleanse.Fear:Value()) or
            (BuffByType(22,Vaper.Cleanse.D3:Value()) and Vaper.Cleanse.Charm:Value()) then
            Control.CastSpell(HKITEM[MikaelsCrucible], MikaelsCrucibleAlly)
        end
    end

    local ExistCleanse = ExistSpell("SummonerBoost")
    local CleanseSlot = SummonerSlot("SummonerBoost")
    local CleanseTarget = ClosestHero(1500,foe)
    if ExistCleanse and Ready(CleanseSlot) and CleanseTarget and Vaper.Cleanse.Cleanse:Value() then
        if (BuffByType(5,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Stun:Value()) or
            (BuffByType(7,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Silence:Value()) or
            (BuffByType(8,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Taunt:Value()) or
            ((BuffByType(9,Vaper.Cleanse.DS1:Value()) or BuffByType(31,Vaper.Cleanse.DS1:Value())) and Vaper.Cleanse.Disarm:Value()) or
            (BuffByType(10,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Slow:Value()) or
            (BuffByType(11,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Root:Value()) or
            (BuffByType(18,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Sleep:Value()) or
            (BuffByType(19,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Nearsight:Value()) or
            ((BuffByType(21,Vaper.Cleanse.DS1:Value()) or BuffByType(28,Vaper.Cleanse.DS1:Value())) and Vaper.Cleanse.Fear:Value()) or
            (BuffByType(22,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Charm:Value()) or
            (BuffByType(25,Vaper.Cleanse.DS1:Value()) and Vaper.Cleanse.Blind:Value()) then
            Control.CastSpell(HKSPELL[CleanseSlot])
        end      
    end
end
