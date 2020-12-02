# dec/02/2020 18:41:34 by RouterOS 6.47
# software id = KBGT-B9DM
#
# model = CCR1036-12G-4S
# serial number = 6AA90571618F
/interface bridge
add name=PENDAPATAN-WIFI
/interface ethernet
set [ find default-name=ether1 ] name=ether1-UNG speed=100Mbps
set [ find default-name=ether2 ] speed=100Mbps
set [ find default-name=ether3 ] name=ether3-Pelayanan speed=100Mbps
set [ find default-name=ether4 ] name=ether4-Pendapatan-LAN speed=100Mbps
set [ find default-name=ether5 ] name="ether5-Access Point" speed=100Mbps
set [ find default-name=ether6 ] name=ether6-Keuangan speed=100Mbps
set [ find default-name=ether7 ] speed=100Mbps
set [ find default-name=ether8 ] speed=100Mbps
set [ find default-name=ether9 ] advertise=\
    10M-full,100M-full,1000M-full,2500M-full,5000M-full,10000M-full name=\
    ether9-Server speed=40Gbps
set [ find default-name=ether10 ] name=ether10-KOMINFO_Integrasi speed=\
    100Mbps
set [ find default-name=ether11 ] name=ether11-ASTINET speed=100Mbps
set [ find default-name=ether12 ] name=ether12-Admin speed=100Mbps
set [ find default-name=sfp1 ] advertise=10M-full,100M-full,1000M-full \
    disabled=yes
set [ find default-name=sfp2 ] advertise=10M-full,100M-full,1000M-full \
    disabled=yes
set [ find default-name=sfp3 ] advertise=10M-full,100M-full,1000M-full \
    disabled=yes
set [ find default-name=sfp4 ] advertise=10M-full,100M-full,1000M-full \
    disabled=yes
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip firewall layer7-protocol
add name=EXE regexp="\\x4d\\x5a(\\x90\\x03|\\x50\\x02)\\x04"
add name=ZIP regexp="pk\\x03\\x04\\x14"
add name=MP4 regexp="\\x18\\x66\\x74\\x79\\x70"
add name=RAR regexp="Rar\\x21\\x1a\\x07"
add name=youtube regexp="r[0-9]+---[a-z]+-+[a-z0-9-]+\\.googlevideo\\.com"
/ip pool
add name=dhcp_pool5 ranges=192.168.50.2-192.168.50.254
add name=dhcp_pool9 ranges=192.168.90.2-192.168.90.254
add name=dhcp_pool12 ranges=192.168.120.2-192.168.120.254
add name=dhcp_pool4.2 ranges=192.168.42.2-192.168.42.254
add name=dhcp_pool6 ranges=\
    192.168.60.1-192.168.60.2,192.168.60.4-192.168.60.254
add name=dhcp_pool3.2 ranges=192.168.32.2-192.168.32.254
add name=PENDAPATAN-WIFI ranges=10.5.50.2-10.5.51.254
add name=PRO ranges=170.16.1.1-170.16.1.100
add name=pool1 ranges=170.16.10.1-170.16.10.100
/ip dhcp-server
add add-arp=yes address-pool=dhcp_pool5 disabled=no interface=\
    "ether5-Access Point" name=dhcp5
add add-arp=yes address-pool=dhcp_pool9 disabled=no interface=ether9-Server \
    name=dhcp9
add add-arp=yes address-pool=dhcp_pool12 disabled=no interface=ether12-Admin \
    name=dhcp12
add address-pool=dhcp_pool6 disabled=no interface=ether6-Keuangan name=dhcp6
add add-arp=yes address-pool=PENDAPATAN-WIFI disabled=no interface=\
    PENDAPATAN-WIFI name=PENDAPATAN-WIFI
/ip pool
add name=dhcp_pool4.1 next-pool=dhcp_pool4.2 ranges=\
    192.168.41.2-192.168.41.254
add name=dhcp_pool3.1 next-pool=dhcp_pool3.2 ranges=\
    192.168.31.2-192.168.31.254
add name=dhcp_pool3 next-pool=dhcp_pool3.1 ranges=192.168.30.2-192.168.30.254
add name=dhcp_pool4 next-pool=dhcp_pool4.1 ranges=192.168.40.2-192.168.40.254
/ip dhcp-server
add add-arp=yes address-pool=dhcp_pool3 disabled=no interface=\
    ether3-Pelayanan name=dhcp3
add add-arp=yes address-pool=dhcp_pool4 disabled=no interface=\
    ether4-Pendapatan-LAN name=dhcp4
/ppp profile
set *0 only-one=yes
/queue type
set 0 kind=bfifo
set 1 kind=none
add kind=pcq name=PCQ pcq-classifier=\
    src-address,dst-address,src-port,dst-port pcq-dst-address6-mask=64 \
    pcq-src-address6-mask=64
add kind=pcq name=down_pcq pcq-classifier=dst-address pcq-dst-address6-mask=\
    64 pcq-src-address6-mask=64
