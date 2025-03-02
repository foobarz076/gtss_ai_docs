# SillyTavern 常见问题

!!! tips "好消息，好消息！😃"

    好消息！本文档和各大浏览器均达成了合作，使用 Ctrl-F 即可在页内快速搜索关键词！

!!! tips "提问的智慧"

    你也许在很多地方看到有人提起过这篇文章了，但总体上，
    这篇文章能够教给你如何“正确”的提出一个技术问题，以致于更有可能得到可以解决问题的答案。

    但是，**那篇文章的作者不提供对个别引用的项目的实际支持服务**，因此不要对他们问你在这里遇到的问题，

    > 如果你因寻求某些帮助而阅读本指南，并在离开时还觉得可以从本文作者这里得到直接帮助，那你就是我们之前说的那些傻瓜之一。
    > 别问我们问题，我们只会忽略你。我们在这本指南中想教你如何从那些真正懂得你所遇到的软件或硬件问题的人处取得协助，
    > 而 99% 的情况下那不会是我们。除非你确定本指南的作者之一刚好是你所遇到的问题领域的专家，否则请不要打扰我们，这样大家都会开心一点。

    最后，这篇文章可以在[这里](../../resources/ask.md)阅读。

## 提问之前

### 截图酒馆的报错，或是你遇到的其它问题

假如你认为你的智慧足以把你遇到的问题准确无误的描述出来，那么你应该也有能力自己解决那个问题，也就没有必要提问了。

### 取得终端日志

!!! info "终端是什么？"

    终端是一个基于文本的界面，你可以通过它向计算机发出指令。可以把它想象成一个超级强大的遥控器，或者一个直接和电脑大脑对话的窗口。

    例如你通过 Windows 的批处理脚本运行酒馆时，会打开一个命令提示符或是 PowerShell 窗口。而你在 Termux 运行时首先打开的
    Termux 界面也是个终端窗口。

除了酒馆报错的截图，你最好也把发现错误的当下，终端产生的日志通过截图或文字的形式发送出来，有助于更迅速的定位问题。

??? tips "我如何从终端复制文字？"

    以下是如何在 Windows 命令提示符、Windows 终端和 Termux 中复制文本的方法：

    **Windows 命令提示符**

    在 Windows 命令提示符中，复制文本有几种方法：

    *   **使用鼠标和右键菜单:**
        1.  右键单击命令提示符窗口中的任意位置。
        2.  在弹出的菜单中选择“标记”。
        3.  使用鼠标左键突出显示要复制的文本。
        4.  按 Enter 键复制文本。
        5.  您可以通过右键单击并选择“粘贴”将文本粘贴到任何文本框或文档中。您还可以通过在框内右键单击并选择“粘贴”将其粘贴回命令提示符中。
    *   **使用键盘快捷键:**
        1.  确保启用了键盘快捷键。要执行此操作，请右键单击命令提示符的标题栏，然后选择“属性”。在“选项”选项卡上，选中“启用 Ctrl 键快捷方式”旁边的框。您还可以选中“将 Ctrl + Shift + C / V 用作复制/粘贴”选项。
        2.  使用鼠标或键盘（按住 Shift 键并使用左右箭头键）选择文本。
        3.  按 Ctrl + C 复制文本。
        4.  按 Ctrl + V 粘贴文本。
    * **使用鼠标选择和右键单击：**
        1. 确保已选中“快速编辑模式”。为此，右键单击命令提示符窗口中的任意位置。
        2.  选择“快速编辑模式”。现在，您可以使用鼠标左键突出显示要复制的文本。
        3.  要复制，请右键单击。
        4.  要粘贴，请右键单击命令提示符窗口中的任意位置。

    **Windows 终端**

    Windows 终端提供了多种复制文本的方式：

    *   **使用键盘快捷键:**
        1.  使用鼠标或键盘选择文本。
        2.  按 Ctrl + C 复制文本。
        3.  按 Ctrl + V 粘贴文本。
        4.  您还可以使用 Ctrl + Shift + A 选择所有文本，然后使用 Ctrl + C 复制所有选定的文本。
    *   **右键单击复制/粘贴:**
        1.  启用`copyOnSelect`设置。这将自动将新选择的文本复制到剪贴板。要启用此设置，请打开 Windows 终端设置，转到“交互”选项卡，然后启用“自动将所选内容复制到剪贴板”。
        2.  选择文本。
        3.  右键单击终端以将选定的文本复制并粘贴到您的终端。
    *   **鼠标和滚轮:**
        1.  拖动滚动条中的滑块来选择文本。
        2.  按住 Shift 键，然后单击要复制的文本块的最后一个字符。这将选择整个文本块。
        3.  按 Ctrl + C 复制文本。
    *   **鼠标和Ctrl + Shift:**
        1.  将鼠标移至要复制的文本的开头。
        2.  按住 Ctrl + Shift 键并拖动鼠标以选择文本。
        3.  按“C”复制文本。

    **Termux**

    Termux 在 Android 设备上运行，复制文本的方式与传统桌面环境略有不同：

    *   **使用长按菜单:**
        1.  长按终端屏幕上的某些文本。
        2.  拖动图钉以选择要复制的文本。
        3.  在弹出的菜单中点击“复制”。

