local t = {}

local keys = {
	'byr',
	'iyr',
	'eyr',
	'hgt',
	'hcl',
	'ecl',
	'pid',
--	'cid',
}

local tot = 0
local p = {}
for a in io.lines() do
	if a == '' then
		local b = true
		for _,k in ipairs(keys) do
			if not p[k] then b= false end
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
for _,k in ipairs(keys) do
	if not p[k] then b= false end
end
if b then tot = tot + 1 end

print(tot)