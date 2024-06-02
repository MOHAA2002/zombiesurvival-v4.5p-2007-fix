-- ZS Boom Stick
-- JetBoom

myTime = 0

function onInit( )
	_SWEPSetSound( MyIndex, "single_shot", "weapons/shotgun/shotgun_dbl_fire.wav" )
	_SWEPSetSound( MyIndex, "reload", "Weapon_SMG1.Reload" )
end

function onThink( )
 	
end

function onPrimaryAttack( )
	_EntEmitSound(Owner, "weapons/shotgun/shotgun_dbl_fire.wav")
	myTime = _CurTime()
end

function onSecondaryAttack( )
end

function onReload()
	if myTime < _CurTime()-2.5 then
		myTime = _CurTime()
		return true
	else
		return false
	end
end

function getWeaponSwapHands()
	return false
end

function getWeaponFOV()
	return 75	
end

function getWeaponSlot()
	return 3	
end

function getWeaponSlotPos()
	return 8	
end

function getFiresUnderwater()
	return true
end

function getReloadsSingly()
	return false
end

function getDamage()
	return 14
end

function getPrimaryShotDelay()
	return 1.5
end

function getSecondaryShotDelay()
	return 100
end

function getPrimaryIsAutomatic()
	return false
end

function getSecondaryIsAutomatic()
	return false
end

function getPrimaryAmmoType()
	return "Buckshot"
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
	return 30
end

function getDefClipSecondary()
	return -1
end

function getPrimaryScriptOverride()
	return 0
end

function getSecondaryScriptOverride()
	return 3
end

function getBulletSpread()
	return vector3( 0.04, 0.04, 0.04 )
end

function getViewKick()
	return vector3( -50.0, 1.0, 1.0)
end

function getViewKickRandom()
	return vector3( 25.0, 25.0, 25.0 )
end

function getViewModel( )
	return "models/weapons/v_shotgun.mdl"
end

function getWorldModel( )
	return "models/weapons/w_shotgun.mdl"
end

function getClassName()
	return "weapon_boomstick"
end

function getNumShotsPrimary()
	return 12
end

function getAnimPrefix()
	return "shotgun"
end

function getPrintName()
	return "Boom Stick"
end

function getDeathIcon( )
	return "d_shotgun"
end
