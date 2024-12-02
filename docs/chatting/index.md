# AI 聊天相关工具和知识概览

!!! tips

    点击左边或菜单内的导航，可以快速的跳到相关的小节。

## 重中之重 - 自己动手，不要给奸商交智商税

* 本文档的所有部分都在鼓励你自行安装和运行各种前端（例如 SillyTavern），
  购买 AI 公司提供的服务，而不是从各种来历不明的第三方那里。
* 来历不明的第三方服务也许会有下面所述的各种问题，也许也会有这里没有记载的更多问题。
* 在某些情况下，你可以完全无视这一部分的内容，例如你信任你的来源（例如你认识的朋友），{--或是你甘愿被割韭菜--}

[为什么？](avoid_scamming.md){ .md-button }

## 取用模型的主要方式

### 取得 LLM 服务的登录凭据

!!! tips
    
    无论你使用什么前端，你总要用它们的 API 密钥访问它们。

* API 密钥

[GPT](api_connection/index.md#openai-chatgpt){ .md-button }
[Claude](api_connection/index.md#anthropic-claude){ .md-button }
[Gemini](api_connection/index.md#google-gemini){ .md-button }

* Cookie

[Claude](#){ .md-button }

### 使用 Clewd
一种利用网页版 Claude 发出比网页提供的更具灵活性的请求的方式。需要提前获得 Claude 网页版应用的 Cookie。

!!! tips

    省流：酒馆是使用 AI 的场所，小克(Claude)是 AI，Clewd 是拐骗良家小克到酒馆的黄毛，破限是酒。

### 使用本地模型

!!! bug

    因为文档作者财力不足，暂时没有和本地运行模型相关的建议。

## 常用前端 - SillyTavern 

SillyTavern（简称 ST，中文俗称酒馆）是一个常用的使用 LLM 进行聊天的界面。

[更多介绍](sillytavern/index.md){ .md-button }
[安装和运行](sillytavern/install.md){ .md-button }
[导入角色](sillytavern/get_char.md){ .md-button }
[导入预设](sillytavern/get_preset.md){ .md-button }
[导入其它文件](sillytavern/get_resource.md){ .md-button }
[开始聊天](sillytavern/chat.md){ .md-button }

[其它常见问题](sillytavern/faq.md){ .md-button }
[官方文档 (英文)](https://docs.sillytavern.app){ .md-button }
[GitHub 仓库](https://github.com/SillyTavern/SillyTavern){ .md-button }

## 其它教程

!!! important 

    因为文档主要的作者没有用过这些教程，所以不负责这些内容的支持服务。
    
    在参照这些教程的时候如果遇到问题，请咨询教程的原始作者，或在注明来源的情况下，询问你的其他朋友。

* [Claude 宝宝教程](https://sqivg8d05rm.feishu.cn/wiki/BBocw85QTiA8EXkNcUZcT2pCnIe) 
  
    由 Discord 服务器「类脑 ΟΔΥΣΣΕΙΑ」的前管理员和部分用户编写。主要以 Clewd 和 Claude 的使用为主。

    飞书需要登录才能复制文档中的内容，除此以外，文档中含有部分非官方渠道的销售链接，注意甄别。