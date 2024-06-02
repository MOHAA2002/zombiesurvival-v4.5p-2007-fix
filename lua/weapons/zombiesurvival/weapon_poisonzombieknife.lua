-- ZS Poison Zombie Weapon
-- Based roughly off of the older lua crowbar
-- JetBoom

CrabsLeft = 3

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
		_EntEmitSound(Owner, "npc/zombie_poison/pz_die"..math.random(1,2)..".wav")
	end
	
	function onPrimaryAttack( )
		if ( _PlayerInfo( Owner, "alive" ) == false ) then return; end
		local tracedVictim
		_TraceLine( _PlayerGetShootPos( Owner ), _PlayerGetShootAng( Owner ), 65, Owner )
		_RunString("CheckCorpseExplode(".._TraceEndPos().x..", ".._TraceEndPos().y..", ".._TraceEndPos().z..")")
		_PlayerViewModelSequence(Owner, 171)
		if (_TraceHitNonWorld()) then
			tracedVictim = _TraceGetEnt()
			_MakeDecal(math.random(46, 51))
			_EntEmitSound(tracedVictim, "npc/zombie/claw_strike"..math.random( 1, 3 )..".wav")
		if(_EntGetName(tracedVictim) == "zombieplayer"
			or _EntGetName(tracedVictim) == "fastzombie_01"
			 or _EntGetType(tracedVictim) == "npc_zombie"
			  or _EntGetType(tracedVictim) == "npc_fastzombie"
			   or _EntGetType(tracedVictim) == "npc_poisonzombie"
			    or _EntGetType(tracedVictim) == "npc_headcrab"
			     or _EntGetType(tracedVictim) == "npc_headcrab_fast"
			      or _EntGetType(tracedVictim) == "npc_headcrab_black"
			       or _EntGetType(tracedVictim) == "npc_zombie_torso") then
			return
		end
		if(tracedVictim > _MaxPlayers()) then
			_TraceAttack( tracedVictim, Owner, Owner, 50)
			if _EntGetModel(tracedVictim) == "models/props_lab/monitor01b.mdl" then
				_EntRemove(tracedVictim)
			else
				_phys.ApplyForceCenter(tracedVictim, vecMul( _PlayerGetShootAng(Owner), vector3(75000, 75000, 200000)))
				_EntitySetPhysicsAttacker(tracedVictim, Owner)
			end
		end
		if (_PlayerInfo(tracedVictim, "health") > 49) then
			_PlayerSetHealth(tracedVictim, _PlayerInfo(tracedVictim, "health")-49)
			_TraceAttack( tracedVictim, Owner, Owner, 1)
			_GModRect_Start( "gmod/white" )
			 _GModRect_SetPos(0.0, 0.0, 1.0, 1.0)
			 _GModRect_SetColor(50, 255, 0, 150)
			 _GModRect_SetTime(0, 0.1, 0.8)
			 _GModRect_SetDelay(0)
			_GModRect_Send(tracedVictim, 9111)
			_EffectInit()
			 _EffectSetOrigin(_TraceEndPos())
			 _EffectSetNormal(vecMul(_PlayerGetShootAng(Owner), -1))
			 _EffectSetScale(7)
			 _EffectSetFlags(9)
			_EffectDispatch("bloodspray")
		else
			_TraceAttack( tracedVictim, Owner, Owner, 500) -- weeeeeeeeeee
			_EffectInit()
			 _EffectSetOrigin(_TraceEndPos())
			 _EffectSetNormal(vecMul(_PlayerGetShootAng(Owner), -1))
			 _EffectSetScale(7)
			 _EffectSetFlags(9)
			_EffectDispatch("bloodspray")
		end
			return
		elseif (_TraceHitWorld()) then
			_MakeDecal(math.random(46, 51))
			_EntEmitSound(Owner, "npc/zombie/claw_strike"..math.random( 1, 3 )..".wav")
		else
			_EntEmitSound(Owner, "npc/zombie/claw_miss"..math.random( 1, 2 )..".wav")
		end
	end

	function onSecondaryAttack()
		_EntPrecacheModel("models/headcrabblack.mdl")
		if(CrabsLeft <= 0) then
			_EntEmitSound(Owner, "npc/zombie_poison/pz_idle"..math.random(2,4)..".wav")
			return
		end
		_EntEmitSound(Owner, "npc/zombie_poison/pz_throw"..math.random(2,3)..".wav")
		_RunString("ThrowHeadCrab("..Owner..")")
		CrabsLeft = CrabsLeft-1
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
		return 2	
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
		return 2.0
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
		return vector3( 0.0, 8.0, 0.0 )
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
		return 10.0
	end

	function getSecondaryIsAutomatic()
		return false
	end

	function getBulletSpreadSecondary()
		return vector3( 0.001, 0.001, 0.001 )
	end

	function getViewKickSecondary()
		return vector3( 0.5, 0.0, 0.0)
	end

	function getViewKickRandomSecondary()
		return vector3( 0.0, 0.0, 0.0 )
	end

	function getNumShotsSecondary()
		return 1
	end

	function getSecondaryAmmoType()
		return "none"
	end

	function getViewModel( )
		return "models/weapons/v_knife_t.mdl"
	end

	function getWorldModel( )
		return "models/weapons/shell.mdl"
	end

	function getClassName() 
		return "weapon_poisonzombieknife"
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
		return 0;
	end

	function getAnimPrefix() -- How the player holds the weapon: pistol, smg, ar2, shotgun, rpg, phys, crossbow, melee, slam, grenade
		return "phys"
	end

	function getPrintName()
		return "Poison Zombie Weapon";
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
