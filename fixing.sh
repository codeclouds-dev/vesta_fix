#!/bin/bash
echo -e "\e[31;43m**Fixing VestaCp (CISPL - Server Support Team) *****\e[0m"
/usr/local/vesta/bin/v-stop-service iptables

#ex -sc '%s/RESTRICT_SYSLOG = "0"/RESTRICT_SYSLOG = "2"/g|x' /etc/csf/csf.conf

if [ -e '/usr/local/vesta/nginx/conf/nginx.conf' ]; then
cp /usr/local/vesta/nginx/conf/nginx.conf /usr/local/vesta/nginx/conf/nginx-conf
sed -i "s/listen .*/listen          9050;/g" /usr/local/vesta/nginx/conf/nginx.conf && service vesta restart
fi

if [ -e '/usr/local/vesta/data/firewall/ports.conf' ]; then
cp /usr/local/vesta/data/firewall/ports.conf /usr/local/vesta/data/firewall/ports-conf-bkp
#ex -sc '%s/PROTOCOL='TCP' PORT='8083'/#PROTOCOL='TCP' PORT='8083'/g|x' /usr/local/vesta/data/firewall/ports.conf
sed --in-place '16d' /usr/local/vesta/data/firewall/ports.conf
#ex -sc '16i|PROTOCOL='TCP' PORT='9050'' -cx /usr/local/vesta/data/firewall/ports.conf
#echo "PROTOCOL='TCP' PORT='9050'" >> /usr/local/vesta/data/firewall/ports.conf
fi

if [ -e '/usr/local/vesta/data/firewall/rules.conf' ]; then
cp /usr/local/vesta/data/firewall/rules.conf /usr/local/vesta/data/firewall/rules-conf-bkp
echo "RULE='20' ACTION='ACCEPT' PROTOCOL='TCP' PORT='9050' IP='180.87.240.74/29' COMMENT='Vesta' SUSPENDED='no' TIME='10:24:29' DATE='2018-04-09'" >> /usr/local/vesta/data/firewall/rules.conf
echo "RULE='21' ACTION='ACCEPT' PROTOCOL='TCP' PORT='9050' IP='111.93.172.122/29' COMMENT='Vesta' SUSPENDED='no' TIME='10:24:29' DATE='2018-04-09'" >> /usr/local/vesta/data/firewall/rules.conf
echo "RULE='22' ACTION='ACCEPT' PROTOCOL='TCP' PORT='9050' IP='103.250.86.42/29' COMMENT='Vesta' SUSPENDED='no' TIME='10:24:29' DATE='2018-04-09'" >> /usr/local/vesta/data/firewall/rules.conf
echo "RULE='23' ACTION='ACCEPT' PROTOCOL='TCP' PORT='9050' IP='118.185.76.18/29' COMMENT='Vesta' SUSPENDED='no' TIME='10:24:29' DATE='2018-04-09'" >> /usr/local/vesta/data/firewall/rules.conf
echo "RULE='24' ACTION='ACCEPT' PROTOCOL='TCP' PORT='9050' IP='203.171.33.10' COMMENT='Vesta' SUSPENDED='no' TIME='10:24:29' DATE='2018-04-09'" >> /usr/local/vesta/data/firewall/rules.conf
/usr/local/vesta/bin/v-start-service iptables
fi
