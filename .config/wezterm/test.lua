function scandir()
	print()
	local i, t, popen = 0, {}, io.popen

	local pfile = popen("find ~/personal ~/.config -mindepth 1 -maxdepth 1 -type d ")
	for filename in pfile:lines() do
		i = i + 1
		print(filename:match("^.+[\\/](.+)$"))
		t[i] = { label = filename, filename }
	end
	pfile:close()
	return t
end
local pathStripped = string.match(cwd, "^file://(.+)") or cwd
local a = scandir()
