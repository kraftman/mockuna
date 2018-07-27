

local mockable = require '../lib/mockable'
local mocker = require '../lib/mocker'

describe('test', function()
    local newMock
    before_each(function()
        local mockFunction = function() return 'mocked' end
        newMock = mocker:mock(mockable, 'test', mockFunction)
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

    end)

    it('returns different mocks based on the call count', function()

    end)
end)
