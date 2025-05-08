#!/bin/bash

# ARCH
arch=$(uname -a)

# CPU Physical
cpuf=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)

# CPU Virtual
cpuv=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)

# RAM
freeram=$(free | grep Mem | awk '{print $4}')
totalram=$(free | grep Mem | awk '{print $2}')
usageram=$(free -m | grep Mem | awk '{ printf("%.2f%%"), $3/$2 }')

# Available memory
usedmem=$(df -m | grep /dev/ | grep -v /shm | awk '{print $3}')
totalmem=$(df -Bg | grep /dev/ | grep -v /shm | awk '{print $2}')
usagemem=$(df | grep /dev/ | grep -v /shm | awk '{printf("%.2f%%"), $3/$2}')

# Current utilization rate
cpuload=$(top -bn1 | grep '^%Cpu' | awk '{ printf("%.1f%%"), $2 }')

# Date
lb=$(who -b | awk '{print $3 " " $4}')

# LVM is active
lvm=$(lsblk | grep -q 'lvm' && echo "yes" || echo "no")

# Number of active connections
active_con=$(ss -t | grep ESTAB | wc -l)

# Number of active users
active_user=$(who | awk '{print $1}' | sort -u | wc -l)

# IP and MAC
ip=$(ip a | grep inet | grep -v inet6 | grep 'global dynamic' | cut -d'/' -f1 | awk '{print $2}')
mac=$(ip a | grep link/ether | awk '{print $2}')

wall "Architecture: $arch
CPU physical: $cpuf
vCPU : $cpuv
Memory Usage: $freeram/${totalram}MB ($usageram%)
Disk Usage: $usedmem/${totalmemGb}GB ($usagemem%)
CPU load: $cpuload%
Last boot: $lb
LVM use: $lvmu
Connections TCP : $active_con ESTABLISHED
User log: $active_user
Network: IP $ip ($mac)
Sudo : 42 cmd"
