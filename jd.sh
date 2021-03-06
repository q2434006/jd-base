#!/usr/bin/env bash

## Author: Evine Deng
## Source: https://github.com/EvineDeng/jd-base
## Modified： 2021-01-27
## Version： v3.8.0

## 路径
ShellDir=${JD_DIR:-$(cd $(dirname $0); pwd)}
[ ${JD_DIR} ] && HelpJd=jd || HelpJd=jd.sh
ScriptsDir=${ShellDir}/scripts
ConfigDir=${ShellDir}/config
FileConf=${ConfigDir}/config.sh
FileConfSample=${ShellDir}/sample/config.sh.sample
LogDir=${ShellDir}/log
ListScripts=($(cd ${ScriptsDir}; ls *.js | grep -E "j[drx]_"))
ListCron=${ConfigDir}/crontab.list

## 导入config.sh
function Import_Conf {
  if [ -f ${FileConf} ]
  then
    . ${FileConf}
    if [ -z "${Cookie1}" ]; then
      echo -e "请先在config.sh中配置好Cookie...\n"
      exit 1
    fi
  else
    echo -e "配置文件 ${FileConf} 不存在，请先按教程配置好该文件...\n"
    exit 1
  fi
}

## 更新crontab
function Detect_Cron {
  if [[ $(cat ${ListCron}) != $(crontab -l) ]]; then
    crontab ${ListCron}
  fi
}

## 用户数量UserSum
function Count_UserSum {
  for ((i=1; i<=1000; i++)); do
    Tmp=Cookie$i
    CookieTmp=${!Tmp}
    [[ ${CookieTmp} ]] && UserSum=$i || break
  done
}

## 组合Cookie和互助码子程序
function Combin_Sub {
  CombinAll=""
  for ((i=1; i<=${UserSum}; i++)); do
    for num in ${TempBlockCookie}; do
      if [[ $i -eq $num ]]; then
        continue 2
      fi
    done
    Tmp1=$1$i
    Tmp2=${!Tmp1}
    case $# in
      1)
        CombinAll="${CombinAll}&${Tmp2}"
        ;;
      2)
        CombinAll="${CombinAll}&${Tmp2}@$2"
        ;;
      3)
        if [ $(($i % 2)) -eq 1 ]; then
          CombinAll="${CombinAll}&${Tmp2}@$2"
        else
          CombinAll="${CombinAll}&${Tmp2}@$3"
        fi
        ;;
      4)
        case $(($i % 3)) in
          1)
            CombinAll="${CombinAll}&${Tmp2}@$2"
            ;;
          2)
            CombinAll="${CombinAll}&${Tmp2}@$3"
            ;;
          0)
            CombinAll="${CombinAll}&${Tmp2}@$4"
            ;;
        esac
        ;;
    esac
  done
  echo ${CombinAll} | perl -pe "{s|^&||; s|^@+||; s|&@|&|g; s|@+|@|g}"
}

