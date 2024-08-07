return {
  "robitx/gp.nvim",
  config = function()
    local conf = {
      providers = {
        anthropic = {
          endpoint = "https://api.anthropic.com/v1/messages",
          secret = os.getenv("ANTHROPIC_API_KEY"),
        },
      },
      agents = {
        {
          name = "Sonnet-3.5",
          provider = "anthropic",
          chat = true,
          command = true,
          model = { model = "claude-3-5-sonnet-20240620" },
          system_prompt = [[
            Never add comments to the code. I'm smart, you're smart, let's get stuff done quickly.
            I'm an experienced developer. No need for verbose explanations.
          ]],
        },
      },
    }
    require("gp").setup(conf)
  end,
}
