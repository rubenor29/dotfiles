vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Se añaden llaves extra para que sea una lista: { { ... } }
    vim.pack.add({ { src = "alpha-nvim" } })

    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Header
    dashboard.section.header.val = {
      "                                                      ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                      ",
    }

    -- Menú
    dashboard.section.buttons.val = {
      dashboard.button("SPC ee", "  > Abrir/Cerrar explorador de archivos", "<cmd>Oil<CR>"),
      dashboard.button("SPC ff", "󰱼  > Buscar archivo", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  > Buscar palabra", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC q", "  > Salir de NVIM", "<cmd>qa<CR>"),
    }

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })
  end,
})

require("core.options")
require("core.keymaps")
require("plugins.utils")
require("plugins.ui")
require("plugins.code")
