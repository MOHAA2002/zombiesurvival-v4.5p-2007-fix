-- Zombie Survival v4.5 public
-- By JetBoom

-- V Options V

_ServerCommand("mapcyclefile maplist.txt\n")
-- Set this lower or higher depending on how hard you want the mod.
-- 3.0 = ZS V2 difficulty. 4.0 = ZS V3 Extreme Difficulty
-- 3.5 or more - Reviving
DIFFICULTY = 4.1
-- Force the server to replace npc_makers with Lua makers, regardless of the server is Windows or Linux.
FORCELINUXSPAWN = true
-- Time in minutes how long humans must survive. If you have human resurrect on, make this a bit higher.
ROUNDTIME = 20
-- Time in seconds after the round ends before the map is reset
INTERMISSIONTIME = 30
-- Can player zombies resurrect after they kill humans? Put the amount of human kills here. Leave at 0 to disable.
HUMANRESURRECT = 3
-- Music/sound used when all humans are dead
ZOMBIEWINSOUND = "youlose2.wav"
-- Music/sound used when humans survive
HUMANWINSOUND = "zombiesurvival/humanvictory.mp3"
-- Music/sound used when 1 human is left. ONLY works when atleast 4 players in server
LASTHUMANSOUND = "zombiesurvival/lasthuman_noxious.mp3"
-- Music/sound played when "Half-Life" has been reached.
HALFLIFESOUND = "zombiesurvival/halflife_noxious.mp3"
-- Music/sound played to a person when they turn to The Undead
DEATHSOUND = "music/stingers/HL1_stinger_song28.mp3"
-- Percent of round time before no one can join as a human
HUMANDEADLINE = 0.25
-- If true, a person is killed when the round starts.
RANDOMFIRSTZOMBIE = true
-- Starting weapon.
STARTWEAPON = "weapons/zombiesurvival/weapon_battleaxe.lua"

REWARDS = {} -- Leave this
-- SWEPs and normal items (weapon_357, ect) work here.
REWARDS[10] = {[1]="weapons/zombiesurvival/weapon_deagle.lua", [2]="weapons/zombiesurvival/weapon_glock3.lua"}
REWARDS[25] = {[1]="weapons/zombiesurvival/weapon_uzi.lua", [2]="weapons/zombiesurvival/weapon_smg.lua"}
REWARDS[45] = {[1]="weapons/zombiesurvival/weapon_sweepershotgunmk2.lua", [2]="weapons/zombiesurvival/weapon_barricadekit.lua"}
REWARDS[60] = {[1]="weapons/zombiesurvival/weapon_rifle.lua", [2]="weapon_crossbow"}
REWARDS[80] = {[1]="weapons/zombiesurvival/weapon_boomstick.lua", [2]="weapons/zombiesurvival/weapon_slamgiver.lua"}
REWARDS[105] = {[1]="weapons/zombiesurvival/weapon_ak47.lua"}
REWARDS[130] = {[1]="weapon_physcannon"}
REWARDS[160] = {[1]="weapons/zombiesurvival/weapon_rocketlauncher.lua"}

function PlayerSetMaxSpeed(userid, speed)
	AddTimer(0.1, 1, _PlayerSetMaxSpeed, userid, speed)
end

-- Name = Display name.
-- Health = Starting health.
-- Threshold = Infliction required.
-- SWEP = Scripted weapon given.
-- Model = Model used.
-- Speed = Max walking speed.
ZombieClasses = {} -- Leave this
ZombieClasses[1] = {Name = "Zombie", Revives = true, Health = 145, Threshold = 0.0, SWEP = "weapons/zombiesurvival/weapon_zombieknife.lua", Model = "models/player/classic.mdl", Speed = 130}
ZombieClasses[2] = {Name = "Fast Zombie", Health = 75, Threshold = 0.5, SWEP = "weapons/zombiesurvival/weapon_fastzombieknife.lua", Model = "models/player/corpse1.mdl", Speed = 220}
ZombieClasses[3] = {Name = "Poison Zombie", Health = 225, Threshold = 0.75, SWEP = "weapons/zombiesurvival/weapon_poisonzombieknife.lua", Model = "models/player/charple01.mdl", Speed = 110}
ZombieClasses[4] = {Name = "Headcrab", Health = 25, Threshold = 0.0, SWEP = "weapons/zombiesurvival/weapon_headcrabknife.lua", Model = "models/headcrabclassic.mdl", Speed = 170}
ZombieClasses[5] = {Name = "Fast Headcrab", Health = 25, Threshold = 0.5, SWEP = "weapons/zombiesurvival/weapon_headcrabknife.lua", Model = "models/headcrab.mdl", Speed = 250}
ZombieClasses[6] = {Name = "Taliban Zombie", Health = 10, Threshold = 0.75, SWEP = "weapons/zombiesurvival/weapon_firezombie.lua", Model = "models/player/classic.mdl", Speed = 190}

-- V Developers V

ENDROUND = false
LASTHUMAN = false
HALFLIFE = false
QUARTERLIFE = false
FIRSTDIED = false
ARCADEMODE = false
INFLICTION = 0.01
ROUNDEND = 0
KILLEDPEOPLE = ""
HALFLIFEENTITY = _EntCreate("ambient_generic")
LASTHUMANENTITY = _EntCreate("ambient_generic")
if HALFLIFEENTITY > 0 then
	_EntSetKeyValue(HALFLIFEENTITY, "message", HALFLIFESOUND)
	_EntSetKeyValue(HALFLIFEENTITY, "fadein", "3")
	_EntSetKeyValue(HALFLIFEENTITY, "fadeout", "3")
	_EntSetKeyValue(HALFLIFEENTITY, "volstart", "10")
	_EntSetKeyValue(HALFLIFEENTITY, "health", "10")
	_EntSetKeyValue(HALFLIFEENTITY, "spawnflags", "17")
	_EntSetPos(HALFLIFEENTITY, vector3(0,0,0))
	_EntSpawn(HALFLIFEENTITY)
end
if LASTHUMANENTITY > 0 then
	_EntSetKeyValue(LASTHUMANENTITY, "message", LASTHUMANSOUND)
	_EntSetKeyValue(LASTHUMANENTITY, "fadein", "3")
	_EntSetKeyValue(LASTHUMANENTITY, "fadeout", "3")
	_EntSetKeyValue(LASTHUMANENTITY, "volstart", "10")
	_EntSetKeyValue(LASTHUMANENTITY, "health", "10")
	_EntSetKeyValue(LASTHUMANENTITY, "spawnflags", "17")
	_EntSetPos(LASTHUMANENTITY, vector3(0,0,0))
	_EntSpawn(LASTHUMANENTITY)
end

PlayerInfo = {}
for i=1, _MaxPlayers() do
	PlayerInfo[i] = {}
	PlayerInfo[i].Class = 1
	PlayerInfo[i].LastChange = -30
	PlayerInfo[i].KilledSelf = false
end

function math.clamp(num, mi, ma)
	if num > ma then num = ma elseif
	num < mi then num = mi end
	return num
end

DIFFICULTY = math.clamp(DIFFICULTY, 0.75, 100.0)

function canPlayerHaveItem(playerid, itemname)
	if isUndead(playerid) then
		return string.find(ZombieClasses[PlayerInfo[playerid].Class].SWEP, itemname) ~= nil
	end
	return true
end

function GiveDefaultItems(userid)
	_player.ShouldDropWeapon(userid, false)
	if isUndead(userid) then
		if ENDROUND then return end
		_PlayerGiveSWEP(userid, ZombieClasses[PlayerInfo[userid].Class].SWEP or "none")
	else
		_PlayerGiveSWEP(userid, "weapons/zombiesurvival/weapon_swissarmyknife.lua")
		_PlayerGiveSWEP(userid, STARTWEAPON)
	end
end

ForbiddenModels = {}
for i=1, table.getn(ZombieClasses) do
	ForbiddenModels[ZombieClasses[i].Model] = true
end
-- Don't remove these two lines!
ForbiddenModels[DEFAULT_PLAYER_MODEL] = true
ForbiddenModels[""] = true

function PlayerSpawnChooseModel(userid)
	if _PlayerInfo(userid, "team") == TEAM_GREEN then
		_PlayerSetModel(userid, ZombieClasses[PlayerInfo[userid].Class].Model or "models/player/classic.mdl")
	else
		if _PlayerPreferredModel(userid) == "" then
			if _PlayerInfo(userid, "model") == DEFAULT_PLAYER_MODEL then
				_PlayerSetModel(userid, "models/player/male_02.mdl")
			end
		else
			local model = string.lower(_PlayerPreferredModel(userid))
			if ForbiddenModels[model] then
				_PlayerSetModel(userid, "models/player/male_02.mdl")
			else
				_PlayerSetModel(userid, model)
			end
		end
	end
