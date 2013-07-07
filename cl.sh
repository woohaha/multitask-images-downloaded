#!/bin/bash
#===============================================================================
#
#          FILE:  cl.sh
# 
#         USAGE:  ./cl.sh 
# 
#   DESCRIPTION:  一鍵獲取草榴圖片地址
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  woohaha (), realwoohaha@gmail.com
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  07/06/2013 05:02:43 PM HKT
#      REVISION:  ---
#===============================================================================

download_path='.'

[ -z $1 ] && {
	echo '錯誤：沒有輸入網址'
	exit 1
}
wget -N -P /tmp $1

echo -n '#'>> $download_path/$(basename -s .html $1).downloadlist
echo $1 >> $download_path/$(basename -s .html $1).downloadlist

echo -n '#'>> $download_path/$(basename -s .html $1).downloadlist
title=$(grep -Poh '(?<=<title>).*(?=\[)' /tmp/$(basename $1) |enca -L zh_CN -x UTF-8)
echo $title >> $download_path/$(basename -s .html $1).downloadlist
grep -Poh '(?<=src.{2}).*?\.jpe?g' /tmp/$(basename $1) >> $download_path/$(basename -s .html $1).downloadlist


#cat $download_path/$(basename -s .html $1).downloadlist|wget -i- -P $title

downloadlist() {
    ctl=0
    tasks=5
    lines=$(wc -l $1|cut -d' ' -f1)
    while [ $ctl -le $lines ]; do
	   if [ $(ps aux|grep wget|grep -v grep|wc -l) -le $tasks ];then
		  ((ctl++))
		  head -n $ctl $1|tail -n1|wget -i- -N -P $2 &
	   else
		  continue
	   fi
    done
}

downloadlist $download_path/$(basename -s .html $1).downloadlist $title
