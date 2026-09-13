# 无 OpenAI API Key 的 ChatGPT 审核包接入方案

## 目标

网站本身不调用 OpenAI。ChatGPT 定时任务每四小时生成候选项目审核包，管理员审核后将批准版本导入网站草稿箱，再由管理员发布。

## 需要新增的后台页面

### /admin/content-inbox

显示 ChatGPT 审核包：

- 项目来源、commit SHA、核验时间
- 许可证、署名义务、商业化风险
- 商品母版和各平台文案
- 三张独立 16:9 宣传图
- 待核实项和版本差异
- 状态：待审核、已批准、已拒绝、已导入

操作：批准、拒绝、退回修改、下载审核包、导入商品草稿。

### /admin/content-inbox/import

支持上传 JSON 审核包和三张图片。上传后只创建草稿，不直接公开。

### /admin/services/:id/review

在现有服务编辑页旁增加审核视图，集中确认标题、价格、正文、图片、许可证说明和渠道文案。任何修改都会生成新版本并取消旧批准状态。

## 导入格式

```json
{
  "schema_version": "1.0",
  "source": {
    "repository": "owner/repository",
    "url": "https://github.com/owner/repository",
    "commit_sha": "完整提交哈希",
    "checked_at": "ISO-8601"
  },
  "evidence": [],
  "license_review": {
    "spdx": "",
    "commercial_use": "allowed|restricted|unknown",
    "obligations": [],
    "risks": []
  },
  "product": {
    "title": "",
    "positioning": "",
    "features": [],
    "deliverables": [],
    "pricing": [],
    "faq": []
  },
  "channel_drafts": {
    "website": {},
    "xianyu": {},
    "xiaohongshu": {},
    "douyin": {},
    "kuaishou": {},
    "bilibili": {}
  },
  "images": [
    {"slot": "hero", "file": "01-hero.png", "ratio": "16:9"},
    {"slot": "features", "file": "02-features.png", "ratio": "16:9"},
    {"slot": "scenario", "file": "03-scenario.png", "ratio": "16:9"}
  ],
  "unverified": [],
  "idempotency_key": "repository:commit_sha:template_version"
}
```

## 校验规则

- repository、commit_sha、许可证结论和三张图片缺一不可。
- 三张图片必须是独立文件，比例为 16:9。
- 图片不得出现原项目名称、仓库名称、GitHub 用户名、GitHub Logo、仓库地址和原作者标识。
- 事实、推断和未验证内容必须分栏保存。
- 相同 idempotency_key 只更新原草稿，不重复创建。
- 服务端限制 JSON 和图片大小，验证 MIME 类型和扩展名，随机化保存文件名。
- 导入、批准、拒绝、发布全部记录操作人、时间和版本。
- 未批准版本不能进入发布接口。

## 数据状态

`imported → awaiting_review → approved → draft_created → published`

异常状态：`rejected`、`needs_revision`、`validation_failed`。

## 后续自动导入

以后如需取消手工上传，可以新增带签名的：

`POST /api/admin/content-inbox/import`

使用独立 webhook secret、时间戳、防重放签名、IP/频率限制和幂等键。接口仍然只能创建待审核草稿，不能直接发布。
