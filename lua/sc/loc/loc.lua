-- ResMod english.json
Hooks:Add("LocalizationManagerPostInit", "PD2HEAT_english_Localization", function(loc)
	LocalizationManager:add_localized_strings({
		["menu_es_boost"] = "Boost",
		["menu_es_crew"] = "Crew",
		["menu_es_personal"] = "Personal",
		["menu_es_bad"] = "Bad",
		["menu_es_other"] = "Other",
		["menu_paygrade"] = "Pay grade: ",
		["menu_diffgrade"] = "Difficulty: ",

		["heat_credits"] = "Heat Credits",
		["heat_credits_help"] = "View the credits for Heat.",

		["res_saveboost"] = "HOLD $BTN_INTERACT TO BOOST TO LEVEL 100",

		["PD2HEATOptionsButtonTitleID"] = "Heat Options",
		["PD2HEATOptionsButtonDescID"] = "Heat's Options.",

		["PD2HEATScreenFXTitleID"] = "HEATed Screen Effects",
		["PD2HEATScreenFXDescID"] = "Adds a variety of tweaks to screen effects meant to give a more intense feeling to gun fights. NOTE: Not recommended for those with epilepsy.",
		["PD2HEATHUDOptionsButtonTitleID"] = "Heat HUD & UI Options",
		["PD2HEATHUDOptionsButtonDescID"] = "Heat's HUD & UI Options.",
		["PD2HEATOTHEROptionsButtonTitleID"] = "Extra Heat Options",
		["PD2HEATOTHEROptionsButtonDescID"] = "Extra Heat options.",
		["PD2HEATUIOptionsButtonTitleID"] = "Alpha UI",
		["PD2HEATUIOptionsButtonDescID"] = "Alpha UI options.",
		["PD2HEATTimeOfDayTitleID"] = "New + Randomized Time-of-days",
		["PD2HEATTimeOfDayDescID"] = "Allows you to customize the time-of-day on certain heists.",

		["restoration_level_data_unknown"] = "TIME UNKNOWN, LOCATION UNKNOWN",
		["PD2HEATEnv_BanksTitleID"] = "Branch Bank",
		["PD2HEATEnv_BanksDescID"] = "Select an environment for Branch Bank.",
		["PD2HEATEnv_RVD1TitleID"] = "Reservoir Dogs Day 1",
		["PD2HEATEnv_RVD1DescID"] = "Select an environment for  Reservoir Dogs Day 1.",
		["PD2HEATEnv_RVD2TitleID"] = "Reservoir Dogs Day 2",
		["PD2HEATEnv_RVD2DescID"] = "Select an environment for  Reservoir Dogs Day 2.",
		["PD2HEATEnv_FSD1TitleID"] = "Firestarter Day 1",
		["PD2HEATEnv_FSD1DescID"] = "Select an environment for Firestarter Day 1.",
		["PD2HEATEnv_PBR2TitleID"] = "Birth of Sky",
		["PD2HEATEnv_PBR2DescID"] = "Select an environment for Birth of Sky.",
		["PD2HEATEnv_CJ2TitleID"] = "The Bomb: Dockyard",
		["PD2HEATEnv_CJ2DescID"] = "Select an environment for The Bomb: Dockyard.",
		["PD2HEATEnv_UnderPassTitleID"] = "Transport Underpass",
		["PD2HEATEnv_UnderPassDescID"] = "Select an environment for Transport Underpass.",
		["PD2HEATEnv_MallCrasherTitleID"] = "Mallcrasher",
		["PD2HEATEnv_MallCrasherDescID"] = "Select an environment for Mallcrasher.",
		["PD2HEATEnv_Mia_1TitleID"] = "Hotline Miami Day 1",
		["PD2HEATEnv_Mia_1DescID"] = "Select an environment for Hotline Miami Day 1.",
		["PD2HEATEnv_FSD3TitleID"] = "Firestarter Day 3",
		["PD2HEATEnv_FSD3DescID"] = "Select an environment for Firestarter Day 3.",
		["PD2HEATEnv_WDD1NTitleID"] = "Watchdogs Day 1 (Night)",
		["PD2HEATEnv_WDD1NDescID"] = "Select an environment for Watchdogs Day 1 (Night).",
		["PD2HEATEnv_WDD1DTitleID"] = "Watchdogs Day 1 (Day)",
		["PD2HEATEnv_WDD1DDescID"] = "Select an environment for Watchdogs Day 1 (Day).",
		["PD2HEATEnv_WDD2DTitleID"] = "Watchdogs Day 2 (Day)",
		["PD2HEATEnv_WDD2DDescID"] = "Select an environment for Watchdogs Day 2 (Day).",
		["PD2HEATEnv_Alex3TitleID"] = "Rats Day 3",
		["PD2HEATEnv_Alex3DescID"] = "Select an environment for Rats Day 3.",
		["PD2HEATEnv_BigTitleID"] = "Big Bank",
		["PD2HEATEnv_BigDescID"] = "Select an environment for Big Bank.",
		["PD2HEATEnv_FSTitleID"] = "Four Stores",
		["PD2HEATEnv_FSDescID"] = "Select an environment for Four Stores.",
		["PD2HEATEnv_UkraTitleID"] = "Ukrainian Job",
		["PD2HEATEnv_UkraDescID"] = "Select an environment for Ukrainian Job.",
		["PD2HEATEnv_KosugiTitleID"] = "Shadow Raid",
		["PD2HEATEnv_KosugiDescID"] = "Select an environment for Shadow Raid Job.",
		["PD2HEATEnv_PetaTitleID"] = "Goat Simulator Day 1",
		["PD2HEATEnv_PetaDescID"] = "Select an environment for Goat Simulator Day 1.",
		["PD2HEATEnv_FRIENDTitleID"] = "Scarface Mansion",
		["PD2HEATEnv_FRIENDDescID"] = "Select an environment for Scarface Mansion.",
		["PD2HEATINFOHUDOptionsButtonTitleID"] = "Buff Tracker",
		["PD2HEATINFOHUDOptionsButtonDescID"] = "Displays icons to reflect information about active skills on the left side of the screen. Does not require Alpha UI to be enabled.",
		["PD2HEATInfo_HudTitleID"] = "Enable Buff Tracker",
		["PD2HEATInfo_HudDescID"] = "Enables or disables the entire buff tracking UI.",
		["PD2HEATInfo_SizeTitleID"] = "Icon Size",
		["PD2HEATInfo_SizeDescID"] = "Controls the size of icons on the buff tracker.",
		["PD2HEATInfo_CountTitleID"] = "Row Count",
		["PD2HEATInfo_CountDescID"] = "Controls the number of rows the buff tracker displays before adding a new column.",
		["PD2HEATInfo_single_shot_fast_reloadTitleID"] = "Rapid Reset",
		["PD2HEATInfo_single_shot_fast_reloadDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_ammo_efficiencyTitleID"] = "Ammo Efficiency",
		["PD2HEATInfo_ammo_efficiencyDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_bloodthirst_stacksTitleID"] = "Bloodthirst",
		["PD2HEATInfo_bloodthirst_stacksDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_bullet_hellTitleID"] = "Bullet Hell",
		["PD2HEATInfo_bullet_hellDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_bullet_stormTitleID"] = "Bullet Storm",
		["PD2HEATInfo_bullet_stormDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_close_combatTitleID"] = "Close Combat Counter",
		["PD2HEATInfo_dmg_multiplier_outnumberedDescID"] = "Enables or disables tracking of the number of enemies within 7m while you have a relevant skill.",
		["PD2HEATInfo_revive_damage_reductionTitleID"] = "Combat Medic",
		["PD2HEATInfo_revive_damage_reductionDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_desperadoTitleID"] = "Desperado",
		["PD2HEATInfo_desperadoDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_grinderTitleID"] = "Histamine (Grinder)",
		["PD2HEATInfo_grinderDescID"] = "Enables or disables tracking of this specific perk deck ability.",
		["PD2HEATInfo_hyper_critsTitleID"] = "Low Blow",
		["PD2HEATInfo_hyper_critsDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_infiltratorTitleID"] = "Life Drain (Infiltrator)",
		["PD2HEATInfo_infiltratorDescID"] = "Enables or disables tracking of this specific perk deck ability.",
		["PD2HEATInfo_long_dis_reviveTitleID"] = "Inspire",
		["PD2HEATInfo_long_dis_reviveDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_messiahTitleID"] = "Messiah",
		["PD2HEATInfo_messiahDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_overheat_stacksTitleID"] = "Overheat",
		["PD2HEATInfo_overheat_stacksDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_revived_damage_reductionTitleID"] = "Painkillers",
		["PD2HEATInfo_revived_damage_reductionDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_first_aid_damage_reductionTitleID"] = "Quick Fix",
		["PD2HEATInfo_first_aid_damage_reductionDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_rogueTitleID"] = "Killer Instinct (Rogue)",
		["PD2HEATInfo_rogueDescID"] = "Enables or disables tracking of this specific perk deck ability.",
		["PD2HEATInfo_increased_movement_speedTitleID"] = "Running From Death",
		["PD2HEATInfo_increased_movement_speedDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_damage_speed_multiplierTitleID"] = "Second Wind",
		["PD2HEATInfo_damage_speed_multiplierDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_headshot_accuracy_addendTitleID"] = "Sharpshooter",
		["PD2HEATInfo_headshot_accuracy_addendDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_shell_stacking_reloadTitleID"] = "Shell Rack",
		["PD2HEATInfo_shell_stacking_reloadDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_silent_precisionTitleID"] = "Silent Precision",
		["PD2HEATInfo_silent_precisionDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_melee_kill_increase_reload_speedTitleID"] = "Snatch",
		["PD2HEATInfo_melee_kill_increase_reload_speedDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_trigger_happyTitleID"] = "Trigger Happy",
		["PD2HEATInfo_trigger_happyDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_offhand_auto_reloadTitleID"] = "Trusty Sidearm",
		["PD2HEATInfo_offhand_auto_reloadDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_unseen_strikeTitleID"] = "Unseen Strike",
		["PD2HEATInfo_unseen_strikeDescID"] = "Enables or disables tracking of this specific skill.",
		["PD2HEATInfo_survive_one_hitTitleID"] = "Oni Irezumi (Yakuza)",
		["PD2HEATInfo_survive_one_hitDescID"] = "Enables or disables tracking of this specific perk deck ability.",
		["PD2HEATInfo_doctor_bag_health_regenTitleID"] = "Doctor Bag Health Regen",
		["PD2HEATInfo_doctor_bag_health_regenDescID"] = "Enables or disables tracking of doctor bag health regen.",
		["PD2HEATAltLastDownColorTitleID"] = "Alternative Last Down Color Grading",
		["PD2HEATAltLastDownColorDescID"] = "Switches the last down color grading to color_sin_classic.",
		["PD2HEATNoBleedoutTiltTitleID"] = "Disable Bleedout Camera Tilt",
		["PD2HEATNoBleedoutTiltDescID"] = "Disables the camera tilt that happens while in bleedout.",
		["PD2HEATClassicMoviesTitleID"] = "Classic Loadout Backgrounds",
		["PD2HEATClassicMoviesDescID"] = "Enable or disable PD:TH loadout backgrounds when playing on Classic heists.",

		["windowofoppurtunity"] = "Window Of Opportunity",
		["wheresthevan"] = "Where's The Van",
		["menu_jukebox_heist_ponr"] = "Point Of No Return",
		["PD2HEATPaintingsTitleID"] = "Unused Art Gallery Paintings",
		["PD2HEATPaintingsDescID"] = "Enable or disable the ability for unused paintings to spawn on Art Gallery. As host only.",
		["PD2HEATMainHUDTitleID"] = "Alpha HUD ON/OFF",
		["PD2HEATMainHUDDescID"] = "Enable or disable the alpha HUD entirely.",
		["PD2HEATWaypointsTitleID"] = "Alpha Waypoints",
		["PD2HEATWaypointsDescID"] = "Enable or disable Alpha Waypoints.",
		["PD2HEATAssaultPanelTitleID"] = "Alpha Assault Tape",
		["PD2HEATAssaultPanelDescID"] = "Enable or disable the Alpha Assault Tape.",
		["PD2HEATAltAssaultTitleID"] = "Early Alpha Assault Indicator",
		["PD2HEATAltAssaultDescID"] = "Enable or disable the Early Alpha Assault Indicator. Replaces tape.",
		["PD2HEATObjectivesPanelTitleID"] = "Alpha Objectives Panel",
		["PD2HEATObjectivesPanelDescID"] = "Enable or disable the Alpha Objectives Panel.",
		["PD2HEATPresenterTitleID"] = "Alpha Presenter",
		["PD2HEATPresenterDescID"] = "Enable or disable the Alpha Presenter, which is used for loot secure and objective reminder dialogue.",
		["PD2HEATInteractionTitleID"] = "Alpha Interaction Meter",
		["PD2HEATInteractionDescID"] = "Enable or disable the Alpha Interaction meter.",
		["PD2HEATStealthTitleID"] = "Alpha Stealth Meter",
		["PD2HEATStealthDescID"] = "Enable or disable the Alpha Stealth meter.",
		["PD2HEATDownTitleID"] = "Alpha Downed Timer",
		["PD2HEATDownDescID"] = "Enable or disable the Alpha Downed timer.",
		["PD2HEATBagTitleID"] = "Alpha Bag Panel",
		["PD2HEATBagDescID"] = "Enable or disable the Alpha Bag panel.",
		["PD2HEATHostageTitleID"] = "Hide Hostage Panel",
		["PD2HEATHostageDescID"] = "If enabled, hides the hostage panel when an assault begins, if assault tape or early alpha indicator are on.",
		["PD2HEATDifficultyMarkersTitleID"] = "Pre-Release Difficulty Markers",
		["PD2HEATDifficultyMarkersDescID"] = "Enable or disable the Pre-Release Difficulty Markers.",
		["PD2HEATStaminaIndicatorTitleID"] = "Debug Stamina Indicator",
		["PD2HEATStaminaIndicatorDescID"] = "Enable or disable the Debug Stamina Indicator.",
		["PD2HEATBlackScreenTitleID"] = "Heat Blackscreen",
		["PD2HEATBlackScreenDescID"] = "Enable or disable the Heat Blackscreen.",
		["PD2HEATLoadoutsTitleID"] = "Alpha Loadouts",
		["PD2HEATLoadoutsDescID"] = "Enable or disable the Alpha Loadouts screen.",
		["PD2HEATDistrictTitleID"] = "CRIME.NET District Descriptions",
		["PD2HEATDistrictDescID"] = "Enable or disable district descriptions in CRIME.NET. Not gameplay accurate.",
		["PD2HEATSCOptionsButtonTitleID"] = "Heat Options",
		["PD2HEATSCOptionsButtonDescID"] = "Heat Options",
		["PD2HEATHolidayTitleID"] = "Holiday Effects",
		["PD2HEATHolidayDescID"] = "Enable or disable Holiday effects for Heat.",
		["PD2HEATRestoreHitFlashTitleID"] = "Restore Hit Flash",
		["PD2HEATRestoreHitFlashDescID"] = "Enable or disable the restored hit flash when taking damage.",	
		["PD2HEATNotifyTitleID"] = "Feature Notification",
		["PD2HEATNotifyDescID"] = "Enable or disable the notification for this feature.",
		["PD2HEATPauseTitleID"] = "Alpha Pause Menu",
		["PD2HEATPauseDescID"] = "Enable or disable the Alpha Pause Menu.",

		["menu_support"] = "Overhaul Guide/Support",
		["menu_support_help"] = "View the guide for Heat's Overhaul, get support, find crew mates.",
		["menu_manual_header"] = "Placeholder Text",
		["hud_assault_alpha"] = "POLICE ASSAULT",
		["hud_loot_secured_title"] = "LOOT SECURED!",
		["debug_none"] = "OBJECTIVE",

		["heist_contact_shatter"] = "Jackal",
		["heist_contact_akashic"] = "NO DATA",

		["menu_contacts_shatter"] = "CRIMENET Affiliates",
		["heist_contact_shatter_description"] = "Jackal.",
		["heist_contact_jackal_description"] = "NO DATA",
		["heist_contact_raze_description"] = "DEPRECATED",
		["heist_contact_akashic_description"] = "NO DATA",

		["bm_msk_shatter_true"] = "Phoenix",
		["bm_msk_shatter_true_desc"] = "The Phoenix represents rebirth. Each death bringing about new life.\n\nYou've been here before, haven't you? It's time for your new life.",

		["menu_l_global_value_veritas"] = "Heat",
		["menu_l_global_value_veritas_desc"] = "This is a Heat item!",

		["menu_alex_1_zipline"] = "Bag Zipline",

		["menu_asset_wet_intel"] = "Intel",
		["menu_asset_risk_murky"] = "Murkywater Mercenaries",
		["menu_asset_risk_bexico"] = "Policía Federal",
		["menu_asset_risk_zombie"] = "zOmbIe rEpsondERs",
		--["menu_asset_wet_boat"] = "Boat",
		--["menu_asset_wet_boat_desc"] = "Buy an additional boat drop-off and escape",

		["bm_msk_canada"] = "Hockey Hell",
		["bm_msk_canada_desc"] = "Leave nothing behind -- even when the heat arrives, you fight for what you want, when you want it. (even if it's a thermobaric explosive.)",
		["bm_msk_jsr"] = "Mrs. Graffiti",
		["bm_msk_jsr_desc"] = "Made by a true artist. Cleaning up graffiti is like burning a book, yeah?\n\nArt is art, respect that.",
		["bm_msk_jsrf"] = "Mr. Graffiti",
		["bm_msk_jsrf_desc"] = "Graffiti tells tales. Being an artist in the cold city can be a painful story.\n\nGraffiti tells these tales like a book. You'd best read them.",
		["bm_msk_courier_stash"] = "The Lootbag",
		["bm_msk_courier_stash_desc"] = "In case you wanna grab a few extra hundred dollar bills, and you don't have the room in your pockets, this mask will do the trick.",

		["bm_msk_female_mask"] = "Standard Issue Mask (Female)",
		["bm_msk_female_mask_desc"] = "A standard issue mask, provided by CRIMENET.\n\nMade of a dense material, it's not flimsy, but it's not easy to wear, either.",
		["bm_msk_female_mask_blood"] = "Recovered Mask (Female)",
		["bm_msk_female_mask_blood_desc"] = "A standard issue mask, provided by CRIMENET.\n\nMade of a dense material, it's not flimsy, but it's not easy to wear, either.\n\nThis was found in the aftermath of a botched robbery on an OMNIA depot, and all the remained were bodies & blood.\n\nThe crew's last message before going dark, was ''ERIT PREMIUM SANGUINE SANCTUM''.",
		["bm_msk_female_mask_clown"] = "Rosie",
		["bm_msk_female_mask_clown_desc"] = "A standard issue mask, provided by CRIMENET.\n\nMade of a dense material, it's not flimsy, but it's not easy to wear, either.\n\nThis was worn by a heister by the alias of Rosie, though she now wears a new mask these days.\n\nCaught on footage, she was seen taking down a whole squad of SWAT's totally unarmed.",
		["bm_msk_male_mask"] = "Standard Issue Mask (Male)",
		["bm_msk_male_mask_desc"] = "A standard issue mask, provided by CRIMENET.\n\nMade of a dense material, it's not flimsy, but it's not easy to wear, either.",
		["bm_msk_male_mask_blood"] = "Recovered Mask (Male)",
		["bm_msk_male_mask_blood_desc"] = "A standard issue mask, provided by CRIMENET.\n\nMade of a dense material, it's not flimsy, but it's not easy to wear, either.\n\nThis was found in the aftermath of a botched robbery on an OMNIA depot, and all the remained were bodies & blood.\n\nThe crew's last message before going dark, was ''ERIT PREMIUM SANGUINE SANCTUM''.",
		["bm_msk_male_mask_clown"] = "Cross",
		["bm_msk_male_mask_clown_desc"] = "A standard issue mask, provided by CRIMENET.\n\nMade of a dense material, it's not flimsy, but it's not easy to wear, either.\n\nThis was worn by a heister by the alias of Cross, though he now wears a new mask these days.\n\nA talented marksman, he once took out four armored transports in the span of 5 seconds.",

		["bm_msk_twister_mask"] = "Mystery Man",
		["bm_msk_twister_mask_desc"] = "Whomever is behind this mask, is a mystery.\n\nIt could be somebody unknown, or somebody you've known all along.",
		["bm_msk_voodoo_mask"] = "Black Magic",
		["bm_msk_voodoo_mask_desc"] = "Found in the jungle ruins of a bombing raid, this mask withstood the elements and carnage, and now is known as an omen.\n\nIt will most likely find you when you need it most, and imbue the luck to withstand destruction.\n\nOne must ask, though -- at what cost?",

		["bm_msk_f1"] = "X1 Helmet",
		["bm_msk_f1_desc"] = "When speeding down highways & burning rubber through crowded streets, make sure you wear protection.\n\nIt might protect you from a nasty fall -- but definitely not bullets.",
		--["bm_msk_f1_b"] = "X1 Helmet (Clean)",
		--["bm_msk_f1_b_desc"] = "When speeding down highways & burning rubber through crowded streets, make sure you wear protection.\n\nIt might protect you from a nasty fall -- but definitely not bullets.\n\nThis is a duplicate of the helmet, without those brand stickers on it, found in a lockup with a bunch of fancy vehicles.\n\nKeep this handy, and you might get the chance to drive one of your own.",
		["bm_msk_sweettooth"] = "Sweet Tooth",
		["bm_msk_sweettooth_desc"] = "Sweet Tooth, real name Marcus 'Needles' Kane, is a character from the Twisted Metal video game series. Sweet Tooth is best known for being a killer clown that drives a combat ice cream truck.\n\nIt\'s said that he once had escaped from a mental institution. Now he leads a life of crime.",

		["bm_msk_wolf_stone"] = "Stonecold Wolf",
		["bm_msk_wolf_stone_desc"] = "Wolf's original mask from when he first tipped over the edge, acting out crimes from his favourite media. The mask was thought lost in a robbery, inspired by the video game 'Hyper Heisting.'\n\nIn the wake of the gang's early jobs, the mask resurfaced, and was brought to the safehouse by one of Bain's associates.\n\nThe mask's original pattern has partially worn away over time, perhaps mirroring the decline in Wolf's mental stability.",

		["bm_msk_dallas_aged"] = "Aged Dallas",
		["bm_msk_dallas_aged_desc"] = "You & your crew found these masks in the strange Egyptian box at Henry's Rock. The box itself was later intercepted in transit, and the remaining contents delivered to you.\n\nSomething about these masks... it's unusual. There's no information on where they possibly came from.\n\nJackal suggests that it might be a practical joke, or some kind of attempt to freak the crew out.\n\nAs far as you can tell, though? These seem very, very old.",
		["bm_msk_chains_aged"] = "Aged Chains",
		["bm_msk_chains_aged_desc"] = "You & your crew found these masks in the strange Egyptian box at Henry's Rock. The box itself was later intercepted in transit, and the remaining contents delivered to you.\n\nSomething about these masks... it's unusual. There's no information on where they possibly came from.\n\nJackal suggests that it might be a practical joke, or some kind of attempt to freak the crew out.\n\nAs far as you can tell, though? These seem very, very old.",
		["bm_msk_hoxton_aged"] = "Aged Hoxton",
		["bm_msk_hoxton_aged_desc"] = "You & your crew found these masks in the strange Egyptian box at Henry's Rock. The box itself was later intercepted in transit, and the remaining contents delivered to you.\n\nSomething about these masks... it's unusual. There's no information on where they possibly came from.\n\nJackal suggests that it might be a practical joke, or some kind of attempt to freak the crew out.\n\nAs far as you can tell, though? These seem very, very old.",
		["bm_msk_wolf_aged"] = "Aged Wolf",
		["bm_msk_wolf_aged_desc"] = "You & your crew found these masks in the strange Egyptian box at Henry's Rock. The box itself was later intercepted in transit, and the remaining contents delivered to you.\n\nSomething about these masks... it's unusual. There's no information on where they possibly came from.\n\nJackal suggests that it might be a practical joke, or some kind of attempt to freak the crew out.\n\nAs far as you can tell, though? These seem very, very old.",

		["bm_msk_beef_dallas"] = "Beeef Dallas",
		["bm_msk_beef_dallas_desc"] = "The Crew used these masks when doing the Slaughterhouse heist.\n\nDallas chose to keep the design similar to his iconic clown mask.",
		["bm_msk_beef_chains"] = "Beeef Chains",
		["bm_msk_beef_chains_desc"] = "The Crew used these masks when doing the Slaughterhouse heist.\n\nChains, being the enforcer type, wanted an intimidating animal for his design. What's more intimidating than a friggin' dinosaur?",
		["bm_msk_beef_hoxton"] = "Beeef Hoxton",
		["bm_msk_beef_hoxton_desc"] = "The Crew used these masks when doing the Slaughterhouse heist.\n\nHoxton had a simple list for his mask:\n- Protective!\n- Efficient!\n- Stylish!\n\nAnd thus, this mask was born.",
		["bm_msk_beef_wolf"] = "Beeef Wolf",
		["bm_msk_beef_wolf_desc"] = "The Crew used these masks when doing the Slaughterhouse heist.\n\nWolf's design was inspired by one of his favourite character designs from his game developer days.",

		["bm_msk_vyse_dallas"] = "The Source",
		["bm_msk_vyse_dallas_desc"] = "Vyse stood face to face with the devil of pepper extracts and survived, this mask was made out of the bones of that devil.",
		["bm_msk_vyse_chains"] = "Childs Play",
		["bm_msk_vyse_chains_desc"] = "Although Vyse stole more money and gold than Fort Knox could hold, he had a decency to show some of share some of the contents with sick children.\n\nBain reportedly visited some of those children, and this mask is their thanks for Vyse.",
		["bm_msk_vyse_hoxton"] = "The Three Stooges",
		["bm_msk_vyse_hoxton_desc"] = "They say when you mess up, you should face the pain, and try again. Not Vyse, though. Every time he fucked up, he got slapped by the hands of former military, and kept going. Not even Larry, Curley, and Moe could take such a beating.",
		["bm_msk_vyse_wolf"] = "Bear Grylls",
		["bm_msk_vyse_wolf_desc"] = "Vyse challenged Bear Grylls to a piss drinking completion... Vyse won, and Mr. Grylls used his survival skills to help make this mask.",

		["bm_msk_secret_old_hoxton"] = "Secret Hoxton Reborn",
		["bm_msk_secret_old_hoxton_desc"] = "Hoxton left the Old Country to get his Payday in the new. When Bain first told him about the Secret, he fancied the idea of going after ancient items for their potential value, never really caring whether or not the legendary power Bain talked about was real or not.",

		["bm_msk_secret_clover"] = "Secret Clover",
		["bm_msk_secret_clover_desc"] = "When Bain told Clover about the secret, she was skeptical; Bain's talk of ancient objects with mythical power always seemed farfetched, but when she came face to face with the assembly from the three boxes, all doubt left her mind.",

		["bm_msk_secret_dragan"] = "Secret Dragan",
		["bm_msk_secret_dragan_desc"] = "Being an ex-cop, Dragan had an eye for evidence, and when Bain showed him his research for the secret he was prepared to hunt for ancient objects of power.",

		["bm_msk_secret_bonnie"] = "Secret Bonnie",
		["bm_msk_secret_bonnie_desc"] = "Bonnie, upon being told of the secret by Bain, took a huge swig of her favourite whiskey and was raring to go fuck Kataru up.",

		["bm_msk_secret_syndey"] = "Secret Sydney",
		["bm_msk_secret_syndey_desc"] = "When told of the secret by Bain, Sydney disbelieved tales of ancient powers. Regardless the opportunity to challenge an unknown yet overarching authority was enough to get her onboard.",

		["bm_msk_secret_richard"] = "Secret Richard",
		["bm_msk_secret_richard_desc"] = "Rumours circulating the criminal underworld talk of the killer who inspired Jacket; a killer who met a grizzly end at the hands of an unknown organization. When Jacket was told of the secret by Bain, he later appeared with what seemed to be the mask of his greatest inspiration.",

		["bm_all_seeing"] = "The All Seeing Anchor",
		["bm_all_seeing_desc"] = "A horrifying vision, a nightmarish sight.\n\nThe powers that be have seen you, and ensure you are rewarded for your contributions.",

		["bm_msk_classic_helmet"] = "The Classic Enforcer",
		["bm_msk_classic_helmet_desc"] = "A gift given by an ex-SWAT enforcer. Before retiring, he found Jackal... and offered only the gear he had access to, to aid in Jackal's efforts.\n\nHis curious offer was due to one reason: he saw himself, what OMNIA was doing in secret. But he himself, refused to divulge those secrets, and left soon after, never to be seen again.\n\nJackal sent these helmets forward. A reward for your contributions.",

		["bm_cube"] = "devmask.model",
		["bm_cube_desc"] = "Push the placeholder, we'll get around to it.",

		--["bm_j4"] = "J-4",
		--["bm_j4_desc"] = "Jackal's mask. Or at least, a recreation.\n\nThe real mask is important to Jackal, and some say the real thing is loaded with sensitive data.\n\nThis recreation, however, the system running the display is very rudimentary, and only seeks to replicate the real thing.\n\nA gift for your efforts.",


		["bm_msk_finger"] = "The Griefer",
		["bm_msk_finger_desc"] = "The Griefer is a mythical beast, known to have been a part of this world long ago. The beast deliberately chased and harassed common folk in villages and towns, hunting them down in unsuspecting ways. The Griefer derived pleasure from these acts and was a threat to the peace until the King's men finally found him and destroyed him.",

		["bm_msk_instinct"] = "The Intuition",
		["bm_msk_instinct_desc"] = "This mask belonged to a mysterious warrior from far away place. He walked the lands, guided by his intuition, hunting evil forces across the world. He ventured to dungeons and slew thousands of evil beings he came across. In the end, he found peace, knowing that the next generation would continue as he did.",

		["bm_msk_unforsaken"] = "The Unforsaken",
		["bm_msk_unforsaken_desc"] = "This legendary mask is a token of our appreciation of our community's dedication, understanding and continued support. From us in the OVERKILL crew - we salute you.\n\nThrough thick and thin, let those helmets fly.",

		["bm_msk_chains_halloween"] = "Shatter Shield",
		["bm_msk_chains_halloween_desc"] = "Being a mercenary for hire, you see lots of pain, and death. Even if you feel invincible, unstoppable... sometimes it all comes back to haunt you.\n\nOn a lovely, bright and snowy October afternoon in 2008, Chains was sleeping in. Fresh off an assassination job on behalf of Murkywater, he did the tough stuff, got paid, and got a sweet hotel room to sleep in.\n\nFor the first time in years, he suffered a nightmare. He can't recall what it was, but he woke up, paralyzed, and a figure that was more skeleton than man standing over him, and he was unable to move.\n\nEach time he held his gun after that day, the following nights would each be restless, and terrible.\n\nEventually, he had to say, 'enough.' Got out of the merc-for-hire business, and saw a therapist. Had medication to help. Life was good for a year...\n\nExactly a year later, on October 31st, 2009, Murkywater was sure that a man out to fix his life would expose secrets, try to hurt the company. They couldn't have that.\n\nChains was thrust into the criminal life to protect himself, becoming a soldier once more.\n\nThis time, though? It was different. The nightmares and sleep paralysis didn't return. He wasn't out to hurt others.\n\nThis time, it was about protecting himself.",

		["bm_msk_dallas_halloween"] = "Monster's Reflection",
		["bm_msk_dallas_halloween_desc"] = "Spend so many years constructing false identities, lies, and stories, you start to lose yourself.\n\nYou start bouncing from person to person, picking up traits and quirks from your various friends, lovers, and flings. Maybe they start to blend together, and you feel like an amalgamation.\n\nDallas woke one October morning, walking to the mirror -- hair dyed an ugly blonde and patchy shave. A tacky suit, stained with sweat from restless nightmares. A throbbing headache after a weekend of jumping from liquor to liquor.\n\nStaring at himself, all he could think is that he was more like a Frankenstein's monster than a person: just bits and pieces convincing enough to make it further in his criminal career.\n\nIt was a turning point, but sometimes, he still can't shake the feeling that his pieces aren't all his.",

		["bm_msk_hoxton_halloween"] = "Halloween Dream",
		["bm_msk_hoxton_halloween_desc"] = "One of Hoxton's Halloween memories was traveling to the states one October with his extended relatives, off to see NYC as a sort of special getaway.\n\nHe was never a big fan of candy, but loved the pumpkin pie being served at his relative's party.\n\nWhile wandering the halls outside the party hall, he saw a big vault door, and trinkets and riches of all sorts being wheeled in.\n\nSince then, he always was fond of hitting places during holidays.",

		["bm_msk_wolf_halloween"] = "Devil's Cry",
		["bm_msk_wolf_halloween_desc"] = "On a cold October evening in 2010, Wolf was still recovering from the financial fallout from his company going defunct.\n\nLaying alone in a motel room, he thought about his family, how he felt he failed them, and how he might never see them again -- a whole country away and stranded after his last lifeline cut him away.\n\nHaving spent the last of his savings on a trip to the states, in a bid to secure enough money to start fresh with a new home, he was crushed.\n\nWeeks later, bouncing from friends places, motels, and shelters, he received the first call from his significant other in weeks.\n\nThe relationship was no more. 'I don't see this working out well any longer.'\n\nMaybe there was a fresh start.\n\nMaybe there was a new profession to pursue.",


		["pattern_jkl_patt01_title"] = "Jackal's Logo",
		["pattern_jkl_patt02_title"] = "Company",
		["material_jkl_matt01_title"] = "Fighting Feathers",
		["material_jkl_matt02_title"] = "Memory's Gold",

		["menu_scores"] = "SCORES",

		["PD2HEATColorOption"] = "Change the color of this HUD element to your own liking",
		["PD2HEATColorsOptionsButtonTitleID"] = "Color settings",
		["PD2HEATColorsOptionsButtonDescID"] = "Change the color of many HUD objects.",
		["PD2HEATObjectivesBGTitleID"] = "Objectives background",
		["PD2HEATObjectivesFGTitleID"] = "Objectives foreground",
		["PD2HEATAssaultBGTitleID"] = "Assault background",
		["PD2HEATAssaultFGTitleID"] = "Assault foreground",
		["PD2HEATNoReturnTitleID"] = "Point of no return text",
		["PD2HEATTimerTextTitleID"] = "Heist timer text",
		["PD2HEATAssaultEndlessBGTitleID"] = "Captain assault background",
		["PD2HEATAssaultSurvivedBGTitleID"] = "Survived Assault background",
		["PD2HEATStaminaTitleID"] = "Stamina",
		["PD2HEATStaminaThresholdTitleID"] = "Stamina threshold",
		["PD2HEATBagBitmapTitleID"] = "Bag",
		["PD2HEATBagTextTitleID"] = "Bag text",
		["PD2HEATNoReturnTextTitleID"] = "No point of return text",
		["PD2HEATHostagesTextTitleID"] = "Hostages text",
		["PD2HEATHintTextTitleID"] = "Hint text",
		["PD2HEATMaskOnTextTitleID"] = "Mask on text",
		["PD2HEATStopAllBotsTitleID"] = "Stop All Bots",
		["PD2HEATStopAllBotsDescID"] = "Stops all bots by holding the stop bot key.",
		["PD2HEATPONRTrackTitleID"] = "Point Of No Return Music",
		["PD2HEATPONRTrackDescID"] = "Changes the music track on Pro-Jobs when the point of no return starts.",
		["PD2HEATPONRTracksTitleID"] = "Point Of No Return Music",
		["PD2HEATPONRTracksDescID"] = "Select the music track for Pro-Jobs when the point of no return starts.",
		["PD2HEATMusicShuffleTitleID"] = "Music Shuffle",
		["PD2HEATMusicShuffleDescID"] = "Changes the music track after assault ends.",
		["PD2HEATScaleTitleID"] = "HUD scaling",
		["PD2HEATScaleDescID"] = "Changes HUD scaling. May require a restart.",
		["PD2HEATSizeOnScreenTitleID"] = "HUD size on screen",
		["PD2HEATSizeOnScreenDescID"] = "Changes the size of the HUD on the screen. May require a restart.",
		["PD2HEATTeammateTitleID"] = "Alpha teammates panel",
		["PD2HEATTeammateDescID"] = "Enable or disable the alpha teammates panel, which displays you & your team's statistics.",
		["PD2HEATHeistTimerTitleID"] = "Alpha heist timer",
		["PD2HEATHeistTimerDescID"] = "Enable or disable the alpha heist timer.",
		["PD2HEATMaskOnTitleID"] = "Alpha mask on text",
		["PD2HEATMaskOnDescID"] = "Enable or disable the alpha mask on text.",
		["PD2HEATNameLabelsTitleID"] = "Alpha name labels",
		["PD2HEATNameLabelsDescID"] = "Enable or disable the alpha name labels.",
		["PD2HEATHintTitleID"] = "Alpha hint panel",
		["PD2HEATHintDescID"] = "Enable or disable the alpha hint panel.",
		["PD2HEATExtraOptionsButtonTitleID"] = "More HUD options",
		["PD2HEATExtraOptionsButtonDescID"] = "Even more options!",
		["PD2HEATRealAmmoTitleID"] = "Real Ammo",
		["PD2HEATRealAmmoDescID"] = "The total ammo counter ignores ammo currently in your weapon.",
		["PD2HEATStealthOrigPosTitleID"] = "Vanilla Detection Meter Positioning",
		["PD2HEATStealthOrigPosDescID"] = "Places the detection meter in the same area as Vanilla.",
		["PD2HEATLowerBagTitleID"] = "Lowered carried bag popup",
		["PD2HEATLowerBagDescID"] = "Lowers the pop-up that appears when grabbing a bag.",
		["PD2HEATAssaultStyleTitleID"] = "Assault Panel Style",
		["PD2HEATAssaultStyleDescID"] = "Allows you to choose the style of assault panel you want to use.",
		["PD2HEATCasingTickerTitleID"] = "Alpha Casing Tape",
		["PD2HEATCasingTickerDescID"] = "Enable or disable the Alpha Casing Tape (Requires Alpha Tape Style).",
		["PD2HEATCustodyTitleID"] = "Alpha Custody",
		["PD2HEATCustodyDescID"] = "Enable or disable alpha custody panel.",
		["PD2HEATCrimenetTitleID"] = "Alpha CRIMENET (WIP)",
		["PD2HEATCrimenetDescID"] = "Enable or disable alpha CRIMENET.",
		["PD2HEATProfileTitleID"] = "Alpha Profile Box",
		["PD2HEATProfileDescID"] = "Enable or disable alpha Profile Box.",
		["PD2HEATNewsfeedTitleID"] = "Alpha Newsfeed",
		["PD2HEATNewsfeedDescID"] = "Enable or disable alpha Newsfeed.",
		["PD2HEATUppercaseNamesTitleID"] = "Uppercase names",
		["PD2HEATUppercaseNamesDescID"] = "Enable or disable uppercase names.",
		["PD2HEATPeerColorsTitleID"] = "Alpha Peer Colors",
		["PD2HEATPeerColorsDescID"] = "Enable or disable the alpha peer colors.",
		["PD2HEATPocoCrimenetAlignSortTitleID"] = "Poco Align and Sort CRIMENET",
		["PD2HEATPocoCrimenetAlignSortDescID"] = "Aligns and sorts CRIMENET by difficulty.",
		["PD2HEATPocoCrimenetScaleTitleID"] = "Poco CRIMENET Scale",
		["PD2HEATPocoCrimenetScaleDescID"] = "Allows you to set the scale of CRIMENET.",
		["PD2HEATVoiceIconTitleID"] = "Voice Chat Icon",
	    ["PD2HEATVoiceIconDescID"] = "Displays when a player is using voice chat in-game.",
		["alpha_assault"] = "Early Alpha Corner",
		["beta_assault"] = "Alpha Tape",

		["menu_ingame_manual"] = "Heat Guide",
		["menu_ingame_manual_help"] = "View the guide for Heat.",

		["menu_jukebox_resmusic_wetwork"] = "Spectre Shark",
		["menu_jukebox_screen_resmusic_wetwork"] = "Spectre Shark",
		["menu_jukebox_resmusic_bluewave"] = "Spectre Shark 2020",
		["menu_jukebox_screen_resmusic_bluewave"] = "Spectre Shark 2020",
		["menu_jukebox_resmusic_burnout"] = "Brute Force",
		["menu_jukebox_screen_resmusic_burnout"] = "Brute Force",
		["menu_jukebox_resmusic_doghouse"] = "Bleeding Edge",
		["menu_jukebox_screen_resmusic_doghouse"] = "Bleeding Edge",
		["menu_jukebox_resmusic_lethalforce"] = "Lethal Force",
		["menu_jukebox_screen_resmusic_lethalforce"] = "Lethal Force",
		["menu_jukebox_resmusic_redmarks"] = "Red Marks",
		["menu_jukebox_screen_resmusic_redmarks"] = "Red Marks",
		["menu_jukebox_resmusic_ponr"] = "Window of Opportunity",
		["menu_jukebox_screen_resmusic_ponr"] = "Window of Opportunity",
		["menu_jukebox_resmusic_speciesnova"] = "Species Nova",
		["menu_jukebox_screen_resmusic_speciesnova"] = "Species Nova",
		["menu_jukebox_resmusic_madvlad"] = "Mad Vlad",
		["menu_jukebox_screen_resmusic_madvlad"] = "Mad Vlad",
		["menu_jukebox_resmusic_proto"] = "Jackknife",
		["menu_jukebox_screen_resmusic_proto"] = "Jackknife",
		["menu_jukebox_screen_m1"] = "Criminal Intent (Old Version)",
		["menu_jukebox_screen_m2"] = "Preparations (Old Version)",
		["menu_jukebox_screen_m3"] = "Blueprints (Prototype Version)",
		["menu_jukebox_screen_m4"] = "Resistance",
		["menu_jukebox_screen_m5"] = "Fortress",
		["menu_jukebox_screen_m6"] = "Payday Royale Theme",
		["menu_jukebox_screen_m_holiday"] = "The Headless Bulldozer",

		["menu_color_plus"] = "E3 PAYDAY+",
		["menu_color_rvd1"] = "Inverted",
		["menu_color_e3nice"] = "E3 Nice",
		["menu_color_force"] = "E3 BHD",
		["menu_color_halloween"] = "Change",
		["menu_color_halloween2"] = "Pumpkin Spice",

		["color_plus"] = "E3 PAYDAY+",
		["color_rvd1"] = "Inverted",
		["color_e3nice"] = "E3 Nice",
		["color_force"] = "E3 BHD",
		["color_halloween"] = "Change",
		["color_halloween2"] = "Pumpkin Spice",

		["gm_gms_purchase"] = "Purchase with Continental Coins",
		["gm_gms_purchase_window_title"] = "Are you sure?",
		["gm_gms_purchase_window_message"] = "Do you really want to buy '{1}'?\n\nIt will cost you {2} {3}.",
		["gm_gms_purchase_failed"] = "Cannot Purchase",
		["gm_gms_free_of_charge_message"] = "{1} is free of charge, and can be applied to as many weapons as you wish.",
		["gm_gms_cannot_afford_message"] = "You cannot purchase {1}, as you do not have enough {3} to afford it. To purchase {1}, you will need {2} {3}",

		["bm_menu_amount_locked"] = "NONE IN STOCK",

		["PD2HEATArmorFixTitleID"] = "Armor Flash Fix",
		["PD2HEATArmorFixDescID"] = "Enable or disable armor flash fix.",


		["ch_watchdogs_d1_heavy_wpn1_hl"] = "HEAVY ARMOR, AND HEAVIER WEAPONS",
		["ch_watchdogs_d1_heavy_wpn1"] = "Complete day one of the WATCHDOGS job, wearing an ICTV and using miniguns, the Thanatos sniper, or RPG's only, on the OVERKILL difficulty or above.  You must have played from the start of the heist to complete this challenge.",
		
		--Phoenix .500--
		["bm_w_shatters_fury"] = "Phoenix .500 Revolver",
		["bm_wp_wpn_fps_pis_shatters_fury_b_comp1"] = "Horus Barrel",
		["bm_wp_wpn_fps_pis_shatters_fury_b_comp2"] = "Shatter Barrel",
		["bm_wp_wpn_fps_pis_shatters_fury_b_long"] = "Hathor Barrel",
		["bm_wp_wpn_fps_pis_shatters_fury_b_short"] = "Firebird Barrel",
		["bm_wp_wpn_fps_pis_shatters_fury_g_ergo"] = "Ergo Grip",
		["bm_wp_wpn_fps_pis_shatters_fury_body_smooth"] = "Smooth Cylinder",
		["menu_l_global_value_shatters_fury"] = "This is a HEAT item!",
		
		--Anubis .45--
		--Semi-automatic pistol. Hold down ■ to aim. Release to fire.
		["bm_w_socom"] = "Anubis .45 Pistol",
		["bm_w_x_socom"] = "Akimbo Anubis .45 Pistols",
		["bm_wp_wpn_fps_upg_fl_pis_socomlam"] = "Ra Combined Module",
		["bm_wp_wpn_fps_upg_fl_pis_socomlam_desc"] = "Turn it on/off by pressing $BTN_GADGET.",

		--Ranted NMH--
		["heist_no_mercy_ranted_name"] = "No Mercy",
		["heist_no_mercy_ranted_brief"] = "We are hitting up the Mercy Hospital in a heist for blood. The source is carrying some kind of rare virus and we need to get it out of him. Let nothing stop us as the paycheck is a hefty one. Spilling some blood for this kind of cash is not the end of the world.",

		["heist_nmh_res_name"] = "Mercy Hospital",
		["heist_nmh_res_brief"] = "Our client needs a blood sample from a patient being kept in the isolation ward of Mercy Hospital. You gotta go in there, take out the surveillance, subdue the civilians and get me into the patient database so I can ID the guy. With the security in this place, it should be a nice clean job. I'll get you out via the roof when you're done. This job is a little shady, brokered through a third part, got some some serious shadow-company military industrial vibes, but worth the risk. The payday is something we're gonna need in the future, plus a nice cash bonus.",
		
		["heist_nmh_new"] = "Draw and analyze patient's blood",
		["heist_nmh_new_desc"] = "You gotta find a centrifuge to validate the blood samples.",
		
		["heist_nmh_new2"] = "Call the elevator",
		["heist_nmh_new2_desc"] = "Press the button and wait for the elevator",
		
		["heist_nmh_new3"] = "Call the elevator",
		["heist_nmh_new3_desc"] = "Press the button and wait for the elevator",	
		
		--OICW--
		["bm_w_osipr"] = "SABR Rifle",
		["bm_w_osipr_gl"] = "SABR Grenade Launcher",
		
		--GO Bank remastered--
		["menu_nh_mod_gobank_v2"] = "GO Bank Remastered",
		
		["heist_gobank_v2_name"] = "GO Bank Remastered",
		["heist_gobank_v2_brief"] = "This is a classic bank job. Break the vault, empty the deposit boxes and get the loot out. Simple. Bain's intel says this branch has the lowest hit-rate in the country. It's time to change that.\n\n» Search the environment for keycards. Two are needed for the vault\n» Failing that, use a drill on the vault\n» Crack open the deposit boxes\n» Assemble the skyhook\n» Get the money out",
		
		["heist_roberts_v2_name"] = "Robert's Bank",
		["heist_roberts_v2_brief"] = "We got a bank here. Not a big branch but I've learned the vault is temporarily holding stacks of cash in transit. Foreign exchange notes.\n\nAnyway, you know how to do it - your way. Sneak in silent, or unleash hell. Either way, I got a little idea for how to lift the money out of there. You'll see what I mean. I think you'll like it.",

		["csgo_plane_timer_text"] = "Wait for the plane &&TIMER",
		["csgo_plane_timer_desc"] = "Wait for the plane &&TIMER",
		
		["hud_equipment_pickup_spraycan"] = "Press $BTN_INTERACT to pickup Spraycan",
		["hud_action_spraypaint"] = "Press $BTN_INTERACT to Spraypaint",
		["hud_action_spraypaint_none"] = "Spraycan Required",
		["spraycan_obtained"] = "Spraycan Obtained",
		["hud_equipment_obtained_spraycan"] = "Spraycan Obtained",
		
		["trophy_csgo01"] = "Graffiti Box",
		["trophy_csgo01_desc"] = "And you didnt even have to buy this one",
		["trophy_csgo01_objective"] = "Find spraypaint and spray graffiti in the vault on GO Bank Remastered.",

		["END"] = "END",	--what
		
		--Whurr Heat Street Edit--
		["heist_heat_street_new_name"] = "Heat Street True Classic",
		["heist_heat_street_new_brief"] = "Someone once said there is no such thing as a sure thing, but this job looks easy: get in, get the briefcase, get out. Your trusted wheelman Matt will be waiting for you in the alley and as long as you get to the van there is no way you can fail. Is there?",
		["heist_street_new_name"] = "Heat Street: The Heist",
		["heist_street_new_brief"] = "Someone once said there is no such thing as a sure thing, but this job looks easy: get in, get the briefcase, get out. Your trusted wheelman Matt will be waiting for you in the alley and as long as you get to the van there is no way you can fail. Is there?",

		--Heat Street, Skirmish edition--
		["heist_skm_heat_street_name"] = "Uptown - Inkwell Industrial",
		["heist_skm_heat_street_brief"] = "The kerels recently interrogated a prisoner that claims to have seen the face of Bain and can identify him. While we know it isn't true, the kerels don't, and neither do our rivals, so we're going to use the situation to gain some cash. Intercept the chop while they're transferring him to witness protection, near the old factory storage yard where that dumkop Matt crashed his car while trying to get away from us.",
		["heist_skm_street_name"] = "Holdout: Uptown - Inkwell Industrial",
		["heist_skm_street_brief"] = "The kerels recently interrogated a prisoner that claims to have seen the face of Bain and can identify him. While we know it isn't true, the kerels don't, and neither do our rivals, so we're going to use the situation to gain some cash. Intercept the chop while they're transferring him to witness protection, near the old factory storage yard where that dumkop Matt crashed his car while trying to get away from us.",	

		--Xmas Hoxout and Breaking Feds--
		["heist_xmn_hox"] = "Hoxton Breakout Xmas",
		["heist_xmn_hox1"] = "The Breakout Xmas",
		["heist_xmn_hox_1_brief"] = "The Dentist got Hoxton a re-trial. Uh, not you, Hox - I mean Old... Look, we'll sort out names later. The trial will be quick. With his record, he ain't gonna walk, but that's not the point. The point is he's moving, and we can hit him in transit. We're going to grab him right after the hearing. A nice little screw you to the US justice system.$NL;$NL;The plan is as loud as it gets: we blast a wall in the courthouse, grab Hox and get him the hell out.$NL;$NL;Area's locked down for blocks around. They'll be expecting trouble. Have your guns ready and pack a lot of ammo.",
		["heist_xmn_hox2"] = "The Search Xmas",
		["heist_xmn_hox_2_brief"] = "Well, lads, thanks for breakin' me out. But I shouldn't have been there to begin with. Someone set me up. I'm sure of it. The Feds had too much on me. Way more than those mingebag wankers could dig up. Someone ratted. Someone fucked me. And I'm gonna find out who.$NL;$NL;Now, it ain't gonna be easy. No fannying about around the edges, right? No shadowy deals or contacts, or that bollocks. We're going to the source. The biggest FBI nest. Gonna find out who screwed me.",
		["heist_xmn_hox_brief"] = "The Dentist got Hoxton a re-trial. We're going to grab him right after the hearing. The plan is as loud as it gets: we blow up a wall, grab Hoxton and get him the hell out.$NL;$NL;» Free Hoxton$NL;» Take Hoxton to the armored truck$NL;» Escort the armored truck with Hoxton in it$NL;» Escape with Hoxton.",
		
		["heist_xmn_tag_name"] = "Breakin' Feds Xmas"
	})

	local job = Global.level_data and Global.level_data.level_id
	for _,j4 in ipairs(heat.what_a_horrible_heist_to_have_a_curse) do
		if job == j4 then
			LocalizationManager:add_localized_strings({	
				["hud_assault_vip"] = "FACE YOUR NIGHTMARES AND WAKE UP",
			})
			break
		end
	end			
	
end)

