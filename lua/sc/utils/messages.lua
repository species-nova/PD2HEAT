--Get the highest existing enum value in the messages list.
local max_v = 0
for k, v in pairs(Message) do
	max_v = math.max(v, max_v)
end

--Add additional custom messages.
Message.OnEnemyHit = max_v + 1 --Additional listener for when enemies are hit in melee.