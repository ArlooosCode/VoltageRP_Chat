--[[

  ESX RP Chat

--]]
ESX = nil

TriggerEvent('esx:getShtestaredObjtestect', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_rpchatt:getitemy', function(source, cb)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local telefon = xPlayer.getInventoryItem('phone').count
		cb(telefon)
	end
end)

ESX.PlayerData = xPlayer

local danePostaci = {}

RegisterServerEvent("wyjebzaafk")
AddEventHandler("wyjebzaafk", function()
	DropPlayer(source, "VRP: Byłeś zbyt długo nieaktywny")
end)

TriggerEvent('es:addGroupCommand', 'reloadchatnames', 'admin', function(source, args, user)
	TriggerClientEvent('esx_rpchat:reloadNames', -1)
end, function(source, args, user)
end)

RegisterServerEvent("esx_rpchatt:openchat")
AddEventHandler("esx_rpchatt:openchat", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	color = {r = 255, g = 255, b = 204, alpha = 255}
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, "...", source, color)
end)

function sendToDiscordCoords (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	if message == nil or message == '' then return FALSE end	
	PerformHttpRequest('https://discord.com/api/webhooks/800076220569223169/CveeRECWItzi8JBAYnjpV6r-5JwMoRjeL9WFk23SW0V5x-12rjmJ20gotqggn_fzPqci', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("esx_rpchatt:sendcoords")
AddEventHandler("esx_rpchatt:sendcoords", function(coordy)
	x, y, z = table.unpack(coordy)
	sendToDiscordCoords('Kordy', x..', '..y..', '..z, 8421504)
	Wait(100)
	sendToDiscordCoords('Kordy', 'x = '..x..', y = '..y..', z = '..z, 8421504)
end)
--Licytacja komenda

RegisterCommand('licytacja', function(source, id, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.group == ('superadmin') then
		if id[1]== nil then
			TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś ID gracza"})
			return
		elseif GetPlayerPing(id[1])== 0 then
			TriggerClientEvent("pNotify:SendNotification", source, {text = "Niema nikogo o takim ID"})
			return
		elseif id[2] == nil then
			TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś modelu pojazdu"})
			return
		elseif id[3] == nil then
			TriggerClientEvent("pNotify:SendNotification", source, {text = "Nie podałeś ceny pojazdu"})
			return
		elseif id[4] == nil then
			TriggerClientEvent("pNotify:SendNotification", source, {text = "[0-4] Nie podałeś tablic pojazdu"})
			return
		elseif id[5] == nil then
			TriggerClientEvent("pNotify:SendNotification", source, {text = "[4-8] Nie podałeś tablic pojazdu"})
			return
		end
		local xPlayer = ESX.GetPlayerFromId(id[1])
		local osoba = id[1]
		local vehicle = id[2]
		local kasa = tonumber(id[3])
		local tablice = id[4]..''..id[5]
		
		if string.len(tostring(id[4]..' '..id[5])) < 7 then
			xPlayer.showNotification('Tablice posiadają poniżej 7 znaków')
			return
		elseif string.len(tostring(id[4]..' '..id[5])) > 8 then
			xPlayer.showNotification('Tablica posiada powyzej 7 znaków')
		end
		
		TriggerClientEvent('esx_rpchatt:pobieraniemodelu', source, {vehicle, {id[4], id[5]}, osoba, kasa})
	else
		xPlayer.showNotification('Nie posiadasz permisji')
	end
end, false)

RegisterNetEvent('esx_rpchatt:dodajpojazd')
AddEventHandler('esx_rpchatt:dodajpojazd', function(vehicle, newPlate, id, kasa, model)
	local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(id)
	local charid = MySQL.Sync.fetchAll('SELECT charid FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
	})
	
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, charid, plate, vehicle, state, modelname) VALUES (@owner, @charid, @plate, @vehicle, @state, @modelname)',
	{
		['@owner']   = xPlayer.identifier,
		['@charid'] = charid[1].charid,
		['@plate']   = newPlate,
		['@vehicle'] = json.encode(vehicle),
		['@state'] = 1,		
		['@modelname'] = model
	}, function (rowsChanged)

	end)
	
	TriggerClientEvent("pNotify:SendNotification", _source, {text = 'Dodano pojazd dla ID: ' .. id .. '<br>Model: ' .. model ..'<br>Cena pojazdu: '.. kasa ..'<br>Tablice: '.. newPlate})
	
	xPlayer.removeAccountMoney('bank', kasa)
	
end)

