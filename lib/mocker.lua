

local mocker = {}

-- TODO
-- create a standalone mock that can be extended 

local createMock = function(parent, originalName, originalFunction, newFunction)
  local mock = {}
  mock.callCount = 0
  mock.__originalParent = parent
  mock.__originalFunction = originalFunction
  mock.__originalName = originalName
  function mock:restore()
    self.__originalParent[self.__originalName] = self.__originalFunction
  end

  function mock:reset()
    self.callCount = 0
    self.calledWith = {}
    self.args = {}
  end

  setmetatable(mock, {
    __call = newFunction
  })
  return mock
end

-- function mocker:mock(moduleName)
--   --local original = require(moduleName)

--   local fake = {

--   }
--   fake.__index = fake
--   function fake:Mock(functionName, returnValues)
--     if type(returnValues) == 'function' then
--       self[functionName] = returnValues
--     else
--       self[functionName] = function(...)
--         return returnValues
--       end
--     end
--   end

--   --fake.original = original
--   package.loaded[moduleName] = fake

--   return fake
-- end

function mocker:mock(parent, methodName, stubFunction)
  local originalFunction = parent[methodName]
  if not originalFunction then
    return error('class does not have method: '..methodName)
  end
  local mock = createMock(parent, methodName, originalFunction, stubFunction)
  parent[methodName] = mock
end

return mocker
