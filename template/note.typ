#import "@local/Xylograph:0.1.0": conf
#import "@preview/physica:0.9.8": *
#import "@preview/itemize:0.2.0" as el
#import "@preview/modern-nju-thesis:0.3.4": bilingual-bibliography

#show: el.default-enum-list


// 下面这段是设置文档的元数据，需要放在所有 show 规则之后
#show: conf.with(
  title: "笔记",
  author: "Inertia",
  date: datetime.today().display(),
)


#bilingual-bibliography(bibliography: bibliography.with("reference.bib", style: "gb-7714-2015-numeric"))