!!! warning "不含使用第三方渠道时发生的各种问题"

    如果你用第三方渠道时发生任何问题，首先应该去问卖给你服务的人。

## AI 回复问题

### Gemini

#### Bad Request (400)
现象：

* **The request body is malformed.**
* **Please use a valid role: user,model.**

原因： 

* 酒馆发送给Gemini的数据中出现了不合API格式的数据，例如 user 或 assistant 以外的role。
可行的解决方案： 
* 换用 Gemini 适用的聊天预设，并检查是否需要修改。

现象：

* **User location is not supported for the API use.**
* **Gemini API free tier is not available in your country. Please enable billing on your project in Google AI Studio.**

原因：

* 你的IP位于 Gemini API 不支持的区域（例如中国大陆或香港），或是不提供免费层级的地区（欧洲经济区，英国和瑞士）
可行的解决方案：
* 切换 IP 到支持的国家。
* 去 Google Cloud 绑卡启用结算功能。{--（然后稳定版本就没得嫖咯）--}

#### Permission Denied (403)
现象：

* **Your API key doesn't have the required permissions.**
* **API key not valid. Please pass a valid API key**
* **API key expired. Please renew the API key.**

原因：

* 你输入的 API Key 无效，已过期或是已被删除。
可行的解决方案：
* 去 Google AI Studio 重新申请新的 Key。

现象:

* **Consumer has been suspended.**
* 或是除了 **Forbidden** 之外没有其它输出。

原因： 

* 你的 API Key 关联的 Google Cloud 项目，或是Google Cloud 账号被封禁。
  
可行的解决方案：

* 重新建立新的项目，或是换个Google 账号。

#### Resource has been exhausted / Too Many Requests (429)
现象：

* **Resource has been exhausted**
* **Too Many Requests**
* **The model is overloaded.Pease try later**
  
原因：

* 超过了免费层级的频率限制（对于 Gemini 1.5 Pro ，每分钟2次，每分钟32000Token，每天50次）
* 超过了实验模型的频率限制（每天50次）

可行的解决方案：

* 等
* 调低聊天预设中的上下文 Token 数量。
* 换个模型
* 换个API Key

#### Internal Server Error (500)
现象：

* 酒馆前端的报错只有 Internal Server Error

部分可能的原因：

* 部分实验模型（例如gemini-exp-1121）会在超出速率限制时产生此错误。
* 其它导致此报错的问题很多，具体错误需要查看酒馆控制台报错信息
  
可行的解决方案：

* 重试请求
* 换个模型

#### 空回复或报错
现象:

* **Prompt was blocked due to : OTHER**
* **Prompt was blocked due to : PROHIBITED_CONTENT**

原因：

* 输入被判断为不安全或包含禁止内容
  
可行的解决方案：

* 部分安全过滤器无法关闭，例如CSAM（ 儿童性虐待材料）或PII（个人可识别信息）。
* 打开预设中的缓解输入审查/伪造回复选项

现象：

* **Google AI Studio returned error: Candidate text empty**
* 或者没有报错，但是回复没有内容

原因：
* 输出被判断为不安全或包含禁止内容

可行的解决方案：

* 打开预设中的缓解输出审查选项。

