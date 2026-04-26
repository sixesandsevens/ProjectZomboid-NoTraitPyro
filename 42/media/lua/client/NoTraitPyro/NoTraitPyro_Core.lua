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

    local category = item:getCategory()
    local fullType = item:getFullType()
    local name = string.lower(item:getName() or "")

    -- 1. Reliable category
    if category == "Literature" then
        return true
    end

    -- 2. Explicit known items
    if fullType == "Base.Money" then return true end
    if fullType == "Base.IDcard" then return true end
    if fullType == "Base.IDcard_Female" then return true end
    if fullType == "Base.CardDeck" then return true end

    -- 3. Controlled keyword matching (strict)
    if string.find(name, "paper") then return true end
    if string.find(name, "note") then return true end
    if string.find(name, "map") then return true end
    if string.find(name, "photo") then return true end

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
