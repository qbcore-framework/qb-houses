local QBCore = exports['qb-core']:GetCoreObject()
local houseowneridentifier = {}
local houseownercid = {}
local housekeyholders = {}
local housesLoaded = false

-- Threads

Citizen.CreateThread(function()
    local HouseGarages = {}
    local result = exports.oxmysql:fetchSync('SELECT * FROM houselocations', {})
    if result[1] then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = json.decode(v.garage) or {}
            Config.Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {}
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage
            }
        end
    end
    TriggerClientEvent("qb-garages:client:houseGarageConfig", -1, HouseGarages)
    TriggerClientEvent("qb-houses:client:setHouseConfig", -1, Config.Houses)
end)

Citizen.CreateThread(function()
    while true do
        if not housesLoaded then
            exports.oxmysql:fetch('SELECT * FROM player_houses', {}, function(houses)
                if houses then
                    for _, house in pairs(houses) do
                        houseowneridentifier[house.house] = house.identifier
                        houseownercid[house.house] = house.citizenid
                        housekeyholders[house.house] = json.decode(house.keyholders)
                    end
                end
            end)
            housesLoaded = true
        end
        Citizen.Wait(7)
    end
end)

-- Commands

QBCore.Commands.Add("decorate", "Decorate Interior", {}, false, function(source)
    local src = source
    TriggerClientEvent("qb-houses:client:decorate", src)
end)

