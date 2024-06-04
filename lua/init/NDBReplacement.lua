players = {} -- Playerdata for current game, uses userid as key
ndbdata = {} --"Database" data, dont modify this directly from gamemodes. Uses networkid(steamid) as key
NDB = {}     -- Contains functions to be called from gamemode

--Temporary Backup system
function NDBBackUpFile()
    NDBBackupTracker = NDBBackupTracker + 1
    local filecontent = _file.Read("lua/ndb/ndb.data")
    local backupfilepath = "lua/ndb/ndb_backup"..tostring(NDBBackupTracker)..".data"
    _file.Write(backupfilepath, filecontent)
    _Msg("NDB: Backup created\n")
end

function SaveNDBtoFile()
    local s = "NDBBackupTracker = "..tostring(NDBBackupTracker).."\n"
    for steamid, data in pairs(ndbdata) do
        s = s .. "ndbdata['" .. steamid .. "'] = {\n"
        s = s .. "\tMoney = " .. data.Money .. ",\n"
        s = s .. "\tZSHumanKills = " .. data.ZSHumanKills .. ",\n"
        s = s .. "\tZSZombieKills = " .. data.ZSZombieKills .. ",\n"
        s = s .. "\tCertifications = '" .. data.Certifications .. "',\n"
        s = s .. "}\n"
    end
    _file.Write("lua/ndb/ndb.data", s)
     _Msg("NDB: Player data saved\n")
end

if not _file.Exists("lua/ndb/ndb.data") then
    NDBBackupTracker = 0
    SaveNDBtoFile()
    _Msg("NDB: Created Player Data File\n")
else
    local filecontent = _file.Read("lua/ndb/ndb.data")
    _RunString(filecontent)
    NDBBackUpFile()
    _Msg("NDB: Loaded Player Data\n")
end

if NDBHookSpawn then UnHookEvent(NDBHookSpawn) end
NDBHookSpawn = HookEvent("eventPlayerInitialSpawn", function(userid)
    local steamid = _PlayerInfo(userid, "networkid")

    -- Should probably do a separate if or statement for each one incase we need to add more variables.
    if ndbdata[steamid] then
        players[userid] = ndbdata[steamid]
    else
        players[userid] = {}
        players[userid].Money = 0
        players[userid].ZSHumanKills = 0
        players[userid].ZSZombieKills = 0
        players[userid].Certifications = ""
    end
end)

if NDBHookDisconnect then UnHookEvent(NDBHookDisconnect) end
NDBHookDisconnect = HookEvent("eventPlayerDisconnect", function(userid)
    NDB.SaveInfo(userid)
    players[userid] = nil
end)

function NDB.SaveInfo(userid)
    local steamid = _PlayerInfo(userid, "networkid")
    ndbdata[steamid] = players[userid]
end

function NDB.GlobalSave()
    for userid, data in pairs(players) do
        NDB.SaveInfo(userid)
    end
    SaveNDBtoFile()
end

--The ZS gamemode sends a false for bool, im not sure what its meant to do.
function NDB.AddMoney(userid, amount, bool)
    players[userid].Money = players[userid].Money + amount
end
