" Lazy.nvim + treesitter + nvim-lspconfig + nvim-cmp completion
" ******************vim基础***************
" 快速移动行:6m0 第6行移至第1行[range]m[range] -->move
" 快速复制行:6c0 复制6行至第1行[range]c[range] -->copy
" 快速删除行:5,6d 第5行至6行[range]d -->delete
" 多行变一行：J (前面可以加数字代表几行)
" 缩进行：>5> （缩进5行:包含光标所在行）
" 反缩进：<5<
" 批量修改：control+v --> j/h 上下选择；然后shift+i插入，d删除、r修改
" 插入行首：shift+i
" 插入行尾：shift+a
" 跳转至末尾：G
" 文件跳转至开头：gg
" 搜索/word  使用n下一个，N上一个
" 快捷键：:%s/key/key/g
" 当前行：:s/foo/bar/g
" 当前行+2：:.,+2s/foo/bar/g
" 指定行：:5,12s/foo/bar/g
" 全文：:%s/foo/bar/g
" ******************多文件***************
" 打开多文件：vim file1 file2 / :e file file2
" ******************窗口***************
" 水平窗口：:sp 
" 垂直窗口：:vsp 
" 关闭窗口：:clo[se]
" 切换窗口：Ctrl+w +h,j,k,l
" ******************## [python miniforge环境设置](https://github.com/conda-forge/miniforge)
" ### download miniforge
" 1. for mac:
" > bash: curl -fsSLo Miniforge3.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh
" 2. for linux 
" > curl -o Miniforge3-linux-x86_64.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
" ### install miniforge
" > bash Miniforge3-xxx.sh -b
" > $HOME/miniforge3
" > conda env list (for fish shell: conda init fish)
" ### settings miniforge
" > conda create -n base python
" > conda activate base
" > conda deactivate base
" > conda配置清华源
" > conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
" > conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
" > conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
" > conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
" > conda config --set show_channel_urls yes
" https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pylsp
" pip install python-lsp-server python-lsp-black(模式化代码) neovim ruff python-lsp-ruff --改用rust ruff进行类型检查
" ******************nvim treesitter语法高亮设置***************
" 真彩色,修复终端和gui显示不同配色问题
if has("termguicolors")
    " enable true color
    set termguicolors
    set guioptions-=e
