# 理解 `async/await` 与 Promise 的返回值

## 1. 核心原则：`async` 函数永远返回 Promise

`async` 关键字有一个最核心、最基础的特性：**它的返回值永远是一个 Promise 对象。**

* 如果你的 `async` 函数代码成功执行并 `return` 了一个值（例如 `return data`），JavaScript 引擎会自动将其包装成 `Promise.resolve(data)`。
* 如果你的 `async` 函数代码在执行过程中 `throw` 了一个错误，引擎会将其包装成 `Promise.reject(error)`。

这意味着，调用一个 `async` 函数，你拿到的**永远**是“一份承诺”，而不是最终的数据。

## 2. 常见陷阱：在调用端忘记 `await`

这是在使用 `async/await` 时最容易犯的错误。

**错误的示例代码：**
```javascript
// 事件处理器本身不是 async 函数
const handleSearchKeydown = (event) => {
  if (event.code === 'Enter') {
    // 1. fetchWeatherData 是一个 async 函数，它立即返回一个 Promise
    const data = fetchWeatherData(elements.searchTextField.value);
    
    // 2. 此时的 `data` 变量，是一个处于 pending 状态的 Promise 对象
    // 3. 我们把这个 Promise 对象传给了 updateUI，而不是它最终的数据
    updateUI(data); 
  }
};
```
在上面的代码中，`updateUI` 函数收到的 `data` 参数，将会是 `Promise { <pending> }`，而不是我们期望的 JSON 对象，因此无法从中读取 `data.current.temp_c` 等属性。

## 3. 解决方案

为了获取 Promise 中“包裹”的最终值，我们必须等待它从 `pending` 状态变为 `resolved` (成功) 或 `rejected` (失败)。

### 方案 A：在调用端也使用 `async/await` (最佳实践)

这是最清晰、最符合 `async/await` 设计思想的方式。

**正确的示例代码：**
```javascript
// 1. 将事件处理器也声明为 async
const handleSearchKeydown = async (event) => {
  if (event.code === 'Enter') {
    // 2. 使用 try...catch 来捕获可能发生的“拒绝(rejected)”状态
    try {
      // 3. 使用 await 来“暂停”函数，直到 Promise 完成，并解包出最终的数据
      const data = await fetchWeatherData(elements.searchTextField.value);
      
      // 4. 现在，data 就是我们期望的 JSON 对象了
      updateUI(data);
    } catch (error) {
      // 5. 如果 Promise 被拒绝，错误会被 catch 捕获
      showError(error);
    }
  }
};
```

### 方案 B：使用 `.then()` 和 `.catch()` (知识拓展)

`async/await` 本质上是 Promise 链式调用的“语法糖”。了解其底层原理有助于我们理解更复杂的异步场景。

**等效的示例代码：**
```javascript
const handleSearchKeydown = (event) => {
  if (event.code === 'Enter') {
    fetchWeatherData(elements.searchTextField.value)
      .then(data => {
        // 当 Promise 成功 (resolved) 时，这个函数会被调用
        updateUI(data);
      })
      .catch(error => {
        // 当 Promise 失败 (rejected) 时，这个函数会被调用
        showError(error);
      });
  }
};
```

## 4. 总结

**黄金法则：** 当你调用一个返回 Promise 的函数（特别是 `async` 函数）时，你必须用某种方式来“等待”并“解包”它的结果。要么使用 `await` (推荐)，要么使用 `.then()`。