## 组合Cookie、Token与互助码，用户自己的放在前面，我的放在后面
function Combin_All {
  export JD_COOKIE=$(Combin_Sub Cookie)
  export FRUITSHARECODES=$(Combin_Sub ForOtherFruit "10d586425f004bea9bc6a4efd8ded363@a4d4d8f7d5224ed3965f3fb96ead3ca7@f5fa8239d8634af6a9cfbb02b63e75be@838307aafca140a288a57b13acaeefc9@e287868088134f85a51aa612aef799eb")
  export PETSHARECODES=$(Combin_Sub ForOtherPet "MTE1NDAxNzcwMDAwMDAwMzg2OTEyMDE=@MTE1NDAxNzYwMDAwMDAwMzkxMzA3Nzk=@MTAxODcxOTI2NTAwMDAwMDAxOTgzNTU4MQ==@MTE1NDQ5OTUwMDAwMDAwNDA4MDk2NTk=@MTE1NDQ5MzYwMDAwMDAwNDMxOTcyMzE=")
  export PLANT_BEAN_SHARECODES=$(Combin_Sub ForOtherBean "zeiyrbbt7irnru6qlotfndx5xq@e7lhibzb3zek3mrkd4aiaipvjwizclj63p2jd4q@olmijoxgmjutyje2p7ynkacag3ahc2jd5krr37q@glx6bffm23glbaxrusyezlowaq5ac3f4ijdgqji@fn5sjpg5zdejmbqx6uhnni3lxetodlduifw5k5q@kb6dfwffm5de336qzhnns4vsyq")
  export DREAM_FACTORY_SHARE_CODES=$(Combin_Sub ForOtherDreamFactory "e2yLK9zErwCxQxXbTeZwkQ==@C8J7ycznIiIYHrAL_PtHUQ==@74yuQa-ShHL8Jtks8Ea27Q==@hdm0lFdPU0Z7wlGfDCHqdQ==")
  export DDFACTORY_SHARECODES=$(Combin_Sub ForOtherJdFactory "T015vPlwRB4Z81bUT0cCjVWnYaS5kRrbA@T0225KkcRBYe8F2Ccx6nkPcNcQCjVWnYaS5kRrbA@T0225KkcRhlM8l3WIRqllqZZIQCjVWnYaS5kRrbA@T016a1bYlYq8Lelu94x6CjVWnYaS5kRrbA@T0205KkcPFtAogO0WVKM16hRCjVWnYaS5kRrbA")
  export JDZZ_SHARECODES=$(Combin_Sub ForOtherJdzz)
  export JDJOY_SHARECODES=$(Combin_Sub ForOtherJoy "aAnCSbZU5yvB1-IqNP6yLA==@ziY0n_wE07McSaXsVZILNKt9zd5YaBeE@TmasgTEZzD7qxToDIBVScKt9zd5YaBeE@1PPXijvOJzrGfHa3WkUQPg==@75rdQ4LblJ5_u2edcIV72A==")
  export JXNC_SHARECODES=$(Combin_Sub ForOtherJxnc)
  export JXNCTOKENS=$(Combin_Sub TokenJxnc)
  # jd_newYearMoney
  export JDNY_SHARECODES=$(Combin_Sub ForOtherJDNYM)
  # 京东国际
  export JD_GLOBAL_CHA_SHARECODES=$(Combin_Sub ForOtherGLOBAL_CHA)
  export BOOKSHOP_SHARECODES=$(Combin_Sub ForOtherBookShop "a84d199836ec4f81b27f2dc3f87a6b7e@10b13f2a4b2c4f6bb3695c27e7a59140@b481b1aee9264231933350d27d95bcee@cc7c8d5471fd4dedaf4be97c9624d402")
  export JD_CASH_SHARECODES=$(Combin_Sub ForOtherCash "IR80aOyyYP4lnjM@eU9YaOS1Y_VzomqGz3MU0w@eU9YauvnYfUn8G6EySJAgw@9rCcuXgXvkGfJvhb@eU9YEKnrMatFiCatiCxI")
  export JDNIAN_SHARECODES=$(Combin_Sub ForOtherNian "cgxZWifbeu-Wpm2AD0bol5Cu@cgxZ-tAo8DJqM5xu3ogeOY7OXkOQ2Lw_ympGPITqNcceAad8Y1ph2UOXS-LOq3PUCqmgYjpt-td3CYw18qw@cgxZdTXtIrzev12aC1eu5yr9cCz6N7HkgPrFkYPPzBDaaWjtjA3fokuFPMA@cgxZLWaFIb7S4gvPZ1jlo3Ru3_zhiy3nnTsS4mQaaZc" "cgxZWifbeu_a6gmFRGbg6Lh1SmQdF0DUmQ@cgxZdTXtIu6J7ljIXVGv6VoOs61gdyYXgT0ctAtCCykLsWw5accav11_0dI@cgxZ-fMU8RF0M5dV3r4QOsLKNQRnjyuoh9haQkLPPMH6fJjgVIkoZy5ww_K-I2JJ@cgxZ-OAB8S5NPaJF0LUYNl1oYE9tdRYPs2e2kWz3RrqEMgqutLWhZlw" "cgxZdTXtIuyLvwyYXgWh7YMhXtAVbaE0Ozjf2OUdEJZsvB1JgZ-5v5F_bDc@cgxZdTXtI-iI6FycAFH7u-1dMgurAZjyJ58rjmucS1-MNDQLuuFxg0MP4nk@cgxZdTXtIr7e6AzPXQT666v1QrNvBgZa6pzohEggDpwCCoJqAmI3w2yaU_s@cgxZdTXtIb7b4gbIXQSu6lqwwvtQXfo34CxB9K3ndzOzMDWK93LMQ85BnsQ")
  if [[ $(date -u "+%H") -eq 12 ]] || [[ $(date -u "+%H") -eq 13 ]]; then
    export JDNIANPK_SHARECODES=$(Combin_Sub ForOtherNianPk "IgNWdiLGaPavrFeXXWqpo92CVx1rlFXa1hw@IgNWdiLGaPYPW6QdgLVwfWRfHi2sIXbO_6hkp5Nr2iQcqjh14hEp3rCPZEl-yN5DMhuIkmTMvwsMySwsQBXxWw@IgNWdiLGaPaAvmHPDgH8vAJv1gVmRQDCnfIVBGR1YL3lZ0Mg7ZEiozjTjCdf89ov@IgNWdiLGaPbY7QnMDA2h6oo8Zl9cHaLDgH6QPmTn0q2RXfS87n0@IgNWdiLGaPavrFeXXQWp6ManqCzbdRZ7medtakVd_L0@IgNWdiLGaPaAvmHPXlT87UNYCPQXNpYWPdp-07g7zX8y2QkXwRtY2WnqEQ20Kpyh" "IgNWdiLGaPaAvmHPXFatuVqLKY15hpHmyg4fhXsFsRff2aOCWUu0_7H0YKL4vTvw@IgNWdiLGaPYMeJgco6twdnEMl2rrhxlHqH_OGEhGAmaFSuLs3fmrFj0xyOcRB27Ueur0pQ@IgNWdiLGaPYNa40cnJJ-Q3yU2CnzdMURKoahzOZQqq0TG7hyAFOUIXwKLVE0fw@IgNWdiLGaPaAvmHOWlerveOAjRDDS82JlJNWJL9xrIGrdFL_OGjK2z6Io6AIAbXG@IgNWdiLGaPaAvmHPDAGr7dyADPlqIEeTrfW5IA1FeA8sbmZ48J_ipjzhagoDxvop@IgNWdiLGaPaAvmHMDASh59_hel_M5qSDfbknFBwDTlaynaDxiGO6-aTtWJPQkFxA")
  else
    export JDNIANPK_SHARECODES=$(Combin_Sub ForOtherNianPk)
  fi
  export JDSXSY_SHARECODES=$(Combin_Sub ForOtherImmortal "23xIs4YwE5Z7HdgnUcxRT-XlSoXoJLmBE@56xIs4YwE5Z7G8-z3rXfTNliqVYXz9M6JRXG-yH8Vx4dLQzrizP4dLTPyH1_nW4EszjVqzvYCF7YE6CoNmvdjLBMjQ_@43xIs4YwE5Z7DsWOzDSP_d8Rjea5vaaX61gfhVs6SfEGnwcZB9wEJX2m2nHKOaC6Zjyw" "34xIs4YwE5Z7HhWvhuV0OSNsWxu4l5KyQo6VAKcMVw0BbhzvPXXg@43xIs4YwE5Z7DsWOzDSPOBTEaue3ty6EyxKwJhHK0IpkCccZB9wBAAi2jzGjO7Zk0NBQ@46xIs4YwE5Z7G9J6kzXVQUmik-F9Rd23gLTdzlTswGj7g5F1Q_VaEE-_9VqfmrrK7GkGwYKFc" "40xIs4YwE5Z7G9Wz1fXbiNaj7BIJ_cEtkCA14e3w3wC_EWRE9DEWJLOHy4bS9CN@43xIs4YwE5Z7DsWOzDSPPhRRrG8MhYR4xhrORXRDTIPqsocZB9wBIC2jyBAueqKUNS5w@28xIs4YwE5Z7HdgnUcxRT_3luPSlp4IXoJLmBFTjzk")
  export JDSGMH_SHARECODES=$(Combin_Sub ForOtherSgmh "T015vPlwRB4Z81bUT0cCjVWmIaW5kRrbA@T0225KkcRBYe8F2Ccx6nkPcNcQCjVWmIaW5kRrbA@T0225KkcRhlM8l3WIRqllqZZIQCjVWmIaW5kRrbA@T016a1bYlYq8Lelu94x6CjVWmIaW5kRrbA@T0205KkcPFtAogO0WVKM16hRCjVWmIaW5kRrbA")
  export JSMOBILEFESTIVAL_SHARECODES=$(Combin_Sub ForOtherJdMobileFestival)
}

