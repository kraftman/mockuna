

local mockable = require '../lib/mockable'
local mocker = require '../lib/mocker'


describe('test', function()
    it('it mocks out a method', function() 
        mocker:mock(mockable, 'test', function() return 'mocked' end)
        local result = mockable.test()
        print(result)
        assert(result == 'mocked')
    end)

    it('it restores a mocked method', function()
    
    end)

    it('it returns a different mocks based on the arguements', function()
    
    end)

    it('returns different mocks based on the call count', function()
    
    end)
end)
