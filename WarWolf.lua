local Heroes 						= {"Warwick"}
local _atan 						= math.atan2
local _pi 							= math.pi
local _max 							= math.max
local _min 							= math.min
local _abs 							= math.abs
local _sqrt 						= math.sqrt
local _find 						= string.find
local _sub 							= string.sub
local _len 							= string.len
local _huge 						= math.huge
local _insert						= table.insert
local LocalGameLatency				= Game.Latency
local LocalGameTimer 				= Game.Timer
local charName 						= myHero.charName
local isAioLoaded 					= false
local LocalGameHeroCount 			= Game.HeroCount;
local LocalGameHero 				= Game.Hero;
local LocalGameMinionCount 			= Game.MinionCount;
local LocalGameMinion 				= Game.Minion;
local LocalGameTurretCount 			= Game.TurretCount;
local LocalGameTurret 				= Game.Turret;
local LocalGameWardCount 			= Game.WardCount;
local LocalGameWard 				= Game.Ward;
local LocalGameObjectCount 			= Game.ObjectCount;
local LocalGameObject				= Game.Object;
local LocalGameMissileCount 		= Game.MissileCount;
local LocalGameMissile				= Game.Missile;
local LocalGameParticleCount		= Game.ParticleCount;
local LocalGameParticle				= Game.Particle;
local LocalGameCampCount			= Game.CampCount;
local LocalGameCamp					= Game.Camp;
local isEvading 					= ExtLibEvade and ExtLibEvade.Evading
local _targetedMissiles = {}
local _activeSkillshots = {}

if not table.contains(Heroes, charName) then 
	print("WarWolf - " ..charName.. " is not supported, loading other modules...")
else
	print("WarWolf loading...")
end

Callback.Add("Load",
function()	

	if FileExist(COMMON_PATH.. "Collision.lua") then
		require 'Collision'
	else
		print("Collision lib missing... Download and insert it in " ..COMMON_PATH.. " !")
	end	

	Menu = MenuElement({type = MENU, id = charName, name = "WarWolf for "..charName})	
	Menu:MenuElement({id = "AiO", name = "AiO Settings", type = MENU})

		
			Menu.AiO:MenuElement({id = "Draw", name = "Draw Settings", type = MENU})

				Menu.AiO.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = false})
				Menu.AiO.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = false})
				Menu.AiO.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = false})
				Menu.AiO.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = false})

			Menu.AiO:MenuElement({id = "Pred", name = "Prediction Settings", type = MENU})
				Menu.AiO.Pred:MenuElement({id = "pred", name = "Pred to use",  drop = {"Noddy's", "HPred"}, value = 2})

				Menu.AiO.Pred:MenuElement({id = "HPred", name = "HPred Settings", type = MENU})
				Menu.AiO.Pred.HPred:MenuElement({id = "reactionTime", name = "Reaction Time", value = .5, min = .1, max = 1, step = .1})
				Menu.AiO.Pred.HPred:MenuElement({id = "accuracy", name = "HitChance", value = 3, min = 1, max = 5, step = 1})

				Menu.AiO.Pred:MenuElement({id = "NPred", name = "Noddy's Pred Settings", type = MENU})
				Menu.AiO.Pred.NPred:MenuElement({id = "soonTM", name = "Nothing here :P", value = false})
	HPred()
	AioLoad()
end)

function AioLoad()
	if not isAioLoaded then
		LoadAio()
		return
	end
end

function LoadAio()

	isAioLoaded = true
	if table.contains(Heroes, charName) then
		_G[charName]()
	end

	Callback.Add("Tick", function() Utils:OnTick() end)
	if _G.SDK then
        _G.SDK.Orbwalker:OnPostAttack(function() Utils:OnPostAttack() end)
    elseif _G.EOW then
        EOW:AddCallback(EOW.AfterAttack, function() Utils:OnPostAttack() end)
    elseif _G.GOS then
        GOS:OnAttackComplete(function() Utils:OnPostAttack() end)
    end
	Callback.Add("Tick", function() HPred:Tick() end)
	Callback.Add("Draw", function() AioDraw() end)
	LoadSummonersAiO()
end

function LoadSummonersAiO()

	Utils.Smite = Utils:GetSmite(SUMMONER_1) or 0
	if Utils.Smite == 0 then
		Utils.Smite = Utils:GetSmite(SUMMONER_2);		
	end
	Utils.lastSmite = GetTickCount()

	Utils.Ignite = Utils:GetIgnite(SUMMONER_1) or 0
	if Utils.Ignite == 0 then
		Utils.Ignite = Utils:GetIgnite(SUMMONER_2);		
	end
	Utils.Ignite = GetTickCount()
end

function AioDraw()

	if Q and Q.range and Menu.AiO.Draw.DrawQ:Value() then
		if Utils:IsReady(_Q) then
			Draw.Circle(myHero.pos, Q.range, 1, Draw.Color(255, 0, 255, 0))
		else
			Draw.Circle(myHero.pos, Q.range, 1, Draw.Color(255, 255, 0, 0))
		end
	end	
	if W and W.range and Menu.AiO.Draw.DrawW:Value() then
		if Utils:IsReady(_W) then
			Draw.Circle(myHero.pos, W.range, 1, Draw.Color(255, 0, 255, 0))
		else
			Draw.Circle(myHero.pos, W.range, 1, Draw.Color(255, 255, 0, 0))
		end
	end	
	if E and E.range and Menu.AiO.Draw.DrawE:Value() then
		if Utils:IsReady(_E) then
			Draw.Circle(myHero.pos, E.range, 1, Draw.Color(255, 0, 255, 0))
		else
			Draw.Circle(myHero.pos, E.range, 1, Draw.Color(255, 255, 0, 0))
		end
	end		
	if R and R.range and Menu.AiO.Draw.DrawR:Value() then
		if Utils:IsReady(_R) then
			Draw.Circle(myHero.pos, R.range, 1, Draw.Color(500, 500, 0))
		else
			Draw.Circle(myHero.pos, R.range, 1, Draw.Color(500, 500, 0, 0))
		end
	end
end

--[[                                                                                               
                                                                                                 
UUUUUUUU     UUUUUUUUTTTTTTTTTTTTTTTTTTTTTTTIIIIIIIIIILLLLLLLLLLL                SSSSSSSSSSSSSSS 
U::::::U     U::::::UT:::::::::::::::::::::TI::::::::IL:::::::::L              SS:::::::::::::::S
U::::::U     U::::::UT:::::::::::::::::::::TI::::::::IL:::::::::L             S:::::SSSSSS::::::S
UU:::::U     U:::::UUT:::::TT:::::::TT:::::TII::::::IILL:::::::LL             S:::::S     SSSSSSS
 U:::::U     U:::::U TTTTTT  T:::::T  TTTTTT  I::::I    L:::::L               S:::::S            
 U:::::D     D:::::U         T:::::T          I::::I    L:::::L               S:::::S            
 U:::::D     D:::::U         T:::::T          I::::I    L:::::L                S::::SSSS         
 U:::::D     D:::::U         T:::::T          I::::I    L:::::L                 SS::::::SSSSS    
 U:::::D     D:::::U         T:::::T          I::::I    L:::::L                   SSS::::::::SS  
 U:::::D     D:::::U         T:::::T          I::::I    L:::::L                      SSSSSS::::S 
 U:::::D     D:::::U         T:::::T          I::::I    L:::::L                           S:::::S
 U::::::U   U::::::U         T:::::T          I::::I    L:::::L         LLLLLL            S:::::S
 U:::::::UUU:::::::U       TT:::::::TT      II::::::IILL:::::::LLLLLLLLL:::::LSSSSSSS     S:::::S
  UU:::::::::::::UU        T:::::::::T      I::::::::IL::::::::::::::::::::::LS::::::SSSSSS:::::S
    UU:::::::::UU          T:::::::::T      I::::::::IL::::::::::::::::::::::LS:::::::::::::::SS 
      UUUUUUUUU            TTTTTTTTTTT      IIIIIIIIIILLLLLLLLLLLLLLLLLLLLLLLL SSSSSSSSSSSSSSS   
                                                                                              
--]]

class "Utils"

function Utils:IsReady(spell)
	return Game.CanUseSpell(spell) == 0
end

function Utils:IsValid(unit, pos, range)
	return self:GetDistance(unit.pos, pos) <= range and unit.health > 0 and unit.isTargetable and unit.visible
end

function Utils:GetDistanceSqr(p1, p2)
    local dx = p1.x - p2.x
    local dz = p1.z - p2.z
    return (dx * dx + dz * dz)
end

function Utils:GetDistance(p1, p2)
    return _sqrt(self:GetDistanceSqr(p1, p2))
end

function Utils:GetDistance2D(p1,p2)
    return _sqrt((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y))
end

function Utils:GetHpPercent(unit)
    return unit.health / unit.maxHealth * 100
end

function Utils:GetManaPercent(unit)
	return unit.mana / unit.maxMana * 100
end

