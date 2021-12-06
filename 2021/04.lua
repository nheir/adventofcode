local part = 2
local seq = {}

local cards = {}

for d in io.read('l'):gmatch("%d+") do seq[#seq+1] = tonumber(d) end

io.read('l')

local cur = {}
for l in io.lines() do
	if #cur == 5 then
		cards[#cards+1] = cur
		cur = {}
	else
		cur[#cur+1] =  {}
		for d in l:gmatch('%d+') do table.insert(cur[#cur], tonumber(d)) end
	end
end
if #cur > 0 then
	cards[#cards+1] = cur
end

local function all(pred, t)
	for _,v in ipairs(t) do
		if not pred(v) then
			return false
		end
	end
	return true
end

local function marked(v)
	return v == 'X'
end

local function bingo_col(t,i)
	for j=1,5 do
		if not marked(t[j][i]) then
			return false
		end
	end
	return true
end

local set = {}
local remain = #cards

local function found(card,v)
	if set[card] then return end
	set[card] = true
	local sum = 0
	for i=1,5 do
		for j=1,5 do
			if card[i][j] ~= 'X' then
				sum = sum + card[i][j]
			end
		end
	end
	remain = remain - 1
	if part == 1 or remain == 0 then
		print(sum*v)
		os.exit(0)
	end
end

for _,d in ipairs(seq) do
	for _,card in ipairs(cards) do
		for _,c in ipairs(card) do
			for i,v in ipairs(c) do
				if v == d then
					c[i] = 'X'
				end
			end
		end
		if not set[card] then
			for i=1,5 do
				if all(marked, card[i]) or bingo_col(card,i) then
					found(card, d)
				end
			end
		end
	end
end
