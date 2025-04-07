local isScoreboardOpen = false
local playerPings = {}
local playerJobs = {}
local serverPlayerList = {}
local scrollOffset = 0
local ESX, QBCore, QBOX = nil, nil, false

CreateThread(function()
    if Config.Framework == "esx" then
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework == "qbcore" then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

RegisterNetEvent('omes_scoreboard:receivePings')
AddEventHandler('omes_scoreboard:receivePings', function(players)
    playerPings = {}
    for _, player in ipairs(players) do
        playerPings[tostring(player.id)] = player.ping
    end
end)

RegisterNetEvent('omes_scoreboard:receiveJobs')
AddEventHandler('omes_scoreboard:receiveJobs', function(jobs)
    playerJobs = jobs
end)

RegisterNetEvent('omes_scoreboard:receiveAllPlayers')
AddEventHandler('omes_scoreboard:receiveAllPlayers', function(players)
    serverPlayerList = players
end)

local function GetAllPlayers()
    local players = {}
    
    for _, player in ipairs(serverPlayerList) do
        local serverID = player.id
        local strServerID = tostring(serverID)
        
        local ping = playerPings[strServerID] or 0
        
        local playerJob = "Unknown"
        local playerJobGrade = 0
        
        if playerJobs[strServerID] then
            playerJob = playerJobs[strServerID].job
            playerJobGrade = playerJobs[strServerID].jobGrade
        elseif NetworkIsPlayerActive(GetPlayerFromServerId(tonumber(serverID))) and GetPlayerFromServerId(tonumber(serverID)) == PlayerId() then
            if Config.Framework == "esx" and ESX then
                local playerData = ESX.GetPlayerData()
                if playerData and playerData.job then
                    playerJob = playerData.job.name
                    playerJobGrade = playerData.job.grade
                end
            elseif Config.Framework == "qbcore" and QBCore then
                local playerData = QBCore.Functions.GetPlayerData()
                if playerData and playerData.job then
                    playerJob = playerData.job.name
                    playerJobGrade = playerData.job.grade.level
                end
            elseif Config.Framework == "qbx" then
                local playerData = QBX.PlayerData
                if playerData and playerData.job then
                    playerJob = playerData.job.name
                    playerJobGrade = playerData.job.grade.level
                end
            end
        else
        end
        
        table.insert(players, {
            id = serverID,
            name = player.name,
            ping = ping,
            job = playerJob,
            jobGrade = playerJobGrade
        })
    end
    
    table.sort(players, function(a, b)
        return a.id < b.id
    end)
    
    return players
end

local function RequestPingData()
    TriggerServerEvent('omes_scoreboard:requestPings')
end

local function RequestJobData()
    TriggerServerEvent('omes_scoreboard:requestJobs')
end

local function RequestAllPlayers()
    TriggerServerEvent('omes_scoreboard:requestAllPlayers')
end

function ToggleScoreboard()
    isScoreboardOpen = not isScoreboardOpen
    
    if isScoreboardOpen then
        scrollOffset = 0
        
        RequestPingData()
        RequestJobData()
        RequestAllPlayers()
        Citizen.Wait(100)
        
        local players = GetAllPlayers()
        
        local jobCounts = {}
        local jobConfigs = nil
        
        if Config.ShowJobs then
            jobConfigs = Config.DisplayedJobs
            
            for _, jobConfig in ipairs(Config.DisplayedJobs) do
                jobCounts[jobConfig.name] = 0
            end
            
            for _, player in ipairs(players) do
                for _, jobConfig in ipairs(Config.DisplayedJobs) do
                    if player.job == jobConfig.name then
                        jobCounts[jobConfig.name] = jobCounts[jobConfig.name] + 1
                    end
                end
            end
        end
        
        SendNUIMessage({
            type = "showScoreboard",
            players = players,
            title = Config.ScoreboardTitle,
            position = Config.Position,
            largeMode = Config.LargeMode,
            showJobs = Config.ShowJobs,
            jobConfigs = jobConfigs,
            jobCounts = jobCounts
        })
    else
        SendNUIMessage({
            type = "hideScoreboard"
        })
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if IsControlJustPressed(0, Config.OpenKey) then
            ToggleScoreboard()
        end
        
        if isScoreboardOpen then
            if IsControlJustPressed(0, Config.OpenKey) then
                ToggleScoreboard()
            end
            
            if IsControlPressed(0, 172) then
                scrollOffset = scrollOffset - 5
                if scrollOffset < 0 then scrollOffset = 0 end
                SendNUIMessage({
                    type = "scroll",
                    offset = scrollOffset
                })
            end
            
            if IsControlPressed(0, 173) then
                scrollOffset = scrollOffset + 5
                SendNUIMessage({
                    type = "scroll",
                    offset = scrollOffset
                })
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isScoreboardOpen then
            RequestPingData()
            RequestJobData()
            RequestAllPlayers()
            Citizen.Wait(100)
            
            local players = GetAllPlayers()
            
            local jobCounts = {}
            local jobConfigs = nil
            
            if Config.ShowJobs then
                jobConfigs = Config.DisplayedJobs
                
                for _, jobConfig in ipairs(Config.DisplayedJobs) do
                    jobCounts[jobConfig.name] = 0
                end
                
                for _, player in ipairs(players) do
                    for _, jobConfig in ipairs(Config.DisplayedJobs) do
                        if player.job == jobConfig.name then
                            jobCounts[jobConfig.name] = jobCounts[jobConfig.name] + 1
                        end
                    end
                end
            end
            
            SendNUIMessage({
                type = "updatePlayers",
                players = players,
                title = Config.ScoreboardTitle,
                position = Config.Position,
                largeMode = Config.LargeMode,
                showJobs = Config.ShowJobs,
                jobConfigs = jobConfigs,
                jobCounts = jobCounts
            })
        end
        Citizen.Wait(Config.RefreshInterval)
    end
end)

function Draw3DText(x, y, z, text, size)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    size = size or Config.MaxTextSize
    
    SetTextScale(size, size)
    SetTextFont(Config.TextFont)
    SetTextProportional(1)
    SetTextColour(table.unpack(Config.TextColor))
    SetTextDropshadow(table.unpack(Config.TextDropShadow))
    SetTextEdge(table.unpack(Config.TextEdge))
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if isScoreboardOpen and Config.ShowPlayerIDs then
            local players = GetActivePlayers()
            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)
            
            for _, id in ipairs(players) do
                local ped = GetPlayerPed(id)
                if DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local distance = #(myCoords - coords)
                    
                    if distance <= Config.MaxDisplayDistance then
                        local serverID = GetPlayerServerId(id)
                        local textSize = Config.MaxTextSize * (1.0 - (distance / 20.0))
                        textSize = math.max(Config.MinTextSize, textSize)
                        
                        local heightOffset = Config.HeightOffsetBase
                        if distance > 5.0 then
                            heightOffset = Config.HeightOffsetBase + (distance - 5.0) * Config.HeightOffsetFactor
                        end
                        
                        Draw3DText(coords.x, coords.y, coords.z + heightOffset, "ID: " .. serverID, textSize)
                    end
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)