function Utils:GetTarget(range)

	if _G.EOWLoaded then
		if myHero.ap > myHero.totalDamage then
			return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
		else
			return EOW:GetTarget(range, EOW.ad_dec, myHero.pos)
		end
	elseif _G.SDK and _G.SDK.TargetSelector then
		if myHero.ap > myHero.totalDamage then
			return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
		else
			return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		end
	elseif _G.GOS then
		if myHero.ap > myHero.totalDamage then
			return GOS:GetTarget(range, "AP")
		else
			return GOS:GetTarget(range, "AD")
		end
	end
end

function Utils:HasBuff(unit, buffName)

	for i = 1, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and buff.count > 0 and buff.name:lower() == buffName:lower() then 
			return true
		end
	end
	return false
end

function Utils:IsParticleInRange(particleName, pos, range)

	for i = 1, LocalGameParticleCount() do
    	local particle = LocalGameParticle(i)
		if particle and not particle.dead then
			if particle.name:lower() == particleName:lower() then
				if self:GetDistance(particle.pos, pos) <= range then 
					return true
				end
			end
		end
	end
	return false
end

local _AllyHeroes
function Utils:GetAllyHeroes()
  	if #_AllyHeroes > 0 then return _AllyHeroes end
  	_AllyHeroes = {}
  	for i = 1, LocalGameHeroCount() do
    	local unit = LocalGameHero(i)
    	if unit and unit.isAlly then
      		_insert(_AllyHeroes, unit)
    	end
	end
	return _AllyHeroes
end

local _EnemyHeroes
function Utils:GetEnemyHeroes()
  	if #_EnemyHeroes > 0 then return _EnemyHeroes end
  	_EnemyHeroes = {}
  	for i = 1, LocalGameHeroCount() do
    	local unit = LocalGameHero(i)
    	if unit and unit.isEnemy then
      		_insert(_EnemyHeroes, unit)
    	end
	end
	return _EnemyHeroes
end

function Utils:GetEnemyHeroesInRange(pos, range)
	local _EnemyHeroes = {}
  	for i = 1, LocalGameHeroCount() do
    	local unit = LocalGameHero(i)
    	if unit and unit.isEnemy and self:IsValid(unit, pos, range) then
	  		_insert(_EnemyHeroes, unit)
  		end
  	end
  	return _EnemyHeroes
end

function Utils:GetAllyHeroesInRange(pos, range)
	local _AllyHeroes = {}	
  	for i = 1, LocalGameHeroCount() do
    	local unit = LocalGameHero(i)
    	if unit and unit.isAlly and self:IsValid(unit, pos, range) then
	  		_insert(_AllyHeroes, unit)
  		end
  	end
  	return _AllyHeroes
end

function Utils:GetEnemyMinionsInRange(pos, range)

	local _EnemyMinions = {}
  	for i = 1, LocalGameMinionCount() do
    	local unit = LocalGameMinion(i)
    	if unit and unit.isEnemy and self:IsValid(unit, pos, range) then
	  		_insert(_EnemyMinions, unit)
  		end
  	end
  	return _EnemyMinions
end

function Utils:GetAllyMinionsInRange(pos, range)

	local _AllyMinions = {}	
  	for i = 1, LocalGameMinionCount() do
    	local unit = LocalGameMinion(i)
    	if unit and unit.isAlly and self:IsValid(unit, pos, range) then
	  		_insert(_AllyMinions, unit)
  		end
  	end
  	return _AllyMinions
end

function Utils:IsUnderEnemyTurret(pos)

	for i = 1, LocalGameTurretCount() do
		local turret = LocalGameTurret(i);
		if turret then
			if turret.valid and turret.health > 0 and turret.isEnemy then
				local turretPos = turret.pos
				if Utils:GetDistance(pos, turretPos) <= 900 then 
					return true
				end
			end
		end
	end
	return false
end

function Utils:IsUnderAllyTurret(pos)

	for i = 1, LocalGameTurretCount() do
		local turret = LocalGameTurret(i);
		if turret then
			if turret.valid and turret.health > 0 and turret.isAlly then
				local turretPos = turret.pos
				if Utils:GetDistance(pos, turretPos) <= 900 then 
					return true
				end
			end
		end
	end
	return false
end

local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
function Utils:CastSpell(spell,pos,range,delay)

	local range = range or _huge
	local delay = delay or 250
	local ticker = GetTickCount()

	if castSpell.state == 0 and self:GetDistance(myHero.pos, pos) < range and ticker - castSpell.casting > delay + LocalGameLatency() then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < LocalGameLatency() then
			Control.SetCursorPos(pos)
			Control.KeyDown(spell)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end,LocalGameLatency()/1000)
		end
		if ticker - castSpell.casting > LocalGameLatency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end

function Utils:CastSpellMM(spell, pos, range, delay)

	local range = range or _huge
	local delay = delay or 250
	local ticker = GetTickCount()

	if castSpell.state == 0 and self:GetDistance(myHero.pos, pos) < range and ticker - castSpell.casting > delay + LocalGameLatency() then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < LocalGameLatency() then
			local castPosMM = pos:ToMM()
			Control.SetCursorPos(castPosMM.x,castPosMM.y)
			Control.KeyDown(spell)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end,LocalGameLatency()/1000)
		end
		if ticker - castSpell.casting > LocalGameLatency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end

function Utils:CastSpellCharged(spell, pos, range, delay)

	local range = range or _huge
	local delay = delay or 250
	local ticker = GetTickCount()

	if castSpell.state == 0 and self:GetDistance(myHero.pos, pos) < range and ticker - castSpell.casting > delay + LocalGameLatency() then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end
	if castSpell.state == 1 then
		if ticker - castSpell.tick < LocalGameLatency() then
			Control.SetCursorPos(pos)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end,LocalGameLatency()/1000)
		end
		if ticker - castSpell.casting > LocalGameLatency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end



 -- Thnx Noddy :)

local SmiteNames = {'SummonerSmite','S5_SummonerSmiteDuel','S5_SummonerSmitePlayerGanker','S5_SummonerSmiteQuick','ItemSmiteAoE'};
local SmiteDamage = {390 , 410 , 430 , 450 , 480 , 510 , 540 , 570 , 600 , 640 , 680 , 720 , 760 , 800 , 850 , 900 , 950 , 1000};

function Utils:GetSmite(smiteSlot)
	local smite = 0;
	local spellName = myHero:GetSpellData(smiteSlot).name;
	for i = 1, 5 do
		if spellName == SmiteNames[i] then
			smite = smiteSlot
		end
	end
	return smite;
end

function Utils:GetIgnite(igniteSlot)
	local ignite = 0;
	local spellName = myHero:GetSpellData(igniteSlot).name;
	if spellName:lower() == "summonerignite" then
		ignite = smiteSlot
	end
	return ignite;
end

function Utils:CastSmite()

	local sData = myHero:GetSpellData(Utils.Smite);
	if sData.name == SmiteNames[3] or sData.name == SmiteNames[2] then
		if sData.level > 0 then
			if (sData.ammo > 0 and sData.ammoCurrentCd == 0) then
				for i = 1, LocalGameHeroCount() do
					local hero = LocalGameHero(i);
					if hero and hero.isEnemy and self:IsValid(hero, myHero.pos, 500 + (myHero.boundingRadius + hero.boundingRadius)) then
						if Utils.Smite == SUMMONER_1 then
							Control.CastSpell(HK_SUMMONER_1, hero)
							self.lastSmite = GetTickCount()
						else
							Control.CastSpell(HK_SUMMONER_2, hero)
							self.lastSmite = GetTickCount()
						end
					end
				end
			end
		end
	end
end

function Utils:CalculatePhysicalDamage(target, damage)

	if target and damage then
		local targetArmor = target.armor * myHero.armorPenPercent - myHero.armorPen
		local damageReduction = 100 / ( 100 + targetArmor)
		if targetArmor < 0 then
			damageReduction = 2 - (100 / (100 - targetArmor))
		end		
		damage = damage * damageReduction	
		return damage
	end
	return 0
end

function Utils:CalculateMagicalDamage(target, damage)
	
	if target and damage then	
		local targetMR = target.magicResist * myHero.magicPenPercent - myHero.magicPen
		local damageReduction = 100 / ( 100 + targetMR)
		if targetMR < 0 then
			damageReduction = 2 - (100 / (100 - targetMR))
		end		
		damage = damage * damageReduction
		return damage
	end
	return 0
end

function Utils:IsImmobile(unit)

	for i = 1, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 22 or buff.type == 29) and buff.count > 0 then
			return true
		end
	end
	return false	
end

function Utils:OnVision(unit)

	local _OnVision = {}
	if _OnVision[unit.networkID] == nil then _OnVision[unit.networkID] = {state = unit.visible , tick = GetTickCount(), pos = unit.pos} end
	if _OnVision[unit.networkID].state == true and not unit.visible then _OnVision[unit.networkID].state = false _OnVision[unit.networkID].tick = GetTickCount() end
	if _OnVision[unit.networkID].state == false and unit.visible then _OnVision[unit.networkID].state = true _OnVision[unit.networkID].tick = GetTickCount() end
	return _OnVision[unit.networkID]
