# GFW List
curl -sS https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt | \
    base64 -d | sort -u | sed '/^$\|@@/d'| sed 's#!.\+##; s#|##g; s#@##g; s#http:\/\/##; s#https:\/\/##;' | \
    sed '/apple\.com/d; /sina\.cn/d; /sina\.com\.cn/d; /baidu\.com/d; /qq\.com/d' | \
    sed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/d' | grep '^[0-9a-zA-Z\.-]\+$' | \
    grep '\.' | sed 's#^\.\+##' | sort -u > /tmp/temp_gfwlist1

curl -sS https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf | \
    sed 's/ipset=\/\.//g; s/\/gfwlist//g; /^server/d' > /tmp/temp_gfwlist2

curl -sS https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt > /tmp/temp_gfwlist3

cat /tmp/temp_gfwlist1 /tmp/temp_gfwlist2 /tmp/temp_gfwlist3 default/extra.conf | \
    sort -u | sed 's/^\.*//g' > /tmp/temp_gfwlist

# Update GFW List

cat /tmp/temp_gfwlist | sed 's/^/\./g' > /tmp/proxy-list.conf

#sed -i 's/^/nameserver \//' /tmp/proxy-list.conf
#sed -i 's/$/\/GFW/' /tmp/proxy-list.conf
cat script/gfw_group.conf /tmp/proxy-list.conf> proxy-list.conf

# Update China IPV4 List
qqwry="$(curl -kLfsm 5 https://raw.githubusercontent.com/metowolf/iplist/master/data/special/china.txt)"
ipipnet="$(curl -kLfsm 5 https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt)"
clang="$(curl -kLfsm 5 https://ispip.clang.cn/all_cn.txt)"
iplist="$qqwry\n$ipipnet\n$clang"
echo -e "${iplist}" | sort | uniq |sed -e 's/^/whitelist-ip /g' >whitelist-ip.conf
echo -e "${iplist}" | sort | uniq |sed -e 's/^/blacklist-ip /g' >blacklist-ip.conf

# Update China List
accelerated-domains="$(curl -kLfsm 5 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf)"
apple_china="$(curl -kLfsm 5 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf)"
google_china="$(curl -kLfsm 5 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf)"
cdn_testlist="$(curl -kLfsm 5 https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/cdn-testlist.txt)"
domain_list="$accelerated-domains\n$apple_china\n$google_chinan\ncdn_testlist$"
echo -e "${domain_list}" | sort | uniq |sed -e 's/^/\./g' >direct-list.conf