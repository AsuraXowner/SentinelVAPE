local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/AsuraXowner/SentinelVAPE/main/' .. select(1, path:gsub('sentinelvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after SentinelVAPE updates.\n' .. res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'sentinelvape', 'sentinelvape/games', 'sentinelvape/profiles', 'sentinelvape/assets', 'sentinelvape/libraries', 'sentinelvape/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local commit = 'main'
	if (not isfile('sentinelvape/profiles/commit.txt')) or readfile('sentinelvape/profiles/commit.txt') ~= commit then
		wipeFolder('sentinelvape')
		wipeFolder('sentinelvape/games')
		wipeFolder('sentinelvape/guis')
		wipeFolder('sentinelvape/libraries')
	end
	writefile('sentinelvape/profiles/commit.txt', commit)
end

return loadstring(downloadFile('sentinelvape/main.lua'), 'main')()