end

function Utils:OnVisionF()

	local visionTick = GetTickCount()
	if GetTickCount() - visionTick > 100 then
		for k, v in pairs(self:GetEnemyHeroes()) do
			if v then
				self:OnVision(v)
			end
		end
	end
end

function Utils:OnWaypoint(unit)

	local _OnWaypoint = {}
	if _OnWaypoint[unit.networkID] == nil then _OnWaypoint[unit.networkID] = {pos = unit.posTo , speed = unit.ms, time = LocalGameTimer()} end
	if _OnWaypoint[unit.networkID].pos ~= unit.posTo then 
		_OnWaypoint[unit.networkID] = {startPos = unit.pos, pos = unit.posTo , speed = unit.ms, time = LocalGameTimer()}
			DelayAction(function()
				local time = (LocalGameTimer() - _OnWaypoint[unit.networkID].time)
				local speed = self:GetDistance2D(_OnWaypoint[unit.networkID].startPos,unit.pos)/(LocalGameTimer() - _OnWaypoint[unit.networkID].time)
				if speed > 1250 and time > 0 and unit.posTo == _OnWaypoint[unit.networkID].pos and self:GetDistance(unit.pos,_OnWaypoint[unit.networkID].pos) > 200 then
					_OnWaypoint[unit.networkID].speed = self:GetDistance2D(_OnWaypoint[unit.networkID].startPos,unit.pos)/(LocalGameTimer() - _OnWaypoint[unit.networkID].time)
				end
			end,0.05)
	end
	return _OnWaypoint[unit.networkID]
end -- not sure what or why removed stuff, who cares, works.

function Utils:GetPred(unit,speed,delay,sourcePos)

	local speed = speed or _huge
	local delay = delay or 0.25
	local sourcePos = sourcePos or myHero.pos
	local unitSpeed = unit.ms

	if self:OnWaypoint(unit).speed > unitSpeed then unitSpeed = self:OnWaypoint(unit).speed end

	if unitSpeed > unit.ms then
		local predPos = unit.pos + Vector(self:OnWaypoint(unit).startPos,unit.posTo):Normalized() * (unitSpeed * (delay + (self:GetDistance(sourcePos,unit.pos)/speed)))
		if self:GetDistance(unit.pos,predPos) > self:GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
		return predPos
	elseif self:IsImmobile(unit) then
		return unit.pos
	else
		return unit:GetPrediction(speed,delay)
	end
end


function Utils:OnTick()

	Orb:GetOrbMode()
	self:OnVisionF()
	self:CastItems()

	if Orb.combo then
		if Menu.AiO.Activator.Summoners.useSmite:Value() and Orb.combo then
			Utils:CastSmite()
		end
	end
end

--[[
                                                                                                                
     OOOOOOOOO     RRRRRRRRRRRRRRRRR   BBBBBBBBBBBBBBBBB   
   OO:::::::::OO   R::::::::::::::::R  B::::::::::::::::B  
 OO:::::::::::::OO R::::::RRRRRR:::::R B::::::BBBBBB:::::B 
O:::::::OOO:::::::ORR:::::R     R:::::RBB:::::B     B:::::B
O::::::O   O::::::O  R::::R     R:::::R  B::::B     B:::::B
O:::::O     O:::::O  R::::R     R:::::R  B::::B     B:::::B
O:::::O     O:::::O  R::::RRRRRR:::::R   B::::BBBBBB:::::B 
O:::::O     O:::::O  R:::::::::::::RR    B:::::::::::::BB  
O:::::O     O:::::O  R::::RRRRRR:::::R   B::::BBBBBB:::::B 
O:::::O     O:::::O  R::::R     R:::::R  B::::B     B:::::B
O:::::O     O:::::O  R::::R     R:::::R  B::::B     B:::::B
O::::::O   O::::::O  R::::R     R:::::R  B::::B     B:::::B
O:::::::OOO:::::::ORR:::::R     R:::::RBB:::::BBBBBB::::::B
 OO:::::::::::::OO R::::::R     R:::::RB:::::::::::::::::B 
   OO:::::::::OO   R::::::R     R:::::RB::::::::::::::::B  
     OOOOOOOOO     RRRRRRRR     RRRRRRRBBBBBBBBBBBBBBBBB   
                                                                                                                                                                              
--]]

class "Orb"

function Orb:DisableMovement(bool)

	if _G.SDK then
		_G.SDK.Orbwalker:SetMovement(not bool)
	elseif _G.EOWLoaded then
		EOW:SetMovements(not bool)
	elseif _G.GOS then
		GOS.BlockMovement = bool
	end
end

function Orb:DisableAttacks(bool)

	if _G.SDK then
		_G.SDK.Orbwalker:SetAttack(not bool)
	elseif _G.EOWLoaded then
		EOW:SetAttacks(not bool)
	elseif _G.GOS then
		GOS.BlockAttack = bool
	end
end

function Orb:GetOrbMode()

	self.combo, self.harass, self.lastHit, self.laneClear, self.jungleClear, self.canMove, self.canAttack = nil,nil,nil,nil,nil,nil,nil
		
	if _G.EOWLoaded then

		local mode = EOW:Mode()

		self.combo = mode == 1
		self.harass = mode == 2
	    self.lastHit = mode == 3
	    self.laneClear = mode == 4
	    self.jungleClear = mode == 4

		self.canmove = EOW:CanMove()
		self.canattack = EOW:CanAttack()
	elseif _G.SDK then

		self.combo = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO]
		self.harass = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS]
	   	self.lastHit = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT]
	   	self.laneClear = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR]
	   	self.jungleClear = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR]

		self.canmove = _G.SDK.Orbwalker:CanMove(myHero)
		self.canattack = _G.SDK.Orbwalker:CanAttack(myHero)
	elseif _G.GOS then

		local mode = GOS:GetMode()

		self.combo = mode == "Combo"
		self.harass = mode == "Harass"
	    self.lastHit = mode == "Lasthit"
	    self.laneClear = mode == "Clear"
	    self.jungleClear = mode == "Clear"

		self.canMove = GOS:CanMove()
		self.canAttack = GOS:CanAttack()	
	end
end

class "Warwick"

function Warwick:__init()

	if charName ~= "Warwick" then return end

	self:LoadSpells()
	self:LoadMenu()

	Callback.Add("Tick", function() self:OnTick() end)

	if _G.SDK then
        _G.SDK.Orbwalker:OnPostAttack(function() self:OnPostAttack() end)
    elseif _G.EOW then
        EOW:AddCallback(EOW.AfterAttack, function() self:OnPostAttack() end)
    elseif _G.GOS then
        GOS:OnAttackComplete(function() self:OnPostAttack() end)
    end
end

function Warwick:LoadSpells()

	attackRange = myHero.range + myHero.boundingRadius
	Q = { range = myHero:GetSpellData(_Q).range,	delay = 0.25 }
	W = { range = 0 }
	E = { range = myHero:GetSpellData(_E).range,	delay = 0.50 }
	R = { range = 1250 }
end

function Warwick:LoadMenu()

	Menu:MenuElement({id = "Combo", name = "Combo Settings", type = MENU})
	Menu:MenuElement({id = "Harass", name = "Harass Settings", type = MENU})

	--- Combo ---
		Menu.Combo:MenuElement({id = "auto", name = "AutoWin", value = true, tooltip = "Kappa"})
		Menu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true})
		Menu.Combo:MenuElement({id = "useW", name = "Use W", value = true})
		Menu.Combo:MenuElement({id = "useE", name = "Use W after Q", value = true})
		Menu.Combo:MenuElement({id = "useR", name = "Use R", value = true})

	--- Harass ---
		Menu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true})
		Menu.Harass:MenuElement({id = "useW", name = "Use W", value = true})
		Menu.Harass:MenuElement({id = "useE", name = "Use E", value = true})
end

function Warwick:OnTick()

	self.qTarget 	= Utils:GetTarget(Q.range)
	self.eTarget 	= Utils:GetTarget(E.range) 
	self.rTarget 	= Utils:GetTarget(R.range)

	if #Utils:GetEnemyHeroesInRange(myHero.pos, attackRange) > 0 or myHero.attackData.state == STATE_WINDUP then
		Orb:DisableMovement(true)
	else
		Orb:DisableMovement(false)
	end

	if not myHero.dead then
		if not isEvading then
			if Orb.combo then
				self:Combo()		
			end
		end
	end
end

function Warwick:OnPostAttack()

	local qReady = Menu.Combo.useQ:Value() and Utils:IsReady(_Q)
	if (Orb.combo or Orb.harass) and qReady then
		if #Utils:GetEnemyHeroesInRange(myHero.pos, attackRange * 2) > 0 then
			for i = 1, #Utils:GetEnemyHeroesInRange(myHero.pos, attackRange * 2) do
				local current = Utils:GetEnemyHeroesInRange(myHero.pos, attackRange * 2)[i]
				if current then
					if Utils:IsValid(current, myHero.pos, Q.range) then
						Control.CastSpell(HK_Q, current)
						break
					end
				end
			end
		end
	end