Hooks:Add("LocalizationManagerPostInit", "SC_Localization", function(loc)
	LocalizationManager:add_localized_strings({
		["bm_sc_blank"] = "", --assumedly this is a debug thing, but I'm not going to touch it--

		--Menu Stuff--
		["menu_hud_cheater"] = "",
		["menu_inspect_player"] = "Inspect Player",
		["menu_inspect_player_desc"] = "Inspect player's stats",
		["menu_toggle_one_down_lobbies"] = "Allow Pro-Job Lobbies",

		--Skirmish Heists--
		["heist_skm_mallcrasher"] = "Shield Mall",
		["heist_skm_mallcrasher_h1"] = "Shield Mall",
		["heist_skm_arena"] = "Monarch Stadium",
		["heist_skm_arena_h1"] = "Monarch Stadium",
		["heist_skm_big2"] = "Benevolent Bank",
		["heist_skm_big2_h1"] = "Benevolent Bank",
		["heist_skm_watchdogs_stage2"] = "Almendia Logistics Dockyard",
		["heist_skm_watchdogs_stage2_h1"] = "Almendia Logistics Dockyard",
		["heist_skm_mus"] = "Andersonian Museum",
		["heist_skm_mus_h1"] = "Andersonian Museum",
		["heist_skm_run"] = "Uptown - Inkwell Industrial",
		["heist_skm_run_h1"] = "Uptown - Inkwell Industrial",

		--Hint Override--
		["hint_otherside"] = "Spring's presence prevents the airlock from closing!",

		--Heist Breifings--
		["heist_pines_briefing"] = "We need you there fast, because it's really out in the sticks, so you're going in like the paras. Find the pilot - he's probably near the wreck, and then we'll send in a chopper to extract him. Stay with him til he's safely out, Also, Vlad says that plane was loaded with product, Search the forest and get as much out as you can. We could always use a little extra cash during Christmas.\n\nNOTE FROM JACKAL:\nThe explosion from that crash alerted nearby Reaper teams. Don't expect a police response.",

		----Weapons + Mods Descriptions/names----
		["bm_wp_upg_i_93r"] = "Bernetti 93t Kit",
		["bm_wp_upg_i_93r_desc"] = "Enables a 3 round burst firemode, at the cost of extra kick.", --still need to do the one for the primary bernetti--

		--Shotgun Generic Mods--
		["bm_wp_ns_duck_desc_sc"] = "Causes pellets to spread horizontally, instead of clustering.",
		["bm_wp_upg_a_slug"] = "AP Slug",
		["bm_wp_upg_a_slug_desc"] = "Fires a single lead slug that penetrates body armor, enemies, shields, titan shields, and walls.",
		["bm_wp_upg_a_taser_slug"] = "Taser Slug",
		["bm_wp_upg_a_taser_slug_desc"] = "Fires a single barbed slug that tases the target upon impact.",
		["bm_wp_upg_a_custom_desc"] = "Fires a wide spread with 6 large pellets. Effective at close range.",
		["bm_wp_upg_a_dragons_breath_auto_desc_sc"] = "Fires a wide spread of pellets that burn through body armor. Has a chance to set enemies on fire.",
		["bm_wp_upg_a_piercing_auto_desc_sc"] = "Fires armor piercing flechettes that inflict bleed damage over time. Effective at longer ranges than normal.",
		
		--Generic Mods--
		["bm_wp_upg_vg_afg"] = "AFG",
		["bm_wp_upg_vg_stubby"] = "Stubby Vertical Grip",
		["bm_wp_upg_vg_tac"] = "TAC Vertical Grip",
		["bm_wp_upg_vintage_sc"] = "Vintage Mag",
		["bm_wp_upg_mil_sc"] = "Milspec Mag",
		["bm_wp_upg_tac_sc"] = "Tactical Mag",
		["bm_wp_scorpion_m_extended"] = "Double Magazine",
		["bm_wp_rpk_m_ban_sc"] = "Potassium Magazine",
		["bm_wp_r870_s_folding_ext"] = "Extended Muldon Stock",
		["bm_ap_saw_sc_desc"] = "Cuts through body armor and many locks.",

		--Weapon Sights--
		["bm_wp_upg_o_leupold_desc_sc"] = "Automatically marks special enemies, as well as guards in Stealth, while aiming.", --I believe all sights/objects with this effect call this same line, rather than having a unique one. Will need to be decoupled later when we add zoom to all of the sight descriptions.

		--[[
		--Generic Optic Zoom Descriptions--
		["bm_wp_upg_o_tiny"] = "1.1x MAGNIFICATION.",
		["bm_wp_upg_o_small"] = "1.2x MAGNIFICATION.",
		["bm_wp_upg_o_cs_desc"] = "1.5x MAGNIFICATION.",
		["bm_wp_upg_o_aim"] = "2x MAGNIFICATION.",
		["bm_wp_upg_o_med"] = "3x MAGNIFICATION.",
		["bm_wp_upg_o_large"] = "4x MAGNIFICATION.",
		["bm_wp_upg_o_huge"] = "5x MAGNIFICATION.",
		--;)
		["bm_wp_upg_o_overkill"] = "6x MAGNIFICATION.",
		]]

		--'Nade Launchers--
		["bm_wp_upg_a_grenade_launcher_incendiary_desc_sc"] = "Fires a round that causes a fire at point of impact. The fire deals damage over time, and has a chance to interrupt enemies.",
		["bm_wp_upg_a_grenade_launcher_frag_desc_sc"] = "Fires a round that causes an explosion at point of impact. The explosion deals 800 damage and has a radius of 5 meters.",
		["bm_wp_upg_a_grenade_launcher_electric_desc_sc"] = "Fires a round that causes a burst of electricity at point of impact. The burst deals 400 damage, has a radius of 5 meters, and has a chance to tase enemies.",
		["bm_wp_upg_a_grenade_launcher_electric_arbiter_desc_sc"] = "Fires a round that causes a burst of electricity at point of impact. The burst deals 300 damage, has a radius of 2.5 meters, and has a chance to tase enemies.",

		--Flamethrowers--
		["bm_wp_fla_mk2_mag_rare_sc"] = "Rare",
		["bm_wp_fla_mk2_mag_rare_desc_sc"] = "Doubles the burn duration on ignited enemies, but halves damage over time.",
		["bm_wp_fla_mk2_mag_well_desc_sc"] = "Halves the burn duration on ignited enemies, but doubles damage over time.",
		["bm_ap_flamethrower_sc_desc"] = "Set the world ablaze.\n\nBURNS THROUGH BODY ARMOR.", --used by both flamethrowers, decouple later?--

		--LMGs/Miniguns--
		["bm_wp_upg_a_halfthatkit"] = "Super Size Me!", -- lol
		["bm_wp_m134_body_upper_light"] = "Light Body",
		["bm_wp_upg_a_halfthatkit_desc"] = "Adds a 10% movement speed penalty while the weapon is equipped.\n\nIncreases weapon's ammo pickup by 20%.",
		["bm_wp_upg_a_halfthatkit_tecci_desc"] = "Adds a 25% movement speed penalty while the weapon is equipped.\n\nIncreases weapon's ammo pickup by 50%.",

		--Thanatos--
		["bm_thanatos_sc_desc"] = "Anti-materiel rifle, normally used to combat well-armored targets.\n\nMay nothing stop your shot.\n\nCAN PENETRATE BODY ARMOR, SHIELDS, TITAN SHIELDS, AND THIN WALLS.",

		--Galant--
		["bm_galant_sc_desc"] = "A classic WW2 battle rifle. Reliable, accurate, and quick to reload.\n\nReloads faster when the magazine is empty.",

		--Kobus 90--
		["bm_wp_p90_body_p90_tan"] = "Tan Body",
		["bm_ap_weapon_mod_sc_desc"] = "ADDS BODY ARMOR PENETRATION, SHIELD PENETRATION, AND WALL PENETRATION.", --this is unused.  for a reason, i think
		["bm_wp_90_body_boxy"] = "OMNIA Assault Frame",
		["bm_wp_90_body_boxy_desc"] = "Recovered from the desolated remains of an old OMNIA warehouse, this frame makes no difference to the weapon's handling or its functionality whatsoever, but its block-like aesthetic surely makes it a nice thing to have.",

		--Phoenix .500--
		["bm_wp_shatters_fury_desc"] = "A massive .500 caliber revolver, with intense kick and stopping power. A fan favorite.\n\nCAN PENETRATE BODY ARMOR, SHIELDS, AND THIN WALLS.",

		--OICW/SABR--
		["bm_w_osipr_desc_pc"] = "X-Generation weapon technology.\nEquipped with a 20mm grenade launcher.\nPress $BTN_BIPOD to switch to the Grenade Launcher.",
		["bm_w_osipr_desc"] = "X-Generation weapon technology.\nEquipped with a 20mm grenade launcher.\nHold $BTN_BIPOD to switch to the Grenade Launcher.",

		--Contractor .308--
		["bm_w_tti"] = "Contractor .308 Rifle",

		--Kang Arms X1--
		["bm_w_qbu88"] = "Káng Arms X1 Rifle",

		--Gecko M2
		["bm_w_maxim9_desc"] = "This weapon is suppressed.",

		--socom deez nuts--
		["bm_w_socom_desc"] = "Jackal's sidearm of choice. A reliable and powerful .45ACP handgun with a stylish design.",

		--Legendary Skins--
		["bm_menu_sc_legendary_ak"] = "Vlad's Rodina",
		["bm_menu_sc_legendary_flamethrower"] = "Dragon Lord",
		["bm_menu_sc_legendary_deagle"] = "Midas Touch",
		["bm_menu_sc_legendary_m134"] = "The Gimp",
		["bm_menu_sc_legendary_r870"] = "Big Kahuna",
		["bm_wskn_ak74_rodina_desc_sc"] = "A special-issue AK that - in war and crime - has demonstrated an unquenchable thirst for blood.",
		["bm_wskn_deagle_bling_desc_sc"] = "A hand-crafted Deagle built as testament to the finest gaming-trained crackshot in the world.",

		["bm_wp_upg_o_marksmansight_rear"] = "Steele Sight",

		--Modifiers--
		["bm_wp_upg_bonus_sc_none"] = "No Modifier",
		["bm_wp_upg_bonus_sc_none_desc"] = "USE THIS TO DISABLE BOOSTS FROM WEAPON SKINS.",

		--Little Friend--
		["bm_m203_weapon_sc_desc_pc"] = "Equipped with a M203 40mm grenade launcher.\nPress $BTN_BIPOD to switch to the mounted Grenade Launcher.",
		["bm_m203_weapon_sc_desc"] = "Equipped with a M203 40mm grenade launcher.\nHold $BTN_BIPOD to switch to the mounted Grenade Launcher.",

		--Generic weapon descriptions--
		["bm_light_ap_weapon_sc_desc"] = "CAN PENETRATE BODY ARMOR",
		["bm_ap_weapon_sc_desc"] = "CAN PENETRATE BODY ARMOR, SHIELDS, AND THIN WALLS.",
		["bm_ap_weapon_sc_desc"] = "CAN PENETRATE BODY ARMOR, SHIELDS, AND THIN WALLS.",
		["bm_heavy_ap_weapon_sc_desc"] = "CAN PENETRATE BODY ARMOR, SHIELDS, TITAN SHIELDS, AND THIN WALLS.",
		["bm_ap_2_weapon_sc_desc"] = "CAN PENETRATE BODY ARMOR. ARROWS CAN BE PICKED BACK UP. MUST BE DRAWN FOR MAXIMUM EFFECTIVENESS. DRAW SPEED SCALES WITH RELOAD SPEED.",
		["bm_ap_3_weapon_sc_desc"] = "CAN PENETRATE BODY ARMOR. BOLTS CAN BE PICKED BACK UP.",
		["bm_40mm_weapon_sc_desc"] = "Press $BTN_GADGET to toggle Flip Up Sight.",
		["bm_rocket_launcher_sc_desc"] = "ROCKETS FIRED BY THIS WEAPON INSTANTLY DESTROY TURRETS.",
		["bm_quake_shotgun_sc_desc"] = "FIRES BOTH BARRELS AT ONCE, DOUBLING THE NUMBER OF PELLETS.",
		["bm_hx25_buck_sc_desc"] = "FIRES 12 PELLETS IN A WIDE SPREAD.\n\nSTILL TREATED AS A GRENADE LAUNCHER BY SKILLS.",
		["bm_auto_generated_mod_sc_desc"] = "TODO: This weapon mod is missing stats.",

		--Overhaul Content Indicators--
		["loot_sc"] = "Heat",
		["loot_sc_desc"] = "THIS IS A HEAT ITEM!",

		["menu_l_global_value_omnia"] = "OMNIA",
		["menu_l_global_value_omnia_desc"] = "THIS IS AN OMNIA ITEM!",

		["menu_rifle"] = "RIFLES",
		["menu_jowi"] = "Wick",
		["menu_moving_target_sc"] = "Subtle",

		["bm_hint_titan_60"] = "The Titandozer leaves in 60 seconds!",
		["bm_hint_titan_10"] = "The Titandozer leaves in 10 seconds!",
		["bm_hint_titan_end"] = "The Titandozer left to haunt another world!",

		["bm_hint_titan_end"] = "The Titandozer left to haunt another world!",
		["bm_menu_gadget_plural"] = "Gadgets",

		-- Melee weapon descriptions (don't forget to call them in blackmarkettweakdata, not weapontweakdata) --
		["bm_melee_katana_info"] = "While playing as Jiro, killing a Cloaker with a charged attack triggers a special kill animation.",
		["bm_melee_buck_info"] = "Surprisingly effective against modern weapons, too.\n\nReduces incoming damage by 15% while charging.\n\nCan damage enemies through body armor.", --Buckler Shield
		["bm_melee_cs_info"] = "Did you know Chainsaws were invented to help with surgery for childbirth?\n\nDeals 30 damage every 0.25 seconds to targets in front of you while charging. This can be increased with skills. Cannot parry enemy attacks.", -- ROAMING FR-
		["bm_melee_ostry_info"] = "Spiiiiiiiiiin.\n\nDeals 18 damage every 0.25 seconds to targets in front of you while charging. This can be increased with skills. Cannot parry enemy attacks.", --Kazaguruma
		["bm_melee_wing_info"] = "Goes great with a disguise kit!\n\nDeals quadruple damage when attacking enemies from behind.",-- Wing Butterfly Knife
		["bm_melee_switchblade_info"] = "Designed for violence, deadly as a revolver - that's the switchblade!\n\nDeals double damage when attacking enemies from behind.",-- Switchblade Knife
		["bm_melee_chef_info"] = "Not sure if this was used for chopping meat from the supermarket.\n\nFully charged hits spread panic.", -- Psycho Knife
		["bm_melee_nin_info"] = "Fires nails, which have a short effective range, and instant travel. Still counts as a melee kill.\n\nDeals 50% more headshot damage.", -- Pounder
		["bm_melee_boxing_gloves_info"] = "I didn't hear no bell.\n\nKills performed with the OVERKILL Boxing Gloves instantly refill your stamina.\n\nCan damage enemies through body armor.", -- OVERKILL Boxing Gloves
		["bm_melee_clean_info"] = "Give the cops that extra clean shave they need.\n\nDeals 120 bleed damage over three seconds.", --Alabama Razor
		["bm_melee_barbedwire_info"] = "There's no afterlife waiting for my sorry ass... and I'm just here... talking to a fucking baseball bat!\n\nDeals 120 bleed damage over three seconds.\n\nCan damage enemies through body armor.", --Lucille Baseball Bat
		["bm_melee_cqc_info"] = "Contains an exotic poison that deals 120 extra damage and carries a chance to interrupt over three seconds.\n\nDeals 50% more headshot damage.", --Kunai, Syringe
		["bm_melee_fight_info"] = "Be water, my friend.\n\nParrying an enemy attack deals 200% more damage and knockdown.\n\nCan damage enemies through body armor.", --Empty Palm Kata
		["bm_melee_slot_lever_info"] = "GIMME A JACKPOT!\n\nHas a 5% chance to deal 900% more damage and knockdown.",
		["bm_melee_cleaver_info"] = "He's whacking and hacking and slashing.\n\nDeals 50% less headshot damage in exchange for increased overall effectiveness against the body and limbs.", --Cleavers
		["bm_melee_spoon_gold_info"] = "But we asked ourselves, what is better than a Comically Large Spoon? Well, two Comically Large Spoons of course.\n\nHas a 30% chance to set an enemy on fire, dealing 120 extra damage over 3 seconds.\n\nCan damage enemies through body armor.",
		["bm_melee_branding_iron_info"] = "This fire-heated iron sends a message.\n\nHas a 30% chance to set an enemy on fire, dealing 120 extra damage over 3 seconds.\n\nDeals 50% more headshot damage.",
		["bm_melee_multi_slash_info"] = "Twice the blades, twice the fun.\n\nMelee attacks deal double damage every hit after the first while drawn.", --multi_slash damage type weapons
		["bm_melee_bludgeoning_info"] = "Can damage enemies through body armor.", --Bludgeoning damage type weapons.
		["bm_melee_piercing_info"] = "Deals 50% more headshot damage.", --Piercing damage type weapons.

		--We assets now--
		["menu_asset_dinner_safe"] = "Safe",
		["menu_asset_bomb_inside_info"] = "Insider Info",
		["menu_asset_mad_cyborg_test_subject"] = "Test Subjects",

		--Player Outfits--
		["bm_suit_two_piece_sc"] = "Two-piece Suit",
		["bm_suit_two_piece_desc_sc"] = "The classy approach to heisting. Never hurts to look sharp when yelling, 'down on the ground!'\n\nSelecting this option will make sure you wear your Default outfit, regardless of any heist's own outfit.",

		["bm_suit_loud_suit"] = "Combat Harness",
		["bm_suit_loud_suit_desc"] = "This is a suit for when you don't mind the heat. It's lightweight, easy to move in, and built for utility. Good choice for going in for a smash and grab, or when hitting heavily fortified mercenary facilities.",

		["bm_suit_jackal_track"] = "Special Merchandise",
		["bm_suit_jackal_track_desc"] = "A special-made tracksuit, with both the Jackal logo, and a variation on the VERITAS logo.\n\nThe crew received them in unmarked boxes, but Jackal confirms he never sent them, or has seen them before.\nIt's unknown where they came from.\n\n\n\n...Inside the packages, was one note:\n\n''##A TOKEN OF APPRECIATION, FOR THOSE WITH DEDICATION.\nXOXO\n--S.N.##''\n\n",

		["bm_suit_sunny"] = "Sunny-Side Robber",
		["bm_suit_sunny_desc"] = "Sometimes you just want to roll up your sleeves, and do a little heisting.",

		--["bm_suit_pool"] = "Bodhi's Pool Repair Uniform",							    ~~R.I.P.~~
		--["bm_suit_pool_desc"] = "Sharp threads for pool repair men...",			~~TAKEN TOO SOON~~

		["bm_suit_prison"] = "Prison Suit",
		["bm_suit_prison_desc"] = "You've been taken into custody!",

		["bm_suit_var_jumpsuit_flecktarn"] = "Flecktarn Camo",
		["bm_suit_var_jumpsuit_flecktarn_desc"] = "A classic camo used by two European countries, proven battle-effective by its ability to blend into forested environments easily. It sure as hell doesn't work in urban areas, but in rural ones it does wonders to trick people's eyes.",

		["bm_suit_var_jumpsuit_flatgreen"] = "Gooey Green", --actually it's pronounced 'gee-you-eye'
		["bm_suit_var_jumpsuit_flatgreen_desc"] = "This suit was rumored to have belonged to one member of a trio of psychotic criminals, having been recovered near a destroyed garbage truck that was presumed to have been involved in a bloody heist on a GenSec armored car, which left numerous SWAT members dead and quite a few wounded. The identity of these criminals are still shrouded in mystery, as most evidence was destroyed with the Garbage Truck, only leaving this jumpsuit.",

		--New menu stats--
		["bm_menu_deflection"] = "Deflection",
		["bm_menu_regen_time"] = "Regen Delay",
		["bm_menu_swap_speed"] = "Swap Time",
		["bm_menu_standing_range"] = "Range",
		["bm_menu_moving_range"] = "Range (Moving)",
		["bm_menu_pickup"] = "Ammo Pickup",
		["bm_menu_spread"] = "Accuracy",
		["bm_menu_recoil"] = "Stability",
		["bm_menu_concealment"] = "Mobility",

		--Blackmarket GUI per-armor skill descriptions.
		["bm_menu_armor_grinding_1"] = "Armor regenerated every tick: $passive_armor_regen",
		["bm_menu_armor_grinding_2"] = "Armor regenerated every tick: $passive_armor_regen \nArmor regenerated when damaging enemies: $active_armor_regen",

		["bm_menu_armor_max_health_store_1"] = "Max health stored: $health_stored",
		["bm_menu_armor_max_health_store_2"] = "Max health stored: $health_stored \nArmor regen bonus on kill: $regen_bonus%",
	})
end)

