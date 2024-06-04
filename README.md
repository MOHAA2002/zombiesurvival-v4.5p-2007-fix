# Zombie Survival v4.5p (2007) Fix

## Bugs:
- ZombieSurvival.lua crashes gmod9 from function gamerulesStartMap: _EntPrecacheModel("models/player/"..result[i])
- Survivors don't become The Undead after being killed.
- [LUA] Error calling 'eventPlayerKilled' : 'Line 658: attempt to index global 'players' (a nil value)'
- [LUA] Error calling 'eventNPCKilled' : 'Line 610: attempt to index global 'players' (a nil value)'
- [LUA] Error calling 'eventPlayerSpawn' : 'Line 585: attempt to index global 'players' (a nil value)'
- [LUA] Error calling 'eventPlayerSpawn' : 'Line 602: attempt to index global 'players' (a nil value)'
- HL2 grenade duplicated with weapon_grenade.lua when spawned in map.
- d_pwn.vtf & d_pwn.vmt missing from weapon_firezombie.lua.

## Fixes:
- NDB Database replaced. -Brainles5
- Recreated human win sound (humanvictory.mp3) by using unlife1.mp3 dated from 2006 in v1.10. -Soldier
