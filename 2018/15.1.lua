local N,E,S,O = 2,3,1,0
local dir = {
	[N] = function (x,y) return x,y+1 end,
	[E] = function (x,y) return x+1,y end,
	[S] = function (x,y) return x,y-1 end,
	[O] = function (x,y) return x-1,y end,
}

local function short(underground, source, targets)
	local visited = {}
	for i=1,underground.w do
		visited[i] = {}
	end

	local file = {source}
	local i = 0
	while #file > 0 do
		local next_file = {}
		for _,v in ipairs(file) do
			if not visited[v.x][v.y] then
				visited[v.x][v.y] = i
				for d=0,3 do
					local x,y = dir[d](v.x,v.y)
					if underground[x][y] == '.' then
						if not visited[x][y] then
							table.insert(next_file,{x=x,y=y})
						end
					end
				end
			end
		end
		file = next_file
		i = i + 1
		for _,v in ipairs(targets) do
			if visited[v.x][v.y] then
				return i,v.x,v.y
			end
		end
	end
	return false
end

local function comp(a,b)
	return a.x < b.x or (a.x == b.x and a.y < b.y)
end

local function inrange(v,underground)
	for i=0,3 do
		local x,y = dir[i](v.x,v.y)
		if type(underground[x][y]) == 'table' then
			if v.type ~= underground[x][y].type then
				return true
			end
		end
	end
	return false
end

local function attack(v,underground)
	local min_hp,min_i,min_v
	for i=0,3 do
		local x,y = dir[i](v.x,v.y)
		if type(underground[x][y]) == 'table' then
			if v.type ~= underground[x][y].type then
				if not min_hp or min_hp > underground[x][y].hp then
					min_hp = underground[x][y].hp
					min_i = i
					min_v = underground[x][y]
				end
			end
		end
	end
	min_v.hp = min_v.hp - 3
	if min_v.hp <= 0 then
		min_v.dead = true
		underground[min_v.x][min_v.y] = '.'
		return min_v
	end
end

local function f(underground, elves, goblins)
	local entities = {}
	table.move(elves,1,#elves,1,entities)
	table.move(goblins,1,#goblins,#entities+1,entities)

	local ec,gc = #elves, #goblins
	steps = 0

	while ec > 0 and gc > 0 do
		table.sort(entities, comp)
		for _,entity in ipairs(entities) do
			if not entity.dead then
				if ec == 0 or gc == 0 then
					steps = steps - 1
					break
				end
				if not inrange(entity,underground) then
					local targets = {}
					for _,enemy in ipairs(entities) do
						if enemy.type ~= entity.type and not enemy.dead then
							for d=0,3 do
								local x,y = dir[d](enemy.x,enemy.y)
								if underground[x][y] == '.' then
									table.insert(targets, {x=x,y=y})
								end
							end
						end
					end
					table.sort(targets, comp)

					local min_dir,min_dist,min_x,min_y
					for d=0,3 do
						local x,y = dir[d](entity.x,entity.y)
						if underground[x][y] == '.' then
							local dist,x,y = short(underground, {x=x,y=y}, targets)
							if dist and (not min_dir or min_dist > dist or (min_dist == dist and comp({x=x, y=y}, {x=min_x, y=min_y}))) then
								min_dir = d
								min_dist = dist
								min_x = x
								min_y = y
							end
						end
					end
					if min_dir then
						local x,y = dir[min_dir](entity.x,entity.y)
						underground[entity.x][entity.y] = '.'
						underground[x][y] = entity
						entity.x, entity.y = x, y
					else
					end
				end
				if inrange(entity,underground) then
					local enemy = attack(entity,underground)
					if enemy then
						if enemy.type == 'E' then
							ec = ec - 1
						else
							gc = gc - 1
						end
					end
				end
			end
		end
		steps = steps + 1
	end
	local ret = 0
	for _,entity in pairs(entities) do
		if not entity.dead then
			ret = ret + entity.hp
		end
	end
	return ret * steps
end

local underground = {w=0,h=0}
local elves,goblins = {},{}
local i = 1
for l in io.lines() do
	local t = {}
	for j=1,#l do
		local c = l:sub(j,j)
		if c == 'G' then
			local v = {x=i,y=j,type=c,hp=200}
			t[j] = v
			table.insert(goblins,v)
		elseif c == 'E' then
			local v = {x=i,y=j,type=c,hp=200}
			t[j] = v
			table.insert(elves,v)
		else
			t[j] = c
		end
	end
	underground.h = math.max(underground.h, #t)
	table.insert(underground,t)
	i = i + 1
end
underground.w = i-1
print(f(underground, elves, goblins))