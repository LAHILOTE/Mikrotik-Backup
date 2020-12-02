# dec/02/2020 18:59:07 by RouterOS 6.47.7
# software id = Z6DG-Z12S
#
# model = 951Ui-2nD
# serial number = 64370504EDFB
/interface bridge
add name=HOTSPOT
add name=Private
add name=WiFi
/interface ethernet
set [ find default-name=ether1 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full name=\
    ether1-Internet
set [ find default-name=ether2 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full name=\
    ether2-WiFi
set [ find default-name=ether3 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full mac-address=\
    04:95:73:84:17:AF name=ether3-PC
set [ find default-name=ether4 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full name=\
    ether4-PiHole
set [ find default-name=ether5 ] advertise=\
    10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full name=\
    ether5-UniFi
/interface l2tp-client
add connect-to=sin-a07.ipvanish.com ipsec-secret=l2tpvpn name=VPN password=\
    Patrick123 user=martin_hanly@msn.com
/interface vlan
add interface=ether5-UniFi name=Hotspot vlan-id=300
add interface=ether5-UniFi name=Network vlan-id=200
/interface ovpn-client
add certificate=client connect-to=36.89.215.26 disabled=yes mac-address=\
    02:B0:88:D7:A9:AD name=OpenVPN password=vpn user=vpn
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa-psk eap-methods="" management-protection=allowed \
    mode=dynamic-keys name=profile1 supplicant-identity="" \
    wpa-pre-shared-key=00000000 wpa2-pre-shared-key=987654321
/interface wireless
set [ find default-name=wlan1 ] antenna-gain=0 band=2ghz-b/g/n country=\
    no_country_set disabled=no frequency=auto installation=indoor mode=\
    ap-bridge name=WirelessLan security-profile=profile1 ssid=Wireless \
    station-roaming=enabled wps-mode=disabled
/ip firewall layer7-protocol
add name=EXE regexp="\\x4d\\x5a(\\x90\\x03|\\x50\\x02)\\x04"
add name=ZIP regexp="pk\\x03\\x04\\x14"
add name=MP4 regexp="\\x18\\x66\\x74\\x79\\x70"
add name=RAR regexp="Rar\\x21\\x1a\\x07"
add name=youtube regexp="r[0-9]+---[a-z]+-+[a-z0-9-]+\\.googlevideo\\.com"
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
add dns-name=lince.hotspot.network hotspot-address=10.5.50.1 html-directory=\
    flash/hotspo login-by=mac,http-chap,http-pap mac-auth-password=20122012 \
    name=hsprof1 rate-limit=14M/3M
/ip pool
add name=WiFi ranges=192.168.40.1-192.168.40.253
add name=Network ranges=192.168.10.2-192.168.10.254
add name=Hotspot ranges=10.5.50.2-10.5.51.254
add name=UniFi ranges=192.168.100.2-192.168.100.254
add name=Private ranges=172.16.178.2-172.16.178.254
/ip dhcp-server
add add-arp=yes address-pool=WiFi disabled=no interface=WiFi lease-time=5m \
    name=WiFi
add address-pool=Network interface=Network name=Network
add add-arp=yes address-pool=Hotspot disabled=no interface=HOTSPOT name=\
    Hotspot
add add-arp=yes address-pool=UniFi interface=ether5-UniFi name=UniFi
add add-arp=yes address-pool=Private disabled=no interface=Private name=\
    Private
/ip hotspot
add address-pool=Hotspot addresses-per-mac=unlimited idle-timeout=none \
    interface=HOTSPOT keepalive-timeout=1d name=HOTSPOT profile=hsprof1
/port
set 0 baud-rate=115200 data-bits=8 flow-control=none name=usb1 parity=none \
    stop-bits=1
/queue type
set 0 kind=bfifo
set 1 kind=none
add kind=pcq name=Limit pcq-classifier=dst-address pcq-dst-address6-mask=64 \
    pcq-limit=1000KiB pcq-rate=50k pcq-src-address6-mask=64
add kind=pcq name=PCQ pcq-classifier=\
    src-address,dst-address,src-port,dst-port pcq-dst-address6-mask=64 \
    pcq-src-address6-mask=64
add kind=pcq name=down_pcq pcq-classifier=dst-address pcq-dst-address6-mask=\
    64 pcq-src-address6-mask=64
add kind=pcq name=up_pcq pcq-classifier=src-address pcq-dst-address6-mask=64 \
    pcq-src-address6-mask=64
add kind=pfifo name=PFIFO-64 pfifo-limit=64
set 10 pcq-rate=1k
/queue interface
set ether3-PC queue=default
set ether4-PiHole queue=default
/queue tree
add name="Global Traffic" parent=global queue=default
add max-limit=20M name=Download parent="Global Traffic" queue=default
add max-limit=4M name=Upload parent="Global Traffic"
add limit-at=512k max-limit=5M name="2. Game" packet-mark=games_down parent=\
    Download priority=1 queue=down_pcq
add limit-at=128k max-limit=5M name="6. Icmp" packet-mark=icmp_down parent=\
    Download priority=1 queue=down_pcq
add limit-at=128k max-limit=5M name="5. Dns" packet-mark=dns_down parent=\
    Download priority=1 queue=down_pcq
add max-limit=180M name="8. Download Traffic" parent=Download queue=default
add max-limit=30M name="1. Small Browsing" packet-mark=small_browsing_down \
    parent="8. Download Traffic" priority=5 queue=down_pcq
add max-limit=70M name="2. Heavy Browsing" packet-mark=heavy_browsing_down \
    parent="8. Download Traffic" priority=7 queue=down_pcq
add limit-at=512k max-limit=5M name="7. Remote" packet-mark=remote_down \
    parent=Download priority=3 queue=down_pcq
add max-limit=40M name="3. YouTube" packet-mark=youtube_down parent=\
    "8. Download Traffic" priority=7 queue=down_pcq
add max-limit=40M name="4. Extensi" packet-mark=extensi_down parent=\
    "8. Download Traffic" queue=down_pcq
add limit-at=256k max-limit=5M name="2. game" packet-mark=games_up parent=\
    Upload priority=1 queue=up_pcq
add limit-at=128k max-limit=5M name="6. icmp" packet-mark=icmp_up parent=\
    Upload priority=1 queue=up_pcq
add limit-at=512k max-limit=5M name="5. dns" packet-mark=dns_up parent=Upload \
    priority=1 queue=up_pcq
add limit-at=256k max-limit=5M name="7. remote" packet-mark=remote_up parent=\
    Upload priority=3 queue=up_pcq
add max-limit=20M name="8. Upload Traffic" parent=Upload queue=default
add max-limit=5M name="1. small browsing" packet-mark=small_browsing_up \
    parent="8. Upload Traffic" priority=5 queue=up_pcq
add max-limit=5M name="2. heavy browsing" packet-mark=heavy_browsing_up \
    parent="8. Upload Traffic" priority=7 queue=up_pcq
add max-limit=5M name="3. youtube" packet-mark=youtube_up parent=\
    "8. Upload Traffic" priority=7 queue=up_pcq
add max-limit=20M name="1. Vip" packet-mark=vip-dl parent=Download priority=1 \
    queue=down_pcq
add max-limit=4M name="1. vip" packet-mark=vip-up parent=Upload priority=1 \
    queue=up_pcq
add limit-at=1M max-limit=10M name="4. Google" packet-mark=ggc-telkom-down \
    parent=Download queue=pcq-download-default
add limit-at=1M max-limit=10M name="3. Sosmed" packet-mark=sosmed-down \
    parent=Download priority=5 queue=pcq-download-default
add limit-at=200k max-limit=2M name="4. google" packet-mark=ggc-telkom-up \
    parent=Upload queue=pcq-upload-default
add limit-at=200k max-limit=2M name="3. sosmed" packet-mark=sosmed-up parent=\
    Upload priority=5 queue=pcq-upload-default
add max-limit=5M name="4. extensi" packet-mark=extensi_up parent=\
    "8. Upload Traffic" queue=up_pcq
/snmp community
set [ find default=yes ] addresses=0.0.0.0/0
/system logging action
set 0 memory-lines=500
set 1 disk-lines-per-file=500
/user group
set full policy="local,telnet,ssh,ftp,reboot,read,write,policy,test,winbox,pas\
    sword,web,sniff,sensitive,api,romon,dude,tikapp"
add name=mikhmon policy="write,api,!local,!telnet,!ssh,!ftp,!reboot,!read,!pol\
    icy,!test,!winbox,!password,!web,!sniff,!sensitive,!romon,!dude,!tikapp"
/interface bridge port
add bridge=WiFi interface=ether2-WiFi
add bridge=WiFi interface=Network
add bridge=HOTSPOT interface=Hotspot
add bridge=Private interface=ether3-PC
add bridge=Private interface=WirelessLan
/ip firewall connection tracking
set enabled=yes generic-timeout=5m icmp-timeout=5s loose-tcp-tracking=no \
    tcp-close-timeout=1s tcp-close-wait-timeout=5s tcp-fin-wait-timeout=5s \
    tcp-last-ack-timeout=1s tcp-syn-received-timeout=1s tcp-syn-sent-timeout=\
    1s tcp-time-wait-timeout=1s udp-stream-timeout=1m udp-timeout=1s
/ip neighbor discovery-settings
set discover-interface-list=all
/ip address
add address=192.168.40.254/24 disabled=yes interface=ether2-WiFi network=\
    192.168.40.0
add address=192.168.10.1/24 disabled=yes interface=Network network=\
    192.168.10.0
add address=10.5.50.1/23 interface=Hotspot network=10.5.50.0
add address=192.168.100.1/24 disabled=yes interface=ether5-UniFi network=\
    192.168.100.0
add address=192.168.40.254/24 interface=WiFi network=192.168.40.0
add address=172.16.178.1/24 interface=Private network=172.16.178.0
add address=192.168.100.100/24 disabled=yes interface=ether1-Internet \
    network=192.168.100.0
/ip cloud
set update-time=no
/ip cloud advanced
set use-local-address=yes
/ip dhcp-client
add disabled=no interface=ether1-Internet
/ip dhcp-server lease
add address=192.168.40.244 client-id=1:f0:3:8c:6b:31:43 comment=LAPTOP \
    mac-address=F0:03:8C:6B:31:43 server=WiFi
add address=192.168.40.240 client-id=1:4:d9:f5:b0:91:56 comment=PC \
    mac-address=04:D9:F5:B0:91:56 server=WiFi
add address=192.168.40.230 client-id=1:28:3f:69:fc:bd:90 comment=HP \
    mac-address=28:3F:69:FC:BD:90 server=WiFi
add address=192.168.40.229 comment="STB Kamar" mac-address=E8:AC:AD:6E:AC:AF \
    server=WiFi
add address=192.168.100.254 client-id=1:80:2a:a8:ac:3d:1e comment=UniFi \
    mac-address=80:2A:A8:AC:3D:1E server=UniFi
add address=192.168.40.224 client-id=1:b4:6b:fc:8f:ab:9c mac-address=\
    B4:6B:FC:8F:AB:9C server=WiFi
add address=192.168.40.223 client-id=1:18:d0:c5:65:8c:69 mac-address=\
    18:D0:C5:65:8C:69 server=WiFi
add address=192.168.40.217 comment="STB Luar" mac-address=28:8C:B8:44:3F:D0 \
    server=WiFi
add address=192.168.40.216 client-id=1:50:8f:4c:69:6b:29 mac-address=\
    50:8F:4C:69:6B:29 server=WiFi
add address=192.168.40.232 client-id=1:f8:28:19:4f:4:1 comment=Adjust \
    mac-address=F8:28:19:4F:04:01 server=WiFi
add address=192.168.40.208 client-id=1:dc:85:de:48:94:24 mac-address=\
    DC:85:DE:48:94:24 server=WiFi
add address=192.168.40.215 client-id=1:c0:e4:34:79:f1:5f mac-address=\
    C0:E4:34:79:F1:5F server=WiFi
add address=192.168.40.213 client-id=1:8:8c:2c:a:fc:eb mac-address=\
    08:8C:2C:0A:FC:EB server=WiFi
add address=172.16.178.3 comment="STB KAMAR" mac-address=E8:AC:AD:6E:AC:AF \
    server=Private
add address=172.16.178.4 client-id=1:f0:3:8c:6b:31:43 mac-address=\
    F0:03:8C:6B:31:43 server=Private
add address=172.16.178.6 client-id=1:ec:8:6b:8:4a:4d mac-address=\
    EC:08:6B:08:4A:4D server=Private
add address=172.16.178.7 client-id=1:0:23:8:be:c7:e2 mac-address=\
    00:23:08:BE:C7:E2 server=Private
add address=192.168.40.197 client-id=1:d4:5d:64:54:b9:f4 mac-address=\
    D4:5D:64:54:B9:F4 server=WiFi
add address=172.16.178.11 client-id=1:d0:9c:7a:c:6e:b6 comment="BETS HP" \
    mac-address=D0:9C:7A:0C:6E:B6 server=Private
add address=172.16.178.12 client-id=1:ac:b5:7d:82:39:1a comment="BETS LAPTOP" \
    mac-address=AC:B5:7D:82:39:1A server=Private
add address=172.16.178.16 client-id=1:cc:25:ef:81:c2:56 mac-address=\
    CC:25:EF:81:C2:56 server=Private
add address=172.16.178.5 client-id=1:e8:e8:b7:6e:db:52 mac-address=\
    E8:E8:B7:6E:DB:52 server=Private
add address=172.16.178.14 client-id=1:50:8f:4c:69:6b:29 mac-address=\
    50:8F:4C:69:6B:29 server=Private
/ip dhcp-server network
add address=10.5.50.0/23 gateway=10.5.50.1
add address=172.16.178.0/24 gateway=172.16.178.1
add address=192.168.10.0/24 gateway=192.168.10.1
add address=192.168.40.0/24 gateway=192.168.40.254
add address=192.168.100.0/24 gateway=192.168.100.1
/ip dns
set allow-remote-requests=yes servers=202.134.0.155,202.134.1.10
/ip firewall address-list
add address=172.16.178.4 comment=LAPTOP list=VIP
add address=0.0.0.0/8 list=private-lokal
add address=10.0.0.0/8 list=private-lokal
add address=100.64.0.0/10 list=private-lokal
add address=169.254.0.0/16 list=private-lokal
add address=127.0.0.0/8 list=private-lokal
add address=172.16.0.0/12 list=private-lokal
add address=192.0.0.0/24 list=private-lokal
add address=192.0.2.0/24 list=private-lokal
add address=192.168.0.0/16 list=private-lokal
add address=198.18.0.0/15 list=private-lokal
add address=198.51.100.0/24 list=private-lokal
add address=203.0.113.0/24 list=private-lokal
add address=224.0.0.0/3 list=private-lokal
add address=172.16.178.3 comment="STB KAMAR" list=VIP
add address=31.13.24.0/21 comment="Facebook Ireland" list=sosmed
add address=31.13.64.0/18 comment="Facebook Ireland" list=sosmed
add address=31.13.64.0/19 comment="Facebook Ireland" list=sosmed
add address=31.13.64.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.65.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.66.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.67.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.68.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.69.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.70.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.71.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.72.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.73.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.74.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.75.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.76.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.78.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.80.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.81.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.82.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.83.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.84.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.85.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.86.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.87.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.90.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.91.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.92.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.94.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.95.0/24 comment="Facebook Ireland" list=sosmed
add address=31.13.96.0/19 comment="Facebook Ireland" list=sosmed
add address=45.64.40.0/22 comment="Facebook Singapore Pte Ltd. Singapore" \
    list=sosmed
add address=66.220.144.0/20 comment="Facebook, Inc. United States" list=\
    sosmed
add address=66.220.144.0/21 comment="Facebook, Inc. United States" list=\
    sosmed
add address=66.220.152.0/21 comment="Facebook, Inc. United States" list=\
    sosmed
add address=69.63.176.0/20 comment="Facebook, Inc. United States" list=sosmed
add address=69.63.176.0/21 comment="Facebook, Inc. United States" list=sosmed
add address=69.63.184.0/21 comment="Facebook, Inc. United States" list=sosmed
add address=69.171.224.0/19 comment="Facebook, Inc. United States" list=\
    sosmed
add address=69.171.224.0/20 comment="Facebook, Inc. United States" list=\
    sosmed
add address=69.171.239.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=69.171.240.0/20 comment="Facebook, Inc. United States" list=\
    sosmed
add address=69.171.255.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=74.119.76.0/22 comment="Facebook, Inc. United States" list=sosmed
add address=103.4.96.0/22 comment=" Temasek Avenue Singapore" list=sosmed
add address=157.240.0.0/17 comment="Facebook, Inc. United States" list=sosmed
add address=157.240.1.0/24 comment="Facebook, Inc. United States" list=sosmed
add address=157.240.2.0/24 comment="Facebook, Inc. United States" list=sosmed
add address=157.240.3.0/24 comment="Facebook, Inc. United States" list=sosmed
add address=157.240.6.0/24 comment="Facebook, Inc. United States" list=sosmed
add address=157.240.7.0/24 comment="Facebook, Inc. United States" list=sosmed
add address=157.240.8.0/24 comment="Facebook, Inc. United States" list=sosmed
add address=157.240.9.0/24 comment="Facebook, Inc. United States" list=sosmed
add address=157.240.10.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.11.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.12.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.13.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.14.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.15.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.16.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.18.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.20.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.21.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=157.240.22.0/24 comment="Facebook, Inc. United States" list=\
    sosmed
add address=173.252.64.0/19 comment="Facebook, Inc. United States" list=\
    sosmed
add address=173.252.88.0/21 comment="Facebook, Inc. United States" list=\
    sosmed
add address=173.252.96.0/19 comment="Facebook, Inc. United States" list=\
    sosmed
add address=179.60.192.0/22 comment="Edge Network Services Ltd United States" \
    list=sosmed
add address=179.60.192.0/24 comment="Edge Network Services Ltd United States" \
    list=sosmed
add address=179.60.193.0/24 comment="Edge Network Services Ltd United States" \
    list=sosmed
add address=179.60.195.0/24 comment="Edge Network Services Ltd United States" \
    list=sosmed
add address=185.60.216.0/22 comment="Facebook Ireland" list=sosmed
add address=185.60.216.0/24 comment="Facebook Ireland" list=sosmed
add address=185.60.218.0/24 comment="Facebook Ireland" list=sosmed
add address=185.60.219.0/24 comment="Facebook Ireland" list=sosmed
add address=204.15.20.0/22 comment="Facebook, Inc. United States" list=sosmed
add address=64.63.0.0/18 comment="MoPub, Inc. United States" list=sosmed
add address=69.195.160.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.162.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.163.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.164.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.165.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.166.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.168.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.169.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.171.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.172.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.173.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.175.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.176.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.177.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.178.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.179.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.180.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.181.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.182.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.184.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.185.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.186.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.187.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.188.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.189.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.190.0/24 comment="Twitter Inc. United States" list=sosmed
add address=69.195.191.0/24 comment="Twitter Inc. United States" list=sosmed
add address=103.252.112.0/23 comment=\
    "60 Robinson Road, #11-02 BEA Building, Singapore 068892. Singapore" \
    list=sosmed
add address=103.252.114.0/23 comment=\
    "60 Robinson Road, #11-02 BEA Building, Singapore 068892. Singapore" \
    list=sosmed
add address=104.244.40.0/24 comment="Twitter Inc. United States" list=sosmed
add address=104.244.41.0/24 comment="Twitter Inc. United States" list=sosmed
add address=104.244.42.0/24 comment="Twitter Inc. United States" list=sosmed
add address=104.244.43.0/24 comment="Twitter Inc. United States" list=sosmed
add address=104.244.44.0/24 comment="Twitter Inc. United States" list=sosmed
add address=104.244.45.0/24 comment="Twitter Inc. United States" list=sosmed
add address=104.244.46.0/24 comment="Twitter Inc. United States" list=sosmed
add address=104.244.47.0/24 comment="Twitter Inc. United States" list=sosmed
add address=185.45.5.0/24 comment="Twitter International Company Ireland" \
    list=sosmed
add address=185.45.6.0/23 comment="Twitter International Company Ireland" \
    list=sosmed
add address=188.64.224.0/24 comment="Heron SAS France" list=sosmed
add address=188.64.225.0/24 comment="Heron SAS France" list=sosmed
add address=188.64.226.0/23 comment="Heron SAS France" list=sosmed
add address=188.64.226.0/24 comment="Heron SAS France" list=sosmed
add address=188.64.227.0/24 comment="Heron SAS France" list=sosmed
add address=188.64.228.0/24 comment="Heron SAS France" list=sosmed
add address=188.64.229.0/24 comment="Heron SAS France" list=sosmed
add address=192.44.69.0/24 comment="Crashlytics, Inc United States" list=\
    sosmed
add address=192.133.76.0/22 comment="Twitter Inc. United States" list=sosmed
add address=192.133.76.0/23 comment="Twitter Inc. United States" list=sosmed
add address=199.16.156.0/22 comment="Twitter Inc. United States" list=sosmed
add address=199.16.156.0/23 comment="Twitter Inc. United States" list=sosmed
add address=199.59.148.0/22 comment="Twitter Inc. United States" list=sosmed
add address=199.96.56.0/23 comment="Twitter Inc. United States" list=sosmed
add address=199.96.56.0/24 comment="Twitter Inc. United States" list=sosmed
add address=199.96.57.0/24 comment="Twitter Inc. United States" list=sosmed
add address=199.96.58.0/23 comment="Twitter Inc. United States" list=sosmed
add address=199.96.60.0/23 comment="Twitter Inc. United States" list=sosmed
add address=199.96.60.0/24 comment="Twitter Inc. United States" list=sosmed
add address=199.96.61.0/24 comment="Twitter Inc. United States" list=sosmed
add address=199.96.62.0/23 comment="Twitter Inc. United States" list=sosmed
add address=202.160.128.0/24 comment=\
    "Twitter Asia Pacific Pte. Ltd. Singapore" list=sosmed
add address=202.160.129.0/24 comment=\
    "Twitter Asia Pacific Pte. Ltd. Singapore" list=sosmed
add address=202.160.130.0/24 comment=\
    "Twitter Asia Pacific Pte. Ltd. Singapore" list=sosmed
add address=202.160.131.0/24 comment=\
    "Twitter Asia Pacific Pte. Ltd. Singapore" list=sosmed
add address=209.237.192.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.193.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.194.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.195.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.196.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.197.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.198.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.199.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.200.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.201.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.204.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.205.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.206.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.207.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.208.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.209.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.210.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.211.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.212.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.213.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.214.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.215.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.216.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.217.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.218.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.219.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.220.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.221.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.222.0/24 comment="Twitter Inc. United States" list=sosmed
add address=209.237.223.0/24 comment="Twitter Inc. United States" list=sosmed
add address=169.55.60.0/24 comment=Whatsapp list=sosmed
add address=108.168.255.0/24 comment=Whatsapp list=sosmed
add address=108.168.254.0/24 comment=Whatsapp list=sosmed
add address=52.205.162.0/24 comment=instagram list=sosmed
add address=52.203.82.0/24 comment=instagram list=sosmed
add address=52.200.119.0/24 comment=instagram list=sosmed
add address=52.22.234.0/24 comment=instagram list=sosmed
add address=34.234.104.0/24 comment=instagram list=sosmed
add address=34.225.190.0/24 comment=instagram list=sosmed
add address=34.202.99.0/24 comment=instagram list=sosmed
add address=8.8.4.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=8.8.8.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=8.34.208.0/21 comment="Google LLC United States" list=LLC-GOOGLE
add address=8.34.216.0/21 comment="Google LLC United States" list=LLC-GOOGLE
add address=8.35.192.0/21 comment="Google LLC United States" list=LLC-GOOGLE
add address=8.35.200.0/21 comment="Google LLC United States" list=LLC-GOOGLE
add address=23.236.48.0/20 comment="Google LLC United States" list=LLC-GOOGLE
add address=23.251.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=34.64.0.0/11 comment="Google LLC United States" list=LLC-GOOGLE
add address=34.68.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.72.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.76.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.80.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.84.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.88.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.92.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.96.0.0/12 comment="United States" list=LLC-GOOGLE
add address=34.96.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.100.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.104.0.0/14 comment="United States" list=LLC-GOOGLE
add address=34.108.0.0/14 comment="United States" list=LLC-GOOGLE
add address=35.184.0.0/13 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.184.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.184.32.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.184.64.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.184.96.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.184.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.184.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.184.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.184.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.185.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.185.32.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.185.64.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.185.96.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.185.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.185.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.185.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.185.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.186.0.0/16 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.186.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.186.32.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.186.64.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.186.96.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.186.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.186.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.187.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.187.32.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.187.64.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.187.96.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.187.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.187.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.187.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.187.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.188.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.188.32.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.188.64.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.188.96.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.188.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.188.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.188.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.188.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.189.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.189.32.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.189.64.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.189.96.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.189.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.189.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.189.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.189.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.190.0.0/16 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.190.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.190.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.190.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.190.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=35.192.0.0/13 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.200.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.204.0.0/15 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.220.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.224.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.228.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.232.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.236.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.240.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=35.244.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=64.233.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.160.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.161.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.162.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.163.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.164.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.165.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.166.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.167.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.168.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.169.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.170.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.171.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.172.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.176.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.177.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.178.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.179.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.180.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.181.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.182.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.183.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.184.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.185.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.186.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.187.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.188.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.189.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.190.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=64.233.191.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=66.102.0.0/20 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.102.1.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.102.2.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.102.3.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.102.4.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.102.8.0/23 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.102.12.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.249.64.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.249.64.0/20 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.249.80.0/22 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.249.84.0/23 comment="Google LLC United States" list=LLC-GOOGLE
add address=66.249.88.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=70.32.128.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=70.32.129.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=70.32.131.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=70.32.133.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=70.32.145.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=70.32.146.0/23 comment="Google LLC United States" list=LLC-GOOGLE
add address=70.32.151.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=72.14.192.0/18 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.114.24.0/21 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.0.0/16 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.0.0/20 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.6.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.20.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.21.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.23.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.24.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.27.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.28.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.30.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.31.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.39.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.44.0/22 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.68.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.69.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.70.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.71.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.72.0/22 comment="Google LLC United States" list=LLC-GOOGLE
add address=74.125.124.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.126.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.127.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.128.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.129.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.130.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.131.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.132.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.133.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.134.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.135.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.136.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.138.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.139.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.140.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.141.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.142.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.143.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.152.0/21 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.176.0/20 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.192.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.193.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.195.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.196.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.197.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.198.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.199.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.200.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.201.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.202.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.203.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.204.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.205.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.206.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.225.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.226.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.227.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.228.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.230.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.232.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.234.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.235.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.236.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=74.125.238.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=89.207.231.0/24 comment="Google CWB PNI-3 Switzerland" list=\
    LLC-GOOGLE
add address=104.132.34.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.154.0.0/15 comment="Google LLC United States" list=LLC-GOOGLE
add address=104.154.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=104.154.32.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.154.64.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.154.96.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.154.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.154.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.154.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.154.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.155.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=104.155.32.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.155.64.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.155.96.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.155.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.155.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.155.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.155.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.196.0.0/14 comment="Google LLC United States" list=LLC-GOOGLE
add address=104.196.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=104.196.32.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.196.64.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.196.96.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.196.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.196.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.196.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.196.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.197.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=104.197.32.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.197.64.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.197.96.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.197.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.197.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.197.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.197.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.198.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=104.198.32.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.198.64.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.198.96.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.198.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.198.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.198.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.198.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.199.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=104.199.32.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.199.64.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.199.96.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.199.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.199.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.199.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=104.199.224.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=107.167.160.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=107.178.192.0/18 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.59.80.0/20 comment="Google LLC United States" list=LLC-GOOGLE
add address=108.170.192.0/18 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.0.0/17 comment="Google LLC United States" list=LLC-GOOGLE
add address=108.177.8.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=108.177.9.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=108.177.10.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.11.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.12.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.13.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.14.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.15.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.96.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.97.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.98.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.103.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.104.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.111.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.112.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.119.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.120.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.121.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.122.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.125.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.126.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=108.177.127.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=130.211.0.0/16 comment="Google LLC United States" list=LLC-GOOGLE
add address=136.112.0.0/12 comment="Google LLC United States" list=LLC-GOOGLE
add address=142.250.0.0/15 comment="Google LLC United States" list=LLC-GOOGLE
add address=146.148.0.0/17 comment="Google LLC United States" list=LLC-GOOGLE
add address=162.216.148.0/22 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=162.222.176.0/21 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.102.8.0/21 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.102.8.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.102.10.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.102.11.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.102.12.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.102.14.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.110.32.0/21 comment="YouTube, LLC United States" list=\
    LLC-GOOGLE
add address=172.217.0.0/16 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.0.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.1.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.2.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.3.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.4.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.5.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.6.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.7.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.8.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.9.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=172.217.10.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.11.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.12.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.13.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.14.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.15.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.16.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.17.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.18.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.19.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.20.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.21.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.22.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.23.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.24.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.25.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.26.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.27.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.28.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.29.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.30.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.31.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.128.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.192.0/18 comment="United States" list=LLC-GOOGLE
add address=172.217.192.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.193.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.194.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.195.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.197.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.217.204.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=172.253.0.0/16 comment="Google LLC United States" list=LLC-GOOGLE
add address=173.194.0.0/16 comment="Google LLC United States" list=LLC-GOOGLE
add address=173.194.0.0/19 comment="Google LLC United States" list=LLC-GOOGLE
add address=173.194.7.0/24 comment="Google LLC United States" list=LLC-GOOGLE
add address=173.194.32.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.34.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.35.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.36.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.37.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.38.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.39.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.40.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.41.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.42.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.44.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.46.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.48.0/20 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.53.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.63.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.66.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.67.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.68.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.69.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.70.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.73.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.74.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.76.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.78.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.79.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.96.0/21 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.112.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.113.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.117.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.118.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.119.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.120.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.121.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.124.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.128.0/20 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.132.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.136.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.140.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.141.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.142.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.144.0/20 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.160.0/21 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.175.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.176.0/20 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.192.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.193.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.194.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.195.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.196.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.197.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.198.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.199.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.200.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.201.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.202.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.203.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.204.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.205.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.206.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.207.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.208.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.209.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.210.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.211.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.212.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.213.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.214.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.215.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.216.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.217.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.218.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.219.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.220.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.221.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.222.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.194.223.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=173.255.112.0/20 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=185.25.28.0/23 comment="Google CWB infra P2P Switzerland" list=\
    LLC-GOOGLE
add address=185.150.148.0/22 comment="Google UK Limited United Kingdom" list=\
    LLC-GOOGLE
add address=192.104.160.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=192.158.28.0/22 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=192.178.0.0/15 comment="Google LLC United States" list=LLC-GOOGLE
add address=199.36.154.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=199.36.156.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=199.192.112.0/22 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=199.223.232.0/21 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=207.223.160.0/20 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=208.68.108.0/22 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=208.81.188.0/22 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.128.0/17 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.137.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.144.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.145.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.147.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.164.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.200.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.201.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.202.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.203.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.232.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.233.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.234.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.85.235.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.107.176.0/20 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.107.176.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.107.182.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.107.184.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=209.107.185.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.192.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.192.0/22 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.196.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.198.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.199.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.200.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.201.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.202.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.203.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.204.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.206.0/23 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.208.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.209.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.210.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.211.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.212.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.213.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.214.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.215.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.216.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.217.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.218.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.219.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.220.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.221.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.222.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.58.223.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.73.80.0/20 comment="YouTube, LLC United States" list=\
    LLC-GOOGLE
add address=216.239.32.0/19 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.239.32.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.239.33.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.239.34.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.239.35.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.239.36.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.239.38.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.239.39.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.252.220.0/22 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.252.220.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=216.252.222.0/24 comment="Google LLC United States" list=\
    LLC-GOOGLE
add address=99.198.128.0/17 list=google
add address=89.207.224.0/24 list=google
add address=85.187.222.0/24 list=google
add address=84.235.77.0/24 list=google
add address=8.8.8.0/24 list=google
add address=8.8.4.0/24 list=google
add address=8.35.200.0/21 list=google
add address=8.35.192.0/21 list=google
add address=8.34.216.0/21 list=google
add address=8.34.208.0/21 list=google
add address=74.125.90.0/23 list=google
add address=74.125.71.0/24 list=google
add address=74.125.70.0/24 list=google
add address=74.125.69.0/24 list=google
add address=74.125.68.0/24 list=google
add address=74.125.6.0/24 list=google
add address=74.125.39.0/24 list=google
add address=74.125.31.0/24 list=google
add address=74.125.30.0/24 list=google
add address=74.125.29.0/24 list=google
add address=74.125.28.0/24 list=google
add address=74.125.27.0/24 list=google
add address=74.125.26.0/24 list=google
add address=74.125.25.0/24 list=google
add address=74.125.238.0/24 list=google
add address=74.125.237.0/24 list=google
add address=74.125.236.0/24 list=google
add address=74.125.235.0/24 list=google
add address=74.125.234.0/24 list=google
add address=74.125.233.0/24 list=google
add address=74.125.232.0/24 list=google
add address=74.125.231.0/24 list=google
add address=74.125.230.0/24 list=google
add address=74.125.23.0/24 list=google
add address=74.125.228.0/24 list=google
add address=74.125.227.0/24 list=google
add address=74.125.226.0/24 list=google
add address=74.125.225.0/24 list=google
add address=74.125.224.0/24 list=google
add address=74.125.22.0/24 list=google
add address=74.125.21.0/24 list=google
add address=74.125.206.0/24 list=google
add address=74.125.205.0/24 list=google
add address=74.125.204.0/24 list=google
add address=74.125.203.0/24 list=google
add address=74.125.202.0/24 list=google
add address=74.125.201.0/24 list=google
add address=74.125.200.0/24 list=google
add address=74.125.199.0/24 list=google
add address=74.125.198.0/24 list=google
add address=74.125.196.0/24 list=google
add address=74.125.195.0/24 list=google
add address=74.125.193.0/24 list=google
add address=74.125.192.0/24 list=google
add address=74.125.143.0/24 list=google
add address=74.125.142.0/24 list=google
add address=74.125.141.0/24 list=google
add address=74.125.140.0/24 list=google
add address=74.125.139.0/24 list=google
add address=74.125.138.0/24 list=google
add address=74.125.135.0/24 list=google
add address=74.125.134.0/24 list=google
add address=74.125.133.0/24 list=google
add address=74.125.132.0/24 list=google
add address=74.125.131.0/24 list=google
add address=74.125.130.0/24 list=google
add address=74.125.129.0/24 list=google
add address=74.125.128.0/24 list=google
add address=74.125.127.0/24 list=google
add address=74.125.126.0/24 list=google
add address=74.125.0.0/18 list=google
add address=74.125.0.0/16 list=google
add address=72.14.192.0/18 list=google
add address=70.32.151.0/24 list=google
add address=70.32.146.0/23 list=google
add address=70.32.145.0/24 list=google
add address=70.32.144.0/24 list=google
add address=70.32.142.0/23 list=google
add address=70.32.140.0/23 list=google
add address=70.32.132.0/23 list=google
add address=70.32.131.0/24 list=google
add address=70.32.128.0/23 list=google
add address=70.32.128.0/19 list=google
add address=66.249.64.0/19 list=google
add address=66.102.4.0/24 list=google
add address=66.102.3.0/24 list=google
add address=66.102.2.0/24 list=google
add address=66.102.12.0/24 list=google
add address=66.102.1.0/24 list=google
add address=66.102.0.0/20 list=google
add address=64.9.252.0/22 list=google
add address=64.9.248.0/22 list=google
add address=64.9.244.0/22 list=google
add address=64.9.243.0/24 list=google
add address=64.9.242.0/24 list=google
add address=64.9.241.0/24 list=google
add address=64.9.240.0/24 list=google
add address=64.9.236.0/22 list=google
add address=64.9.228.0/23 list=google
add address=64.9.225.0/24 list=google
add address=64.9.224.0/24 list=google
add address=64.233.191.0/24 list=google
add address=64.233.190.0/24 list=google
add address=64.233.189.0/24 list=google
add address=64.233.188.0/24 list=google
add address=64.233.187.0/24 list=google
add address=64.233.186.0/24 list=google
add address=64.233.185.0/24 list=google
add address=64.233.184.0/24 list=google
add address=64.233.183.0/24 list=google
add address=64.233.182.0/24 list=google
add address=64.233.181.0/24 list=google
add address=64.233.180.0/24 list=google
add address=64.233.179.0/24 list=google
add address=64.233.178.0/24 list=google
add address=64.233.177.0/24 list=google
add address=64.233.176.0/24 list=google
add address=64.233.171.0/24 list=google
add address=64.233.169.0/24 list=google
add address=64.233.168.0/24 list=google
add address=64.233.167.0/24 list=google
add address=64.233.166.0/24 list=google
add address=64.233.165.0/24 list=google
add address=64.233.164.0/24 list=google
add address=64.233.163.0/24 list=google
add address=64.233.162.0/24 list=google
add address=64.233.161.0/24 list=google
add address=64.233.160.0/24 list=google
add address=64.233.160.0/19 list=google
add address=45.56.0.0/18 list=google
add address=41.244.244.0/24 list=google
add address=35.184.0.0/13 list=google
add address=23.255.128.0/17 list=google
add address=23.251.128.0/19 list=google
add address=23.236.48.0/20 list=google
add address=23.228.128.0/18 list=google
add address=223.27.237.0/24 list=google
add address=216.58.223.0/24 list=google
add address=216.58.222.0/24 list=google
add address=216.58.221.0/24 list=google
add address=216.58.220.0/24 list=google
add address=216.58.219.0/24 list=google
add address=216.58.218.0/24 list=google
add address=216.58.217.0/24 list=google
add address=216.58.216.0/24 list=google
add address=216.58.215.0/24 list=google
add address=216.58.214.0/24 list=google
add address=216.58.213.0/24 list=google
add address=216.58.212.0/24 list=google
add address=216.58.211.0/24 list=google
add address=216.58.210.0/24 list=google
add address=216.58.209.0/24 list=google
add address=216.58.208.0/24 list=google
add address=216.58.200.0/24 list=google
add address=216.58.192.0/19 list=google
add address=216.252.222.0/24 list=google
add address=216.252.221.0/24 list=google
add address=216.252.220.0/24 list=google
add address=216.252.220.0/22 list=google
add address=216.239.60.0/24 list=google
add address=216.239.39.0/24 list=google
add address=216.239.38.0/24 list=google
add address=216.239.36.0/24 list=google
add address=216.239.35.0/24 list=google
add address=216.239.34.0/24 list=google
add address=216.239.33.0/24 list=google
add address=216.239.32.0/24 list=google
add address=216.239.32.0/19 list=google
add address=216.21.160.0/20 list=google
add address=209.85.235.0/24 list=google
add address=209.85.234.0/24 list=google
add address=209.85.233.0/24 list=google
add address=209.85.232.0/24 list=google
add address=209.85.203.0/24 list=google
add address=209.85.202.0/24 list=google
add address=209.85.201.0/24 list=google
add address=209.85.200.0/24 list=google
add address=209.85.147.0/24 list=google
add address=209.85.145.0/24 list=google
add address=209.85.144.0/24 list=google
add address=209.85.128.0/17 list=google
add address=209.107.182.0/23 list=google
add address=209.107.176.0/23 list=google
add address=209.107.176.0/20 list=google
add address=208.68.108.0/22 list=google
add address=207.223.160.0/20 list=google
add address=199.223.232.0/21 list=google
add address=199.192.112.0/22 list=google
add address=197.199.254.0/24 list=google
add address=197.199.253.0/24 list=google
add address=192.200.224.0/19 list=google
add address=192.178.0.0/15 list=google
add address=192.158.28.0/22 list=google
add address=192.119.28.0/24 list=google
add address=192.119.16.0/20 list=google
add address=192.104.160.0/23 list=google
add address=185.25.30.0/24 list=google
add address=185.25.28.0/23 list=google
add address=185.150.148.0/22 list=google
add address=173.255.112.0/20 list=google
add address=173.194.79.0/24 list=google
add address=173.194.78.0/24 list=google
add address=173.194.77.0/24 list=google
add address=173.194.76.0/24 list=google
add address=173.194.74.0/24 list=google
add address=173.194.73.0/24 list=google
add address=173.194.72.0/24 list=google
add address=173.194.70.0/24 list=google
add address=173.194.7.0/24 list=google
add address=173.194.69.0/24 list=google
add address=173.194.68.0/24 list=google
add address=173.194.67.0/24 list=google
add address=173.194.66.0/24 list=google
add address=173.194.64.0/24 list=google
add address=173.194.63.0/24 list=google
add address=173.194.53.0/24 list=google
add address=173.194.47.0/24 list=google
add address=173.194.46.0/24 list=google
add address=173.194.45.0/24 list=google
add address=173.194.44.0/24 list=google
add address=173.194.43.0/24 list=google
add address=173.194.42.0/24 list=google
add address=173.194.41.0/24 list=google
add address=173.194.40.0/24 list=google
add address=173.194.39.0/24 list=google
add address=173.194.38.0/24 list=google
add address=173.194.37.0/24 list=google
add address=173.194.36.0/24 list=google
add address=173.194.35.0/24 list=google
add address=173.194.34.0/24 list=google
add address=173.194.33.0/24 list=google
add address=173.194.32.0/24 list=google
add address=173.194.223.0/24 list=google
add address=173.194.222.0/24 list=google
add address=173.194.221.0/24 list=google
add address=173.194.220.0/24 list=google
add address=173.194.219.0/24 list=google
add address=173.194.218.0/24 list=google
add address=173.194.217.0/24 list=google
add address=173.194.216.0/24 list=google
add address=173.194.215.0/24 list=google
add address=173.194.214.0/24 list=google
add address=173.194.213.0/24 list=google
add address=173.194.212.0/24 list=google
add address=173.194.211.0/24 list=google
add address=173.194.210.0/24 list=google
add address=173.194.209.0/24 list=google
add address=173.194.208.0/24 list=google
add address=173.194.207.0/24 list=google
add address=173.194.206.0/24 list=google
add address=173.194.205.0/24 list=google
add address=173.194.204.0/24 list=google
add address=173.194.203.0/24 list=google
add address=173.194.202.0/24 list=google
add address=173.194.201.0/24 list=google
add address=173.194.200.0/24 list=google
add address=173.194.199.0/24 list=google
add address=173.194.198.0/24 list=google
add address=173.194.197.0/24 list=google
add address=173.194.196.0/24 list=google
add address=173.194.195.0/24 list=google
add address=173.194.194.0/24 list=google
add address=173.194.193.0/24 list=google
add address=173.194.192.0/24 list=google
add address=173.194.175.0/24 list=google
add address=173.194.142.0/24 list=google
add address=173.194.141.0/24 list=google
add address=173.194.140.0/24 list=google
add address=173.194.136.0/24 list=google
add address=173.194.132.0/24 list=google
add address=173.194.127.0/24 list=google
add address=173.194.126.0/24 list=google
add address=173.194.125.0/24 list=google
add address=173.194.124.0/24 list=google
add address=173.194.121.0/24 list=google
add address=173.194.120.0/24 list=google
add address=173.194.119.0/24 list=google
add address=173.194.118.0/24 list=google
add address=173.194.117.0/24 list=google
add address=173.194.113.0/24 list=google
add address=173.194.112.0/24 list=google
add address=173.194.0.0/16 list=google
add address=172.253.0.0/16 list=google
add address=172.217.30.0/24 list=google
add address=172.217.28.0/24 list=google
add address=172.217.24.0/24 list=google
add address=172.217.16.0/24 list=google
add address=172.217.0.0/24 list=google
add address=172.217.0.0/16 list=google
add address=172.102.9.0/24 list=google
add address=172.102.8.0/24 list=google
add address=172.102.8.0/21 list=google
add address=172.102.14.0/23 list=google
add address=172.102.12.0/23 list=google
add address=172.102.11.0/24 list=google
add address=172.102.10.0/24 list=google
add address=128.0.0.0/2 list=google
add address=162.222.176.0/21 list=google
add address=162.216.148.0/22 list=google
add address=146.88.60.0/24 list=google
add address=146.148.0.0/17 list=google
add address=142.250.0.0/15 list=google
add address=136.32.0.0/11 list=google
add address=136.22.1.0/24 list=google
add address=136.22.0.0/24 list=google
add address=136.22.0.0/23 list=google
add address=130.211.0.0/16 list=google
add address=111.92.162.0/24 list=google
add address=108.59.80.0/20 list=google
add address=108.177.98.0/24 list=google
add address=108.177.97.0/24 list=google
add address=108.177.96.0/24 list=google
add address=108.177.9.0/24 list=google
add address=108.177.8.0/24 list=google
add address=108.177.7.0/24 list=google
add address=108.177.30.0/24 list=google
add address=108.177.17.0/24 list=google
add address=108.177.16.0/24 list=google
add address=108.177.15.0/24 list=google
add address=108.177.14.0/24 list=google
add address=108.177.13.0/24 list=google
add address=108.177.12.0/24 list=google
add address=108.177.11.0/24 list=google
add address=108.177.10.0/24 list=google
add address=108.177.0.0/17 list=google
add address=108.170.192.0/18 list=google
add address=107.188.128.0/17 list=google
add address=107.178.192.0/18 list=google
add address=107.167.160.0/19 list=google
add address=104.196.0.0/14 list=google
add address=104.154.0.0/15 list=google
add address=104.134.240.0/24 list=google
add address=104.133.7.0/24 list=google
add address=104.133.6.0/24 list=google
add address=104.133.5.0/24 list=google
add address=104.133.4.0/24 list=google
add address=104.133.2.0/23 list=google
add address=104.133.1.0/24 list=google
add address=104.133.0.0/24 list=google
add address=104.132.98.0/24 list=google
add address=104.132.8.0/24 list=google
add address=104.132.7.0/24 list=google
add address=104.132.65.0/24 list=google
add address=104.132.62.0/24 list=google
add address=104.132.61.0/24 list=google
add address=104.132.6.0/24 list=google
add address=104.132.59.0/24 list=google
add address=104.132.57.0/24 list=google
add address=104.132.56.0/24 list=google
add address=104.132.52.0/24 list=google
add address=104.132.51.0/24 list=google
add address=104.132.5.0/24 list=google
add address=104.132.43.0/24 list=google
add address=104.132.42.0/24 list=google
add address=104.132.41.0/24 list=google
add address=104.132.40.0/24 list=google
add address=104.132.38.0/24 list=google
add address=104.132.37.0/24 list=google
add address=104.132.34.0/24 list=google
add address=104.132.33.0/24 list=google
add address=104.132.30.0/24 list=google
add address=104.132.3.0/24 list=google
add address=104.132.29.0/24 list=google
add address=104.132.27.0/24 list=google
add address=104.132.26.0/24 list=google
add address=104.132.25.0/24 list=google
add address=104.132.23.0/24 list=google
add address=104.132.227.0/24 list=google
add address=104.132.222.0/24 list=google
add address=104.132.216.0/24 list=google
add address=104.132.215.0/24 list=google
add address=104.132.214.0/24 list=google
add address=104.132.213.0/24 list=google
add address=104.132.212.0/24 list=google
add address=104.132.211.0/24 list=google
add address=104.132.210.0/24 list=google
add address=104.132.21.0/24 list=google
add address=104.132.209.0/24 list=google
add address=104.132.207.0/24 list=google
add address=104.132.206.0/24 list=google
add address=104.132.205.0/24 list=google
add address=104.132.203.0/24 list=google
add address=104.132.202.0/24 list=google
add address=104.132.201.0/24 list=google
add address=104.132.200.0/24 list=google
add address=104.132.199.0/24 list=google
add address=104.132.198.0/24 list=google
add address=104.132.196.0/24 list=google
add address=104.132.192.0/24 list=google
add address=104.132.190.0/24 list=google
add address=104.132.19.0/24 list=google
add address=104.132.189.0/24 list=google
add address=104.132.187.0/24 list=google
add address=104.132.186.0/24 list=google
add address=104.132.184.0/24 list=google
add address=104.132.183.0/24 list=google
add address=104.132.180.0/24 list=google
add address=104.132.18.0/24 list=google
add address=104.132.179.0/24 list=google
add address=104.132.178.0/24 list=google
add address=104.132.177.0/24 list=google
add address=104.132.176.0/24 list=google
add address=104.132.174.0/24 list=google
add address=104.132.171.0/24 list=google
add address=104.132.17.0/24 list=google
add address=104.132.169.0/24 list=google
add address=104.132.168.0/24 list=google
add address=104.132.167.0/24 list=google
add address=104.132.166.0/24 list=google
add address=104.132.165.0/24 list=google
add address=104.132.164.0/24 list=google
add address=104.132.163.0/24 list=google
add address=104.132.162.0/24 list=google
add address=104.132.161.0/24 list=google
add address=104.132.160.0/24 list=google
add address=104.132.159.0/24 list=google
add address=104.132.155.0/24 list=google
add address=104.132.153.0/24 list=google
add address=104.132.152.0/24 list=google
add address=104.132.151.0/24 list=google
add address=104.132.150.0/24 list=google
add address=104.132.149.0/24 list=google
add address=104.132.146.0/24 list=google
add address=104.132.144.0/24 list=google
add address=104.132.142.0/24 list=google
add address=104.132.141.0/24 list=google
add address=104.132.140.0/24 list=google
add address=104.132.139.0/24 list=google
add address=104.132.138.0/24 list=google
add address=104.132.135.0/24 list=google
add address=104.132.132.0/24 list=google
add address=104.132.130.0/24 list=google
add address=104.132.128.0/24 list=google
add address=104.132.126.0/24 list=google
add address=104.132.125.0/24 list=google
add address=104.132.124.0/24 list=google
add address=104.132.120.0/24 list=google
add address=104.132.12.0/24 list=google
add address=104.132.119.0/24 list=google
add address=104.132.118.0/24 list=google
add address=104.132.117.0/24 list=google
add address=104.132.116.0/24 list=google
add address=104.132.114.0/24 list=google
add address=104.132.113.0/24 list=google
add address=104.132.11.0/24 list=google
add address=104.132.0.0/23 list=google
add address=104.132.0.0/14 list=google
add address=103.25.178.0/24 list=google
add address=64.15.125.0/24 list=google
add address=64.15.124.0/24 list=google
add address=64.15.123.0/24 list=google
add address=64.15.122.0/24 list=google
add address=64.15.120.0/24 list=google
add address=64.15.119.0/24 list=google
add address=64.15.118.0/24 list=google
add address=64.15.117.0/24 list=google
add address=64.15.115.0/24 list=google
add address=64.15.114.0/24 list=google
add address=64.15.113.0/24 list=google
add address=64.15.112.0/24 list=google
add address=64.15.112.0/20 list=google
add address=216.73.80.0/20 list=google
add address=208.65.155.0/24 list=google
add address=208.65.152.0/24 list=google
add address=208.65.152.0/22 list=google
add address=208.117.255.0/24 list=google
add address=208.117.253.0/24 list=google
add address=208.117.246.0/24 list=google
add address=208.117.244.0/24 list=google
add address=208.117.243.0/24 list=google
add address=208.117.235.0/24 list=google
add address=208.117.233.0/24 list=google
add address=208.117.231.0/24 list=google
add address=208.117.230.0/24 list=google
add address=208.117.229.0/24 list=google
add address=208.117.228.0/24 list=google
add address=208.117.227.0/24 list=google
add address=208.117.226.0/24 list=google
add address=208.117.225.0/24 list=google
add address=208.117.224.0/19 list=google
add address=172.110.32.0/21 list=google
add address=104.237.191.0/24 list=google
add address=104.237.190.0/24 list=google
add address=104.237.189.0/24 list=google
add address=104.237.188.0/24 list=google
add address=104.237.174.0/24 list=google
add address=104.237.172.0/24 list=google
add address=104.237.161.0/24 list=google
add address=104.237.160.0/24 list=google
add address=104.237.160.0/19 list=google
add address=172.16.178.5 comment=S10e list=VIP
add address=172.16.178.14 comment="REDMI 4X" list=VIP
/ip firewall filter
add action=accept chain=input comment="BYPASS INTERNET POSITIF" disabled=yes \
    protocol=udp src-port=53
/ip firewall mangle
add action=mark-connection chain=prerouting comment=CN-DN dst-address-list=\
    private-lokal new-connection-mark=CN-DN passthrough=yes src-address-list=\
    !private-lokal
add action=mark-packet chain=postrouting comment=VIP dst-address-list=VIP \
    new-packet-mark=VIP-DN passthrough=no src-address-list=!private-lokal
add action=mark-packet chain=postrouting comment=PM-DN connection-mark=CN-DN \
    new-packet-mark=PM-DN passthrough=no
add action=mark-connection chain=prerouting comment=CN-UP dst-address-list=\
    !private-lokal new-connection-mark=CN-UP passthrough=yes \
    src-address-list=private-lokal
add action=mark-packet chain=postrouting comment=VIP dst-address-list=\
    !private-lokal new-packet-mark=VIP-UP passthrough=no src-address-list=VIP
add action=mark-packet chain=postrouting comment=PM-UP connection-mark=CN-UP \
    new-packet-mark=PM-UP passthrough=no
add action=mark-routing chain=prerouting comment="Youtube, IG, FB" disabled=\
    yes dst-address-list=Youtube new-routing-mark="Kecuali Link ID" \
    passthrough=no src-address-list=private-lokal time=\
    0s-1d,sun,mon,tue,wed,thu,fri,sat
add action=mark-routing chain=prerouting disabled=yes dst-address-list=\
    Netflix new-routing-mark="Kecuali Link ID" passthrough=no \
    src-address-list=private-lokal
add action=mark-routing chain=prerouting disabled=yes dst-address-list=google \
    new-routing-mark="Kecuali Link ID" passthrough=no src-address-list=\
    private-lokal
add action=mark-routing chain=prerouting disabled=yes dst-address-list=\
    GlobalMedia new-routing-mark="Kecuali Link ID" passthrough=no \
    src-address-list=private-lokal
add action=mark-routing chain=prerouting disabled=yes dst-address-list=\
    LLC-GOOGLE new-routing-mark="Kecuali Link ID" passthrough=no \
    src-address-list=private-lokal
add action=mark-routing chain=prerouting disabled=yes dst-address-list=sosmed \
    new-routing-mark="Kecuali Link ID" passthrough=no src-address-list=\
    private-lokal
add action=mark-routing chain=prerouting disabled=yes dst-address-list=\
    "IP GAME ONLINE" new-routing-mark="Kecuali Link ID" passthrough=no \
    src-address-list=private-lokal time=0s-1d,sun,mon,tue,wed,thu,fri,sat
add action=mark-routing chain=prerouting disabled=yes dst-address-list=\
    !private-lokal new-routing-mark="Kecuali Link ID" passthrough=no \
    protocol=tcp src-address-list=private-lokal time=\
    0s-1d,sun,mon,tue,wed,thu,fri,sat
add action=mark-routing chain=prerouting disabled=yes dst-address-list=\
    !private-lokal new-routing-mark="Kecuali Link ID" passthrough=no \
    protocol=udp src-address-list=private-lokal time=\
    0s-1d,sun,mon,tue,wed,thu,fri,sat
add action=accept chain=prerouting disabled=yes dst-address-list=\
    !private-lokal dst-port=0-2000,8000-8999,4500 protocol=tcp \
    src-address-list=private-lokal
add action=accept chain=prerouting disabled=yes dst-address-list=\
    !private-lokal dst-port=0-2000,8000-8999,4500 protocol=udp \
    src-address-list=private-lokal
add action=mark-routing chain=prerouting disabled=yes dst-address-list=\
    !private-lokal new-routing-mark="Kecuali Link ID" passthrough=no \
    src-address-list=private-lokal
add action=jump chain=forward disabled=yes in-interface=ether1-Internet \
    jump-target=jumpTRAFIK
add action=jump chain=forward disabled=yes in-interface=VPN jump-target=\
    jumpTRAFIK
add action=jump chain=forward disabled=yes jump-target=jumpTRAFIK \
    out-interface=ether1-Internet
add action=jump chain=forward disabled=yes jump-target=jumpTRAFIK \
    out-interface=VPN
add action=accept chain=jumpTRAFIK disabled=yes protocol=icmp
add action=accept chain=jumpTRAFIK disabled=yes protocol=tcp src-port=\
    53,5353,123
add action=accept chain=jumpTRAFIK disabled=yes dst-port=53,5353,123 \
    protocol=tcp
add action=accept chain=jumpTRAFIK disabled=yes protocol=udp src-port=\
    53,5353,123
add action=accept chain=jumpTRAFIK disabled=yes dst-port=53,5353,123 \
    protocol=udp
add action=mark-packet chain=jumpTRAFIK disabled=yes new-packet-mark=trafik \
    passthrough=no protocol=tcp src-port=0-2000,8000-8999,4500
add action=mark-packet chain=jumpTRAFIK disabled=yes dst-port=\
    0-2000,8000-8999,4500 new-packet-mark=trafik passthrough=no protocol=tcp
add action=mark-packet chain=jumpTRAFIK disabled=yes new-packet-mark=trafik \
    passthrough=no protocol=udp src-port=0-2000,8000-8999,4500
add action=mark-packet chain=jumpTRAFIK disabled=yes dst-port=\
    0-2000,8000-8999,4500 new-packet-mark=trafik passthrough=no protocol=udp
add action=accept chain=jumpTRAFIK disabled=yes
add action=return chain=jumpTRAFIK disabled=yes
/ip firewall nat
add action=dst-nat chain=dstnat comment="DNS Premium United States" dst-port=\
    53 protocol=udp to-addresses=208.67.220.220 to-ports=443
add action=dst-nat chain=dstnat dst-port=53 protocol=udp to-addresses=\
    208.67.222.222 to-ports=443
add action=dst-nat chain=dstnat comment="DNS Premium Singapore" dst-port=53 \
    protocol=udp random=50 to-addresses=103.31.225.117 to-ports=443
add action=dst-nat chain=dstnat dst-port=53 protocol=udp random=50 \
    to-addresses=103.11.143.205 to-ports=443
add action=masquerade chain=srcnat out-interface=ether1-Internet
add action=masquerade chain=srcnat disabled=yes out-interface=VPN
add action=masquerade chain=srcnat disabled=yes out-interface=OpenVPN
/ip firewall raw
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting comment=Facebook content=.facebook.com disabled=yes \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.fbcdn.net disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=fb.com disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.facebook.net disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=fbstatic-a.akamaihd.net disabled=yes \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.fbsbx.com disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=akamaihd.net disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=fbcdn-sphotos-a.akamaihd.net disabled=yes \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting comment=Instagram content=.cdninstagram.com disabled=\
    yes dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.instagram.com disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting comment=Youtube content=.googlevideo.com disabled=yes \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.youtube.com disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.ytimg.com disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting comment=Tiktok content=.tiktokv.com disabled=yes \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.tiktokcdn.com disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.musical.ly disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting comment="Likee Videoo" content=likee.video disabled=\
    yes dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=like.video disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting comment=Twitter content=.twitter.com disabled=yes \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.twimg.com disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting comment=Telegram content=.telegram.org disabled=yes \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=Youtube address-list-timeout=\
    1h chain=prerouting content=.telegram.me disabled=yes dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment=\
    "MOBILE LEGENDS: BANG BANG (ML)" disabled=yes dst-address-list=\
    !private-lokal dst-port=\
    5000-5508,5551-5558,5601-5608,5651-5658,30097-30147 protocol=tcp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment=\
    "ARENA OF VALOR (AOV)  GARENA" disabled=yes dst-address-list=\
    !private-lokal dst-port=10001-10094 protocol=tcp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment=\
    "ARENA OF VALOR (AOV)  GARENA" disabled=yes dst-address-list=\
    !private-lokal dst-port=10101-10201,10080-10110,17000-18000 protocol=udp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment="Free fire garena" \
    disabled=yes dst-address-list=!private-lokal dst-port=39698,39003,39779 \
    protocol=tcp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment=PUBG disabled=yes \
    dst-address-list=!private-lokal dst-port=\
    7086-7995,12070-12460,41182-41192 protocol=udp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment=PUBG disabled=yes \
    dst-address-list=!private-lokal dst-port=10012,17500 protocol=tcp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment="POINT BLANK - Zepetto" \
    disabled=yes dst-address-list=!private-lokal dst-port=40000-40010 \
    protocol=udp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment=ROBLOX disabled=yes \
    dst-address-list=!private-lokal dst-port=56849-57729,60275-64632 \
    protocol=udp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment="Free fire garena" \
    disabled=yes dst-address-list=!private-lokal dst-port=10000-10007,7008 \
    protocol=udp
add action=add-dst-to-address-list address-list="IP GAME ONLINE" \
    address-list-timeout=1d chain=prerouting comment=PUBG disabled=yes \
    dst-address-list=!private-lokal dst-port="10491,10010,10013,10612,20002,20\
    001,20000,12235,13748,13972,13894,11455,10096,10039" protocol=udp
/ip hotspot walled-garden ip
add action=accept comment="Mikhmon QR Code Scanner" disabled=no dst-host=\
    laksa19.github.io
/ip proxy
set cache-administrator=admin@mudher.com cache-on-disk=yes cache-path=disk1
/ip route
add check-gateway=ping disabled=yes distance=1 gateway=VPN routing-mark=\
    "Kecuali Link ID"
add disabled=yes distance=1 gateway=OpenVPN routing-mark=vpngaben
add disabled=yes distance=1 gateway=192.168.100.1
add disabled=yes distance=1 dst-address=10.0.0.0/8 gateway=10.118.128.1
/ip service
set telnet disabled=yes
set ssh disabled=yes
set api-ssl disabled=yes
/radius
add address=127.0.0.1 disabled=yes secret=123456 service=hotspot
/routing igmp-proxy
set query-interval=5s query-response-interval=5s quick-leave=yes
/routing igmp-proxy interface
add alternative-subnets=0.0.0.0/0 upstream=yes
add interface=ether2-WiFi
add interface=ether5-UniFi
/system clock
set time-zone-autodetect=no time-zone-name=Asia/Makassar
/system identity
set name=Mudher
/system ntp client
set enabled=yes primary-ntp=202.162.32.12 secondary-ntp=118.189.138.5
/tool netwatch
add host=192.168.195.1
