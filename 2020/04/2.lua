local t = {}

local ecl = {
	amb=true,
	blu=true,
	brn=true,
	gry=true,
	grn=true,
	hzl=true,
	oth=true,
}
local keys = {
	byr=function (a) a = tonumber(a) return 1920 <= a and a <= 2002 end,
	iyr=function (a) a = tonumber(a) return 2010 <= a and a <= 2020 end,
	eyr=function (a) a = tonumber(a) return 2020 <= a and a <= 2030 end,
	hgt=function (a) local v,u = a:match('^(%d+)(%w+)$') if u == 'in' then return 59 <= tonumber(v) and tonumber(v) <= 76 elseif u == 'cm' then return 150 <= tonumber(v) and tonumber(v) <= 193 end end,
	hcl=function (a) return a:match('^#%x%x%x%x%x%x$') end,
	ecl=function (a) return ecl[a] end,
	pid=function (a) return a:match('^%d%d%d%d%d%d%d%d%d$') end,
--	'cid',
}


local tot = 0
local p = {}
for a in io.lines() do
	if a == '' then
		local b = true
		for k,f in pairs(keys) do
			if not p[k] then b= false
			else
				if not f(p[k]) then
					b = false
				end
			end
		end
		if b then tot = tot + 1 end
		p = {}
	else
		for k,v in a:gmatch('(%w+):(%S+)') do
			p[k] = v
		end
	end
end

local b = true
for k,f in pairs(keys) do
	if not p[k] then b= false
	elseif not f(p[k]) then
		b = false
	end
end
if b then tot = tot + 1 end

print(tot)