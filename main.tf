variable "yandex_cloud_token" {
  type        = string
  description = "Enter secret token"
}

variable "image_id" {
  type = string
  description = "fd87kbts7j40q5b9rpjr"
}


provider "yandex" {
  token     = var.yandex_cloud_token
  #token     = ""
  cloud_id  = "b1ghqvpq8ojemmvlnup8"
  folder_id = "b1glausc3p7sms17sseu"
  #  zone      = "ru-central1-a"
}

#----------------- WWW -----------------------------
resource "yandex_compute_instance" "nginx-1" {
  name        = "vm-nginx-1"
  hostname    = "nginx-1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-nginx-1.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "10.0.1.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "nginx-2" {
  name        = "vm-nginx-2"
  hostname    = "nginx-2"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-nginx-2.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "10.0.2.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

#----------------- bastion -----------------------------
resource "yandex_compute_instance" "bastion" {
  name        = "vm-bastion"
  hostname    = "bastion"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd82v0f4ufbnvm3b9s08"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-bastion.id]
    ip_address         = "10.0.4.4"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}


##----------------- prometheus -----------------------------
resource "yandex_compute_instance" "prometheus" {
  name        = "vm-prometheus"
  hostname    = "prometheus"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-services.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "10.0.3.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

#----------------- grafana -----------------------------
resource "yandex_compute_instance" "grafana" {
  name        = "vm-grafana"
  hostname    = "grafana"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-grafana.id]
    ip_address         = "10.0.4.5"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

#----------------- elastic -----------------------------
resource "yandex_compute_instance" "elastic" {
  name        = "vm-elastic"
  hostname    = "elastic"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = 15
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.inner-services.id
    security_group_ids = [yandex_vpc_security_group.inner.id]
    ip_address         = "10.0.3.4"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

#----------------- kibana -----------------------------
resource "yandex_compute_instance" "kibana" {
  name        = "vm-kibana"
  hostname    = "kibana"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.inner.id, yandex_vpc_security_group.public-kibana.id]
    ip_address         = "10.0.4.3"
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}
