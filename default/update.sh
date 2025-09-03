# GFW List
curl -sS https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt | \
    base64 -d | sort -u | sed '/^$\|@@/d'| sed 's#!.\+##; s#|##g; s#@##g; s#http:\/\/##; s#https:\/\/##;' | \
    sed '/apple\.com/d; /sina\.cn/d; /sina\.com\.cn/d; /baidu\.com/d; /qq\.com/d' | \
    sed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/d' | grep '^[0-9a-zA-Z\.-]\+$' | \
    grep '\.' | sed 's#^\.\+##' | sort -u > /tmp/temp_gfwlist1
curl -sS https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf | \
    sed 's/ipset=\/\.//g; s/\/gfwlist//g; /^server/d' > /tmp/temp_gfwlist2
curl -sS https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt > /tmp/temp_gfwlist3
cat /tmp/temp_gfwlist1 /tmp/temp_gfwlist2 /tmp/temp_gfwlist3  | \
    sort -u | sed 's/^\.*//g' > /tmp/temp_gfwlist | sed -e '/^$/d' > proxy-domain-list.conf

# Update China List
accelerated_domains="$(curl -kLfsm 5 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf)"
apple_china="$(curl -kLfsm 5 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/refs/heads/master/apple.china.conf)"
google_china="$(curl -kLfsm 5 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/refs/heads/master/google.china.conf)"
cust_cndomain="$(cat script/cust_cndomain.conf)"
domain_list="$accelerated_domains\n$apple_china\n$google_china"
echo -e "${domain_list}" | sort | uniq |sed -e 's/#.*//g' -e '/^$/d' -e 's/server=\///g' -e 's/\/114.114.114.114//g' | sort -u >direct-domain-list.conf
