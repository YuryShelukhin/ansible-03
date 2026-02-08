locals {
  vm_common_settings = {
    zone        = "ru-central1-a"
    subnet_id   = yandex_vpc_subnet.services-subnet.id      
    platform_id = "standard-v3"
    
    cores  = 2
    memory = 4
    
    disk_size     = 20
    disk_type     = "network-hdd"
    disk_image_id = "fd8emvfmfoaordspe1jr" # Ubuntu 22.04 LTS

    network_nat                = true
    network_security_group_ids = [yandex_vpc_security_group.services-sg.id]  
    
    metadata = {
      ssh-keys = "ubuntu:${file("/home/yury/HW/ansible/ansible-03/secrets/yandex-cloud-key.pub")}"
    }
  }
}

resource "yandex_compute_instance" "vm-clickhouse" {
  name        = "vm-clickhouse"
  hostname    = "clickhouse"
  platform_id = local.vm_common_settings.platform_id
  zone        = local.vm_common_settings.zone

  allow_stopping_for_update = true

  resources {
    cores  = local.vm_common_settings.cores
    memory = local.vm_common_settings.memory
  }

  boot_disk {
    initialize_params {
      image_id = local.vm_common_settings.disk_image_id
      size     = local.vm_common_settings.disk_size
      type     = local.vm_common_settings.disk_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = local.vm_common_settings.subnet_id
    nat                = local.vm_common_settings.network_nat
    security_group_ids = local.vm_common_settings.network_security_group_ids
  }

  metadata = local.vm_common_settings.metadata


}

resource "yandex_compute_instance" "vm-vector" {
  name        = "vm-vector"
  hostname    = "vector"
  platform_id = local.vm_common_settings.platform_id
  zone        = local.vm_common_settings.zone

  allow_stopping_for_update = true

  resources {
    cores  = local.vm_common_settings.cores
    memory = local.vm_common_settings.memory
  }

  boot_disk {
    initialize_params {
      image_id = local.vm_common_settings.disk_image_id
      size     = local.vm_common_settings.disk_size
      type     = local.vm_common_settings.disk_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = local.vm_common_settings.subnet_id
    nat                = local.vm_common_settings.network_nat
    security_group_ids = local.vm_common_settings.network_security_group_ids
  }

  metadata = local.vm_common_settings.metadata
}

resource "yandex_compute_instance" "vm-lighthouse" {
  name        = "vm-lighthouse"
  hostname    = "lighthouse"
  platform_id = local.vm_common_settings.platform_id
  zone        = local.vm_common_settings.zone

  allow_stopping_for_update = true

  resources {
    cores  = local.vm_common_settings.cores
    memory = local.vm_common_settings.memory
  }

  boot_disk {
    initialize_params {
      image_id = local.vm_common_settings.disk_image_id
      size     = local.vm_common_settings.disk_size
      type     = local.vm_common_settings.disk_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = local.vm_common_settings.subnet_id
    nat                = local.vm_common_settings.network_nat
    security_group_ids = local.vm_common_settings.network_security_group_ids
  }

  metadata = local.vm_common_settings.metadata
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../playbook/inventory/prod.yml"
  content  = templatefile("${path.module}/templates/inventory_template.j2", {
    clickhouse_external_ip = yandex_compute_instance.vm-clickhouse.network_interface[0].nat_ip_address
    clickhouse_internal_ip = yandex_compute_instance.vm-clickhouse.network_interface[0].ip_address
    vector_external_ip = yandex_compute_instance.vm-vector.network_interface[0].nat_ip_address
    vector_internal_ip = yandex_compute_instance.vm-vector.network_interface[0].ip_address
    lighthouse_external_ip = yandex_compute_instance.vm-lighthouse.network_interface[0].nat_ip_address
    lighthouse_internal_ip = yandex_compute_instance.vm-lighthouse.network_interface[0].ip_address
  })
  
  depends_on = [
    yandex_compute_instance.vm-clickhouse,
    yandex_compute_instance.vm-vector,
    yandex_compute_instance.vm-lighthouse
  ]
}
