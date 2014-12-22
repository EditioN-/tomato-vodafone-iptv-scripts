#!/bin/sh
# vodafone router script
# v. 0.6
# WORK IN PROGRESS
# Originally by zipleen
# Vodafone IPTV Adaptation by EditioN-
# 22/12/2014 - Adaptação do script para Vodafone IPTV. Este serviço usa bastantes mais redes que o MEO, estas foram portadas do thomson
# 24/12/2012 - o voip usa a gama a seguir ah que eu tinha definido, apesar da meo so usar essa gama de ips, tive de meter o resto da gama
# 25/12/2010 - rp_filter tem de estar off para multicast funcionar!! tomato fixed!
# 07/11/2010 - wireless ebtables drop multicast
# 06/11/2010 - usar o iface para ficar compativel com ddwrt
# 28/10/2010 - a rede 10.173.0.0 eh melhor em vez da 10.172.192 pois havia hosts 10.173.7.X a quererem enviar streams! added a 10.173.x.x ao forward
# 22/10/2010 - release inicial, ver http://blog.lvengine.com/articles/how-to-make-meo-fiber-iptv-service-work-with-another-router

iface=$interface

deconfig() {
 ifconfig $iface 0.0.0.0
}

bound() {
  #debug das environment variables
  #env > /tmp/env
  
  # definir o ip
  ifconfig $iface $ip netmask $subnet
 	
  # rp_filter tem de estar off na vlan12!!!
  echo 0 > /proc/sys/net/ipv4/conf/$iface/rp_filter
   
  # o route original - a rota seguinte ja trata desta, ptt esta n eh necessaria
  #route add -net 10.194.128.0 netmask $subnet gw $router dev $iface 
  
  route add -net 212.18.177.96 netmask 255.255.255.224 gw $router dev $iface
 
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=95.136.[4-5].* mask=23
  ## 95.136.4.1 -> 95.136.5.254
  ## 95.136.4.0 / 255.255.254.0 / 23
  route add -net 95.136.4.0 netmask 255.255.254.0 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=213.30.36.212 mask=32
  ## 213.30.36.212 / 255.255.255.255
  route add -net 213.30.36.212 netmask 255.255.255.255 gw $router dev $iface
  route add -net 87.103.116.0 netmask 255.255.252.0 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=10.20.100.[0-31] mask=27
  ## 10.20.100.1 -> 10.20.100.30
  ## 10.20.100.0 / 255.255.255.224 / 27
  route add -net 10.20.100.0 netmask 255.255.255.224 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=87.103.[116-119].* mask=22
  ## 87.103.116.1 -> 87.103.119.254
  ## 87.103.116.0 / 255.255.252.0 / 22
  route add -net 95.136.4.112 netmask 255.255.252.0 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=93.108.253.[128-255] mask=25
  ## 93.108.253.129 -> 93.108.253.254
  ## 93.108.253.128 / 255.255.255.128 / 25
  route add -net 93.108.253.128 netmask 255.255.255.128 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=10.20.110.[0-31] mask=27
  ## 10.20.110.1 -> 10.20.110.30
  ## 10.20.110.0 / 255.255.255.224 / 27
  route add -net 10.20.110.0 netmask 255.255.255.224 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=10.20.120.[0-31] mask=27
  ## 10.20.120.1 -> 10.20.120.30
  ## 10.20.120.0 / 255.255.255.224 / 27
  route add -net 10.20.120.0 netmask 255.255.255.224 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=10.20.150.[0-31] mask=27
  ## 10.20.150.1 -> 10.20.150.30
  ## 10.20.150.0 / 255.255.255.224 / 27
  route add -net 10.20.150.0 netmask 255.255.255.224 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=213.30.43.16 mask=32
  ## 213.30.43.16 / 255.255.255.255
  route add -net 213.30.43.16 netmask 255.255.255.255 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=213.30.36.[208-215] mask=29
  ## 213.30.36.209 -> 213.30.36.215
  ## 213.30.36.208 / 255.255.255.248 / 29
  route add -net 213.30.36.208 netmask 255.255.255.248 gw $router dev $iface
  
  # rule add chain=qos_user_labels index=1 dstip=IPTVnetVDF log=disabled state=enabled label=Video
  # add name=IPTVnetVDF type=ip addr=10.163.114.0/24 mask=24
  ## 10.163.114.1 -> 10.163.114.254
  ## 10.163.114.0 / 255.255.255.0 / 24
  route add -net 10.163.114.0 netmask 255.255.255.0 gw $router dev $iface
   
  # FORWARD parece ser preciso para passar os packets daquelas outras redes para a rede local
  # SNAT para a br0 conseguir aceder ah nossa redes privadas iptv
  echo "#!/bin/sh" > /tmp/iptablesiptv.sh 
  echo "if [ \`iptables -L -t nat -n | grep 95.136.4.0/23 | wc -l\` -eq 0 ]; then" >> /tmp/iptablesiptv.sh
  echo "iptables -I INPUT 1 -p igmp -j ACCEPT" >> /tmp/iptablesiptv.sh
  echo "iptables -I INPUT 1 -i $iface -p udp --dst 224.0.0.0/4 --dport 1025: -j ACCEPT" >> /tmp/iptablesiptv.sh
  # pela razao la de cima, vamos adicionar a 10.173.* ao forward
  #echo "iptables -I INPUT 1 -i $iface -s 194.65.46.0/23 -p udp -j ACCEPT" >> /tmp/iptablesiptv.sh
  #echo "iptables -I FORWARD -i $iface -o br0 -s 10.173.192.0/18 -j ACCEPT" >> /tmp/iptablesiptv.sh 
  echo "iptables -I FORWARD -i $iface -o br0 -s 10.70.0.0/16 -j ACCEPT" >> /tmp/iptablesiptv.sh
  echo "iptables -I FORWARD -i $iface -o br0 -s 95.136.4.0/23 -j ACCEPT" >> /tmp/iptablesiptv.sh
  echo "iptables -I FORWARD -i $iface -o br0 -s 212.18.177.96/27 -j ACCEPT" >> /tmp/iptablesiptv.sh
  echo "iptables -I FORWARD -i $iface -o br0 -s 87.103.116.0/22 -j ACCEPT" >> /tmp/iptablesiptv.sh
  echo "iptables -I FORWARD -i $iface -o br0 -s 93.108.253.128/25 -j ACCEPT" >> /tmp/iptablesiptv.sh
  # o router original parece nao dar acesso ah rede 10.x ...
  #echo "iptables --table nat -I POSTROUTING 1 --out-interface $iface --source 192.168.1.0/24 --destination 10.173.192.0/18 --jump SNAT --to-source $ip" >> /tmp/iptablesiptv.sh
  #echo "iptables --table nat -I POSTROUTING 1 --out-interface $iface --source 192.168.1.0/24 --destination 10.173.0.0/16 --jump SNAT --to-source $ip" >> /tmp/iptablesiptv.sh
  echo "iptables --table nat -I POSTROUTING 1 --out-interface $iface --source 192.168.1.0/24 --destination 95.136.4.0/23 --jump SNAT --to-source $ip" >> /tmp/iptablesiptv.sh
  echo "iptables --table nat -I POSTROUTING 1 --out-interface $iface --source 192.168.1.0/24 --destination 212.18.177.96/20 --jump SNAT --to-source $ip" >> /tmp/iptablesiptv.sh
  echo "iptables --table nat -I POSTROUTING 1 --out-interface $iface --source 192.168.1.0/24 --destination 87.103.116.0/22 --jump SNAT --to-source $ip" >> /tmp/iptablesiptv.sh
  
  # ebtables necessita build > 52!
  #echo "ebtables -t nat -F" >> /tmp/iptablesiptv.sh 
  #echo "ebtables -t nat -A OUTPUT -o eth1 -d Multicast -p 0x800 --ip-proto udp --ip-dst 239.255.255.250/32 -j ACCEPT" >> /tmp/iptablesiptv.sh
  #echo "ebtables -t nat -A OUTPUT -o eth1 -d Multicast -j DROP" >> /tmp/iptablesiptv.sh
  
  #echo "iptables --table nat -I POSTROUTING 1 --out-interface $iface --source 192.168.1.0/24 --destination 213.13.18.164/32 --jump SNAT --to-source $ip" >> /tmp/iptablesiptv.sh
  echo "fi" >> /tmp/iptablesiptv.sh
  chmod +x /tmp/iptablesiptv.sh
}

renew() {
  # sou lazy e vou correr apenas os comandos todos outra vez! parece workar :P
  bound
}

case $1 in
        deconfig)
              deconfig
              ;;
        bound)
              bound
              ;;
        renew)
              renew
              ;;
        update)
      	      renew
              ;;
esac
                                                                                                                        
