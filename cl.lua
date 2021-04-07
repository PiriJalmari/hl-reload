local aika = 2000
local lataus = false
local x = 0.001
local xw = 0.4
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(o) ESX = o end)
	end
end)

function Timeri()
	Citizen.CreateThread(function()
		while x < 0.2 do
			Citizen.Wait(aika / 180)
			x = x + 0.002
			xw = xw + 0.00100
		end
		lataus = true
	end)
end

function LatausJaProgressBar(ase)
	lataus = false
	x = 0.001
	xw = 0.4
	Timeri()
	--ClearPedTasks(GetPlayerPed(-1))
	SetPedCanSwitchWeapon(GetPlayerPed(-1), false)
	SetPedCanRagdoll(GetPlayerPed(-1), false)
	SetPlayerSprint(GetPlayerPed(-1), false)
	SetEntityMaxSpeed(GetPlayerPed(-1), 4.0)
	while not lataus do
		Citizen.Wait(0)
		--NÄÄ VITTUU
		DisableControlAction(0, 21, true)
		DisableControlAction(0, 45, true)
		DisableControlAction(0, 24, true)
		DisableControlAction(0, 289, true)
		DisableControlAction(0, 69, true)
		DisableControlAction(0, 92, true)
		DisableControlAction(0, 257, true)
		DisableControlAction(0, 25, true)
		--DisableControlAction(0, 37, true)
		--TEKSTI--
		SetTextColour(255,255,255,255)
		SetTextFont(4)
		SetTextScale(0.08, 0.8)
		SetTextDropShadow(2, 2, 0, 0, 0)
		SetTextEntry("STRING")
		AddTextComponentString("Ladataan asetta")
		DrawText(0.448, 0.9)
		
		DrawRect(xw, 0.925, x, 0.05, 26, 166, 93, 200) --BAR
		DrawRect(0.5, 0.95, 0.2, 0.002, 0, 0, 0, 255) --ALA
		DrawRect(0.5, 0.90, 0.2, 0.002, 0, 0, 0, 255) --YLÄ
		DrawRect(0.4, 0.925, 0.001, 0.05, 0, 0, 0, 255) --VASEN
		DrawRect(0.6, 0.925, 0.001, 0.05, 0, 0, 0, 255) --OIKEE
	end
	local lipasmax = GetMaxAmmoInClip(GetPlayerPed(-1), ase, 1)
	TaskReloadWeapon(GetPlayerPed(-1), 0)
	SetAmmoInClip(GetPlayerPed(-1), ase, lipasmax)
	SetEntityMaxSpeed(GetPlayerPed(-1), 10.0)
	SetPedCanSwitchWeapon(GetPlayerPed(-1), true)
	SetPedCanRagdoll(GetPlayerPed(-1), true)
end

Citizen.CreateThread(function()
	--SetPedConfigFlag(GetPlayerPed(-1), 331, false) IHAN TURHA
	while true do
		Citizen.Wait(1)
		if IsPedArmed(GetPlayerPed(-1), 4) and ESX ~= nil then
			local ase = GetSelectedPedWeapon(GetPlayerPed(-1))
			local luodit = GetAmmoInPedWeapon(GetPlayerPed(-1), ase)
			local bool, lippaanluodit = GetAmmoInClip(GetPlayerPed(-1), ase)
			local lippaanmaxit = GetMaxAmmoInClip(GetPlayerPed(-1), ase, 1)
			local aseenluodit = luodit - lippaanluodit
			if aseenluodit > 0 then
				SetPedAmmo(GetPlayerPed(-1), ase, 0)
				Citizen.Wait(10)
				SetAmmoInClip(GetPlayerPed(-1), ase, lippaanmaxit)
			end
			if lippaanluodit == 0 then
				if IsControlPressed(0, 24) then
					ClearPedTasks(GetPlayerPed(-1))
				end
			end
			if lippaanluodit < lippaanmaxit then
				if IsControlJustReleased(0, 45) then
					ESX.TriggerServerCallback('reload:kaytaLipas', function(state)
						if state then
							LatausJaProgressBar(ase)
						else
							if not Guns[ase] then
								ESX.ShowNotification('Sinulla ei ole ~r~lippaita~w~ enempää')
							else
								ESX.ShowNotification('Sinulla ei ole ~r~luoteja~w~ enempää')
							end
						end
					end, ase)
					Citizen.Wait(400)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)
