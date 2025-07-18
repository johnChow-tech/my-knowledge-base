# CSS 初始化 (CSS Reset & Normalize)

## What (是什么?)

CSS 初始化是一种在项目开始时，通过编写一段CSS代码来覆盖或统一不同浏览器默认样式的技术。其目的是为了消除浏览器之间的样式差异，确保项目在一个可预测的、一致的视觉基础上进行开发。

## Why (为什么需要?)

每个浏览器（Chrome, Firefox, Safari等）都有自己的一套默认样式表。例如：
* `<body>` 元素在某些浏览器里有默认的 `margin`。
* `<h1>` 到 `<h6>` 标签的 `font-size` 和 `margin` 各不相同。
* `<ul>` 列表有默认的 `padding-left` 和 `list-style-type`。

这些差异会导致我们辛辛苦苦写的页面，在同事的电脑上或者其他浏览器里看起来“错位”了。CSS 初始化的核心目的，就是解决这个**“跨浏览器表现不一致”**的痛点。

## When (什么时候用?)

**在每一个新项目开始时。** 初始化样式表通常应该是我们整个 `style.css` 文件中，最先被加载或定义的部分。

## How (怎么做? - 主流方案对比)

主要有三种流派，它们的核心思想不同：

| 方法 (Method) | 核心思想 | 优点 (Pros) | 缺点 (Cons) | 代表库 (Example) |
| :--- | :--- | :--- | :--- | :--- |
| **CSS Reset** | **推倒重来 (Annihilate)** | 提供一个完全“干净”的画布，所有元素的样式都由你100%掌控。 | 工作量大，你需要为几乎所有元素重新定义基础样式（如标题大小、列表样式等）。 | [Eric Meyer's Reset](https://meyerweb.com/eric/tools/css/reset/) |
| **CSS Normalize** | **拨乱反正 (Unify & Correct)** | 不移除所有样式，而是保留有用的默认样式，并修正不同浏览器间的差异和已知的Bug。 | 页面上仍会保留一些默认样式，可能不是你想要的。 | [normalize.css](https://necolas.github.io/normalize.css/) |
| **Modern Hybrids** | **取长补短 (Modernize & Reset)** | 结合前两者的优点，通常更激进地重置一些样式，同时利用现代CSS特性来提供更合理的默认值。 | 可能带有一定的个人或团队风格偏好。 | [destyle.css](https://classic.yarnpkg.com/en/package/destyle.css) , `sanitize.css` |