add kind=pcq name=up_pcq pcq-classifier=src-address pcq-dst-address6-mask=64 \
    pcq-src-address6-mask=64
set 12 pfifo-limit=100
/queue interface
set ether1-UNG queue=default
set ether2 queue=default
set ether3-Pelayanan queue=default
set ether4-Pendapatan-LAN queue=default
set "ether5-Access Point" queue=default
set ether6-Keuangan queue=default
set ether9-Server queue=default
set ether11-ASTINET queue=default
/queue tree
add name="Global Traffic" parent=global queue=default
add max-limit=200M name=Download parent="Global Traffic" queue=default
add max-limit=40M name=Upload parent="Global Traffic"
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
add max-limit=200M name="1. Vip" packet-mark=vip-dl parent=Download priority=\
    1 queue=down_pcq
add max-limit=40M name="1. vip" packet-mark=vip-up parent=Upload priority=1 \
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
/tool user-manager customer
set admin access=\
    own-routers,own-users,own-profiles,own-limits,config-payment-gw password=\
    qwerty12
/tool user-manager profile
add name=shareduser30 name-for-users="" override-shared-users=off owner=admin \
    price=0 starts-at=logon validity=0s
/tool user-manager profile limitation
add address-list="" download-limit=0B group-name=shareduser30 ip-pool="" \
    ip-pool6="" name=shareduser30 owner=admin transfer-limit=0B upload-limit=\
    0B uptime-limit=0s
/user group
set full policy="local,telnet,ssh,ftp,reboot,read,write,policy,test,winbox,pas\
    sword,web,sniff,sensitive,api,romon,dude,tikapp"
/interface bridge port
add bridge=PENDAPATAN-WIFI interface=ether7
add bridge=PENDAPATAN-WIFI interface=ether8
add bridge=PENDAPATAN-WIFI interface=ether2
/ip firewall connection tracking
set enabled=yes generic-timeout=5m icmp-timeout=5s loose-tcp-tracking=no \
    tcp-close-timeout=1s tcp-close-wait-timeout=5s tcp-fin-wait-timeout=5s \
    tcp-last-ack-timeout=1s tcp-syn-received-timeout=1s tcp-syn-sent-timeout=\
    1s tcp-time-wait-timeout=1s udp-stream-timeout=1m udp-timeout=1s
/ip neighbor discovery-settings
set discover-interface-list=all
/interface l2tp-server server
set default-profile=default enabled=yes ipsec-secret=898989 use-ipsec=yes
/interface ovpn-server server
set certificate=server cipher=blowfish128,aes128,aes192,aes256 enabled=yes \
    require-client-certificate=yes
/interface pptp-server server
set authentication=pap,chap,mschap1,mschap2 default-profile=default enabled=\
    yes
/ip address
add address=192.168.30.1/24 interface=ether3-Pelayanan network=192.168.30.0
add address=192.168.50.1/24 interface="ether5-Access Point" network=\
    192.168.50.0
add address=192.168.40.1/24 interface=ether4-Pendapatan-LAN network=\
    192.168.40.0
add address=192.168.90.1/24 interface=ether9-Server network=192.168.90.0
add address=192.168.120.1/24 interface=ether12-Admin network=192.168.120.0
add address=36.89.215.26/29 comment="SERVER DATA CENTER" interface=\
    ether11-ASTINET network=36.89.215.24
add address=36.89.215.27/29 comment=ASET interface=ether11-ASTINET network=\
    36.89.215.24
add address=36.89.215.28/29 comment=LINUX interface=ether11-ASTINET network=\
    36.89.215.24
add address=36.89.215.29/29 comment=FREE interface=ether11-ASTINET network=\
    36.89.215.24
add address=36.89.215.30/29 comment=RETRIBUSI interface=ether11-ASTINET \
    network=36.89.215.24
add address=10.5.50.1/23 interface=PENDAPATAN-WIFI network=10.5.50.0
add address=172.21.6.6/30 interface=ether10-KOMINFO_Integrasi network=\
    172.21.6.4
/ip arp
add address=192.168.90.203 interface=ether9-Server mac-address=\
    00:15:5D:5A:C8:03
add address=192.168.90.204 interface=ether9-Server mac-address=\
    00:15:5D:5A:C8:05
add address=192.168.90.200 interface=ether9-Server mac-address=\
    20:04:0F:E5:1E:C0
add address=192.168.90.205 interface=ether9-Server mac-address=\
    00:15:5D:5A:C8:06
add address=192.168.90.3 interface=ether9-Server mac-address=\
    50:9A:4C:69:79:9A
add address=192.168.90.8 interface=ether9-Server mac-address=\
    20:04:0F:E5:1E:C0
add address=192.168.90.201 interface=ether9-Server mac-address=\
    00:15:5D:5A:C8:07
/ip cloud
set ddns-enabled=yes update-time=no
/ip dhcp-client
add add-default-route=no disabled=no interface=ether6-Keuangan use-peer-dns=\
    no
add add-default-route=no dhcp-options=clientid,hostname,clientid_duid \
    disabled=no interface=ether1-UNG use-peer-ntp=no
