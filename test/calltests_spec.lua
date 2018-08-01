
local mockable = require 'test.mockable'
local mockuna = require 'mockuna.mockuna'

describe('Tests ordering of mocks', function()
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

    it('test neverCalledWith true', function()
        mockable.test('test')
        assert(mockable.test:neverCalledWith('tester'))
    end)

    it('test neverCalledWith false', function()
        mockable.test('test')
        assert(mockable.test:neverCalledWith('test') == false)
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

    it('test alwaysCalledWithExactly true', function()
        mockable.test('test1')
        mockable.test('test1')
        assert(mockable.test:alwaysCalledWithExactly('test1') == true)
    end)

    it('test alwaysCalledWithExactly false', function()
        mockable.test('test1')
        mockable.test('test2')
        assert(mockable.test:alwaysCalledWithExactly('test1') == false)
    end)

    it('test calledOnceWithExactly false', function()
        mockable.test('test1')
        mockable.test('test1')
        assert(mockable.test:calledOnceWithExactly('test1') == false)
    end)

    it('test calledOnceWithExactly true', function()
        mockable.test('test1')
        mockable.test('test2')
        assert(mockable.test:calledOnceWithExactly('test1') == true)
    end)

    it('tests getCall', function()
        mockable.test('test1')
        mockable.test('test2')
        local secondCall = mockable.test:getCall(2);
        assert(secondCall.args[1] == 'test2')
    end)

    it('tests getCalls', function()
        mockable.test('test1')
        mockable.test('test2')
        local allCalls = mockable.test:getCalls();
        assert(allCalls[1].args[1] == 'test1')
        assert(allCalls[2].args[1] == 'test2')
    end)

    it('tests firstCall', function()
        mockable.test('test1')
        local firstCall = mockable.test.firstCall;
        assert(firstCall.args[1] == 'test1')
    end)

    it('tests secondCall', function()
        mockable.test('test1')
        mockable.test('test2')
        local secondCall = mockable.test.secondCall;
        assert(secondCall.args[1] == 'test2')
    end)

    it('tests thirdCall', function()
        mockable.test('test1')
        mockable.test('test2')
        mockable.test('test3')
        local thirdCall = mockable.test.thirdCall;
        assert(thirdCall.args[1] == 'test3')
    end)

    it('tests lastCall', function()
        mockable.test('test1')
        local lastCall = mockable.test.lastCall;
        assert(lastCall.args[1] == 'test1')

        mockable.test('test2')
        lastCall = mockable.test.lastCall;
        assert(lastCall.args[1] == 'test2')

        local result = mockable.test('test3')
        lastCall = mockable.test.lastCall;
        assert(lastCall.args[1] == 'test3')
    end)
end)