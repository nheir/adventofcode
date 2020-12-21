local function get_tokens(l)
  local tokens = {}
  local i = 1
  while i <= #l do
    if l:sub(i,i) == ' ' then
      i = i + 1
    elseif l:gmatch('^[()+*]',i) then
      table.insert(tokens, l:sub(i,i))
      i = i + 1
    else -- number
      local a,b,n = l:find('^(%d+)',i)
      table.insert(tokens, tonumber(n))
      i = b + 1
    end
  end
  return tokens
end

local parse_expr, parse_term
-- expr: term {(+|*) term}
function parse_expr(tokens, i)
  local ret, i = parse_term(tokens, i)
  local ret_term
  while tokens[i] == '*' or tokens[i] == '+' do
    local op = tokens[i]
    ret_term, i = parse_term(tokens, i+1)
    if op == '*' then ret = ret*ret_term end
    if op == '+' then ret = ret+ret_term end
  end
  return ret, i
end

-- term: number
-- term: ( expr )
function parse_term(tokens, i)
  if tokens[i] == '(' then
    local ret, i = parse_expr(tokens, i+1)
    return ret, i+1
  else
    return tokens[i], i+1
  end
end

local t = 0
for l in io.lines() do
  local ret = parse_expr(get_tokens(l),1)
  t = t + ret
end

print(t)
