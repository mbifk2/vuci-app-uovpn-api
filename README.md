# vuci-app-uovpn-api
## Ubus OpenVPN endpoints for Vuci
## Description
This provides two Vuci endpoints for Teltonika RUTX10 routers that communicate with [my ubus module for OpenVPN.](https://github.com/mbifk2/ubus-openvpn-module)

```
{apiURL}/clients - accepts GET and takes a server name as argument.
Example:
Request: {"data":{"server_name":"server"}}
Response:
{
    "success": true,
    "data": {
        "result": "ok",
        "clients": {
            "client": {
                "rx_bytes": 7113,
                "tx_bytes": 6622,
                "real_address": "192.168.2.1:54394",
                "uptime": "00:06:28",
                "virtual_address": "172.16.10.6",
                "common_name": "client"
            },
            "client3": {
                "rx_bytes": 10893,
                "tx_bytes": 10403,
                "real_address": "192.168.2.1:46374",
                "uptime": "00:14:07",
                "virtual_address": "172.16.10.10",
                "common_name": "client3"
            },
            "client2": {
                "rx_bytes": 10894,
                "tx_bytes": 10404,
                "real_address": "192.168.2.1:40405",
                "uptime": "00:14:07",
                "virtual_address": "172.16.10.14",
                "common_name": "client2"
            }
        }
    }
}

{apiURL}/actions/disconnect - accepts POST and takes a server name and client name as arguments.
Example:
Request: {"data":{"server_name": "server", "client_name": "client"}}
Response:
{
    "success": true,
    "data": {
        "result": "ok",
        "msg": {
            "message": "SUCCESS: common name 'client' found, 1 client(s) killed"
        }
    }
}
```
