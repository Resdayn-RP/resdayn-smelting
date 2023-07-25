if not (ResdaynCore or ResdaynMining) then return end

---@class smeltine
local smelting = {}

smelting.recipes = require("custom.resdaynSmelting.recipes")
smelting.config = require("custom.resdaynSmelting.config")

---@param pid integer
---@return boolean isInRange
function smelting.isInRange(pid)
    for i=1, #smelting.config.locations, 1 do
        if -(smelting.config.locations[i] - ResdaynCore.functions.getPlayerCoords(pid) < smelting.config.maxRadius) then
            return true
        end
    end
    return false
end

---@param seconds integer
function smelting.smeltingProcess(seconds)
    -- define interval and interval target
    local interval, elapsed = seconds / 4, 0
    while elapsed < seconds do
        elapsed  = elapsed + interval
        ResdaynCore.functions.Wait(interval)
    end 
end

---@param pid integer
---@param targetMat string
function smelting.startSmelting(pid, targetMat)
    if not (targetMat or smelting.recipes[targetMat]) then return end

    if not smelting.isInRange(pid) then return end

    local player = Players[pid]
    local input, output = smelting.recipes[targetMat].requirement, smelting.recipes[targetMat].output

    if tes3mp.GetInventoryItemCount(pid, input.item) < input.amount then return end

    ResdaynCore.functions.removeItem(player, input.item, input.amount)
    
    smelting.smeltingProcess(input.time)

    ResdaynCore.functions.addItem(player, output.item, output.amount)
end

return smelting