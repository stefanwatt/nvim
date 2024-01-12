return {
{ 'echasnovski/mini.pick', version = false,config=function() require('mini.pick').setup() end, keys = {
	{"<leader>ff", mode={"n","x","o"}, function() MiniPick.builtin.files() end,desc="Find Files"}
} },
}
