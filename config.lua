-- REQUREMENTS
-- GO:
-- MasonInstall gopls golangci-lint-langserver delve goimports gofumpt gomodifytags gotests impl
-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "catppuccin-frappe"

-- keymappings [view all the defaults by pressing <leader>Lk] lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('dap-python').test_method()<cr>", "Test Method" }
lvim.builtin.which_key.mappings["df"] = { "<cmd>lua require('dap-python').test_class()<cr>", "Test Class" }
lvim.builtin.which_key.vmappings["d"] = {
  name = "Debug",
  s = { "<cmd>lua require('dap-python').debug_selection()<cr>", "Debug Selection" },
}
lvim.builtin.which_key.mappings["r"] = {
  name = "Flutter",
  r = { "<cmd>Telescope flutter commands<cr>", "Flutter Commands" },
}

lvim.builtin.which_key.mappings["P"] = {
  name = "Python",
  e = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Pick Env" },
  s = { "<cmd>lua require('swenv.api').get_current_venv()<cr>", "Show Env" },
  i = { ":!isort % --profile=black<cr>", "Sort Imports" },
  n = { "<cmd>lua require('neogen').generate()<cr>", "Generate function docstring" },
}

lvim.builtin.which_key.mappings["n"] = {
  name = "Neogen",
  n = { "<cmd>lua require('neogen').generate()<cr>", "Generate function docstring" },
  c = { "<cmd>lua require('neogen').generate({type = 'class'})<cr>", "Generate class docstring" },
  f = { "<cmd>lua require('neogen').generate({type = 'file'})<cr>", "Generate file docstring" },
  t = { "<cmd>lua require('neogen').generate({type = 'type'})<cr>", "Generate type docstring" },
}

lvim.builtin.which_key.mappings["D"] = {
  name = "Docker",
  D = { "<cmd>lua require('user.lazydocker').lazydocker_toggle()<cr>", "Lazydocker" },
}

lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

lvim.builtin.which_key.mappings["a"] = {
  name = "Arduino",
  a = { "<cmd>ArduinoAttach<CR>", "Attach board" },
  v = { "<cmd>ArduinoVerify<CR>", "Verify code" },
  u = { "<cmd>ArduinoUpload<CR>", "Upload code" },
  f = { "<cmd>ArduinoUploadAndSerial<CR>", "Upload code and open serial connection" },
  s = { "<cmd>ArduinoSerial<CR>", "Serial connection" },
  b = { "<cmd>ArduinoChooseBoard<CR>", "Choose board" },
  p = { "<cmd>ArduinoChooseProgrammer<CR>", "Choose programmer" },
}

-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "arduino",
  "bash",
  "c",
  "dart",
  "go",
  "gomod",
  "javascript",
  "json",
  "lua",
  "python",
  "rust",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- generic LSP settings
