# 取得 AI 服务的 API 密钥

!!! warning 此文档不会涉及非官方途径

    此文档不会涉及官方途径以外的连接方式。
    在 SillyTavern 官方 Discord 服务器提及非官方途径以外的反向代理和中转会导致你被封禁。

!!! important "记得去看看官方 API 的价格"

    即使你不能亲自开设以下平台的 API 帐号，或是愿意用别人家的{--被别人割韭菜--}，你最好也把这三大家官方的价格表看一遍，所有低于这个单价的，要么是来路不正规（例如用一堆 Google 帐号白嫖 Gemini API 的免费层级，或是逃云服务平台的账单），或者就是偷梁换柱（用其它便宜的模型代替它声称的模型，「是吧 officechat 办公室? Gemini 的信息都在你用户的报错中出现了。是吧赛博女友(科普百晓生)，解释一下你用户报错中的`you.com`?」）等等。
    
    * OpenAI Platform（GPT 类模型，Azure OpenAI Service 的定价相同）: [https://openai.com/api/pricing/](https://openai.com/api/pricing/)
    * Anthropic Console（Claude 模型，AWS Bedrock / Google Vertex AI 中的 Claude 模型的定价相同）：[https://www.anthropic.com/pricing#anthropic-api](https://www.anthropic.com/pricing#anthropic-api)
    * Google Gemini： [https://cloud.google.com/vertex-ai/generative-ai/pricing?hl=zh-cn#gemini-models](https://cloud.google.com/vertex-ai/generative-ai/pricing?hl=zh-cn#gemini-models)

## OpenAI 模型（ChatGPT 等）

* 如果你有 OpenAI 支持区域（因为众所周知的原因，肯定没有中国大陆和香港）的手机号码和银行卡，可以自行开设 OpenAI API 帐号： https://openai.com/api/pricing/
* 退而求其次，如果你有带 VISA/Mastercard 或是 American Express 标志的国际信用卡/借记卡，可以尝试 OpenAI 东家微软 Azure 下的 Azure OpenAI Service 服务：https://azure.microsoft.com/zh-cn/products/ai-services/openai-service

## Anthropic 模型（Claude）
* 如果你有 Anthropic 支持区域（因为众所周知的原因，肯定没有中国大陆和香港）的手机号码和银行卡，可以自行开设 Anthropic Console 帐号：https://www.anthropic.com/pricing#anthropic-api
* 退而求其次，如果你有带 VISA/Mastercard 或是 American Express 标志的国际信用卡/借记卡，可以尝试通过 AWS Bedrock（https://aws.amazon.com/bedrock/claude/ ）或 Google Vertex AI （https://cloud.google.com/vertex-ai/generative-ai/docs/partner-models/use-claude?hl=zh-cn ）使用 Claude 模型。
* 某个 Discord 服务器（类脑 ΟΔΥΣΣΕΙΑ 啦）里面流行的方法是订阅 Claude Pro，然后自行抓取 Cookie 给一个名为 clewd 的软件，再接入酒馆来使用。（「酒馆是使用 AI 的场所，小克(Claude)是 AI，Clewd 是拐骗良家小克到酒馆的黄毛，破限是酒。」）
  * 注册 Claude 帐号需要 Anthropic 支持区域（因为众所周知的原因，肯定没有中国大陆和香港）的手机号码，订阅 Claude Pro 的话，还需要支持区域的银行卡，或是通过 App Store 或 Google Play 订阅。
  * 无论在哪里订阅， Claude Pro 的价格都是每月 20$ , App Store 和 Google Play 可能因为地区的问题低于这个价格。但如果你想不开找人代充，明显高于这个价格的就得多留个心眼了。
  * clewd 教程在这： https://rentry.org/teralomaniac_clewd ， Pro 订阅和退款流教程在这： https://rentry.co/zbfn8te4
  * 另外，由类脑社区成员编写的「Claude 宝宝教程」在这（**飞书警告**）： https://sqivg8d05rm.feishu.cn/wiki/BBocw85QTiA8EXkNcUZcT2pCnIe
  * 这种方式显然违反 [Anthropic 的 Claude 消费者服务协议。(3.7 节，禁止以非 Anthropic API 以外的通过机器人、脚本或其他自动或非人工方式访问 Anthropic 服务。）](https://www.anthropic.com/legal/consumer-terms) , 当然你越狱和搞颜色其实也违反了这些 LLM 的[可接受使用政策](https://www.anthropic.com/legal/aup)，因此 Anthropic 可能会封你的 Claude 帐号，Cookie 也有可能过期，因此你可能需要经常的注册新的帐号，和更换 Cookie。（但是因为封号会退款，因此也有不少人在下一个账单日付款（俗称被爆金币）之前把自己的 Cookie 发出来求人乱玩被封的，那就是另一回事了。）

## Google Gemini

* 你可以自行前往 Google AI Studio 申请 API 密钥： https://ai.google.dev/gemini-api/docs/ai-studio-quickstart?hl=zh-cn 
* 对于 IP 位于 Gemini 支持的区域（因为众所周知的原因，肯定没有香港，有完全不可靠的消息说 Google 没有阻止中国大陆的 IP 连接 Gemini API，但是 Google 在中国大陆早就全线被墙了啊），且不是欧洲经济区，英国或瑞士的话，Gemini 提供免费层级，虽然配额卡的很紧但应该也够用。脸皮够厚还有手段的话，注册一堆 Google 帐号来回去嫖也是可以的。
* 如果你有带 VISA/Mastercard 或是 American Express 标志的国际信用卡/借记卡，通过关联有付款资料的 Google Cloud 项目，你的 API 便是付费层级了。付费层级的定价在： https://ai.google.dev/pricing?hl=zh-cn 。以及虽然不一定都会相信，[但 Google 说免费层级调用的输入会用于改进产品的提示和响应，付费层级则不会。](https://ai.google.dev/gemini-api/terms?hl=zh-cn)