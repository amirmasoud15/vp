#!/bin/bash
# start.sh

# اجرای وب سرور در پس‌زمینه
python3 -m http.server 8080 &

# اجرای sshx به صورت دائم (بدون --once)
sshx serve
