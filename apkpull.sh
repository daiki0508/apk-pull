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

    if [ $permission = "1" ]; then
        break
    elif [ $permission = "2" ]; then
        break
    else
        echo -e "\e[31;1m[!] Please select again number.\e[m"
    fi
done

# aptのアップデート
echo "[*] apk update...";

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

if [ $permission = "1" ]; then
    # bannerのインストール
    apt install figlet -y;
else
    # bannerのインストール
    echo "$password" | sudo -S apt install figlet -y;
fi

# 画面のクリア
clear
# bannerの表示
figlet APK PULL

# adbのインストール
echo "[*] adb install...";

if [ $permission = "1" ]; then
    apt install android-tools-adb -y;
else
    echo "$password" | sudo -S apt install android-tools-adb -y;
fi

echo -e "\e[32;1m[*] adb installed!\e[m";

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
            echo -e "\e[32;1m[*] packageNameLists.txt found!\e[m";
            echo -e "\n-------------------------------------------------------";
            if [ $permission = "1" ]; then
                cat $path/packageNameLists.txt;
            else
                echo "$password" | sudo -S cat $path/packageNameLists.txt;
            fi
            echo -e "-------------------------------------------------------\n";
            break
        else
            echo -e "\e[31;1m[!] packageNameLists.txt didn't find.\e[m";
        fi
    elif [ $options = "2" ]; then
        echo -n "input packageNameLists.txt path: ";
        read path
        ## ファイルの存在チェック
        if [ -e $path/ ]; then
            echo -e "\e[32;1m[*] packageNameLists.txt found!\e[m";
            echo -e "\n-------------------------------------------------------";
            if [ $permission = "1" ]; then
                cat $path/packageNameLists.txt;
            else
                echo "$password" | sudo -S cat $path/packageNameLists.txt;
            fi
            echo -e "-------------------------------------------------------\n";
            break
        else
            echo -e "\e[31;1m[!] packageNameLists.txt didn't find.\e[m";
        fi
    else
        echo -e "\e[31;1m[!] Please select again number.\e[m"
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
        echo -e "\e[31;1m[!] Please select again number.\e[m"
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
            echo -e "\n--------------------------------";
            adb devices
            echo -e "--------------------------------\n";
            echo -n "Is the terminal to connect to displayed?(y/n): ";
            read yn
            if [ $yn = "y" ]; then
                echo -e "\e[32;1m[*] device connected!\e[m";
                break
            elif [ $yn = "n" ]; then
                echo -e "\e[31;1m[!] Connect the terminal you want to connect to the PC via USB.\e[m";
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
            echo -e "\n--------------------------------";
            adb devices
            echo -e "--------------------------------\n";
            echo -n "Is the terminal to connect to displayed?(y/n): ";
            read yn
            if [ $yn = "y" ]; then
                echo -e "\e[32;1m[*] device connected!\e[m";
                break
            elif [ $yn = "n" ]; then
                echo -e "\e[31;1m[!] input again ip and port number.\e[m";
            fi
        done
        break
    else
        echo -e "\e[31;1m[!] Please select again number.\e[m"
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
    echo -e "\e[32;1m[*] apk copied!\e[m";

    ## apkの抽出
    echo "[*] apk pull...";
    adb pull /storage/emulated/0/Download/base.apk $outputspath/$packageName.apk
    echo -e "\e[32;1m[*] apk pulled!\e[m";
done<"$path/packageNameLists.txt"

# 終了
echo -e "\e[32;1m[*] finished!\e[m";