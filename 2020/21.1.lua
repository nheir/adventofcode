local t = {}

local function split(l,p)
	local i,j,m = l:find('(' .. p .. ')')
	if m then return m, split(l:sub(j+1),p) end
end

local function a2s(t)
	local s = {}
	for _,k in ipairs(t) do
		s[k] = true
	end
	return s
end

local function s2a(s)
	local t = {}
	for k in pairs(s) do
		table.insert(t, k)
	end
	return t
end

local all_ings = {}
local count = {}
local tab = {}
for l in io.lines() do
	local ings, alerg = l:match('([%w ]+) %(contains ([%w, ]+)%)')
	ings = a2s{split(ings, '%w+')}
	for k in pairs(ings) do
		all_ings[k] = true
		count[k] = (count[k] or 0) + 1
	end
	alerg = a2s{split(alerg, '%w+')}
	for a in pairs(alerg) do
		if tab[a] then
			for i in pairs(tab[a]) do
				tab[a][i] = ings[i]
			end
		else
			tab[a] = {}
			for i in pairs(ings) do
				tab[a][i] = true
			end
		end
	end
end

local ings = s2a(tab)
local tail = {}
for k,s in pairs(tab) do tail[k] = #s2a(s) end
table.sort(ings, function (a,b) return tail[a] < tail[b] end)

local corr = {}
local function walk(name)
	if tail[name] == 1 then
		local ing = next(tab[name])
		corr[ing] = name
		all_ings[ing] = nil
		for k,v in pairs(tab) do
			if v[ing] then
				v[ing] = nil
				tail[k] = tail[k] - 1
				if tail[k] == 1 then
					walk(k)
				end
			end
		end
	end
end

walk(ings[1])

if arg[0] == '21.1.lua' then
	local ret = 0
	for k in pairs(all_ings) do
		ret = ret + count[k]
	end
	print(ret)
elseif arg[0] == '21.2.lua' then

local function sort(...)
	table.sort(...)
	return ...
end
	print(
		table.concat(
			sort(
				s2a(corr),
				function (a,b) return corr[a] < corr[b]
				end
			),
			','
		)
	)
end
