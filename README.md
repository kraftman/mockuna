# mockuna
[![Build Status](https://travis-ci.org/kraftman/mockuna.svg?branch=master)](https://travis-ci.org/kraftman/mokuna) [![codecov](https://codecov.io/gh/kraftman/mockuna/branch/master/graph/badge.svg)](https://codecov.io/gh/kraftman/mockuna)

Lua mocking framework based on [sinon](http://sinonjs.org/)

##Usage
Basic busted example:

```lua
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
end)

```
