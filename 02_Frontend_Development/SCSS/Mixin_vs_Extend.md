# SCSS 核心：`@mixin` vs. `@extend` 的选择与权衡

`@mixin` 和 `@extend` 都是 SCSS 中实现代码复用、遵循 DRY (Don't Repeat Yourself) 原则的强大工具。然而，它们在底层的实现原理和最佳使用场景上有本质区别。

## @mixin：可定制的“代码复印机”

- **核心思想:** `@mixin` 像一个函数。你定义一个可复用的样式块，然后在需要的地方通过 `@include` 将其内容**完整地复制**过来。
- **关键特性:** **可以传递参数**，这使得它非常灵活，可以生成动态变化的样式。

**示例：**
```scss
// 定义一个可以接收参数的 mixin
@mixin flex-center($direction: row) {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: $direction;
}

.container-horizontal {
  @include flex-center(); // 使用默认的 row
}

.container-vertical {
  @include flex-center(column); // 传入参数 column
}
```
**编译后的 CSS (代码被复制):**
```css
.container-horizontal {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: row;
}

.container-vertical {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
}
```

---

## @extend：语义化的“群组邀请函”

- **核心思想:** `@extend` 用于将多个选择器**合并**成一个。它告诉 SCSS，某个选择器与另一个选择器共享同一套样式规则，请把它们放在一个“群组”里。
- **关键特性:** 它表达的是一种**“是一个”(is-a)** 的语义关系。例如，“一个危险按钮**是**一个按钮”。它**不能传递参数**。

**示例 (通常与占位符 `%` 配合使用):**
```scss
// 定义一个“抽象”的按钮样式
%button {
  padding: 8px 16px;
  border-radius: 4px;
}

.button-primary {
  @extend %button;
  background-color: blue;
}

.button-secondary {
  @extend %button;
  background-color: grey;
}
```
**编译后的 CSS (选择器被合并):**
```css
.button-primary, .button-secondary {
  padding: 8px 16px;
  border-radius: 4px;
}

.button-primary {
  background-color: blue;
}

.button-secondary {
  background-color: grey;
}
```

---

## 对比与决策

| 特性         | `@mixin` (混入)                                                                                       | `@extend` (继承)                                                                     |
| :----------- | :---------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------- |
| **核心思想** | **复制代码**                                                                                          | **合并选择器**                                                                       |
| **参数**     | ✅ **支持**                                                                                            | ❌ 不支持                                                                             |
| **输出结果** | 产生重复的样式属性                                                                                    | 产生组合的选择器列表                                                                 |
| **适用场景** | 1. 需要参数的功能性代码块<br>2. **复杂的选择器** (伪类/伪元素, 媒体查询)<br>3. 不希望产生关联的工具类 | 1. 元素间存在**“is-a”**的语义关系<br>2. **简单的选择器**<br>3. 目标是输出最精简的CSS |
| **风险**     | 代码冗余 (通常可被Gzip忽略)                                                                           | **选择器耦合**，在复杂场景下可能产生意想不到的、庞大的选择器组合，导致维护困难。     |

## 黄金法则 (The Golden Rule)

> **当你犹豫不决时，优先使用 `@mixin`。**

在现代前端开发中，组件化和复杂选择器（如伪类 `:hover`, 媒体查询 `@media`）是常态。`@mixin` 的**可预测性和安全性**（它不会创建意想不到的选择器关联），使其成为了更通用、更安全的选择。由它产生的少量代码冗余，在 Gzip 压缩下对性能的影响几乎可以忽略不计。

只在你非常确定元素之间存在清晰、简单的继承关系，并且不会在复杂选择器内部使用时，才考虑使用 `@extend` 来优化最终的 CSS 文件大小。