interface=eth0
dumpdir=/root/dumps

while /bin/true; do
  pkt_old=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
  sleep 1
  pkt_new=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`

  pkt=$(( $pkt_new - $pkt_old ))
  echo -ne "\r$pkt packets/s\033[0K"

  if [ $pkt -gt 30000 ]; then
    echo -e "\n`date` Under Attack. Capturing..."
    pktname="dump_`date +%d-%m-%y_%H:%M:%S`.pcap"
    tcpdump -i $interface -t -w $dumpdir/dump_`date +%d-%m-%y_%H:%M:%S`.pcap -c 30000
    echo "`date` Packets Captured. Sleeping..."
    ./discord.sh \
--webhook-url="put ur webhook here" \
--username "REFLEX Server Monitor" \
--title "Attack Monitor" \
--description "A DDoS attack on server **PATH NY** has managed to bypass PATH's vac and the attack has been logged and will be investigated soon.\n\n**Capture Name:** $pktname\n**Capture Location:** $dumpdir\n**Attack PPS:** $pkt\n\n**Server IP:** ||YOUR SERVER IP HERE||" \
--color "0x700D06" \
--url "https://discord.gg/kT2QDkpQV7" \
--thumbnail "https://unhittablehosting.xyz/images/us.png" \
--author "Server Monitor" \
--author-url "https://unhittablehosting.xyz" \
--author-icon "https://unhittablehosting.xyz/images/RF.ico" \
--footer "Server Attack Monitor" \
--footer-icon "https://img.pngio.com/warning-icon-png-321332-free-icons-library-warning-icon-png-2400_2400.jpg" \
--text "Look below for the attack details." \
--timestamp

sleep 300
fi
done