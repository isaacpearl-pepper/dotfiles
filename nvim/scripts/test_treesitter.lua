-- Treesitter health check script
-- Run with: nvim --headless -c "luafile ~/.config/nvim/scripts/test_treesitter.lua"

vim.defer_fn(function()
  local function check(name, condition, details)
    if condition then
      print("✓ " .. name)
    else
      print("✗ " .. name .. (details and (" - " .. details) or ""))
    end
    return condition
  end

  local all_passed = true

  -- Check tree-sitter-cli is available
  local ts_cli = vim.fn.executable("tree-sitter") == 1
  all_passed = check("tree-sitter-cli installed", ts_cli) and all_passed

  -- Check nvim-treesitter module loads
  local ts_ok, ts = pcall(require, "nvim-treesitter")
  all_passed = check("nvim-treesitter module loads", ts_ok, ts_ok and "" or tostring(ts)) and all_passed

  -- Check Python parser is loadable
  local parser_ok = pcall(vim.treesitter.language.inspect, "python")
  all_passed = check("Python parser loadable", parser_ok) and all_passed

  -- Check Python highlights query exists
  local query_ok, query = pcall(vim.treesitter.query.get, "python", "highlights")
  all_passed = check("Python highlights query exists", query_ok and query ~= nil) and all_passed

  -- Check query has captures (patterns structure changed in newer versions)
  if query then
    local has_content = next(query.captures) ~= nil
    all_passed = check("Python query has captures", has_content) and all_passed
  end

  -- Check site/queries symlink exists
  local site_queries = vim.fn.stdpath("data") .. "/site/queries/python"
  local symlink_exists = vim.fn.isdirectory(site_queries) == 1
  all_passed = check("Python queries symlinked to site dir", symlink_exists) and all_passed

  -- Check treesitter starts on Python buffer
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.bo[bufnr].filetype = "python"
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"def foo():", "    return 42"})
  local start_ok = pcall(vim.treesitter.start, bufnr, "python")
  local hl_active = vim.treesitter.highlighter.active[bufnr] ~= nil
  all_passed = check("Treesitter highlighting activates", start_ok and hl_active) and all_passed
  vim.api.nvim_buf_delete(bufnr, {force = true})

  print("")
  if all_passed then
    print("All checks passed!")
    vim.cmd("cquit 0")
  else
    print("Some checks failed!")
    vim.cmd("cquit 1")
  end
end, 500)
