-- ZS Starting Weapon
-- JetBoom

-- This is called when the weapon is given to player	
function onInit( )
	_SWEPSetSound( MyIndex, "single_shot", "Weapon_USP.Single" )
end

-- This is called every frame
function onThink( )
		
end

-- This is called when the player presses his primary fire button. This does nothing in this
-- implementation, as gmod takes care of simple fire routines. You'll only need to implement 
-- this if you wish to do something more exciting (i.e. fire a rocket, launch a grenade...)

function onPrimaryAttack( )
	
end

function getTracerFreqPrimary() return 1 end

-- Same as above
function onSecondaryAttack( )		
	
end

-- Return true if you want it to reload successfully
function onReload( )
	return true
end

-- Set this to true if you want the gun on the right side of your view.
-- False if you want it on the left.
function getWeaponSwapHands()
	return true	
end

-- Sets the player's Field of View while using this weapon.
function getWeaponFOV()
	return 74	
end


-- Slot number for the new weapon
-- 0 = crowbar/grav gun
-- 1 = pistol/357
-- 2 = smg/pulse rifle
-- 3 = shotgun/crossbow
-- 4 = genade/rpg
-- 5 = bugbait
function getWeaponSlot()
	return 1	
end

-- Position of weapon in the slot. If it is in the same slot position of another gun it will 
-- not show up.
function getWeaponSlotPos()
	return 5	
end

-- Just guess what this does.
function getFiresUnderwater()
	return false
end

-- Reload after every shot? (like the crossbow)
function getReloadsSingly()
	return false
end

-- how much damage the bullet does
function getDamage()
	return 10.5
end

-- Delay between shots (in seconds)
function getPrimaryShotDelay()
	return 0.17
end

-- Delay between shots for secondary fire (in seconds)
function getSecondaryShotDelay()
	return 100
end

-- Automatic weapon
function getPrimaryIsAutomatic()
	return false
end

-- Automatic weapon for secondary fire
function getSecondaryIsAutomatic()
	return false
end

-- Ammo type for primary fire
function getPrimaryAmmoType()
	return "pistol"
end

-- Ammo type for secondary fire
function getSecondaryAmmoType()
	return "pistol"
end

-- Max Clip size. -1 if no clip
function getMaxClipPrimary()
	return 12
end

-- Max Clip size for secondary fire. -1 if no clip
function getMaxClipSecondary()
	return -1
end

-- Primary Ammo given to player when given the gun
function getDefClipPrimary()
	return 84
end

-- Secondary Ammo given to player when given the gun
function getDefClipSecondary()
	return -1
end

-- 0 = Don't override, shoot bullets, make sound and flash
-- 1 = Don't shoot bullets but do make flash/sounds
-- 2 = Only play animations
-- 3 = Don't do anything
function getPrimaryScriptOverride()
	return 0
end

-- see above
function getSecondaryScriptOverride()
	return 3
end

-- Higher the # the bigger the spread
function getBulletSpread()
	return vector3( 0.02, 0.02, 0.02 )
end

-- amount of view kick
function getViewKick()
	return vector3( 0, 0.0, 0.0)
end

-- same as above only random values (set to 0.0 , 0.0, 0.0 for no random kick)
function getViewKickRandom()
	return vector3( 1.0, 0.7, 0.7 )
end

-- Defines the first person model
function getViewModel( )
	return "models/weapons/v_pist_p228.mdl"
end

-- Defines what it looks like from 3rd person view
function getWorldModel( )
	return "models/weapons/w_pist_p228.mdl"
end

-- Classname of wep. So you can use "give" for this
function getClassName()
	return "weapon_battleaxe"
end

-- getAnimPrefix - the animation prefix. one of the following: 
-- pistol, smg, ar2, shotgun, rpg, phys, crossbow, melee, slam, grenade
function getAnimPrefix()
	return "pistol"
end

-- Text you see when choosing the weapon
function getPrintName()
	return "'BattleAxe' Handgun"
end

function getDeathIcon( )
	return "d_glock"
end
