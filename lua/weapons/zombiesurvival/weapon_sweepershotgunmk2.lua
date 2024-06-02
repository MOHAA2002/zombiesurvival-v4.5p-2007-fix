-- ZS Sweeper Shotgun
-- Alternating | - line fire shotgun
-- JetBoom

temp = true

function onInit() _SWEPSetSound(MyIndex, "single_shot", "") end
function onPrimaryAttack()
	_EntEmitSound(MyIndex, "weapons/shotgun/shotgun_fire"..math.random(6,7)..".wav")
	_SWEPUpdateVariables(MyIndex)
end

function getTracerFreqPrimary() return 1 end
function getWeaponSwapHands() return true end
function getWeaponFOV()	return 74 end
function getWeaponSlot() return 3 end
function getWeaponSlotPos() return 9 end
function getFiresUnderwater() return true end
function getReloadsSingly() return true end
function getDamage() return 12 end
function getPrimaryShotDelay() return 0.8 end
function getPrimaryIsAutomatic() return false end
function getBulletSpread()
	temp = not temp
	if temp then
		return vector3(0.4, 0.0, 0.0)
	else
		return vector3(0.0, 0.4, 0.0)
	end
end
function getNumShotsPrimary() return 8 end
function getViewKick() return vector3(-5.0, 0.0, 0.0) end
function getViewKickRandom() return vector3(0.0, 2.0, 1.5) end
function getViewModel() return "models/weapons/v_shot_m3super90.mdl" end
function getWorldModel() return "models/weapons/w_shot_m3super90.mdl" end
function getClassName() return "weapon_sweepershotgunmk2" end
function getPrimaryAmmoType() return "Buckshot" end
function getSecondaryAmmoType() return "Buckshot" end
function getMaxClipPrimary() return 8 end
function getMaxClipSecondary() return -1 end
function getDefClipPrimary() return 32 end
function getDefClipSecondary() return -1 end
function getAnimPrefix() return "shotgun" end
function getPrintName() return "'Sweeper' MK2 Shotgun" end
function getPrimaryScriptOverride() return 0 end
function getSecondaryScriptOverride() return 3 end
function getDeathIcon() return "d_shotgun" end
