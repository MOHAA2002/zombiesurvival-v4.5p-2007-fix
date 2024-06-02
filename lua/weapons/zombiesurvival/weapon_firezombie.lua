	function onPickup(playerid)
		_PlayerSetVecView(playerid, vector3(0, 0, 64))
		_PlayerSetVecDuck(playerid, vector3(0, 0, 24))
		_EntFire(playerid, "setcolor", "255 50 0", 0)
	end

	function onThink( )
		if _player.GetFlashlight(Owner) then
			_PlayerSetFlashlight(Owner, false)
		end
	end

	function Holster()
		_EntEmitSound(Owner, "npc/zombie/zombie_die"..math.random(1,3)..".wav")
	end

	function onPrimaryAttack( )
		_EntEmitSound(Owner, "npc/stalker/go_alert2a.wav")
		_RunString("Gib("..Owner..")")
		local ent = _EntCreate("env_explosion")
		if ent > 0 then
			_EntSetPos(ent, _EntGetPos(Owner))
			_EntSetKeyValue(ent, "iMagnitude", "80")
			_EntSetKeyValue(ent, "iRadiusOverride", "170")
			_EntSetOwner(ent, Owner)
			_EntSpawn(ent)
			_EntFire(ent, "explode", "", 0)
			_EntFire(ent, "kill", "", 0.05)
		end
		OrbExplosion(_EntGetPos(Owner), 0)
end

function OrbTest(pos)
	local info = _EntCreate("info_target")
	if info > 0 then
		_EntSetPos(info, pos)
		_EntSpawn(info)
		_EntFire(info,"kill","", 0.5)
		return _EntGetWaterLevel(info) < 1
	end
	return false
end

function OrbExplosion(pos, delay)
--[[
	if OrbTest(pos) then
		local explosion = _EntCreate("prop_combine_ball")
		if explosion > 0 then
			_EntSetPos(explosion, pos)
			_EntSpawn(explosion)
			_EntFire(explosion, "explode", "", delay)
			_EntRemove(explosion)
			_EntFire(explosion, "kill", "", delay+0.05)
		end
	end
	]]
end
	
	function onReload()
		return false
	end

	function getWeaponSwapHands()
		return false	
	end

	function getWeaponFOV()
		return 75
	end

	function getWeaponSlot()
		return 0	
	end

	function getWeaponSlotPos()
		return 2	
	end

	function getFiresUnderwater()
		return true
	end

	function getReloadsSingly()
		return false
	end

	function getDamage()
		return 10
	end

	function getPrimaryShotDelay()
		return 1.0
	end
	
	function getPrimaryIsAutomatic()
		return true
	end
		
	function getBulletSpread()
		return vector3( 0.00, 0.00, 0.00 )
	end

	function getViewKick()
		return vector3( 0.0, 0.0, 0.0)
	end

	function getViewKickRandom()
		return vector3( 0.0, 8.0, 0.0 )
	end
	
	function getNumShotsPrimary()
		return 1
	end

	function getPrimaryAmmoType()
		return "none"
	end

	function getDamageSecondary()
		return 10
	end

	function getSecondaryShotDelay()
		return 2.5
	end

	function getSecondaryIsAutomatic()
		return false
	end

	function getBulletSpreadSecondary()
		return vector3( 0.001, 0.001, 0.001 )
	end

	function getViewKickSecondary()
		return vector3( 0.0, 0.0, 0.0)
	end

	function getViewKickRandomSecondary()
		return vector3( 0.0, 0.0, 0.0 )
	end

	function getNumShotsSecondary()
		return 1
	end

	function getSecondaryAmmoType()
		return "none"
	end

	function getViewModel( )
		return "models/weapons/v_c4.mdl"
	end

	function getWorldModel( )
		return "models/weapons/w_c4.mdl"
	end

	function getClassName() 
		return "weapon_firezombie"
	end

	function getMaxClipPrimary()
		return 1
	end

	function getMaxClipSecondary()
		return -1
	end

	function getDefClipPrimary() -- ammo in gun by default
		return 1
	end

	function getDefClipSecondary()
		return 0
	end

	function getAnimPrefix() -- How the player holds the weapon: pistol, smg, ar2, shotgun, rpg, phys, crossbow, melee, slam, grenade
		return "slam"
	end

	function getPrintName()
		return "Fire Zombie"
	end

	function getPrimaryScriptOverride()
		return 3
	end

	function getSecondaryScriptOverride()
		return 3
	end

	function getDeathIcon( )
		return "d_pwn"
	end
