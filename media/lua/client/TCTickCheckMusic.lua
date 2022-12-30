-- @filename - TCTickCheckMusic.lua

require "TCMusicClientFunctions"

local woMusicTable = {}
local playerMusicTable = {}
local vehicleMusicTable = {}

local tickControl = 100 -- Сокращает количество срабатываний скрипта. Больше число - меньше срабатываний
local tickStart = 0

function OnRenderTickClientCheckMusic ()
    tickStart = tickStart + 1
    if tickStart % tickControl == 0 then
        tickStart = 0
        -- Запрашиваем данные с сервера о музыке
        if isClient() then 
            ModData.request("trueMusicData") 
        end
        
        -- проверяем играет ли музыка в машинах, рядом с нами
        local vehicles = getCell():getVehicles()
        for i=0, vehicles:size()-1 do
            local vehicle = vehicles:get(i)
            local vehicleRadio = vehicle:getPartById("Radio")
            -- Ищем рядом авто, которые должны играть музыку
            if vehicleRadio and vehicleRadio:getModData().tcmusic then
                if vehicleRadio:getModData().tcmusic.mediaItem and 
                        vehicleRadio:getModData().tcmusic.isPlaying then
                    -- если найдено
                    vehicle:updateParts(); -- Выполнить обновление деталей, тем самым, вызвав функцию на сервере Vehicle.Update.Radio
                    -- print("updateParts")
                    if not vehicleMusicTable[vehicle:getSqlId()] then
                        -- если авто нет в локальной таблице, значит музыка не играет. Включаем музыку и записываем авто в таблицу.
                        local id = vehicle:getEmitter():playSoundImpl(vehicleRadio:getModData().tcmusic.mediaItem, IsoObject.new())
                        local vol = vehicleRadio:getDeviceData():getDeviceVolume()
                        local vol3d = true
                        if vehicle == getPlayer():getVehicle() then -- Если текущий игрок сидит в "играющей" машине для него повышается громкость и выключается 3д-эффект
                            vol = vol * 5
                            vol3d = false
                        elseif vehicleRadio:getModData().tcmusic.windowsOpen then
                            -- Открытые/разбитые окна влияют на громкость музыку и дальность приманивания зомби
                            vol = vol * 3
                        end
                        vehicleMusicTable[vehicle:getSqlId()] = {
                            obj = vehicle,
                            localmusicid = id,
                            volume = vol,
                        }
                        vehicle:getEmitter():setVolume(vehicleMusicTable[vehicle:getSqlId()]["localmusicid"], vol / 5)
                        vehicle:getEmitter():set3D(vehicleMusicTable[vehicle:getSqlId()]["localmusicid"], vol3d)
                    else
                        -- если авто есть в локальной таблице, значит музыка играет
                        if vehicleMusicTable[vehicle:getSqlId()]["obj"]:getEmitter() and 
                                vehicleMusicTable[vehicle:getSqlId()]["obj"]:getEmitter():isPlaying(vehicleMusicTable[vehicle:getSqlId()]["localmusicid"]) then
                            -- если музыка играет, продолжаем контролировать громкость и необходимость вкл/выкл 3д-эффекта
                            local vol = vehicleRadio:getDeviceData():getDeviceVolume()
                            if vehicle == getPlayer():getVehicle() then
                                vol = vol * 5
                                vehicle:getEmitter():set3D(vehicleMusicTable[vehicle:getSqlId()]["localmusicid"], false)
                            else
                                if vehicleRadio:getModData().tcmusic.windowsOpen then
                                    vol = vol * 3
                                end
                                vehicle:getEmitter():set3D(vehicleMusicTable[vehicle:getSqlId()]["localmusicid"], true)
                            end
                            if vehicleMusicTable[vehicle:getSqlId()]["volume"] ~= vol then
                                vehicle:getEmitter():setVolume(vehicleMusicTable[vehicle:getSqlId()]["localmusicid"], vol / 5)
                                vehicleMusicTable[vehicle:getSqlId()]["volume"] = vol
                            end
                        else
                        -- если музыка перестала играть, отправляем информацию на сервер и очищаем локальную таблицу
                            sendClientCommand(getPlayer(), 'truemusic', 'setMediaItemToVehiclePart', { vehicle = vehicleMusicTable[vehicle:getSqlId()]["obj"]:getId(), mediaItem = vehicleMusicTable[vehicle:getSqlId()]["obj"]:getPartById("Radio"):getModData().tcmusic.mediaItem, isPlaying = false })
                            vehicleMusicTable[vehicle:getSqlId()] = nil
                        end
                    end
                else
                    if vehicleMusicTable[vehicle:getSqlId()] then -- авто не должно играть музыка, но оно есть в локальной таблице
                        if vehicleMusicTable[vehicle:getSqlId()]["obj"] and vehicleMusicTable[vehicle:getSqlId()]["obj"]:getEmitter() then
                            vehicleMusicTable[vehicle:getSqlId()]["obj"]:getEmitter():stopSound(vehicleMusicTable[vehicle:getSqlId()]["localmusicid"])
                        end
                        vehicleMusicTable[vehicle:getSqlId()] = nil
                    end
                end
            end
        end
        
        -- пока в локальной таблице есть авто, мы продолжаем их мониторить
        for musicId, musicVehicleData in pairs(vehicleMusicTable) do
            if not musicVehicleData["obj"] then
                vehicleMusicTable[musicId] = nil
                -- continue
            else
                if musicVehicleData["obj"]:getPartById("Radio") and 
                        musicVehicleData["obj"]:getPartById("Radio"):getModData().tcmusic and 
                        musicVehicleData["obj"]:getPartById("Radio"):getModData().tcmusic.mediaItem then
                    
                    -- если авто перестало играть музыку, отправляем информацию на сервер
                    if musicVehicleData["obj"]:getEmitter() and not musicVehicleData["obj"]:getEmitter():isPlaying(musicVehicleData["localmusicid"]) then
                        sendClientCommand(getPlayer(), 'truemusic', 'setMediaItemToVehiclePart', { vehicle = musicVehicleData["obj"]:getId(), mediaItem = musicVehicleData["obj"]:getPartById("Radio"):getModData().tcmusic.mediaItem, isPlaying = false })
                        vehicleMusicTable[musicId] = nil
                    end
                    
                else
                    musicVehicleData["obj"]:getEmitter():stopSound(musicVehicleData["localmusicid"])
                    vehicleMusicTable[musicId] = nil
                end
            end
        end

        local musicServerTable = ModData.getOrCreate("trueMusicData")
        if musicServerTable and musicServerTable["now_play"] then
            for musicId, musicServerData in pairs(musicServerTable["now_play"]) do
                -- print("IN MODDATA:" .. musicId)
                local strCoord = string.match(musicId, '%d*[-]%d*[-]%d*')

                -- Автомобильная музыка обрабатывается в коде выше
                if musicId == "Vehicle" then

                -- Музыка из мира
                elseif strCoord then 
                    local musicData = woMusicTable[musicId] -- musicId = координаты места где стоит музыкальный проигрыватель

                    -- если проигрывателя нет в локальной таблице, значит музыка не играет. Ищем проигрыватель, включаем музыку и записываем в таблицу.
                    if not (musicData and musicData["obj"]) then 
                        local i = string.find(strCoord, "-")
                        local x = tonumber(string.sub(strCoord, 1, i-1))
                        strCoord = string.sub(strCoord, i+1)
                        i = string.find(strCoord, "-")
                        local y = tonumber(string.sub(strCoord, 1, i-1))
                        local z = tonumber(string.sub(strCoord, i+1))
                        local playerObj = getPlayer()
                        
                        if playerObj and (playerObj:getX() >= x - 60 and playerObj:getX() <= x + 60 and
                                playerObj:getY() >= y - 60 and playerObj:getY() <= y + 60) then -- если игрок рядом с местом, где играет музыка
                            local musicSquare = getSquare(x,y,z)
                            if musicSquare then
                                for i=1,musicSquare:getObjects():size() do
                                    object2 = musicSquare:getObjects():get(i-1)
                                    if instanceof( object2, "IsoWaveSignal") then
                                        local sprite = object2:getSprite()
                                        if sprite ~= nil then
                                            local name_sprite = sprite:getName()
                                            if TCMusic.WorldMusicPlayer[name_sprite] then
                                                getSoundManager():StopMusic()
                                                -- print(getSoundManager():getCurrentMusicName())
                                                -- print(getSoundManager():getCurrentMusicLibrary())
                                                woMusicTable[musicId] = {
                                                    obj = object2, 
                                                    volume = object2:getDeviceData():getDeviceVolume()
                                                }
                                                musicData = woMusicTable[musicId]
                                                if musicData["obj"]:getDeviceData():getEmitter() and musicData["obj"]:getDeviceData():getEmitter():isPlaying(musicData["obj"]:getModData().tcmusic.mediaItem) then
                                                    -- Если музыка уже играет не включать повторно (музыка для игроков в наушниках включается в другом месте)
                                                else
                                                    if musicData["obj"]:getDeviceData():getEmitter() then
                                                        musicData["obj"]:getDeviceData():getEmitter():stopAll()
                                                    end
                                                    musicData["obj"]:getDeviceData():playSound(musicData["obj"]:getModData().tcmusic.mediaItem, musicData["volume"] * 0.4, false)
                                                end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    -- если проигрыватель есть в локальной таблице
                    if musicData and musicData["obj"] then 
                        if musicData["obj"]:getModData().tcmusic.isPlaying then
                            if musicData["obj"]:getDeviceData() and musicData["obj"]:getDeviceData():getEmitter() then

                                -- если музыка перестала играть, отправляем информацию на сервер и очищаем локальную таблицу
                                if not musicData["obj"]:getDeviceData():getEmitter():isPlaying(musicData["obj"]:getModData().tcmusic.mediaItem) then
                                    musicData["obj"]:getDeviceData():getEmitter():stopAll()
                                    musicData["obj"]:getModData().tcmusic.isPlaying = false
                                    musicData["obj"]:transmitModData()
                                    ModData.getOrCreate("trueMusicData")["now_play"][musicId] = nil
                                    woMusicTable[musicId] = nil
                                    if isClient() then ModData.transmit("trueMusicData") end

                                -- если музыка играет, контролируем настройки громкости
                                else
                                    if musicData["volume"] ~= musicData["obj"]:getDeviceData():getDeviceVolume() then
                                        musicData["obj"]:getDeviceData():getEmitter():setVolumeAll(musicData["obj"]:getDeviceData():getDeviceVolume() * 0.4)
                                        woMusicTable[musicId]["volume"] = musicData["obj"]:getDeviceData():getDeviceVolume()
                                    end
                                end
                            else
                                woMusicTable[musicId] = nil
                            end
                        else
                            if musicData["obj"]:getDeviceData() and musicData["obj"]:getDeviceData():getEmitter() then
                                musicData["obj"]:getDeviceData():getEmitter():stopAll()
                            end
                            ModData.getOrCreate("trueMusicData")["now_play"][musicId] = nil
                            woMusicTable[musicId] = nil
                            if isClient() then ModData.transmit("trueMusicData") end
                        end
                    end

                -- Музыка "из карманов"
                else 
                    local player = nil
                    if isClient() then
                        player = getPlayerByOnlineID(musicId)
                    else
                        for playerNum = 0, getNumActivePlayers() - 1 do
                            local playerObj = getSpecificPlayer(playerNum)
                            if playerObj:getUsername() == musicId then player = playerObj end
                        end
                    end
                    if player and not player:isDead() then
                        local x = player:getX()
                        local y = player:getY()
                        local z = player:getZ()
                        local playerObj = getPlayer()
                        if playerObj then 
                            -- разбор случая для локального игрока, у которого в руках играем музыка
                            if playerObj == player then 
                                local musicData = playerMusicTable[musicId]
                                local musicplayer = playerObj:getInventory():getItemById(musicServerData["itemid"])

                                -- если игрок выбросил бумбокс, отправляем информацию на сервер
                                if not musicplayer then
                                    ModData.getOrCreate("trueMusicData")["now_play"][musicId] = nil
                                    if isClient() then ModData.transmit("trueMusicData") end
                                -- если музыка перестала играть, отправляем информацию на сервер
                                elseif not musicplayer:getModData().tcmusic.mediaItem or musicplayer:getDeviceData():getEmitter() and not musicplayer:getDeviceData():getEmitter():isPlaying(musicplayer:getModData().tcmusic.mediaItem) then
                                    musicplayer:getModData().tcmusic.isPlaying = false
                                    ModData.getOrCreate("trueMusicData")["now_play"][musicId] = nil
                                    if isClient() then ModData.transmit("trueMusicData") end
                                end
                            
                            -- Анализ остальных игроков, если они в зоне радиуса текущего игрока
                            elseif ((playerObj:getX() >= x - 60 and playerObj:getX() <= x + 60 and
                                    playerObj:getY() >= y - 60 and playerObj:getY() <= y + 60)) then
                                local musicData = playerMusicTable[musicId]

                                -- если игрока с музыкой нет в локальной таблице
                                if not musicData then
                                    if -- (player:getPrimaryHandItem() and (player:getPrimaryHandItem():getID() == musicServerData["itemid"])) or 
                                            (player:getSecondaryHandItem() and (player:getSecondaryHandItem():getID() == musicServerData["itemid"])) and 
                                            player:getSecondaryHandItem():getDeviceData() and (player:getSecondaryHandItem():getDeviceData():getPower() > 0) then
                                        -- проверяем, что проигрыватель всё еще в руках игрока, запускаем музыку, записываем в локальную таблицу
                                        local id = player:getEmitter():playSoundImpl(musicServerData["musicName"], nil)
                                        local koef = 0.4 -- коэффициент отвечающий за наличие наушников
                                        if musicServerData["headphone"] then
                                            koef = 0.02
                                        end
                                        playerMusicTable[musicId] = {
                                            localmusicid = id,
                                            volume = musicServerData["volume"] * koef,
                                        }
                                        player:getEmitter():setVolume(playerMusicTable[musicId]["localmusicid"], musicServerData["volume"] * koef)
                                    end
                                else

                                    -- если игрок в локальной таблице и музыка продолжает играть, контролируем громкость
                                    if player:getEmitter():isPlaying(musicData["localmusicid"]) then
                                        if -- (player:getPrimaryHandItem() and (player:getPrimaryHandItem():getID() == musicServerData["itemid"])) or 
                                            (player:getSecondaryHandItem() and player:getSecondaryHandItem():getDeviceData() and 
                                                player:getSecondaryHandItem():getDeviceData():getIsTurnedOn() and 
                                                (player:getSecondaryHandItem():getDeviceData():getPower() > 0) and 
                                                (player:getSecondaryHandItem():getID() == musicServerData["itemid"])) then
                                            local koef = 0.4  -- коэффициент отвечающий за наличие наушников
                                            if musicServerData["headphone"] then
                                                koef = 0.02
                                            end
                                            if musicData["volume"] ~= musicServerData["volume"] * koef then
                                                player:getEmitter():setVolume(musicData["localmusicid"], musicServerData["volume"] * koef)
                                                musicData["volume"] = musicServerData["volume"] * koef
                                            end

                                        -- если у игрока пропал проигрыватель из рук, отключаем музыку
                                        else
                                            ModData.getOrCreate("trueMusicData")["now_play"][musicId] = nil
                                            if isClient() then ModData.transmit("trueMusicData") end
                                            player:getEmitter():stopSound(musicData["localmusicid"])
                                            playerMusicTable[musicId] = nil
                                        end

                                    -- если музыка закончилась, отправляем информацию на сервер
                                    else
                                        ModData.getOrCreate("trueMusicData")["now_play"][musicId] = nil
                                        if isClient() then ModData.transmit("trueMusicData") end
                                        playerMusicTable[musicId] = nil
                                    end
                                end
                            end
                        end

                    -- если игрок с музыкой вышел из игры или умер
                    else
                        if player and playerMusicTable[musicId] then
                            player:getEmitter():stopSound(playerMusicTable[musicId]["localmusicid"])
                        end
                        ModData.getOrCreate("trueMusicData")["now_play"][musicId] = nil
                        if isClient() then ModData.transmit("trueMusicData") end
                        playerMusicTable[musicId] = nil
                    end
                end
            end
        end
        
        -- очищаем локальные таблицы от "фантомов", о которых не знает сервер
        for musicId, musicClientData in pairs(woMusicTable) do
            if not ModData.getOrCreate("trueMusicData")["now_play"][musicId] then
                if musicClientData["obj"] then
                    if musicClientData["obj"]:getDeviceData() and musicClientData["obj"]:getDeviceData():getEmitter() then
                        musicClientData["obj"]:getDeviceData():getEmitter():stopAll()
                    end
                    if musicClientData["obj"]:getModData() and musicClientData["obj"]:getModData().tcmusic then
                        musicClientData["obj"]:getModData().tcmusic.isPlaying = false
                        if string.match(musicId, '%d*[-]%d*[-]%d*') then
                            musicClientData["obj"]:transmitModData()
                        end
                    end
                end
                woMusicTable[musicId] = nil
            end
        end
        
        for musicId, musicClientData in pairs(playerMusicTable) do
            if not ModData.getOrCreate("trueMusicData")["now_play"][musicId] then
                local player = nil
                if isClient() then
                    player = getPlayerByOnlineID(musicId)
                else
                    player = getPlayer()
                end
                if player then
                    player:getEmitter():stopSound(musicClientData["localmusicid"])
                end
                playerMusicTable[musicId] = nil
            end
        end
    end
end

function startTrueMusicTick ()
    Events.OnTick.Add(OnRenderTickClientCheckMusic)
end

Events.OnCreatePlayer.Add(startTrueMusicTick)
