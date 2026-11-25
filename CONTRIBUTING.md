# 📦 应用清单新建规则与注意事项

本文档基于 **ScoopBucket-Soup** 仓库现有架构、内置辅助工具、CI 检查流程以及历史维护经验整理而成，旨在规范新增和重构应用清单（Manifest）时的标准做法并规避已知坑点。

---

## 一、项目目录与核心工具

新建应用时请严格遵循仓库既有目录结构：

```text
scoopbucket-soup/
├── bucket/
│   └── <app>.json              # 应用清单主文件
├── scripts/
│   └── <app>/
│       └── uninstall.ps1       # 独立卸载清理脚本（推荐抽离至此）
├── bin/
│   ├── utils.ps1               # 公共安装/持久化/卸载辅助函数库
│   ├── winget.psm1             # WinGet 源清单查询模块
│   ├── sqlite.psm1             # SQLite 查询支持（供 winget.psm1 使用）
│   ├── AppsUtils.psm1          # 外部数据挂载与命令执行辅助模块
│   ├── formatjson.ps1           # 清单 JSON 格式化脚本
│   ├── checkver.ps1             # 版本检测与 autoupdate 测试脚本
│   ├── checkurls.ps1            # 下载链接可用性校验脚本
│   ├── missing-checkver.ps1     # 检查缺失 checkver/autoupdate 的清单
│   ├── sync-readme-app-list.ps1 # 同步 README.md 中的应用列表表格
│   └── test.ps1                 # Pester 自动化测试入口
└── test/
    └── Scoop-Bucket.Tests.ps1  # 引用 Scoop 核心的 Schema 与文件格式校验
```

### `bin/utils.ps1` 常用辅助函数

| 函数名 | 用途说明 | 典型使用阶段 |
| :--- | :--- | :--- |
| `New-PersistDirectory` | 创建 Junction 软链接并可选 `-Migrate` 迁移外部目录数据 | `pre_install` / `installer` |
| `Remove-Junction` | 仅删除 Junction 软链接本身，不删除 `$persist_dir` 目标数据 | `post_uninstall` / `uninstall.ps1` |
| `Remove-AppData` | 统一批量删除本地残余目录、注册表键、注册表值及条件键 | `scripts/<app>/uninstall.ps1` |
| `Stop-App` | 按进程名或 `$dir` 路径结束运行中的进程（支持自动提权重试） | `pre_uninstall` / `installer` |
| `Require-Admin` | 校验并提示以管理员权限运行（涉及 HKLM、服务、ProgramData 时必用） | `installer` / `pre_uninstall` |
| `Set-RegValue` | 提权写入注册表值（仅当值不存在或不一致时执行） | `installer` / `post_install` |
| `Get-RedirectedUrl1st` | 获取 URL 首次 302 重定向的目标地址（不自动跟踪后续跳转） | `checkver.script` |
| `Enable-DevelopmentMode` | 启用 Windows 开发人员模式（MSIX/特殊包场景） | `installer` |

> [!TIP]
> 在同一个 hook（如 `pre_install` 或 `installer.script`）中，只需在开头引入一次 `. "$bucketsdir\$bucket\bin\utils.ps1"` 即可，避免重复引入（参考 `feishu.json` 历史修复 `53b8f40`）。

---

## 二、清单命名与基础字段规范

1. **文件名规范**：放在 `bucket/<app>.json`，全小写字母、数字和连字符 `-` 命名，不带版本号（特殊锁定分支版本除外，如 `navicat170-premium-lite-cn.json`、`dingtalk-global.json`）。
2. **基础字段完整性**：必须包含 `version`、`description`、`homepage`、`license`、`url`（或 `architecture`）、`hash`。
   - `description`：建议简明准确（中文或官方简介），该字段会由 `sync-readme-app-list.ps1` 自动同步至 `README.md` 表格。
   - `license`：商业/闭源软件填写 `"Proprietary"`，或使用 `{ "identifier": "Proprietary", "url": "..." }` 对象形式。
   - `hash`：默认使用 SHA256（小写 64 位十六进制）；若上游仅提供 MD5/SHA1/SHA512，需加前缀（如 `"md5:..."`）。