endif
lua <<EOF
local execute = vim.api.nvim_command
local fn = vim.fn
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
    {'rcarriga/nvim-notify'}, -- notify
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter', -- optional
            'nvim-tree/nvim-web-devicons'     -- optional
        }
    },
    {'neovim/nvim-lspconfig'}, -- lsp config
    {'simrat39/rust-tools.nvim'}, -- rust config
    {'dstein64/vim-startuptime'}, -- 启动插件时间：StartupTime
    {'Yggdroot/LeaderF', build=':LeaderfInstallCExtension' }, -- 模糊查找
    -- 删除the delimiters entirely, press ds"
    {'tpope/vim-surround'}, -- 修改包裹符号 'string' 按下: cs'": string" 
    {'danilamihailov/beacon.nvim'}, --大跳转时分屏切换高亮显示
    {'rhysd/accelerated-jk'}, -- 加快j、k 速度
    {
      'stevearc/oil.nvim', -- vim 模式文件管理器,'-' 返回上一层
      opts = {},
      -- Optional dependencies
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {'mbbill/undotree'}, -- 显示撤消历史 ;u
    {'phaazon/hop.nvim',as = 'hop',
        config = function()
        -- Hop 快捷单词跳转 ;j 行跳转;l （比vim-easymotion更好用) :h hop-config 
        require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    },
    {'norcalli/nvim-colorizer.lua',}, -- color: #8080ff; 十六进制颜色实时显示
    {'scrooloose/nerdcommenter'}, --注释 ;cc 取消注释;cu
    {'mhinz/vim-startify'}, -- 在启动窗口显示最近打开的文件 :Startify
    {'jiangmiao/auto-pairs'}, -- 括号自动补全
    {'windwp/nvim-ts-autotag'}, -- 自动闭合/重命名html标签  html,tsx,vue,svelte,php,rescript.
    {'godlygeek/tabular'}, -- Text 对齐符号、对齐方式 :Tabularized /,
    {'mzlogin/vim-markdown-toc'}, -- markdown生成目录:GenTocGFM :UpdateToc :RemoveToc
    {'plasticboy/vim-markdown'}, -- markdown高亮显示;
    -- [[ "跳转上一个标题 
    -- ]] "跳转下一个标题
    -- ]c "跳转到当前标题
    -- ]u "跳转到副标题
    -- zr "打开下一级折叠
    -- zR "打开所有折叠
    -- zm "折叠当前段落
    -- zM "折叠所有段落
    -- :Toc "显示目录依赖tabular
    {'akinsho/bufferline.nvim', version='v3.*', dependencies='nvim-tree/nvim-web-devicons'}, -- 顶部状态栏
    {'nvim-lualine/lualine.nvim', dependencies={'nvim-tree/nvim-web-devicons', lazy=true}}, -- 底部状态栏
    {"lukas-reineke/indent-blankline.nvim"}, -- 缩进线
    {'itchyny/vim-cursorword'}, -- 光标下划线和高亮
    -- cd ~/.local/share/nvim/lazy/onehalf
    -- ln -s vim/autoload ../onehalf/
    -- ln -s vim/colors ../onehalf/
    {'sonph/onehalf',
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "vim")
        end
    }, -- theme onehalf
    -- python auto-completion engine
    {"hrsh7th/nvim-cmp",},
    -- nvim-cmp completion sources
    {"hrsh7th/cmp-nvim-lsp",},
    {'hrsh7th/cmp-cmdline',},
    {"hrsh7th/cmp-path",},
    {"hrsh7th/cmp-buffer",},
    {'SirVer/ultisnips',},
    {'honza/vim-snippets',},
    {'quangnguyen30192/cmp-nvim-ultisnips',},
    {'sbdchd/neoformat'},  -- 代码格式化 call:F8 call :Neoformat /:Neoformat! python black 
    --" 代码高亮显示:TSInstall python css html javascript scss typescript
    {'nvim-treesitter/nvim-treesitter', build=':TSUpdate'},
    {'romgrk/nvim-treesitter-context'}, --  类和函数超屏显示
    {'nvim-treesitter/nvim-treesitter-refactor'}, -- 变量与函数跳转 
    {'liuchengxu/vim-which-key',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    }, -- 快捷键提示
    -- 输入法切换: 用rime:squirrel.custom.yaml, https://github.com/cbingos/rime
    {'alvan/vim-closetag'},
    {"Pocco81/auto-save.nvim"}, -- 自动保存 :ASToggle
})

-- rust lspconfig : macos-->brew install rust-analyzer
local rt = {
    server = {
        settings = {
            on_attach = function(_, bufnr)
                -- Hover actions
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                -- Code action groups
                vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                require 'illuminate'.on_attach(client)
            end,
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                }, 
            },
        }
    },
}
-- nvim-web-devicons --> :735
require'nvim-web-devicons'.setup({
 override = {
  fish = {
    -- icon = "",
    -- color = "#428850",
    -- cterm_color = "65",
    name = "fish"
  }
 },
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
})
require("oil").setup({
  -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- Set to false if you still want to use netrw.
  default_file_explorer = true,
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  -- Buffer-local options to use for oil buffers
  buf_options = {
    buflisted = false,
    bufhidden = "hide",
  },
  -- Window-local options to use for oil buffers
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "n",
  },
  -- Restore window options to previous values when leaving an oil buffer
  restore_win_options = true,
  -- Skip the confirmation popup for simple operations
  skip_confirm_for_simple_edits = false,
  -- Deleted files will be removed with the trash_command (below).
  delete_to_trash = false,
  -- Change this to customize the command used when deleting to trash
  trash_command = "trash-put",
  -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  prompt_save_on_select_new_entry = true,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["g."] = "actions.toggle_hidden",
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = false,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
  },
  -- Configuration for the floating window in oil.open_float
  float = {
    -- Padding around the floating window
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 10,
    },
    -- This is the config that will be passed to nvim_open_win.
    -- Change values here to customize the layout
    override = function(conf)
      return conf
    end,
  },
  -- Configuration for the actions floating preview window
  preview = {
    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a single value or a list of mixed integer/float types.
    -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
    max_width = 0.9,
    -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
    min_width = { 40, 0.4 },
    -- optionally define an integer/float for the exact width of the preview window
    width = nil,
    -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a single value or a list of mixed integer/float types.
    -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
    max_height = 0.9,
    -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
    min_height = { 5, 0.1 },
    -- optionally define an integer/float for the exact height of the preview window
    height = nil,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
  -- Configuration for the floating progress window
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
})
require('rust-tools').setup(rt)
local cmp = require'cmp'
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
cmp.setup({
    snippet = {
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<Esc>'] = cmp.mapping.close(),
      -- ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      -- ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace,select = true}),
      ['<Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            -- fallback()
            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
          end
      end,
      ['<S-Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            -- fallback()
            cmp_ultisnips_mappings.jump_backwards(fallback)
          end
      end,
      ["<cr>"] = cmp.mapping.confirm({select = true})
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' }, 
      { name = 'path' },
      { name = 'buffer' },
      { name = 'calc' }
    }),
    completion = {
        keyword_length = 1,
        completeopt = "menu,menuone,noselect"
    },
    experimental = {
        ghost_text = false
    },
  })

cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
})
-- Setup lspconfig. update_capabilities --> default_capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
local lspconfig = require("lspconfig")
-- nvim-colorizer.lua: #8080ff; 十六进制颜色实时显示
-- require'colorizer'.setup{
--        'css';
--        'javascript';
        -- 'python';
--        html = {
--            mode = 'foreground';
--        }
-- }
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pylsp
-- pip install python-lsp-server python-lsp-black(模式化代码) python-lsp-ruff --改用rust ruff进行类型检查
lspconfig.pylsp.setup({
  on_attach = custom_attach,
  settings = {
    pylsp = {
      plugins = {
        ruff = { enabled = true, executable = "ruff", lineLength = 128}, -- 用ruff替换pyflakes,flake8,pycodestyle,mccabe
        -- pylint = { enabled = true, executable = "pylint" },
        -- pyflakes = { enabled = false, executable = "flake8"},
        -- pycodestyle = { enabled = false},
        -- mccabe = { enabled = false},
        jedi_completion = { fuzzy = true},
        python_lsp_black = { enabled = true},
      },
    },
  },
  flags = {
    debounce_text_changes = 200,
  },
  capabilities = capabilities,
})
-- javascript tssverver install nodejs npm
-- npm install -g typescript typescript-language-server
lspconfig.tsserver.setup({
    cmd = {"/opt/homebrew/bin/typescript-language-server", "--stdio" },
    filetypes = {"js", "ts", "html", "javascript", "javascriptreact", "javascript.jsx", "typescript",
    "typescriptreact", "typescript.tsx"},
    capabilities = capabilities,
})
-- html : npm i -g vscode-langservers-extracted
-- which vscode-html-language-server, 配置不起作用？
-- lspconfig.html.setup {
-- capabilities = capabilities,
-- }
-- dart flutter 
require'nvim-treesitter.configs'.setup {
    -- run :TSInstall python html css dart javascript lua typescript
    -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = {
        "javascript", "beancount", "bibtex", "c_sharp", "clojure", "comment",
        "commonlisp", "cuda", "dart", "devicetree", "elixir", "erlang",
        "fennel", "Godot", "glimmer", "graphql", "java", "jsdoc", "julia",
        "kotlin", "ledger", "nix", "ocaml", "ocaml_interface", "php", "ql",
        "query", "r", "rust", "ruby", "scss", "sparql", "supercollider",
        "svelte", "teal", "tsx", "typescript", "turtle", "verilog", "vue", "zig",
        "python","css",'html','toml'
        
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = {"beancount", "bibtex", "c_sharp", "clojure", "comment",
        "commonlisp", "cuda", "devicetree", "elixir", "erlang",
        "fennel", "Godot", "glimmer", "graphql", "java", "julia",
        "kotlin", "ledger", "nix", "ocaml", "ocaml_interface", "php", "ql",
        "r", "rust", "ruby", "sparql", "supercollider", "query",
        "svelte", "teal", "turtle", "verilog", "zig","toml",
        } -- list of language that will be disable
    },
    indent = {
            enable = true,
    },
    autotag = {enable=true},
    refactor = {
        highlight_definitions = { enable = true },
        -- highlight_current_scope = { enable = true }, 
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "fr", --重命名
                },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "fd", -- 跳转到定义
                list_definitions = "fD", -- 显示定义
                list_definitions_toc = "fl", -- 显示所有定义
                goto_next_usage = "fj", -- 跳转至下一个引用
                goto_previous_usage = "fk", -- 跳转至上一个引用
            },
        },
    },
}
-- require'treesitter-context.config'.setup{
--    enable = true, -- 函数或类太长时，上方显示该前所属
-- }
-- 通知窗口
-- vim.notify = require("notify")
require("notify").setup({
  -- Animation style (see below for details)
  stages = "fade_in_slide_out",
  -- Function called when a new window is opened, use for changing win settings/config
  on_open = nil,
  -- Function called when a window is closed
  on_close = nil,
  -- Render function for notifications. See notify-render()
  render = "default",
  -- Default timeout for notifications
  timeout = 5000,
  -- For stages that change opacity this is treated as the highlight behind the window
  -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
  background_colour = "Normal",
  -- Minimum width for notification windows
  minimum_width = 50,
  -- Icons for the different levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "I",
    DEBUG = "D",
    TRACE = "✎",
  },
})
vim.notify = require("notify")
-- 缩进线显示
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    -- component_separators = { left = "", right = "" },
    -- section_separators = { left = "", right = "" },
    section_separators = "",
    component_separators = "",
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = {
      "filename",
      {
        ime_state,
        color = {fg = 'black', bg = '#e4736b'}
      },
      {
        spell,
        color = {fg = 'black', bg = '#5999da'}
      },
    },
    lualine_x = {
      "encoding",
      {
        "fileformat",
        symbols = {
          unix = "unix",
          dos = "win",
          mac = "mac",
        },
      },
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = {
      "location",
      {
        "diagnostics",
        sources = { "nvim_diagnostic" }
      },
      {
        trailing_space,
        color = "WarningMsg"
      },
      {
        mixed_indent,
        color = "WarningMsg"
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {'quickfix', 'fugitive'},
})
require("bufferline").setup({
    options = {
        numbers = "buffer_id",
        close_command = "bdelete! %d",
        right_mouse_command = nil,
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
            style = 'icon',
            icon = '|',},
        buffer_close_icon = "x",
        modified_icon = "●",
        close_icon = "x",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 4,
        -- 使用 nvim 内置lsp
        diagnostics = "nvim_lsp",
        -- 左侧让出 nvim-tree 的位置
        -- offsets = {{
        --       filetype = "NvimTree",
        --        text = "File Explorer",
        --       highlight = "Directory",
        --       text_align = "left"
        -- }},
        custom_filter = function(bufnr)
          local exclude_ft = { "qf", "fugitive", "git" }
          local cur_ft = vim.bo[bufnr].filetype
          local should_filter = vim.tbl_contains(exclude_ft, cur_ft)
          if should_filter then
            return false
          end
          return true
        end,
        show_buffer_icons = false,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = "bar",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = "id",
    },
})
EOF
let g:vim_markdown_math = 1
" ******************python path设置***************
let g:python3_host_prog = "/Users/abc/miniforge3/bin/python"
" ******************UltiSnips设置***************
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" ******************accelerated_jk 加快j、k速度设置***************
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
" set shortmess+=c
" ******************leader键设置***************
let g:mapleader = ";"
let g:maplocalleader=';'
" ******************文件树Netrw 设置***************
" Vex左侧 :Sex
" 水平 :Vex!右侧
let g:netrw_banner = 0
let g:netrw_liststyle = 3
" 定义Netrw文件树打开方式：0当前窗口,1水平,2垂直,3新标签,4新窗口
let g:netrw_browse_split = 3
" 文件浏览器的宽度，为窗口的25%
let g:netrw_winsize = 25
" ******************leaderF 设置***************
" 弹窗显示结果
let g:Lf_WindowPosition = 'popup'
" brew install ctags 安装ctags 以便支持;:LeaderfFunction
" 列出所有LeaderF的可执行命令, 供用户检索, 可以不用记忆所有其他命令
noremap <silent> <Localleader>f :LeaderfFile <cr>
noremap <silent> <Localleader>fh :LeaderfSelf<cr>
" 搜索most recently used file, 默认显示100个, 可以配置数量
noremap <silent> <Localleader>fm :LeaderfMru<cr>
" 搜索当前目录most recently used file, 默认显示100个, 可以配置数量
noremap <silent> <Localleader>fmm :LeaderfMruCwd<cr>
" 查找当前文件的函数或者方法, 这个基本可以用来替代tarbar
noremap <silent> <Localleader>ff :LeaderfFunction!<cr>
" 检索当前buffer的tags
noremap <silent> <Localleader>ft :LeaderfBufTag!<cr>
" 但查找所有listed buffers的tags
noremap <silent> <Localleader>fb :LeaderfBufTagAll!<cr>
" 在当前文件单词搜索行, 可以用来替代/和?
noremap <silent> <Localleader>fl :LeaderfLine<cr>
" 在所有vim的windows里检索
noremap <silent> <Localleader>fw :LeaderfWindow<cr>
" Hop 快捷单词跳转 ;j 行跳转;l 
noremap <silent> <Localleader>j <cmd>lua require'hop'.hint_words()<cr>
noremap <silent> <Localleader>l :HopLine<cr>
" ******************vim-startify启动页***************
let g:startify_session_dir = '~/.config/nvim/session'
let g:startify_session_autoload = 1
let g:startify_custom_header = [
    \ '+--------------------------+',
    \ '     today is a good day    ',
    \ '+--------------------------+',
    \]
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction
" vim-startify 首页显示参数
let g:startify_lists = [
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'files',     'header': ['   Files']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]
let g:startify_bookmarks = ['~/Documents/Google/tornadoProject/ichingshifa','~/Public/']
" ******************theme 设置***************
if has("gui_running")
    set background=light
    colorscheme onehalflight
