# 简介

# 安装
## mac
```
# 暂未支持mac,可使用ubuntu安装方式
brew tab install freecracy/gvm
```
## ubuntu
```bash
wget -q https://raw.githubusercontent.com/freecracy/gvm/master/gvm && sudo mv gvm /usr/local/bin/gvm && sudo  chmod +x /usr/local/bin/gvm 
```
# 使用
```bash
Use Age:
    gvm list                 列出已安装版本
    gvm listall              列出用版本
    gvm add [version]        安装对应版本
    gvm use [version]        选择对应版本
    gvm version              显示当前使用版本
    gvm remove [version|gvm] 卸载对应版本或卸载gvm
    gvm help                 显示帮助信息
```

# 卸载
```bash
gvm remove gvm
```