end

function onShowHelp(userid)
	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0.2, 0.3, 0.0, 0.0 )
	 _GModRect_SetColor( 0, 0, 0, 100 )
	 _GModRect_SetTime( 15, 0, 1 )
	_GModRect_Send( userid, 50 )

	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0.198, 0.298, 0.604, 0.154 )
	 _GModRect_SetColor( 0, 0, 0, 150 )
	 _GModRect_SetTime( 15, 0, 1 )
	_GModRect_SendAnimate( userid, 50, 1, 0.2 )

	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0.2, 0.3, 0.0, 0.0 )
	 _GModRect_SetColor( 0, 0, 0, 10 )
	 _GModRect_SetTime( 15, 0, 1 )
	_GModRect_Send( userid, 51 )

	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0.2, 0.3, 0.6, 0.15 )
	 _GModRect_SetColor( 0, 0, 0, 50 )
	 _GModRect_SetTime( 15, 0, 1 )
	_GModRect_SendAnimate( userid, 51, 1, 0.2 )

	if isUndead(userid) then
	_GModText_Start( "Default" )
	 _GModText_SetPos( 0.21, 0.36 )
	 _GModText_SetColor( 255, 255, 255, 0 )
	 _GModText_SetTime( 15, 1, 1 )
	 _GModText_SetText( "You are part of The Undead. Kill humans to redeem yourself.\nYou may die as many times as it takes, but revive before the time limit! \n F4=Class Change")
	_GModText_Send( userid, 50 )
	else
	_GModText_Start( "Default" )
	 _GModText_SetPos( 0.21, 0.36 )
	 _GModText_SetColor( 255, 255, 255, 0 )
	 _GModText_SetTime( 15, 1, 1 )
	 _GModText_SetText( "Kill the undead to increase your score. You get weapons at certain score levels.\nDie and you will become an Undead! Humans must survive for the time set to win!" )
	_GModText_Send( userid, 50 )
	end
	
	_GModText_Start( "Default" )
	 _GModText_SetPos( 0.21, 0.36 )
	 _GModText_SetColor( 255, 255, 255, 255 )
	 _GModText_SetTime( 15, 1, 1 )
	_GModText_SendAnimate( userid, 50, 2, 0.2 )

	_GModText_Start( "ImpactMassive" )
	 _GModText_SetPos( 0.41, 0.295 )
	 _GModText_SetColor( 255, 255, 255, 0 )
	 _GModText_SetTime( 15, 1, 1 )
	 _GModText_SetText( "[HELP]" )
	_GModText_Send( userid, 51 )

	_GModText_Start( "ImpactMassive" )
	 _GModText_SetPos( 0.41, 0.295 )
	 _GModText_SetColor( 255, 255, 255, 255 )
	 _GModText_SetTime( 15, 1, 1 )
	_GModText_SendAnimate( userid, 51, 2, 0.2 )
end

function eventPlayerDisconnect(name, userid, address, steamid, reason)
	if IsPlayerOnline(userid) then
		PlayerInfo[userid].Class = 1
		PlayerInfo[userid].LastChange = -30
		PlayerInfo[userid].KilledSelf = false
		--CalculateInfliction()
	end
end

function onShowSpare2(userid)
	if not isUndead(userid) then
		BottomPrintMessage(userid, "This button is for Undead only.", 255, 255, 255, 200)
		return
	elseif _CurTime() < PlayerInfo[userid].LastChange+30.0 then
		BottomPrintMessage(userid, "You must wait a moment\nbefore switching classes!", 255, 255, 255, 200)
		return
	end
	DisplayClassMenu(userid)
end

function ChooseClass(userid, num, seconds)
	_GModRect_Hide(userid, 750, 0.25)
	_GModText_Hide(userid, 751, 0.25)
	local tab = {}
	local x = 1
	for i=1, table.getn(ZombieClasses) do
		if INFLICTION >= ZombieClasses[i].Threshold then
			tab[x] = i
			x = x + 1
		end
	end
	if num > table.getn(tab) then
		return
	end
	PlayerInfo[userid].Class = tab[num]
	CenterPrintMessage(userid, "You are now a "..ZombieClasses[PlayerInfo[userid].Class].Name, 255, 255, 255, 200)
	_PlayerSilentKill(userid, 2, true)
	PlayerInfo[userid].LastChange = _CurTime()
end

function DisplayClassMenu(userid)
	_PlayerOption(userid, "ChooseClass", 99999)	
	 _GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0.77, 0.37, 0.325, 0.25 )
	 _GModRect_SetColor( 0, 0, 0, 100 )
	 _GModRect_SetTime( 7.5, 1, 1 )
	_GModRect_Send( userid, 750 )

	_GModText_Start( "Default" )
	 _GModText_SetPos( 0.79, 0.4 )
	 _GModText_SetColor( 255, 255, 255, 255 )
	 _GModText_SetTime( 7.5, 1, 1 )
	 local str = "Choose a Class:\n"
	 local x = 1
	 for i=1, table.getn(ZombieClasses) do
		if INFLICTION >= ZombieClasses[i].Threshold then
			str = str..x..". "..ZombieClasses[i].Name.."\n"
			x = x + 1
		end
	 end
	 str = str.."\n"..x..". Cancel"
	 _GModText_SetText( str )
	_GModText_Send( userid, 751 )
end

function onGravGunPunt(userid, entity)
	if _EntGetModel(entity) == "models/props_lab/monitor01b.mdl" then
		_EntRemove(entity)
		return false
	end
	return true
end

function onGravGunPickup(userid, entity)
	if _EntGetModel(entity) == "models/props_lab/monitor01b.mdl" then
		_EntRemove(entity)
		return false
	end
	return true
end

function onShowTeam(userid)
	if isUndead(userid) then
		BottomPrintMessage(userid, "You'll havto wait till next round...", 255, 255, 255, 200)
	else
		BottomPrintMessage(userid, "Killing yourself might just work...", 255, 255, 255, 200)
	end
end

function GetPlayerDamageScale(hitgroup)
	if hitgroup == HITGROUP_HEAD then
		return 4.1
	end
	return 0.85
end

function isUndead(userid)
	return _PlayerInfo(userid,"team") == TEAM_GREEN
end

function eventKeyPressed(userid, in_key)
	if in_key == IN_WALK then
		if isUndead(userid) then
			_PlayerKill(userid)
			CenterPrintMessage(userid, "Walk = g4y", 255, 0, 0)
		end
	end
end

lastTick = 0
function gamerulesThink()
	if _CurTime() > lastTick+3 then
		gamerulesTick()
		lastTick = _CurTime()
	end
end

function gamerulesTick()
	_GModText_Start( "ImpactMassive" )
	 _GModText_SetPos( 0.005, 0.01 )
	 _GModText_SetColor( 0, 255, 0, 255 )
	 _GModText_SetTime( 9999, 0, 0 )
	 if not ENDROUND then
		 _GModText_SetText( ToMinutesSeconds(ROUNDTIME*60-_CurTime()) )
	 else
		 _GModText_SetText( "NR: "..ToMinutesSeconds(ROUNDEND+INTERMISSIONTIME-_CurTime()))
	 end
	_GModText_Send( 0, 666 )
	if not FIRSTDIED then
		if RANDOMFIRSTZOMBIE then
			if _TeamNumPlayers(TEAM_BLUE) > 3 then
				while not FIRSTDIED do
					local i = math.random(1, _MaxPlayers())
					if IsPlayerOnline(i) then
						if _PlayerInfo(i, "team") == TEAM_BLUE then
							JoinUndeadFirst(i)
						end
					end
				end
			end
		end
	end
	if not ENDROUND then
		if _CurTime() >= ROUNDTIME*60 then
			EndRound(1)
		end
	end
end

function PickDefaultSpawnTeam(userid)
	if _CurTime() > ROUNDTIME*60*HUMANDEADLINE or LASTHUMAN or string.find(KILLEDPEOPLE, _PlayerInfo(userid, "networkid")) then
		_PlayerChangeTeam(userid, TEAM_GREEN)
		KILLEDPEOPLE = KILLEDPEOPLE.._PlayerInfo(userid, "networkid")
		FIRSTDIED = true
		CalculateInfliction()
	else
		_PlayerChangeTeam(userid, TEAM_BLUE)
	end
	return true
end

function eventPlayerActive(name, userid, steamid)
	Splash(userid)
	drawInfliction(userid)
end

