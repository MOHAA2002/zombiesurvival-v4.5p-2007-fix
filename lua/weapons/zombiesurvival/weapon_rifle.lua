-- ZS Hunting Rifle
-- JetBoom

myTime = 0

function onInit( )
	_SWEPSetSound( MyIndex, "single_shot", "npc/sniper/sniper1.wav" )
end

function onThink( )
 	
end

function onPrimaryAttack( )
	myTime = _CurTime()
	_EntEmitSound(Owner, "npc/sniper/sniper1.wav")
end

function onSecondaryAttack( )		
	
end

function onReload( )
	if myTime < _CurTime()-1.5 then
		myTime = _CurTime()
		return true
	else
		return false
	end
end

function getTracerFreqPrimary() return 1 end

function getWeaponSwapHands()
	return true	
end

function getWeaponFOV()
	return 75	
end

function getWeaponSlot()
	return 3	
end

function getWeaponSlotPos()
	return 7	
end

function getFiresUnderwater()
	return true
end

function getReloadsSingly()
	return false
end

function getDamage()
	return 85
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
	return "357"
end

function getSecondaryAmmoType()
	return "none"
end

function getMaxClipPrimary()
	return 2
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
	return vector3( 0.01, 0.01, 0.01 )
end

function getViewKick()
	return vector3( -9.0, 1.0, 1.0)
end

function getViewKickRandom()
	return vector3( 3.0, 3.0, 3.0 )
end

function getViewModel( )
	return "models/weapons/v_shot_xm1014.mdl"
end

function getWorldModel( )
	return "models/weapons/w_shot_xm1014.mdl"
end

function getClassName()
	return "weapon_rifle"
end

function getAnimPrefix()
	return "rpg"
end

function getPrintName()
	return "Slug Rifle"
end

function getDeathIcon( )
	return "d_scout"
end