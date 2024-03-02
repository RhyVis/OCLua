local internet = require('component').internet
local computer = require('computer')
local json = require('json')
local serialization = require("serialization")

local url = "http://localhost:21314/api/oc"

while true do
    local opt_0, resp_ = xpcall(function()

        --Stage get scripts
        local get_req = internet.request(url)
        local get_s = true
        local get_time = computer.uptime()
        while get_s do
            local status, err = get_req.finishConnect()
            if status then
                break
            end
            if status == nil then
                get_s = false
                break
            end
            if computer.uptime() >= get_time + 15 then
                get_req.close()
                get_s = false
                break
            end
            os.sleep(0)
        end

        --Stage execution of commands
        if get_req.finishConnect() then
            local resp_code, _, _ = get_req.response()

            if resp_code == 200 then
                local result = ""
                while true do
                    local chunk, err = get_req.read()
                    if not chunk then
                        break
                    end
                    result = result .. chunk
                end
                local r = result

                --Stage extracting commands
                local cm_t = json.decode(r)
                local cr_t = {}

                for sign, command in pairs(cm_t) do

                    print("Received command pack: "..sign)

                    local code, _ = load(command)
                    local opt, resp = xpcall(code, debug.traceback)

                    local command_j = ""

                    if opt then
                        command_j = json.encode(resp)
                    else
                        command_j = json.encode("ERROR")
                    end

                    cr_t[sign] = command_j
                end

                --Stage report in
                local conn = { ["content-type"] = "text/plain;charset=utf-8" }
                local report_req = internet.request(url, json.encode(cr_t), conn)

                local report_s = true
                local report_start_time = computer.uptime()
                while report_s do
                    local status, err = report_req.finishConnect()
                    if status then
                        break
                    end
                    if status == nil then
                        report_s = false
                    end
                    if computer.uptime() >= report_start_time + 1 then
                        report_req.close()
                        report_s = false
                    end
                    os.sleep(0)
                end
                if report_s then
                    report_req.close()
                end
            end
        end

        --Standard wait time
        os.sleep(1)

    end, debug.traceback)
end