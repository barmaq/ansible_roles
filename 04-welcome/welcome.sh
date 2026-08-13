#!/bin/bash

# Цветовые коды
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}${CYAN}=========================================="
echo -e "         СИСТЕМНАЯ ИНФОРМАЦИЯ"
echo -e "==========================================${NC}"

echo -e "\n${BOLD}${YELLOW}[ ИМЯ СЕРВЕРА ]${NC}"
echo -e "${WHITE}$(hostname)${NC}"

echo -e "\n${BOLD}${YELLOW}[ ОПЕРАЦИОННАЯ СИСТЕМА ]${NC}"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo -e "${WHITE}${PRETTY_NAME}${NC}"
else
    echo -e "${WHITE}Debian $(cat /etc/debian_version 2>/dev/null)${NC}"
fi

echo -e "\n${BOLD}${YELLOW}[ АКТИВНЫЕ СЕТЕВЫЕ ИНТЕРФЕЙСЫ ]${NC}"
echo -e "${BOLD}-----------------------------------------------------------------------${NC}"
printf "${BOLD}%-20s %-16s %-20s %-10s${NC}\n" "ИНТЕРФЕЙС" "IP-АДРЕС" "MAC-АДРЕС" "СТАТУС"
echo -e "${BOLD}-----------------------------------------------------------------------${NC}"

for iface in /sys/class/net/*; do
    iface_name=$(basename "$iface")
    
    # Исключаем ненужные
    [[ "$iface_name" == "lo" ]] && continue
    [[ "$iface_name" == tun* ]] && continue
    [[ "$iface_name" == docker* ]] && continue
    [[ "$iface_name" == veth* ]] && continue
    [[ "$iface_name" == br-* ]] && continue
    
    # Состояние
    state=$(cat "$iface/operstate" 2>/dev/null || echo "unknown")
    
    # MAC (обрезаем до 17 символов)
    mac_addr=$(cat "$iface/address" 2>/dev/null | cut -c1-17 || echo "-")
    
    # IP (только первый адрес)
    ip_addr=$(ip -4 addr show "$iface_name" 2>/dev/null | grep -oP 'inet \K[\d.]+' | head -1)
    [ -z "$ip_addr" ] && ip_addr="-"
    
    # Определяем цвета
    if [[ "$state" == "up" ]] || [[ "$state" == "UP" ]]; then
        status_text="UP ✓"
        status_color="${GREEN}"
        iface_color="${GREEN}"
    else
        status_text="DOWN ✗"
        status_color="${RED}"
        iface_color="${RED}"
    fi
    
    # Формируем вывод с фиксированной шириной
    # Обрезаем длинные имена интерфейсов
    if [ ${#iface_name} -gt 19 ]; then
        iface_name="${iface_name:0:16}..."
    fi
    
    # Выводим построчно с правильным выравниванием
    echo -ne "${iface_color}${iface_name}${NC}"
    
    # Добиваем пробелами до 20 символов
    spaces=$((20 - ${#iface_name}))
    for ((i=0; i<$spaces; i++)); do echo -n " "; done
    
    # IP-адрес
    if [ "$ip_addr" != "-" ]; then
        echo -ne "${CYAN}${ip_addr}${NC}"
    else
        echo -ne "-"
    fi
    
    # Добиваем до 38 символов (20+16+2)
    ip_len=${#ip_addr}
    spaces=$((17 - $ip_len))
    for ((i=0; i<$spaces; i++)); do echo -n " "; done
    
    # MAC-адрес
    if [ "$mac_addr" != "-" ]; then
        echo -ne "${PURPLE}${mac_addr}${NC}"
    else
        echo -ne "-"
    fi
    
    # Добиваем до 60 символов (20+16+2+20+2)
    mac_len=${#mac_addr}
    spaces=$((22 - $mac_len))
    for ((i=0; i<$spaces; i++)); do echo -n " "; done
    
    # Статус
    echo -e "${status_color}${status_text}${NC}"
done

echo -e "${BOLD}-----------------------------------------------------------------------${NC}"
echo -e "${CYAN}        $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo -e "${BOLD}${CYAN}==========================================${NC}"
