# Переход с lazy.nvim на vim.pack

Источник для сверки: `.migration-backup/pre-vim-pack-2026-09-29/`. В нём 55 плагинов, объявленных в старом конфиге, без самого менеджера `lazy.nvim`.

**Статусы:** ✅ перенесён в активный конфиг (не обязательно уже установлен локально); 🔁 заменён частично; ⏳ ожидает переноса; 🚫 исключён из планов переноса (остаётся в бэкапе). Наличие записи в `nvim-pack-lock.json` не означает, что все функции плагина проверены вручную.

**Правило дальнейшей миграции:** ассистент только добавляет `vim.pack.add` в Lua-файлы, подключает их в `init.lua` и переносит настройки/бинды. **Сам не запускает установку плагинов** (включая запуск Neovim с активным конфигом, который вызовет `vim.pack.add`), не скачивает их вручную и не обновляет lock-файл ради установки. Установку и проверку работы установленных плагинов выполняет пользователь. Допустимы проверки синтаксиса и тесты с заглушкой `vim.pack.add`, которые не обращаются к сети.
Бинды записывать напрямую через `vim.keymap.set(...)`, опции — через `vim.opt`, без локальных псевдонимов `map` и `opt`.

Спецификации `vim.pack.add` теперь содержат только URL, без `src`, `name`, `version`, `confirm` и `load`. При новой установке Neovim по умолчанию запросит подтверждение. Без `name` репозиторий `rose-pine/neovim` будет регистрироваться под именем `neovim`, а не прежним `rose-pine`; существующий lock-файл вручную не менялся. Удаление `version` для Treesitter означает, что при будущем обновлении будет использоваться обычная ревизия по умолчанию, а не ранее указанная версия.
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
| `snacks.nvim` | ✅ | `lua/plugins/snacks.lua`: Picker снова включён с прежними `hidden`, `ignored`, `supports_live`; поиск файлов, grep и LSP-пикеры доступны через бинды. Секция explorer удалена, Fyler остаётся проводником. `<leader>sp` по-прежнему вызывает пикер lazy.nvim, которого больше нет. |
| `which-key.nvim` | ✅ | `lua/plugins/which-key.lua`: прежний preset `helix`, группы, `<leader>?` и `<C-w><Space>`. |
| `bufferline.nvim` | ✅ | `lua/plugins/bufferline.lua`: прежние оформление, диагностика и семь биндов; иконки через `mini.icons`, отступ для Fyler вместо neo-tree. `<S-h>`/`<S-l>` теперь переключают буферы в порядке Bufferline. |
| `lualine.nvim` | ✅ | `lua/plugins/lualine.lua`: старые секции, тема Rose Pine, исключения по filetype и скроллбар из бэкапа. |
| `lualine-pretty-path` | ✅ | Подключён вместе с Lualine; иконки предоставляет существующий `mini.icons` через `mock_nvim_web_devicons()`. |
| `nvim-web-devicons` | 🚫 | Не переносим: Fyler, Bufferline и Lualine используют `mini.icons`. |
| `tiny-inline-diagnostic.nvim` | ✅ | `lua/plugins/lsp.lua`: прежний preset `modern` и параметры из бэкапа; встроенные `virtual_text` и `virtual_lines` отключены, чтобы не дублировать сообщения. |
| `marks.nvim` | ✅ | `lua/plugins/marks.lua`: настройки по умолчанию и прежняя подсветка `MarkSignHL`. |

### Редактирование

