local timer = (require "timer")()

local t = {}

for l in io.lines() do
	local v = {}
	for d in l:gmatch('(%-?%d+)') do
		v[#v+1] = tonumber(d) + (#v & 1)
	end
	v[#v+1] = l:match('(o[nf]f?)') == 'on'
	t[#t+1] = v
end

local function intersect1(a,b,c,d)
	return c < b and a < d
end

local function intersect3(c1,c2)
	if intersect1(c1[1], c1[2], c2[1], c2[2])
		and intersect1(c1[3], c1[4], c2[3], c2[4])
		and intersect1(c1[5], c1[6], c2[5], c2[6]) then
		local inter = {}
		for i=1,6,2 do
			inter[#inter+1] = math.max(c1[i],c2[i])
			inter[#inter+1] = math.min(c1[i+1],c2[i+1])
		end
		return inter
	end
end

local function createChildren(t, x, y, z, full)
	local x = { t.x1, x, t.x2 }
	local y = { t.y1, y, t.y2 }
	local z = { t.z1, z, t.z2 }
	for i=0,1 do
		for j=0,1 do
			for k=0,1 do
				if x[1+i] < x[2+i] and y[1+j] < y[2+j] and z[1+k] < z[2+k] then
					t[(i<<2)|(j<<1)|k] = {
						x1=x[1+i], x2=x[2+i],
						y1=y[1+j], y2=y[2+j],
						z1=z[1+k], z2=z[2+k],
						empty=not full,
						full=full
					}
				end
			end
		end
	end
end

local function insert(tree, c)
	if not tree then return end
	if tree.full then -- full
		return
	end
	local x1,x2,y1,y2,z1,z2 = table.unpack(c)
	local inter = intersect3(c, {
		tree.x1, tree.x2, tree.y1, tree.y2, tree.z1, tree.z2
	})
	if not inter then return end
	if inter[1] == tree.x1 and inter[2] == tree.x2 and inter[3] == tree.y1 and inter[4] == tree.y2 and inter[5] == tree.z1 and inter[6] == tree.z2 then
		tree.full = true
		tree.empty = false
		for i=0,7 do
			tree[i] = nil
		end
		return
	end
	if tree.empty then
		local x = inter[1] == tree.x1 and inter[2] or inter[1]
		local y = inter[3] == tree.y1 and inter[4] or inter[3]
		local z = inter[5] == tree.z1 and inter[6] or inter[5]
		createChildren(tree, x, y, z, false)
		tree.empty = false
	end
	local s = 0
	for i=0,7 do
		insert(tree[i], c)
		if not tree[i] or tree[i].full then
			s = s + 1
		end
	end
	if s == 8 then
		tree.full = true
		tree.empty = false
		for i=0,7 do
			tree[i] = nil
		end
	end
end

local function remove(tree, c)
	if not tree then return end
	if tree.empty then -- empty
		return
	end
	local x1,x2,y1,y2,z1,z2 = table.unpack(c)
	local inter = intersect3(c, {
		tree.x1, tree.x2, tree.y1, tree.y2, tree.z1, tree.z2
	})
	if not inter then return end
	if inter[1] == tree.x1 and inter[2] == tree.x2 and inter[3] == tree.y1 and inter[4] == tree.y2 and inter[5] == tree.z1 and inter[6] == tree.z2 then
		tree.full = false
		tree.empty = true
		for i=0,7 do
			tree[i] = nil
		end
		return
	end
	if tree.full then
		local x = inter[1] == tree.x1 and inter[2] or inter[1]
		local y = inter[3] == tree.y1 and inter[4] or inter[3]
		local z = inter[5] == tree.z1 and inter[6] or inter[5]
		createChildren(tree, x, y, z, true)
		tree.full = false
	end
	local s = 0
	for i=0,7 do
		remove(tree[i], c)
		if not tree[i] or tree[i].empty then
			s = s + 1
		end
	end
	if s == 8 then
		tree.empty = true
		for i=0,7 do
			tree[i] = nil
		end
	end
end

local function tree_size(tree)
	if not tree then return 0 end
	if tree.empty then return 0 end
	if tree.full then
		return (tree.x2-tree.x1)*(tree.y2-tree.y1)*(tree.z2-tree.z1)
	end
	local s = 0
	for i=0,7 do
		s = s + tree_size(tree[i])
	end
	return s
end

local octree = {x1=-50,x2=51,y1=-50,y2=51,z1=-50,z2=51,empty=true,full=false}
local count = 0
for i=1,#t do
	local v = t[i]
	if v[7] then
		insert(octree, v)
	else
		remove(octree, v)
	end
end

timer:log("Insertion in octree [-50,50]")

print(tree_size(octree))

local octree = {x1=-50,x2=51,y1=-50,y2=51,z1=-50,z2=51,empty=true,full=false}

for i=1,#t do
	octree.x1 = math.min(octree.x1, t[i][1])
	octree.x2 = math.max(octree.x2, t[i][2])
	octree.y1 = math.min(octree.y1, t[i][3])
	octree.y2 = math.max(octree.y2, t[i][4])
	octree.z1 = math.min(octree.z1, t[i][5])
	octree.z2 = math.max(octree.z2, t[i][6])
end

local count = 0
for i=1,#t do
	local v = t[i]
	if v[7] then
		insert(octree, v)
	else
		remove(octree, v)
	end
end
timer:log("Insertion in complete octree")

print(tree_size(octree))