require("uapi")
local json = require("json")
local me = c.me_controller

function GenerateItemJSON()
    local items = me.getItemsInNetwork()
    local file = io.open("indexItem.json", "w")
    io.output(file)
    io.write(json.encode(items))
    io.close(file)
end

function GenerateFluidJSON()
    local fluids = me.getFluidsInNetwork()
    local file = io.open("indexFluid.json", "w")
    io.output(file)
    io.write(json.encode(fluids))
    io.close(file)
end