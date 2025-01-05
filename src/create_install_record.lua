local http = require("socket.http")
local ltn12 = require("ltn12")
local cjson = require("cjson")

local base_url = "https://api.glitch.fun/api/"
local auth_token = "YOUR_AUTH_TOKEN"

function createInstallRecord(title_id, user_install_id, platform)
    local url = base_url .. "titles/" .. title_id .. "/installs"
    local payload = {
        user_install_id = user_install_id,
        platform = platform
    }
    local body = cjson.encode(payload)

    local response_body = {}
    local res, code, headers, status = http.request{
        url = url,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. auth_token,
            ["Content-Length"] = tostring(#body),
        },
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(response_body)
    }

    if res == 1 and code == 201 then
        print("Install record created: " .. table.concat(response_body))
    else
        print("Error code:", code, "Response:", table.concat(response_body))
    end
end

