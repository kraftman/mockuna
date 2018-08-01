

local mockable = require 'test.mockable'
local mockuna = require 'mockuna.mockuna'

describe('spy tests', function()
    local mock1, mock2
    before_each(function()
      mock1 = mockuna:spy(mockable, 'test')
      mock2 = mockuna:spy(mockable, 'throwsException')
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
      local result, err = pcall(function() return mockable.throwsException() end)
      local errMessage = 'this is exceptional!'
      assert(err:find(errMessage))
      assert(mock2:threw() == true)
      assert(mock2:threw(errMessage) == true)
      assert(mock2:threw('not thrown') == false)
    end)

    it('returns false if stub didnt throw', function()
      mockable.test()
      assert(mock1.callCount == 1)
      assert(mock1:threw() == false)
    end)

    it('returns exceptions', function()
      assert(mock2:threw() == false)
      local result, err = pcall(function() return mockable.throwsException() end)
      local errMessage = 'this is exceptional!'
      assert(mock2.exceptions[1]:find(errMessage))
      assert(mock2.exceptions[2] == nil)
      result, err = pcall(function() return mockable.throwsException() end)
      assert(mock2.exceptions[2]:find(errMessage))
    end)

    it('always throws ', function()
      -- TODO add a negative case for this
      assert(mock2:threw() == false)
      local result, err = pcall(function() return mockable.throwsException() end)
      result, err = pcall(function() return mockable.throwsException() end)
      assert(mock2.callCount == 2)
      assert(mock2:alwaysThrew('this is exceptional!'))
    end)
end)