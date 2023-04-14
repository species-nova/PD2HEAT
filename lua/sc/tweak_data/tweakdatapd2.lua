-- Custom menu poses
Hooks:PostHook(TweakData, "_setup_scene_poses", "ResScenePoses", function(self)
	self.scene_poses.weapon.ray = {"husk_generic1", "husk_generic2", "husk_generic3", "husk_generic4"}
	self.scene_poses.weapon.ray.required_pose = false
	self.scene_poses.weapon.osipr = {"husk_mosconi"}
end)