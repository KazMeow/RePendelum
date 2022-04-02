return function(URL)
	local getsynasset, request = getsynasset or getcustomasset or error('invalid attempt to \'getsynassetfromurl\' (custom asset retrieval function expected)'), (syn and syn.request) or (http and http.request) or (request) or error('invalid attempt to \'getsynassetfromurl\' (http request function expected)')
	local Extension, Types, URL = '', {'.png', '.webm'}, assert(tostring(type(URL)) == 'string', 'invalid argument #1 to \'getsynassetfromurl\' (string [URL] expected, got '..tostring(type(URL))..')') and URL or nil
	local Response, TempFile = request({
		Url = URL,
		Method = 'GET'
	})

	if Response.StatusCode == 200 then
		Extension = Response.Body:sub(2, 4) == 'PNG' and '.png' or Response.Body:sub(25, 28) == 'webm' and '.webm' or nil
	end

	if Response.StatusCode == 200 and (Extension and table.find(Types, Extension)) then
		for i = 1, 15 do
			local Letter, Lower = string.char(math.random(65, 90)), math.random(1, 5) == 3 and true or false
			TempFile = (not TempFile and '' .. (Lower and Letter:lower() or Letter)) or (TempFile .. (Lower and Letter:lower() or Letter)) or nil
		end

		writefile(TempFile..Extension, Response.Body)

		return getsynasset(TempFile..Extension)
	elseif Response.StatusCode ~= 200 or not Extension then
		warn('unexpected \'getsynassetfromurl\' Status Error: ' .. Response.StatusMessage .. ' ('..URL..')')
	elseif not (Extension) then
		warn('unexpected \'getsynassetfromurl\' Error: (PNG or webm file expected)')
	end
end
