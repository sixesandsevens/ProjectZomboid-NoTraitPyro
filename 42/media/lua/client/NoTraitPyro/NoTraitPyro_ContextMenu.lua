require "NoTraitPyro/NoTraitPyro_Core"
require "NoTraitPyro/NoTraitPyro_SetFireAction"

function NoTraitPyro.onSetFire(_, player, square, igniter, flammable)
    if not player or not square or not flammable then return end
    if luautils.walkAdj(player, square, false) then
        ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), igniter, true, false)
        ISWorldObjectContextMenu.equip(player, player:getSecondaryHandItem(), flammable, false, false)
        ISTimedActionQueue.add(NoTraitPyroSetFireAction:new(player, square, flammable))
    end
end

function NoTraitPyro.onFillWorldObjectContextMenu(playerId, context, worldobjects, test)
    local player = getSpecificPlayer(playerId)
    if not player then return end

    local inventory = player:getInventory()
    local igniters = NoTraitPyro.getGroupedItems(inventory, NoTraitPyro.isIgniter)
    local flammables = NoTraitPyro.getGroupedItems(inventory, NoTraitPyro.isFlammable)
    if not igniters or not flammables then return end

    for _, object in ipairs(worldobjects) do
        local square = object and object:getSquare()
        if square then
            local setFireOption = context:addOption(getText("ContextMenu_NoTraitPyro_SetFire"), worldobjects)
            local igniterMenu = context:getNew(context)
            context:addSubMenu(setFireOption, igniterMenu)

            for igniterName, igniterValues in pairs(igniters) do
                local igniterLabel = string.format("%s (%d)", igniterName, #igniterValues)
                local igniterOption = igniterMenu:addOption(igniterLabel, worldobjects)
                local flammableMenu = context:getNew(context)
                context:addSubMenu(igniterOption, flammableMenu)

                for flammableName, flammableValues in pairs(flammables) do
                    local flammableLabel = string.format("%s (%d)", flammableName, #flammableValues)
                    flammableMenu:addOption(flammableLabel, worldobjects, NoTraitPyro.onSetFire, player, square, igniterValues[1], flammableValues[1])
                end
            end
            return
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(NoTraitPyro.onFillWorldObjectContextMenu)
