# SillyTavern 云端部署：从零开始的 VPS 与域名搭建指南

嘿，朋友！欢迎来到这篇有点“技术范儿”但绝对轻松愉快的指南。你是不是也想把心爱的 SillyTavern 部署到云端，随时随地都能和你的 AI 伙伴畅聊，而且还想确保这一切既安全又稳定？那么，你来对地方了！

这篇指南会像一位耐心的老朋友一样，手把手带你走过从购买第一台虚拟服务器（VPS）和拥有自己的域名，到最终成功搭建并加固 SillyTavern 的全过程。

别担心那些看起来高深莫测的技术名词，我们会用最容易理解的方式解释它们。准备好了吗？带上你的好奇心和一点点耐心，让我们一起开启这段激动人心的云端之旅吧！

!!! important "开始之前"

    如果你有云端部署的需求，那你应该已经有了一个在本地运行的 SillyTavern 实例。因此你应该已经知道了如何安装和使用它。不过如果你想复习以下的话：

    [详细步骤](../install.md){ .md-button }

!!! important "额外所需的基础知识"

    在开始之前，记得阅读另外两篇基础知识条目：
    
    [域名和DNS相关的基础知识](../../../basic/domain.md){ .md-button }
    [OpenSSH 相关的基础知识](../../../basic/ssh.md){ .md-button }

## 第一站：为何要给 SillyTavern “上锁”？—— 用户验证与安全

想象一下，你把家门钥匙随便放在门口的地垫下，是不是有点心惊胆战？同样地，将 SillyTavern 暴露在开放的互联网上，却不做任何安全防护，也是非常危险的 。

!!! danger "没好好做安全防护，可能会导致（包括或不限于）以下问题："

    * **API 密钥泄露：** SillyTavern 需要连接各种 AI 服务（比如 OpenAI、Anthropic 等），这些连接通常需要 API 密钥。如果你的 SillyTavern 实例没有任何保护，任何人发现它的地址后，都能轻易访问，进而可能窃取这些宝贵的 API 密钥。一旦密钥落入坏人手中，他们就可以滥用你的额度，造成经济损失，甚至用你的身份进行非法活动 。（特别是你为了方便，允许在前端展示 API 密钥的情况下）
    * **设置被篡改与恶意扩展注入：** 不设防的 SillyTavern 就像一个不设防的后台。攻击者可以随意修改你的设置，更糟糕的是，他们可能会注入恶意的扩展程序。虽然具体的恶意扩展示例链接 当前无法访问，但想象一下，一个扩展突然让你的 AI 伙伴发出刺耳噪音，或者在后台偷偷做坏事，这绝对不是你想要的。保护实例就是保护自己免受这类骚扰和潜在危害。
    * **非授权访问：** 最直接的风险就是，任何人都能连接到你的 SillyTavern，查看你的聊天记录、角色卡，甚至冒充你与 AI 互动 。


为了防止这些风险，SillyTavern 官方强烈建议设置用户验证 。这就像给你的家门装上一把坚固的锁。常见的验证方式包括：

- **HTTP 基础认证 (HTTP Basic Authentication):** 这是最简单的一种方式，访问时需要输入用户名和密码。
- **SillyTavern 多用户模式 (Multi-user Mode):** 这是一个更完善的方案，允许多个用户拥有各自独立的设置、聊天记录和角色。每个用户可以设置自己的密码，实现基本的隐私隔离 。

!!! warning "如果没有有效的 HTTPS 保护，这两种方式都不能提供真正的安全性。"

    如果没有 HTTPS 加持，用户名和密码会以明文形式在网络上传输，容易被窃听 。而且，HTTP 基础认证模式没有内置的防护机制来阻止“暴力破解”（就是不断尝试密码）。

    因此，无论是哪种用户验证方式，都强烈依赖 HTTPS 提供的安全性。HTTPS (HyperText Transfer Protocol Secure) 是一种通过加密来保护网络通信的协议。它能确保：

    - **数据加密：** 你和服务器之间传输的数据（包括登录凭据、API 密钥、聊天内容）都被加密，第三方即使截获了数据也无法读懂 。
    - **身份验证：** HTTPS 证书可以证明你连接的确实是你想要连接的服务器，而不是一个伪装的假冒者。

    没有 HTTPS，你的登录凭据就像是在大街上喊出来一样，毫无秘密可言 。因此，要实现安全的用户验证，HTTPS 是必不可少的一环。

!!! warning "SillyTavern 的多用户模式并不能提供其它隔离和保护"

    因为用户的数据（包括设置、API 密钥、聊天记录、角色等等）是未加密存储在服务器上的。因此同一个 SillyTavern 示例上的管理员用户，或拥有服务器 SSH 访问权限的用户，都可以直接访问到所有用户的数据。

    如果你在和其它人共用实例，请把这个问题考虑在内。（你也不想你的朋友偷偷查看你的聊天记录吧？）

## 第二站：域名的魔力 —— 为何需要它？

你可能会问：“我只是想远程访问我的 SillyTavern，为什么还需要一个域名呢？” 问得好！答案就藏在上一节我们强调的 HTTPS 里。

要让浏览器信任你的 HTTPS 连接，你需要一个由受信任的证书颁发机构（CA，Certificate Authority）签发的 SSL/TLS 证书。这些机构（比如 Let's Encrypt）在颁发证书时，需要验证你确实拥有对这个域名的控制权。它们（通常）不会给一个光秃秃的 IP 地址颁发广泛信任的证书。

所以，流程是这样的：

1. **你需要 HTTPS** 来加密通信，保护用户验证凭据和 API 密钥 。
2. **你需要 SSL/TLS 证书** 来启用 HTTPS。
3. **你需要一个域名** 来获取受信任的 SSL/TLS 证书。

拥有一个域名，就像给你的云端 SillyTavern 安上了一个正式的门牌号，这样证书颁发机构才能确认“哦，这确实是你的地盘”，然后给你颁发“安全认证”（SSL/TLS 证书）。有了这个认证，浏览器才会放心地建立加密连接，你的小秘密才不会被偷窥。

同理自签名的证书也是不行的，因为浏览器不会信任它们。自签名证书就像是你自己在家里打印的身份证，别人可不一定认得。

## 第三站：域名大采购 —— 拥有你的专属网址

现在我们知道了域名的重要性，是时候去挑选一个属于你自己的网址了！购买域名就像在网上给自己注册一个独一无二的名字。

[更多细节](../../../basic/domain.md){ .md-button }

!!! note "再快速复习一下域名的选择"

    - 有没有长期使用的打算？如果只是临时用用，可能不需要买（首年或续费）太贵的域名。
    - 你是否已经在使用一些服务？例如假如你已经在用 Cloudflare ，那么你可以直接在 Cloudflare 上购买域名，省去后续的 DNS 设置步骤。
    - 留意特定的后缀（TLD）是否有额外的限制或要求，比如限制注册人国籍，注册时间，或者要求正确的配置 HTTPS 证书等。

!!! success "里程碑达成！"

    恭喜你，现在拥有了自己的互联网门牌号！这是搭建云端服务的重要一步。下一步，我们要为这个门牌号找一个“家”——虚拟服务器。

## 第四站：寻找云端小窝 —— 购买 VPS

VPS，全称 Virtual Private Server（虚拟专用服务器），就像是在一台大型物理服务器上划分出来的一个个独立的小空间。每个 VPS 都有自己独立的操作系统、资源（CPU、内存、硬盘）和 IP 地址，你可以像操作一台真实的电脑一样完全控制它。对于运行 SillyTavern 这样的应用来说，VPS 是一个性价比很高的选择 。

