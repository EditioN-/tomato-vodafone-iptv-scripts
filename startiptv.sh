#!/bin/sh
# vodafone router script
# v. 0.6
# WORK IN PROGRESS
# Originally by zipleen
# Vodafone IPTV Adaptation by EditioN-
#
# 22/12/2014 - Versão modificada para Vodafone IPTV, Thanks to zipleen!! (by EditioN-)
# 24/12/2012 - pequena modificao por causa do /21 para /20 - voip stuff  (by zipleen)
# 11/12/2010 - detectao da directoria pelo dirname e deteccao do programa de igmp a usar para facilitar a vida no ddwrt (by zipleen)
# 06/11/2010 - iface added, para facilitar codigo para ddwrt (by zipleen)
# 22/10/2010 - release inicial (by zipleen)

## directoria que vai conter o script
## jffs eh a que aconselho, pode ser qualquer outra como por exemplo cifs1 
## ou tmp/smbshare. deixar o default para simplesmente auto-detectar a directoria onde o script esta
dir=`dirname $0`

# interface do iptv
iface="vlan105"

# descobrir qual igmpproxy usar
# se o igmpproxy na directoria actual existir, vai-se usar esse
# se o igmpproxy n existir, vamos procurar por um igmpproxy e se esse nao existir vamos procurar por um igmprt (ddwrt)
if [ -f `dirname $0`/igmpproxy ]; then
 igmpbin=`dirname $0`/igmpproxy
else
 # nao ha igmpproxy! vamos tentar procurar o igmpproxy..
 if [ `which igmpproxy` != "" ]; then
  igmpbin=`which igmpproxy`
 elif [ `which igmprt` != "" ]; then
  igmpbin=`which igmprt`
 else
  echo "nao existe igmpproxy nem igmprt! tem de existir um igmpproxy ou nada funciona.."
  exit
 fi
fi

# descobrir qual igmp etc file eh para ser usado!
if [ -f `dirname $0`/igmp.alt ]; then
 igmpetcfile=`dirname $0`/igmp.alt
elif [ -f `dirname $0`/igmp.ddwrt.conf ]; then
 igmpetcfile=`dirname $0`/igmp.ddwrt.conf
else
 echo "eh necessario um igmp.alt na directoria pois as firmwares nao conseguem criar um igmp.conf valido!"
 exit
fi

## com este if, podemos correr este script qts vezes quisermos que vamos ter sempre a correr isto bem!
if [ `ps | grep "udhcpc -i $iface" | grep dhcpevent | wc -l` -eq 0 ]; then
 # a interface comeca sempre down
 #ifconfig $iface ether hw 00:26:44:xx:xx:xx
 ifconfig $iface up
 # o dhcp client quando tiver o ip vai correr o outro script (-S)
 udhcpc -i $iface -s /$dir/dhcpevent.sh
 # (tomato) se no /etc/ existir um igmp.alt, o rc service corre o igmpproxy com este ficheiro
 cp /$dir/igmp.alt /etc
 # o dhcpevent vai criar este script que tem de ser corrido
 /tmp/iptablesiptv.sh
fi

# aqui eh verificado se o igmpproxy esta a correr e se nao estiver, corre-o 
if [ `ps | grep 'igmpproxy' | grep 'igmp.alt' | wc -l` -eq 0 ]; then
 $igmpbin $igmpetcfile &
 
 # old ways =)
 #/$dir/igmpproxy /$dir/igmp.alt &
fi

# como o ddwrt nao tem script de firewall para correr "depois", verificamos aqui se os iptables existem (de uma maneira rudimentar)
if [ `iptables -L -t nat | grep '213.13.16.0/20' | grep 'SNAT' | wc -l` -eq 0 ]; then
 /tmp/iptablesiptv.sh
fi
