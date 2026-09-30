# Переход с lazy.nvim на vim.pack

Источник для сверки: `.migration-backup/pre-vim-pack-2026-09-29/`. В нём 55 плагинов, объявленных в старом конфиге, без самого менеджера `lazy.nvim`.

**Статусы:** ✅ перенесён в активный конфиг (не обязательно уже установлен локально); 🔁 заменён частично; ⏳ ожидает переноса; 🚫 исключён из планов переноса (остаётся в бэкапе). Наличие записи в `nvim-pack-lock.json` не означает, что все функции плагина проверены вручную.

**Правило дальнейшей миграции:** ассистент только добавляет `vim.pack.add` в Lua-файлы, подключает их в `init.lua` и переносит настройки/бинды. **Сам не запускает установку плагинов** (включая запуск Neovim с активным конфигом, который вызовет `vim.pack.add`), не скачивает их вручную и не обновляет lock-файл ради установки. Установку и проверку работы установленных плагинов выполняет пользователь. Допустимы проверки синтаксиса и тесты с заглушкой `vim.pack.add`, которые не обращаются к сети.
Бинды записывать напрямую через `vim.keymap.set(...)`, опции — через `vim.opt`, без локальных псевдонимов `map` и `opt`.

Спецификации `vim.pack.add` теперь содержат только URL, без `src`, `name`, `version`, `confirm` и `load`. При новой установке Neovim по умолчанию запросит подтверждение. Без `name` репозиторий `rose-pine/neovim` будет регистрироваться под именем `neovim`, а не прежним `rose-pine`; существующий lock-файл вручную не менялся. Удаление `version` для fff и Treesitter означает, что при будущей установке/обновлении будет использоваться обычная ревизия по умолчанию, а не ранее указанная версия.
Хуки установки/обновления регистрируются через `lua/utils/pack_changed.lua`; действия каждого плагина остаются в его модуле и срабатывают только на события `install` и `update`.

## Старые плагины

### Темы

| Плагин | Статус | Активная конфигурация |
| --- | --- | --- |
| `rose-pine` | ✅ | `lua/plugins/colorscheme.lua`; тема по умолчанию |
| `tokyonight.nvim` | ✅ | `lua/plugins/colorscheme.lua` |

### Интерфейс и навигация

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `snacks.nvim` | ✅ | `lua/plugins/snacks.lua`: прежние бинды перенесены через `vim.pack`. Совпадающие бинды с FFF и Fyler оставлены; из-за порядка подключения в `init.lua` бинды Snacks получают приоритет. После переноса конфиг изменён вручную: секция `explorer` удалена, `picker` содержит `enbkaed = false` (возможно, опечатка). `<leader>sp` по-прежнему вызывает пикер lazy.nvim, которого больше нет. |
| `which-key.nvim` | ✅ | `lua/plugins/which-key.lua`: прежний preset `helix`, группы, `<leader>?` и `<C-w><Space>`. |
| `bufferline.nvim` | ✅ | `lua/plugins/bufferline.lua`: прежние оформление, диагностика и семь биндов; иконки через `mini.icons`, отступ для Fyler вместо neo-tree. `<S-h>`/`<S-l>` теперь переключают буферы в порядке Bufferline. |
| `lualine.nvim` | ⏳ | — |
| `lualine-pretty-path` | ⏳ | Зависимость прежней настройки lualine. |
| `nvim-web-devicons` | ⏳ | Вместо него для Fyler подключён `mini.icons`; если другим плагинам понадобится именно web-devicons, вернуться к решению. |
| `tiny-inline-diagnostic.nvim` | ⏳ | — |
| `marks.nvim` | ⏳ | — |

### Редактирование

| Плагин | Статус |
| --- | --- |
| `blink.cmp` | ✅ | `lua/plugins/blink.lua`: старые бинды (`enter` и `<C-y>`), источники LSP/путей/сниппетов/буфера и иконки типов дополнения из бэкапа. Lua fuzzy без сборки Rust. |
| `friendly-snippets` | ✅ | Подключён рядом с Blink; источник сниппетов также читает восстановленный `snippets/go.json`. |
| `mini.ai` | ⏳ |
| `mini.align` | ⏳ |
| `mini.pairs` | ⏳ |
| `mini.surround` | ⏳ |
| `nvim-colorizer.lua` | ⏳ |
| `ts-comments.nvim` | ⏳ |
| `yanky.nvim` | ⏳ |
| `inc-rename.nvim` | ⏳ |
| `dotenv.nvim` | ⏳ |

