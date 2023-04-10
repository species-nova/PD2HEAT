table.insert(StatisticsManager.special_unit_ids, "tank_biker")
table.insert(StatisticsManager.special_unit_ids, "boom")
table.insert(StatisticsManager.special_unit_ids, "boom_summers")
table.insert(StatisticsManager.special_unit_ids, "taser_summers")
table.insert(StatisticsManager.special_unit_ids, "medic_summers")
table.insert(StatisticsManager.special_unit_ids, "rboom")
table.insert(StatisticsManager.special_unit_ids, "heavy_swat_sniper")
table.insert(StatisticsManager.special_unit_ids, "weekend_dmr")
table.insert(StatisticsManager.special_unit_ids, "tank_titan")
table.insert(StatisticsManager.special_unit_ids, "tank_titan_assault")
table.insert(StatisticsManager.special_unit_ids, "spring")
table.insert(StatisticsManager.special_unit_ids, "headless_hatman")
table.insert(StatisticsManager.special_unit_ids, "summers")
table.insert(StatisticsManager.special_unit_ids, "omnia_lpf")
table.insert(StatisticsManager.special_unit_ids, "tank_medic")
table.insert(StatisticsManager.special_unit_ids, "phalanx_minion_assault")
table.insert(StatisticsManager.special_unit_ids, "spooc_titan")
table.insert(StatisticsManager.special_unit_ids, "taser_titan")
table.insert(StatisticsManager.special_unit_ids, "autumn")
table.insert(StatisticsManager.special_unit_ids, "marshal_marksman")

local orig_stats = StatisticsManager.init
function StatisticsManager:init()
	orig_stats(self)

	local function create_defaults(id)
		self._defaults.killed[id] = {
			count = 0,
			head_shots = 0,
			melee = 0,
			explosion = 0,
			tied = 0
		}
	end

	create_defaults("cop_forest")
	create_defaults("omnia_lpf")
	create_defaults("taser_summers")
	create_defaults("boom_summers")
	create_defaults("medic_summers")
	create_defaults("boom")
	create_defaults("rboom")
	create_defaults("tank_titan")
	create_defaults("tank_titan_assault")
	create_defaults("tank_medic")
	create_defaults("spring")
	create_defaults("headless_hatman")
	create_defaults("summers")
	create_defaults("fbi_vet")
	create_defaults("hrt")
	create_defaults("fbi_female")
	create_defaults("skeleton_swat_titan")
	create_defaults("tank_biker")
	create_defaults("phalanx_minion_assault")
	create_defaults("spooc_titan")
	create_defaults("taser_titan")	
	create_defaults("autumn")
	create_defaults("gensec_guard")
	create_defaults("marshal_marksman")
		
	--Weekend	
	create_defaults("weekend_dmr")
	create_defaults("weekend")
	create_defaults("weekend_lmg")
end