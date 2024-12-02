#!/data/data/com.termux/files/usr/bin/bash
MIRROR_BASE_DIR="/data/data/com.termux/files/usr/etc/termux/mirrors"
TERMUX_HOME="/data/data/com.termux/files/home"

unlink_and_link() {
    MIRROR_GROUP="$1"
    if [ -L "/data/data/com.termux/files/usr/etc/termux/chosen_mirrors" ]; then
        unlink "/data/data/com.termux/files/usr/etc/termux/chosen_mirrors"
    fi
    ln -s "${MIRROR_GROUP}" "/data/data/com.termux/files/usr/etc/termux/chosen_mirrors"
}

print_error(){
  echo -e "\033[1;31m$1\033[0m"
}
print_success(){
  echo -e "\033[1;32m$1\033[0m"
}
print_prompt(){
  echo -e "\033[1;33m$1\033[0m"
}
print_info(){
  echo -e "\033[1;34m$1\033[0m"
}

on_fail(){
  print_error "$1"
  select yn in "🔁 再次尝试" "❎ 退出脚本"; do
    case $yn in
        "🔁 再次尝试" ) 
          $2
          break;;
        "❎ 退出脚本" ) 
          exit 1
    esac
done
}

# 检查 Termux 版本和发行渠道
check_system() {
  print_info "⏳ 正在检查环境，和脚本依赖的插件是否安装……" 
  if [ -z "${TERMUX_VERSION}" ]; then
    print_error "🚫 TERMUX_VERSION 变量不存在，你确定是在 Termux 里运行的嘛，杂鱼？"
    exit 1
  fi

  if [[ "$TERMUX_VERSION" =~ "googleplay" ]]; then
    print_error "🚫 不要用 Play 商店版 Termux，除非你知道你在做什么。"
    exit 1
  fi

  if [[ ! $(termux-info | grep "com.termux.api") ]]; then
    print_error "🚫 装 Termux:API 了没，杂鱼？"
    read -p "👉 按 Enter 将打开 Termux:API 在 F-Droid 仓库的页面，请确保你拥有国际互联网连接。在安装完毕后，记得退出并重新启动 Termux."
    termux-open-url https://f-droid.org/en/packages/com.termux.api/
    exit 2
  fi

  if [[ ! $(termux-info | grep "com.termux.widget") ]]; then
    print_error "🚫 装 Termux:Widget 了没，杂鱼？"
    read -p "👉 按 Enter 将打开 Termux:Widget 在 F-Droid 仓库的页面，请确保你拥有国际互联网连接。在安装完毕后，记得退出并重新启动 Termux."
    termux-open-url https://f-droid.org/en/packages/com.termux.widget/
    exit 2
  fi
}

# 更新软件仓库，更新系统
update_mirrorlist() {
  print_prompt "🤔 要我帮你更换 Termux 软件仓库为中国镜像嘛？这也许能提高下载软件包的速度。"
  select yn in "帮我换" "不用了"; do
    case $yn in
      帮我换 ) 
          unlink_and_link ${MIRROR_BASE_DIR}/chinese_mainland
          TERMUX_APP_PACKAGE_MANAGER=apt pkg --check-mirror update
          break;;
      不用了 ) 
          read -p "⏩️ 稍后你可以运行 termux-change-repo 命令自己换。按 Enter 键继续下一步。" 
          break;;
    esac
  done
}

upgrade_system() {
  print_info "⏳ 正在更新 Termux 环境……"
  apt --yes --allow-change-held-packages  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" upgrade \
    || (on_fail "🚫 Termux 升级时发生问题，请手动运行 pkg upgrade 命令后重试。" $0)
}

install_dep(){
  print_info "⏳ 正在安装 Git 和 Node.js……"
  apt --yes install git nodejs-lts \
    || (on_fail "🚫 安装 Git 和 Node.js 时发生问题。请手动运行 pkg install git nodejs-lts 命令后重试。" $0;)
}

update_npm_mirror(){
  print_prompt "🤔 要我帮你更换 Npmjs 软件仓库为淘宝的镜像嘛？这也许能提高下载软件包的速度。"
  select yn in "帮我换" "不用了"; do
    case $yn in
      帮我换 ) 
          npm config set registry https://registry.npmmirror.com
          break;;
      不用了 ) 
          read -p "⏩️ 那么请自行确保你拥有能连接到 npmjs 的国际互联网连接，祝你好运。以及按 Enter 继续。" 
          break;;
    esac
  done
}

