-- ZS Desert Eagle
-- JetBoom

function onInit( )
	_SWEPSetSound( MyIndex, "single_shot", "Weapon_DEagle.Single" )
end

function onThink( )
		
end

function onPrimaryAttack( )
	
end

function onSecondaryAttack( )		
	
end

function getTracerFreqPrimary() return 1 end

function onReload( )
	return true
end

function getWeaponSwapHands()
	return true	
end

function getWeaponFOV()
	return 74	
end

function getWeaponSlot()
	return 1	
end

function getWeaponSlotPos()
	return 3	
end

function getFiresUnderwater()
	return false
end

function getReloadsSingly()
	return false
end

function getDamage()
	return 31
end

function getPrimaryShotDelay()
	return 0.3
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
	return "pistol"
end

function getSecondaryAmmoType()
	return "pistol"
end

function getMaxClipPrimary()
	return 7
end

function getMaxClipSecondary()
	return -1
end

function getDefClipPrimary()
	return 36
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
	return vector3( 0.02, 0.02, 0.02 )
end

function getViewKick()
	return vector3( 0, 0.0, 0.0)
end

function getViewKickRandom()
	return vector3( 2.0, 1.0, 1.0 )
end

function getViewModel( )
	return "models/weapons/v_pist_deagle.mdl"
end

function getWorldModel( )
	return "models/weapons/w_pist_deagle.mdl"
end

function getClassName()
	return "weapon_deagle"
end

function getAnimPrefix()
	return "pistol"
end

function getPrintName()
	return "Desert Eagle"
end

function getDeathIcon( )
	return "d_deagle"
end