RegisterNetEvent('goldengate_chat:updateName') 
AddEventHandler('goldengate_chat:updateName', function()
  getIdentityToArray(source)
end)

RegisterNetEvent('goldengate:dzwonekPolicyjny')
AddEventHandler('goldengate:dzwonekPolicyjny', function(status)
	if status == 'ls' then
		TriggerClientEvent("sendProximityMessagePoliceDzwonek", -1, 'Ktoś oczekuje szeryfa na komendzie LS!')
	elseif status == 'glowna' then
		TriggerClientEvent("sendProximityMessagePoliceDzwonek", -1, 'Ktoś oczekuje szeryfa na komendzie głównej Vespucci!')
	elseif status == 'sandy' then
		TriggerClientEvent("sendProximityMessagePoliceDzwonek", -1, 'Ktoś oczekuje szeryfa na komendzie Sandy Shores!')
	elseif status == 'paleto' then
		TriggerClientEvent("sendProximityMessagePoliceDzwonek", -1, 'Ktoś oczekuje szeryfa na komendzie Paleto Bay!')
	elseif status == 'lamesa' then
		TriggerClientEvent("sendProximityMessagePoliceDzwonek", -1, 'Ktoś oczekuje szeryfa na komendzie La Mesa!')
	end
end)

RegisterNetEvent('goldengate:dzwonekDbCars')
AddEventHandler('goldengate:dzwonekDbCars', function(status)
	if status == 'dbcars' then
		TriggerClientEvent("sendProximityMessageDbCarsDzwonek", -1, 'Ktoś oczekuje pracownika na firmie!')
	end
end)

RegisterNetEvent('goldengate:dzwonekDycha')
AddEventHandler('goldengate:dzwonekDycha', function(rodzaj)
	if rodzaj == 'silownia' then
	TriggerClientEvent("sendProximityMessageSilowniaDzwonek", -1, 'Ktoś oczekuje pracownika na siłowni!')
	end
end)


RegisterNetEvent('goldengate:dzwonekEMS')
AddEventHandler('goldengate:dzwonekEMS', function(status)
	if status == 'glowny' then
		TriggerClientEvent("sendProximityMessageEMSDzwonek", -1, 'Ktoś oczekuje medyka w szpitalu na Pillbox!')
	elseif status == 'hanys' then
		TriggerClientEvent("sendProximityMessageEMSDzwonek", -1, 'Ktoś oczekuje medyka w szpitalu na Mount Zonah!')
	elseif status == 'sandy' then
		TriggerClientEvent("sendProximityMessageEMSDzwonek", -1, 'Ktoś oczekuje medyka w szpitalu na Sandy!')
	elseif status == 'paleto' then
		TriggerClientEvent("sendProximityMessageEMSDzwonek", -1, 'Ktoś oczekuje medyka w szpitalu na Paleto!')
	end
end)

RegisterNetEvent('goldengate:dzwonekWEAZEL')
AddEventHandler('goldengate:dzwonekWEAZEL', function(weazel)
	if weazel == 'news' then
		TriggerClientEvent("sendProximityMessageWEAZELDzwonek", -1, 'Ktoś oczekuje pracownika w siedzibie Weazel News!')
	end
end)

RegisterNetEvent('goldengate:dzwonekAVOCAT')
AddEventHandler('goldengate:dzwonekAVOCAT', function(avocat)
	if avocat == 'kancelaria' then
		TriggerClientEvent("sendProximityMessageAVOCATDzwonek", -1, 'Ktoś oczekuje pracownika w kancelarii adwokackiej!')
	end
end)

ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)


--[[]]--

function getIdentity(source)
	local identifier = ESX.GetPlayerFromId(source).identifier
	for i=1, #danePostaci do
		if tostring(danePostaci[i].identifier) == tostring(identifier) then
			return danePostaci[i]
		end
	end
