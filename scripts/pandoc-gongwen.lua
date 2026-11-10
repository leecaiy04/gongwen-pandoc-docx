-- Use the styles already defined in 公文空白格式模板.docx.
-- Pandoc 2.2 only applies paragraph custom styles through Div blocks.
local heading_styles = {
  [1] = "公文标题（方正小标宋二号）",
  [2] = "一级标题（黑体三号）",
  [3] = "二级标题（楷体三号）",
  [4] = "三级标题（仿宋三号）",
  [5] = "四级标题（仿宋三号）",
}

local body_style = "公文正文（仿宋三号）"

local function styled_paragraph(inlines, style)
  return pandoc.Div(
    {pandoc.Para(inlines)},
    pandoc.Attr("", {}, { ["custom-style"] = style })
  )
end

local function style_blocks(blocks)
  local result = {}
  for _, block in ipairs(blocks) do
    if block.t == "Header" then
      local style = heading_styles[math.min(block.level, 5)] or heading_styles[5]
      table.insert(result, styled_paragraph(block.content, style))
    elseif block.t == "Para" then
      table.insert(result, styled_paragraph(block.content, body_style))
    elseif block.t == "Div" then
      block.content = style_blocks(block.content)
      table.insert(result, block)
    else
      table.insert(result, block)
    end
  end
  return result
end

function Pandoc(doc)
  doc.blocks = style_blocks(doc.blocks)
  return doc
end
