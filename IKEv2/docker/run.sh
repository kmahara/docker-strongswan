#!/bin/sh

# =================================================================
. /etc/strongswan/cert.env

if [ ! -f /etc/strongswan/ipsec.d/private/ca_key.der ]; then
	echo "Create: CA certs. dn=$CA_DN"
	echo 

	for i in aacerts acerts cacerts certs crls ocspcerts private reqs; do
		D=/etc/strongswan/ipsec.d/$i
		if [ ! -d $D ]; then
			mkdir $D
			chmod 700 $D
		fi		
	done
	chmod 755 /etc/strongswan/ipsec.d/cacerts

	strongswan pki --gen > /etc/strongswan/ipsec.d/private/ca_key.der
	strongswan pki --self --lifetime 3650 \
		--in /etc/strongswan/ipsec.d/private/ca_key.der \
		--dn "$CA_DN" \
		--ca --flag sererAuth > /etc/strongswan/ipsec.d/cacerts/ca.der

fi

if [ ! -f /etc/strongswan/ipsec.d/private/vpn_server_key.der ]; then
	echo "Create: Server certs. dn=$VPNSERVER_DN"
	strongswan pki --gen > /etc/strongswan/ipsec.d/private/vpn_server_key.der
	strongswan pki --pub --in /etc/strongswan/ipsec.d/private/vpn_server_key.der | strongswan pki \
		--issue --cacert /etc/strongswan/ipsec.d/cacerts/ca.der \
		--cakey /etc/strongswan/ipsec.d/private/ca_key.der \
		--dn "$VPNSERVER_DN" \
		--flag serverAuth \
		--san "$VPNSERVER_NAME" \
		--lifetime 3650 \
		> /etc/strongswan/ipsec.d/certs/vpn_server.der
fi


# =================================================================
iptables -t nat -A POSTROUTING -s 192.168.12.0/24 -j MASQUERADE

exec /usr/sbin/strongswan start --nofork