Hooks:Add("LocalizationManagerPostInit", "SC_Localization_Weapons", function(loc)
	LocalizationManager:add_localized_strings({
		["bm_menu_bonus"] = "Modifiers",
		["steam_inventory_stat_boost"] = "Stat Modifier",

		--Safe House--
		["dialog_safehouse_text"] = "You haven't visited the safe house yet.\n\nYou should, as you might find something new.\n\nWould you like to go there now?",

		["bm_menu_custom_plural"] = "WEAPON ATTACHMENTS IN THE CUSTOM CATEGORY", --was used orig. for autofire/rof attachments i think--
	
		["menu_es_rep_upgrade"] = "",	--bullshitted removal of you got x more skillpoints message--

		--Bipod--
		["bm_sc_bipod_desc_pc"] = "Deploy/Undeploy by pressing $BTN_BIPOD on a valid surface.\n\nDramatically reduces recoil while deployed.",
		["bm_sc_bipod_desc"] = "Deploy/Undeploy by holding $BTN_BIPOD on a valid surface.\n\nDramatically reduces recoil while deployed.",

		--String override for the stungun--
		["bm_melee_taser_info"] = "Device that electrocutes and interrupts targets on touch when fully charged.\n\nBzzt!",
				
		-- Renamed default weapons and mods + descriptions-- --move all these to their respective weapons--
		-- actually important name stuff that kinda matters--
		["bm_wp_g3_m_psg"] = "Präzision Magazine",
		["bm_wp_upg_ass_ak_b_zastava"] = "Long Barrel",
		["bm_wp_upg_ass_m4_b_beowulf"] = "Wolf Barrel",
		["bm_wp_g3_b_sniper"] = "Macro Barrel",
		["bm_wp_g3_b_short"] = "Micro Barrel",

		-- default attachment name stuff		
		["bm_wp_mp5_fg_mp5sd"] = "SPOOC Foregrip",
		["bm_wp_hs2000_sl_long"] = "Elite Slide",
		["bm_wp_vhs_b_sniper"] = "Hyper Barrel",
		["bm_wp_vhs_b_silenced"] = "Bad Dragan Barrel",
		["bm_wp_corgi_b_short"] = "MSG Barrel",
		["bm_wp_pis_usp_b_match"] = "Freeman Slide",
		["bm_wp_1911_m_big"] = "Casket Magazine",
		["bm_wp_usp_m_big"] = "Casket Magazine",
		["bm_wp_p90_b_ninja"] = "Ninja Barrel",

		--Modifiers-- --Let me know if I'm safe to move these up, like the other stuff--
		["bm_menu_bonus_concealment_p1"] = "Small Mobility bonus and Accuracy/Stability penalty",
		["bm_menu_bonus_concealment_p1_mod"] = "Small Mobility Modifier",
		["bm_menu_bonus_concealment_p2"] = "Large Mobility bonus and Accuracy/Stability penalty",
		["bm_menu_bonus_concealment_p2_mod"] = "Large Mobility Modifier",
		["bm_menu_bonus_concealment_p3"] = "Massive Mobility bonus and Accuracy/Stability penalty",
		["bm_menu_bonus_concealment_p3_mod"] = "Massive Mobility Modifier",
		["bm_menu_bonus_spread_p1"] = "Small Accuracy bonus and Stability penalty",
		["bm_menu_bonus_spread_p1_mod"] = "Small Accuracy Modifier",
		["bm_menu_bonus_spread_n1"] = "Massive Stability bonus and Accuracy penalty",
		["bm_menu_bonus_recoil_p3_mod"] = "Massive Stability Modifier",
		["bm_menu_bonus_recoil_p1"] = "Small Stability bonus and Accuracy penalty",
		["bm_menu_bonus_recoil_p1_mod"] = "Small Stability Modifier",
		["bm_menu_bonus_recoil_p2"] = "Large Stability bonus and Accuracy penalty",
		["bm_wp_upg_bonus_team_exp_money_p3_desc"] = "+5% Experience reward for you and your crew, -10% Money reward for you and your crew",
		["bm_menu_bonus_spread_p2_mod"] = "Large Accuracy Modifier",
		["bm_menu_bonus_spread_p3_mod"] = "Massive Accuracy Modifier",
		["bm_menu_bonus_recoil_p2_mod"] = "Large Stability Modifier",
		["bm_wp_upg_bonus_team_money_exp_p1"] = "Money Boost",
		["bm_wp_upg_bonus_team_money_exp_p1_desc"] = "+10% Money reward for you and your crew, -5% Experience reward for you and your crew.",

		["bm_wp_upg_i_singlefire_desc"] = "LOCKS YOUR WEAPON TO SINGLE-FIRE MODE.",
		["bm_wp_upg_i_autofire_desc"] = "LOCKS YOUR WEAPON TO AUTO-FIRE MODE.",

		--Fixed names for SMGS to ARs--
		["bm_w_olympic"] = "Para Rifle",
		["bm_w_akmsu"] = "Krinkov Rifle",
		["bm_w_x_akmsu"] = "Akimbo Krinkov Rifles",
		["bm_w_hajk"] = "CR 805B Rifle",

		["menu_akimbo_assault_rifle"] = "Akimbo Assault Rifle",

		--Throwables--
		["bm_concussion_desc"] = "Capacity: 3 \nRange: 10m \nStuns enemy for up to 4s \nEnemy accuracy reduced by 50% for 7s \nStuns all enemies, excluding Titan-Shields, Titan-Bulldozers and Captains\n\nThis stunning little beauty will take everyone's breath away, giving you that extra moment to kill them.",
		["bm_grenade_smoke_screen_grenade_desc"] = "Range: 8m \nDuration: 12s \n \nDrop one of these, and you'll vanish in a cloud of smoke, leaving your enemies struggling to take aim at you.",
		["bm_grenade_frag_desc"] = "Capacity: 3\nDamage: 800 \nRange: 5m \n \nThe classic explosive hand grenade. Is there any more to say?",
		["bm_dynamite_desc"] = "Capacity: 3\nDamage: 800 \nRange: 4m \nDoes not bounce or roll from impact point, but deals less splash damage than similar explosives.\n\nDesigned to effectively blast through rock. Even more effective at blasting through people.",
		["bm_grenade_frag_com_desc"] = "Capacity: 3 \nDamage: 800 \nRange: 5m \n \nA sleek new look to the classic hand grenade, sure to provide that OVERKILL touch to each blast.",
		["bm_grenade_dada_com_desc"] = "Capacity: 3 \nDamage: 800 \nRange: 5m \n \nThe doll's outer layers hides its explosive inner workings. A tribute to the Motherland.",
		["bm_grenade_molotov_desc"] = "Capacity: 3 \nDamage: 1200 per pool over 10s \nRange: 3.75m \nDuration: 10s \nDetonates on impact \n \nA breakable bottle of flammable liquid with a burning rag. It is cheap, simple and highly effective. Light this motherf***er up!",
		["bm_grenade_fir_com_desc"] = "Capacity: 3 \nDamage: 1440 per pool over 12s \nRange: 3.75m \nDuration: 12s \nDetonates after 2.5s \n \nA self igniting phosphorus container. Perfect for bouncing off walls and around corners towards your enemies.",
		["bm_wpn_prj_ace_desc"] = "Capacity: 9 \nDamage: 240 \n \nThrowing cards with added weight and a razor edge. A real killer hand of cards.",
		["bm_wpn_prj_four_desc"] = "Capacity: 9 \nDamage: 200 (Impact) \nDamage: 200 over 5s (Poison) \nInterrupts enemy actions \n \nThe throwing star has a long history filled with blood and battle. These poison coated stainless steel stars will pose a lethal threat to anyone in your way.",
		["bm_wpn_prj_target_desc"] = "Capacity: 9 \nDamage: 240 \n \nA solid backup plan and a reliable tactic for a precise and silent kill.",
		["bm_wpn_prj_jav_desc"] = "Capacity: 6 \nDamage: 360 \n \nWith its origins lost in cloudy pre-history, the javelin is a simple weapon. After all, it's a thrown stick with a pointy end that ruins someone's day.",
		["bm_wpn_prj_hur_desc"] = "Capacity: 6 \nDamage: 360 \n \nThey say a sharp axe is never wrong. A thrown sharp axe couldn't be any more right.",
		["bm_grenade_electric_desc"] = "Capacity: 3\nDamage: 400 \nRange: 5m \n \nShrapnel is all well and good but some things need to be fried, and this little beauty is a rather practical beast for dishing out some damage with high voltage.",
	})
end)

