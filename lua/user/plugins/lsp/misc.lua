return {
  { "mfussenegger/nvim-jdtls", commit = "75d27daa061458dd5735b5eb5bbc48d3baad1186" },
  {
    "williamboman/mason.nvim",
    commit = "6f706712ec0363421e0988cd48f512b6a6cf7d6e",
    config=function ()
      require("mason").setup()
    end
  },
}