# 安装 SillyTavern
install_sillytavern(){
  if [ -d "${TERMUX_HOME}/SillyTavern" ]; then
    print_info "⏩️ 酒馆目录（~/SillyTavern）已存在，跳过安装酒馆的过程。"
  else
    print_prompt "🤔 选择酒馆版本？"
    prompt_release="release 分支（最新稳定版）"
    prompt_1_12_5="1.12.5（可能有机率缓解 Chrome / Edge 浏览器下的卡顿问题）"
    select yn in "$prompt_release" "$prompt_1_12_5"; do
      print_info "⏳ 正在克隆酒馆仓库……"
      case $yn in
        "$prompt_release" ) 
            git clone https://github.com/SillyTavern/SillyTavern.git \
              || (on_fail "🚫 克隆 SillyTavern 仓库时发生问题。请检查你的国际互联网连接状态。" $0)
            break;;
        "${prompt_1_12_5}" ) 
            git clone https://github.com/SillyTavern/SillyTavern.git --branch 1.12.5 \
              || (on_fail "🚫 克隆 SillyTavern 仓库时发生问题。请检查你的国际互联网连接状态。" $0)
            break;;
      esac
    done
  fi

  print_info "⏳ 正在安装酒馆的 Node.js 依赖项……"
  (cd SillyTavern && npm install --no-audit --no-fund --loglevel=info --omit=dev) \
    || (on_fail "🚫 安装酒馆及其依赖时发生问题。请手动在 SillyTavern 目录里 npm install 命令后重试。" $0)
}

# 安装 Clewd （可选）
install_clewd(){
  print_prompt "🤔 要安装 Clewd 么？"
  print_info "ℹ️ 如果你通过 API 使用 Claude 模型，或是根本不使用 Claude，那么你并不需要安装 Clewd。"
  select yn in "安装" "跳过"; do
    case $yn in
      "安装" ) 
          if [ -d "${TERMUX_HOME}/clewd" ]; then
            print_info "⏩️ Clewd 目录（~/clewd）已存在，跳过安装 Clewd 的过程。"
          else
            print_info "⏳ 正在克隆 Clewd 仓库……"
            git clone https://github.com/teralomaniac/clewd --branch test \
              || (on_fail "🚫 克隆 Clewd 仓库时发生问题。请检查你的国际互联网连接状态。" $0)
          fi
          print_info "⏳ 正在安装Clewd的 Node.js 依赖项……"
          (cd clewd && npm install --no-audit --no-fund --loglevel=info --omit=dev &&
           node clewd.js && sed -i 's/"PassParams": true,/"PassParams": false,/g' config.js ) \
           || (on_fail "🚫 安装 Clewd 及其依赖时发生问题。请手动在 clewd 目录里运行 npm install 命令后重试。" $0)
          break;;
      "跳过" ) 
          break;;
    esac
  done
}

generate_startup_script() {
  print_info "⏳ 正在生成启动脚本……"
  mkdir -p "${TERMUX_HOME}/.shortcuts"
  
cat << \EOF > ${TERMUX_HOME}/.shortcuts/酒馆启动
#!/data/data/com.termux/files/usr/bin/bash
SILLYTAVERN_PATH=/data/data/com.termux/files/home/SillyTavern
termux-wake-lock
cd $SILLYTAVERN_PATH
bash start.sh
EOF

  if [ -d "${TERMUX_HOME}/clewd" ]; then
cat << \EOF > ${TERMUX_HOME}/.shortcuts/Clewd启动
#!/data/data/com.termux/files/usr/bin/bash
CLEWD_PATH=/data/data/com.termux/files/home/clewd
termux-wake-lock
cd $CLEWD_PATH
node clewd.js
EOF
  fi

  chmod -R 700 "${TERMUX_HOME}/.shortcuts"
}

on_success(){
  print_success "✅ 酒馆和 Clewd 安装完毕"
  print_info "👉 添加 Termux:Widget 小部件或快捷方式即可分别运行 clewd 和酒馆。"
  print_prompt "🦊 不性感狐狐在线讨炸豆腐（不是）"
  select yn in "去看看" "下次一定"; do
    case $yn in
      "去看看" ) 
          termux-open-url "https://afdian.com/a/foobarz076"
          break;;
      "下次一定" ) 
          break;;
    esac
  done
}

main(){
  print_info "                                             
ℹ️  杂鱼用酒馆(SillyTavern) (和/或 Clewd) 安装脚本 for Termux
🦊  作者: Foobarz076
🌏  类脑Discord: https://discord.gg/HWNkueX34q
"

  # 起始提示
  print_prompt "😈 承认你是看不懂手动部署教程或是懒狗杂鱼了？" 
  select yn in "🥺 我是杂鱼（大声）" "🥲 我觉得我还可以抢救一下"; do
      case $yn in
          "🥺 我是杂鱼（大声）" ) break;;
          "🥲 我觉得我还可以抢救一下" ) 
              read -p "✅ 那我就再帮你打开一次我写的文档。按 Enter 键结束脚本。" 
              termux-open-url https://gtss-ai-docs.barz.foo/chatting/index.html
              exit;;
      esac
  done

check_system && \
update_mirrorlist && \
upgrade_system && \
install_dep && \
update_npm_mirror && \
install_sillytavern && \
install_clewd && \
generate_startup_script && \
on_success && \
return 0

}

main
