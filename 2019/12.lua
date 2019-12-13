local input = {}
for l in io.lines() do
	input[#input+1] = load('return ' .. l:gsub('[<>]', {['<']='{',['>']='}'}))()
end

local pos1, pos2 = {}, {}
local vel1, vel2 = {}, {}
for i=1,#input do
	pos1[i] = {x=input[i].x, y=input[i].y, z=input[i].z}
	pos2[i] = {x=input[i].x, y=input[i].y, z=input[i].z}
	vel1[i] = {x=0,y=0,z=0}
	vel2[i] = {x=0,y=0,z=0}
end

local function step(pos, vel)
	for i=1,#pos do
		for j=i+1,#pos do
			for _,a in ipairs{'x','y','z'} do
				if pos[i][a] < pos[j][a] then
					vel[i][a] = vel[i][a] + 1
					vel[j][a] = vel[j][a] - 1
				elseif pos[i][a] > pos[j][a] then
					vel[i][a] = vel[i][a] - 1
					vel[j][a] = vel[j][a] + 1
				end
			end
		end
	end

	for i=1,#pos do
		for _,a in ipairs{'x','y','z'} do
			pos[i][a] = pos[i][a] + vel[i][a]
		end
	end
end

local function eq(a1, a2, key)
	for i=1,#a1 do
		if a1[i][key] ~= a2[i][key] then
			return false
		end
	end
	return true
end

local res = {}
local count = 0
repeat
	step(pos1, vel1)
	step(pos2, vel2)
	step(pos2, vel2)
	count = count + 1
	for _,key in ipairs{'x', 'y', 'z'} do
		if not res[key] then
			if eq(pos1, pos2, key) and eq(vel1, vel2, key) then
				res[key] = count
			end
		end
	end
until res.x and res.y and res.z

-- assuming it match the initial position
local function gcd(a,b)
	if b < 0 then
		return gcd(a,-b)
	end
	if a < b then
		return gcd(b,a)
	end
	if b == 0 then
		return a
	end
	return gcd(b, a % b)
end

local function lcm(a,b)
	return a*b // gcd(a,b)
end

print(lcm(lcm(res.x, res.y), res.z))

--[[ local count = 0
for i=1,#input do
	local pot = 0
	local kin = 0
	for _,a in ipairs{'x','y','z'} do
		pot = pot + math.abs(input[i][a])
		kin = kin + math.abs(vitesse[i][a])
	end
	count = count + pot*kin
end
print(count)
--]]
