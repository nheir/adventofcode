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

-- merge rules ?
local scan_error = 0
for i,ticket in ipairs(tickets) do
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
		if not valid then scan_error = scan_error + v end
	end
end

print(scan_error)