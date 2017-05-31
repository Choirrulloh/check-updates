#!/bin/bash

HOSTNAME=$(hostname -s)

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
echo "<updates> <host>";
echo "<name>$HOSTNAME</name>"
echo -ne "<engine>"

if [ -x /usr/bin/yum ]; then
  echo -ne "yum</engine>\n<packages>"
  yum -q list updates |tac |head --lines=-1 | while read i
    do
    i=$(echo $i) #this strips off yum's irritating use of whitespace
    if [ "${i}x" != "x" ]
    then
      UVERSION=${i#*\ }
      UVERSION=${UVERSION%\ *}
      PNAME=${i%%\ *}
      echo -ne "<package>\n<name>$PNAME</name>\n"
      echo -ne "<cur>$(yum -q list installed $PNAME | tail -n 1|awk '{print $2}')</cur>\n"
      echo -ne "<next>$UVERSION</next>\n</package>\n"
    fi
  done

  echo -ne "\n"

elif [ -x /usr/bin/apt-get ]; then
  apt-get -qq update 
  echo -ne "apt</engine>\n<packages>\n"
  apt-get --just-print upgrade 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1:::$2:::$3\n"}'|awk -F':::' '{print "<package><name>"$1"</name><cur>"$2"</cur><next>"$3"</next></package>" }'
  echo -ne "\n"
fi

echo -ne "</packages>\n</host>\n</updates>"
