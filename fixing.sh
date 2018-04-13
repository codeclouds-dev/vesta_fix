#!/bin/bash

/usr/local/vesta/bin/v-stop-firewall

#ex -sc '%s/RESTRICT_SYSLOG = "0"/RESTRICT_SYSLOG = "2"/g|x' /etc/csf/csf.conf

if [ -e '/usr/local/vesta/nginx/conf/nginx.conf' ]; then
cp /usr/local/vesta/nginx/conf/nginx.conf /usr/local/vesta/nginx/conf/nginx-conf
sed -i "s/listen .*/listen          9050;/g" /usr/local/vesta/nginx/conf/nginx.conf && service vesta restart
fi

if [ -e '/usr/local/vesta/data/firewall/ports.conf' ]; then
cp /usr/local/vesta/data/firewall/ports.conf /usr/local/vesta/data/firewall/ports-conf-bkp
#ex -sc '%s/PROTOCOL='TCP' PORT='8083'/#PROTOCOL='TCP' PORT='8083'/g|x' /usr/local/vesta/data/firewall/ports.conf
sed --in-place '16d' /usr/local/vesta/data/firewall/ports.conf
ex -sc '16i|PROTOCOL='TCP' PORT='9050'' -cx /usr/local/vesta/data/firewall/ports.conf
#ex -sc '16i|PROTOCOL='TCP' PORT='9050'' -cx /usr/local/vesta/data/firewall/ports.conf
#echo "PROTOCOL='TCP' PORT='9050'" >> /usr/local/vesta/data/firewall/ports.conf
fi

if [ -e '/usr/local/vesta/data/firewall/rules.conf' ]; then
cp /usr/local/vesta/data/firewall/rules.conf /usr/local/vesta/data/firewall/rules-conf-bkp
/usr/local/vesta/bin/v-delete-firewall-rule 2
echo "RULE='2' ACTION='ACCEPT' PROTOCOL='TCP' PORT='9050' IP='180.87.240.74/29' COMMENT='Vesta' SUSPENDED='no' TIME='10:24:29' DATE='2018-04-09'" >> /usr/local/vesta/data/firewall/rules.conf
/usr/local/vesta/bin/v-update-firewall
fi