function drawInfliction(userid)
	_GModRect_Start("gmod/white")
	 _GModRect_SetPos(0.41, 0.96, (INFLICTION)*0.18, 0.05)
	 _GModRect_SetColor( math.floor(INFLICTION*255), math.floor(255-(INFLICTION*255)), 0, 255 )
	 _GModRect_SetTime(9999, 1, 1)
	_GModRect_Send(userid, 901)
end

function JoinUndead(userid, silent)
	_PlayerChangeTeam(userid, TEAM_GREEN)
	DrawUndeadOverlay(userid)
	CalculateInfliction()
	if not silent then
		_GModRect_Start("gmod/white-grad-down")
		 _GModRect_SetPos(0, 0, 1, 0.1)
		 _GModRect_SetColor(200, 0, 0, 255)
		 _GModRect_SetTime(3, 0.1, 0.5)
		_GModRect_Send(userid, 14101)
		_GModRect_Start("gmod/white")
		 _GModRect_SetPos(0, 0, 1, 3)
		 _GModRect_SetColor(200, 0, 0, 255)
		 _GModRect_SetTime(3, 1.25, 0.8)
		_GModRect_SendAnimate(userid, 14101, 4.3, 0.4)
		_GModRect_Start( "gmod/white" )
		 _GModRect_SetPos( 0, 0, 1, 1 )
		 _GModRect_SetColor( 0, 0, 0, 200 )
		 _GModRect_SetTime( 3, 2, 0.1 )
		 _GModRect_SetDelay( 1 )
		_GModRect_Send( userid, 14100 )
		_PlaySoundPlayer(userid, DEATHSOUND)
		_GModText_Start("ImpactMassive")
		 _GModText_SetPos(-1, 0)
		 _GModText_SetColor(200, 255, 255, 255)
		 _GModText_SetTime(7, 0.5, 0.5)
		 _GModText_SetText("You are dead.")
		_GModText_Send(userid, 61)
		_GModText_Start("ImpactMassive")
		 _GModText_SetPos(-1, 0.6)
		 _GModText_SetColor(255, 50, 0, 255)
		 _GModText_SetTime(7, 1.5, 1.5)
		 _GModText_SetText("You are dead.")
		_GModText_SendAnimate(userid, 61, 3, 0.4)
	end
	KILLEDPEOPLE = KILLEDPEOPLE.._PlayerInfo(userid, "networkid")
end

function JoinUndeadFirst(userid)
	_PlayerChangeTeam(userid, TEAM_GREEN)
	DrawUndeadOverlay(userid)
	CalculateInfliction()
	BottomPrintMessage(userid, "You have been chosen to\nstart the Undead army!", 255, 0, 0, 200)
	KILLEDPEOPLE = KILLEDPEOPLE.._PlayerInfo(userid, "networkid")
	FIRSTDIED = true
	_PlayerRespawn(userid)
end

function DrawUndeadOverlay(userid)
	_GModRect_Start( "gmod/white" )
 	 _GModRect_SetPos( 0, 0, 1, 1 )
	 _GModRect_SetColor( 255, 200, 90, 90 )
	 _GModRect_SetTime( 9999, 0, 0 )
	 _GModRect_SetDelay( 4 )
	_GModRect_Send( userid, 22 )
end

function HideUndeadOverlay(userid)
	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0, 0, 1, 1 )
	 _GModRect_SetColor( 255, 255, 255, 255 )
	 _GModRect_SetTime( 2, 0.1, 3 )
	_GModRect_Send( userid, 22 )
	_GModText_Start( "ImpactMassive" )
	 _GModText_SetPos( -1, 0.7 )
	 _GModText_SetColor( 0, 255, 0, 255 )
	 _GModText_SetTime( 5, 1, 1 )
	 _GModText_SetText( "You have redeemed yourself." )
	_GModText_Send( userid, 20000 )
end

LINUXSPAWNERS = {}
LINUXZOMBIES = 0
function gamerulesStartMap()
	PlayerFreezeAll( false )
	_TeamSetName( TEAM_BLUE, "Survivors" )
	_TeamSetName( TEAM_GREEN, "The Undead" )
	_TeamSetName( TEAM_YELLOW, "Error in script" )
	_TeamSetName( TEAM_RED, "Error in script" )
	_GameSetTargetIDRules(3)
	local result = _file.Find( "models/player/*.mdl" )
	for i=1, table.getn(result) do
	    if result[i] ~= "." and result[i] ~= ".." then
			if _file.Exists( "models/player/"..result[i]) then
				_EntPrecacheModel("models/player/"..result[i])
			end
		end
	end
	result = _file.Find( "models/weapons/*.mdl" )
	for i=1, table.getn(result) do
	    if result[i] ~= "." and result[i] ~= ".." then
			if _file.Exists( "models/player/"..result[i]) then
				_EntPrecacheModel("models/player/"..result[i])
			end
		end
	end
	_EntPrecacheModel("models/headcrabclassic.mdl")
	_EntPrecacheModel("models/headcrabblack.mdl")
	_EntPrecacheModel("models/headcrab.mdl")
	if not RANDOMFIRSTZOMBIE then
		FIRSTDIED = true
	end
	AddTimer(1, 1, SpawnDisp)
	local str = [["resources"
{
"sound/zombiesurvival/minutes.mp3" "file"
"sound/zombiesurvival/remaining.mp3" "file"
"materials/zombiesurvival/zssplash_v4.vmt" "file"
"materials/zombiesurvival/zssplash_v4.vtf" "file"
"materials/deathnotify/d_brains.vmt" "file"
"materials/deathnotify/d_brains.vtf" "file"
"sound/]]..HALFLIFESOUND..[[" "file"
"sound/]]..LASTHUMANSOUND..[[" "file"
}]]
	_file.Write("maps/".._GetCurrentMap()..".res", str)
	_Msg("-  Zombie Survival v4.5 -\n-     By JetBoom    -\n")

	-- ZS doesn't work because of npc_makers not being Linux friendly or something like that.
	if _IsLinux() or FORCELINUXSPAWN then
		for i=1, 4000 do
			if string.find(_EntGetType(i), "maker") ~= nil then
				LINUXSPAWNERS[table.getn(LINUXSPAWNERS)+1] = vecAdd(_EntGetPos(i), vector3(0,0,16))
				_EntRemove(i)
			end
		end
		if table.getn(LINUXSPAWNERS) > 0 then
			AddTimer(3, 0, SpawnLinuxZombies)
		end
	end
	local mahlazah = "sk_zombie_health "..math.clamp(DIFFICULTY*25, 25, 500).."\nsk_zombie_dmg_both_slash "..math.clamp(DIFFICULTY*9, 9, 500).."\nsk_zombie_dmg_one_slash "..math.clamp(DIFFICULTY*5, 5, 300).."\nsk_healthkit 25\nsk_healthvial 10\nsk_healthcharger 50\nsk_battery 15\n"
	AddTimer(0.25, 1, _ServerCommand, mahlazah)
	for _, ent in _EntitiesFindByClass("weapon_frag") do
		local wep = _EntCreate("weapon_swep")
		if wep > 0 then
			_EntSetKeyValue(wep, "Script", "weapons/zombiesurvival/weapon_grenade.lua")
			_EntSetPos(wep, _EntGetPos(ent))
			_EntRemove(ent)
			_EntSpawn(wep)
		end
	end
end

LINUXZOMBIELIST = {}
LINUXSQUADZOMBIELIST = {}
LINUXSQUADS = {}
for i=1, 10 do
	LINUXSQUADS[i] = 0
end
function SpawnLinuxZombies()
	if LINUXZOMBIES > 24 then return end
	local zombie = 0
	local spawner = math.random(1, table.getn(LINUXSPAWNERS))
	if math.random(1, 20) > 19 then
		zombie = _EntCreate("npc_fastzombie")
	else
		zombie = _EntCreate("npc_zombie")
	end
	_TraceLine(LINUXSPAWNERS[spawner], vector3(0,0,1), 32, 1337)
	if not _TraceHitNonWorld() then
		if zombie > 0 then
			for i=1, 5 do
				if LINUXSQUADS[i] < 8 then
					_EntSetKeyValue(zombie, "squadname", "zombiesquad"..i)
					LINUXSQUADZOMBIELIST[zombie] = i
					LINUXSQUADS[i] = LINUXSQUADS[i] + 1
					break
				end
			end
			_EntSetKeyValue(zombie, "spawnflags", "1792")
			_EntSetPos(zombie, LINUXSPAWNERS[spawner])
			_EntSpawn(zombie)
			LINUXZOMBIELIST[zombie] = true
			LINUXZOMBIES = LINUXZOMBIES + 1
		end
	end
