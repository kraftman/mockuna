

local mockable = require 'test.mockable'
local mockuna = require 'mockuna.mockuna'

describe('Tests ordering of mocks', function()
    local mock1, mock2, mock3
    before_each(function()
        local mockFunction = function() return 'mocked' end
        local mockFunction2 = function() return 'mocked', 'here' end
        mock1 = mockuna:spy(mockable, 'test', mockFunction)
        mock2 = mockuna:spy(mockable, 'test2', mockFunction2)
        mock3 = mockuna:spy(mockable, 'test3', mockFunction)
    end)

    after_each(function()
        mock1:restore();
        mock2:restore();
        mock3:restore();
    end)

    it('records the return value', function()
        mockable.test()
        assert(mockable.test:returned('not mocked'))
    end)

    it('records the return value false', function()
        mockable.test()
        assert(mockable.test:returned('not mockeds') == false)
    end)

    it('records multiple return values', function()
        mockable.test2()
        assert(mockable.test2:returned('not mocked 2', 'not mocked 2a'))
    end)

    it('tests alwaysReturned true', function()
        mockable.test2()
        assert(mockable.test2:alwaysReturned('not mocked 2', 'not mocked 2a'))
    end)

end)