QBCore.Commands.Add("createhouse", "Create House (Real Estate Only)", {{name = "price", help = "Price of the house"}, {name = "tier", help = "Name of the item(no label)"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = tonumber(args[1])
    local tier = tonumber(args[2])
    if Player.PlayerData.job.name == "realestate" then
        TriggerClientEvent("qb-houses:client:createHouses", src, price, tier)
    else
        TriggerClientEvent('QBCore:Notify', src, "Only realestate can use this command", "error")
    end
end)

QBCore.Commands.Add("addgarage", "Add House Garage (Real Estate Only)", {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == "realestate" then
        TriggerClientEvent("qb-houses:client:addGarage", src)
    else
        TriggerClientEvent('QBCore:Notify', src, "Only realestate can use this command", "error")
    end
end)

QBCore.Commands.Add("enter", "Enter House", {}, false, function(source)
    local src = source
    TriggerClientEvent('qb-houses:client:EnterHouse', src)
end)

QBCore.Commands.Add("ring", "Ring The Doorbell", {}, false, function(source)
    local src = source
    TriggerClientEvent('qb-houses:client:RequestRing', src)
end)

-- Item

QBCore.Functions.CreateUseableItem("police_stormram", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
        TriggerClientEvent("qb-houses:client:HomeInvasion", source)
    else
        TriggerClientEvent('QBCore:Notify', source, "This is only possible for emergency services!", "error")
    end
end)

-- Functions

function hasKey(identifier, cid, house)
    if houseowneridentifier[house] and houseownercid[house] then
        if houseowneridentifier[house] == identifier and houseownercid[house] == cid then
            return true
        else
            if housekeyholders[house] then
                for i = 1, #housekeyholders[house], 1 do
                    if housekeyholders[house][i] == cid then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function GetHouseStreetCount(street)
    local count = 1
    local query = '%' .. street .. '%'
    local result = exports.oxmysql:fetchSync('SELECT * FROM houselocations WHERE name LIKE ?', {query})
    if result[1] then
        for i = 1, #result, 1 do
            count = count + 1
        end
    end
    return count
end

local function escape_sqli(source)
    local replacements = {
        ['"'] = '\\"',
        ["'"] = "\\'"
    }
    return source:gsub("['\"]", replacements)
end

-- Events

RegisterNetEvent('qb-houses:server:setHouses', function()
    local src = source
    TriggerClientEvent("qb-houses:client:setHouseConfig", src, Config.Houses)
end)

RegisterNetEvent('qb-houses:server:addNewHouse', function(street, coords, price, tier)
    local src = source
    local street = street:gsub("%'", "")
    local price = tonumber(price)
    local tier = tonumber(tier)
    local houseCount = GetHouseStreetCount(street)
    local name = street:lower() .. tostring(houseCount)
    local label = street .. " " .. tostring(houseCount)
    exports.oxmysql:insert('INSERT INTO houselocations (name, label, coords, owned, price, tier) VALUES (?, ?, ?, ?, ?, ?)',
        {name, label, json.encode(coords), 0, price, tier})
    Config.Houses[name] = {
        coords = coords,
        owned = false,
        price = price,
        locked = true,
        adress = label,
        tier = tier,
        garage = {},
        decorations = {}
    }
    TriggerClientEvent("qb-houses:client:setHouseConfig", -1, Config.Houses)
    TriggerClientEvent('QBCore:Notify', src, "You have added a house: " .. label)
end)

RegisterNetEvent('qb-houses:server:addGarage', function(house, coords)
    local src = source
    exports.oxmysql:execute('UPDATE houselocations SET garage = ? WHERE name = ?', {json.encode(coords), house})
    local garageInfo = {
        label = Config.Houses[house].adress,
        takeVehicle = coords
    }
    TriggerClientEvent("qb-garages:client:addHouseGarage", -1, house, garageInfo)
    TriggerClientEvent('QBCore:Notify', src, "You have added a garage: " .. garageInfo.label)
end)

RegisterNetEvent('qb-houses:server:viewHouse', function(house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    local houseprice = Config.Houses[house].price
    local brokerfee = (houseprice / 100 * 5)
    local bankfee = (houseprice / 100 * 10)
    local taxes = (houseprice / 100 * 6)

    TriggerClientEvent('qb-houses:client:viewHouse', src, houseprice, brokerfee, bankfee, taxes,
        pData.PlayerData.charinfo.firstname, pData.PlayerData.charinfo.lastname)
end)

RegisterNetEvent('qb-houses:server:buyHouse', function(house)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local price = Config.Houses[house].price
    local HousePrice = math.ceil(price * 1.21)
    local bankBalance = pData.PlayerData.money["bank"]

    if (bankBalance >= HousePrice) then
        houseowneridentifier[house] = pData.PlayerData.license
        houseownercid[house] = pData.PlayerData.citizenid
        housekeyholders[house] = {
            [1] = pData.PlayerData.citizenid
        }
        exports.oxmysql:insert('INSERT INTO player_houses (house, identifier, citizenid, keyholders) VALUES (?, ?, ?, ?)',
            {house, pData.PlayerData.license, pData.PlayerData.citizenid, json.encode(housekeyholders[house])})
        exports.oxmysql:execute('UPDATE houselocations SET owned = ? WHERE name = ?', {1, house})
        TriggerClientEvent('qb-houses:client:SetClosestHouse', src)
        pData.Functions.RemoveMoney('bank', HousePrice, "bought-house") -- 21% Extra house costs
        TriggerEvent('qb-bossmenu:server:addAccountMoney', "realestate", (HousePrice / 100) * math.random(18, 25))    
    else
        TriggerClientEvent('QBCore:Notify', source, "You dont have enough money..", "error")
    end
end)

RegisterNetEvent('qb-houses:server:lockHouse', function(bool, house)
    TriggerClientEvent('qb-houses:client:lockHouse', -1, bool, house)
end)

RegisterNetEvent('qb-houses:server:SetRamState', function(bool, house)
    Config.Houses[house].IsRaming = bool
    TriggerClientEvent('qb-houses:server:SetRamState', -1, bool, house)
end)

RegisterNetEvent('qb-houses:server:giveKey', function(house, target)
    local pData = QBCore.Functions.GetPlayer(target)
    table.insert(housekeyholders[house], pData.PlayerData.citizenid)
    exports.oxmysql:execute('UPDATE player_houses SET keyholders = ? WHERE house = ?',
        {json.encode(housekeyholders[house]), house})
end)

RegisterNetEvent('qb-houses:server:removeHouseKey', function(house, citizenData)
    local src = source
    local newHolders = {}
    if housekeyholders[house] then
        for k, v in pairs(housekeyholders[house]) do
            if housekeyholders[house][k] ~= citizenData.citizenid then
                table.insert(newHolders, housekeyholders[house][k])
            end
        end
    end
    housekeyholders[house] = newHolders
    TriggerClientEvent('QBCore:Notify', src, 'Keys Have Been Removed From ' .. citizenData.firstname .. ' ' .. citizenData.lastname, 'error')
    exports.oxmysql:execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
end)

RegisterNetEvent('qb-houses:server:OpenDoor', function(target, house)
    local OtherPlayer = QBCore.Functions.GetPlayer(target)
    if OtherPlayer then
        TriggerClientEvent('qb-houses:client:SpawnInApartment', OtherPlayer.PlayerData.source, house)
    end
end)

RegisterNetEvent('qb-houses:server:RingDoor', function(house)
    local src = source
    TriggerClientEvent('qb-houses:client:RingDoor', -1, src, house)
end)

RegisterNetEvent('qb-houses:server:savedecorations', function(house, decorations)
    exports.oxmysql:execute('UPDATE player_houses SET decorations = ? WHERE house = ?', {json.encode(decorations), house})
    TriggerClientEvent("qb-houses:server:sethousedecorations", -1, house, decorations)
end)

RegisterNetEvent('qb-houses:server:LogoutLocation', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local MyItems = Player.PlayerData.items
    exports.oxmysql:execute('UPDATE players SET inventory = ? WHERE citizenid = ?',
        {json.encode(MyItems), Player.PlayerData.citizenid})
    QBCore.Player.Logout(src)
    TriggerClientEvent('qb-multicharacter:client:chooseChar', src)
end)

RegisterNetEvent('qb-houses:server:giveHouseKey', function(target, house)
    local src = source
    local tPlayer = QBCore.Functions.GetPlayer(target)
    if tPlayer then
        if housekeyholders[house] then
            for _, cid in pairs(housekeyholders[house]) do
                if cid == tPlayer.PlayerData.citizenid then
                    TriggerClientEvent('QBCore:Notify', src, 'This person already has the keys of the house!', 'error', 3500)
                    return
                end
            end
            housekeyholders[house][#housekeyholders[house]+1] = tPlayer.PlayerData.citizenid
            exports.oxmysql:execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
            TriggerClientEvent('qb-houses:client:refreshHouse', tPlayer.PlayerData.source)
            TriggerClientEvent('QBCore:Notify', tPlayer.PlayerData.source,
                'You have the keys of ' .. Config.Houses[house].adress .. ' recieved!', 'success', 2500)
        else
            local sourceTarget = QBCore.Functions.GetPlayer(src)
            housekeyholders[house] = {
                [1] = sourceTarget.PlayerData.citizenid
            }
            housekeyholders[house][#housekeyholders[house]+1] = tPlayer.PlayerData.citizenid
            exports.oxmysql:execute('UPDATE player_houses SET keyholders = ? WHERE house = ?', {json.encode(housekeyholders[house]), house})
            TriggerClientEvent('qb-houses:client:refreshHouse', tPlayer.PlayerData.source)
            TriggerClientEvent('QBCore:Notify', tPlayer.PlayerData.source, 'You have the keys of ' .. Config.Houses[house].adress .. ' recieved!', 'success', 2500)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Something went wrond try again!', 'error', 2500)
    end
end)

RegisterNetEvent('qb-houses:server:setLocation', function(coords, house, type)
    if type == 1 then
        exports.oxmysql:execute('UPDATE player_houses SET stash = ? WHERE house = ?', {json.encode(coords), house})
    elseif type == 2 then
        exports.oxmysql:execute('UPDATE player_houses SET outfit = ? WHERE house = ?', {json.encode(coords), house})
    elseif type == 3 then
        exports.oxmysql:execute('UPDATE player_houses SET logout = ? WHERE house = ?', {json.encode(coords), house})
    end
    TriggerClientEvent('qb-houses:client:refreshLocations', -1, house, json.encode(coords), type)
end)

RegisterNetEvent('qb-houses:server:SetHouseRammed', function(bool, house)
    Config.Houses[house].IsRammed = bool
    TriggerClientEvent('qb-houses:client:SetHouseRammed', -1, bool, house)
end)

RegisterNetEvent('qb-houses:server:SetInsideMeta', function(insideId, bool)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local insideMeta = Player.PlayerData.metadata["inside"]
    if bool then
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = insideId
        Player.Functions.SetMetaData("inside", insideMeta)
    else
        insideMeta.apartment.apartmentType = nil
        insideMeta.apartment.apartmentId = nil
        insideMeta.house = nil
        Player.Functions.SetMetaData("inside", insideMeta)
    end
end)

-- Callbacks

QBCore.Functions.CreateCallback('qb-houses:server:buyFurniture', function(source, cb, price)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local bankBalance = pData.PlayerData.money["bank"]

    if bankBalance >= price then
        pData.Functions.RemoveMoney('bank', price, "bought-furniture")
        cb(true)
    else
        TriggerClientEvent('QBCore:Notify', src, "You dont have enough money..", "error")
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-houses:server:ProximityKO', function(source, cb, house)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local retvalK = false
    local retvalO = false

    if Player then
        local identifier = Player.PlayerData.license
        local CharId = Player.PlayerData.citizenid
        if hasKey(identifier, CharId, house) then
            retvalK = true
        elseif Player.PlayerData.job.name == "realestate" then
            retvalK = true
        else
            retvalK = false
        end
    end

    if houseowneridentifier[house] and houseownercid[house] then
        retvalO = true
    else
        retvalO = false
    end

    cb(retvalK, retvalO)
end)

QBCore.Functions.CreateCallback('qb-houses:server:hasKey', function(source, cb, house)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local retval = false
    if Player then
        local identifier = Player.PlayerData.license
        local CharId = Player.PlayerData.citizenid
        if hasKey(identifier, CharId, house) then
            retval = true
        elseif Player.PlayerData.job.name == "realestate" then
            retval = true
        else
            retval = false
        end
    end

    cb(retval)
end)

QBCore.Functions.CreateCallback('qb-houses:server:isOwned', function(source, cb, house)
    if houseowneridentifier[house] and houseownercid[house] then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-houses:server:getHouseOwner', function(source, cb, house)
    cb(houseownercid[house])
end)

QBCore.Functions.CreateCallback('qb-houses:server:getHouseKeyHolders', function(source, cb, house)
    local retval = {}
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if housekeyholders[house] then
        for i = 1, #housekeyholders[house], 1 do
            if Player.PlayerData.citizenid ~= housekeyholders[house][i] then
                local result = exports.oxmysql:fetchSync('SELECT charinfo FROM players WHERE citizenid = ?',
                    {housekeyholders[house][i]})
                if result[1] then
                    local charinfo = json.decode(result[1].charinfo)
                    table.insert(retval, {
                        firstname = charinfo.firstname,
                        lastname = charinfo.lastname,
                        citizenid = housekeyholders[house][i]
                    })
                end
                cb(retval)
            end
        end
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:TransferCid', function(source, cb, NewCid, house)
    local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE citizenid = ?', {NewCid})
    if result[1] then
        local HouseName = house.name
        housekeyholders[HouseName] = {}
        housekeyholders[HouseName][1] = NewCid
        houseownercid[HouseName] = NewCid
        houseowneridentifier[HouseName] = result[1].license
        exports.oxmysql:execute(
            'UPDATE player_houses SET citizenid = ?, keyholders = ?, identifier = ? WHERE house = ?',
            {NewCid, json.encode(housekeyholders[HouseName]), result[1].license, HouseName})
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-houses:server:getHouseDecorations', function(source, cb, house)
    local retval = nil
    local result = exports.oxmysql:fetchSync('SELECT * FROM player_houses WHERE house = ?', {house})
    if result[1] then
        if result[1].decorations then
            retval = json.decode(result[1].decorations)
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('qb-houses:server:getHouseLocations', function(source, cb, house)
    local retval = nil
    local result = exports.oxmysql:fetchSync('SELECT * FROM player_houses WHERE house = ?', {house})
    if result[1] then
        retval = result[1]
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('qb-houses:server:getHouseKeys', function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
end)

QBCore.Functions.CreateCallback('qb-houses:server:getOwnedHouses', function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    if pData then
        exports.oxmysql:fetch('SELECT * FROM player_houses WHERE identifier = ? AND citizenid = ?', {pData.PlayerData.license, pData.PlayerData.citizenid}, function(houses)
            local ownedHouses = {}
            for i = 1, #houses, 1 do
                ownedHouses[#ownedHouses+1] = houses[i].house
            end
            if houses then
                cb(ownedHouses)
            else
                cb(nil)
            end
        end)
    end
end)

QBCore.Functions.CreateCallback('qb-houses:server:getSavedOutfits', function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    if pData then
        exports.oxmysql:fetch('SELECT * FROM player_outfits WHERE citizenid = ?', {pData.PlayerData.citizenid},
            function(result)
                if result[1] then
                    cb(result)
                else
                    cb(nil)
                end
            end)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetPlayerHouses', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local MyHouses = {}
    local result = exports.oxmysql:fetchSync('SELECT * FROM player_houses WHERE citizenid = ?',
        {Player.PlayerData.citizenid})
    if result and result[1] then
        for k, v in pairs(result) do
            table.insert(MyHouses, {
                name = v.house,
                keyholders = {},
                owner = Player.PlayerData.citizenid,
                price = Config.Houses[v.house].price,
                label = Config.Houses[v.house].adress,
                tier = Config.Houses[v.house].tier,
                garage = Config.Houses[v.house].garage
            })

            if v.keyholders ~= "null" then
                v.keyholders = json.decode(v.keyholders)
                if v.keyholders then
                    for f, data in pairs(v.keyholders) do
                        local keyholderdata = exports.oxmysql:fetchSync('SELECT * FROM players WHERE citizenid = ?',
                            {data})
                        if keyholderdata[1] then
                            keyholderdata[1].charinfo = json.decode(keyholderdata[1].charinfo)

                            local userKeyHolderData = {
                                charinfo = {
                                    firstname = keyholderdata[1].charinfo.firstname,
                                    lastname = keyholderdata[1].charinfo.lastname
                                },
                                citizenid = keyholderdata[1].citizenid,
                                name = keyholderdata[1].name
                            }

                            table.insert(MyHouses[k].keyholders, userKeyHolderData)
                        end
                    end
                else
                    MyHouses[k].keyholders[1] = {
                        charinfo = {
                            firstname = Player.PlayerData.charinfo.firstname,
                            lastname = Player.PlayerData.charinfo.lastname
                        },
                        citizenid = Player.PlayerData.citizenid,
                        name = Player.PlayerData.name
                    }
                end
            else
                MyHouses[k].keyholders[1] = {
                    charinfo = {
                        firstname = Player.PlayerData.charinfo.firstname,
                        lastname = Player.PlayerData.charinfo.lastname
                    },
                    citizenid = Player.PlayerData.citizenid,
                    name = Player.PlayerData.name
                }
            end
        end

        SetTimeout(100, function()
            cb(MyHouses)
        end)
    else
        cb({})
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetHouseKeys', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local MyKeys = {}

    local result = exports.oxmysql:fetchSync('SELECT * FROM player_houses', {})
    for k, v in pairs(result) do
        if v.keyholders ~= "null" then
            v.keyholders = json.decode(v.keyholders)
            for s, p in pairs(v.keyholders) do
                if p == Player.PlayerData.citizenid and (v.citizenid ~= Player.PlayerData.citizenid) then
                    table.insert(MyKeys, {
                        HouseData = Config.Houses[v.house]
                    })
                end
            end
        end

        if v.citizenid == Player.PlayerData.citizenid then
            table.insert(MyKeys, {
                HouseData = Config.Houses[v.house]
            })
        end
    end
    cb(MyKeys)
end)

QBCore.Functions.CreateCallback('qb-phone:server:MeosGetPlayerHouses', function(source, cb, input)
    local src = source
    if input then
        local search = escape_sqli(input)
        local searchData = {}
        local query = '%' .. search .. '%'
        local result = exports.oxmysql:fetchSync('SELECT * FROM players WHERE citizenid = ? OR charinfo LIKE ?',
            {search, query})
        if result[1] then
            local houses = exports.oxmysql:fetchSync('SELECT * FROM player_houses WHERE citizenid = ?',
                {result[1].citizenid})
            if houses[1] then
                for k, v in pairs(houses) do
                    table.insert(searchData, {
                        name = v.house,
                        keyholders = keyholders,
                        owner = v.citizenid,
                        price = Config.Houses[v.house].price,
                        label = Config.Houses[v.house].adress,
                        tier = Config.Houses[v.house].tier,
                        garage = Config.Houses[v.house].garage,
                        charinfo = json.decode(result[1].charinfo),
                        coords = {
                            x = Config.Houses[v.house].coords.enter.x,
                            y = Config.Houses[v.house].coords.enter.y,
                            z = Config.Houses[v.house].coords.enter.z
                        }
                    })
                end
                cb(searchData)
            end
        else
            cb(nil)
        end
    else
        cb(nil)
    end
end)
