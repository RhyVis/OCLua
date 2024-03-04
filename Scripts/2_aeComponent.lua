function aeItem()
    return c.me_controller.getItemsInNetwork()
end

function aeFluid()
    return c.me_controller.getFluidsInNetwork()
end

function aeCpuInfo()
    local cpus = c.me_controller.getCpus()
    for k, v in pairs(cpus) do
        v["cpuid"] = k
        v["cpu"] = nil
    end
    return cpus
end

function aeCpuDetail(cpuid)
    local cpu = c.me_controller.getCpus()[cpuid]['cpu']
    local json = require('json')
    return json.encode(cpu.activeItems()) .. "#@#"
            .. json.encode(cpu.storedItems()) .. "#@#"
            .. json.encode(cpu.pendingItems()) .. "#@#"
            .. json.encode(cpu.finalOutput())
end

function aeCraft(name, meta, amount)
    return c.me_controller.getCraftables({name=name, damage=meta})[1].request(amount, true)
end