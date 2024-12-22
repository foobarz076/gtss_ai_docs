# Git

> Git 是一个分布式版本控制系统，被广泛应用于软件开发、文档编写、配置管理等各种场景。它能够记录文件的每一次修改，方便团队协作，追踪代码变更历史，以及回溯到任何一个之前的版本。

但假如你在这之前还不知道 Git 是什么，那么上面那段话对你就毫无用处，对目前的你来说，Git 就是用来下载这篇教程提及的其它软件的。

## 安装 Git

!!! info

    考虑到文档读者的受众、智力水平和阅读理解能力，这里会多“关照” Windows 一点。
    如果你已经是个熟练的 macOS / GNU/Linux 用户，那么聪明的你应该自己就能搞定。🙂

    [git-scm.com 提供了如何在各个操作系统上安装 Git 的文档。](https://git-scm.com/downloads)

!!! failure "警惕国产搜索引擎诈骗"

    Git 是可以免费获取的，自由的开放源代码软件。
    如果你因为下载这个付了钱（不含可能产生的电费和流量费），那么恭喜你被骗了。 🙃

### Windows （通过 WinGet 安装）

!!! quote

    程序包管理器是一个用于自动安装、升级、配置和使用软件的系统或工具集。 大多数程序包管理器都是设计用于发现和安装开发人员工具。

    理想情况下，开发人员使用程序包管理器来指定先决条件，这些先决条件适用于为给定项目开发解决方案所需的工具。 然后，程序包管理器就会按照声明性说明来安装和配置这些工具。 程序包管理器可减少准备环境所需的时间，并有助于确保在计算机上安装相同版本的程序包。

    WinGet 是一种命令行工具，使用户能够在 Windows 10、Windows 11 和 Windows Server 2025 计算机上发现、安装、升级、删除和配置应用程序。 此工具是 Windows 程序包管理器服务的客户端接口。

    --[Windows 程序包管理器](https://learn.microsoft.com/zh-cn/windows/package-manager/)

你需要的只是运行一行命令：

```powershell
PS> winget install Git.Git
```
```powershell title="这是输出"
已找到 Git [Git.Git] 版本 2.47.1
此应用程序由其所有者授权给你。
Microsoft 对第三方程序包概不负责，也不向第三方程序包授予任何许可证。
正在下载 https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.1/Git-2.47.1-arm64.exe
  ██████████████████████████████  64.0 MB / 64.0 MB
已成功验证安装程序哈希
正在启动程序包安装...
已成功安装
```

### macOS

直接安装 Xcode 命令行工具，里面自然会有 Git。

```bash
$ xcode-select --install
```

## Termux

你需要的只是运行一行命令：

```bash
$ pkg install git
```