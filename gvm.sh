#!/bin/env bash
#https://api.github.com/repos/golang/go/branches
# 获取版本信息
#curl -sSf https://api.github.com/repos/golang/go/branches |grep name |grep release |awk '{printf $2"\n"}' | cut -c17- |tr -d '",'
# 下载相应版本go1.12.9.linux-amd64.tar.gz
set -e
#set -u
set -o pipefail
{

    base=".gvm"
    base_dir="${HOME}/${base}"
    os=$(uname -s)
    file_os="linux"

    [[ $os == "Darwin" ]] && file_os="darwin"

    [[ ! -d $base_dir ]] && mkdir -p  "$base_dir"

    if [[ $1 == "list" ]];then
        printf -- "已安装以下版本:\n"
        for line in $(ls $base_dir) ;do
            if [[ $line == "tar" ]] ; then
                continue
            fi
            printf -- "$line\n"
        done
    fi

    if [[ $1 ==  "listall" ]];then
        printf -- "可选版本:\n"
        version_all=$(curl -sSf https://api.github.com/repos/golang/go/branches |grep name |grep release |awk '{printf $2"\n"}' | cut -c17- |tr -d '",')
        for version in $version_all ;do
             printf -- "$version\n"
        done
    fi

    if [[ $1 == "add" || $1 == "install" && $2 != "" ]];then
        printf -- "[1/4] 开始下载...\n"
        version=$2
        if [[ ! -e "${base_dir}/tar/${2}.${file_os}-amd64.tar.gz" ]] ; then
            printf -- "downloading...\n"
            #wget -qP  $base_dir/tar  https://dl.google.com/go/${2}.${file_os}-amd64.tar.gz
            mkdir -p "$base_dir/tar"
            curl -L "https://dl.google.com/go/${2}.${file_os}-amd64.tar.gz" > "$base_dir/tar/$2.$file_os-amd64.tar.gz"
            #https://raw.githubusercontent.com/golang/go/release-branch.go1.13/VERSION
            if [[ $? != 0 ]] ;then
                 version_rc=$(curl "https://raw.githubusercontent.com/golang/go/release-branch.${version}/VERSION")
                 version=$version_rc
                 #wget -qP  $base_dir/tar  https://dl.google.com/go/${version_rc}.${file_os}-amd64.tar.gz
                 curl -sL "https://dl.google.com/go/${version_rc}.${file_os}-amd64.tar.gz" > "$base_dir/tar/$version_rc.$file_os-amd64.tar.gz"
                 #mv ${base_dir}/tar/${version_rc}.${file_os}-amd64.tar.gz ${base_dir}/tar/${2}.${file_os}-amd64.tar.gz
            fi
        fi
        printf -- "[2/4] 开始解压...\n"
        if [[ ! -d "${base_dir}/${2}" ]] ;then
            printf -- "unzip......\n"
            tar -xvzf "$base_dir/tar/${version}.${file_os}-amd64.tar.gz" -C "$base_dir"
            mv "${base_dir}/go" "${base_dir}/${2}"
        fi
        printf -- "[3/4] 开始安装...\n"
        if [[ ! $GVM  ]]; then
            [[ -s "${HOME}/.zshrc" ]] &&  echo source "${HOME}/.gvmrc" >> ${HOME}/.zshrc
            [[ -s "${HOME}/.bashrc" ]] &&  echo source "${HOME}/.gvmrc" >> ${HOME}/.bashrc
            #source $HOME/.zshrc
            #source $HOME/.bashrc
        fi
        echo export GOROOT="${base_dir}/${2}" > ${HOME}/.gvmrc
        echo export GOTOOLDIR="${base_dir}/${2}/pkg/tool/${file_os}_amd64" >> ${HOME}/.gvmrc
        echo export GVM=true >> ${HOME}/.gvmrc
        echo export GVM_VERSION=$2 >> ${HOME}/.gvmrc
        gvm_path="${base_dir}/${2}/bin"
        if [[ -z $GOPATH ]] ;then
            GOPATH="${HOME}/.go"
        fi
        mkdir -p $GOPATH
        echo export GOBIN="${GOPATH}/bin" >> ${HOME}/.gvmrc
        echo export PATH='$GOROOT'/bin:'$GOBIN':'$PATH' >> ${HOME}/.gvmrc
        source ${HOME}/.gvmrc
        printf -- "[4/4] 安装完成"
        gvm sersion
    fi

    if [[ $1 == "remove" || $1 == "uninstall" || $1 == "rm" ]];then
        #printf -- "remove && uninstall\n"
        if [[ $2 == "gvm" ]];then
            sudo rm -rf /usr/local/bin/gvm && rm -rf ${base_dir} && rm -rf  "${HOME}/.gvmrc"
        fi
        if [[ -d "${base_dir}/${2}" ]] ;then
            rm -rf "${base_dir}/${2}"
            [[ -f ${GOPATH}/bin/go ]] && rm -rf ${GOPATH}/bin/go
        fi
    fi

    if [[ $1 == "use" ||  $1 == "select" && $2 != "" ]] ;then

        if [[ ! -d "${base_dir}/${2}" ]];then
            gvm add $2
        fi

        echo  export GOROOT="${base_dir}/${2}" } > "${HOME}/.gvmrc"
        echo export GOTOOLDIR="${base_dir}/${2}/pkg/tool/linux_amd64" } >> ${HOME}/.gvmrc
        #echo export GOBIN="${base_dir}/${2}/bin" >> ${HOME}/.gvmrc
        echo export GVM=true >> ${HOME}/.gvmrc
        echo export GVM_VERSION=$2 >> ${HOME}/.gvmrc
        gvm_path="${base_dir}/${2}/bin"
        if [[ -z $GOPATH ]] ;then
            GOPATH="${HOME}/.go"
        fi
        mkdir -p $GOPATH
        echo export GOBIN="${GOPATH}/bin" >> ${HOME}/.gvmrc
        echo export PATH='$GOROOT'/bin:'$GOPATH'/bin:'$PATH' >> ${HOME}/.gvmrc
        source ${HOME}/.gvmrc
    fi

    if [[ $1 == "version" || $1 == "-v" ]] ; then
        if command -v go > /dev/null ;then
            go version
        fi
    fi

    if [[ $1 == "help" || $1 == "-h" || $1 = "" ]] ; then
        printf -- "Use Age:\n"
        printf -- "    gvm list                 列出已安装版本\n"
        printf -- "    gvm listall              列出用版本\n"
        printf -- "    gvm add [version]        安装对应版本\n"
        printf -- "    gvm use [version]        选择对应版本\n"
        printf -- "    gvm version              显示当前使用版本\n"
        printf -- "    gvm rm  [version|gvm] 卸载对应版本或卸载gvm\n"
        printf -- "    gvm help                 显示帮助信息\n"
    fi

}
exit 0


base_dir=$HOME"/.gvm"

if [[ ! -d $base_dir ]] ; then
    mkdir -p  $base_dir
fi

echo "[1/3]"
if [[ ! -e "${base_dir}/tar/go1.12.9.linux-amd64.tar.gz" ]] ; then
    echo "downloading..."
    wget -qP  $base_dir/tar  https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
fi

echo "[2/3]"
if [[ ! -d "$base_dir/go1.12.9" ]] ;then
    echo "downloading......"
    tar xzf $base_dir/tar/go1.12.9.linux-amd64.tar.gz -C $base_dir
    mv $base_dir/go $base_dir/go1.12.9
fi

echo "[3/3]"
echo export GOROOT="${base_dir}/go1.12.9" > "$HOME/.gvmrc"
 { export GOTOOLDIR="${GOROOT}/pkg/tool/linux_amd64" >> "$HOME/.gvmrc"
echo export GOBIN="${base_dir}/bin" >> "$HOME/.gvmrc"
echo export GVM=true >> "$HOME/.gvmrc"
if [[ ! $GVM ]]; then
    [[ -s "${HOME}/.gvmrc" ]] &&  echo source "${HOME}/.gvmrc" >> "$HOME/.zshrc"
fi
