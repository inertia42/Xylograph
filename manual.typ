#import "lib.typ": conf
#import "@preview/physica:0.9.8": *
#import "@preview/cheq:0.3.0": checklist
#import "@preview/codly:1.3.0": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/metalogo:1.2.0": LaTeX

#show: el.default-enum-list
#show: checklist
#show: codly-init.with()
#codly(display-name: false)


#show: conf.with(
  title: "Typst 使用记录",
  author: "Inertia",
  date: datetime.today().display(),
)

#outline()
#pagebreak()
感觉Typst中存在许多比较重要的排版问题没有解决，需要手动引入一些技巧来处理，本手册主要用于记录这些解决方案。

- [ ] 字体设置
- [ ] 参考文献修改 csl 以实现自定义
- [ ] 脚注、边注等各类注释
- [ ] 附录等部分的实现


= 使用相关
== 代码片段高亮
使用`codly`包来实现代码片段高亮，其他用法基本和Markdown一致。不过Typst代码对应的名称分为`typ`、`typc`（Typst Code）以及`typm`（Typst Math）。使用大致如下
```typc
#import "@preview/codly:1.3.0": *
#show: codly-init.with()
#codly(display-name: false) // 可选，用于关闭代码块右上角显示的语言名称
```
具体使用文档可见#link("https://typst.app/universe/package/codly")[codly文档]，此外其还有一个扩展包#link("https://typst.app/universe/package/codly-languages")[codly-languages]。

== 链接和下划线
插入链接和Markdown语法略有区别，格式是`#link("url")[title]`，此外可以下面的命令给链接加上下划线
```typc
#show link: underline
```
但是Typst中下划线的实现略有问题，中英文的下划线会错位，可见#link("https://typst-doc-cn.github.io/guide/FAQ/underline-misplace.html")[FAQ: 中英文下划线错位了怎么办？]，这一问题在我的模板中可以使用下面的命令解决
```typc
#set underline(offset: .13em)
```

== 脚注等
可以使用`#footnote[contents]`命令插入脚注。

== 文档结构相关
=== 插入目录
使用`#outline()`命令可以插入目录。

=== 插入动图
使用 Typst 的 VSCode 插件时，可以通过 Tinymist 的预览功能播放动图，只需要正常插入动图即可。但是导出的 PDF 不支持播放动图。
```typc
#image("sine_wave.gif")
```
效果如下
#image("resources/sine_wave.gif")

== 数学公式相关
=== 长公式跨页打断
使用如下命令可以实现长公式跨页打断
```typc
#show math.equation: set block(breakable: true).
```
=== 多行公式的多点对齐
Typst 这一点比 #LaTeX 方便一些，一行中可以使用`&`、`&&`等标记依次定义对齐点，而且括号会自动缩放，效果如下
$
  delta g_(s i, +) &= frac(i Lambda_0^s, 2 omega_s) frac(e, T_i) F_(M i) { &&J_0 J_+ delta phi_0^* delta phi_+ (1 - omega_(* i) / omega)_0 (1 + omega_(d i) / omega)_0 \
    & quad quad &&- J_0 J_+ delta phi_0^* delta phi_+ (1 - omega_(* i) / omega)_+ \
    & quad quad &&+ frac(i Lambda_0^s, 2 omega_+) J_0^2 J_s |delta phi_0|^2 delta phi_s [N_0^s + N_1 (frac(v_perp^2, 4 v_(t i)^2) + frac(v_parallel^2, 2 v_(t i)^2))] } \
  &= frac(i Lambda_0^s, 2 omega_s) frac(e, T_i) F_(M i) {&&J_0 J_+ delta phi_0^* delta phi_+ [N_0^+ + N_1 (...)] \
    & quad quad &&+ frac(i Lambda_0^s, 2 omega_+) J_0^2 J_s |delta phi_0|^2 delta phi_s [N_0^s + N_1 (...)] }.
$<notag>
== 其他
=== 在 Typst 中插入 #LaTeX logo
使用`metalogo`包可以插入 #LaTeX logo，使用方法如下
```typc
#import "@preview/metalogo:1.2.0": TeX, LaTeX
```
= 排版相关
== 数学公式相关
=== 分数的风格设置
Typst 和 #LaTeX 不同，在其中无需显式使用类似于 `\frac{}{}`的命令，而是可以直接使用`/`来表示分数，Typst会自动转换，例如对于行间公式` a/b`，在 Typst 下效果为
$ a/b $
但是默认情况下，`frac`的显示风格是`style: vertical`，即行内公式中也会强行显示竖排，故而可以用如下命令使其在行内公式中使用水平风格
```typc
#show math.equation.where(block: false): set math.frac(style: "horizontal")
```
这个解决方案来自于#link("https://typst.app/docs/reference/math/frac/")[Typst官方文档]。

