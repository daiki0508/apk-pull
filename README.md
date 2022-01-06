# apk-pull
apk-pull is a script that can extract one or more apk files from the terminal to the PC.

## Prepare
### adbs
adbs is a tool to connect to shell without any problem even if multiple terminals are connected to PC.<br>
Please see the official github for detailed installation method and usage.<br>
[adbs](https://github.com/ksoichiro/adbs)
1. Install go.
2. Install adbs.
```bash
$ go install github.com/ksoichiro/adbs@latest
```
3. Copy the installed adbs to /usr/local/bin.

### Install
```bash
$ git clone https://github.com/daiki0508/apk-pull.git
$ cd ./apk-pull
$ ./install.sh
```

### Creating the required files.
<b>If you want to use the files and folders created by executing install.sh as they are, the following processing is not necessary.</b>
1. Create packageNameLists.txt.
2. Describe the package name of the apk you want to extract in packageNameLists.txt.

## Usages
### apkpull.sh
- Script used to extract apk file from terminal to PC.
```bash
$ ./apkpull.sh
```

### cleanup.sh
- A script that clears the used packageNameLists.txt and deletes all apks in the extraction destination directory.
```bash
$ ./cleanup.sh
```
