# 内容自动化与人工审核规范

本文件定义 GitHub 项目发现、商业化包装、AI 文案与图片生成，以及网站审核发布流程。实现时必须遵循“生成草稿、人工审核、批准后发布”。

## 商业产品团队提示词

系统应以一个专业商业产品团队的能力工作，覆盖：

- 高级产品经理与 SaaS 产品策划
- 商业软件包装与电商营销文案
- 闲鱼、小红书、抖音、快手、哔哩哔哩内容运营
- 品牌视觉设计
- 软件商业化与开源许可证合规

输入可以是 GitHub 链接、README、Release、截图或相关资料。任务不是改写 README，而是先验证项目事实，再整理为可部署、可交付、可定制、可销售的产品方案。

每个项目必须输出：

1. 事实证据表：来源 URL、commit SHA、版本、许可证、核验时间。
2. 产品定位：目标客户、使用场景、核心价值、交付边界、部署条件。
3. 商品母版：名称、卖点、功能、套餐、FAQ、交付清单、风险说明。
4. 渠道草稿：官网、闲鱼、小红书、抖音、快手、哔哩哔哩。
5. 三张独立宣传图：统一品牌风格、不同信息目标、分别保存。
6. 合规结论：许可证义务、署名、源码公开条件、商标和素材风险。
7. 待审核项：事实、价格、图片、渠道与账号分别确认。

不得虚构功能、用户、增长数据、收益、兼容性或许可证。无法验证的内容标为“待核实”。

## 每四小时 GitHub 候选扫描

- 使用持久化任务调度器，每 4 小时执行一次；支持暂停、立即运行、失败重试和历史记录。
- 每轮先收集最多 30 个公开候选，再依据近期活跃度、可部署性、商业场景、文档完整度和许可证筛选 5–10 个。
- 保存 star、fork、issue、release、commit 与抓取时间快照。只有存在历史快照时才能计算 4/24/48 小时增量。
- 没有许可证、许可证冲突、明显侵权、恶意代码风险或不能确认商业使用边界的项目，不进入可售队列。
- 用 repository + commit SHA + 内容模板版本作为幂等键，避免重复草稿。
- 自动化只允许创建草稿和图片任务；不得自动公开网站商品，也不得自动向社交平台发布。

## OpenAI 文案与图片能力

- 通过服务端 OpenAI API 或管理员已授权的工具调用，不直接暴露私人 ChatGPT 会话。
- API 密钥只保存在服务端环境变量或密钥管理系统，禁止进入浏览器、日志、仓库和导出文件。
- 文案生成采用结构化 JSON 输出，服务端按 schema 校验后写入草稿。
- 图片使用官方图像生成能力。每个商品生成三张独立图片：
  - 官网首图：16:9，突出产品与核心价值。
  - 功能场景图：16:9，展示真实使用场景。
  - 社交宣传图：按平台比例生成构图，文字层由 HTML/SVG/Canvas 精确排版。
- 中文价格、二维码和重要文字不依赖图片模型直接绘制。
- 保存模型、提示词版本、生成时间、费用、操作人和来源项目，支持重做与回滚。
- 管理员可设置单次、单日费用上限和并发限制。

建议环境变量：

```env
OPENAI_API_KEY=
OPENAI_TEXT_MODEL=
OPENAI_IMAGE_MODEL=
CONTENT_AUTOMATION_ENABLED=false
CONTENT_SCAN_INTERVAL_HOURS=4
CONTENT_MAX_CANDIDATES=30
CONTENT_DRAFT_WEBHOOK_SECRET=
```

## 网站草稿 API

后台应提供经过认证的草稿导入接口，例如：

`POST /api/admin/drafts/import`

请求至少包含：

- source_repository
- source_commit_sha
- evidence
- license_review
- product_master
- channel_drafts
- image_assets
- generator_metadata
- idempotency_key

接口只能创建或更新草稿，返回 draft_id、version 和 review_url。公开发布必须由管理员在后台点击批准；内容、价格、图片或目标渠道发生变化后必须重新审核。

## 状态机

`candidate → researching → draft → awaiting_review → approved → publishing → published`

异常状态包括 `rejected`、`failed` 和 `verification_required`。任何自动任务不得绕过 `awaiting_review` 与 `approved`。

## 第一阶段行为

网站草稿 API 尚未完成时，每四小时任务把审核包发送到 ChatGPT 任务结果或 GitHub 审核区，不得声称已上传网站。接口上线并完成密钥配置后，再把自动化切换到草稿 API。
