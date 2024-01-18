
apt install ddclient

https://support.google.com/domains/answer/6147083?hl=en-GB&ref_topic=9018335
https://ddclient.net/


systemctl enable ddclient.service

/etc/ddclient.conf

ssl=yes
protocol=googledomains
login=
password=
use=web, web=checkip.dyndns.org
net.tudders.dev
jupyter.tudders.dev
dns.tudders.dev

