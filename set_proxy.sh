# set_proxy.sh文件内容
host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")                                       
export ALL_PROXY="http://$host_ip:7897"                                                                   
echo "设置代理成功，端口：7897，请在Windows中打开客户端允许本地局域网请求" > /home/user/set_proxy.log     # 输出log，验证是否开机运行成功；
exit 0   
