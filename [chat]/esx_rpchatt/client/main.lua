--[[

  ESX RP Chat

--]]
ESX = nil
local PlayerData = {}
local group 
local wylacz = false 

kick = 1800
kickostrzezenie = true

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtestaredObjtestect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job

end)

local dzielnica = false

AddEventHandler('esx:onPlayerSpawn', function()
	ESX.TriggerServerCallback('mrp:GetServer', function(name, players)
		if name == 'Tilos' then
			dzielnica = true
		end
	end)
end)

Config = {}

Config.messages = {
    'Dołącz do naszej społeczności: [discord.gg/45ArgMg]',
    'Zapraszamy do urzędu po odbiór paszportu na dzielnicę Skye',
}

if dzielnica then
	CreateThread(function()
		while true do
			for a = 1, #Config.messages do
				TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(196, 124, 0, 0.4); border-radius: 3px;"><i class="fas fa-bullhorn"></i>&nbsp; {0}: <br>{1}</div>',
					args = { 'Urząd Miasta', Config.messages[a] }
				})
				Citizen.Wait(15 * 60000)
			end
			Citizen.Wait(0)
		end
	end)
end


CreateThread(function()
	while true do
		Citizen.Wait(1000)
		gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
		if gracz then
			pozycja = GetEntityCoords(gracz, true)
			local bw = exports['esx_ambulancejob']:isDead()
			local isJailed = exports['esx_jailer']:getJailStatus()
			if pozycja == starapozycja and not bw and not isJailed then
				if time > 0 then
					if kickostrzezenie and time == math.ceil(kick / 30) then
						TriggerEvent("chatMessage", "UWAGA", {255, 0, 0}, "^1 Zostaniesz wyrzucony za " .. time .. " sekund za nieaktywność!")
					end
					time = time - 1
				else
					TriggerServerEvent("wyjebzaafk")
				end
			else
				time = kick
			end
			starapozycja = pozycja
		end
	end
end)

function ShowAdvancedNotification(title, subject, msg, icon, iconType)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	SetNotificationMessage(icon, icon, false, iconType, title, subject)
	DrawNotification(false, false)
end

local zasieg = 0.5

RegisterNetEvent('goldengate:zasiegVoice')
AddEventHandler('goldengate:zasiegVoice', function(prox)
    zasieg = tonumber(prox) + 0.0
end)

RegisterNetEvent('esx_rpchat:reloadNames')
AddEventHandler('esx_rpchat:reloadNames', function()
	TriggerServerEvent('goldengate_chat:updateName')
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

RegisterCommand("wylacz", function(source)
    if wylacz == false then
		wylacz = true
	else 
		wylacz = false 
	end	
end)

TeleportToWaypoint = function()
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end

                ESX.ShowNotification("Teleported.")
            else
                ESX.ShowNotification("Please place your waypoint.")
            end
        else
            ESX.ShowNotification("You do not have rights to do this.")
        end
    end)
end

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(name, id, message)
    local pid = GetPlayerFromServerId(id)
    local myId = PlayerId()
	
    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = "💬 <span style='font-weight: bold; color: rgb(128, 128, 128);'>{0}</span> [{1}]: {2}",
			args = { name, id, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.99 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
			TriggerEvent('chat:addMessage', {
				template = "💬 <span style='font-weight: bold; color: rgb(128, 128, 128);'>{0}</span> [{1}]: {2}",
				args = { name, id, message }
			})
		end
    end
end)

RegisterNetEvent('sendProximityMessageDarkWeb')
AddEventHandler('sendProximityMessageDarkWeb', function(message)
	if wylacz == false then 
		if PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'offpolice' or PlayerData.job.name == 'offsheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance')then

		else
			ESX.TriggerServerCallback('esx_rpchatt:getitemy', function (telefon)
				if telefon >= 1 then
					TriggerEvent('chat:addMessage', {
						template = "💻 <span style='font-weight: bold; color: rgb(132, 13, 37);'>{0}</span>: {1}",
						args = { 'Anonim', ' '..message }
					})
				end
			end)
		end
	end	
end)

RegisterNetEvent('sendProximityMessageTweet')
AddEventHandler('sendProximityMessageTweet', function(imienazwisko, message)
	ESX.TriggerServerCallback('esx_rpchatt:getitemy', function (telefon)
		if wylacz == false then
			if telefon >= 1 then
				TriggerEvent('chat:addMessage', {
					template = "🕊️ <span style='font-weight: bold; color: rgb(0, 153, 204);'>@{0}</span>: {1}",
					args = { imienazwisko, message }
				})
			end
		end	
	end)
end)

