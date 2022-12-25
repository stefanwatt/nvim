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
  use { "terrortylor/nvim-comment", commit = "e9ac16ab056695cad6461173693069ec070d2b23" }
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
  use { "GustavoKatel/tasks.nvim", commit = "1bb8b9725cc7bb58e646d9a8da48a57010cafcad" }
  use { "williamboman/mason.nvim", commit = "6f706712ec0363421e0988cd48f512b6a6cf7d6e" }
  use { "VonHeikemen/searchbox.nvim", commit = "4b8d3bb68283d27434d81b92424f1398fa9d739a",
    requires = { { "MunifTanjim/nui.nvim" } } }
  use { "kdheepak/lazygit.nvim", commit = "9c73fd69a4c1cb3b3fc35b741ac968e331642600" }
  use { "f-person/git-blame.nvim", commit = "08e75b7061f4a654ef62b0cac43a9015c87744a2" }
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
  })
  use { "stefanwatt/auto-save.nvim" }
  use { "stefanwatt/lsp-lines.nvim" }
  use { "monaqa/dial.nvim", commit = "6bf54a83cd40448f1ba5171358f0d6f48bd970fd" }
  use { "jose-elias-alvarez/typescript.nvim", commit = "785fed9919723961583d534169134cee90bd479c" }
  use { "elihunter173/dirbuf.nvim", commit = "ac7ad3c8e61630d15af1f6266441984f54f54fd2" }
  use { "gbprod/yanky.nvim", commit = "39bef9fe84af59499cdb88d8e8fb69f3175e1265" }
  use { "danielvolchek/tailiscope.nvim" }

  use({
      "glepnir/lspsaga.nvim",
      branch = "main",
  })

  -- Colorschemes
  use { "Everblush/everblush.nvim", commit = "8341ec1d72018973ca09862e07249195fa1039d3" }
  use { "decaycs/decay.nvim", as = "decay", commit = "dd6fcc3915892dcf723032dd570a414f342c7f6a" }
  use { "folke/tokyonight.nvim", commit = "4092905fc570a721128af73f6bf78e5d47f5edce" }
  use { "lunarvim/darkplus.nvim", branch = "neovim-0.7", commit = "13ef9daad28d3cf6c5e793acfc16ddbf456e1c83" }
  use { "lunarvim/onedarker.nvim", commit = "4eaa5e8760832d23a84f8ad4e0ff012eacd2c01f" }
  use { "catppuccin/nvim", as = "catppuccin", commit = "167ecd3ee31d254390862fb90ad91492a469366e" }
  use { "sam4llis/nvim-tundra", commit = "dfe152f2a8bac247a6b05b08c7e3e8124d165115" }

  -- lsp-zero
  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

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
  use { "nvim-treesitter/playground", commit = "1290fdf6f2f0189eb3b4ce8073d3fda6a3658376",
    requires = { "nvim-treesitter/nvim-treesitter" } }
  use { "p00f/nvim-ts-rainbow", commit = "fad8badcd9baa4deb2cf2a5376ab412a1ba41797" }
  use { "windwp/nvim-ts-autotag", commit = "5bbdfdaa303c698f060035f37a91eaad8d2f8e27" }

  -- Git
  use { "lewis6991/gitsigns.nvim", commit = "f98c85e7c3d65a51f45863a34feb4849c82f240f" }

  -- DAP
  use { "mfussenegger/nvim-dap", commit = "0b320f5bd4e5f81e8376f9d9681b5c4ee4483c25" }
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" },
    commit = "c8ce83a66deb0ca6f5af5a9f9d5fcc05a6d0f66b" }
  use { "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" }
  -- lua debug adapter
  use { "jbyuki/one-small-step-for-vimkind", commit = "ccd671fedaca36e474aadfdd70b9ca4189fcd86e" }
  use { "mxsdev/nvim-dap-vscode-js", commit = "079d0f3713c4649603290dc2ecc765e23e76a9fc",
    requires = { "mfussenegger/nvim-dap" } }

  -- Java
  use { "mfussenegger/nvim-jdtls", commit = "75d27daa061458dd5735b5eb5bbc48d3baad1186" } 
  -- END PLUGINS

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