local r = tweak_data.levels.ai_groups.russia --LevelsTweakData.LevelType.Russia
local difficulty = Global.game_settings and Global.game_settings.difficulty or "normal"
local difficulty_index = tweak_data:difficulty_to_index(difficulty)
local m = tweak_data.levels.ai_groups.murkywater --LevelsTweakData.LevelType.Murkywater
local z = tweak_data.levels.ai_groups.zombie --LevelsTweakData.LevelType.Zombie
local f = tweak_data.levels.ai_groups.federales
local ai_type = tweak_data.levels:get_ai_group_type()

if ai_type == r then
	Hooks:Add("LocalizationManagerPostInit", "SC_Localization_Ticker", function(loc)
		LocalizationManager:add_localized_strings({
			["hud_assault_alpha"] = "ЩTУPM HAЁMHИKOB"
		})
	end)
elseif ai_type == z then
	Hooks:Add("LocalizationManagerPostInit", "SC_Localization_Ticker", function(loc)
		LocalizationManager:add_localized_strings({
			["hud_assault_alpha"] = "PCILOE ASUASLT"
		})
	end)
elseif ai_type == f then
	Hooks:Add("LocalizationManagerPostInit", "SC_Localization_Ticker", function(loc)
		LocalizationManager:add_localized_strings({
			["hud_assault_alpha"] = "ASALTO FEDERAL"
		})
	end)
elseif ai_type == m and difficulty_index <= 7 then
	Hooks:Add("LocalizationManagerPostInit", "SC_Localization_Ticker", function(loc)
		LocalizationManager:add_localized_strings({
			["hud_assault_alpha"] = "MURKYWATER ASSAULT"
		})
	end)
elseif ai_type == m then
	Hooks:Add("LocalizationManagerPostInit", "SC_Localization_Ticker", function(loc)
		LocalizationManager:add_localized_strings({
			["hud_assault_alpha"] = "OMNIA INCURSION"
		})
	end)
end

Hooks:Add("LocalizationManagerPostInit", "ASSAULT_STRINGS_IN_PROGRESS", function(loc)
	LocalizationManager:add_localized_strings({
		["hud_assault_end_line"] = "////", --this has bugged me forever, 3 bars makes the banner look uneven
	
		--USA, Interchangeable--
		["hud_assault_cover_us"] = "STAY IN COVER",
		["hud_assault_cover_usds"] = "TRY TO SURVIVE",
		["hud_assault_cover_us_run"] = "STICK TO COVER", --to be used on heists that have a lot of forward movement, in place of "stay in cover".  Heat Street, HoxOut 1, etc.
	
		--LAW-OPS/DHS ZEAL Teams--
		["hud_assault_assault"] = "POLICE ASSAULT IN PROGRESS",
		["hud_assault_assault_ds"] = "ZEAL FORCES DEPLOYED",
		
		--Zombies--
		["hud_assault_assault_zm"] = "NECROCIDE IN PROGRESS",
		["hud_assault_assault_zmds"] = "THE DEAD LIVE AGAIN...",
		["hud_assault_cover_zm"] = "BAIN HAS STARTLED THE HORDE",
		["hud_assault_cover_zmds"] = "WHAT A HORRIBLE NIGHT TO HAVE A CURSE",
		
		--Federales--
		["hud_assault_assault_mex"] = "ASALTO FEDERAL EN MARCHA",
		["hud_assault_assault_mexds"] = "ESCUADRÓN DE LA MUERTE AVANZANDO",
		["hud_assault_cover_mex"] = "MANTENTE A CUBIERTO",
		["hud_assault_cover_mexds"] = "INTENTA SOBREVIVIR",
		
		--Russian Reapers--
		["hud_assault_assault_ru"] = "ИДЕТ ШТУРМ ЖНЕЦОВ",
		["hud_assault_cover_ru"] = "ОСТАВАЙТЕСЬ В УКРЫТИИ",
		["hud_assault_assault_ruds"] = "ИДЕТ РЕЙД DRAK", 
		["hud_assault_cover_ruds"] = "ПОСТАРАЙТЕСЬ ВЫЖИТЬ",
		
		--Murkywater Mercenaries/OMNIA Security Task Force--
		["hud_assault_assault_murk"] = "MURKYWATER ASSAULT IN PROGRESS",
		["hud_assault_assault_omni"] = "OMNIA INCURSION UNDERWAY",
		
		--easter egg cover lines, anything with "ds" after the line is used on Death Sentence because death sentence uses "try to survive" instead of "stay in cover"--
		["hud_assault_cover_bs1"] = "YOU HAVE BEEN SUCCESSFULLY DISTRACTED BY THE ASSAULT BANNER",
		["hud_assault_cover_bs2"] = "ERROR: COVER NOT LOCATED",
		["hud_assault_cover_bs2ds"] = "ERROR: SURVIVAL NOT LOCATED",
		["hud_assault_cover_bs3"] = "HAPPY HOLIDAYS YA DIRTY BEAST",
		["hud_assault_cover_bs4"] = "COVER'NT",
		["hud_assault_cover_bs4ds"] = "LIVE'NT",
		["hud_assault_cover_bs5"] = "SLAY IN COVER",
		["hud_assault_cover_bs5ds"] = "DON'T GET SLAIN",
		["hud_assault_cover_bs6"] = "DO NOT THE COVER",
		["hud_assault_cover_bs6ds"] = "DO NOT YOUR SURVIVAL CHANCES",
		["hud_assault_cover_bs7"] = "THE MOVIE IS ON",
		["hud_assault_cover_bs8"] = "KEEP THOSE SAUSAGES SAFE",
		["hud_assault_cover_bs9"] = "NON-STOP DEADLY ACTION",
		["hud_assault_cover_bs10"] = "CHAD WAS HERE",
		["hud_assault_cover_bs11"] = "YOU ARE ADVISED TO REMAIN IN CLOSE PROXIMITY TO A SOLID OBJECT THAT IS AS LEAST WAIST-HIGH AS TO OBSTRUCT YOUR SILHOUETTE FROM POTENTIAL CONTACT WITH THE ADVERSARY'S PROJECTILES",
		["hud_assault_cover_bs12"] = "I FEEL MY BLOOD RUSHING THROUGH MY BODY. YES... THIS IS IT. THE FEELING IS COMING BACK TO ME! THE SENSATION OF KILLING! THE DOOM AND DARKNESS. THE DARK STREETS. THEY'RE CALLING ME. CALLING ME TO THE ULTIMATE RING!",
		
		["hud_assault_vip_summers"] = "VS. CAPTAIN SUMMERS & HIS CREW",
		["hud_assault_vip_spring"] = "VS. CAPTAIN SPRING",
		["hud_assault_vip_autumn"] = "VS. CAPTAIN AUTUMN",
		["hud_assault_vip_winters"] = "VS. CAPTAIN WINTERS",
		["hud_assault_vip_hvhwarn"] = "DEMONIC PRESENCE AT UNSAFE LEVELS",
		["hud_assault_vip_hvh"] = "VS. HORSELESS HATLESS HEADLESS TITAN DOZER FROM HELL",
		
	})
end)

 if _G.HopLib then
	local ai_type = tweak_data.levels:get_ai_group_type()
	local murkywetew = tweak_data.levels.ai_groups.murkywater --LevelsTweakData.LevelType.Murkywater
	local lapood = tweak_data.levels.ai_groups.lapd

	Hooks:Add("LocalizationManagerPostInit", "SC_HoplibKillFeedCompat", function(loc)
		loc:load_localization_file(ModPath .. "lua/sc/loc/hoplibkillfeedcompat.json")
	end)

	if ai_type == murkywetew then
		Hooks:Add("LocalizationManagerPostInit", "SC_HoplibKillFeedCompat_murkywetew", function(loc)
			-- log("awesome! loaded!")
			loc:load_localization_file(ModPath .. "lua/sc/loc/murkywetew.json")
		end)
	end
	if ai_type == lapood then
		Hooks:Add("LocalizationManagerPostInit", "SC_HoplibKillFeedCompat_lapood", function(loc)
			loc:load_localization_file(ModPath .. "lua/sc/loc/lapood.json")
		end)
	end
 end

