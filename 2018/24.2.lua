-- 1193 units each with 4200 hit points (immune to slashing, radiation, fire) with an attack that does 33 bludgeoning damage at initiative 2

local function parse_line(l)
	local n, hp = l:match("(%d+) units each with (%d+) hit points")
	local attrs = l:match("%b()") or ''
	local dmg, dmg_type, initiative = l:match("with an attack that does (%d+) (%w+) damage at initiative (%d+)")
	local attr = {immune={}, weak={}}
	local key
	for w in attrs:gmatch('%w+') do
		if w == 'weak' or w == 'immune' then
			key = w
		elseif w ~= 'to' then
			attr[key][w] = true
		end
	end
	return {n=tonumber(n),hp=tonumber(hp),attr=attr,dmg=tonumber(dmg),dmg_type=dmg_type,initiative=tonumber(initiative)}
end

io.read('l') -- header
local groups = {}
local l = io.read('l')
local i = 1
while l ~= '' do
	local immune = parse_line(l)
	immune.type = 'immune'
	immune.id = i
	table.insert(groups,immune)
	l = io.read('l')
	i = i + 1
end
io.read('l') -- header
local l = io.read('l')
i = 1
while l do
	local infection = parse_line(l)
	infection.type = 'infection'
	infection.id = i
	table.insert(groups,infection)
	l = io.read('l')
	i = i + 1
end

local reset_groups
do
	local old_groups = groups
	reset_groups = function ()
		local t = {}
		for _,g in ipairs(old_groups) do
			local tg = {}
			for k,v in pairs(g) do
				tg[k] = v
			end
			table.insert(t,tg)
		end
		groups = t
	end
	reset_groups()
end

local function effective_power(a)
	return a.n * a.dmg
end

local function comp_initiative(a,b)
	return a.initiative > b.initiative
end

local function comp_selection(a,b)
	if effective_power(a) > effective_power(b) then
		return true
	elseif effective_power(a) == effective_power(b) then
		return comp_initiative(a,b)
	end
	return false
end

local function is_immune(a)
	return a.type == 'immune'
end

local function is_infection(a)
	return a.type == 'infection'
end

local function filter(f)
	local t = {}
	for i=1,#groups do
		if f(groups[i]) then
			table.insert(t,groups[i])
		end
	end
	return t
end

local function nb_immunes()
	return #filter(is_immune)
end

local function nb_infections()
	return #filter(is_infection)
end

local function is_alive(a)
	return a.n > 0
end


local function to_optim(boost)
	reset_groups()
	for _,g in ipairs(groups) do
		if is_immune(g) then
			g.dmg = g.dmg + boost
		end
	end
	local has_change = true
	while has_change and nb_infections() > 0 and nb_immunes() > 0 do
		has_change = false
		table.sort(groups, comp_selection)
		local attacks = {}
		local used = {}
		for _,g in ipairs(groups) do
			local score = 0
			local target
			for _,def in ipairs(groups) do
				if not used[def] and def.type ~= g.type and not def.attr.immune[g.dmg_type] then
					local s = g.dmg
					if def.attr.weak[g.dmg_type] then s = s+s end
					if score < s then
						score = s
						target = def
					end
				end
			end
			if target then
				used[target] = g
				g.att = g
				g.def = target
				table.insert(attacks, g)
			end
		end
		table.sort(attacks, comp_initiative)
		for _,attack in ipairs(attacks) do
			local att,def = attack.att, attack.def
			local dmg = effective_power(att)
			if def.attr.weak[att.dmg_type] then dmg = dmg + dmg end
			if dmg // def.hp > 0 then
				has_change = true
			end
			def.n = def.n - (dmg // def.hp)
			if def.n < 0 then def.n = 0 end
		end
		groups = filter(is_alive)
	end
	local sum = {immune=0, infection=0}
	for _,n in ipairs(groups) do
		sum[n.type] = sum[n.type] + n.n
	end

	return has_change and nb_immunes() > 0
end

local function dico(bmin, bmax)
	if not bmax then
		bmax = 2*bmin
		if to_optim(bmax) then
			return dico(bmin,bmax)
		else
			return dico(bmax)
		end
	end
	if bmax <= bmin+1 then
		return bmax
	end
	d = (bmin+bmax)//2
	if to_optim(d) then
		return dico(bmin,d)
	end
	return dico(d,bmax)
end

to_optim(dico(1))
local sum = 0
for _,n in ipairs(groups) do
	sum = sum + n.n
end
print(sum)