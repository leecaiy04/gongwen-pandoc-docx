---
name: gongwen-pandoc-docx
description: 将中文 Markdown 转为套用指定公文空白模板的 DOCX。用户要求按 # 至 ##### 映射公文标题和四级标题、或要用 Pandoc 保持该模板版式时使用。
---

# Markdown 公文转 Word

使用本 Skill 将 Markdown 转为普通公文版式的 DOCX。版式以 `assets/gongwen-reference.docx` 为唯一基准，不修改该模板的字体、页边距、页脚或样式定义。

## 标题映射

| Markdown | 模板 Word 样式 |
| --- | --- |
| `#` | 公文标题（方正小标宋二号） |
| `##` | 一级标题（黑体三号） |
| `###` | 二级标题（楷体三号） |
| `####` | 三级标题（仿宋三号） |
| `#####` 及更深层级 | 四级标题（仿宋三号） |
| 普通段落 | 公文正文（仿宋三号） |

标题序号由 Markdown 原文提供，例如 `## 一、总体要求`、`### （一）具体措施`。

## 转换

优先运行当前 Skill 中的启动器：

```bash
bash scripts/markdown-to-gongwen-docx.sh input.md output.docx
```

Windows 使用：

```bat
scripts\markdown-to-gongwen-docx.cmd input.md output.docx
```

启动器优先使用 Python 3，找不到 Python 时使用 Node.js。两种实现都需要 Pandoc 在 `PATH` 中。可直接运行 `scripts/markdown-to-gongwen-docx.py` 或 `scripts/markdown-to-gongwen-docx.mjs`。

## 边界

该 Skill 面向不带红头、文号、签发人、印章和版记的普通材料。正式红头发文、套打、附件、版记等场景需要使用具备相应字段处理能力的公文生成流程。

转换后至少检查 DOCX 包完整性：

```bash
unzip -t output.docx
```
