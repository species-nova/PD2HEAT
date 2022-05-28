HEAT = HEAT or {}

--Wrapper over DelayedCalls:Add to resolve delayed call name collisions in an automated manner.
--Metatable to track number of delayed calls of a given type, and cache delayed calls strings to reduce string concatenations.
local call_name_cache = {}
local call_name_cache_meta = {
	__index = function(cache, func)
		cache[func] = {count = 0}
		setmetatable(cache[func], {
			__index = function(t, count)
				t[count] = func .. count
				return t[count]
			end
		})
		return cache[func]
	end
}
setmetatable(call_name_cache, call_name_cache_meta)

--Call this in the same way as DelayedCalls:Add.
function HEAT.AddDelayedCall(name, delay, lambda)
	local count = call_name_cache[name].count 
	call_name_cache[name].count = count + 1
	DelayedCalls:Add(call_name_cache[name][count], delay, function()
		lambda()
		call_name_cache[name].count = call_name_cache[name].count - 1
	end)
end