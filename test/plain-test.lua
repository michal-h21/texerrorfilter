-- Pokus s testováním v čistý Lua
--
--
--
local tests = {}
local context = nil
local current_test = nil

local function print_test(tests, status, failed)
  print(string.format("%i..%i", 1, #tests))
  for k,v in ipairs(tests) do
    local status_msg = v.status and "ok" or "not ok"
    print(string.format("%s %i - %s",status_msg,k, v.name))
  end
end

local function test_finish()
  local failed = 0
  local new_tests = {}
  for _, v in ipairs(tests) do
    if not v.status then
      failed = failed + 1
    end
  end
  local status = (failed == 0) and true or false
  print_test(tests, status, failed)
end

  

-- just make some logical comparisons as the argument
local function Assert(x)
  local status, msg = pcall(function() return assert(x)  end)
  local test_obj = {
    status = status,
    msg = msg,
  }
  -- table.insert(tests, test_obj)
  if not current_test then
    error("You must call Assert inside `It` block")
  end
  current_test.status = current_test.status and status
  table.insert(current_test.tests, test_obj)
  if not status then test_finish() end
  return status, msg
end

-- 
local function Context(msg)
  context = msg
  current_test = nil
end


local function Describe(msg)
  Context(msg)
end

local function It(name)
  current_test = {
    context = context,
    name = name, 
    status = true,
    tests = {}
  }
  table.insert(tests, current_test)
end

do Describe "Začněme test"
  do It "První otázky"
   Assert(2<3)
   Assert(2>3)
  end
end

test_finish()