-- make sure server will always be installed even if the server is in skipped_servers list
lvim.lsp.installer.setup.ensure_installed = {
  "gopls",
  "jsonls",
  "pyright",
  "sumeko_lua",
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

-- ARDUINO LSP
-- NOTE: mind the cli-config path
local MY_FQBN = "arduino:avr:uno"
require 'lspconfig'.arduino_language_server.setup {
  cmd = {
    "arduino-language-server",
    "-cli-config", "$HOME/Library/Arduino15/arduino-cli.yaml",
    "-cli",
    "arduino-cli",
    "-clangd",
    "clangd",
    "-fqbn",
    MY_FQBN
  },
  filetypes = { "arduino" },
}

-- DART LSP
require 'lspconfig'.dartls.setup {}


-- GO LSP
local lsp_manager = require "lvim.lsp.manager"
lsp_manager.setup("golangci_lint_ls", {
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
})

lsp_manager.setup("gopls", {
  on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    local map = function(mode, lhs, rhs, desc)
      if desc then
        desc = desc
      end

      vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
    end
    map("n", "<leader>Ci", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
    map("n", "<leader>Ct", "<cmd>GoMod tidy<cr>", "Tidy")
    map("n", "<leader>Ca", "<cmd>GoTestAdd<Cr>", "Add Test")
    map("n", "<leader>CA", "<cmd>GoTestsAll<Cr>", "Add All Tests")
    map("n", "<leader>Ce", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
    map("n", "<leader>Cg", "<cmd>GoGenerate<Cr>", "Go Generate")
    map("n", "<leader>Cf", "<cmd>GoGenerate %<Cr>", "Go Generate File")
    map("n", "<leader>Cc", "<cmd>GoCmt<Cr>", "Generate Comment")
    map("n", "<leader>DT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
  end,
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      codelenses = {
        generate = false,
        gc_details = true,
        test = true,
        tidy = true,
      },
    },
  },
})


-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "isort",     filetypes = { "python" }, extra_args = { "--profile=black" } },
  { command = "black",     filetypes = { "python" } },
  { command = "goimports", filetypes = { "go" } },
  { command = "gofumpt",   filetypes = { "go" } },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "mypy",       filetypes = { "python" } },
  { command = "pydocstyle", filetypes = { "python" } },
  { command = "revive",     filetypes = { "go" } },
  {
    -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "shellcheck",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--severity", "warning" },
  },
}

-- Additional Plugins
lvim.plugins = {
  { "folke/zen-mode.nvim" },
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "shaunsingh/nord.nvim" },

  { "AckslD/swenv.nvim" },
  { "mfussenegger/nvim-dap-python" },
  { "jbyuki/one-small-step-for-vimkind" },

  -- arduino
  { "stevearc/vim-arduino" },

  -- flutter
  { "akinsho/flutter-tools.nvim" },

  -- go
  { "olexsmir/gopher.nvim" },
  { "leoluz/nvim-dap-go" },

  {
    -- You can generate docstrings automatically.
    "danymat/neogen",
    config = function()
      require("neogen").setup {
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = "numpydoc",
            },
          },
        },
      }
    end,
  },
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = {
          "gitcommit", "gitrebase", "svn", "hgcommit",
        },
        lastplace_open_folds = true,
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    lazy = true,
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },
  -- looks
  { "rebelot/kanagawa.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  },
}

-- TODO: debugpy installed by default
-- Setup dap for python
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function() require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python") end)

-- Supported test frameworks are unittest, pytest and django. By default it
-- tries to detect the runner by probing for pytest.ini and manage.py, if
-- neither are present it defaults to unittest.
pcall(function() require("dap-python").test_runner = "pytest" end)

-- Setup dap for lua - works for debugging plugs
local dap = require "dap"
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

-- Setup dap for dart
dap.adapters.dart = {
  type = "executable",
  command = "dart",
  -- This command was introduced upstream in https://github.com/dart-lang/sdk/commit/b68ccc9a
  args = { "debug_adapter" }
}
dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch Dart Program",
    -- The nvim-dap plugin populates this variable with the filename of the current buffer
    program = "${file}",
    -- The nvim-dap plugin populates this variable with the editor's current working directory
    cwd = "${workspaceFolder}",
    args = { "--help" }, -- Note for Dart apps this is args, for Flutter apps toolArgs
  }
}


-- Setup dap for go
require('dap-go').setup {
  -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details do:
  -- :help dap-configuration
  dap_configurations = {
    {
      -- Must be "go" or it will be ignored by the plugin
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
    },
  },
  -- delve configurations
  delve = {
    -- time to wait for delve to initialize the debug session.
    -- default to 20 seconds
    initialize_timeout_sec = 20,
    -- a string that defines the port to start delve debugger.
    -- default to string "${port}" which instructs nvim-dap
    -- to start the process in a random available port
    port = "${port}"
  },
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc" },
  -- enable wrap mode for json files only
  command = "setlocal wrap",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.dart" },
  -- enable wrap mode for json files only
  command = "",
})
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
