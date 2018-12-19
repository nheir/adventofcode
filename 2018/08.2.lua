function readtree(t,i)
	local tree = {children={}}
	local m = t[i]
	local j = i+2
	for i=1,m do
		local child, next_j = readtree(t,j)
		table.insert(tree.children,child)
		j = next_j
	end
	tree.metadata = {}
	table.move(t,j,j+t[i+1]-1,1,tree.metadata)
	return tree,j+t[i+1]
end

function sum_meta(tree)
	local sum = 0
	if #tree.children == 0 then
		for _,v in ipairs(tree.metadata) do
			sum = sum + v
		end
	else
		for _,v in ipairs(tree.metadata) do
			if tree.children[v] then
				sum = sum + sum_meta(tree.children[v])
			end
		end
	end
	return sum
end

function f(t)
	return sum_meta(readtree(t,1))
end

local t = {}
for n in io.input():lines('n') do
  table.insert(t,n)
end

print(f(t))