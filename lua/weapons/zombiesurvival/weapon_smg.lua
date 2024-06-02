-- ZS SMG
-- JetBoom

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
	
	function getTracerFreqPrimary() return 1 end

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
		return vector3( 0.06, 0.06, 0.09 )
	end

	function getViewKick()
		return vector3( -1.0, 0.0, 0.0)
	end

	function getViewKickRandom()
		return vector3( 1.1, 1.0, 0.9 )
	end

	function getViewModel( )
		return "models/weapons/v_smg_mp5.mdl"
	end

	function getWorldModel( )
		return "models/weapons/w_smg_mp5.mdl"
	end

	function getClassName()
		return "weapon_smg"
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
		return "Sub-Machine Gun"
	end

	function getPrimaryScriptOverride()
		return 0
	end

	function getSecondaryScriptOverride()
		return 3
	end

function getDeathIcon( )
	return "d_mp5navy"
end
