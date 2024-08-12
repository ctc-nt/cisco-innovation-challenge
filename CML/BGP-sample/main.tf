terraform { 
  required_providers { 
    cml2 = { 
      source = "registry.terraform.io/ciscodevnet/cml2" 
      version = "~> 0.7.0"
    } 
  } 
} 

provider "cml2" {
  address = var.cml_address
  username = var.cml_user
  password = var.cml_password
  skip_verify = true
} 

variable "cml_address" {
  description = "CML controller address"
  type        = string
}

variable "cml_user" {
  description = "cml2 username"
  type        = string
}

variable "cml_password" {
  description = "cml2 password"
  type        = string
  sensitive   = true
} 

resource "cml2_lab" "cic" {
    title       = "CIC Lab"
    description = "cisco inovation challenge Lab"
}


resource "cml2_node" "r1" {
  lab_id         = cml2_lab.cic.id
  label          = "R1"
  nodedefinition = "csr1000v"
  x = -100
  y = 0
  configuration = <<-EOT
hostname R1
username cisco password 0 cisco
enable password 0 cisco
ip domain name cisco.com
interface GigabitEthernet1
 ip address 192.168.132.14 255.255.255.0
 no shutdown
ip route 0.0.0.0 0.0.0.0 192.168.132.254
ip ssh version 2
line vty 0 4
 login local
!
crypto key generate rsa
  EOT
}


resource "cml2_node" "r2" {
  lab_id         = cml2_lab.cic.id
  label          = "R2"
  nodedefinition = "csr1000v"
  x = 100
  y = 0
  configuration = <<-EOT
hostname R2
username cisco password 0 cisco
enable password 0 cisco
ip domain name cisco.com
interface GigabitEthernet1
 ip address 192.168.132.15 255.255.255.0
 no shutdown
ip route 0.0.0.0 0.0.0.0 192.168.132.254
ip ssh version 2
line vty 0 4
 login local
!
crypto key generate rsa
  EOT
}

resource "cml2_node" "r3" {
  lab_id         = cml2_lab.cic.id
  label          = "R3"
  nodedefinition = "csr1000v"
  x = 0
  y = 100
  configuration = <<-EOT
hostname R3
username cisco password 0 cisco
enable password 0 cisco
ip domain name cisco.com
interface GigabitEthernet1
 ip address 192.168.132.16 255.255.255.0
 no shutdown
ip route 0.0.0.0 0.0.0.0 192.168.132.254
ip ssh version 2
line vty 0 4
 login local
!
crypto key generate rsa
  EOT
}
resource "cml2_node" "mgmtsw" {
  lab_id         = cml2_lab.cic.id
  label          = "mgmtsw"
  nodedefinition = "unmanaged_switch"
  x = 300
  y = 300
}
resource "cml2_node" "ext" {
  lab_id         = cml2_lab.cic.id
  label          = "External"
  configuration  = "System Bridge"
  nodedefinition = "external_connector"
  x              = 400
  y              = 300
}


resource "cml2_link" "l1" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.r1.id
  slot_a = 3 #gi0/0/0/0
  node_b = cml2_node.r2.id
  slot_b = 3 #gi0/0/0/0
} 

resource "cml2_link" "l2" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.r1.id
  slot_a = 4 #gi0/0/0/0
  node_b = cml2_node.r3.id
  slot_b = 3 #gi0/0/0/0
} 

resource "cml2_link" "l3" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.r2.id
  slot_a = 4 #gi0/0/0/0
  node_b = cml2_node.r3.id
  slot_b = 4 #gi0/0/0/0
} 

resource "cml2_link" "o1" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.mgmtsw.id
  slot_a = 1 
  node_b = cml2_node.r1.id
  slot_b = 0 # MgmtEth0/RP0/CPU0/0	
} 
resource "cml2_link" "o2" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.mgmtsw.id
  slot_a = 2 
  node_b = cml2_node.r2.id
  slot_b = 0 # MgmtEth0/RP0/CPU0/0	
} 
resource "cml2_link" "o3" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.mgmtsw.id
  slot_a = 3 #gi0/0/0/0
  node_b = cml2_node.r3.id
  slot_b = 0 # MgmtEth0/RP0/CPU0/0	
} 

resource "cml2_link" "mgmt-link" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.mgmtsw.id
  slot_a = 0 #gi0/0/0/0
  node_b = cml2_node.ext.id
  slot_b = 0 #gi0/0/0/0
} 

resource "cml2_lifecycle" "top" {
  lab_id = cml2_lab.cic.id
  elements = [
    cml2_node.r1.id,
    cml2_node.r2.id,
    cml2_node.r3.id,
    cml2_node.mgmtsw.id,
    cml2_node.ext.id,
    cml2_link.l1.id,
    cml2_link.l2.id,
    cml2_link.l3.id,
    cml2_link.o1.id,
    cml2_link.o2.id,
    cml2_link.o3.id,
    cml2_link.mgmt-link.id,
  ]
  state = "STARTED"
  wait = false
} 
