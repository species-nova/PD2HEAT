function DramaTweakData:init()
	self:_create_table_structure()

	self.drama_actions = {
		criminal_hurt = 0.25,
		criminal_dead = 0.39,
		criminal_disabled = 0.1
	}
	self.decay_period = 10
	self.max_dis = 4000
	self.max_dis_mul = 0.75
	self.low = 0.1
	self.peak = 0.95
	self.consistentcombat = 0.4
	self.assault_fade_end = 1
end
