#!/bin/bash

##################################
# Author: daiki0508
# Distribution: Debian(Derived)
##################################

# 例外時に処理を終了
set -eu

# sudo passwordを要求
echo -n "sudo password: "
read password

# aptのアップデート
echo "[*] apk update...";
echo "$password" | sudo -S apt update;
echo "$password" | sudo -S apt dist-upgrade -y;
echo "$password" | sudo -S apt autoremove -y;
echo "$password" | sudo -S apt autoclean -y;
echo -e "\e[32;1m[*] apt updated!\e[32;40;1m";

# bannerのインストール
echo "$password" | sudo -S apt install figlet -y;
# 画面のクリア
clear
# bannerの表示
figlet APK PULL

# adbのインストール
echo "[*] adb install...";
echo "$password" | sudo -S adb install android-tools-adb -y;
echo -e "\e[32;1m[*] adb installed!\e[32;40;1m";

# packageNameLists.txtのパス指定
while :
do
    echo "Do you want to specify the path for packageNameLists.txt?";
    echo "1) The default(the same hierarchy)";
    echo "2) Specify any path.(absolute path)";
    echo -n "Please select options number: ";
    read options
    if [ $options = "1" ]; then
        path="."
        ## ファイルの存在チェック
        if [ -e $path/ ]; then
            echo -e "\e[32;1m[*] packageNameLists.txt found!\e[32;40;1m";
            echo "$password" | sudo -S cat $path/packageNameLists.txt;
            break
        else
            echo -e "\e[31;1m[!] packageNameLists.txt didn't find.\e[31;40;1m";
    elif [ $options = "2" ]; then
        echo -n "input packageNameLists.txt path: ";
        read path
        ## ファイルの存在チェック
        if [ -e $path/ ]; then
            echo -e "\e[32;1m[*] packageNameLists.txt found!\e[32;40;1m";
            echo "$password" | sudo -S cat $path/packageNameLists.txt;
            break
        else
            echo -e "\e[31;1m[!] packageNameLists.txt didn't find.\e[31;40;1m";
    else
        echo -e "\e[31;1mPlease select again number.\e[31;40;1m"
    fi
done

# 取得したapkの出力先パスの指定
while :
do
    echo "Do you want to specify the output destination folder of the extracted apk?";
    echo "1) The default(the same hierarchy)";
    echo "2) Specify any path.(absolute path)";
    echo -n "Please select options number: ";
    read options
    if [ $options = "1" ]; then
        outputspath="."
        break
    elif [ $options = "2" ]; then
        echo -n "apk output path: ";
        read outputspath
        break
    else
        echo -e "\e[31;1mPlease select again number.\e[31;40;1m"
    fi
done

# adbで接続する方法を指定
## usb or wifi
echo "[*] device connect...";
while :
do
    echo "Please specify the connection method.";
    echo "1) USB connect";
    echo "2) WIFI connect";
    echo -n "Please select options number: ";
    read options
    if [ $options = "1" ]; then
        while :
        do
            adb devices
            echo -n "Is the terminal to connect to displayed?(y/n): ";
            read yn
            if [ $yn = "y" ]; then
                echo -e "\e[32;1m[*] device connected!\e[32;40;1m";
                break
            elif [ $yn = "n" ]; then
                echo -e "\e[31;1m[!] Connect the terminal you want to connect to the PC via USB.\e[31;40;1m";
            fi
        done
        break
    elif [ $options = "2" ]; then
        while :
        do
            echo -n "ip: ";
            read ip
            echo -n "port: ";
            read port
            adb connect $ip:$port
            adb devices
            echo -n "Is the terminal to connect to displayed?(y/n): ";
            read yn
            if [ $yn = "y" ]; then
                echo -e "\e[32;1m[*] device connected!\e[32;40;1m";
                break
            elif [ $yn = "n" ]; then
                echo -e "\e[31;1m[!] input again ip and port number.\e[31;40;1m";
            fi
        done
        break
    else
        echo -e "\e[31;1mPlease select again number.\e[31;40;1m"
    fi
done

# packageLists.txtから取得したパッケージ名でアプリを抽出
while read -r packageName
do
    packagePath=$(adbs shell pm list packages -f | grep $packageName)
    ## /data/app...base.apk=packageNameを抽出
    tmp=(${packagePath//:/ })
    split=${tmp[1]}
    
    ## /data/app...base.apkを抽出
    tmp=(${split//base.apk/ })
    split=${tmp[0]}base.apk
    echo "[*] apk found! -> $split";
    
    ## android7.0以降の回避策
    echo "[*] apk copy...";
    adb shell cp $split /storage/emulated/0/Download
    echo -e "\e[32;1m[*] apk copied!\e[32;40;1m";

    ## apkの抽出
    echo "[*] apk pull...";
    adb pull /storage/emulated/0/Download/base.apk $outputspath/
    echo -e "\e[32;1m[*] apk pulled!\e[32;40;1m";
done<"$path/packageNameLists.txt"

# 終了
echo -e "\e[32;1mfinished!\e[32;40;1m";