/ip dhcp-server lease
add address=192.168.40.13 client-id=1:1c:1b:d:db:e3:44 comment=DEVELOPER \
    mac-address=1C:1B:0D:DB:E3:44 server=dhcp4
add address=192.168.40.9 client-id=1:98:28:a6:3:96:be comment=BARON \
    mac-address=98:28:A6:03:96:BE server=dhcp4
add address=192.168.120.254 client-id=1:10:78:d2:3e:ad:80 mac-address=\
    10:78:D2:3E:AD:80 server=dhcp12
add address=192.168.120.252 client-id=1:48:e2:44:4:8c:3b mac-address=\
    48:E2:44:04:8C:3B server=dhcp12
add address=192.168.120.231 client-id=1:b4:d5:bd:95:44:d mac-address=\
    B4:D5:BD:95:44:0D server=dhcp12
add address=192.168.120.233 client-id=1:f0:3:8c:6b:31:43 mac-address=\
    F0:03:8C:6B:31:43 server=dhcp12
add address=192.168.90.8 client-id=1:20:4:f:e5:1e:c0 mac-address=\
    20:04:0F:E5:1E:C0 server=dhcp9
add address=192.168.120.81 client-id=1:70:85:c2:72:7d:18 mac-address=\
    70:85:C2:72:7D:18 server=dhcp12
add address=192.168.30.8 client-id=1:4:d9:f5:53:9f:4b comment=PELAYANAN-3 \
    mac-address=04:D9:F5:53:9F:4B server=dhcp3
add address=192.168.30.9 client-id=1:4:d9:f5:53:9e:9b comment=PELAYANAN-2 \
    mac-address=04:D9:F5:53:9E:9B server=dhcp3
add address=192.168.30.4 client-id=1:4:d9:f5:53:9e:dc comment=PELAYANAN-1 \
    mac-address=04:D9:F5:53:9E:DC server=dhcp3
add address=192.168.40.10 client-id=1:70:85:c2:71:d3:fb comment="PAK BOS" \
    mac-address=70:85:C2:71:D3:FB server=dhcp4
add address=192.168.90.7 client-id=1:18:66:da:ef:6c:30 mac-address=\
    18:66:DA:EF:6C:30 server=dhcp9
add address=192.168.90.6 client-id=1:0:15:5d:5a:c8:8 mac-address=\
    00:15:5D:5A:C8:08 server=dhcp9
add address=192.168.90.5 client-id=1:50:9a:4c:69:79:9a mac-address=\
    50:9A:4C:69:79:9A server=dhcp9
add address=192.168.40.6 client-id=1:1c:1b:d:88:35:ab mac-address=\
    1C:1B:0D:88:35:AB server=dhcp4
add address=192.168.40.8 client-id=1:74:27:ea:f:b1:2c mac-address=\
    74:27:EA:0F:B1:2C server=dhcp4
add address=192.168.40.3 client-id=1:8c:89:a5:19:9c:f2 mac-address=\
    8C:89:A5:19:9C:F2 server=dhcp4
add address=192.168.40.15 client-id=1:8:0:27:45:28:8c mac-address=\
    08:00:27:45:28:8C server=dhcp4
add address=192.168.40.7 client-id=1:a4:1f:72:6e:46:7c mac-address=\
    A4:1F:72:6E:46:7C server=dhcp4
add address=10.5.50.25 client-id=1:28:3f:69:fc:bd:90 mac-address=\
    28:3F:69:FC:BD:90 server=PENDAPATAN-WIFI
add address=192.168.30.10 client-id=1:4:d9:f5:53:9f:8f comment=3 mac-address=\
    04:D9:F5:53:9F:8F server=dhcp3
add address=10.5.50.28 client-id=1:60:e3:27:10:ff:69 comment="K VONI" \
    mac-address=60:E3:27:10:FF:69 server=PENDAPATAN-WIFI
add address=10.5.50.36 client-id=1:48:e2:44:4:8c:3b comment="K VIVI" \
    mac-address=48:E2:44:04:8C:3B server=PENDAPATAN-WIFI
add address=10.5.50.6 client-id=1:ba:b9:9e:45:e5:38 mac-address=\
    BA:B9:9E:45:E5:38 server=PENDAPATAN-WIFI
add address=10.5.50.67 client-id=1:f0:3:8c:6b:31:43 mac-address=\
    F0:03:8C:6B:31:43 server=PENDAPATAN-WIFI
add address=10.5.50.204 client-id=1:9c:ae:d3:f5:c9:c5 comment=\
    "EPSON SCAN PELAYANAN" mac-address=9C:AE:D3:F5:C9:C5 server=\
    PENDAPATAN-WIFI
/ip dhcp-server network
add address=10.5.50.0/23 gateway=10.5.50.1
add address=192.168.30.0/24 gateway=192.168.30.1
add address=192.168.40.0/24 gateway=192.168.40.1
add address=192.168.50.0/24 gateway=192.168.50.1
add address=192.168.60.0/24 gateway=192.168.60.3
add address=192.168.90.0/24 gateway=192.168.90.1
add address=192.168.100.0/24 gateway=192.168.100.1
add address=192.168.120.0/24 gateway=192.168.120.1
/ip dns
set allow-remote-requests=yes servers=\
    172.20.100.1,8.8.8.8,8.8.4.4,202.134.1.10,202.134.0.155