| Плагин | Статус |
| --- | --- |
| `blink.cmp` | ✅ | `lua/plugins/blink.lua`: старые бинды (`enter` и `<C-y>`), источники LSP/путей/сниппетов/буфера и иконки типов дополнения из бэкапа. Lua fuzzy без сборки Rust. |
| `friendly-snippets` | ✅ | Подключён рядом с Blink; источник сниппетов также читает восстановленный `snippets/go.json`. |
| `mini.ai` | ✅ | `lua/plugins/mini.lua`: текстовые объекты из бэкапа и подсказки which-key. |
| `mini.align` | ✅ | `lua/plugins/mini.lua`: стандартная настройка. |
| `mini.pairs` | ✅ | `lua/plugins/mini.lua`: пары в insert и command mode. Старые `skip_next`, `skip_ts`, `skip_unbalanced`, `markdown` не поддерживаются текущим API `mini.pairs` и не перенесены как неработающие настройки. |
| `mini.surround` | ✅ | `lua/plugins/mini.lua`: старые префиксы `gsa`/`gsd`/`gsf`/`gsF`/`gsh`/`gsr`, подсказки which-key; `gsn` вызывает `update_n_lines()` отдельным биндом. |
| `nvim-colorizer.lua` | 🚫 | Пользователь решил не переносить: подсветка литералов цвета не нужна. |
| `ts-comments.nvim` | ✅ | `lua/plugins/comments.lua`: настройка по умолчанию для комментариев с учётом Treesitter. |
| `yanky.nvim` | ✅ | `lua/plugins/yanki.lua`: история копирования, подсветка на 150 мс и прежние бинды. |
| `inc-rename.nvim` | ✅ | `lua/plugins/lsp.lua`: `<leader>cr` запускает инкрементальное переименование с предпросмотром пустого имени. |
| `dotenv.nvim` | 🚫 | Пользователь решил не переносить. |

### Поиск, Git и утилиты

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `grug-far.nvim` | ✅ | `lua/plugins/grug-far.lua`: интерактивный поиск и замена через `<leader>sr` с фильтром по расширению текущего файла. |
| `gitsigns.nvim` | ✅ | `lua/plugins/git.lua`: знаки изменений слева относительно `git merge-base HEAD master` для каждого репозитория; без `master` остаётся стандартное сравнение с индексом. База вычисляется при подключении буфера: после переключения ветки переоткрыть файл. Новый плагин, не из старого набора. |
| `git-conflict.nvim` | ⏳ | — |
| `todo-comments.nvim` | ✅ | `lua/plugins/comments.lua`: настройка по умолчанию и старый `<leader>st` через Snacks Picker. |
| `leetcode.nvim` | 🚫 | Решено не переносить, даже после возвращения Snacks Picker. |
| `nui.nvim` | 🚫 | Зависимость исключённого `leetcode.nvim`; отдельно не нужен. |
| `plenary.nvim` | ✅ | Подключён в `lua/plugins/comments.lua` перед `todo-comments.nvim`; также понадобится при переносе Neotest. |

### LSP и форматирование

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `nvim-lspconfig` | ✅ | Подключён в `lua/plugins/lsp.lua`; прежние LSP-бинды с Snacks Picker восстановлены, знаки диагностики взяты из бэкапа. Настройки отдельных языков пока не перенесены. |
| `mason.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; `<leader>cm` открывает Mason. |
| `mason-lspconfig.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; автоматически включает установленные через Mason LSP-серверы. |
| `mason-tool-installer.nvim` | ✅ | Подключён и настроен в `lua/plugins/lsp.lua`; пока запрашивает только `lua_ls`. |
| `conform.nvim` | ✅ | `lua/plugins/formatting.lua`: форматтеры из бэкапа, бинды и форматирование перед сохранением. Исполняемые файлы форматтеров нужно установить отдельно. |
| `nvim-lint` | 🚫 | Решено не переносить. |
| `lazydev.nvim` | ✅ | `lua/plugins/lsp.lua`: поддержка `vim.uv` и библиотека `snacks.nvim` для глобального `Snacks` в LuaLS; без старых зависимостей busted/luassert. |
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

### Отладка / DAP

| Плагин | Статус |
| --- | --- |
| `nvim-dap` | ⏳ |
| `nvim-dap-view` | ⏳ |
| `nvim-dap-envfile` | ⏳ |
| `nvim-dap-go` | ⏳ |
| `mason-nvim-dap.nvim` | ⏳ |
| `one-small-step-for-vimkind` | ⏳ |

### Тесты и покрытие

| Плагин | Статус |
| --- | --- |
| `neotest` | ⏳ |
| `nvim-nio` | ⏳ |
| `neotest-golang` | ⏳ |
| `neotest-plenary` | ⏳ |
| `nvim-coverage` | ⏳ |

Neotest использует DAP только для отдельного действия «Debug Nearest» (`<leader>td`); обычный запуск тестов не следует смешивать с миграцией отладчика.

### Превью

