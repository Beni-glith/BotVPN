#!/bin/bash

# Urutan tampilan (INI yang bikin rapi)
server_order=(
  "SG-TEAM1"
)

# Alias => domain
declare -A servers=(
  ["SG-TEAM1"]="sgteam1.rajaserverpremium.web.id"
)

# Port + label
declare -A ports=(
  [22]="VPS LOGIN"
  [80]="NO TLS"
  [443]="TLS"
)

green="\e[32m"; red="\e[31m"; nc="\e[0m"

echo "🔍 Cek status server"
echo "-------------------------------------------"

for alias in "${server_order[@]}"; do
  host="${servers[$alias]}"
  echo -e "\n🌐 Server: $alias"

  for port in 22 80 443; do
    timeout 2 bash -c "</dev/tcp/$host/$port" &>/dev/null
    if [[ $? -eq 0 ]]; then
      echo -e "  Port $port (${ports[$port]}): ${green}OPEN${nc}"
    else
      echo -e "  Port $port (${ports[$port]}): ${red}CLOSED${nc}"
    fi
  done
done
