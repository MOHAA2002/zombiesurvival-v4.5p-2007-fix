# zombiesurvival-v4.5p-2007-fix
 Restoration on JetBoom's Last GMOD9 ZS Build

Bugs:
- ZombieSurvival.lua crashes gmod9 from function gamerulesStartMap: _EntPrecacheModel("models/player/"..result[i])
- Survivors don't become The Undead after killed.
- HL2 grenade duplicated with weapon_grenade.lua when spawned in map.
- Ammo regeneration not working (unless not present in Lua code).
- weapon_firezombie.lua missing d_pwn.vtf & d_pwn.vmt

Fixes:
- Recreated Human Win Sound (humanvictory.mp3) by using unlife1.mp3 dated from 2006 in v1.10.