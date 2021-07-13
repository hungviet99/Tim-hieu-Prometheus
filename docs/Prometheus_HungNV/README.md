# Cấu hình và cài đặt prometheus

## 1. Mô hình 

### Mô hình triển khai 

![deploy](./images/trienkhai.png)

### IP planning 

![ipplanning](./images/ipplanning.png)

## 2. Mục lục 

### 2.1. Cài đặt và cấu hình

1. [Prometheus Overview](./docs/1._Overview.md)
2. [Cài đặt Prometheus vs Grafana trên CentOS 7](./docs/2._Install_Prometheus_vs_Grafana.md)
3. [Cài đặt Node Exporter trên CentOS](./docs/3._Install_Node_Exporter_on_CentOS.md)
4. [Cài đặt Node Exporter trên Windows](./docs/4._Install_Node_Exporter_on_Windows.md)
5. [Cài đặt Node Exporter trên Ubuntu](./docs/5._Install_Node_Exporter_on_Ubuntu.md)
6. [Cài đặt Libvirt Exporter monitor Libvirt KVM](./docs/12._Install_libvirt_exporter_monitor_kvm.md)
7. [Cài đặt SNMP Exporter monitor iDRAC](./docs/6._Install_SNMP_monitor_iDRAC.md)
8. [Cài đặt SNMP Exporter monitor Switch](./docs/11._Install_SNMP_monitor_switch.md)
9. [Khái niệm và cài đặt Pushgateway](./docs/14._Pushgateway_in_prometheus.md)
10. [Cấu hình Alerting](./docs/15._Alert_manager.md)
11. [Cấu hình Basic authen cho prometheus](./docs/18._Cau_hinh_basic_authen_cho_prometheus.md)

### 2.2. Grafana Dashboard

1. [Import Json để tạo dashboard cho Node Exporter](./docs/7._Import_dashboard_for_node_exporter_from_json_file.md)
2. [Import Json để tạo dashboard cho SNMP Exporter](./docs/10._Import_dashboard_for_snmp_exporter_from_json_file.md)
3. [Import Json để tạo dashboard cho Libvirt Exporter](./docs/13._Import_dashboard_for_libvirt_exporter_from_json_file.md)

### 2.3. Note Extend

1. [File Json template cho Dashboard Grafana](./Exporter_Dashboard_Json)
2. [File module cho SNMP Exporter](./SNMP_Exporter)
3. [Một số rule cảnh báo cho hệ thống](./docs/16._Mot_so_rule_canh_bao_cho_he_thong.md)
4. [Lưu trữ và sizing cho prometheus](./docs/17._Storage_Prometheus.md)