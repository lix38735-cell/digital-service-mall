# ORBITAL — 沉浸式星际探索 (Interactive Experience)

这是一个**与商城主代码隔离**的设计展示实验项目，放置于 `experiments/orbital-experience/`，不会更改现有业务文件。

## 项目亮点

- 大幅星球渐变渲染、双轨道运动与背景实时粒子星空
- 鼠标视差、滚动进度、标题与卡片视觉层次
- 三颗星体互动：Kepler-186f、Gliese 667Cc、TRAPPIST-1e
- 场景颜色、星体外观、观测数值及当前选择联动
- 点击「开启星际旅程」模拟跃迁动画并切换目标
- 可选 Web Audio 低音量环境音，默认关闭且不自动播放
- 探索档案可直接跳转观察；「发射信号」有互动反馈
- 全中文内容，移动端适配，支持 `prefers-reduced-motion`

## 运行方式

本演示为 **单文件静态网页**，无构建依赖。直接打开 [index.html](./index.html)，或者从此目录启动静态服务器：

```bash
python3 -m http.server 8000
```

访问 http://localhost:8000 即可。浏览器首次打开时会尝试加载 Google Fonts；离线时使用系统字体。

## 部署

使用 GitHub Pages / Netlify / Vercel 静态部署时，将发布目录设为 `experiments/orbital-experience`。如与已有项目共享仓库，请不要直接把商城根目录替换成此演示文件。

## 说明

行星名字对应真实系外行星，星球外观、观测信号以及跃迁过程都是**创意可视化，不代表真实天文观测**。本演示不会主动搜集用户数据或向后端发起业务请求。

这是 GitHub 内的独立轻量版本。完整可拆分源码的 ZIP 版本在 ChatGPT 项目交付中提供。