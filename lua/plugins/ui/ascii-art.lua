local M = {}

M.isometric = {
	[[      ___          ___          ___                                 ___     ]],
	[[     /__/\        /  /\        /  /\         ___       ___         /__/\    ]],
	[[     \  \:\      /  /:/_      /  /::\       /__/\     /  /\       |  |::\   ]],
	[[      \  \:\    /  /:/ /\    /  /:/\:\      \  \:\   /  /:/       |  |:|:\  ]],
	[[  _____\__\:\  /  /:/ /:/_  /  /:/  \:\      \  \:\ /__/::\     __|__|:|\:\ ]],
	[[ /__/::::::::\/__/:/ /:/ /\/__/:/ \__\:\ ___  \__\:\\__\/\:\__ /__/::::| \:\]],
	[[ \  \:\~~\~~\/\  \:\/:/ /:/\  \:\ /  /://__/\ |  |:|   \  \:\/\\  \:\~~\__\/]],
	[[  \  \:\  ~~~  \  \::/ /:/  \  \:\  /:/ \  \:\|  |:|    \__\::/ \  \:\      ]],
	[[   \  \:\       \  \:\/:/    \  \:\/:/   \  \:\__|:|    /__/:/   \  \:\     ]],
	[[    \  \:\       \  \::/      \  \::/     \__\::::/     \__\/     \  \:\    ]],
	[[     \__\/        \__\/        \__\/          ~~~~                 \__\/    ]],
}

M.slanted = {
	[[                                                                   ]],
	[[      ████ ██████           █████      ██                    ]],
	[[     ███████████             █████                            ]],
	[[     █████████ ███████████████████ ███   ███████████  ]],
	[[    █████████  ███    █████████████ █████ ██████████████  ]],
	[[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
	[[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
	[[██████  █████████████████████ ████ █████ █████ ████ ██████]],
}

M.basic = {
	[[                                           ██             ]],
	[[                                           ▀▀             ]],
	[[██▄████▄   ▄████▄    ▄████▄   ██▄  ▄██   ████     ████▄██▄]],
	[[██▀   ██  ██▄▄▄▄██  ██▀  ▀██   ██  ██      ██     ██ ██ ██]],
	[[██    ██  ██▀▀▀▀▀▀  ██    ██   ▀█▄▄█▀      ██     ██ ██ ██]],
	[[██    ██  ▀██▄▄▄▄█  ▀██▄▄██▀    ████    ▄▄▄██▄▄▄  ██ ██ ██]],
	[[▀▀    ▀▀    ▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀▀▀▀▀▀▀  ▀▀ ▀▀ ▀▀]],
}

M.bloody = {
	[[ ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓]],
	[[ ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
	[[▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░]],
	[[▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ]],
	[[▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒]],
	[[░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░]],
	[[░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░]],
	[[   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ]],
	[[         ░    ░  ░    ░ ░        ░   ░         ░   ]],
	[[                                ░                  ]],
}
local function darken(hex, percent)
    -- Remove the hash at the start if it's there
    hex = hex:gsub("#", "")

    -- Convert hex to RGB
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)

    -- Darken each channel
    r = math.floor(r * (1 - percent / 100))
    g = math.floor(g * (1 - percent / 100))
    b = math.floor(b * (1 - percent / 100))

    -- Ensure values are within 0-255
    r = math.max(0, math.min(255, r))
    g = math.max(0, math.min(255, g))
    b = math.max(0, math.min(255, b))

    -- Convert back to hex
    return string.format("#%02X%02X%02X", r, g, b)
end

M.one_piece = [[
      ⠀⠀⡶⠛⠲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡶⠚⢶⡀⠀
      ⢰⠛⠃⠀⢠⣏⠀⠀⠀⠀⣀⣠⣤⣤⣤⣤⣤⣤⣄⣀⡀⠀⠀⠀⣸⠇⠀⠈⠙⣧
      ⠸⣦⣤⣄⠀⠙⢷⣤⣶⠟⠛⢉⣁⣤⣤⣤⣤⣀⣉⠙⠻⢷⣤⡾⠋⢀⣤⣤⣴⠏
      ⠀⠀⠀⠈⠳⣤⡾⠋⣀⣴⣿⣿⠿⠿⠟⠛⠿⠿⣿⣿⣶⣄⠙⢿⣦⠟⠁⠀⠀⠀
      ⠀⠀⠀⢀⣾⠟⢀⣾⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣷⡄⠹⣷⡀⠀⠀⠀
      ⠀⠀⠀⣾⡏⢠⣿⣿⡯⠤⠤⠤⠒⠒⠒⠒⠒⠒⠒⠤⠤⠽⣿⣿⡆⠹⣷⡀⠀⠀
      ⠀⠀⢸⣟⣠⡿⠿⠟⠒⣒⣒⣉⣉⣉⣉⣉⣉⣉⣉⣉⣒⣒⡛⠻⠿⢤⣹⣇⠀⠀
      ⠀⠀⣾⡭⢤⣤⣠⡞⠉⠁⢀⣀⣀⠀⠀⠀⠀⢀⣀⣀⠀⠈⢹⣦⣤⡤⠴⣿⠀⠀
      ⠀⠀⣿⡇⢸⣿⣿⣇⠀⣼⣿⣿⣿⣷⠀⠀⣼⣿⣿⣿⣷⠀⢸⣿⣿⡇⠀⣿⠀⠀
      ⠀⠀⢻⡇⠸⣿⣿⣿⡄⢿⣿⣿⣿⡿⠀⠀⢿⣿⣿⣿⡿⢀⣿⣿⣿⡇⢸⣿⠀⠀
      ⠀⠀⠸⣿⡀⢿⣿⣿⣿⣆⠉⠛⠋⠀⢴⣶⠀⠉⠛⠉⣠⣿⣿⣿⡿⠀⣾⠇⠀⠀
      ⠀⠀⠀⢻⣷⡈⢻⣿⣿⣿⣿⣶⣤⣀⣈⣁⣀⡤⣴⣿⣿⣿⣿⡿⠁⣼⠏⠀⠀⠀
      ⠀⠀⠀⢀⣽⣷⣄⠙⢿⣿⣿⡟⢲⠧⡦⠼⠤⢷⢺⣿⣿⡿⠋⣠⣾⢿⣄⠀⠀⠀
      ⣰⠟⠛⠛⠁⣨⡿⢷⣤⣈⠙⢿⡙⠒⠓⠒⠒⠚⡹⠛⢁⣤⣾⠿⣧⡀⠙⠋⠙⣆
      ⠹⣤⡀⠀⠐⡏⠀⠀⠉⠛⠿⣶⣿⣶⣤⣤⣤⣾⣷⠾⠟⠋⠀⠀⢸⡇⠀⢠⣤⠟
      ⠀⠀⠳⢤⠾⠃⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠘⠷⠤⠾⠁⠀
            ]]

function M.bee()

	local mocha = require("catppuccin.palettes").get_palette("mocha")
	local color_map = {
		[[      AAAA]],
		[[AAAAAA  AAAA]],
		[[AA    AAAA  AAAA        KKHHKKHHHH]],
		[[AAAA    AAAA  AA    HHBBKKKKKKKKKKKKKK]],
		[[  AAAAAA      AAKKBBHHKKBBYYBBKKKKHHKKKKKK]],
		[[      AAAA  BBAAKKHHBBBBKKKKBBYYBBHHHHKKKKKK]],
		[[        BBAABBKKYYYYHHKKYYYYKKKKBBBBBBZZZZZZ]],
		[[    YYBBYYBBKKYYYYYYYYYYKKKKBBKKAAAAZZOOZZZZ]],
		[[    XXXXYYYYBBYYYYYYYYBBBBBBKKKKBBBBAAAAZZZZ]],
		[[    XXXXUUUUYYYYBBYYYYYYBBKKBBZZOOAAZZOOAAAAAA]],
		[[  ZZZZZZXXUUXXXXYYYYYYYYBBAAAAZZOOOOAAOOZZZZAAAA]],
		[[  ZZUUZZXXUUUUXXXXUUXXFFFFFFFFAAAAOOZZAAZZZZ  AA]],
		[[    RRRRUUUUZZZZZZZZXXOOFFFFOOZZOOAAAAAAZZZZAA]],
		[[    CCSSUUUUZZXXXXZZXXOOFFFFOOZZOOOOZZOOAAAA]],
		[[    CCCCUUUUUUUUUURRRROOFFFFOOZZOOOOZZOOZZZZ]],
		[[    CCCCUUUUUUUUSSCCCCEEQQQQOOZZOOOOZZOOZZZZ]],
		[[    CCCCUUGGUUUUCCCCCCEEQQQQOOZZOOOOZZEEZZ]],
		[[    RRRRGGGGUUGGCCCCCCOOOOOOOOZZOOEEZZII]],
		[[      IIRRGGGGGGCCCCCCOOOOOOOOZZEEII]],
		[[            GGRRCCCCCCOOOOEEEEII  II]],
		[[                RRRRRREEEE  IIII]],
		[[                      II]],
		[[]],
	}

	local yellow = "#FAC87C"
	local orange = "#BF854E"
	local maroon = "#502E2B"
	local brown = "#38291B"
	local colors = {
		["A"] = { fg = mocha.rosewater },
		["Y"] = { fg = yellow },
		["B"] = { fg = darken(yellow, 5) },
		["X"] = { fg = darken(yellow, 20) },
		["U"] = { fg = darken(yellow, 25) },
		["F"] = { fg = darken(yellow, 35) },
		["O"] = { fg = darken(yellow, 45) },
		["K"] = { fg = maroon },
		["H"] = { fg = darken(maroon, 10) },
		["Z"] = { fg = mocha.crust },
		["G"] = { fg = darken(yellow, 25) },
		["R"] = { fg = orange },
		["Q"] = { fg = darken(orange, 20) },
		["E"] = { fg = darken(orange, 35) },
		["I"] = { fg = brown },
		["C"] = { fg = mocha.mantle },
		["S"] = { fg = mocha.subtext1 },
	}

	local header = {}
	for _, line in ipairs(color_map) do
		local header_line = [[]]
		for i = 1, #line do
			if line:sub(i, i) ~= " " then
				header_line = header_line .. "█"
			else
				header_line = header_line .. " "
			end
		end
		table.insert(header, header_line)
	end

	local header_add = [[          N        E      O    B   E E         ]]
	table.insert(header, header_add)

	local hl_add = {}
	for i = 1, #header_add do
		table.insert(hl_add, { "NeoBeeTitle", 1, i })
	end
	return header
end

return M
