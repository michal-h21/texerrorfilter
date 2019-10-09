local m = {}

local function get_filename(chunk)
  local filename = chunk:match("([^\n]+)")
  local first = filename:match("^[%./\\]+")
  if first then return filename end
  return false
end

local function get_chunks(text)
  local chunks = {}
  local newtext = text:gsub("(%b())", function(a)
    local chunk = string.sub(a,2,-2)
    local filename = get_filename(chunk) 
    if not filename then return a end
    local children, text = get_chunks(chunk)
    table.insert(chunks, {filename = filename, text = text, children = children})
    return ""
  end)
  return chunks, newtext 
end


function print_chunks(chunks, level)
  local level = level or 0
  local indent = string.rep("  ", level)
  for k,v in ipairs(chunks) do
    print(indent .. v.filename, string.len(v.text))
    print_chunks(v.children, level + 1)
  end
end

local function parse_errors(text) 
  local lines = {}
  local errors = {}
  local find_line_no = false
  local error_lines = {}
  for line in text:gmatch("([^\n]+)") do
    lines[#lines+1] = line
  end
  for i = 1, #lines do 
    local line = lines[i]
    local err = line:match("^!(.+)")
    local lineno = line:match("^l%.([0-9]+)")
    if err then 
      errors[#errors+1] = err 
      -- we didn't find error line number since previous error, insert 
      if find_line_no then
        error_lines[#error_lines+1] = false
      end
      find_line_no = true
    elseif lineno then
      find_line_no = false
      error_lines[#error_lines+1] = tonumber(lineno)
    end
    i = i + 1
  end
  return errors, error_lines
end


local function get_errors(chunks, errors)
  local errors =  errors or {}
  for _, v in ipairs(chunks) do
    local current_errors, error_lines = parse_errors(v.text)
    for i, err in ipairs(current_errors) do
      table.insert(errors, {filename = v.filename, error = err, line = error_lines[i] })
    end
    errors = get_errors(v.children, errors)
  end
  return errors
end


function m.parse(log)
  local chunks, newtext = get_chunks(log)
  -- save the unparsed text that contains system messages
  table.insert(chunks, {filename = "system", text = newtext, children = {}})
  print_chunks(chunks)
  local errors = get_errors(chunks)
  for _,v in ipairs(errors) do 
    print("error", v.filename, v.line, v.error)
  end
  return errors, chunks 
end



return m