RegisterNetEvent('sendProximityMessageOgloszenie')
AddEventHandler('sendProximityMessageOgloszenie', function(fal, msg)
	ESX.TriggerServerCallback('esx_rpchatt:getitemy', function (telefon)
		if wylacz == false then
			if telefon >= 1 then
				TriggerEvent('chat:addMessage', {
					template = "📰 <span style='font-weight: bold; color: rgb(0, 179, 0);'>{0}</span>: {1}",
					args = { fal, msg }
				})
			end
		end	
	end)
end)

RegisterCommand('twt', function(source, args, user)	
	if exports['gcphone']:getMenuIsOpen() then
		TriggerServerEvent("sendProximityMessageTweetServer", table.concat(args, " "))
	else
		ESX.ShowNotification('Musisz wyciągnąć telefon żeby napisać wiadomość')
	end
end, false)

RegisterCommand('darkweb', function(source, args, user)	
	if exports['gcphone']:getMenuIsOpen() then
		TriggerServerEvent("sendProximityMessageDarkWebServer", table.concat(args, " "))
	else
		ESX.ShowNotification('Musisz wyciągnąć telefon żeby napisać wiadomość')
	end
end, false)

RegisterCommand('kordy', function(source, args, user)	
	ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "superadmin" then
			coordy = GetEntityCoords(PlayerPedId(-1))
			TriggerServerEvent('esx_rpchatt:sendcoords', coordy)
        else
			ESX.ShowNotification("Nie masz uprawnień!")
        end
    end)
end, false)

local font = 4 
local time = 6000 
local nbrDisplaying = 1

RegisterNetEvent('esx_rpchat:triggerDisplay')
AddEventHandler('esx_rpchat:triggerDisplay', function(text, source, color)
	local player = GetPlayerFromServerId(source)
    if player ~= -1 then
		local offset = 0 + (nbrDisplaying*0.14)
		Display(GetPlayerFromServerId(source), text, offset, color)
	end
end)

function Display(mePlayer, text, offset, color)
    local displaying = true
    CreateThread(function()
        Wait(time)
        displaying = false
    end)
    CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = GetDistanceBetweenCoords(coordsMe['x'], coordsMe['y'], coordsMe['z'], coords['x'], coords['y'], coords['z'], true)
            if dist < 50 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+ 0.75 +offset, text, color)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text, color)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*1.7
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextCentre(true)


        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
		DrawRect(_x+0.0011, _y+scale/50, width*1.1, height*1.2, color.r, color.g, color.b, 100)
    end