Hooks:Add("LocalizationManagerPostInit", "SC_Localization_Skills", function(loc)
	LocalizationManager:add_localized_strings({	
		["menu_toggle_one_down"] = "Pro-Job",
		["menu_one_down"] = "Pro-Job",
		["menu_es_pro_job_bonus"] = "Pro-Job",

		["menu_asset_lock_additional_assets_pro"] = "NOT AVAILABLE IN PRO-JOBS!",

		["cn_menu_contract_daypay_header"] = "Day Rate:",
		["cn_menu_contract_jobpay_header"] = "Contract Pay:",
		["victory_stage_cash_summary_name_job"] = "You earned $stage_cash on your contract day rate and an additional $job_cash for completing the contract.",

		["debug_interact_grenade_crate_take_grenades"] = "HOLD $BTN_INTERACT TO REFILL YOUR THROWABLES",
		["debug_interact_bodybags_bag_take_bodybag"] = "HOLD $BTN_INTERACT TO REFILL YOUR BODY BAGS",

		["menu_equipment_armor_kit"] = "Throwable Case",
		["bm_equipment_armor_kit"] = "Throwable Case",
		["debug_equipment_armor_kit"] = "Throwable Case",
		["bm_equipment_armor_kit_desc"] = "To use the throwable case, you need to place it by holding $BTN_USE_ITEM. Once placed it cannot be moved, but it can be used by you and your crew by holding $BTN_INTERACT to refill your throwables. It can only be used three times.\n\nYou can see how many uses are left by looking into the case.\n\nThe Throwable Case is a concealable case, usually used by a soldier or mercenary to carry specialized weaponry when the heat comes.",

		["bm_equipment_ecm_jammer_desc"] = "To use the ECM Jammer, you need to place it by holding $BTN_USE_ITEM. Once placed it cannot be moved and it will be active for 10 seconds.\n\nYou can toggle the ECM Jammer's feedback ability by interacting with it. The feedback will have a chance to incapacitate your enemies within a 25 meter radius. Feedback lasts for 20 seconds and will recharge after 4 minutes.\n\nECM jammers can open ATM machines and temporarily cancel out electronic devices such as cell phones, cameras, and other detection systems easing your way towards your goal.",
		["bm_equipment_first_aid_kit_desc"] = "To use the first aid kit, you need to place it by holding $BTN_USE_ITEM. Once placed it cannot be moved, but it can be used by you and your crew by holding $BTN_INTERACT to regain 100 health. First aid kits can only be used once.\n\nThe first aid kit is a collection of supplies and equipment for use in rapidly giving first aid in emergency situations.",
		["bm_equipment_doctor_bag_desc"] = "To use the doctor bag, you need to place it by holding $BTN_USE_ITEM. Once placed it cannot be moved, but it can be used by you and your crew by holding $BTN_INTERACT to regain 20% of their maximum health and 4% maximum health every 4 seconds for 3 minutes. Doctor bags can be used twice.\n\nThe doctor bag is a portable bag, usually used by a physician or other medical professional to transport medical supplies and medicine.",
		["bm_equipment_sentry_gun_desc"] = "To use the sentry gun, you need to place it by holding $BTN_USE_ITEM. Upon deployment it will use 40% of your maximum ammo. Upon taking too much damage, it will shut off. While in this state, interacting with it by holding $BTN_INTERACT will place it into an automatic repair mode. Picking up sentries will refund their remaining ammo and repair them. Sentry guns terrify civilians, forcing them to the ground.\n\nThe Sentry Gun automatically aims and fires at targets that are detected by its sensors. It's commonly used as a distraction, drawing attention away from you and your team.",
		["bm_equipment_sentry_gun_silent_desc"] = "To use the sentry gun, you need to place it by holding $BTN_USE_ITEM. Upon deployment it will use 40% of your maximum ammo. Upon taking too much damage, it will shut off. While in this state, interacting with it by holding $BTN_INTERACT will place it into an automatic repair mode. Picking up sentries will refund their remaining ammo and repair them. Sentry guns terrify civilians, forcing them to the ground.\n\nThe Suppressed Sentry Gun is the counterpart to the regular, louder Sentry Gun as it's more used to take out enemies than a classic distraction.",

		["hud_int_hold_take_pardons"] = "PRESS $BTN_INTERACT TO TAKE THE PARDON",
		["debug_interact_gage_assignment_take"] = "PRESS $BTN_INTERACT TO PICK UP THE PACKAGE",

		["far_repair_sentry_macro"] = "Sentry critically damaged, repairs needed.",
		["fixing_sentry_macro"] = "Repair progress: $AMMO_LEFT%",
		--Are concatenated to the related button prompts. Using Macros results in controller prompts at the wrong times.
		["repair_sentry_macro"] = " to start sentry auto-repair sequence",
		["pickup_sentry_macro"] = " to retrieve sentry.\n$AMMO_LEFT ammo left. ", --Gets % health remaining appended to the end.
		["firemode_sentry_macro"] = " to change fire modes.\n$AMMO_LEFT ammo left.",
		["hud_interact_pickup_sentry_gun"] = "$AMMO_LEFT", --$AMMO_LEFT macro is a dummy macro to be replaced with desired string, since changing interaction objects is slightly cursed.
		["hud_interact_sentry_gun_switch_fire_mode"] = "$AMMO_LEFT",
		["hud_repair_sentry"] = "$AMMO_LEFT",
		["hud_action_repair_sentry"] = "Repairing sentry",

		--More fitting descriptions of difficulties--
		["menu_risk_elite"] = "DEATH WISH. FOR YOU, ACTION IS THE JUICE.",
		["menu_risk_sm_wish"] = "DEATH SENTENCE. NOW SHOW THEM THAT YOU CAN'T BE STOPPED.",

		--Loading Hints--
		--Heat Gameplay Hints--
		["loading_gameplay_res_title"] = "Heat Gameplay Tips",
		["loading_gameplay_res_1"] = "Cloakers make a 'wheezing' sound when aggressive towards heisters. Use this to locate them.",
		["loading_gameplay_res_2"] = "Cloakers no longer make an ambient humming sound or screech when charging. Pay attention to your surroundings, as their goggles are now always lit up.",
		["loading_gameplay_res_3"] = "On Death Sentence, enemies may prioritize you if you reload. Make sure that you're in good cover or far from enemies. It might be better to swap weapons sometimes, especially if using a pistol as your secondary.",
		["loading_gameplay_res_4"] = "Tasers no longer reload your weapons. Try to stay topped up when possible, or switch to a secondary if you're about to be tased.",
		["loading_gameplay_res_5"] = "Cloakers will actively go after lone heisters, stick together or go to jail alone.",
		["loading_gameplay_res_6"] = "Cloakers deal direct health damage when they kick you. This can be reduced with Deflection or the Counter Strike skill.",
		["loading_gameplay_res_7"] = "Green Bulldozers will attempt to flank players and will run in, unload, and then run away. Be careful not to get overwhelmed or surprised.",
		["loading_gameplay_res_8"] = "Saiga/Black Bulldozers are hyper-aggressive and will charge at the player. This makes them easy to predict, but highly dangerous if you aren't prepared.",
		["loading_gameplay_res_9"] = "LMG Dozers/Skulldozers will attempt to provide covering fire for other units, but will still charge in various circumstances and have very high DPS.",
		["loading_gameplay_res_10"] = "Benelli Shotgunner Dozers replace Minigun Dozers. They only spawn in Crime Spree and alongside Captain Spring on Death Sentence. They are very, very dangerous.",
		["loading_gameplay_res_11"] = "All Dozers will prioritize targeting players who are reloading.",
		["loading_gameplay_res_12"] = "On Death Sentence, Bulldozers enter a berserker rage when their glass visors are broken, increasing their damage by 10%.",
		["loading_gameplay_res_13"] = "Cloakers perform their iconic screech when they are about to jump kick you, dodge to the side when you hear it.",
		["loading_gameplay_res_14"] = "Cloaker Jump Kicks will cuff you instead of down you.",
		["loading_gameplay_res_15"] = "Flashbangs cannot be broken on Death Sentence. Your opinion, my choice.",
		["loading_gameplay_res_16"] = "You can parry melee attacks by charging your own. This can be upgraded to work against cloaker kicks.",
		["loading_gameplay_res_17"] = "Enemy melee attacks are vastly more effective than before. Don't expect to simply walk past a horde.",
		["loading_gameplay_res_18"] = "You know what's better than smacking enemies with a baseball bat? Smacking them in the head with a baseball bat for headshot damage.",
		["loading_gameplay_res_19"] = "Snipers take a brief period of time to focus before firing. You'll know when you are being focused if all of your audio begins to fade away.",
		["loading_gameplay_res_20"] = "Your Jokers aren't safe from being kicked by Cloakers.",
		["loading_gameplay_res_21"] = "Regular enemies will come at you wielding a variety of weapons. You can tell who is carrying what by watching for details in their uniforms.",
		["loading_gameplay_res_22"] = "Shotgun-wielding enemies are deadly. Up close, they may take you down in two shots if you don't have much armor. However, they have very limited range.",
		["loading_gameplay_res_23"] = "Enemies try to hide behind Shields on higher difficulties.",
		["loading_gameplay_res_24"] = "Enemies will behave significantly smarter and are less predictable on higher difficulties.",
		["loading_gameplay_res_25"] = "Death Sentence difficulty has gone through a full design overhaul from vanilla to make it harder and meaner without being unfair. Check the Guide.",
		["loading_gameplay_res_26"] = "Pro Jobs forbid you from buying generic assets before the heist (such as the Medic Bag, Ammo Bag or the Body Bag Case), toggle friendly fire on (even with your bots) and may trigger a PONR in the final stretch of the mission with special Bravo enemies joining the ranks.",
		["loading_gameplay_res_27"] = "Heat provides different factions, such as Murkywater mercenaries and enforcers from other states. They function the same, but add a nice flavor to heists that canonically take place away from Washington DC.",
		["loading_gameplay_res_28"] = "Cloakers will throw smoke grenades at you before charging.",
		--New Units Hints--
		["loading_new_units_res_title"] = "Heat Unit Tips",
		["loading_new_units_res_1"] = "Titan HRTs are lightning-fast units that will free hostages and steal loot before you know they were there. Also, they will drop a tear gas grenade when killed without a Headshot or melee.",
		["loading_new_units_res_2"] = "LPFs are weak to melee.",
		["loading_new_units_res_3"] = "Lighter units will be Overhealed by the LPF. Overhealed enemies are outlined in purple. Overhealed units will always survive at least one shot.",
		["loading_new_units_res_4"] = "Titan Cloakers have advanced cloaking gear that renders them nearly invisible, but it still has the ambient hum of older models of standard Cloaker gear. Listen for them.",
		["loading_new_units_res_5"] = "Titan Dozers will actively attempt to avoid direct combat whenever possible and lay suppressive fire on you from a safe distance.",
		["loading_new_units_res_6"] = "Titan Snipers trade damage-per-shot and armor-piercing from their standard counterparts for a higher rate of fire and being able to shoot while moving.",
		["loading_new_units_res_7"] = "Instead of using a laser sight, Titan Sniper shots leave behind purple tracers. Use these to track them down.",
		["loading_new_units_res_8"] = "Titan Shields can only be pierced with the Thanatos, OVE9000 Saw when using Rip and Tear basic, and special AP rounds in Sentry Guns.",
		["loading_new_units_res_9"] = "Captain Spring and Titan Dozers take bonus headshot damage at all times.",
		["loading_new_units_res_10"] = "Titan Tasers fire electric rounds that severely restrict your movement temporarily. Your screen will glow blue when shot by one.",
		["loading_new_units_res_11"] = "Veteran Cops have quick reflexes that limit how much damage any given shot can deal. They cannot dodge melee, fire, or explosives. Alternatively, pick something with a high rate of fire and lower damage.",
		["loading_new_units_res_12"] = "Veteran Cops physically dodge and jump all over the place to make themselves harder to hit. They also drop smoke grenades frequently.",
		["loading_new_units_res_13"] = "Titan SWAT are lightly resistant to melee, but it still works well as a finisher.",
		["loading_new_units_res_14"] = "Titan SWAT cannot be taken hostage or converted to fight on your side.",
		["loading_new_units_res_15"] = "Titan SWAT boast LMGs and automatic shotguns. They are a major threat to your well-being.",
		["loading_new_units_res_16"] = "The dreaded Bravo units spawn on Pro Jobs only, when a PONR is triggered. They are powerful no-nonsense enemies with enhanced body armor, and more powerful weapons.",
		["loading_new_units_res_17"] = "Bravo units can throw frag grenades. Look for the flashers and listen for the beep.",
		["loading_new_units_res_18"] = "AKAN fields their own Titan units, which look different but behave the same way. Their overall color scheme and visual characteristics are the same, though, so that they may be easily identified.",
		["loading_new_units_res_19"] = "The Grenadier launches tear gas grenades at range with his underbarrel attachment, damaging players that stand in the cloud. On Death Sentence he instead comes armed with deadlier, stamina-draining nerve gas grenades.",
		--Captain Hints--
		["loading_captains_res_title"] = "Heat Captain Tips",
		["loading_captains_res_1"] = "To take Captain Summers down, target his crew first starting with Doc. He's unkillable until his entire crew is dead, and the other two are nearly invulnerable until Doc is dead.",		
		["loading_captains_res_2"] = "Don't hug Captain Summers. He WILL melt you with his flamethrower, and he has a Buzzer that he will electrocute you with.",		
		["loading_captains_res_3"] = "Captain Spring can take a ton of damage but will eventually go down. Watch for his grenades and try to lead him around, as he's very slow.",	
		["loading_captains_res_4"] = "Captain Spring throws Cluster HE grenades periodically. Don't stay close to him for long.",	
		["loading_captains_res_5"] = "Captain Spring may be dangerous, but he is incredibly slow and has poor range.",	
		["loading_captains_res_6"] = "Captain Autumn will loudly taunt when he attacks. Use this to locate him.",	
		["loading_captains_res_7"] = "Unlike other Captains, the police will not announce Autumn's arrival, as to not ruin the element of surprise.",	
		["loading_captains_res_8"] = "Captain Autumn will progressively disable your deployables if he's allowed to stay undetected in the map for a while. Disabled deployables are outlined in purple and can only be restored if Autumn is found and defeated.",	
		["loading_captains_res_9"] = "You will probably not beat Captain Autumn in a fist fight. Don't even try.",	
		["loading_captains_res_10"] = "Captain Winters is nearly immune to explosives and fire, and has strong bullet resistance, but is somewhat vulnerable to melee.",	
		["loading_captains_res_11"] = "Captain Winters' shield is completely unpierceable.",	
		["loading_captains_res_12"] = "Captain Winters has been overhauled. He now wanders around the map healing enemies in a large area around him while aggressively charging when the opportunity arises.",	
		--Stealth Hints--
		["loading_stealth_res_title"] = "Heat Stealth Tips",
		["loading_stealth_res_1"] = "Guards will no longer be instantly alerted by seeing broken cameras. A specific guard will be made to inspect the camera, allowing it to be used as a lure.",	
		["loading_stealth_res_2"] = "Killing unalerted guards with melee or taking them hostage will not set off a pager. Melee killing a guard a split second after he was alerted will still prevent the pager from being set off.",	
		["loading_stealth_res_3"] = "Melee killing unalerted guards or taking them hostage will still trigger guard replacements and map events.",	
		["loading_stealth_res_4"] = "Guards with no pagers do not increase suspicion when killed.",	
		["loading_stealth_res_5"] = "All loud weapons in stealth have a fixed 25 meter noise radius.",	
		["loading_stealth_res_6"] = "Civilians will get down in response to gunfire in both loud and stealth.",	
		["loading_stealth_res_7"] = "Sentry Guns will pacify any civilians in a notable radius around them.",	
		["loading_stealth_res_8"] = "While carrying any bag, you can be seen from much farther away, and will also be detected much faster while standing, sprinting, or jumping. Stay low and slow.",	
		["loading_stealth_res_9"] = "You get up to 4 ECMs instead of 2 like in vanilla, but they have half duration. Make sure to use them for objectives.",	
		["loading_stealth_res_10"] = "Suppressed weapons generate no noise in stealth.",	
		["loading_stealth_res_11"] = "You can take up to 4 cops hostage in stealth, just like in loud. This will NOT activate their pager or increase suspicion, but will if you later kill them.",	
		["loading_stealth_res_12"] = "Most instant fail states for stealth (such as alerted cameras, or exceeding the maximum level of pagers) have been removed or severely toned down. Check the Guide for more detailed information.",	
		["loading_stealth_res_13"] = "Guards will no longer instantly die from any source of damage while unalerted. Aim for the head, and bring something more damaging than your fists.",	
		["loading_stealth_res_14"] = "When the suspicion meter is full, you have 60 seconds to finish up what you started before the alarm is raised.",	
		["loading_stealth_res_15"] = "The higher the suspicion meter is, the easier it is to be detected by guards.",	
		["loading_stealth_res_16"] = "You can carry more body bags with you than in the base game, and even more so if you are playing solo.",	
		["loading_stealth_res_17"] = "In Crime.net Offline Mode, you will be given extra cable ties to make up for missing players. The amount still increases if you have the right skills.",	
		["loading_stealth_res_18"] = "Guards killed by gunfire will set off their pagers. While pagers going off doesn't increase suspicion, ignoring them certainly will.",	
		["loading_stealth_res_19"] = "Pager operators are less lenient on higher difficulties. Your last pager is indicated by the use of a special voice line.",	
		["loading_stealth_res_20"] = "Answering pagers beyond your allowed limit massively increases suspicion, but not as much as dropping or not answering.",	
		["loading_stealth_res_21"] = "Pagers take longer to answer and expire faster on the ground on higher difficulties.",	
		--Equipment/Skill Hints--
		["loading_equip_skills_res_title"] = "Heat Equipment/Skill Tips",
		["loading_equip_skills_res_1"] = "Shotguns lose range as their accuracy gets lower, experiment and see what works best! Be careful not to leave yourself unable to deal with snipers, though; consider a non-shotgun secondary.",	
		["loading_equip_skills_res_2"] = "Pistols are very fast to swap to and are generally accurate and stable. They work very well as backup weapons if you aren't specialized in something else.",	
		["loading_equip_skills_res_3"] = "Weapons in Heat fall under a variety of classes with different pros and cons. Higher damage weapons may kill enemies faster, but they may run dry on you before you know it!",	
		["loading_equip_skills_res_4"] = "Higher-damage weapons are generally less concealable unless they have significant downsides, such as Accuracy or Rate of Fire.",	
		["loading_equip_skills_res_5"] = "Wolf has upgraded our Sentry Guns to allow field repairs. It takes some time, but they will automatically repair once you initiate it.",	
		["loading_equip_skills_res_6"] = "If you have Sentry AP rounds unlocked, you can choose your default ammo type in the Equipment menu.",	
		["loading_equip_skills_res_7"] = "Perk Decks give significant damage bonuses and many of them provide rare and precious healing abilities. Make sure not to neglect upgrading them if you want to play higher difficulties.",	
		["loading_equip_skills_res_8"] = "Crew Chief, Armorer, Muscle, Crook, Gambler, and Biker are basic but consistent perk decks. They're great first choices for a perk deck to build into.",	
		["loading_equip_skills_res_9"] = "Hitman has been reworked into a low long-term survivability and consistency perk deck, but in exchange allows you to gain huge stores of 'Temporary HP' to power through tough spots.",	
		["loading_equip_skills_res_10"] = "Crew Chief is a team-focused perk deck that grants small but useful buffs to you and your teammates and more buffs if you have multiple hostages. It pairs well with The Controller tree in Mastermind.",	
		["loading_equip_skills_res_11"] = "Gambler is a team-focused perk deck that grants a little HP and bonus ammo to teammates when you pick ammo up. Pairs well with skills that grant extra ammo drops.",	
		["loading_equip_skills_res_12"] = "Maniac is a fast team-focused perk deck that reduces incoming damage for you and teammates as long as you keep up consistent killing. Pairs well with high-damage-output builds and builds with Damage Resist.",	
		["loading_equip_skills_res_13"] = "Hacker's Pocket ECM provides team wide healing and powerful crowd control, but takes a long time to recharge. It is also effective in stealth.",	
		["loading_equip_skills_res_14"] = "Burglar is a perk deck that provides small bonuses to Stealth in exchange for being a bit weaker than other decks in Loud.",	
		["loading_equip_skills_res_15"] = "Kingpin is a versatile perk deck. The injector can be used for self sustain, surviving heavy damage, or drawing fire away from your team.",	
		["loading_equip_skills_res_16"] = "Tag Team is a team-focused perk deck that allows you to provide a lot of healing to a specific teammate as long as the two of you keep up consistent killing.",	
		["loading_equip_skills_res_17"] = "Bullets that pierce shields deal half damage.",	
		["loading_equip_skills_res_18"] = "The Peacemaker and Phoenix .500 Revolvers are able to pierce like a sniper rifle.",
		["loading_equip_skills_res_19"] = "If you have a blue meter on the side of your screen, then you have dodge. When it's flashing, you will dodge the next bullet. Please refer to the Guide for an in-depth explanation of our dodge rework.",	
		["loading_equip_skills_res_20"] = "The higher a weapon's concealment is, the faster you can draw and holster it.",	
		["loading_equip_skills_res_21"] = "The Chainsaw and Kazaguruma deal damage to enemies in front of you while held.",	
		["loading_equip_skills_res_22"] = "The Butterfly Knife and Switchblade deal massive damage when stabbing enemies in the back.",	
		["loading_equip_skills_res_23"] = "The Icepick and Gold Fever do increased headshot damage in exchange for poor speed.",	
		["loading_equip_skills_res_24"] = "Poison deals only moderate damage, but induces vomiting which interrupts other actions.",	
		["loading_equip_skills_res_25"] = "Concussion Grenades provide very potent disruption, even against bulldozers.",	
		["loading_equip_skills_res_26"] = "Aiming down sights grants significantly increased accuracy and reduced recoil, even with LMGs.",	
		["loading_equip_skills_res_27"] = "The Pounder Nailgun melee weapon has an incredibly long range, far longer than any other melee weapon.",	
		["loading_equip_skills_res_28"] = "Leveling up perk decks unlocks the Throwables Case.",
		["loading_equip_skills_res_29"] = "Replenishing your throwables in the Equipment Case now refills your entire stock with each use.",	
		["loading_equip_skills_res_30"] = "Save Inspire ace for when things have really gone sideways, it has a very long cooldown and requires line of sight.",	
		["loading_equip_skills_res_31"] = "Heat adds two new Perk Decks (Wildcard and Blank) which provide only the common perks and no perks whatsoever, respectively. They are meant for self-imposed challenges.",
		--Misc Hints--
		["loading_misc_res_title"] = "Heat Miscellaneous Tips",
		["loading_misc_res_1"] = "OUT OF DATE",	
		["loading_misc_res_2"] = "Heat has a Steam Guide! This should be your resource for more detailed information. Check the Main Menu.",	
		["loading_misc_res_3"] = "Heat has a Discord server! Join for discussion, balance feedback, and matchmaking! Check the Main Menu.",	
		--Trivia Hints--
		["loading_fluff_res_title"] = "Heat Trivia",
		["loading_fluff_res_1"] = "Nobody knows OMNIA's true goals.",	
		["loading_fluff_res_2"] = "The LPF is owed a lot of beers.",	
		["loading_fluff_res_3"] = "The LPF and Titan Sniper are Australian.",	
		["loading_fluff_res_4"] = "The NYPD Bronco Cop loves donuts.",	
		["loading_fluff_res_5"] = "The ZEAL UMP Elite SWAT's name is Chad.",	
		["loading_fluff_res_6"] = "Titan Dozers and Titan SWAT have glowing eyes thanks to extensive genetic engineering, human experiments, and combat drugs.",	
		["loading_fluff_res_7"] = "Captain Spring is not human. He might have been, once upon a time.",	
		["loading_fluff_res_8"] = "guys how do you change localization strings help",	
		["loading_fluff_res_9"] = "OMNIA has been developing reinforced security doors to protect against dinosaur attacks.",	
		["loading_fluff_res_10"] = "The Grenadier used to work in pest control.",	
		["loading_fluff_res_11"] = "You have never seen a Titan Cloaker.",
		["loading_fluff_res_12"] = "DATA MISSING . . .",	
		["loading_fluff_res_13"] = "DATA MISSING . . .",	
		["loading_fluff_res_14"] = "HAHAHAHAHA.",
		["loading_fluff_res_15"] = "Captain Summers and his crew used to be a crew of four heisters, much like a multinational equivalent of the Payday Crew. They are now a strike team for OMNIA.",
		["loading_fluff_res_16"] = "Captain Summers and his crew officially died in a building collapse while trying to rob a bank. This was a ruse.",
		["loading_fluff_res_17"] = "Captain Autumn spends a fortune on handcuffs.",
		["loading_fluff_res_18"] = "Captain Summers spends a fortune on gas gas gas.",
		["loading_fluff_res_19"] = "Captain Spring spends a fortune on bullets and grenades.",
		["loading_fluff_res_20"] = "Captain Winters spends a fortune on shields and duct tape.",
		["loading_fluff_res_21"] = "The Grenadier division spends a fortune on Diphoterine due to several friendly fire incidents.",
		["loading_fluff_res_22"] = "You may or may not have met Captain Summers before.",
		["loading_fluff_res_23"] = "The Policía Federal has a special chupacabra hunting division.",
		["loading_fluff_res_24"] = "Captains don't die, they just pass out.",
		["loading_fluff_res_25"] = "Russian Reapers offered a 'quick and brutal crackdown on cartels' at a price cheaper than OMNIA, which led to the Policía Federal adopting their version of TITAN units. This was a ploy to get their forces closer to OMNIA and Murky operations both in Mexico and the US.",

		["menu_button_deploy_bipod"] = "BIPOD/ALT-FIRE",
		["skill_stockholm_syndrome_trade"] = "Down Restored!",
		["hint_short_max_pagers"] = "Neglecting pagers will significantly increase guard suspicion.",

		--Infamy String--
		["menu_infamy_desc_root_new"] = "As a new arrival to the criminal elite, the first order of business is for you to get gear and fanfare befitting someone of your status.\n\nBONUSES:\nYour infamous base drop rate is increased from ##0.3%## to ##0.6%##\nExperience gained is increased by ##5%##.",

		--Renaming some of the skill subtrees--
		["st_menu_mastermind_single_shot"] = "Assault",
		["st_menu_enforcer_armor"] = "Juggernaut",
		["st_menu_enforcer_ammo"] = "Support",
		["st_menu_technician_auto"] = "Combat Engineer",
		["st_menu_technician_breaching"] = "Breacher",
		["st_menu_technician_sentry"] = "Fortress",
		["hud_instruct_mask_on"] = "Press $BTN_USE_ITEM To put on Mask",
		["hud_instruct_mask_on_alpha"] = "Press $BTN_USE_ITEM to put on your mask",

		--Default Suit String--
		["bm_suit_none_desc"] = "This is the heister's default outfit with the selected armor.\n\nWill automatically change from the Two-piece Suit depending on the selected heist!",

		--Mutators--
		["menu_mutators_achievement_disabled"] = "Mutators that reduce Experience and Money gained will also disable the earning of achievements, most trophies, and level completions!",
		["mutator_medidozer_longdesc"] = "All normal enemies during assault waves are replaced with Medics, and all special units are replaced with Bulldozers.",
		["mutator_medicdozers"] = "Medic Dozers",
		["mutator_medicdozers_desc"] = "Medic Dozers can now spawn.",
		["mutator_medicdozers_longdesc"] = "Whenever a Bulldozer of any variety spawns, there is a 50% chance that it will be replaced by a Medic Bulldozer. \n\nNote: If the M1014 Bulldozer mutator is enabled, then the Medic Dozer will have a 33.3% chance of replacing an IZHMA Bulldozer.",

		["mutator_notitans"] = "Budget Cuts",
		["mutator_notitans_desc"] = "Disables Titan Units.",
		["mutator_notitans_longdesc"] = "All spawn instances of Titan Units are disabled.",

		["mutator_mememanonly"] = "HAHAHA, FOOLED YOU GUYS!",
		["mutator_mememanonly_desc"] = "SUFFERING",
		["mutator_mememanonly_longdesc"] = "CANTRUNNOESCAPEHELPHELPHELP\n\nWARNING: This mutator may cause crashes on some maps.",

		["MutatorMoreDonutsPlus"] = "More Donuts+",
		["MutatorMoreDonutsPlus_desc"] = "All common enemies replaced by NYPD Bronco Cops, and all specials are replaced by OMNIA LPFs.",
		["MutatorMoreDonutsPlus_longdesc"] = "All common enemies are replaced by NYPD Bronco Cops, and all specials are replaced with OMNIA LPFs.\n\nWARNING: You reap what you sow.",

		["MutatorJungleInferno"] = "Jungle Inferno",
		["MutatorJungleInferno_desc"] = "All enemies are replaced by Captain Summers.",
		["MutatorJungleInferno_longdesc"] = "All non-scripted spawn enemies are replaced by clones of Captain Summers.\n\nWARNING: You're in Summers' kingdom now, baby!",

		["mutator_minidozers"] = "M1014 Bulldozer Rush",
		["mutator_minidozers_desc"] = "M1014 Bulldozers can now spawn.",
		["mutator_minidozers_longdesc"] = "Whenever a IZHMA Bulldozer spawns, there is a 50% chance that it will be replaced by a Bulldozer wielding an M1014.\n\nNote: If the Medic Bulldozer mutator is enabled, then the M1014 Bulldozer will have a 33.3% chance of replacing an IZHMA Bulldozer.",

		["mutator_fatroll"] = "Fat Roll",
		["mutator_fatroll_desc"] = "Damage Grace disabled.",
		["mutator_fatroll_longdesc"] = "Damage grace on players and AI crew members is set to 0, meaning that there is no delay on instances of damage.",

		["mutator_zombie_outbreak"] = "The Dead, Walking",
		["mutator_zombie_outbreak_desc"] = "Replaces all enemies with Zombie units",
		["mutator_zombie_outbreak_longdesc"] = "The dead have risen! Replaces all enemies with Zombie units",

		["mutator_faction_override"] = "Enemy Faction Override",
		["mutator_faction_override_desc"] = "Override a level's chosen faction",
		["mutator_faction_override_longdesc"] = "Want Murkies on Bank Heist? Or Zombies to invade Big Bank? Maybe you desire Reapers showing up to your run of Heat Street? Go ahead!",
		["mutator_faction_override_"] = "",
		["mutator_faction_override_select"] = "",
		["mutator_faction_override_america"] = "USA - Generic",
		["mutator_faction_override_russia"] = "Russian Reapers",
		["mutator_faction_override_zombie"] = "Zombies",
		["mutator_faction_override_murkywater"] = "Murkywater",
		["mutator_faction_override_nypd"] = "USA - Classic",
		["mutator_faction_override_lapd"] = "USA - LAPD",
		["faction_selector_choice"] = "Faction: ",

		--Crime spree modifier changes--
		["cn_crime_spree_brief"] = "A Crime Spree is an endless series of randomly selected heists, executed in succession. With each heist you complete, your Rank and Reward will increase! Each 20th or 26th rank you will need to choose a modifier and each 100th rank there is an increase to the risk level, that will make the next heists harder to complete. After risk level 600, the amount of I-frames that players have -- which is the amount of time that exists between damage being able to be received -- begins to decrease, and Bravo units begin to spawn normally.\n\n##If you invite your crew, make sure they started their own Crime Spree before joining in order to gain ranks and Rewards as well.##",
		["menu_cs_next_modifier_forced"] = "",
		["menu_cs_modifier_dozers"] = "One additional Bulldozer is allowed into the level.",
		["menu_cs_modifier_medics"] = "One additional Medic is allowed into the level.",
		["menu_cs_modifier_no_hurt"] = "Enemies are 50% resistant to knock down.",
		["menu_cs_modifier_dozer_immune"] = "Bulldozers take 50% less explosive damage.",
		["menu_cs_modifier_bravos"] = "Enemies have an additional 6.667% chance to become Bravo Units.",
		["menu_cs_modifier_grace"] = "Your damage grace period is reduced by a 60th of a second.",
		["menu_cs_modifier_letstrygas"] = "Smoke Grenades are now replaced with Tear Gas.",
		["menu_cs_modifier_boomboom"] = "Grenadiers now explode on death.",
		["menu_cs_modifier_friendlyfire"] = "Teammates now take 100% friendly fire damage.",
		["menu_cs_modifier_dodgethis"] = "Veteran Cops now dodge all bullets.",
		["menu_cs_modifier_natascha"] = "Taking damage now slows players by 10%.",
		["menu_cs_modifier_notaserstun"] = "Tasers require a skill to be stunned.",
		["menu_cs_modifier_kicktodieinstantly"] = "Cloaker kicks and Taser shocks now count as real downs.",
		["menu_cs_modifier_nervegas"] = "Tear gas deals double damage to players out of stamina.",
		["menu_cs_modifier_sniper_aim"] = "Snipers now aim their rifles 100% faster.",
		["menu_cs_modifier_health_damage_total"] = "",
		["menu_cs_modifier_heavies"] = "All rifle SWAT units have an additional 15% chance to become an elite UMP unit.",
		["menu_cs_modifier_heavy_sniper"] = "Titan Snipers and Bravo Sharpshooters will now fire their rifles on full auto at close range.",
		["menu_cs_modifier_dozer_medic"] = "Whenever a Bulldozer spawns, there is a chance that it will be a Medic Bulldozer. A Medic Bulldozer counts as both a Medic and a Bulldozer.",
		["menu_cs_modifier_dozer_minigun"] = "Whenever a Green or Black Bulldozer spawns, there is a chance that it will be replaced by a Bulldozer wielding an M1014.",
		["menu_cs_modifier_shield_phalanx"] = "All regular Shield units have an additional 15% chance to become a Titan Shield.",
		["menu_cs_modifier_taser_overcharge"] = "The tasing knockout effect of the Taser is no longer delayed.",
		["menu_cs_modifier_dozer_rage"] = "When a Bulldozer's faceplate is destroyed, the Bulldozer enters a berserker rage, receiving a 10% increase to their base damage output.",
		["menu_cs_modifier_medic_adrenaline"] = "All Medic units have an additional 15% chance to become an OMNIA LPF.",
		["menu_cs_modifier_cloaker_arrest"] = "Cloaker melee strikes will now cuff players.",
		["menu_cs_modifier_cloaker_smoke"] = "Cloakers will now have a 50% chance to drop a flashbang when they dodge.",
		["menu_cs_modifier_cloaker_tear_gas"] = "All HRT units have an additional 15% chance to become a Titan HRT.",
		["menu_cs_modifier_dozer_lmg"] = "Whenever a Green or Black Bulldozer spawns, there is a chance that it will be replaced by a Skulldozer.",
		["menu_cs_modifier_assault_extender"] = "Police assaults are an additional 25% longer, this is reduced by an additional 5% per hostage, up to a maximum of 4 hostages.",
		["menu_cs_modifier_unfinished"] = "This modifier is currently non functional, check back later!",
		["menu_cs_modifier_10secondsresponsetime"] = "All police assaults now start at maximum intensity.",

		["bm_menu_skill"] = "Crew Boosts",
		["menu_crew_default"] = "DEFAULT SET",

		["menu_crew_interact"] = "Quick",
		["menu_crew_interact_desc"] = "Players interact 15% faster per AI controlled crew member.",

		["menu_crew_inspire"] = "Inspiring",
		["menu_crew_inspire_desc"] = "Bots equipped with this ability can now use the Inspire aced ability.\n\nThey cannot do this more than once every 90 seconds. Cooldown is reduced by 15 seconds per AI controlled crew member.",

		["menu_crew_scavenge"] = "Enduring",
		["menu_crew_scavenge_desc"] = "Players regain 1 down after 3 assault waves.\n\nThe number of assault waves required is reduced by 1 per AI controlled crew member.",

		["menu_crew_ai_ap_ammo"] = "Impacting",
		["menu_crew_ai_ap_ammo_desc"] = "Your crew can shoot through body armor and knock down shields.",

		["menu_crew_healthy"] = "Reinforcer",
		["menu_crew_healthy_desc"] = "Players' health is increased by 30.",

		["menu_crew_sturdy"] = "Protector",
		["menu_crew_sturdy_desc"] = "Players' armor is increased by 10%.",

		["menu_crew_evasive"] = "Distractor",
		["menu_crew_evasive_desc"] = "Players' dodge meters are filled by 3% of their dodge every second.",

		["menu_crew_motivated"] = "Invigorator",
		["menu_crew_motivated_desc"] = "Players have 15 more stamina.",

		["menu_crew_regen"] = "Healer",
		["menu_crew_regen_desc"] = "Players heal 1 health every 4 seconds.",

		["menu_crew_quiet"] = "Concealer",
		["menu_crew_quiet_desc"] = "Players gain 2 more concealment.",

		["menu_crew_generous"] = "Stockpiler ",
		["menu_crew_generous_desc"] = "Players are granted an extra throwable for every 70 kills.",

		["menu_crew_eager"] = "Accelerator",
		["menu_crew_eager_desc"] = "Players reload 10% faster.",

--[[   SKILLTREES   ]]--
	--{

		--[[   MASTERMIND   ]]--
		--{
			--[[   MEDIC SUBTREE   ]]--
			--{

			--Combat Medic--
			["menu_combat_medic_beta_sc"] = "Combat Medic",
			["menu_combat_medic_beta_desc_sc"] = "BASIC: ##$basic##\nYou gain a ##10%## damage reduction for ##5## seconds both after and during reviving another player.\n\nACE: ##$pro##\nReviving a crew member gives them ##30%## more health.",

			--Quick Fix--
			["menu_tea_time_beta_sc"] = "Quick Fix",
			["menu_tea_time_beta_desc_sc"] = "BASIC: ##$basic##\nDecreases your First Aid Kit and Doctor Bag deploy time by ##50%.##\n\nACE: ##$pro##\nCrew members that use your First Aid Kits take ##50%## less damage for ##5## seconds.",

			--Painkillers-- (Payne Killers)
			["menu_fast_learner_beta_sc"] = "Painkillers",
			["menu_fast_learner_beta_desc_sc"] = "BASIC: ##$basic##\nCrew members you revive take ##25%## less damage for ##5## seconds.\n\nACE: ##$pro##\nThe damage reduction is increased by an additional ##25%.##",

			--Uppers--
			["menu_tea_cookies_beta_sc"] = "Uppers",
			["menu_tea_cookies_beta_desc_sc"] = "BASIC: ##$basic##\nAdds ##3## more First Aid Kits to your inventory.\n\nACE: ##$pro##\nAdds ##3## more First Aid Kits to your inventory.\n\nYour deployed first aid kits will be automatically used if a player would go down within a ##5## meter radius of the first aid kit.\n\nThis cannot occur more than once every ##30## seconds individually for each player.",

			--Combat Doctor--
			["menu_medic_2x_beta_sc"] = "Combat Doctor",
			["menu_medic_2x_beta_desc_sc"] = "BASIC: ##$basic##\nYour doctor bags have ##1## more charge.\n\nACE: ##$pro##\nYou can now deploy ##2## Doctor Bags instead of just one.",

			--Inspire--
			["menu_inspire_beta_sc"] = "Inspire",
			["menu_inspire_beta_desc_sc"] = "BASIC: ##$basic##\nYou revive crew members ##50%## faster.\n\nShouting at your teammates will increase their movement and reload speed by ##20%## for ##10## seconds.\n\nACE: ##$pro##\nYou can revive crew members with ##clear line of sight## at a distance of ##9 meters## by shouting at them. This cannot occur more than once every ##90## seconds.",


			--}

			--[[   CONTROLLER SUBTREE   ]]--
			--{

			--Cable Guy--
			["menu_triathlete_beta_sc"] = "Cable Guy",
			["menu_triathlete_beta_desc_sc"] = "BASIC: ##$basic##\nIncreases your supply of cable ties by ##4##.\n\nYou cable tie hostages ##75%## faster.\n\nACE: ##$pro##\nYour chance to pick up cable ties from ammo boxes is increased to ##30%.##\n\nIncreases your maximum cable ties by ##3.##",

			--Smooth Talker-- (LOL)
			["menu_cable_guy_beta_sc"] = "Smooth Talker",
			["menu_cable_guy_beta_desc_sc"] = "BASIC: ##$basic##\nCivilians remain intimidated ##50%## longer.\n\nACE: ##$pro##\nThe power and range of your intimidation is increased by ##50%.##",

			--Stockholm Syndrome--
			["menu_joker_beta_sc"] = "Stockholm Syndrome",
			["menu_joker_beta_desc_sc"] = "BASIC: ##$basic##\nYour hostages will not flee when they have been rescued by law enforcers.\n\nACE: ##$pro##\nNearby civilians and jokers have a chance of reviving you if you interact with them, and have a chance of giving you ammo.",

			--Joker--
			["menu_stockholm_syndrome_beta_sc"] = "Joker",
			["menu_stockholm_syndrome_beta_desc_sc"] = "BASIC: ##$basic##\nYou can convert a non-special enemy to fight on your side. This can not be done during stealth and enemies must surrender before you can convert them. You can only convert one enemy at a time.\n\nYour converted enemy takes ##60%## less damage.\n\nConverted enemies count as hostages for the purposes of skills and trading people out of custody.\n\nACE: ##$pro##\nYou can now have ##2## converted enemies at the same time.\n\nYour converted enemy takes an additional ##20%## less damage.",

			--Partners in Crime--
			["menu_control_freak_beta_sc"] = "Partners in Crime",
			["menu_control_freak_beta_desc_sc"] = "BASIC: ##$basic##\nEach hostage increases your movement speed by ##3%##, up to ##4## times.\n\nACE: ##$pro##\nEach hostage increases your health by ##7.5%##, up to ##4## times.",

			--Hostage Taker--
			["menu_black_marketeer_beta_sc"] = "Hostage Taker",
			["menu_black_marketeer_beta_desc_sc"] = "BASIC: ##$basic##\nYou regenerate ##1## health every ##4## seconds for each hostage, up to ##4## times.\n\nACE: ##$pro##\nHealth regen from Hostage Taker is increased by ##150%## when you have ##4## or more hostages.\n\nNote: Hostage Taker does not stack.",


			--}

			--[[   ASSAULT SUBTREE, FORMERLY SHARPSHOOTER   ]]--
			--{

			--Sturdy Arm--
			["menu_stable_shot_beta_sc"] = "Sturdy Arm",
			["menu_stable_shot_beta_desc_sc"] = "BASIC: ##$basic##\nYou and your crews' stability rating for all weapons is increased by ##5.##\n\nACE: ##$pro##\nReduces the hipfire recoil of SMGs and LMGs by ##25%.##",

			--None in the Chamber--
			["menu_scavenger_sc"] = "None in the Chamber",
			["menu_scavenger_desc_sc"] = "BASIC: ##$basic##\nMovement spread is reduced by ##30%## for SMGs and LMGs.\n\nACE: ##$pro##\nThe emptier your magazine, the faster you reload SMGs and LMGs. Up to ##30%## faster when your magazine is completely empty.",

			--Spray 'n Pray--
			["menu_sharpshooter_sc"] = "Spray 'n Pray",
			["menu_sharpshooter_desc_sc"] = "BASIC: ##$basic##\nBloom spread is reduced by ##30%## for SMGs and LMGs.\n\nACE: ##$pro##\nSMGs and LMGs fire ##15%## faster.\n\nEvery ##5th## bullet fired by an SMG or LMG without releasing the trigger consumes no ammo.",

			--Quintstacked Mags--
			["menu_spotter_teamwork_beta_sc"] = "Quintstacked Mags",
			["menu_spotter_teamwork_beta_desc_sc"] = "BASIC: ##$basic##\nYour weapons' magazine sizes are increased by ##20%.##\n\nNote: Does not apply to single shot weapons.\n\nACE: ##$pro##\nYour weapons' magazine sizes are increased by an additional ##30%.##",

			--Heavy Impact--
			["menu_speedy_reload_sc"] = "Heavy Impact",
			["menu_speedy_reload_desc_sc"] = "BASIC: ##$basic##\nYour bullets can ##now pierce body armor.##\n\nACE: ##$pro##\nYour ranged weapons to have a chance to knock back Shield enemies. Higher damage weapons have a higher chance to knock back shields.\n\nNote: Does not apply to Captain Winters",

			--Bullet Hell--
			["menu_body_expertise_beta_sc"] = "Bullet Hell",
			["menu_body_expertise_beta_desc_sc"] = "BASIC: ##$basic##\nFiring ##5## rounds from an SMG or LMG without releasing the trigger grants the gun a ##40%## chance to not consume ammo, increased rate of fire, and reduced recoil until you stop firing.\n\nACE: ##$pro##\nBullet Hell's effect persists for ##3## seconds after releasing the trigger as long as you don't swap guns, and can be triggered by any automatic gun.\n\nKilling an enemy while Bullet Hell's effect is active loads up to ##4## bullets into the magazine from your total ammo pool.",

			--}
		--}

		--[[   ENFORCER   ]]--
		--{
			--[[   SHOTGUNNER SUBTREE   ]]--
			--{

			--Underdog--
			["menu_underdog_beta_sc"] = "Underdog",
			["menu_underdog_beta_desc_sc"] = "BASIC: ##$basic##\nYou deal ##5%## more gun and melee damage for each enemy within ##8## meters, up to ##25%## more damage.\n\nACE: ##$pro##\nYou take ##5%## less damage for each enemy within ##8## meters, up to ##25%## less damage.",

			--Gung-Ho--
			["menu_close_by_beta_sc"] = "Gung-Ho",
			["menu_close_by_beta_desc_sc"] = "BASIC: ##$basic##\nYour rate of fire is increased by ##20%## while hip-firing with shotguns and flamethrowers.\n\nACE: ##$pro##\nYou can now hip-fire while sprinting.\n\nKilling an enemy while sprinting regenerates ##1## stamina.",

			--Shell Rack--
			["menu_shotgun_cqb_beta_sc"] = "Shell Rack",
			["menu_shotgun_cqb_beta_desc_sc"] = "BASIC: ##$basic##\nKilling an enemy within 8 meters increases your shotgun and flamethrower reload speed by ##4%##, stacking up to ##5## times. All stacks are lost when you reload a gun that benefits from this bonus.\n\nACE: ##$pro##\nStacks apply to all per-round reloads, and grant an additional ##4%## reload speed to such reloads.",

			--Riding Coach--
			["menu_shotgun_impact_beta_sc"] = "Riding Coach",
			["menu_shotgun_impact_beta_desc_sc"] = "BASIC: ##$basic##\nWhen there are ##3## or more enemies within ##8## meters, you draw shotguns and flamethrowers ##75%## faster.\n\nACE: ##$pro##\nWhen there are ##3## or more enemies within ##8## meters, you holster all weapons ##75%## faster.",

			--Shotgun Surgeon--
			["menu_far_away_beta_sc"] = "Shotgun Surgeon",
			["menu_far_away_beta_desc_sc"] = "BASIC: ##$basic##\nShotguns and flamethrowers deal ##75%## more damage to overhealed enemies within ##8## meters.\n\nACE: ##$pro##\nLethal headshots with shotguns and flamethrowers against enemies within ##8## meters cannot be healed by medics.",

			--OVERHEAT--
			["menu_overkill_sc"] = "OVERHEAT",
			["menu_overkill_desc_sc"] = "BASIC: ##$basic##\nShooting an enemy within ##8## meters with a shotgun or flamethrower has a ##40%## chance to cause one of the enemy's carried magazines to cook off, dealing an additional ##50%## of the damage dealt to the target and enemies within ##5## meters.\n\nACE: ##$pro##\nEvery time you kill an enemy within ##8## meters, Overheat's chance to trigger increases by an additional ##10%## for ##10## seconds. This effect stacks up to ##6## times.",

			--}

			--[[   ARMORER SUBTREE   ]]--
			--{

			--Stun Resistance--
			["menu_oppressor_beta_sc"] = "Stun Resistance",
			["menu_oppressor_beta_desc_sc"] = "BASIC: ##$basic##\nEnemy melee attacks push you back ##0.25%## less for every point of armor you have.\n\nACE: ##$pro##\nReduces the visual effect duration of Flashbangs and Concussion Grenades by ##80%.##",

			--Die Hard--
			["menu_show_of_force_sc"] = "Die Hard",
			["menu_show_of_force_desc_sc"] = "BASIC: ##$basic##\nYou gain ##5## deflection.\n\nEach point of deflection makes you take ##1%## less health damage.\n\nACE: ##$pro##\nYou gain an additional ##5## deflection.",

			--Transporter--
			["menu_pack_mule_beta_sc"] = "Transporter",
			["menu_transporter_beta_desc_sc"] = "BASIC: ##$basic##\nFor each ##10## armor points the bag movement penalty is reduced by ##0.5%##.\n\nACE: ##$pro##\nYou can now sprint with any bag.\n\nNote: The movement penalty from the bag still applies.",

			--More Blood to Bleed--
			["menu_iron_man_beta_sc"] = "More Blood to Bleed",
			["menu_iron_man_beta_desc_sc"] = "BASIC: ##$basic##\nYou gain ##15%## extra health.\n\nACE: ##$pro##\nYou gain an additional ##25%## extra health.",

			--Bullseye--
			["menu_prison_wife_beta_sc"] = "Bullseye",
			["menu_prison_wife_beta_desc_sc"] = "BASIC: ##$basic##\nHeadshots regenerate ##5## armor once every ##3## seconds.\n\nACE: ##$pro##\nHeadshots regenerate an additional ##30## armor once every ##3## seconds.",

			--Fully Armored--
			["menu_juggernaut_beta_sc"] = "Fully Armored",
			["menu_juggernaut_beta_desc_sc"] = "BASIC: ##$basic##\nWhile your armor is full, damage taken is reduced by a number of points equal to ##25%## of your maximum armor and sprinting costs ##50%## less stamina.\n\nACE: ##$pro##\nWhen you take damage while your armor is full after it was broken, or when your armor breaks after being full, non-special enemies within ##8## meters of you are staggered.",


			--}

			--[[   AMMO SPECIALIST SUBTREE   ]]--
			--{

			--Scavenger--
			["menu_scavenging_sc"] = "Scavenger",
			["menu_scavenging_desc_sc"] = "BASIC: ##$basic##\nYou gain a ##50%## increased ammo box pick up range.\n\nACE: ##$pro##\nEvery ##5th## enemy you kill will drop an extra ammo box.",

			--Bulletstorm--
			["menu_ammo_reservoir_beta_sc"] = "Bulletstorm",
			["menu_ammo_reservoir_beta_desc_sc"] = "BASIC: ##$basic##\nAmmo bags placed by you grant players the ability to shoot without depleting their ammunition for up to ##5## seconds after interacting with it. The more ammo players replenish, the longer the duration of the effect.\n\nACE: ##$pro##\nIncreases the base duration of the effect by up to ##15## seconds.",

			--Specialist Equipment--
			["menu_portable_saw_beta_sc"] = "Diamond Tipped",
			["menu_portable_saw_beta_desc_sc"] = "BASIC: ##$basic##\nReduces the wear down of saw blades by ##50%.##\n\nACE: ##$pro##\nYou can now saw through shield enemies with your OVE9000 Portable Saw.",

			--Extra Lead--
			["menu_ammo_2x_beta_sc"] = "Extra Lead",
			["menu_ammo_2x_beta_desc_sc"] = "BASIC: ##$basic##\nEach ammo bag contains additional ##200%## ammunition.\n\nACE: ##$pro##\nYou can now place ##2## ammo bags instead of just one.",

			--Rip and Tear--
			["menu_carbon_blade_beta_sc"] = "Specialized Equipment",
			["menu_carbon_blade_beta_desc_sc"] = "BASIC: ##$basic##\nKilling an enemy while you have the the OVE9000 Portable Saw or a weapon that can hold a single shot equipped increases their reload speed by ##75%## for ##1.5## seconds.\n\nACE: ##$pro##\nKilling an enemy while you have the the OVE9000 Portable Saw or a weapon that can hold a single shot equipped has a ##50%## chance to cause nearby enemies in a ##10## meter radius to panic.\n\nPanic makes enemies go into short bursts of uncontrollable fear.",

			--Fully Loaded--
			["menu_bandoliers_beta_sc"] = "Fully Loaded",
			["menu_bandoliers_desc_sc"] = "BASIC: ##$basic##\nYou replenish a throwable for every ##20## ammo boxes you pick up.\n\nACE: ##$pro##\nYou carry and pick up ##50%## more ammo.",

			--}
		--}

		--[[   TECHNICIAN   ]]--
		--{
			--[[   ENGINEER SUBTREE   ]]--
			--{

			--Logistician--
			["menu_defense_up_beta_sc"] = "Logistician",
			["menu_defense_up_beta_desc_sc"] = "BASIC: ##$basic##\nYou deploy and interact with all deployables ##25%## faster.\n\nACE: ##$pro##\nYou and your crew deploy and interact with all deployables ##50%## faster.",

			--Nerves of Steel--
			["menu_fast_fire_beta_sc"] = "Nerves of Steel",
			["menu_fast_fire_beta_desc_sc"] = "BASIC: ##$basic##\nYou can now ##use steel sights while in bleedout.##\n\nACE: ##$pro##\nYou take ##50%## less damage while interacting with objects.",

			--Engineering
			["menu_eco_sentry_beta_sc"] = "Engineering",
			["menu_eco_sentry_beta_desc_sc"] = "BASIC: ##$basic##\nYour sentry guns gain ##40%## more health.\n\nACE: ##$pro##\nYour sentry guns gain an additional ##60%## more health.",

			--Jack of all Trades
			["menu_jack_of_all_trades_beta_sc"] = "Jack of All Trades",
			["menu_jack_of_all_trades_beta_desc_sc"] = "BASIC: ##$basic##\nYou carry ##100%## more throwables.\n\nACE: ##$pro##\nYou can now equip a second deployable to bring with you. Pressing the ##'X'## key will allow you to toggle between deployables.",

			--Tower Defense--
			["menu_tower_defense_beta_sc"] = "Tower Defense",
			["menu_tower_defense_beta_desc_sc"] = "BASIC: ##$basic##\nYou can now toggle AP rounds on your sentry guns, lowering the rate of fire by ##66%## and allowing it to pierce through enemies and shields.\n\nACE: ##$pro##\nYou can now carry a maximum of ##2## sentry guns.\n\nSentry guns now cost ##35%## of your maximum ammo to place.",
			
			--Bulletproof--
			["menu_iron_man_sc"] = "Bulletproof",
			["menu_iron_man_desc_sc"] = "BASIC: ##$basic##\nYour armor cannot be pierced.\n\nACE: ##$pro##\nYour armor recovers ##20%## faster.",

			--}

			--[[   BREACHER SUBTREE   ]]--
			--{

			--Hardware Expert--
			["menu_hardware_expert_beta_sc"] = "Hardware Expert",
			["menu_hardware_expert_beta_desc_sc"] = "BASIC: ##$basic##\nYou fix drills and saws ##20%## faster.\n\nYour drill makes ##65%## less noise.\n\nACE: ##$pro##\nYou fix drills and saws an additional ##30%## faster.\n\nYour drills and saws are now silent. Civilians and guards have to see the drill or saw in order to be alerted.",

			--Danger Close--
			["menu_trip_mine_expert_beta_sc"] = "Danger Close",
			["menu_combat_engineering_desc_sc"] = "BASIC: ##$basic##\nThe radius of trip mine explosion is increased by ##30%.##\n\nACE: ##$pro##\nYour trip mine deals ##50%## more damage.",

			--Full Bore--
			["menu_drill_expert_beta_sc"] = "Full Bore",
			["menu_drill_expert_beta_desc_sc"] = "BASIC: ##$basic##\nYour drill and saw efficiency is increased by ##10%.##\n\nACE: ##$pro##\nFurther increases your drill and saw efficency by ##20%.##",

			--Demoman--
			["menu_more_fire_power_sc"] = "Demoman",
			["menu_more_fire_power_desc_sc"] = "BASIC: ##$basic##\nYou can now carry ##6## shaped charges and ##6## trip mines.\n\nYou deploy shaped charges and trip mines ##20%## faster.\n\nACE: ##$pro##\nYou can now carry ##8## shaped charges and ##10## trip mines.\n\nYou deploy shaped charges and trip mines an additional ##20%## faster.",

			--Kick Starter--
			["menu_kick_starter_beta_sc"] = "Kick Starter",
			["menu_kick_starter_beta_desc_sc"] = "BASIC: ##$basic##\nYour drills and saws gain a ##30%## chance to automatically restart after breaking.\n\nACE: ##$pro##\nYou gain the ability to restart drills and saws by hitting them with a melee attack. You get ##1## chance for each time it breaks with a ##50%## success rate.",

			--Fire Trap--
			["menu_fire_trap_beta_sc"] = "Fire Trap",
			["menu_fire_trap_beta_desc_sc"] = "BASIC: ##$basic##\nYour trip mines now spread fire around the area of detonation for ##10## seconds in a ##7.5## meter radius.\n\nACE: ##$pro##\nYour trip mines now spread fire around the area of detonation for ##20## seconds in an ##11.25## meter radius.",


			--}

			--[[  BATTLE SAPPER  SUBTREE   ]]--
			--{



			--}
		--}

		--[[   GHOST   ]]--
		--{
			--[[   COVERT OPS SUBTREE   ]]--
			--{


			--}

			--[[   COMMANDO SUBTREE   ]]--
			--{

			--Shockproof--
			["menu_insulation_beta_sc"] = "Shockproof",
			["menu_insulation_beta_desc_sc"] = "BASIC: ##$basic##\nMelee attacks that would electrocute you instead counter-electrocute the attacker, dealing ##50%## damage to his health.\n\nSlows last ##50%## of their normal duration.\n\nACE: ##$pro##\nInteracting with an enemy Taser within ##2## seconds of him electrocuting you will counter-electrocute him, dealing ##50%## damage to his health.",


			--}

			--[[   SILENT KILLER SUBTREE   ]]--
			--{

			--Dexterous Hands--
			["menu_scavenger_beta_sc"] = "Dexterous Hands",
			["menu_scavenger_beta_desc_sc"] = "BASIC: ##$basic##\nIncreases the mobility of melee weapons by ##15.##\n\nACE: ##$pro##\nYou can dodge melee attacks. Dodging a melee attack parries the attacker.",

			--Fast Feet--
			["menu_optic_illusions_sc"] = "Fast Feet",
			["menu_optic_illusions_desc_sc"] = "BASIC: ##$basic##\nHitting an enemy with a melee attack restores ##1## stamina.\n\nACE: ##$pro##\nSprinting grants a brief burst of extra speed.\n\nYou must regenerate any amount of stamina before this can occur again.",

			--Silent Precision--
			["menu_silence_expert_beta_sc"] = "Silent Precision",
			["menu_silence_expert_beta_desc_sc"] = "BASIC: ##$basic##\nIf you do not take damage for ##3## seconds, you gain ##25%## increased accuracy and range until you take damage.\n\nACE: ##$pro##\nSilent Precision's accuracy and range bonus persists for ##3## seconds after taking damage.",

			--Unseen Strike--
			["menu_hitman_beta_sc"] = "Unseen Strike",
			["menu_hitman_beta_desc_sc"] = "BASIC: ##$basic##\nIf you do not take damage for ##3## seconds, you gain ##30%## increased critical hit chance until you take damage.\n\nCritical hits deal ##100%## additional damage.\n\nACE: ##$pro##\nUnseen Strike's critical hit chance persists for ##3## seconds after taking damage.",

			--Backstab--
			["menu_backstab_beta_sc"] = "Backstab",
			["menu_backstab_beta_desc_sc"] = "BASIC: ##$basic##\nYour critical hit chance is increased by ##40%## when attacking enemies from behind.\n\nACE: ##$pro##\nKilling an enemy from behind with guns or melee fills your dodge meter by ##100%## of your dodge.",

			--Low Blow--
			["menu_unseen_strike_beta_sc"] = "Low Blow",
			["menu_unseen_strike_beta_desc_sc"] = "BASIC: ##$basic##\nYou gain a ##3%## critical hit chance for every ##3## points of detection risk under ##35## up to a maximum of ##30%.##\n\nCritical hits deal ##100%## additional damage.\n\nACE: ##$pro##\nYou gain a ##3%## critical hit chance for every point of detection risk under ##35## up to a maximum of ##30%.##\n\nKilling an enemy in melee causes your next ##3## bullets to automatically be critical hits. The damage bonus stacks if they would have been critical hits anyway.",

			--}
		--}

		--[[   FUGITIVE   ]]--
		--{
			--[[   GUNSLINGER SUBTREE   ]]--
			--{



			--}

			--[[   RELENTLESS SUBTREE   ]]--
			--{

			--Swan Song--
			["menu_perseverance_desc_sc"] = "BASIC: ##$basic##\nWhen your health reaches ##0##, instead of instantly going down, you can fight for ##4## seconds with a ##50%## movement speed penalty.\n\nACE: ##$pro##\nSwan Song grants infinite ammo, and lasts an additional ##4## seconds.",



			--}

			--[[   BRAWLER SUBTREE   ]]--
			--{

			--Martial Arts--
			["menu_martial_arts_beta_sc"] = "Iron Knuckles",
			["menu_martial_arts_beta_desc_sc"] = "BASIC: ##$basic##\nYou take ##50%## less damage from all melee attacks because of training.\n\nACE: ##$pro##\nYou gain a ##15%## damage reduction while your melee weapon is drawn.",

			--Bloodthirst--
			["menu_bloodthirst_sc"] = "Bloodthirst",
			["menu_bloodthirst_desc_sc"] = "BASIC: ##$basic##\nKilling an enemy outside of melee increases your next melee attack's knockdown by ##30%##, up to a maximum of ##90%.##\n\nACE: ##$pro##\nKilling an enemy outside of melee increases your next melee attack's damage by ##20%##, up to a maximum of ##60%.##.",
			
			--Pumping Iron--
			["menu_steroids_beta_sc"] = "Pumping Iron",
			["menu_steroids_beta_desc_sc"] = "BASIC: ##$basic##\nYou swing and charge melee weapons ##20%## faster.\n\nACE: ##$pro##\nYou swing and charge melee weapons an additional ##30%## faster.",

			--Snatch--
			["menu_wolverine_beta_sc"] = "Snatch",
			["menu_wolverine_beta_desc_sc"] = "BASIC: ##$basic##\nMelee kills instantly load ##3## rounds into your current gun from your total ammo pool. Grenade and Rocket Launchers only receive ##1## round instead.\n\nACE: ##$pro##\nMelee kills increase your reload speed by ##50%## for ##10## seconds.",

			--Counter Strike--
			["menu_drop_soap_beta_sc"] = "Counter Strike",
			["menu_drop_soap_beta_desc_sc"] = "BASIC: ##$basic##\nYou can now parry cloaker kicks while you have your melee weapon drawn, knocking them down.\n\nACE: ##$pro##\nYou can now parry dozer punches while you have your melee weapon drawn, briefly stunning them.",

			--Frenzy--
			["menu_frenzy_sc"] = "Frenzy",
			["menu_frenzy_desc_sc"] = "BASIC: ##$basic##\nYour health cannot be increased above ##25%##, but you deal ##150%## more saw and melee damage.\n\nACE: ##$pro##\nYou deal ##75%## more gun damage.",



			--}
		--}
	--}

		--Deep Pockets--
		["menu_thick_skin_beta_sc"] = "Second Wind",
		["menu_thick_skin_beta_desc_sc"] = "BASIC: ##$basic##\nWhen your armor breaks you gain ##10%## speed until it has regenerated to full.\n\nACE: ##$pro##\nWhen your armor breaks you gain ##15%## speed until ##2## seconds after it has regenerated to full.",

		--Duck & Cover--
		["menu_sprinter_beta_sc"] = "Duck & Cover",
		["menu_sprinter_beta_desc_sc"] = "BASIC: ##$basic##\nYour stamina starts regenerating ##25%## earlier and ##25%## faster.\n\nACE: ##$pro##\nYour dodge meter fills up by ##8%## of your dodge every second while crouching.",

		--Sneaky Bastard--
		["menu_jail_diet_beta_desc_sc"] = "BASIC: ##$basic##\nYou gain ##1## point of dodge for every ##3## points of detection risk under ##35## up to a maximum of ##10##\n\nACE: ##$pro##\nYou gain ##1## point of dodge for every point of detection risk under ##35## up to a maximum of ##10##.\n\nWhile your armor is broken, dodging an attack restores ##15## health. This can only occur once every time your armor breaks.",

		--Sharpshooter--
		["menu_discipline_sc"] = "Sharpshooter",
		["menu_discipline_desc_sc"] = "BASIC: ##$basic##\nLethal headshots using Rifles set to semi-auto increase your accuracy with guns by ##10## for ##10## seconds.\n\nACE: ##$pro##\nLethal headshots using Rifles set to semi-auto increase your rate of fire by ##20%## for ##10## seconds.",

		--Tactical Precision--
		["menu_heavy_impact_beta_sc"] = "Tactical Precision",
		["menu_heavy_impact_beta_desc_sc"] = "BASIC: ##$basic##\nYou aim down sights ##75%## faster.\n\nYour guns gain ##15%## more accuracy and range while aiming down sights.\n\nACE: ##$pro##\nYou reload rifles ##35%## faster while fewer than ##3## enemies are within ##8## meters.",

		--Rapid Reset--
		["menu_engineering_beta_sc"] = "Rapid Reset",
		["menu_engineering_beta_desc_sc"] = "BASIC: ##$basic##\nLethal headshots using Rifles remove ##50%## of their bloom spread.\n\nACE: ##$pro##\nLethal headshots using Rifles will increase your reload speed by ##50%## for ##10## seconds.",

		--Ammo Efficiency--
		["menu_single_shot_ammo_return_sc"] = "Ammo Efficiency",
		["menu_single_shot_ammo_return_desc_sc"] = "BASIC: ##$basic##\nGetting ##2## lethal headshots with Rifles in less than ##6## seconds will grant ##3%## of your maximum ammo to the Rifle.\n\nACE: ##$pro##\nThe effect is now triggered upon landing ##2## lethal headshots within ##10## seconds, and the ammo is refunded directly into your magazine whenever possible.",

		--Helmet Popping--
		["menu_rifleman_sc"] = "Helmet Popping",
		["menu_rifleman_desc_sc"] = "BASIC: ##$basic##\nRifle bullets pierce through heads. Rifle bullets that pierce through heads deal ##100%## more damage to any other enemies they hit.\n\nACE: ##$pro##\nRifle headshots deal ##25%## more damage to enemies you have already headshot.",

		--Mind Blown--
		["menu_kilmer_sc"] = "Mind Blown",
		["menu_kilmer_desc_sc"] = "BASIC: ##$basic##\nHeadshots with Rifles deal ##70%## of the damage dealt to the closest enemy in a ##5## meter radius.\n\nFor every ##8## meters away you are from the enemy, the effect chains to an additional enemy.\n\nACE: ##$pro##\nIf you are more than ##8## meters away from the enemy, the chaining effect deals a full ##100%## damage dealt.",

		--Cleaner--
		["menu_jail_workout_sc"] = "Cleaner",
		["menu_jail_workout_desc_sc"] = "BASIC: ##$basic##\nYou gain ##1## additional body bag in your inventory.\n\nYou deal ##5%## more damage against special enemies.\n\nACE: ##$pro##\nYou gain the ability to place ##2## body bag cases.\n\nYou deal an additional ##10%## damage against special enemies.",

		--Nimble--
		["menu_cleaner_beta_sc"] = "Nimble",
		["menu_cleaner_beta_desc_sc"] = "BASIC: ##$basic##\nYou pick all locks and handcuffs ##50%## faster.\n\nACE: ##$pro##\nYou can now ##silently crack safes by hand.##",

		--Sixth Sense--
		["menu_chameleon_beta_sc"] = "Sixth Sense",
		["menu_chameleon_beta_desc_sc"] = "BASIC: ##$basic##\nYou gain the ability to automatically mark enemies within a ##10## meter radius around you after standing still for ##3.5## seconds.\n\nACE: ##$pro##\nYou ##gain access to all insider assets.##",

		--Systems Specialist--
		["menu_second_chances_beta_sc"] = "Systems Specialist",
		["menu_second_chances_beta_desc_sc"] = "BASIC: ##$basic##\nYour camera loop duration is increased by ##20## seconds.\n\nYou interact with all computers, hacks, cameras, and ECMs ##25%## faster.\n\nACE: ##$pro##\nIncreases the duration of marked enemies by ##100%## and you can now mark specials and guards in stealth by aiming at them with any weapon.\n\nYou interact with all computers, hacks, cameras, and ECMs an additional ##50%## faster.",

		--ECM Specialist--
		["menu_ecm_booster_beta_sc"] = "ECM Specialist",
		["menu_ecm_booster_beta_desc_sc"] = "BASIC: ##$basic##\nYou can now place ##3## ECM jammers instead of just two.\n\nACE: ##$pro##\nYou can now place ##4## ECM jammers instead of just three.",

		--ECM Overdrive--
		["menu_ecm_2x_beta_sc"] = "ECM Overdrive",
		["menu_ecm_2x_beta_desc_sc"] = "BASIC: ##$basic##\nYour ECM jammer can ##now be used to open certain electronic doors.##\n\nYour ECM jammer and feedback duration is increased by ##25%.##\n\nACE: ##$pro##\nThe ECM jammer duration is increased by an additional ##25%## and the ECM feedback duration lasts ##25%## longer.\n\nPagers are delayed by the ECM jammer.",

		--Evasion--
		["menu_awareness_beta_sc"] = "Evasion",
		["menu_awareness_beta_desc_sc"] = "BASIC: ##$basic##\nYou can sprint at full speed in any direction.\n\nYou can fall ##25%## further.\n\nACE: ##$pro##\nRun and reload - you can reload your weapons while sprinting.",

		--Moving Target--
		["menu_dire_need_beta_sc"] = "Moving Target",
		["menu_dire_need_beta_desc_sc"] = "BASIC: ##$basic##\nYou gain ##2%## extra movement speed for every ##3## points of detection risk under ##35##, up to ##20%.##\n\nACE: ##$pro##\nYou gain ##2%## extra movement speed for every point of detection risk under ##35##, up to ##20%.##\n\nYour dodge meter fills up by ##15%## of your dodge every second while sprinting.\n\nYour dodge meter fills up by ##60%## of your dodge every second while on a zipline.",

		--Equilibrium--
		["menu_equilibrium_beta_sc"] = "Fast on the Draw",
		["menu_equilibrium_beta_desc_sc"] = "BASIC: ##$basic##\nYou draw and holster pistols ##50%## faster\n\nACE: ##$pro##\nSwapping to a pistol causes its first shot to fire an additional bullet.",

		--Snap Shot--
		["menu_dance_instructor_sc"] = "Snap Shot",
		["menu_dance_instructor_desc_sc"] = "BASIC: ##$basic##\nPistol bullets ricochet off of shields and walls.\n\nNote: Does not apply to bullets that penetrate through shields or walls.\n\nACE: ##$pro##\nBullets from any gun ricochet off of shields and walls.",

		--Trusty Sidearm--
		["menu_gun_fighter_sc"] = "Trusty Sidearm",
		["menu_gun_fighter_desc_sc"] = "BASIC: ##$basic##\nYou holster weapons ##50%## faster when their magazine is empty.\n\nPistols reload ##20%## faster while your other weapon's magazine is empty.\n\nACE: ##$pro##\nYou automatically reload your other weapon at ##35%## speed while you have a pistol equipped.",

		--Ambidexterity--
		["menu_akimbo_skill_sc"] = "Ambidexterity",
		["menu_akimbo_skill_desc_sc"] = "BASIC: ##$basic##\nYou can now equip akimbo weapons.\n\nACE: ##$pro##\nAkimbo weapons gain ##35%## more total ammo capacity and pickup.",
		["bm_menu_skill_locked_x_g17"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_b92fs"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_g18c"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_jowi"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_pl14"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_legacy"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_g22c"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_usp"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_1911"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_chinchilla"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_mp5"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_sr2"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_mac10"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_akmsu"] = "Requires the Ambidexterity skill.",
		["bm_menu_skill_locked_x_basset"] = "Requires the Ambidexterity skill.",

		--Desperado--
		["menu_expert_handling_sc"] = "Desperado",
		["menu_expert_handling_desc_sc"] = "BASIC: ##$basic##\nEach pistol headshot grants pistols an ##8%## accuracy and range boost for ##6## seconds. This effect can stack ##5## times.\n\nACE: ##$pro##\nStacks now last for ##10## seconds, and grant all guns increased accuracy and range.",
		
		--Trigger Happy--
		["menu_trigger_happy_beta_sc"] = "Trigger Happy",
		["menu_trigger_happy_beta_desc_sc"] = "BASIC: ##$basic##\nEach pistol headshot grants pistols a ##10%## damage boost for ##6## seconds. This effect can stack ##5## times.\n\nACE: ##$pro##\nStacks now last for ##10## seconds, and grant all guns increased damage.",

		--Running From Death--
		["menu_nine_lives_beta_sc"] = "Running from Death",
		["menu_nine_lives_beta_desc_sc"] = "BASIC: ##$basic##\nYou move ##25%## faster for ##10## seconds after being revived.\n\nACE: ##$pro##\nYou gain a ##30%## damage reduction for ##10## seconds after being revived.\n\nYour weapons are instantly reloaded after reviving.",

		--Undying--
		["menu_running_from_death_beta_sc"] = "Undying",
		["menu_running_from_death_beta_desc_sc"] = "BASIC: ##$basic##\nYou gain a ##100%## increase to bleedout health.\n\nACE: ##$pro##\nYou gain an additional ##100%## increase to bleedout health.\n\nYou may use your primary weapon while in bleedout.",

		--What Doesn't Kill--
		["menu_what_doesnt_kill_beta_sc"] = "What Doesn't Kill",
		["menu_what_doesnt_kill_beta_desc_sc"] = "BASIC: ##$basic##\nIncoming damage is reduced by ##1.5## points for each down you are closer to custody. \n\nACE: ##$pro##\nIncoming damage is reduced by an additional ##3## points at all times.",

		--Haunt--
		["menu_haunt_sc"] = "Haunt",
		["menu_haunt_desc_sc"] = "BASIC: ##$basic##\nKilling an enemy within ##18## meters has a ##5%## chance to spread panic for each down you are closer to custody.\n\nPanic makes enemies go into short bursts of uncontrollable fear.\n\nACE: ##$pro##\nEnemy panic chance is increased by an additional ##10%## at all times.",

		--Messiah--
		["menu_pistol_beta_messiah_sc"] = "Messiah",
		["menu_pistol_beta_messiah_desc_sc"] = "BASIC: ##$basic##\nYou can be downed ##1## additional time before going into custody for the first time.\n\nACE: ##$pro##\nWhile in bleedout, killing an enemy will allow you to revive yourself. This effect has a ##80## second cooldown. Kills while downed reduce the cooldown by ##20## seconds.",
	})
end)

Hooks:Add("LocalizationManagerPostInit", "SC_Localization_Perk_Decks", function(loc)
	LocalizationManager:add_localized_strings({
		["bm_menu_dodge"] = "Dodge",

		--Shared Upgrades--
		["menu_deckall_name_sc"] = "Damage Boost",
		["menu_deckall_2_desc_sc"] = "You do ##25%## more damage.",
		["menu_deckall_4_desc_sc"] = "You do an additional ##25%## more damage.",
		["menu_deckall_6_desc_sc"] = "You do an additional ##25%## more damage.",
		["menu_deckall_8_desc_sc"] = "You do an additional ##25%## more damage.",

		--Crook--
		["menu_deck6_1_desc_sc"] = "Your dodge is increased by ##5## points.\n\nYour armor is increased by ##15%## for ballistic vests.",
		["menu_deck6_3_desc_sc"] = "Your dodge is increased by an additional ##5## points for ballistic vests.",
		["menu_deck6_5_desc_sc"] = "Your armor is increased by an additional ##15%## for ballistic vests.",
		["menu_deck6_7_desc_sc"] = "Your dodge is increased by an additional ##5## points for ballistic vests.",
		["menu_deck6_9_desc_sc"] = "Your armor is increased by an additional ##20%## for ballistic vests.\n\nDeck completion Bonus: Your chance of getting a higher quality item during PAYDAY is increased by ##10%.##",

		--Rogue
		["menu_deck4_1_desc_sc"] = "Your dodge is increased by ##5## points.\n\nYou swap between your weapons ##50%## faster.",
		["menu_deck4_3_desc_sc"] = "Your dodge is increased by an additional ##5## points.",
		["menu_deck4_5_desc_sc"] = "Your dodge meter will be filled to ##200%## of its normal maximum when you are revived.",
		["menu_deck4_7_desc_sc"] = "Your dodge is increased by an additional ##5## points.",
		["menu_deck4_9_desc_sc"] = "Dodging an attack causes you to regenerate ##1## health every ##2## seconds for the next ##20## seconds. This effect can stack up to ##10## times, but all stacks are lost whenever you take health damage.\n\nDeck completion Bonus: Your chance of getting a higher quality item during PAYDAY is increased by ##10%.##",

		--Hitman--
		["menu_deck5_1_sc"] = "Gun-fu",
		["menu_deck5_3_sc"] = "Trained Assassin",
		["menu_deck5_5_sc"] = "With a Pencil",
		["menu_deck5_7_sc"] = "Expert Assassin",

		["menu_deck5_1_desc_sc"] = "Killing an enemy outside of melee stores ##25## health. You can store up to ##75## health.\n\nKilling an enemy in melee turns that stored health into temporary health that decays at a rate of ##5## per second.\n\nTemporary health can exceed your normal maximum health, but you can only have up to ##240## temporary health at once.\n\nNote: Frenzy will reduce temporary health by ##75%##.",
		["menu_deck5_3_desc_sc"] = "Your dodge meter fills up by ##100%## of your dodge when your armor is restored.\n\nYou gain ##5## dodge points.",
		["menu_deck5_5_desc_sc"] = "You store ##60%## more health.",
		["menu_deck5_7_desc_sc"] = "You gain ##120## temporary health when you are revived.\n\nYou gain an additional ##5## dodge points.",
		["menu_deck5_9_desc_sc"] = "While you have temporary health, you gain ##20## deflection and ##20%## additional movement speed.\n\nEach point of deflection makes you take ##1%## less health damage.\n\nDeck completion Bonus: Your chance of getting a higher quality item during PAYDAY is increased by ##10%.##",

		["menu_deck2_1_desc_sc"] = "You gain ##10%## more health.",
		["menu_deck2_3_desc_sc"] = "You gain an additional ##10%## more health.",
		["menu_deck2_5_desc_sc"] = "You gain an additional ##10%## more health.",
		["menu_deck2_7_desc_sc"] = "Every shot you fire with your guns has a ##5%## chance to spread panic among your enemies.\n\nPanic will make enemies go into short bursts of uncontrollable fear.",
		["menu_deck2_9_desc_sc"] = "You gain an additional ##10%## more health.\n\nYou gain ##25%## of your maximum health after reviving.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		["menu_deck1_3_desc_sc"] = "You and your crew's stamina is increased by ##50%##.\n\nIncreases your shout distance by ##25%##.\n\nNote: Crew perks do not stack.",
		["menu_deck1_5_desc_sc"] = "You and your crew gain ##5%## more health.",
		["menu_deck1_7_desc_sc"] = "Incoming damage is reduced by ##1## point for you and your crew for each hostage up to ##4## times.",
		["menu_deck1_9_desc_sc"] = "You and your crew gains ##5%## max health and ##5%## stamina for each hostage up to ##4## times.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",
		
		--Armorer--
		["menu_deck3_1_desc_sc"] = "You gain ##10%## more armor.",
		["menu_deck3_3_desc_sc"] = "You gain an additional ##10%## more armor.",
		["menu_deck3_5_desc_sc"] = "You gain an additional ##5%## more armor.",
		["menu_deck3_7_desc_sc"] = "Your armor recovery rate is increased by ##10%##.",
		["menu_deck3_9_desc_sc"] = "Your armor recovery rate is increased by an additional ##10%##.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Burglar--
		["menu_deck7_1_desc_sc"] = "Your dodge is increased by ##5## points.",
		["menu_deck7_3_desc_sc"] = "Your dodge is increased by an additional ##5## points.\n\nYou bag corpses ##20%## faster.",
		["menu_deck7_5_desc_sc"] = "You pick locks ##20%## faster.",
		["menu_deck7_7_desc_sc"] = "Your dodge is increased by an additional ##5## points.\n\nYou answer pagers ##10%## faster.",
		["menu_deck7_9_desc_sc"] = "Your armor recovery rate is increased by ##10%##.\n\nDeck completion Bonus: Your chance of getting a higher quality item during PAYDAY is increased by ##10%.##",

		--Gambler--
		["menu_deck10_1_desc_sc"] = "Ammo supplies you pick up also yield medical supplies that heal you for ##4## to ##8## health.\n\nCannot occur more than once every ##10## seconds, but every ammo box you pick up reduces this by ##3## to ##5## seconds.",
		["menu_deck10_3_desc_sc"] = "When you get healed from picking up ammo packs, your teammates also gain an ammo pickup.\n\nYou gain ##5## dodge points.",
		["menu_deck10_5_desc_sc"] = "Increase health gained from ammo packs by an additional ##2##.\n\nWhen you get healed from picking up ammo packs, your dodge meter is also filled up by ##100%## of your dodge.",
		["menu_deck10_7_desc_sc"] = "When you get healed from picking up ammo packs, your teammates also get healed for ##50%## of the amount.\n\nYou gain ##5## dodge points.",
		["menu_deck10_9_desc_sc"] = "Increase health gained from ammo packs by an additional ##2##.\n\nWhen you get healed from picking up ammo packs, you also gain ##30## armor.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Infiltrator--
		["menu_deck8_1_desc_sc"] = "##4%## less damage from enemies for each enemy within ##8## meters, up to ##20%## less damage.",
		["menu_deck8_3_desc_sc"] = "##5%## less damage from enemies for each enemy within ##8## meters, up to ##25%## less damage.",
		["menu_deck8_5_desc_sc"] = "##6%## less damage from enemies for each enemy within ##8## meters, up to ##30%## less damage.",
		["menu_deck8_7_desc_sc"] = "You move ##10%## faster while there are fewer than ##3## enemies within ##8## meters.",
		["menu_deck8_9_desc_sc"] = "Each successful melee hit heals ##1## health every ##1.5## seconds for ##7.5## seconds, this effect can stack up to ##5## times.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Sociopath--
		["menu_deck9_1_sc"] = "No Talk",
		["menu_deck9_1_desc_sc"] = "When there are ##3## or more enemies within ##8## meters, you take ##15%## less damage.",
		["menu_deck9_3_desc_sc"] = "Killing an enemy regenerates ##20## armor.\n\nThis cannot occur more than once every ##3## seconds.",
		["menu_deck9_5_desc_sc"] = "Killing an enemy with a melee weapon regenerates ##5%## health.\n\nThis cannot occur more than once every second.",
		["menu_deck9_7_desc_sc"] = "Killing an enemy within ##18## meters regenerates an additional ##20## armor.\n\nThis cannot occur more than once every ##3## seconds.",
		["menu_deck9_9_desc_sc"] = "Killing an enemy within ##18## meters has a ##25%## chance to spread panic among your enemies.\n\nPanic will make enemies go into short bursts of uncontrollable fear.\n\nThis cannot occur more than once every ##2## seconds.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Grinder--
		["menu_deck11_1_desc_sc"] = "Killing an enemy heals ##1## health every second for ##6## seconds, this effect stacks up to ##4## times. The duration of your stacks is refreshed every time you deal damage.\n\nYour maximum armor is reduced by ##50%##.",
		["menu_deck11_3_desc_sc"] = "Stacks last for ##10## seconds.",
		["menu_deck11_5_desc_sc"] = "Stacks now heal ##1## health every ##0.5## seconds.",
		["menu_deck11_7_desc_sc"] = "You can now have up to ##8## stacks.",
		["menu_deck11_9_desc_sc"] = "Every stack increases your movement speed by ##2.5%##.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Ex-President-- ... or is it like, EX-President?  like a boss term?
		["menu_deck13_1_desc_sc"] = "While your armor is up, you will store ##4## health for every enemy you kill.\n\nWhen your armor starts to regenerate after being completely depleted, you will gain health equal to the stored health amount.\n\nMaximum amount of stored health depends on your equipped armor, with heavier armors being able to store less health than lighter armors.",
		["menu_deck13_3_desc_sc"] = "Increases the amount of health stored from kills by ##2##.\n\nYour dodge is increased by ##5## points.",
		["menu_deck13_5_desc_sc"] = "Increases the maximum health that can be stored by ##25%##.",
		["menu_deck13_7_desc_sc"] = "Increases the amount of health stored from kills by ##2##.\n\nYour dodge is increased by an additional ##5## points.",
		["menu_deck13_9_desc_sc"] = "Killing an enemy speeds up your armor recovery speed depending on your equipped armor. Heavier armors gain a smaller bonus than lighter armors. This bonus is reset whenever your armor recovers.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Maniac--
		["menu_deck14_1_desc_sc"] = "Damage you deal is converted into Hysteria Stacks. Max amount of stacks is ##2400##.\n\nHysteria Stacks:\nIncoming damage is reduced by ##1## point for every ##400## stacks of Hysteria. Hysteria Stacks decay by ##400## every ##8## seconds.",
		["menu_deck14_5_desc_sc"] = "Changes the decay of your Hysteria Stacks to ##300## every ##8## seconds.",
		["menu_deck14_7_desc_sc"] = "Incoming damage is now reduced by ##1## point for every ##300## stacks of Hysteria.",
		["menu_deck14_9_desc_sc"] = "Hysteria stacks are ##100%## more potent for you.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Anarchist--
		["menu_deck15_1_desc_sc"] = "Instead of fully regenerating armor when out of combat, The Anarchist will periodically regenerate armor at a rate equivalent to ##8## armor per second. Heavier armor regenerates more armor per tick, but has a longer delay between ticks.\n\nNote: Skills and perks that increases the armor recovery rate are disabled when using this perk deck.",
		["menu_deck15_3_desc_sc"] = "##50%## of your health is converted into ##50%## armor.",
		["menu_deck15_5_desc_sc"] = "##50%## of your health is converted into ##100%## armor.",
		["menu_deck15_7_desc_sc"] = "##50%## of your health is converted into ##150%## armor.",
		["menu_deck15_9_desc_sc"] = "Dealing damage will grant you armor - This can only occur once every ##3## seconds. Heavier armors are granted more armor.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Kingpin--
		["menu_deck17_1_desc_sc"] = "Unlocks and equips the Kingpin Injector. Changing to another perk deck will make the Injector unavailable again. The Injector replaces your current throwable, is equipped in your throwable slot and can be switched out if desired.\n\nWhile in game you can use the throwable key to activate the injector. Activating the injector will heal you for ##30%## of all damage taken or dodged for ##4## seconds.\n\nYou can still take damage during the effect. The Injector can only be used once every ##30## seconds.",
		["menu_deck17_3_desc_sc"] = "Your movement speed is increased by ##20%## while the Kingpin Injector is active.\n\nActivating the Injector fills your dodge meter by ##250%## of your dodge.",
		["menu_deck17_5_desc_sc"] = "You are now healed for ##30%## of all damage taken or dodged for ##6## seconds while the Kingpin Injector is active.\n\nEnemies nearby will prefer targeting you, whenever possible, while the Injector is active.",
		["menu_deck17_7_desc_sc"] = "The amount of health received during the Injector effect is increased to ##80%## while below ##25%## health.\n\nActivating the Injector fills your dodge meter by an additional ##250%## of your dodge.",
		["menu_deck17_9_desc_sc"] = "For every ##5## health gained during the injector effect while at maximum health, the recharge time of the injector is reduced by ##2## seconds.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",
		["bm_ability_chico_injector_desc"] = "A medical injection device, filled with something mysterious.\n\nUpon consumption, the user's pain reception is dulled significantly. Such an effect is potent, and those high on these stimulants are known to be extremely threatening.\n\nThe world is yours.", --i'm sorry i needed to fix it
		
		--Sicario--
		["menu_deck18_1_desc_sc"] = "Your dodge is increased by ##5## points.\n\nUnlocks and equips the throwable ##Smoke Bomb.##\n\nWhen deployed, the smoke bomb creates a smoke screen that lasts for ##12## seconds. While standing inside the smoke screen, you and your allies regenerate armor ##100%## faster. Any enemies that stand in the smoke will see their accuracy reduced by ##80%##.\n\nThe Smoke Bomb has a ##40## second cooldown, but killing enemies will reduce this cooldown by ##1## second.",
		["menu_deck18_3_desc_sc"] = "Your dodge is increased by an additional ##5## points.",
		["menu_deck18_5_desc_sc"] = "Killing an enemy while inside of the smoke bomb reduces its cooldown by ##3## seconds.",
		["menu_deck18_7_desc_sc"] = "Your dodge is increased by an additional ##5## points.",
		["menu_deck18_9_desc_sc"] = "Your dodge meter fills up by ##100%## of your dodge every second while you are inside of your smoke screen.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Stoic--
		["menu_deck19_1_desc_sc"] = "Unlocks and equips the Stoic Hip Flask.\n\n##30%## of damage taken is applied over time (##8## seconds).\n\nYou can use the throwable key to activate the Stoic Hip Flask and immediately negate any damage-over-time.\n\nWhenever damage-over-time is negated, you heal for ##300%## of the remaining damage-over-time. The flask has a ##30## second cooldown.\n\nAll of your ##armor is converted to 50% health.##",
		["menu_deck19_3_desc_sc"] = "The cooldown of your flask will be reduced by ##1## second for each enemy you kill.",
		["menu_deck19_5_desc_sc"] = "After not taking damage for ##4## seconds any remaining damage-over-time will be negated.",
		["menu_deck19_7_desc_sc"] = "When your health is below ##50%##, the cooldown of your flask will be reduced by ##6## seconds for each enemy you kill.",
		["menu_deck19_9_desc_sc"] = "You gain ##25%## of your maximum health after reviving.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Tag Team--
		["menu_deck20_1_desc_sc"] = "Unlocks and equips the ##Gas Dispenser.##\n\nTo activate the Gas Dispenser you need to look at another allied unit within a ##18## meter radius with clear line of sight and press the throwable key to tag them.\n\nKills you or the tagged unit make heal you for ##8## health and the tagged unit for ##5## health.\n\nThe effect lasts for ##11## seconds, and has a cooldown of ##80## seconds.",
		["menu_deck20_3_desc_sc"] = "Enemies you or the tagged unit kill extend the duration of the gas dispenser by ##2## seconds. This increase is reduced by ##0.2## seconds each time it happens.",
		["menu_deck20_5_desc_sc"] = "Each enemy you or the tagged unit kills reduces damage you take by ##0.5## points up to a maximum of ##8## until the Gas Dispenser's effect and cooldown ends.",
		["menu_deck20_7_desc_sc"] = "Healing from the Gas Dispenser is increased by ##100%##.",
		["menu_deck20_9_desc_sc"] = "Each enemy you kill will reduce the cooldown of the Gas Dispenser by ##2## seconds.\n\nEach enemy the tagged unit kills will reduce the cooldown of the Gas Dispenser by ##2## seconds until you are no longer paired.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Biker--
		["menu_deck16_1_desc_sc"] = "Every time you or your crew performs a kill you will gain ##2## health. This can only occur once every ##2## seconds.",
		["menu_deck16_3_desc_sc"] = "You regenerate ##10## armor every ##3## seconds.",
		["menu_deck16_5_desc_sc"] = "Every ##25%## armor missing reduces cooldown to kill regen by ##0.5## seconds.",
		["menu_deck16_7_desc_sc"] = "You now regenerate ##20## armor every ##2.5## seconds.\n\nKilling an enemy with a melee weapon instantly triggers this effect and causes the next armor regen tick to occur ##1## second sooner.",
		["menu_deck16_9_desc_sc"] = "Every ##25%## armor missing increases the number of health gained from kills by ##2##.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Yakuza--
		["menu_deck12_1_desc_sc"] = "The lower your health, the faster your dodge meter will passively fill up. When your health is below ##50%##, your dodge meter fills by up to ##10%## of your dodge every second.\n\nYour dodge is increased by ##5## points.",
		["menu_deck12_3_desc_sc"] = "The lower your health the more your dodge meter is filled when you kill an enemy. When your health is below ##50%##, your meter fills by up to ##50%## of your dodge.",
		["menu_deck12_5_desc_sc"] = "The lower your health, the less damage you take. When your health is below ##50%##, you will take up to ##25%## less damage.",
		["menu_deck12_7_desc_sc"] = "The lower your health the more your dodge meter is filled when you kill an enemy in melee. When your health is below ##50%##, your meter fills by up to ##50%## of your dodge.\n\nThis effect stacks with Hebi Irezumi.",
		["menu_deck12_9_desc_sc"] = "Once every ##300## seconds, if you would be downed as a result of your health depleting you instead survive with ##1## health and ##50## armor. Killing an enemy reduces this cooldown by ##5## seconds.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Hacker--
		["menu_deck21_1_desc_sc"] = "Unlocks and equips the ##Pocket ECM Device##.\n\nWhile in game you can use the throwable key to activate the Pocket ECM Device.\n\nActivating the Pocket ECM Device before the alarm is raised will trigger the jamming effect, disabling all electronics and pagers for a ##12## second duration.\n\nActivating the Pocket ECM Device after the alarm is raised will trigger the feedback effect, granting a chance to stun enemies on the map every second for a ##12## second duration.\n\nThe Pocket ECM Device has ##1## charge with a ##80## second cooldown timer, but each kill you perform will shorten the cooldown timer by ##3## seconds.",
		["menu_deck21_3_desc_sc"] = "Your dodge is increased by ##5## points.",
		["menu_deck21_5_desc_sc"] = "Killing an enemy while the feedback effect is active will regenerate ##20## health.",
		["menu_deck21_7_desc_sc"] = "Your armor recovery rate is increased by ##10%##.\n\nYour dodge is increased by an additional ##5## points.",
		["menu_deck21_9_desc_sc"] = "Crew members killing enemies while the feedback effect is active will regenerate ##10## health.\n\nDeck Completion Bonus: Your chance of getting a higher quality item during a PAYDAY is increased by ##10%.##",

		--Blank Deck & Wildcard--
		["menu_st_spec_0"] = "Blank Deck",
		["menu_st_spec_22"] = "Blank Deck",
		["menu_st_spec_0_desc"] = "This deck has no benefits at all.\n\nFor the heister looking for punishment.",
		["menu_st_spec_00"] = "Wildcard Deck",
		["menu_st_spec_23"] = "Wildcard Deck",
		["menu_st_spec_00_desc"] = "This deck only has the shared upgrades.\n\nFor the heister looking for danger.",
		["menu_deck0_1"] = "",
		["menu_deck0_1_desc"] = "",
	})
end)


