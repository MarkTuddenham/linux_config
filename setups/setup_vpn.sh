

apt install strongswan strongswan-pki
cd /etc/ipsec.d
ipsec pki --gen --type rsa --size 4096 --outform der > private/strongswanKey.der
chmod 600 private/strongswanKey.der
ipsec pki --self --ca --lifetime 3650 --in private/strongswanKey.der --type rsa --dn "C=GB, O=Mark Tuddenham, CN=Mark Tuddenham Root CA" --outform der > cacerts/strongswanCert.der
ipsec pki --print --in cacerts/strongswanCert.der
ipsec pki --gen --type rsa --size 4096 --outform der > private/vpnHostKey.der
chmod 600 private/vpnHostKey.der
ipsec pki --pub --in private/vpnHostKey.der --type rsa | ipsec pki --issue --lifetime 730 --cacert cacerts/strongswanCert.der --cakey private/strongswanKey.der --dn "C=GB, O=Mark Tuddenham, CN=net.tudders.dev" --san "net.tudders.dev" --flag serverAuth --flag ikeIntermediate --outform der > certs/vpnHostCert.der
ipsec pki --print --in certs/vpnHostCert.der

openssl x509 -inform DER -in cacerts/strongswanCert.der -out cacerts/strongswanCert.pem -outform PEM

echo ": RSA vpnHostKey.der" >> /etc/ipsec.secrets

generate_key() {
  KEY=private/${1}Key.der
  KEY_PEM=private/${1}Key.pem
  CERT=certs/${1}Cert.der
  CERT_PEM=certs/${1}Cert.pem
  P12=p12/${1}.p12
  ipsec pki --gen --type rsa --size 2048 --outform der > ${KEY}
  chmod 600 ${KEY}
  ipsec pki --pub --in ${KEY} --type rsa | ipsec pki --issue --lifetime 730 --cacert cacerts/strongswanCert.der --cakey private/strongswanKey.der --dn "C=GB, O=Mark Tuddenham, CN="${1}"@net.tudders.dev" --san ${1}"@net.tudders.dev" --outform der > ${CERT}
  openssl rsa -inform DER -in ${KEY} -out ${KEY_PEM} -outform PEM
  openssl x509 -inform DER -in ${CERT} -out ${CERT_PEM} -outform PEM
  openssl pkcs12 -export -inkey ${KEY_PEM} -in ${CERT_PEM} -name ${1}" Certificate" -certfile cacerts/strongswanCert.pem -caname "Mark Tuddenham Root CA" -out ${P12}

}

ipsec restart

copy ipsec.conf to /etc/ipsec.conf

echo "net.ipv4.ip_forward = 1" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects = 0" |  tee -a /etc/sysctl.conf
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" |  tee -a /etc/sysctl.conf

for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done
sysctl -p

echo "for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done
iptables -t nat -A POSTROUTING -j SNAT --to-source 10.0.0.11 -o eth0
iptables -A INPUT -p udp --dport 500 --j ACCEPT
iptables -A INPUT -p udp --dport 4500 --j ACCEPT
iptables -A INPUT -p esp -j ACCEPT" >> /etc/rc.local

# if /etc/rc.local didn't exist add a shebang (e.g. #!/bin/bash) and chmod a+x /etc/rc.local

systemctl enable strongswan
systemctl start strongswan


