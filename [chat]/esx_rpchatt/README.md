# esx_rpchat
FXServer ESX RP Chat


#### Description
This is a proximity chat script. With a few commands such as Twitter, OOC, Local Me, and Local Do.

#### Requirements
- [esx_identity](https://github.com/ESX-Org/esx_identity)

#### Download

**1) Using [fvm](https://github.com/qlaffont/fvm-installer)**
```
fvm install --save --folder=esx esx-org/esx_rpchat
```

**2) Manually**
- Download https://github.com/ESX-Org/esx_rpchat/releases/latest
- Put it in resource/[esx] directory

**3) Using Git**

```
cd resouces
git clone https://github.com/ESX-Org/esx_rpchat
```

#### Installation

1) Add `start esx_rpchat` to your server.cfg


#### Example of a command in server.lua


RegisterCommand('test', function(source, args, rawCommand)
    local playerName = GetPlayerName(source)
    local msg = rawCommand:sub(6)
    local name = getIdentity(source)
    fal = name.firstname .. " " .. name.lastname
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(28, 160, 242, 0.6); border-radius: 3px;"><i class="fab fa-twitter"></i> @{0}:<br> {1}</div>',
        args = { fal, msg }
    })
end, false)


Thats based off the /tweet with command /here