-- ZS Glock 3
-- JetBoom

function onInit( )
	_SWEPSetSound( MyIndex, "single_shot", "Weapon_Glock.Single" )
end

function getNumShotsPrimary() return 3 end
function onReload() return true end
function getWeaponSwapHands() return true end
function getWeaponFOV() return 74 end
function getTracerFreqPrimary() return 1 end
function getWeaponSlot() return 1 end
function getWeaponSlotPos()	return 4 end
function getFiresUnderwater() return false end
function getReloadsSingly()	return false end
function getDamage() return 12.5 end
function getPrimaryShotDelay() return 0.3 end
function getSecondaryShotDelay() return 100 end
function getPrimaryIsAutomatic() return false end
function getSecondaryIsAutomatic() return false end
function getPrimaryAmmoType() return "pistol" end
function getSecondaryAmmoType() return "pistol" end
function getMaxClipPrimary() return math.ceil(20/3) end
function getMaxClipSecondary() return -1 end
function getDefClipPrimary() return math.ceil(20/3)*2 end
function getDefClipSecondary() return -1 end
function getPrimaryScriptOverride() return 0 end
function getSecondaryScriptOverride() return 3 end
function getBulletSpread()	return vector3( 0.11, 0.11, 0.11 ) end
function getViewKick() return vector3( 0.05, 0.05, 0.05) end
function getViewKickRandom() return vector3( 0, 0, 0.025 ) end
function getViewModel() return "models/weapons/v_pist_glock18.mdl" end
function getWorldModel() return "models/weapons/w_pist_glock18.mdl" end
function getClassName() return "weapon_glock3" end
function getAnimPrefix() return "pistol" end
function getPrintName() return "Glock 3" end
function getDeathIcon() return "d_glock" end
