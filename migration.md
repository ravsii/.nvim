# Переход с lazy.nvim на vim.pack

Источник для сверки: `.migration-backup/pre-vim-pack-2026-09-29/`. В нём 55 плагинов, объявленных в старом конфиге (включая `swagger-preview.nvim`, которого не было в `lazy-lock.json`), без самого менеджера `lazy.nvim`.

**Статусы:** ✅ перенесён в активный конфиг; 🔁 заменён частично; ⏳ пока только в бэкапе. Наличие записи в `nvim-pack-lock.json` не означает, что все функции плагина проверены вручную.

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
| `leetcode.nvim` | ⏳ | Старый `picker.provider = "snacks-picker"` больше не подходит без Snacks. |
| `nui.nvim` | ⏳ | Зависимость LeetCode. |
| `plenary.nvim` | ⏳ | Зависимость нескольких ещё не перенесённых плагинов. |

### LSP и форматирование

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `nvim-lspconfig` | ⏳ | — |
| `mason.nvim` | ⏳ | — |
| `mason-lspconfig.nvim` | ⏳ | — |
| `mason-tool-installer.nvim` | ⏳ | — |
| `conform.nvim` | ⏳ | Языковые форматтеры из бэкапа нужно собрать в одном файле Conform. |
| `nvim-lint` | ⏳ | — |
| `lazydev.nvim` | ⏳ | — |
| `SchemaStore.nvim` | ⏳ | В старом конфиге объявлен, но схемы явно не подключались к LSP; проверить необходимость. |
| `luassert-types` | ⏳ | Библиотека для старой настройки lazydev. |
| `busted-types` | ⏳ | Библиотека для старой настройки lazydev. |

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

Итого для старого набора: **7 перенесено, 1 заменён частично, 47 ещё не перенесены**. `lazy.nvim` как менеджер заменён на `vim.pack` и в подсчёт не входит.

## Новые замены

| Плагин | Назначение | Состояние |
| --- | --- | --- |
| [`fff`](https://github.com/dmtrKovalenko/fff) | Поиск файлов и live grep вместо соответствующих пикеров Snacks | Добавлен в `lua/plugins/fff.lua` и native lock-файл. Нативный бинарник `libfff_nvim` присутствует; работу интерактивного пикера вручную ещё нужно проверить. |
| [`fyler.nvim`](https://github.com/FylerOrg/fyler.nvim) | Дерево слева вместо Snacks Explorer / промежуточного netrw | Добавлен в `lua/plugins/fyler.lua` и native lock-файл; `<leader>e` переключает крайний левый сплит шириной 30 колонок. Текущий каталог отображается сверху (`winbar`); Fyler — проводник по умолчанию, изменения требуют подтверждения. Настроек netrw больше нет. |
| [`mini.icons`](https://github.com/nvim-mini/mini.icons) | Иконки файлов и каталогов для Fyler | Подключён в `lua/plugins/icons.lua`; Fyler использует провайдер `mini_icons`. На момент проверки установки не было: GitHub недоступен через прокси. |

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
