# 取得 AI 服务的 API 密钥

!!! warning 此文档不会涉及非官方途径

    此文档不会涉及官方途径或需要官方途径取得的登录凭据（Cookie或API密钥等）以外的连接方式。
    在 SillyTavern 官方 Discord 服务器提及非官方途径以外的反向代理和中转会导致你被封禁。

!!! important "记得去看看官方 API 的价格"

    即使你不能亲自开设以下平台的 API 帐号，或是愿意用别人家的{--被别人割韭菜--}，你最好也把这三大家官方的价格表看一遍，所有低于这个单价的，要么是来路不正规（例如用一堆 Google 帐号白嫖 Gemini API 的免费层级，或是逃云服务平台的账单），或者就是偷梁换柱（用其它便宜的模型代替它声称的模型等等。
    
    > 「是吧 officechat 办公室? Gemini 的信息都在你用户的报错中出现了。是吧赛博女友(科普百晓生)，解释一下你用户报错中的`you.com`?」
    
    * OpenAI Platform（GPT 类模型，Azure OpenAI Service 的定价相同）: [https://openai.com/api/pricing/](https://openai.com/api/pricing/)
    * Anthropic Console（Claude 模型，AWS Bedrock / Google Vertex AI 中的 Claude 模型的定价相同）：[https://www.anthropic.com/pricing#anthropic-api](https://www.anthropic.com/pricing#anthropic-api)
    * Google Gemini： [https://cloud.google.com/vertex-ai/generative-ai/pricing?hl=zh-cn#gemini-models](https://cloud.google.com/vertex-ai/generative-ai/pricing?hl=zh-cn#gemini-models)
  
!!! warning "开通 OpenAI / Anthropic 官方 API 服务的先决条件"

    除了 Google Cloud，另外两家都需要有一个支持区域的手机号和银行卡（因为众所周知的原因，肯定没有中国大陆和香港）。

    如果你可以不通过 App Store 和 Play Store 订阅 ChatGPT Plus 或者 Claude Pro，那应该就没问题。

## OpenAI 模型（ChatGPT 等）

* 如果你有 OpenAI 支持区域的手机号码和银行卡，可以自行开设 OpenAI API 帐号： https://openai.com/api/pricing/
* 退而求其次，如果你有带 VISA/Mastercard 或是 American Express 标志的国际信用卡/借记卡，可以尝试 OpenAI 东家微软 Azure 下的 Azure OpenAI Service 服务：https://azure.microsoft.com/zh-cn/products/ai-services/openai-service

[前往 OpenAI Platform](#){ .md-button }
[前往 Azure AI Studio](#){ .md-button }
[详细步骤](#){ .md-button }

## Anthropic 模型（Claude）

!!! info "文档部分内容暂缓更新"

    因为 Anthropic 收紧了给 Google Cloud 和 AWS Bedrock 上 Claude 的配额。主要表现为不能申请开通，或者开通之后没有配额等等。因此这两部分内容暂时停更。

* 如果你有 Anthropic 支持区域的手机号码和银行卡，可以自行开设 Anthropic Console 帐号：https://www.anthropic.com/pricing#anthropic-api
* 退而求其次，如果你有带 VISA/Mastercard 或是 American Express 标志的国际信用卡/借记卡，可以尝试通过 AWS Bedrock（https://aws.amazon.com/bedrock/claude/ ）或 Google Vertex AI （https://cloud.google.com/vertex-ai/generative-ai/docs/partner-models/use-claude?hl=zh-cn ）使用 Claude 模型。

[前往 Anthropic Console](https://console.anthropic.com/dashboard){ .md-button }
[详细步骤](anthropic.md){ .md-button }


!!! tips "通过 Vertex API 在 SillyTavern 使用 Claude?"

    因为 SillyTavern 并不直接支持这样做，你需要通过一些额外的手段，将 Vertex API 调用转换为 SillyTavern 支持的，兼容 OpenAI 的调用方式。

    * oai-reverse-proxy 正是其中一种方式。
  
## Google Gemini

* 你可以自行前往 Google AI Studio 申请 API 密钥： https://ai.google.dev/gemini-api/docs/ai-studio-quickstart?hl=zh-cn 
* 对于 IP 位于 Gemini 支持的区域（因为众所周知的原因，肯定没有香港，有完全不可靠的消息说 Google 没有阻止中国大陆的 IP 连接 Gemini API，但是 Google 在中国大陆早就全线被墙了），且不是欧洲经济区，英国或瑞士的话，Gemini 提供免费层级，虽然配额卡的很紧但应该也够用。脸皮够厚还有手段的话，注册一堆 Google 帐号来回去嫖也是可以的。
* 如果你有带 VISA/Mastercard 或是 American Express 标志的国际信用卡/借记卡，通过关联有付款资料的 Google Cloud 项目，你的 API 便是付费层级了。付费层级的定价在： https://ai.google.dev/pricing?hl=zh-cn 。以及虽然不一定都会相信，[但 Google 说免费层级调用的输入会用于改进产品的提示和响应，付费层级则不会。](https://ai.google.dev/gemini-api/terms?hl=zh-cn)

[前往 Google AI Studio](https://aistudio.google.com){ .md-button }
[详细步骤](#){ .md-button }
