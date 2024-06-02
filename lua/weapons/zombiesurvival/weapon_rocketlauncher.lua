-- ZS Big RocketLauncher
-- JetBoom

initTime = 0

function onInit()
	_SWEPSetSound(MyIndex, "single_shot", "Weapon_RPG.Single")
	initTime = _CurTime()
end

function onThink()
end

function onPrimaryAttack()
	if not _PlayerInfo(Owner, "alive") then return end
	if initTime+2.0 > _CurTime() then return end
	local iBolt = _EntCreate("rpg_missile")
	if iBolt > 0 then
		_EntSetKeyValue( iBolt, "damage", "340")
		local pos = _PlayerGetShootPos(Owner)
		pos.z = pos.z+26
		_EntSetPos(iBolt, pos)
		_EntSetAng(iBolt, _PlayerGetShootAng(Owner))
		_EntSetOwner(iBolt, Owner)
		_EntSpawn(iBolt)
		_EntSetVelocity(iBolt, vecMul(_PlayerGetShootAng(Owner), vector3(300, 300, 300)))
		_SWEPUseAmmo(MyIndex, 0, 1)
	end	
end

function onSecondaryAttack()
     
end

function onReload()
	return true
end

function getWeaponSwapHands()
	return false	
end

function getWeaponFOV()
	return 75	
end


function getWeaponSlot()
	return 5	
end

function getWeaponSlotPos()
	return 5	
end

function getFiresUnderwater()
	return true
end

function getReloadsSingly()
	return false
end

function getDamage()
	return 100
end

function getPrimaryShotDelay()
	return 2.0
end

function getSecondaryShotDelay()
	return 0.1
end

function getPrimaryIsAutomatic()
	return false
end

function getSecondaryIsAutomatic()
	return false
end

function getPrimaryAmmoType()
	return "RPG_Round"
end

function getSecondaryAmmoType()
	return "none"
end

function getMaxClipPrimary()
	return 1
end

function getMaxClipSecondary()
	return -1
end

function getDefClipPrimary()
	return 2
end

function getDefClipSecondary()
	return -1
end

function getPrimaryScriptOverride()
	return 1
end

function getSecondaryScriptOverride()
	return 3
end

function getBulletSpread()
	return vector3( 0.0, 0.0, 0.0 )
end

function getViewKick()
	return vector3( 25.0, 12.0, 0.0)
end

function getViewKickRandom()
	return vector3( 4.0, 4.0, 6.0 )
end

function getViewModel( )
	return "models/weapons/v_rpg.mdl"
end

function getWorldModel( )
	return "models/weapons/w_rocket_launcher.mdl"
end

function getClassName()
	return "weapon_rocketlauncher"
end

-- pistol, smg, ar2, shotgun, rpg, phys, crossbow, melee, slam, grenade
function getAnimPrefix()
	return "rpg"
end

function getPrintName()
	return "Rocket Launcher"
end


      -- 0 = Don't override, shoot bullets, make sound and flash
	-- 1 = Don't shoot bullets but do make flash/sounds
	-- 2 = Only play animations
	-- 3 = Don't do anything
	
	function getPrimaryScriptOverride()
		return 2
end

	function getSecondaryScriptOverride()
		return 3
end