!!! info "这是考虑性价比的选择"

    一些云计算平台提供的应用服务（如 Azure App Service、AWS Lambda 等）能够更加简单的提供预配置的环境（帮你搞定前面的那一堆问题），唯一的问题是价格通常会比 VPS 高出不少。

    如果你依然十分敏感价格，那么找几个信任的朋友一起分摊 VPS 的费用也是一个不错的选择。只要确保你们之间有良好的信任关系，并且都了解如何安全地使用和管理这个 VPS。

#### 选择 VPS 提供商

市面上有很多 VPS 提供商，各有优劣。一些常见的选择包括：

!!! warning "不构成作者对它们的推荐或背书"

    * 如果你不轻易相信一面之词，可以上网搜索，或者在各种社区查看用户的评价和反馈。
    * 此外，本文档的作者并不对这些提供商的服务质量或安全性做任何保证。也难以有效的回答你对它们的任何问题。

- **Linode (现 Akamai):** 老牌提供商，性能稳定，文档丰富 。（唯一可能需要考虑的因素是只支持信用卡或 PayPal 付款）
- **DigitalOcean:** 以简洁、开发者友好著称 。
- **Vultr:** 提供全球多个地点的服务器，价格有竞争力 。
- **BandwagonHost:** 价格有高有低（网络连接有优化的会贵一些），部分基础套餐提供年付折扣 。
- **Hetzner 和 Netcup:** 两家德国的 VPS 提供商，价格便宜，性能不错 。(对于这个需求，一个美中不足的问题会是，位于德国会导致你无法”白嫖“到 Gemini 的 API)

!!! important "在这个需求上，你大约首先还需要注意 VPS 的物理位置"

    OpenAI、Anthropic (Claude)、Google AI (Vertex AI / Gemini API) 等主流 AI 服务对其 API 的使用有地理区域限制，你需要确保你购买的 VPS **物理位置** 位于这些服务的**支持区域内**。

    总体来说：

    * 首先**避免**购买位于中国大陆、香港和俄罗斯的 VPS（因为这些地区的 AI 服务通常不支持）。
    * 如果你主力使用的 AI 是 Gemini，并且需要免费层级的话，避开欧洲经济区、英国和瑞士（因为这些地区的 Gemini API 也不支持免费层级）。
    * 剩下能够提供 VPS 的流行区域一般就没问题了，例如美国、日本、新加坡等等。

!!! note "其它你可能能会考虑的因素"

    - **操作系统:** 推荐选择流行且稳定的 Linux 发行版（本文档会以 Debian 为例），社区支持良好。以及很多时候 Windows Server 需要单独授权，价格也会高出不少。
    - **配置 (CPU, RAM, 存储):** 对于 SillyTavern，初始配置不必太高。通常 1-2 vCPU、1-2GB RAM、20-30GB SSD 存储就足够开始了。（主流 VPS 提供商的 5$ 方案大约都是这样的配置）。如果感觉卡顿或需要运行更多服务，可以随时升级。
    - **带宽/流量:** 注意提供商的月流量限制。对于聊天应用，流量消耗一般不大。
    - **价格:** 对比不同提供商相同配置的价格。注意是否有隐藏费用或续费价格变化。
    - **控制面板:** 大多数 VPS 提供商会提供一个网页控制面板，用于管理 VPS（启动、停止、重启、重装系统、查看资源使用情况等）。控制面板提供基础的功能就足够了，因为我们主要通过 SSH 来管理服务器。

    对了，以上的配置需求都是以你目前只会运行 SillyTavern 为前提的。如果你打算在同一台 VPS 上运行其它服务（比如数据库、反向代理、文件存储等），那么你可能需要更高的配置。

所以，一个典型的 VPS 购买流程大致如下：

1. 选择 VPS 提供商和套餐。
2. 选择服务器的**物理位置**（确保在 AI 服务支持区域内！）。
3. 选择操作系统（推荐 Debian 最新稳定版）。
4. 配置服务器选项（如 SSH 密钥、主机名等，有些可以在购买后设置）。
5. 完成支付。
6. 等待 VPS 实例创建完成。通常几分钟内就好。
7. 提供商会通过邮件或在控制面板提供 VPS 的 IP 地址、初始 root 密码（或告知需要通过控制台设置/重置）。

!!! success "里程碑达成！"

    你现在拥有了一台属于自己的云服务器，它正静静地等待着你的指令。接下来，我们要让你的域名指向这台服务器。

## 第五站：域名指路 —— DNS 设置

现在，你有了域名（门牌号）和 VPS（家），我们需要告诉互联网，当有人访问你的域名时，应该去哪里找你的 VPS。这个“指路”的工作就是通过 DNS（Domain Name System，域名系统）来完成的。

!!! note "我们首先来设置 A/AAAA 记录"

    DNS 系统中有很多种记录类型，用于不同的目的。我们现在最关心的是 **A 记录 (Address Record)**。A 记录的作用非常简单：**将一个域名（或子域名）指向一个 IPv4 地址** 。
    如果你的 VPS 有 IPv6 地址，也可以设置 **AAAA 记录**，它的作用和 A 记录类似，只不过是将域名指向一个 IPv6 地址。

你需要回到你购买**域名**的地方（域名注册商的管理后台），而不是 VPS 提供商那里。

1. **登录域名注册商后台：** 找到你购买的域名。
2. **进入 DNS 管理界面：** 查找类似 “DNS Management”、“Manage DNS Zone”、“域名解析” 或 “Nameserver Settings” 的选项 。
3. **找到 A 记录设置：** 你可能会看到一个已有的 DNS 记录列表。你需要添加或修改 A 记录。
4. **配置 A 记录：**
    - **主机记录 (Host/Name):**
        - 如果你想让 `barz.foo` (根域) 指向你的 VPS，通常输入 `@` 或者留空（具体看注册商的要求）。
        - 如果你想用一个子域名，比如 `sillytavern.barz.foo`，就在这里输入 `sillytavern`。
    - **记录类型 (Type):** 选择 `A` 。
    - **记录值 (Value/Points to/Address):** 输入你的 **VPS 的公网 IPv4 地址** 。这个地址在你购买 VPS 后会得到。
    - **TTL (Time To Live):** 通常保持默认值即可（比如 秒或 小时）。TTL 表示 DNS 解析结果可以在缓存中保留多久。对于 Cloudflare DNS 的话，保持默认的“自动”即可。
5. **保存更改：** 确认无误后保存设置。

!!! note "接下来，只需要等……"

    DNS 更改不是立即在全球生效的，需要一段时间让全球的 DNS 服务器更新缓存，这个过程称为 DNS 传播 。通常需要几分钟到几小时，极端情况下可能长达-48 小时 。

    - **等待一段时间后**，你可以使用本地电脑的命令行工具 `ping barz.foo` 或 `ping sillytavern.barz.foo`，看看返回的 IP 地址是否是你 VPS 的 IP 地址 。
    - 也可以使用在线的 DNS 检测工具（如 `dnschecker.org` 或 `whatsmydns.net`）来查看全球不同地点的 DNS 解析情况 。

!!! success "里程碑达成！"

    你已经成功地将你的域名指向了你的 VPS。现在，当人们在浏览器中输入你的域名时，互联网就知道该去敲哪台服务器的门了。接下来，我们要正式进入服务器内部，开始我们的搭建工作！

## 第六站：进入服务器内部 —— SSH 连接与用户设置

现在是时候登录到你新购买的 VPS，进行一些基础设置了。我们将使用 SSH（Secure Shell）协议来远程连接服务器。SSH 提供了一个加密的命令行通道，让你可以在本地电脑上安全地操作远程服务器 。

通过 SSH 连接到 VPS 的方法可以在这里复习：

[玩转 SSH：你的第一份远程连接指南](../../../basic/ssh.md){ .md-button }

那么现在，在你成功的连接到了 VPS 之后，你会看到一个命令行界面，通常是这样的：

```bash
root@your_vps_ip:~#
```

