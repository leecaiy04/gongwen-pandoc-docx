# Markdown 公文转 Word Skill

本仓库将 Markdown 转为套用 `gongwen-reference.docx` 的 DOCX。模板定义了公文标题、正文和四级标题的字体、字号、缩进、页面及页脚，转换器只将 Markdown 内容映射到这些既有样式。

## 依赖

- Pandoc，且 `pandoc` 位于 `PATH`
- Python 3 或 Node.js；Linux 启动器优先用 Python 3，Windows 启动器优先用 Python 3 Launcher

## 转换

Linux：

```bash
bash scripts/markdown-to-gongwen-docx.sh input.md output.docx
```

Windows：

```bat
scripts\markdown-to-gongwen-docx.cmd input.md output.docx
```

Markdown 映射：`#` 为公文标题，`##` 至 `#####` 依次为一级至四级标题，普通段落为公文正文。标题序号应直接写在 Markdown 中。

## 本地安装

Linux/macOS：

```bash
bash scripts/install.sh --target codex
bash scripts/install.sh --target workbuddy
```

Windows PowerShell：

```powershell
.\scripts\install.ps1 -Target codex
.\scripts\install.ps1 -Target workbuddy
```

将仓库发布到 GitHub 后，先克隆仓库再执行对应的安装命令。WorkBuddy 平台导入包可通过 `bash scripts/package-workbuddy.sh` 生成。

## GitHub 登录

Linux：

```bash
bash scripts/github-login.sh
```

网络较慢时仅对本次登录使用代理，不写入 Git 全局配置：

```bash
bash scripts/github-login.sh --proxy http://222869.xyz:51082
```

Windows PowerShell：

```powershell
.\scripts\github-login.ps1
.\scripts\github-login.ps1 -Proxy http://222869.xyz:51082
```
