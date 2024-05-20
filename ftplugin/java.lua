local function configureBuffer() --(client, bufnr)
  require("local.modules.lsp").configureBuffer()

  vim.keymap.set('n', '<M-o>', require'jdtls'.organize_imports,
    {noremap = true, silent = true, buffer = true, desc = 'JDT LS organize imports'})
  vim.keymap.set('n', 'crv', require('jdtls').extract_variable,
    {noremap = true, silent = true, buffer = true, desc = 'JDT LS extract variable'})
  vim.keymap.set('v', 'crv', function() require('jdtls').extract_variable(true) end,
    {noremap = true, silent = true, buffer = true, desc = 'JDT LS extract variable'})
  vim.keymap.set('n', 'crv', require('jdtls').extract_variable,
    {noremap = true, silent = true, buffer = true, desc = 'JDT LS extract variable'})
  vim.keymap.set('v', 'crv', function() require('jdtls').extract_variable(true) end,
    {noremap = true, silent = true, buffer = true, desc = 'JDT LS extract variable'})
  vim.keymap.set('v', 'crm', function() require('jdtls').extract_method(true) end,
    {noremap = true, silent = true, buffer = true, desc = 'JDT LS extract method'})
  vim.keymap.set('n', '<leader>df', function() require'jdtls'.test_class() end,
    {noremap = true, silent = true, buffer = true, desc = 'JDT LS test class'})
  vim.keymap.set('n', '<leader>dm', function() require'jdtls'.test_nearest_method() end,
    {noremap = true, silent = true, buffer = true, desc = 'JDT LS test nearest method'})

  vim.cmd [[
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
    command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
    command! -buffer JdtJol lua require('jdtls').jol()
    command! -buffer JdtBytecode lua require('jdtls').javap()
    command! -buffer JdtJshell lua require('jdtls').jshell()
  ]]
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = '/w/jdtls/workspace/' .. project_name

local config = {
  cmd = {'jdtls', '-data', workspace_dir},
  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', '.hg', 'mvnw'}, { upward = true })[1]),
  on_attach = configureBuffer,
  settings = {
    java = {
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/home/sakhnik/.sdkman/candidates/java/8.0.362.fx-zulu/",
          },
          {
            name = "JavaSE-11",
            path = "/home/sakhnik/.sdkman/candidates/java/11.0.19.fx-zulu/",
          },
        }
      }
    }
  },
}

local bundles = {
  "/usr/share/java-debug/com.microsoft.java.debug.plugin.jar",
  "/usr/share/java-debug/com.microsoft.java.debug.core.jar"
}
vim.list_extend(bundles, vim.split(vim.fn.glob("/w/nvim/vscode-java-test/server/*.jar", 1), "\n"))

config['init_options'] = {
  bundles = bundles;
}

require('jdtls').start_or_attach(config)
