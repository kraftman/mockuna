

local m = {}

m.test = function()
    return 'not mocked'
end

m.test2 = function()
    return 'not mocked 2'
end

m.test3 = function()
    return 'not mocked 3'
end

return m