

local mockable = require '../lib/mockable'
local mockuna = require '../lib/mockuna'

describe('Tests ordering of mocks', function()
    local mock1, mock2, mock3
    before_each(function()
        local mockFunction = function() return 'mocked' end
        local mockFunction2 = function() return 'mocked', 'here' end
        mock1 = mockuna:mock(mockable, 'test', mockFunction)
        mock2 = mockuna:mock(mockable, 'test2', mockFunction2)
        mock3 = mockuna:mock(mockable, 'test3', mockFunction)
    end)

    after_each(function()
        mock1:restore();
        mock2:restore();
        mock3:restore();
    end)

    it('records the return value', function()
        mockable.test()
        assert(mockable.test:returned('mocked'))
    end)

    it('records multiple return values', function()
        mockable.test()
        assert(mockable.test:returned('mocked', 'here'))
    end)
end)