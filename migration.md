# Переход с lazy.nvim на vim.pack

Источник для сверки: `.migration-backup/pre-vim-pack-2026-09-29/`. В нём 55 плагинов, объявленных в старом конфиге (включая `swagger-preview.nvim`, которого не было в `lazy-lock.json`), без самого менеджера `lazy.nvim`.

**Статусы:** ✅ перенесён в активный конфиг (не обязательно уже установлен локально); 🔁 заменён частично; ⏳ ожидает переноса; 🚫 исключён из планов переноса (остаётся в бэкапе). Наличие записи в `nvim-pack-lock.json` не означает, что все функции плагина проверены вручную.

**Правило дальнейшей миграции:** ассистент только добавляет `vim.pack.add` в Lua-файлы, подключает их в `init.lua` и переносит настройки/бинды. **Сам не запускает установку плагинов** (включая запуск Neovim с активным конфигом, который вызовет `vim.pack.add`), не скачивает их вручную и не обновляет lock-файл ради установки. Установку и проверку работы установленных плагинов выполняет пользователь. Допустимы проверки синтаксиса и тесты с заглушкой `vim.pack.add`, которые не обращаются к сети.
Бинды записывать напрямую через `vim.keymap.set(...)`, без локального псевдонима `map`.

Спецификации `vim.pack.add` теперь содержат только URL, без `src`, `name`, `version`, `confirm` и `load`. При новой установке Neovim по умолчанию запросит подтверждение. Без `name` репозиторий `rose-pine/neovim` будет регистрироваться под именем `neovim`, а не прежним `rose-pine`; существующий lock-файл вручную не менялся. Удаление `version` для fff и Treesitter означает, что при будущей установке/обновлении будет использоваться обычная ревизия по умолчанию, а не ранее указанная версия.

## Старые плагины

### Темы

| Плагин | Статус | Активная конфигурация |
| --- | --- | --- |
| `rose-pine` | ✅ | `lua/config/pack.lua`, `lua/plugins/colorscheme.lua`; тема по умолчанию |
| `tokyonight.nvim` | ✅ | `lua/config/pack.lua`, `lua/plugins/colorscheme.lua` |

### Интерфейс и навигация

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `snacks.nvim` | 🔁 | Поиск файлов и grep заменены на `fff`; файловое дерево — на `fyler.nvim`. Остальные функции Snacks не перенесены — см. ниже. Сам Snacks не установлен через `vim.pack`. |
| `which-key.nvim` | ⏳ | Группы и подсказки клавиш пока отсутствуют. |
| `bufferline.nvim` | ⏳ | — |
| `lualine.nvim` | ⏳ | — |
| `lualine-pretty-path` | ⏳ | Зависимость прежней настройки lualine. |
| `nvim-web-devicons` | ⏳ | Вместо него для Fyler подключён `mini.icons`; если другим плагинам понадобится именно web-devicons, вернуться к решению. |
| `tiny-inline-diagnostic.nvim` | ⏳ | — |
| `marks.nvim` | ⏳ | — |

### Редактирование