| Плагин | Статус | Примечание |
| --- | --- | --- |
| `markdown-preview.nvim` | ✅ | `lua/plugins/preview.lua`: `<leader>cp` для Markdown, `FileType` для команд в текущем буфере; установщик плагина вызывается через `PackChanged` при установке/обновлении пользователем. |
| `swagger-preview.nvim` | ✅ | `lua/plugins/preview.lua`: `<leader>cp` для JSON, прежние host `127.0.0.1` и port `6969`; `npm install` вызывается через `PackChanged` при установке/обновлении пользователем. Требуется npm. |

Итого для старого набора: **35 перенесено, 12 ожидают переноса, 8 исключены**. `lazy.nvim` как менеджер заменён на `vim.pack` и в подсчёт не входит.

SchemaStore, LSP/Mason и `which-key.nvim` присутствуют в `nvim-pack-lock.json`, но работу LSP, установку `lua_ls` и интерфейс which-key нужно проверить вручную.
Прежние бинды LSP из `lua/core/lsp.lua` восстановлены в `lua/plugins/lsp.lua`: `gd`, `gI`, `gr`, `gy`, `<leader>cl`, `<leader>ss`, `<leader>sS` снова вызывают Snacks Picker с превью. `gD`, `gK` и другие действия остаются встроенными LSP-вызовами. Старое удаление встроенных `grn`, `gra`, `gri`, `grr` не возвращали; для `gr` восстановлен `nowait = true`, что может помешать этим сочетаниям. SchemaStore и языковые настройки LSP остаются в `lsp.lua`; для дополнения вместо встроенного LSP-автотриггера подключён Blink в `lua/plugins/blink.lua` (до `lsp.lua` в `init.lua`). Встроенное автоматическое дополнение слов отключено, чтобы меню не конкурировали.

## Новые замены

