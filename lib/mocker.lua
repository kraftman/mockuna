

local mocker = {}
local call = require './call'

-- TODO
-- create a standalone mock that can be extended

local allCalls = {}

local utils = {}

utils.calledOnce = function(mock)
  return mock.callCount == 1
end

utils.calledTwice = function(mock)
  return mock.callCount == 2
end

utils.calledThrice = function(mock)
  return mock.callCount == 3
end

utils.called = function(mock)
  return mock.callCount > 0
end

utils.notCalled = function(mock)
  return mock.callCount == 0
end

utils.firstCall = function(mock)
  return mock.calls[1]
end

utils.secondCall = function(mock)
  return mock.calls[2]
end

utils.thirdCall = function(mock)
  return mock.calls[3]
end

utils.lastCall = function(mock)
  return mock.calls[#mock.calls]
end

local function findMockPairs(mock, otherMock)
  local firstFoundAt, secondFoundAt
  for i = 1, #allCalls do
    if allCalls[i] == mock then
      firstFoundAt = i
    elseif allCalls[i] == otherMock then
      secondFoundAt = i
    end
  end
  return firstFoundAt, secondFoundAt
end

utils.calledBefore = function(mock, otherMock)
  local firstFoundAt, secondFoundAt = findMockPairs(mock, otherMock)
  return firstFoundAt < secondFoundAt
end

utils.calledImmediatelyBefore = function(mock, otherMock) 
  local firstFoundAt, secondFoundAt = findMockPairs(mock, otherMock)
  if firstFoundAt + secondFoundAt == 0 then
    return false
  end
  return firstFoundAt - secondFoundAt == 1
end

utils.calledImmediatelyAfter = function(mock, otherMock) 
  local firstFoundAt, secondFoundAt = findMockPairs(mock, otherMock)
  if firstFoundAt + secondFoundAt == 0 then
    return false
  end
  return secondFoundAt - firstFoundAt == 1
end

utils.calledAfter = function(mock, otherMock) 
  local firstFoundAt, secondFoundAt = findMockPairs(mock, otherMock)
  return firstFoundAt > secondFoundAt
end

local mockBase = {}

function mockBase:__index(key, ...)
  if utils[key] then
    return utils[key](self, ...)
  end
  print(self)
  return rawget(self, key)
end

function mockBase:__call(...)
  self.callCount = self.callCount + 1
  -- add to args
  -- add to global called with
  -- add to count called with, e.g. call(2).calledWith
  local newCall = call:new(...)
  table.insert(self.args, newCall.args)
  table.insert(self.calls, newCall)
  table.insert(allCalls, self)
  if self.__newFunction then
    return self.__newFunction(...)
  else
    return
  end
end

function mockBase:reset()
  self.callCount = 0
  self.args = {}
  self.calls = {}
end

local createMock = function(parent, originalName, originalFunction, newFunction)
  local mock = setmetatable({}, mockBase)
  mock.callCount = 0
  mock.__originalParent = parent
  mock.__originalFunction = originalFunction
  mock.__originalName = originalName
  mock.__newFunction = newFunction
  mock.__type = 'mock'
  function mock:restore()
    self.__originalParent[self.__originalName] = self.__originalFunction
  end

  function mock:reset()
    self.callCount = 0
    self.calledWith = {}
    self.args = {}
  end

  return mock
end

function mocker:mock(parent, methodName, stubFunction)
  local originalFunction = parent[methodName]
  if not originalFunction then
    return error('class does not have method: '..methodName)
  end
  if type(originalFunction) == 'table' and originalFunction.__type == 'mock' then
    error('already mocked')
  end
  local mock = createMock(parent, methodName, originalFunction, stubFunction)
  parent[methodName] = mock
  return mock
end

function mocker:reset()
  allCalls = {}
end

return mocker
