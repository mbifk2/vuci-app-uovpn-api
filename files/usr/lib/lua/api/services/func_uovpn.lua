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

-- GET /api/uovpn/clients
function uovpn:GET_TYPE_clients()
	local server_name = self.arguments.server_name
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

	return self:Response({result="ok", clients=clients})
end

return uovpn
