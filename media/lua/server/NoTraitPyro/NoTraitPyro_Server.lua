NoTraitPyro = NoTraitPyro or {}

NoTraitPyro.fireEnergy = NoTraitPyro.fireEnergy or 50

local function isPlayerCloseEnough(player, square)
    if not player or not square then return false end

    local playerSquare = player:getSquare()
    if not playerSquare then return false end

    local dx = math.abs(playerSquare:getX() - square:getX())
    local dy = math.abs(playerSquare:getY() - square:getY())
    local dz = math.abs(playerSquare:getZ() - square:getZ())

    return dx <= 1 and dy <= 1 and dz == 0
end

local function onClientCommand(module, command, player, args)
    if module ~= "NoTraitPyro" or command ~= "SetFire" then return end
    if not player or not args then return end

    local x = tonumber(args.x)
    local y = tonumber(args.y)
    local z = tonumber(args.z)
    if not x or not y or not z then return end

    local square = getCell():getGridSquare(x, y, z)
    if not isPlayerCloseEnough(player, square) then return end

    IsoFireManager.StartFire(getCell(), square, true, NoTraitPyro.fireEnergy)
end

Events.OnClientCommand.Add(onClientCommand)
