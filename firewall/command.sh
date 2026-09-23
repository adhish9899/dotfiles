
# Whitelisting IPs
firewall-cmd --permanent --zone=trusted --add-source=15.235.220.7/32
firewall-cmd --permanent --zone=trusted --add-source=16.208.107.214/32

firewall-cmd --permanent --zone=public --add-port=2222/tcp # Adding port 2222. We will disable port 22

firewall-cmd --reload

## Adding port 2222 in sshd config to be able to ssh
cat > /etc/ssh/sshd_config.d/10-port.conf <<'EOF'
Port 22
Port 2222
PermitRootLogin no
# if SELinux is re-enabled: semanage port -a -t ssh_port_t -p tcp 2222
EOF

### Check if the changes are applied
sshd -t && systemctl reload sshd
sshd -T | grep -E '^(permitrootlogin|logingracetime|port) '

## Any rule not matching the public zone is dropped. Traffic from `whitelisted` IP is handled by trusted zone
firewall-cmd --permanent --zone=public --set-target=DROP

## 
sshd -t && systemctl reload sshd

## VERY IMPORTANT A timer so that you dont get locked out. 
systemd-run --on-active=15min --unit=fw-rollback /bin/sh -c 'firewall-cmd --permanent --zone=public --set-target=ACCEPT; firewall-cmd --permanent --zone=public --add-service=ssh; firewall-cmd --reload; logger -t fw-rollback restored'

### LIST TIMERS
systemctl list-timers fw-rollback.timer

## Firewall apply
firewall-cmd --permanent --zone=public --set-target=DROP

## 
firewall-cmd --permanent --zone=public --remove-service=ssh 

## Answer ping
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" icmp-type name="echo-request" accept'
firewall-cmd --zone=public --list-all
firewall-cmd --reload

## Remove the timer
systemctl stop fw-rollback.timer
systemctl list-timers --all | grep fw-rollback

