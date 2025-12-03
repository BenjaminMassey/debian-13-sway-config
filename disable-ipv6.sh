nmcli -t -f NAME connection show | while read -r conn; do
  sudo nmcli connection modify "$conn" ipv6.method disabled
done
systemctl restart NetworkManager