| Плагин | Назначение | Состояние |
| --- | --- | --- |
| [`fyler.nvim`](https://github.com/FylerOrg/fyler.nvim) | Дерево слева | Добавлен в `lua/plugins/fyler.lua` и native lock-файл; `<leader>e` переключает крайний левый сплит шириной 30 колонок. Текущий каталог отображается сверху (`winbar`); имена dotfiles при показе через `g.` подсвечиваются приглушённым цветом `Comment`. Fyler настроен как проводник по умолчанию. |
| [`mini.icons`](https://github.com/nvim-mini/mini.icons) | Иконки файлов и каталогов для Fyler, Bufferline и Lualine | Перенесён из `lua/plugins/icons.lua` в `lua/plugins/mini.lua`; Fyler использует провайдер `mini_icons`, Lualine — `mock_nvim_web_devicons()`. |
| [`blink.lib`](https://github.com/saghen/blink.lib) | Зависимость Blink из текущей ветки | Подключён в `lua/plugins/blink.lua`; старый Blink v1 обходился без этого плагина. |

## Очерёдность оставшегося переноса

Приоритет ориентировочный: сначала базовые возможности редактора, затем удобства и специализированные инструменты. Внутри группы можно переносить плагины по одному или небольшими связками; настройки каждого плагина держать рядом с его подключением. Ниже перечислены **12** плагинов со статусом ⏳ ровно по одному разу. Настройки отдельных языковых LSP-серверов ещё предстоит вернуть из бэкапа без старого механизма слияния `opts`; каталог SchemaStore пока не подключён к JSON/YAML LSP.

1. **Интерфейс и Git (1):** `git-conflict.nvim`.
2. **Отладка / DAP (6):** `nvim-dap`, `nvim-dap-view`, `nvim-dap-envfile`, `nvim-dap-go`, `mason-nvim-dap.nvim`, `one-small-step-for-vimkind`.
3. **Тесты и покрытие (5):** `nvim-nio`, `neotest`, `neotest-golang`, `neotest-plenary`, `nvim-coverage`. Зависимости устанавливать перед надстройками; отладка теста через `<leader>td` потребует DAP.
Превью (`markdown-preview.nvim`, `swagger-preview.nvim`) уже подключены; для них предусмотрены отдельные build-шаги.

**Исключены из переноса (8):** `luassert-types`, `busted-types`, `leetcode.nvim`, `nui.nvim`, `nvim-lint`, `nvim-colorizer.lua`, `dotenv.nvim`, `nvim-web-devicons`. Их конфигурация остаётся только в бэкапе; устанавливать их не планируем.

**Отдельно:** FFF убран из активного конфига: `lua/plugins/fff.lua` удалён, подключение из `init.lua` убрано. Его файлы и запись в `nvim-pack-lock.json` не удалялись вручную; очистку установленного пакета выполнить отдельно по решению пользователя. Поиск файлов и grep теперь выполняет Snacks Picker; Fyler остаётся проводником.

## TODO: языковые инструменты и LSP

Сверить `.migration-backup/pre-vim-pack-2026-09-29/lua/langs/` и `lua/install.lua` с активными `lua/plugins/lsp.lua`, `lua/plugins/formatting.lua` и `lua/plugins/treesitter.lua`. Сейчас `mason-tool-installer` запрашивает только `lua_ls`; переносить языковые настройки напрямую, **без прежнего слияния `opts`**.

- [ ] Перенести список используемых Mason LSP-серверов: `gopls`, `golangci_lint_ls`, `lua_ls`, `jsonls` (пакет Mason `json-lsp`), `yamlls`, `marksman`, `slint_lsp` (пакет `slint-lsp`), `buf_ls`; сверить имена серверов с актуальным `mason-lspconfig`.
- [ ] Перенести в `mason-tool-installer` остальные инструменты из языковых файлов: Go (`gofumpt`, `delve`, `goimports`, `golangci-lint`, `impl`, `gci`), Lua (`stylua`), shell (`shfmt`), Markdown (`markdownlint-cli2`, `markdown-toc`). Не возвращать исключённый `nvim-lint` автоматически.
- [ ] Вернуть настройки серверов `gopls` и `lua_ls` из старых `langs/go.lua` и `langs/lua.lua`; проверить автоактивацию через Mason и поведение `lua_ls` вместе с `lazydev.nvim`.
- [ ] Подключить схемы SchemaStore к JSON/YAML LSP (`jsonls`, `yamlls`) и проверить диагностику на этих файлах.
- [ ] Сверить оставшиеся языковые парсеры Treesitter и форматтеры с активным конфигом; затем проверить работу серверов и внешних инструментов в Neovim. Закомментированный Python-конфиг не включать без отдельного решения.

## Бинды прежнего Snacks

После удаления FFF бинды `<leader><space>` и `<leader>fc` вызывают поиск файлов Snacks; `<leader>/`, `<leader>sw` и `<leader>sR` используют его grep и продолжение поиска. Для `<leader>sw` сохранён visual mode из удалённого FFF. `<leader>e` остаётся у Fyler. `<leader>sp` всё ещё вызывает `Snacks.picker.lazy()` и может не работать без lazy.nvim. Picker включён с настройками `hidden = true`, `ignored = true`, `supports_live = true`, как в бэкапе; секция explorer не возвращалась.

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
| Fyler и Snacks | `<leader>e` вызывает Fyler; поиск файлов и grep — Snacks Picker. FFF больше не загружается. |
| LSP | Перенесены `K`, `gd`, `gD`, `gI`, `gK`, `gr`, `gy`, `<C-k>` (insert), `<leader>cC`, `<leader>ca`, `<leader>cc`, `<leader>cl`, `<leader>cr`, `<leader>ss`, `<leader>sS`. Прежние Snacks LSP-пикеры снова открывают списки и превью; `gr` с `nowait` может мешать встроенным `grn`, `gra`, `gri`, `grr`. |
| Общие бинды | Из `lua/config/keymaps.lua` не вернулся `<leader>ur` (очистка поиска, `diffupdate`, перерисовка). Старый `<leader>l` для lazy.nvim намеренно не возвращён; управление `vim.pack` осталось на `<leader>Pu` и `<leader>Pl`. |

Отдельно от биндов: настройки языковых LSP-серверов, интеграция SchemaStore с JSON/YAML и источник сниппетов для автодополнения ещё не перенесены.

## Общий статус конфига

- Базовые `options`, `keymaps`, `autocmds` сохранены; управление плагинами: `<leader>Pu` и `<leader>Pl`.
- Все 10 файлов `ftplugin/*` и `snippets/go.json` восстановлены из бэкапа без изменений. Сниппеты станут доступны через источник автодополнения после его переноса; настройки `lua/langs/*` и `lua/install.lua` всё ещё только в бэкапе.
- Ранее сознательно удалённые Rust, Typst, C++, timers.nvim и лишние темы в этот список не входят: их уже не было в данном снимке.
