# apk-pull

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

### Creating the required files.
1. Create packageNameLists.txt.
2. Describe the package name of the apk you want to extract in packageNameLists.txt.

## Usages
- apkpull.sh
```bash
$ ./apkpull.sh
```
- cleanup.sh
```bash
$ ./cleanup.sh
```
