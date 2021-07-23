#!/bin/bash

set -e; OS=""

f_check_os(){
    if cat /etc/*release | grep CentOS > /dev/null 2>&1; then {
        if [ $(rpm --eval '%{centos_ver}') == 7 ]; then {
            OS="CentOS7";
            echo $OS
        } else {
            OS="CentOS8";
            echo $OS
        } fi
    } elif cat /etc/*release | grep Ubuntu > /dev/null 2>&1; then {
        OS="ubuntu"
        echo $OS
    } fi
}

f_setup_node_exporter(){
    if [ $(id -u) -eq 0 ]; then
        f_check_os
        if [ $OS == "CentOS7" ]; then
            echo "############## ENABLE PORT 9100 AND DISABLE SELINUX ##############"
            sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
            sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
            setenforce 0 || echo "selinux is disable"
            firewall-cmd --zone=public --add-port=9100/tcp --permanent  || echo "firewall of"
            firewall-cmd --reload   || echo "firewall of"
            yum install -y wget
        elif [ $OS == "ubuntu" ]; then
            echo "############## ENABLE PORT 9100 ##############"
            apt install -y wget
            ufw allow 9100/tcp  || echo "firewall of"
            ufw reload  || echo "firewall of"
        elif [ $OS == "CentOS8" ]; then
            echo "############## ENABLE PORT 9100 AND DISABLE SELINUX ##############"
            sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
            sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
            setenforce 0 || echo "selinux is disable"
            firewall-cmd --zone=public --add-port=9100/tcp --permanent || echo "firewall of"
            firewall-cmd --reload || echo "firewall of"
            dnf install -y wget
        fi
        echo "############## DOWNLOAD SOURCE CODE NODE EXPORTER ##############"
        useradd --no-create-home --shell /bin/false node_exporter
        cd /opt
        wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
        tar xvf node_exporter-0.18.1.linux-amd64.tar.gz
        cp /opt/node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin
        chown node_exporter:node_exporter /usr/local/bin/node_exporter
        rm -rf node_exporter-0.18.1.linux-amd64*

echo "############## CREATE SERVICE NODE EXPORTER ##############"
cat <<EOF >  /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

        systemctl daemon-reload
        systemctl start node_exporter
        systemctl enable node_exporter
    else
        echo "Can dang nhap bang tai khoan root de thuc hien!!!"
    fi
}

f_setup_libvirt_exporter(){
    if [ $(id -u) -eq 0 ]; then
        f_check_os
        if [ $OS == "CentOS7" ]; then
            echo "tat firewall"
            firewall-cmd --zone=public --add-port=9177/tcp --permanent  || echo "firewall of"
            firewall-cmd --reload   || echo "firewall of"
            cd /opt
            echo "########### Download golang ###########"
            wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
            tar -zxvf go1.15.5.linux-amd64.tar.gz -C /usr/local/
            export PATH=$PATH:/usr/local/go/bin
            mkdir $HOME/work
            export GOPATH=$HOME/work
            echo "########### Cai dat cac goi can thiet ###########"
            yum install ca-certificates gcc-c++ git go libnl-devel kernel-devel make -y
            yum install -y virt-viewer libguestfs-tools python-devel python3-devel
            yum install -y libvirt virt-install bridge-utils virt-manager
            yum install -y libvirt-devel
            echo "########### download libxml ###########"
            wget ftp://xmlsoft.org/libxml2/libxml2-2.9.8.tar.gz -P /tmp
            tar -xf /tmp/libxml2-2.9.8.tar.gz -C /tmp/
            cd /tmp/libxml2-2.9.8
            ./configure
            make -j$(nproc)
            make install
            mkdir -p /libvirt-exporter
            cd /libvirt-exporter
            echo "########### Download source code linvirt exporter ###########"
            wget https://github.com/hungviet99/libvirt-exporter/archive/refs/tags/2.1.1.tar.gz
            tar xvf 2.1.1.tar.gz
            mv /libvirt-exporter/libvirt-exporter-2.1.1/* /libvirt-exporter/
            cd /libvirt-exporter/
            echo "build code"
            go build -mod vendor
echo "########### Tao service linvirt exporter ###########"
cat <<EOF >  /etc/systemd/system/libvirt_exporter.service
[Unit]
Description=Libvirt Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/libvirt-exporter/libvirt-exporter

[Install]
WantedBy=multi-user.target
EOF
            systemctl daemon-reload
            systemctl restart libvirt_exporter
            systemctl status libvirt_exporter
        elif [ $OS == "CentOS8" ]; then
            echo "tat firewall"
            firewall-cmd --zone=public --add-port=9177/tcp --permanent  || echo "firewall of"
            firewall-cmd --reload   || echo "firewall of"
            cd /opt
            echo "########### Download golang ###########"
            wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
            tar -zxvf go1.15.5.linux-amd64.tar.gz -C /usr/local/
            export PATH=$PATH:/usr/local/go/bin
            mkdir $HOME/work
            export GOPATH=$HOME/work
            echo "########### Cai dat cac goi can thiet ###########"
            yum install ca-certificates gcc-c++ git go libnl3-devel kernel-devel make -y
            yum install -y virt-viewer libguestfs-tools python3-devel
            yum install -y libvirt virt-install bridge-utils virt-manager
            yum install -y libvirt-devel
            echo "########### download libxml ###########"
            wget ftp://xmlsoft.org/libxml2/libxml2-2.9.8.tar.gz -P /tmp
            tar -xf /tmp/libxml2-2.9.8.tar.gz -C /tmp/
            cd /tmp/libxml2-2.9.8
            ./configure
            make -j$(nproc)
            make install
            mkdir -p /libvirt-exporter
            cd /libvirt-exporter
            echo "########### Download source code linvirt exporter ###########"
            wget https://github.com/hungviet99/libvirt-exporter/archive/refs/tags/2.1.1.tar.gz
            tar xvf 2.1.1.tar.gz
            mv /libvirt-exporter/libvirt-exporter-2.1.1/* /libvirt-exporter/
            cd /libvirt-exporter/
            echo "build code"
            go build -mod vendor
echo "########### Tao service linvirt exporter ###########"
cat <<EOF >  /etc/systemd/system/libvirt_exporter.service
[Unit]
Description=Libvirt Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/libvirt-exporter/libvirt-exporter

[Install]
WantedBy=multi-user.target
EOF
            systemctl daemon-reload
            systemctl restart libvirt_exporter
            systemctl status libvirt_exporter
        fi
    else
        echo "Can dang nhap bang tai khoan root de thuc hien!!!"
    fi
}

f_check_libvirt_exporter_service(){
    systemctl | grep libvirt-exporter || systemctl | grep libvirt_exporter
    if [ $? -eq 0 ]; then
        echo "Libvirt exporter da ton tai"
    else
        if virsh version > /dev/null 2>&1;
        then
            f_setup_libvirt_exporter
            echo "###### CAI DAT XONG LIBVIRT EXPORTER ######"
        else
            echo 'Khong co libvirt !! Khong cai Libvirt exporter'
        fi
    fi
}

f_check_node_exporter_service(){
    systemctl | grep node-exporter || systemctl | grep node_exporter
    if [ $? -eq 0 ]; then
        echo "Node exporter da ton tai"
    else
        f_setup_node_exporter
        echo "###### CAI DAT XONG LIBVIRT EXPORTER ######"
    fi
}

f_main(){
    f_check_libvirt_exporter_service
    f_check_node_exporter_service
    echo "       ################################"
    echo "       ###### CAI DAT THANH CONG ######"
    echo "       ################################"
}
f_main
exit