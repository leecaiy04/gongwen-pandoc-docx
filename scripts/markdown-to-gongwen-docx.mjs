#!/usr/bin/env node
import { spawnSync } from "node:child_process";
import { existsSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const [input, output] = process.argv.slice(2);
if (!input || !output || process.argv.length !== 4) {
  console.error("用法: node markdown-to-gongwen-docx.mjs 输入.md 输出.docx");
  process.exit(64);
}
if (!existsSync(input)) {
  console.error(`输入文件不存在：${input}`);
  process.exit(66);
}

const scriptDir = dirname(fileURLToPath(import.meta.url));
const skillDir = resolve(scriptDir, "..");
const result = spawnSync(process.env.PANDOC || "pandoc", [
  input,
  "--from=markdown",
  "--to=docx",
  `--reference-doc=${resolve(skillDir, "assets", "gongwen-reference.docx")}`,
  `--lua-filter=${resolve(scriptDir, "pandoc-gongwen.lua")}`,
  `--output=${output}`,
], { stdio: "inherit" });

if (result.error?.code === "ENOENT") {
  console.error("未找到 Pandoc。请先安装 Pandoc，并确保 pandoc 在 PATH 中。");
  process.exit(127);
}
process.exit(result.status ?? 1);