| Плагин | Статус |
| --- | --- |
| `blink.cmp` | ⏳ |
| `friendly-snippets` | ⏳ |
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
| `nvim-lspconfig` | ✅ | Подключён в `lua/plugins/lsp.lua`; настройки отдельных языков пока не перенесены. |
| `mason.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; `<leader>cm` открывает Mason. |
| `mason-lspconfig.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; автоматически включает установленные через Mason LSP-серверы. |
| `mason-tool-installer.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; пока запрашивает только `lua_ls`. |
| `conform.nvim` | ✅ | `lua/plugins/formatting.lua`: форматтеры из бэкапа, бинды и форматирование перед сохранением. Исполняемые файлы форматтеров нужно установить отдельно. |
| `nvim-lint` | 🚫 | Решено не переносить. |
| `lazydev.nvim` | ✅ | `lua/plugins/lsp.lua`: поддержка `vim.uv`, без старых зависимостей для busted/luassert/Snacks. |
| `SchemaStore.nvim` | ✅ | Подключён в `lua/plugins/autocomplete.lua` без `setup()`; схемы пока не подключены к JSON/YAML LSP. |
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
| `markdown-preview.nvim` | ⏳ | Старый build-хук вызывает `require("lazy")`; при переносе заменить. |
| `swagger-preview.nvim` | ⏳ | Есть в бэкапе, но отсутствует в его `lazy-lock.json`; нужна установка npm-зависимостей. |

Итого для старого набора: **14 перенесено, 1 заменён частично, 35 ожидают переноса, 5 исключены**. `lazy.nvim` как менеджер заменён на `vim.pack` и в подсчёт не входит.

Новые SchemaStore и LSP/Mason-плагины пока не добавлены в `nvim-pack-lock.json`: во время проверки установка с GitHub завершилась `Proxy CONNECT aborted`. Реальную работу LSP и установку `lua_ls` нужно проверить после восстановления доступа.
Прежние бинды LSP из `lua/core/lsp.lua` пока не перенесены: часть вызывала Snacks picker, часть может быть возвращена через встроенный `vim.lsp.buf` отдельно. Файл `lua/plugins/autocomplete.lua` сейчас содержит только SchemaStore, но ещё не плагин автодополнения.

## Новые замены

| Плагин | Назначение | Состояние |
| --- | --- | --- |
| [`fff`](https://github.com/dmtrKovalenko/fff) | Поиск файлов и live grep вместо соответствующих пикеров Snacks | Добавлен в `lua/plugins/fff.lua` и native lock-файл. Нативный бинарник `libfff_nvim` присутствует; работу интерактивного пикера вручную ещё нужно проверить. |
| [`fyler.nvim`](https://github.com/FylerOrg/fyler.nvim) | Дерево слева вместо Snacks Explorer / промежуточного netrw | Добавлен в `lua/plugins/fyler.lua` и native lock-файл; `<leader>e` переключает крайний левый сплит шириной 30 колонок. Текущий каталог отображается сверху (`winbar`); Fyler — проводник по умолчанию, изменения требуют подтверждения. Настроек netrw больше нет. |
| [`mini.icons`](https://github.com/nvim-mini/mini.icons) | Иконки файлов и каталогов для Fyler | Подключён в `lua/plugins/icons.lua`, присутствует в native lock-файле; Fyler использует провайдер `mini_icons`. |

## Очерёдность оставшегося переноса

Приоритет ориентировочный: сначала базовые возможности редактора, затем удобства и специализированные инструменты. Внутри группы можно переносить плагины по одному или небольшими связками; настройки каждого плагина держать рядом с его подключением. Ниже перечислены все **35** плагинов со статусом ⏳ ровно по одному разу. Настройки отдельных языковых LSP-серверов ещё предстоит вернуть из бэкапа без старого механизма слияния `opts`; каталог SchemaStore пока не подключён к JSON/YAML LSP.

1. **Автодополнение и сниппеты (2):** `blink.cmp`, `friendly-snippets`. Локальный `snippets/go.json` уже восстановлен; проверить его подключение к источнику сниппетов.
2. **Повседневное редактирование и поиск с заменой (10):** `mini.pairs`, `mini.ai`, `mini.surround`, `ts-comments.nvim`, `grug-far.nvim`, `mini.align`, `yanky.nvim`, `inc-rename.nvim`, `nvim-colorizer.lua`, `dotenv.nvim`.
3. **Интерфейс, навигация и Git (10):** `which-key.nvim`, `lualine.nvim`, `lualine-pretty-path`, `tiny-inline-diagnostic.nvim`, `todo-comments.nvim`, `git-conflict.nvim`, `bufferline.nvim`, `marks.nvim`, `nvim-web-devicons`, `plenary.nvim`. `nvim-web-devicons` не нужен Fyler с `mini.icons`: переносить только если потребуется другим плагинам. `plenary.nvim` ставить раньше зависящего от него плагина, а не обязательно на этом этапе.
4. **Отладка и тесты (11):** `nvim-dap`, `nvim-dap-view`, `nvim-dap-envfile`, `nvim-dap-go`, `mason-nvim-dap.nvim`, `one-small-step-for-vimkind`; затем `nvim-nio`, `neotest`, `neotest-golang`, `neotest-plenary`, `nvim-coverage`. Зависимости устанавливать перед надстройками.
5. **Специализированные и необязательные (2):** `markdown-preview.nvim`, `swagger-preview.nvim`. Для превью нужны отдельные build-шаги.

**Исключены из переноса (5):** `luassert-types`, `busted-types`, `leetcode.nvim`, `nui.nvim`, `nvim-lint`. Их конфигурация остаётся только в бэкапе; устанавливать их не планируем.

**Отдельно:** `snacks.nvim` — 🔁, а не ⏳: поиск и дерево уже заменены на fff и Fyler. Недостающие функции и бинды ниже следует оценивать по необходимости, а не автоматически возвращать весь Snacks.

## Бинды прежнего Snacks

**Перенесены:**

| Бинд | Было | Стало |
| --- | --- | --- |
| `<leader><space>` | Поиск файлов | `fff.find_files()` |
| `<leader>fc` | Поиск файлов конфига | `fff.find_files_in_dir(stdpath("config"))` |
| `<leader>/` | Grep | `fff.live_grep()` |
| `<leader>sw` | Grep слова | `fff.live_grep_under_cursor()`; теперь также работает в visual mode |
| `<leader>sR` | Возобновить пикер | `fff.resume()` |
| `<leader>e` | Snacks Explorer | `fyler.toggle({ kind = "split_left_most" })` |

FFF ищет в своей индексируемой директории (по умолчанию cwd) и учитывает `.gitignore`: это **не полностью идентично** поиску от корня проекта в Snacks и его прежним `hidden = true, ignored = true`.

**Не перенесены; клавиш в активном конфиге для них пока нет:**

| Возможности старого Snacks | Бинды из бэкапа |
| --- | --- |
| Дополнительные вызовы Explorer | `<leader>fe`, `<leader>fE`, `<leader>E` |
| Пикер буферов и удаление буферов | `<leader>,`, `<leader>fb`, `<leader>bd`, `<leader>bo` |
| Только Git-файлы, недавние файлы | `<leader>fg`, `<leader>fr` |
| Поиск в текущем/открытых буферах, lazy-спецификациях | `<leader>sb`, `<leader>sB`, `<leader>sp` |
| Git browse, stash, история, blame, diff, status, LazyGit | `<leader>gB`, `<leader>gS`, `<leader>gf`, `<leader>gl`, `<leader>gb`, `<leader>gd`, `<leader>gs`, `<leader>gg` |
| История команд/поиска, уведомления | `<leader>:`, `<leader>n`, `<leader>s/`, `<leader>sc` |
| Остальные пикеры (команды, диагностика, справка, метки и др.) | `<leader>sC`, `<leader>sD`, `<leader>sH`, `<leader>sM`, `<leader>sa`, `<leader>sd`, `<leader>sh`, `<leader>si`, `<leader>sj`, `<leader>sk`, `<leader>sl`, `<leader>sm`, `<leader>sq`, `<leader>su`, `<leader>s"` |
| Переключатели UI и выбор темы | `<leader>uA`, `<leader>uC`, `<leader>uD`, `<leader>uL`, `<leader>uS`, `<leader>uT`, `<leader>ua`, `<leader>ub`, `<leader>uc`, `<leader>ud`, `<leader>uh`, `<leader>ug`, `<leader>ul`, `<leader>us`, `<leader>uw` |
| Терминал в normal mode | `<C-/>`, `<C-_>` (отдельный терминальный `<C-/>` из `config/keymaps.lua` остался) |
| Scratch-буферы и профайлер | `<leader>.`, `<leader>S`, `<leader>dpp`, `<leader>dph` |

Другие настройки Snacks (`bigfile`, `quickfile`, уведомления, indent, scope, слова, GitLab URL и т. п.) также не перенесены. Бинды остальных плагинов вернутся при переносе самих плагинов, если будет принято решение их сохранить.

## Общий статус конфига

- Базовые `options`, `keymaps`, `autocmds` сохранены; управление плагинами: `<leader>Pu` и `<leader>Pl`.
- Все 10 файлов `ftplugin/*` и `snippets/go.json` восстановлены из бэкапа без изменений. Сниппеты станут доступны через источник автодополнения после его переноса; настройки `lua/langs/*` и `lua/install.lua` всё ещё только в бэкапе.
- Ранее сознательно удалённые Rust, Typst, C++, timers.nvim и лишние темы в этот список не входят: их уже не было в данном снимке.
