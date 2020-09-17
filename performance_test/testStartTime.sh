#!/bin/bash
# Author:mochacha
# 日期：2020年9月16日
# 脚本说明：app启动时间测试脚本

# 安装apk包，传入参数：完整apk包地址
apk_install(){
    adb install $1
    sleep 5s
}

# 卸载apk包，传入参数：app包名
apk_uninstall(){
    adb uninstall $1
    sleep 5s
}

# 计算启动时间，传入参数：app<包名>/<活动名>
testStartTime(){
    adb shell am start -W $1 | grep -i Total | sed 's/ //g' | cut -d ":" -f 2
    sleep 5s
}

# 杀掉app进程，传入参数：app包名
clearApp(){
    adb shell am force-stop $1
    sleep 5s
}

# 关闭app
quitApp(){
    adb shell input keyevent 3
    adb shell input keyevent 3
    sleep 5s
}

COLOR='\033[32m'; RES='\033[0m'
read -p "请输入apk地址：" apk_address
read -p "请输入包名和活动名：" package_activity_name
package_name=$(echo ${package_activity_name} | cut -d "/" -f 1)
echo -e "\n"
echo -e "${COLOR}apk包名为：${package_name} ${RES}\n"

# 如果已经安装，先卸载app
apk_uninstall ${package_name}

# 首次安装启动时间，测试5次，取平均值
apk_install ${apk_address}
start_time1=$(testStartTime ${package_activity_name})
apk_uninstall ${package_name}

apk_install ${apk_address}
start_time2=$(testStartTime ${package_activity_name})
apk_uninstall ${package_name}

apk_install ${apk_address}
start_time3=$(testStartTime ${package_activity_name})
apk_uninstall ${package_name}

apk_install ${apk_address}
start_time4=$(testStartTime ${package_activity_name})
apk_uninstall ${package_name}

apk_install ${apk_address}
start_time5=$(testStartTime ${package_activity_name})

echo -e "${COLOR}\n"
echo -e "首次启动时间（ms）：${start_time1} ${start_time2} ${start_time3} ${start_time4} ${start_time5}"
echo -n "平均启动时间（ms）："
echo "(${start_time1}+${start_time2}+${start_time3}+${start_time4}+${start_time5})/5" | bc
echo -e "${RES}\n"

# 热启动的启动时间，测试5次，取平均值
quitApp ${package_name}
start_time1=$(testStartTime ${package_activity_name})

quitApp ${package_name}
start_time2=$(testStartTime ${package_activity_name})

quitApp ${package_name}
start_time3=$(testStartTime ${package_activity_name})

quitApp ${package_name}
start_time4=$(testStartTime ${package_activity_name})

quitApp ${package_name}
start_time5=$(testStartTime ${package_activity_name})

echo -e "${COLOR}"
echo "热启动时间（ms）：${start_time1} ${start_time2} ${start_time3} ${start_time4} ${start_time5}"
echo -n "平均启动时间（ms）："
echo "(${start_time1}+${start_time2}+${start_time3}+${start_time4}+${start_time5})/5" | bc
echo -e "${RES}\n"

# 冷启动的启动时间，测试5次，取平均值
clearApp ${package_name}
start_time1=$(testStartTime ${package_activity_name})

clearApp ${package_name}
start_time2=$(testStartTime ${package_activity_name})

clearApp ${package_name}
start_time3=$(testStartTime ${package_activity_name})

clearApp ${package_name}
start_time4=$(testStartTime ${package_activity_name})

clearApp ${package_name}
start_time5=$(testStartTime ${package_activity_name})

echo -e "${COLOR}"
echo "冷启动时间（ms）：${start_time1} ${start_time2} ${start_time3} ${start_time4} ${start_time5}"
echo -n "平均启动时间（ms）："
echo "(${start_time1}+${start_time2}+${start_time3}+${start_time4}+${start_time5})/5" | bc
echo -e "$RES\n"

echo -e "${COLOR}测试结束，卸载app成功${RES}"
clearApp ${package_name}