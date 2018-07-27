-- contains what it was called with
-- calledWith

local call = {}
call.__index = call

function call:new(...)
    local c = setmetatable({}, call)
    c.args = unpack(...)
    c.exactArgs = ...
    return c
end

return call