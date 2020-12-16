local rules = {}
local myticket
local tickets = {}

local state = 'rules'

for l in io.lines() do
	if l == '' then
		state = ({rules="ticket", ticket='tickets'})[state]
	else
		if state == "rules" then
			local field, values = l:match("([%w ]+): (.*)")
			local rule = {}
			for a,b in values:gmatch('(%d+)%-(%d+)') do
				table.insert(rule, {tonumber(a), tonumber(b)})
			end
			rules[field] = rule
		elseif l:find('%d') then
			local ticket = {}
			for n in l:gmatch("%d+") do
				table.insert(ticket, tonumber(n))
			end
			if state == "ticket" then
				myticket = ticket
			else
				table.insert(tickets, ticket)
			end
		end
	end
end

for i=#tickets,1,-1 do
	local ticket = tickets[i]
	for j,v in ipairs(ticket) do
		local valid = false
		for _, rule in pairs(rules) do
			for _,r in ipairs(rule) do
				if r[1] <= v and v <= r[2] then
					valid = true
					break
				end
			end
			if valid then break end
		end
		if not valid then
			table.remove(tickets, i)
			break
		end
	end
end

local nbrules = #myticket
local applies = {}
for r in pairs(rules) do
	local t = {}
	for i=1,nbrules do t[i] = true
	end
	t.size = nbrules
	applies[r] = t
end

for i=#tickets,1,-1 do
	local ticket = tickets[i]
	for j,v in ipairs(ticket) do
		for name, rule in pairs(rules) do
			local match = false
			for _,r in ipairs(rule) do
				if r[1] <= v and v <= r[2] then
					match = true
					break
				end
			end
			if not match and applies[name][j] then
				applies[name][j] = nil
				applies[name].size = applies[name].size - 1
			end
		end
	end
end

local a = {}
for r in pairs(rules) do
	applies[r].name = r
	table.insert(a, applies[r])
end

table.sort( a, function (a,b) return a.size < b.size end)

for j,rule in ipairs(a) do
	local t = {}
	local v
	for i=1,nbrules do if rule[i] then
		table.insert(t, i)
		v = i
	end end
	if rule.size == 1 then
		rule.val = v
		for k=j+1,nbrules do
			if a[k][v] then
				a[k][v] = nil
				a[k].size = a[k].size - 1
			end
		end
	end
end

local res = 1
for _,r in ipairs(a) do
	if r.name:find('^departure') then
		print(r.name, myticket[r.val])
		res = res * myticket[r.val]
	end
end

print(res)
