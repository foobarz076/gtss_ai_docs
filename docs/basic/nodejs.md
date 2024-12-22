# Node.js

!!! quote 
    
    Node.js 是一个开源和跨平台的 JavaScript 运行时环境。它是几乎所有类型项目的流行工具！

    Node.js 在浏览器之外运行 V8 JavaScript 引擎（Google Chrome 的核心）。这使得 Node.js 的性能非常出色。
    
    --[NodeJS 简介](https://nodejs.org/zh-cn/learn/getting-started/introduction-to-nodejs)

介于你几乎不会在这个场景下写 JavaScript 代码，你只要知道你接下来使用的某些工具（例如 SillyTavern）需要安装这个才能运行就好。

## 安装 Node.JS

!!! info

    考虑到文档读者的受众、智力水平和阅读理解能力，这里会多“关照” Windows 一点。
    如果你已经是个熟练的 macOS / GNU/Linux 用户，那么聪明的你应该自己就能搞定。🙂

    [Node.js 提供了如何在各个操作系统上通过包管理器安装的文档。](https://nodejs.org/zh-cn/download/package-manager/all)

!!! failure "警惕国产搜索引擎诈骗"

    Node.js 是可以免费获取的，自由的开放源代码软件。
    如果你因为下载这个付了钱（不含可能产生的电费和流量费），那么恭喜你被骗了。 🙃

### Windows （通过 WinGet 安装）

!!! quote

    程序包管理器是一个用于自动安装、升级、配置和使用软件的系统或工具集。 大多数程序包管理器都是设计用于发现和安装开发人员工具。

    理想情况下，开发人员使用程序包管理器来指定先决条件，这些先决条件适用于为给定项目开发解决方案所需的工具。 然后，程序包管理器就会按照声明性说明来安装和配置这些工具。 程序包管理器可减少准备环境所需的时间，并有助于确保在计算机上安装相同版本的程序包。

    WinGet 是一种命令行工具，使用户能够在 Windows 10、Windows 11 和 Windows Server 2025 计算机上发现、安装、升级、删除和配置应用程序。 此工具是 Windows 程序包管理器服务的客户端接口。

    --[Windows 程序包管理器](https://learn.microsoft.com/zh-cn/windows/package-manager/)

你需要的只是运行一行命令：

```powershell
PS> winget install OpenJS.NodeJS.LTS 
```
```powershell title="这是输出"
已找到 Node.js (长期支持) [OpenJS.NodeJS.LTS] 版本 22.12.0
此应用程序由其所有者授权给你。
Microsoft 对第三方程序包概不负责，也不向第三方程序包授予任何许可证。
正在下载 https://nodejs.org/dist/v22.12.0/node-v22.12.0-arm64.msi
  ██████████████████████████████  25.7 MB / 25.7 MB
已成功验证安装程序哈希
正在启动程序包安装...
已成功安装
```

### Windows （下载安装包安装）

!!! info

    除非你因为各种原因无法运行 `winget` 命令（典型的例子包括打死不愿意安装 Microsoft Store 的 LTSC 用户），
    否则首先尝试上面那一步。


打开下载 Node.js 预构建安装程序的页面： 
[https://nodejs.org/zh-cn/download/prebuilt-installer](https://nodejs.org/zh-cn/download/prebuilt-installer)

![](../_assets/basics/nodejs_01.png)

* 第一个选项选择你的操作系统。
* 第二个选项选择你的电脑 CPU 的体系结构，除非你家境殷实用了搭载骁龙处理器的 Windows 电脑（那你选”ARM64“），否则都该选”x64“。
* 第三个选项选择你要下载的 Node.js 版本，大多数情况下，你都应该选择最靠上的 LTS 版本。

至于安装器，虽然界面都是英文，但你可以一路 Next 的点下去。

### macOS

在安装完 [brew](https://brew.sh/) 之后，你需要的就只是再运行一条命令。

```bash
$ brew install node
```

Homebrew 默认提供的 Node.js 的最新版本，你可以以 `node@版本号` 的形式指定想要安装的 Node.js 版本，以 22 为例：

```bash
$ brew install node@22
```

## Termux

你需要的只是运行一行命令：

```bash
$ pkg install nodejs-lts
```

### 配置 Node.js 使用其它 NPM 存储库

事情并不会总是一帆风顺，因为还是那堵伟大光荣正确的防火墙在给你添堵 🙃

如果你在运行 `npm` 命令时遇到了任何的网络错误，你可以尝试为 npm 设置替代存储库位置。
例如淘宝的 `npmmirror`。

``` bash
$ npm config set registry https://registry.npmmirror.com
```