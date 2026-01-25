
#let winered = rgb(190, 20, 83)
#let epubblue = rgb(1, 126, 218)

// 这部分来自于原来的 elegant-note 主题相关设置，不过 hazy 颜色打印的时候会略有麻烦（不是纯黑白）
// 用户自定义选项：[black (黑色主题), hazy (朦胧灰背景), 12pt (字号), founder (方正字体)]
#let ecolor = rgb(0, 0, 0) // 定义主题色为黑色
#let geyecolor = rgb(251, 250, 248) // 定义背景色为一种柔和的护眼灰 (Hazy background)

// 修复公式后段落首行缩进的辅助函数
// 参考 https://github.com/typst/typst/issues/3206#issuecomment-3013274959
#let fix-indent(it) = {
  // 辅助函数：安全地获取 children
  let get-children(elem) = {
    let f = elem.fields()
    if "children" in f {
      f.children
    } else if "child" in f {
      // 被包装的元素，递归获取
      get-children(f.child)
    } else {
      none
    }
  }

  // 辅助函数：解包获取实际元素
  let unwrap(elem) = {
    let f = elem.fields()
    if "child" in f and "styles" in f {
      // 这是一个 styled 包装
      unwrap(f.child)
    } else {
      elem
    }
  }

  let children = get-children(it)
  if children == none { return it }

  let cnt = -1
  let processing = 0

  for child in children {
    cnt += 1
    let actual = unwrap(child)
    let child-func = actual.func()

    if processing >= 2 {
      processing -= 1
      continue
    } else if processing == 1 {
      processing -= 1
      context h(-par.first-line-indent.amount) + child
      continue
    }

    child

    if (
      cnt < children.len() - 2
        and (
          (child-func == math.equation and "block" in actual.fields() and actual.block)
            or child-func == list.item
            or child-func == enum.item
            or child-func == raw
        )
        and {
          let next1-func = unwrap(children.at(cnt + 1)).func()
          let next2-func = unwrap(children.at(cnt + 2)).func()
          next1-func != parbreak and next2-func == text
        }
    ) {
      processing = 2
    }
  }
}

