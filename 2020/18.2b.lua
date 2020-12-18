local function pushToken(tok, val)
  --print(tok,string.format('%q',val))
  coroutine.yield(tok, val)
end

local lexer = coroutine.create(function ()
  local state = 0
  local val = nil
  repeat
    local c = io.read(1)
    if not c then
      if state ~= 0 then
        pushToken(state,val)
      end
    elseif c:match('%d') then
      if state == 1 then
        val = 10*val + tonumber(c)
      else
        if state ~= 0 then
          pushToken(state,val)
        end
        state = 1
        val = tonumber(c)
      end
    elseif c:match('[\n()+*]') then
      if state ~= 0 then
        pushToken(state,val)
      end
      pushToken(2,c)
      state = 0
    else -- if c in (' ','\r','\t') then
      if state ~= 0 then
        pushToken(state,val)
      end
      state = 0
    end
  until not c
  pushToken(3, c)
end)

local function parse_error(msg)
  print("error:", msg)
  os.exit(1)
end

local function getToken()
  local t, tok, val = coroutine.resume(lexer)
  if false then parse_error(tok) end
  return { id=tok, val=val }
end

local function isEnd()
  return not io.read(0)
end

-- start -> {expr \n}+ EOF
local function parse_start()
  local att = 0
  repeat
    local tree, next_lexem = parse_expr()
    if next_lexem.id ~= 2 or next_lexem.val ~= '\n' then parse_error("newline expected") end
    att = att + tree
  until isEnd()
  return att
end

-- expr -> term {* term}
-- expr -> term
function parse_expr()
  local tree, next_lexem = parse_term()
  while next_lexem.id == 2 and next_lexem.val == '*' do
    local tree2
    tree2, next_lexem = parse_term()
    tree = tree * tree2
  end
  return tree, next_lexem
end

-- term -> factor {+ factor}
-- term -> factor
function parse_term()
  local tree, next_lexem = parse_factor()
  while next_lexem.id == 2 and next_lexem.val == '+' do
    local tree2
    tree2, next_lexem = parse_factor(stream)
    tree = tree + tree2
  end
  return tree, next_lexem
end

-- factor -> number
-- factor -> ( expr )
function parse_factor()
  local lexem = getToken()
  if lexem.id == 1 then
    return lexem.val, getToken()
  elseif lexem.id == 2 and lexem.val == '(' then
    local tree, next_lexem = parse_expr()
    if next_lexem.id ~= 2 or next_lexem.val ~= ')' then
      parse_error(') expected')
    end
    return tree, getToken()
  end
  parse_error("number or ( expected")
end

print(parse_start())