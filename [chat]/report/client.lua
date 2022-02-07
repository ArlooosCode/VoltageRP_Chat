local group 

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

RegisterNetEvent("textsent")
AddEventHandler('textsent', function(names2)
	--TriggerEvent('textsentlul', "", " Wiadomosc wyslana do:^0 " .. names2 .. "","")
	TriggerEvent('textsentlul', "","", "Wiadomosc zostala wyslana do "..names2)
end)

RegisterNetEvent('textsentlul')
AddEventHandler('textsentlul', function(id, name, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if GetDistanceBetweenCoords(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)), GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid)), true) < 19.999 then
        TriggerEvent('chat:addMessage', {
            --template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(255, 102, 163, 0.3); border-radius: 3px;"><i class="fas fa-flag"style="font-size:15px;color:white"></i>&ensp;<i><b><font size="3" color="#FFFFFF">{0}</font></b></i>&ensp;<b><i><font color="white">{1}</font></i></b></div>',
            template = "🚩 <span style='font-weight: bold; color: rgb(255, 0, 0);'>{1}</span>",
			args = { name, message }
        })
    end
end)


RegisterNetEvent("textmsg")
AddEventHandler('textmsg', function(source, textmsg, names2, names3)
	TriggerEvent('textsentlul',"",""," ADMIN - " .. names3 .."  ".."^0: " .. textmsg)
end)

RegisterNetEvent('report:witam')
AddEventHandler('report:witam', function()
	TriggerEvent('textsentlul', "","", "Wiadomosc zostala wyslana!")
end)

RegisterNetEvent('sendReport')
AddEventHandler('sendReport', function(id, name, message)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('textsentlul', "","", "Wiadomosc zostala wyslana!")
	TriggerEvent('textsentlul', "","", "[ZGLOS] | [".. id .."]" .. name .."  "..":^0  " .. message)
  elseif (group == 'mod' or group == 'admin' or group == 'superadmin' or group == 'opiekun') and pid ~= myId then
	TriggerEvent('textsentlul', "","", "[ZGLOS] | [".. id .."]" .. name .."  "..":^0  " .. message)
  end
end)

CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/zglos')
end)

