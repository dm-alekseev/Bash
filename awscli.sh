#!/bin/bash
install_linux() {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
}
install_macos() {
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
}
install_windows(){
    pip install awscli
    # echo "Установка для Windows..."
    # curl -O https://awscli.amazonaws.com/AWSCLIV2.msi
    # msiexec.exe /i AWSCLIV2.msi /quiet
    # ;;
}
if command -v aws &>/dev/null; then
    echo "AWS уже установлен."
else

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ -e /etc/lsb-release ]]; then
        install_linux
    else
        exit 1
    fi

  if [[ "$OSTYPE" == "cygwin"* ]]; then
        install_windows
    else
        exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &>/dev/null; then
        install_macos
    else
        exit 1
    fi
  else
    exit 1
  fi
fi
