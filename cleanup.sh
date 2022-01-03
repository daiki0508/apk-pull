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
        echo -e "\e[31;1m[!] Please select again number.\e[m";
    fi
done

# packageNameLists.txtの削除
while :
do
    echo "Do you want to reset packageNameLists.txt?";
    echo -e "\e[33;1mIf you select 'clear', all the contents in packageNameLists.txt will be reset.\e[m"
    echo -e "\e[33;1mIf you want to change some contents, please change manually.\e[m"
    echo "1) clear";
    echo "2) not clear";
    echo -n "Please select number: ";
    read options

    if [ $options = "1" ]; then
        ## 実行
        echo "[*] packageNameLists.txt clear...";
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
                    break
                else
                    echo -e "\e[31;1m[!] packageNameLists.txt didn't find.\e[m";
                fi
            else
                echo -e "\e[31;1m[!] Please select again number.\e[m";
            fi
        done
        echo -e "\n-------------------------------------------------------";
            if [ $permission = "1" ]; then
                cat $path/packageNameLists.txt;
                echo -e "-------------------------------------------------------\n";

                ### 確認
                echo -n "Do you really want to clear this?(y/n): "
                read yn

                if [ $yn = "y" ]; then
                    echo -n > $path/packageNameLists.txt
                elif [ $yn = "n" ]; then
                    echo -e "\e[33;1m[!] \"NO\" was selected.\e[m"
                    break
                fi
            else
                echo "$password" | sudo -S cat $path/packageNameLists.txt;
                echo -e "-------------------------------------------------------\n";

                ### 確認
                echo -n "Do you really want to clear this?(y/n): "
                read yn

                if [ $yn = "y" ]; then
                    echo "$password" | sudo -S echo -n > $path/packageNameLists.txt;
                elif [ $yn = "n" ]; then
                    echo -e "\e[33;1m[!] \"NO\" was selected.\e[m"
                    break
                fi
            fi
        echo -e "\e[32;1m[*] packageNameLists.txt cleared!\e[m";
        break
    elif [ $options = "2" ]; then
        break
    else
        echo -e "\e[31;1m[!] Please select again number.\e[m";
    fi
done

# 改行
echo "";

# 出力ディレクトリ内のapkのリセット
while :
do
    echo "Do you want to delete the apk in the output directory?";
    echo -e "\e[33;1mIf you select 'delete', all the files in the directory will be reset.\e[m"
    echo -e "\e[33;1mIf you want to delete part of files in directory, please delete manually.\e[m"
    echo "1) apks delete";
    echo "2) apks don't delete";
    echo -n "Please select number: ";
    read options

    if [ $options = "1" ]; then
        ## 実行
        echo "[*] apks delete...";
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

                ## ディレクトリの存在確認
                if [ -d $outputspath ]; then
                    echo -e "\e[32;1m[*] The directory exists.\e[m";
                    break
                else
                    echo -e "\e[31;1m[!] The directory doesn't exists.\e[m";
                fi
            else
                echo -e "\e[31;1m[!] Please select again number.\e[m"
            fi
        done
        echo -e "\n--------------------------------";
        if [ $permission = "1" ]; then
            echo "$(ls $outputspath | grep -E "*.sh")"
            echo -e "--------------------------------\n";
                
            ### 確認
            echo -n "Do you really want to delete this?(y/n): "
            read yn

            if [ $yn = "y" ]; then
                rm -rf $outputspath/*.apk
            elif [ $yn = "n" ]; then
                echo -e "\e[33;1m[!] \"NO\" was selected.\e[m"
                break
            fi
        else
            echo "$(echo "$password" | sudo -S ls $outputspath | grep -E "*.sh")"
            echo -e "--------------------------------\n";

            ### 確認
            echo -n "Do you really want to delete this?(y/n): "
            read yn

            if [ $yn = "y" ]; then
                echo "$password" | sudo -S rm -rf $outputspath/*.apk
            elif [ $yn = "n" ]; then
                echo -e "\e[33;1m[!] \"NO\" was selected.\e[m"
                break
            fi
        fi
        echo -e "\e[32;1m[*] apks deleted!\e[m";
        break
    elif [ $options = "2" ]; then
        break
    else
        echo -e "\e[31;1m[!] Please select again number.\e[m"
    fi
done

# 終了
echo -e "\e[32;1m[*] finished!\e[m";