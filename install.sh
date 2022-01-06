#!/bin/bash

##################################
# Author: daiki0508
# Distribution: Debian(Derived)
##################################

# 例外時に処理を終了
set -eu

# root or sudo mode 選択
while :
do
    echo "Please select the current user rights.";
    echo "1) Root permission"
    echo "2) sudo permission"
    echo -n "Please select number: "
    read permission

    if [ $permission = "1" ] || [ $permission = "2" ]; then
        break
    else
        echo -e "\e[31;1m[!] Please select again number.\e[m"
    fi
done

# aptのアップデート
echo "[*] apt update...";

if [ $permission = "1" ]; then
    apt update;
    apt dist-upgrade -y;
    apt autoremove -y;
    apt autoclean -y;
else
    # sudo passwordを要求
    echo -n "sudo password: "
    read password
    echo "$password" | sudo -S apt update;
    echo "$password" | sudo -S apt dist-upgrade -y;
    echo "$password" | sudo -S apt autoremove -y;
    echo "$password" | sudo -S apt autoclean -y;
fi

echo -e "\e[32;1m[*] apt updated!\e[m";

echo "[*] figlet install..."
if [ $permission = "1" ]; then
    # bannerのインストール
    apt install figlet -y;
else
    # bannerのインストール
    echo "$password" | sudo -S apt install figlet -y;
fi
echo -e "\e[32;1m[*] figlet installed!\e[m";

# adbのインストール
echo "[*] adb install...";

if [ $permission = "1" ]; then
    apt install android-tools-adb -y;
else
    echo "$password" | sudo -S apt install android-tools-adb -y;
fi

echo -e "\e[32;1m[*] adb installed!\e[m";

# デフォルトの設定
## outputs
echo "[*] create outputs directory...";
if [ $permission = "1" ]; then
    mkdir outputs
else
    echo "$password" | sudo -S mkdir outputs
fi
echo -e "\e[32;1m[*] created outputs directory!\e[m";
## packageNameLists.txt
echo "[*] create packageNameLists.txt file...";
if [ $permission = "1" ]; then
    touch packageNameLists.txt
else
    echo "$password" | sudo -S touch packageNameLists.txt
fi
echo -e "\e[32;1m[*] created packageNameLists.txt file!\e[m";

# 終了
echo -e "\e[32;1m[*] install completed!!\e[m";