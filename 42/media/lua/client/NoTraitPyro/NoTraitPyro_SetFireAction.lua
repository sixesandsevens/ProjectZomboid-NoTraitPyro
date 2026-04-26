require "TimedActions/ISBaseTimedAction"

NoTraitPyroSetFireAction = ISBaseTimedAction:derive("NoTraitPyroSetFireAction")

function NoTraitPyroSetFireAction:isValid()
    return self.character ~= nil and self.square ~= nil
end

function NoTraitPyroSetFireAction:update()
end

function NoTraitPyroSetFireAction:start()
    self:setActionAnim("Loot")
end

function NoTraitPyroSetFireAction:stop()
    ISBaseTimedAction.stop(self)
end

function NoTraitPyroSetFireAction:perform()
    NoTraitPyro.setFire(self.square, self.flammable)

    if self.flammable and self.character:getInventory():contains(self.flammable) then
        self.character:getInventory():Remove(self.flammable)
    end

    ISBaseTimedAction.perform(self)
end

function NoTraitPyroSetFireAction:new(character, square, flammable)
    local o = ISBaseTimedAction.new(self, character)
    o.character = character
    o.square = square
    o.flammable = flammable
    o.maxTime = 80
    return o
end