3. **使用 `notes` 而非 `note`**：
   - Scoop `schema.json` 中仅定义了 `"notes"`（字符串或字符串数组），**新建清单严禁使用已废弃的 `"note"`**。
   - 统一持久化提示文案：`"notes": "User data is persisted in \"$persist_dir\"."`。
   - 若应用**无法持久化数据**（如 `navicat170-premium-lite-cn.json`、`wpsoffice-cn.json`）或需**手动关闭软件内自更新**（如 `fn-sync.json`、`qqnt.json`），必须在 `notes` 中明确告知用户。

---

## 三、安装包解包与服务处理规范 (`pre_install` / `installer` / `post_install`)

### 1. 优先采用绿色解包，避免静默安装污染系统

- **NSIS / Electron / 7z 自解压格式 `.exe`**：
  - 在下载链接末尾添加 `#/dl.7z`（如 `oopz.json`、`douyin.json`、`123pan.json`、`weflow.json`），让 Scoop 自动调用 7-Zip 初步解包。
  - 若核心文件嵌套在 `$PLUGINSDIR\app-64.7z`、`$TEMP\...\app.7z` 或 `app.7z` 中，使用 `Expand-7zipArchive ... -Removal` 二次解压到 `$dir`。
  - 解包后务必清理多余的安装器残留（如 `$dir\`$*`、`uninst*`、`uninstaller`、`resources\app-update.yml` 等），防止软件自带更新器/卸载器干扰 Scoop 管理。
- **Inno Setup 安装包**：
  - 优先直接配置 `"innosetup": true`（如 `quark.json`、`navicat-premium-lite-cn.json`、`iobit-unlocker.json`）。
  - 若内置逻辑不适用，可声明 `"depends": "innounp"` 并在脚本中调用 `Expand-InnoArchive -Path "$dir\$fname" -Removal`（如 `bilibili-livehime.json`）。

### 2. 必须运行静默安装器的特殊场景

对于高度依赖系统驱动或服务（如 `uuyc.json`）而无法直接绿色解包的应用：

1. 安装脚本开头校验管理员权限。
2. **先停止已有进程与后台服务再执行持久化迁移和安装**：防止服务占用 `ProgramData` / `AppData` 下的配置文件句柄导致 `New-PersistDirectory ... -Migrate` 失败。
3. 以静默参数安装到指定目录（如 `/S /D=$dir`）。
4. 清理官方安装器额外生成的桌面/开始菜单快捷方式（`*xxx*.lnk`）、开机自启项（`HKCU\...\Run`）和系统“添加或删除程序”注册表项（`Uninstall`），统一交由 Scoop 的 `shortcuts` 管理。
5. 若软件依赖系统服务运行，安装收尾确保 `Start-Service` 拉起服务。

### 3. Windows 系统服务注册规范（源自 `123pan` 历史经验）

- **禁止仅通过修改注册表注入服务**（系统服务控制管理器 SCM 往往需重启后才能识别）。
- 应使用 PowerShell 原生命令 `New-Service` 正式注册服务，再向注册表补充 `Description` 属性并调用 `Start-Service` 使服务即时生效；在真正卸载时先 `Stop-Service`，再使用 `& sc.exe delete` 正式注销服务（参考 `123pan.json`）。

---

## 四、数据持久化规范 (`persist` 与 `New-PersistDirectory`)

Scoop 升级时会创建新的版本目录（`apps/<app>/<new_version>`），未做持久化的数据将在切换版本或清理旧版时失效。

