#!/bin/bash

#帮助文档
function usage()
{
	echo "usage: bash work_2.sh [options]"
	echo "the options:"
	echo "-a	统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比"
	echo "-p	统计不同场上位置的球员数量、百分比"
	echo "-n	名字最长的球员是谁？名字最短的球员是谁?"
	echo "-g	年龄最大的球员是谁？年龄最小的球员是谁?"
	echo "-h	帮助文档"
}

#统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员>数量、百分比
function age_range()
{

	sum=0
	age_20=0
	age_20_30=0
	age_30=0
	age=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)

	for a in $age
	do
		if [ "$a" != 'Age' ] ; then
			let sum+=1

			if [ "$a" -lt 20 ]; then
	
				let age_20+=1

			elif [ "$a" -gt 30 ]; then
		
				let age_30+=1
		 
			else	
				let age_20_30+=1
			fi
		fi
	done

	rate1=$( awk 'BEGIN{printf "%.2f",'$age_20*100/$sum'}')
	rate2=$( awk 'BEGIN{printf "%.2f",'$age_20_30*100/$sum'}')
	rate3=$( awk 'BEGIN{printf "%.2f",'$age_30*100/$sum'}')

	echo "20岁以下的人数与比例分别为："$age_20" "$rate1"%"
	echo "20岁到30岁之间的人数与比例分别为："$age_20_30" "$rate2"%"
	echo "30岁以上的人数与比例分别为："$age_30" "$rate3"%"
}

#统计不同场上位置的球员数量、百分比
function positons()
{
	all=0
	POSITIONS=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)
	declare -A dic

	for line in $POSITIONS
	do
		if [[ $line != 'Position' ]];then
			let all+=1

			if [[ !${dic[$line]} ]];then
				let dic[$line]+=1
			else
				dic[$line]=0
			fi
		fi
	done
	for key in ${!dic[@]}
	do
		rate=$(awk 'BEGIN{printf "%.2f",'${dic[$key]}*100/$all'}')
   		 echo  "$key : ${dic[$key]}"" 所占比例为：""$rate"'%'
	done
}

#名字最长的球员是谁？名字最短的球员是谁?
function name()
{
	name=$(awk -F '\t' '{print length($9)}' worldcupplayerinfo.tsv)
	longest=0
	shortest=100
	count=0

	for n in $name
	do
		let count+=1
		if [[ $n -gt $longest ]];then
			longest=$n
			long_name=$(sed -n $count'p' 'worldcupplayerinfo.tsv'|awk -F '\t' '{print $9}')
		fi
		if [[ $n -lt $shortest ]];then
			shortest=$n
			short_name=$(sed -n $count'p' 'worldcupplayerinfo.tsv'|awk -F '\t' '{print $9}')
		fi
	done


	echo "名字最长的运动员是："$long_name" 有"$longest"个字符"
	echo "名字最短的运动员是："$short_name" 有"$shortest"个字符"
}
#年龄最大的球员是谁？年龄最小的球员是谁?
function age()
{
	 age=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
	 max=0
	 min=100
	 total=0

	 for a in $age
	 do
		 if [ "$a" != "Age" ];then
			 let total+=1
		
			 if [[ $a -gt $max ]];then
				 max=$a
				 max_name=$(awk -F '\t' 'NR=='$total' {print $9}' worldcupplayerinfo.tsv)
			 fi
			 if [[ $a -lt $min ]];then
				 min=$a
				 min_name=$(awk -F '\t' 'NR=='$total' {print $9}' worldcupplayerinfo.tsv)
			 fi
		 fi
	 done

	 echo "年龄最大的球员是："$max_name""
	 echo "年龄最小的球员是："$min_name""

}


while [[ "$#" -ne 0 ]]; do
	case "$1" in
		"-a")
			age_range
			shift
			;;
		"-p")
			positons
			shift
			;;
		"-n")
			name
			shift
			;;
		"-g")
			age
			shift
			;;
		"-h")
			usage
			shift
			;;
	esac
done
