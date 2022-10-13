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

-- Use a protected call so we don"t error out on first use
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
  -- BEGIN PLUGINS
  use { "wbthomason/packer.nvim", commit = "6afb67460283f0e990d35d229fd38fdc04063e0a" }
  use { "nvim-lua/plenary.nvim", commit = "4b7e52044bbb84242158d977a50c4cbcd85070c7" }
  use { "windwp/nvim-autopairs", commit = "4fc96c8f3df89b6d23e5092d31c866c53a346347" }
  -- use { "numToStr/Comment.nvim", commit = "d9cfae1059b62f7eacc09dba181efe4894e3b086" }
  use { "terrortylor/nvim-comment", commit = "e9ac16ab056695cad6461173693069ec070d2b23"}
  use { "JoosepAlviste/nvim-ts-context-commentstring", commit = "4d3a68c41a53add8804f471fcc49bb398fe8de08" }
  use { "kyazdani42/nvim-web-devicons", commit = "563f3635c2d8a7be7933b9e547f7c178ba0d4352" }
  use { "kyazdani42/nvim-tree.lua", commit = "7282f7de8aedf861fe0162a559fc2b214383c51c" }
  use { "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" }
  use { "nvim-lualine/lualine.nvim", commit = "a52f078026b27694d2290e34efa61a6e4a690621" }
  use { "akinsho/toggleterm.nvim", commit = "2a787c426ef00cb3488c11b14f5dcf892bbd0bda" }
  use { "ahmedkhalf/project.nvim", commit = "628de7e433dd503e782831fe150bb750e56e55d6" }
  use { "lewis6991/impatient.nvim", commit = "b842e16ecc1a700f62adb9802f8355b99b52a5a6" }
  use { "lukas-reineke/indent-blankline.nvim", commit = "db7cbcb40cc00fc5d6074d7569fb37197705e7f6" }
  use { "goolord/alpha-nvim", commit = "0bb6fc0646bcd1cdb4639737a1cee8d6e08bcc31" }
  use { "folke/which-key.nvim", commit = "6885b669523ff4238de99a7c653d47b081b5506d" }
  use { "phaazon/hop.nvim", branch = "v2", commit = "2a1b686aad85a3c241f8cd8fd42eb09c7de5ed79" }
  use { "kylechui/nvim-surround", commit = "17191679202978b1de8c1bd5d975400897b1b92d" }
  use { "stefanwatt/nvim-typing-test", commit = "727c239e5a16127175b252b92d85e28c7813ed9a" }
  use { "GustavoKatel/tasks.nvim", commit = "1bb8b9725cc7bb58e646d9a8da48a57010cafcad" }
  use { "williamboman/mason.nvim", commit = "6f706712ec0363421e0988cd48f512b6a6cf7d6e" }
  use { "VonHeikemen/searchbox.nvim", commit = "4b8d3bb68283d27434d81b92424f1398fa9d739a",
    requires = { { "MunifTanjim/nui.nvim" } } }
  use { "kdheepak/lazygit.nvim", commit = "9c73fd69a4c1cb3b3fc35b741ac968e331642600" }
  use { "f-person/git-blame.nvim", commit = "08e75b7061f4a654ef62b0cac43a9015c87744a2" }
  use { "EdenEast/nightfox.nvim", commit = "59c3dbcec362eff7794f1cb576d56fd8a3f2c8bb" }
  use { "jlcrochet/vim-razor", commit = "4fdf2b50ac0060bd1ceb7203b58fef21805d9033" }
  use { "anuvyklack/hydra.nvim", commit = "6ef743f693fee84cf9f50faff21effa5c1704dd1" }
  use { "noib3/nvim-cokeline", requires = "kyazdani42/nvim-web-devicons",
    config = function() require("cokeline").setup() end, commit = "501f93ec84af0d505d95d3827cad470b9c5e86dc" }

  use({
    "folke/noice.nvim",
    event = "VimEnter",
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      "hrsh7th/nvim-cmp",
    }
  }) -- Colorschemes
  use { "Everblush/everblush.nvim", commit = "8341ec1d72018973ca09862e07249195fa1039d3" }
  use { "decaycs/decay.nvim", as = "decay", commit = "dd6fcc3915892dcf723032dd570a414f342c7f6a" }
  use { "folke/tokyonight.nvim", commit = "4092905fc570a721128af73f6bf78e5d47f5edce" }
  use { "lunarvim/darkplus.nvim", branch = "neovim-0.7", commit = "13ef9daad28d3cf6c5e793acfc16ddbf456e1c83" }
  use { "lunarvim/onedarker.nvim", commit = "4eaa5e8760832d23a84f8ad4e0ff012eacd2c01f" }
  use { "catppuccin/nvim", as = "catppuccin", commit = "167ecd3ee31d254390862fb90ad91492a469366e" }

  -- cmp plugins
  use { "hrsh7th/nvim-cmp", commit = "2427d06b6508489547cd30b6e86b1c75df363411" }
  use { "hrsh7th/cmp-buffer", commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa" }
  use { "hrsh7th/cmp-path", commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1" }
  use { "saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" }
  use { "hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" }
  use { "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" }

  --
  -- -- snippets
  use { "L3MON4D3/LuaSnip", commit = "8f8d493e7836f2697df878ef9c128337cbf2bb84" }
  use { "rafamadriz/friendly-snippets", commit = "2be79d8a9b03d4175ba6b3d14b082680de1b31b1" }

  -- LSP
  use { "neovim/nvim-lspconfig", commit = "af43c300d4134db3550089cd4df6c257e3734689" }
  use { "williamboman/nvim-lsp-installer", commit = "23820a878a5c2415bfd3b971d1fe3c79e4dd6763" }
  use { "jose-elias-alvarez/null-ls.nvim", commit = "c0c19f32b614b3921e17886c541c13a72748d450" }
  use { "RRethy/vim-illuminate", commit = "a2e8476af3f3e993bb0d6477438aad3096512e42" }

  -- Telescope
  use { "nvim-telescope/telescope.nvim", commit = "76ea9a898d3307244dce3573392dcf2cc38f340f" }
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" },
    commit = "02cc3874738bc0f86e4b91f09b8a0ac88aef8e96" }
  use { "elianiva/telescope-npm.nvim", commit = "60eee38b34f577104475a592dd3716a7afa2aef1" }
  use { "ibhagwan/fzf-lua", requires = { "kyazdani42/nvim-web-devicons" },
    commit = "e7c610889ff954101c644cdb9cf68e499a3751ac" }
  use { "tami5/sqlite.lua", commit = "47685f0adb89928fc1b2a9b812418680f29aaf27" }
  use { "nvim-telescope/telescope-frecency.nvim", requires = { "tami5/sqlite.lua" },
    commit = "9634c3508c6565284065ec011476204ce13f354a" }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", commit = "aebc6cf6bd4675ac86629f516d612ad5288f7868" }

  -- Git
  use { "lewis6991/gitsigns.nvim", commit = "f98c85e7c3d65a51f45863a34feb4849c82f240f" }

  -- DAP
  use { "mfussenegger/nvim-dap", commit = "0b320f5bd4e5f81e8376f9d9681b5c4ee4483c25" }
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" },
    commit = "c8ce83a66deb0ca6f5af5a9f9d5fcc05a6d0f66b" }
  use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }

  -- Java
  use { "mfussenegger/nvim-jdtls", commit = "75d27daa061458dd5735b5eb5bbc48d3baad1186" } -- END PLUGINS

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  -- END PLUGINS
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