/ip dns static
add address=36.89.215.26 name=YANJAK type=A
/ip firewall address-list
add address=10.0.0.0/8 list=private-lokal
add address=172.16.0.0/12 list=private-lokal
add address=192.168.0.0/16 list=private-lokal
add address=192.168.120.81 list=VIP
add address=192.168.90.0/24 disabled=yes list=VIP
add address=10.5.50.25 disabled=yes list=VIP
add address=10.5.50.6 list=VIP
add address=36.89.215.26 list=server
add address=36.89.215.27 list=server
add address=36.89.215.28 list=server
add address=36.89.215.29 list=server
add address=36.89.215.30 list=server
add address=118.98.0.0/17 list=ggc-telkom
add address=118.97.0.0/16 list=ggc-telkom
/ip firewall filter
add action=accept chain=input comment="DNS FORWARDING" protocol=udp src-port=\
    53
add action=accept chain=output comment="Drop FTP Brute Forcers" content=\
    "530 Login incorrect" dst-limit=1/1m,9,dst-address/1m protocol=tcp
add action=add-dst-to-address-list address-list=FTP_BlackList \
    address-list-timeout=1d chain=output content="530 Login incorrect" \
    protocol=tcp
add action=drop chain=input dst-port=21 protocol=tcp src-address-list=\
    FTP_BlackList
add action=add-src-to-address-list address-list=SSH_BlackList_1 \
    address-list-timeout=1m chain=input comment=\
    "Drop SSH&TELNET Brute Forcers" connection-state=new dst-port=22-23 \
    protocol=tcp
add action=add-src-to-address-list address-list=SSH_BlackList_2 \
    address-list-timeout=1m chain=input connection-state=new dst-port=22-23 \
    protocol=tcp src-address-list=SSH_BlackList_1
add action=add-src-to-address-list address-list=SSH_BlackList_3 \
    address-list-timeout=1m chain=input connection-state=new dst-port=22-23 \
    protocol=tcp src-address-list=SSH_BlackList_2
add action=add-src-to-address-list address-list=IP_BlackList \
    address-list-timeout=1d chain=input connection-state=new dst-port=22-23 \
    protocol=tcp src-address-list=SSH_BlackList_3
add action=drop chain=input dst-port=22-23 protocol=tcp src-address-list=\
    IP_BlackList
/ip firewall mangle
add action=mark-routing chain=prerouting comment="Mark IP Server" \
    new-routing-mark=SERVER passthrough=no src-address=192.168.90.0/24
add action=mark-routing chain=prerouting comment="Integrasi Capil/DKCS" \
    dst-address=172.21.21.2 new-routing-mark=CAPIL passthrough=no \
    src-address-list=private-lokal
add action=accept chain=prerouting comment="Bypass Local Traffic" \
    dst-address-list=private-lokal src-address-list=private-lokal
add action=accept chain=forward dst-address-list=private-lokal \
    src-address-list=private-lokal
add action=jump chain=forward comment="QOS Down" in-interface=ether1-UNG \
    jump-target=qos-down
add action=return chain=qos-down
add action=jump chain=forward comment="QOS Up" jump-target=qos-up \
    out-interface=ether1-UNG
add action=return chain=qos-up
add action=mark-packet chain=postrouting comment="VIP Traffic" \
    dst-address-list=VIP new-packet-mark=vip-dl passthrough=no \
    src-address-list=!private-lokal
add action=mark-packet chain=postrouting dst-address-list=!private-lokal \
    new-packet-mark=vip-up passthrough=no src-address-list=VIP
add action=mark-connection chain=prerouting comment="Sosmed Traffic" \
    dst-address-list=sosmed new-connection-mark=sosmed passthrough=yes \
    src-address-list=private-lokal
add action=accept chain=prerouting connection-mark=sosmed
add action=mark-packet chain=qos-down connection-mark=sosmed new-packet-mark=\
    sosmed-down passthrough=no
add action=mark-packet chain=qos-up connection-mark=sosmed new-packet-mark=\
    sosmed-up passthrough=no
add action=mark-connection chain=forward comment="Games Traffic" \
    dst-address-list=games new-connection-mark=games passthrough=yes \
    protocol=tcp src-address-list=private-lokal
add action=mark-connection chain=forward dst-address-list=games \
    new-connection-mark=games passthrough=yes protocol=udp src-address-list=\
    private-lokal
add action=mark-packet chain=forward connection-mark=games in-interface=\
    ether1-UNG new-packet-mark=games_down passthrough=no
add action=mark-packet chain=forward connection-mark=games new-packet-mark=\
    games_up out-interface=ether1-UNG passthrough=no
add action=mark-connection chain=prerouting comment=GGC-Telkom \
    dst-address-list=ggc-telkom new-connection-mark=ggc-redirector \
    passthrough=yes src-address-list=private-lokal
