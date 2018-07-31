

local mockable = require 'test.mockable'
local mockuna = require 'mockuna.mockuna'

describe('stub responses', function()
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

    it('allows reassigning the stub function', function()
        local result = mockable.test()
        assert(result == 'mocked')
        mock1:returns(function() return 'remocked' end)
        result = mockable.test()
        assert(result == 'remocked')
    end)

    it('returns a value on a specific call', function()
        mock1:onCall(2):returns('returna', 'returnb')
        local result = mockable.test()
        assert(result == 'mocked')
        local a, b = mockable.test()
        assert(a == 'returna')
        assert(b == 'returnb')
    end)

    it('returns different values based on args', function()
        mock1:withArgs('this'):returns('returna', 'returnb')
        local result = mockable.test()
        assert(result == 'mocked')
        local a, b = mockable.test('this')
        assert(a == 'returna')
        assert(b == 'returnb')
    end)

end)