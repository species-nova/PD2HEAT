--Should stick these in a global table somewhere since I constantly paste them in for debugging purposes.
heat = heat or {}
	local indent_strs = {
		"",
		"    ",
		"        ",
		"            "
	}

	local function get_indent(indent)
		while not indent_strs[indent] do
			table.insert(indent_strs, indent_strs[#indent_strs] .. "    ")
		end
		return indent_strs[indent]
	end

	local function print_table(t, name, max_depth, indent, seen)
		indent = indent and indent + 1 or 1
		local i = get_indent(indent)
		if max_depth and indent > max_depth then log(i .. "...") return end

		seen = seen or {}
		name = name or "[Unknown]"

		if seen[t] then
			log(i .. "REFERENCE TO " .. seen[t])
			return
		end

		seen[t] = tostring(name)
		for k, v in pairs(t) do
			heat.print_value(v, k, max_depth, indent, seen)
		end
	end

function heat.print_value(v, k, max_depth, indent, seen)
	indent = indent and indent + 1 or 1
	local i = get_indent(indent)
	if max_depth and indent > max_depth then log(i .. "...") return end
	
	seen = seen or {}
	k = k or "[Unknown]"

	local type = type(v)
	if type == "table" then
		log(i .. tostring(k) .. " = {")
		print_table(v, k, max_depth, indent, seen)
		log(i .. "}")
	elseif type == "userdata" then
		local v_table = getmetatable(v) or {}

		log(i .. tostring(k) .. " = " .. tostring(v) .. " | type = " .. type .. " {")
		print_table(v_table, k, max_depth, indent, seen)
		log(i .. "}")
	else
		log(i .. tostring(k) .. " = " .. tostring(v) .. " | type = " .. type)
	end
end

--Safer wrapper for the sblt builtin log function.
--Takes in var args of any type (including nil) and concatenates them all together.
function heat.log(...)
	local args = {...}

	for i = 1, #args do
		args[i] = tostring(args[i])
	end

	log(table.concat(args, ""))
end