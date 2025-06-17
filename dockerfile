FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# نصب ابزارهای پایه و openssh-server و gotty
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    curl \
    git \
    vim \
    python3 \
    python3-pip \
    nodejs \
    npm \
    build-essential \
    software-properties-common \
    openssh-server \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ساخت دایرکتوری لازم برای sshd
RUN mkdir /var/run/sshd

# تنظیم پسورد root (لطفا تغییرش بده)
RUN echo 'root:rootpassword' | chpasswd

# اجازه لاگین روت با پسورد
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# تغییر تنظیمات PAM برای sshd
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# لینک‌های نمادین برای python و node
RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/nodejs /usr/bin/node

# دانلود و نصب gotty (نسخه پایدار)
RUN wget https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz && \
    tar xzf gotty_linux_amd64.tar.gz && \
    mv gotty /usr/local/bin/ && \
    rm gotty_linux_amd64.tar.gz

# دایرکتوری کاری
WORKDIR /root

# باز کردن پورت‌های SSH و gotty
EXPOSE 22 8080

# اجرای همزمان sshd و gotty (ترمینال وب روی پورت 8080)
CMD service ssh start && gotty --port 8080 /bin/bash