## 转换JD_BEAN_SIGN_STOP_NOTIFY或JD_BEAN_SIGN_NOTIFY_SIMPLE
function Trans_JD_BEAN_SIGN_NOTIFY {
  case ${NotifyBeanSign} in
    0)
      export JD_BEAN_SIGN_STOP_NOTIFY="true"
      ;;
    1)
      export JD_BEAN_SIGN_NOTIFY_SIMPLE="true"
      ;;
  esac
}

## 转换UN_SUBSCRIBES
function Trans_UN_SUBSCRIBES {
  export UN_SUBSCRIBES="${goodPageSize}\n${shopPageSize}\n${jdUnsubscribeStopGoods}\n${jdUnsubscribeStopShop}"
}

## 申明全部变量
function Set_Env {
  Count_UserSum
  Combin_All
  Trans_JD_BEAN_SIGN_NOTIFY
  Trans_UN_SUBSCRIBES
}

## 随机延迟子程序
function Random_DelaySub {
  CurDelay=$((${RANDOM} % ${RandomDelay} + 1))
  echo -e "\n命令未添加 \"now\"，随机延迟 ${CurDelay} 秒后再执行任务，如需立即终止，请按 CTRL+C...\n"
  sleep ${CurDelay}
}

## 随机延迟判断
function Random_Delay {
  if [ -n "${RandomDelay}" ] && [ ${RandomDelay} -gt 0 ]; then
    CurMin=$(date "+%M")
    if [ ${CurMin} -gt 2 ] && [ ${CurMin} -lt 30 ]; then
      Random_DelaySub
    elif [ ${CurMin} -gt 31 ] && [ ${CurMin} -lt 59 ]; then
      Random_DelaySub
    fi
  fi
}

