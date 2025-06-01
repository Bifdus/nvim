-- For toggling formatting
if vim.g.formatting_enabled == nil then
  vim.g.formatting_enabled = true
end

return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>fb',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Check if formatting is enabled
        if not vim.g.autoformat then
          return false
        end
        -- Disable "format_on_save lsp_fallback" for specific languages
        local disable_filetypes = { c = true, cpp = true, php = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      -- Add custom formatters here
      formatters = {
        sqlfluff = {
          command = 'sqlfluff',
          args = { 'fix', '--dialect', 'tsql', '-' },
          stdin = true,
          tempfile_postfix = '.sql',
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        cs = { 'csharpier' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = {'prettier'},
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier' },
        json = { 'prettierd', 'prettier' },
        yaml = { 'prettierd', 'prettier' },
        sql = { 'sqlfluff' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
