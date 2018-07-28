

local mockable = require '../lib/mockable'
local mockuna = require '../lib/mockuna'

describe('test', function()
    local newMock
    before_each(function()
        local mockFunction = function() return 'mocked' end
        newMock = mockuna:mock(mockable, 'test', mockFunction)
    end)

    after_each(function()
        newMock:restore();
    end)

    it('it mocks out a method', function()
        local result = mockable.test()
        assert(result == 'mocked')
    end)

    it('it restores a mocked method', function()
        local result = mockable.test()
        assert(result == 'mocked')
        newMock:restore();
        result = mockable.test()
        assert(result == 'not mocked')
    end)

    it('returns the correct callCount', function()
        local result = mockable.test()
        assert(result == 'mocked')
        assert(newMock.callCount == 1)
        assert(newMock.calledOnce)
        assert(newMock.calledTwice == false)
        mockable.test()
        assert(newMock.callCount == 2)
        assert(newMock.calledOnce == false)
        assert(newMock.calledTwice)
    end)

    it('resets correctly', function()
        local result = mockable.test()
        assert(result == 'mocked')
        assert(newMock.called)
        assert(newMock.callCount == 1)
        assert(newMock.calledOnce)
        assert(newMock.calledTwice == false)
        newMock:reset()

        assert(newMock.called == false)
        assert(newMock.callCount == 0)
        assert(newMock.calledOnce == false)
        assert(newMock.calledTwice == false)
    end)

    it('it returns a different mocks based on the arguments', function()
        mockable.test('this')
        assert(mockable.test.args[1][1] == 'this')
        mockable.test('that')
        assert(mockable.test.args[2][1] == 'that')
        mockable.test('this1', 'this2', 'this3')
        assert(mockable.test.args[1][1] == 'this')
        assert(mockable.test.args[2][1] == 'that')
        assert(mockable.test.args[3][2] == 'this2')
        assert(mockable.test.args[3][3] == 'this3')
    end)
end)

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

    it('tests calledBefore', function()
        assert(mock1:calledBefore(mock2) == false)
        mockable.test()
        mockable.test2()
        assert(mock1:calledBefore(mock2) == true)
        mockuna:reset()
        assert(mock1:calledBefore(mock2) == false)
    end)

    it('tests calledAfter', function() 
        assert(mock1:calledAfter(mock2) == false)
        mockable.test2()
        mockable.test()
        assert(mock1:calledAfter(mock2) == true)
        mockuna:reset()
        assert(mock1:calledAfter(mock2) == false)
    end)

    it('tests calledImmediatelyBefore false', function()
        assert(mock1:calledImmediatelyBefore(mock3) == false)
        mockable.test()
        mockable.test2()
        mockable.test3()
        assert(mock1:calledImmediatelyBefore(mock3) == false)
        mockuna:reset()
        assert(mock1:calledImmediatelyBefore(mock3) == false)
    end)

    it('tests calledImmediatelyBefore true', function()
        assert(mock1:calledImmediatelyBefore(mock3) == false)
        mockable.test()
        mockable.test3()
        assert(mock1:calledImmediatelyBefore(mock3) == true)
        mockuna:reset()
        assert(mock1:calledImmediatelyBefore(mock3) == false)
    end)

    it('tests calledImmediatelyAfter false', function()
        assert(mock1:calledImmediatelyAfter(mock3) == false)
        mockable.test3()
        mockable.test2()
        mockable.test()
        assert(mock1:calledImmediatelyAfter(mock3) == false)
        mockuna:reset()
        assert(mock1:calledImmediatelyAfter(mock3) == false)
    end)

    it('tests calledImmediatelyAfter true', function()
        assert(mock1:calledImmediatelyAfter(mock3) == false)
        mockable.test3()
        mockable.test()
        assert(mock1:calledImmediatelyAfter(mock3) == true)
        mockuna:reset()
        assert(mock1:calledImmediatelyAfter(mock3) == false)
    end)

    it('test calledWith false', function()
        mockable.test('tast')
        assert(mockable.test:calledWith('test') == false)
    end)

    it('test calledWith true', function()
        mockable.test('test')
        assert(mockable.test:calledWith('test'))
    end)

    it('test calledWith multiple', function()
        mockable.test('test1', 'test2')
        assert(mockable.test:calledWith('test1', 'test2'))
    end)

    it('test calledWithExactly true', function()
        mockable.test('test1', 'test2')
        assert(mockable.test:calledWithExactly('test1', 'test2'))
    end)

    it('test calledWithExactly false', function()
        mockable.test('test1', 'test2')
        assert(mockable.test:calledWithExactly('test1') == false)
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