end

function getIdentityreport(source)
	local identifier = ESX.GetPlayerFromId(source).identifier
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end

function getIdentityToArray(source)
	local identifier = ESX.GetPlayerFromId(source).identifier
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]
		local znaleziono = false

		for i=1, #danePostaci do
			if tostring(danePostaci[i].identifier) == tostring(identifier) then
				znaleziono = true
				danePostaci[i].phone_number = identity['phone_number']
				break
			end
		end

		if znaleziono == false then
			table.insert(danePostaci, {
				identifier = identifier,
				phone_number = identity['phone_number']
			})
		end

	end
end

 AddEventHandler('chatMessage', function(source, name, message)
      if string.sub(message, 1, string.len("/")) ~= "/" then
          local name = getIdentity(source)
		  local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent("sendProximityMessage", -1, xPlayer.name, source, message)
      end
      CancelEvent()
end)
  
RegisterNetEvent('menu:phone')
AddEventHandler('menu:phone', function()
	local name = getIdentity(source)
	TriggerClientEvent("sendProximityMessagePhone", -1, source, source, name.phone_number)
end)

function sendToDiscordMe (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		local dzielnica = GetConvar("cfgdzielnica", "false")
		if dzielnica == 'Tilos' then
			PerformHttpRequest('https://discordapp.com/api/webhooks/709326784990281788/kxWpnNjGEvaAkNkrV-brgFAZ6AIIMN8wEatMvSeDk9qrO9ycY6BFuNLOhXzFpRN1i1SW', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		elseif dzielnica == 'Skye' then
			PerformHttpRequest('https://discord.com/api/webhooks/800076333332824064/VtG0-2o8dx_ljsdCFAqZcCpp2SnutC5ixor9vEx71As0pQBfHkTlhKorPOmAQwfaTB76', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		end
end

function sendToDiscordDo (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		local dzielnica = GetConvar("cfgdzielnica", "false")
		if dzielnica == 'Tilos' then
			PerformHttpRequest('https://discordapp.com/api/webhooks/709337706274095134/4W8y24IuHeAFR8F-R-F2e2Flsqc4GtxeL8-bMbaR9JCVlBke7J7GRsgAfGpmjxGV2aVv', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		elseif dzielnica == 'Skye' then
			PerformHttpRequest('https://discord.com/api/webhooks/800076382025678928/z4zL0eYba9xGDBt48U7AWzCtibYTzQPuD4oLnCe74mzLW3EIs6FMBtH3FsVb2839tstB', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		end
end

function sendToDiscordTry (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		local dzielnica = GetConvar("cfgdzielnica", "false")
		if dzielnica == 'Tilos' then
			PerformHttpRequest('https://discordapp.com/api/webhooks/709339539868614719/Q32xOalfyfHsZunNKJx1dte9WQRXS7lQt97agv_jzRD9HwgNhc9Mv2iqJlO9P422cCNS', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		elseif dzielnica == 'Skye' then
			PerformHttpRequest('https://discord.com/api/webhooks/800076434910871653/GRHPRBfvLemcvFNwLeQylJyn0ujv1mdd3fDXx20Lc0pDYk6uWz8DxvExn1NKZSEabwos', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		end
end

function sendToDiscordAd (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		local dzielnica = GetConvar("cfgdzielnica", "false")
		if dzielnica == 'Tilos' then
			PerformHttpRequest('https://discordapp.com/api/webhooks/709340848545857556/VCLQnm6XWsY1CXOkDEY82mv5LiTBgNPuG2FsK2EkagQhH4kF67yeUzzR832hnwn3wMxX', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		elseif dzielnica == 'Skye' then
			PerformHttpRequest('https://discord.com/api/webhooks/800076504049647686/bUWyGhtqxmzFtMpSXWwAMyf7ePED1CRRDpgSQsVg_GOINUgljb9VfeNEjbbhZ_wGntEn', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		end
end

function sendToDiscordTwitter (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		local dzielnica = GetConvar("cfgdzielnica", "false")
		if dzielnica == 'Tilos' then
			PerformHttpRequest('https://discordapp.com/api/webhooks/709345236807319632/I3uVkvK2e6FrxuF05Gi_Z1wVrQ8yUBHiwj6EL7UQn7WR3f4mJbnEPSssoHUuSSuw4ETQ', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		elseif dzielnica == 'Skye' then
			PerformHttpRequest('https://discord.com/api/webhooks/800076572366995508/wI-BQI9SDSy6UFHh2JfSXTvL2vC7VwHlhM2CU2SGZIm5sQFcXa20zRb69PUV7akkfqQa', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		end
end

function sendToDiscordFrakcyjne (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		local dzielnica = GetConvar("cfgdzielnica", "false")
		if dzielnica == 'Tilos' then
			PerformHttpRequest('https://discordapp.com/api/webhooks/709343303094501437/K28bAdsYbeTyZqb8ENGaSrzrL2eapYb2oOATYr7diImh_LLaxAOamTyRLbjQBKVvE2WI', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		elseif dzielnica == 'Skye' then
			PerformHttpRequest('https://discord.com/api/webhooks/800076650539646977/J2yZ9NidxpJzR8ENh-mEl9TcNyJsvXFerNMSeCk18otqg-BQaUsx0ECdF-TdsFgKc6C0', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		end
end

function sendToDiscordAdmin (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		local dzielnica = GetConvar("cfgdzielnica", "false")
		if dzielnica == 'Tilos' then
			PerformHttpRequest('https://discordapp.com/api/webhooks/709346994392662046/tiExu2AsvnW9Q1kRW5WF9q1ZtMT17fLFuoNmc8ZGFgG307o-plwdSM7ymmh1O4TA1RDX', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		elseif dzielnica == 'Skye' then
			PerformHttpRequest('https://discord.com/api/webhooks/800076697906053130/O0gA3XhG83yC9Y2jPMo98b52ygAv0_JijLTz2VMM19EArhhdtTSGRrj5sZU2WfH73Otn', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		end
end

function sendToDiscordDark (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		local dzielnica = GetConvar("cfgdzielnica", "false")
		if dzielnica == 'Tilos' then
			PerformHttpRequest('https://discordapp.com/api/webhooks/709350532996661269/n04loqeFOvVXtpD_BGMB8Syt-sT82Z-xlOQKxBzQGfyNo84-wG22phOgWm2Fw6ltNBWc', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		elseif dzielnica == 'Skye' then
			PerformHttpRequest('https://discord.com/api/webhooks/800076757856026664/TPKvYMUKSV05WHsFk1qR-dPGX4Hn5YUf1qhRAyDRCs_CN2uM5_uJrodY4jIKvO8Wxr9P', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
		end
end

RegisterCommand('me', function(source, args, rawCommand)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local czas = os.date("%Y/%m/%d %X")
    TriggerClientEvent("sendProximityMessageMe", -1, source, source, table.concat(args, " "))

	local text = ''
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
	color = {r = 0, g = 227, b = 243, alpha = 255}
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
	sendToDiscordMe('RPChat | Me', '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..text..'\n**Data: **'..czas,11750815)
end, false)

RegisterCommand('try', function(source, args, rawCommand)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local czas = os.date("%Y/%m/%d %X")
	local czy = math.random(1, 2)
    TriggerClientEvent("sendProximityMessageCzy", -1, source, source, table.concat(args, " "), czy)
	-- 82, 92, 91
	if czy == 1 then
		kolor = ''
	else
		kolor = ''
	end
	local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
	for i = 1,#args do
		text = text .. ' '..kolor..' ' .. args[i]
	end
		color = {r = 106, g = 212, b = 176, alpha = 255}
		color2 = {r = 232, g = 27, b = 9, alpha = 255}
	if czy == 1 then
		TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
		sendToDiscordTry('RPChat | Try (powodzenie)', '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..text..'\n**Data: **'..czas,56108)
	else
		TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color2)
		sendToDiscordTry('RPChat | Try (niepowodzenie)', '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..text..'\n**Data: **'..czas,16711680)
	end
end, false)

RegisterCommand('do', function(source, args, rawCommand)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local czas = os.date("%Y/%m/%d %X")
    TriggerClientEvent("sendProximityMessageDo", -1, source, source, table.concat(args, " "))

	local text = '' -- edit here if you want to change the language : EN: the person / FR: la personne
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
	color = {r = 18, g = 105, b = 202, alpha = 255}
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
	sendToDiscordDo('RPChat | Do', '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..text..'\n**Data: **'..czas,16744192)
end, false)

 RegisterCommand('help', function(source, args, rawCommand)
    local msg = rawCommand:sub(3)
    local name = getIdentity(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    fal = "Podstawowe komendy chatu"
    TriggerClientEvent('chat:addMessage', source, {
        template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(189, 112, 4, 0.4); border-radius: 3px;"><i class="far fa-question-circle"></i>&nbsp; {0}: <br>{1}<br>{2}<br>{3}<br>{4}</div>',
        args = { fal, '[chat bez komendy] - Local OOC;', '[/me], [/do], [/if] - Komendy narracyjne;', '[/ad] - Zamieszczenie ogłoszenia ($15);', '[/zglos] - Wiadomośc do admina;'}
    })
end, false)

RegisterCommand('ad', function(source, args, rawCommand)
    local msg = rawCommand:sub(3)
    local name = getIdentity(source)
	local amount = 1000
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local czas = os.date("%Y/%m/%d %X")
	local quantity = xPlayer.getInventoryItem('phone').count
	
	local name = getIdentityreport(_source)	
	local imienazwisko = name.firstname..' '..name.lastname
	if wylaczsocial == false then
		if quantity > 0 then
			fal = "Ogłoszenie - " .. imienazwisko
			TriggerClientEvent('sendProximityMessageOgloszenie', -1, fal, msg)
			sendToDiscordAd('RPChat | Ogłoszenie', '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..msg..'\n**Data: **'..czas,2061822)
			TriggerClientEvent("pNotify:SendNotification", source, {text = "Zapłaciłeś/aś $1000 za nadanie ogłoszenia"})
			xPlayer.removeAccountMoney('bank', amount)
		else
			TriggerClientEvent("pNotify:SendNotification", _source, {text = 'Nie masz przy sobie telefonu!'})
		end
	else	
		xPlayer.showNotification('Twitter i Ogłoszenia są wyłączone')
	end	
	
end, false)

RegisterCommand('ems', function(source, args, rawCommand)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
	fal = "EMS"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	local czas = os.date("%Y/%m/%d %X")
	if xPlayer.job.name == 'ambulance' then
		if grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = "🚑️ <span style='font-weight: bold; color: rgb(239, 83, 69);'>@{0}</span>: {1}",
			args = { fal, msg }
			})
			sendToDiscordFrakcyjne('RPChat | Frakcja: '..fal, '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..msg..'\n**Data: **'..czas,8421504)
		end
	end
end, false)

RegisterCommand('bmc', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local czas = os.date("%Y/%m/%d %X")
	fal = "BMC"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'kawiarnia' then
		if grade == 'boss' or grade == 'kierownik' or grade == 'kelner' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = "☕ <span style='font-weight: bold; color: rgb(164, 98, 40);'>@{0}</span>: {1}",
			args = { fal, msg }
			})
			sendToDiscordFrakcyjne('RPChat | Frakcja: '..fal, '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..msg..'\n**Data: **'..czas,8421504)
		end
	end
end, false)

RegisterCommand('lssd', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local czas = os.date("%Y/%m/%d %X")
	fal = "LSSD"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'sheriff' then
		if grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = "⭐️ <span style='font-weight: bold; color: rgb(124, 66, 0);'>@{0}</span>: {1}",
			args = { fal, msg }
			})
			sendToDiscordFrakcyjne('RPChat | Frakcja: '..fal, '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..msg..'\n**Data: **'..czas,8421504)
		end
	end
end, false)

RegisterCommand('taxi', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local czas = os.date("%Y/%m/%d %X")
	fal = "TAXI"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'taxi' then
		if grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = "🚕 <span style='font-weight: bold; color: rgb(255, 255, 0);'>@{0}</span>: {1}",
			args = { fal, msg }
			})
			sendToDiscordFrakcyjne('RPChat | Frakcja: '..fal, '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..msg..'\n**Data: **'..czas,8421504)
		end
	end
end, false)

RegisterCommand('lspd', function(source, args, rawCommand)
    local msg = rawCommand:sub(5)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local czas = os.date("%Y/%m/%d %X")
	fal = "LSPD"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'police' then
		if grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = "🚓 <span style='font-weight: bold; color: rgb(0, 8, 124);'>@{0}</span>: {1}",
			args = { fal, msg }
			})
			sendToDiscordFrakcyjne('RPChat | Frakcja: '..fal, '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..msg..'\n**Data: **'..czas,8421504)
		end
	end
end, false)

RegisterCommand('weazel', function(source, args, rawCommand)
    local msg = rawCommand:sub(8)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local czas = os.date("%Y/%m/%d %X")
	fal = "Weazel News"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'weazel' then
		--if grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = "🎥 <span style='font-weight: bold; color: rgb(239, 83, 69);'>@{0}</span>: {1}",
			args = { fal, msg }
			})
			sendToDiscordFrakcyjne('RPChat | Frakcja: '..fal, '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..msg..'\n**Data: **'..czas,8421504)
		--end
	end
end, false)

RegisterCommand('mechanic', function(source, args, rawCommand)
    local msg = rawCommand:sub(9)
    local name = getIdentity(source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local czas = os.date("%Y/%m/%d %X")
	fal = "Warsztat"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'mechanic' then
		if grade == 'boss' or grade == 'kierownik' then
			TriggerClientEvent('chat:addMessage', -1, {
			template = "🔧 <span style='font-weight: bold; color: rgb(232, 87, 9);'>@{0}</span>: {1}",
			args = { fal, msg }
			})
			sendToDiscordFrakcyjne('RPChat | Frakcja: '..fal, '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..msg..'\n**Data: **'..czas,8421504)
		end
	end
end, false)

RegisterCommand('admin', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	local czas = os.date("%Y/%m/%d %X")
	if (xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'opiekun') then
		local tekst = table.concat(args, " ")
		TriggerClientEvent('chat:addMessage', -1, {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(232, 27, 9, 0.9); border-radius: 3px;"><i class="fas fa-shield-alt"></i>&nbsp; {0}: {1}</div>',
			args = { "ADMIN", tekst }
		})
		sendToDiscordAdmin('RPChat | Admin', '**Nick:** '..xPlayer.name..'\n**ID:** ['..source..']\n**Wiadomość:** '..tekst..'\n**Data: **'..czas,16711680)
	else
		xPlayer.showNotification('Nie posiadasz permisji')
	end
end, false)

function sendToDiscordKomendy (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "mrp_logs",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		PerformHttpRequest('https://discordapp.com/api/webhooks/712257367659511889/NCKNrr0cwgYvRLPloZUZ0-6Nn7CsHywsPQLpp-Vq7baKa2HgKRs9x6Kvft6UuffGEqLQ', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

local wylaczsocial = false
RegisterCommand('wylacztwt', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	local czas = os.date("%Y/%m/%d %X")
	if (xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'opiekun') then
		if wylaczsocial == false then
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(0, 0, 200, 0.9); border-radius: 3px;"><i class="fab fa-twitter"></i>&nbsp; {0}: {1}</div>',
				args = { "Twitter Admin", 'Twitter został wyłączony przez moderację' }
			})
			wylaczsocial = true
			sendToDiscordKomendy('Wylacz TWT', '**Nick:** '..xPlayer.name..'\n**ID:** ['..xPlayer.source..']\n**Wyłączył twittera\nData: **'..czas,56108)
		else 
			TriggerClientEvent('chat:addMessage', -1, {
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(0, 0, 200, 0.9); border-radius: 3px;"><i class="fab fa-twitter"></i>&nbsp; {0}: {1}</div>',
				args = { "Twitter Admin", 'Twitter został włączony, prosimy o zachowanie kultury!' }
			})
			wylaczsocial = false
			sendToDiscordKomendy('Wlacz TWT', '**Nick:** '..xPlayer.name..'\n**ID:** ['..xPlayer.source..']\n**Włączył twittera\nData: **'..czas,56108)
		end	
	else
		xPlayer.showNotification('Nie posiadasz permisji')
	end
end, false)

RegisterServerEvent('sendProximityMessageTweetServer')
AddEventHandler('sendProximityMessageTweetServer', function(message)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if wylaczsocial == false then
		if CheckPhone(_source) <= 0 then
			TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz telefonu.')
			return
		end

		local xPlayer = ESX.GetPlayerFromId(_source)
		local czas = os.date("%Y/%m/%d %X")
		local name = getIdentityreport(_source)
		
		local imienazwisko = name.firstname..' '..name.lastname
		
		TriggerClientEvent("sendProximityMessageTweet", -1, imienazwisko, message)
		sendToDiscordTwitter('RPChat | Twitter', '**Nick:** '..xPlayer.name..'\n**ID:** ['.._source..']\n**Wiadomość:** '..message..'\n**Data: **'..czas,2061822)
	else
		xPlayer.showNotification('Twitter jest wyłączony')
	end	
end)

RegisterServerEvent('sendProximityMessageDarkWebServer')
AddEventHandler('sendProximityMessageDarkWebServer', function(message)
	local _source = source
    if CheckPhone(_source) <= 0 then
        local playerName = GetPlayerName(_source)
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz telefonu.')
        return
    end

    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getAccount('black_money').money <= 100 then
		TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz brudnej gotówki żeby napisać wiadomość')
		return
	end
	
	local czas = os.date("%Y/%m/%d %X")
	local name = getIdentityreport(_source)
	
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offpolice' or xPlayer.job.name == 'offsheriff' or xPlayer.job.name == 'offambulance' then
		TriggerClientEvent('esx:showNotification', _source, 'Nie możesz wysłać wiadomości na darkweb')
	else
		TriggerClientEvent("sendProximityMessageDarkWeb", -1, message)
		sendToDiscordDark('RPChat | Darkweb', '**Nick:** '..xPlayer.name..'\n**ID:** ['.._source..']\n**Wiadomość:** '..message..'\n**Data: **'..czas,8421504)
		xPlayer.removeAccountMoney('black_money', 100)
	end
end)

RegisterCommand('doj', function(source, args, rawCommand)
    local msg = rawCommand:sub(4)
    local name = getIdentity(source)
	fal = "DOJ"
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = xPlayer.job.grade_name
	if xPlayer.job.name == 'avocat' then
		if grade == 'boss' then
			TriggerClientEvent('chat:addMessage', -1, {
				template = "⚖️ <span style='font-weight: bold; color: rgb(2, 31, 53);'>@{0}</span>: {1}",
				args = { fal, msg }
			})
		end
	end
end, false)

AddEventHandler('chatMessage', function(source, color, msg)
	cm = stringsplit(msg, " ")
	if cm[1] == "/odpowiedz" or cm[1] == "/r" then
		local xPlayer = ESX.GetPlayerFromId(source)
		CancelEvent()
		if tablelength(cm) > 1 then
			local tPID = tonumber(cm[2])
			local names2 = GetPlayerName(tPID)
			local names3 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 and i ~=2 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
			local grupos = getIdentityreport(source)
			if grupos.group ~= "user" then
				TriggerClientEvent('textmsg', tPID, source, textmsg, names2, names3)
				TriggerClientEvent('textsent', source, names2)
			end
		end
	end
	
	if cm[1] == "/report" then
		CancelEvent()
		if tablelength(cm) > 1 then
			local names1 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
		    TriggerClientEvent("sendReport", -1, source, names1, textmsg)
		end
	end
end)

RegisterServerEvent('esx_rpchat:shareDisplay')
AddEventHandler('esx_rpchat:shareDisplay', function(text, color)
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function CheckPhone(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    while xPlayer == nil do
        Citizen.Wait(100)
    end

    local items = xPlayer.getInventoryItem('phone')
    if items == nil then
        return(0)
    else
       return(items.count)
    end
end