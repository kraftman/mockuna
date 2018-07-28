
local mockable = require 'test.mockable'
local mockuna = require 'mockuna.mockuna'

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

    it('it throws when method doesnt exist', function()
        local mockFunction = function() return 'mocked' end
        local erroringFunction = function()
            mockuna:mock(mockable, 'nonExistant', mockFunction) 
        end
        local _, err = pcall(erroringFunction)

        assert(err:find('class does not have method: nonExistant'))
    end)
    it('it throws when method doesnt exist', function()
        local mockFunction = function() return 'mocked' end
        local erroringFunction = function()
            mockuna:mock(mockable, 'test', mockFunction)
        end

        local _, err = pcall(erroringFunction)

        assert(err:find('already mocked'))
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
        assert(newMock.calledThrice == false)
        mockable.test()
        assert(newMock.callCount == 2)
        assert(newMock.calledOnce == false)
        assert(newMock.calledTwice)
        assert(newMock.calledThrice == false)
        mockable.test()
        assert(newMock.callCount == 3)
        assert(newMock.calledOnce == false)
        assert(newMock.calledTwice == false)
        assert(newMock.calledThrice == true)
    end)

    it('handles notcalledCorrectly', function()
        assert(newMock.notCalled == true)
        mockable.test()
        assert(newMock.notCalled == false)
        mockable.test:reset()
        assert(newMock.notCalled == true)
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
