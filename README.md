# Zombie Survival v4.5p (2007) Fix

## Bugs:
### High Priority:
- ZombieSurvival.lua crashes gmod9 from function gamerulesStartMap: _EntPrecacheModel("models/player/"..result[i])
- Game doesn't end after timer hits 0 or last survivor killed.
- [LUA] Error calling 'eventPlayerKilled' : 'Line 1199: attempt to index global 'Muted' (a nil value)'
- Game potentially crashes when reloading map after creating res: _file.Write("maps/".._GetCurrentMap()..".res", str)
### Medium Priority:
- HL2 grenade duplicated with weapon_grenade.lua when spawned in map.
### Low Priority:

## Fixes:
- NDB Database replaced. -Brainles5
- Recreated human win sound (humanvictory.mp3) by using unlife1.mp3 dated from 2006 in v1.10. -Soldier
