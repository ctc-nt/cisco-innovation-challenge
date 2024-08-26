terraform { 
  required_providers { 
    cml2 = { 
      source = "registry.terraform.io/ciscodevnet/cml2" 
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

resource "cml2_node" "pca1" {
  lab_id         = cml2_lab.cic.id
  label          = "PCA1"
  nodedefinition = "ubuntu-pca-agent"
  x = -200
  y = 0
  configuration = <<-EOT
#cloud-config
hostname: cml-sensor-01
manage_etc_hosts: True
system_info:
  default_user:
    name: cisco
password: cisco
chpasswd: { expire: False }
ssh_pwauth: True

write_files:
- path: /etc/environment
  content: |
    PCA_TOKEN="MTcyMjUyNzI5M3xyYjRNVDJoXzRoNTRnWVU3enU0LTlYS0pBNFZyNy02SGUwMlFWQ2NiT2VVbEpFeDJ3QjNiT0J0SGxmUUJYQ2ptTFBCaS1sOGxKNkZDcHJXb01lNFlXMjc1Q0NtX1JMblg0ejNwVGZqZXY4RWc2QWJrN29JSFN5M0tiTFdySW5TcXRLenpPb19VUXc5NXhXcnhHRXJDR2dvSmZPaFVjVFZGNzMtU1lhUWZkcnlhWS1HSmF0UFJZTGZPQUJmZzVjYWlPN2NBNXdCTjBpa1BPUzdDenkzOGVfSlIxQ2thajhnb2NtRDUwdmEtY3ZyeXNjaG5GQkZMMGtUckE2WnVCWXBaR1FsMGVod3pFZjRMbWVmc3lubThGSWpUVUdGb284SjQxenZFYzczYm9DTC1ValhYanp5c0czUFVZTVhzdzlwdFZjUFRaTFRBZ0lfZGJtaE1fd1VaVDFBQjR5RlZuRjI1U0JxVG53eVRzUjRGdlpEZm9OaHBSYnhUZmxnS0s0aWEtdmxkckJxYkVGWmE4MkdmSVdNSS1CZTZxc3pBQjZ5eE1mT1lESlQzS0gyd3o0cDlsM0pqdkRZUjlTVFNYck04emlZR1lrNGlwcUpwUVA3YUZ5VlpWeU5IbHFYUlpuamg0UkNtQ1hlU3RuZHR5MFpwQlcwWUxEcEJhRW5yY3ZZM0U1RVdnSXBRNEd1VHJDekZJRDFsT2lqWkdHc2Nkd1M4WVBnM2dtYWk1eGVQWktaSWJwUDNWRk9OVmhlX1JVa00taHZhV2E2SThLbzltQ2dvSkptNkdCRVVnX3NWNVhtaUY5N0lGeFNRSUdjVVlXUTRpa2F0ZzVxQTVXWlY0WlJsR1lFLVdRcFE5VEZDcnZyNUw5SG9KeTZTaUM0cXZwUmdWSmFlUlFPMmxrcHdVTGlYUWZIR3RpNjY1eGZ0bGVDNVhPQ2pGNmFxTUdubnJOYUVsdkxHTmw0djlzeE1XQld3NW14TWctTFljWEliSlo4c0tyLTFCRDFoakNpZHB6SU11Sko4dWVQd3NmalFfbHljUFItNHJWUjdoaEk2WnJhXzBGbk9RbVFvRTJJTmZuOWdzWGN6TS02TjJiTk5MajBrVzFjalVpb0ZrWFpqR2djNWViX2VlZGo5TmVheUk0ZmRVcWN3RDJFaF92dUwxa0xGMVEyNmJGMUJhWTRYS1RHb3MyMnp4dFdub0Z4RERWQ3hiWjRXeW9XR0ZvQWw4ZGk5XzdmcGo5TkVsVmJlWG50dzVNVm1rVjVTWUp3LWQzeHFTQkVubGM4dmFBPT18p1AYzEw_NVH2iOMtEMDG4doFOO6KwX4Jx-QOEca8TTw="
    PCA_RR_IP="172.17.12.171"
    PCA_RR_PORT=55888
  append: true
  
- path: /etc/cloud/cloud.cfg.d/99-network.cfg
  permissions: '0644'
  content: |
    network:
      config: disabled
  
- path: /etc/netplan/60-cic.yaml
  permissions: '0644'
  content: |
    network:
      version: 2
      ethernets:
        ens2:
          addresses:
            - 192.168.132.32/24
          nameservers:
            addresses:
              - 8.8.8.8
          routes:
            - to: 0.0.0.0/0
              via: 192.168.132.254
        ens3:
          addresses:
            - 192.168.1.1/24
          routes:
            - to: 192.168.0.0/22
              via: 192.168.1.254

- path: /etc/docker/daemon.json
  content: |
      {
        "default-address-pools":[  
          {  
            "base":"100.255.0.0/16",
            "size":24
          }
        ]
      }

runcmd:
  - [ netplan, apply ]
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

resource "cml2_node" "pca2" {
  lab_id         = cml2_lab.cic.id
  label          = "PCA2"
  nodedefinition = "ubuntu-pca-agent"
  x = 200
  y = 0
  configuration = <<-EOT
#cloud-config
hostname: cml-sensor-01
manage_etc_hosts: True
system_info:
  default_user:
    name: cisco
password: cisco
chpasswd: { expire: False }
ssh_pwauth: True

write_files:
- path: /etc/environment
  content: |
    PCA_TOKEN="MTcyMjUyNzI5M3xyYjRNVDJoXzRoNTRnWVU3enU0LTlYS0pBNFZyNy02SGUwMlFWQ2NiT2VVbEpFeDJ3QjNiT0J0SGxmUUJYQ2ptTFBCaS1sOGxKNkZDcHJXb01lNFlXMjc1Q0NtX1JMblg0ejNwVGZqZXY4RWc2QWJrN29JSFN5M0tiTFdySW5TcXRLenpPb19VUXc5NXhXcnhHRXJDR2dvSmZPaFVjVFZGNzMtU1lhUWZkcnlhWS1HSmF0UFJZTGZPQUJmZzVjYWlPN2NBNXdCTjBpa1BPUzdDenkzOGVfSlIxQ2thajhnb2NtRDUwdmEtY3ZyeXNjaG5GQkZMMGtUckE2WnVCWXBaR1FsMGVod3pFZjRMbWVmc3lubThGSWpUVUdGb284SjQxenZFYzczYm9DTC1ValhYanp5c0czUFVZTVhzdzlwdFZjUFRaTFRBZ0lfZGJtaE1fd1VaVDFBQjR5RlZuRjI1U0JxVG53eVRzUjRGdlpEZm9OaHBSYnhUZmxnS0s0aWEtdmxkckJxYkVGWmE4MkdmSVdNSS1CZTZxc3pBQjZ5eE1mT1lESlQzS0gyd3o0cDlsM0pqdkRZUjlTVFNYck04emlZR1lrNGlwcUpwUVA3YUZ5VlpWeU5IbHFYUlpuamg0UkNtQ1hlU3RuZHR5MFpwQlcwWUxEcEJhRW5yY3ZZM0U1RVdnSXBRNEd1VHJDekZJRDFsT2lqWkdHc2Nkd1M4WVBnM2dtYWk1eGVQWktaSWJwUDNWRk9OVmhlX1JVa00taHZhV2E2SThLbzltQ2dvSkptNkdCRVVnX3NWNVhtaUY5N0lGeFNRSUdjVVlXUTRpa2F0ZzVxQTVXWlY0WlJsR1lFLVdRcFE5VEZDcnZyNUw5SG9KeTZTaUM0cXZwUmdWSmFlUlFPMmxrcHdVTGlYUWZIR3RpNjY1eGZ0bGVDNVhPQ2pGNmFxTUdubnJOYUVsdkxHTmw0djlzeE1XQld3NW14TWctTFljWEliSlo4c0tyLTFCRDFoakNpZHB6SU11Sko4dWVQd3NmalFfbHljUFItNHJWUjdoaEk2WnJhXzBGbk9RbVFvRTJJTmZuOWdzWGN6TS02TjJiTk5MajBrVzFjalVpb0ZrWFpqR2djNWViX2VlZGo5TmVheUk0ZmRVcWN3RDJFaF92dUwxa0xGMVEyNmJGMUJhWTRYS1RHb3MyMnp4dFdub0Z4RERWQ3hiWjRXeW9XR0ZvQWw4ZGk5XzdmcGo5TkVsVmJlWG50dzVNVm1rVjVTWUp3LWQzeHFTQkVubGM4dmFBPT18p1AYzEw_NVH2iOMtEMDG4doFOO6KwX4Jx-QOEca8TTw="
    PCA_RR_IP="172.17.12.171"
    PCA_RR_PORT=55888
  append: true
  
- path: /etc/cloud/cloud.cfg.d/99-network.cfg
  permissions: '0644'
  content: |
    network:
      config: disabled
  
- path: /etc/netplan/60-cic.yaml
  permissions: '0644'
  content: |
    network:
      version: 2
      ethernets:
        ens2:
          addresses:
            - 192.168.132.33/24
          nameservers:
            addresses:
              - 8.8.8.8
          routes:
            - to: 0.0.0.0/0
              via: 192.168.132.254
        ens3:
          addresses:
            - 192.168.2.1/24
          routes:
            - to: 192.168.0.0/22
              via: 192.168.2.254

- path: /etc/docker/daemon.json
  content: |
      {
        "default-address-pools":[  
          {  
            "base":"100.255.0.0/16",
            "size":24
          }
        ]
      }

runcmd:
  - [ netplan, apply ]
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

resource "cml2_node" "pca3" {
  lab_id         = cml2_lab.cic.id
  label          = "PCA3"
  nodedefinition = "ubuntu-pca-agent"
  x = 0
  y = 200
  configuration = <<-EOT
#cloud-config
hostname: cml-sensor-01
manage_etc_hosts: True
system_info:
  default_user:
    name: cisco
password: cisco
chpasswd: { expire: False }
ssh_pwauth: True

write_files:
- path: /etc/environment
  content: |
    PCA_TOKEN="MTcyMjUyNzI5M3xyYjRNVDJoXzRoNTRnWVU3enU0LTlYS0pBNFZyNy02SGUwMlFWQ2NiT2VVbEpFeDJ3QjNiT0J0SGxmUUJYQ2ptTFBCaS1sOGxKNkZDcHJXb01lNFlXMjc1Q0NtX1JMblg0ejNwVGZqZXY4RWc2QWJrN29JSFN5M0tiTFdySW5TcXRLenpPb19VUXc5NXhXcnhHRXJDR2dvSmZPaFVjVFZGNzMtU1lhUWZkcnlhWS1HSmF0UFJZTGZPQUJmZzVjYWlPN2NBNXdCTjBpa1BPUzdDenkzOGVfSlIxQ2thajhnb2NtRDUwdmEtY3ZyeXNjaG5GQkZMMGtUckE2WnVCWXBaR1FsMGVod3pFZjRMbWVmc3lubThGSWpUVUdGb284SjQxenZFYzczYm9DTC1ValhYanp5c0czUFVZTVhzdzlwdFZjUFRaTFRBZ0lfZGJtaE1fd1VaVDFBQjR5RlZuRjI1U0JxVG53eVRzUjRGdlpEZm9OaHBSYnhUZmxnS0s0aWEtdmxkckJxYkVGWmE4MkdmSVdNSS1CZTZxc3pBQjZ5eE1mT1lESlQzS0gyd3o0cDlsM0pqdkRZUjlTVFNYck04emlZR1lrNGlwcUpwUVA3YUZ5VlpWeU5IbHFYUlpuamg0UkNtQ1hlU3RuZHR5MFpwQlcwWUxEcEJhRW5yY3ZZM0U1RVdnSXBRNEd1VHJDekZJRDFsT2lqWkdHc2Nkd1M4WVBnM2dtYWk1eGVQWktaSWJwUDNWRk9OVmhlX1JVa00taHZhV2E2SThLbzltQ2dvSkptNkdCRVVnX3NWNVhtaUY5N0lGeFNRSUdjVVlXUTRpa2F0ZzVxQTVXWlY0WlJsR1lFLVdRcFE5VEZDcnZyNUw5SG9KeTZTaUM0cXZwUmdWSmFlUlFPMmxrcHdVTGlYUWZIR3RpNjY1eGZ0bGVDNVhPQ2pGNmFxTUdubnJOYUVsdkxHTmw0djlzeE1XQld3NW14TWctTFljWEliSlo4c0tyLTFCRDFoakNpZHB6SU11Sko4dWVQd3NmalFfbHljUFItNHJWUjdoaEk2WnJhXzBGbk9RbVFvRTJJTmZuOWdzWGN6TS02TjJiTk5MajBrVzFjalVpb0ZrWFpqR2djNWViX2VlZGo5TmVheUk0ZmRVcWN3RDJFaF92dUwxa0xGMVEyNmJGMUJhWTRYS1RHb3MyMnp4dFdub0Z4RERWQ3hiWjRXeW9XR0ZvQWw4ZGk5XzdmcGo5TkVsVmJlWG50dzVNVm1rVjVTWUp3LWQzeHFTQkVubGM4dmFBPT18p1AYzEw_NVH2iOMtEMDG4doFOO6KwX4Jx-QOEca8TTw="
    PCA_RR_IP="172.17.12.171"
    PCA_RR_PORT=55888
  append: true
  
- path: /etc/cloud/cloud.cfg.d/99-network.cfg
  permissions: '0644'
  content: |
    network:
      config: disabled
  
- path: /etc/netplan/60-cic.yaml
  permissions: '0644'
  content: |
    network:
      version: 2
      ethernets:
        ens2:
          addresses:
            - 192.168.132.34/24
          nameservers:
            addresses:
              - 8.8.8.8
          routes:
            - to: 0.0.0.0/0
              via: 192.168.132.254
        ens3:
          addresses:
            - 192.168.3.1/24
          routes:
            - to: 192.168.0.0/22
              via: 192.168.3.254

- path: /etc/docker/daemon.json
  content: |
      {
        "default-address-pools":[  
          {  
            "base":"100.255.0.0/16",
            "size":24
          }
        ]
      }

runcmd:
  - [ netplan, apply ]
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
  slot_a = 3 #gi4
  node_b = cml2_node.r2.id
  slot_b = 3 #gi4
} 

resource "cml2_link" "l2" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.r1.id
  slot_a = 4 #gi5
  node_b = cml2_node.r3.id
  slot_b = 3 #gi4
} 

resource "cml2_link" "l3" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.r2.id
  slot_a = 4 #gi5
  node_b = cml2_node.r3.id
  slot_b = 4 #gi4
} 

resource "cml2_link" "l4" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.pca1.id
  slot_a = 1 #ens3
  node_b = cml2_node.r1.id
  slot_b = 1 #gi2
} 
resource "cml2_link" "l5" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.pca2.id
  slot_a = 1 #ens3
  node_b = cml2_node.r2.id
  slot_b = 1 #gi2
} 
resource "cml2_link" "l6" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.pca3.id
  slot_a = 1 #ens3
  node_b = cml2_node.r3.id
  slot_b = 1 #gi2
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
resource "cml2_link" "o4" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.mgmtsw.id
  slot_a = 4 
  node_b = cml2_node.pca1.id
  slot_b = 0 #ens2 
} 
resource "cml2_link" "o5" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.mgmtsw.id
  slot_a = 5 
  node_b = cml2_node.pca2.id
  slot_b = 0 #ens2 
} 
resource "cml2_link" "o6" {
  lab_id = cml2_lab.cic.id
  node_a = cml2_node.mgmtsw.id
  slot_a = 6 
  node_b = cml2_node.pca3.id
  slot_b = 0 #ens2 
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
  depends_on = [
    cml2_node.r1,
    cml2_node.r2,
    cml2_node.r3,
    cml2_node.mgmtsw,
    cml2_node.ext,
    cml2_link.l1,
    cml2_link.l2,
    cml2_link.l3,
    cml2_link.o1,
    cml2_link.o2,
    cml2_link.o3,
    cml2_link.mgmt-link,
    cml2_node.pca1,
    cml2_node.pca2,
    cml2_node.pca3,
    cml2_link.l4,
    cml2_link.l5,
    cml2_link.l6,
    cml2_link.o4,
    cml2_link.o5,
    cml2_link.o6,
  ]
  state = "STARTED"
  wait = false
} 
