#!/usr/bin/env bash
# =============设置一下参数=========
export VPORT=${VPORT:-'8002'}
#下面为固定隧道参数，去掉前面#，不设置则使用临时隧道
#export TOK=${TOK:-'xxxx'} 

# ===============分割线===============
run_arg() {
chmod 777 ./cff.js
if [[ -n "${TOK}" ]]; then
  nohup ./cff.js tunnel --edge-ip-version auto --protocol http2 run --token ${TOK} >/dev/null 2>&1 &

else
[ -s ./argo.log  ] && rm -rf ./argo.log
nohup ./cff.js tunnel --edge-ip-version auto --no-autoupdate --protocol http2 --logfile ./argo.log --loglevel info --url http://localhost:${VPORT} 2>/dev/null 2>&1 &

fi
}

run_arg
export server_ip=$(curl -s https://ipinfo.io/ip)
export ACCESS_TOKEN=${ACCESS_TOKEN:-'08dd8ccc089e20;47292b48b784cb'}  # 到ipinfo.io注册,多个token用;隔开


IFS=';' read -ra tokens <<< "$ACCESS_TOKEN"

export country_abbreviation=""

# Try free API without access token
country_abbreviation=$(curl -s "https://ipinfo.io/${server_ip}/country")

# If the free API doesn't provide a result, try with access tokens
if [[ -z "$country_abbreviation" || ! "$country_abbreviation" =~ ^[A-Z]{2}$ ]]; then
  for token in "${tokens[@]}"; do
    country_abbreviation=$(curl -s "https://ipinfo.io/${server_ip}/country?token=${token}")

    # Check if the obtained abbreviation is valid (two uppercase letters)
    if [[ -n "$country_abbreviation" && "$country_abbreviation" =~ ^[A-Z]{2}$ ]]; then
      echo "Successfully obtained valid country abbreviation using token: $country_abbreviation"
      break  # Exit the loop if a valid abbreviation is obtained
    else
      echo "Token $token did not provide a valid country abbreviation."
    fi
  done
fi

# If still not valid or doesn't exist, default to "UN"
if [ -z "$country_abbreviation" ] || [[ ! "$country_abbreviation" =~ ^[A-Z]{2}$ ]]; then
  country_abbreviation="UN"
fi
echo "country_abbreviation: $country_abbreviation" > ./guojia.yaml
