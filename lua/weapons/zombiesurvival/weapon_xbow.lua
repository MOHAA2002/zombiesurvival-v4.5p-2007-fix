function onInit()
	_SWEPSetSound( MyIndex, "single_shot", "Weapon_Crossbow.Single" )
end

function onThink()
end

function onPrimaryAttack()
	local Bolt = _EntCreate( "physics_prop" )
		if (Bolt > 0) then
		_EntPrecacheModel( "models/mixerman3d/other/arrow.mdl" )
		_EntSetModel(Bolt, "models/mixerman3d/other/arrow.mdl")
		_EntSetPos( Bolt, vecAdd(_PlayerGetShootPos( Owner ),vecMul(_PlayerGetShootAng( Owner ),vector3(60,60,60))))
		_EntSetAng( Bolt, _PlayerGetShootAng(Owner))
		_EntSetOwner( Bolt, Owner )
		_EntSetAng(Bolt, _PlayerGetShootAng(Owner))
		_EntSpawn(Bolt)
		local vAim = _PlayerGetShootAng( Owner )
		if ( vAim == nil) then	return; end
			vAim.x = vAim.x * 380000
			vAim.y = vAim.y * 380000
			vAim.z = vAim.z * 380000
		_phys.ApplyForceCenter(Bolt, vAim)
		_EntitySetPhysicsAttacker(Bolt, Owner)
		_EntFire(Bolt, "kill", "", 15)
		_SWEPUseAmmo(MyIndex, 0, 1)
	end
end

function onSecondaryAttack()
end

function onReload()
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
	return 3;	
end

function getFiresUnderwater()
	return true
end

function getReloadsSingly()
	return true
end

function getDamage()
	return 100
end

function getPrimaryShotDelay()
	return 1.25
end

function getSecondaryShotDelay()
	return 0.1
end

function getPrimaryIsAutomatic()
	return false
end

function getSecondaryIsAutomatic()
	return false
end

function getPrimaryAmmoType()
	return "XBowBolt"
end

function getSecondaryAmmoType()
	return "none";
end

function getMaxClipPrimary()
	return 1;
end

function getMaxClipSecondary()
	return -1;
end

function getDefClipPrimary()
	return 10;
end

function getDefClipSecondary()
	return -1;
end

function getPrimaryScriptOverride()
	return 2;
end

function getSecondaryScriptOverride()
	return 3;
end

function getBulletSpread()
	return vector3( 0.0, 0.0, 0.0 );
end

function getViewKick()
	return vector3( 0, 0.0, 0.0);
end

function getViewKickRandom()
	return vector3( 0.0, 0.0, 0.0 );
end

function getViewModel( )
	return "models/weapons/v_crossbow.mdl";
end

function getWorldModel( )
	return "models/weapons/w_crossbow.mdl";
end

function getClassName()
	return "weapon_xbow";
end

function getAnimPrefix()
	return "crossbow";
end

function getPrintName()
	return "X-Bow";
end
