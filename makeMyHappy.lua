if not http then
	print("Sorry, I need access to the interwebs to download stuffs.")
	return
end

-- Change this to "dev" if you want to download the last development snapshot.
-- Note that these versions may screw over your state files and be buggy, or at
-- least not was well tested as the release versions.
local branch = "master"

-- The list of files we can fetch.
local files = {
	{
		name = "sm",
		url = "https://github.com/fnuecke/lama/raw/"..branch.."/lama-min"
	},
	{
		name = "lama-conf",
		info = "This is a utility application for managing the API's internal state from the shell.",
		url = "https://github.com/fnuecke/lama/raw/"..branch.."/lama-conf",
		ask = true,
		default = true
	},
	{
		name = "lama-example",
		info = "This is an small example application, demonstrating how to write a resumable program using the API.",
		url = "https://github.com/fnuecke/lama/raw/"..branch.."/lama-example",
		ask = true,
		default = false
	},
	{
		name = "lama-src",
		info = "This is the full, non-minified version of the API. You only need this if you're interested in the implementation details.",
		url = "https://github.com/fnuecke/lama/raw/"..branch.."/lama",
		ask = true,
		default = false
	}
}

-- Utility function to grab user input.
local function prompt(default)
	if default then
		print("> [Y/n]")
	else
		print("> [y/N]")
	end
	while true do
		local event, code = os.pullEvent("key")
		if code == keys.enter then
			return default
		elseif code == keys.y then
			return true
		elseif code == keys.n then
			return false
		end
	end
end

-- Interactively download all files.
for _, file in ipairs(files) do
	local install = true
	if file.ask then
		print("Do you wish to install '" .. file.name .. "'?")
		if file.info then
			print("  " .. file.info)
		end
		install = prompt(file.default)
	end
	if install then
		if fs.exists(file.name) then
			print("Warning: file '" .. file.name .. "' already exists. Overwrite?")
			install = prompt(true)
		end
	end
	if install then
		print("Fetching '" .. file.name .. "'...")
		local request = http.get(file.url)
		if request then
			local response = request.getResponseCode()
			if response == 200 then
				local f = fs.open(file.name, "w")
				f.write(request.readAll())
				f.close()
				print("Done.")
			else
				print("Oh dear, something went wrong (bad HTTP response code " .. response .. ").")
				print("Please try again later; sorry for the inconvenience!")
				os.sleep(0.1)
				return
			end
		else
			print("Oh dear, something went wrong (did not get a request handle).")
			print("Please try again later; sorry for the inconvenience!")
			os.sleep(0.1)
			return
		end
	else
		print("Skipping.")
	end
	print()
end

-- Prevent last key entry to be entered in the shell.
os.sleep(0.1)