end

function drawScore(userid)
	if isUndead(userid) then
		if HUMANRESURRECT > 0 then
			_GModText_Start("ImpactMassive")
			 _GModText_SetPos(0.01, 0.06)
			 _GModText_SetColor(255, 0, 0, 255)
			 _GModText_SetTime(99999, 0, 0)
			 _GModText_SetText(_PlayerInfo(userid,"kills").."/"..HUMANRESURRECT)
			_GModText_Send(userid, 101)
			_GModText_Start("BudgetLabel")
			 _GModText_SetPos(0.01, 0.117)
			 _GModText_SetColor(255, 0, 0, 255)
			 _GModText_SetTime(99999, 0, 0)
			 _GModText_SetText("All Time: "..players[userid].ZSZombieKills)
			_GModText_Send(userid, 102)
		else
			_GModText_Hide(userid, 101, 0)
		end
		return
	end
	_GModText_Start("ImpactMassive")
	 _GModText_SetPos(0.01, 0.06)
	 _GModText_SetColor(255, 0, 0, 255)
	 _GModText_SetTime(99999, 0, 0)
	 _GModText_SetText(_PlayerInfo(userid, "kills").." kills")
	_GModText_Send(userid, 101)
	_GModText_Start("BudgetLabel")
	 _GModText_SetPos(0.01, 0.117)
	 _GModText_SetColor(0, 255, 0, 255)
	 _GModText_SetTime(99999, 0, 0)
	 _GModText_SetText("All Time: "..players[userid].ZSHumanKills)
	_GModText_Send(userid, 102)
end

function eventNPCKilled(killerid, killed)
	if _EntGetType(killerid) == "player" then
		if _PlayerInfo(killerid, "alive") and _PlayerInfo(killerid, "team") == TEAM_BLUE then
			_PlayerAddScore(killerid, 1)
			players[killerid].ZSHumanKills = players[killerid].ZSHumanKills + 1
			CheckGiveWeapon(killerid)
			drawScore(killerid)
		end
	end
	if LINUXZOMBIELIST[killed] then
		LINUXZOMBIES = LINUXZOMBIES - 1
		LINUXZOMBIELIST[killed] = nil
		if LINUXSQUADZOMBIELIST[killed] ~= nil then
			LINUXSQUADS[LINUXSQUADZOMBIELIST[killed]] = LINUXSQUADS[LINUXSQUADZOMBIELIST[killed]] - 1
			LINUXSQUADZOMBIELIST[killed] = nil
		end
	end
end

function SecondWind(killed)
	AddTimer(1.75, 1, Revive, killed)
end

function Revive(userid)
	if Gibbed[userid] then return end
	local deadpos = _EntGetPos(userid)
	local deadang = _EntGetAng(userid)
	_PlayerRespawn(userid)
	_EntSetPos(userid, deadpos)
	_EntSetAng(userid, deadang)
	_EntEmitSound(userid, "npc/zombie/zombie_voice_idle"..math.random( 1, 14 )..".wav")
	_PlayerSetHealth(userid, ZombieClasses[PlayerInfo[userid].Class].Health*0.2 or 30)
end

function eventPlayerKilled(killed, attacker, weapon)
	_PlayerAddDeath(killed, 1)
	if isUndead(killed) then
		if DIFFICULTY >= 3.5 then
			if ZombieClasses[PlayerInfo[killed].Class].Revives then
				if math.random(1, 3) > 1 then
					if _player.LastHitGroup(killed) > HITGROUP_HEAD and IsPlayer(attacker) and attacker ~= killed then
						if weapon ~= "sweepershotgunmk2" and string.find(weapon, "env_") == nil then
							SecondWind(killed)
							return
						end
					end
				end
			end
		end
		if IsPlayer(attacker) then
			if attacker ~= killed then
				_PlayerAddScore(attacker, 1)
				players[attacker].ZSHumanKills = players[attacker].ZSHumanKills + 1
				drawScore(attacker)
				CheckGiveWeapon(attacker)
			end
		end
	else
		FIRSTDIED = true
		if IsPlayer(attacker) and attacker ~= killed then
			_PlayerAddScore(attacker, 1)
			if not PlayerInfo[attacker].KilledSelf then
				players[attacker].ZSZombieKills = players[attacker].ZSZombieKills + 1
				if players[attacker].ZSZombieKills == 100 then
					players[attacker].Certifications = players[attacker].Certifications.." zombie"
					_PrintMessageAll(3, _PlayerInfo(attacker,"name").." is a ZOMBIE MASTER!!")
					NDB.SaveInfo(attacker)
				end
			end
			if HUMANRESURRECT > 0 then
				if _PlayerInfo(attacker, "kills") >= HUMANRESURRECT then
					HideUndeadOverlay(attacker)
					_PlaySoundPlayer(attacker, "ambient/levels/prison/inside_battle_zombie"..math.random(1,3)..".wav")
					_PrintMessageAll(3, _PlayerInfo(attacker,"name").." has redeemed themselves.")
					AddTimer(1.5, 1, _PlayerRespawn, attacker)
					PlayerInfo[attacker].KilledSelf = false
					_PlayerSetScore(attacker, 0)
					_PlayerSetHealth(attacker, 999)
					_PlayerChangeTeam(attacker, TEAM_BLUE)
					_PlayerSetModel(attacker, "models/player/male_02.mdl")
					_PlayerInfo(attacker, "networkid")
					_PlayerSilentKill(attacker, 1.0, true)
					_EntSetName(attacker, "player")
					KILLEDPEOPLE = string.gsub(KILLEDPEOPLE, _PlayerInfo(attacker, "networkid"), "")
					_PlayerSetVecView(attacker, vector3(0, 0, 64))
					_PlayerSetVecDuck(attacker, vector3(0, 0, 24))
				end
			end
		end
		JoinUndead(killed, false)
		AddTimer(1.75, 1, Revive, killed)
		_PlaySound("ambient/creatures/town_child_scream1.wav")
		_PlaySound("ambient/creatures/town_child_scream1.wav")
		_PlayerSetScore(killed, 0)
		drawScore(killed)
		drawScore(attacker)
		if killed == attacker then
			PlayerInfo[killed].KilledSelf = true
			_PrintMessage(killed, 3, "Killing yourself has stopped you from gaining all time scores.")
		end
	end
end

function onTakeDamage(ent, inflictor, attacker, damage)
	if _EntGetType(ent) == "player" then
		if damage > _PlayerInfo(ent, "health")+34 then
			if _EntGetType(attacker) == "player" then
				if _PlayerInfo(attacker, "team") ~= _PlayerInfo(ent, "team") then
					if isUndead(ent) then
						if _player.LastHitGroup(ent) == HITGROUP_CHEST or _player.LastHitGroup(ent) == HITGROUP_STOMACH then
							if PlayerInfo[ent].Class == 1 then
								LegsGib(ent)
							else
								Gib(ent)
							end
						elseif math.random(1,5) > 4 then
							if PlayerInfo[ent].Class == 1 then
								LegsGib(ent)
							else
								Gib(ent)
							end
						else
							Gib(ent)
						end
					else
						Gib(ent)
					end
				end
			else
				Gib(ent)
			end
		end
	end
end

function IsInRadius(a, b, dist)
	return math.abs(vecLength(vecSub(_EntGetPos(a),_EntGetPos(b)))) <= dist
end

-- Finally, corpse eating.
function CheckCorpseExplode(x, y, z)
	local ents = _EntitiesFindInSphere(vector3(x, y, z), 75)
	for i=1, table.getn(ents) do
		if IsPlayer(ents[i]) then
			if not Gibbed[ents[i]] then
				if IsPlayerOnline(ents[i]) and not _PlayerInfo(ents[i], "alive") then
					Gib(ents[i])
				end
			end
		end
	end
end

function IsInRadius(a, b, dist)
	return math.abs(vecLength(vecSub(_EntGetPos(a),_EntGetPos(b)))) <= dist
end

ANTIDOORSPAM = {}
function eventPlayerUseEntity(userid, entity)
	if isUndead(userid) then
		if _EntGetName(entity) == "gibs" then
			if not IsInRadius(userid, entity, 120) then return true end
			local maxhealth = ZombieClasses[PlayerInfo[userid].Class].Health
			local health = _PlayerInfo(userid, "health")
			if health < maxhealth then
				_PlayerSetHealth(userid, health+(math.ceil(maxhealth*0.1)))
				if _PlayerInfo(userid, "health") > maxhealth then
					_PlayerSetHealth(userid, maxhealth)
				end
				_EntEmitSound(entity, "physics/body/body_medium_break"..math.random(2, 4)..".wav")
				_EntFire(entity, "kill", "", 0.01)
				return true
			end
		end
	end
	if _EntGetType(entity) == "prop_door_rotating" then
		if ANTIDOORSPAM[entity] then
			if _CurTime() > ANTIDOORSPAM[entity]+0.65 then
				ANTIDOORSPAM[entity] = _CurTime()
				return false
			else
				return true
			end
		else
			ANTIDOORSPAM[entity] = _CurTime()
			return false
		end
	end
	return false
