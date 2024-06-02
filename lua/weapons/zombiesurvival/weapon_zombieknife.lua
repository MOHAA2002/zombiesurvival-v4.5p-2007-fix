-- ZS Zombie Weapon
-- Based roughly off of the older lua crowbar
-- JetBoom

	function onPickup(playerid)
		_PlayerSetVecView(playerid, vector3(0, 0, 64))
		_PlayerSetVecDuck(playerid, vector3(0, 0, 24))
	end

	function onThink( )
		if _player.GetFlashlight(Owner) then
			_PlayerSetFlashlight(Owner, false)
		end
	end
	
	function Holster()
		_EntEmitSound(Owner, "npc/zombie/zombie_die"..math.random(1,3)..".wav")
	end
	
	function onPrimaryAttack( )
		if not _PlayerInfo( Owner, "alive" ) then return end
		local tracedVictim
		_TraceLine( _PlayerGetShootPos( Owner ), _PlayerGetShootAng( Owner ), 65, Owner )
		_RunString("CheckCorpseExplode(".._TraceEndPos().x..", ".._TraceEndPos().y..", ".._TraceEndPos().z..")")
		_PlayerViewModelSequence(Owner, 171)
		if _TraceHitNonWorld() then
			tracedVictim = _TraceGetEnt()
			_MakeDecal(math.random(46, 51))
			_EntEmitSound(tracedVictim, "npc/zombie/claw_strike"..math.random( 1, 3 )..".wav")
		if _EntGetName(tracedVictim) == "zombieplayer"
			or _EntGetName(tracedVictim) == "fastzombie_01"
			 or _EntGetType(tracedVictim) == "npc_zombie"
			  or _EntGetType(tracedVictim) == "npc_fastzombie"
			   or _EntGetType(tracedVictim) == "npc_poisonzombie"
			    or _EntGetType(tracedVictim) == "npc_headcrab"
			     or _EntGetType(tracedVictim) == "npc_headcrab_fast"
			      or _EntGetType(tracedVictim) == "npc_headcrab_black"
			       or _EntGetType(tracedVictim) == "npc_zombie_torso" then
			return
		end
		if tracedVictim > _MaxPlayers() then
			_TraceAttack( tracedVictim, Owner, Owner, 30)
			if _EntGetModel(tracedVictim) == "models/props_lab/monitor01b.mdl" then
				_EntRemove(tracedVictim)
			else
				_phys.ApplyForceCenter(tracedVictim, vecMul( _PlayerGetShootAng(Owner), vector3(60000, 60000, 185000)))
				_EntitySetPhysicsAttacker(tracedVictim, Owner)
			end
		end
		if _PlayerInfo(tracedVictim, "health") > 29 then     -- All this code to ignore suit armor
			_GModRect_Start( "gmod/white" )
			 _GModRect_SetPos(0.0, 0.0, 1.0, 1.0)
			 _GModRect_SetColor(255, 50, 50, 150)
			 _GModRect_SetTime(0, 0.1, 0.4)
			 _GModRect_SetDelay(0)
			_GModRect_Send(tracedVictim, 9111)
			_PlayerSetHealth(tracedVictim, _PlayerInfo(tracedVictim, "health")-29)
			_EffectInit()
			 _EffectSetOrigin(_TraceEndPos())
			 _EffectSetNormal(vecMul(_PlayerGetShootAng(Owner), -1))
			 _EffectSetScale(5)
			 _EffectSetFlags(9)
			_EffectDispatch("bloodspray")
			_TraceAttack( tracedVictim, Owner, Owner, 1)
		else
			_PlayerSetArmor(tracedVictim, 0)
			_TraceAttack( tracedVictim, Owner, Owner, 30) -- whoosh
			_EffectInit()
			 _EffectSetOrigin(_TraceEndPos())
			 _EffectSetNormal(vecMul(_PlayerGetShootAng(Owner), -1))
			 _EffectSetScale(5)
			 _EffectSetFlags(9)
			_EffectDispatch("bloodspray")
		end
			return
		elseif _TraceHitWorld() then
			_MakeDecal(math.random(46, 51))
			_EntEmitSound(Owner, "npc/zombie/claw_strike"..math.random( 1, 3 )..".wav")
		else
			_EntEmitSound(Owner, "npc/zombie/claw_miss"..math.random( 1, 2 )..".wav")
		end
	end

	function onSecondaryAttack( )
			_EntEmitSound(Owner, "npc/zombie/zombie_voice_idle"..math.random( 1, 14 )..".wav")
	end

	function onReload( )
		return false
	end

	function getWeaponSwapHands()
		return false	
	end

	function getWeaponFOV()
		return 60
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
		return 1.0;
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
		return vector3( 0.0, 8.0, 0.0 );
	end
	
	function getNumShotsPrimary()
		return 1;
	end

	function getPrimaryAmmoType()
		return "none";
	end

	function getDamageSecondary()
		return 10;
	end

	function getSecondaryShotDelay()
		return 2.5;
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
		return "models/weapons/shell.mdl"
	end

	function getClassName() 
		return "weapon_zombieknife";
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

	function getAnimPrefix() -- How the player holds the weapon: pistol, smg, ar2, shotgun, rpg, phys, crossbow, melee, slam, grenade
		return "phys";
	end

	function getPrintName()
		return "Zombie Weapon";
	end

	function getPrimaryScriptOverride()
		return 2;
	end

	function getSecondaryScriptOverride()
		return 2;
	end

	function getDeathIcon( )
		return "d_brains"
	end