end

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    
    
    if pid == myId then
        TriggerEvent('chat:addMessage', {
			template = "<span style='font-weight: bold; color: rgb(0, 227, 243);'>Obywatel[{0}]</span>: {1}",
            args = { name, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.99 then
	    if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
        TriggerEvent('chat:addMessage', {
            template = "<span style='font-weight: bold; color: rgb(0, 227, 243);'>Obywatel[{0}]</span>: {1}",
            args = { name, message }
        })
		end
    end
end)

RegisterNetEvent('sendProximityMessageZ')
AddEventHandler('sendProximityMessageZ', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    
    
    if pid == myId then
        TriggerEvent('chat:addMessage', {
			template = "<span style='font-weight: bold; color: rgb(0, 0, 0);'>Obywatel[{0}]</span>: {1}",
            args = { name, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.99 then
	    if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
        TriggerEvent('chat:addMessage', {
            template = "<span style='font-weight: bold; color: rgb(0, 0, 0);'>Obywatel[{0}]</span>: {1}",
            args = { name, message }
        })
		end
    end
end)

RegisterNetEvent('sendProximityMessageTweet')
AddEventHandler('sendProximityMessageTweet', function(id, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
	local name = ""
    if pid == myId then
        TriggerEvent('chat:addMessage', {
		template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(28, 160, 242, 0.9); border-radius: 3px;"><i class="fab fa-twitter"></i>&nbsp;{0} {1}</div>',
		args = { name, message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageRSE')
AddEventHandler('sendProximityMessageRSE', function(id)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
	local name = " PompaRP Rockstar Editor"
	local nagraj = '[/nagrajklip] - Rozpoczyna nagrywanie'
	local anuluj = '[/anulujklip] - Anuluje nagrywanie'
	local zapisz = '[/zapiszklip] - Zapisuje nagranie - klip musi mieć conajmniej 3 sekundy'
	local editor = '[/rseditor] - Rozłącza z serwerem i przenosi do Rockstar Editora'
    if pid == myId then
        TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; color: rgba(80, 124, 58, 0.9); border-radius: 3px;"><i class="fas fa-video"></i>{0}<br>{1}<br>{2}<br>{3}<br>{4}</div>',
					args = { name, nagraj, anuluj, zapisz, editor }
        })
    end
end)


RegisterNetEvent('sendProximityMessagePrzebieg')
AddEventHandler('sendProximityMessagePrzebieg', function(id, przebieg, opissilnika, opisturbo, opishamulce, opisskrzynia, opiszawieszenie)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
		local name = ""
    if pid == myId then
        TriggerEvent('chat:addMessage', {
					template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; color: rgba(232, 87, 9, 0.9); border-radius: 3px;"><i class="fas fa-car"></i>{0} {1}<br>{2}<br>{3}<br>{4}<br>{5}<br>{6}</div>',
					args = { name, przebieg, opissilnika, opisturbo, opishamulce, opisskrzynia, opiszawieszenie }
        })
    end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    

    if pid == myId then
        TriggerEvent('chat:addMessage', {
			template = "<span style='font-weight: bold; color: rgb(18, 105, 202);'>Obywatel[{0}]</span>: {1}",
            args = { name, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.99 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
        TriggerEvent('chat:addMessage', {
			template = "<span style='font-weight: bold; color: rgb(18, 105, 202);'>Obywatel[{0}]</span>: {1}",
            args = { name, message }
        })
		end
    end
end)

RegisterNetEvent('sendProximityMessageCzy')
AddEventHandler('sendProximityMessageCzy', function(id, name, message, czy)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
	local color = {r = 164, g = 30, b = 191, alpha = 255}
   
	if czy == 1 then
      if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = "✔️ <span style='font-weight: bold; color: #4CAF50;'>{0}</span>: {1}",
			args = { name, '(^2z powodzeniem^7) '..message }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.99 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
			TriggerEvent('chat:addMessage', {
				template = "✔️ <span style='font-weight: bold; color: #4CAF50;'>{0}</span>: {1}",
				args = { name, '(^2z powodzeniem^7) '..message }
			})
		end
      end
	elseif czy == 2 then
	  if pid == myId then
        TriggerEvent('chat:addMessage', {
			template = "❌ <span style='font-weight: bold; color: #F44336;'>{0}</span>: {1}",							
            args = { name, '(^1z niepowodzeniem^7) '..message }
        })
      elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.99 then
		if Citizen.InvokeNative(0xB8DFD30D6973E135, pid) then
			TriggerEvent('chat:addMessage', {
				template = "❌ <span style='font-weight: bold; color: #F44336;'>{0}</span>: {1}",
				args = { name, '(z niepowodzeniem) '..message }
			})
		end
      end
	end
	
end)

RegisterNetEvent('sendProximityMessagePhone')
AddEventHandler('sendProximityMessagePhone', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

	if pid ~= -1 then
		if pid == myId then
			TriggerEvent('chat:addMessage', {
				template = "🔖 <span style='font-weight: bold; color: #42A5F5;'>{0}</span>: {1}",
				args = { name, message }
			})
		elseif GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) <= 19.99 then
			TriggerEvent('chat:addMessage', {
				template = "🔖 <span style='font-weight: bold; color: #42A5F5;'>{0}</span>: {1}",
				args = { name, message }
			})
		end
	end
end)

RegisterNetEvent('sendProximityMessageDbCarsDzwonek')
AddEventHandler('sendProximityMessageDbCarsDzwonek', function(message)
    if PlayerData.job ~= nil and PlayerData.job.name == 'db' then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(140, 14, 8, 1.0); border-radius: 3px;"><i class="fas fa-concierge-bell"></i>&nbsp;[{0}] {1}</div>',
            args = { 'DB Cars', message }
        })
    end
end)

RegisterNetEvent('sendProximityMessagePoliceDzwonek')
AddEventHandler('sendProximityMessagePoliceDzwonek', function(message)
    if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' or PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(140, 14, 8, 1.0); border-radius: 3px;"><i class="fas fa-concierge-bell"></i>&nbsp;[{0}] {1}</div>',
            args = { 'KOMISARIAT', message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageSilowniaDzwonek')
AddEventHandler('sendProximityMessageSilowniaDzwonek', function(message)
    if PlayerData.job ~= nil and PlayerData.job.name == 'silownia' then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(140, 14, 8, 1.0); border-radius: 3px;"><i class="fas fa-concierge-bell"></i>&nbsp;[{0}] {1}</div>',
            args = { 'SILOWNIA', message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageEMSDzwonek')
AddEventHandler('sendProximityMessageEMSDzwonek', function(message)
    if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(140, 14, 8, 1.0); border-radius: 3px;"><i class="fas fa-concierge-bell"></i>&nbsp;[{0}] {1}</div>',
            args = { 'SZPITAL', message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageWEAZELDzwonek')
AddEventHandler('sendProximityMessageWEAZELDzwonek', function(message)
    if PlayerData.job ~= nil and PlayerData.job.name == 'weazel' then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(255, 204, 204, 1.0); border-radius: 3px;"><i class="fas fa-concierge-bell"></i>&nbsp;[{0}] {1}</div>',
            args = { 'WEAZEL', message }
        })
    end
end)

RegisterNetEvent('sendProximityMessageAVOCATDzwonek')
AddEventHandler('sendProximityMessageAVOCATDzwonek', function(message)
    if PlayerData.job ~= nil and PlayerData.job.name == 'avocat' then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.4vw; margin: 0.5vw; font-size: 15px; background-color: rgba(255, 204, 204, 1.0); border-radius: 3px;"><i class="fas fa-concierge-bell"></i>&nbsp;[{0}] {1}</div>',
            args = { 'AVOCAT', message }
        })
    end
end)

RegisterNetEvent('esx_rpchat:25usd')
AddEventHandler('esx_rpchat:25usd', function()
	TriggerEvent("pNotify:SendNotification", {text "Zapłaciłeś/aś $25 za wysłanie Tweeta"})
end)

local zawiadamia = false
local zawiadamia2 = false

CreateThread(function()
    while true do
        Citizen.Wait(7)
        local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
        local PozycjaGracza = GetEntityCoords(Gracz)
        local Dystans = GetDistanceBetweenCoords(PozycjaGracza, 441.27, -981.92, 30.68, true)
        if Dystans <= 6 then
			DrawMarker(27, 441.27, -981.92, 29.78, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 0, 158, 189, 100, false, true, 2, false, false, false, false)     
			
            if Dystans <= 1.5 and zawiadamia == false then
				ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby ~y~wysłać ~s~powiadomienie do służb')
				if IsControlJustPressed(0, 38) then
					TriggerEvent('pNotify:SendNotification', {text = 'Wysłano zawiadomienie!'})
					TriggerEvent('pNotify:SendNotification', {text = 'Następny raz będziesz mógł/mogła użyć dzwonka za dwie minuty.'})
					zawiadamia = true
					TriggerServerEvent('goldengate:dzwonekPolicyjny', 'ls')
					Citizen.Wait(120 * 1000)
					zawiadamia = false
				end
            end
        end
    end
end)

Config.dzwonki = {
	PoliceLosSantos = {
		Pos = {x = 0, y = 0, z = 0},
		Job  = 'goldengate:dzwonekPolicyjny',
		Job2 = 'ls'		
	},
	PoliceVespucci = {
		Pos = {x = -1099.02, y = -840.88, z = 18.05},
		Job  = 'goldengate:dzwonekPolicyjny',
		Job2 = 'glowna'		
	},
	PoliceSandy  = {
		Pos = {x = 1853.21, y = 3687.82, z = 33.3},
		Job  = 'goldengate:dzwonekPolicyjny',
		Job2 = 'sandy'		
	},
	PolicePaleto = {
		Pos = {x = -448.03, y = 6013.37, z = 30.72},
		Job  = 'goldengate:dzwonekPolicyjny',
		Job2 = 'paleto'		
	},	
	PoliceLaMesa = {
		Pos = {x = 834.92224121094, y = -1288.5969238281, z = 27.242113113403},
		Job  = 'goldengate:dzwonekPolicyjny',
		Job2 = 'lamesa'		
	},
	EmsGlowny = {
		Pos = {x = 314.08966064453, y = -587.18890380859, z = 42.261253356934},
		Job  = 'goldengate:dzwonekEMS',
		Job2 = 'glowny'		
	},
	EmsHanys  = { 
		Pos = {x = -436.32998657227, y = -325.75286865234, z = 33.910774230957},
		Job  = 'goldengate:dzwonekEMS',
		Job2 = 'hanys'	
	},
	EmsSandy  = {
		Pos = {x = 1831.32, y = 3675.48, z = 33.32},
		Job  = 'goldengate:dzwonekEMS',
		Job2 = 'sandy'	
	},
	EmsPaleto = {
		Pos = {x = -254.6699, y = 6329.6362, z = 31.48},
		Job  = 'goldengate:dzwonekEMS',
		Job2 = 'paleto'
	},
	--[[Silownia = {
		Pos = {x = -34.576, y = -1666.6339, z = 28.5373},
		Job  = 'goldengate:dzwonekDycha',
		Job2 = 'silownia'	
	},]]
	Kancelaria = {
		Pos = {x = -71.56, y = -816.34, z = 242.43},
		Job  = 'goldengate:dzwonekWEAZEL',
		Job2 = 'kancelaria'
	},
	dbcars = {
		Pos = {x = 113.08670806885, y = -141.35105895996, z = 54.0262678527832},
		Job  = 'goldengate:dzwonekDbCars',
		Job2 = 'dbcars'
	}
}

CreateThread(function()
	while true do
		Citizen.Wait(7)
        local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
        local PozycjaGracza = GetEntityCoords(Gracz)
		for k,v in pairs(Config.dzwonki) do
			if #(vec3(v.Pos.x, v.Pos.y, v.Pos.z) - PozycjaGracza) < 6 then
				DrawMarker(27, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 0, 158, 189, 100, false, true, 2, false, false, false, false)
				if #(vec3(v.Pos.x, v.Pos.y, v.Pos.z) - PozycjaGracza) < 1.5 then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby ~y~wysłać ~s~powiadomienie do służb')
					ESX.ShowFloatingHelpNotification('~b~ DZWONEK', vec3(v.Pos.x, v.Pos.y, v.Pos.z + 1))
					if IsControlJustPressed(0, 38) then
						if zawiadamia2 == false then
							TriggerEvent('pNotify:SendNotification', {text = 'Wysłano zawiadomienie!'})
							TriggerServerEvent(v.Job, v.Job2)	
							zawiadamia2 = true
						else
							ESX.ShowNotification('Dopiero za 2 minuty możesz zadzwonić dzwonkiem')
						end
					end
				end
			end
		end
	end
end)

local openchatspam = false

CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if exports['chat']:checkchat() then
			if not openchatspam then
				TriggerServerEvent('esx_rpchatt:openchat')
				openchatspam = true
			end
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if openchatspam then
			Wait(5100)
			openchatspam = false
		end
	end
end)
		
CreateThread(function()
	while true do
		Citizen.Wait(1)
		if zawiadamia2 then
			Citizen.Wait(120 * 1000)
			zawiadamia2 = false
		end	
	end
end)


--Licytacja

RegisterNetEvent('esx_rpchatt:pobieraniemodelu')
AddEventHandler('esx_rpchatt:pobieraniemodelu', function(dane)
	local model = (type(dane[1]) == 'number' and dane[1] or GetHashKey(dane[1]))
	if IsModelInCdimage(model) then
		local playerPed = PlayerPedId()
		local playerCoords, playerHeading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)
		ESX.Game.SpawnVehicle(model, playerCoords, playerHeading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

			local VehType = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
			SetVehicleNumberPlateText(vehicle, tostring(dane[2][1]..' '..dane[2][2]))
			
			Citizen.Wait(500)
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			TriggerServerEvent('esx_rpchatt:dodajpojazd', vehicleProps, tostring(dane[2][1]..' '..dane[2][2]), dane[3], dane[4], VehType)
		end)
	else
		ESX.ShowNotification('Nie znaleziono modelu')
	end
end)

--Setplate

RegisterNetEvent('esx_rpchatt:setplate_client')
AddEventHandler('esx_rpchatt:setplate_client', function(plate, osoba)
	local playerPed = PlayerPedId()
	local coords  = GetEntityCoords(playerPed)
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords, 8.0, 0, 70)
		end
		
		local newPlate     = plate
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local tablice = GetVehicleNumberPlateText(vehicle)
		SetVehicleNumberPlateText(vehicle, newPlate)
		
		TriggerServerEvent('esx_rpchatt:setplate_server', tablice, newPlate, osoba)
end)