1. **安装目录内部数据**：使用 Scoop 原生 `"persist"` 字段（如 `oopz.json` 的 `"persist": "sandbox"`、`todesk.json` 的 `["Logs", "config.ini"]`）。
2. **外部固定路径数据（`%APPDATA%`、`%LOCALAPPDATA%`、`%ProgramData%` 等）**：
   - 在 `pre_install` 或 `installer.script` 中使用：
     ```powershell
     Write-Host ("`nPersisting $env:APPDATA\<AppDir> ... ") -NoNewline
     New-PersistDirectory "$env:APPDATA\<AppDir>" "$persist_dir\AppData" -Migrate
     ```
   - **完整排查隐蔽存储位置（源自 `uuyc` 历史教训）**：部分软件（尤其是远程桌面、同步工具、带后台服务客户端）不仅在 `%APPDATA%` / `%LOCALAPPDATA%` 存界面配置，还会把**机器 UUID、设备 ID、登录 Token** 写入 `C:\ProgramData\...`（如 `uuyc` 的 `C:\ProgramData\Netease\GameViewer`）。新建清单前务必抓包或监控文件写入，确认所有关键数据目录均已持久化，否则每次更新都会丢失登录态或被服务端判定为“新电脑”。
   - **兼容与权限验证（源自 `123pan` 历史教训）**：部分软件对 NTFS Junction 目录或系统提权目录有特殊校验，甚至可能导致登录权限异常；新增持久化后必须实测登录、重启及更新流程，确认无异常。

---

## 五、卸载与更新隔离规范（重中之重）

### 1. 核心机制：`scoop update` 会触发旧版本卸载钩子！

在 Scoop 源码（`scoop-update.ps1`）中，更新应用采用 **“先卸载旧版本，再安装新版本”** 的机制，执行顺序为：

1. 下载并校验新版压缩包/安装程序；
2. 对旧版本依次执行：**`pre_uninstall`** $\rightarrow$ **`uninstaller`** $\rightarrow$ **`post_uninstall`**（并移除旧版 Shim、快捷方式及 `current` 联接）；
3. 对新版本执行：`install_app`（`pre_install` $\rightarrow$ `installer` $\rightarrow$ `post_install`）。

### 2. 强制规避事项

- **严禁在常规软件中使用 `"uninstaller"` 调用官方原厂卸载程序**：
  - 诸如 `Uninstall.exe /S`、`unins*.exe /S` 等原厂卸载器在 `scoop update` 期间同样会被调用，可能导致每次更新都执行全量卸载、向服务器注销当前设备并抹除登录凭据（参考 `uuyc` 修复提交 `efd5a94`）。
- **将深度清理逻辑独立至 `scripts/<app>/uninstall.ps1`**：
  - 清单内保持精简统一的调用入口（`pre_uninstall` 负责提权与停进程，`post_uninstall` 引入脚本）：
    ```json
    "pre_uninstall": [
        "$bucket = $install.bucket",
        ". \"$bucketsdir\\$bucket\\bin\\utils.ps1\"",
        "Require-Admin",
        "Stop-App"
    ],
    "post_uninstall": [
        "$bucket = $install.bucket",
        ". \"$bucketsdir\\$bucket\\bin\\utils.ps1\"",
        ". \"$bucketsdir\\$bucket\\scripts\\<app>\\uninstall.ps1\""
    ]
    ```
  - 说明：若不涉及 HKLM 注册表、系统服务或管理员进程，`pre_uninstall` 可省略 `Require-Admin`（如 `piliplus.json`、`utools.json`）。
- **在 `uninstall.ps1` 中隔离 `update` 与 `uninstall` 阶段**：
  - 如果卸载脚本涉及删除系统服务（`sc.exe delete`）、删除关键注册表凭据、或清理非 `$persist_dir` 的外部状态目录（如 `ProgramData`），**必须在 `scripts/<app>/uninstall.ps1` 开头拦截更新操作**（参考 `scripts/uuyc/uninstall.ps1`）：
    ```powershell
    if ($cmd -eq 'update' -or ((Get-PSCallStack | Select-Object -ExpandProperty ScriptName) -match 'scoop-update\.ps1')) {
        return
    }
    ```
  - 同样，`pre_uninstall` 中只做 `Stop-App` 与 `Stop-Service`（释放文件锁），**不要在 `pre_uninstall` 中执行 `sc.exe delete` 删除服务**。
- **严禁对 Junction 目录直接执行 `Remove-Item -Force -Recurse`**：
  - 使用 `New-PersistDirectory` 映射的目录本质是 Junction 软链接。直接把该路径放入 `Remove-AppData -LocalPaths` 在部分 PowerShell 版本下可能穿透软链接误删 `$persist_dir` 中的持久化数据！
  - **正确做法**：在删除缓存目录之前，先调用 `Remove-Junction "<挂载路径>" -ErrorAction SilentlyContinue | Out-Null` 安全解除软链接（参考 `scripts/quark/uninstall.ps1`、`scripts/uuyc/uninstall.ps1`）。

### 3. `scripts/<app>/uninstall.ps1` 残留清理覆盖范围

结合 Total Uninstall 等安装监控脚本及现有应用实践，卸载清理应尽量覆盖：

- **本地残留目录（`$localPaths`）**：`%APPDATA%`、`%LOCALAPPDATA%`、`%ProgramData%`、`systemprofile\AppData\Local` 下的非持久化缓存与更新器目录。
- **注册表键（`$registryPaths`）**：
  - 软件自身键：`HKCU`/`HKU\$userSID\SOFTWARE\<Vendor>`、`HKLM\SOFTWARE\<Vendor>`（含 `Wow6432Node`）
  - 卸载与路径键：`...\CurrentVersion\Uninstall\<App>`、`...\App Paths\<App>.exe`
  - URL 协议与文件关联：`...\SOFTWARE\Classes\<Protocol>`
  - 系统诊断与音频策略残留：`HKLM\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications\<exe>`、`$userSID\...\LowRegistry\Audio\PolicyConfig\PropertyStore`（推荐动态匹配，参考 `scripts/oopz/uninstall.ps1`、`scripts/neteasemusic/uninstall.ps1`）
- **注册表值（`$registryValues`）**：
  - 开机自启：`...\CurrentVersion\Run|<Name>`
  - 兼容性助手记录：`...\AppCompatFlags\Compatibility Assistant\Store|<exe路径>`（建议同时覆盖 `$dir` 与 `current` 路径）
  - `UserAssist` 执行记录（ROT13 编码路径，可参考 `scripts/todesk/uninstall.ps1`、`scripts/oopz/uninstall.ps1` 动态生成）
- **防火墙与计划任务**：使用 `Get-NetFirewallRule` / `FirewallRules` 与 `Get-ScheduledTask` 清理相关规则与定时任务（参考 `scripts/fn-sync/uninstall.ps1`、`scripts/uuyc/uninstall.ps1`）。

---

## 六、版本检测与自动更新 (`checkver` & `autoupdate`)

CI 仓库每 12 小时通过 `schedule.yml` 自动运行 Excavator 巡检更新，因此新清单应尽可能提供可用的 `checkver` 与 `autoupdate`（可用 `.\bin\missing-checkver.ps1` 查看缺口）。

常见写法参考：

| 上游来源类型 | 推荐实现方式 | 仓库参考清单 |
| :--- | :--- | :--- |
| GitHub Releases | `"checkver": "github"` 或 API `jsonpath` + `regex` | `weflow.json`、`piliplus.json` |
| 官方 JSON API / 页面 | `url` + `jsonpath` 或 `regex` | `feishu.json`、`bilibili-livehime.json`、`douyin.json` |
| 302 重定向固定入口 | `checkver.script` 调用 `Get-RedirectedUrl1st` 或 `HttpWebRequest` | `oopz.json`、`uuyc.json`、`dingtalk-global.json` |
| WinGet 软件源 | `Import-Module "$pwd\bin\WinGet.psm1"` + `Get-WinGetManifest` | `123pan.json` |
| 需动态签名的下载链接 | `checkver.script` 请求签名接口并用命名捕获组（如 `(?<query>...)`）传递参数 | `fn-sync.json` |
| 官方 CDN 缓存异常 | `Resolve-DnsName` 解析真实 IP 后带 `Host` 头请求 | `qqnt.json` |

> [!NOTE]
> `autoupdate` 默认由 Scoop 自动下载文件计算 SHA256，一般无需手写 `"hash"`；仅当上游不提供校验接口但需要显式声明，或需要自定义匹配官方提供的 MD5/JSON 校验字段时，配置 `"hash": { "mode": "download" }` 或 `"mode": "json"`。

---

## 七、编码、格式规范与提交前必检清单

仓库 CI（`ci.yml` 与 `sync_readme_apps.yml`）以及 `.editorconfig` / `.gitattributes` 对仓库内**所有非二进制文本文件**有严格要求（`test/Scoop-Bucket.Tests.ps1` 会递归扫描全部文件）：

### 1. 文件格式铁律

- **字符编码**：必须为 **UTF-8（无 BOM）**。
  - **注意**：在 Windows PowerShell 5.1 中使用 `Set-Content -Encoding UTF8` 会默认写入 UTF-8 BOM 导致测试失败！运行或编辑脚本请使用 **PowerShell 7+ (`pwsh`)** 或确认编辑器以无 BOM 格式保存。
- **换行符**：除 `.yml` / `.yaml` 外，所有文本文件（`.json`、`.ps1`、`.md` 等）**必须使用 CRLF (`\r\n`)**。
- **末尾换行**：文件末尾**必须保留一个换行符**。
- **空白字符**：**严禁任何行尾空格**（包括 Markdown 中的双空格换行）；缩进仅限空格（一般为 4 空格，YAML 为 2 空格），**严禁 TAB 缩进**。
- **PowerShell 语法**：所有 `.ps1` / `.psm1` 文件必须无语法错误。

### 2. 提交前本地验证步骤

在提交或发起 PR 前，请按顺序在仓库根目录执行以下检查（推荐在 `pwsh` 下运行）：

1. **格式化清单**（注意参数传应用名，**不带 `.json` 后缀**）：
   ```powershell
   .\bin\formatjson.ps1 <app>
   ```
2. **验证版本检查与自动更新**：
   ```powershell
   .\bin\checkver.ps1 -dir .\bucket <app>
   # 若需测试 autoupdate 链接与哈希生成逻辑：
   .\bin\checkver.ps1 -dir .\bucket <app> -ForceUpdate
   ```
3. **验证下载链接有效性**：
   ```powershell
   .\bin\checkurls.ps1 <app>
   ```
4. **同步更新 `README.md` 应用列表**（PR CI `sync_readme_apps.yml` 在新增或删除清单时会强制检查 `README.md` 是否已同步，且该步之后注意检查末尾是否被脚本多加空行或尾部空格）：
   ```powershell
   .\bin\sync-readme-app-list.ps1
   ```
5. **运行仓库自动化测试套件**（必须全部 Passed，0 Failed）：
   ```powershell
   .\bin\test.ps1
   ```
6. **本地实测完整生命周期**（强烈建议）：
   - `scoop install .\bucket\<app>.json`：验证安装/解包、快捷方式、服务注册及数据持久化（检查 `$persist_dir` 与 Junction 是否生效）。
   - `scoop update <app>`（或使用 `-f` 强制重装模拟升级）：**重点验证更新后登录状态、配置、设备标识是否保留，无重登或数据丢失**。
   - `scoop uninstall <app>`：验证进程结束、Junction 解除、服务注销及缓存/注册表残余清理效果。
