TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('MP:buyveh', function(source, cb, prix)

    local _source = source

    local xPlayer = ESX.GetPlayerFromId(source)

    local namecash = Config.Money

    if xPlayer.getAccount(namecash).money >= tonumber(prix) then

        xPlayer.removeAccountMoney(namecash, tonumber(prix))
        cb(true)

    else
        ESX.showNotification("Vous n'avez pas assez d'argent pour acheté ce véhicule !")
        cb(false)
    end
end)

