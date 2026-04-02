#!/bin/sh
# سكريبت تنصيب خالد الاحترافي - حل مشكلة Magic Number
# المسارات
URL="https://github.com/KhaledAli65/books/raw/main/khaled_plugin.tar.gz"
DEST="/usr/lib/enigma2/python/Plugins/Extensions/Khaled_inline_Backup"

echo "📥 جاري تحميل البلجن من السيرفر..."
wget --no-check-certificate $URL -O /tmp/khaled_plugin.tar.gz

echo "📦 جاري فك الضغط والتثبيت..."
tar -xzf /tmp/khaled_plugin.tar.gz -C /

# --- الجزء الأهم: التشفير الموضعي لضمان التوافق ---
if [ -f "$DEST/plugin.py" ]; then
    echo "⚙️ جاري مطابقة التشفير مع إصدار بايثون الجهاز..."
    # تشفير الملف باستخدام بايثون الجهاز نفسه
    python -m py_compile "$DEST/plugin.py"
    
    # معالجة الناتج لصور بايثون 3 الحديثة
    if [ -d "$DEST/__pycache__" ]; then
        cp $DEST/__pycache__/plugin.cpython*.pyc $DEST/plugin.pyc
        rm -rf $DEST/__pycache__
    fi
    
    # التأكد من نجاح التشفير قبل حذف المصدر (لحماية الروابط)
    if [ -f "$DEST/plugin.pyc" ] || [ -f "$DEST/plugin.pyo" ]; then
        rm -f "$DEST/plugin.py"
        echo "✅ تم التشفير بنجاح وإخفاء الروابط الـ 35."
    fi
fi

# ضبط الصلاحيات
chmod -R 755 $DEST
echo "♻️ جاري إعادة تشغيل الواجهة (Enigma2 Restart)..."
killall -9 enigma2
