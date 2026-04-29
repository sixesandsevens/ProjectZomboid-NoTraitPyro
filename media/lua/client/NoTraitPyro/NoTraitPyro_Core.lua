print("NO TRAIT PYRO FILE LOADED")

Events.OnGameStart.Add(function()
    print("NO TRAIT PYRO LOADED (OnGameStart)")
end)

NoTraitPyro = NoTraitPyro or {}

NoTraitPyro.fireEnergy = 50

function NoTraitPyro.isIgniter(item)
    if not item then return false end
    if getCore():getGameVersion():getMajor() < 42 then
        return item:getType() == "Lighter" or item:getType() == "Matches"
    end
    local scriptItem = item:getScriptItem()
    if not scriptItem then return false end
    return scriptItem:getDisplayCategory() == "FireSource"
end

function NoTraitPyro.isFlammable(item)
    if not item then return false end

    local category = item:getCategory() or ""
    local fullType = item:getFullType() or ""
    local name = string.lower(item:getName() or "")
    local fullTypeLower = string.lower(fullType)

    -- Hard deny: these should never be fuel
    if string.find(fullTypeLower, "key") then return false end
    if string.find(fullTypeLower, "bag") then return false end
    if string.find(fullTypeLower, "bottle") then return false end
    if string.find(fullTypeLower, "water") then return false end
    if string.find(fullTypeLower, "fluid") then return false end
    if string.find(fullTypeLower, "container") then return false end

    if category == "Key" then return false end
    if category == "Container" then return false end
    if category == "Clothing" then return false end
    if category == "Food" then return false end
    if category == "Weapon" then return false end

    -- Known safe fuel
    if category == "Literature" then return true end

    if fullType == "Base.Money" then return true end
    if fullType == "Base.IDcard" then return true end
    if fullType == "Base.IDcard_Female" then return true end
    if fullType == "Base.CardDeck" then return true end

    -- Controlled paper-ish names
    if string.find(name, "paper") then return true end
    if string.find(name, "note") then return true end
    if string.find(name, "photo") then return true end
    if string.find(name, "map") then return true end

    return false
end

function NoTraitPyro.getGroupedItems(inventory, predicate)
    local grouped = {}
    local items = inventory:getAllEvalRecurse(predicate, ArrayList.new())
    if items:size() == 0 then return nil end
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local name = item:getName()
        grouped[name] = grouped[name] or {}
        table.insert(grouped[name], item)
    end
    return grouped
end

function NoTraitPyro.setFire(square, flammable)
    if not square then return end
    IsoFireManager.StartFire(getCell(), square, true, NoTraitPyro.fireEnergy)
end

function NoTraitPyro.requestSetFire(square)
    if not square then return end

    if isClient and isClient() then
        sendClientCommand("NoTraitPyro", "SetFire", {
            x = square:getX(),
            y = square:getY(),
            z = square:getZ(),
        })
        return
    end

    NoTraitPyro.setFire(square)
end