end

TorsoModels = {}
TorsoModels[1] = "models/Zombie/Classic_torso.mdl"
TorsoModels[2] = "models/Humans/Charple03.mdl"

GibModels = {}
GibModels[1]="models/Gibs/Antlion_gib_medium_1.mdl"
GibModels[2]="models/Gibs/Antlion_gib_small_1.mdl"
GibModels[3]="models/Gibs/Antlion_gib_medium_2.mdl"
GibModels[4]="models/Gibs/Antlion_gib_medium_3.mdl"
GibModels[5]="models/Gibs/Antlion_gib_small_1.mdl"
GibModels[6]="models/Gibs/Antlion_gib_small_2.mdl"

_EntPrecacheModel("models/Gibs/Antlion_gib_medium_1.mdl")
_EntPrecacheModel("models/Gibs/Antlion_gib_small_1.mdl")
_EntPrecacheModel("models/Gibs/Antlion_gib_medium_2.mdl")
_EntPrecacheModel("models/Gibs/Antlion_gib_medium_3.mdl")
_EntPrecacheModel("models/Gibs/Antlion_gib_small_1.mdl")
_EntPrecacheModel("models/Gibs/Antlion_gib_small_2.mdl")
_EntPrecacheModel("models/gibs/HGIBS.mdl")
_EntPrecacheModel("models/gibs/HGIBS_rib.mdl")
_EntPrecacheModel("models/gibs/HGIBS_rib.mdl")
_EntPrecacheModel("models/gibs/HGIBS_rib.mdl")
_EntPrecacheModel("models/gibs/HGIBS_scapula.mdl")
_EntPrecacheModel("models/gibs/HGIBS_spine.mdl")

Gibbed = {}
for i=1, _MaxPlayers() do
	Gibbed[i] = false
end

_EntPrecacheModel("models/Zombie/Classic_legs.mdl")

function LegsGib(userid)
	Gibbed[userid] = true
	_EntEmitSoundEx(userid, "physics/flesh/flesh_bloody_break.wav", 1.0, 0.75)
	local ent = _EntCreate("prop_dynamic_override")
	if ent > 0 then
		_EntSetModel(ent, "models/Zombie/Classic_legs.mdl")
		_EntSetPos(ent, _EntGetPos(userid))
		_EntSetAng(ent, _EntGetAng(userid))
		_EntSpawn(ent)
		_EntFire(ent, "kill", "", 1.5)
	end
	local vecpos = vecAdd(_EntGetPos(userid), vector3(0,0,40))
	ent = _EntCreate("env_shooter")
	if ent > 0 then
		_EntSetPos(ent, _EntGetPos(userid))
		_EntSetKeyValue(ent, "gibangles", vecString(_EntGetAngAngle(userid)))
		_EntSetKeyValue(ent, "m_iGibs", "1")
		_EntSetKeyValue(ent, "m_flVelocity", 0)
		_EntSetKeyValue(ent, "shootmodel", "models/Zombie/Classic_legs.mdl")
		_EntSetKeyValue(ent, "m_flVariance", "0")
		_EntSetKeyValue(ent, "simulation", "2")
		_EntSpawn(ent)
		_EntFire(ent, "shoot", "", 1.5)
		_EntFire(ent, "kill", "", 1.6)
	end
	ent = _EntCreate("env_shooter")
	if ent > 0 then
		_EntSetPos(ent, vecpos)
		_EntSetKeyValue(ent, "m_iGibs", "30")
		_EntSetKeyValue(ent, "delay", "0.12")
		_EntSetKeyValue(ent, "m_flVelocity", 300)
		_EntSetKeyValue(ent, "shootmodel", "Decals/flesh/Blood1.vmt")
		_EntSetKeyValue(ent, "m_flVariance", "0.5")
		_EntSetKeyValue(ent, "m_flGibLife", "1.25")
		_EntSetKeyValue(ent, "angles", "-90 0 0")
		_EntSetKeyValue(ent, "shootsounds", "3")
		_EntSetKeyValue(ent, "spawnflags", "5")
		_EntSetKeyValue(ent, "simulation", "0")
		_EntSpawn(ent)
		_EntFire(ent, "shoot", "", 0)
		_EntFire(ent, "kill", "", 1.5)
	end
	ent = _EntCreate("env_shooter")
	if ent > 0 then
		_EntSetPos(ent, vecpos)
		_EntSetKeyValue(ent, "m_iGibs", "1")
		_EntSetKeyValue(ent, "m_flVelocity", 75)
		_EntSetKeyValue(ent, "shootmodel", "models/Zombie/Classic_torso.mdl")
		_EntSetKeyValue(ent, "m_flVariance", "0.2")
		_EntSetKeyValue(ent, "simulation", "2")
		_EntSetKeyValue(ent, "angles", "-90 0 0")
		_EntSpawn(ent)
		_EntFire(ent, "shoot", "", 0)
		_EntFire(ent, "kill", "", 0.1)
	end
	_EffectInit()
	_EffectSetOrigin(vecpos)
	_EffectSetScale(8)
	_EffectSetFlags(9)
	_EffectDispatch("bloodspray")
	_EffectDispatch("bloodspray")
	_EffectDispatch("bloodspray")
	AddTimer(0.11, 1, _PlayerSilentKill, userid, 1.5, true)
end

