-- ZS Swiss Army Knife
-- Based roughly off of the older lua crowbar
-- JetBoom

	function onInit( )
	end

	function onThink( )
	end
	
	function onPrimaryAttack( )
		if( _PlayerInfo(Owner, "alive") == false) then return; end
		local tracedVictim
		_TraceLine( _PlayerGetShootPos( Owner ), _PlayerGetShootAng( Owner ), 60, Owner )
		_PlayerViewModelSequence(Owner, 171)
		if(_TraceHitNonWorld()) then
			tracedVictim = _TraceGetEnt()
			_TraceAttack( tracedVictim, Owner, Owner, 15)
			if(tracedVictim <= _MaxPlayers() or string.sub(_EntGetType(tracedVictim), 1, 3) == "npc" or _EntGetType(tracedVictim) == "prop_ragdoll") then
				_MakeDecal(math.random(46, 51))
				_EntEmitSound(tracedVictim, "weapons/knife/knife_hit"..math.random( 1, 4 )..".wav")
			else
				_MakeDecal(math.random(72, 74))
				_EntEmitSound(tracedVictim, "weapons/knife/knife_hitwall1.wav")
			end
		elseif (_TraceHitWorld()) then
			_MakeDecal(math.random(72, 74))
			_EntEmitSound(Owner, "weapons/knife/knife_hitwall1.wav")
		else
			_EntEmitSound(Owner, "weapons/knife/knife_slash"..math.random( 1, 2 )..".wav")
		end
	end

	function onSecondaryAttack( )
	end

	function onReload( )
		return false
	end

	function getWeaponSwapHands()
		return false	
	end

	function getWeaponFOV()
		return 75
	end

	function getWeaponSlot()
		return 0	
	end

	function getWeaponSlotPos()
		return 2;	
	end

	function getFiresUnderwater()
		return true;
	end

	function getReloadsSingly()
		return false;
	end

	function getDamage()
		return 10;
	end

	function getPrimaryShotDelay()
		return 0.75;
	end
	
	function getPrimaryIsAutomatic()
		return true;
	end
		
	function getBulletSpread()
		return vector3( 0.00, 0.00, 0.00 );
	end

	function getViewKick()
		return vector3( 0.0, 0.0, 0.0);
	end

	function getViewKickRandom()
		return vector3( 0.0, 3.0, 0.0 );
	end
	
	function getNumShotsPrimary()
		return 1;
	end

	function getPrimaryAmmoType()
		return "none";
	end

	function getDamageSecondary()
		return 0
	end

	function getSecondaryShotDelay()
		return 400
	end

	function getSecondaryIsAutomatic()
		return false;
	end

	function getBulletSpreadSecondary()
		return vector3( 0.001, 0.001, 0.001 );
	end

	function getViewKickSecondary()
		return vector3( 0.5, 0.0, 0.0);
	end

	function getViewKickRandomSecondary()
		return vector3( 0.0, 0.0, 0.0 );
	end

	function getNumShotsSecondary()
		return 1;
	end

	function getSecondaryAmmoType()
		return "none";
	end

	function getViewModel( )
		return "models/weapons/v_knife_t.mdl";
	end

	function getWorldModel( )
		return "models/weapons/w_knife_ct.mdl";
	end

	function getClassName() 
		return "weapon_swissarmyknife";
	end

	function getMaxClipPrimary()
		return 1;
	end

	function getMaxClipSecondary()
		return -1;
	end

	function getDefClipPrimary() -- ammo in gun by default
		return 1;
	end

	function getDefClipSecondary()
		return 0;
	end

	function getAnimPrefix()
		return "melee"
	end

	function getPrintName()
		return "Swiss Army Knife";
	end

	function getPrimaryScriptOverride()
		return 2
	end

	function getSecondaryScriptOverride()
		return 3
	end
	
	function getDeathIcon( )
		return "d_knife"
	end