add action=accept chain=prerouting connection-mark=ggc-redirector
add action=mark-packet chain=qos-down connection-mark=ggc-redirector \
    new-packet-mark=ggc-telkom-down passthrough=no
add action=mark-packet chain=qos-up connection-mark=ggc-redirector \
    new-packet-mark=ggc-telkom-up passthrough=no
add action=mark-connection chain=forward comment="ICMP Traffic" \
    new-connection-mark=icmp passthrough=yes protocol=icmp src-address-list=\
    private-lokal
add action=mark-packet chain=forward connection-mark=icmp in-interface=\
    ether1-UNG new-packet-mark=icmp_down passthrough=no protocol=icmp
add action=mark-packet chain=forward connection-mark=icmp new-packet-mark=\
    icmp_up out-interface=ether1-UNG passthrough=no protocol=icmp
add action=mark-connection chain=forward comment="DNS Traffic" dst-port=53 \
    new-connection-mark=dns passthrough=yes protocol=udp src-address-list=\
    private-lokal
add action=mark-packet chain=forward connection-mark=dns in-interface=\
    ether1-UNG new-packet-mark=dns_down passthrough=no protocol=udp
add action=mark-packet chain=forward connection-mark=dns new-packet-mark=\
    dns_up out-interface=ether1-UNG passthrough=no protocol=udp
add action=mark-connection chain=forward comment="Remote Traffic" dst-port=\
    22,23,8291,5938,4899 new-connection-mark=remote passthrough=yes protocol=\
    tcp src-address-list=private-lokal
add action=mark-packet chain=forward connection-mark=remote in-interface=\
    ether1-UNG new-packet-mark=remote_down passthrough=no
add action=mark-packet chain=forward connection-mark=remote new-packet-mark=\
    remote_up out-interface=ether1-UNG passthrough=no
add action=mark-connection chain=forward comment="YouTube Traffic" \
    layer7-protocol=youtube new-connection-mark=youtube passthrough=yes \
    src-address-list=private-lokal
add action=mark-packet chain=forward connection-mark=youtube in-interface=\
    ether1-UNG new-packet-mark=youtube_down passthrough=no
add action=mark-packet chain=forward connection-mark=youtube new-packet-mark=\
    youtube_up out-interface=ether1-UNG passthrough=no
add action=mark-connection chain=forward comment="Extension Layer7" \
    layer7-protocol=EXE new-connection-mark=extensi passthrough=yes
add action=mark-connection chain=forward layer7-protocol=ZIP \
    new-connection-mark=extensi passthrough=yes
add action=mark-connection chain=forward layer7-protocol=RAR \
    new-connection-mark=extensi passthrough=yes
add action=mark-packet chain=forward connection-mark=extensi in-interface=\
    ether1-UNG new-packet-mark=extensi_down passthrough=no
add action=mark-packet chain=forward connection-mark=extensi new-packet-mark=\
    extensi_up out-interface=ether1-UNG passthrough=no
add action=mark-connection chain=forward comment="Browsing Traffic" \
    connection-mark=!heavy_traffic new-connection-mark=browsing passthrough=\
    yes src-address-list=private-lokal
add action=mark-connection chain=forward comment="Heavy Traffic" \
    connection-bytes=1024000-0 connection-mark=browsing connection-rate=\
    512k-102400k new-connection-mark=heavy_traffic passthrough=yes protocol=\
    tcp
add action=mark-connection chain=forward connection-bytes=1024000-0 \
    connection-mark=browsing connection-rate=256k-102400k \
    new-connection-mark=heavy_traffic passthrough=yes protocol=udp
add action=mark-packet chain=forward connection-mark=heavy_traffic \
    in-interface=ether1-UNG new-packet-mark=heavy_browsing_down passthrough=\
    no
add action=mark-packet chain=forward connection-mark=heavy_traffic \
    new-packet-mark=heavy_browsing_up out-interface=ether1-UNG passthrough=no
add action=mark-packet chain=forward connection-mark=browsing in-interface=\
    ether1-UNG new-packet-mark=small_browsing_down passthrough=no
add action=mark-packet chain=forward connection-mark=browsing \
    new-packet-mark=small_browsing_up out-interface=ether1-UNG passthrough=no
/ip firewall nat
add action=dst-nat chain=dstnat comment="LOKAL - FORWARDING" dst-address=\
    172.16.178.5 dst-port=1433 protocol=tcp to-addresses=192.168.90.205 \
    to-ports=1433
add action=dst-nat chain=dstnat dst-address=172.16.178.5 dst-port=1521 \
    protocol=tcp to-addresses=192.168.90.201 to-ports=1521
add action=dst-nat chain=dstnat dst-address=172.16.178.5 to-addresses=\
    192.168.90.203
add action=dst-nat chain=dstnat comment="PUTTY TapBox" dst-address=\
    36.89.215.28 dst-port=22-23 protocol=tcp to-addresses=192.168.90.250 \
    to-ports=22-23
