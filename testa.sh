#!/bin/bash
domain=$(cat /etc/xray/domain)
ipsaya=$(wget -qO- ipinfo.io/ip)
mkdir -p /etc/psiphon
cd /etc/psiphon
wget https://github.com/Psiphon-Labs/psiphon-tunnel-core-binaries/raw/master/psiphond/psiphond
chmod +x psiphond
./psiphond --ipaddress ${ipsaya} --web 3000 --protocol SSH:3001 --protocol OSSH:3002 --protocol FRONTED-MEEK-OSSH:8443 generate
cp *.dat psiphon.txt
zip -r psiphon.zip psiphon.txt
cp psiphon.zip /home/vps/public_html

#!/bin/bash
cat >/usr/bin/psiphond << EOF
#!/bin/bash

cd /etc/psiphon
./psiphond run
EOF

chmod +x /usr/bin/psiphond
cat >/etc/systemd/system/psiphond.service << EOF
                                                                                   
[Unit]
Description=psiphond bot service
Documentation=FighterTunnel
After=syslog.target network-online.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/bin/psiphond

[Install]
WantedBy=multi-user.target

EOF
cd
systemctl daemon-reload
systemctl enable psiphond
systemctl restart psiphond
#systemctl status psiphond
rm -rf psiphon
clear
echo -e ""
echo -e ""
echo -e " \033[31m##########\033[33m##########\033[32m##########\033[34m##########\033[35m##########\033[36m##########\e[0m"
echo -e " \033[31m╭══════════════════════════════════════════════════════════╮\e[0m"
echo -e " \033[34m│$NC\033[33m                      Psiphon ACCOUNT                       $NC\033[34m│\e[0m"
echo -e " \033[33m╰══════════════════════════════════════════════════════════╯\e[0m"
echo -e " \033[34m╭══════════════════════════════════════════════════════════╮\e[0m"
echo -e ""
echo -e " \033[32mLink Psiphon\e[0m : http://${domain}:81/psiphon.zip"
echo -e ""
echo -e " \033[35m╰══════════════════════════════════════════════════════════╯\e[0m"
echo -e " \033[31m##########\033[33m##########\033[32m##########\033[34m##########\033[35m##########\033[36m##########\e[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
