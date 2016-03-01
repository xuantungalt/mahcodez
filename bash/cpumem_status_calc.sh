#/bin/sh

_SCRIPDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
_STATLOGF="cpu-mem-status.log"
_STATPROG=$(which mpstat)
[ $? -eq 0  ] || exit 1

_CURTIME=$(date +'%Y-%m-%d %Hh%Mm%Ss')
IFS=$'\n\r'

if [ -z $1 ]
then
	_STATLINE="$_CURTIME|"
	for _STAT in $(mpstat -P ALL|sed -n '/all/,$p')
	do
		_STATLINE="$_STATLINE"$(echo $_STAT|awk '{print $3":"$4"|"}')
	done
	_MEMSTAT=$(free -m|grep 'Mem:'|awk '{printf("mem:%.2f\n", ($3 / $2) * 100)}')
	_STATLINE=$_STATLINE$_MEMSTAT
	echo $_STATLINE >> "$_SCRIPDIR/$_STATLOGF"
else
	case $1 in
	calc)
		_SUMOFCPU=0
		_SUMOFRAM=0
		_NOFLINES=0
		_RAMVALUE=0
		_CPUVALUE=0
		for _ALINE in $(cat "$_SCRIPDIR/$_STATLOGF")
		do
			_CPUUSAGE=$(echo $_ALINE|awk -F '|' '{print $2}' | awk -F ':' '{print $2}')
			[ $(echo "$_CPUUSAGE>$_CPUVALUE" | bc) -eq 1 ] && _CPUVALUE=$_CPUUSAGE
			_SUMOFCPU=$(echo "$_CPUUSAGE + $_SUMOFCPU" | bc)

			_RAMUSAGE=$(echo $_ALINE|awk -F '|' '{print $NF}' | awk -F ':' '{print $2}')
			[ $(echo "$_RAMUSAGE>$_RAMVALUE" | bc) -eq 1 ] && _RAMVALUE=$_RAMUSAGE
			_SUMOFRAM=$(echo "$_RAMUSAGE + $_SUMOFRAM" | bc)

			_NOFLINES=$(echo "$_NOFLINES + 1" | bc)
		done
		_SFROM=$(head -n 1 "$_SCRIPDIR/$_STATLOGF" | awk -F '|' '{print $1}')
		_STO=$(tail -n 1 "$_SCRIPDIR/$_STATLOGF" | awk -F '|' '{print $1}')
		echo "Average usage from: $_SFROM -> $_STO"
		echo "CPU Average: "$(echo "$_SUMOFCPU $_NOFLINES" | awk '{printf("Average: %.2f%%\n", $1 / $2)}')
		echo "CPU Peak: $_CPUVALUE%"
		echo "RAM Average: "$(echo "$_SUMOFRAM $_NOFLINES" | awk '{printf("Average: %.2f%%\n", $1 / $2)}')
		echo "RAM Peak: $_RAMVALUE%"
		cat "$_SCRIPDIR/$_STATLOGF" | grep --color "$_CPUVALUE\|$_RAMVALUE"
		;;	
	*)
		echo "usage: status.sh <calc>"
		;;
	esac
fi

unset IFS
