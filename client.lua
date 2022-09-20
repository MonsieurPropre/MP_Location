ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	for i = 1, #Config.Locations, 1 do
		if Config.Locations[i].ped ~= nil then
			RequestModel("a_m_m_bevhills_02")
			local pedHash = GetHashKey("a_m_m_bevhills_02")
			local ped = CreatePed(7, pedHash, Config.Locations[i].ped.coords, Config.Locations[i].ped.heading, false, false)
			SetEntityInvincible(ped, true)
			SetBlockingOfNonTemporaryEvents(ped, true)
			FreezeEntityPosition(ped, true)
		end
	end
end)

if Config.Marker then
	Citizen.CreateThread(function()
		local coords = Config.SpawnVeh
		local headingveh = Config.headingveh
		while true do
			Citizen.Wait(3)

			for i = 1, #Config.Locations, 1 do
				local distance = #(GetEntityCoords(PlayerPedId(), false) - Config.Locations[i].coords)

				if distance < Config.DrawDistance then
					DrawMarker(Config.Locations[i].type, Config.Locations[i].coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Locations[i].size, Config.Locations[i].color.r, Config.Locations[i].color.g, Config.Locations[i].color.b, 100, false, true, 2, false, false, false, false)

					if distance < 1.95 then
						ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour louer un véhicule')

						if IsControlJustReleased(0, 38) then
							print(coords)
							OpenVehicleMenu(coords, headingveh)
						end
					end
				end
			end
		end
	end)
else
	Citizen.CreateThread(function()
		local coords = Config.SpawnVeh
		while true do
			Citizen.Wait(1)
	
			for i = 1, #Config.Locations, 1 do
				local distance = #(GetEntityCoords(PlayerPedId(), false) - Config.Locations[i].coords)

				if distance < 1.95 then
					ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour louer un véhicule')

					if IsControlJustReleased(0, 38) then
						OpenVehicleMenu(coords)
					end
				end
			end
		end
	end)
end


Citizen.CreateThread(function()
	for i = 1, #Config.Blips, 1 do
		local blip = AddBlipForCoord(Config.Blips[i])

		SetBlipSprite(blip, 171)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Location de véhicule')
		EndTextCommandSetBlipName(blip)
	end
end)

function spawnveh(veh, coords, heading)
    local model = veh
    local modelHash = GetHashKey(model)

    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end

    local vehicle = CreateVehicle(modelHash, coords, heading, false, false)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    local newPlate = exports['esx_vehicleshop']:GenerateSocietyPlate('LOCA')
	SetVehicleNumberPlateText(vehicle, newPlate)
	TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate)
	--SetVehicleMaxMods(vehicle)
    ESX.ShowNotification('Le véhicule est prêt !')
end


function buyveh(value, price, coordsspawnveh, heading)
	ESX.TriggerServerCallback("MP:buyveh", function(cb)
		if cb then
			spawnveh(value, coordsspawnveh, heading)
		end
	end, price)
end
	

function OpenVehicleMenu(coordsspawnveh, heading)
	print(coordsspawnveh)
	local elements = {
        {label = ('Voiture'), value = 'voiture'},
        {label = ('Moto'), value = 'moto'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions', {
			title    = 'Location de véhicule',
			align    = 'center',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'voiture' then	
				ESX.UI.Menu.CloseAll()
                OpenVoitureMenu(coordsspawnveh, heading)
			end
			if data.current.value == 'moto' then
                ESX.UI.Menu.CloseAll()
                OpenMotoMenu(coordsspawnveh, heading)
			end

		end, function(data, menu)
			menu.close()
		end)
end

function OpenVoitureMenu(coordsspawnveh, heading)

	local elements = Config.locaveh

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions', {
			title    = 'Voiture',
			align    = 'center',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= nil then
                buyveh(data.current.value, data.current.price, coordsspawnveh, heading)
                ESX.UI.Menu.CloseAll()
			end

		end, function(data, menu)
			menu.close()
	end)
end

function OpenMotoMenu(coordsspawnveh)

	local elements = Config.locamoto

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions', {
			title    = 'Moto',
			align    = 'center',
			elements = elements
		}, function(data, menu)

			if data.current.value ~= nil then
                buyveh(data.current.value, data.current.price, coordsspawnveh, heading)
                ESX.UI.Menu.CloseAll()
			end

		end, function(data, menu)
			menu.close()
	end)
end
