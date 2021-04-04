ESX = nil

TriggerEvent('arp:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('reload:kaytaLipas', function(source, cb, ase)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not Guns[ase] then
        local c = xPlayer.getInventoryItem('clip').count
        if c >= 1 then
            xPlayer.removeInventoryItem('clip', 1)
            cb(true)
        else
            cb(false)
        end
    else
        local c = xPlayer.getInventoryItem('luoti').count
        if c >= 1 then
            xPlayer.removeInventoryItem('luoti', 1)
            cb(true)
        else
            cb(false)
        end
    end
end)