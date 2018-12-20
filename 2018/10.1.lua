local function box(t,date)
	local right,top,left,bottom = t[1].x+date*t[1].vx,t[1].y+date*t[1].vy,t[1].x+date*t[1].vx,t[1].y+date*t[1].vy
	for _,p in ipairs(t) do
		if p.x+date*p.vx < left then left = p.x+date*p.vx end
		if p.x+date*p.vx > right then right = p.x+date*p.vx end
		if p.y+date*p.vy < bottom then bottom = p.y+date*p.vy end
		if p.y+date*p.vy > top then top = p.y+date*p.vy end
	end
	return left,bottom,right-left+1,top-bottom+1 
end

local function box_size(x,y,w,h)
	return w*h
end

local function dico(t, dmin, vmin, dmax, vmax)
	if not dmax then
		dmax = 2*dmin
		vmax = box_size(box(t, dmax))
		if vmax > vmin then
			return dico(t,dmin,vmin,dmax,vmax)
		else
			return dico(t,dmax,vmax)
		end
	end
	if dmax <= dmin+1 then
		return dmax
	end
	d = (dmin+dmax)//2
	v = box_size(box(t,d))
	if v > vmin or v < box_size(box(t,d+1)) then
		return dico(t,dmin,vmin,d,v)
	end
	return dico(t,d,v,dmax,vmax)
end

local function f(t)
	local date = dico(t,1,box_size(box(t,1)))
	local x,y,w,h = box(t,d)
	local content = {}
	for j=1,h do
		content[j] = {}
		for i=1,w do
			content[j][i] = '.'
		end
	end
	for _,v in pairs(t) do
		content[v.y+d*v.vy-y+1][v.x+d*v.vx-x+1] = '#'
	end
	for j=1,h do
		print(table.concat(content[j]))
	end
end

local t = {}
for l in io.lines() do
	local x,y,vx,vy = l:match('position=< ?(-?%d+),  ?(-?%d+)> velocity=< ?(-?%d+),  ?(-?%d+)>')
	table.insert(t,{x=tonumber(x),y=tonumber(y),vx=tonumber(vx),vy=tonumber(vy)})
end
f(t)