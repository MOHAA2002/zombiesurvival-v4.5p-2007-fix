-- ZS Headhumper Weapon
-- Based roughly off of the older lua crowbar
-- JetBoom

	function onPickup(playerid)
		_PlayerSetVecView(playerid, vector3(0, 0, 16))
		_PlayerSetVecDuck(playerid, vector3(0, 0, 16))
		_EntFire(playerid, "ignorefalldamage", "true", 0)
	end

	function onThink( )
		if _player.GetFlashlight(Owner) then
			_PlayerSetFlashlight(Owner, false)
		end
	end

	function Holster()
		_EntEmitSound(Owner, "npc/headcrab/die"..math.random(1,2)..".wav")
	end	

	function onPrimaryAttack( )
		if not _PlayerInfo(Owner, "alive") then return end
		local tracedVictim = 0
		_TraceLine( _PlayerGetShootPos( Owner ), _PlayerGetShootAng( Owner ), 50, Owner )
		_RunString("CheckCorpseExplode(".._TraceEndPos().x..", ".._TraceEndPos().y..", ".._TraceEndPos().z..")")
		_PlayerViewModelSequence(Owner, 171)
		if _TraceHitNonWorld() then
			tracedVictim = _TraceGetEnt()
			_MakeDecal(math.random(46, 51))
			_EntEmitSound(tracedVictim, "npc/headcrab/headbite.wav")
			if _EntGetName(tracedVictim) == "zombieplayer"
			or _EntGetName(tracedVictim) == "fastzombie_01"
			 or _EntGetType(tracedVictim) == "npc_zombie"
			  or _EntGetType(tracedVictim) == "npc_fastzombie"
			   or _EntGetType(tracedVictim) == "npc_poisonzombie"
			    or _EntGetType(tracedVictim) == "npc_headcrab"
			     or _EntGetType(tracedVictim) == "npc_headcrab_fast"
			      or _EntGetType(tracedVictim) == "npc_headcrab_black"
			       or _EntGetType(tracedVictim) == "npc_zombie_torso" then return end
			if _EntGetType(tracedVictim) ~= "player" then
				_TraceAttack( tracedVictim, Owner, Owner, 15)
				_EntEmitSound(tracedVictim, "npc/headcrab/headbite.wav")
			elseif _PlayerInfo(tracedVictim, "health") > 14 then
				_PlayerSetHealth(tracedVictim, _PlayerInfo(tracedVictim, "health")-14)
				_TraceAttack( tracedVictim, Owner, Owner, 1)
				_GModRect_Start( "gmod/white" )
				 _GModRect_SetPos(0.0, 0.0, 1.0, 1.0)
				 _GModRect_SetColor(255, 50, 50, 150)
				 _GModRect_SetTime(0, 0.1, 0.2)
				 _GModRect_SetDelay(0)
				_GModRect_Send(tracedVictim, 9111)
				_EffectInit()
				 _EffectSetOrigin(_TraceEndPos())
				 _EffectSetNormal(vecMul(_PlayerGetShootAng(Owner), -1))
				 _EffectSetScale(4)
				 _EffectSetFlags(9)
				_EffectDispatch("bloodspray")
				_EntEmitSound(tracedVictim, "npc/headcrab/headbite.wav")
			else
				_EffectInit()
				 _EffectSetOrigin(_TraceEndPos())
				 _EffectSetNormal(vecMul(_PlayerGetShootAng(Owner), -1))
				 _EffectSetScale(4)
				 _EffectSetFlags(9)
				 _EffectDispatch("bloodspray")
				_TraceAttack( tracedVictim, Owner, Owner, 25) -- whoosh
				_EntEmitSound(tracedVictim, "npc/headcrab/headbite.wav")
			end
		elseif _TraceHitWorld() then
			_MakeDecal(math.random(46, 51))
			_EntEmitSound(Owner, "npc/headcrab/headbite.wav")
		end
	end

	function onSecondaryAttack()
		if _EntGetModel(Owner) == "models/headcrab.mdl" then
			_EntEmitSound(Owner, "npc/headcrab/attack"..math.random(1,3)..".wav")
			_EntSetVelocity(Owner, vecAdd(_EntGetVelocity(Owner), vecMul( _PlayerGetShootAng(Owner), vector3(150, 150, 500))))
		else
			_EntEmitSound(Owner, "npc/headcrab/attack"..math.random(1,3)..".wav")
			_EntSetVelocity(Owner, vecAdd(_EntGetVelocity(Owner), vecMul( _PlayerGetShootAng(Owner), vector3(100, 100, 400))))
		end
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
		return 7
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
		return 1.25
	end
	
	function getPrimaryIsAutomatic()
		return true
	end
		
	function getBulletSpread()
		return vector3( 0.00, 0.00, 0.00 )
	end

	function getViewKick()
		return vector3( 0.0, 0.0, 0.0)
	end

	function getViewKickRandom()
		return vector3( 0.0, 0.0, 0.0 )
	end
	
	function getNumShotsPrimary()
		return 1
	end

	function getPrimaryAmmoType()
		return "none"
	end

	function getDamageSecondary()
		return 10
	end

	function getSecondaryShotDelay()
		return 1.5
	end

	function getSecondaryIsAutomatic()
		return true;
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
		return "weapon_headcrabknife";
	end

	function getMaxClipPrimary()
		return 1
	end

	function getMaxClipSecondary()
		return -1
	end

	function getDefClipPrimary()
		return 1
	end

	function getDefClipSecondary()
		return 0
	end

	function getAnimPrefix()
		return "phys"
	end

	function getPrintName()
		return "Headcrab Weapon";
	end

	function getPrimaryScriptOverride()
		return 2
	end

	function getSecondaryScriptOverride()
		return 2
	end
	
	function getDeathIcon( )
		return "d_brains"
	end