add action=dst-nat chain=dstnat comment="WEB - TAPPING BOX" dst-address=\
    36.89.215.28 dst-port=80 protocol=tcp to-addresses=192.168.90.250 \
    to-ports=80
add action=dst-nat chain=dstnat comment="WEB - UNMS" disabled=yes \
    dst-address=36.89.215.28 dst-port=443 protocol=tcp to-addresses=\
    192.168.90.6 to-ports=443
add action=dst-nat chain=dstnat comment="WEB FREE" disabled=yes dst-address=\
    36.89.215.29 protocol=tcp to-addresses=192.168.40.13 to-ports=8085
add action=dst-nat chain=dstnat comment="SERVER - BACKUP" disabled=yes \
    dst-address=36.89.215.29 protocol=tcp to-addresses=192.168.90.209
add action=dst-nat chain=dstnat comment=UNIFI dst-address=36.89.215.28 \
    dst-port=3478 protocol=udp to-addresses=192.168.90.200 to-ports=3478
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=10001 \
    protocol=udp to-addresses=192.168.90.200 to-ports=10001
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=8080 \
    protocol=tcp to-addresses=192.168.90.200 to-ports=8080
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=8081 \
    protocol=tcp to-addresses=192.168.90.200 to-ports=8081
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=8443 \
    protocol=tcp to-addresses=192.168.90.200 to-ports=8443
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=8843 \
    protocol=tcp to-addresses=192.168.90.200 to-ports=8843
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=8880 \
    protocol=tcp to-addresses=192.168.90.200 to-ports=8880
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=6789 \
    protocol=tcp to-addresses=192.168.90.200 to-ports=6789
add action=dst-nat chain=dstnat comment="WEB - YANJAK 80" dst-address=\
    36.89.215.26 dst-port=80 protocol=tcp to-addresses=192.168.90.203 \
    to-ports=80
add action=dst-nat chain=dstnat comment="WEB - YANJAK 8010" dst-address=\
    36.89.215.26 dst-port=8010 protocol=tcp to-addresses=192.168.90.203 \
    to-ports=8010
add action=dst-nat chain=dstnat comment="WEB - YANJAK 443" dst-address=\
    36.89.215.26 dst-port=443 protocol=tcp to-addresses=192.168.90.203 \
    to-ports=443
add action=dst-nat chain=dstnat comment="WEB - RETRIBUSI" dst-address=\
    36.89.215.30 dst-port=80 protocol=tcp to-addresses=192.168.90.204 \
    to-ports=80
add action=dst-nat chain=dstnat dst-address=36.89.215.30 dst-port=443 \
    protocol=tcp to-addresses=192.168.90.204 to-ports=443
add action=dst-nat chain=dstnat comment="WEB - ASET" dst-address=36.89.215.27 \
    dst-port=80 protocol=tcp to-addresses=192.168.90.207 to-ports=80
add action=dst-nat chain=dstnat dst-address=36.89.215.27 dst-port=443 \
    protocol=tcp to-addresses=192.168.90.207 to-ports=443
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - MAIN SERVER 1" \
    dst-address=36.89.215.26 dst-port=3389 protocol=tcp to-addresses=\
    192.168.90.200 to-ports=3389
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - MAIN SERVER 2" \
    dst-address=36.89.215.27 dst-port=3389 protocol=tcp to-addresses=\
    192.168.90.206 to-ports=3389
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - TAPPING BOX" \
    dst-address=36.89.215.28 dst-port=3389 protocol=tcp to-addresses=\
    192.168.90.250 to-ports=3389
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - ORACLE" \
    dst-address=36.89.215.26 dst-port=3391 protocol=tcp to-addresses=\
    192.168.90.201 to-ports=3389
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - WEB" dst-address=\
    36.89.215.26 dst-port=3393 protocol=tcp to-addresses=192.168.90.203 \
    to-ports=3389
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - RETRIBUSI" \
    dst-address=36.89.215.26 dst-port=3394 protocol=tcp to-addresses=\
    192.168.90.204 to-ports=3389
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - SIMDA" dst-address=\
    36.89.215.26 dst-port=3395 protocol=tcp to-addresses=192.168.90.205 \
    to-ports=3389
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - ASET" dst-address=\
    36.89.215.27 dst-port=3391 protocol=tcp to-addresses=192.168.90.207 \
    to-ports=3389
add action=dst-nat chain=dstnat comment="REMOTE DESKTOP - SERVER BACKUP" \
    disabled=yes dst-address=36.89.215.29 dst-port=3389 protocol=tcp \
    to-addresses=192.168.90.209 to-ports=3389
add action=dst-nat chain=dstnat comment=ORACLE dst-address=36.89.215.26 \
    dst-port=1521 protocol=tcp to-addresses=192.168.90.201 to-ports=1521
add action=dst-nat chain=dstnat comment="WEB SERVICE" dst-address=\
    36.89.215.26 dst-port=8078 protocol=tcp to-addresses=192.168.90.203 \
    to-ports=8078
add action=dst-nat chain=dstnat dst-address=36.89.215.26 dst-port=8007 \
    protocol=tcp to-addresses=192.168.90.203 to-ports=8007
