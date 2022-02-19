ESX              = nil
local PlayerData = {}
local display = false
local HasAlreadyGotMessage = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	end

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)



RegisterCommand("newplate", function(source, args)
    SetDisplay(not display)
end)

--very important cb 
RegisterNUICallback("exit", function(data)
    chat("exited", {0,255,0})
    SetDisplay(false)
end)



-- this cb is used as the main route to transfer data back 
-- and also where we hanld the data sent from js
RegisterNUICallback("main", function(data)
    
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	local yourjob = ESX.PlayerData.job.name

	-- check if you are in a vehicle
	if vehicle == 0 then	
		TriggerEvent('chat:addMessage', 'You are not in a vehicle.')
		HasAlreadyGotMessage = true
	else

	-- check your job only police sheriff and highway patrol can change plate	
 	if yourjob == "police" or yourjob == "sheriff" or yourjob == "highwaypatrol" then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), true )
			platetext = data.text
			SetVehicleNumberPlateText(vehicle, platetext)
	       	TriggerEvent('chat:addMessage', 'You changed your plate to ' .. data.text, {0,255,0})
	else
	-- if you are not in the special club	
	TriggerEvent('chat:addMessage', 'You are a mere mortal. You cannot use this command', {255,0,0})
		end
	end	



    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    chat(data.error, {255,0,0})
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end
