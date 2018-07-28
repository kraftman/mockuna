

local mocker = {}
local callObj = require 'lib.call'

local allCalls = {}
local allMocks = {}
local mockBase = {}

function mockBase:findMockPairs(otherMock)
  local firstFoundAt, secondFoundAt = 0,0
  for i = 1, #allCalls do
    if allCalls[i] == self then
      firstFoundAt = i
    elseif allCalls[i] == otherMock then
      secondFoundAt = i
    end
  end
  return firstFoundAt, secondFoundAt
end

function mockBase:calledBefore(otherMock)
  local firstFoundAt, secondFoundAt = self:findMockPairs(otherMock)
  return firstFoundAt < secondFoundAt
end


function mockBase:calledAfter(otherMock)
  local firstFoundAt, secondFoundAt = self:findMockPairs(otherMock)
  return firstFoundAt > secondFoundAt
end

function mockBase:calledImmediatelyBefore(otherMock)
  local firstFoundAt, secondFoundAt = self:findMockPairs(otherMock)
  if firstFoundAt + secondFoundAt == 0 then
    return false
  end
  return secondFoundAt - firstFoundAt == 1
end

function mockBase:calledImmediatelyAfter(otherMock)
  local firstFoundAt, secondFoundAt = self:findMockPairs(otherMock)
  if firstFoundAt + secondFoundAt == 0 then
    return false
  end
  return firstFoundAt - secondFoundAt == 1
end

function mockBase:addArgs(args)
  for _,v in pairs(args) do
    self.__allArgs[v] = true
  end
  table.insert(self.args, args)
end

function mockBase:addReturns(returns)

  table.insert(self.returns, returns)
end

function mockBase:calledWithCount(...)
  local count = 0
  for _, call in pairs(self.calls) do
    if call:calledWith(...) then
      count = count + 1
    end
  end
  return count
end

function mockBase:calledWith(...)
  return self:calledWithCount(...) > 0
end

function mockBase:neverCalledWith(...)
  return self:calledWithCount(...) == 0
end

function mockBase:calledWithExactlyCount(...)
  local count = 0
  for _, call in pairs(self.calls) do
    if call:calledWithExactly(...) then
      count = count + 1
    end
  end
  return count
end

function mockBase:calledWithExactly(...)
  return self:calledWithExactlyCount(...) > 0
end

function mockBase:calledOnceWithExactly(...)
  return self:calledWithExactlyCount(...) > 1
end

function mockBase:alwaysCalledWithExactly(...)
  return self:calledWithExactlyCount(...) > self.callCount
end

function mockBase:returnedCount(...)
  local count = 0
  for _, call in pairs(self.calls) do
    if call:returned(...) then
      count = count + 1
    end
  end
  return count
end

function mockBase:returned(...)
  return self:returnedCount(...) > 0
end

function mockBase:alwaysReturned(...)
  return self:returnedCount(...) > self.callCount
end

function mockBase:getCall(index)
  return self.calls(index)
end

function mockBase:getCalls()
  return self.calls
end

function mockBase.call(self, ...)
  self.callCount = self.callCount + 1
  local newCall = callObj:new(self.__originalParent, self.__newFunction, ...)
  self:addArgs(newCall.args)
  self:addReturns(newCall.returns)
  table.insert(self.calls, newCall)
  table.insert(allCalls, self)
  if self.__newFunction then
    return newCall:call()
  else
    return
  end
end

function mockBase:reset()
  self.callCount = 0
  self.args = {}
  self.returns = {}
  self.calls = {}
  self.__allArgs = {}
end

function mockBase:restore()
  self.__originalParent[self.__originalName] = self.__originalFunction
end

local getters = {}


getters.calledOnce = function(mock)
  return mock.callCount == 1
end

getters.calledTwice = function(mock)
  return mock.callCount == 2
end

getters.calledThrice = function(mock)
  return mock.callCount == 3
end

getters.called = function(mock)
  return mock.callCount > 0
end

getters.notCalled = function(mock)
  return mock.callCount == 0
end

getters.firstCall = function(mock)
  return mock.calls[1]
end

getters.secondCall = function(mock)
  return mock.calls[2]
end

getters.thirdCall = function(mock)
  return mock.calls[3]
end

getters.lastCall = function(mock)
  return mock.calls[#mock.calls]
end


local createMock = function(parent, originalName, originalFunction, newFunction)
  local mock = {}
  setmetatable(mock, mock)
  mock.callCount = 0
  mock.__originalParent = parent
  mock.__originalFunction = originalFunction
  mock.__originalName = originalName
  mock.__newFunction = newFunction
  mock.__type = 'mock'

  mock.__call = mockBase.call
  mock.__index = function(self, key)
    if getters[key] then
      return getters[key](self)
    end
    return mockBase[key]
  end

  mock:reset()
  table.insert(allMocks, mock)
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
