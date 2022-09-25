local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use { "wbthomason/packer.nvim", commit = "00ec5adef58c5ff9a07f11f45903b9dbbaa1b422" } -- Have packer manage itself
  use { "nvim-lua/plenary.nvim", commit = "986ad71ae930c7d96e812734540511b4ca838aa2" } -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs", commit = "fa6876f832ea1b71801c4e481d8feca9a36215ec" } -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim", commit = "2c26a00f32b190390b664e56e32fd5347613b9e2" }
  use { "JoosepAlviste/nvim-ts-context-commentstring", commit = "88343753dbe81c227a1c1fd2c8d764afb8d36269" }
  use { "kyazdani42/nvim-web-devicons", commit = "8d2c5337f0a2d0a17de8e751876eeb192b32310e" }
  use { "kyazdani42/nvim-tree.lua", commit = "bdb6d4a25410da35bbf7ce0dbdaa8d60432bc243" }
  use { "akinsho/bufferline.nvim", commit = "c78b3ecf9539a719828bca82fc7ddb9b3ba0c353" }
  use { "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" }
  use { "nvim-lualine/lualine.nvim", commit = "3362b28f917acc37538b1047f187ff1b5645ecdd" }
  use { "akinsho/toggleterm.nvim", commit = "aaeed9e02167c5e8f00f25156895a6fd95403af8" }
  use { "ahmedkhalf/project.nvim", commit = "541115e762764bc44d7d3bf501b6e367842d3d4f" }
  use { "lewis6991/impatient.nvim", commit = "969f2c5c90457612c09cf2a13fee1adaa986d350" }
  use { "lukas-reineke/indent-blankline.nvim", commit = "6177a59552e35dfb69e1493fd68194e673dc3ee2" }
  use { "goolord/alpha-nvim", commit = "ef27a59e5b4d7b1c2fe1950da3fe5b1c5f3b4c94" }
  use { "folke/which-key.nvim", commit = "bd4411a2ed4dd8bb69c125e339d837028a6eea71" }
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    commit = "2a1b686aad85a3c241f8cd8fd42eb09c7de5ed79"
  }
  use { "kylechui/nvim-surround", commit = "22a25192ed98a937efe48b93c192a352d197c7e3" }
  use { "stefanwatt/nvim-typing-test" }
  use({ "GustavoKatel/tasks.nvim", commit = "1bb8b9725cc7bb58e646d9a8da48a57010cafcad" })
  use { "williamboman/mason.nvim" }
  use {
    'VonHeikemen/searchbox.nvim',
    commit = "ccdbbb8b1b378d4e45d9af9040a6c1e925ad1c56",
    requires = {
      { 'MunifTanjim/nui.nvim', commit = "51cbd0ccc9410e317a947eea1e99966226a5f8b5" }
    }
  }
  use { "kdheepak/lazygit.nvim", commit = "9c73fd69a4c1cb3b3fc35b741ac968e331642600" }
  use { "f-person/git-blame.nvim", commit = "1bb73289929107309d2d90f7582ece5e9436bfd8" }
  use { "mrshmllow/document-color.nvim", commit = "07c05b2d0dc29da1e82e1189d6f435d5a6aef4e1" }
  use { "https://git.sr.ht/~whynothugo/lsp_lines.nvim", commit = "dbfd8e96ec2696e1ceedcd23fd70e842256e3dea" }
  use { "EdenEast/nightfox.nvim", commit = "e2f961859cbfb2ba38147dc59fdd2314992c8b62" }
  use { "jlcrochet/vim-razor", commit = "4fdf2b50ac0060bd1ceb7203b58fef21805d9033" }
  use { "ThePrimeagen/refactoring.nvim", commit = "c9ca8e3bbf7218101f16e6a03b15bf72b99b2cae", requires = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" }
  } }


  -- Colorschemes
  use { 'Everblush/everblush.nvim', as = 'everblush', commit = "d6746505ec81930c93f71da30d72f5ba5f55ef7c" }
  use { 'decaycs/decay.nvim', as = 'decay', commit = "7ce218fdc23ac6447c6408b99c2b9ddb9a5ce649" }
  use { "folke/tokyonight.nvim", commit = "8223c970677e4d88c9b6b6d81bda23daf11062bb" }
  use { "lunarvim/darkplus.nvim", branch = "neovim-0.7" }
  use { "lunarvim/onedarker.nvim" }
  use { "catppuccin/nvim", as = "catppuccin" }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp", commit = "df6734aa018d6feb4d76ba6bda94b1aeac2b378a" } -- The completion plugin
  use { "hrsh7th/cmp-buffer", commit = "62fc67a2b0205136bc3e312664624ba2ab4a9323" } -- buffer completions
  use { "hrsh7th/cmp-path", commit = "466b6b8270f7ba89abd59f402c73f63c7331ff6e" } -- path completions
  use { "saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" } -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" }
  use { "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" }
  --
  -- -- snippets
  use { "L3MON4D3/LuaSnip", commit = "79b2019c68a2ff5ae4d732d50746c901dd45603a" } --snippet engine
  use { "rafamadriz/friendly-snippets", commit = "d27a83a363e61009278b6598703a763ce9c8e617" } -- a bunch of snippets to use

  -- LSP
  use { "neovim/nvim-lspconfig", commit = "148c99bd09b44cf3605151a06869f6b4d4c24455" } -- enable LSP
  use { "williamboman/nvim-lsp-installer", commit = "e9f13d7acaa60aff91c58b923002228668c8c9e6" } -- simple to use language server installer
  use { "jose-elias-alvarez/null-ls.nvim", commit = "ff40739e5be6581899b43385997e39eecdbf9465" } -- for formatters and linters
  use { "RRethy/vim-illuminate", commit = "59f69f90fbce5cf37741fb8e4aa040e78a0b3516" }

  -- Telescope
  use { "nvim-telescope/telescope.nvim", commit = "d96eaa914aab6cfc4adccb34af421bdd496468b0" }
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
  use { "elianiva/telescope-npm.nvim", commit = "60eee38b34f577104475a592dd3716a7afa2aef1" }
  use { 'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    commit = "ee19eda2e3b2c7e627c94e0daf9c93ab17027ab1"
  }
  use { "tami5/sqlite.lua", commit = "d53bdff134a81e12834c3f7bd431376482132b7c" }
  use {
    "nvim-telescope/telescope-frecency.nvim",
    requires = { "tami5/sqlite.lua" },
    commit = "68ac8cfe6754bb656b4f84d6c3dafa421b6f9697"
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    commit = "518e27589c0463af15463c9d675c65e464efc2fe",
  }

  -- Git
  use { "lewis6991/gitsigns.nvim", commit = "c18e016864c92ecf9775abea1baaa161c28082c3" }

  -- DAP
  use { "mfussenegger/nvim-dap", commit = "014ebd53612cfd42ac8c131e6cec7c194572f21d" }
  use { "rcarriga/nvim-dap-ui", commit = "d76d6594374fb54abf2d94d6a320f3fd6e9bb2f7" }
  use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }

  -- Java
  use { "mfussenegger/nvim-jdtls", commit = "3a148dac526396678f141a033270961d0d9ccb88" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
