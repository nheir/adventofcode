local timer = {}
timer.__index = timer

function timer:__gc()
	print(string.format("\x1b[2mTotal: \x1b[3m%.2fms\x1b[0m", (os.clock() - self.start)*1000))
end

function timer.new() 
	local start = os.clock()
	return setmetatable({ start = start, last = start }, timer)
end

function timer:measure()
	local t = os.clock()
	local diff = t - self.last
	self.last = t
	return diff
end

function timer:log(msg)
	local t = self:measure()
	print(string.format("\x1b[2m%s: \x1b[3m%.2fms\x1b[0m", msg, t*1000))
end

function timer:total()
	local t = os.clock()
	return t - self.start
end

return setmetatable({}, {
	__call = function () return timer.new() end
})
