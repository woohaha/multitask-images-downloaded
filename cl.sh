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

download_root_path="$HOME/163/lll"
download_path=''
while getopts p:r:s:w:u opt;do
    case $opt in
	   p)
		  download_path="$download_root_path/pure"
		  ;;
	   r)
		  download_path="$download_root_path/rosi"
		  ;;
	   s)
		  download_path="$download_root_path/scute"
		  ;;
	   w)
		  download_path="$download_root_path/white"
		  ;;
	   u)
		  download_path="$download_root_path"
		  ;;
    esac
done
[ -z $download_path ] && download_path=$download_root_path


[ -z $OPTARG ] && OPTARG=$1
[ -z $OPTARG ] && {
	echo '錯誤：沒有輸入網址'
	exit 1
}
wget -N -k -P /tmp $OPTARG

echo -n '#'>> $download_path/$(basename -s .html $OPTARG).downloadlist
echo $OPTARG >> $download_path/$(basename -s .html $OPTARG).downloadlist

echo -n '#'>> $download_path/$(basename -s .html $OPTARG).downloadlist
title=$(grep -Poh '(?<=<title>).*(?=\ +\-)' /tmp/$(basename $OPTARG) |enca -L zh_CN -x UTF-8 | sed 's/  草榴社區//'|tr '\[\]\ ' '_')
echo $title >> $download_path/$(basename -s .html $OPTARG).downloadlist
grep -Poh '(?<=src.{2}).*?\.[jJ][pP][eE]?[gG]' /tmp/$(basename $OPTARG) >> $download_path/$(basename -s .html $OPTARG).downloadlist


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

gallery_gen(){
    ls $1/* | grep -P '(([Jj][Pp][Ee]?[Gg])|([Pp][Nn][Gg]))' |awk -F'/' '{print $NF}'|xargs -n1 -I% echo '<li><a href="%" rel="lightbox"><img class="gallery" src="%" alt="thumbnail image"/></a\></li>' >> $1/index.html
}

echo '正在下載圖片...'
downloadlist $download_path/$(basename -s .html $1).downloadlist $download_path/$title
gallery_gen "$download_path/$title"
echo 'Done!'
rm /tmp/$(basename $OPTARG)