else
    set background=light
    colorscheme onehalflight
endif
" let g:everforest_background = 'hard'
" let g:everforest_better_performance = 1
" ******************neoformat 设置***************
let g:neoformat_enabled_python = ['black']
autocmd FileType python noremap <buffer> <F8> :Neoformat! python black --fast<CR>
autocmd FileType js noremap <buffer> <F9> :Neoformat! js-beautify<CR>
noremap <silent> <Localleader>cc <Plug>NERDCommenterComment
noremap <silent> <Localleader>cu <Plug>NERDCommenterUncomment
" save files with auto format
" augroup fmt
"   autocmd!
"   autocmd BufWritePre * undojoin | Neoformat
" augroup END
" ****************** 代码注释插件 nerdcomment设置***************
let g:NERDSpaceDelims=1
" ******************vim基本设置***************
" 保持缩进
augroup remember_folds
  autocmd!
  autocmd BufWritePre * mkview
  autocmd BufWritePost * silent! loadview
augroup END
" 行号：插入模式显示绝对否则显示相对行号
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
" 减少重绘次数
set lazyredraw
" 设置历史操作记录为1000条
set history=1000
" 复制+粘贴快捷键设置
nnoremap <silent> <C-c> "+yy<CR>
nnoremap <silent> <C-v> "+p<CR>
map <C-c> "+yy
map <C-v> "+p
" 共享系统剪切板, m1 架构下好像存在问题, mac下直接注释掉就可以复制中文！！！
" set clipboard=unnamed
" set clipboard^=unnamed,unnamedplus
set clipboard+=unnamed,unnamedplus
" set clipboard=unnamedplus
" 命令模式下，在底部显示，当前键入的指令。键入指令是2y3d，底部显示2y3，键入d的时候，显示消失
set showcmd
" 保留撤销历史
" set undofile
" 最后的状态
set laststatus=1
" 正则匹配除了 $ . * ^ 之外其他元字符都要加反斜杠
set magic
" 光标所在的当前行高亮
set cursorline
" 设置行宽，即一行显示多少个字符。
set textwidth=108
" 自动折行，即太长的行分成几行显示。
" set nowrap
set wrap
" 只有遇到指定的符号（比如空格、连词号和其他标点符号），才发生折行。
set linebreak
" 支持使用鼠标。
set mouse=a
" set guioptions的缩写,gvim里可以通过设置 guioptions 来达到显示或隐藏某些gui组件
" set guioptions=m 可以隐藏菜单栏
set go=
" 在vi中输入），}时，光标会暂时的回到相匹配的（，{（如果没有相匹配的就发出错误信息的铃声），编程时很有用
set showmatch
" 自动载入被修改的文件
set autoread
au FocusGained,BufEnter * checktime
" 短暂跳转到匹配括号的时间
set matchtime=1
" 不创建备份文件。默认情况下，文件保存时，会额外创建一个备份文件，它的文件名是在原文件名的末尾，再添加一个波浪号（〜）。
set nobackup
" 表示不创建临时交换文件
set noswapfile
" 表示编辑的时候不需要备份文件
set nowritebackup
" 表示不创建撤销文件
set noundofile
" 没有保存或文件只读时弹出确认
set confirm
" 按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致
set autoindent
" 智能选择对齐方式,类似C语言.换行时自动学会缩进
set smartindent
" #很聪明的查找,输入一个字符马上自动匹配,而不是输入完再查找
set incsearch
" 搜索时支持大小写
set ignorecase
set smartcase
" 按下 Tab 键时，Vim 显示的空格数。
set tabstop=4
" 在文本上按下>>（增加一级缩进）、<<（取消一级缩进）或者==（取消全部缩进）时，每一级的字符数
set shiftwidth=4
" 由于 Tab 键在不同的编辑器缩进不一致，该设置自动将 Tab 转为空格。
set expandtab
" set smarttab
set nocompatible
" 命令模式下，底部操作指令按下 Tab 键自动补全。
set wildmenu
set wildmode=longest:list,full
set fo=cqrt
" 是否显示状态栏。0 表示不显示，1 表示只在多窗口时显示，2 表示显示。
set laststatus=2
" 在状态栏显示光标的当前位置（位于哪一行哪一列）
set ruler
" 对退格键提供更好帮助
set backspace=indent,eol,start
" 出错时，发出视觉提示，通常是屏幕闪烁。
set noeb visualbell
"侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on
" 打开语法高亮。自动识别代码，使用多种颜色显示。
syntax on
syntax enable
" 自动切换工作目录，Vim会话之中打开多个文件情况
set autochdir
" encoding
set fencs=utf-8,usc-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
" " 使用 utf-8 编码
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
set foldmethod=indent
set foldlevel=99
" ******************vim设置字体,显示nvim-web-devicons***************
" -- brew tap homebrew/cask-fonts
" -- brew install font-hack-nerd-font
" Linux
" set guifont=<FONT_NAME> <FONT_SIZE>
" set guifont=hack_nerd_font_mono:h14
" macOS (OS X) and Windows
" set guifont=<FONT_NAME>:h<FONT_SIZE>
set guifont=hack_nerd_font_mono:h14
" ******************neovim自带高亮复制显示设置***************
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END
" ******************pythonF9自动运行设置***************
map <F9> :call CompileRunGcc()<CR>
nnoremap <silent> <leader>r :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec '!g++ % -o %<'
        exec '!time ./%<'
    elseif &filetype == 'cpp'
        exec '!g++ % -o %<'
        exec '!time ./%<'
    elseif &filetype == 'python'
        exec '!time ~/miniforge3/bin/python3 %'
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'dart'
        :!time dart %
    endif
