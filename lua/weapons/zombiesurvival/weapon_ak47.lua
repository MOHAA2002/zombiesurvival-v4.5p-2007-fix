-- ZS AK-47
-- JetBoom

	function onInit( )
		_SWEPSetSound( MyIndex, "single_shot", "Weapon_AK47.Single" )
	end

	function getWeaponSwapHands()
		return true	
	end

	function getWeaponFOV()
		return 74	
	end

	function getWeaponSlot()
		return 4	
	end

	function getWeaponSlotPos()
		return 6	
	end
	
	function getTracerFreqPrimary() return 1 end

	function getFiresUnderwater()
		return true
	end

	function getReloadsSingly()
		return false
	end

	function getDamage()
		return 19
	end

	function getPrimaryShotDelay()
		return 0.09
	end

	function getSecondaryShotDelay()
		return 100
	end

	function getPrimaryIsAutomatic()
		return true
	end

	function getSecondaryIsAutomatic()
		return true
	end

	function getBulletSpread()
		return vector3( 0.018, 0.017, 0.017 )
	end

	function getViewKick()
		return vector3( -1.9, 0.0, 0.0)
	end

	function getViewKickRandom()
		return vector3( 0.8, 0.7, 0.6 )
	end

	function getViewModel( )
		return "models/weapons/v_rif_ak47.mdl"
	end

	function getWorldModel( )
		return "models/weapons/w_rif_ak47.mdl"
	end

	function getClassName()
		return "weapon_ak47"
	end

	function getPrimaryAmmoType()
		return "AR2"
	end

	function getSecondaryAmmoType()
		return "AR2"
	end

	function getMaxClipPrimary()
		return 30
	end

	function getMaxClipSecondary()
		return -1
	end

	function getDefClipPrimary()
		return 120
	end

	function getDefClipSecondary()
		return -1
	end

	function getAnimPrefix()
		return "smg"
	end

	function getPrintName()
		return "AK47 Assault Rifle"
	end

	function getPrimaryScriptOverride()
		return 0
	end

	function getSecondaryScriptOverride()
		return 3
	end
	
	function getDeathIcon( )
		return "d_ak47"
	end
