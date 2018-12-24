local segments = {}
for l in io.lines() do
	local xy,a,b,c = l:match('([xy])=(%d+), [xy]=(%d+)%.%.(%d+)')
	if xy == 'x' then
		local segment = {x=tonumber(a),y=tonumber(b),ex=tonumber(a),ey=tonumber(c)}
		table.insert(segments, segment)
	else
		local segment = {x=tonumber(b),y=tonumber(a),ex=tonumber(c),ey=tonumber(a)}
		table.insert(segments, segment)
	end
end

local x_min,x_max,y_min,y_max = segments[1].x,segments[1].ex,segments[1].y,segments[1].ey
for _,segment in ipairs(segments) do
	if segment.x < x_min then x_min = segment.x end
	if segment.ex > x_max then x_max = segment.ex end
	if segment.y < y_min then y_min = segment.y end
	if segment.ey > y_max then y_max = segment.ey end
end
x_min = x_min-1
x_max = x_max+1
y_max = y_max+1

local underground = {}
for y=y_min,y_max do
	underground[y] = {}
	for x=x_min,x_max do
		underground[y][x] = '.'
	end
end

for _,segment in ipairs(segments) do
	for x=segment.x,segment.ex do
		for y=segment.y,segment.ey do
			underground[y][x] = '#'
		end
	end
end

local spring_x = 500
local spring_y = y_min - 1

local propagate = {}

local last_level = {}
for x = x_min,x_max do 
	last_level[x] = { min = x, max = x, open=true, left = x, right = x }
end
propagate[y_max] = last_level

for y=y_max-1,y_min,-1 do
	local res = {}
	res[x_min] = { min = x_min, max = x_min, open=true, left = x_min, right = x_min }
	local x = x_min+1
	while x <= x_max do
		local effect = {y=y}
		if underground[y][x] == '#' then
			effect.min, effect.max = x,x
			effect.open = false
			res[x] = effect
			x = x + 1
		else
			effect.open = false
			effect.min = x
			if propagate[y+1][x].open then
				effect.open = true
				effect.max = x
				effect.left, effect.right = x,x
				res[x] = effect
				x = x + 1
			else
				if res[x-1].open then
					effect.left = x-1
					effect.open = true
				end
				while x <= x_max and underground[y][x] == '.' do
					if propagate[y+1][x].open then
						effect.right = x
						effect.open = true
						break
					end
					res[x] = effect
					x = x + 1
				end
				effect.max = x-1
			end
		end
	end
	propagate[y] = res
end

local used = {}

local start = {[spring_x] = true}
for y=y_min,y_max-1 do
	local next_step = {}
	for x in pairs(start) do
		local effect = propagate[y][x]
		used[effect] = true
		next_step[effect] = true
	end
	start = {}
	for effect in pairs(next_step) do
		for x=effect.min,effect.max do
			if underground[y+1][x] ~= '#' then
				start[x] = true
			end
		end
		if effect.left then
			used[propagate[y][effect.left]] = true
			start[effect.left] = true
		end
		if effect.right then
			used[propagate[y][effect.right]] = true
			start[effect.right] = true
		end
	end
end

local count = 0
for effect in pairs(used) do
	count = count + effect.max - effect.min + 1
end

print(count)

