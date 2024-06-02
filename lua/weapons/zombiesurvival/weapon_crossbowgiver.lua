-- ZS SMG
-- JetBoom

function onPickup( playerid )
	local weap = _EntGetType(_PlayerGetActiveWeapon(playerid))
	_PlayerGiveItem(playerid, "weapon_crossbow")
	_PlayerRemoveWeapon(playerid, "weapon_crossbowgiver")
end

	function onInit( )
		_SWEPSetSound( MyIndex, "single_shot", "Weapon_MP5Navy.Single" )
	end

	function getWeaponSwapHands()
		return true	
	end

	function getWeaponFOV()
		return 74	
	end

	function getWeaponSlot()
		return 3	
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
		return 11
	end

	function getPrimaryShotDelay()
		return 0.09
	end

	function getSecondaryShotDelay()
		return 80
	end

	function getPrimaryIsAutomatic()
		return true
	end

	function getSecondaryIsAutomatic()
		return true
	end

	function getBulletSpread()
		return vector3( 0.04, 0.04, 0.04 )
	end

	function getViewKick()
		return vector3( 0.0, 0.0, 0.0)
	end

	function getViewKickRandom()
		return vector3( 0.1, 0.0, 0.05 )
	end

	function getViewModel( )
		return "models/weapons/v_smg_mp5.mdl"
	end

	function getWorldModel( )
		return "models/weapons/w_smg_mp5.mdl"
	end

	function getClassName()
		return "weapon_crossbowgiver"
	end

	function getPrimaryAmmoType()
		return "SMG1"
	end

	function getSecondaryAmmoType()
		return "SMG1"
	end

	function getMaxClipPrimary()
		return 30
	end

	function getMaxClipSecondary()
		return -1
	end

	function getDefClipPrimary()
		return 90
	end

	function getDefClipSecondary()
		return -1
	end

	function getAnimPrefix()
		return "smg"
	end

	function getPrintName()
		return "qqq"
	end

	function getPrimaryScriptOverride()
		return 3
	end

	function getSecondaryScriptOverride()
		return 3
	end

function getDeathIcon( )
	return "d_mp5navy"
end
