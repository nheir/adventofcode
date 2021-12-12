local function class(t)
	local mt = { __index = t }
	return function (...)
		local this = setmetatable({}, t)
		return t.new and t.new(this, ...) or this
	end
end

local DefaultTable = class {
	new = function (self, fn)
		self._default = fn
	end,
	__index = function (t, k)
		t[k] = t._default()
		return t[k]
	end,
}

local timer = (require "timer")()

local t = DefaultTable(function () return {} end)

for l in io.lines() do
	local a,b = l:match("([^-]+)%-([^-]+)")
	table.insert(t[a],b)
	table.insert(t[b],a)
end

local small = {}
for a in pairs(t) do
	if a:match('^[a-z]+$') then
		small[a] = true
	end
end
timer:log("Read graph")

local function dfs(a, marked)
	if marked[a] then return 0 end
	if a == 'end' then return 1 end
	marked[a] = small[a]
	local r = 0
	for _,n in pairs(t[a]) do
		r = r + dfs(n, marked)
	end
	marked[a] = nil
	return r
end

print(dfs('start', {}))
timer:log("DFS with 0 repetition")

local function dfs2(a, marked, once)
	if marked[a] and (once or a == 'start') then
		return 0
	end
	if a == 'end' then return 1 end
	if marked[a] then
		once = true
	end
	if small[a] then
		marked[a] = (marked[a] or 0) + 1
	end
	local r = 0
	for _,n in pairs(t[a]) do
		r = r + dfs2(n, marked, once)
	end
	if small[a] then
		marked[a] = marked[a] - 1
		if marked[a] == 0 then
			marked[a] = nil
		end
	end
	return r
end

print(dfs2('start', {}, false))
timer:log("DFS with 0 or 1 repetition")