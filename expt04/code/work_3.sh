#!/bin/bash

function usage
{
	echo "Usage: work_3.sh [options]"
	echo "the options:"
	echo "-h	统计来源主机TOP 100和分别对应的总次数"
	echo "-i	统计来源主机TOP 100 IP 和分别对应的总次数"
	echo "-u	统计最频繁被访问的URL TOP 100"
	echo "-s	统计不同相应状态码的出现次数和对应百分比"
	echo "-4	统计不同4XX状态码对应的TOP 10 URL和对应出现总次数"
	echo "-url	给定URL输出TOP 100访问来源主机"
	echo "-help"	

}

#统计来源主机TOP 100和分别对应的总次数
function host
{
	echo "统计来源主机TOP 100和分别对应的总次数:"
	sed -e '1d' web_log.tsv | awk -F '\t' '{a[$1]+=1} END {for(i in a) {print a[i],i}}' | sort -nr -k 2 | head -n 100

}

#统计来源主机TOP 100 IP 和分别对应的总次数
function ip
{
	echo "来源主机TOP 100 IP 和分别对应的总次数:"

	sed -e '1d' web_log.tsv|awk -F '\t' '{if($1~/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/) print $1}'|awk '{a[$1]++} END {for(i in a){print i,a[i]}}'|sort -nr -k 2 |head -n 100
}

#统计最频繁被访问的URL TOP 100
function url()
{
	echo "统计最频繁被访问的URL TOP 100:"
	awk -F '\t' '{a[$5]+=1} END {for(i in a) {print i}}' web_log.tsv | sort -nr -k 2 | head -n 100

}

#统计不同相应状态码的出现次数和对应百分比
function status_code()
{
	echo "不同相应状态码的出现次数和对应百分比:"
	awk -F '\t' '{a[$6]++;c[1]++} END {for(i in a) {printf("%d %-10d %.4f%\n",i,a[i],a[i]*100/c[1])}}' web_log.tsv|sort -nr -k 2|head -n 100
}

#不同4XX状态码对应的TOP 10 URL和对应出现总次数
function 4xx()
{
	echo "不同4XX状态码对应的TOP 10 URL和对应出现总次数:"
	#先把4xx状态码全部求出来
	a=$(sed -e '1d' 'web_log.tsv'|awk -F '\t' '{if($6~/^4+/) a[$6]++} END {for(i in a) print i}')
	#对于每一个4xx，求其top x
	for i in $a
	do
 	      	sed -e '1d' web_log.tsv|awk -F '\t' '{if($6~/^'$i'/) a[$6][$5]++} END {for(i in a){for(j in a[i]){print i,j,a[i][j]}}}'|sort -nr -k3|head -n 10
	done

}

# 给定URL输出TOP 100访问来源主机
function url_host()
{
	echo "给定URL输出TOP 100访问来源主机"
	awk -F '\t' '{if($5=="'$1'") a[$1]++} END {for(i in a){print i,a[i]}}' web_log.tsv |sort -nr -k 2|head -n 100	
}
while [[ "$#" -ne 0 ]];do
	case "$1" in
		"-h")
			host
			shift
			;;
		"-i")
			ip
			shift
			;;
		"-u")
			url
			shift
			;;
		"-s")
			status_code
			shift
			;;
		"-4")
			4xx
			shift
			;;
		"-url")
			url_host "$2"
			shift 2
			;;
		"-help")
			usage
			shift
			;;
	esac
done
