

local mockable = require 'test.mockable'
local mockuna = require 'mockuna.mockuna'

describe('stub responses', function()
    local mock1, mock2, mock3
    before_each(function()
        local mockFunction = function() return 'mocked' end
        local mockFunction2 = function() return 'mocked', 'here' end
        mock1 = mockuna:stub(mockable, 'test', mockFunction)
        mock2 = mockuna:stub(mockable, 'test2', mockFunction2)
        mock3 = mockuna:stub(mockable, 'test3', mockFunction)
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

    it('returns an empty stub', function()
        local stub = mockuna:stub()
        assert(stub.callCount == 0)
        local result = stub()
        assert(result == nil)
        assert(stub.callCount == 1)
    end)

    it('falls back to previous method if callcount doesnt match', function()
        mock1:restore()
        mock1 = mockuna:stub(mockable, 'test')
        mock1:onCall(2):returns('returna', 'returnb')
        local result = mockable.test()
        assert(result == 'not mocked')

        local a, b = mockable.test()
        print(a,b)
        assert(a == 'returna')
        assert(b == 'returnb')

        result = mockable.test()
        assert(result == 'not mocked')
    end)

    it('falls back to previous method if args dont match', function()
        mock1:restore()
        mock1 = mockuna:stub(mockable, 'test')
        mock1:withArgs('this'):returns('returna', 'returnb')
        local result = mockable.test()
        assert(result == 'not mocked')
        local a, b = mockable.test('this')
        assert(a == 'returna')
        assert(b == 'returnb')
    end)

end)