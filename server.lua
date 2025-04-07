local function GetPlayersWithPing()
    local players = {}
    local playerList = GetPlayers()
    
    for _, player in ipairs(playerList) do
        local ping = GetPlayerPing(player)
        table.insert(players, {
            id = player,
            ping = ping
        })
    end
    
    return players
end

RegisterNetEvent('omes_scoreboard:requestPings')
AddEventHandler('omes_scoreboard:requestPings', function()
    local source = source
    local players = GetPlayersWithPing()
    TriggerClientEvent('omes_scoreboard:receivePings', source, players)
end)

local ESX, QBCore = nil, nil
if Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function GetPlayersWithJobs()
    local playerJobs = {}
    
    if Config.Framework == "esx" and ESX then
        local xPlayers = ESX.GetPlayers()
        for _, playerId in ipairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                playerJobs[tostring(playerId)] = {
                    job = xPlayer.job.name,
                    jobGrade = xPlayer.job.grade
                }
            end
        end
    elseif Config.Framework == "qbcore" and QBCore then
        for _, playerId in ipairs(GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
            if Player then
                playerJobs[tostring(playerId)] = {
                    job = Player.PlayerData.job.name,
                    jobGrade = Player.PlayerData.job.grade.level
                }
            end
        end
    elseif Config.Framework == "qbx" then
        for _, playerId in ipairs(GetPlayers()) do
            local Player = exports.qbx_core:GetPlayer(tonumber(playerId))
            if Player then
                playerJobs[tostring(playerId)] = {
                    job = Player.PlayerData.job.name,
                    jobGrade = Player.PlayerData.job.grade.level
                }
            end
        end
    end
    
    return playerJobs
end

RegisterNetEvent('omes_scoreboard:requestJobs')
AddEventHandler('omes_scoreboard:requestJobs', function()
    local source = source
    local playerJobs = GetPlayersWithJobs()
    TriggerClientEvent('omes_scoreboard:receiveJobs', source, playerJobs)
end)

local function GetAllPlayerInfo()
    local allPlayers = {}
    local playerList = GetPlayers()
    
    for _, playerId in ipairs(playerList) do
        local name = GetPlayerName(playerId)
        table.insert(allPlayers, {
            id = playerId,
            name = name
        })
    end
    
    return allPlayers
end

RegisterNetEvent('omes_scoreboard:requestAllPlayers')
AddEventHandler('omes_scoreboard:requestAllPlayers', function()
    local source = source
    local allPlayers = GetAllPlayerInfo()
    TriggerClientEvent('omes_scoreboard:receiveAllPlayers', source, allPlayers)
end)
