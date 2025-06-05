local function augroup(name)
  return vim.api.nvim_create_augroup("bifdus." .. name, { clear = true })
end

local docker_config_ft_group = augroup("docker_config_ft")
local docker_config_log_group = augroup("docker_config_log")

vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = { "**/*.config" }, command = "setfiletype json", group = docker_config_ft_group }
)

vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = { "**/*.config.log" }, command = "setfiletype json", group = docker_config_log_group }
)

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "blame",
    "fugitive",
    "fugitiveblame",
    "httpResult",
    "lspinfo",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})