function Gib(killed)
	if Gibbed[killed] then return end
	Gibbed[killed] = true
	_TraceLine(_EntGetPos(killed), vector3(0,0,-1), 100, killed)
	if _TraceHit() then
		_MakeDecal(math.random(46,51))
	end
	local velocity = 30
	if isUndead(killed) then
		local classname = ZombieClasses[PlayerInfo[killed].Class].Name
		if classname == "Zombie" or classname == "Poison Zombie" then
			local ent = _EntCreate("env_shooter")
			if ent > 0 then
				_EntSetPos(ent, _EntGetPos(killed))
				_EntSetKeyValue(ent, "m_iGibs", "1")
				_EntSetKeyValue(ent, "m_flVelocity", velocity)
				-- Yes, these are client-side
				_EntSetKeyValue(ent, "shootmodel", "models/Zombie/Classic_legs.mdl")
				_EntSetKeyValue(ent, "m_flVariance", "5.0")
				_EntSetKeyValue(ent, "simulation", "2")
				_EntSpawn(ent)
				_EntFire(ent, "shoot", "", 0)
				_EntFire(ent, "kill", "", 1)
			end
			ent = _EntCreate("env_shooter")
			if ent > 0 then
				_EntSetPos(ent, _EntGetPos(killed))
				_EntSetKeyValue(ent, "m_iGibs", "1")
				_EntSetKeyValue(ent, "m_flVelocity", velocity)
				_EntSetKeyValue(ent, "shootmodel", TorsoModels[math.random(1,2)])
				_EntSetKeyValue(ent, "m_flVariance", "5.0")
				_EntSetKeyValue(ent, "simulation", "2")
				_EntSpawn(ent)
				_EntFire(ent, "shoot", "", 0)
				_EntFire(ent, "kill", "", 1)
			end
		elseif classname == "Fast Zombie" then
			local ent = _EntCreate("env_shooter")
			if ent > 0 then
				_EntSetPos(ent, _EntGetPos(killed))
				_EntSetKeyValue(ent, "m_iGibs", "1")
				_EntSetKeyValue(ent, "m_flVelocity", velocity)
				_EntSetKeyValue(ent, "shootmodel", "models/Gibs/Fast_Zombie_Legs.mdl")
				_EntSetKeyValue(ent, "m_flVariance", "5.0")
				_EntSetKeyValue(ent, "simulation", "2")
				_EntSpawn(ent)
				_EntFire(ent, "shoot", "", 0)
				_EntFire(ent, "kill", "", 1)
			end
			ent = _EntCreate("env_shooter")
			if ent > 0 then
				_EntSetPos(ent, _EntGetPos(killed))
				_EntSetKeyValue(ent, "m_iGibs", "1")
				_EntSetKeyValue(ent, "m_flVelocity", velocity)
				_EntSetKeyValue(ent, "shootmodel", "models/Gibs/Fast_Zombie_Torso.mdl")
				_EntSetKeyValue(ent, "m_flVariance", "5.0")
				_EntSetKeyValue(ent, "simulation", "2")
				_EntSpawn(ent)
				_EntFire(ent, "shoot", "", 0)
				_EntFire(ent, "kill", "", 1)
			end
		end
	else
		local ent = _EntCreate("env_shooter")
		if ent > 0 then
			_EntSetPos(ent, _EntGetPos(killed))
			_EntSetKeyValue(ent, "m_iGibs", "1")
			_EntSetKeyValue(ent, "m_flVelocity", velocity)
			_EntSetKeyValue(ent, "shootmodel", "models/Zombie/Classic_legs.mdl")
			_EntSetKeyValue(ent, "m_flVariance", "5.0")
			_EntSetKeyValue(ent, "simulation", "2")
			_EntSpawn(ent)
			_EntFire(ent, "shoot", "", 0)
			_EntFire(ent, "kill", "", 1)
		end
		ent = _EntCreate("env_shooter")
		if ent > 0 then
			_EntSetPos(ent, _EntGetPos(killed))
			_EntSetKeyValue(ent, "m_iGibs", "1")
			_EntSetKeyValue(ent, "m_flVelocity", velocity)
			_EntSetKeyValue(ent, "shootmodel", TorsoModels[math.random(1,2)])
			_EntSetKeyValue(ent, "m_flVariance", "5.0")
			_EntSetKeyValue(ent, "simulation", "2")
			_EntSpawn(ent)
			_EntFire(ent, "shoot", "", 0)
			_EntFire(ent, "kill", "", 1)
		end
	end
	_EffectInit()
	_EffectSetOrigin(_EntGetPos(killed))
	_EffectSetScale(8)
	_EffectSetFlags(9)
	_EffectDispatch("bloodspray")
	_EffectDispatch("bloodspray")
	_EffectDispatch("bloodspray")
	local gibstospawn = {}
	gibstospawn[1] = "models/gibs/HGIBS.mdl"
	gibstospawn[2] = "models/gibs/HGIBS_rib.mdl"
	gibstospawn[3] = "models/gibs/HGIBS_rib.mdl"
	gibstospawn[4] = "models/gibs/HGIBS_spine.mdl"
	gibstospawn[5] = GibModels[math.random(1, table.getn(GibModels))]
	gibstospawn[6] = GibModels[math.random(1, table.getn(GibModels))]
	for i in gibstospawn do
		local gib = _EntCreate("prop_physics_multiplayer")
		if gib > 0 then
			_EntPrecacheModel(gibstospawn[i])
			_EntSetModel(gib, gibstospawn[i])
			_EntSetKeyValue(gib, "spawnflags", "4")
			_EntSetPos(gib, vecAdd(_EntGetPos(killed), vector3(math.random(-10,10),math.random(-10,10),math.random(10,30))))
			_EntSetName(gib, "gibs")
			_EntSetKeyValue(gib, "physdamagescale", "1500")
			_EntSpawn(gib)
			_EntFire(gib, "AddOutput", "onhealthchanged GibHitWall,RunScript,,0,2", 0)
			_phys.ApplyForceCenter(gib, vecAdd(vecMul(_EntGetVelocity(killed), 12), vector3(math.random(-2000, 2000), math.random(-2000, 2000), math.random(0, 3000))))
			_phys.ApplyTorqueCenter(gib, vector3(math.random(-8000, 8000), math.random(-8000, 8000), math.random(-8000, 8000)))
			_EntFire(gib, "kill", "", 15)
		end
	end
	_EntEmitSoundEx(killed, "physics/flesh/flesh_bloody_break.wav", 1.0, 0.75)
	AddTimer(0.11, 1, _PlayerSilentKill, killed, 1.5, true)
end

function MakeFunction(FunctionName)
	local ent = _EntCreate("gmod_runfunction")
	if ent > 0 then
		_EntSetKeyValue(ent, "FunctionName", FunctionName)
		_EntSpawn(ent)
		_EntSetName(ent, FunctionName)
	end
end

function GibHitWall(hit, gib)
	_TraceLine(_EntGetPos(gib), vector3(0,0,-1), 32, gib)
	if _TraceHit() then
		_MakeDecal(math.random(46,51))
		_EffectInit()
		 _EffectSetOrigin(_EntGetPos(gib))
		 _EffectSetNormal(vector3(0,0,1))
		 _EffectSetScale(7)
		 _EffectSetFlags(9)
		_EffectDispatch("bloodspray")
		_EffectDispatch("bloodspray")
	end
	_TraceLine(_EntGetPos(gib), vector3(0,0,1), 32, gib)
	if _TraceHit() then
		_MakeDecal(math.random(46,51))
		_EffectInit()
		 _EffectSetOrigin(_EntGetPos(gib))
		 _EffectSetNormal(vector3(0,0,-1))
		 _EffectSetScale(7)
		 _EffectSetFlags(9)
		_EffectDispatch("bloodspray")
		_EffectDispatch("bloodspray")
	end
	_TraceLine(_EntGetPos(gib), vector3(1,0,0), 32, gib)
	if _TraceHit() then
		_MakeDecal(math.random(46,51))
		_EffectInit()
		 _EffectSetOrigin(_EntGetPos(gib))
		 _EffectSetNormal(vector3(-1,0,0))
		 _EffectSetScale(7)
		 _EffectSetFlags(9)
		_EffectDispatch("bloodspray")
		_EffectDispatch("bloodspray")
	end
	_TraceLine(_EntGetPos(gib), vector3(-1,0,0), 32, gib)
	if _TraceHit() then
		_MakeDecal(math.random(46,51))
		_EffectInit()
		 _EffectSetOrigin(_EntGetPos(gib))
		 _EffectSetNormal(vector3(1,0,0))
		 _EffectSetScale(7)
		 _EffectSetFlags(9)
		_EffectDispatch("bloodspray")
		_EffectDispatch("bloodspray")
	end
	_TraceLine(_EntGetPos(gib), vector3(0,1,0), 32, gib)
	if _TraceHit() then
		_MakeDecal(math.random(46,51))
		_EffectInit()
		 _EffectSetOrigin(_EntGetPos(gib))
		 _EffectSetNormal(vector3(0,-1,0))
		 _EffectSetScale(7)
		 _EffectSetFlags(9)
		_EffectDispatch("bloodspray")
		_EffectDispatch("bloodspray")
	end
	_TraceLine(_EntGetPos(gib), vector3(0,-1,0), 32, gib)
	if _TraceHit() then
		_MakeDecal(math.random(46,51))
		_EffectInit()
		 _EffectSetOrigin(_EntGetPos(gib))
		 _EffectSetNormal(vector3(0,1,0))
		 _EffectSetScale(7)
		 _EffectSetFlags(9)
		_EffectDispatch("bloodspray")
		_EffectDispatch("bloodspray")
	end
	_EntEmitSound(gib, "physics/flesh/flesh_bloody_impact_hard1.wav")
end
MakeFunction("GibHitWall")

function CheckGiveWeapon(userid)
	local score = _PlayerInfo(userid, "kills")
	if REWARDS[score] then
		local weap = _EntGetType(_PlayerGetActiveWeapon(userid))
		local newwep = REWARDS[score] newwep = newwep[math.random(1, table.getn(newwep))]
		if _file.Exists("lua/"..newwep) then
			_PlayerGiveSWEP(userid, newwep)
		else
			_PlayerGiveItem(userid, newwep)
		end
		_PlayerSelectWeapon(userid, weap)
		BottomPrintMessage(userid, " Your arsenal has been upgraded...", 20, 255, 20)
		_PlaySoundPlayer(userid, "weapons/physcannon/physcannon_charge.wav")
	end
end