endfunc
" ******************python自动插入文件标题***************
autocmd BufNewFile *py exec ":call SetPythonTitle()"
func SetPythonTitle()
  call setline(1,"# -*- coding: utf-8 -*-")
  call append(line("."), "\# File Name: ".("%"))
  call append(line(".")+5, "\# Created Time: ".strftime("%Y-%m-%d",localtime()))
endfunc
" 新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G o
" ******************vim-which-key设置***************
" ******************session设置***************
" 默认超时是 1000 ms,超时提示对应的快捷键
set timeoutlen=500
nnoremap <silent> <leader>sl :SLoad<CR>
nnoremap <silent> <leader>ss :SSave<CR>
nnoremap <silent> <leader>sd :SDelete<CR>
nnoremap <silent> <leader>sc :SClose<CR>
nnoremap <silent> <leader>u :UndotreeToggle<CR>
" ******************window窗口设置***************
nnoremap <silent> <leader>wh :wincmd h<CR>
nnoremap <silent> <leader>wj :wincmd j<CR>
nnoremap <silent> <leader>wk :wincmd k<CR>
nnoremap <silent> <leader>wl :wincmd l<CR>
nnoremap <silent> <leader>nt :Oil --float<CR>
" ******************lsp-key设置***************
" 查看函数声明
" nnoremap <silent> <Localleader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
" " 查看函数定义
nnoremap <silent> <Localleader>gd <cmd>tab split \| lua vim.lsp.buf.definition()<CR> " new tab
" " 查看函数帮助文档
" nnoremap <silent> <Localleader>gh <cmd>lua vim.lsp.buf.hover()<CR>
" " 查看函数相关引用
nnoremap <silent> <Localleader>ge <cmd>lua vim.lsp.buf.references()<CR>
" " 变量重命名
" nnoremap <silent> <Localleader>gr <cmd>lua vim.lsp.buf.rename()<CR>
" " 查看前一处语法错误
" nnoremap <silent> <Localleader>gj <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
" " 查看后一处语法错误
" nnoremap <silent> <Localleader>gk <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" " go to definition lsp_finder/ preview_definition
" " formatting coding 
" nnoremap <silent> <Localleader>gf <cmd>lua vim.lsp.buf.formatting()<CR>
" ******************Leader***************
let g:which_key_map_localleader =  {
            \'fb' : 'LeaderF 缓冲区tags所有',
            \'ft' : 'LeaderF 缓冲区tags当前',
            \'fh' : 'LeaderF 帮助',
            \'f' : 'LeaderF 文件打开',
            \'fm' : 'LeaderF 使用最多文件所有',
            \'fmm' : 'LeaderF 使用最多文件当前',
            \'ff' : 'LeaderF 文件函数',
            \'fl' : 'LeaderF 搜索单词',
            \'fw' : 'LeaderF 搜索窗口',
            \'gd' : 'lsp跳转定义',
            \'gp' : 'lsp查看定义',
            \'gj' : 'lsp查看前一处错误',
            \'gr' : 'lsp变量重命名',
            \'gh' : 'lsp查看帮助文档',
            \'ge' : 'lsp查看相关引用',
            \'gk' : 'lsp查看后一处错误',
            \'cc' : '代码注释',
            \'cu' : '代码取消注释',
            \'sl' : 'session 打开',
            \'ss' : 'session 保存',
            \'sd' : 'session 删除',
            \'sc' : 'session 关闭',
            \'u' : '撤消历史管理',
            \'h' : '帮助文档',
            \'nt' : '目录打开/关闭',
            \}