end

function Warwick:CastQcombo(unit)
	
	if unit and Utils:IsValid(unit, myHero.pos, Q.range) then
		if Utils:GetDistance(unit.pos, myHero.pos) > attackRange then
			Control.CastSpell(HK_Q, unit)
		end
	end
end

function Warwick:CastQdodge()
	
	for i = 1, #Utils:GetEnemyHeroesInRange(myHero.pos, 1000) do
		local current = Utils:GetEnemyHeroesInRange(myHero.pos, 1000)[i]
		if current then
			if current.activeSpell and current.activeSpell.valid and
				(current.activeSpell.target == myHero.handle or 
					Utils:GetDistance(current.activeSpell.placementPos, myHero.pos) <= myHero.boundingRadius * 2 + current.activeSpell.width) and not
				_find(current.activeSpell.name:lower(), "attack") then
				local startPos = current.activeSpell.startPos
				local placementPos = current.activeSpell.placementPos
				local width = 0
				if current.activeSpell.width > 0 then
					width = current.activeSpell.width
				else
					width = 100
				end
				local distance = Utils:GetDistance(myHero.pos, placementPos)											
				if current.activeSpell.target == myHero.handle then
					self:Qdodge()
					return
				else
					if distance <= width * 2 + myHero.boundingRadius then
						self:Qdodge()
						break						
					end
				end
			end
		end
	end
end

function Warwick:Qdodge()
	
	for _, v in pairs(Utils:GetEnemyHeroesInRange(myHero.pos, Q.range)) do
		local hero = v
		if hero then
			if Utils:IsValid(hero, myHero.pos, Q.range) then
				Control.CastSpell(HK_Q, hero)
				return
			end
		end
	end

	for _, v in pairs(Utils:GetEnemyMinionsInRange(myHero.pos, Q.range)) do
		local minion = v
		if minion then
			if Utils:IsValid(minion, myHero.pos, Q.range) then
				Control.CastSpell(HK_Q, minion)
				break
			end
		end
	end
end

function Warwick:CastWcombo(unit)

	
	if unit and Utils:IsValid(unit, myHero.pos, Q.range) then
			Control.CastSpell(HK_E, unit)
	end
	
	
end

function Warwick:CastRcombo(unit)

		if Utils:GetDistance(unit.pos, myHero.pos) > myHero:GetSpellData(_Q).range  then
			Control.CastSpell(HK_R, unit)

		end
	
	
end


function Warwick:Combo()

	local rReady = Menu.Combo.useR:Value() and Utils:IsReady(_R)
	local qReady = Menu.Combo.useQ:Value() and Utils:IsReady(_Q)
	local wReady = Menu.Combo.useW:Value() and Utils:IsReady(_W)
	local eReady = Menu.Combo.useE:Value() and Utils:IsReady(_E)
	
	
	if rReady then
		if self.rTarget then
			self:CastRcombo(self.rTarget)
		end
	end

	if qReady then
		self:CastQdodge()
		if self.qTarget then
			self:CastQcombo(self.qTarget)
		end
	end

	if eReady then
		self:CastWcombo(self.eTarget)
	end
	
	
end

function Warwick:GetQdmg(unit)

	local totalDmg = 0

	if unit then
		local qLvl = myHero:GetSpellData(_Q).level
		if qLvl > 0 then
			local baseDmg = ({ 25, 60, 95, 130, 165 })[qLvl]
			totalDmg = baseDmg + myHero.totalDamage
		end
	end
	return Utils:CalculatePhysicalDamage(unit, totalDmg)
end

function Warwick:GetComboDmg(unit)

	local totalDmg = 0

	if unit then
		local qLvl = myHero:GetSpellData(_Q).level
		if qLvl > 0 then
			totalDmg = totalDmg + self:GetQdmg(unit)
		end
		totalDmg = totalDmg + myHero.totalDamage
	end
	return totalDmg
end

--[[                                                                                                       
                                                                                               dddddddd
HHHHHHHHH     HHHHHHHHHPPPPPPPPPPPPPPPPP                                                       d::::::d
H:::::::H     H:::::::HP::::::::::::::::P                                                      d::::::d
H:::::::H     H:::::::HP::::::PPPPPP:::::P                                                     d::::::d
HH::::::H     H::::::HHPP:::::P     P:::::P                                                    d:::::d 
  H:::::H     H:::::H    P::::P     P:::::Prrrrr   rrrrrrrrr       eeeeeeeeeeee        ddddddddd:::::d 
  H:::::H     H:::::H    P::::P     P:::::Pr::::rrr:::::::::r    ee::::::::::::ee    dd::::::::::::::d 
  H::::::HHHHH::::::H    P::::PPPPPP:::::P r:::::::::::::::::r  e::::::eeeee:::::ee d::::::::::::::::d 
  H:::::::::::::::::H    P:::::::::::::PP  rr::::::rrrrr::::::re::::::e     e:::::ed:::::::ddddd:::::d 
  H:::::::::::::::::H    P::::PPPPPPPPP     r:::::r     r:::::re:::::::eeeee::::::ed::::::d    d:::::d 
  H::::::HHHHH::::::H    P::::P             r:::::r     rrrrrrre:::::::::::::::::e d:::::d     d:::::d 
  H:::::H     H:::::H    P::::P             r:::::r            e::::::eeeeeeeeeee  d:::::d     d:::::d 
  H:::::H     H:::::H    P::::P             r:::::r            e:::::::e           d:::::d     d:::::d 
HH::::::H     H::::::HHPP::::::PP           r:::::r            e::::::::e          d::::::ddddd::::::dd
H:::::::H     H:::::::HP::::::::P           r:::::r             e::::::::eeeeeeee   d:::::::::::::::::d
H:::::::H     H:::::::HP::::::::P           r:::::r              ee:::::::::::::e    d:::::::::ddd::::d
HHHHHHHHH     HHHHHHHHHPPPPPPPPPP           rrrrrrr                eeeeeeeeeeeeee     ddddddddd   ddddd                                                                                                    
                                                                                                       
--]]
class "HPred"
	
local _reviveQueryFrequency = .2
local _lastReviveQuery = LocalGameTimer()
local _reviveLookupTable = 
	{ 
		["LifeAura.troy"] = 4, 
		["ZileanBase_R_Buf.troy"] = 3,
		["Aatrox_Base_Passive_Death_Activate"] = 3
		
		--TwistedFate_Base_R_Gatemarker_Red
			--String match would be ideal.... could be different in other skins
	}

--Stores a collection of spells that will cause a character to blink
	--Ground targeted spells go towards mouse castPos with a maximum range
	--Hero/Minion targeted spells have a direction type to determine where we will land relative to our target (in front of, behind, etc)
	
--Key = Spell name
--Value = range a spell can travel, OR a targeted end position type, OR a list of particles the spell can teleport to	
local _blinkSpellLookupTable = 
	{ 
		["EzrealArcaneShift"] = 475, 
		["RiftWalk"] = 500,
		
		--Ekko and other similar blinks end up between their start pos and target pos (in front of their target relatively speaking)
		["EkkoEAttack"] = 0,
		["AlphaStrike"] = 0,
		
		--Katarina E ends on the side of her target closest to where her mouse was... 
		--["KatarinaE"] = -255, -- Had a few crashes with Katarina in Games, also seems to be fairly inaccurate - disabled for now
		
		--Katarina can target a dagger to teleport directly to it: Each skin has a different particle name. This should cover all of them.
		--["KatarinaEDagger"] = { "Katarina_Base_Dagger_Ground_Indicator","Katarina_Skin01_Dagger_Ground_Indicator","Katarina_Skin02_Dagger_Ground_Indicator","Katarina_Skin03_Dagger_Ground_Indicator","Katarina_Skin04_Dagger_Ground_Indicator","Katarina_Skin05_Dagger_Ground_Indicator","Katarina_Skin06_Dagger_Ground_Indicator","Katarina_Skin07_Dagger_Ground_Indicator" ,"Katarina_Skin08_Dagger_Ground_Indicator","Katarina_Skin09_Dagger_Ground_Indicator"  }, 
	}

local _blinkLookupTable = 
	{ 
		"global_ss_flash_02.troy",
		"Lissandra_Base_E_Arrival.troy",
		"Leblanc_Base_W_return_activation.troy"
		--TODO: Check if liss/Leblanc have diff skill versions. MOST likely dont but worth checking for completion sake
		
		--Zed uses 'switch shadows'... It will require some special checks to choose the shadow he's going TO not from...
		--Shaco deceive no longer has any particles where you jump to so it cant be tracked (no spell data or particles showing path)
		
	}

local _cachedRevives = {}
local _cachedTeleports = {}
local _movementHistory = {}

