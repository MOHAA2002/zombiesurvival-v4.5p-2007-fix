lastnade = 0
	
	function onInit( )
		_SWEPSetSound( MyIndex, "single_shot", "Weapon_Frag.Single" )
	end

	function onThink( )
		-- nil
	end
	
	
	function onPrimaryAttack( )
		if not _PlayerInfo( Owner, "alive" ) then return end
		if _CurTime() < lastnade + 1.49 then return end
		local nade = _EntCreate("physics_prop")
		if nade > 0 then
			lastnade = _CurTime()
			_PlayerViewModelSequence(Owner, 171)
			_EntEmitSound(Owner, "npc/fast_zombie/claw_miss"..math.random( 1, 2 )..".wav")
			_EntSetPos(nade, vecAdd( _PlayerGetShootPos(Owner), vecMul( _PlayerGetShootAng(Owner), vector3(60,60,60))))
			_EntSetModel(nade, "models/weapons/w_grenade.mdl")
			_EntSetOwner(nade, Owner)
			_EntSpawn(nade)
			local vVelocity = vecMul(_PlayerGetShootAng(Owner), vector3(4000, 4000, 5500))
			_phys.ApplyForceCenter(nade, vVelocity)
			_EntitySetPhysicsAttacker(nade, Owner)
			_SWEPUseAmmo(MyIndex, 0, 1)
			_EntFire(nade, "kill", "", 3.1)
			local trail = _EntCreate("env_smoketrail")
			if trail > 0 then
				_EntSetPos(trail, _EntGetPos(nade))
				_EntSetKeyValue(trail, "spawnrate", "25")
				_EntSetKeyValue(trail, "lifetime", "1.0")
				_EntSetKeyValue(trail, "startcolor", "255 100 0")
				_EntSetKeyValue(trail, "endcolor", "255 100 0")
				_EntSetKeyValue(trail, "minspeed", "0")
				_EntSetKeyValue(trail, "maxspeed", "5")
				_EntSetKeyValue(trail, "startsize", "9")
				_EntSetKeyValue(trail, "endsize", "14")
				_EntSetKeyValue(trail, "spawnradius", "6")
				_EntSetKeyValue(trail, "firesprite", "sprites/redglow3.spr")
				_EntSetKeyValue(trail, "smokesprite", "sprites/redglow3.spr")
				_EntSpawn(trail)
				_EntSetParent(trail, nade)
			end
			local ent = _EntCreate("env_explosion")
			if ent > 0 then
				_EntSetPos(ent, _EntGetPos(nade))
				_EntSetKeyValue(ent, "iMagnitude", "125")
				_EntSetOwner(ent, Owner)
				_EntSpawn(ent)
				_EntSetParent(ent, nade)
				_EntFire(ent, "explode", "", 3)
			end
		end
	end
	
	
	function onSecondaryAttack( )

	end
	
	
	function onReload( )
		return true
	end

	function getWeaponSwapHands()
		return false	
	end
	
	function getWeaponFOV()
		return 70
	end
	
	function getWeaponSlot()
		return 4
	end
	
	function getWeaponSlotPos()
		return 3	
	end
	
	function getFiresUnderwater()
		return true
	end
	
	function getReloadsSingly()
		return false
	end
	
	function getDamage()
		return 5
	end
	
	function getPrimaryShotDelay()
		return 1.5
	end
	
	function getSecondaryShotDelay()
		return 400
	end
	
	function getPrimaryIsAutomatic()
		return false
	end
	
	function getSecondaryIsAutomatic()
		return false
	end
	
	function getBulletSpread()
		return vector3( 0.00, 0.00, 0.00 )
	end
	
	function getViewKick()
		return vector3( 0.0, 0.0, 0.0)
	end
	
	function getViewKickRandom()
		return vector3( 0.0, 0.0, 0.0 )
	end

	function getViewModel( )
		return "models/weapons/v_grenade.mdl"
	end
	
	function getWorldModel( )
		return "models/weapons/w_grenade.mdl"
	end
	
	function getClassName()
		return "weapon_grenade"
	end

	function getPrimaryAmmoType()
		return "Grenade"
	end
		
	function getSecondaryAmmoType()
		return
	end
	
	-- return -1 if it doesn't use clips
	function getMaxClipPrimary()
		return 1
	end
	
	function getMaxClipSecondary()
		return -1
	end
	
	-- ammo in gun by default
	function getDefClipPrimary()
		return 1
	end
	
	function getDefClipSecondary()
		return -1
	end

	-- pistol, smg, ar2, shotgun, rpg, phys, crossbow, melee, slam, grenade
	function getAnimPrefix()
		return "melee"
	end

	function getPrintName()
		return "Energy Grenade"
	end

	function getPrimaryScriptOverride()
		return 1
	end

	function getSecondaryScriptOverride()
		return 3
	end
	
	function getBulletSpreadSecondary()
		return vector3( 0.0, 0.0, 0.0 )
	end
	
	function getViewKickSecondary()
		return vector3( 0.0, 0.0, 0.0)
	end
	
	function getViewKickRandomSecondary()
		return vector3( 0.0, 0.0, 0.0 )
	end

	function getDeathIcon( )
		return "d_grenade"
	end
