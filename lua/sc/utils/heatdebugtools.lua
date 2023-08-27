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

	local function print_table(t, name, max_depth, indent, seen, printout)
		indent = indent + 1
		if max_depth and indent > max_depth + 1 then 
			printout[#printout + 1] = get_indent(indent)
			printout[#printout + 1] = "...\n"
			return
		end

		seen = seen or {}
		name = name or "[Unknown]"

		if seen[t] then
			printout[#printout + 1] = get_indent(indent)
			printout[#printout + 1] = "REFERENCE TO "
			printout[#printout + 1] = seen[t]
			printout[#printout + 1] = "\n"
			return
		end

		seen[t] = tostring(name)
		for k, v in pairs(t) do
			heat.print_value(v, k, max_depth, indent, seen, printout)
		end
	end

function heat.print_value(v, k, max_depth, indent, seen, printout)
	printout = printout or {}
	indent = indent and indent + 1 or 1
	printout[#printout + 1] = get_indent(indent)
	if max_depth and indent > max_depth + 1 then
		printout[#printout + 1] = "...\n"
		return
	end
	
	seen = seen or {}
	k = k or "[Unknown]"

	local t = type(v)
	if t == "table" then
		printout[#printout + 1] = tostring(k)
		printout[#printout + 1] = " = {\n"
		print_table(v, k, max_depth, indent, seen, printout)
		printout[#printout + 1] = get_indent(indent)
		printout[#printout + 1] = "}\n"
	elseif t == "userdata" then
		local v_table = getmetatable(v) or {}

		printout[#printout + 1] = tostring(k)
		printout[#printout + 1] = " = "
		printout[#printout + 1] = tostring(v)
		printout[#printout + 1] = " | type = "
		printout[#printout + 1] = t 
		printout[#printout + 1] = " {\n"
		print_table(v_table, k, max_depth, indent, seen, printout)
		printout[#printout + 1] = get_indent(indent)
		printout[#printout + 1] = "}\n"
	else
		printout[#printout + 1] = tostring(k)
		printout[#printout + 1] = " = "
		printout[#printout + 1] = tostring(v)
		printout[#printout + 1] = " | type = "
		printout[#printout + 1] = t
		printout[#printout + 1] = "\n"
	end

	if indent == 1 then
		log(table.concat(printout, ""))
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


heat.log_tags = {
	VOICELINE = true,
	DEBUG = true
}

function heat.tlog(tag, ...)
	if heat.log_tags[tag] then
		return heat.log("[Heat][", tag, "] ", ...)
	end
end 

function heat.traceback()
	local level = 2
	local traceback = {}
	while true do
		local info = debug.getinfo(level, "Sl")
		if not info then
			break
		end
		
		if info.what == "C" then
			traceback[#traceback + 1] = "C function"
		else
			traceback[#traceback + 1] = string.format("[%s]:%d", info.short_src, info.currentline)
		end
		level = level + 1
	end

	log(table.concat(traceback, "\n"))
end