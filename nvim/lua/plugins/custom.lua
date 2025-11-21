return {
  "mrcjkb/rustaceanvim",
  opts = {
    tools = {
      enable_clippy = false,
    },
    --[[
    server = {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
        },
      },
    },
]]
  },
}
