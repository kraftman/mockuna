
local mockable = require 'lib.mockable'

describe('tests mockable', function()
    it('tests test2', function()
        assert(mockable.test2() == 'not mocked 2')
    end)

    it('tests test3', function()
        assert(mockable.test3() == 'not mocked 3')
    end)
end)