function Splash(userid)
	_GModRect_Start("gmod/white")
	 _GModRect_SetPos(0.4, 0.95, 0.2, 0.1)
	 _GModRect_SetColor(0, 0, 0, 200)
	 _GModRect_SetTime(99999, 0, 0)
	_GModRect_Send(userid, 899)

	_GModText_Start("Default")
	 _GModText_SetPos(-1, 0.93)
	 _GModText_SetColor(255, 0, 0, 255)
	 _GModText_SetTime(99999, 0, 0)
	 _GModText_SetText("Infliction")
	_GModText_Send( userid, 900)

	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0, 0, 0.15, 0.15 )
	 _GModRect_SetColor( 0, 0, 0, 175 )
	 _GModRect_SetTime( 99999, 0, 0 )
	_GModRect_Send( userid, 666 )

	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0, 0, 0.16, 0.16 )
	 _GModRect_SetColor( 255, 0, 0, 150 )
	 _GModRect_SetTime( 99999, 0, 0 )
	_GModRect_Send( userid, 665 )

	_GModText_Start( "BudgetLabel" )
	 _GModText_SetPos( 0.79, 0.01 )
	 _GModText_SetColor( 255, 30, 5, 230 )
	 _GModText_SetTime( 9999, 0, 0 )
	 _GModText_SetText("Zombie Survival v4.5p\nBy JetBoom")
	_GModText_Send( userid, 955 )

	_GModRect_Start( "zombiesurvival/zssplash_v4" )
	 _GModRect_SetPos( 0.21, 0.095, 0.6, 0.6 )
	 _GModRect_SetColor( 255, 255, 255, 255 )
	 _GModRect_SetTime( 10, 1, 1 )
	_GModRect_Send( userid, 245 )

	_GModText_Start( "Default" )
	 _GModText_SetPos( -1.0, 0.51 )
	 _GModText_SetColor( 100, 100, 255, 255 )
	 _GModText_SetTime( 10, 1, 1 )
	 _GModText_SetText("Difficulty: "..DIFFICULTY.."x")
	_GModText_Send( userid, 246 )
end

function CalculateInfliction()
	local PlayerCount=_TeamNumPlayers(TEAM_BLUE) + _TeamNumPlayers(TEAM_GREEN)
	local ZombieCount=_TeamNumPlayers(TEAM_GREEN)
	INFLICTION = ZombieCount/PlayerCount
	if INFLICTION >=1.0 and not ENDROUND then
		EndRound(2)
	elseif INFLICTION >= 0.5 and not HALFLIFE then
		HalfLife()
	elseif PlayerCount-ZombieCount <= 1 and PlayerCount > 3 and not LASTHUMAN then
		LastHuman()
	end
	drawInfliction(0)
end

function HalfLife()
	_EntFire(HALFLIFEENTITY, "PlaySound", "", 0)
	--_PlaySound(HALFLIFESOUND)
	HALFLIFE = true
	BottomPrintMessage(0, "'Half-Life' has been reached!", 255, 255, 255, 200)
end

function LastHuman()
	_EntFire(HALFLIFEENTITY, "StopSound", "", 0)
	_EntFire(LASTHUMANENTITY, "PlaySound", "", 0)
	--_PlaySound(LASTHUMANSOUND)
	LASTHUMAN = true
	for i=1, _MaxPlayers() do
		if _PlayerInfo(i, "connected") then
			if isUndead(i) then
				BottomPrintMessage(i, "Kill the last human!", 255, 255, 255, 255)
			else
				BottomPrintMessage(i, "You are the last human alive!", 255, 255, 255, 255)
			end
		end
	end
end

function EndRound(winner)
	if ENDROUND then return end
	for i=1, _MaxPlayers() do
		Muted[i] = true
		_PlayerFreeze(i, true)
		_PlayerGod(i, true)
	end
	_ServerCommand("sv_voiceenable 0\n")
	local zombies = _TeamNumPlayers(TEAM_GREEN)
	local humans = _TeamNumPlayers(TEAM_BLUE)
	local prize = 0
	if zombies + humans >= 8 then
		if zombies > humans then
			prize = zombies*300
			prize = math.floor(prize/humans)
		end
	end
	ENDROUND = true
	ROUNDEND = _CurTime()
	AddTimer(INTERMISSIONTIME, 1, _StartNextLevel)
	local lastplayer = 0
	if winner == 1 then
		if LASTHUMAN then
			for i=1, _MaxPlayers() do
				if IsPlayerOnline(i) then
					if not isUndead(i) then
						if NDB ~= nil and prize > 0 then
							NDB.AddMoney(i, prize, false)
							lastplayer = i
						else
							CenterPrintMessage(0, _PlayerInfo(i, "name").." has survived...\nNext round in "..INTERMISSIONTIME.." seconds.", 20, 20, 255, 255)
						end
					end
				end
			end
			if NDB ~= nil and prize > 0 then
				CenterPrintMessage(0, _PlayerInfo(lastplayer, "name").." has won $"..prize.."...\nNext round in "..INTERMISSIONTIME.." seconds.", 20, 20, 255, 255)
			else
				CenterPrintMessage(0, _PlayerInfo(lastplayer, "name").." has survived...\nNext round in "..INTERMISSIONTIME.." seconds.", 20, 20, 255, 255)
			end
		else
			if NDB ~= nil and prize > 0 then
				for i=1, _MaxPlayers() do
					if IsPlayerOnline(i) then
						if not isUndead(i) then
							NDB.AddMoney(i, prize, false)
						end
					end
				end
				CenterPrintMessage(0, "The remaining humans have won $"..prize.."...\nNext round in "..INTERMISSIONTIME.." seconds.", 20, 20, 255, 255)
			else
				CenterPrintMessage(0, "The remaining humans have survived...\nNext round in "..INTERMISSIONTIME.." seconds.", 20, 20, 255, 255)
			end
		end
		_EntFire(HALFLIFEENTITY, "StopSound", "", 0)
		_EntFire(LASTHUMANENTITY, "StopSound", "", 0)
		_PlaySound(HUMANWINSOUND)
		for i=1, _MaxPlayers() do
			if IsPlayerOnline(i) then
				if isUndead(i) then
					_GModText_Start( "ImpactMassive" )
					 _GModText_SetPos( -1, 0.7 )
					 _GModText_SetColor( 255, 0, 0, 255 )
					 _GModText_SetTime( 9999, 1, 1 )
					 _GModText_SetText( "You have lost the match." )
					_GModText_Send( i, 50 )
				else
					_PlayerGod(i, true)
					_GModText_Start( "ImpactMassive" )
					 _GModText_SetPos( -1, 0.7 )
					 _GModText_SetColor( 0, 0, 255, 255 )
					 _GModText_SetTime( 9999, 1, 1 )
					 _GModText_SetText( "You have won the match." )
					_GModText_Send( i, 50 )
				end
			end
		end
		_GModRect_Start( "gmod/white" )
		 _GModRect_SetPos( 0, 0, 1, 1 )
		 _GModRect_SetColor( 255, 255, 255, 255 )
		 _GModRect_SetTime( 99999, 2.0, 0 )
		_GModRect_Send( 0, 21 )
		for i=1, _MaxPlayers() do
			_PlayerFreeze(i, true)
			_PlayerGod(i, true)
		end
	elseif winner == 2 then
		local sayings = {
		[1] = "All is lost.",
		[2] = "The Undead will still walk.",
		[3] = "No hope for humanity.",
		[4] = "Enjoy the decomposition.",
		[5] = "There's no room in Hell for you.",
		[6] = "LoL!! u r ded.",
		[7] = "Look at you, all messy and dead.",
		[8] = "YOU ARE DEAD."
		}
		CenterPrintMessage(0, sayings[math.random(1,5)].."\n Next round in "..INTERMISSIONTIME.." seconds.", 255, 0, 0, 255)
		_GModText_Start( "ImpactMassive" )
		 _GModText_SetPos( -1, 0.7 )
		 _GModText_SetColor( 255, 0, 0, 255 )
		 _GModText_SetTime( 9999, 1, 1 )
		 _GModText_SetText( "You have lost the match." )
		_GModText_Send( 0, 50 )
		_EntFire(HALFLIFEENTITY, "StopSound", "", 0)
		_EntFire(LASTHUMANENTITY, "StopSound", "", 0)
		_PlaySound(ZOMBIEWINSOUND)
		_GModRect_Start( "gmod/white" )
		 _GModRect_SetPos( 0, 0, 1, 1 )
		 _GModRect_SetColor( 20, 0, 0, 255 )
		 _GModRect_SetTime( 99999, 4.0, 0 )
		_GModRect_Send( 0, 21 )
	end
	if NDB ~= nil then
		NDB.GlobalSave()
	end
end

function CenterPrintMessage(userid, msg, r, g, b)
	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0.37, 0.37, 0.325, 0.1 )
	 _GModRect_SetColor( 0, 0, 0, 100 )
	 _GModRect_SetTime( 7.5, 1, 1 )
	_GModRect_Send( userid, 500 )

	_GModText_Start( "DefaultShadow" )
	 _GModText_SetPos( -1, 0.4 )
	 _GModText_SetColor( r, g, b, 240 )
	 _GModText_SetTime( 7.5, 1, 1 )
	 _GModText_SetText( msg )
	_GModText_Send( userid, 501 )
end

