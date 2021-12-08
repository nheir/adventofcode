local t = {}

local uniq = {[2]=true, [4]=true, [3]=true, [7]=true}

local r = 0
for l in io.lines() do
  local prev, out = l:match('(.+)%|(.+)')
  if out then
    t[#t+1] = {prev, out}
    for w in out:gmatch("%S+") do
      if uniq[#w] then
        r = r + 1
      end
    end
  end
end
print(r)

local function splitchar(s)
	local t = {}
	for c in s:gmatch('.') do
		t[#t+1] = c
	end
	return t
end

local function split(s)
	local t = {}
	for c in s:gmatch('%S+') do
		t[#t+1] = c
	end
	return t
end

local function wiretobit(s) 
  local r = 0
  for c=1,#s do
    r = r | (1 << (string.byte(s,c) - string.byte('a')))
  end
  return r
end

local function countbit(n)
  local r = 0
  while n > 0 do
    if n & 1 == 1 then r = r + 1 end
    n = n >> 1
  end
  return r
end

local ret = 0
for i in ipairs(t) do
  local pat, out = table.unpack(t[i])
  pat = split(pat)
  out = split(out)
  local mapping = {}
  local done = {}
  for i=1,#pat do
    done[i] = true
    if #pat[i] == 2 then
      mapping[1] = i 
    elseif #pat[i] == 3 then
      mapping[7] = i 
    elseif #pat[i] == 4 then
      mapping[4] = i 
    elseif #pat[i] == 7 then
      mapping[8] = i 
    else
      done[i] = false
    end
  end
  for i=1,#pat do
    pat[i] = wiretobit(pat[i])
  end
  for i=1,#out do
    out[i] = wiretobit(out[i])
  end
  -- 0/6/9
  for i=1,#pat do
    if countbit(pat[i]) == 6 then
      if countbit(pat[i] & pat[mapping[1]]) == 1 then
        mapping[6] = i
      elseif pat[i] & pat[mapping[4]] == pat[mapping[4]] then
        mapping[9] = i
      else
        mapping[0] = i
      end
      done[i] = true
    end
  end
  -- 3
  for i=1,#pat do
    if not done[i] then
      if countbit(pat[i] & pat[mapping[1]]) == 2 then
        mapping[3] = i
        done[i] = true
      end
    end
  end
  -- 2/5
  for i=1,#pat do
    if not done[i] then
      if pat[i] & pat[mapping[6]] == pat[i] then
        mapping[5] = i
      else
        mapping[2] = i
      end
      done[i] = true
    end
  end
  local rev = {}
  for i=0,9 do
    rev[pat[mapping[i]]] = i
  end
  local v = 0
  for i,d in ipairs(out) do
    v = v*10 + rev[d]
  end
  ret = ret + v
end

print(ret)