--Cache of all TARGETED missiles currently running
local _cachedMissiles = {}
local _incomingDamage = {}

--Cache of active enemy windwalls so we can calculate it when dealing with collision checks
local _windwall
local _windwallStartPos
local _windwallWidth

function HPred:Tick()
	--Update missile cache
	--DISABLED UNTIL LATER.
	--self:CacheMissiles()
	
	--self:CacheParticles()
	
	--Check for revives and record them	
	if LocalGameTimer() - _lastReviveQuery < _reviveQueryFrequency then return end
	_lastReviveQuery=LocalGameTimer()
	
	--Remove old cached revives
	for _, revive in pairs(_cachedRevives) do
		if LocalGameTimer() > revive.expireTime + .5 then
			_cachedRevives[_] = nil
		end
	end
	
	--Cache new revives
	for i = 1, LocalGameParticleCount() do 
		local particle = LocalGameParticle(i)
		if particle and not _cachedRevives[particle.networkID] and  _reviveLookupTable[particle.name] then
			_cachedRevives[particle.networkID] = {}
			_cachedRevives[particle.networkID]["expireTime"] = LocalGameTimer() + _reviveLookupTable[particle.name]			
			local target = self:GetHeroByPosition(particle.pos)
			if target and target.isEnemy then				
				_cachedRevives[particle.networkID]["target"] = target
				_cachedRevives[particle.networkID]["pos"] = target.pos
				_cachedRevives[particle.networkID]["isEnemy"] = target.isEnemy	
			end
		end
	end
	
	--Update hero movement history	
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t then
			self:UpdateMovementHistory(t)
		end
	end
	
	--Remove old cached teleports	
	for _, teleport in pairs(_cachedTeleports) do
		if teleport and LocalGameTimer() > teleport.expireTime + .5 then
			_cachedTeleports[_] = nil
		end
	end	
	--Update teleport cache
	self:CacheTeleports()
end

function HPred:GetEnemyNexusPosition()
	--This is slightly wrong. It represents fountain not the nexus. Fix later.
	if myHero.team == 100 then return Vector(14340, 171.977722167969, 14390); else return Vector(396,182.132507324219,462); end
end


function HPred:GetGuarenteedTarget(source, range, delay, speed, radius, timingAccuracy, checkCollision)
	--Get hourglass enemies
	target, aimPosition =self:GetHourglassTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get reviving target
	target, aimPosition =self:GetRevivingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end	
	
	--Get teleporting enemies
	target, aimPosition =self:GetTeleportingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)	
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get stunned enemies
	local target, aimPosition =self:GetImmobileTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
end


function HPred:GetReliableTarget(source, range, delay, speed, radius, timingAccuracy, checkCollision)
	--TODO: Target whitelist. This will target anyone which is definitely not what we want
	--For now we can handle in the champ script. That will cause issues with multiple people in range who are goood targets though.
	
	
	--Get hourglass enemies
	target, aimPosition =self:GetHourglassTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get reviving target
	target, aimPosition =self:GetRevivingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get channeling enemies
	target, aimPosition =self:GetChannelingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
		if target and aimPosition then
		return target, aimPosition
	end
	
	--Get teleporting enemies
	target, aimPosition =self:GetTeleportingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)	
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get instant dash enemies
	target, aimPosition =self:GetInstantDashTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end	
	
	--Get dashing enemies
	target, aimPosition =self:GetDashingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius, midDash)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get stunned enemies
	local target, aimPosition =self:GetImmobileTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	if target and aimPosition then
		return target, aimPosition
	end
	
	--Get blink targets
	--target, aimPosition =self:GetBlinkTarget(source, range, speed, delay, checkCollision, radius)
	--if target and aimPosition then
	--	return target, aimPosition
	--end	
end

--Will return how many allies or enemies will be hit by a linear spell based on current waypoint data.
function HPred:GetLineTargetCount(source, aimPos, delay, speed, width, targetAllies)
	local targetCount = 0
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and self:CanTargetALL(t) and (targetAllies or t.isEnemy) then
			local predictedPos = self:PredictUnitPosition(t, delay+ self:GetDistance(source, t.pos) / speed)
			local proj1, pointLine, isOnSegment = self:VectorPointProjectionOnLineSegment(source, aimPos, predictedPos)
			if proj1 and isOnSegment and (self:GetDistanceSqr(predictedPos, proj1) <= (t.boundingRadius + width) * (t.boundingRadius + width)) then
				targetCount = targetCount + 1
			end
		end
	end
	return targetCount
end

--Will return the valid target who has the highest hit chance and meets all conditions (minHitChance, whitelist check, etc)
function HPred:GetUnreliableTarget(source, range, delay, speed, radius, checkCollision, minimumHitChance, whitelist)
	local _validTargets = {}
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and self:CanTarget(t) and (not whitelist or whitelist[t.charName]) then			
			local hitChance, aimPosition = self:GetHitchance(source, t, range, delay, speed, radius, checkCollision)		
			if hitChance >= minimumHitChance then
				_validTargets[t.charName] = {["hitChance"] = hitChance, ["aimPosition"] = aimPosition}
			end
		end
	end
	
	local rHitChance = 0
	local rAimPosition
	for targetName, targetData in pairs(_validTargets) do
		if targetData.hitChance > rHitChance then
			rHitChance = targetData.hitChance
			rAimPosition = targetData.aimPosition
		end		
	end
	
	if rHitChance >= minimumHitChance then
		return rHitChance, rAimPosition
	end	
end

function HPred:GetHitchance(source, target, range, delay, speed, radius, checkCollision)	
	local hitChance = 1	
	
	local aimPosition = self:PredictUnitPosition(target, delay + self:GetDistance(source, target.pos) / speed)	
	local interceptTime = self:GetSpellInterceptTime(source, aimPosition, delay, speed)
	local reactionTime = self:PredictReactionTime(target, .1)
	
	--If they just now changed their path then assume they will keep it for at least a short while... slightly higher chance
	if _movementHistory and _movementHistory[target.charName] and LocalGameTimer() - _movementHistory[target.charName]["ChangedAt"] < .25 then
		hitChance = 2
	end

	--If they are standing still give a higher accuracy because they have to take actions to react to it
	if not target.pathing or not target.pathing.hasMovePath then
		hitChance = 2
	end	
	
	
	local origin,movementRadius = self:UnitMovementBounds(target, interceptTime, reactionTime)
	--Our spell is so wide or the target so slow or their reaction time is such that the spell will be nearly impossible to avoid
	if movementRadius - target.boundingRadius <= radius /2 then
		origin,movementRadius = self:UnitMovementBounds(target, interceptTime, 0)
		if movementRadius - target.boundingRadius <= radius /2 then
			hitChance = 4
		else		
			hitChance = 3
		end
	end	
	
	--If they are casting a spell then the accuracy will be fairly high. if the windup is longer than our delay then it's quite likely to hit. 
	--Ideally we would predict where they will go AFTER the spell finishes but that's beyond the scope of this prediction
	if target.activeSpell and target.activeSpell.valid then
		if target.activeSpell.startTime + target.activeSpell.windup - LocalGameTimer() >= delay then
			hitChance = 5
		else			
			hitChance = 3
		end
	end
	
	--Check for out of range
	if not self:IsInRange(myHero.pos, aimPosition, range) then
		hitChance = -1
	end
	
	--Check minion block
	if hitChance > 0 and checkCollision then
		if self:IsWindwallBlocking(source, aimPosition) then
			hitChance = -1		
		elseif self:CheckMinionCollision(source, aimPosition, delay, speed, radius) then
			hitChance = -1
		end
	end
	
	return hitChance, aimPosition
end

function HPred:PredictReactionTime(unit, minimumReactionTime)
	local reactionTime = minimumReactionTime
	if not unit or not reactionTime then return end
	--If the target is auto attacking increase their reaction time by .15s - If using a skill use the remaining windup time
	if unit.activeSpell and unit.activeSpell.valid then
		local windupRemaining = unit.activeSpell.startTime + unit.activeSpell.windup - LocalGameTimer()
		if windupRemaining > 0 then
			reactionTime = windupRemaining
		end
	end
	
	return reactionTime
end

function HPred:GetDashingTarget(source, range, delay, speed, dashThreshold, checkCollision, radius, midDash)

	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and t.isEnemy and t.pathing.hasMovePath and t.pathing.isDashing and t.pathing.dashSpeed>500  then
			local dashEndPosition = t:GetPath(1)
			if self:IsInRange(source, dashEndPosition, range) then				
				--The dash ends within range of our skill. We now need to find if our spell can connect with them very close to the time their dash will end
				local dashTimeRemaining = self:GetDistance(t.pos, dashEndPosition) / t.pathing.dashSpeed
				local skillInterceptTime = self:GetSpellInterceptTime(myHero.pos, dashEndPosition, delay, speed)
				local deltaInterceptTime =skillInterceptTime - dashTimeRemaining
				if deltaInterceptTime > 0 and deltaInterceptTime < dashThreshold and (not checkCollision or not self:CheckMinionCollision(source, dashEndPosition, delay, speed, radius)) then
					target = t
					aimPosition = dashEndPosition
					return target, aimPosition
				end
			end			
		end
	end
