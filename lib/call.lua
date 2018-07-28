-- contains what it was called with
-- calledWith

local call = {}
call.__index = call

function call:new(parent, method, ...)
    local c = setmetatable({}, call)
    c.args = {...}
    c.exactArgs = ...
    c.parent = parent
    c.method = method
    return c
end

function call:calledWith(...)
    local argsToCheck = {...}
    for k,v in ipairs(argsToCheck) do
        if self.args[k] ~= v then
            return false
        end
    end
    return true
end

function call:calledWithExactly(...)
    local argsToCheck = {...}
    for k,v in ipairs(self.args) do
        if argsToCheck[k] ~= v then
            return false
        end
    end
    return true
end

function call:call()
    -- for spies later
    self.results = table.pack(self.method(self.exactArgs))
    return unpack(self.results)
end

function call:returned(...)
    local returnsToCheck = {...}
    for k,v in ipairs(returnsToCheck) do
        if self.results[k] == v then
            return true
        end
    end
end

return call