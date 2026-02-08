output "deployment_info" {
  value = <<EOF
=== Инфраструктура готова! ===

ClickHouse:  ${yandex_compute_instance.vm-clickhouse.network_interface[0].nat_ip_address}
Vector:      ${yandex_compute_instance.vm-vector.network_interface[0].nat_ip_address}
LightHouse:  ${yandex_compute_instance.vm-lighthouse.network_interface[0].nat_ip_address}

Ansible плейбук:
  ansible-playbook -i inventory/prod.yml site.yml

Или:
  ansible-playbook -i inventory/prod.yml site.yml --tags "prepare"
  ansible-playbook -i inventory/prod.yml site.yml --tags "clickhouse"
  ansible-playbook -i inventory/prod.yml site.yml --tags "vector"
  ansible-playbook -i inventory/prod.yml site.yml --tags "lighthouse"

Инвентарь сохранен в: ${path.module}/../playbook/inventory/prod.yml
EOF
  
}