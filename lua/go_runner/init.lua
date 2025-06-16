-- ~/.config/nvim/lua/go_runner/init.lua

local M = {}

-- Usa uv para leer carpetas dinámicamente
local uv = vim.loop

local current_term_buf = nil

local function list_go_scripts()
  local results = {}
  local handle = uv.fs_scandir("cmd")
  if handle then
    while true do
      local name, type = uv.fs_scandir_next(handle)
      if not name then break end
      if type == "directory" then
        table.insert(results, {
          path = "cmd/" .. name .. "/main.go",
          label = name .. " (main.go)"
        })
      end
    end
  end
  table.insert(results, { path = "main.go", label = "main.go (raíz)" })
  return results
end

function M.run_menu()
  local scripts = list_go_scripts()
  local entry_maker = function(entry)
    return {
      value = entry.path,
      display = entry.label,
      ordinal = entry.label,
    }
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Selecciona main.go para ejecutar",
    layout_strategy = "center",
    layout_config = {
      height = 0.3,
      width = 0.5,
      prompt_position = "top"
    },
    finder = finders.new_table {
      results = scripts,
      entry_maker = entry_maker
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd("botright split")
        vim.cmd("resize 5")
        vim.cmd("term go run " .. selection.value)
        vim.cmd("startinsert")
      end)
      return true
    end
  }):find()
end

function M.stop()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].buftype == "terminal" then
    vim.cmd("bd!")
  else
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "terminal" then
        vim.api.nvim_buf_delete(buf, { force = true })
        break
      end
    end
  end
end

function M.setup()
  vim.keymap.set("n", "<Leader>gr", M.run_menu, { desc = "GoRun con menú Telescope" })
  vim.keymap.set("n", "<Leader>gs", M.stop, { desc = "GoStop - cerrar terminal" })
end

return M

