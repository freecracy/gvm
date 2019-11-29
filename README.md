# 简介
go语言版本管理,自用,非侵入.

# 安装

## 普通安装
```bash
curl https://raw.githubusercontent.com/freecracy/gvm/master/scripts/install | sh
```

## brew 安装
```sh
brew tap freecracy/gvm http://github.com/freecracy/gvm
brew install freecracy/gvm/gvm
```

# 使用
```bash
Use Age:
    gvm list
              列出已安装版本
    gvm list all
                  列出用版本
    gvm [add|install] [version]
                                 安装对应版本
    gvm [use|select] [version]
                                选择对应版本
    gvm version
                 显示当前使用版本
    gvm [rm|remove|uninstall] [version|gvm]
                                             卸载对应版本或卸载gvm
    gvm [help|-h]
                   显示帮助信息
```

# 卸载
```bash
gvm remove gvm
```


