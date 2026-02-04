# LaTeX to Typst Physics & Math Symbol Mapping Cheat Sheet
# This list focuses on symbols where the Typst syntax differs significantly from LaTeX.
# It is optimized for physics and advanced mathematics contexts.

## 1. Greek Letters (Variants)
| LaTeX | Typst | Note |
| :--- | :--- | :--- |
| `\varepsilon` | `epsilon` | Curly epsilon (Standard in Typst) |
| `\epsilon` | `epsilon.alt` | Lunate epsilon |
| `\varphi` | `phi` | Curly phi (Standard in Typst) |
| `\phi` | `phi.alt` | Straight phi |
| `\vartheta` | `theta.alt` | Variant theta |
| `\varrho` | `rho.alt` | Variant rho |

## 2. Calculus, Operators & Constants (Crucial for Physics)
| LaTeX | Typst | Note |
| :--- | :--- | :--- |
| `\partial` | `partial` | Partial derivative symbol |
| `\nabla` | `nabla` | Del operator |
| `\int` | `integral` | Standard integral |
| `\oint` | `integral.cont` | Contour integral |
| `\iint` | `integral.double` | Double integral |
| `\iiint` | `integral.triple` | Triple integral |
| `\sum` | `sum` | Summation |
| `\prod` | `product` | Product operator |
| `\cdot` | `dot.c` | Dot product (centered dot) |
| `\times` | `times` | Cross product |
| `\infty` | `infinity` | Infinity |
| `\hbar` | `planck.reduce` | Reduced Planck constant |
| `\Re` | `Re` | Real part (e.g., Re(z)) |
| `\Im` | `Im` | Imaginary part (e.g., Im(z)) |
| `\prime` | `'` | Prime (e.g., f') |

## 3. Fonts & Text Styles
# Typst uses function syntax `func(content)` rather than `\cmd{content}`.
| LaTeX | Typst | Note |
| :--- | :--- | :--- |
| `\mathbf{A}` | `bold(A)` | Bold math |
| `\mathrm{A}` | `upright(A)` | Upright math (for units/labels) |
| `\mathcal{A}` | `cal(A)` | Calligraphic (Lagrangian, etc.) |
| `\mathbb{R}` | `bb(R)` | Blackboard bold (Sets: R, C, Z) |
| `\mathfrak{g}` | `frak(g)` | Fraktur (Lie algebras) |
| `\mathscr{A}` | `scr(A)` | Typst `cal` often handles script styles too |

## 4. Arrows & Relations (Shorthand Preferred)
# Typst supports succinct shorthands for common arrows and relations.
| LaTeX | Typst (Shorthand) | Typst (Full Name) |
| :--- | :--- | :--- |
| `\to`, `\rightarrow` | `->` | `arrow.r` |
| `\leftarrow` | `<-` | `arrow.l` |
| `\Rightarrow`, `\implies` | `=>` | `arrow.r.double` |
| `\iff`, `\Leftrightarrow` | `<=>` | `arrow.l.r.double` |
| `\mapsto` | `|->` | `arrow.r.bar` |
| `\approx` | `approx` | - |
| `\equiv` | `equiv` | - |
| `\neq` | `!=` | `eq.not` |
| `\leq` | `<=` | `lt.eq` |
| `\geq` | `>=` | `gt.eq` |
| `\ll` | `<<` |
| `\gg` | `>>` |
| `\pm` | `plus.minus` | - |
| `\langle` | `chevron.l` |
| `\rangle` | `chevron.r` |

## 5. Sets & Logic
| LaTeX | Typst | Note |
| :--- | :--- | :--- |
| `\in` | `in` | Element of |
| `\notin` | `in.not` | Not element of |
| `\subset` | `subset` | Proper subset |
| `\subseteq` | `subset.eq` | Subset or equal |
| `\cup` | `union` | Union |
| `\cap` | `sect` | Intersection |
| `\forall` | `forall` | For all |
| `\exists` | `exists` | Exists |
| `\emptyset`, `\varnothing` | `emptyset` | Empty set |