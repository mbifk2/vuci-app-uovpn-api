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

-- GET /api/uovpn/servers
function uovpn:GET_TYPE_servers()
	local conn = ubus_connect(self)
	if not conn then
		return self:ResponseError("Ubus connection failed")
	end
	local ok, data = pcall(function()
		return conn:call("openvpn", "servers", {}) or {}
	end)
	conn:close()
	if not ok then
		return self:ResponseError(100, "Ubus call failed", "GET_TYPE_servers")
	end

	return self:ResponseOK({
		result = "Ubus call completed",
		data = data
	})
end

return uovpn
