# JavaScript ES6+：解构赋值 (Destructuring Assignment)

## 核心思想：像“开箱”一样提取数据

解构是 ES6 引入的一种语法，它允许我们像‘开箱’一样，从数组或对象中方便地提取数据，并直接赋值给独立的变量。这是一种更简洁、更具可读性的数据访问方式。

## 1. 对象解构 (Object Destructuring)

对象解构**根据属性名 (key)** 来提取值。这是最常用的解构形式。

### 基础语法

变量名必须与对象的属性名匹配。

```javascript
const user = {
  name: 'John Doe',
  age: 30,
  country: 'Japan',
};

// 从 user 对象中“解构”出 name 和 age 属性
const { name, age } = user;

console.log(name); // 'John Doe'
console.log(age); // 30
```

### 嵌套解构 (Nested Destructuring)

如果对象有多层嵌套，我们可以用同样的模式深入提取。

```javascript
const weatherData = {
  location: { name: 'Tokyo', country: 'Japan' },
  current: {
    temp_c: 25,
    condition: {
      text: 'Sunny',
    },
  },
};

// 一步到位，获取深层嵌套的属性
const {
  location: { name },
  current: {
    temp_c,
    condition: { text },
  },
} = weatherData;

console.log(name); // 'Tokyo'
console.log(temp_c); // 25
console.log(text); // 'Sunny'
```

### 重命名变量 (Renaming)

如果想用一个不同的变量名来接收属性值，可以使用冒号语法。

```javascript
const { temp_c: temperature } = weatherData.current;

console.log(temperature); // 25
// console.log(temp_c); // 这会报错，因为 temp_c 并未被定义
```

### 设置默认值 (Default Values)

可以为可能不存在的属性提供一个默认值，防止变量为 `undefined`。

```javascript
const { name, country = 'Unknown' } = { name: 'John Doe' };

console.log(name); // 'John Doe'
console.log(country); // 'Unknown'
```

## 2. 数组解构 (Array Destructuring)

数组解构**根据位置顺序 (index)** 来提取值。

```javascript
const coordinates = [35.68, 139.69];

const [latitude, longitude] = coordinates;

console.log(latitude); // 35.68
```

## 3. 核心优势与应用场景

为什么我们应该频繁使用解构？

1.  **代码更简洁:** 告别重复的 `data.current.temp_c` 写法，大幅减少代码量。
2.  **可读性更强:** 在函数开头使用解构，就像一份“内容清单”，清晰地声明了该函数依赖对象的哪些属性，让代码意图更明确。
3.  **函数参数解构:** 可以直接在函数参数位置进行解构，这是现代JavaScript（尤其在React中）非常普遍和优雅的模式。

    ```javascript
    // 不使用解构
    function printUser(user) {
      console.log(user.name);
    }

    // 使用参数解构
    function printUser({ name }) {
      console.log(name);
    }

    printUser({ name: 'John Doe', age: 30 }); // 传入整个对象，函数自动解构
    ```

## 4. 在“天气应用”中的实践

在我们的 `updateUI` 函数中，使用嵌套解构来提取所有需要渲染的数据，是最佳实践。

```javascript
function updateUI(data) {
  // 使用嵌套解构，一次性获取所有需要的数据
  const {
    location: { name, country },
    current: {
      temp_c,
      humidity,
      pressure_mb,
      wind_kph,
      condition: { text, icon },
    },
  } = data;

  // 接下来就可以直接使用这些变量来更新 DOM
  elements.weatherInfoCards.temperature.textContent = `${temp_c}°C`;
  // ...
}
```