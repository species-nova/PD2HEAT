--Should stick these in a global table somewhere since I constantly paste them in for debugging purposes.
HEAT_debug = {}

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
			HEAT_debug.print_value(v, k, max_depth, indent, seen)
		end
	end

function HEAT_debug.print_value(v, k, max_depth, indent, seen)
	indent = indent and indent + 1 or 1
	if max_depth and indent > max_depth then log(i .. "...") return end
	local i = get_indent(indent)
	
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