call which_key#register(';', "g:which_key_map_localleader")
" ******************treesitter-refactor***************
" 模版补全：ctrl+k , ctrl+j
let g:which_key_map_treesitter_refactor =  {
            \'r' : 'treesitter变量重命名',
            \'d' : 'treesitter跳转至定义',
            \'D' : 'treesitter查看函数声明',
            \'l' : 'treesitter显示所有定义',
            \'j' : 'treesitter跳转至下一个引用',
            \'k' : 'treesitter跳转至上一个引用',
            \'v' : ['Vex','文件树水平窗口'],
            \'s' : ['Sex','文件树水平窗口'],
            \'wh' : 'window左边',
            \'wj' : 'window下一个',
            \'wk' : 'window上一个',
            \'wl' : 'window右边',
            \'x' : '忽略NetrwBrowseX',
            \'%' : '忽略MatchitOperationBackward',
            \}
call which_key#register('f', "g:which_key_map_treesitter_refactor")
" ******************tab切换***************
let g:which_key_map_tab = {
            \'j' : ['tabn','tab下一个'],
            \'k' : ['tabp','tab前一个'],
            \'c' : ['tabc','tab关闭当前'],
            \'o' : ['tabo','tab关闭所有其它'],
            \'s' : ['tabs','tab查看所有打开'],
            \'n' : ['tabnew','tab新建'],
            \}
call which_key#register('t', "g:which_key_map_tab")
nnoremap <silent> <leader> :WhichKey ';'<CR>
nnoremap <silent> <localleader> :WhichKey ';'<CR>
nnoremap <silent> t :<c-u>WhichKey 't'<CR>
nnoremap <silent> f :<c-u>WhichKey 'f'<CR>
" ******************startify hide status***************
" autocmd BufEnter * if len(tabpagebuflist()) == 1 | Startify | endif
" 打开文件时，自动跳到上次打开时的位置。如果该位置有错，则不做跳转
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   execute "normal g`\"" |
            \ endif
" 保存init.vim时自动重载，可以直接调用：PackerInstall进行安装
autocmd! BufWritePost $MYVIMRC source $MYVIMRC
" neovide配置
" let g:neovide_refresh_rate=60 " 刷新率
" let g:neovide_refresh_rate_idle=5 "闲置刷新率
" let g:neovide_transparency=0.99 "透明度
" let g:neovide_cursor_trail_size=0.95 "动画步道大
" let g:neovide_cursor_vfx_mode = "ripple" " 光标冒泡
" let g:neovide_cursor_vfx_particle_speed = 2 " speed
