

local m = {}

m.test = function()
    return 'not mocked'
end

m.test2 = function()
    return 'not mocked 2', 'not mocked 2a'
end

m.test3 = function()
    return 'not mocked 3'
end

m.test4 = function()
    return error('this is exceptional!')
end

return m