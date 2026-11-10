#!/bin/sh
# ==============================================================================
# Script Name: Khaled Direct System Restore Script for AJPanel
# Description: Automated atomic restoration without interactive blocking
# Author: Khaled
# ==============================================================================

clear
echo "================================================================"
echo "         KHALED DIRECT RESTORE BACKUP TOOL (AJPanel)           "
echo "================================================================"
echo ""

# 1. البحث عن ملف النسخة الاحتياطية في المسارات المتاحة
echo "[*] Searching for rootfs.tar.bz2 backup file..."

POSSIBLE_PATHS="/media/hdd/rootfs.tar.bz2 /media/usb/rootfs.tar.bz2 /media/sda1/rootfs.tar.bz2 /tmp/rootfs.tar.bz2"
BACKUP_PATH=""

for path in $POSSIBLE_PATHS; do
    if [ -f "$path" ]; then
        BACKUP_PATH="$path"
        break
    fi
done

# التحقق من وجود الملف
if [ -z "$BACKUP_PATH" ]; then
    echo ""
    echo "[ERROR] Backup file (rootfs.tar.bz2) not found!"
    echo "Please make sure your backup is placed in /media/hdd, /media/usb, or /media/sda1"
    echo ""
    exit 1
fi

echo "[SUCCESS] Found backup at: $BACKUP_PATH"
echo ""
echo "----------------------------------------------------------------"
echo "WARNING: System will stop Enigma2 and overwrite rootfs directly!"
echo "Starting restoration process automatically in 3 seconds..."
echo "----------------------------------------------------------------"

# عد تنازلي سريع لإعطاء فرصة للإلغاء عبر زر Exit من الريموت إن أمكن، أو الاستمرار
sleep 3

echo ""
echo "==> [1/3] Stopping Enigma2 interface to prevent file locks..."
killall -9 enigma2

echo "==> [2/3] Starting atomic restoration (bzip2 & tar extraction to /)..."
bzip2 -dc "$BACKUP_PATH" | tar -x -p -o -C /

echo ""
echo "==> [3/3] Restoration completed successfully!"
echo "==> Rebooting system now..."
reboot
