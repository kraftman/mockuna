

local mockable = require 'test.mockable'
local mockuna = require 'mockuna.mockuna'

describe('Tests ordering of mocks', function()
  local mock1, mock2, mock3
  before_each(function()
    local mockFunction = function() return 'mocked' end
    local mockFunction2 = function() return 'mocked', 'here' end
    mock1 = mockuna:spy(mockable, 'test', mockFunction)
    mock2 = mockuna:spy(mockable, 'test2', mockFunction2)
    mock3 = mockuna:spy(mockable, 'test3', mockFunction)
  end)

  after_each(function()
    mock1:restore();
    mock2:restore();
    mock3:restore();
  end)

  it('records the return value', function()
    mockable.test()
    assert(mockable.test:returned('not mocked'))
  end)

  it('records the return value false', function()
    mockable.test()
    assert(mockable.test:returned('not mockeds') == false)
  end)

  it('records multiple return values', function()
    mockable.test2()
    assert(mockable.test2:returned('not mocked 2', 'not mocked 2a'))
  end)

  it('tests alwaysReturned true', function()
    mockable.test2()
    assert(mockable.test2:alwaysReturned('not mocked 2', 'not mocked 2a'))
  end)

  it('records the exact return value false', function()
    mockable.test2()
    assert(mockable.test2:returnedExactly('not mocked 2') == false)
  end)

  it('records the exact return value true', function()
    mockable.test()
    assert(mockable.test:returnedExactly('not mocked'))
  end)

  it('always returned exactly false', function()
    mockable.test2()
    assert(mockable.test2:alwaysReturnedExactly('not mocked 2') == false)
  end)

  it('always returned exactly true', function()
    mockable.test()
    assert(mockable.test:alwaysReturnedExactly('not mocked'))
  end)

  it('returns the return values', function()
    mockable.test()
    mockable.test()
    local returnValues = mock1.returnValues
    assert(mock1.callCount == 2)
    assert(returnValues[1][1] == 'not mocked')
  end)

end)