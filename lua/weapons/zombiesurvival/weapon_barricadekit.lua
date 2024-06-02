barricademodel = "models/props_debris/wood_board05a.mdl"
_EntPrecacheModel(barricademodel)
barricade = 0

	function onPickup(playerid)
		_TraceLine(_PlayerGetShootPos(playerid), _PlayerGetShootAng(playerid), 75, playerid)
		if barricade == 0 then
			barricade = _EntCreate("prop_dynamic_override")
			if barricade > 0 then
				_EntSetPos(barricade, _TraceEndPos())
				_EntSetAngAngle(barricade, vector3(_EntGetAngAngle(playerid).x, _EntGetAngAngle(playerid).y, 90))
				_EntSetModel(barricade, barricademodel)
				_EntSetKeyValue(barricade, "rendermode", "5")
				_EntSpawn(barricade)
				_EntSetMaterial(barricade, "models/debug/debugwhite")
				_EntFire(barricade, "color", "255 0 0 ", 0)
				_EntFire(barricade, "alpha", "90", 0)
			end
		end
	end

	function onDrop( playerid )
		onRemove()
	end
	
    function Holster()
		onRemove()
    end

    function onRemove( )
		if barricade > 0 then
			if _EntGetType(barricade) == "prop_dynamic" then
				_EntRemove(barricade)
				barricade = 0
			end
		end
	end

    function Deploy()
		_TraceLine(_PlayerGetShootPos(Owner), _PlayerGetShootAng(Owner), 75, Owner)
		if barricade == 0 then
			barricade = _EntCreate("prop_dynamic_override")
			if barricade > 0 then
				_EntSetPos(barricade, _TraceEndPos())
				_EntSetAngAngle(barricade, vector3(_EntGetAngAngle(Owner).x, _EntGetAngAngle(Owner).y, 90))
				_EntSetModel(barricade, barricademodel)
				_EntSetKeyValue(barricade, "rendermode", "5")
				_EntSpawn(barricade)
				_EntSetMaterial(barricade, "models/debug/debugwhite")
				_EntFire(barricade, "color", "255 0 0 ", 0)
				_EntFire(barricade, "alpha", "90", 0)
			end
		end
    end

    function onInit( )
    end

    function onThink( )
		if _EntGetType(barricade) == "prop_dynamic" then
			_TraceLine(_PlayerGetShootPos(Owner), _PlayerGetShootAng(Owner), 75, Owner)
			_EntSetPos(barricade, _TraceEndPos())
			_EntSetAngAngle(barricade, vector3(_EntGetAngAngle(Owner).x, _EntGetAngAngle(Owner).y, 90))
		end
    end
	
	function onPrimaryAttack()
		_TraceLine(_PlayerGetShootPos(Owner), _PlayerGetShootAng(Owner), 75, Owner)
		local ent = _EntCreate("prop_physics")
		if ent > 0 then
			_EntSetPos(ent, _TraceEndPos())
			_EntSetAngAngle(ent, vector3(_EntGetAngAngle(Owner).x, _EntGetAngAngle(Owner).y, 90))
			_EntSetModel(ent, barricademodel)
			_EntSetKeyValue(ent, "spawnflags", tostring(8+128+512+1024))
			_EntSpawn(ent)
			_EntFire(ent, "sethealth", "350", 0)
			_EntEmitSound(ent, "npc/dog/dog_servo12.wav")
			_SWEPUseAmmo(MyIndex, 0, _swep.GetClipAmmo(MyIndex, 0))
		end
    end
	
    function onSecondaryAttack()
    end

	function onReload( )
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
        return 6    
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
        return vector3( 0.0, 0.0, 0.0 )
    end
        
    function getNumShotsPrimary()
        return 1
    end
    
    function getPrimaryAmmoType()
        return "SniperRound"
    end

    function getDamageSecondary()
        return 10
    end
    
    function getSecondaryShotDelay()
        return 0.25
    end
    
    function getSecondaryIsAutomatic()
        return true
    end
    
    function getBulletSpreadSecondary()
        return vector3( 0.0, 0.0, 0.0 )
    end
    
    function getViewKickSecondary()
        return vector3( 0.0, 0.0, 0.0)
    end
    
    function getViewKickRandomSecondary()
        return vector3( 0, 0, 0 )
    end
    
    function getNumShotsSecondary()
        return 1
    end
    
    function getSecondaryAmmoType()
        return "none"
    end

    function getViewModel( )
		return "models/weapons/v_rpg.mdl"
    end
    
    function getWorldModel( )
 		return "models/weapons/w_rocket_launcher.mdl"
    end
    
    function getClassName() 
        return "weapon_barricadekit"
    end     

    function getMaxClipPrimary()
        return 1
    end
    
    function getMaxClipSecondary()
        return -1
    end
    
    function getDefClipPrimary()
        return 4
    end
    
    function getDefClipSecondary()
        return 0
    end

    function getAnimPrefix()
        return "shotgun"
    end

    function getPrintName()
        return "Barricade Kit"
    end

    function getDeathIcon()
	    return "d_pwn"
    end

    function getPrimaryScriptOverride()
        return 2
    end

    function getSecondaryScriptOverride()
        return 3
    end
