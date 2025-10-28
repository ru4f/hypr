#!/bin/bash

ICON_DIR="$HOME/.config/eww/icons/hardware"

# ================= CPU ====================
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE=${CPU_USAGE%.*}

if [ "$CPU_USAGE" -lt 40 ]; then
    CPU_ICON="$ICON_DIR/cpu.png"
elif [ "$CPU_USAGE" -lt 75 ]; then
    CPU_ICON="$ICON_DIR/cpu.png"
else
    CPU_ICON="$ICON_DIR/cpu.png"
fi

# ================= RAM ====================
# Lấy RAM sử dụng theo MB
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_PERC=$((100 * RAM_USED / RAM_TOTAL))

RAM_TXT="${RAM_PERC}% (${RAM_USED}MB/${RAM_TOTAL}MB)"
RAM_ICON="$ICON_DIR/ram.png"

# ================= DISK ===================
DISK_USED=$(df / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df / | awk 'NR==2 {print $2}')
DISK_PERC=$((100 * DISK_USED / DISK_TOTAL))

# Chuyển về GB
DISK_USED_GB=$(echo "scale=1; $DISK_USED/1024/1024" | bc)
DISK_TOTAL_GB=$(echo "scale=1; $DISK_TOTAL/1024/1024" | bc)

DISK_TXT="${DISK_PERC}% (${DISK_USED_GB}GB/${DISK_TOTAL_GB}GB)"
DISK_ICON="$ICON_DIR/ssd-disk.png"

# ================= OUTPUT =================
# Dòng 1: icon | Dòng 2: text
echo "${CPU_ICON}|${RAM_ICON}|${DISK_ICON}"
echo "${CPU_USAGE}% | ${RAM_TXT} | ${DISK_TXT}"