### Поиск, Git и утилиты

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `grug-far.nvim` | ⏳ | FFF не заменяет интерактивную замену текста. |
| `git-conflict.nvim` | ⏳ | — |
| `todo-comments.nvim` | ⏳ | Старый вызов `Snacks.picker.todo_comments()` потребует отдельной замены. |
| `leetcode.nvim` | 🚫 | Решено не переносить; старый `picker.provider = "snacks-picker"` больше не подходит без Snacks. |
| `nui.nvim` | 🚫 | Зависимость исключённого `leetcode.nvim`; отдельно не нужен. |
| `plenary.nvim` | ⏳ | Зависимость нескольких ещё не перенесённых плагинов. |

### LSP и форматирование

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `nvim-lspconfig` | ✅ | Подключён в `lua/plugins/lsp.lua`; LSP-бинды переведены на встроенный API, знаки диагностики восстановлены из бэкапа. Настройки отдельных языков пока не перенесены. |
| `mason.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; `<leader>cm` открывает Mason. |
| `mason-lspconfig.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; автоматически включает установленные через Mason LSP-серверы. |
| `mason-tool-installer.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; пока запрашивает только `lua_ls`. |
| `conform.nvim` | ✅ | `lua/plugins/formatting.lua`: форматтеры из бэкапа, бинды и форматирование перед сохранением. Исполняемые файлы форматтеров нужно установить отдельно. |
| `nvim-lint` | 🚫 | Решено не переносить. |
| `lazydev.nvim` | ✅ | `lua/plugins/lsp.lua`: поддержка `vim.uv`, без старых зависимостей для busted/luassert/Snacks. |
| `SchemaStore.nvim` | ✅ | Подключён в `lua/plugins/lsp.lua` без `setup()`; схемы пока не подключены к JSON/YAML LSP. |
| `luassert-types` | 🚫 | Библиотека старой настройки lazydev; не переносить. |
| `busted-types` | 🚫 | Библиотека старой настройки lazydev; не переносить. |

### Treesitter

Все пять плагинов подключаются и настраиваются в `lua/plugins/treesitter.lua`.

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `nvim-treesitter` | ✅ | Настройка, установка парсеров, `FileType`-автокоманда, клавиши; загрузка недостающих парсеров требует сети. |
| `nvim-treesitter-textobjects` | ✅ | Настройка и клавиши движения/обмена. |
| `nvim-treesitter-context` | ✅ | Настройка контекста. |
| `tree-sitter-d2` | ✅ | Обработчик `PackChanged` для `make nvim-install`. |
| `tree-sitter-ghostty` | ✅ | Обработчик `PackChanged` для `make nvim_install`. |

### Отладка и тесты

| Плагин | Статус |
| --- | --- |
| `nvim-dap` | ⏳ |
| `nvim-dap-view` | ⏳ |
| `nvim-dap-envfile` | ⏳ |
| `nvim-dap-go` | ⏳ |
| `mason-nvim-dap.nvim` | ⏳ |
| `one-small-step-for-vimkind` | ⏳ |
| `neotest` | ⏳ |
| `nvim-nio` | ⏳ |
| `neotest-golang` | ⏳ |
| `neotest-plenary` | ⏳ |
| `nvim-coverage` | ⏳ |

### Превью

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `markdown-preview.nvim` | ✅ | `lua/plugins/preview.lua`: `<leader>cp` для Markdown, `FileType` для команд в текущем буфере; установщик плагина вызывается через `PackChanged` при установке/обновлении пользователем. |
| `swagger-preview.nvim` | ✅ | `lua/plugins/preview.lua`: `<leader>cp` для JSON, прежние host `127.0.0.1` и port `6969`; `npm install` вызывается через `PackChanged` при установке/обновлении пользователем. Требуется npm. |

Итого для старого набора: **21 перенесён, 29 ожидают переноса, 5 исключены**. `lazy.nvim` как менеджер заменён на `vim.pack` и в подсчёт не входит.

SchemaStore, LSP/Mason и `which-key.nvim` присутствуют в `nvim-pack-lock.json`, но работу LSP, установку `lua_ls` и интерфейс which-key нужно проверить вручную.
Прежние бинды LSP из `lua/core/lsp.lua` перенесены в `lua/plugins/lsp.lua` с заменой Snacks picker на встроенные действия Neovim (списки определений/ссылок и символов открываются стандартным интерфейсом). Старое удаление встроенных `grn`, `gra`, `gri`, `grr` не возвращали; у `gr` больше нет `nowait`, чтобы эти встроенные сочетания оставались доступными. SchemaStore и языковые настройки LSP остаются в `lsp.lua`; для дополнения вместо встроенного LSP-автотриггера подключён Blink в `lua/plugins/blink.lua` (до `lsp.lua` в `init.lua`). Встроенное автоматическое дополнение слов отключено, чтобы меню не конкурировали.

## Новые замены

| Плагин | Назначение | Состояние |
| --- | --- | --- |
| [`fff`](https://github.com/dmtrKovalenko/fff) | Альтернативный поиск файлов и live grep | Добавлен в `lua/plugins/fff.lua` и native lock-файл. Нативный бинарник `libfff_nvim` присутствует; работу интерактивного пикера вручную ещё нужно проверить. Бинды могут перекрываться Snacks. |
| [`fyler.nvim`](https://github.com/FylerOrg/fyler.nvim) | Альтернативное дерево слева | Добавлен в `lua/plugins/fyler.lua` и native lock-файл; `<leader>e` переключает крайний левый сплит шириной 30 колонок. Текущий каталог отображается сверху (`winbar`); имена dotfiles при показе через `g.` подсвечиваются приглушённым цветом `Comment`. Fyler настроен как проводник по умолчанию, но `<leader>e` теперь перекрыт Snacks. |
| [`mini.icons`](https://github.com/nvim-mini/mini.icons) | Иконки файлов и каталогов для Fyler | Подключён в `lua/plugins/icons.lua`, присутствует в native lock-файле; Fyler использует провайдер `mini_icons`. |
| [`blink.lib`](https://github.com/saghen/blink.lib) | Зависимость Blink из текущей ветки | Подключён в `lua/plugins/blink.lua`; старый Blink v1 обходился без этого плагина. |

## Очерёдность оставшегося переноса

Приоритет ориентировочный: сначала базовые возможности редактора, затем удобства и специализированные инструменты. Внутри группы можно переносить плагины по одному или небольшими связками; настройки каждого плагина держать рядом с его подключением. Ниже перечислены **29** плагинов со статусом ⏳ ровно по одному разу. Настройки отдельных языковых LSP-серверов ещё предстоит вернуть из бэкапа без старого механизма слияния `opts`; каталог SchemaStore пока не подключён к JSON/YAML LSP.

1. **Повседневное редактирование и поиск с заменой (10):** `mini.pairs`, `mini.ai`, `mini.surround`, `ts-comments.nvim`, `grug-far.nvim`, `mini.align`, `yanky.nvim`, `inc-rename.nvim`, `nvim-colorizer.lua`, `dotenv.nvim`.
2. **Интерфейс, навигация и Git (8):** `lualine.nvim`, `lualine-pretty-path`, `tiny-inline-diagnostic.nvim`, `todo-comments.nvim`, `git-conflict.nvim`, `marks.nvim`, `nvim-web-devicons`, `plenary.nvim`. `nvim-web-devicons` не нужен Fyler или Bufferline с `mini.icons`: переносить только если потребуется другим плагинам. `plenary.nvim` ставить раньше зависящего от него плагина, а не обязательно на этом этапе.
3. **Отладка и тесты (11):** `nvim-dap`, `nvim-dap-view`, `nvim-dap-envfile`, `nvim-dap-go`, `mason-nvim-dap.nvim`, `one-small-step-for-vimkind`; затем `nvim-nio`, `neotest`, `neotest-golang`, `neotest-plenary`, `nvim-coverage`. Зависимости устанавливать перед надстройками.
Превью (`markdown-preview.nvim`, `swagger-preview.nvim`) уже подключены; для них предусмотрены отдельные build-шаги.

**Исключены из переноса (5):** `luassert-types`, `busted-types`, `leetcode.nvim`, `nui.nvim`, `nvim-lint`. Их конфигурация остаётся только в бэкапе; устанавливать их не планируем.

**Отдельно:** `snacks.nvim` теперь подключён по просьбе пользователя. Совпадения биндов с FFF/Fyler оставлены для последующей ручной чистки; настройки explorer и picker пользователь уже начал редактировать.

## Бинды прежнего Snacks

Все бинды из прежнего `lua/plugins/snacks.lua` восстановлены в `lua/plugins/snacks.lua` без удаления конфликтующих сочетаний. Модуль загружается последним, поэтому `<leader><space>`, `<leader>fc`, `<leader>/`, `<leader>sw`, `<leader>sR` и `<leader>e` теперь вызывают Snacks вместо FFF/Fyler. В visual mode `<leader>sw` по-прежнему вызывает FFF (Snacks регистрирует этот бинд только в normal mode). `<leader>sp` остался вызовом `Snacks.picker.lazy()` и может не работать без lazy.nvim. Настройки `bigfile`, `quickfile`, GitLab URL, уведомлений, indent, scope и words перенесены; секция explorer позднее удалена пользователем, а настройка picker изменена.

## Сверка биндов уже подключённых плагинов

Сопоставлены Lua-файлы активного конфига и бэкапа, а также список в `nvim-pack-lock.json`. Это проверка определений, **не** ручной тест плагинов в запущенном Neovim.

| Область | Результат |
| --- | --- |
| which-key | Перенесены `<leader>?` и `<C-w><Space>`, preset `helix` и старые группы. Часть групп пока не содержит биндов, поскольку соответствующие плагины ещё не перенесены. |
| Treesitter | Старые `[n`, `]n`, `<C-Space>`, `<BS>`, `<M-h>`, `<M-l>`, `[f`/`]f`, `[a`/`]a`, `[c`/`]c` присутствуют. |
| Conform | `<leader>cf` и `<leader>cF` присутствуют; форматирование перед сохранением перенесено. |
| Bufferline | `<leader>bp`, `<leader>br`, `<leader>bl`, `<S-h>`, `<S-l>`, `[b`, `]b` перенесены. Последние два двигают буфер по строке, а `<S-h>`/`<S-l>` переопределяют общие `:bprevious`/`:bnext`. |
| Blink | Preset `enter` и `<C-y>` для выбора и принятия пункта сохранены; встроенное Neovim-автодополнение больше не включается параллельно. |
| Mason | `<leader>cm` присутствует. |
| FFF, Fyler и Snacks | Все бинды Snacks восстановлены; совпадающие сочетания в normal mode перекрывают бинды FFF/Fyler из-за порядка подключения. |
| LSP | Перенесены `K`, `gd`, `gD`, `gI`, `gK`, `gr`, `gy`, `<C-k>` (insert), `<leader>cC`, `<leader>ca`, `<leader>cc`, `<leader>cl`, `<leader>cr`, `<leader>ss`, `<leader>sS`. Вместо прежних Snacks picker используются `vim.lsp.buf.*`, `vim.lsp.codelens.*` и `:LspInfo`: списки/символы показываются стандартным интерфейсом Neovim. Удаление встроенных `grn`, `gra`, `gri`, `grr` намеренно не возвращали. |
| Общие бинды | Из `lua/config/keymaps.lua` не вернулся `<leader>ur` (очистка поиска, `diffupdate`, перерисовка). Старый `<leader>l` для lazy.nvim намеренно не возвращён; управление `vim.pack` осталось на `<leader>Pu` и `<leader>Pl`. |

Отдельно от биндов: настройки языковых LSP-серверов, интеграция SchemaStore с JSON/YAML и источник сниппетов для автодополнения ещё не перенесены.

## Общий статус конфига

- Базовые `options`, `keymaps`, `autocmds` сохранены; управление плагинами: `<leader>Pu` и `<leader>Pl`.
- Все 10 файлов `ftplugin/*` и `snippets/go.json` восстановлены из бэкапа без изменений. Сниппеты станут доступны через источник автодополнения после его переноса; настройки `lua/langs/*` и `lua/install.lua` всё ещё только в бэкапе.
- Ранее сознательно удалённые Rust, Typst, C++, timers.nvim и лишние темы в этот список не входят: их уже не было в данном снимке.