end

function HPred:GetHourglassTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and t.isEnemy then		
			local success, timeRemaining = self:HasBuff(t, "zhonyasringshield")
			if success then
				local spellInterceptTime = self:GetSpellInterceptTime(myHero.pos, t.pos, delay, speed)
				local deltaInterceptTime = spellInterceptTime - timeRemaining
				if spellInterceptTime > timeRemaining and deltaInterceptTime < timingAccuracy and (not checkCollision or not self:CheckMinionCollision(source, interceptPosition, delay, speed, radius)) then
					target = t
					aimPosition = t.pos
					return target, aimPosition
				end
			end
		end
	end
end

function HPred:GetRevivingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for _, revive in pairs(_cachedRevives) do
		if revive and revive.isEnemy then
			local interceptTime = self:GetSpellInterceptTime(source, revive.pos, delay, speed)
			if interceptTime > revive.expireTime - LocalGameTimer() and interceptTime - revive.expireTime - LocalGameTimer() < timingAccuracy then
				target = revive.target
				aimPosition = revive.pos
				return target, aimPosition
			end
		end
	end	
end

function HPred:GetInstantDashTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and t.isEnemy and t.activeSpell and t.activeSpell.valid and _blinkSpellLookupTable[t.activeSpell.name] then
			local windupRemaining = t.activeSpell.startTime + t.activeSpell.windup - LocalGameTimer()
			if windupRemaining > 0 then
				local endPos
				local blinkRange = _blinkSpellLookupTable[t.activeSpell.name]
				if type(blinkRange) == "table" then
					--Find the nearest matching particle to our mouse
					--local target, distance = self:GetNearestParticleByNames(t.pos, blinkRange)
					--if target and distance < 250 then					
					--	endPos = target.pos		
					--end
				elseif blinkRange > 0 then
					endPos = Vector(t.activeSpell.placementPos.x, t.activeSpell.placementPos.y, t.activeSpell.placementPos.z)					
					endPos = t.activeSpell.startPos + (endPos- t.activeSpell.startPos):Normalized() * _min(self:GetDistance(t.activeSpell.startPos,endPos), range)
				else
					local blinkTarget = self:GetObjectByHandle(t.activeSpell.target)
					if blinkTarget then				
						local offsetDirection						
						
						--We will land in front of our target relative to our starting position
						if blinkRange == 0 then				

							if t.activeSpell.name ==  "AlphaStrike" then
								windupRemaining = windupRemaining + .75
								--TODO: Boost the windup time by the number of targets alpha will hit. Need to calculate the exact times this is just rough testing right now
							end						
							offsetDirection = (blinkTarget.pos - t.pos):Normalized()
						--We will land behind our target relative to our starting position
						elseif blinkRange == -1 then						
							offsetDirection = (t.pos-blinkTarget.pos):Normalized()
						--They can choose which side of target to come out on , there is no way currently to read this data so we will only use this calculation if the spell radius is large
						elseif blinkRange == -255 then
							if radius > 250 then
								endPos = blinkTarget.pos
							end							
						end
						
						if offsetDirection then
							endPos = blinkTarget.pos - offsetDirection * blinkTarget.boundingRadius
						end
						
					end
				end	
				
				local interceptTime = self:GetSpellInterceptTime(myHero.pos, endPos, delay,speed)
				local deltaInterceptTime = interceptTime - windupRemaining
				if self:IsInRange(source, endPos, range) and deltaInterceptTime < timingAccuracy and (not checkCollision or not self:CheckMinionCollision(source, endPos, delay, speed, radius)) then
					target = t
					aimPosition = endPos
					return target,aimPosition					
				end
			end
		end
	end
end

function HPred:GetBlinkTarget(source, range, speed, delay, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameParticleCount() do 
		local particle = LocalGameParticle(i)
		if particle and _blinkLookupTable[particle.name] and self:IsInRange(source, particle.pos, range) then
			local pPos = particle.pos
			for k,v in pairs(self:GetEnemyHeroes()) do
				local t = v
				if t and t.isEnemy and self:IsInRange(t.pos, pPos, t.boundingRadius) then
					if (not checkCollision or not self:CheckMinionCollision(source, pPos, delay, speed, radius)) then
						target = t
						aimPosition = pPos
						return target,aimPosition
					end
				end
			end
		end
	end
end

function HPred:GetChannelingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t then
			local interceptTime = self:GetSpellInterceptTime(myHero.pos, t.pos, delay, speed)
			if self:CanTarget(t) and self:IsInRange(source, t.pos, range) and self:IsChannelling(t, interceptTime) and (not checkCollision or not self:CheckMinionCollision(source, t.pos, delay, speed, radius)) then
				target = t
				aimPosition = t.pos	
				return target, aimPosition
			end
		end
	end
end

function HPred:GetImmobileTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)
	local target
	local aimPosition
	for i = 1, LocalGameHeroCount() do
		local t = LocalGameHero(i)
		if t and self:CanTarget(t) and self:IsInRange(source, t.pos, range) then
			local immobileTime = self:GetImmobileTime(t)
			
			local interceptTime = self:GetSpellInterceptTime(source, t.pos, delay, speed)
			if immobileTime - interceptTime > timingAccuracy and (not checkCollision or not self:CheckMinionCollision(source, t.pos, delay, speed, radius)) then
				target = t
				aimPosition = t.pos
				return target, aimPosition
			end
		end
	end
end

function HPred:CacheTeleports()
	--Get enemies who are teleporting to towers
--[[	for i = 1, LocalGameTurretCount() do
		local turret = LocalGameTurret(i);
		if turret and turret.isEnemy and not _cachedTeleports[turret.networkID] then
			local hasBuff, expiresAt = self:HasBuff(turret, "teleport_target")
			if hasBuff then
				self:RecordTeleport(turret, self:GetTeleportOffset(turret.pos,223.31),expiresAt)
			end
		end
	end	]]
	
	--Get enemies who are teleporting to wards	
--[[	for i = 1, LocalGameWardCount() do
		local ward = LocalGameWard(i);
		if ward and ward.isEnemy and not _cachedTeleports[ward.networkID] then
			local hasBuff, expiresAt = self:HasBuff(ward, "teleport_target")
			if hasBuff then
				self:RecordTeleport(ward, self:GetTeleportOffset(ward.pos,100.01),expiresAt)
			end
		end
	end]] -- Temporary disabled (crashes?)
	
	--Get enemies who are teleporting to minions
	for i = 1, LocalGameMinionCount() do
		local minion = LocalGameMinion(i);
		if minion and minion.isEnemy and not _cachedTeleports[minion.networkID] then
			local hasBuff, expiresAt = self:HasBuff(minion, "teleport_target")
			if hasBuff then
				self:RecordTeleport(minion, self:GetTeleportOffset(minion.pos,143.25),expiresAt)
			end
		end
	end
end

function HPred:RecordTeleport(target, aimPos, endTime)
	_cachedTeleports[target.networkID] = {}
	_cachedTeleports[target.networkID]["target"] = target
	_cachedTeleports[target.networkID]["aimPos"] = aimPos
	_cachedTeleports[target.networkID]["expireTime"] = endTime + LocalGameTimer()
end


function HPred:CalculateIncomingDamage()
	_incomingDamage = {}
	local currentTime = LocalGameTimer()
	for _, missile in pairs(_cachedMissiles) do
		if missile then 
			local dist = self:GetDistance(missile.data.pos, missile.target.pos)			
			if missile.name == "" or currentTime >= missile.timeout or dist < missile.target.boundingRadius then
				_cachedMissiles[_] = nil
			else
				if not _incomingDamage[missile.target.networkID] then
					_incomingDamage[missile.target.networkID] = missile.damage
				else
					_incomingDamage[missile.target.networkID] = _incomingDamage[missile.target.networkID] + missile.damage
				end
			end
		end
	end	
end

function HPred:GetIncomingDamage(target)
	local damage = 0
	if target and _incomingDamage[target.networkID] then
		damage = _incomingDamage[target.networkID]
	end
	return damage
end


local _maxCacheRange = 3000

--Right now only used to cache enemy windwalls
function HPred:CacheParticles()	
	if _windwall and _windwall.name == "" then
		_windwall = nil
	end
	
	for i = 1, LocalGameParticleCount() do
		local particle = LocalGameParticle(i)		
		if particle and self:IsInRange(particle.pos, myHero.pos, _maxCacheRange) then			
			if _find(particle.name, "W_windwall%d") and not _windwall then
				--We don't care about ally windwalls for now
				local owner =  self:GetObjectByHandle(particle.handle)
				if owner and owner.isEnemy then
					_windwall = particle
					_windwallStartPos = Vector(particle.pos.x, particle.pos.y, particle.pos.z)				
					
					local index = _len(particle.name) - 5
					local spellLevel = _sub(particle.name, index, index) -1 
					_windwallWidth = 150 + spellLevel * 25					
				end
			end
		end
	end
