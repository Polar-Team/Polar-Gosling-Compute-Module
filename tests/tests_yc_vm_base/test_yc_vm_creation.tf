data "yandex_vpc_network" "test_network" {
  name = "test-network"
}

resource "yandex_vpc_subnet" "test_subnet" {
  name           = "test-subnet"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.test_network.id
  v4_cidr_blocks = ["10.2.0.0/24"]
}

module "yc_test_vm" {
  source       = "../../"
  yc_vm_create = true

  creation_zone       = "ru-central1-a"
  source_image_family = "ubuntu-2204-lts"
  vm_vcpu_type        = "standard-v2"
  vm_vcpu_qty         = 2
  vm_ram_qty          = 2

  yc_network_interface = {
    "eth0" = {
      subnet_id = yandex_vpc_subnet.test_subnet.id
      nat       = true
      ipv4      = true
    }
  }

  boot_disk = {
    initialize_params = {
      size = 20
      type = "network-hdd"
    }
  }

  additional_labels = {
    environment = "test"
    purpose     = "opentofu-yc-vm-test"
  }
}
