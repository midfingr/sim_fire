#!/bin/bash

## BEFORE RUNNING THIS SCRIPT
## initalise as root the following
## iptables -N TCP 
## iptables -N UDP
## also enable and start the iptables.service
## don't forget to chmod this script

iptables -P FORWARD DROP && iptables -P OUTPUT ACCEPT && iptables -P INPUT DROP && iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT && iptables -A INPUT -i lo -j ACCEPT && iptables -A INPUT -m conntrack --ctstate INVALID -j DROP && iptables -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT && iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP && iptables -A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP && iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable && iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset && iptables -A INPUT -j REJECT --reject-with icmp-proto-unreachable && iptables -t raw -I PREROUTING -m rpfilter --invert -j DROP && iptables -I TCP -p tcp -m recent --update --seconds 60 --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset && iptables -D INPUT -p tcp -j REJECT --reject-with tcp-reset && iptables -A INPUT -p tcp -m recent --set --name TCP-PORTSCAN -j REJECT --reject-with tcp-reset && iptables -I UDP -p udp -m recent --update --seconds 60 --name UDP-PORTSCAN -j REJECT --reject-with icmp-port-unreachable && iptables -D INPUT -p udp -j REJECT --reject-with icmp-port-unreachable && iptables -A INPUT -p udp -m recent --set --name UDP-PORTSCAN -j REJECT --reject-with icmp-port-unreachable

iptables-save > /etc/iptables/iptables.rules
