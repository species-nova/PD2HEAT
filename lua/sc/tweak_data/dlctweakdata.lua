old_DLCTweakData_init = DLCTweakData.init
function DLCTweakData:init(...)
	old_DLCTweakData_init(self, ...)
			
	self.rest = {
		content = {},
		free = true
	}
	self.rest.content.loot_drops = {}
	self.rest.content.upgrades = {}	
	self.wetwork_masks = {
		content = {},
		free = true
	}

	if SystemInfo:platform() == Idstring("PS4") then
		-- console
	elseif SystemInfo:platform() == Idstring("XB1") then
		-- console
	elseif Global.dlc_manager.has_cce_beta then
		table.insert(self.preorder.content.loot_drops, {
			type_items = "masks",
			item_entry = "finger",
			amount = 1
		})
		table.insert(self.preorder.content.loot_drops, {
			type_items = "masks",
			item_entry = "instinct",
			amount = 1
		})
	end

	self.wetwork_masks.content.loot_global_value = "rest"
	self.wetwork_masks.content.loot_drops = {
		{
			type_items = "masks",
			item_entry = "shatter_true",
			amount = 1
		},
		{
			type_items = "masks",
			item_entry = "unforsaken",
			amount = 1
		},	
		{
			type_items = "masks",
			item_entry = "f1",
			amount = 1
		},
		{
			type_items = "masks",
			item_entry = "sweettooth",
			amount = 1
		},
		{
			type_items = "materials",
			item_entry = "jkl_matt01",
			amount = 1
		},
		{
			type_items = "materials",
			item_entry = "jkl_matt02",
			amount = 1
		},	
		{
			type_items = "textures",
			item_entry = "jkl_patt01",
			amount = 1
		},		
		{
			type_items = "textures",
			item_entry = "jkl_patt02",
			amount = 1
		}
	}
	
	self.sc = {}
	self.sc.free = true
	self.sc.content = {}
	self.sc.content.loot_global_value = "sc"
	self.sc.content.loot_drops = {
		{
			type_items = "weapon_mods",
			item_entry = "wpn_fps_upg_bonus_sc_none",
			amount = 1
		}				
	}	
	
	if Steam:is_user_in_source(Steam:userid(), "103582791469447940") then
		self.omnia = {
			content = {},
			free = true
		}
		self.omnia.content.loot_global_value = "rest_omnia"
		self.omnia.content.loot_drops = {
			{
				type_items = "masks",
				item_entry = "all_seeing",
				amount = 1
			},
			{
				type_items = "masks",
				item_entry = "classic_helmet",
				amount = 1
			}				
		}	
	end
	if Steam:is_user_in_source(Steam:userid(), "103582791469447811") then
		self.omnia_2 = {
			content = {},
			free = true
		}
		self.omnia_2.content.loot_global_value = "rest_omnia"
		self.omnia_2.content.loot_drops = {
			{
				type_items = "masks",
				item_entry = "cube",
				amount = 1
			}			
		}	
	end			
		
end