#let conf(
  title: "",
  author: "",
  date: datetime.today().display(),
  body,
) = {
  // 设置文档的基本属性
  set document(author: author, title: title)

  // 页面设置
  set page(
    paper: "a4", // 使用 A4 纸张
    margin: (x: 3cm, y: 3cm), // 设置页边距：左右上下均为 3cm (约等于标准 1 英寸边距)，但是根据clreq 中说的，似乎这样定义边距并不好，可能需要先画出版心然后再计算边距
    // 可见 https://typst-doc-cn.github.io/clreq/#type-area-width
    numbering: "1", // 页码编号格式
    fill: geyecolor, // 设置页面背景填充色 (护眼模式)

    // 页眉设置：仅在第二页及之后显示页眉
    header: context {
      if counter(page).get().first() > 1 {
        // 页眉内容：当前页码，右对齐，灰色字体
        align(right, text(fill: gray)[#counter(page).display("1")])
      }
    },
  )

  // 可以通过在命令行运行 `typst fonts` 查看系统已安装字体的准确名称。Tinymist 插件也可以查看系统中能读取到的字体列表
  //
  // 字体列表说明：
  // Typst 会按顺序查找字体，如果第一个字体不包含某个字符，则尝试第二个，以此类推。
  // 1. "Times New Roman": 用于西文（英文、数字等）。`covers: "latin-in-cjk"` 表示在 CJK 环境下也优先使用该字体显示拉丁字符。
  // 2. "FZSongKeBenXiuKaiJF": 方正宋刻本秀楷，作为主要的中文字体。
  // 3. 后续注释掉的 "SimSun" (宋体) 等作为备选方案，如果未安装方正字体，可取消注释使用。
  set text(
    font: (
      (name: "Times New Roman", covers: "latin-in-cjk"),
      "FZSongKeBenXiuKaiJF",
      // "SimSun",
      // "Noto Serif CJK SC",
    ),
    lang: "zh", // 设置语言环境为中文，影响断行、标点挤压等排版规则
    region: "cn", // 设置地区为中国
    size: 12pt, // 正文字号：12pt (约等于小四号)
    weight: "medium", // 字重：中等
  )

  // 粗体与斜体的字体映射
  // 模拟 LaTeX 中 fontspec 的 BoldFont={SimHei} 行为：
  // 当文本需要加粗 (weight: "bold") 时，强制使用黑体 (SimHei 或 Heiti SC)。
  // 这样做的原因是许多中文字体（如楷体、宋体）直接加粗效果不佳，通常习惯用黑体表示粗体。
  show text.where(weight: "bold"): set text(font: ("Times New Roman", "SimHei", "Heiti SC"))
  show strong: set text(font: ("Times New Roman", "SimHei", "Heiti SC")) // 显式设置 strong 元素的字体，作为双重保障

  // 斜体设置
  // 当文本需要倾斜 (emph) 时，使用楷体 (STKaiti)。
  // 中文排版中通常很少使用真正的“斜体”（几何倾斜），而是用楷体来表示强调。
  show emph: set text(font: "STKaiti")

  // 段落设置
  // LaTeX 中的 \linespread{1.3} 大约对应 1.56 倍行距。
  // 在 Typst 中，leading 控制行间距（基线到基线的额外距离）。
  // 这里设置了首行缩进，但是会强制所有段落都进行首行缩进，需要进行特殊设置才能让行间公式后面的段落不缩进。
  // 两端对齐会带来一些额外问题，暂时不开启。
  set par(
    leading: 0.8em, // 行间距设置为 0.8em
    first-line-indent: (amount: 2em, all: true), // 首行缩进：2个字符宽度
    // justify: true, // 两端对齐，使文本左右边缘整齐
  )


  // 首行缩进修复说明
  // Typst 默认可能在标题后不进行首行缩进。
  // 虽然现代 Typst 版本通常能正确处理 first-line-indent，
  // 但为了确保中文排版的严格性（所有段落都缩进），
  // 我们在后续的 heading show rule 中加入了一个 hack (fake paragraph) 来强制缩进。
  // 此外，设置 `lang: "zh"` 和 `region: "cn"` 也有助于 Typst 正确识别中文段落行为。

  // 标题设置
  // 自定义标题编号格式：1.1, 1.2, ...
  set heading(numbering: (..nums) => {
    numbering("1.1", ..nums) + h(0.6em)
  })

  // 标题样式展示规则 (Show Rule)
  show heading: it => {
    // "ElegantNote" 风格：标题使用黑体 (SimHei) 且加粗
    set text(font: ("Times New Roman", "SimHei", "Heiti SC"), fill: ecolor, weight: "bold")

    if it.level == 1 {
      // 一级标题：对应 LaTeX 的 \Large \bfseries
      // pad 用于增加标题上下的间距
      pad(bottom: 0.5em, top: 1em, text(1.25em, it))
    } else {
      // 次级标题：对应 LaTeX 的 \large \bfseries
      pad(bottom: 0.5em, top: 1em, text(1.05em, it))
    }
  }

  // 列表样式设置
  // 调整列表项的整体缩进，使其与段落缩进保持一致或符合中文习惯
  set list(indent: 2em)
  set enum(indent: 2em, numbering: n => text(fill: ecolor)[#n.])

  // 标题块 (Title Block) 布局
  align(center)[
    // 标题样式：对应 \LARGE \bfseries
    // 在 12pt 基准下，2em 约为 24pt，符合通常的大标题尺寸。
    #block(text(weight: "bold", size: 2em, fill: ecolor, title))
    #v(1em) // 标题与作者之间的垂直间距

    // 作者信息
    #if author != "" {
      block(text(size: 1.2em, author))
    }

    // 日期信息
    #if date != "" {
      v(1em)
      block(text(size: 1.2em, date))
    }
  ]

  // 链接样式设置
  show link: underline
  // 设置链接下划线的偏移量
  set underline(offset: .13em)

  // 设置数学公式在行内时为水平分数
  show math.equation.where(block: false): set math.frac(style: "horizontal")
  // 设置分式中的分式为水平分数
  show math.frac: it => {
    show math.frac: set math.frac(style: "horizontal")
    it
  }
  // 定义非角标引用
  let parencite(key, ..args) = [文献~#cite(key, style: "ieee", ..args)]

  // 设置数学公式编号
  set math.equation(numbering: "(1)")
  show math.equation.where(label: <notag>): set math.equation(numbering: none)

  // 设置长数学公式跨页
  show math.equation: set block(breakable: true)

  // 调整数学公式与旁边文字之间的空白
  show math.equation.where(block: false): it => h(0.25em, weak: true) + it + h(0.25em, weak: true)

  // 调整数学公式后段落的首行缩进
  // 如果段落紧挨行间公式，则插入一个反向缩进，以避免首行缩进
  show: fix-indent


  // 正文内容
  body
}

// 附录环境配置
// 使用时不应包裹整个文档，而是放在正文结束后，通过 show 规则调用：
// show: appendix
#let appendix(body) = {
  set heading(numbering: "A.1", supplement: [Appendix])
  counter(heading).update(0)
  // 在附录中也应用缩进修复
  show: fix-indent
  body
}

// // 定理环境定义
// // 使用 Typst 的 counter 来自动编号定理、定义等
// #let theorem_counter = counter("theorem")

// // 定义“定理”环境
// #let theorem(body, title: "定理") = {
//   theorem_counter.step() // 增加计数器
//   block(width: 100%, breakable: true)[
//     #set text(style: "italic") // 定理内容通常使用斜体（或楷体）
//     #text(fill: ecolor, weight: "bold")[#title #theorem_counter.display()] \
//     #body
//   ]
// }

// // 定义“定义”环境
// #let definition(body, title: "定义") = {
//   theorem_counter.step()
//   block(width: 100%, breakable: true)[
//     // 定义环境标题加粗，内容通常保持正文样式
//     #text(fill: ecolor, weight: "bold")[#title #theorem_counter.display()] \
//     #body
//   ]
// }

// // 定义“引理”环境
// #let lemma(body, title: "引理") = {
//   theorem_counter.step()
//   block(width: 100%, breakable: true)[
//     #set text(style: "italic")
//     #text(fill: ecolor, weight: "bold")[#title #theorem_counter.display()] \
//     #body
//   ]
// }

// // 定义“证明”环境
// // 证明环境不参与编号，结尾添加 QED 符号 (square)
// #let proof(body) = {
//   block(width: 100%, breakable: true)[
//     #text(fill: ecolor, weight: "bold")[证明] \
//     #body
//     #align(right)[$square$] // 右对齐的证毕符号
//   ]
// }
