return {
  {
    "nvim-neorg/neorg",
    version = "v7.0.0",
    build = ":Neorg sync-parsers",
    ft = "norg",
    config = function()
      local load_opts = {
        ["core.defaults"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.concealer"] = {},
      }

      local notes_dir = os.getenv("LOCAL_NOTES_HOME")

      if notes_dir ~= nil then
        load_opts["core.dirman"] = {
          config = {
            workspaces = {
              homelab = notes_dir .. "/Homelab",
              personal = notes_dir .. "/Personal",
              work = notes_dir .. "/Work",
            },
          },
        }
      end

      require("neorg").setup({
        load = load_opts,
      })
    end,
  },
}
