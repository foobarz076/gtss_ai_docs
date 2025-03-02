# Clewd
Clewd 是一种利用网页版 Claude 发出比网页提供的更具灵活性的请求的方式。需要提前获得 Claude 网页版应用的 Cookie。

!!! info 

    因为主要作者没有用过这种方式，所以可能不常更新这部分文档。

!!! tips

    省流：酒馆是使用 AI 的场所，小克(Claude)是 AI，Clewd 是拐骗良家小克到酒馆的黄毛，破限是酒。

!!! warning "你又多违反了一条 Anthropic 的服务条款 🙃"

    这种方式显然违反 [Anthropic 的 Claude 消费者服务协议](https://www.anthropic.com/legal/consumer-terms)。(3.7 节，禁止以非 Anthropic API 以外的通过机器人、脚本或其他自动或非人工方式访问 Anthropic 服务。) , 当然你越狱和搞颜色其实也违反了 [Claude 的可接受使用政策](https://www.anthropic.com/legal/aup)，因此 Anthropic 可能会封你的 Claude 帐号，

!!! important "开始之前"

    在开始之前，请确认以下事项：

    * 要运行 Clewd 的环境已经安装了 Node.js 和 Git。
    * 你拥有一个注册完毕，可以使用的 Claude 帐号。并获得了一个此帐号的 Cookie。


## 通过 Git 下载 Clewd

克隆 Clewd 的仓库目录：

```bash
$ git clone https://github.com/teralomaniac/clewd.git
```

在 Clewd 的目录里，运行 `npm` 命令安装依赖。你可以忽略 `npm fund` 和 `npm audit` 的警告。（{--反正你也不会修--}）

!!! tips "事情并非能够总是一帆风顺x2"

    因为还是那堵伟大光荣正确的防火墙在给你添堵 🙃

    如果你在运行 `npm` 命令时遇到了任何的网络错误，你可以尝试为 npm 设置替代存储库位置。
    例如淘宝的 `npmmirror`。

    ``` bash
    $ npm config set registry https://registry.npmmirror.com
    ```

```bash
clewd $ npm install
```
```text
added 26 packages, and audited 27 packages in 8s

3 packages are looking for funding
  run `npm fund` for details

2 moderate severity vulnerabilities

To address all issues (including breaking changes), run:
  npm audit fix --force

Run `npm audit` for details.
```

运行 `node clewd.js` ，首次运行时会生成必要的配置文件 `config.js`。

!!! tips

    在 Windows 上，你也可以通过双击 `clewd` 目录中的 `start.bat` 来运行。

```bash
clewd $ node clewd.js
```
```text
config file created!
edit config.js to set your settings and restart the program
```

用你用的顺手的编辑器打开生成的 `config.js` 文件。

* Windows 推荐使用 `Notepad++` 或 `Visual Studio Code`。
* Termux 或其它 Linux 环境的话，推荐使用 `nano` , 或者是你用的顺手的其它编辑器。

```javascript
/*
* https://rentry.org/teralomaniac_clewd
* https://github.com/teralomaniac/clewd
*/

// SET YOUR COOKIE BELOW

module.exports = {
    // 如果你只有一个 Cookie，那么把 SET YOUR COOKIE HERE 换成你获得的 Cookie,
    // 形如 sessionKey=sk 开头的一串。
    "Cookie": "SET YOUR COOKIE HERE",
    // 如果你有好几个 Cookie, 那么每行一个的填进 CookieArray 数组里。
    "CookieArray": [
        "sessionKey=sk-ant-sid01...",
        "sessionKey=sk-ant-sid01..."
    ],
    "WastedCookie": [],
    "unknownModels": [],
    "Cookiecounter": 3,
    "CookieIndex": 0,
    "ProxyPassword": "",
    "Ip": "127.0.0.1",
    "Port": 8444,
    "localtunnel": false,
    "BufferSize": 1,
    "SystemInterval": 3,
    "rProxy": "",
    "api_rProxy": "",
    "placeholder_token": "",
    "placeholder_byte": "",
    "PromptExperimentFirst": "",
    "PromptExperimentNext": "",
    "PersonalityFormat": "{{char}}'s personality: {{personality}}",
    "ScenarioFormat": "Dialogue scenario: {{scenario}}",
    "Settings": {
        "RenewAlways": true,
        "RetryRegenerate": false,
        "PromptExperiments": true,
        "SystemExperiments": true,
        "PreventImperson": true,
        "AllSamples": false,
        "NoSamples": false,
        "StripAssistant": false,
        "StripHuman": false,
        "PassParams": false,
        "ClearFlags": true,
        "PreserveChats": false,
        "LogMessages": true,
        "FullColon": true,
        "padtxt": "1000,1000,15000",
        "xmlPlot": true,
        "SkipRestricted": false,
        "Artifacts": false,
        // 如果你遇到了 [message]: 'spawn Unknown system error -8' 错误（已知 Termux 中会发生），
        // 请把这行的 true 改成 false 以关闭预读取。
        "Superfetch": true
    }
}

/*
 BufferSize
 * How many characters will be buffered before the AI types once
 * lower = less chance of `PreventImperson` working properly

 ---

 SystemInterval
 * How many messages until `SystemExperiments alternates`

 ---

 Other settings
 * https://gitgud.io/ahsk/clewd/#defaults
 * and
 * https://gitgud.io/ahsk/clewd/-/blob/master/CHANGELOG.md
 */
```

稍后你就可以运行了：

```bash
Clewd $ bash start.sh
```
```text title="这是输出"
up to date in 418ms
clewd修改版 v4.8(11) by tera
http://127.0.0.1:8144/v1

AllSamples: false
Artifacts: false
ClearFlags: true
FullColon: true
LogMessages: true
NoSamples: false
PassParams: true
PreserveChats: true
PreventImperson: true
PromptExperiments: true
RenewAlways: true
RetryRegenerate: false
SkipRestricted: false
StripAssistant: false
StripHuman: false
Superfetch: true
SystemExperiments: true
padtxt: 1000,1000,15000
xmlPlot: true

superfetch [found] bin/clewd-superfetch-linux-amd64

(index: 1) Logged in {
  name: 'xxxxxxxx',
  mail: 'xxxxxxxx@gmail.com',
  cookieModel: 'claude-3-5-sonnet-20241022',
  capabilities: [ 'claude_pro', 'chat', [length]: 2 ]
}
```
## 附： Clewd 的设置列表

!!! info

    这就是 `config.js` 中的 "Settings" 块内的选项。

    大多数情况下，如果你看不懂下面这些是什么意思，你就不需要修改这些设置。

### SettingName: (DEFAULT)/opt1/opt2...

 - `Superfetch`: (true)/false
    * true will use an alternate method to get past the `We are unable to serve your request` error
    * false won't use this method and you may get the error again

 - `PreventImperson`: (true)/false
    * true trims the bot reply immediately if he says "Human:", "Assistant:", "H:" or "A:"
    * making it so it doesn't hallucinate speaking as you __(chance of missing some spicy things)__

 - `PromptExperiments`: (true)/false
    * true is an alternative way to send your prompt to the AI
    * experiment before setting to false
	* incompatible with `RenewAlways` set to false

 - `RetryRegenerate`: (false)/true
    * true uses the AI's own retry mechanism when you regenerate on your frontend
    * instead of a new conversation
    * experiment with it

 - `SystemExperiments`: (true)/false
    * only has any effect when `RenewAlways` is false
    * true alternates between Main+Jailbreak+User and Jailbreak+User
    * false doesn't alternate

 - `RenewAlways`: (true)/false
    * true makes a new conversation context each time
    * false *tries* to reutilize the same old conversation, sending only the actual last message each time, taking into consideration `SystemExperiments` (will not work properly unless your Main is the first system prompt and your Jailbreak is the last)

 - `StripAssistant`: (false)/true
    * true strips the "Assistant:" prefix from the last assistant message (if it's the last message)

 - `StripHuman`: (false)/true
    * true strips the "Human:" prefix from the last human message (if it's the last message)

 - `AllSamples`: (false)/true
    * mutually exclusive with `NoSamples`
    * true converts all real dialogues to "sample dialogues" (except the last Assistant and Human messages)
    * you're "H" and the AI is "A"
    * whatever the AI replies with is kept (only outgoing)
    * [see this](https://docs.anthropic.com/claude/docs/prompt-troubleshooting-checklist#the-prompt-is-formatted-correctly) for more information
    - Human->H
    - Assistant->A

 - `NoSamples`: (false)/true
    * mutually exclusive with `AllSamples`
    * true converts all "sample dialogues" to real dialogues
    * you're "Human" and the AI is "Assistant"
    * whatever the AI replies with is kept (only outgoing)
    * [see this](https://docs.anthropic.com/claude/docs/prompt-troubleshooting-checklist#the-prompt-is-formatted-correctly) for more information
    - H->Human
    - A->Assistant
	
 - `LogMessages`: (false)/true
    * true logs prompt and reply to `log.txt`

 - `ClearFlags`: (false)/true
    * possibly snake-oil
    * clears your warnings

 - `PassParams`: (false)/true
    * true will send the temperature you set on your frontend
    * only values under <=1.0 >= 0.1
    * this could get your account banned
    * if clewd stops working, set to false

 - `PreserveChats`: (false)/true
    * true prevents the deletion of old chats at any point