add action=dst-nat chain=dstnat dst-address=36.89.215.26 dst-port=8084 \
    protocol=tcp to-addresses=192.168.90.203 to-ports=8084
add action=dst-nat chain=dstnat comment="SQL SERVER" dst-address=36.89.215.26 \
    dst-port=1433 protocol=tcp to-addresses=192.168.90.205 to-ports=1433
add action=dst-nat chain=dstnat comment="FTP FILE SERVER" dst-address=\
    36.89.215.28 dst-port=20-21 protocol=tcp to-addresses=192.168.90.250 \
    to-ports=20-21
add action=dst-nat chain=dstnat comment="FTP SERVER BACKUP" disabled=yes \
    dst-address=36.89.215.29 dst-port=20-21 protocol=tcp to-addresses=\
    192.168.90.209 to-ports=20-21
add action=dst-nat chain=dstnat comment="TAPBOX FTP" dst-address=36.89.215.28 \
    dst-port=3306 protocol=tcp to-addresses=192.168.90.250 to-ports=3306
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=33060 \
    protocol=tcp to-addresses=192.168.90.250 to-ports=33060
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=33062 \
    protocol=tcp to-addresses=192.168.90.250 to-ports=33062
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=33061 \
    protocol=tcp to-addresses=192.168.90.250 to-ports=33061
add action=dst-nat chain=dstnat comment="SMB FILE SERVER" dst-address=\
    36.89.215.28 dst-port=135-139 protocol=tcp to-addresses=192.168.90.250 \
    to-ports=135-139
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=445 \
    protocol=tcp to-addresses=192.168.90.250 to-ports=445
add action=dst-nat chain=dstnat dst-address=36.89.215.28 dst-port=3389 \
    protocol=tcp to-addresses=192.168.90.250 to-ports=3389
add action=dst-nat chain=dstnat comment="SMB SERVER BACKUP" disabled=yes \
    dst-address=36.89.215.29 dst-port=135-139 protocol=tcp to-addresses=\
    192.168.90.209 to-ports=135-139
add action=dst-nat chain=dstnat disabled=yes dst-address=36.89.215.29 \
    dst-port=445 protocol=tcp to-addresses=192.168.90.209 to-ports=445
add action=dst-nat chain=dstnat comment="Open Media Vault" disabled=yes \
    dst-address=36.89.215.28 dst-port=90 protocol=tcp to-addresses=\
    192.168.90.6 to-ports=90
add action=dst-nat chain=dstnat comment="Putty - Open Media Vault" disabled=\
    yes dst-address=36.89.215.27 dst-port=22-23 protocol=tcp to-addresses=\
    192.168.90.6 to-ports=22-23
add action=dst-nat chain=dstnat disabled=yes dst-address=36.89.215.27 \
    dst-port=135-139 protocol=tcp to-addresses=192.168.90.6 to-ports=135-139
add action=dst-nat chain=dstnat disabled=yes dst-address=36.89.215.27 \
    dst-port=445 protocol=tcp to-addresses=192.168.90.6 to-ports=445
add action=dst-nat chain=dstnat disabled=yes dst-address=36.89.215.28 \
    dst-port=4200 protocol=tcp to-addresses=192.168.90.6 to-ports=4200
add action=dst-nat chain=dstnat comment="DNS Premium United States" dst-port=\
    53 protocol=udp to-addresses=208.67.220.220 to-ports=443
add action=dst-nat chain=dstnat dst-port=53 protocol=udp to-addresses=\
    208.67.222.222 to-ports=443
add action=dst-nat chain=dstnat comment="DNS Premium Singapore" dst-port=53 \
    protocol=udp random=50 to-addresses=103.31.225.117 to-ports=443
add action=dst-nat chain=dstnat dst-port=53 protocol=udp random=50 \
    to-addresses=103.11.143.205 to-ports=443
add action=masquerade chain=srcnat comment=NAT
/ip firewall raw
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting comment="Mobile Legends" dst-address-list=\
    !private-lokal dst-port=30000-30110,5001,5003,9001 protocol=tcp \
    src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting content=.youngjoygame.com dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting dst-address-list=!private-lokal dst-port=\
    5000-5570 protocol=udp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting comment=Vainglory dst-address-list=\
    !private-lokal dst-port=7000-8020 protocol=tcp src-address-list=\
    private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting content=.superevil.net dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting comment="Arena Of Valor" dst-address-list=\
    !private-lokal dst-port=10001-10094 protocol=tcp src-address-list=\
    private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting dst-address-list=!private-lokal dst-port=\
    10080,17000 protocol=udp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting comment="PUBG Mobile" dst-address-list=\
    !private-lokal dst-port=10012,17500 protocol=tcp src-address-list=\
    private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting dst-address-list=!private-lokal dst-port="10\
    010,10013,10039,10096,10491,10612,11455,12235,13748,13894,13972,20000-2000\
    2" protocol=udp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting dst-address-list=!private-lokal dst-port="90\
    30,10001-10015,10491,10612,12235,13748,13972,13894,11455,17000,20000-20003\
    " protocol=udp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting dst-address-list=!private-lokal dst-port=\
    7080-8000,10001-10015,17500 protocol=tcp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting content=.igamecj.com dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting content=tencentgames.helpshift.com \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting comment=ROS dst-address-list=!private-lokal \
    dst-port=9080-9081 protocol=tcp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting dst-address-list=!private-lokal dst-port=\
    24000-24300,5500-5520 protocol=udp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting comment=FREEFIRE dst-address-list=\
    !private-lokal dst-port=10000-10100,39698,39779 protocol=tcp \
    src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting dst-address-list=!private-lokal dst-port=\
    16500-17500 protocol=udp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting dst-address-list=!private-lokal dst-port=\
    39000-39700 protocol=udp src-address-list=private-lokal