!!! note "本页中的终端操作提示"

    - 在本页中，以"`#`" 开头的命令表示需要以 `root` 用户身份执行的命令。我们省略了 `sudo` 前缀，但建议你在执行这些命令时，还是使用 `sudo` 来提升权限。
    - 以"`$`" 开头的命令表示可作为以普通用户身份执行的命令。
    - 你在复制这些命令的时候，不需要包含提示符（`#` 或 `$`），只需要复制命令部分即可。

#### 安全第一：创建普通用户并赋予 Sudo 权限

!!! info "你不一定需要自己创建用户"

    一些 VPS 提供商会在为你初装系统时提供一个默认的非 root 用户（比如 `admin` 或 `debian`），你可以直接使用这个用户登录。

    但如果没有，或者你想创建一个新的用户，那么请继续往下看。

直接使用 `root` 用户操作服务器是非常危险的 。`root` 用户拥有系统的最高权限，任何一个小失误都可能导致严重后果。而且，`root` 账户是黑客攻击的首要目标 。

更安全的做法是创建一个普通的、非 root 用户，并只在需要执行管理员任务时，通过 `sudo` (superuser do) 命令临时提升权限 。这遵循了“最小权限原则”——平时用最低权限工作，只在必要时才使用更高权限，大大降低了风险和潜在的破坏范围 。同时，`sudo` 的使用通常会被记录下来，方便审计追踪 。

**步骤如下：**

* **安装 sudo,如果没有的话：** 
   在 Debian （和大部分 GNU/Linux发行版）上，`sudo` 通常是预装的。如果没有（例如 Debian 的安装程序中，如果为 root 用户设置了密码，那么就不会安装 sudo），可以通过以下命令安装：
    
```bash
# apt update
# apt install sudo
```

* **创建新用户：** 
以 `root` 用户身份运行以下命令，将 `foo` 替换为你想要创建的用户名（比如 `sillyadmin`）：
    
```bash
# adduser foo
```
    
* **设置密码和信息：** 
系统会提示你为新用户设置一个**足够强的密码**，并确认。之后会询问一些用户信息（全名、房间号等），这些都是可选的，可以直接按 Enter 跳过 。最后确认信息无误。

* **添加到拥有 sudo 权限的用户组：**
在示例中的 Debian 中，将用户添加到 `sudo` 用户组是授予其 `sudo` 权限的标准方法 。运行以下命令：
        
```
# usermod -aG sudo foo
```
    
!!! tip 

    - `usermod`: 修改用户账户的命令。
    - `-aG`: `-a` 表示追加（append），`-G` 表示指定要加入的附加组（groups）。这个组合意味着将用户添加到指定的组，同时保留其已有的组成员身份 。
    - `sudo`: 要加入的目标组名。
    - `foo`: 你刚刚创建的用户名。