## 使用说明
function Help {
  echo -e "本脚本的用法为："
  echo -e "1. bash ${HelpJd} xxx      # 如果设置了随机延迟并且当时时间不在0-2、30-31、59分内，将随机延迟一定秒数"
  echo -e "2. bash ${HelpJd} xxx now  # 无论是否设置了随机延迟，均立即运行"
  echo -e "3. bash ${HelpJd} hangup   # 重启挂机程序"
  echo -e "4. bash ${HelpJd} resetpwd # 重置控制面板用户名和密码"
  echo -e "\n针对用法1、用法2中的\"xxx\"，无需输入后缀\".js\"，另外，如果前缀是\"jd_\"的话前缀也可以省略。"
  echo -e "当前有以下脚本可以运行（仅列出以jd_、jr_、jx_开头的脚本）："
  cd ${ScriptsDir}
  for ((i=0; i<${#ListScripts[*]}; i++)); do
    Name=$(grep "new Env" ${ListScripts[i]} | awk -F "'|\"" '{print $2}')
    echo -e "$(($i + 1)).${Name}：${ListScripts[i]}"
  done
}

## nohup
function Run_Nohup {
  for js in ${HangUpJs}
  do
    if [[ $(ps -ef | grep "${js}" | grep -v "grep") != "" ]]; then
      ps -ef | grep "${js}" | grep -v "grep" | awk '{print $2}' | xargs kill -9
    fi
  done

  for js in ${HangUpJs}
  do
    [ ! -d ${LogDir}/${js} ] && mkdir -p ${LogDir}/${js}
    LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
    LogFile="${LogDir}/${js}/${LogTime}.log"
    nohup node ${js}.js > ${LogFile} &
  done
}

## pm2
function Run_Pm2 {
  pm2 flush
  for js in ${HangUpJs}
  do
    pm2 restart ${js}.js || pm2 start ${js}.js
  done
}

## 运行挂机脚本
function Run_HangUp {
  Import_Conf && Detect_Cron && Set_Env
  HangUpJs="jd_crazy_joy_coin"
  cd ${ScriptsDir}
  if type pm2 >/dev/null 2>&1; then
    Run_Pm2 2>/dev/null
  else
    Run_Nohup >/dev/null 2>&1
  fi
}

## 重置密码
function Reset_Pwd {
  cp -f ${ShellDir}/sample/auth.json ${ConfigDir}/auth.json
  echo -e "控制面板重置成功，用户名：admin，密码：adminadmin\n"
}

## 运行京东脚本
function Run_Normal {
  Import_Conf && Detect_Cron && Set_Env
  
  FileNameTmp1=$(echo $1 | perl -pe "s|\.js||")
  FileNameTmp2=$(echo $1 | perl -pe "{s|jd_||; s|\.js||; s|^|jd_|}")
  SeekDir="${ScriptsDir} ${ScriptsDir}/backUp ${ConfigDir}"
  FileName=""
  WhichDir=""

  for dir in ${SeekDir}
  do
    if [ -f ${dir}/${FileNameTmp1}.js ]; then
      FileName=${FileNameTmp1}
      WhichDir=${dir}
      break
    elif [ -f ${dir}/${FileNameTmp2}.js ]; then
      FileName=${FileNameTmp2}
      WhichDir=${dir}
      break
    fi
  done
  
  if [ -n "${FileName}" ] && [ -n "${WhichDir}" ]
  then
    [ $# -eq 1 ] && Random_Delay
    LogTime=$(date "+%Y-%m-%d-%H-%M-%S")
    LogFile="${LogDir}/${FileName}/${LogTime}.log"
    [ ! -d ${LogDir}/${FileName} ] && mkdir -p ${LogDir}/${FileName}
    cd ${WhichDir}
    env
    node ${FileName}.js | tee ${LogFile}
  else
    echo -e "\n在${ScriptsDir}、${ScriptsDir}/backUp、${ConfigDir}三个目录下均未检测到 $1 脚本的存在，请确认...\n"
    Help
  fi
}

## 命令检测
case $# in
  0)
    echo
    Help
    ;;
  1)
    if [[ $1 == hangup ]]; then
      Run_HangUp
    elif [[ $1 == resetpwd ]]; then
      Reset_Pwd
    else
      Run_Normal $1
    fi
    ;;
  2)
    if [[ $2 == now ]]; then
      Run_Normal $1 $2
    else
      echo -e "\n命令输入错误...\n"
      Help
    fi
    ;;
  *)
    echo -e "\n命令过多...\n"
    Help
    ;;
esac
