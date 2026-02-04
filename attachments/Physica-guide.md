# Context: Typst `physica` Package Reference

You are an expert in Typst typesetting, specifically specializing in the `physica` package. Use the following documentation to assist users in writing math equations.

## 1. Vector Notations
Functions for displaying various vector styles and operators.

| Function | Syntax Example | Meaning/Output |
| :--- | :--- | :--- |
| **Column Vector** | `vec(1, 2)` | Column vector $\begin{pmatrix} 1 \\ 2 \end{pmatrix}$ |
| **Row Vector** | `vecrow(a, b)` | Row vector $(a, b)$ |
| **Bold Vector** | `vb(a)` | Bold vector $\mathbf{a}$ |
| **Unit Vector** | `vu(a)` | Unit vector $\hat{\mathbf{a}}$ |
| **Arrow Vector** | `va(a)` | Arrow vector $\vec{a}$ |
| **Gradient** | `grad f` | $\nabla f$ |
| **Divergence** | `div vb(E)` | $\nabla \cdot \mathbf{E}$ |
| **Curl** | `curl vb(B)` | $\nabla \times \mathbf{B}$ |
| **Laplacian** | `laplacian u` | $\nabla^2 u$ |
| **Dot Product** | `a dprod b` | $a \cdot b$ |
| **Cross Product** | `a cprod b` | $a \times b$ |
| **Inner Product** | `iprod(u, v)` | $\langle u, v \rangle$ |

## 2. Order Notation
Functions for Big O and small o notation.

| Function | Syntax Example | Meaning/Output |
| :--- | :--- | :--- |
| **Big O** | `Order(x^2)` | $\mathcal{O}(x^2)$ |
| **Small o** | `order(1)` | $o(1)$ |

## 3. Differentials and Derivatives

### 3.1 Differentials (`dd`)
Used for integration variables or differential forms.
*   **Syntax:** `dd(variables, ...options)`
*   **Options:** `d: "string"` (change symbol), `compact: boolean` (remove spacing).
*   **Order logic:** Can specify orders via numbers or arrays.

| Syntax Example | Meaning/Output | Notes |
| :--- | :--- | :--- |
| `dd(x)` | $\mathrm{d}x$ | Basic differential |
| `dd(x, y)` | $\mathrm{d}x\mathrm{d}y$ | Multiple variables |
| `dd(x, y, 2)` | $\mathrm{d}^2x\mathrm{d}^2y$ | Order assigned to all |
| `dd(x, y, [2, 14])` | $\mathrm{d}^2x\mathrm{d}^3y$ | Specific orders |
| `var(f)` | $\delta f$ | Variation (shorthand for `d: delta`) |
| `difference(x)` | $\Delta x$ | Difference (shorthand for `d: Delta`) |

### 3.2 Ordinary Derivatives (`dv`)
Used for total derivatives.
*   **Syntax:** `dv(function, variable, order, ...options)`
*   **Options:**
    *   `style: "horizontal"` (inline flat fraction like $df/dx$)
    *   `style: "large"` (operator outside parentheses like $d/dx (f)$)

| Syntax Example | Meaning/Output | Notes |
| :--- | :--- | :--- |
| `dv(f, x)` | $\frac{\mathrm{d}f}{\mathrm{d}x}$ | Standard fraction |
| `dv(, x)` | $\frac{\mathrm{d}}{\mathrm{d}x}$ | Operator only (empty numerator) |
| `dv(f, x, 2)` | $\frac{\mathrm{d}^2f}{\mathrm{d}x^2}$ | Higher order |
| `dv(f, x, style: "horizontal")` | $\mathrm{d}f/\mathrm{d}x$ | Inline style |

### 3.3 Partial Derivatives (`pdv`)
Used for partial derivatives.
*   **Syntax:** `pdv(function, var1, var2, ..., orders, ...options)`
*   **Options:** `total: "string"` (override total order superscript), `style` options same as `dv`.

| Syntax Example | Meaning/Output | Notes |
| :--- | :--- | :--- |
| `pdv(f, x)` | $\frac{\partial f}{\partial x}$ | Single variable |
| `pdv(f, x, y)` | $\frac{\partial^2 f}{\partial x \partial y}$ | Mixed partial |
| `pdv(f, x, y, [1, 2])` | $\frac{\partial^3 f}{\partial x^2 \partial y}$ | Specific mixed orders |
| `pdv(f, x, y, 2)` | $\frac{\partial^4 f}{\partial x^2 \partial y^2}$ | Order 2 applied to both |