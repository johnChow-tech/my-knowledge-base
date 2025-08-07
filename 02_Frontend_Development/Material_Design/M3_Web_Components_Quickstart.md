# M3 Web Components 项目实践笔记

## 1. 核心理念

Material 3 (M3) 是一个设计系统，它提供了一套专业、美观且注重易用性的组件。在开发中，我们的策略是**信任组件库的内部设计**，将我们的主要精力放在**布局、间距和业务逻辑**上，而不是过度修改组件的内部细节。

## 2. 引入与设置 (Import & Setup)

我们在项目中采用了官方推荐的、基于现代 Web 标准的 `importmap` 方式来引入组件库。

**步骤:**
1.  **引入核心字体与图标:** 在 `index.html` 的 `<head>` 中，引入 `Roboto` 字体和 `Material Symbols` 图标库。
    ```html
    <link href="[https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap](https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap)" rel="stylesheet" />
    <link href="[https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL@20..48,100..700,0..1](https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL@20..48,100..700,0..1)" rel="stylesheet" />
    ```

2.  **设置 `importmap`:** 同样在 `<head>` 中，使用 `importmap` 来映射 M3 模块的加载路径，避免在 JS 中书写冗长的 URL。
    ```html
    <script type="importmap">
      {
        "imports": {
          "@material/web/": "[https://esm.run/@material/web/](https://esm.run/@material/web/)"
        }
      }
    </script>
    ```

3.  **加载组件与排版样式:** 使用 `<script type="module">` 来加载所有 M3 组件的 JS 逻辑，并应用 M3 的排版基础样式。
    ```html
    <script type="module">
      import '@material/web/all.js';
      import { styles as typescaleStyles } from '@material/web/typography/md-typescale-styles.js';
      document.adoptedStyleSheets.push(typescaleStyles.styleSheet);
    </script>
    ```

## 3. 主题与色彩系统 (Theme & Color System)

我们采用“直接链接 CSS 文件”的工作流来管理颜色主题，并实现了自动暗色模式切换。

1.  **生成主题:** 使用官方的 **[Material Theme Builder](https://m3.material.io/theme-builder)**，输入一个“源色彩”，即可导出包含 `light.css` 和 `dark.css` 的完整主题包。

2.  **实现自动暗色模式:** 在 `index.html` 的 `<head>` 中，使用 `<link>` 标签并配合 `media` 属性来链接这两个主题文件。浏览器会根据用户的操作系统设置，自动选择加载对应的文件。
    ```html
    <link rel="stylesheet" href="css/light.css" media="(prefers-color-scheme: light)">
    <link rel="stylesheet" href="css/dark.css" media="(prefers-color-scheme: dark)">
    ```

3.  **在自定义样式中使用主题色:** 在我们自己的 `style.scss` 文件中，通过 CSS 自定义属性 (`var()`) 来引用主题文件中定义的“色彩角色”，确保我们的自定义样式也能响应主题切换。
    ```scss
    body {
      background-color: var(--md-sys-color-background);
      color: var(--md-sys-color-on-background);
    }
    ```

## 4. 在 HTML 中使用组件

M3 组件以**自定义 HTML 标签**的形式使用。

* **基本用法:** `<md-filled-button>Click Me</md-filled-button>`
* **组合组件 (Slots):** 复杂的组件（如文本框）使用 `slot` 属性来插入子组件（如图标按钮）。这是一种标准的 Web Components 技术。
    ```html
    <md-outlined-text-field label="City Name">
        <md-icon-button slot="leading-icon">
            <md-icon>search</md-icon>
        </md-icon-button>
    </md-outlined-text-field>
    ```

## 5. 使用 CSS 控制组件样式

这是最关键、也最容易混淆的部分。由于 **Shadow DOM** 的存在，我们不能用常规的 CSS 选择器去修改组件的内部元素。

我们遵循两大思路：

1.  **控制“外部盒子”:**
    * **做什么:** 控制组件的布局、位置、大小和间距。
    * **怎么做:** 像对待普通 `<div>` 一样，直接给组件标签写 CSS。
    * **示例:**
        ```scss
        .popular-cities {
          display: flex;
          gap: 8px;
        }

        .popular-cities md-suggestion-chip {
          margin-top: 4px; 
        }
        ```

2.  **定制“内部零件”:**
    * **做什么:** 修改组件内部的样式，如颜色、形状、字体大小等。
    * **怎么做:** 使用组件官方文档提供的 **CSS 自定义属性 (CSS Custom Properties)**。
    * **如何查找:**
        1.  查阅该组件在 [Material Web 官网](https://material-web.dev/) 的文档，找到 "Styling" 部分。
        2.  使用浏览器开发者工具，在 Elements 面板中找到组件下方的 `#shadow-root`，观察其内部元素的样式，找到可用的 `--md-*` 变量。
    * **示例:**
        ```scss
        .input-box md-outlined-text-field {
          /* 覆写 M3 组件内部的 CSS 变量，来改变其圆角 */
          --md-outlined-text-field-container-shape: 12px;
        }
        ```

### 总结
M3 Web Components 提供了一套专业且可靠的 UI 基础。通过 `importmap` 引入，使用 Theme Builder 定制并链接主题，最后通过“外部布局”和“内部自定义属性”相结合的方式进行样式控制，是使用它的最佳实践。