add action=add-dst-to-address-list address-list=games address-list-timeout=\
    none-dynamic chain=prerouting comment=PB-GARENA-ZEPETTO dst-address-list=\
    !private-lokal dst-port=39190-39200,49001-49190 protocol=tcp \
    src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting comment=INSTAGRAM content=.cdninstagram.com \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting content=.instagram.com dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting comment=WHATSAPP content=.whatsapp.net \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting content=.whatsapp.com dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting comment=LIFE360 content=.life360.com \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting comment=FACEBOOK content=.facebook.com \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting content=.facebook.net dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting content=.fbcdn.net dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting comment=TWITTER content=.twitter.com \
    dst-address-list=!private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting content=.twimg.com dst-address-list=\
    !private-lokal src-address-list=private-lokal
add action=add-dst-to-address-list address-list=sosmed address-list-timeout=\
    none-dynamic chain=prerouting comment=TIKTOK content=.tiktokv.com \
    dst-address-list=!private-lokal src-address-list=private-lokal
/ip proxy
set cache-administrator=mudher.d@gmail.com cache-on-disk=yes \
    max-cache-object-size=9999KiB
/ip proxy access
add action=deny dst-host=*porn* redirect-to=\
    "www.youtube.com/watch\?v=jsJNAOmCbSg"
add action=deny dst-host=*xvideos* redirect-to=\
    "www.youtube.com/watch\?v=jsJNAOmCbSg"
add action=deny dst-host=*bokep* redirect-to=\
    "www.youtube.com/watch\?v=jsJNAOmCbSg"
add action=deny dst-host=*jav* redirect-to=\
    "www.youtube.com/watch\?v=jsJNAOmCbSg"
/ip route
add check-gateway=ping distance=1 gateway=36.89.215.25 routing-mark=SERVER
add distance=1 gateway=172.21.6.5 routing-mark=CAPIL
add distance=1 gateway=10.100.203.1
add distance=1 dst-address=192.168.169.0/24 gateway=192.168.60.1
/ip route rule
add action=lookup-only-in-table dst-address=10.5.50.0/23 table=main
add action=lookup-only-in-table dst-address=192.168.20.0/24 table=main
add action=lookup-only-in-table dst-address=192.168.30.0/24 table=main
add action=lookup-only-in-table dst-address=192.168.40.0/24 table=main
add action=lookup-only-in-table dst-address=192.168.50.0/24 table=main
add action=lookup-only-in-table dst-address=192.168.60.0/24 table=main
add action=lookup-only-in-table dst-address=192.168.70.0/24 table=main
add action=lookup-only-in-table dst-address=192.168.90.0/24 table=main
add action=lookup-only-in-table dst-address=192.168.120.0/24 table=main
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh disabled=yes
/ip ssh
set allow-none-crypto=yes forwarding-enabled=remote
/lcd
set default-screen=stats time-interval=hour
/ppp secret
add local-address=172.16.178.1 name=qloex password=qloex remote-address=\
    172.16.178.2 service=l2tp
add local-address=172.16.178.1 name=mud password=mud remote-address=\
    172.16.178.3 service=l2tp
add local-address=172.16.178.1 name=fajar password=fajar remote-address=\
    172.16.178.4 service=l2tp
/system clock
set time-zone-autodetect=no time-zone-name=Asia/Makassar
/system identity
set name=PENDAPATAN
/system ntp client
set enabled=yes primary-ntp=202.162.32.12 secondary-ntp=118.189.138.5
/tool user-manager database
set db-path=user-manager
/tool user-manager profile profile-limitation
add from-time=0s limitation=shareduser30 profile=shareduser30 till-time=\
    23h59m59s weekdays=\
    sunday,monday,tuesday,wednesday,thursday,friday,saturday
/tool user-manager router
add coa-port=1700 customer=admin disabled=no ip-address=127.0.0.1 log=\
    auth-fail name=PendapatanMikroTik shared-secret=123456 use-coa=no
/tool user-manager user
add customer=admin disabled=no ipv6-dns=:: password=pendapatan shared-users=1 \
    username=pendapatan wireless-enc-algo=none wireless-enc-key="" \
    wireless-psk=""