end

function HPred:CacheMissiles()
	local currentTime = LocalGameTimer()
	for i = 1, LocalGameMissileCount() do
		local missile = LocalGameMissile(i)
		if missile and not _cachedMissiles[missile.networkID] and missile.missileData then
			--Handle targeted missiles
			if missile.missileData.target and missile.missileData.owner then
				local missileName = missile.missileData.name
				local owner =  self:GetObjectByHandle(missile.missileData.owner)	
				local target =  self:GetObjectByHandle(missile.missileData.target)		
				if owner and target and _find(target.type, "Hero") then			
					--The missile is an auto attack of some sort that is targeting a player	
					if (_find(missileName, "BasicAttack") or _find(missileName, "CritAttack")) then
						--Cache it all and update the count
						_cachedMissiles[missile.networkID] = {}
						_cachedMissiles[missile.networkID].target = target
						_cachedMissiles[missile.networkID].data = missile
						_cachedMissiles[missile.networkID].danger = 1
						_cachedMissiles[missile.networkID].timeout = currentTime + 1.5
						
						local damage = owner.totalDamage
						if _find(missileName, "CritAttack") then
							--Leave it rough we're not that concerned
							damage = damage * 1.5
						end						
						_cachedMissiles[missile.networkID].damage = self:CalculatePhysicalDamage(target, damage)
					end
				end
			end
		end
	end
end

function HPred:CalculatePhysicalDamage(target, damage)
	
	local localDmg = 0
	if target and damage then		
		local targetArmor = target.armor * myHero.armorPenPercent - myHero.armorPen
		local damageReduction = 100 / ( 100 + targetArmor)
		if targetArmor < 0 then
			damageReduction = 2 - (100 / (100 - targetArmor))
		end		
		localDmg = damage * damageReduction
	end
	return localDmg
end

function HPred:CalculateMagicalDamage(target, damage)
	
	local localDmg = 0
	if target and damage then	
		local targetMR = target.magicResist * myHero.magicPenPercent - myHero.magicPen
		local damageReduction = 100 / ( 100 + targetMR)
		if targetMR < 0 then
			damageReduction = 2 - (100 / (100 - targetMR))
		end		
		localDmg = damage * damageReduction
	end
	
	return localDmg
end


function HPred:GetTeleportingTarget(source, range, delay, speed, timingAccuracy, checkCollision, radius)

	local target
	local aimPosition
	for _, teleport in pairs(_cachedTeleports) do
		if teleport and teleport.expireTime > LocalGameTimer() and self:IsInRange(source,teleport.aimPos, range) then			
			local spellInterceptTime = self:GetSpellInterceptTime(source, teleport.aimPos, delay, speed)
			local teleportRemaining = teleport.expireTime - LocalGameTimer()
			if spellInterceptTime > teleportRemaining and spellInterceptTime - teleportRemaining <= timingAccuracy and (not checkCollision or not self:CheckMinionCollision(source, teleport.aimPos, delay, speed, radius)) then								
				target = teleport.target
				aimPosition = teleport.aimPos
				return target, aimPosition
			end
		end
	end		
end

function HPred:GetTargetMS(target)
	if target then
		local ms = target.pathing.isDashing and target.pathing.dashSpeed or target.ms
		return ms
	end
	return _huge
end

function HPred:Angle(A, B)

	if A and B then
		local deltaPos = A - B
		local angle = _atan(deltaPos.x, deltaPos.z) *  180 / _pi	
		if angle < 0 then angle = angle + 360 end
		return angle
	end
end

function HPred:UpdateMovementHistory(unit)

	if not unit then return end

	if not _movementHistory[unit.charName] then
		_movementHistory[unit.charName] = {}
		_movementHistory[unit.charName]["EndPos"] = unit.pathing.endPos
		_movementHistory[unit.charName]["StartPos"] = unit.pathing.endPos
		_movementHistory[unit.charName]["PreviousAngle"] = 0
		_movementHistory[unit.charName]["ChangedAt"] = LocalGameTimer()
	end
		
	if _movementHistory[unit.charName]["EndPos"].x ~=unit.pathing.endPos.x or _movementHistory[unit.charName]["EndPos"].y ~=unit.pathing.endPos.y or _movementHistory[unit.charName]["EndPos"].z ~=unit.pathing.endPos.z then				
		_movementHistory[unit.charName]["PreviousAngle"] = self:Angle(Vector(_movementHistory[unit.charName]["StartPos"].x, _movementHistory[unit.charName]["StartPos"].y, _movementHistory[unit.charName]["StartPos"].z), Vector(_movementHistory[unit.charName]["EndPos"].x, _movementHistory[unit.charName]["EndPos"].y, _movementHistory[unit.charName]["EndPos"].z))
		_movementHistory[unit.charName]["EndPos"] = unit.pathing.endPos
		_movementHistory[unit.charName]["StartPos"] = unit.pos
		_movementHistory[unit.charName]["ChangedAt"] = LocalGameTimer()
	end
end

--Returns where the unit will be when the delay has passed given current pathing information. This assumes the target makes NO CHANGES during the delay.
function HPred:PredictUnitPosition(unit, delay)

	if not unit or not delay then return end
	local predictedPosition = unit.pos
	local timeRemaining = delay
	local pathNodes = self:GetPathNodes(unit)
	for i = 1, #pathNodes -1 do
		local nodeDistance = self:GetDistance(pathNodes[i], pathNodes[i +1])
		local nodeTraversalTime = nodeDistance / self:GetTargetMS(unit)
			
		if timeRemaining > nodeTraversalTime then
			--This node of the path will be completed before the delay has finished. Move on to the next node if one remains
			timeRemaining =  timeRemaining - nodeTraversalTime
			predictedPosition = pathNodes[i + 1]
		else
			local directionVector = (pathNodes[i+1] - pathNodes[i]):Normalized()
			predictedPosition = pathNodes[i] + directionVector *  self:GetTargetMS(unit) * timeRemaining
			break;
		end
	end
	return predictedPosition
end

function HPred:IsChannelling(target, interceptTime)
	if not target then return false end
	if target.activeSpell and target.activeSpell.valid and target.activeSpell.isChanneling then
		return true
	end
end

function HPred:HasBuff(target, buffName, minimumDuration)
	local duration = minimumDuration
	if not minimumDuration then
		duration = 0
	end
	if not target then return false end
	local durationRemaining
	for i = 1, target.buffCount do
		local buff = target:GetBuff(i)
		if buff and buff.duration > duration and buff.name == buffName then
			durationRemaining = buff.duration
			return true, durationRemaining
		end
	end
end

--Moves an origin towards the enemy team nexus by magnitude
function HPred:GetTeleportOffset(origin, magnitude)
	local teleportOffset = origin + (self:GetEnemyNexusPosition()- origin):Normalized() * magnitude
	return teleportOffset
end

function HPred:GetSpellInterceptTime(startPos, endPos, delay, speed)	
	local interceptTime = LocalGameLatency()/2000 + delay + self:GetDistance(startPos, endPos) / speed
	return interceptTime
end

--Checks if a target can be targeted by abilities or auto attacks currently.
--CanTarget(target)
	--target : gameObject we are trying to hit
function HPred:CanTarget(target)
	return target and target.isEnemy and target.alive and target.visible and target.isTargetable
end

--Derp: dont want to fuck with the isEnemy checks elsewhere. This will just let us know if the target can actually be hit by something even if its an ally
function HPred:CanTargetALL(target)
	return target and target.alive and target.visible and target.isTargetable
end

--Returns a position and radius in which the target could potentially move before the delay ends. ReactionTime defines how quick we expect the target to be able to change their current path
function HPred:UnitMovementBounds(unit, delay, reactionTime)

	if not unit then return end
	local startPosition = self:PredictUnitPosition(unit, delay)
	
	local radius = 0
	local deltaDelay = delay -reactionTime- self:GetImmobileTime(unit)	
	if (deltaDelay >0) then
		radius = self:GetTargetMS(unit) * deltaDelay	
	end
	return startPosition, radius	
end

--Returns how long (in seconds) the target will be unable to move from their current location
function HPred:GetImmobileTime(unit)

	if not unit then return 0 end
	local duration = 0
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i);
		if buff and buff.count > 0 and buff.duration > duration and (buff.type == 5 or buff.type == 8 or buff.type == 21 or buff.type == 22 or buff.type == 24 or buff.type == 11 or buff.type == 29 or buff.type == 30 or buff.type == 39 ) then
			duration = buff.duration
		end
	end
	return duration		
end

--Returns how long (in seconds) the target will be slowed for
function HPred:GetSlowedTime(unit)

	if not unit then return 0 end
	local duration = 0
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i);
		if buff and buff.count > 0 and buff.duration > duration and buff.type == 10 then
			duration = buff.duration			
			return duration
		end
	end
	return duration		
