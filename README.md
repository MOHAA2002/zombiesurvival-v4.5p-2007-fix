# Zombie Survival v4.5p (2007) Fix

## Bugs:
- ZombieSurvival.lua crashes gmod9 from function gamerulesStartMap: _EntPrecacheModel("models/player/"..result[i])
- Game doesn't end after timer hits 0 or last survivor killed.
- [LUA] Error calling 'eventPlayerKilled' : 'Line 1199: attempt to index global 'Muted' (a nil value)'
- HL2 grenade duplicated with weapon_grenade.lua when spawned in map.
- d_pwn.vtf & d_pwn.vmt missing from weapon_firezombie.lua.

## Fixes:
- NDB Database replaced. -Brainles5
- Recreated human win sound (humanvictory.mp3) by using unlife1.mp3 dated from 2006 in v1.10. -Soldier