!!! tip "sudo 的作用并不止于此"

    通过稍微复杂的配置，`sudo` 还可以实现更细粒度的权限控制，比如允许某个用户执行特定的命令而不需要密码，或者限制某些命令只能由特定用户执行。具体的配置方法可以参考 [sudo 的官方文档](https://www.sudo.ws/docs)

* **切换到新用户：**

现在，退出当前的 `root` SSH 会话，然后，使用你**新创建的用户名**重新登录 SSH：

``` bash
$ ssh foo@YOUR_SERVER_IP
```

输入你为新用户设置的密码。

* **测试 Sudo 权限：**

登录后，尝试执行一个需要管理员权限的命令，比如更新软件包列表，并在命令前加上 `sudo`：

```bash
$ sudo apt update
```

系统会提示你输入 `[sudo] password for foo:`。注意，这里需要输入的是你当前登录用户（foo）的密码，而不是 root 密码 。

如果命令成功执行（开始更新软件包列表），那么恭喜你！你的新用户已经配置好了 `sudo` 权限。

!!! quote "sudo 第一次询问你的密码时的提示已经告诉你，你接下来需要注意些什么了。"

    > We trust you have received the usual lecture from the local System Administrator. It usually boils down to these three things:
    >
    > \#1) Respect the privacy of others.
    >
    > \#2) Think before you type.
    > 
    > \#3) With great power comes great responsibility.
     
    > 我们相信你已经收到了来自本地系统管理员的常规讲座。通常可以归结为以下三点：
    >
    > \#1) 尊重他人的隐私。
    > 
    > \#2) 在输入之前先思考。
    >
    > \#3) 权力越大，责任越大。

!!! success "里程碑达成！"

    你已经成功创建了一个安全的非 root 用户，并学会了如何使用 `sudo` 来执行管理任务。这是保障服务器安全的基础，也是后续所有操作推荐使用的账户。从现在开始，除非特别说明，我们都将使用这个带有 `sudo` 权限的普通用户进行操作。

## 第七站：加固城门 —— 强化 SSH 安全

我们已经创建了普通用户，但这扇通往服务器的大门——SSH 服务本身，还可以变得更坚固。默认的 SSH 配置虽然能用，但可以进行一些调整，大大增加攻击者入侵的难度。这就像给你的门不仅上了锁，还加装了防盗链和猫眼。

!!! tip

    上面多次提起的 SSH 基础知识指南中已经包含了强化 SSH 的相关内容。因此这里只介绍最后一步，在（服务器）本地禁用 root 登录。

### 禁用 root 用户登录

除了 sshd 配置文件中的 `PermitRootLogin` 选项外，你也许还需要通过 `passwd` 命令来禁用 root 用户的密码登录，以及普通用户可以通过 `su` 切换到 root 用户。

```bash
# passwd -l root
```
这条命令会锁定 root 用户的密码，禁止任何人使用密码登录 root 用户。

如果日后你需要使用 root 用户登录，你可以通过以下命令解锁：

```bash
$ sudo passwd -u root
```
这条命令会为 root 用户重设密码，同时允许用户使用 `su` 切换到 root 用户。（是否可以通过 ssh 登录 root 用户，取决于 sshd 的配置）

### 验证你的成果

- 尝试用密码登录你的普通用户 (`ssh foo@YOUR_SERVER_IP`)，应该会失败并提示类似 `Permission denied (publickey)` 的信息。
- 尝试用 `root` 用户登录 (`ssh root@YOUR_SERVER_IP`)，无论用密码还是（如果之前设置过）密钥，都应该直接被拒绝 。
- 在以普通用户身份登录后，尝试使用 `su` 切换到 root 用户，应该会提示 `Authentication failure`。

!!! success "里程碑达成！"

    在这些安全措施的加固下，你的 SSH 大门现在固若金汤！只有拥有对应私钥的人才能通过 `foo` 登录，而且 `root` 用户被彻底挡在了门外。这是保障服务器安全非常重要的一步。

    现在，我们的服务器基础环境已经准备就绪且相对安全，是时候请出今天的主角——SillyTavern 了！

## 第八站：安装大作战 —— 选择你的道路

激动人心的时刻到了！基础打牢，城门加固，现在我们要正式请 SillyTavern 入驻我们云端的小窝了。不过，通往成功的道路不止一条。摆在你面前的有两种主流选择：

1. **Docker 魔法阵 (通过 Docker 安装):** 使用容器化技术，将 SillyTavern 及其所有依赖（比如特定版本的 Node.js）打包在一个隔离的“魔法盒子”（容器）里运行。通常更简单、更干净，更新也可能更容易。
2. **裸机硬核流 (直接安装 Node.js):** 直接在你的 VPS 操作系统（Debian）上安装 SillyTavern 所需的一切软件（Node.js, npm, Git），让它直接在服务器上运行。可能稍微节省一点点系统资源，但需要你手动管理更多细节。

!!! failure "为什么不使用更加简单的综合面板，例如宝塔或1panel？"

    这些面板通常会在系统上安装很多额外的服务和软件，可能会导致不必要的资源占用和安全隐患。而且它们的配置和管理方式与 SillyTavern 的要求不太一致，可能会增加额外的复杂性。

    换而言之，如果你学会了这两种部署方式之一，即使未来你想偷懒用回面板，至少你也能知道它们在做什么，但是反过来可救不一定咯。

这里有一个简单的对比，帮你快速找到适合自己的路：

|   |   |   |
|---|---|---|
|**特性**|**Docker 魔法阵 (推荐新手)**|**裸机硬核流**|
|**安装简易度**|较高 (主要配置 Compose 文件)|中等 (需手动安装 Node.js 等)|
|**依赖管理**|自动 (Docker 镜像包含所有依赖)|手动 (需自行安装和管理 Node.js)|
|**环境隔离**|强 (应用运行在独立容器内)|弱 (应用直接运行在宿主系统)|
|**资源占用**|略高 (Docker 引擎本身有开销)|略低 (无 Docker 额外开销)|
|**更新维护**|可能更简单 (更新 Docker 镜像)|可能较繁琐 (需更新 Node.js/应用)|
|**灵活性/控制力**|中等 (通过 Compose 文件控制)|高 (直接控制所有文件和进程)|

**简单来说：**

- 如果你追求**简单快捷、省心省力**，或者对 Linux 系统管理不太熟悉，**Docker 魔法阵**是你的不二之选 。它能帮你规避很多环境配置的坑。
- 如果你是**资源敏感型选手**，希望榨干 VPS 的每一滴性能，或者喜欢**完全掌控**每一个细节，并且不介意多一些手动操作，那么**裸机硬核流**可能更合你胃口。

两条路都能通向成功运行的 SillyTavern。根据你的偏好和技术背景，选择一条开始冒险吧！接下来的两章将分别详细介绍这两种路径的操作步骤。你可以选择其中一条，或者如果你有时间和兴趣，也可以尝试两种方式，看看哪种更适合你。

!!! note "在开始之前，请确保你已经完成了前面-7 站的所有步骤"

    这包括购买 VPS、设置 SSH 连接、创建普通用户、配置 SSH 安全等。

    然后，无论你是否使用 Docker，你都应该先把 Git 安装好。因为我们需要用它来下载 SillyTavern 的代码。

## 第九站：路径一 —— Docker 魔法阵 (轻松部署)

选择了 Docker 这条路？明智的选择！Docker 就像一个收纳大师，能把 SillyTavern 和它需要的所有小零件（比如特定版本的 Node.js）整整齐齐地打包在一个叫做“容器”的盒子里。我们只需要管理这个盒子，省去了很多配置环境的麻烦。

### **安装 Docker 和 Docker Compose**

我们需要安装 Docker 引擎本身，以及 Docker Compose 工具（用来通过一个配置文件管理我们的 SillyTavern 和 Caddy 容器）。推荐使用 Docker 官方仓库来获取最新版本。

!!! quote 

    官方文档位于 https://docs.docker.com/engine/install/debian/ 。

- **更新软件包列表：**
    
```bash
# apt update
```
    
- **安装必要的依赖包：** 允许 `apt` 通过 HTTPS 使用仓库。
    
```bash
# apt install apt-transport-https ca-certificates curl gnupg lsb-release -y
```
    
- **添加 Docker 官方 GPG 密钥：** 验证软件包的真实性。
    
```bash
# install -m 0755 -d /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# chmod a+r /etc/apt/keyrings/docker.gpg
```
    
   
- **设置 Docker 的 APT 仓库：** 告诉 `apt` 去哪里下载 Docker。
    
```bash
# echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
    
- **再次更新软件包列表并安装 Docker：**
    
```bash
# apt update
# apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```
    
这会安装 Docker 引擎、命令行工具、containerd 运行时以及 Docker Compose 插件。

- **验证 Docker 是否安装成功：** 运行一个简单的测试镜像。
    
```bash
# docker run hello-world
```
    
如果看到 "Hello from Docker!" 的消息，说明 Docker 已经正常工作了！

- **(可选) 将你的用户添加到 `docker` 组：** 
    
!!! warning "这一步有已知的安全隐患"

    将用户添加到 `docker` 组后，因为 Docker Daemon 运行在 root 权限下，任何可以访问 Docker 的用户都可以通过 Docker 以 root 权限执行命令。这可能会导致安全隐患，尤其是在多用户环境中。

    如果你在一个多用户的 VPS 上，或者不想给普通用户过多权限，建议跳过这一步，继续使用 `sudo docker` 来运行 Docker 命令。

    但如果你评估了安全风险之后，认为少输入一些 `sudo` 命令是值得的，那么可以继续执行这一步。

```bash
# gapsswd -aG docker foo
```

### **获取 SillyTavern 代码**

我们需要把 SillyTavern 的程序文件下载到服务器上，Docker 会用到其中的一些配置文件和数据目录。
    
```bash
$ git clone https://github.com/SillyTavern/SillyTavern.git 
$ cd SillyTavern/docker
```
    
- 如果你想使用开发中的 `staging` 分支，可以使用 `git clone https://github.com/SillyTavern/SillyTavern.git -b staging.` 。默认克隆的是 `release` 分支。

### **配置 Docker Compose (docker-compose.yml)**

这是 Docker 魔法的核心！我们将创建一个 `docker-compose.yml` 文件来告诉 Docker 如何运行 SillyTavern 和 Caddy。

!!! info "你也许需要修改（而不是创建）这个文件"

    更新的仓库里已经包含了一个 `docker-compose.yml` 文件（在 `docker` 目录里），它只包含了 SillyTavern 的配置。我们接下来会在这个文件的基础上进行修改，添加 Caddy 的配置。

    如果什么时候出错了，你可以通过 `git restore` 命令来恢复到仓库中的版本。

```bash
# 这里用的是 nano ，你也可以用 vim 或者其他你喜欢的编辑器
SillyTavern/docker $ nano docker-compose.yml
```

然后，粘贴以下内容（请仔细阅读注释并根据需要调整）：

```yaml
services:
  # SillyTavern 服务
  # 服务的名称会在各处使用，例如控制单个服务，在网络中连接到其它容器等等。
  sillytavern:
    # 使用 Dockerfile 构建 SillyTavern 镜像，在你对代码进行修改时非常有用
    build: ..
    # 容器的名称和主机名
    container_name: sillytavern
    hostname: sillytavern
    # 使用 SillyTavern 的最新 Docker 镜像
    # 如果你想使用开发中的 staging 分支，可以使用 ghcr.io/sillytavern/sillytavern:staging
    # 如果你想使用特定的版本，可以使用 ghcr.io/sillytavern/sillytavern:版本号
    image: ghcr.io/sillytavern/sillytavern:latest
    # 一些环境变量
    environment:
      # 设置 Node 运行在生产模式，可以在一定程度上提高性能
      # 如果你需要调试，可以设置为 development
      - NODE_ENV=production
      # 强制终端使用彩色输出
      # 这在某些情况下可能会有用，比如在 Docker 日志中查看输出
      - FORCE_COLOR=1
    # 映射端口
    # 8000 是 SillyTavern 的默认端口
    ports:
      # 映射的写法为 "宿主机IP:宿主机端口:容器端口"
      # 如果映射到宿主机的 0.0.0.0 （所有 IP 地址），则可以省略宿主机 IP
      # 因为我们接下来使用 Caddy 作为反向代理，所以这里只需要映射到 localhost 即可。
      - "127.0.0.1:8000:8000"
    # 映射的目录
    # 这里的路径是相对于 docker-compose.yml 文件所在的目录
    volumes:
      # 映射的写法为 "宿主机目录:容器目录"
      # 容器目录一般已经在 Dockerfile 中定义好了, 根据需要宿主机的来源目录即可
      # 这是配置文件
      - "./config:/home/node/app/config"
      # 这是数据
      - "./data:/home/node/app/data"
      # 这是插件
      - "./plugins:/home/node/app/plugins"
      # 这是第三方扩展
      - "./extensions:/home/node/app/public/scripts/extensions/third-party"
    # 重启策略，这是只在容器异常退出时重启
    # 如果你希望容器在任何情况下都重启，可以使用 always
    restart: unless-stopped

  # Caddy 服务
  # Caddy 是一个强大的反向代理服务器，支持自动申请和续签 SSL 证书
  # 它会将所有请求转发到 SillyTavern 服务。
  caddy:
    container_name: caddy
    image: caddy:latest # 使用官方最新的 Caddy 镜像
    ports:
      # 暴露 和 端口到公网，用于 Caddy 接收外部流量和进行 HTTPS 证书申请
      - "80:80"
      - "443:443"
      - "443:443/udp" # 支持 HTTP/3
    volumes:
      # 将宿主机的 Caddyfile 挂载到容器内 Caddy 的配置路径
      - ./caddy/Caddyfile:/etc/caddy/Caddyfile
      # 持久化 Caddy 的状态数据（主要是 SSL 证书）。
      # 这样就不用每次重启容器都重新申请证书了。
      - ./caddy/data:/data
      # 持久化 Caddy 的配置（如果通过 API 修改）
      - ./caddy/config:/config
      # 持久化 Caddy 的日志
      - ./caddy/logs:/var/log/caddy
    restart: unless-stopped
    # 如果一个服务依赖另一个，设置 depends_on 可以确保依赖的服务先启动。
    depends_on:
      - sillytavern 


# 定义网络（可选，但推荐），让容器在同一个虚拟网络中，方便互相通信
networks:
  default:
    name: sillytavern_network
    driver: bridge
```

### **配置 Caddy (Caddyfile)**

接下来，在同一个目录下，创建 `caddy/Caddyfile` 文件：

```bash
SillyTavern/docker $ mkdir caddy
SillyTavern/docker $ nano caddyCaddyfile
```

粘贴以下内容，并将 `barz.foo` 替换为你希望 SillyTavern 运行在哪里的域名，`your_email@example.com` 替换为你的邮箱地址（用于 Let's Encrypt 注册）：

!!! note "这只是一个最简单的配置示例"

    你可以根据需要添加更多的配置选项，比如启用 HTTP/3、设置缓存、添加访问控制等。Caddy 的官方文档提供了详细的配置说明。

    一个主要的原因是我不止有这一个服务，所以用宿主机的 Nginx 反向代理了 😂

```caddy
barz.foo {
    # Caddy 会自动为这个域名申请并续签 Let's Encrypt 或 ZeroSSL 证书，实现 HTTPS [80,,]
    # tls 指令是可选的，如果提供邮箱，有助于账户恢复和接收通知
    tls your_email@example.com

    # 将所有请求反向代理到 SillyTavern 容器
    # 'sillytavern' 是我们在 docker-compose.yml 中定义的服务名
    # '8000' 是 SillyTavern 容器内部监听的端口
    reverse_proxy sillytavern:8000 {
        # 设置请求头，确保 SillyTavern 能正确处理请求
        header_up Host {http.request.host}
        # 把真实的客户端 IP 地址传递给 SillyTavern
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-For {http.request.remote.host}
        header_up X-Forwarded-Port {http.request.port}
        header_up X-Forwarded-Proto {http.request.scheme}
    }
}
```

### 拉取或构建容器映像

```bash
# 如果你想使用现成的 Docker 镜像，可以直接拉取：
SillyTavern/docker $ sudo docker compose pull
# 如果你想使用本地的 Dockerfile 构建镜像，可以运行：
SillyTavern/docker $ sudo docker compose build
# 第一次启动容器，以生成默认的配置文件和数据目录。
# 当你看到 ”Go to: http://127.0.0.1:8000/ to open SillyTavern“ 的时候，说明容器已经成功启动了。
# 这时可以按下 Ctrl+C 停止容器，修改接下来的设置。
SillyTavern/docker $ sudo docker compose up
```

除此以外，你也许会看到”Blocked connection from 172.22.0.3 (forwarded from {http.request.remote.ip}); User Agent: Go-http-client/1.1“ 这种 SillyTavern 拦截了不在白名单的请求的提示。这个是因为 SillyTavern 默认只允许来自 localhost 的请求。你需要按照和在局域网中设置的方式，把 Docker 网桥的 IP 地址添加到白名单中。例如：

```yaml
whitelist:
  - 172.22.*
```

以及因为转发来源的 IP 可能会不断变化，你也许需要在 `config.yaml` 中修改以下行：

```yaml
enableForwardedWhitelist: false
```

### **配置 SillyTavern 的认证**

在第一次启动容器**之前**，或者启动后进入容器修改，我们需要配置 SillyTavern 的认证方式。由于我们使用了 Docker Volume 将 `./config` 映射到了容器的 `/home/node/app/config`，我们可以在宿主机的 `./config` 目录里找到（或创建）`config.yaml` 文件来修改配置。

!!! note "Docker 容器创建的文件会使用容器内的用户权限"

    在容器外面，你可能需要 root 权限才能修改这些文件。你可以使用 `sudo` 来编辑这些文件。

```bash
SillyTavern/docker $ sudo nano config/config.yaml
```

### **使用 SillyTavern 多用户模式**

添加或修改以下行后保存文件：
    
```yaml
# 启用多用户模式
enableUserAccounts: true
# 默认情况下，SillyTavern 会在登录页面显示所有用户的列表
# 如果你不希望在登录页面显示用户名列表，而是要求用户手动输入，可以启用这个
enableDiscreetLogin: true
```
    
### 第二次启动
在配置完成后，我们可以启动 SillyTavern 和 Caddy 了。确保你在 `docker` 目录下，然后运行以下命令：

```
SillyTavern/docker $ docker compose up -d
```

!!! tip 

    - `up`: 创建并启动 `docker-compose.yml` 文件中定义的服务。
    - `-d`: 表示在后台（detached mode）运行，这样你关闭终端后服务还会继续运行。

### **检查状态和日志：**

- 查看容器是否正在运行：`docker compose ps`
- 实时查看 SillyTavern 日志：`docker compose logs -f sillytavern`
- 实时查看 Caddy 日志：`docker compose logs -f caddy`

在 Caddy 的日志中，你应该能看到它成功获取 SSL 证书的信息。在 SillyTavern 的日志中，你应该能看到它成功启动并监听端口的信息。

### **收尾：访问你的 SillyTavern**

打开你的浏览器，输入 `https://barz.foo` (确保是 HTTPS!)。

你应该能看到 SillyTavern 的界面了！以默认的 `default-user` 用户登录之后，你应该能够看到 SillyTavern 的主界面。
接下来，记得在设置的管理员面板中，创建一个新的用户，设置密码，并禁用默认的 `default-user` 用户。

!!! success "Docker 魔法阵达成!"

    恭喜你！SillyTavern 现在正安全地运行在 Docker 容器中，通过 Caddy 自动实现了 HTTPS 加密和反向代理，并且配置了用户验证。这种方式不仅部署相对简单，而且利用了 Docker 的环境隔离和 Compose 的编排能力，让管理和维护都更加方便。数据持久化的问题也通过存储卷得到了解决，确保你的宝贵数据不会丢失。享受你的云端 AI 伙伴吧！

## 第十站：路径二 —— 裸机硬核流 (精简高效)

勇士，你选择了这条更贴近“金属”的道路！这意味着我们将直接在 Debian 服务器上安装和配置 SillyTavern 所需的一切，没有 Docker 的额外抽象层。这可能会带来微小的性能优势（少了 Docker 引擎的开销），并让你对系统有更精细的控制，但同时也需要你承担更多的手动配置和维护工作。

SillyTavern 是一个 Node.js 应用，所以我们需要安装 Node.js 运行环境和它的包管理器 NPM。同时，我们也需要 Git 来下载 SillyTavern 的代码。

### 使用 NodeSource 仓库安装 Node.js 和 NPM
    
Debian 官方源里的 Node.js 版本通常比较旧，而 SillyTavern 可能需要较新的版本。NodeSource 维护了包含最新 Node.js 版本的 APT 仓库，是推荐的安装方式 。
    
* **更新软件包列表：**
    
```bash
# apt update
```
    
* **安装 `curl` (如果尚未安装)：**
用于下载 NodeSource 的设置脚本。
    
```bash
# sudo apt install curl
```
    
* **下载并执行 NodeSource 安装脚本：** 
你需要决定安装哪个 Node.js 主版本。这里我们选择 22.x 版本（当前最新的 LTS 版本）
    
```bash
# curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash - 
```
    
* **安装 Node.js：** 这个包会自动包含对应版本的 NPM。
        
```bash
# 抱歉现在才告诉你，你能在使用 apt 时使用 -y 来跳过确认提示 🙂
# sudo apt install -y nodejs
```
    
* **验证安装：**
    
```bash 
# 这应该会显示你安装的 Node.js 和 NPM 的版本号。
$ node -v
v22.15.0
$ npm -v
10.9.2
```

### **获取 SillyTavern 代码**

和 Docker 路径类似，我们需要把 SillyTavern 的代码下载到服务器。

```bash
$ git clone https://github.com/SillyTavern/SillyTavern.git 
$ cd SillyTavern/docker
```
    
- 如果你想使用开发中的 `staging` 分支，可以使用 `git clone https://github.com/SillyTavern/SillyTavern.git -b staging` 。默认克隆的是 `release` 分支。

### **安装 SillyTavern 的 Node.js 依赖**

进入 SillyTavern 的代码目录后，我们需要使用 NPM 来安装它所依赖的所有 Node.js 模块。

```
SillyTavern $ npm install
```

NPM 会读取项目根目录下的 `package.json` 文件，并下载所有在 `dependencies` 中列出的包到 `node_modules` 文件夹。这个过程可能需要几分钟，取决于你的网络速度和依赖数量。

### **首次运行与配置**

在设置后台运行之前，先手动运行一次，确保 SillyTavern 能正常启动并进行必要的配置（例如生成默认的配置文件）。

```bash
SillyTavern $ node server.js
```
    
在终端按 `Ctrl+C` 停止 SillyTavern，然后编辑配置文件。除了像 Docker 方式一样的起用多用户模式的话，你也许还需要修改一些其它的配置，例如监听地址，端口和白名单等。

### **配置 Systemd 服务 —— 让 SillyTavern 后台运行**

我们不希望每次都手动在前台运行 `node server.js`，并且希望它能在服务器启动时自动运行，如果意外崩溃了还能自动重启。Systemd 就是 Linux 系统中负责管理这些“服务”（也叫守护进程）的标配工具 。我们将为 SillyTavern 创建一个 Systemd 单元文件（Unit File）。

* **创建单元文件：** 使用 `nano` 或其他文本编辑器创建服务文件。在用户模式下，Systemd 的用户服务文件通常放在 `~/.config/systemd/user/` 目录下。

!!! note "为什么使用用户模式 （--user）？"

    - **权限控制**：用户服务只在当前用户的权限下运行，避免了对系统级服务的潜在影响。
    - **简化管理**：用户服务不需要 root 权限，适合普通用户使用。
    - **安全性**：减少了对系统级别的修改，降低了安全风险。

    可能会出问题的是，在某些系统配置上，用户服务可能无法在开机时自动启动，或是在用户注销时停止。你可以通过为用户启用 `linger` 来解决这个问题（这一步需要 root 权限）：

    ```bash
    # loginctl enable-linger foo
    ```
    
```bash
$ EDITOR=nano systemctl edit --user --force --full sillytavern.service
```
    
* **粘贴并修改以下内容：** 
  记得将 `foo` 替换为你实际的**带 sudo 权限的普通用户名**，并确保 `WorkingDirectory` 和 `ExecStart` 中的路径正确无误。
    
```toml
[Unit]
Description=SillyTavern AI Frontend Service
Documentation=https://docs.sillytavern.app/
# 确保在网络可用后启动
After=network.target 

# simple 类型表示 ExecStart 中的命令是主进程
Type=simple
# 设置工作目录为 SillyTavern 的根目录
WorkingDirectory=/home/foo/SillyTavern
# 启动命令：使用 node 执行 server.js
# ExecStart 的目标必须是绝对路径。
ExecStart=/usr/bin/node server.js 
# 如果进程非正常退出（例如崩溃），则自动重启
Restart=on-abnormal
# 可选：设置环境变量，比如指定端口或生产模式
# Environment="NODE_ENV=production"
# 指定日志输出到系统日志
StandardOutput=journal

[Install]
# 定义服务应该在哪个系统运行级别下启用
WantedBy=multi-user.target
```

### **管理 Systemd 服务与查看日志**

现在我们已经定义了服务，需要让 Systemd 知道它的存在并进行管理。

* **重新加载 Systemd 配置：** 让 Systemd 读取你新创建的 `.service` 文件。
    
```bash
$ systemctl --user daemon-reload
```
* **启用服务 (开机自启)：**
    
```bash
$ systemctl --user enable sillytavern
```

这会在系统启动时自动运行 SillyTavern。
3. **立即启动服务：**

```bash
$ systemctl --user start sillytavern
```
    
4. **检查服务状态：**
    
```bash
$ systemctl --user status sillytavern
```

你应该能看到类似 `Active: active (running)` 的字样，以及最近几条日志输出。如果启动失败，这里会显示错误信息。

!!! tip 

    为了方便你日后管理 SillyTavern 服务，记住这几个常用命令：
    （因为我们之前创建的是一个用户服务，所以需要加上 `--user` 参数，不带这个参数时是在管理系统安装的服务，这个时候需要 root 权限）

    |   |   |
    |---|---|
    |**命令**|**描述**|
    |`systemctl --user status sillytavern`|查看服务当前状态、PID 和最近日志|
    |`systemctl --user stop sillytavern`|停止服务|
    |`systemctl --user start sillytavern`|启动服务|
    |`systemctl --user restart sillytavern`|重启服务|
    |`systemctl --user enable sillytavern`|设置服务开机自启|
    |`systemctl --user disable sillytavern`|取消服务开机自启|
    |`systemctl --user daemon-reload`|修改服务文件后需执行，重新加载配置|

    Systemd 会收集由它管理的服务的所有输出（stdout 和 stderr）到系统日志（journal）中。`journalctl` 是查看这些日志的强大工具 。

    |   |   |
    |---|---|
    |**命令**|**描述**|
    |`journalctl --user -u sillytavern`|查看 SillyTavern 服务的所有日志|
    |`journalctl --user -f -u sillytavern`|实时跟踪（follow）SillyTavern 的新日志输出|
    |`journalctl --user -n -u sillytavern`|显示最近 条 SillyTavern 日志|
    |`journalctl --user -u sillytavern --since "1 hour ago"`|查看过去一小时内的 SillyTavern 日志|
    |`journalctl --user -u sillytavern -p err`|只显示 SillyTavern 的错误（err）及更高级别日志|
    |`journalctl --user -u sillytavern --since today`|查看今天的 SillyTavern 日志|

    学会使用 `systemctl` 和 `journalctl` 对于管理和排查在 Systemd 下运行的应用至关重要。

### **安装和配置 Caddy**

现在 SillyTavern 已经在后台稳定运行了，我们需要安装 Caddy 作为反向代理，并让它自动处理 HTTPS。

* **安装 Caddy：** 同样推荐使用官方 Debian 仓库。
    
```bash
# 安装依赖
# apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
# 添加 Caddy GPG 密钥
# curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
# 添加 Caddy APT 仓库
# curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
# 更新并安装 Caddy
# sudo apt update && sudo apt install caddy -y
```

* **验证安装：**
    
```bash
$ caddy version
```
    
* **配置 Caddyfile：** Caddy 安装包通常会自动创建一个 Systemd 服务 (`caddy.service`) 并使用 `/etc/caddy/Caddyfile` 作为默认配置文件。编辑这个文件：
    
```bash
sudo nano /etc/caddy/Caddyfile
```
    
清空默认内容（如果有的话），然后粘贴并修改以下配置：
    
!!! note "这只是一个最简单的配置示例"

    你可以根据需要添加更多的配置选项，比如启用 HTTP/3、设置缓存、添加访问控制等。Caddy 的官方文档提供了详细的配置说明。

```caddy
barz.foo {
    # Caddy 会自动为这个域名申请并续签 Let's Encrypt 或 ZeroSSL 证书，实现 HTTPS
    # tls 指令是可选的，如果提供邮箱，有助于账户恢复和接收通知
    tls your_email@example.com

    # 将所有请求反向代理到 SillyTavern 
    reverse_proxy localhost:8000 {
        # 设置请求头，确保 SillyTavern 能正确处理请求
        header_up Host {http.request.host}
        # 把真实的客户端 IP 地址传递给 SillyTavern
        header_up X-Real-IP {http.request.remote.host}
        header_up X-Forwarded-For {http.request.remote.host}
        header_up X-Forwarded-Port {http.request.port}
        header_up X-Forwarded-Proto {http.request.scheme}
    }
}
```
    
* **保存并退出** (`Ctrl+X`, `Y`, `Enter`)。
    
* **重新加载 Caddy 配置：** 让 Caddy 服务应用新的 `Caddyfile`。
    
```bash
# systemctl reload caddy
```
    
* ***检查 Caddy 状态和日志：**
    
```bash
# systemctl status caddy
# journalctl -u caddy -f
```
    
留意日志中是否有成功获取证书的信息。如果成功的话，你就可以向方才一样，将 Caddy 也设置成开机自启了：

### **访问你的 SillyTavern**

打开浏览器，访问 `https://barz.foo`。

你应该能看到 SillyTavern 的界面了！以默认的 `default-user` 用户登录之后，你应该能够看到 SillyTavern 的主界面。
接下来，记得在设置的管理员面板中，创建一个新的用户，设置密码，并禁用默认的 `default-user` 用户。

!!! success "裸机硬核流达成!"

    厉害了！你成功地在服务器上直接安装、配置并运行了 SillyTavern，通过 Systemd 实现了后台稳定运行和管理，并利用 Caddy 提供了安全可靠的 HTTPS 访问。虽然过程比 Docker 稍微繁琐，但你对整个系统的运作有了更深入的了解，并且可能节省了一些系统资源。这种方式虽然需要更多手动管理，但也赋予了你最大的控制权。

## 第十一站：胜利会师！SillyTavern 云端上线！

无论你选择了 Docker 的便捷魔法，还是裸机部署的硬核挑战，现在都应该抵达了同一个光辉的终点：你的 SillyTavern 实例已经在云端 VPS 上成功运行，并且通过你自己的域名进行 HTTPS 安全访问了！

!!! success "庆祝时刻! 给自己点个赞吧！"

    从购买服务器和域名，到配置 DNS，再到加固 SSH，最后成功安装部署 SillyTavern 并设置好 Caddy 反向代理和 HTTPS，这绝对是一段不小的旅程，你做得非常棒！

    **验证一下胜利果实：**

    - 再次打开浏览器，输入 `https://barz.foo` (记得是 **https** 哦！)。
    - 你应该能看到熟悉的 SillyTavern 界面。
    - 输入你设置的用户名和密码进行登录。
    - 连接你的 AI 后端 API，和你的 AI 伙伴打个招呼，确认一切正常！

!!! note "接下来..."

    你的 SillyTavern 已经基本可用且具备了基础的安全防护。但是，追求极致安全的脚步永不停止！如果你想让你的云端小窝更加坚不可摧，可以考虑接下来的“奖励关卡”——一些可选但强烈推荐的安全加固措施。

    准备好迎接最终挑战了吗？让我们看看还能做些什么来进一步提升安全性！

## 第十二站：奖励关卡 —— 额外的安全护盾 (可选)

你的 SillyTavern 已经上线，并且有了 HTTPS 和用户验证的基础保护。但这就像给城堡建了城墙和城门，我们还可以加派巡逻兵（防火墙）和建立秘密通道（隧道）来让它更安全！这些步骤是可选的，但强烈推荐，尤其是防火墙。

### **部署防火墙：UFW 上岗！**

防火墙就像服务器的网络门卫，严格控制哪些类型的网络连接（通过哪些端口）可以进入或离开你的服务器。默认情况下，服务器可能允许所有端口的入站连接，这给了攻击者可乘之机。我们需要设置规则，只允许我们真正需要的服务端口通过。

#### **VPS 提供商的防火墙 vs. 系统防火墙：**
    
- 一些 VPS 提供商（如 DigitalOcean, Vultr, AWS, GCP）在其管理平台上提供了“云防火墙”或“安全组”功能 [Query reference]。这是一种在服务器外部设置规则的方式，通常更易于管理，并且能在流量到达你的 VPS 之前就进行过滤。如果你的提供商提供此功能，建议优先了解并使用它。
- 如果你想在 VPS 内部进行更精细的控制，或者提供商没有提供方便的云防火墙，那么可以在 Debian 系统内部设置防火墙。`ufw` (Uncomplicated Firewall) 是一个非常用户友好的命令行工具，用于管理 Linux 内核的 `iptables` 防火墙 。我们将以 `ufw` 为例。
  - 
#### **使用 UFW 配置防火墙（在你的 VPS 上执行）：**
    
* **安装 UFW：**
    
```bash
# apt update
# apt install ufw -y
```
    
* **设置默认策略（重要！）：** 
先阻止所有传入连接，允许所有传出连接。这是一个安全的起点。
    
```bash
# ufw default deny incoming
# ufw default allow outgoing
```
    
* **允许必要的入站连接（端口）：** 这是关键一步！我们需要明确允许哪些服务可以被外界访问。
    - **SSH (极其重要！)：** 必须允许 SSH 连接，否则你将无法再次登录服务器！
        
        ```bash
        # ufw allow ssh
        ```
        
        这会默认允许 TCP 端口 。如果你的 SSH 运行在非标准端口（比如之前配置的），你需要明确允许那个端口（例如`2222`）：`sudo ufw allow/tcp 2222` 。
    
    - **HTTP (端口)：** Caddy 需要监听端口 来进行 Let's Encrypt 的 HTTP-01 验证以及将 HTTP 请求重定向到 HTTPS。
        
        ```bash
        # ufw allow http
        ```
        
    - **HTTPS (端口)：** 这是 Caddy 提供 HTTPS 服务的主端口。
        
        ```bash
        # ufw allow https
        ```
    
    - 因为我们让 Caddy 监听了 80 和 443 端口，并反向代理到 SillyTavern 的 8000 端口，所以我们不需要单独允许 8000 端口的入站连接。
* **启用 UFW 防火墙：**
    
    ```bash
    sudo ufw enable
    ```
    
    系统会警告这可能会断开现有连接。因为我们已经允许了 SSH，所以输入 `y` 并按 Enter 继续。

* **检查状态：** 确认防火墙已激活，并且规则设置正确。
    
    ```bash
    # ufw status verbose
    ```
    
    你应该能看到状态是 `active`，并且列出了允许 `22/tcp` (或你的 SSH 端口)、`80/tcp` 和 `443/tcp` 的规则。

**防火墙就位！** 现在，只有 SSH、HTTP 和 HTTPS 端口是开放的，其他所有未明确允许的入站连接都会被阻止，大大减少了服务器的攻击面。
    
- **(可选) Fail2Ban 联动：** 如前所述，Fail2Ban 可以自动检测恶意行为（如 SSH 暴力破解）并动态更新 UFW 规则来临时封禁攻击者的 IP 。安装并配置 Fail2Ban (特别是 `sshd` jail) 可以进一步增强 SSH 安全性。参考 Fail2Ban 文档进行配置 。
    

### **安全隧道简介：Tailscale 与 Cloudflare Tunnel**

防火墙是直接在服务器上设卡，而安全隧道则像是建立了一条从外部特定点到你服务器内部的加密“秘密通道”，流量必须先通过这个通道的入口才能到达你的服务器。这种方式通常可以让你**不必在防火墙上直接开放应用端口（如/443）给整个互联网**。

#### **Tailscale:**
    
- **它是什么？** Tailscale 本质上是一个“零配置”的**网状 VPN (Mesh VPN)** 。它使用 WireGuard 协议 在你所有安装并登录了 Tailscale 的设备（包括你的 VPS、笔记本、手机）之间建立一个**私有的、加密的点对点网络** (称为 tailnet)。
- **核心优势：**
    - **易用性：** 安装客户端并用你的身份提供商（如 Google, Microsoft, GitHub 或 OIDC）登录即可，设备会自动发现并连接彼此 。
    - **身份认证：** 访问控制基于用户身份，而不是易变的 IP 地址，更符合零信任安全模型 。
    - **NAT 穿透：** 通常无需配置防火墙端口转发，Tailscale 会尝试直接连接，或者通过它的 DERP 中继服务器进行连接 。
- **如何用于 SillyTavern？** 你可以在 VPS 和你的个人设备上都安装 Tailscale。然后，你可以通过 VPS 在 Tailscale 网络中的**私有 IP 地址** (通常是 `100.x.x.x` 格式) 来访问 SillyTavern，而**无需将 SillyTavern 的端口暴露给公网**。Caddy 仍然可以在 VPS 内部运行，监听 Tailscale 的 IP 地址，并提供 HTTPS（可以使用 Tailscale 的 MagicDNS 功能自动获取证书，或者 Caddy 的内部证书）。这样，只有你登录了 Tailscale 的设备才能访问 SillyTavern。
- **Tailscale Funnel:** 这是一个**测试版 (beta)** 功能 ，允许你将 Tailscale 网络内的某个服务（通过一个特殊的 `*.ts.net` 域名）**公开**给互联网访问，类似于 Cloudflare Tunnel。但这并不是 Tailscale 的主要设计目标。
- **适用场景：** 主要用于**个人或团队内部**安全地访问私有服务。
- **文档链接：**([https://tailscale.com/kb/](https://tailscale.com/kb/))

#### **Cloudflare Tunnel:**
    
- **它是什么？** Cloudflare Tunnel 使用一个名为 `cloudflared` 的轻量级守护进程，在你的 VPS 上运行。这个进程会主动与 Cloudflare 的全球网络建立**仅出站 (outbound-only)** 的持久连接 。你不需要在防火墙上打开任何入站端口。
- **工作原理：** 当用户访问你在 Cloudflare 上配置好的域名时，请求先到达 Cloudflare 的边缘网络。Cloudflare 通过已经建立的 Tunnel 将请求安全地转发给你的 VPS 上的 `cloudflared` 进程，`cloudflared` 再将请求交给本地运行的服务（比如 Caddy 或直接是 SillyTavern）。
- **核心优势：**
    - **隐藏源站 IP：** 你的 VPS 的真实 IP 地址不会暴露在公网上，提高了安全性 。
    - **无需开放端口：** 依赖于出站连接，绕过了复杂的防火墙入站规则配置 。
    - **利用 Cloudflare 功能：** 可以利用 Cloudflare 提供的 DDoS 防护、WAF (Web Application Firewall)、缓存等功能（部分高级功能可能需要付费）。
    - **易于设置：** 可以通过 Cloudflare Zero Trust 仪表板或命令行进行配置 。
- **如何用于 SillyTavern？** 你可以在 VPS 上运行 `cloudflared`，并配置一个 Tunnel 指向本地运行的 Caddy（监听 `localhost:443` 或其他端口）。然后，在 Cloudflare 的 DNS 设置中，将你的域名指向这个 Tunnel 。这样，所有公网流量都必须先经过 Cloudflare，再通过 Tunnel 到达你的 Caddy/SillyTavern。Cloudflare 会负责处理面向公网的 HTTPS 证书。
- **注意事项：**
    - Cloudflare 会在边缘解密 HTTPS 流量（然后再加密传给你的 Tunnel），这对于某些对端到端加密有严格要求的场景可能是个考虑因素 。
    - 免费套餐对非 HTML 内容（如流媒体）的使用有限制条款，尽管实际执行可能不严格 。
- **适用场景：** 将本地服务**安全地发布到公网**访问。
- **文档链接：**([https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/))

### **防火墙 vs. 隧道：不同的安全哲学**

- **UFW等防火墙软件** 控制的是**直接访问服务器端口**的权限。它简单直接，让你完全控制哪些端口对外界开放。
- **隧道** 则通过一个**中介服务**（Tailscale 或 Cloudflare）来管理访问，通常**避免了直接暴露服务器端口**给公网。这增加了一层抽象和依赖，但也可能带来额外的安全特性（如隐藏 IP、身份验证集成）。

选择哪种方式，或者是否组合使用（例如，使用 UFW 保护 SSH 端口，同时用 Cloudflare Tunnel 暴露 Web 服务），取决于你的具体需求、对第三方服务的信任程度以及你想要的安全模型。对于初学者来说，**配置好 UFW 是一个非常好的起点**。

### **安全永无止境！** 
这些额外的安全层可以显著提高你的 SillyTavern 实例的安全性。即使你现在不打算实施隧道，也强烈建议配置好 UFW 防火墙。

## 终点站：旅途愉快，畅聊无限！

哇哦！我们终于到达了旅程的终点！从一片空白的云服务器，到现在拥有一个安全、稳定、可通过专属域名 HTTPS 访问的 SillyTavern 实例，你真的完成了一项了不起的工程！

**回顾一下你的辉煌成就：**

- 你理解了为何要保护 SillyTavern，特别是 API 密钥的重要性。
- 你拥有了自己的域名，并学会了如何让它指向你的服务器。
- 你挑选并购买了合适的 VPS，还特别注意了地理位置的选择。
- 你掌握了通过 SSH 安全连接服务器，并创建了安全的非 root 用户。
- 你通过 SSH 密钥认证、禁用密码和 root 登录，大大加固了服务器的入口。
- 你根据自己的偏好，成功地通过 Docker 或直接在服务器上安装并运行了 SillyTavern。
- 你配置了 Caddy 作为反向代理，并让它自动搞定了 HTTPS 证书，让访问既安全又便捷。
- （如果完成了奖励关卡）你还可能部署了 UFW 防火墙，甚至了解了 Tailscale 和 Cloudflare Tunnel 这类更高级的安全工具。

现在，你可以随时随地，通过你专属的 `https://barz.foo`，安全地与你的 AI 伙伴们交流互动了！

## **未来的路**

- **探索 SillyTavern：** 深入挖掘 SillyTavern 的各种强大功能吧！自定义角色、探索扩展、调整界面，让它成为你独一无二的 AI 交互中心。
- **保持更新：** 这是非常重要的一点！为了安全和稳定，请记得定期更新你的服务器操作系统 (Debian)、SillyTavern 本身、Node.js (如果你是裸机安装)、Docker (如果你使用 Docker) 以及 Caddy。关注它们的官方发布通知，及时打上安全补丁。
- **持续学习：** 云计算和服务器管理的世界广阔无垠，保持好奇心，继续学习新的知识和技能吧！

再次恭喜你完成了这次云端部署之旅！希望这篇指南对你有所帮助。现在，去和你的 AI 伙伴们好好聊聊，享受这段由你亲手搭建的安全、私密的互动时光吧！旅途愉快！