end

--Returns all existing path nodes
function HPred:GetPathNodes(unit)
	local nodes = {}
	_insert(nodes, unit.pos)
	if unit and unit.pathing and unit.pathing.hasMovePath then
		for i = unit.pathing.pathIndex, unit.pathing.pathCount do
			path = unit:GetPath(i)
			_insert(nodes, path)
		end
	end		
	return nodes
end

--Finds any game object with the correct handle to match (hero, minion, wards on either team)
function HPred:GetObjectByHandle(handle)

	if not handle then return nil end

	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.handle == handle then
			target = enemy
			return target
		end
	end
	
	for i = 1, LocalGameMinionCount() do
		local minion = LocalGameMinion(i)
		if minion and minion.handle == handle then
			target = minion
			return target
		end
	end
	
--[[	for i = 1, LocalGameWardCount() do
		local ward = LocalGameWard(i);
		if ward and ward.handle == handle then
			target = ward
			return target
		end
	end]]
	
--[[	for i = 1, LocalGameTurretCount() do 
		local turret = LocalGameTurret(i)
		if turret and turret.handle == handle then
			target = turret
			return target
		end
	end]]
	
	for i = 1, Game.ParticleCount() do 
		local particle = Game.Particle(i)
		if particle and particle.handle == handle then
			target = particle
			return target
		end
	end
end

function HPred:GetHeroByPosition(position)

	if not position then return nil end
	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
end

function HPred:GetObjectByPosition(position)

	if not position then return nil end
	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
	
	for i = 1, LocalGameMinionCount() do
		local enemy = LocalGameMinion(i)
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
--[[	
	for i = 1, LocalGameWardCount() do
		local enemy = LocalGameWard()
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end]]
	
	for i = 1, LocalGameParticleCount() do 
		local enemy = LocalGameParticle()
		if enemy and enemy.pos.x == position.x and enemy.pos.y == position.y and enemy.pos.z == position.z then
			target = enemy
			return target
		end
	end
end

function HPred:GetEnemyHeroByHandle(handle)	

	if not handle then return nil end
	local target
	for i = 1, LocalGameHeroCount() do
		local enemy = LocalGameHero(i)
		if enemy and enemy.handle == handle then
			target = enemy
			return target
		end
	end
end

--Finds the closest particle to the origin that is contained in the names array
function HPred:GetNearestParticleByNames(origin, names)
	local target
	local distance = 999999
	for i = 1, LocalGameParticleCount() do 
		local particle = LocalGameParticle(i)
		if particle then 
			local d = self:GetDistance(origin, particle.pos)
			if d < distance then
				distance = d
				target = particle
			end
		end
	end
	return target, distance
end

--Returns the total distance of our current path so we can calculate how long it will take to complete
function HPred:GetPathLength(nodes)
	if not nodes then return 0 end
	local result = 0
	for i = 1, #nodes -1 do
		result = result + self:GetDistance(nodes[i], nodes[i + 1])
	end
	return result
end


--I know this isn't efficient but it works accurately... Leaving it for now.
function HPred:CheckMinionCollision(origin, endPos, delay, speed, radius, frequency)
	
	if origin and endpos and radius then
		if not frequency then
			frequency = radius
		end
		local directionVector = (endPos - origin):Normalized()
		local checkCount = self:GetDistance(origin, endPos) / frequency
		for i = 1, checkCount do
			local checkPosition = origin + directionVector * i * frequency
			local checkDelay = delay + self:GetDistance(origin, checkPosition) / speed
			if self:IsMinionIntersection(checkPosition, radius, checkDelay, radius * 3) then
				return true
			end
		end
	end
	return false
end


function HPred:IsMinionIntersection(location, radius, delay, maxDistance)

	if location and radius and delay then
		if not maxDistance then
			maxDistance = 500
		end
		for i = 1, Game.MinionCount() do
			local minion = Game.Minion(i)
			if minion and self:CanTarget(minion) and self:IsInRange(minion.pos, location, maxDistance) then
				local predictedPosition = self:PredictUnitPosition(minion, delay)
				if self:IsInRange(location, predictedPosition, radius + minion.boundingRadius) then
					return true
				end
			end
		end
	end
	return false
end

function HPred:VectorPointProjectionOnLineSegment(v1, v2, v)
	if v1 and v2 and v then
		assert(v1 and v2 and v, "VectorPointProjectionOnLineSegment: wrong argument types (3 <Vector> expected)")
		local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
		local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
		local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
		local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
		local isOnSegment = rS == rL
		local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), y = ay + rS * (by - ay) }
	end
	return pointSegment, pointLine, isOnSegment
end

--Determines if there is a windwall between the source and target pos. 
function HPred:IsWindwallBlocking(source, target)
	if _windwall and source and target then
		local windwallFacing = (_windwallStartPos-_windwall.pos):Normalized()
		return self:DoLineSegmentsIntersect(source, target, _windwall.pos + windwallFacing:Perpendicular() * _windwallWidth, _windwall.pos + windwallFacing:Perpendicular2() * _windwallWidth)
	end	
	return false
end
--Returns if two line segments cross eachother. AB is segment 1, CD is segment 2.
function HPred:DoLineSegmentsIntersect(A, B, C, D)

	local o1 = self:GetOrientation(A, B, C)
	local o2 = self:GetOrientation(A, B, D)
	local o3 = self:GetOrientation(C, D, A)
	local o4 = self:GetOrientation(C, D, B)
	
	if o1 ~= o2 and o3 ~= o4 then
		return true
	end
	
	if o1 == 0 and self:IsOnSegment(A, C, B) then return true end
	if o2 == 0 and self:IsOnSegment(A, D, B) then return true end
	if o3 == 0 and self:IsOnSegment(C, A, D) then return true end
	if o4 == 0 and self:IsOnSegment(C, B, D) then return true end
	
	return false
end

--Determines the orientation of ordered triplet
--0 = Colinear
--1 = Clockwise
--2 = CounterClockwise
function HPred:GetOrientation(A,B,C)
	if A and B and C then
		local val = (B.z - A.z) * (C.x - B.x) -
			(B.x - A.x) * (C.z - B.z)
		if val == 0 then
			return 0
		elseif val > 0 then
			return 1
		else
			return 2
		end
	end
	return 0
end

function HPred:IsOnSegment(A, B, C)
	return B.x <= _max(A.x, C.x) and 
		B.x >= _min(A.x, C.x) and
		B.z <= _max(A.z, C.z) and
		B.z >= _min(A.z, C.z)
end

--Gets the slope between two vectors. Ignores Y because it is non-needed height data. Its all 2d math.
function HPred:GetSlope(A, B)
	return (B.z - A.z) / (B.x - A.x)
end

function HPred:GetEnemyByName(name)
	local target
	if name then
		for i = 1, LocalGameHeroCount() do
			local enemy = LocalGameHero(i)
			if enemy and enemy.isEnemy and enemy.charName == name then
				target = enemy
				return target
			end
		end
	end
	return nil
end

function HPred:IsPointInArc(source, origin, target, angle, range)
	if origin and target and source and angle and range then
		local deltaAngle = _abs(HPred:Angle(origin, target) - HPred:Angle(source, origin))
		if deltaAngle < angle and self:IsInRange(origin,target,range) then
			return true
		end
	end
	return false
end

function HPred:GetEnemyHeroes()
	return Utils:GetEnemyHeroes()
end -- #Lazy

function HPred:GetDistanceSqr(p1, p2)	
	return Utils:GetDistanceSqr(p1, p2)
end -- #Lazy

function HPred:IsInRange(p1, p2, range)
	return self:GetDistance(p1, p2) <= range
end

function HPred:GetDistance(p1, p2)
	return _sqrt(self:GetDistanceSqr(p1, p2))
end

--[[print("Q Name: " ..myHero:GetSpellData(_Q).name..  " | Q Range: " ..myHero:GetSpellData(_Q).range.. " | Q Width: " ..myHero:GetSpellData(_Q).width.. " | Q Speed: " ..myHero:GetSpellData(_Q).speed)
print("W Name: " ..myHero:GetSpellData(_W).name..  " | W Range: " ..myHero:GetSpellData(_W).range.. " | W Width: " ..myHero:GetSpellData(_W).width.. " | W Speed: " ..myHero:GetSpellData(_W).speed)
print("E Name: " ..myHero:GetSpellData(_E).name..  " | E Range: " ..myHero:GetSpellData(_E).range.. " | E Width: " ..myHero:GetSpellData(_E).width.. " | E Speed: " ..myHero:GetSpellData(_E).speed)
print("R Name: " ..myHero:GetSpellData(_R).name..  " | R Range: " ..myHero:GetSpellData(_R).range.. " | R Width: " ..myHero:GetSpellData(_R).width.. " | R Speed: " ..myHero:GetSpellData(_R).speed)]]

-- Last but not least https://i.imgur.com/rQJRA8u.png 