function BottomPrintMessage(userid, msg, r, g, b)
	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0.37, 0.77, 0.325, 0.1 )
	 _GModRect_SetColor( 0, 0, 0, 100 )
	 _GModRect_SetTime( 7.5, 1, 1 )
	_GModRect_Send( userid, 520 )

	_GModText_Start( "DefaultShadow" )
	 _GModText_SetPos( -1, 0.8 )
	 _GModText_SetColor( r, g, b, 240 )
	 _GModText_SetTime( 7.5, 1, 1 )
	 _GModText_SetText( msg )
	_GModText_Send( userid, 521 )
end
	
function SidePrintMessage(userid, msg, r, g, b)
	_GModRect_Start( "gmod/white" )
	 _GModRect_SetPos( 0.77, 0.37, 0.325, 0.1 )
	 _GModRect_SetColor( 0, 0, 0, 100 )
	 _GModRect_SetTime( 7.5, 1, 1 )
	_GModRect_Send( userid, 520 )

	_GModText_Start( "DefaultShadow" )
	 _GModText_SetPos( 0.79, 0.4 )
	 _GModText_SetColor( r, g, b, 240 )
	 _GModText_SetTime( 7.5, 1, 1 )
	 _GModText_SetText( msg )
	_GModText_Send( userid, 521 )
end

disp1 = 0
disp2 = 0
disp3 = 0
disp4 = 0
disp5 = 0
disp6 = 0
disp7 = 0
disp8 = 0

function SpawnDisp()
	disp1 = _EntCreate( "ai_relationship" )
	if disp1 > 0 then
		_EntSetKeyValue( disp1, "subject", "npc_headcrab")
		_EntSetKeyValue( disp1, "target", "zombieplayer")
		_EntSetKeyValue( disp1, "disposition", 3)
		_EntSetKeyValue( disp1, "Radius for subject", 99999)
		_EntSetKeyValue( disp1, "rank", 99)
		_EntSetKeyValue( disp1, "Reciprocal", 1)
		_EntSetPos(disp1, vector3(0, 0, 0))
		_EntSpawn(disp1)
	end
	disp2 = _EntCreate( "ai_relationship" )
	if disp2 > 0 then
		_EntSetKeyValue( disp2, "subject", "npc_headcrab_fast")
		_EntSetKeyValue( disp2, "target", "zombieplayer")
		_EntSetKeyValue( disp2, "disposition", 3)
		_EntSetKeyValue( disp2, "Radius for subject", 99999)
		_EntSetKeyValue( disp2, "rank", 99)
		_EntSetKeyValue( disp2, "Reciprocal", 1)
		_EntSetPos(disp2, vector3(0, 0, 0))
		_EntSpawn(disp2)
	end
	disp3 = _EntCreate( "ai_relationship" )
	if disp3 > 0 then
		_EntSetKeyValue( disp3, "subject", "npc_headcrab_black")
		_EntSetKeyValue( disp3, "target", "zombieplayer")
		_EntSetKeyValue( disp3, "disposition", 3)
		_EntSetKeyValue( disp3, "Radius for subject", 99999)
		_EntSetKeyValue( disp3, "rank", 99)
		_EntSetKeyValue( disp3, "Reciprocal", 1)
		_EntSetPos(disp3, vector3(0, 0, 0))
		_EntSpawn(disp3)
	end
	disp4 = _EntCreate( "ai_relationship" )
	if disp4 > 0 then
		_EntSetKeyValue( disp4, "subject", "npc_fastzombie")
		_EntSetKeyValue( disp4, "target", "zombieplayer")
		_EntSetKeyValue( disp4, "disposition", 3)
		_EntSetKeyValue( disp4, "Radius for subject", 99999)
		_EntSetKeyValue( disp4, "rank", 99)
		_EntSetKeyValue( disp4, "Reciprocal", 1)
		_EntSetPos(disp4, vector3(0, 0, 0))
		_EntSpawn(disp4)
	end
	disp5 = _EntCreate( "ai_relationship" )
	if disp5 > 0 then
		_EntSetKeyValue( disp5, "subject", "npc_zombie")
		_EntSetKeyValue( disp5, "target", "zombieplayer")
		_EntSetKeyValue( disp5, "disposition", 3)
		_EntSetKeyValue( disp5, "Radius for subject", 99999)
		_EntSetKeyValue( disp5, "rank", 99)
		_EntSetKeyValue( disp5, "Reciprocal", 1)
		_EntSetPos(disp5, vector3(0, 0, 0))
		_EntSpawn(disp5)
	end
	disp6 = _EntCreate( "ai_relationship" )
	if disp6 > 0 then
		_EntSetKeyValue( disp6, "subject", "npc_poisonzombie")
		_EntSetKeyValue( disp6, "target", "zombieplayer")
		_EntSetKeyValue( disp6, "disposition", 3)
		_EntSetKeyValue( disp6, "Radius for subject", 99999)
		_EntSetKeyValue( disp6, "rank", 99)
		_EntSetKeyValue( disp6, "Reciprocal", 1)
		_EntSetPos(disp6, vector3(0, 0, 0))
		_EntSpawn(disp6)
	end
	disp7 = _EntCreate( "ai_relationship" )
	if disp7 > 0 then
		_EntSetKeyValue( disp7, "subject", "npc_poisonzombie")
		_EntSetKeyValue( disp7, "target", "zombieplayer")
		_EntSetKeyValue( disp7, "disposition", 3)
		_EntSetKeyValue( disp7, "Radius for subject", 99999)
		_EntSetKeyValue( disp7, "rank", 99)
		_EntSetKeyValue( disp7, "Reciprocal", 1)
		_EntSetPos(disp7, vector3(0, 0, 0))
		_EntSpawn(disp7)
	end
	disp8 = _EntCreate( "ai_relationship" )
	if disp8 > 0 then
		_EntSetKeyValue(disp8, "subject", "npc_zombie_torso")
		_EntSetKeyValue(disp8, "target", "zombieplayer")
		_EntSetKeyValue(disp8, "disposition", 3)
		_EntSetKeyValue(disp8, "Radius for subject", 99999)
		_EntSetKeyValue(disp8, "rank", 99)
		_EntSetKeyValue(disp8, "Reciprocal", 1)
		_EntSetPos(disp8, vector3(0, 0, 0))
		_EntSpawn(disp8)
	end
end

function ApplyDisp()
	_EntFire(disp1, "ApplyRelationship", "", 0)
	_EntFire(disp2, "ApplyRelationship", "", 0.1)
	_EntFire(disp3, "ApplyRelationship", "", 0.2)
	_EntFire(disp4, "ApplyRelationship", "", 0.3)
	_EntFire(disp5, "ApplyRelationship", "", 0.4)
	_EntFire(disp6, "ApplyRelationship", "", 0.5)
	_EntFire(disp7, "ApplyRelationship", "", 0.6)
	_EntFire(disp8, "ApplyRelationship", "", 0.7)
end

function eventPlayerSpawn(userid)
	AddTimer(0.1, 1, _PlayerEnableSprint, userid, false)
	Gibbed[userid] = false
	if isUndead(userid) then
		_EntSetName(userid, "zombieplayer")
		ApplyDisp()
		_PlayerSetDrawViewModel(userid, false)
		_PlayerSetHealth(userid, ZombieClasses[PlayerInfo[userid].Class].Health or 100)
		PlayerSetMaxSpeed(userid, ZombieClasses[PlayerInfo[userid].Class].Speed or 170)
		_EntSetMaxHealth(userid, 1)
	else
		_PlayerSetDrawViewModel(userid, true)
	end
	drawScore(userid)
end

function ThrowHeadCrab(userid)
	AddTimer(2.0, 1, DoThrowHeadCrab, userid)
end

function DoThrowHeadCrab(userid)
	if not isUndead(userid) or not _PlayerInfo(userid, "alive") then return end
	_EntEmitSound(userid, "npc/headcrab_poison/ph_jump"..math.random(1,3)..".wav")

	local headcrab = _EntCreate( "npc_headcrab_black")
	if headcrab > 0 then
		local angle = _PlayerGetShootAng(userid)
		angle.z = 0
		local pos = _PlayerGetShootPos(userid)
		pos.z = pos.z+5
		_EntSetPos(headcrab, vecAdd(pos, vecMul(angle, vector3(55,55,55))))
		_EntSetAng(headcrab, _EntGetAng(userid))
		local fireforce = vecMul(_PlayerGetShootAng(userid), vector3(600, 600, 600*1.25))
		_EntSpawn(headcrab)
		_EntSetVelocity(headcrab, fireforce)
		ApplyDisp()
	end
end

function PlayerUnlock(userid)
	AddTimer(2.5, 1, _PlayerLockInPlace, userid, false)
end
