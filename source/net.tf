resource "yandex_vpc_network" "ansible-network" {
  name = "ansible-network"
}

resource "yandex_vpc_subnet" "services-subnet" {
  name           = "services-subnet"
  network_id     = yandex_vpc_network.ansible-network.id 
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.130.0.0/24"]
}

resource "yandex_vpc_security_group" "services-sg" {
  name        = "services-security-group"
  network_id  = yandex_vpc_network.ansible-network.id

  ingress {
    protocol       = "ANY"
    description    = "Internal traffic within subnet"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["10.130.0.0/24"]
  }

  ingress {
    protocol       = "TCP"
    description    = "SSH access"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ClickHouse HTTP interface"
    port           = 8123
    v4_cidr_blocks = ["0.0.0.0/0"] 
  }
  
  ingress {
    protocol       = "TCP"
    description    = "ClickHouse native TCP interface"
    port           = 9000
    v4_cidr_blocks = ["10.130.0.0/24"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Vector internal API"
    port           = 8686
    v4_cidr_blocks = ["10.130.0.0/24"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Lighthouse web interface"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    protocol       = "TCP"
    description    = "Lighthouse HTTPS"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow any outgoing traffic"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}