此外，还有一个问题是如何让分式分子或分母中的分式也自动使用水平风格，可以使用如下命令
```typc
#show math.frac: it => {
  show math.frac: set math.frac(style: "horizontal")
  it
}
```

=== 行间公式编号设置
一般使用如下命令来让给每个行间公式编号
```typc
#set math.equation(numbering: "(1)")
```
但是这会给所有公式无差别地编上号，如果只想给部分公式编号，可以使用
```typc
#show math.equation.where(label: <notag>): set math.equation(numbering: none)
```
这样只需要给不编号的公式后添加`<notag>`标签即可，例如
$ grad p= vb(J) cprod vb(B). $<notag>

== 文本排版相关
=== 盘古之白问题
Typst大致支持盘古之白，但是`raw`元素以及行内公式两边不会自动插入，目前可以通过如下命令解决
```typc
show math.equation.where(block: false): it => h(0.25em, weak: true) + it + h(0.25em, weak: true)
```

=== 文本对齐问题
Typst 的中文文本对齐实现不佳，可见#link("https://typst-doc-cn.github.io/clreq/#justification")[clreq gap for typst：文本对齐]。部分问题可以通过使用两端对齐来解决，但是这会带来新的问题，且不符合中文排版习惯，需要持续关注相关改进。

=== 列表编号错位问题
可参见#link("https://typst-doc-cn.github.io/guide/FAQ/enum-list-marker-fix.html")[FAQ：列表符号/编号和内容错位怎么办？]。这里采用`itemize`包解决问题，使用命令如下
```typc
#import "@preview/itemize:0.2.0" as el
#show: el.default-enum-list
```

=== 首行缩进问题
Typst v0.13 改进了之前的首行缩进问题，现在可以用如下命令
```typc
#set par(first-line-indent: (amount: 2em, all: true))
```
来设置首行缩进，但是这带来了新的问题，即公式、图表等块元素的下一行会自动缩进，可见#link("https://typst-doc-cn.github.io/guide/FAQ/block-equation-in-paragraph.html")[FAQ：如何避免公式、图表等块元素的下一行缩进？]，但是其中给出的解决方案不好用，因此从相关#link("https://github.com/typst/typst/issues/3206#issuecomment-3013274959")[issue]中找到了一个方案，但是原始版本会和上面的`notag`解决方案冲突，修改后解决方案如下，思路是给公式后紧接着的行前添加一个反向缩进（若有空行则不添加）。但这个方案还有待进一步优化。
```typc
#show: it => {
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
```
== 参考文献相关
=== 参考文献引用风格
一般来说参考文献引用会有上角标和非角标两种风格，在Typst中这两种风格是和选择的`style`挂钩的，也即来源于不同的 CSL 文件，这里对于我们常用的 `gb-7714-2015-numeric`风格可以定义一个专门的非角标引用命令
```typc
#let parencite(key, ..args) = [文献~#cite(key, style: "ieee", ..args)]
```
注意使用时的调用格式是`#parencite(<label>)`，而不是`#parencite(label)`。
=== 参考文献样式的本地化问题
由于Typst不支持CSL-M标准，在部分情况下，当中英文参考文献同时出现时，英文参考文献中的“et al.”会显示为“等”，可见#link("https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html")[FAQ：如何修复英文参考文献中的“等”？]，这里采用了其中的解决方案，引入 modern-nju-thesis 的`bilingual-bibliography`函数进行手动替换，使用如下命令
```typc
// 在文档开头引入
#import "@preview/modern-nju-thesis:0.3.4": bilingual-bibliography
// 将原本的 #bibliography("reference.bib") 替换为
#bilingual-bibliography(bibliography: bibliography.with("reference.bib"))
```
=== 参考文献自定义
可以通过修改 CSL 文件来修改参考文献样式。

= 可参考的互联网资源
1. #link("https://typress-web.vercel.app/")[Typress：输出Typst格式的公式OCR工具]
2. #link("https://convert.silkyai.cn/")[TyLax：#LaTeX 格式和Typst格式的转换工具]及其#link("https://www.reddit.com/r/typst/comments/1q5p0pn/tylax_an_opensource_bidirectional_converter_for/")[reddit帖子]
3. #link("https://qwinsi.github.io/tex2typst-webapp/cheat-sheet.html")[#LaTeX 和 Typst 的对照表]
4. #link("https://github.com/qjcg/awesome-typst?tab=readme-ov-file")[Awesome Typst]
5. #link("https://typst-doc-cn.github.io/clreq/")[clreq-gap for typst：分析 Typst 与中文排版的差距]
6. #link("https://typst.dev/guide/FAQ.html")[Typst 中文社区常见问题]
7. #link("https://github.com/Yousa-Mirage/Tufted-Blog-Template")[Tufted Blog Template：一个看起来不错的博客模板]
8. #link("https://typst-doc-cn.github.io/csl-sanitizer/")[为 Typst 修改过的中文 CSL 样式文件]
