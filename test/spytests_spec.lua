

local mockable = require 'test.mockable'
local mockuna = require 'mockuna.mockuna'

describe('spy tests', function()
    local mock1, mock2
    before_each(function()
      mock1 = mockuna:spy(mockable, 'test')
      mock2 = mockuna:spy(mockable, 'test4')
    end)

    after_each(function()
        mock1:restore();
        mock2:restore();
    end)

    it('returns an empty spy', function()
        local spy = mockuna:spy()
        assert(spy.callCount == 0)
        local result = spy()
        assert(result == nil)
        assert(spy.callCount == 1)
    end)

    it('tracks exceptions', function()
      local result, err = pcall(function() return mockable.test4() end)
      local errMessage = 'this is exceptional!'
      assert(err:find(errMessage))
      assert(mock2:threw() == true)
      assert(mock2:threw(errMessage) == true)
      assert(mock2:threw('not thrown') == false)
    end)

end)