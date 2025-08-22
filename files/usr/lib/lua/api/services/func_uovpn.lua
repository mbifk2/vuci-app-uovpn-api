local FunctionService = require("api/FunctionService")
local ubus = require("ubus")

local uovpn = FunctionService:new()

local function ubus_connect(self)
	local conn = ubus.connect()
	if not conn then
		self:add_critical_error(100, "Ubus connection failed", "ubus_connect")
		return nil
	end
	return conn
end

function uovpn:GET_TYPE_clients()
	local server_name = self.arguments.data.server_name
	local conn = ubus_connect(self)

	if not server_name then
		return self:Response({success=false, error="server_name required"}, 400)
	end

	local path = "openvpn." .. server_name

	local clients = {}
	clients = conn:call(path, "clients", {}) or {}

	if next(clients) == nil then
		return self:ResponseNotFound("No clients found")
	end

	return self:ResponseOK({result="ok", clients=clients})
end

function uovpn:disconnect()
	local server_name = self.arguments.data.server_name
	local client_name = self.arguments.data.client_name

    if not server_name or server_name == "" then
        return self:Response({success=false, error="server_name required"}, 400)
    end
    if not client_name or client_name == "" then
        return self:Response({success=false, error="client_name required"}, 400)
    end

    local conn = ubus_connect(self)
    if not conn then
        return self:ResponseInternalError("Ubus connection failed")
    end

    local path = "openvpn." .. server_name
    local res = conn:call(path, "disconnect", { name = client_name }) or {}

    return self:ResponseOK({
        result = "ok",
        msg = res
    })
end

local disconnect_action = uovpn:action("disconnect", uovpn.disconnect)

local server_name = disconnect_action:option("server_name")
server_name.require = true
server_name.maxlength = 256

function server_name:validate(value)
	if value == "" then
		return false, "server_name cannot be empty"
	end
		return true
end

local client_name = disconnect_action:option("client_name")
client_name.require = true
client_name.maxlength = 256

function client_name:validate(value)
	if value == "" then
		return false, "client_name cannot be empty"
	end
		return true
end

return uovpn